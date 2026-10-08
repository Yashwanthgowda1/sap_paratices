"""
LinkedIn job scraper using Selenium headed browser.
Searches for SDET/QA roles and paginates through results.
"""

from __future__ import annotations

import time
import uuid
from typing import Dict, List
from urllib.parse import quote

from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from selenium.common.exceptions import TimeoutException

from ..config import get_config
from ..keywords import SEARCH_KEYWORDS
from ..logger import start_logging
from .base_scraper import BaseScraper

logger = start_logging("linkedin_scraper")

SEARCH_ROLES = SEARCH_KEYWORDS

# No experience filter — let the AI matcher score all levels
DATE_FILTER = "r172800"  # past 2 days


class LinkedInScraper(BaseScraper):
    def __init__(self) -> None:
        super().__init__(headless=False, profile_suffix="linkedin")
        self.cfg = get_config()

    def scrape(self, max_jobs: int = 100) -> List[Dict]:
        jobs: List[Dict] = []
        seen_ids: set = set()

        with self:
            self._ensure_login()   # single login check before any search

            for role in SEARCH_ROLES:
                if len(jobs) >= max_jobs:
                    break
                logger.info(f"Searching LinkedIn for: {role}")
                role_jobs = self._search_role(role, max_jobs - len(jobs), seen_ids)
                jobs.extend(role_jobs)
                logger.info(f"  Found {len(role_jobs)} jobs for '{role}' (total: {len(jobs)})")

        logger.info(f"LinkedIn total: {len(jobs)} jobs")
        return jobs

    def _ensure_login(self) -> None:
        """Navigate to feed and wait for manual login if not already logged in."""
        self.goto("https://www.linkedin.com/feed/")
        time.sleep(3)
        if not self._is_logged_in():
            self.wait_for_manual_login("LinkedIn")
            # After pressing Enter, wait up to 30s for feed to load — don't just sleep 3s
            if not self._wait_until_logged_in(timeout=30):
                # Give the user a second chance
                print("\n  Still waiting for login to complete...")
                input("  Press Enter again once the LinkedIn feed/home is fully loaded: ")
                if not self._wait_until_logged_in(timeout=20):
                    raise RuntimeError("LinkedIn login failed — timed out waiting for feed.")
        logger.info("LinkedIn: session verified (logged in)")

    def _wait_until_logged_in(self, timeout: int = 30) -> bool:
        """Poll _is_logged_in() for up to timeout seconds."""
        import time as _t
        deadline = _t.time() + timeout
        while _t.time() < deadline:
            if self._is_logged_in():
                return True
            current = self.driver.current_url
            print(f"\r  Waiting... current page: {current[:80]}", end="", flush=True)
            _t.sleep(1.5)
        print()  # newline after the \r
        print(f"  Final URL: {self.driver.current_url}")
        return False

    def _is_logged_in(self) -> bool:
        """URL-based check — authenticated LinkedIn pages have predictable URL patterns."""
        url = self.driver.current_url
        # Any of these URLs means we are authenticated
        if any(p in url for p in (
            "linkedin.com/feed",
            "linkedin.com/in/",
            "linkedin.com/mynetwork",
            "linkedin.com/jobs",
            "linkedin.com/messaging",
            "linkedin.com/notifications",
        )):
            return True
        # These patterns mean we are on a login/auth page
        if any(p in url.lower() for p in (
            "login", "authwall", "checkpoint",
            "uas/login", "session_redirect", "signup",
        )):
            return False
        # Fallback: check for the global nav (CSS selectors change, but try a few)
        for sel in (
            "div.global-nav__me",
            "img.global-nav__me-photo",
            "[data-global-nav-item-type='nav-settings']",
            "input.search-global-typeahead__input",
        ):
            if self.safe_find(By.CSS_SELECTOR, sel):
                return True
        return False

    def _has_login_modal(self) -> bool:
        """Detect LinkedIn login modal overlays that don't change the URL."""
        for sel in (
            "input#session_key",
            "form.login__form",
            "div.join-linkedin",
            ".join-form",
            "a[data-tracking-control-name='guest_homepage-basic_nav-header-signin']",
        ):
            if self.safe_find(By.CSS_SELECTOR, sel):
                return True
        return False

    def _search_role(self, role: str, limit: int, seen_ids: set) -> List[Dict]:
        location = quote(self.cfg.job_location)
        keywords = quote(role)
        url = (
            f"https://www.linkedin.com/jobs/search/?keywords={keywords}"
            f"&location={location}&f_TPR={DATE_FILTER}&sortBy=DD"
        )
        self.goto(url)

        # Wait up to 12s for job cards — if login modal appears instead, pause
        CARD_SEL = "li.jobs-search-results__list-item, div.job-card-container"
        try:
            WebDriverWait(self.driver, 12).until(
                EC.presence_of_element_located((By.CSS_SELECTOR, CARD_SEL))
            )
        except TimeoutException:
            if self.is_login_page() or self._has_login_modal():
                self.wait_for_manual_login("LinkedIn")
                self.goto(url)
                time.sleep(4)
            else:
                logger.debug(f"No job cards found for '{role}' — possibly 0 results.")
                return []

        jobs: List[Dict] = []
        page = 0

        while len(jobs) < limit:
            new_jobs = self._extract_page_jobs(seen_ids)
            jobs.extend(new_jobs)

            if len(new_jobs) == 0:
                logger.debug(f"No new jobs on page {page + 1}, stopping.")
                break

            page += 1
            if page >= 10:  # max 10 pages per role
                break

            if not self._go_next_page():
                break
            time.sleep(2)

        return jobs[:limit]

    def _extract_page_jobs(self, seen_ids: set) -> List[Dict]:
        jobs = []
        self.scroll_to_bottom()
        time.sleep(1.5)

        cards = self.driver.find_elements(By.CSS_SELECTOR, "li.jobs-search-results__list-item")
        if not cards:
            cards = self.driver.find_elements(By.CSS_SELECTOR, "div.job-card-container")

        for card in cards:
            try:
                job_id = card.get_attribute("data-job-id") or str(uuid.uuid4())[:8]
                if job_id in seen_ids:
                    continue
                seen_ids.add(job_id)

                title_el = card.find_element(By.CSS_SELECTOR, "a.job-card-list__title, a.job-card-container__link")
                title = title_el.text.strip() if title_el else ""
                apply_url = title_el.get_attribute("href") if title_el else ""

                company = self._safe_card_text(card, ".job-card-container__primary-description, .artdeco-entity-lockup__subtitle")
                location = self._safe_card_text(card, ".job-card-container__metadata-item, .artdeco-entity-lockup__caption")
                posted_text = self._safe_card_text(card, ".job-card-container__listed-time, time")

                if not title:
                    continue

                jobs.append({
                    "id": f"li_{job_id}",
                    "title": title,
                    "company": company,
                    "location": location or self.cfg.job_location,
                    "experience": self.cfg.job_experience,
                    "salary": "",
                    "posted_ago": posted_text or "Recently",
                    "posted_hours": self._parse_hours(posted_text),
                    "source": "linkedin",
                    "apply_url": apply_url.split("?")[0] if apply_url else "",
                    "jd": "",
                    "required_skills": [],
                    "nice_to_have": [],
                    "link_valid": bool(apply_url),
                    "domain": "",
                })
            except Exception as e:
                logger.debug(f"Card parse error: {e}")

        return jobs

    def _safe_card_text(self, card, selector: str) -> str:
        try:
            el = card.find_element(By.CSS_SELECTOR, selector)
            return el.text.strip()
        except Exception:
            return ""

    def _go_next_page(self) -> bool:
        try:
            next_btn = self.driver.find_element(
                By.CSS_SELECTOR,
                "button[aria-label='View next page'], li.artdeco-pagination__button--next button",
            )
            if next_btn.is_enabled():
                next_btn.click()
                time.sleep(2)
                return True
        except Exception:
            pass
        return False

    def _parse_hours(self, text: str) -> int:
        if not text:
            return 48
        t = text.lower()
        import re
        m = re.search(r"(\d+)\s*(minute|hour|day|week)", t)
        if not m:
            return 48
        n, unit = int(m.group(1)), m.group(2)
        return {"minute": 0, "hour": n, "day": n * 24, "week": n * 168}.get(unit, 48)

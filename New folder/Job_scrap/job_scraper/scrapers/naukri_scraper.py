"""
Naukri.com job scraper — Selenium headed.
RapidAPI path removed (endpoint changed/unavailable); Selenium is the primary method.
"""

from __future__ import annotations

import time
import uuid
from typing import Dict, List

from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from selenium.common.exceptions import TimeoutException

from ..config import get_config
from ..keywords import NAUKRI_SLUGS
from ..logger import start_logging
from .base_scraper import BaseScraper

logger = start_logging("naukri_scraper")

ROLE_SLUGS = NAUKRI_SLUGS

# Naukri redesigned in 2024 — selectors use class*= to survive minor renames
CARD_SEL   = "div.srp-jobtuple-wrapper, article.jobTuple, div[class*='srp-jobtuple']"
TITLE_SEL  = "a.title, h2.title a, a[class*='title']"
COMP_SEL   = "a.comp-name, a.subTitle, a[class*='comp-name'], a[class*='comp ']"
LOC_SEL    = "span.loc, span.locWdth, span[class*='loc '], li.location"
EXP_SEL    = "span.exp, span.expwdth, span[class*='exp '], li.experience"
SAL_SEL    = "span.sal, span.salary, span[class*='sal '], li.salary"


class NaukriScraper:
    def __init__(self) -> None:
        self.cfg = get_config()

    def scrape(self, max_jobs: int = 80) -> List[Dict]:
        scraper = _NaukriSeleniumScraper()
        jobs = scraper.scrape(max_jobs)
        logger.info(f"Naukri total: {len(jobs)} jobs")
        return jobs


class _NaukriSeleniumScraper(BaseScraper):
    def __init__(self) -> None:
        # use_uc=True: undetected-chromedriver bypasses Naukri's bot detection
        super().__init__(headless=False, profile_suffix="naukri", use_uc=True)

    def scrape(self, max_jobs: int = 80) -> List[Dict]:
        jobs: List[Dict] = []
        seen: set = set()

        with self:
            self._ensure_session()

            for slug in ROLE_SLUGS:
                if len(jobs) >= max_jobs:
                    break
                city = self.cfg.job_location.split(",")[0].strip().lower().replace(" ", "-")
                url = f"https://www.naukri.com/{slug}-jobs-in-{city}?jobAge=2"
                logger.info(f"Naukri scraping: {url}")

                self.goto(url)
                if not self._wait_for_cards(timeout=10):
                    # Fallback: try without city
                    url2 = f"https://www.naukri.com/{slug}-jobs?jobAge=2"
                    logger.debug(f"No cards for city URL, trying: {url2}")
                    self.goto(url2)
                    if not self._wait_for_cards(timeout=8):
                        logger.warning(f"Naukri: 0 cards for '{slug}' — title: {self.driver.title!r} url: {self.driver.current_url!r}")
                        # Log a snippet of classes visible on the page to help update selectors
                        try:
                            src = self.driver.page_source
                            import re
                            classes = re.findall(r'class="([^"]{5,60})"', src)[:15]
                            logger.debug(f"Naukri page classes sample: {classes}")
                        except Exception:
                            pass
                        continue

                if self.is_login_page():
                    self.wait_for_manual_login("Naukri")
                    self.goto(url)
                    self._wait_for_cards(timeout=10)

                cards = self.driver.find_elements(By.CSS_SELECTOR, CARD_SEL)
                logger.info(f"Naukri '{slug}': {len(cards)} cards on page")

                for card in cards:
                    if len(jobs) >= max_jobs:
                        break
                    try:
                        job_id = (
                            card.get_attribute("data-job-id")
                            or card.get_attribute("data-id")
                            or uuid.uuid4().hex[:8]
                        )
                        if job_id in seen:
                            continue
                        seen.add(job_id)

                        title     = self._card_text(card, TITLE_SEL)
                        company   = self._card_text(card, COMP_SEL)
                        location  = self._card_text(card, LOC_SEL)
                        exp       = self._card_text(card, EXP_SEL)
                        salary    = self._card_text(card, SAL_SEL)
                        apply_url = self._card_href(card, TITLE_SEL)

                        if not title:
                            continue

                        jobs.append({
                            "id": f"nk_{job_id}",
                            "title": title,
                            "company": company,
                            "location": location or self.cfg.job_location,
                            "experience": exp or "3-5 years",
                            "salary": salary,
                            "posted_ago": "Recently",
                            "posted_hours": 24,
                            "source": "naukri",
                            "apply_url": apply_url,
                            "jd": "",
                            "required_skills": [],
                            "nice_to_have": [],
                            "link_valid": bool(apply_url),
                            "domain": "",
                        })
                    except Exception as e:
                        logger.debug(f"Naukri card parse error: {e}")

        logger.info(f"Naukri Selenium: {len(jobs)} jobs")
        return jobs

    # ── helpers ───────────────────────────────────────────────────────────────

    def _ensure_session(self) -> None:
        self.goto("https://www.naukri.com/")
        time.sleep(2)
        if self.is_login_page():
            self.wait_for_manual_login("Naukri")
        logger.info("Naukri: session ready")

    def _wait_for_cards(self, timeout: int = 10) -> bool:
        try:
            WebDriverWait(self.driver, timeout).until(
                EC.presence_of_element_located((By.CSS_SELECTOR, CARD_SEL))
            )
            return True
        except TimeoutException:
            return False

    def _card_text(self, card, selector: str) -> str:
        try:
            return card.find_element(By.CSS_SELECTOR, selector).text.strip()
        except Exception:
            return ""

    def _card_href(self, card, selector: str) -> str:
        try:
            return card.find_element(By.CSS_SELECTOR, selector).get_attribute("href") or ""
        except Exception:
            return ""

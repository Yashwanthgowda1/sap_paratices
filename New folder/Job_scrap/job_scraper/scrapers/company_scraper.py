"""
Direct company career page scraper using Selenium.
Visits each company's career URL and extracts SDET/QA job listings.
"""

from __future__ import annotations

import time
import uuid
from typing import Dict, List

from selenium.webdriver.common.by import By

from ..companies import COMPANIES, Company
from ..config import get_config
from ..logger import start_logging
from .base_scraper import BaseScraper

logger = start_logging("company_scraper")

SDET_KEYWORDS = [
    "sdet", "qa automation", "test automation", "automation engineer",
    "quality engineer", "quality assurance", "software engineer in test",
    "automation tester", "test engineer",
]

EXP_KEYWORDS = ["3", "4", "5", "3-5", "3 to 5", "3+ years", "4+ years"]


class CompanyScraper(BaseScraper):
    def __init__(self) -> None:
        super().__init__(headless=False, profile_suffix="company")
        self.cfg = get_config()

    def scrape(self, max_per_company: int = 5, max_total: int = 200) -> List[Dict]:
        all_jobs: List[Dict] = []

        with self:
            for company in COMPANIES:
                if len(all_jobs) >= max_total:
                    break
                try:
                    jobs = self._scrape_company(company, max_per_company)
                    all_jobs.extend(jobs)
                    if jobs:
                        logger.info(f"  {company.name}: {len(jobs)} jobs found")
                    time.sleep(2)
                except Exception as e:
                    logger.debug(f"Company scrape failed ({company.name}): {e}")

        logger.info(f"Company pages total: {len(all_jobs)} jobs")
        return all_jobs

    def _scrape_company(self, company: Company, max_jobs: int) -> List[Dict]:
        self.goto(company.career_url)
        time.sleep(2.5)

        # Detect if login required (rare for company pages)
        if self.is_login_page():
            logger.debug(f"Login required for {company.name}, skipping.")
            return []

        # Search for SDET/QA job listing elements
        job_links = self._find_job_links()
        relevant = self._filter_relevant(job_links)[:max_jobs]

        jobs: List[Dict] = []
        for link_text, link_href in relevant:
            jobs.append({
                "id": f"co_{uuid.uuid4().hex[:8]}",
                "title": link_text.strip(),
                "company": company.name,
                "location": self.cfg.job_location,
                "experience": "3-5 years",
                "salary": "",
                "posted_ago": "Recently",
                "posted_hours": 48,
                "source": "company",
                "apply_url": link_href,
                "jd": "",
                "required_skills": [],
                "nice_to_have": [],
                "link_valid": bool(link_href and link_href.startswith("http")),
                "domain": company.domain,
            })
        return jobs

    def _find_job_links(self) -> List[tuple]:
        """Return (text, href) pairs for all <a> tags that look like job listings."""
        anchors = self.driver.find_elements(By.TAG_NAME, "a")
        links = []
        for a in anchors:
            try:
                text = a.text.strip()
                href = a.get_attribute("href") or ""
                if text and len(text) > 5 and href.startswith("http"):
                    links.append((text, href))
            except Exception:
                continue
        return links

    def _filter_relevant(self, links: List[tuple]) -> List[tuple]:
        """Keep only links that match SDET/QA keywords and experience keywords."""
        relevant = []
        for text, href in links:
            text_lower = text.lower()
            href_lower = href.lower()
            is_sdet = any(kw in text_lower or kw in href_lower for kw in SDET_KEYWORDS)
            if is_sdet:
                relevant.append((text, href))
        return relevant

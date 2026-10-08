"""
Indeed / Google Jobs scraper via RapidAPI and SerpAPI.
"""

from __future__ import annotations

import uuid
from typing import Dict, List

from ..config import get_config
from ..keywords import SEARCH_KEYWORDS
from ..logger import start_logging

logger = start_logging("indeed_scraper")


class IndeedScraper:
    def __init__(self) -> None:
        self.cfg = get_config()

    def scrape(self, max_jobs: int = 60) -> List[Dict]:
        jobs: List[Dict] = []
        if self.cfg.has_rapidapi:
            try:
                jobs = self._scrape_rapidapi(max_jobs)
                logger.info(f"Indeed (RapidAPI): {len(jobs)} jobs")
                return jobs
            except Exception as e:
                logger.warning(f"Indeed RapidAPI failed: {e}")
        logger.warning("Indeed: No API key available, skipping.")
        return []

    def _scrape_rapidapi(self, max_jobs: int) -> List[Dict]:
        import requests
        jobs: List[Dict] = []

        for role in SEARCH_KEYWORDS:
            if len(jobs) >= max_jobs:
                break
            url = "https://indeed12.p.rapidapi.com/jobs/search"
            headers = {
                "X-RapidAPI-Key": self.cfg.rapidapi_key,
                "X-RapidAPI-Host": "indeed12.p.rapidapi.com",
            }
            params = {
                "query": f"{role} 3-5 years",
                "location": self.cfg.job_location,
                "page_id": "1",
                "locality": "in",
            }
            resp = requests.get(url, headers=headers, params=params, timeout=20)
            resp.raise_for_status()
            data = resp.json()
            for j in data.get("hits", []):
                jobs.append(self._normalize(j))

        return jobs[:max_jobs]

    def _normalize(self, j: Dict) -> Dict:
        return {
            "id": f"in_{j.get('id', uuid.uuid4().hex[:8])}",
            "title": j.get("title", ""),
            "company": j.get("company_name", ""),
            "location": j.get("location", self.cfg.job_location),
            "experience": "3-5 years",
            "salary": j.get("salary", ""),
            "posted_ago": j.get("date", "Recently"),
            "posted_hours": 48,
            "source": "indeed",
            "apply_url": f"https://in.indeed.com/viewjob?jk={j.get('id', '')}",
            "jd": j.get("description", ""),
            "required_skills": [],
            "nice_to_have": [],
            "link_valid": bool(j.get("id")),
            "domain": "",
        }

"""
Google Jobs scraper via SerpAPI.
Returns structured job listings from Google's job search index.
"""

from __future__ import annotations

import uuid
from typing import Dict, List

from ..config import get_config
from ..keywords import google_queries
from ..logger import start_logging

logger = start_logging("google_jobs_scraper")


class GoogleJobsScraper:
    def __init__(self) -> None:
        self.cfg = get_config()

    def scrape(self, max_jobs: int = 80) -> List[Dict]:
        if not self.cfg.has_serpapi:
            logger.warning("SERPAPI_KEY not set — skipping Google Jobs.")
            return []
        try:
            return self._scrape(max_jobs)
        except Exception as e:
            logger.error(f"Google Jobs scrape error: {e}")
            return []

    def _scrape(self, max_jobs: int) -> List[Dict]:
        import requests
        queries = google_queries(self.cfg.job_location)
        jobs: List[Dict] = []
        seen: set = set()

        for query in queries:
            if len(jobs) >= max_jobs:
                break
            params = {
                "engine": "google_jobs",
                "q": query,
                "hl": "en",
                "gl": "in",
                "api_key": self.cfg.serpapi_key,
            }
            resp = requests.get(
                "https://serpapi.com/search", params=params, timeout=30
            )
            resp.raise_for_status()
            data = resp.json()

            for j in data.get("jobs_results", []):
                job_id = j.get("job_id", uuid.uuid4().hex[:8])
                if job_id in seen:
                    continue
                seen.add(job_id)

                # Extract direct apply link
                apply_url = ""
                for opt in j.get("apply_options", []):
                    link = opt.get("link", "")
                    if link.startswith("http"):
                        apply_url = link
                        break

                extensions = j.get("detected_extensions", {})
                jobs.append({
                    "id": f"gj_{job_id[:10]}",
                    "title": j.get("title", ""),
                    "company": j.get("company_name", ""),
                    "location": j.get("location", self.cfg.job_location),
                    "experience": extensions.get("work_from_home", "3-5 years"),
                    "salary": extensions.get("salary", ""),
                    "posted_ago": j.get("detected_extensions", {}).get("posted_at", "Recently"),
                    "posted_hours": self._parse_posted(j.get("detected_extensions", {}).get("posted_at", "")),
                    "source": "google",
                    "apply_url": apply_url,
                    "jd": j.get("description", "")[:1000],
                    "required_skills": [],
                    "nice_to_have": [],
                    "link_valid": bool(apply_url),
                    "domain": "",
                })

            logger.debug(f"Google Jobs query '{query}': {len(data.get('jobs_results', []))} results")

        logger.info(f"Google Jobs: {len(jobs)} jobs")
        return jobs[:max_jobs]

    def _parse_posted(self, text: str) -> int:
        if not text:
            return 48
        import re
        m = re.search(r"(\d+)\s*(hour|day|week)", text.lower())
        if not m:
            return 48
        n, unit = int(m.group(1)), m.group(2)
        return {"hour": n, "day": n * 24, "week": n * 168}.get(unit, 48)

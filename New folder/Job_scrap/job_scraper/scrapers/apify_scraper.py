"""
Apify-based job scraper.
Uses free/low-cost Apify actors to scrape Indeed and Google Jobs.
Runs actors asynchronously and polls for completion.
"""

from __future__ import annotations

import time
import uuid
from typing import Dict, List, Optional

import requests

from ..config import get_config
from ..logger import start_logging

logger = start_logging("apify_scraper")

APIFY_BASE = "https://api.apify.com/v2"

# Actor configs: (actor_id, search_input_builder, result_normalizer)
SEARCH_ROLES = [
    "SDET QA automation",
    "Test Automation Engineer",
    "QA Automation Engineer",
]


class ApifyScraper:
    def __init__(self) -> None:
        self.cfg = get_config()
        self._headers = {"Authorization": f"Bearer {self.cfg.apify_api_key}"}

    def scrape(self, max_jobs: int = 100) -> List[Dict]:
        all_jobs: List[Dict] = []

        # ── Indeed (misceres~indeed-scraper) ─────────────────────────────────
        try:
            indeed_jobs = self._run_indeed(max_jobs)
            all_jobs.extend(indeed_jobs)
            logger.info(f"Apify Indeed: {len(indeed_jobs)} jobs")
        except Exception as e:
            logger.warning(f"Apify Indeed failed: {e}")

        # ── Google Jobs (apify~google-search-scraper via jobs query) ─────────
        if len(all_jobs) < max_jobs:
            try:
                google_jobs = self._run_google_jobs(max_jobs - len(all_jobs))
                all_jobs.extend(google_jobs)
                logger.info(f"Apify Google Jobs: {len(google_jobs)} jobs")
            except Exception as e:
                logger.warning(f"Apify Google Jobs failed: {e}")

        logger.info(f"Apify total: {len(all_jobs)} jobs")
        return all_jobs[:max_jobs]

    # ── Indeed ────────────────────────────────────────────────────────────────

    def _run_indeed(self, max_jobs: int) -> List[Dict]:
        jobs: List[Dict] = []
        city = self.cfg.job_location.split(",")[0].strip()

        for role in SEARCH_ROLES:
            if len(jobs) >= max_jobs:
                break
            items = self._run_actor(
                "misceres~indeed-scraper",
                {
                    "country": "IN",
                    "position": role,
                    "location": city,
                    "maxItems": min(30, max_jobs - len(jobs)),
                    "fromage": 2,      # posted in last 2 days
                    "sort": "date",    # newest first
                },
                run_memory=512,
                run_timeout=180,
            )
            for item in items:
                if item.get("isExpired"):
                    continue
                j = self._normalize_indeed(item)
                if j["posted_hours"] <= 48:   # only last 2 days
                    jobs.append(j)

        return jobs[:max_jobs]

    def _normalize_indeed(self, item: Dict) -> Dict:
        job_id = item.get("id", uuid.uuid4().hex[:8])
        apply_url = item.get("externalApplyLink") or item.get("url", "")
        posted = item.get("postedAt", "Recently")
        return {
            "id": f"ap_in_{job_id}",
            "title": item.get("positionName", ""),
            "company": item.get("company", ""),
            "location": item.get("location", self.cfg.job_location),
            "experience": self.cfg.job_experience,
            "salary": str(item.get("salary") or ""),
            "posted_ago": posted,
            "posted_hours": self._parse_posted(posted),
            "source": "indeed",
            "apply_url": apply_url,
            "jd": item.get("description", ""),
            "required_skills": [],
            "nice_to_have": [],
            "link_valid": bool(apply_url) and not item.get("isExpired"),
            "domain": "",
        }

    # ── Google Jobs ───────────────────────────────────────────────────────────

    def _run_google_jobs(self, max_jobs: int) -> List[Dict]:
        jobs: List[Dict] = []
        city = self.cfg.job_location.split(",")[0].strip()

        for role in SEARCH_ROLES[:2]:
            if len(jobs) >= max_jobs:
                break
            query = f"{role} jobs in {city} site:linkedin.com OR site:naukri.com OR site:indeed.com"
            items = self._run_actor(
                "apify~google-search-scraper",
                {
                    "queries": query,
                    "resultsPerPage": 10,
                    "maxPagesPerQuery": 2,
                    "languageCode": "en",
                    "countryCode": "in",
                },
                run_memory=256,
                run_timeout=120,
            )
            for item in items:
                j = self._normalize_google(item, role)
                if j:
                    jobs.append(j)

        return jobs[:max_jobs]

    def _normalize_google(self, item: Dict, role: str) -> Optional[Dict]:
        url = item.get("url", "")
        title = item.get("title", "")
        snippet = item.get("description", item.get("snippet", ""))
        if not url or not title:
            return None
        # Filter to actual job postings
        job_sites = ("linkedin.com/jobs", "naukri.com", "indeed.com", "glassdoor", "careers", "jobs")
        if not any(s in url.lower() for s in job_sites):
            return None
        return {
            "id": f"ap_gg_{uuid.uuid4().hex[:8]}",
            "title": title,
            "company": item.get("displayedUrl", "").split("/")[0],
            "location": self.cfg.job_location,
            "experience": self.cfg.job_experience,
            "salary": "",
            "posted_ago": "Recently",
            "posted_hours": 48,
            "source": "google",
            "apply_url": url,
            "jd": snippet,
            "required_skills": [],
            "nice_to_have": [],
            "link_valid": True,
            "domain": "",
        }

    # ── Apify runner ──────────────────────────────────────────────────────────

    def _run_actor(
        self,
        actor_id: str,
        input_data: Dict,
        run_memory: int = 256,
        run_timeout: int = 120,
        poll_interval: int = 5,
    ) -> List[Dict]:
        # Start async run
        r = requests.post(
            f"{APIFY_BASE}/acts/{actor_id}/runs",
            headers=self._headers,
            params={"token": self.cfg.apify_api_key, "memory": run_memory, "timeout": run_timeout},
            json=input_data,
            timeout=30,
        )
        r.raise_for_status()
        run_id = r.json()["data"]["id"]
        logger.info(f"Apify actor {actor_id} started — run {run_id}")

        # Poll until done
        deadline = time.time() + run_timeout + 30
        while time.time() < deadline:
            time.sleep(poll_interval)
            sr = requests.get(
                f"{APIFY_BASE}/actor-runs/{run_id}",
                headers=self._headers,
                timeout=10,
            )
            sr.raise_for_status()
            status = sr.json()["data"]["status"]
            if status == "SUCCEEDED":
                break
            if status in ("FAILED", "ABORTED", "TIMED-OUT"):
                raise RuntimeError(f"Apify run {run_id} ended with status: {status}")

        # Fetch dataset
        dr = requests.get(
            f"{APIFY_BASE}/actor-runs/{run_id}/dataset/items",
            headers=self._headers,
            params={"token": self.cfg.apify_api_key},
            timeout=30,
        )
        dr.raise_for_status()
        items = dr.json()
        logger.info(f"Apify {actor_id}: {len(items)} items retrieved")
        return items

    @staticmethod
    def _parse_posted(text: str) -> int:
        import re
        t = (text or "").lower()
        m = re.search(r"(\d+)\s*(minute|hour|day|week)", t)
        if not m:
            return 48
        n, unit = int(m.group(1)), m.group(2)
        return {"minute": 0, "hour": n, "day": n * 24, "week": n * 168}.get(unit, 48)

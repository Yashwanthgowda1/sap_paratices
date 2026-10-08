"""
Link validator: verifies that a job URL is a real, accessible job posting.
- Known job board domains (LinkedIn, Naukri, Indeed, etc.) are trusted as valid
  because they require login and return 403/999 for bots regardless.
- Company career page URLs are HTTP-checked.
"""

from __future__ import annotations

from concurrent.futures import ThreadPoolExecutor, as_completed
from typing import Dict, List
from urllib.parse import urlparse

import requests

from ..config import get_config
from ..logger import start_logging

logger = start_logging("link_validator")

# These domains require authentication — HTTP checks always fail for bots.
# Trust any URL from these domains as valid if it looks like a job posting.
TRUSTED_JOB_BOARDS = {
    "linkedin.com",
    "naukri.com",
    "indeed.com",
    "in.indeed.com",
    "glassdoor.com",
    "monster.com",
    "shine.com",
    "timesjobs.com",
    "foundit.in",
    "instahyre.com",
    "hirist.com",
    "apna.co",
    "freshersworld.com",
    "careers360.com",
    "wellfound.com",
    "cutshort.io",
    "internshala.com",
    "naukrigulf.com",
}

# URL patterns that are clearly homepage/search, not a real posting
NOT_A_POSTING = (
    "/jobs/search",
    "/jobs/?",
    "naukri.com/jobs",
    "naukri.com/$",
    "linkedin.com/feed",
    "linkedin.com/company",
)


def validate_jobs(jobs: List[Dict]) -> List[Dict]:
    """Validate all job links. Returns jobs with link_valid and link_status set."""
    cfg = get_config()
    timeout = cfg.link_validation_timeout

    def check(job: Dict) -> Dict:
        url = job.get("apply_url", "")
        if not url or not url.startswith("http"):
            return {**job, "link_valid": False, "link_status": "no_url"}

        # Trust known job board URLs — HTTP checks don't work (auth required)
        if _is_trusted_board(url):
            is_posting = _looks_like_posting(url)
            return {**job, "link_valid": is_posting, "link_status": "trusted_board" if is_posting else "homepage_url"}

        # HTTP check for company career pages
        valid, status = _http_check(url, timeout)
        return {**job, "link_valid": valid, "link_status": status}

    validated: List[Dict] = []
    with ThreadPoolExecutor(max_workers=10) as pool:
        futures = {pool.submit(check, j): j for j in jobs}
        for fut in as_completed(futures):
            try:
                validated.append(fut.result())
            except Exception as e:
                job = futures[fut]
                logger.debug(f"Validation error for {job.get('id')}: {e}")
                validated.append({**job, "link_valid": False, "link_status": "error"})

    valid_count = sum(1 for j in validated if j.get("link_valid"))
    broken_count = len(validated) - valid_count
    logger.info(f"Link validation: {valid_count} valid, {broken_count} broken out of {len(validated)}")
    return validated


def _is_trusted_board(url: str) -> bool:
    try:
        domain = urlparse(url).netloc.lower().lstrip("www.")
        return any(domain == tb or domain.endswith("." + tb) for tb in TRUSTED_JOB_BOARDS)
    except Exception:
        return False


def _looks_like_posting(url: str) -> bool:
    """Return False if the URL is clearly a search/homepage, not a job posting."""
    if any(pat in url for pat in NOT_A_POSTING):
        return False
    # LinkedIn job posting: /jobs/view/DIGITS or /jobs/TITLE-at-COMPANY-DIGITS
    if "linkedin.com" in url:
        return "/jobs/view/" in url or "/jobs/" in url
    # Naukri posting: contains a job-listings path or job ID
    if "naukri.com" in url:
        return "job-listings" in url or "/job/" in url or bool(url.split("/")[-1])
    # Indeed posting: contains jk= param or /viewjob
    if "indeed.com" in url:
        return "jk=" in url or "viewjob" in url or "applystart" in url
    # Generic: URL has a meaningful path (not just domain/)
    parsed = urlparse(url)
    return len(parsed.path.strip("/")) > 3


def _http_check(url: str, timeout: int) -> tuple[bool, str]:
    try:
        headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
                          "(KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"
        }
        resp = requests.head(url, headers=headers, timeout=timeout, allow_redirects=True)
        if resp.status_code < 400:
            return True, f"HTTP {resp.status_code}"
        if resp.status_code == 405:
            resp2 = requests.get(url, headers=headers, timeout=timeout, stream=True)
            resp2.close()
            if resp2.status_code < 400:
                return True, f"HTTP {resp2.status_code}"
        return False, f"HTTP {resp.status_code}"
    except requests.exceptions.ConnectionError:
        return False, "connection_error"
    except requests.exceptions.Timeout:
        return False, "timeout"
    except Exception as e:
        return False, str(e)[:40]

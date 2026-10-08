"""
JSON-based persistent storage for jobs, applied history, and resume cache.
"""

from __future__ import annotations

import json
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Optional

BASE_DIR = Path(__file__).resolve().parent.parent.parent / "data"
BASE_DIR.mkdir(exist_ok=True)

JOBS_FILE = BASE_DIR / "jobs.json"
APPLIED_FILE = BASE_DIR / "applied.json"
RESUME_CACHE_FILE = BASE_DIR / "resume_cache.json"


def _load(path: Path) -> Any:
    if path.exists():
        try:
            return json.loads(path.read_text(encoding="utf-8"))
        except json.JSONDecodeError:
            return [] if "jobs" in path.name or "applied" in path.name else {}
    return [] if "jobs" in path.name or "applied" in path.name else {}


def _save(path: Path, data: Any) -> None:
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False), encoding="utf-8")


# ── Jobs ──────────────────────────────────────────────────────────────────────

def save_jobs(jobs: List[Dict]) -> None:
    _save(JOBS_FILE, jobs)


def load_jobs() -> List[Dict]:
    return _load(JOBS_FILE)


def get_job_by_id(job_id: str) -> Optional[Dict]:
    return next((j for j in load_jobs() if j.get("id") == job_id), None)


def update_job(job_id: str, updates: Dict) -> bool:
    jobs = load_jobs()
    for i, j in enumerate(jobs):
        if j.get("id") == job_id:
            jobs[i] = {**j, **updates}
            save_jobs(jobs)
            return True
    return False


# ── Applied tracker ───────────────────────────────────────────────────────────

def log_application(job: Dict, status: str = "Applied") -> None:
    applied: List[Dict] = _load(APPLIED_FILE)
    applied.append({
        "id": job.get("id"),
        "title": job.get("title"),
        "company": job.get("company"),
        "apply_url": job.get("apply_url"),
        "status": status,
        "applied_at": datetime.now().isoformat(),
    })
    _save(APPLIED_FILE, applied)


def load_applied() -> List[Dict]:
    return _load(APPLIED_FILE)


def update_application_status(job_id: str, status: str) -> bool:
    applied = load_applied()
    for a in applied:
        if a.get("id") == job_id:
            a["status"] = status
            a["updated_at"] = datetime.now().isoformat()
            _save(APPLIED_FILE, applied)
            return True
    return False


# ── Resume cache ──────────────────────────────────────────────────────────────

def save_resume_cache(data: Dict) -> None:
    _save(RESUME_CACHE_FILE, data)


def load_resume_cache() -> Dict:
    return _load(RESUME_CACHE_FILE)

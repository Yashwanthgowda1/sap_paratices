from __future__ import annotations

import os
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional

from dotenv import load_dotenv


_ENV_PATH = Path(__file__).resolve().parent.parent / ".env"
load_dotenv(_ENV_PATH, override=True)


def _get(key: str, default: str = "") -> str:
    return os.getenv(key, default).strip()


@dataclass
class Config:
    # ── AI APIs ──────────────────────────────────────────────────────────────
    anthropic_api_key: str = field(default_factory=lambda: _get("ANTHROPIC_API_KEY"))
    groq_api_key: str = field(default_factory=lambda: _get("GROQ_API_KEY"))

    # ── Job Board APIs ────────────────────────────────────────────────────────
    rapidapi_key: str = field(default_factory=lambda: _get("RAPIDAPI_KEY"))
    serpapi_key: str = field(default_factory=lambda: _get("SERPAPI_KEY"))
    apify_api_key: str = field(default_factory=lambda: _get("APIFY_API_KEY"))

    # ── Search Parameters ─────────────────────────────────────────────────────
    job_role: str = field(default_factory=lambda: _get("JOB_ROLE", "SDET"))
    job_location: str = field(default_factory=lambda: _get("JOB_LOCATION", "Bangalore, India"))
    job_experience: str = field(default_factory=lambda: _get("JOB_EXPERIENCE", "3-5 years"))
    salary_min: int = field(default_factory=lambda: int(_get("JOB_SALARY_MIN", "15")))
    salary_max: int = field(default_factory=lambda: int(_get("JOB_SALARY_MAX", "30")))

    # ── Credentials ───────────────────────────────────────────────────────────
    linkedin_email: str = field(default_factory=lambda: _get("LINKEDIN_EMAIL"))
    linkedin_password: str = field(default_factory=lambda: _get("LINKEDIN_PASSWORD"))
    naukri_email: str = field(default_factory=lambda: _get("NAUKRI_EMAIL"))
    naukri_password: str = field(default_factory=lambda: _get("NAUKRI_PASSWORD"))

    # ── Paths ─────────────────────────────────────────────────────────────────
    chrome_profile_dir: str = field(
        default_factory=lambda: _get("CHROME_PROFILE_DIR", "./chrome_profile")
    )
    resume_path: str = field(default_factory=lambda: _get("RESUME_PATH", "./resume/resume.pdf"))

    # ── Runtime ───────────────────────────────────────────────────────────────
    headless: bool = False
    max_jobs_per_source: int = 100
    link_validation_timeout: int = 8
    apply_delay_seconds: float = 2.0

    @property
    def has_anthropic(self) -> bool:
        return bool(self.anthropic_api_key and self.anthropic_api_key != "sk-ant-api03-...")

    @property
    def has_groq(self) -> bool:
        return bool(self.groq_api_key and self.groq_api_key != "gsk_...")

    @property
    def has_rapidapi(self) -> bool:
        return bool(self.rapidapi_key and len(self.rapidapi_key) > 10)

    @property
    def has_serpapi(self) -> bool:
        return bool(self.serpapi_key and len(self.serpapi_key) > 10)


_instance: Optional[Config] = None


def get_config() -> Config:
    global _instance
    if _instance is None:
        _instance = Config()
    return _instance

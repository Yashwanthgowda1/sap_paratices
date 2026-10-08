"""
ATS scoring: parse resume → structured data + ATS score using AI.
Falls back to rule-based scoring if no AI key is available.
"""

from __future__ import annotations

import re
from typing import Any, Dict

from ..constants import SKILL_KEYWORDS
from ..logger import start_logging

logger = start_logging("ats_scorer")


def score_resume(resume_text: str) -> Dict[str, Any]:
    """
    Parse resume text and return structured ATS data.
    Tries Anthropic first, then Groq, then rule-based.
    """
    try:
        from ..ai_client import AIClient
        ai = AIClient()
        data = ai.parse_resume(resume_text)
        if data:
            logger.info(f"Resume parsed by AI: {data.get('name', 'Unknown')}, ATS={data.get('ats_score')}")
            return data
    except Exception as e:
        logger.warning(f"AI resume parsing failed: {e}. Using rule-based fallback.")

    return _rule_based_parse(resume_text)


def _rule_based_parse(text: str) -> Dict[str, Any]:
    """Simple regex-based resume parser."""
    skills_found = [s for s in SKILL_KEYWORDS if s.lower() in text.lower()]

    # Years of experience
    year_matches = re.findall(r"(\d+)\s*\+?\s*years?", text, re.IGNORECASE)
    total_years = max((int(y) for y in year_matches), default=3)
    total_years = min(total_years, 20)

    # Email
    email_match = re.search(r"[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}", text)
    email = email_match.group(0) if email_match else ""

    # Phone
    phone_match = re.search(r"[\+\(]?\d[\d\s\-\(\)]{8,14}\d", text)
    phone = phone_match.group(0).strip() if phone_match else ""

    # Name (first non-empty line)
    lines = [l.strip() for l in text.splitlines() if l.strip()]
    name = lines[0] if lines else "Candidate"

    ats_score = min(40 + len(skills_found) * 3, 95)

    career_level = "mid"
    if total_years <= 1:
        career_level = "fresher"
    elif total_years <= 2:
        career_level = "junior"
    elif total_years <= 5:
        career_level = "mid"
    elif total_years <= 8:
        career_level = "senior"
    else:
        career_level = "lead"

    return {
        "name": name,
        "email": email,
        "phone": phone,
        "total_years": total_years,
        "current_title": "QA Automation Engineer",
        "skills": skills_found,
        "experience": [],
        "education": [],
        "domain": "IT Services",
        "career_level": career_level,
        "ats_score": ats_score,
        "key_achievements": [],
    }

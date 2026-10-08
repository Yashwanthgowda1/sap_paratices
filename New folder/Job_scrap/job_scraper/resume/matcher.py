from __future__ import annotations

import re
from typing import Any, Dict, List

from ..constants import REC_APPLY, REC_IMPROVE, REC_SKIP, SKILL_KEYWORDS
from ..logger import start_logging

logger = start_logging("matcher")

_SKILL_SET_LOWER = {s.lower() for s in SKILL_KEYWORDS}


def match_jobs(resume_data: Dict[str, Any], jobs: List[Dict]) -> List[Dict]:
    logger.info(f"Matching {len(jobs)} jobs against resume...")
    resume_skills_lower = {s.lower() for s in resume_data.get("skills", [])}
    enriched = []
    for job in jobs:
        try:
            enriched.append(_match_one(resume_data, job, resume_skills_lower))
        except Exception as e:
            logger.warning(f"Match failed for {job.get('title')}: {e}")
            enriched.append({**job, "match_percent": 50, "missing_skills": [], "recommendation": REC_IMPROVE})
    enriched.sort(key=lambda j: j.get("match_percent", 0), reverse=True)
    return enriched


def analyze_jobs_with_ai(jobs: List[Dict], resume_data: Dict = None) -> List[Dict]:
    """Run AI JD relevance check on every job; tags ai_verdict / ai_score / ai_reason."""
    try:
        from ..ai_client import AIClient
        ai = AIClient()
    except Exception as e:
        logger.warning(f"AI client unavailable for JD analysis: {e}")
        return jobs

    results = []
    for job in jobs:
        try:
            verdict = ai.analyze_jd_relevance(job, resume_data)
            results.append({**job, **verdict})
            logger.debug(
                f"AI [{verdict['ai_verdict'].upper()} {verdict['ai_score']}] "
                f"{job.get('title')} @ {job.get('company')}"
            )
        except Exception as e:
            logger.warning(f"AI JD analysis failed for {job.get('title')}: {e}")
            results.append({**job, "ai_verdict": "select", "ai_score": 50, "ai_reason": ""})

    selected = sum(1 for j in results if j.get("ai_verdict") == "select")
    logger.info(f"AI JD filter: {selected}/{len(results)} jobs selected")
    return results


def _match_one(resume_data: Dict, job: Dict, resume_skills_lower: set) -> Dict:
    required = job.get("required_skills", []) or _extract_skills_rule_based(job.get("jd", ""))
    nice = job.get("nice_to_have", [])

    matched = [s for s in required if _skill_matches(s, resume_skills_lower)]
    missing = [s for s in required if s not in matched]
    matched_nice = [s for s in nice if _skill_matches(s, resume_skills_lower)]

    match_pct = round((len(matched) / len(required)) * 100) if required else 55
    match_pct = min(match_pct + len(matched_nice) * 3, 100)

    exp_match = _check_exp_match(resume_data.get("total_years", 3), job.get("experience", "3-5 years"))

    interview_chance = min(95, int(
        match_pct * 0.5
        + (25 if exp_match == "exact" else 12 if exp_match == "partial" else 0)
        + len(matched_nice) * 2
    ))

    if match_pct >= 75:
        rec = REC_APPLY
    elif match_pct >= 50:
        rec = REC_IMPROVE
    else:
        rec = REC_SKIP

    return {
        **job,
        "required_skills": required,
        "nice_to_have": nice,
        "matched_skills": matched,
        "missing_skills": missing,
        "match_percent": match_pct,
        "exp_match": exp_match,
        "interview_chance": interview_chance,
        "recommendation": rec,
    }


def _skill_matches(skill: str, resume_skills_lower: set) -> bool:
    sl = skill.lower()
    return any(sl in rs or rs in sl for rs in resume_skills_lower)


def _check_exp_match(candidate_years: int, job_exp_str: str) -> str:
    nums = re.findall(r"\d+", job_exp_str)
    if not nums:
        return "partial"
    lo = int(nums[0])
    hi = int(nums[1]) if len(nums) > 1 else lo + 3
    if lo <= candidate_years <= hi:
        return "exact"
    if abs(candidate_years - lo) <= 1 or abs(candidate_years - hi) <= 1:
        return "partial"
    return "mismatch"


def _extract_skills_rule_based(jd_text: str) -> List[str]:
    jd_lower = jd_text.lower()
    return [s for s in SKILL_KEYWORDS if s.lower() in jd_lower]

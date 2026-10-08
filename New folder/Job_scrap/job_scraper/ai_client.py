"""
Unified AI client supporting Anthropic (Claude) and Groq (Llama).
Primary: Anthropic for deep analysis.
Fallback: Groq for fast batch processing.
"""

from __future__ import annotations

import json
import re
from typing import Any, Dict, Optional

from .config import get_config
from .logger import start_logging

logger = start_logging("ai_client")


class AnthropicClient:
    """Wrapper around the Anthropic Messages API."""

    def __init__(self) -> None:
        cfg = get_config()
        if not cfg.has_anthropic:
            raise RuntimeError("ANTHROPIC_API_KEY not set in .env")
        import anthropic
        self._client = anthropic.Anthropic(api_key=cfg.anthropic_api_key)

    def complete(
        self,
        prompt: str,
        system: str = "You are a helpful assistant. Return valid JSON only, no markdown.",
        model: str = "claude-sonnet-4-5",
        max_tokens: int = 2000,
    ) -> str:
        logger.debug(f"Anthropic request: model={model}, tokens={max_tokens}")
        msg = self._client.messages.create(
            model=model,
            max_tokens=max_tokens,
            system=system,
            messages=[{"role": "user", "content": prompt}],
        )
        return msg.content[0].text

    def complete_json(self, prompt: str, system: str = "", **kwargs) -> Dict[str, Any]:
        raw = self.complete(prompt, system=system or "Return valid JSON only.", **kwargs)
        raw = re.sub(r"```json|```", "", raw).strip()
        return json.loads(raw)


class GroqClient:
    """Wrapper around the Groq chat completions API (fast, cheap)."""

    def __init__(self) -> None:
        cfg = get_config()
        if not cfg.has_groq:
            raise RuntimeError("GROQ_API_KEY not set in .env")
        from groq import Groq
        self._client = Groq(api_key=cfg.groq_api_key)

    def complete(
        self,
        prompt: str,
        system: str = "You are a helpful assistant. Return valid JSON only.",
        model: str = "llama-3.1-8b-instant",
        max_tokens: int = 1500,
    ) -> str:
        logger.debug(f"Groq request: model={model}")
        resp = self._client.chat.completions.create(
            model=model,
            messages=[
                {"role": "system", "content": system},
                {"role": "user", "content": prompt},
            ],
            max_tokens=max_tokens,
            temperature=0.1,
        )
        return resp.choices[0].message.content

    def complete_json(self, prompt: str, system: str = "", **kwargs) -> Dict[str, Any]:
        raw = self.complete(prompt, system=system or "Return valid JSON only.", **kwargs)
        raw = re.sub(r"```json|```", "", raw).strip()
        return json.loads(raw)


class AIClient:
    """
    Unified client with automatic fallback:
      deep_analysis()  → Anthropic (high quality)
      fast_batch()     → Groq (fast / cheap)
    """

    def __init__(self) -> None:
        cfg = get_config()
        self._anthropic: Optional[AnthropicClient] = None
        self._groq: Optional[GroqClient] = None

        if cfg.has_anthropic:
            try:
                self._anthropic = AnthropicClient()
                logger.info("Anthropic client initialized")
            except Exception as e:
                logger.warning(f"Anthropic init failed: {e}")

        if cfg.has_groq:
            try:
                self._groq = GroqClient()
                logger.info("Groq client initialized")
            except Exception as e:
                logger.warning(f"Groq init failed: {e}")

    # ── High-quality operations (Anthropic first) ────────────────────────────

    def parse_resume(self, resume_text: str) -> Dict[str, Any]:
        system = (
            "You are an 15+ year  expert resume parser for tech/QA roles. "
            "Return ONLY valid JSON with these exact fields: "
            "name, email, phone, total_years (int), current_title, "
            "skills (list of strings), experience (list of {company, title, duration, description}), "
            "education (list of {degree, institution, year}), "
            "domain, career_level (fresher|junior|mid|senior|lead|manager), "
            "ats_score (int 0-100), key_achievements (list of strings)."
        )
        prompt = f"Parse this resume and return structured JSON:\n\n{resume_text[:6000]}"
        return self._call_json(prompt, system, prefer="anthropic")

    def score_ats(self, resume_data: Dict, job_jd: str) -> Dict[str, Any]:
        system = (
            "You are an ATS scoring expert. Return JSON with: "
            "match_percent (int 0-100), matched_skills (list), missing_skills (list), "
            "nice_to_have (list), interview_chance (int 0-100), "
            "recommendation (apply|improve|skip), "
            "resume_tips (list of 3-5 actionable strings)."
        )
        resume_summary = json.dumps({
            "skills": resume_data.get("skills", []),
            "total_years": resume_data.get("total_years"),
            "career_level": resume_data.get("career_level"),
        })
        prompt = (
            f"Resume summary:\n{resume_summary}\n\n"
            f"Job Description:\n{job_jd[:2000]}\n\n"
            "Score how well this resume matches the job. Return JSON only."
        )
        return self._call_json(prompt, system, prefer="groq")

    def generate_cover_letter(self, resume_data: Dict, job: Dict) -> str:
        system = "You are a professional cover letter writer for SDET/QA roles."
        prompt = (
            f"Write a professional cover letter (under 280 words) for:\n"
            f"Role: {job.get('title')} at {job.get('company')}\n"
            f"Location: {job.get('location')}\n"
            f"JD: {job.get('jd', '')[:800]}\n\n"
            f"Candidate: {resume_data.get('name')}, "
            f"{resume_data.get('total_years')} years experience, "
            f"skills: {', '.join(resume_data.get('skills', [])[:8])}\n\n"
            "Return only the cover letter text, no subject line."
        )
        try:
            if self._anthropic:
                return self._anthropic.complete(prompt, system=system, max_tokens=600)
        except Exception as e:
            logger.warning(f"Cover letter via Anthropic failed: {e}")
        if self._groq:
            return self._groq.complete(prompt, system=system, max_tokens=600)
        return ""

    def extract_jd_skills(self, jd_text: str) -> Dict[str, Any]:
        system = "Extract skills from a job description. Return JSON only."
        prompt = (
            f"Extract from this JD:\n{jd_text[:2000]}\n\n"
            "Return JSON: {required_skills: [], nice_to_have: [], experience_years: '3-5', "
            "domain: 'FinTech|SaaS|etc'}"
        )
        return self._call_json(prompt, system, prefer="groq")

    def analyze_jd_relevance(self, job: Dict, resume_data: Dict = None) -> Dict[str, Any]:
        """AI decides if a job is worth applying to. Returns ai_verdict/ai_score/ai_reason.
        Uses whichever AI client is available — Groq (fast) first, Anthropic as fallback.
        """
        system = (
            "You are a smart job filter for an SDET / QA Automation Engineer with 3-5 years "
            "of experience (Selenium, Playwright, RestAssured, Cypress, API testing, Java/Python). "
            "Decide if the job is relevant and worth applying. "
            "Return ONLY JSON: {\"ai_verdict\": \"select\" or \"skip\", "
            "\"ai_score\": int 0-100, \"ai_reason\": \"one sentence\"}"
        )
        title = job.get("title", "")
        company = job.get("company", "")
        jd_snippet = (job.get("jd") or "")[:600]
        skills = ", ".join(job.get("required_skills", [])[:10])

        resume_ctx = ""
        if resume_data:
            resume_ctx = (
                f"Candidate skills: {', '.join(resume_data.get('skills', [])[:12])}\n"
                f"Experience: {resume_data.get('total_years', 3)} years\n"
            )

        prompt = (
            f"Job Title: {title}\n"
            f"Company: {company}\n"
            f"Required Skills: {skills}\n"
            f"JD Snippet: {jd_snippet}\n"
            f"{resume_ctx}"
            "Is this a genuine QA / Automation / SDET role worth applying to?"
        )
        # Try Groq first (fast/cheap), fall back to Anthropic — uses whatever key is set in .env
        result = self._call_json(prompt, system, prefer="groq")
        return {
            "ai_verdict": result.get("ai_verdict", "select"),
            "ai_score": int(result.get("ai_score", 50)),
            "ai_reason": result.get("ai_reason", ""),
        }

    # ── Internal helpers ──────────────────────────────────────────────────────

    def _call_json(
        self, prompt: str, system: str, prefer: str = "anthropic"
    ) -> Dict[str, Any]:
        clients = (
            [self._anthropic, self._groq]
            if prefer == "anthropic"
            else [self._groq, self._anthropic]
        )
        last_err: Optional[Exception] = None
        for client in clients:
            if client is None:
                continue
            try:
                return client.complete_json(prompt, system=system)
            except Exception as e:
                last_err = e
                logger.warning(f"AI call failed ({type(client).__name__}): {e}")
        logger.error(f"All AI clients failed. Last error: {last_err}")
        return {}

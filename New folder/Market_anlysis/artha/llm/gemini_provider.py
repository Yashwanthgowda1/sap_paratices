"""Google Gemini provider."""
from __future__ import annotations

from artha.llm.base import LLMError, LLMProvider


class GeminiProvider(LLMProvider):
    name = "Gemini (Google)"

    def generate(self, system: str, user: str,
                 max_tokens: int = 1800, temperature: float = 0.3) -> str:
        try:
            import google.generativeai as genai
        except ImportError as exc:
            raise LLMError(
                "google-generativeai not installed. "
                "pip install google-generativeai") from exc
        try:
            genai.configure(api_key=self.api_key)
            model = genai.GenerativeModel(
                model_name=self.model, system_instruction=system)
            resp = model.generate_content(
                user,
                generation_config={
                    "max_output_tokens": max_tokens,
                    "temperature": temperature,
                },
            )
            return resp.text or ""
        except Exception as exc:
            raise LLMError(f"Gemini call failed: {exc}") from exc

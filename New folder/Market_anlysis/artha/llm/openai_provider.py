"""OpenAI GPT provider."""
from __future__ import annotations

from artha.llm.base import LLMError, LLMProvider


class OpenAIProvider(LLMProvider):
    name = "GPT (OpenAI)"

    def generate(self, system: str, user: str,
                 max_tokens: int = 1800, temperature: float = 0.3) -> str:
        try:
            from openai import OpenAI
        except ImportError as exc:
            raise LLMError("openai SDK not installed. pip install openai") from exc
        try:
            client = OpenAI(api_key=self.api_key)
            resp = client.chat.completions.create(
                model=self.model,
                max_tokens=max_tokens,
                temperature=temperature,
                messages=[
                    {"role": "system", "content": system},
                    {"role": "user", "content": user},
                ],
            )
            return resp.choices[0].message.content or ""
        except Exception as exc:
            raise LLMError(f"OpenAI call failed: {exc}") from exc

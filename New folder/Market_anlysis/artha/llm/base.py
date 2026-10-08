"""Abstract LLM provider so Claude/OpenAI/Gemini are swappable at runtime."""
from __future__ import annotations

from abc import ABC, abstractmethod


class LLMError(RuntimeError):
    """Raised when a provider is misconfigured or the API call fails."""


class LLMProvider(ABC):
    name: str = "base"

    def __init__(self, api_key: str, model: str):
        if not api_key:
            raise LLMError(f"{self.name}: API key is required.")
        self.api_key = api_key
        self.model = model

    @abstractmethod
    def generate(self, system: str, user: str,
                 max_tokens: int = 1800, temperature: float = 0.3) -> str:
        """Return the model's text response, or raise LLMError."""

    def __repr__(self) -> str:  # pragma: no cover
        return f"<{self.__class__.__name__} model={self.model}>"

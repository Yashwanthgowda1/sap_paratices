"""Factory: pick an LLM provider by name with a runtime-supplied API key.

Keys entered in the dashboard sidebar take priority; .env values are the fallback.
"""
from __future__ import annotations

from artha.config import SETTINGS
from artha.llm.base import LLMError, LLMProvider
from artha.llm.claude_provider import ClaudeProvider
from artha.llm.gemini_provider import GeminiProvider
from artha.llm.openai_provider import OpenAIProvider

PROVIDERS = {
    "Claude (Anthropic)": {
        "cls": ClaudeProvider,
        "default_model": SETTINGS.anthropic_model,
        "env_key": SETTINGS.anthropic_key,
        "models": ["claude-sonnet-4-6", "claude-opus-4-8", "claude-haiku-4-5-20251001"],
    },
    "GPT (OpenAI)": {
        "cls": OpenAIProvider,
        "default_model": SETTINGS.openai_model,
        "env_key": SETTINGS.openai_key,
        "models": ["gpt-4o", "gpt-4o-mini", "gpt-4-turbo"],
    },
    "Gemini (Google)": {
        "cls": GeminiProvider,
        "default_model": SETTINGS.gemini_model,
        "env_key": SETTINGS.google_key,
        "models": ["gemini-1.5-pro", "gemini-1.5-flash", "gemini-2.0-flash-exp"],
    },
}


def provider_names() -> list[str]:
    return list(PROVIDERS.keys())


def models_for(name: str) -> list[str]:
    return PROVIDERS.get(name, {}).get("models", [])


def default_key_for(name: str) -> str:
    return PROVIDERS.get(name, {}).get("env_key", "")


def get_provider(name: str, api_key: str = "",
                 model: str | None = None) -> LLMProvider:
    spec = PROVIDERS.get(name)
    if not spec:
        raise LLMError(f"Unknown provider '{name}'.")
    key = api_key or spec["env_key"]
    chosen_model = model or spec["default_model"]
    return spec["cls"](api_key=key, model=chosen_model)

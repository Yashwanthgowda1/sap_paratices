"""Anthropic Claude provider — uses direct REST calls (no SDK httpx dependency)."""
from __future__ import annotations

import requests

from artha.llm.base import LLMError, LLMProvider

_API_URL = "https://api.anthropic.com/v1/messages"
_API_VERSION = "2023-06-01"


class ClaudeProvider(LLMProvider):
    name = "Claude (Anthropic)"

    def generate(self, system: str, user: str,
                 max_tokens: int = 1800, **_) -> str:
        if not self.api_key:
            raise LLMError("No Anthropic API key — paste it in the sidebar.")
        headers = {
            "x-api-key": self.api_key,
            "anthropic-version": _API_VERSION,
            "content-type": "application/json",
        }
        payload = {
            "model": self.model,
            "max_tokens": max_tokens,
            "system": system,
            "messages": [{"role": "user", "content": user}],
        }
        try:
            resp = requests.post(_API_URL, headers=headers, json=payload, timeout=120)
            resp.raise_for_status()
            data = resp.json()
            return "".join(
                block["text"] for block in data.get("content", [])
                if block.get("type") == "text")
        except requests.HTTPError as exc:
            code = exc.response.status_code
            body = exc.response.text[:300]
            if code == 401:
                raise LLMError("Invalid API key — check it in the sidebar.") from exc
            if code == 429:
                raise LLMError("Rate limit hit — wait a moment and try again.") from exc
            raise LLMError(f"Claude API error {code}: {body}") from exc
        except requests.ConnectionError as exc:
            raise LLMError("Cannot reach api.anthropic.com — check internet/VPN.") from exc
        except Exception as exc:
            raise LLMError(f"Claude call failed: {exc}") from exc

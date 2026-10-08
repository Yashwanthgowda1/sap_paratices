"""Live mutual-fund NAVs via the free mfapi.in service (sources AMFI daily)."""
from __future__ import annotations

import time
from dataclasses import dataclass, field
from typing import Optional

import requests

from artha.config import SETTINGS
from artha.logger import get_logger

log = get_logger("artha.mf")

_BASE = "https://api.mfapi.in/mf"
_cache: dict[str, tuple[float, "FundNav"]] = {}


@dataclass
class FundNav:
    scheme_code: str
    scheme_name: str
    nav: float
    nav_date: str
    history: list[tuple[str, float]] = field(default_factory=list)  # (date, nav)
    ok: bool = True


def get_nav(scheme_code: str, with_history: bool = False) -> Optional[FundNav]:
    """Latest NAV (and optional history) for an AMFI scheme code."""
    key = f"{scheme_code}:{with_history}"
    hit = _cache.get(key)
    if hit and (time.time() - hit[0]) < max(SETTINGS.quote_cache_ttl, 300):
        return hit[1]
    try:
        resp = requests.get(f"{_BASE}/{scheme_code}", timeout=10)
        resp.raise_for_status()
        payload = resp.json()
        data = payload.get("data", [])
        if not data:
            return None
        latest = data[0]
        hist: list[tuple[str, float]] = []
        if with_history:
            hist = [(row["date"], float(row["nav"])) for row in data]
        fund = FundNav(
            scheme_code=str(scheme_code),
            scheme_name=payload.get("meta", {}).get("scheme_name", scheme_code),
            nav=float(latest["nav"]),
            nav_date=latest["date"],
            history=hist,
        )
        _cache[key] = (time.time(), fund)
        return fund
    except Exception as exc:
        log.warning("NAV fetch failed for %s: %s", scheme_code, exc)
        return None


def rolling_cagr(history: list[tuple[str, float]], years: int) -> Optional[float]:
    """Point-to-point CAGR over `years` using the NAV history list (newest first)."""
    if not history or len(history) < 2:
        return None
    newest_nav = history[0][1]
    target_days = years * 365
    for i, (_, nav) in enumerate(history):
        if i >= target_days and nav > 0:
            return round(((newest_nav / nav) ** (1 / years) - 1) * 100, 2)
    return None

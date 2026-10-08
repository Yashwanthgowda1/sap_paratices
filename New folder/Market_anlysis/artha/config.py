"""Central configuration. Loads .env, exposes typed settings and tax constants."""
from __future__ import annotations

import os
from dataclasses import dataclass, field

from dotenv import load_dotenv

load_dotenv()


def _f(key: str, default: float) -> float:
    try:
        return float(os.getenv(key, default))
    except (TypeError, ValueError):
        return default


@dataclass(frozen=True)
class Settings:
    """Runtime settings sourced from environment, with safe defaults."""

    anthropic_key: str = os.getenv("ANTHROPIC_API_KEY", "")
    openai_key: str = os.getenv("OPENAI_API_KEY", "")
    google_key: str = os.getenv("GOOGLE_API_KEY", "")

    anthropic_model: str = os.getenv("ANTHROPIC_MODEL", "claude-sonnet-4-6")
    openai_model: str = os.getenv("OPENAI_MODEL", "gpt-4o")
    gemini_model: str = os.getenv("GEMINI_MODEL", "gemini-1.5-pro")

    repo_rate: float = _f("RBI_REPO_RATE", 6.50)
    inflation: float = _f("CPI_INFLATION", 4.80)
    gsec_10y: float = _f("GSEC_10Y", 7.05)
    quote_cache_ttl: int = int(_f("QUOTE_CACHE_TTL", 60))


SETTINGS = Settings()


# --- Indian tax constants, FY 2025-26 / AY 2026-27 (post Budget 2024 regime) ---
@dataclass(frozen=True)
class TaxRules:
    STCG_EQUITY: float = 0.20          # Sec 111A, raised from 15% (Jul 2024)
    LTCG_EQUITY: float = 0.125         # Sec 112A, raised from 10% (Jul 2024)
    LTCG_EQUITY_EXEMPTION: float = 125_000  # per FY, raised from 1,00,000
    EQUITY_LTCG_DAYS: int = 365        # >12 months = long term for listed equity
    CESS: float = 0.04                 # Health & Education cess on tax
    # Slab-rate instruments (debt MF post-Apr-2023, FD, dividends) use user's slab.
    SURCHARGE_THRESHOLD: float = 5_000_000


TAX = TaxRules()


# Market symbols used for live quotes (Yahoo Finance tickers).
INDEX_TICKERS = {
    "NIFTY 50": "^NSEI",
    "SENSEX": "^BSESN",
    "INDIA VIX": "^INDIAVIX",
    "USD/INR": "INR=X",
    "GOLD (USD/oz)": "GC=F",
    "CRUDE (Brent)": "BZ=F",
}

# Default export dir (kept for logs/snapshots; no Excel generated).
EXPORT_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), "exports")

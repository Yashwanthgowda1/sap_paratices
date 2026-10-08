"""Live market data via Yahoo Finance v8 chart API (no key required).

Uses direct requests to query1.finance.yahoo.com instead of yfinance fast_info,
which is broken in newer library versions. Quotes are cached in-process for
SETTINGS.quote_cache_ttl seconds so repeated reruns don't hammer Yahoo.
"""
from __future__ import annotations

import time
from dataclasses import dataclass
from typing import Optional

import requests

from artha.config import INDEX_TICKERS, SETTINGS
from artha.logger import get_logger

log = get_logger("artha.market")

_YF_URL = "https://query1.finance.yahoo.com/v8/finance/chart/{symbol}?interval=1d&range=5d"
_HEADERS = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"}
_cache: dict[str, tuple[float, "Quote"]] = {}


@dataclass
class Quote:
    symbol: str
    price: float
    prev_close: float
    change_pct: float
    currency: str = "INR"
    ok: bool = True

    @property
    def is_up(self) -> bool:
        return self.change_pct >= 0


def _fresh(symbol: str) -> Optional[Quote]:
    hit = _cache.get(symbol)
    if hit and (time.time() - hit[0]) < SETTINGS.quote_cache_ttl:
        return hit[1]
    return None


def get_quote(symbol: str) -> Quote:
    """Live quote for one Yahoo ticker via v8 chart API. Fails soft on any error."""
    cached = _fresh(symbol)
    if cached:
        return cached
    try:
        url = _YF_URL.format(symbol=requests.utils.quote(symbol, safe=""))
        resp = requests.get(url, headers=_HEADERS, timeout=10)
        resp.raise_for_status()
        result = resp.json()["chart"]["result"]
        if not result:
            return Quote(symbol, 0.0, 0.0, 0.0, ok=False)
        meta = result[0]["meta"]
        price = float(meta.get("regularMarketPrice") or 0.0)
        prev  = float(meta.get("chartPreviousClose") or meta.get("previousClose") or price)
        cur   = str(meta.get("currency") or "INR")
        change = ((price - prev) / prev * 100.0) if prev else 0.0
        q = Quote(symbol, round(price, 2), round(prev, 2), round(change, 2), cur)
        _cache[symbol] = (time.time(), q)
        return q
    except Exception as exc:
        log.warning("quote failed for %s: %s", symbol, exc)
        return Quote(symbol, 0.0, 0.0, 0.0, ok=False)


def get_index_snapshot() -> dict[str, Quote]:
    """Top-of-dashboard ticker strip: Nifty, Sensex, VIX, USD/INR, Gold, Crude."""
    return {label: get_quote(tk) for label, tk in INDEX_TICKERS.items()}


def gold_inr_per_gram(usd_inr: float) -> float:
    """Convert live COMEX gold (USD/oz) to INR per gram."""
    g = get_quote("GC=F")
    if not g.ok or not g.price:
        return 0.0
    return round((g.price * usd_inr) / 31.1035, 0)


def get_history(symbol: str, period: str = "1y") -> list[float]:
    """Return a list of daily close prices (oldest first) via Yahoo v8 chart API."""
    try:
        url = (_YF_URL.replace("interval=1d&range=5d", f"interval=1d&range={period}")
               .format(symbol=requests.utils.quote(symbol, safe="")))
        resp = requests.get(url, headers=_HEADERS, timeout=15)
        resp.raise_for_status()
        result = resp.json()["chart"]["result"]
        if not result:
            return []
        closes = result[0]["indicators"]["quote"][0]["close"]
        return [float(c) for c in closes if c is not None]
    except Exception as exc:
        log.warning("history failed for %s: %s", symbol, exc)
        return []
    """Best-effort fundamentals from yfinance info dict (PE, 52w range, etc.)."""
    try:
        import yfinance as yf
        info = yf.Ticker(symbol).info
        return {
            "pe": info.get("trailingPE"),
            "sector": info.get("sector"),
            "week52_high": info.get("fiftyTwoWeekHigh"),
            "week52_low": info.get("fiftyTwoWeekLow"),
            "roe": info.get("returnOnEquity"),
            "debt_to_equity": info.get("debtToEquity"),
            "dividend_yield": info.get("dividendYield"),
            "beta": info.get("beta"),
        }
    except Exception as exc:
        log.warning("fundamentals failed for %s: %s", symbol, exc)
        return {}

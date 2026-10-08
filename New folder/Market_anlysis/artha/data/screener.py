"""Screener.in fundamentals via the public company page (best-effort scrape).

No official API exists; the public company page exposes the top ratio row
(Market Cap, Current Price, P/E, Book Value, ROCE, ROE, Dividend Yield, etc.).
Login-gated data (full financials) is NOT accessed. Fails soft to {} so the
rest of the app keeps working if the site layout changes or blocks us.
"""
from __future__ import annotations

import time
from dataclasses import dataclass, field

import requests

from artha.logger import get_logger

log = get_logger("artha.screener")

_BASE = "https://www.screener.in/company/{sym}/"
_CONSOLIDATED = "https://www.screener.in/company/{sym}/consolidated/"
_HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
                  "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120 Safari/537.36",
    "Accept-Language": "en-US,en;q=0.9",
}
_cache: dict[str, tuple[float, "ScreenerData"]] = {}
_TTL = 900  # ratios change slowly; 15-min cache


@dataclass
class ScreenerData:
    symbol: str
    current_price: float = 0.0
    ratios: dict[str, str] = field(default_factory=dict)   # label -> raw value
    pros: list[str] = field(default_factory=list)
    cons: list[str] = field(default_factory=list)
    ok: bool = True

    def ratio(self, label: str) -> str:
        for k, v in self.ratios.items():
            if label.lower() in k.lower():
                return v
        return "—"


def _to_float(text: str) -> float:
    try:
        return float(text.replace(",", "").replace("₹", "").replace("%", "").strip())
    except (ValueError, AttributeError):
        return 0.0


def get_screener(symbol: str) -> ScreenerData:
    """Fetch Screener.in ratios for an NSE symbol (strip any .NS suffix)."""
    sym = symbol.replace(".NS", "").replace(".BO", "").upper()
    hit = _cache.get(sym)
    if hit and (time.time() - hit[0]) < _TTL:
        return hit[1]
    try:
        from bs4 import BeautifulSoup
    except ImportError:
        log.warning("beautifulsoup4 not installed; screener disabled")
        return ScreenerData(sym, ok=False)

    html = ""
    for url in (_CONSOLIDATED.format(sym=sym), _BASE.format(sym=sym)):
        try:
            resp = requests.get(url, headers=_HEADERS, timeout=12)
            if resp.status_code == 200:
                html = resp.text
                break
        except Exception as exc:
            log.warning("screener request failed %s: %s", url, exc)
    if not html:
        return ScreenerData(sym, ok=False)

    try:
        soup = BeautifulSoup(html, "lxml")
        ratios: dict[str, str] = {}
        for li in soup.select("#top-ratios li"):
            name_el = li.select_one(".name")
            val_el = li.select_one(".value")
            if name_el and val_el:
                name = name_el.get_text(" ", strip=True)
                value = val_el.get_text(" ", strip=True)
                ratios[name] = value
        price = _to_float(ratios.get("Current Price", "0"))

        def _bullets(section: str) -> list[str]:
            node = soup.find("p", string=lambda s: s and section in s)
            out: list[str] = []
            if node and node.find_next("ul"):
                out = [li.get_text(" ", strip=True)
                       for li in node.find_next("ul").select("li")]
            return out

        data = ScreenerData(
            symbol=sym, current_price=price, ratios=ratios,
            pros=_bullets("Pros"), cons=_bullets("Cons"))
        _cache[sym] = (time.time(), data)
        return data
    except Exception as exc:
        log.warning("screener parse failed for %s: %s", sym, exc)
        return ScreenerData(sym, ok=False)

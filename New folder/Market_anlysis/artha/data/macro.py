"""Macro snapshot: RBI/CPI defaults + live USD-INR, gold, crude, VIX, yield cues.

RBI repo / CPI / G-sec are config-driven (update after each MPC) because the RBI
site actively blocks scraping; everything else is pulled live from Yahoo.
"""
from __future__ import annotations

from dataclasses import dataclass

from artha.config import SETTINGS
from artha.data.market_data import get_quote, gold_inr_per_gram
from artha.logger import get_logger

log = get_logger("artha.macro")


@dataclass
class MacroSnapshot:
    repo_rate: float
    inflation: float
    gsec_10y: float
    usd_inr: float
    vix: float
    gold_inr_gram: float
    crude: float

    @property
    def rate_environment(self) -> str:
        if self.inflation < 4.0:
            return "Rate cut likely — supportive for debt MF & NBFCs"
        if self.inflation > 6.0:
            return "Rate hike risk — negative for long-duration debt"
        return "Rates on hold — inflation within RBI 2-6% band"

    @property
    def vix_mood(self) -> str:
        if self.vix == 0:
            return "n/a"
        if self.vix > 20:
            return "High fear — hedge / stagger entries"
        if self.vix < 13:
            return "Complacent / calm market"
        return "Normal volatility"


def get_macro() -> MacroSnapshot:
    usd = get_quote("INR=X")
    vix = get_quote("^INDIAVIX")
    crude = get_quote("BZ=F")
    usd_inr = usd.price or 84.0
    return MacroSnapshot(
        repo_rate=SETTINGS.repo_rate,
        inflation=SETTINGS.inflation,
        gsec_10y=SETTINGS.gsec_10y,
        usd_inr=round(usd_inr, 2),
        vix=vix.price,
        gold_inr_gram=gold_inr_per_gram(usd_inr),
        crude=crude.price,
    )

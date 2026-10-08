"""Service layer: refresh live prices on holdings and assemble the full snapshot.

Keeps the Streamlit app thin — the UI calls build_snapshot() and renders.
"""
from __future__ import annotations

from dataclasses import dataclass
from datetime import date, datetime

from artha.analytics.portfolio import (
    PortfolioSummary,
    overall_health,
    risk_flags,
    summarise,
)
from artha.analytics.tax_engine import (
    TaxResult,
    analyse_portfolio_tax,
    deduction_opportunities,
)
from artha.data.macro import MacroSnapshot, get_macro
from artha.data.market_data import get_index_snapshot
from artha.data.mutual_funds import get_nav
from artha.logger import get_logger
from artha.models import AssetClass, Flag, Holding, Severity, UserProfile

log = get_logger("artha.service")


@dataclass
class Snapshot:
    as_of: str
    indices: dict
    macro: MacroSnapshot
    holdings: list[Holding]
    summary: PortfolioSummary
    tax_results: list[TaxResult]
    tax_summary: dict
    flags: list[Flag]
    health: tuple[Severity, str]


def refresh_prices(holdings: list[Holding]) -> None:
    """Mutate holdings in place with live stock prices / MF NAVs / derived values."""
    from artha.data.market_data import get_quote
    from artha.data.macro import get_macro

    gold_gram = 0.0
    if any(h.asset_class in (AssetClass.SGB, AssetClass.GOLD) for h in holdings):
        gold_gram = get_macro().gold_inr_gram

    for h in holdings:
        try:
            if h.asset_class in (AssetClass.EQUITY_MF, AssetClass.DEBT_MF,
                                 AssetClass.ELSS) and h.scheme_code:
                fund = get_nav(h.scheme_code)
                if fund:
                    h.current_price = fund.nav
            elif h.asset_class == AssetClass.EQUITY and h.symbol:
                q = get_quote(h.symbol)
                if q.ok and q.price:
                    h.current_price = q.price
            elif h.asset_class == AssetClass.SGB:
                # Live gold per gram if available, else coupon-accreted value.
                h.current_price = gold_gram or h.avg_buy_price
            elif h.asset_class == AssetClass.FD:
                # Simple-interest accrual on principal to today.
                years = h.holding_days / 365.0
                h.current_price = round(
                    h.avg_buy_price * (1 + h.interest_rate / 100.0 * years), 0)
            if not h.current_price:
                h.current_price = h.avg_buy_price  # graceful fallback
        except Exception as exc:
            log.warning("price refresh failed for %s: %s", h.symbol or h.name, exc)
            h.current_price = h.current_price or h.avg_buy_price


def build_snapshot(holdings: list[Holding], user: UserProfile,
                   refresh: bool = True) -> Snapshot:
    if refresh:
        refresh_prices(holdings)
    indices = get_index_snapshot()
    macro = get_macro()
    summary = summarise(holdings)
    tax_results, tax_summary = analyse_portfolio_tax(holdings, user)
    flags = risk_flags(holdings, summary, user)
    flags.extend(deduction_opportunities(user))
    flags.sort(key=lambda f: f.severity.rank, reverse=True)
    health = overall_health(flags)
    return Snapshot(
        as_of=datetime.now().strftime("%d-%b-%Y %H:%M"),
        indices=indices, macro=macro, holdings=holdings, summary=summary,
        tax_results=tax_results, tax_summary=tax_summary, flags=flags,
        health=health)

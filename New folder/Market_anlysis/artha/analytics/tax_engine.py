"""CA-grade tax engine — FY 2025-26 rules (post Budget 2024).

Handles per-holding capital-gains classification, FD interest + TDS, SGB maturity
exemption, ELSS lock-in, and portfolio-level LTCG exemption bucketing. Also a
"wait N days to turn LTCG" optimiser that quantifies the rupee saving.

Nothing here is advice — it is deterministic computation of statutory rules.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from datetime import date, timedelta
from typing import Optional

from artha.config import TAX
from artha.models import AssetClass, Flag, Holding, Severity, UserProfile


@dataclass
class TaxResult:
    holding: Holding
    tax_type: str                 # STCG | LTCG | SLAB | TAX_FREE | LOSS
    gain: float
    taxable_gain: float
    tax_rate: float
    tax_payable: float
    days_to_ltcg: Optional[int] = None
    wait_saving: float = 0.0      # ₹ saved by waiting to LTCG (price held flat)
    note: str = ""


def _equity_cg(h: Holding, ltcg_exemption_left: float) -> TaxResult:
    gain = h.pnl
    if gain < 0:
        return TaxResult(h, "LOSS", gain, 0.0, 0.0, 0.0,
                         note="Capital loss — set off against other gains")
    if h.holding_days < TAX.EQUITY_LTCG_DAYS:
        # Short term — Sec 111A @ 20%
        tax = gain * TAX.STCG_EQUITY
        days_left = TAX.EQUITY_LTCG_DAYS - h.holding_days
        # Saving if the same gain were taxed as LTCG today (price held flat)
        ltcg_taxable = max(0.0, gain - ltcg_exemption_left)
        ltcg_tax = ltcg_taxable * TAX.LTCG_EQUITY
        saving = max(0.0, tax - ltcg_tax)
        return TaxResult(h, "STCG", gain, gain, TAX.STCG_EQUITY, round(tax, 0),
                         days_to_ltcg=days_left, wait_saving=round(saving, 0),
                         note=f"Hold {days_left} more days → LTCG (12.5%)")
    # Long term — Sec 112A @ 12.5% beyond ₹1.25L/yr aggregate exemption
    taxable = max(0.0, gain - ltcg_exemption_left)
    tax = taxable * TAX.LTCG_EQUITY
    return TaxResult(h, "LTCG", gain, taxable, TAX.LTCG_EQUITY, round(tax, 0),
                     note="LTCG — within ₹1.25L exemption pays ₹0")


def _slab_cg(h: Holding, slab: float) -> TaxResult:
    """Debt MF (post Apr-2023), international funds, FoF — always slab rate."""
    gain = h.pnl
    if gain <= 0:
        return TaxResult(h, "LOSS", gain, 0.0, 0.0, 0.0, note="Loss — set off")
    tax = gain * slab
    return TaxResult(h, "SLAB", gain, gain, slab, round(tax, 0),
                     note=f"Taxed at slab {slab*100:.0f}% (no indexation)")


def _sgb(h: Holding, slab: float) -> TaxResult:
    """SGB: capital gains at RBI 8-yr maturity are FULLY TAX-FREE."""
    gain = h.pnl
    if gain <= 0:
        return TaxResult(h, "LOSS", gain, 0.0, 0.0, 0.0, note="Loss")
    # If sold on exchange before maturity: LTCG 12.5% (>12m) else slab.
    if h.holding_days >= TAX.EQUITY_LTCG_DAYS:
        tax = gain * TAX.LTCG_EQUITY
        return TaxResult(h, "LTCG", gain, gain, TAX.LTCG_EQUITY, round(tax, 0),
                         wait_saving=round(tax, 0),
                         note="HOLD TO MATURITY → capital gain becomes ₹0 tax")
    tax = gain * slab
    return TaxResult(h, "SLAB", gain, gain, slab, round(tax, 0),
                     note="Held <1yr; maturity would be fully tax-free")


def compute_holding_tax(h: Holding, user: UserProfile,
                        ltcg_exemption_left: float) -> TaxResult:
    if h.asset_class in (AssetClass.EQUITY, AssetClass.EQUITY_MF, AssetClass.ELSS):
        return _equity_cg(h, ltcg_exemption_left)
    if h.asset_class in (AssetClass.DEBT_MF, AssetClass.BOND):
        return _slab_cg(h, user.slab_rate)
    if h.asset_class == AssetClass.SGB:
        return _sgb(h, user.slab_rate)
    if h.asset_class in (AssetClass.FD,):
        gain = h.pnl
        tax = max(0.0, gain) * user.slab_rate
        return TaxResult(h, "SLAB", gain, max(0.0, gain), user.slab_rate,
                         round(tax, 0), note="FD interest taxed at slab; TDS 10%")
    if h.asset_class in (AssetClass.PPF, AssetClass.NPS):
        return TaxResult(h, "TAX_FREE", h.pnl, 0.0, 0.0, 0.0,
                         note="EEE / exempt on maturity (within rules)")
    return TaxResult(h, "SLAB", h.pnl, max(0.0, h.pnl), user.slab_rate,
                     round(max(0.0, h.pnl) * user.slab_rate, 0))


def analyse_portfolio_tax(holdings: list[Holding],
                          user: UserProfile) -> tuple[list[TaxResult], dict]:
    """Compute tax per holding with a shared ₹1.25L equity-LTCG exemption bucket."""
    exemption_left = TAX.LTCG_EQUITY_EXEMPTION
    results: list[TaxResult] = []
    # Process LTCG-eligible equity first so the exemption is applied sensibly.
    order = sorted(holdings, key=lambda h: 0 if h.holding_days >= 365 else 1)
    for h in order:
        res = compute_holding_tax(h, user, exemption_left)
        if res.tax_type == "LTCG" and h.is_equity_like:
            used = min(exemption_left, max(0.0, res.gain))
            exemption_left = max(0.0, exemption_left - used)
        results.append(res)

    total_tax = sum(r.tax_payable for r in results)
    total_gain = sum(r.gain for r in results if r.gain > 0)
    total_loss = sum(r.gain for r in results if r.gain < 0)
    wait_savings = sum(r.wait_saving for r in results)
    cess = total_tax * TAX.CESS
    summary = {
        "total_realisable_gain": round(total_gain, 0),
        "total_loss_available": round(total_loss, 0),
        "total_tax_if_sold_today": round(total_tax, 0),
        "cess": round(cess, 0),
        "total_with_cess": round(total_tax + cess, 0),
        "ltcg_exemption_left": round(exemption_left, 0),
        "wait_optimisation_saving": round(wait_savings, 0),
        "itr_form": _itr_form(results),
        "schedule_112a_count": sum(
            1 for r in results if r.tax_type == "LTCG" and r.holding.is_equity_like),
    }
    return results, summary


def _itr_form(results: list[TaxResult]) -> str:
    has_cg = any(r.tax_type in ("STCG", "LTCG") for r in results)
    return "ITR-2 (capital gains present)" if has_cg else "ITR-1 (SAHAJ)"


# ---- Section 80C / 80CCD(1B) deduction coaching (the CA nudges) ----
def deduction_opportunities(user: UserProfile) -> list[Flag]:
    flags: list[Flag] = []
    c80 = 150_000 - user.sec_80c_used
    if c80 > 0:
        save = c80 * user.slab_rate
        flags.append(Flag(
            Severity.INFO, "80C headroom unused",
            f"₹{c80:,.0f} of 80C limit free — ELSS/PPF/EPF can save "
            f"≈₹{save:,.0f} tax.", category="tax", saving=save))
    nps = 50_000 - user.sec_80ccd1b_used
    if nps > 0:
        save = nps * user.slab_rate
        flags.append(Flag(
            Severity.INFO, "80CCD(1B) NPS unused",
            f"Invest ₹{nps:,.0f} in NPS for an EXTRA deduction (over 80C) → "
            f"save ≈₹{save:,.0f}.", category="tax", saving=save))
    return flags

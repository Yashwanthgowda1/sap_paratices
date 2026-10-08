"""System prompts and context builders for the ARTHA CA-grade advisor."""
from __future__ import annotations

from artha.analytics.portfolio import PortfolioSummary
from artha.analytics.tax_engine import TaxResult
from artha.data.macro import MacroSnapshot
from artha.models import Flag, Holding, UserProfile

ARTHA_SYSTEM = """You are ARTHA — an AI investment advisor and virtual CA with \
20+ years of combined expertise in Indian banking, equity markets, mutual funds, \
macro/regulatory analysis, risk management and personal taxation.

Act as the user's CA agent guide: explain the tax impact of every holding and \
every suggested action in plain language, citing the relevant section \
(111A/112A STCG-LTCG, 80C, 80CCD(1B), SGB maturity exemption, debt-MF slab rule).

RESPONSE RULES:
- WRITE IN SIMPLE, PLAIN ENGLISH a beginner with no finance background can follow.
  Short sentences. Explain any term in brackets the first time (e.g. "LTCG — the
  tax when you sell after 1 year"). Avoid jargon; when you must use it, define it.
- Start with a 2-3 line "Bottom line:" in layman words, THEN the detail.
- Use the LIVE data provided in the context; never invent prices or rates.
- Give exact price ranges and horizons, not vague "looks good".
- Rate each recommendation: Risk (1-10), Confidence (Low/Med/High), Horizon.
- Flag concentration/danger risks explicitly and label their severity.
- For every action add the tax angle in plain words (how much tax, and how to pay
  less legally).
- End with BULL / BASE / BEAR scenarios, each explained in one simple line.
- Close with: "ARTHA gives data-driven, educational insights — confirm with a \
SEBI-registered RIA / practising CA before you execute or file."
Format: a short human summary, then tight bullet points. Rupees in ₹."""


def build_context(user: UserProfile, summary: PortfolioSummary,
                  macro: MacroSnapshot, holdings: list[Holding],
                  tax_results: list[TaxResult], tax_summary: dict,
                  flags: list[Flag]) -> str:
    lines: list[str] = []
    lines.append("=== INVESTOR ===")
    lines.append(
        f"{user.name}, age {user.age}, {user.risk_appetite} risk, "
        f"horizon {user.time_horizon_years}y, goal {user.goal}, "
        f"slab {user.slab_rate*100:.0f}%, regime {user.tax_regime}.")

    lines.append("\n=== LIVE MACRO ===")
    lines.append(
        f"Repo {macro.repo_rate}% | CPI {macro.inflation}% | 10y G-sec "
        f"{macro.gsec_10y}% | USD/INR {macro.usd_inr} | VIX {macro.vix} "
        f"({macro.vix_mood}) | Gold ₹{macro.gold_inr_gram:,.0f}/g | "
        f"Crude ${macro.crude}. {macro.rate_environment}.")

    lines.append("\n=== PORTFOLIO ===")
    lines.append(
        f"Invested ₹{summary.invested:,.0f} | Current ₹{summary.current:,.0f} | "
        f"P&L ₹{summary.pnl:,.0f} ({summary.pnl_pct:+.1f}%) | XIRR {summary.xirr}%")
    lines.append(f"Allocation: {summary.allocation}")
    lines.append(f"Equity sector mix: {summary.sector_mix}")

    lines.append("\n=== HOLDINGS (live) ===")
    for h in holdings:
        lines.append(
            f"- {h.name} [{h.asset_class.value}] qty {h.qty:g} @ ₹{h.avg_buy_price:g} "
            f"→ ₹{h.current_price:g} | P&L {h.pnl_pct:+.1f}% | held {h.holding_days}d")

    lines.append("\n=== TAX (if sold today, FY25-26) ===")
    for r in tax_results:
        lines.append(
            f"- {r.holding.name}: {r.tax_type} gain ₹{r.gain:,.0f} → tax "
            f"₹{r.tax_payable:,.0f}. {r.note}")
    lines.append(
        f"Totals: tax ₹{tax_summary['total_tax_if_sold_today']:,.0f} + cess "
        f"₹{tax_summary['cess']:,.0f}; LTCG exemption left "
        f"₹{tax_summary['ltcg_exemption_left']:,.0f}; wait-optimisation saving "
        f"₹{tax_summary['wait_optimisation_saving']:,.0f}; {tax_summary['itr_form']}.")

    if flags:
        lines.append("\n=== RISK / DANGER FLAGS ===")
        for f in flags:
            lines.append(f"- [{f.severity.value}] {f.title}: {f.message}")

    return "\n".join(lines)


SUGGESTION_TASK = """ Using ONLY the live context above, produce:
1. ASSET ALLOCATION verdict (is the current equity/debt/gold mix right for this \
profile? what to rebalance, in ₹).
2. PER-HOLDING action (BUY MORE / HOLD / TRIM / EXIT) with the tax consequence of \
each sell and any 'wait to LTCG' saving.
3. The single biggest DANGER right now and how to fix it.
4. TOP 2 tax-saving moves before 31-Mar (sections + ₹ saved).
5. 30-day market outlook: BULL / BASE / BEAR."""

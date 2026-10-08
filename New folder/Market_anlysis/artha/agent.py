"""ARTHA agent: a lightweight tool-routing orchestrator.

Given a plain-English question it decides which live tools to call —
Screener.in fundamentals, the deploy-₹X screener, portfolio/tax context — then
hands an enriched, fact-rich prompt to whichever LLM the user picked. The tool
trace is surfaced in the UI so the user sees what the agent actually fetched.
"""
from __future__ import annotations

import re
from dataclasses import dataclass, field

from artha.analytics.opportunity import screen
from artha.data.market_data import get_quote
from artha.data.screener import get_screener
from artha.llm import LLMError, get_provider
from artha.llm.prompts import ARTHA_SYSTEM, SUGGESTION_TASK, build_context
from artha.logger import get_logger
from artha.models import UserProfile

log = get_logger("artha.agent")


@dataclass
class AgentRun:
    tool_trace: list[str] = field(default_factory=list)
    extra_context: str = ""
    answer: str = ""
    error: str = ""


def _parse_amount(text: str) -> float | None:
    t = text.lower().replace(",", "")
    m = re.search(r"(?:₹|rs\.?\s*)?(\d+(?:\.\d+)?)\s*(k|thousand|l|lakh|lac|cr|crore)?",
                  t)
    if not m:
        return None
    num = float(m.group(1))
    unit = m.group(2) or ""
    if unit in ("k", "thousand"):
        num *= 1_000
    elif unit in ("l", "lakh", "lac"):
        num *= 100_000
    elif unit in ("cr", "crore"):
        num *= 10_000_000
    return num if num >= 500 else None


def _detect_symbols(text: str, holdings, watchlist: dict[str, str]) -> list[str]:
    """Match symbols the user actually tracks — their holdings + DB watchlist."""
    up = text.upper()
    known: dict[str, str] = {s.replace(".NS", ""): s for s in watchlist}
    for h in holdings:
        if h.symbol:
            known[h.symbol.replace(".NS", "")] = h.symbol
    found: list[str] = []
    for short, full in known.items():
        if short and short in up and full not in found:
            found.append(full)
    return found[:4]


def run_agent(question: str, snap, user: UserProfile, cfg: dict,
              watchlist: dict[str, str],
              extra_context: str = "") -> AgentRun:
    run = AgentRun()
    q = question.strip()
    base = build_context(user, snap.summary, snap.macro, snap.holdings,
                         snap.tax_results, snap.tax_summary, snap.flags)
    extra: list[str] = []

    # Tool 1: fundamentals for any symbol named in the question.
    for sym in _detect_symbols(q, snap.holdings, watchlist):
        run.tool_trace.append(f"📑 Screener.in → fundamentals for {sym}")
        sd = get_screener(sym)
        quote = get_quote(sym)
        if sd.ok and sd.ratios:
            picks = {k: sd.ratios[k] for k in list(sd.ratios)[:10]}
            extra.append(f"[Screener {sym}] live ₹{quote.price or sd.current_price} | "
                         + ", ".join(f"{k}={v}" for k, v in picks.items()))
            if sd.pros:
                extra.append(f"[Screener {sym} PROS] " + " | ".join(sd.pros[:4]))
            if sd.cons:
                extra.append(f"[Screener {sym} CONS] " + " | ".join(sd.cons[:4]))
        else:
            extra.append(f"[Screener {sym}] unavailable; live price ₹{quote.price}")

    # Tool 2: deploy-amount screener if the user mentions an investable sum.
    amount = _parse_amount(q)
    if amount:
        run.tool_trace.append(f"🎯 Deploy screener → rating your watchlist for ₹{amount:,.0f}")
        opps, plan = screen(amount, watchlist)
        extra.append(f"[Deploy ₹{amount:,.0f}] mode: {plan['deploy_mode']}; "
                     f"GOOD={plan['good_count']} AVOID={plan['avoid_count']}")
        for o in opps[:6]:
            extra.append(
                f"  - {o.name} [{o.sector}] ₹{o.price} {o.verdict} "
                f"(RSI {o.rsi}, {o.pct_off_high}% off high): {'; '.join(o.reasons[:2])}"
                + (f" → put ₹{o.suggested_amount:,.0f}" if o.suggested_amount else ""))

    run.extra_context = "\n".join(extra)
    task = q or SUGGESTION_TASK
    user_msg = base
    if run.extra_context:
        user_msg += "\n\n=== AGENT TOOL RESULTS (live) ===\n" + run.extra_context
    if extra_context:
        user_msg += "\n\n" + extra_context
    user_msg += f"\n\n=== TASK ===\n{task}"

    try:
        provider = get_provider(cfg["provider"], cfg["api_key"], cfg["model"])
    except LLMError as exc:
        run.error = str(exc)
        return run
    try:
        run.answer = provider.generate(ARTHA_SYSTEM, user_msg)
    except LLMError as exc:
        run.error = str(exc)
    return run

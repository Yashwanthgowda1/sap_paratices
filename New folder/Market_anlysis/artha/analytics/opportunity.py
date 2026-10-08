"""Deploy-₹X screener: rate stocks AND mutual funds GOOD/NEUTRAL/AVOID on live
data, then show the *impact of investing today*.

Two universes are screened, not just your own holdings:
  • Market stocks  — Nifty 500-level liquid NSE stock set (artha.data.universe)
    plus whatever is on your watchlist. Live price + technicals (50/200 DMA, RSI,
    % off 52-week high, trailing-12m trend) combined with fundamentals from
    Screener.in (ROE, ROCE, P/E, dividend yield).
  • Mutual funds   — curated set of Direct-Growth schemes. Live NAV + rolling
    1y/3y/5y CAGR from AMFI history (mfapi.in).

For a given amount we score every instrument, pick the GOOD ones, allocate the
money across them by score, and project a 1-year outcome. Projections are
clearly-labelled scenarios ("if the trend holds") — never guarantees.

Each stock also carries a hold_signal (BUY NOW / ACCUMULATE / WATCH / AVOID)
and a wait_period string (plain-English timing advice including LTCG guidance).
"""
from __future__ import annotations

import time
from dataclasses import dataclass, field

from artha.data.macro import get_macro
from artha.data.market_data import get_history, get_quote
from artha.data.mutual_funds import get_nav, rolling_cagr
from artha.logger import get_logger
from artha.models import Severity

log = get_logger("artha.opportunity")

# Cache screener calls separately from the module-level cache in screener.py
# so we don't hammer Screener.in during a full 139-stock screen.
_SCREENER_CACHE: dict[str, tuple[float, object]] = {}
_SCREENER_TTL = 1800.0   # 30 min — fundamentals barely move intraday


def _clamp(x: float, lo: float, hi: float) -> float:
    return max(lo, min(hi, x))


def _to_num(text: str) -> float:
    """Convert Screener.in ratio text like '22.5 %' or '₹ 1,234' to float."""
    try:
        cleaned = (str(text)
                   .replace(",", "").replace("₹", "").replace("%", "")
                   .replace("Cr.", "").strip().split()[0])
        return float(cleaned)
    except (ValueError, AttributeError, IndexError):
        return 0.0


# =========================== STOCKS =======================================
@dataclass
class Opportunity:
    symbol: str
    name: str
    sector: str
    price: float
    pct_off_high: float
    rsi: float
    pe: float | None
    trend_up: bool
    golden_cross: bool
    score: float
    verdict: str                   # GOOD | NEUTRAL | AVOID
    severity: Severity
    reasons: list[str] = field(default_factory=list)
    suggested_amount: float = 0.0
    kind: str = "stock"
    # ---- impact-if-invested-today ----
    trend_1y: float = 0.0          # factual trailing-12m price return %
    proj_1y_pct: float = 0.0       # scenario expected 1y return % (labelled)
    proj_1y_value: float = 0.0     # suggested_amount grown by proj_1y_pct
    # ---- fundamentals (from Screener.in) ----
    roe: float | None = None       # Return on Equity %
    roce: float | None = None      # Return on Capital Employed %
    div_yield: float | None = None # Dividend yield %
    # ---- timing guidance ----
    hold_signal: str = ""          # e.g. "🟢 BUY NOW", "🟡 WAIT FOR DIP", "🔴 AVOID"
    wait_period: str = ""          # plain-English timing/hold advice


def _rsi(closes: list[float], period: int = 14) -> float:
    if len(closes) <= period:
        return 50.0
    gains, losses = [], []
    for i in range(1, len(closes)):
        d = closes[i] - closes[i - 1]
        gains.append(max(d, 0))
        losses.append(max(-d, 0))
    avg_gain = sum(gains[-period:]) / period
    avg_loss = sum(losses[-period:]) / period
    if avg_loss == 0:
        return 100.0
    rs = avg_gain / avg_loss
    return round(100 - (100 / (1 + rs)), 1)


def _sma(closes: list[float], n: int) -> float:
    tail = [c for c in closes[-n:] if c]
    return sum(tail) / len(tail) if tail else 0.0


def _get_screener_cached(sym_bare: str):
    """Fetch Screener.in fundamentals; extra TTL layer on top of screener.py cache."""
    hit = _SCREENER_CACHE.get(sym_bare)
    if hit and (time.time() - hit[0]) < _SCREENER_TTL:
        return hit[1]
    from artha.data.screener import get_screener
    sd = get_screener(sym_bare)
    _SCREENER_CACHE[sym_bare] = (time.time(), sd)
    return sd


def _hold_signal(verdict: str, score: float, rsi: float, pct_off_high: float) -> str:
    if verdict == "AVOID":
        return "🔴 AVOID"
    if rsi > 72 or pct_off_high < 4:
        return "🟡 WAIT FOR DIP"
    if verdict == "GOOD" and score >= 2.5:
        return "🟢 BUY NOW"
    if verdict == "GOOD":
        return "🟢 ACCUMULATE"
    return "🟡 WATCH"


def _wait_period(verdict: str, rsi: float, pct_off_high: float,
                 score: float, trend_1y: float) -> str:
    if verdict == "AVOID":
        return ("Avoid entry now — price below 200-DMA or overbought. "
                "Wait for trend reversal before investing.")
    if rsi > 72:
        return (f"RSI {rsi:.0f} — overbought. Wait 2-4 weeks for RSI to cool "
                f"below 65 for a safer entry.")
    if pct_off_high < 4:
        return ("Near 52-week high — limited margin of safety. "
                "Wait for an 8-12% correction for better entry.")

    ltcg_note = ("Hold ≥ 1 year to qualify for LTCG (12.5% tax vs 20% STCG). "
                 "Optimal hold: 18-24 months for full trend to play out.")

    if verdict == "GOOD":
        if trend_1y < -20:
            return (f"Down {trend_1y:.0f}% over 12m but strong fundamentals — "
                    f"classic value entry. Enter in 2-3 tranches over 4-6 weeks. "
                    f"{ltcg_note}")
        if trend_1y > 20:
            return (f"Strong uptrend (+{trend_1y:.0f}% in 12m). Good momentum entry. "
                    f"{ltcg_note}")
        return f"Good setup. {ltcg_note}"

    return ("Neutral setup. Accumulate in small SIP lots on 5-10% dips. "
            "Review in 3 months — switch to lumpsum if trend confirms.")


def _score_one(symbol: str, name: str, sector: str) -> "Opportunity | None":
    closes = get_history(symbol, "1y")
    if len(closes) < 20:
        return None
    try:
        price  = closes[-1]
        high52 = max(closes)
        dma50  = _sma(closes, 50)
        dma200 = _sma(closes, 200) if len(closes) >= 200 else dma50
        rsi    = _rsi(closes)
        pct_off_high = round((high52 - price) / high52 * 100, 1) if high52 else 0.0
        trend_up = price >= dma200
        golden   = dma50 >= dma200
        first    = next((c for c in closes if c), price)
        trend_1y = round((price / first - 1) * 100, 1) if first else 0.0

        score: float = 0.0
        reasons: list[str] = []
        pe_val: float | None = None
        roe_val: float | None = None
        roce_val: float | None = None
        div_val: float | None = None

        # ---- Technical signals ----
        if trend_up:
            score += 1.0; reasons.append("Above 200-DMA (uptrend)")
        else:
            score -= 1.0; reasons.append("Below 200-DMA (downtrend)")
        if golden:
            score += 0.5; reasons.append("Golden-cross zone")
        if rsi < 30:
            score += 1.0; reasons.append(f"RSI {rsi} — oversold, attractive entry")
        elif rsi > 70:
            score -= 1.0; reasons.append(f"RSI {rsi} — overbought, wait for dip")
        else:
            reasons.append(f"RSI {rsi}")
        if pct_off_high >= 15:
            score += 1.0; reasons.append(f"{pct_off_high}% below 52w high")
        elif pct_off_high <= 3:
            score -= 0.5; reasons.append("Near 52w high — limited upside buffer")

        # ---- Fundamental signals (Screener.in, best-effort) ----
        try:
            sym_bare = symbol.replace(".NS", "").replace(".BO", "").upper()
            sd = _get_screener_cached(sym_bare)
            if sd and sd.ok:
                roe_raw  = _to_num(sd.ratio("ROE"))
                roce_raw = _to_num(sd.ratio("ROCE"))
                pe_raw   = _to_num(sd.ratio("Stock P/E"))
                div_raw  = _to_num(sd.ratio("Dividend Yield"))

                if roe_raw > 0:
                    roe_val = round(roe_raw, 1)
                    if roe_raw >= 25:
                        score += 1.0; reasons.append(f"ROE {roe_val}% — excellent")
                    elif roe_raw >= 15:
                        score += 0.5; reasons.append(f"ROE {roe_val}% — strong")
                    elif roe_raw >= 8:
                        reasons.append(f"ROE {roe_val}%")
                    else:
                        score -= 0.3; reasons.append(f"ROE {roe_val}% — weak")

                if roce_raw > 0:
                    roce_val = round(roce_raw, 1)
                    if roce_raw >= 25:
                        score += 1.0; reasons.append(f"ROCE {roce_val}% — capital-efficient")
                    elif roce_raw >= 15:
                        score += 0.5; reasons.append(f"ROCE {roce_val}%")
                    elif roce_raw >= 8:
                        reasons.append(f"ROCE {roce_val}%")
                    else:
                        score -= 0.3; reasons.append(f"ROCE {roce_val}% — low")

                if pe_raw > 0:
                    pe_val = round(pe_raw, 1)
                    if pe_raw < 12:
                        score += 0.5; reasons.append(f"P/E {pe_val} — deep value")
                    elif pe_raw < 20:
                        score += 0.3; reasons.append(f"P/E {pe_val} — fair value")
                    elif pe_raw > 60:
                        score -= 1.0; reasons.append(f"P/E {pe_val} — very expensive")
                    elif pe_raw > 40:
                        score -= 0.5; reasons.append(f"P/E {pe_val} — premium valuation")
                    else:
                        reasons.append(f"P/E {pe_val}")

                if div_raw > 0:
                    div_val = round(div_raw, 2)
                    if div_raw >= 2.0:
                        score += 0.3; reasons.append(f"Div yield {div_val}% — pays income")
        except Exception as exc:
            log.debug("Screener fundamentals skipped for %s: %s", symbol, exc)

        # ---- Verdict ----
        if score >= 2.0:
            verdict, sev = "GOOD", Severity.SAFE
        elif score >= 0:
            verdict, sev = "NEUTRAL", Severity.WARNING
        else:
            verdict, sev = "AVOID", Severity.DANGER

        # ---- 1y projection scenario (trend-weighted + recovery room) ----
        proj = (0.6 * _clamp(trend_1y, -20, 30)
                + 0.4 * _clamp(pct_off_high, 0, 20))
        proj_1y_pct = round(_clamp(proj, -12, 32), 1)

        # ---- Timing guidance ----
        hs = _hold_signal(verdict, score, rsi, pct_off_high)
        wp = _wait_period(verdict, rsi, pct_off_high, score, trend_1y)

        return Opportunity(
            symbol=symbol, name=name, sector=sector,
            price=round(price, 2), pct_off_high=pct_off_high,
            rsi=rsi, pe=pe_val, trend_up=trend_up, golden_cross=golden,
            score=round(score, 2), verdict=verdict, severity=sev, reasons=reasons,
            trend_1y=trend_1y, proj_1y_pct=proj_1y_pct,
            roe=roe_val, roce=roce_val, div_yield=div_val,
            hold_signal=hs, wait_period=wp)
    except Exception as exc:
        log.warning("screen failed for %s: %s", symbol, exc)
        return None


# =========================== MUTUAL FUNDS =================================
@dataclass
class FundOpportunity:
    scheme_code: str
    name: str
    category: str
    nav: float
    cagr_1y: float | None
    cagr_3y: float | None
    cagr_5y: float | None
    score: float
    verdict: str
    severity: Severity
    reasons: list[str] = field(default_factory=list)
    suggested_amount: float = 0.0
    kind: str = "fund"
    proj_1y_pct: float = 0.0
    proj_1y_value: float = 0.0
    # ---- timing guidance ----
    hold_signal: str = ""
    wait_period: str = ""


def _score_fund(scheme_code: str, category: str) -> FundOpportunity | None:
    fund = get_nav(scheme_code, with_history=True)
    if not fund or not fund.nav:
        return None
    try:
        c1 = rolling_cagr(fund.history, 1)
        c3 = rolling_cagr(fund.history, 3)
        c5 = rolling_cagr(fund.history, 5)
        reasons: list[str] = []
        score = 0.0

        # Long-run compounding is the main signal for funds.
        anchor = c3 if c3 is not None else c1
        if anchor is not None:
            if anchor >= 18:
                score += 1.5; reasons.append(f"3Y CAGR {anchor}% — strong compounder")
            elif anchor >= 12:
                score += 1.0; reasons.append(f"3Y CAGR {anchor}% — solid")
            elif anchor >= 8:
                score += 0.3; reasons.append(f"3Y CAGR {anchor}% — moderate")
            else:
                score -= 0.5; reasons.append(f"3Y CAGR {anchor}% — lagging")
        if c5 is not None and c5 >= 15:
            score += 0.5; reasons.append(f"5Y CAGR {c5}% — durable track record")
        if c1 is not None:
            if c1 >= 20:
                score += 0.5; reasons.append(f"1Y {c1}% — strong recent momentum")
            elif c1 >= 12:
                score += 0.3; reasons.append(f"1Y {c1}% — good momentum")
            elif c1 < 0:
                score -= 0.5; reasons.append(f"1Y {c1}% — down recently")

        if score >= 1.5:
            verdict, sev = "GOOD", Severity.SAFE
        elif score >= 0.3:
            verdict, sev = "NEUTRAL", Severity.WARNING
        else:
            verdict, sev = "AVOID", Severity.DANGER

        # 3Y CAGR is a steadier 1y expectation than last-12m noise.
        base = anchor if anchor is not None else (c1 or 0.0)
        proj_1y_pct = round(_clamp(base, -5, 25), 1)

        # Fund timing guidance
        if verdict == "GOOD":
            hs = "🟢 SIP / INVEST"
            wp = (f"Good long-term compounder. Start SIP now and continue 3-5 years. "
                  f"Lumpsum also fine if VIX < 16. "
                  f"3Y CAGR: {c3}% | 1Y: {c1}%")
        elif verdict == "NEUTRAL":
            hs = "🟡 SIP ONLY"
            wp = ("Average performer. Prefer SIP over lumpsum; review in 6 months. "
                  "Consider switching to a higher-CAGR fund in same category.")
        else:
            hs = "🔴 AVOID"
            wp = "Poor recent returns. Avoid new investment; existing units: review exit."

        return FundOpportunity(
            scheme_code=str(scheme_code), name=fund.scheme_name, category=category,
            nav=round(fund.nav, 2), cagr_1y=c1, cagr_3y=c3, cagr_5y=c5,
            score=round(score, 2), verdict=verdict, severity=sev, reasons=reasons,
            proj_1y_pct=proj_1y_pct,
            hold_signal=hs, wait_period=wp)
    except Exception as exc:
        log.warning("fund screen failed for %s: %s", scheme_code, exc)
        return None


# =========================== ORCHESTRATION ================================
def screen(amount: float,
           watchlist: dict[str, str]) -> tuple[list[Opportunity], dict]:
    """Legacy watchlist-only screen (used by the AI agent tool). Unchanged API."""
    if not watchlist:
        return [], {"amount": amount, "deploy_mode": "Add stocks to your watchlist "
                    "first (Holdings tab) — nothing to screen.", "vix": 0,
                    "good_count": 0, "avoid_count": 0}
    results = [o for o in (
        _score_one(s, s.replace(".NS", "").replace(".BO", ""), sec)
        for s, sec in watchlist.items()) if o]
    results.sort(key=lambda o: o.score, reverse=True)
    goods = [o for o in results if o.verdict == "GOOD"]
    if goods:
        total = sum(o.score for o in goods)
        for o in goods:
            o.suggested_amount = round(amount * o.score / total, 0)
    macro = get_macro()
    plan = {
        "amount": amount, "deploy_mode": _deploy_mode(amount, macro.vix),
        "vix": macro.vix, "good_count": len(goods),
        "avoid_count": sum(1 for o in results if o.verdict == "AVOID"),
    }
    return results, plan


def _deploy_mode(amount: float, vix: float) -> str:
    if vix and vix > 20:
        return "Stagger / SIP — India VIX high, market nervous"
    if amount < 50_000:
        return "SIP — amount under ₹50k; rupee-cost average monthly"
    return "Lumpsum in 2-3 tranches over 4-6 weeks"


def screen_all(amount: float,
               watchlist: dict[str, str] | None = None,
               include_market: bool = True,
               include_funds: bool = True,
               max_stocks: int = 150,
               max_funds: int = 50) -> dict:
    """Screen the market stock universe + mutual funds (+ your watchlist), score
    everything using technicals AND fundamentals (ROE/ROCE/P/E from Screener.in),
    allocate `amount` across the GOOD picks, and project a 1-year outcome.
    Returns a dict the Deploy panel + AI agent both consume.
    """
    from artha.data.universe import MARKET_FUNDS, MARKET_STOCKS

    # ---- stock set: market universe ∪ your watchlist ----
    # Values: (display_name, sector)
    stock_src: dict[str, tuple[str, str]] = {}
    if include_market:
        for sym, name, sector in MARKET_STOCKS[:max_stocks]:
            stock_src[sym] = (name, sector)
    for sym, sec in (watchlist or {}).items():
        if sym not in stock_src:
            fallback_name = sym.replace(".NS", "").replace(".BO", "")
            stock_src[sym] = (fallback_name, sec)

    stock_opps = [o for o in (
        _score_one(s, nm, sec) for s, (nm, sec) in stock_src.items()) if o]
    stock_opps.sort(key=lambda o: o.score, reverse=True)

    # ---- funds ----
    fund_opps: list[FundOpportunity] = []
    if include_funds:
        for code, _name, cat in MARKET_FUNDS[:max_funds]:
            fo = _score_fund(code, cat)
            if fo:
                fund_opps.append(fo)
        fund_opps.sort(key=lambda f: f.score, reverse=True)

    # ---- allocate across GOOD picks (stocks 60% of budget, funds 40%) ----
    good_stocks = [o for o in stock_opps if o.verdict == "GOOD"]
    good_funds  = [f for f in fund_opps  if f.verdict == "GOOD"]

    stock_budget = amount * 0.60 if (good_stocks and good_funds) else (
        amount if good_stocks else 0.0)
    fund_budget  = amount - stock_budget if good_stocks else (
        amount if good_funds else 0.0)

    projected_value = 0.0
    if good_stocks:
        total_s = sum(o.score for o in good_stocks)
        for o in good_stocks:
            o.suggested_amount = round(stock_budget * o.score / total_s, 0)
            o.proj_1y_value = round(o.suggested_amount * (1 + o.proj_1y_pct / 100), 0)
            projected_value += o.proj_1y_value
    if good_funds:
        total_f = sum(f.score for f in good_funds)
        for f in good_funds:
            f.suggested_amount = round(fund_budget * f.score / total_f, 0)
            f.proj_1y_value = round(f.suggested_amount * (1 + f.proj_1y_pct / 100), 0)
            projected_value += f.proj_1y_value

    macro = get_macro()
    deployed = (sum(o.suggested_amount for o in good_stocks)
                + sum(f.suggested_amount for f in good_funds))
    proj_gain = projected_value - deployed if (good_stocks or good_funds) else 0.0
    proj_pct  = round(proj_gain / deployed * 100, 1) if deployed else 0.0

    highlights = _highlights(amount, deployed, projected_value, proj_gain, proj_pct,
                             good_stocks, good_funds, stock_opps, fund_opps)

    plan = {
        "amount": amount,
        "deploy_mode": _deploy_mode(amount, macro.vix),
        "vix": macro.vix,
        "good_count": len(good_stocks) + len(good_funds),
        "avoid_count": (sum(1 for o in stock_opps if o.verdict == "AVOID")
                        + sum(1 for f in fund_opps if f.verdict == "AVOID")),
        "stocks_screened": len(stock_opps),
        "funds_screened": len(fund_opps),
        "projected_value": round(projected_value, 0),
        "projected_gain": round(proj_gain, 0),
        "projected_pct": proj_pct,
        "highlights": highlights,
    }
    return {"stocks": stock_opps, "funds": fund_opps, "plan": plan}


def _highlights(amount, deployed, proj_value, proj_gain, proj_pct,
                good_stocks, good_funds, stock_opps, fund_opps) -> list[str]:
    h: list[str] = []
    if deployed:
        h.append(f"Deploy ₹{deployed:,.0f} across {len(good_stocks)+len(good_funds)} "
                 f"GOOD picks → ~₹{proj_value:,.0f} projected in 1 year "
                 f"(+₹{proj_gain:,.0f}, {proj_pct:+.1f}%) if trends hold.")
    else:
        h.append("No GOOD picks right now — market stretched; consider waiting / SIP.")

    mom = max((o for o in stock_opps), key=lambda o: o.trend_1y, default=None)
    if mom and mom.trend_1y > 0:
        h.append(f"Top momentum: {mom.name} +{mom.trend_1y:.0f}% over last 12 months "
                 f"— {mom.hold_signal}.")

    # Best ROE stock among GOOD picks
    best_roe = max(
        (o for o in good_stocks if o.roe is not None),
        key=lambda o: o.roe or 0, default=None)
    if best_roe:
        h.append(f"Best return on equity: {best_roe.name} — ROE {best_roe.roe}%, "
                 f"ROCE {best_roe.roce}%, P/E {best_roe.pe}.")

    topf = max((f for f in fund_opps if f.cagr_3y is not None),
               key=lambda f: f.cagr_3y, default=None)
    if topf:
        h.append(f"Top fund: {topf.name} — 3Y CAGR {topf.cagr_3y}% ({topf.category}).")
    return h

"""Portfolio analytics: allocation, XIRR, and the risk/danger severity engine."""
from __future__ import annotations

from collections import defaultdict
from dataclasses import dataclass
from datetime import date

from artha.models import AssetClass, Flag, Holding, Severity, UserProfile

# Equity-weight guidance by risk profile (floor, ceiling) in %.
_EQUITY_BAND = {
    "conservative": (20, 40),
    "moderate": (45, 70),
    "aggressive": (65, 90),
}
_CONCENTRATION_WARN = 20.0
_CONCENTRATION_DANGER = 25.0
_SECTOR_WARN = 30.0
_SECTOR_DANGER = 40.0


@dataclass
class PortfolioSummary:
    invested: float
    current: float
    pnl: float
    pnl_pct: float
    xirr: float
    allocation: dict[str, float]        # asset class -> % of current value
    sector_mix: dict[str, float]        # sector -> % of equity-like value


def _xirr(cashflows: list[tuple[date, float]], guess: float = 0.15) -> float:
    """Newton-Raphson XIRR. Outflows negative, final inflow positive."""
    if len(cashflows) < 2:
        return 0.0
    t0 = cashflows[0][0]
    times = [(d - t0).days / 365.0 for d, _ in cashflows]
    amounts = [a for _, a in cashflows]

    def npv(rate: float) -> float:
        return sum(a / (1 + rate) ** t for a, t in zip(amounts, times))

    def dnpv(rate: float) -> float:
        return sum(-t * a / (1 + rate) ** (t + 1) for a, t in zip(amounts, times))

    rate = guess
    for _ in range(100):
        f = npv(rate)
        df = dnpv(rate)
        if abs(df) < 1e-9:
            break
        new = rate - f / df
        if abs(new - rate) < 1e-6:
            return round(new * 100, 2)
        rate = max(new, -0.9999)
    return round(rate * 100, 2)


def summarise(holdings: list[Holding]) -> PortfolioSummary:
    invested = sum(h.invested_value for h in holdings)
    current = sum(h.current_value for h in holdings)
    pnl = current - invested

    alloc_raw: dict[str, float] = defaultdict(float)
    for h in holdings:
        alloc_raw[h.asset_class.value] += h.current_value
    allocation = {k: round(v / current * 100, 1) for k, v in alloc_raw.items()} \
        if current else {}

    sector_raw: dict[str, float] = defaultdict(float)
    equity_total = sum(h.current_value for h in holdings if h.is_equity_like)
    for h in holdings:
        if h.is_equity_like:
            sector_raw[h.sector] += h.current_value
    sector_mix = {k: round(v / equity_total * 100, 1)
                  for k, v in sector_raw.items()} if equity_total else {}

    cashflows = [(h.buy_date, -h.invested_value) for h in holdings]
    cashflows.sort(key=lambda x: x[0])
    cashflows.append((date.today(), current))
    xirr = _xirr(cashflows)

    return PortfolioSummary(
        invested=round(invested, 0), current=round(current, 0),
        pnl=round(pnl, 0),
        pnl_pct=round(pnl / invested * 100, 2) if invested else 0.0,
        xirr=xirr, allocation=allocation, sector_mix=sector_mix)


def risk_flags(holdings: list[Holding], summary: PortfolioSummary,
               user: UserProfile) -> list[Flag]:
    """Generate danger/severity findings for the UI 'Risk & Alerts' panel."""
    flags: list[Flag] = []
    current = summary.current or 1.0

    # 1. Single-holding concentration
    for h in holdings:
        pct = h.current_value / current * 100
        if pct >= _CONCENTRATION_DANGER:
            flags.append(Flag(
                Severity.DANGER, f"{h.name}: {pct:.0f}% of portfolio",
                f"Single-stock concentration above {_CONCENTRATION_DANGER:.0f}%. "
                "A shock here hits the whole portfolio — trim toward 15-20%.",
                category="concentration"))
        elif pct >= _CONCENTRATION_WARN:
            flags.append(Flag(
                Severity.WARNING, f"{h.name}: {pct:.0f}% of portfolio",
                f"Above {_CONCENTRATION_WARN:.0f}% in one name — watch position size.",
                category="concentration"))

    # 2. Sector concentration
    for sector, pct in summary.sector_mix.items():
        if pct >= _SECTOR_DANGER:
            flags.append(Flag(
                Severity.DANGER, f"{sector} sector: {pct:.0f}% of equity",
                f"Sector bet above {_SECTOR_DANGER:.0f}% — diversify across sectors.",
                category="concentration"))
        elif pct >= _SECTOR_WARN:
            flags.append(Flag(
                Severity.WARNING, f"{sector} sector: {pct:.0f}% of equity",
                f"Sector weight above {_SECTOR_WARN:.0f}% — monitor rotation risk.",
                category="concentration"))

    # 3. Equity allocation vs declared risk appetite
    equity_pct = sum(v for k, v in summary.allocation.items()
                     if k in ("equity", "equity_mf", "elss"))
    lo, hi = _EQUITY_BAND.get(user.risk_appetite, (45, 70))
    if equity_pct > hi:
        flags.append(Flag(
            Severity.WARNING, f"Equity {equity_pct:.0f}% > {hi}% band",
            f"Overweight equity for a {user.risk_appetite} profile "
            f"({lo}-{hi}% suggested). Rebalance into debt/gold.", category="risk"))
    elif equity_pct < lo:
        flags.append(Flag(
            Severity.INFO, f"Equity {equity_pct:.0f}% < {lo}% band",
            f"Underweight equity vs a {user.risk_appetite} horizon — "
            "returns may lag inflation.", category="risk"))

    # 4. Deep drawdown positions
    for h in holdings:
        if h.pnl_pct <= -20:
            flags.append(Flag(
                Severity.DANGER, f"{h.name}: {h.pnl_pct:.0f}% unrealised loss",
                "Review the thesis — is this a temporary dip or broken fundamentals? "
                "Consider tax-loss harvesting before 31-Mar.", category="risk"))

    # 5. Emergency diversification check
    if len(holdings) < 3:
        flags.append(Flag(
            Severity.WARNING, "Thin diversification",
            "Fewer than 3 holdings — idiosyncratic risk is high.", category="risk"))

    flags.sort(key=lambda f: f.severity.rank, reverse=True)
    return flags


def overall_health(flags: list[Flag]) -> tuple[Severity, str]:
    """Headline portfolio health badge from the worst active flag."""
    if any(f.severity == Severity.DANGER for f in flags):
        return Severity.DANGER, "Action needed — danger flags present"
    if any(f.severity == Severity.WARNING for f in flags):
        return Severity.WARNING, "Caution — review warnings"
    return Severity.SAFE, "Healthy — no major risk flags"

"""Day-to-day expense tracker: savings rate, 50/30/20 check, surplus to invest."""
from __future__ import annotations

from dataclasses import dataclass, field

from artha.models import Flag, Severity

# Canonical 50/30/20 budgeting rule (needs / wants / savings).
_NEEDS = {"rent", "emi", "groceries", "utilities", "transport", "insurance",
          "healthcare", "education"}
_WANTS = {"dining", "shopping", "entertainment", "travel", "subscriptions",
          "misc"}


@dataclass
class ExpenseReport:
    income: float
    total_expense: float
    needs: float
    wants: float
    savings: float
    savings_rate: float             # % of income saved
    needs_pct: float
    wants_pct: float
    investable_surplus: float       # what's free to invest this month
    by_category: dict[str, float]
    flags: list[Flag] = field(default_factory=list)


def analyse_expenses(income: float,
                     expenses: dict[str, float],
                     current_sip: float = 0.0,
                     emergency_fund: float = 0.0) -> ExpenseReport:
    total = sum(max(0.0, v) for v in expenses.values())
    needs = sum(v for k, v in expenses.items() if k.lower() in _NEEDS)
    wants = sum(v for k, v in expenses.items() if k.lower() in _WANTS)
    savings = income - total
    sr = (savings / income * 100.0) if income else 0.0
    needs_pct = (needs / income * 100.0) if income else 0.0
    wants_pct = (wants / income * 100.0) if income else 0.0
    surplus = max(0.0, savings - current_sip)

    flags: list[Flag] = []
    if sr < 0:
        flags.append(Flag(Severity.DANGER, "Spending exceeds income",
                          f"You overspent ₹{-savings:,.0f} this month. Cut 'wants' "
                          "before investing anything.", category="expense"))
    elif sr < 20:
        flags.append(Flag(Severity.WARNING, f"Low savings rate {sr:.0f}%",
                          "Target at least 20% (50/30/20 rule). Trim discretionary "
                          "spend to free up SIP capacity.", category="expense"))
    else:
        flags.append(Flag(Severity.SAFE, f"Healthy savings rate {sr:.0f}%",
                          "At or above the 20% benchmark — good discipline.",
                          category="expense"))

    if wants_pct > 30:
        flags.append(Flag(Severity.WARNING, f"'Wants' at {wants_pct:.0f}% of income",
                          "Above the 30% guideline — dining/shopping/travel is heavy.",
                          category="expense"))
    if needs_pct > 50:
        flags.append(Flag(Severity.WARNING, f"'Needs' at {needs_pct:.0f}% of income",
                          "Fixed costs above 50% — little room to invest; review "
                          "rent/EMI load.", category="expense"))

    # Emergency fund: aim 6 months of expenses.
    months_covered = (emergency_fund / total) if total else 0.0
    if emergency_fund and months_covered < 6:
        flags.append(Flag(Severity.WARNING,
                          f"Emergency fund covers {months_covered:.1f} months",
                          "Build to 6 months of expenses before raising equity risk.",
                          category="expense"))

    return ExpenseReport(
        income=round(income, 0), total_expense=round(total, 0),
        needs=round(needs, 0), wants=round(wants, 0), savings=round(savings, 0),
        savings_rate=round(sr, 1), needs_pct=round(needs_pct, 1),
        wants_pct=round(wants_pct, 1), investable_surplus=round(surplus, 0),
        by_category=dict(expenses), flags=flags)

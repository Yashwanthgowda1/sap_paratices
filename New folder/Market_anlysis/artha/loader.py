"""Load/parse portfolio holdings from a JSON file into Holding objects."""
from __future__ import annotations

import json
from datetime import date, datetime
from pathlib import Path

from artha.models import AssetClass, Holding, UserProfile


def _parse_date(value: str | None) -> date | None:
    if not value:
        return None
    return datetime.strptime(value, "%Y-%m-%d").date()


def load_holdings(path: str | Path) -> list[Holding]:
    raw = json.loads(Path(path).read_text(encoding="utf-8"))
    holdings: list[Holding] = []
    for row in raw.get("holdings", []):
        holdings.append(Holding(
            symbol=row.get("symbol", ""),
            name=row["name"],
            asset_class=AssetClass(row["asset_class"]),
            qty=float(row.get("qty", 0)),
            avg_buy_price=float(row["avg_buy_price"]),
            buy_date=_parse_date(row["buy_date"]),
            sector=row.get("sector", "—"),
            isin=row.get("isin", ""),
            scheme_code=row.get("scheme_code", ""),
            interest_rate=float(row.get("interest_rate", 0)),
            maturity_date=_parse_date(row.get("maturity_date")),
        ))
    return holdings


def load_profile(path: str | Path) -> UserProfile:
    raw = json.loads(Path(path).read_text(encoding="utf-8"))
    p = raw.get("profile", {})
    return UserProfile(
        name=p.get("name", "Investor"),
        age=int(p.get("age", 30)),
        income_per_year=float(p.get("income_per_year", 1_800_000)),
        risk_appetite=p.get("risk_appetite", "moderate"),
        goal=p.get("goal", "wealth_creation"),
        time_horizon_years=int(p.get("time_horizon_years", 5)),
        tax_regime=p.get("tax_regime", "new"),
        slab_rate=float(p.get("slab_rate", 0.30)),
        sec_80c_used=float(p.get("sec_80c_used", 85_000)),
        sec_80ccd1b_used=float(p.get("sec_80ccd1b_used", 0)),
        preferred_sectors=p.get("preferred_sectors", []),
        avoid_sectors=p.get("avoid_sectors", []),
    )

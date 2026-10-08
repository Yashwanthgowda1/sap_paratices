"""Domain models: asset classes, severity levels, holdings, user profile, flags."""
from __future__ import annotations

from dataclasses import dataclass, field
from datetime import date
from enum import Enum
from typing import Optional


class AssetClass(str, Enum):
    EQUITY = "equity"
    EQUITY_MF = "equity_mf"
    DEBT_MF = "debt_mf"
    ELSS = "elss"
    FD = "fd"
    SGB = "sgb"
    NPS = "nps"
    PPF = "ppf"
    BOND = "bond"
    GOLD = "gold"
    CASH = "cash"


class Severity(str, Enum):
    """Danger/severity ladder shown as badges in the UI."""
    SAFE = "SAFE"
    INFO = "INFO"
    WARNING = "WARNING"
    DANGER = "DANGER"

    @property
    def emoji(self) -> str:
        return {"SAFE": "🟢", "INFO": "🔵", "WARNING": "🟡", "DANGER": "🔴"}[self.value]

    @property
    def color(self) -> str:
        return {"SAFE": "#1a9850", "INFO": "#4575b4",
                "WARNING": "#f4a825", "DANGER": "#d73027"}[self.value]

    @property
    def rank(self) -> int:
        return {"SAFE": 0, "INFO": 1, "WARNING": 2, "DANGER": 3}[self.value]


@dataclass
class Flag:
    """A single risk/tax/concentration finding with a severity."""
    severity: Severity
    title: str
    message: str
    category: str = "general"           # risk | tax | concentration | macro
    saving: float = 0.0                 # ₹ opportunity, where applicable


@dataclass
class Holding:
    """One portfolio position. Live fields (current_price, nav) filled at refresh."""
    symbol: str
    name: str
    asset_class: AssetClass
    qty: float                          # shares/units; for FD/SGB use nominal
    avg_buy_price: float                # per unit; for FD = principal, SGB = issue/g
    buy_date: date
    sector: str = "—"
    isin: str = ""
    scheme_code: str = ""               # mfapi.in code for mutual funds
    current_price: float = 0.0          # live, per unit
    interest_rate: float = 0.0          # FD/bond/SGB coupon, % p.a.
    maturity_date: Optional[date] = None

    # ---- derived ----
    @property
    def invested_value(self) -> float:
        if self.asset_class in (AssetClass.FD, AssetClass.PPF, AssetClass.NPS):
            return self.avg_buy_price            # principal already in ₹
        return self.qty * self.avg_buy_price

    @property
    def current_value(self) -> float:
        price = self.current_price or self.avg_buy_price
        if self.asset_class in (AssetClass.FD, AssetClass.PPF, AssetClass.NPS):
            return price                         # treat current_price as corpus
        return self.qty * price

    @property
    def pnl(self) -> float:
        return self.current_value - self.invested_value

    @property
    def pnl_pct(self) -> float:
        base = self.invested_value or 1.0
        return self.pnl / base * 100.0

    @property
    def holding_days(self) -> int:
        return (date.today() - self.buy_date).days

    @property
    def is_equity_like(self) -> bool:
        return self.asset_class in (
            AssetClass.EQUITY, AssetClass.EQUITY_MF, AssetClass.ELSS)


@dataclass
class UserProfile:
    name: str = "Investor"
    age: int = 30
    income_per_year: float = 1_800_000
    risk_appetite: str = "moderate"      # conservative | moderate | aggressive
    goal: str = "wealth_creation"
    time_horizon_years: int = 5
    tax_regime: str = "new"              # new | old
    slab_rate: float = 0.30             # marginal rate for slab-taxed income
    sec_80c_used: float = 85_000
    sec_80ccd1b_used: float = 0.0        # NPS extra 50k
    preferred_sectors: list[str] = field(default_factory=list)
    avoid_sectors: list[str] = field(default_factory=list)

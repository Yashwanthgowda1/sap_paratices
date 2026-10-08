"""SQLite persistence (stdlib, no server). Stores profile, holdings, watchlist,
and monthly expenses so the app keeps your data between runs.

The sample JSON is used ONCE to seed an empty database; after that the DB is the
source of truth. Live prices/fundamentals are always fetched fresh (yfinance /
mfapi.in / Screener.in) — only your positions and preferences are persisted.
"""
from __future__ import annotations

import sqlite3
from datetime import date, datetime
from pathlib import Path

from artha.logger import get_logger
from artha.models import AssetClass, Holding, UserProfile

log = get_logger("artha.db")

DB_PATH = Path(__file__).resolve().parent.parent / "artha.db"


def _conn() -> sqlite3.Connection:
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def init_db() -> None:
    with _conn() as c:
        c.executescript("""
        CREATE TABLE IF NOT EXISTS profile(
            id INTEGER PRIMARY KEY CHECK (id=1),
            name TEXT, age INTEGER, income_per_year REAL, risk_appetite TEXT,
            goal TEXT, time_horizon_years INTEGER, tax_regime TEXT,
            slab_rate REAL, sec_80c_used REAL, sec_80ccd1b_used REAL);
        CREATE TABLE IF NOT EXISTS holdings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            symbol TEXT, name TEXT NOT NULL, asset_class TEXT NOT NULL,
            qty REAL, avg_buy_price REAL, buy_date TEXT, sector TEXT,
            isin TEXT, scheme_code TEXT, interest_rate REAL, maturity_date TEXT);
        CREATE TABLE IF NOT EXISTS watchlist(
            symbol TEXT PRIMARY KEY, sector TEXT);
        CREATE TABLE IF NOT EXISTS expenses(
            category TEXT PRIMARY KEY, amount REAL);
        CREATE TABLE IF NOT EXISTS meta(key TEXT PRIMARY KEY, value TEXT);
        """)


def _d(value: str | None) -> date | None:
    return datetime.strptime(value, "%Y-%m-%d").date() if value else None


# ---------------- profile ----------------
def save_profile(p: UserProfile) -> None:
    with _conn() as c:
        c.execute("""
            INSERT INTO profile(id,name,age,income_per_year,risk_appetite,goal,
                time_horizon_years,tax_regime,slab_rate,sec_80c_used,sec_80ccd1b_used)
            VALUES(1,?,?,?,?,?,?,?,?,?,?)
            ON CONFLICT(id) DO UPDATE SET
                name=excluded.name, age=excluded.age,
                income_per_year=excluded.income_per_year,
                risk_appetite=excluded.risk_appetite, goal=excluded.goal,
                time_horizon_years=excluded.time_horizon_years,
                tax_regime=excluded.tax_regime, slab_rate=excluded.slab_rate,
                sec_80c_used=excluded.sec_80c_used,
                sec_80ccd1b_used=excluded.sec_80ccd1b_used
        """, (p.name, p.age, p.income_per_year, p.risk_appetite, p.goal,
              p.time_horizon_years, p.tax_regime, p.slab_rate,
              p.sec_80c_used, p.sec_80ccd1b_used))


def get_profile() -> UserProfile | None:
    with _conn() as c:
        row = c.execute("SELECT * FROM profile WHERE id=1").fetchone()
    if not row:
        return None
    return UserProfile(
        name=row["name"], age=row["age"], income_per_year=row["income_per_year"],
        risk_appetite=row["risk_appetite"], goal=row["goal"],
        time_horizon_years=row["time_horizon_years"], tax_regime=row["tax_regime"],
        slab_rate=row["slab_rate"], sec_80c_used=row["sec_80c_used"],
        sec_80ccd1b_used=row["sec_80ccd1b_used"])


# ---------------- holdings ----------------
def list_holdings() -> list[Holding]:
    with _conn() as c:
        rows = c.execute("SELECT * FROM holdings ORDER BY id").fetchall()
    out: list[Holding] = []
    for r in rows:
        out.append(Holding(
            symbol=r["symbol"] or "", name=r["name"],
            asset_class=AssetClass(r["asset_class"]), qty=r["qty"] or 0,
            avg_buy_price=r["avg_buy_price"] or 0, buy_date=_d(r["buy_date"]),
            sector=r["sector"] or "—", isin=r["isin"] or "",
            scheme_code=r["scheme_code"] or "",
            interest_rate=r["interest_rate"] or 0,
            maturity_date=_d(r["maturity_date"])))
    return out


def add_holding(h: Holding) -> None:
    with _conn() as c:
        c.execute("""
            INSERT INTO holdings(symbol,name,asset_class,qty,avg_buy_price,buy_date,
                sector,isin,scheme_code,interest_rate,maturity_date)
            VALUES(?,?,?,?,?,?,?,?,?,?,?)
        """, (h.symbol, h.name, h.asset_class.value, h.qty, h.avg_buy_price,
              h.buy_date.isoformat() if h.buy_date else None, h.sector, h.isin,
              h.scheme_code, h.interest_rate,
              h.maturity_date.isoformat() if h.maturity_date else None))


def delete_holding(name: str) -> None:
    with _conn() as c:
        c.execute("DELETE FROM holdings WHERE name=?", (name,))


# ---------------- watchlist ----------------
def list_watchlist() -> dict[str, str]:
    with _conn() as c:
        rows = c.execute("SELECT symbol,sector FROM watchlist ORDER BY symbol").fetchall()
    return {r["symbol"]: (r["sector"] or "—") for r in rows}


def add_watch(symbol: str, sector: str = "—") -> None:
    with _conn() as c:
        c.execute("INSERT OR REPLACE INTO watchlist(symbol,sector) VALUES(?,?)",
                  (symbol.upper(), sector))


def remove_watch(symbol: str) -> None:
    with _conn() as c:
        c.execute("DELETE FROM watchlist WHERE symbol=?", (symbol.upper(),))


# ---------------- expenses ----------------
def save_expenses(expenses: dict[str, float]) -> None:
    with _conn() as c:
        c.execute("DELETE FROM expenses")
        c.executemany("INSERT INTO expenses(category,amount) VALUES(?,?)",
                      list(expenses.items()))


def get_expenses() -> dict[str, float]:
    with _conn() as c:
        rows = c.execute("SELECT category,amount FROM expenses").fetchall()
    return {r["category"]: r["amount"] for r in rows}


# ---------------- seeding ----------------
def seed_from_json_if_empty(json_path: str) -> None:
    """Populate an empty DB from the sample JSON exactly once."""
    init_db()
    with _conn() as c:
        already = c.execute("SELECT value FROM meta WHERE key='seeded'").fetchone()
    if already:
        return
    from artha.loader import load_holdings, load_profile
    log.info("Seeding empty database from %s", json_path)
    save_profile(load_profile(json_path))
    for h in load_holdings(json_path):
        add_holding(h)
    for h in load_holdings(json_path):
        if h.symbol:
            add_watch(h.symbol, h.sector)
    with _conn() as c:
        c.execute("INSERT OR REPLACE INTO meta(key,value) VALUES('seeded','1')")

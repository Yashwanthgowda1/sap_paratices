"""ARTHA — AI Investment Intelligence dashboard (Streamlit).

Run:  streamlit run app.py

Everything renders in-UI and is driven by YOUR data (SQLite, seeded once from
data/sample_portfolio.json): live ticker strip, portfolio summary, risk/danger
severity panel, deep holdings table + editor, a watchlist you control, CA-grade
tax dashboard, a day-to-day expense tracker, a "deploy ₹X" live screener, and a
multi-LLM agent whose provider + API key you choose live in the sidebar.
"""
from __future__ import annotations

import copy
from datetime import date

import pandas as pd
import plotly.graph_objects as go
import streamlit as st

from artha import db, llm
from artha.agent import run_agent
from artha.analytics.expense_tracker import analyse_expenses
from artha.analytics.opportunity import screen_all
from artha.config import TAX
from artha.data.groww_mcp import get_bridge
from artha.models import AssetClass, Holding, Severity, UserProfile
from artha.service import build_snapshot

SAMPLE = "data/sample_portfolio.json"

st.set_page_config(page_title="ARTHA — AI Investment Intelligence",
                   page_icon="📈", layout="wide")

st.markdown("""
<style>
.badge{display:inline-block;padding:2px 10px;border-radius:12px;color:#fff;
       font-size:0.75rem;font-weight:700;letter-spacing:.3px}
.flagcard{border-left:5px solid #ccc;padding:8px 12px;margin:6px 0;
          background:#1e2228;border-radius:6px}
.big{font-size:1.6rem;font-weight:800;margin:0}
.sub{color:#9aa4b2;font-size:0.8rem;margin:0}
</style>
""", unsafe_allow_html=True)


def badge(sev: Severity) -> str:
    return (f"<span class='badge' style='background:{sev.color}'>"
            f"{sev.emoji} {sev.value}</span>")


def _invalidate() -> None:
    st.session_state.pop("snapshot", None)


@st.cache_resource(show_spinner=False)
def _groww():
    """Live Groww MCP bridge, cached so the authorised session survives reruns."""
    return get_bridge()


# ----------------------------- Sidebar ------------------------------------
def sidebar(profile: UserProfile) -> tuple[UserProfile, dict]:
    st.sidebar.title("⚙️ ARTHA Controls")

    st.sidebar.subheader("🤖 AI Advisor")
    provider = st.sidebar.selectbox("Model provider", llm.provider_names())
    model = st.sidebar.selectbox("Model", llm.models_for(provider))
    default_key = llm.default_key_for(provider)
    api_key = st.sidebar.text_input(
        "API key (overrides .env)", value="", type="password",
        placeholder="paste key — this session only")
    st.sidebar.caption(f"{provider} · "
                       f"{'✅ key set' if (api_key or default_key) else '⚠️ no key'}")

    st.sidebar.subheader("👤 Investor profile")
    name = st.sidebar.text_input("Name", profile.name)
    age = st.sidebar.number_input("Age", 18, 90, profile.age)
    risk = st.sidebar.selectbox(
        "Risk appetite", ["conservative", "moderate", "aggressive"],
        index=["conservative", "moderate", "aggressive"].index(profile.risk_appetite))
    horizon = st.sidebar.number_input("Horizon (years)", 1, 40,
                                      profile.time_horizon_years)
    income = st.sidebar.number_input("Annual income (₹)", 0, 100_000_000,
                                     int(profile.income_per_year), 50_000)
    slabs = [0.05, 0.10, 0.15, 0.20, 0.30]
    slab = st.sidebar.selectbox(
        "Income-tax slab", slabs, index=slabs.index(profile.slab_rate)
        if profile.slab_rate in slabs else 4, format_func=lambda x: f"{x*100:.0f}%")
    c80 = st.sidebar.number_input("80C already used (₹)", 0, 150000,
                                  int(profile.sec_80c_used), 5000)
    nps = st.sidebar.number_input("80CCD(1B) NPS used (₹)", 0, 50000,
                                  int(profile.sec_80ccd1b_used), 5000)

    new = UserProfile(
        name=name, age=int(age), income_per_year=float(income), risk_appetite=risk,
        goal=profile.goal, time_horizon_years=int(horizon), slab_rate=float(slab),
        sec_80c_used=float(c80), sec_80ccd1b_used=float(nps))
    if st.sidebar.button("💾 Save profile"):
        db.save_profile(new)
        _invalidate()
        st.sidebar.success("Profile saved")
    cfg = {"provider": provider, "model": model, "api_key": api_key}
    return new, cfg


# ----------------------------- Panels -------------------------------------
def ticker_strip(indices: dict) -> None:
    cols = st.columns(len(indices))
    for col, (label, q) in zip(cols, indices.items()):
        arrow = "▲" if q.is_up else "▼"
        color = "#1a9850" if q.is_up else "#d73027"
        val = f"{q.price:,.2f}" if q.ok else "—"
        col.markdown(f"<p class='sub'>{label}</p><p class='big'>{val}</p>"
                     f"<p style='color:{color};margin:0'>{arrow} {q.change_pct:+.2f}%</p>",
                     unsafe_allow_html=True)


def summary_panel(snap) -> None:
    s = snap.summary
    sev, msg = snap.health
    st.markdown(f"### Portfolio &nbsp; {badge(sev)} &nbsp; "
                f"<span class='sub'>{msg}</span>", unsafe_allow_html=True)
    c = st.columns(5)
    c[0].metric("Invested", f"₹{s.invested:,.0f}")
    c[1].metric("Current", f"₹{s.current:,.0f}")
    c[2].metric("P&L", f"₹{s.pnl:,.0f}", f"{s.pnl_pct:+.2f}%")
    c[3].metric("XIRR (ann.)", f"{s.xirr:.1f}%")
    c[4].metric("Holdings", f"{len(snap.holdings)}")
    if s.allocation:
        fig = go.Figure(go.Bar(
            x=list(s.allocation.values()), y=list(s.allocation.keys()),
            orientation="h", marker_color="#4575b4",
            text=[f"{v}%" for v in s.allocation.values()], textposition="auto"))
        fig.update_layout(height=220, margin=dict(l=0, r=0, t=10, b=0),
                          title="Asset allocation (% of current value)",
                          template="plotly_dark")
        st.plotly_chart(fig, use_container_width=True)


def risk_panel(snap) -> None:
    st.markdown("### 🚨 Risk & Danger Alerts")
    risk_flags = [f for f in snap.flags if f.category in ("risk", "concentration")]
    tax_flags = [f for f in snap.flags if f.category == "tax"]
    if not risk_flags:
        st.success("No active risk/concentration flags.")
    for f in risk_flags:
        extra = f" · saves ₹{f.saving:,.0f}" if f.saving else ""
        st.markdown(
            f"<div class='flagcard' style='border-left-color:{f.severity.color}'>"
            f"{badge(f.severity)} &nbsp;<b>{f.title}</b>{extra}<br>"
            f"<span class='sub'>{f.message}</span></div>", unsafe_allow_html=True)
    if tax_flags:
        st.markdown("#### 💡 Tax-saving nudges (your CA)")
        for f in tax_flags:
            st.markdown(
                f"<div class='flagcard' style='border-left-color:{f.severity.color}'>"
                f"{badge(f.severity)} &nbsp;<b>{f.title}</b> · save ≈₹{f.saving:,.0f}"
                f"<br><span class='sub'>{f.message}</span></div>",
                unsafe_allow_html=True)


def holdings_panel(snap) -> None:
    st.markdown("### 📊 Holdings — Deep View")
    tax_by_name = {r.holding.name: r for r in snap.tax_results}
    rows = []
    for h in snap.holdings:
        r = tax_by_name.get(h.name)
        rows.append({
            "Holding": h.name, "Class": h.asset_class.value, "Qty": f"{h.qty:g}",
            "Buy ₹": f"{h.avg_buy_price:,.2f}", "LTP ₹": f"{h.current_price:,.2f}",
            "Invested ₹": f"{h.invested_value:,.0f}",
            "Current ₹": f"{h.current_value:,.0f}", "P&L %": f"{h.pnl_pct:+.1f}%",
            "Held (d)": h.holding_days, "Tax type": r.tax_type if r else "—",
            "Tax if sold ₹": f"{r.tax_payable:,.0f}" if r else "—",
        })
    df = pd.DataFrame(rows)

    def color_pnl(val):
        if isinstance(val, str) and val.endswith("%"):
            n = float(val.replace("%", "").replace("+", ""))
            return f"color:{'#1a9850' if n >= 0 else '#d73027'};font-weight:700"
        return ""

    if df.empty:
        st.info("No holdings yet — use the form below to add your first position.")
    else:
        st.dataframe(df.style.map(color_pnl, subset=["P&L %"]),
                     use_container_width=True, hide_index=True)
    _holdings_editor()


def _holdings_editor() -> None:
    with st.expander("➕ Add / remove a holding (saved to your database)"):
        with st.form("add_holding", clear_on_submit=True):
            cols = st.columns(4)
            name = cols[0].text_input("Name*")
            symbol = cols[1].text_input("Yahoo symbol (e.g. INFY.NS)")
            acls = cols[2].selectbox("Asset class", [a.value for a in AssetClass])
            sector = cols[3].text_input("Sector", "—")
            cols2 = st.columns(4)
            qty = cols2[0].number_input("Qty / units", 0.0, step=1.0)
            avg = cols2[1].number_input("Avg buy price / principal ₹", 0.0, step=100.0)
            bdate = cols2[2].date_input("Buy date", date(2025, 1, 1))
            scheme = cols2[3].text_input("MF scheme code (mfapi.in)")
            add_to_wl = st.checkbox("Also add symbol to my watchlist", value=True)
            if st.form_submit_button("Add holding") and name and avg > 0:
                db.add_holding(Holding(
                    symbol=symbol, name=name, asset_class=AssetClass(acls),
                    qty=qty, avg_buy_price=avg, buy_date=bdate, sector=sector,
                    scheme_code=scheme))
                if add_to_wl and symbol:
                    db.add_watch(symbol, sector)
                _invalidate()
                st.success(f"Added {name}")
                st.rerun()

        names = [h.name for h in db.list_holdings()]
        if names:
            rm = st.selectbox("Remove a holding", ["—"] + names)
            if st.button("Delete selected") and rm != "—":
                db.delete_holding(rm)
                _invalidate()
                st.rerun()


def groww_panel() -> None:
    st.markdown("### 🔗 Groww — Live Brokerage (MCP)")
    st.caption("Pulls your real Groww holdings over the Model Context Protocol "
               "(groww.in/updates/groww-mcp). First connect opens a browser to "
               "log in & authorise; the token is cached by the Groww server.")
    bridge = _groww()
    s = bridge.status

    if not s.ready_to_connect:
        st.warning(f"Prerequisites missing — {s.install_hint}. ARTHA keeps working "
                   "on your manually-entered holdings meanwhile.")
        return

    cols = st.columns([1, 1, 2])
    if not s.connected:
        if cols[0].button("🔌 Connect Groww", type="primary"):
            with st.spinner("Starting Groww MCP server — a browser window will "
                            "open for login & consent. Authorise, then wait…"):
                bridge.connect()
            st.rerun()
    else:
        cols[0].success("● Connected")
        if cols[1].button("⟳ Refresh from Groww"):
            st.session_state["groww_holdings"] = bridge.fetch_holdings()
            st.session_state["groww_ctx"] = bridge.raw_portfolio_text()
            st.rerun()

    if s.last_error:
        st.error(s.last_error)
    if s.connected:
        st.caption(f"Tools exposed: {', '.join(s.tools) or '—'}")

    live = st.session_state.get("groww_holdings")
    if s.connected and live is None:
        with st.spinner("Fetching your Groww holdings…"):
            live = bridge.fetch_holdings()
            st.session_state["groww_holdings"] = live
            st.session_state["groww_ctx"] = bridge.raw_portfolio_text()

    if live:
        st.dataframe(pd.DataFrame([{
            "Symbol": h.symbol, "Holding": h.name, "Qty": f"{h.qty:g}",
            "Avg ₹": f"{h.avg_buy_price:,.2f}",
            "LTP ₹": f"{h.current_price:,.2f}" if h.current_price else "—",
            "ISIN": h.isin or "—"} for h in live]),
            use_container_width=True, hide_index=True)
        if st.button("⬇️ Import these into my portfolio (DB)"):
            existing = {h.name for h in db.list_holdings()}
            added = 0
            for h in live:
                if h.name in existing:
                    continue
                db.add_holding(h)
                if h.symbol:
                    db.add_watch(h.symbol, h.sector)
                added += 1
            _invalidate()
            st.success(f"Imported {added} new holding(s) from Groww.")
            st.rerun()
    elif s.connected:
        st.info("Connected, but no holdings returned yet. Use ⟳ Refresh, or check "
                "that your Groww account holds equity.")


def watchlist_panel() -> None:
    st.markdown("### ⭐ My Watchlist (drives the Deploy screener)")
    wl = db.list_watchlist()
    if wl:
        st.dataframe(pd.DataFrame(
            [{"Symbol": s, "Sector": sec} for s, sec in wl.items()]),
            use_container_width=True, hide_index=True)
    else:
        st.info("Empty. Add the stocks you want ARTHA to track for new money.")
    cols = st.columns([2, 2, 1])
    sym = cols[0].text_input("Add symbol (e.g. INFY.NS)", key="wl_sym")
    sec = cols[1].text_input("Sector", "—", key="wl_sec")
    if cols[2].button("Add") and sym:
        db.add_watch(sym, sec)
        st.rerun()
    if wl:
        rm = st.selectbox("Remove", ["—"] + list(wl), key="wl_rm")
        if st.button("Remove symbol") and rm != "—":
            db.remove_watch(rm)
            st.rerun()


def tax_panel(snap, user: UserProfile) -> None:
    st.markdown("### 🧾 CA Tax Dashboard — FY 2025-26")
    t = snap.tax_summary
    c = st.columns(4)
    c[0].metric("Tax if sold today", f"₹{t['total_tax_if_sold_today']:,.0f}")
    c[1].metric("Health & Ed cess (4%)", f"₹{t['cess']:,.0f}")
    c[2].metric("LTCG exemption left", f"₹{t['ltcg_exemption_left']:,.0f}")
    c[3].metric("Wait-to-LTCG saving", f"₹{t['wait_optimisation_saving']:,.0f}")
    st.caption(f"ITR form: **{t['itr_form']}** · Schedule 112A line items: "
               f"**{t['schedule_112a_count']}** · In plain words: sell within 1 year "
               "= 20% tax (STCG); sell after 1 year = 12.5% but first ₹1.25L of "
               "profit each year is tax-free (LTCG).")
    rows = []
    for r in snap.tax_results:
        rows.append({
            "Holding": r.holding.name, "Type": r.tax_type,
            "Gain ₹": f"{r.gain:,.0f}", "Taxable ₹": f"{r.taxable_gain:,.0f}",
            "Rate": f"{r.tax_rate*100:.1f}%" if r.tax_rate else "—",
            "Tax ₹": f"{r.tax_payable:,.0f}", "Days→LTCG": r.days_to_ltcg or "—",
            "Wait saves ₹": f"{r.wait_saving:,.0f}" if r.wait_saving else "—",
            "CA note": r.note,
        })
    st.dataframe(pd.DataFrame(rows), use_container_width=True, hide_index=True)


def calculator_panel(snap, user: UserProfile) -> None:
    st.markdown("### 🧮 Wait-vs-Sell Tax Calculator")
    names = [h.name for h in snap.holdings]
    if not names:
        st.info("No holdings yet.")
        return
    pick = st.selectbox("Pick a holding", names, key="calc_pick")
    h = next(x for x in snap.holdings if x.name == pick)
    growth = st.slider("Assumed annual price growth %", -20, 40, 8) / 100.0
    r = next(x for x in snap.tax_results if x.holding.name == pick)
    sell_now_net = h.current_value - r.tax_payable
    left, right = st.columns(2)
    with left:
        st.markdown("**Sell today**")
        st.write(f"Current value: ₹{h.current_value:,.0f}")
        st.write(f"{r.tax_type} tax: ₹{r.tax_payable:,.0f}")
        st.write(f"**Net in hand: ₹{sell_now_net:,.0f}**")
    with right:
        if h.is_equity_like and r.days_to_ltcg:
            days = r.days_to_ltcg
            future_val = h.current_value * (1 + growth) ** (days / 365.0)
            gain = future_val - h.invested_value
            future_tax = max(0.0, gain - TAX.LTCG_EQUITY_EXEMPTION) * TAX.LTCG_EQUITY
            net = future_val - future_tax
            st.markdown(f"**Wait {days} days → LTCG**")
            st.write(f"Est. value: ₹{future_val:,.0f}")
            st.write(f"LTCG tax: ₹{future_tax:,.0f}")
            st.write(f"**Net in hand: ₹{net:,.0f}**")
            diff = net - sell_now_net
            st.success(f"{'⏳ WAIT' if diff > 0 else '💰 SELL / review'} — "
                       f"difference ₹{diff:,.0f}")
        elif h.asset_class == AssetClass.SGB:
            st.markdown("**Hold to RBI maturity (8y)**")
            st.write("Capital gain at maturity: **₹0 tax**.")
            st.success(f"Holding to maturity saves ₹{r.tax_payable:,.0f}.")
        else:
            st.info("No LTCG-crossover benefit — taxed at slab / already long-term.")


def expenses_panel(user: UserProfile) -> None:
    st.markdown("### 💸 Day-to-Day Expense Tracker")
    stored = db.get_expenses()
    if not stored:
        stored = {"rent": 0, "groceries": 0, "utilities": 0,
                  "transport": 0, "dining": 0, "shopping": 0,
                  "subscriptions": 0, "misc": 0}
    df = pd.DataFrame([{"category": k, "amount": v} for k, v in stored.items()])
    edited = st.data_editor(df, num_rows="dynamic", use_container_width=True,
                            key="exp_editor")

    # Income field — always shows monthly, syncs back to annual profile on save
    income_m = st.number_input(
        "Your monthly take-home pay (₹) — after tax, after PF deduction",
        min_value=0, max_value=10_000_000,
        value=int(user.income_per_year / 12), step=1000,
        help="Enter what lands in your bank account each month. Annual = this × 12.")
    st.caption(f"= ₹{income_m * 12:,.0f} / year  |  Savings = Monthly pay − Total expenses")

    sip = st.number_input("Current monthly SIP (₹)", 0, 1_000_000, 0, 500)
    efund = st.number_input("Emergency fund saved (₹)", 0, 50_000_000, 0, 10000)

    if st.button("💾 Save & analyse expenses"):
        exp = {str(r["category"]).strip(): float(r["amount"] or 0)
               for _, r in edited.iterrows() if str(r["category"]).strip()}
        db.save_expenses(exp)
        # Sync the monthly income back to the user profile (annual = monthly × 12)
        updated = UserProfile(
            name=user.name, age=user.age,
            income_per_year=float(income_m * 12),
            risk_appetite=user.risk_appetite, goal=user.goal,
            time_horizon_years=user.time_horizon_years,
            tax_regime=user.tax_regime, slab_rate=user.slab_rate,
            sec_80c_used=user.sec_80c_used, sec_80ccd1b_used=user.sec_80ccd1b_used)
        db.save_profile(updated)
        rep = analyse_expenses(income_m, exp, sip, efund)
        st.session_state["exp_report"] = rep
        _invalidate()   # force snapshot rebuild with new income

    rep = st.session_state.get("exp_report")
    if rep:
        # Plain formula so there is no confusion
        st.markdown(
            f"**₹{rep.income:,.0f}** (income) − **₹{rep.total_expense:,.0f}** (expenses) "
            f"= **₹{rep.savings:,.0f}** savings ({rep.savings_rate:.0f}%)",
            unsafe_allow_html=False)
        c = st.columns(4)
        c[0].metric("Total spend", f"₹{rep.total_expense:,.0f}")
        c[1].metric("Monthly savings", f"₹{rep.savings:,.0f}", f"{rep.savings_rate:.0f}%")
        c[2].metric("Investable surplus", f"₹{rep.investable_surplus:,.0f}")
        c[3].metric("Needs / Wants", f"{rep.needs_pct:.0f}% / {rep.wants_pct:.0f}%")
        if rep.by_category:
            non_zero = {k: v for k, v in rep.by_category.items() if v > 0}
            if non_zero:
                fig = go.Figure(go.Pie(labels=list(non_zero),
                                       values=list(non_zero.values()), hole=0.4))
                fig.update_layout(height=300, template="plotly_dark",
                                  title="Where your money goes")
                st.plotly_chart(fig, use_container_width=True)
        for f in rep.flags:
            st.markdown(
                f"<div class='flagcard' style='border-left-color:{f.severity.color}'>"
                f"{badge(f.severity)} &nbsp;<b>{f.title}</b><br>"
                f"<span class='sub'>{f.message}</span></div>", unsafe_allow_html=True)
        st.info(f"👉 Plain words: income ₹{rep.income:,.0f} − expenses "
                f"₹{rep.total_expense:,.0f} = ₹{rep.savings:,.0f} left. After your "
                f"₹{sip:,.0f} SIP, **₹{rep.investable_surplus:,.0f}/month** is free. "
                "Go to the Deploy tab to put it to work.")


def _stock_card(o) -> None:
    amt = f" · suggested ₹{o.suggested_amount:,.0f}" if o.suggested_amount else ""
    proj = ""
    if o.suggested_amount and o.proj_1y_value:
        proj = (f"<br><span class='sub'>Scenario: ₹{o.suggested_amount:,.0f} → "
                f"~₹{o.proj_1y_value:,.0f} in 1y ({o.proj_1y_pct:+.0f}%)</span>")
    # Fundamentals line
    fund_bits = []
    if o.roe  is not None: fund_bits.append(f"ROE {o.roe}%")
    if o.roce is not None: fund_bits.append(f"ROCE {o.roce}%")
    if o.pe   is not None: fund_bits.append(f"P/E {o.pe}")
    if o.div_yield and o.div_yield > 0: fund_bits.append(f"Div {o.div_yield}%")
    fund_line = (f"<br><span class='sub'><b>Fundamentals:</b> "
                 f"{' · '.join(fund_bits)}</span>") if fund_bits else ""
    # Hold signal + wait period
    hs_line = ""
    if o.hold_signal:
        hs_line = (f"<br><span class='sub'><b>{o.hold_signal}</b>"
                   + (f" — {o.wait_period}" if o.wait_period else "")
                   + "</span>")
    st.markdown(
        f"<div class='flagcard' style='border-left-color:{o.severity.color}'>"
        f"{badge(o.severity)} &nbsp;<b>{o.name}</b> ({o.sector}) — "
        f"₹{o.price:,.2f} · <b>{o.verdict}</b> · 12m {o.trend_1y:+.0f}%{amt}<br>"
        f"<span class='sub'>{' · '.join(o.reasons)}</span>"
        f"{fund_line}{hs_line}{proj}</div>",
        unsafe_allow_html=True)


def _fund_card(f) -> None:
    amt = f" · suggested ₹{f.suggested_amount:,.0f}" if f.suggested_amount else ""
    cagr = " / ".join(
        f"{lbl} {v:.1f}%" for lbl, v in
        (("1Y", f.cagr_1y), ("3Y", f.cagr_3y), ("5Y", f.cagr_5y)) if v is not None)
    proj = ""
    if f.suggested_amount and f.proj_1y_value:
        proj = (f"<br><span class='sub'>At 3Y-CAGR pace: ₹{f.suggested_amount:,.0f} → "
                f"~₹{f.proj_1y_value:,.0f} in 1y ({f.proj_1y_pct:+.0f}%)</span>")
    hs_line = ""
    if f.hold_signal:
        hs_line = (f"<br><span class='sub'><b>{f.hold_signal}</b>"
                   + (f" — {f.wait_period}" if f.wait_period else "")
                   + "</span>")
    st.markdown(
        f"<div class='flagcard' style='border-left-color:{f.severity.color}'>"
        f"{badge(f.severity)} &nbsp;<b>{f.name}</b> [{f.category}] · NAV ₹{f.nav:,.2f} · "
        f"<b>{f.verdict}</b>{amt}<br><span class='sub'>CAGR {cagr or '—'} · "
        f"{' · '.join(f.reasons)}</span>{hs_line}{proj}</div>",
        unsafe_allow_html=True)


def deploy_panel() -> None:
    st.markdown("### 🎯 Deploy My Money — Market-wide Opportunities (live)")
    st.caption("Screens ~140 liquid NSE stocks (large/mid/small cap, 16 sectors) AND 48 mutual funds "
               "on live technicals (200-DMA, RSI, 52w position, 12m trend) **plus** "
               "real fundamentals (ROE, ROCE, P/E, dividend yield from Screener.in). "
               "Each pick shows a buy/wait signal and a hold-period recommendation. Educational, not advice.")
    c = st.columns([2, 1, 1])
    amount = c[0].number_input("Amount to invest now (₹)", 500, 100_000_000, 60000, 5000)
    inc_mkt = c[1].checkbox("Market stocks", value=True)
    inc_fun = c[2].checkbox("Mutual funds", value=True)
    if st.button("🔎 Screen the market", type="primary"):
        wl = db.list_watchlist()
        with st.spinner("Pulling live prices, technicals, fundamentals (ROE/ROCE/P/E) "
                        "and fund NAVs for ~140 stocks + 48 funds… "
                        "(first run 60-120s due to Screener.in lookups; "
                        "subsequent runs use 30-min cache and are fast)"):
            st.session_state["deploy"] = screen_all(
                float(amount), wl, include_market=inc_mkt, include_funds=inc_fun)
    data = st.session_state.get("deploy")
    if not data:
        st.info("Pick an amount and hit **Screen the market** to see today's "
                "good-vs-bad opportunities across stocks and funds.")
        return
    stocks, funds, plan = data["stocks"], data["funds"], data["plan"]

    # ---- impact / positives of investing today ----
    st.markdown("#### ✅ If you invest today")
    m = st.columns(4)
    m[0].metric("Deploying", f"₹{sum(x.suggested_amount for x in stocks if x.suggested_amount)+sum(x.suggested_amount for x in funds if x.suggested_amount):,.0f}")
    m[1].metric("Projected 1y value", f"₹{plan['projected_value']:,.0f}",
                f"{plan['projected_pct']:+.1f}%")
    m[2].metric("Projected gain", f"₹{plan['projected_gain']:,.0f}")
    m[3].metric("GOOD / AVOID", f"{plan['good_count']} / {plan['avoid_count']}")
    for hl in plan["highlights"]:
        st.success(hl)
    st.info(f"**How to deploy:** {plan['deploy_mode']}  ·  India VIX {plan['vix']}  ·  "
            f"Screened {plan['stocks_screened']} stocks + {plan['funds_screened']} funds  ·  "
            f"Fundamentals: ROE · ROCE · P/E from Screener.in")

    good_s = [o for o in stocks if o.verdict == "GOOD"]
    good_f = [f for f in funds if f.verdict == "GOOD"]
    if good_s or good_f:
        st.markdown("#### 🟢 GOOD to buy now (money allocated here)")
        for o in good_s:
            _stock_card(o)
        for f in good_f:
            _fund_card(f)
    else:
        st.warning("No GOOD picks right now — the universe looks stretched. "
                   "Consider a staggered SIP or waiting for a dip.")

    with st.expander(f"📊 All screened stocks ({len(stocks)})"):
        for o in stocks:
            if o.verdict != "GOOD":
                _stock_card(o)
    if funds:
        with st.expander(f"💼 All screened mutual funds ({len(funds)})"):
            for f in funds:
                if f.verdict != "GOOD":
                    _fund_card(f)
    st.caption("**Legend:** 🟢 GOOD = reasonable to buy now | 🟡 NEUTRAL = wait / small SIP | 🔴 AVOID = overbought or downtrend. "
               "**Signals:** 🟢 BUY NOW = all lights green | 🟢 ACCUMULATE = good setup | 🟡 WAIT FOR DIP = near high or overbought RSI | 🔴 AVOID = multiple red flags. "
               "Projections extrapolate recent trend/CAGR — scenarios, never guarantees. "
               "ROE/ROCE/P/E from Screener.in (15-min cache). Hold ≥ 1 year for LTCG (12.5%) vs STCG (20%).")


def macro_panel(snap) -> None:
    m = snap.macro
    st.markdown("### 🏦 Macro / RBI / SEBI Watch")
    c = st.columns(4)
    c[0].metric("RBI repo", f"{m.repo_rate:.2f}%")
    c[1].metric("CPI inflation", f"{m.inflation:.2f}%")
    c[2].metric("10y G-sec", f"{m.gsec_10y:.2f}%")
    c[3].metric("India VIX", f"{m.vix:.1f}", m.vix_mood)
    st.info(f"**Rate view:** {m.rate_environment}")


def ai_panel(snap, user: UserProfile, cfg: dict) -> None:
    st.markdown("### 🧠 ARTHA Agent — your CA + investment advisor")
    st.caption(f"Agent on **{cfg['provider']}** / {cfg['model']}. It fetches live "
               "fundamentals (Screener.in) and screens your watchlist as needed, "
               "then explains everything in simple English.")
    question = st.text_area(
        "Ask ARTHA (plain English) — or leave blank for a full review",
        placeholder="e.g. I have ₹60,000 to invest — which of my stocks is good to "
                    "buy now? Should I book the TCS loss before March?", height=90)

    # Build cross-module context so the AI sees expenses + deploy too
    extra_module_ctx: list[str] = []
    rep = st.session_state.get("exp_report")
    if rep:
        extra_module_ctx.append(
            f"=== EXPENSE TRACKER (latest saved) ===\n"
            f"Monthly income ₹{rep.income:,.0f} | Expenses ₹{rep.total_expense:,.0f} | "
            f"Savings ₹{rep.savings:,.0f} ({rep.savings_rate:.0f}%) | "
            f"Investable surplus ₹{rep.investable_surplus:,.0f}/month | "
            f"Needs {rep.needs_pct:.0f}% / Wants {rep.wants_pct:.0f}%\n"
            + "\n".join(f"  [{f.severity.value}] {f.title}: {f.message}"
                        for f in rep.flags))
    deploy_data = st.session_state.get("deploy")
    if deploy_data:
        stocks, funds, plan = (deploy_data["stocks"], deploy_data["funds"],
                               deploy_data["plan"])
        lines = [
            f"=== DEPLOY SCREENER (last run, market-wide) ===",
            f"Amount ₹{plan['amount']:,.0f} | Mode: {plan['deploy_mode']} | "
            f"VIX {plan['vix']} | screened {plan['stocks_screened']} stocks + "
            f"{plan['funds_screened']} funds | GOOD {plan['good_count']} / "
            f"AVOID {plan['avoid_count']}",
            f"Projected 1y: ₹{plan['projected_value']:,.0f} "
            f"(+₹{plan['projected_gain']:,.0f}, {plan['projected_pct']:+.1f}%) if trends hold",
        ]
        for o in [s for s in stocks if s.verdict == "GOOD"][:8]:
            lines.append(
                f"  STOCK {o.name} [{o.sector}] ₹{o.price} → {o.verdict} "
                f"(score {o.score}, RSI {o.rsi}, 12m {o.trend_1y:+.0f}%, "
                f"{o.pct_off_high}% off high) → put ₹{o.suggested_amount:,.0f}")
        for f in [x for x in funds if x.verdict == "GOOD"][:6]:
            lines.append(
                f"  FUND {f.name} [{f.category}] NAV ₹{f.nav} → {f.verdict} "
                f"(3Y CAGR {f.cagr_3y}%) → put ₹{f.suggested_amount:,.0f}")
        extra_module_ctx.append("\n".join(lines))

    groww_ctx = st.session_state.get("groww_ctx")
    if groww_ctx:
        extra_module_ctx.append(
            "=== GROWW LIVE BROKERAGE (via MCP) ===\n" + groww_ctx)

    if st.button("🚀 Ask the agent", type="primary"):
        if not (cfg["api_key"] or llm.default_key_for(cfg["provider"])):
            st.error(f"Enter an API key for {cfg['provider']} in the sidebar first.")
            return
        with st.spinner(f"{cfg['provider']} agent is working…"):
            run = run_agent(question, snap, user, cfg, db.list_watchlist(),
                            extra_context="\n\n".join(extra_module_ctx))
        if run.tool_trace:
            with st.expander("🛠️ Tools the agent called", expanded=True):
                for t in run.tool_trace:
                    st.write(t)
        if run.error:
            st.error(run.error)
        elif run.answer:
            st.markdown(run.answer)


# ----------------------------- Main ---------------------------------------
def main() -> None:
    st.title("📈 ARTHA — AI Investment Intelligence")
    db.seed_from_json_if_empty(SAMPLE)
    profile = db.get_profile() or UserProfile()
    profile, cfg = sidebar(profile)

    top = st.columns([1, 4])
    with top[0]:
        if st.button("🔄 Refresh live data", type="primary"):
            _invalidate()
    with top[1]:
        st.caption("Live quotes via Yahoo Finance · NAVs via mfapi.in (AMFI) · "
                   "fundamentals via Screener.in. Educational — confirm with a "
                   "SEBI-registered RIA / CA.")

    if "snapshot" not in st.session_state:
        with st.spinner("Fetching live prices, NAVs and macro…"):
            holdings = copy.deepcopy(db.list_holdings())
            st.session_state.snapshot = build_snapshot(holdings, profile)
    snap = st.session_state.snapshot
    st.caption(f"As of {snap.as_of}")

    ticker_strip(snap.indices)
    st.divider()
    summary_panel(snap)

    tabs = st.tabs(["🚨 Risk & Alerts", "📊 Holdings", "🧾 CA Tax", "🧮 Calculator",
                    "💸 Expenses", "🎯 Deploy ₹X", "🏦 Macro", "🧠 AI Agent"])
    with tabs[0]:
        risk_panel(snap)
    with tabs[1]:
        holdings_panel(snap)
        st.divider()
        groww_panel()
        st.divider()
        watchlist_panel()
    with tabs[2]:
        tax_panel(snap, profile)
    with tabs[3]:
        calculator_panel(snap, profile)
    with tabs[4]:
        expenses_panel(profile)
    with tabs[5]:
        deploy_panel()
    with tabs[6]:
        macro_panel(snap)
    with tabs[7]:
        ai_panel(snap, profile, cfg)


if __name__ == "__main__":
    main()

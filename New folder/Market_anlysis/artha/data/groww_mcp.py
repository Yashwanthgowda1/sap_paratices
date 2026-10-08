"""Groww MCP bridge — pulls your live Groww portfolio into ARTHA.

Groww ships an MCP server (https://groww.in/updates/groww-mcp) that exposes your
real brokerage account — holdings, positions, F&O, order management — to AI
assistants over the Model Context Protocol. It runs as a Node process
(`npx @groww/mcp-server https://mcp.groww.in/mcp <port>`) and authenticates your
Groww login via OAuth in the browser on first connect; the token is then cached
by the Node server so later connects are silent.

Streamlit is synchronous and reruns the whole script on every interaction, while
an MCP stdio session is a long-lived async subprocess. We bridge the two by
owning ONE asyncio event loop in a daemon thread that keeps the session (and the
authorised Node process) alive for the life of the process. Streamlit calls hop
onto that loop with ``run_coroutine_threadsafe`` and block on the result. The
whole bridge is cached as a singleton (``get_bridge``) so it survives reruns.

Every external dependency is optional and failure is non-fatal: if the ``mcp``
SDK isn't installed, Node is missing, or OAuth hasn't been done, the bridge
reports a clear status and ARTHA keeps running on your manually-entered holdings.
"""
from __future__ import annotations

import asyncio
import json
import shutil
import threading
from concurrent.futures import Future
from dataclasses import dataclass, field
from datetime import date
from typing import Any, Callable

from artha.logger import get_logger
from artha.models import AssetClass, Holding

log = get_logger("artha.groww")

# Official Groww MCP endpoint + the local OAuth callback port from their docs.
MCP_URL = "https://mcp.groww.in/mcp"
OAUTH_PORT = "52155"
NPM_PACKAGE = "@groww/mcp-server"

# First connect may block on the browser OAuth consent screen — be generous.
CONNECT_TIMEOUT = 180.0
CALL_TIMEOUT = 60.0

# Tool-name heuristics: Groww does not publish exact tool names, so we match the
# live `tools/list` result by intent. Order = priority.
_HOLDINGS_HINTS = ("holding", "portfolio", "stocks", "equity")
_POSITIONS_HINTS = ("position", "fno", "f&o", "derivative")


@dataclass
class GrowwStatus:
    mcp_available: bool = False      # the `mcp` python SDK is importable
    node_available: bool = False     # `npx` is on PATH
    connecting: bool = False
    connected: bool = False
    tools: list[str] = field(default_factory=list)
    last_error: str = ""
    holdings_count: int = 0

    @property
    def ready_to_connect(self) -> bool:
        return self.mcp_available and self.node_available

    @property
    def install_hint(self) -> str:
        bits = []
        if not self.mcp_available:
            bits.append("`pip install mcp` (in the app's .venv)")
        if not self.node_available:
            bits.append("install Node.js ≥ 22.17 so `npx` is on PATH")
        return " · ".join(bits)


def _mcp_importable() -> bool:
    try:
        import mcp  # noqa: F401
        from mcp import ClientSession  # noqa: F401
        from mcp.client.stdio import stdio_client  # noqa: F401
        return True
    except Exception:
        return False


class GrowwBridge:
    """Synchronous facade over an async MCP session living in a daemon thread."""

    def __init__(self) -> None:
        self._loop: asyncio.AbstractEventLoop | None = None
        self._thread: threading.Thread | None = None
        self._jobs: asyncio.Queue | None = None
        self._ready = threading.Event()          # loop + session are live
        self._shutdown = threading.Event()
        self._lock = threading.Lock()
        self.status = GrowwStatus(
            mcp_available=_mcp_importable(),
            node_available=shutil.which("npx") is not None)

    # ---- public sync API -------------------------------------------------
    def connect(self) -> bool:
        """Spawn the Node MCP server and open a session. Blocks until ready or
        the OAuth/connect window times out. Idempotent."""
        with self._lock:
            if self.status.connected:
                return True
            if not self.status.ready_to_connect:
                self.status.last_error = (
                    "Prerequisites missing — " + self.status.install_hint)
                return False
            self.status.connecting = True
            self.status.last_error = ""
            self._ready.clear()
            self._shutdown.clear()
            self._thread = threading.Thread(
                target=self._run_thread, name="groww-mcp", daemon=True)
            self._thread.start()

        ok = self._ready.wait(timeout=CONNECT_TIMEOUT)
        self.status.connecting = False
        if not ok and not self.status.last_error:
            self.status.last_error = (
                "Timed out waiting for Groww OAuth / server start. Complete the "
                "login in the browser window, then try again.")
        return self.status.connected

    def fetch_holdings(self) -> list[Holding]:
        """Pull live equity holdings from Groww and map to ARTHA Holdings."""
        if not self.status.connected:
            if not self.connect():
                return []
        tool = self._pick_tool(_HOLDINGS_HINTS)
        if not tool:
            self.status.last_error = (
                "Connected, but no holdings/portfolio tool was exposed by the "
                f"Groww MCP server. Tools seen: {', '.join(self.status.tools) or '—'}")
            return []
        try:
            raw = self._call(tool, {})
        except Exception as exc:                       # noqa: BLE001
            self.status.last_error = f"Groww tool '{tool}' failed: {exc}"
            log.warning(self.status.last_error)
            return []
        holdings = _parse_holdings(raw)
        self.status.holdings_count = len(holdings)
        return holdings

    def raw_portfolio_text(self) -> str:
        """A compact text dump of holdings + positions for the AI agent."""
        lines: list[str] = []
        for hint, label in ((_HOLDINGS_HINTS, "HOLDINGS"),
                            (_POSITIONS_HINTS, "POSITIONS/F&O")):
            tool = self._pick_tool(hint)
            if not tool:
                continue
            try:
                raw = self._call(tool, {})
            except Exception as exc:                   # noqa: BLE001
                lines.append(f"[Groww {label}] tool error: {exc}")
                continue
            lines.append(f"[Groww {label} via {tool}] {_stringify(raw)[:1500]}")
        return "\n".join(lines)

    def disconnect(self) -> None:
        self._shutdown.set()
        if self._loop and self._loop.is_running():
            self._loop.call_soon_threadsafe(lambda: None)
        self.status.connected = False
        self.status.tools = []

    # ---- internals -------------------------------------------------------
    def _pick_tool(self, hints: tuple[str, ...]) -> str | None:
        low = {t.lower(): t for t in self.status.tools}
        for hint in hints:
            for lname, orig in low.items():
                if hint in lname:
                    return orig
        return None

    def _call(self, tool: str, args: dict[str, Any]) -> Any:
        if not self._loop:
            raise RuntimeError("Groww bridge loop not running.")
        fut = self._submit(lambda session: session.call_tool(tool, args))
        result = fut.result(timeout=CALL_TIMEOUT)
        return _unwrap_tool_result(result)

    def _submit(self, make_coro: Callable[[Any], Any]) -> Future:
        """Hand a job to the session-owning loop; returns a concurrent Future."""
        assert self._loop and self._jobs is not None
        box: Future = Future()

        async def _enqueue() -> None:
            await self._jobs.put((make_coro, box))

        asyncio.run_coroutine_threadsafe(_enqueue(), self._loop)
        return box

    def _run_thread(self) -> None:
        try:
            asyncio.run(self._session_main())
        except Exception as exc:                        # noqa: BLE001
            self.status.last_error = f"Groww MCP session error: {exc}"
            log.warning(self.status.last_error)
        finally:
            self.status.connected = False
            self._ready.set()   # unblock connect() even on failure

    async def _session_main(self) -> None:
        """Own the loop: open the MCP session, then service jobs until shutdown."""
        from mcp import ClientSession, StdioServerParameters
        from mcp.client.stdio import stdio_client

        self._loop = asyncio.get_running_loop()
        self._jobs = asyncio.Queue()

        params = StdioServerParameters(
            command="npx",
            args=["-y", NPM_PACKAGE, MCP_URL, OAUTH_PORT])

        async with stdio_client(params) as (read, write):
            async with ClientSession(read, write) as session:
                await session.initialize()
                listed = await session.list_tools()
                self.status.tools = [t.name for t in listed.tools]
                self.status.connected = True
                self.status.last_error = ""
                log.info("Groww MCP connected; tools: %s", self.status.tools)
                self._ready.set()

                while not self._shutdown.is_set():
                    try:
                        make_coro, box = await asyncio.wait_for(
                            self._jobs.get(), timeout=1.0)
                    except asyncio.TimeoutError:
                        continue
                    try:
                        box.set_result(await make_coro(session))
                    except Exception as exc:            # noqa: BLE001
                        box.set_exception(exc)


# --------------------------- result parsing -------------------------------
def _unwrap_tool_result(result: Any) -> Any:
    """MCP CallToolResult → the useful payload (parsed JSON if possible)."""
    content = getattr(result, "content", result)
    if isinstance(content, list):
        texts = []
        for block in content:
            txt = getattr(block, "text", None)
            if txt is not None:
                texts.append(txt)
            else:
                data = getattr(block, "data", None)
                if data is not None:
                    texts.append(str(data))
        joined = "\n".join(texts)
        try:
            return json.loads(joined)
        except Exception:
            return joined
    return content


def _stringify(raw: Any) -> str:
    if isinstance(raw, (dict, list)):
        try:
            return json.dumps(raw, ensure_ascii=False)
        except Exception:
            return str(raw)
    return str(raw)


def _rows_from(raw: Any) -> list[dict]:
    """Dig a list-of-dicts out of whatever shape the tool returned."""
    if isinstance(raw, list):
        return [r for r in raw if isinstance(r, dict)]
    if isinstance(raw, dict):
        for key in ("holdings", "data", "payload", "result", "items", "stocks"):
            val = raw.get(key)
            if isinstance(val, list):
                return [r for r in val if isinstance(r, dict)]
            if isinstance(val, dict):
                nested = _rows_from(val)
                if nested:
                    return nested
    return []


def _first(row: dict, *keys: str, default: Any = None) -> Any:
    for k in keys:
        if k in row and row[k] not in (None, ""):
            return row[k]
    return default


def _num(val: Any) -> float:
    try:
        return float(str(val).replace(",", ""))
    except (TypeError, ValueError):
        return 0.0


def _parse_holdings(raw: Any) -> list[Holding]:
    """Tolerant map of Groww holding rows → ARTHA Holding objects.

    Groww's exact field names aren't published, so we accept the common
    broker-API spellings (tradingSymbol/symbol, quantity/qty, averagePrice…).
    """
    out: list[Holding] = []
    for row in _rows_from(raw):
        symbol = str(_first(row, "tradingSymbol", "trading_symbol", "symbol",
                             "nseScriptCode", "bseScriptCode", default="")).strip()
        name = str(_first(row, "companyName", "company_name", "name", "scripName",
                           default=symbol or "Groww holding")).strip()
        qty = _num(_first(row, "quantity", "qty", "netQuantity", "holdingsQuantity",
                          default=0))
        avg = _num(_first(row, "averagePrice", "avgPrice", "average_price",
                          "buyPrice", "costPrice", default=0))
        ltp = _num(_first(row, "ltp", "lastPrice", "currentPrice", "marketPrice",
                          default=0))
        if not name and not symbol:
            continue
        yf_symbol = symbol
        if symbol and not symbol.endswith((".NS", ".BO")):
            yf_symbol = f"{symbol}.NS"      # NSE default for Yahoo quotes
        h = Holding(
            symbol=yf_symbol, name=name, asset_class=AssetClass.EQUITY,
            qty=qty, avg_buy_price=avg, buy_date=date.today(), sector="—",
            isin=str(_first(row, "isin", "isinCode", default="")))
        if ltp:
            h.current_price = ltp
        out.append(h)
    return out


# --------------------------- singleton ------------------------------------
_BRIDGE: GrowwBridge | None = None


def get_bridge() -> GrowwBridge:
    """Process-wide singleton. In Streamlit, wrap with st.cache_resource so the
    live session survives script reruns."""
    global _BRIDGE
    if _BRIDGE is None:
        _BRIDGE = GrowwBridge()
    return _BRIDGE

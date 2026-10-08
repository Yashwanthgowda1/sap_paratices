"""
Permission manager: asks user before applying to each job.
Shows a rich terminal table and waits for y/n/s input.
"""

from __future__ import annotations

from typing import Dict, Optional

try:
    from rich.console import Console
    from rich.table import Table
    from rich.prompt import Prompt
    _HAS_RICH = True
except ImportError:
    _HAS_RICH = False

from ..logger import start_logging
from ..utils.data_store import log_application

logger = start_logging("permission_manager")
_console = Console() if _HAS_RICH else None


def ask_permission(job: Dict) -> str:
    """
    Show job details and ask user: apply / skip / stop.
    Returns: 'apply' | 'skip' | 'stop'
    """
    _print_job_card(job)
    while True:
        raw = input(
            "\n  [y] Apply    [n] Skip    [s] Stop all applications\n  Your choice: "
        ).strip().lower()
        if raw in ("y", "yes"):
            return "apply"
        if raw in ("n", "no"):
            return "skip"
        if raw in ("s", "stop", "q", "quit"):
            return "stop"
        print("  Please enter y, n, or s.")


def notify_login_required(site: str) -> None:
    print(f"\n{'='*60}")
    print(f"  ⚠  LOGIN REQUIRED: {site}")
    print(f"  The browser opened the {site} login page.")
    print(f"  Please log in manually, then come back here.")
    print(f"{'='*60}")
    choice = input("  [Enter] I have logged in    [s] Skip this site: ").strip().lower()
    if choice in ("s", "skip"):
        raise RuntimeError(f"User skipped login for {site}")


def notify_review_before_submit(job: Dict) -> str:
    """Called just before final Submit button — lets user review filled form."""
    print(f"\n{'='*60}")
    print(f"  ✅  FORM FILLED: {job.get('title')} at {job.get('company')}")
    print(f"  The application form has been auto-filled.")
    print(f"  Please REVIEW the form in the browser before submitting.")
    print(f"{'='*60}")
    while True:
        raw = input("  [y] Submit now    [n] I'll submit manually    [s] Skip this job: ").strip().lower()
        if raw in ("y", "yes"):
            return "submit"
        if raw in ("n", "no"):
            return "manual"
        if raw in ("s", "skip"):
            return "skip"
        print("  Please enter y, n, or s.")


def record_decision(job: Dict, decision: str) -> None:
    if decision == "apply":
        log_application(job, status="Applied")
        logger.info(f"Applied: {job.get('title')} at {job.get('company')}")
    elif decision == "skip":
        logger.info(f"Skipped: {job.get('title')} at {job.get('company')}")
    elif decision == "stop":
        logger.info("User stopped application process.")


def _print_job_card(job: Dict) -> None:
    sep = "─" * 60
    print(f"\n{sep}")
    print(f"  🏢  {job.get('company', 'Unknown Company')}")
    print(f"  💼  {job.get('title', 'Unknown Title')}")
    print(f"  📍  {job.get('location', '')}")
    print(f"  💰  {job.get('salary', 'Not specified')}")
    print(f"  ⏱   Posted: {job.get('posted_ago', 'Recently')}")
    print(f"  🎯  Match: {job.get('match_percent', '?')}%  |  Interview chance: {job.get('interview_chance', '?')}%")
    print(f"  🔗  {job.get('apply_url', 'No URL')}")
    if job.get("missing_skills"):
        print(f"  ❌  Missing skills: {', '.join(job['missing_skills'][:5])}")
    print(sep)

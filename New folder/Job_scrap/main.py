"""
CLI entry point for the SDET/QA Job Scraper.

Usage:
  python main.py dashboard              → Start Flask server + open browser
  python main.py scrape                 → Scrape all sources
  python main.py scrape --source linkedin
  python main.py analyze path/to/resume.pdf
  python main.py apply                  → Interactive per-job apply flow
  python main.py companies              → List all 200+ registered companies
"""

from __future__ import annotations

import argparse
import sys
import webbrowser
from pathlib import Path

# Fix Windows cp1252 terminal encoding so emoji in print() don't crash
if sys.stdout.encoding and sys.stdout.encoding.lower() not in ("utf-8", "utf-16"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")

ROOT = Path(__file__).resolve().parent
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from job_scraper.logger import start_logging

logger = start_logging("main")


def cmd_dashboard(args) -> None:
    port = getattr(args, "port", 5000)
    url = f"http://127.0.0.1:{port}"
    print(f"\n  🚀  Dashboard starting at {url}")
    print(f"  Open this URL in your browser (or it opens automatically).\n")
    import threading
    threading.Timer(1.5, lambda: webbrowser.open(url)).start()
    from server.app import run_server
    run_server(port=port)


def cmd_scrape(args) -> None:
    source = getattr(args, "source", "all")
    max_jobs = getattr(args, "max", 200)

    from job_scraper.utils.data_store import save_jobs, load_resume_cache
    from job_scraper.utils.link_validator import validate_jobs
    from job_scraper.resume.matcher import match_jobs, analyze_jobs_with_ai

    all_jobs: list = []

    scraper_map = {
        "linkedin": _scrape_linkedin,
        "naukri": _scrape_naukri,
        "indeed": _scrape_indeed,
        "google": _scrape_google,
        "company": _scrape_company,
        "apify": _scrape_apify,
    }

    sources_to_run = list(scraper_map.keys()) if source == "all" else [source]

    for src in sources_to_run:
        fn = scraper_map.get(src)
        if not fn:
            print(f"  Unknown source: {src}")
            continue
        print(f"\n  🔍  Scraping {src}...")
        try:
            jobs = fn(max_jobs)
            all_jobs.extend(jobs)
            print(f"  ✅  {src}: {len(jobs)} jobs")
        except Exception as e:
            print(f"  ❌  {src} failed: {e}")
            logger.error(f"{src} scrape error", exc_info=True)

    print(f"\n  🔗  Validating {len(all_jobs)} links...")
    all_jobs = validate_jobs(all_jobs)

    resume_data = load_resume_cache()
    if resume_data:
        print(f"  🤖  Running AI match against resume...")
        all_jobs = match_jobs(resume_data, all_jobs)
    else:
        print(f"  ℹ   No resume cached — run 'python main.py analyze <resume>' first for match scores.")

    print(f"  🧠  Running AI JD relevance filter...")
    all_jobs = analyze_jobs_with_ai(all_jobs, resume_data)

    save_jobs(all_jobs)
    valid = sum(1 for j in all_jobs if j.get("link_valid"))
    high = sum(1 for j in all_jobs if (j.get("match_percent") or 0) >= 75)
    print(f"\n  ✅  Done: {len(all_jobs)} jobs saved ({valid} valid links, {high} high-match)")


def _scrape_linkedin(max_jobs: int) -> list:
    from job_scraper.scrapers.linkedin_scraper import LinkedInScraper
    return LinkedInScraper().scrape(max_jobs=min(max_jobs, 100))


def _scrape_naukri(max_jobs: int) -> list:
    from job_scraper.scrapers.naukri_scraper import NaukriScraper
    return NaukriScraper().scrape(max_jobs=min(max_jobs, 80))


def _scrape_indeed(max_jobs: int) -> list:
    from job_scraper.scrapers.indeed_scraper import IndeedScraper
    return IndeedScraper().scrape(max_jobs=min(max_jobs, 60))


def _scrape_google(max_jobs: int) -> list:
    from job_scraper.scrapers.google_jobs_scraper import GoogleJobsScraper
    return GoogleJobsScraper().scrape(max_jobs=min(max_jobs, 80))


def _scrape_company(max_jobs: int) -> list:
    from job_scraper.scrapers.company_scraper import CompanyScraper
    return CompanyScraper().scrape(max_total=min(max_jobs, 150))


def _scrape_apify(max_jobs: int) -> list:
    from job_scraper.scrapers.apify_scraper import ApifyScraper
    return ApifyScraper().scrape(max_jobs=min(max_jobs, 100))


def cmd_analyze(args) -> None:
    resume_path = Path(args.resume)
    if not resume_path.exists():
        print(f"  ❌  File not found: {resume_path}")
        sys.exit(1)

    print(f"\n  📎  Parsing resume: {resume_path.name}...")
    from job_scraper.resume.parser import extract_text
    from job_scraper.resume.ats_scorer import score_resume
    from job_scraper.utils.data_store import save_resume_cache
    import json

    text = extract_text(resume_path)
    data = score_resume(text)
    save_resume_cache(data)

    print(f"\n  ✅  Resume parsed successfully:")
    print(f"      Name:         {data.get('name', 'Unknown')}")
    print(f"      Experience:   {data.get('total_years', '?')} years")
    print(f"      Level:        {data.get('career_level', '?')}")
    print(f"      ATS Score:    {data.get('ats_score', '?')}/100")
    print(f"      Skills ({len(data.get('skills', []))}): {', '.join(data.get('skills', [])[:10])}")
    print(f"\n  💾  Cached to data/resume_cache.json")


def cmd_apply(args) -> None:
    from job_scraper.utils.data_store import load_jobs, load_resume_cache
    from job_scraper.applier.permission_manager import ask_permission, record_decision
    from job_scraper.applier.linkedin_applier import LinkedInApplier
    from job_scraper.applier.company_applier import CompanyApplier

    jobs = load_jobs()
    resume_data = load_resume_cache()

    if not jobs:
        print("  ❌  No jobs found. Run 'python main.py scrape' first.")
        sys.exit(1)
    if not resume_data:
        print("  ⚠   No resume cached. Run 'python main.py analyze <resume>' for better auto-fill.")

    # Only apply to valid, high-match jobs
    candidates = [j for j in jobs if j.get("link_valid") and (j.get("match_percent", 0) >= 50)]
    candidates.sort(key=lambda j: j.get("match_percent", 0), reverse=True)

    print(f"\n  🎯  {len(candidates)} jobs qualify (valid link + ≥50% match)")
    print(f"  You will be asked to confirm each application before the browser opens.\n")

    for job in candidates:
        decision = ask_permission(job)
        if decision == "stop":
            print("\n  🛑  Stopped.")
            break
        if decision == "skip":
            record_decision(job, "skip")
            continue

        # Apply
        record_decision(job, "apply")
        src = job.get("source", "")
        if src == "linkedin":
            applier = LinkedInApplier()
        else:
            applier = CompanyApplier()

        try:
            result = applier.apply(job, resume_data)
            print(f"\n  Result: {result}")
        except Exception as e:
            print(f"\n  ❌  Apply error: {e}")


def cmd_all(args) -> None:
    import types
    print("\n  ========== STEP 1: Companies ==========")
    cmd_companies(args)

    print("\n  ========== STEP 2: Scrape Jobs ==========")
    scrape_args = types.SimpleNamespace(source="all", max=200)
    cmd_scrape(scrape_args)

    print("\n  ========== STEP 3: Dashboard ==========")
    dash_args = types.SimpleNamespace(port=getattr(args, "port", 5000))
    cmd_dashboard(dash_args)


def cmd_companies(args) -> None:
    from job_scraper.companies import COMPANIES
    from collections import Counter
    tiers = Counter(c.tier for c in COMPANIES)
    print(f"\n  Total companies: {len(COMPANIES)}\n")
    for tier, count in sorted(tiers.items()):
        companies = [c.name for c in COMPANIES if c.tier == tier]
        print(f"  {tier} ({count}):")
        for name in companies:
            print(f"    · {name}")
        print()


# ── CLI setup ─────────────────────────────────────────────────────────────────

def main() -> None:
    parser = argparse.ArgumentParser(
        prog="job_scraper",
        description="SDET/QA Job Search & Application Automation",
    )
    sub = parser.add_subparsers(dest="command")

    # all
    al = sub.add_parser("all", help="Run companies → scrape → dashboard in one go")
    al.add_argument("--port", type=int, default=5000)

    # dashboard
    d = sub.add_parser("dashboard", help="Start web dashboard")
    d.add_argument("--port", type=int, default=5000)

    # scrape
    s = sub.add_parser("scrape", help="Scrape job listings")
    s.add_argument("--source", default="all", choices=["all", "linkedin", "naukri", "indeed", "google", "company", "apify"])
    s.add_argument("--max", type=int, default=200, help="Max jobs per source")

    # analyze
    a = sub.add_parser("analyze", help="Parse and ATS-score your resume")
    a.add_argument("resume", help="Path to resume (PDF/DOCX/TXT)")

    # apply
    sub.add_parser("apply", help="Interactive per-job application flow")

    # companies
    sub.add_parser("companies", help="List all registered companies")

    args = parser.parse_args()

    handlers = {
        "all": cmd_all,
        "dashboard": cmd_dashboard,
        "scrape": cmd_scrape,
        "analyze": cmd_analyze,
        "apply": cmd_apply,
        "companies": cmd_companies,
    }

    if not args.command:
        parser.print_help()
        sys.exit(0)

    handlers[args.command](args)


if __name__ == "__main__":
    main()

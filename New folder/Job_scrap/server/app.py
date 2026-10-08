"""
Flask backend: serves the dashboard and REST API endpoints.
Supports real-time scraping progress via Socket.IO.
"""

from __future__ import annotations

import sys
import time
import threading
from pathlib import Path

# Make job_scraper importable from the Job_scrap root
ROOT = Path(__file__).resolve().parent.parent
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from flask import Flask, jsonify, request, send_from_directory
from flask_cors import CORS
from flask_socketio import SocketIO

from job_scraper.logger import start_logging
from job_scraper.utils.data_store import (
    load_applied,
    load_jobs,
    load_resume_cache,
    save_jobs,
    save_resume_cache,
    update_application_status,
)

logger = start_logging("server")

DASHBOARD_DIR = ROOT / "dashboard"
app = Flask(__name__, static_folder=str(DASHBOARD_DIR))
CORS(app)
socketio = SocketIO(app, cors_allowed_origins="*", async_mode="threading")

_scrape_running = threading.Event()


def _emit_log(msg: str, level: str = "info") -> None:
    socketio.emit("log", {"msg": msg, "level": level})


# ── Static dashboard ──────────────────────────────────────────────────────────

@app.route("/")
def index():
    return send_from_directory(str(DASHBOARD_DIR), "index.html")


# ── Jobs API ──────────────────────────────────────────────────────────────────

@app.route("/api/jobs")
def get_jobs():
    jobs = load_jobs()
    source_filter = request.args.get("source")
    rec_filter = request.args.get("recommendation")
    if source_filter and source_filter != "all":
        jobs = [j for j in jobs if j.get("source") == source_filter]
    if rec_filter:
        jobs = [j for j in jobs if j.get("recommendation") == rec_filter]
    return jsonify(jobs)


@app.route("/api/stats")
def get_stats():
    jobs = load_jobs()
    applied = load_applied()
    sources = {"linkedin": 0, "naukri": 0, "indeed": 0, "google": 0, "company": 0}
    total = valid = high_match = broken = 0
    for j in jobs:
        total += 1
        src = j.get("source", "")
        if src in sources:
            sources[src] += 1
        if j.get("link_valid"):
            valid += 1
        else:
            broken += 1
        if (j.get("match_percent") or 0) >= 75:
            high_match += 1
    return jsonify({
        "total": total,
        "valid_links": valid,
        "high_match": high_match,
        "broken": broken,
        "applied": len(applied),
        "sources": sources,
    })


@app.route("/api/jobs", methods=["DELETE"])
def clear_jobs():
    save_jobs([])
    return jsonify({"ok": True, "message": "All job data cleared."})


@app.route("/api/tracker")
def get_tracker():
    return jsonify(load_applied())


@app.route("/api/tracker/<job_id>", methods=["PATCH"])
def update_tracker(job_id: str):
    data = request.get_json() or {}
    status = data.get("status")
    if status:
        update_application_status(job_id, status)
    return jsonify({"ok": True})


# ── Resume API ────────────────────────────────────────────────────────────────

@app.route("/api/analyze-resume", methods=["POST"])
def analyze_resume():
    if "file" not in request.files:
        return jsonify({"error": "No file provided"}), 400

    import os
    import tempfile
    file = request.files["file"]
    suffix = Path(file.filename).suffix if file.filename else ".pdf"
    with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as tmp:
        file.save(tmp.name)
        tmp_path = tmp.name

    try:
        from job_scraper.resume.parser import extract_text
        from job_scraper.resume.ats_scorer import score_resume
        text = extract_text(tmp_path)
        result = score_resume(text)
        save_resume_cache(result)
        return jsonify(result)
    except Exception as e:
        logger.error(f"Resume analysis error: {e}")
        return jsonify({"error": str(e)}), 500
    finally:
        os.unlink(tmp_path)


@app.route("/api/resume-cache")
def get_resume_cache():
    return jsonify(load_resume_cache())


# ── Scrape trigger ────────────────────────────────────────────────────────────

@app.route("/api/scrape", methods=["POST"])
def trigger_scrape():
    if _scrape_running.is_set():
        return jsonify({"status": "already_running"}), 409

    data = request.get_json() or {}
    sources = data.get("sources", ["linkedin", "naukri", "indeed", "google", "apify", "company"])

    def _run():
        _scrape_running.set()
        try:
            from job_scraper.scrapers.linkedin_scraper import LinkedInScraper
            from job_scraper.scrapers.naukri_scraper import NaukriScraper
            from job_scraper.scrapers.indeed_scraper import IndeedScraper
            from job_scraper.scrapers.google_jobs_scraper import GoogleJobsScraper
            from job_scraper.scrapers.company_scraper import CompanyScraper
            from job_scraper.scrapers.apify_scraper import ApifyScraper
            from job_scraper.utils.link_validator import validate_jobs
            from job_scraper.resume.matcher import match_jobs, analyze_jobs_with_ai

            all_jobs = []
            resume_data = load_resume_cache()

            scraper_map = {
                "linkedin": (LinkedInScraper, {"max_jobs": 80}),
                "naukri": (NaukriScraper, {"max_jobs": 80}),
                "indeed": (IndeedScraper, {"max_jobs": 60}),
                "google": (GoogleJobsScraper, {"max_jobs": 80}),
                "company": (CompanyScraper, {"max_total": 100}),
                "apify": (ApifyScraper, {"max_jobs": 100}),
            }

            for src in sources:
                if src not in scraper_map:
                    continue
                try:
                    _emit_log(f"🔍 Scraping {src}...", "info")
                    ScraperClass, kwargs = scraper_map[src]
                    scraper_obj = ScraperClass()
                    jobs = scraper_obj.scrape(**kwargs)
                    all_jobs.extend(jobs)
                    _emit_log(f"✅ {src}: {len(jobs)} jobs found", "ok")
                except Exception as e:
                    _emit_log(f"❌ {src} failed: {e}", "err")
                    logger.error(f"{src} scraper error", exc_info=True)
                finally:
                    time.sleep(2)  # let Chrome fully release profile lock

            _emit_log(f"🔗 Validating {len(all_jobs)} job links...", "info")
            all_jobs = validate_jobs(all_jobs)

            if resume_data:
                _emit_log("🤖 Running AI matching...", "info")
                all_jobs = match_jobs(resume_data, all_jobs)

            _emit_log("🧠 Running AI JD relevance filter...", "info")
            all_jobs = analyze_jobs_with_ai(all_jobs, resume_data)

            save_jobs(all_jobs)
            _emit_log(f"✅ Complete: {len(all_jobs)} jobs saved.", "ok")
            socketio.emit("scrape_complete", {"count": len(all_jobs)})
        except Exception as e:
            _emit_log(f"Fatal scrape error: {e}", "err")
        finally:
            _scrape_running.clear()

    t = threading.Thread(target=_run, daemon=True)
    t.start()
    return jsonify({"status": "started"})


# ── Cover letter ──────────────────────────────────────────────────────────────

@app.route("/api/cover-letter/<job_id>")
def get_cover_letter(job_id: str):
    jobs = load_jobs()
    job = next((j for j in jobs if j.get("id") == job_id), None)
    if not job:
        return jsonify({"error": "Job not found"}), 404
    resume_data = load_resume_cache()
    try:
        from job_scraper.ai_client import AIClient
        ai = AIClient()
        letter = ai.generate_cover_letter(resume_data, job)
        return jsonify({"cover_letter": letter})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


def run_server(host: str = "127.0.0.1", port: int = 5000, debug: bool = False) -> None:
    logger.info(f"Starting dashboard server at http://{host}:{port}")
    socketio.run(app, host=host, port=port, debug=debug)

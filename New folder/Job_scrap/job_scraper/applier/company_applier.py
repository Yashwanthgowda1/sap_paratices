"""
Generic company career page form filler using Selenium (headed Chrome).
Fills form fields, uploads resume, pauses before Submit.
"""

from __future__ import annotations

import time
from pathlib import Path
from typing import Dict

from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select

from ..constants import RESUME_FIELD_MAP
from ..logger import start_logging
from ..scrapers.base_scraper import BaseScraper
from .permission_manager import notify_login_required, notify_review_before_submit

logger = start_logging("company_applier")


def _get_value(resume_data: Dict, field_key: str) -> str:
    from ..config import get_config
    cfg = get_config()
    mapping = {
        "first name": lambda r: (r.get("name", "") or "").split()[0],
        "last name": lambda r: (r.get("name", "") or "").split()[-1],
        "full name": lambda r: r.get("name", ""),
        "name": lambda r: r.get("name", ""),
        "email": lambda r: r.get("email", ""),
        "phone": lambda r: r.get("phone", ""),
        "mobile": lambda r: r.get("phone", ""),
        "years of experience": lambda r: str(r.get("total_years", 4)),
        "years": lambda r: str(r.get("total_years", 4)),
        "experience": lambda r: str(r.get("total_years", 4)),
        "city": lambda r: cfg.job_location.split(",")[0].strip(),
        "location": lambda r: cfg.job_location,
        "linkedin": lambda r: "",
        "github": lambda r: "",
        "portfolio": lambda r: "",
    }
    fn = mapping.get(field_key.lower())
    return fn(resume_data) if fn else ""


class CompanyApplier(BaseScraper):
    def __init__(self) -> None:
        super().__init__(headless=False)

    def apply(self, job: Dict, resume_data: Dict, cover_letter: str = "") -> str:
        """Returns 'applied' | 'manual' | 'skip' | 'error'."""
        url = job.get("apply_url", "")
        if not url:
            return "error"

        with self:
            try:
                return self._do_apply(job, resume_data, cover_letter, url)
            except Exception as e:
                logger.error(f"Apply failed for {job.get('title')}: {e}")
                return "error"

    def _do_apply(self, job: Dict, resume_data: Dict, cover_letter: str, url: str) -> str:
        logger.info(f"Opening: {url}")
        self.goto(url)
        time.sleep(2)

        if self.is_login_page():
            try:
                notify_login_required(job.get("company", "this site"))
            except RuntimeError:
                return "skip"

        self._fill_form(resume_data, cover_letter)
        time.sleep(1)

        decision = notify_review_before_submit(job)
        if decision == "submit":
            if self._click_submit():
                logger.info(f"Submitted: {job.get('title')} at {job.get('company')}")
                return "applied"
            logger.warning("Submit button not found — returning manual.")
            return "manual"
        if decision == "manual":
            input("  Take your time reviewing. Press Enter when done... ")
            return "manual"
        return "skip"

    def _fill_form(self, resume_data: Dict, cover_letter: str) -> None:
        inputs = self.driver.find_elements(
            By.CSS_SELECTOR,
            "input:not([type=hidden]):not([type=file]):not([type=submit]):not([type=button]), textarea"
        )
        for inp in inputs:
            try:
                label = self._get_label(inp)
                if not label:
                    continue
                label_lower = label.lower()
                for field_key in RESUME_FIELD_MAP:
                    if field_key in label_lower:
                        value = _get_value(resume_data, field_key)
                        if value and not inp.get_attribute("value"):
                            inp.clear()
                            inp.send_keys(value)
                        break
                if cover_letter and any(kw in label_lower for kw in ("cover", "letter", "why", "message")):
                    if not inp.get_attribute("value"):
                        inp.clear()
                        inp.send_keys(cover_letter)
            except Exception:
                pass

        resume_path = Path(self.cfg.resume_path)
        if resume_path.exists():
            for fi in self.driver.find_elements(By.CSS_SELECTOR, "input[type=file]"):
                try:
                    fi.send_keys(str(resume_path.resolve()))
                    time.sleep(1)
                except Exception:
                    pass

    def _get_label(self, el) -> str:
        try:
            el_id = el.get_attribute("id")
            if el_id:
                labels = self.driver.find_elements(By.CSS_SELECTOR, f"label[for='{el_id}']")
                if labels:
                    return labels[0].text.strip()
        except Exception:
            pass
        for attr in ("aria-label", "placeholder", "name"):
            try:
                val = el.get_attribute(attr)
                if val:
                    return val.strip()
            except Exception:
                pass
        return ""

    def _click_submit(self) -> bool:
        keywords = ["submit application", "apply now", "send application", "submit", "apply"]
        for kw in keywords:
            for btn in self.driver.find_elements(By.XPATH, f"//button[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), '{kw}')]"):
                try:
                    self.driver.execute_script("arguments[0].click();", btn)
                    time.sleep(2)
                    return True
                except Exception:
                    pass
        return False

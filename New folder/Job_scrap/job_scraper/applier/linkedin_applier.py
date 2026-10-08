"""
LinkedIn Easy Apply automation.
Walks through multi-step modal, fills fields, pauses before final Submit.
Adapted from existing LINKED_IN_AUTOMATION.py patterns in this workspace.
"""

from __future__ import annotations

import time
from pathlib import Path
from typing import Dict

from selenium.common.exceptions import NoSuchElementException, TimeoutException
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support import expected_conditions as EC

from ..config import get_config
from ..logger import start_logging
from ..scrapers.base_scraper import BaseScraper
from .permission_manager import notify_login_required, notify_review_before_submit

logger = start_logging("linkedin_applier")
MAX_STEPS = 25


class LinkedInApplier(BaseScraper):
    def __init__(self) -> None:
        super().__init__(headless=False)
        self.cfg = get_config()

    def apply(self, job: Dict, resume_data: Dict) -> str:
        """Returns 'applied' | 'manual' | 'skip' | 'error'."""
        apply_url = job.get("apply_url", "")
        if not apply_url:
            logger.warning(f"No URL for {job.get('title')}")
            return "error"

        with self:
            return self._do_apply(job, resume_data, apply_url)

    def _do_apply(self, job: Dict, resume_data: Dict, url: str) -> str:
        self.goto(url)
        time.sleep(3)

        if self.is_login_page():
            try:
                notify_login_required("LinkedIn")
            except RuntimeError:
                return "skip"
            self.goto(url)
            time.sleep(3)

        # Try to click Easy Apply button
        easy_btn = self._find_easy_apply_button()
        if not easy_btn:
            logger.info(f"No Easy Apply button — opening external link: {url}")
            return "manual"

        self.safe_click(easy_btn)
        time.sleep(2)
        return self._walk_modal(resume_data, job)

    def _find_easy_apply_button(self):
        selectors = [
            "button.jobs-apply-button",
            "button[aria-label*='Easy Apply']",
            "button.jobs-s-apply button",
            ".jobs-apply-button--top-card button",
        ]
        for sel in selectors:
            el = self.safe_find(By.CSS_SELECTOR, sel)
            if el:
                return el
        return None

    def _walk_modal(self, resume_data: Dict, job: Dict) -> str:
        for step in range(MAX_STEPS):
            time.sleep(1.5)

            # Check if submit button is present (last step)
            submit_btn = self._find_submit_button()
            if submit_btn:
                decision = notify_review_before_submit(job)
                if decision == "submit":
                    self.safe_click(submit_btn)
                    time.sleep(2)
                    logger.info(f"✅ Submitted application for {job.get('title')} at {job.get('company')}")
                    return "applied"
                elif decision == "manual":
                    return "manual"
                else:
                    return "skip"

            # Fill visible form fields
            self._fill_current_step(resume_data)

            # Click Next / Continue
            next_btn = self._find_next_button()
            if next_btn:
                self.safe_click(next_btn)
            else:
                logger.debug(f"Step {step}: no Next button found.")
                break

        return "manual"

    def _fill_current_step(self, resume_data: Dict) -> None:
        inputs = self.driver.find_elements(By.CSS_SELECTOR, "input:not([type=hidden]), textarea")
        for inp in inputs:
            try:
                label = self._get_label_for(inp).lower()
                value = self._infer_value(label, resume_data)
                if value and not inp.get_attribute("value"):
                    inp.clear()
                    inp.send_keys(value)
            except Exception:
                pass

        # Handle radio/select for common questions
        self._handle_selects(resume_data)
        # Upload resume file if prompted
        self._handle_file_upload()

    def _get_label_for(self, el) -> str:
        try:
            el_id = el.get_attribute("id")
            if el_id:
                label = self.driver.find_element(By.CSS_SELECTOR, f"label[for='{el_id}']")
                return label.text
        except Exception:
            pass
        try:
            return el.get_attribute("aria-label") or el.get_attribute("placeholder") or ""
        except Exception:
            return ""

    def _infer_value(self, label: str, resume_data: Dict) -> str:
        cfg = get_config()
        mapping = {
            "first name": resume_data.get("name", "").split()[0] if resume_data.get("name") else "",
            "last name": resume_data.get("name", "").split()[-1] if resume_data.get("name") else "",
            "name": resume_data.get("name", ""),
            "full name": resume_data.get("name", ""),
            "email": resume_data.get("email", ""),
            "phone": resume_data.get("phone", ""),
            "mobile": resume_data.get("phone", ""),
            "city": cfg.job_location.split(",")[0],
            "location": cfg.job_location,
            "linkedin": "",
            "years": str(resume_data.get("total_years", 4)),
            "experience": str(resume_data.get("total_years", 4)),
        }
        for key, val in mapping.items():
            if key in label and val:
                return val
        return ""

    def _handle_selects(self, resume_data: Dict) -> None:
        selects = self.driver.find_elements(By.TAG_NAME, "select")
        for sel in selects:
            try:
                from selenium.webdriver.support.ui import Select
                s = Select(sel)
                options = [o.text.lower() for o in s.options]
                # For yes/no questions about authorization, citizenship etc.
                if any("yes" in o for o in options):
                    s.select_by_visible_text(
                        next(o for o in s.options if "yes" in o.text.lower()).text
                    )
            except Exception:
                pass

    def _handle_file_upload(self) -> None:
        cfg = get_config()
        resume_path = Path(cfg.resume_path)
        if not resume_path.exists():
            return
        file_inputs = self.driver.find_elements(By.CSS_SELECTOR, "input[type=file]")
        for fi in file_inputs:
            try:
                fi.send_keys(str(resume_path.resolve()))
                time.sleep(1)
            except Exception:
                pass

    def _find_next_button(self):
        labels = ["next", "continue", "review", "save", "proceed"]
        for label in labels:
            try:
                btn = self.driver.find_element(
                    By.XPATH,
                    f"//button[contains(translate(text(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'{label}')]",
                )
                if btn.is_displayed() and btn.is_enabled():
                    return btn
            except Exception:
                pass
        return None

    def _find_submit_button(self):
        labels = ["submit application", "submit", "send application"]
        for label in labels:
            try:
                btn = self.driver.find_element(
                    By.XPATH,
                    f"//button[contains(translate(text(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'{label}')]",
                )
                if btn.is_displayed() and btn.is_enabled():
                    return btn
            except Exception:
                pass
        return None

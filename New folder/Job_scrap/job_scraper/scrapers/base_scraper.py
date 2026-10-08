"""
Base Selenium scraper with anti-detection, login detection, and common helpers.
Adapted from LINKED_IN_AUTOMATION.py patterns in the existing codebase.
"""

from __future__ import annotations

import os
import time
from pathlib import Path
from typing import Optional

from selenium import webdriver
from selenium.common.exceptions import (
    NoSuchElementException,
    StaleElementReferenceException,
    TimeoutException,
    WebDriverException,
)
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait

from ..config import get_config
from ..constants import LOGIN_INDICATORS
from ..logger import start_logging

logger = start_logging("base_scraper")


class BaseScraper:
    def __init__(self, headless: bool = False, profile_suffix: str = "", use_uc: bool = False) -> None:
        self.cfg = get_config()
        self.driver: Optional[webdriver.Chrome] = None
        self.headless = headless
        self._wait_timeout = 15
        self._profile_suffix = profile_suffix
        self._use_uc = use_uc

    # ── Browser lifecycle ─────────────────────────────────────────────────────

    def start(self) -> "BaseScraper":
        base = Path(self.cfg.chrome_profile_dir).resolve()
        profile_dir = str(base / self._profile_suffix if self._profile_suffix else base)
        os.makedirs(profile_dir, exist_ok=True)

        if self._use_uc:
            self._start_uc(profile_dir)
        else:
            self._start_selenium(profile_dir)

        logger.info(f"Browser started ({'undetected' if self._use_uc else 'headed'} Chrome)")
        return self

    def _start_uc(self, profile_dir: str) -> None:
        import undetected_chromedriver as uc
        opts = uc.ChromeOptions()
        opts.add_argument(f"--user-data-dir={profile_dir}")
        opts.add_argument("--profile-directory=Default")
        opts.add_argument("--start-maximized")
        opts.add_argument("--disable-notifications")
        opts.add_argument("--no-first-run")
        opts.add_argument("--no-default-browser-check")
        if self.headless:
            opts.add_argument("--headless=new")
        self.driver = uc.Chrome(options=opts, headless=self.headless, use_subprocess=True)

    def _start_selenium(self, profile_dir: str) -> None:
        opts = Options()
        if self.headless:
            opts.add_argument("--headless=new")
        opts.add_argument("--start-maximized")
        opts.add_argument("--disable-blink-features=AutomationControlled")
        opts.add_experimental_option("excludeSwitches", ["enable-automation"])
        opts.add_experimental_option("useAutomationExtension", False)
        opts.add_argument("--no-sandbox")
        opts.add_argument("--disable-dev-shm-usage")
        opts.add_argument("--disable-notifications")
        opts.add_argument("--no-first-run")
        opts.add_argument("--no-default-browser-check")
        opts.add_argument("--disable-extensions")
        opts.add_argument("--disable-popup-blocking")
        opts.add_argument("--disable-logging")
        opts.add_argument("--log-level=3")
        opts.add_argument("--silent")
        opts.add_experimental_option("excludeSwitches", ["enable-logging"])
        opts.add_argument(f"--user-data-dir={profile_dir}")
        opts.add_argument("--profile-directory=Default")

        try:
            from webdriver_manager.chrome import ChromeDriverManager
            raw = ChromeDriverManager().install()
            # webdriver-manager bug: .install() returns THIRD_PARTY_NOTICES, not the exe
            driver_dir = Path(raw).parent
            exe = driver_dir / "chromedriver.exe"
            if not exe.exists():
                # fallback: find any .exe in the dir
                exes = list(driver_dir.glob("chromedriver*.exe"))
                exe = exes[0] if exes else Path(raw)
            service = Service(str(exe), log_output=os.devnull)
            self.driver = webdriver.Chrome(service=service, options=opts)
        except Exception:
            # Last resort: try without profile dir (avoids lock conflicts)
            opts2 = Options()
            for arg in opts.arguments:
                if "--user-data-dir" not in arg and "--profile-directory" not in arg:
                    opts2.add_argument(arg)
            self.driver = webdriver.Chrome(options=opts2)

    def stop(self) -> None:
        if self.driver:
            try:
                self.driver.quit()
            except Exception:
                pass
            self.driver = None
            logger.info("Browser closed")

    def __enter__(self) -> "BaseScraper":
        return self.start()

    def __exit__(self, *_) -> None:
        self.stop()

    # ── Navigation helpers ────────────────────────────────────────────────────

    def goto(self, url: str) -> None:
        logger.debug(f"Navigating to: {url}")
        self.driver.get(url)
        time.sleep(1.5)

    def wait_for(
        self,
        by: str,
        value: str,
        timeout: int = 15,
        condition: str = "presence",
    ):
        wait = WebDriverWait(
            self.driver,
            timeout,
            ignored_exceptions=(StaleElementReferenceException,),
        )
        cond_map = {
            "presence": EC.presence_of_element_located,
            "visible": EC.visibility_of_element_located,
            "clickable": EC.element_to_be_clickable,
        }
        return wait.until(cond_map[condition]((by, value)))

    def safe_find(self, by: str, value: str):
        try:
            return self.driver.find_element(by, value)
        except NoSuchElementException:
            return None

    def safe_text(self, by: str, value: str, default: str = "") -> str:
        el = self.safe_find(by, value)
        if el:
            try:
                return el.text.strip()
            except StaleElementReferenceException:
                return default
        return default

    def safe_attr(self, by: str, value: str, attr: str, default: str = "") -> str:
        el = self.safe_find(by, value)
        if el:
            try:
                return el.get_attribute(attr) or default
            except StaleElementReferenceException:
                return default
        return default

    def safe_click(self, el_or_locator, use_js: bool = False) -> bool:
        try:
            el = (
                el_or_locator
                if hasattr(el_or_locator, "click")
                else self.safe_find(*el_or_locator)
            )
            if not el:
                return False
            if use_js:
                self.driver.execute_script("arguments[0].click();", el)
            else:
                el.click()
            return True
        except Exception as e:
            logger.debug(f"safe_click failed: {e}")
            return False

    def scroll_down(self, px: int = 800) -> None:
        self.driver.execute_script(f"window.scrollBy(0, {px});")
        time.sleep(0.5)

    def scroll_to_bottom(self) -> None:
        self.driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
        time.sleep(1)

    # ── Login detection ───────────────────────────────────────────────────────

    def is_login_page(self) -> bool:
        url = self.driver.current_url.lower()
        title = self.driver.title.lower()
        return any(ind in url or ind in title for ind in LOGIN_INDICATORS)

    def wait_for_manual_login(self, site_name: str) -> None:
        # Emit to dashboard via socketio if server is running
        try:
            from server.app import socketio
            socketio.emit("login_required", {"site": site_name})
            socketio.emit("log", {
                "msg": f"⚠ LOGIN REQUIRED: {site_name} — Check the browser window and log in, then press Enter in the terminal.",
                "level": "warn",
            })
        except Exception:
            pass

        border = "=" * 65
        print(f"\n\n{border}")
        print(f"  ⚠   LOGIN REQUIRED: {site_name}")
        print(f"  1.  Look at the Chrome browser window that just opened.")
        print(f"  2.  Log in to {site_name} manually.")
        print(f"  3.  Once you are on the home/feed page, come back here.")
        print(f"{border}")
        input("  >>> Press Enter here once you are logged in: ")
        print(f"{border}\n")
        logger.info(f"Manual login confirmed for {site_name}")
        time.sleep(2)

    def ensure_logged_in(self, site_name: str, login_url: str) -> None:
        if self.is_login_page():
            logger.warning(f"Login required for {site_name}")
            self.wait_for_manual_login(site_name)
            if self.is_login_page():
                logger.error(f"Still on login page for {site_name}")
                raise RuntimeError(f"Login failed for {site_name}")
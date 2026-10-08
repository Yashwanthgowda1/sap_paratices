import logging
import os
from pathlib import Path

LOG_DIR = Path(__file__).parent.parent / "logs"
LOG_DIR.mkdir(exist_ok=True)

_FORMAT = "%(asctime)s  [%(levelname)-8s]  %(name)s  →  %(message)s"
_DATE   = "%Y-%m-%d %H:%M:%S"

from abc import ABC, abstractmethod





def get_logger(name: str) -> logging.Logger:
    """
    Returns a named logger that writes to:
      1. Console  (INFO and above)
      2. logs/test_execution.log  (DEBUG and above — full detail)

    Usage in any file:
        from utilities.logger import get_logger
        log = get_logger(__name__)
        log.info("Driver launched")
        log.error("Element not found")
    """
    logger = logging.getLogger(name)

    if logger.handlers:
        return logger  # already configured — prevents duplicate log lines

    logger.setLevel(logging.DEBUG)

    # Console handler — shows INFO+ in terminal
    console_handler = logging.StreamHandler()
    console_handler.setLevel(logging.INFO)
    console_handler.setFormatter(logging.Formatter(_FORMAT, _DATE))

    # File handler — writes DEBUG+ to log file
    log_file = LOG_DIR / "test_execution.log"
    file_handler = logging.FileHandler(log_file, mode="a", encoding="utf-8")
    file_handler.setLevel(logging.DEBUG)
    file_handler.setFormatter(logging.Formatter(_FORMAT, _DATE))

    logger.addHandler(console_handler)
    logger.addHandler(file_handler)
    return logger

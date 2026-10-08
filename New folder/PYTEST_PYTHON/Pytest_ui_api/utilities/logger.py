import logging
import os
from pathlib import Path

_LOGS_DIR = Path(__file__).resolve().parent.parent / "logs"
_LOGS_DIR.mkdir(parents=True, exist_ok=True)

_LOG_FILE = _LOGS_DIR / "test_execution.log"

_FMT = "%(asctime)s [%(levelname)s] %(name)s: %(message)s"
_DATE_FMT = "%Y-%m-%d %H:%M:%S"


def get_logger(name: str) -> logging.Logger:
    logger = logging.getLogger(name)
    if logger.handlers:
        return logger

    logger.setLevel(logging.DEBUG)

    ch = logging.StreamHandler()
    ch.setLevel(logging.INFO)
    ch.setFormatter(logging.Formatter(_FMT, _DATE_FMT))

    fh = logging.FileHandler(_LOG_FILE, encoding="utf-8")
    fh.setLevel(logging.DEBUG)
    fh.setFormatter(logging.Formatter(_FMT, _DATE_FMT))

    logger.addHandler(ch)
    logger.addHandler(fh)
    return logger

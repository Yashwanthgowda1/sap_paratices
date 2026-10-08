"""Extract plain text from PDF, DOCX, or TXT resume files."""

from __future__ import annotations

from pathlib import Path


def extract_text(file_path: str | Path) -> str:
    path = Path(file_path)
    if not path.exists():
        raise FileNotFoundError(f"Resume file not found: {file_path}")

    suffix = path.suffix.lower()
    if suffix == ".pdf":
        return _from_pdf(path)
    elif suffix in (".docx", ".doc"):
        return _from_docx(path)
    elif suffix == ".txt":
        return path.read_text(encoding="utf-8", errors="ignore")
    else:
        raise ValueError(f"Unsupported resume format: {suffix}. Use PDF, DOCX, or TXT.")


def _from_pdf(path: Path) -> str:
    try:
        import pdfplumber
        with pdfplumber.open(path) as pdf:
            pages = [page.extract_text() or "" for page in pdf.pages]
        return "\n".join(pages).strip()
    except ImportError:
        raise ImportError("Install pdfplumber: pip install pdfplumber")


def _from_docx(path: Path) -> str:
    try:
        from docx import Document
        doc = Document(str(path))
        return "\n".join(p.text for p in doc.paragraphs).strip()
    except ImportError:
        raise ImportError("Install python-docx: pip install python-docx")

@echo off
cd /d "%~dp0"
echo Starting Job Scraper Dashboard...
python main.py dashboard
if errorlevel 1 (
    echo.
    echo ERROR: Something went wrong. Check the output above.
    pause
)

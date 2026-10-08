# Docker Image Scan — n8n Workflow

A separate, self-contained n8n project that mirrors the existing React app's
scan flow ([../src/parser.js](../src/parser.js), [../src/api.js](../src/api.js))
**without modifying any existing code**.

## What it does

1. **Form Trigger (UI)** — n8n's built-in hosted form. Fields:
   - Provider (anthropic / openai / groq / mistral)
   - Model
   - API Key (password field)
   - GitHub Token (optional, password)
   - Ecosystem (npm / PyPI / Maven / crates.io / Packagist)
   - Scan Output — paste BlackDuck-style raw text
   - Max components to enrich (default 20)
2. **Parse BlackDuck Rows** — Code node. Same regex logic as
   [src/parser.js](../src/parser.js) `parseBlackDuckLine`.
3. **Split Rows** — Loops one row at a time.
4. Per row, in parallel:
   - **OSV Vulnerability Query** — `POST https://api.osv.dev/v1/query`
   - **npm License Lookup** — `GET https://registry.npmjs.org/<pkg>/latest`
   - **PyPI License Lookup** — `GET https://pypi.org/pypi/<pkg>/json`
5. **Merge Enrichment** — joins the three results onto the row, fills
   `license` if BlackDuck didn't provide one.
6. **Provider Switch** — routes to the correct LLM endpoint.
7. **LLM: Anthropic / OpenAI / Groq / Mistral** — same endpoints/headers as
   [src/api.js](../src/api.js) `callLLM`. Asks for a JSON
   `{category, summary, risk_note}` use-case classification.
8. **Parse LLM Output** — extracts JSON, strips the API key from the row.
9. **Aggregate Report** — once all rows done, builds a summary
   (`byRisk`, `byLicense`, `byUseCase`, `totalVulns`) plus the full list.
10. **Respond to Form** — returns JSON to the form submitter.

## How to import

1. Open n8n → **Workflows** → top-right menu → **Import from File**
   (or paste the JSON via **Import from URL/clipboard**).
2. Select [docker_image_scan_workflow.json](docker_image_scan_workflow.json).
3. Save → **Activate** the workflow.
4. Click the Form Trigger node → copy the **Production URL** (or **Test URL**
   while not yet activated). Open it in a browser to use the form.

No credentials need to be configured in n8n — the form passes the API key
through to the HTTP nodes via expressions, exactly the same way the React app
takes the key from the UI textbox in [src/App.jsx](../src/App.jsx) and
forwards it to `callLLM`.

## Notes

- All HTTP nodes use `continueOnFail` + `neverError`, so a missing OSV record
  or a 404 from npm/PyPI won't kill the run — it just leaves that field empty.
- The workflow is read-only against your repo: it does not call any local
  Python or touch any of the existing files.
- This folder is the only thing added; the React app under [../src/](../src/)
  is untouched.

# Docker Image Scan — AI-Powered Component & License Analyzer

A React + Vite web app that analyzes every component inside a Docker image and answers one critical question:

> **Does this component matter to the application — and is it a legal or security risk?**

---

## The Problem

Every Docker image contains 50–200+ components — OS packages, language runtimes, app libraries.

The question nobody can answer quickly:
> "Which of these components is my app actually using — and which one could force us to open-source our entire codebase?"

---

## What It Does

Paste or upload your Docker image component manifest (text, CSV, or Excel) and the tool:

- Lets you define **where your application layer starts** based on your actual image data
- Uses **AI to classify every component's role** — imported, runtime, build-only, or system
- Flags **high-risk licenses** (GPL, AGPL, Strong Copyleft) and calculates legal exposure
- Detects **unknown licenses** automatically via npm / PyPI / GitHub / AI
- Raises **cross-layer conflict alerts** when a risky package appears in both base and app layers

---

## How Layer Detection Works (Important)

**The layer numbers are NOT fixed — they come entirely from the uploaded file.**

Every Docker image has different layer counts depending on how it was built. The tool works in steps:

### Step 1 — User Sets "App Layer Start"

There is an input field: **App starts @ L___**

The user looks at their uploaded data and tells the tool where their application code begins (e.g., Layer 47). Without this, the tool relies on AI classification only.

### Step 2 — Tool Splits Components into Two Groups

```
comp.layer >= appLayerStart  →  APP LAYER      (your application code and deps)
comp.layer <  appLayerStart  →  BASE / SYSTEM  (OS, runtime, system libraries)
```

### Step 3 — AI Fills the Gaps

For components where layer number alone is not enough, the AI classifies each one regardless of layer:

| AI Classification | Meaning | Coupling |
|---              |---|---|
| `core-imported` | App source directly imports this | ●●●●● Highest |
| `imported` | Directly used by application code | ●●●●○ |
| `runtime-dep` | Needed at runtime, not directly imported | ●●●○○ |
| `build-only` | Only in Docker build stage, not in final image | ●●○○○ |
| `system` | OS-level library, app never references it | ●○○○○ |
| `no-relation` | Base infra, zero coupling to the app | ○○○○○ |

### Step 4 — Visual Layer Zone Reference (Heuristic Only)

The zones below are a **visual guide** — they do not drive the logic. The actual classification uses the `appLayerStart` value the user sets:

| Zone | Description | Example Packages |
|---|---|---|
| Base OS | Core OS packages | alpine, debian base |
| Runtime | Language runtime, VM, interpreter | node, python, java |
| System Deps | Libraries from RUN apt/apk | openssl, glibc, curl |
| App Deps | Dependencies from npm/pip/mvn | express, axios, lodash |
| App Layer | Application source code and COPY layers | your code |

---

## The License Risk Logic

This is the core of the tool. It combines two signals:

### Signal 1 — License Category

| Category | Examples | Risk |
|---|---|---|
| Public Domain | Unlicense, CC0, SQLite blessing | None |
| Permissive | MIT, Apache-2.0, BSD, ISC | Low |
| Weak Copyleft | LGPL, MPL-2.0 | Conditional |
| Strong Copyleft | GPL-2.0, GPL-3.0 | High — source disclosure required |
| AGPL | AGPL-3.0 | Critical — even SaaS must release source |

### Signal 2 — Coupling Strength (how the app uses it)


**Key message:** A GPL library buried in the base OS that your app never calls is not a problem. The same GPL library imported in your app code is a serious legal risk.

---

## Cross-Layer Conflict Detection

If the **same package** appears in both the base/system layer AND the app layer, and it carries a restrictive license, the tool raises a **Cross-Layer Conflict Alert** showing:

- The base layer where the license is embedded
- The app layer(s) where it is actively used
- The license category and why it is a problem
- Three options: obtain a commercial exception, replace with a permissive alternative, or release source

---

## Application-Layer Impact Matrix

The Impact Matrix panel ranks every component by priority:

1. Filters to components with copyleft exposure above none
2. Sorts by: Copyleft Exposure (Critical → High → Medium → Low) or Coupling Strength
3. Shows the reason for each classification
4. Gives your legal and engineering teams a clear action list

---

## What Suggestions the AI Gives Per Component

For each flagged component the AI provides:

- **Should this stay in the final image?** — multi-stage Docker build advice
- **What breaks if you remove it?** — removal impact
- **Safer alternatives** with permissive licenses
- **Code example** showing how the component is typically imported in application code


---

## License Auto-Detection Pipeline

When the scan reports a license as `Unknown`, the tool resolves it automatically via these sources in priority order:

1. Offline well-known OS package database (instant, no network)
2. npm registry
3. PyPI registry
4. ClearlyDefined.io (covers Debian, npm, PyPI)
5. GitHub repository search
6. AI inference (last resort)

This ensures no component slips through as Unknown and gets ignored.

---

## AI Providers Supported

Configure any of these in the API Settings panel:

| Provider | Models |
|---|---|
| Anthropic Claude | claude-sonnet-4-5, claude-opus-4-5, claude-haiku-4-5 |
| OpenAI GPT | gpt-4o, gpt-4o-mini, gpt-4-turbo |
| Groq (Fast) | llama-3.3-70b-versatile, mixtral-8x7b-32768 |
| Mistral AI | mistral-large-latest, mistral-small-latest |

---

## Getting Started

```bash
npm install
npm run dev
```

1. Paste your component manifest or upload a CSV / Excel file
2. Set the **App Layer Start** field to the layer where your application code begins
3. Click **Analyze** to run AI classification on all components
4. Open the **Impact Matrix** to see the ranked copyleft exposure list
5. Expand any component for deep AI analysis, CVE check, license text, and source links

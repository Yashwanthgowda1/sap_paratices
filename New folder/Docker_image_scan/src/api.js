// ─── LLM CALLER with 429 / rate-limit awareness ───────────────────────────────
// Use Vite dev-proxy paths on localhost to avoid CORS; direct URLs in production.
const DEV = typeof window !== "undefined" &&
  (window.location.hostname === "localhost" || window.location.hostname === "127.0.0.1");

const API = {
  anthropic:     DEV ? "/proxy/anthropic/v1/messages"            : "https://api.anthropic.com/v1/messages",
  openai:        DEV ? "/proxy/openai/v1/chat/completions"       : "https://api.openai.com/v1/chat/completions",
  groq:          DEV ? "/proxy/groq/openai/v1/chat/completions"  : "https://api.groq.com/openai/v1/chat/completions",
  mistral:       DEV ? "/proxy/mistral/v1/chat/completions"      : "https://api.mistral.ai/v1/chat/completions",
  npm:     (pkg) => DEV ? `/proxy/npm/${pkg}/latest`             : `https://registry.npmjs.org/${pkg}/latest`,
  pypi:    (pkg) => DEV ? `/proxy/pypi/pypi/${pkg}/json`         : `https://pypi.org/pypi/${pkg}/json`,
  github:  (path) => DEV ? `/proxy/github${path}`                : `https://api.github.com${path}`,
  gitlab:  (path) => DEV ? `/proxy/gitlab${path}`                : `https://gitlab.com${path}`,
  osv:           DEV ? "/proxy/osv/v1/query"                     : "https://api.osv.dev/v1/query",
  cd:      (path) => DEV ? `/proxy/clearlydefined${path}`        : `https://api.clearlydefined.io${path}`,
  crates:  (pkg) => DEV ? `/proxy/crates/api/v1/crates/${pkg}`  : `https://crates.io/api/v1/crates/${pkg}`,
  maven:   (q)   => DEV ? `/proxy/maven/solrsearch/select?${q}`  : `https://search.maven.org/solrsearch/select?${q}`,
  packagist:(pkg) => DEV ? `/proxy/packagist/packages/${pkg}.json` : `https://packagist.org/packages/${pkg}.json`,
};

export async function callLLM(systemPrompt, userPrompt, { provider, apiKey, model }) {
  let url, headers, body, extractText;

  if (provider === "anthropic") {
    url = API.anthropic;
    headers = {
      "Content-Type": "application/json",
      "anthropic-version": "2023-06-01",
      "anthropic-dangerous-direct-browser-calls": "true",
    };
    if (apiKey) headers["x-api-key"] = apiKey;
    body = { model, max_tokens: 4096, system: systemPrompt, messages: [{ role: "user", content: userPrompt }] };
    extractText = (d) => (d.content || []).map((b) => b.text || "").join("");
  } else if (provider === "openai") {
    url = API.openai;
    headers = { "Content-Type": "application/json", Authorization: `Bearer ${apiKey}` };
    body = { model, max_tokens: 4096, messages: [{ role: "system", content: systemPrompt }, { role: "user", content: userPrompt }] };
    extractText = (d) => d.choices?.[0]?.message?.content || "";
  } else if (provider === "groq") {
    url = API.groq;
    headers = { "Content-Type": "application/json", Authorization: `Bearer ${apiKey}` };
    body = { model, max_tokens: 4096, messages: [{ role: "system", content: systemPrompt }, { role: "user", content: userPrompt }] };
    extractText = (d) => d.choices?.[0]?.message?.content || "";
  } else if (provider === "mistral") {
    url = API.mistral;
    headers = { "Content-Type": "application/json", Authorization: `Bearer ${apiKey}` };
    body = { model, max_tokens: 4096, messages: [{ role: "system", content: systemPrompt }, { role: "user", content: userPrompt }] };
    extractText = (d) => d.choices?.[0]?.message?.content || "";
  } else {
    throw new Error("Unknown provider: " + provider);
  }

  const resp = await fetch(url, { method: "POST", headers, body: JSON.stringify(body) });

  if (resp.status === 429) {
    const retryAfter = parseInt(resp.headers.get("retry-after") || "15", 10);
    const waitMs = (retryAfter + 1) * 1000;
    const err = new Error(`RATE_LIMIT:${waitMs}`);
    err.isRateLimit = true;
    err.waitMs = waitMs;
    throw err;
  }

  if (!resp.ok) {
    const errText = await resp.text();
    throw new Error(`HTTP ${resp.status}: ${errText.slice(0, 300)}`);
  }

  const data = await resp.json();
  return extractText(data);
}

// ─── SAFE JSON EXTRACTOR ──────────────────────────────────────────────────────
// LLMs sometimes emit literal newlines/tabs inside JSON string values (e.g. in
// "codeSnippet") which is invalid JSON. This pass escapes them inside strings only.
function sanitizeJSON(raw) {
  let out = "", inStr = false, i = 0;
  while (i < raw.length) {
    const ch = raw[i];
    if (inStr) {
      if (ch === "\\") {
        out += ch + (raw[i + 1] || "");
        i += 2;
        continue;
      }
      if (ch === '"') { inStr = false; out += ch; i++; continue; }
      // Escape bare control characters that are illegal inside JSON strings
      if (ch === "\n") { out += "\\n"; i++; continue; }
      if (ch === "\r") { out += "\\r"; i++; continue; }
      if (ch === "\t") { out += "\\t"; i++; continue; }
    } else {
      if (ch === '"') inStr = true;
    }
    out += ch;
    i++;
  }
  return out;
}

export function extractJSON(text) {
  text = text.replace(/```json/g, "").replace(/```/g, "").trim();
  const start = text.indexOf("[");
  const end   = text.lastIndexOf("]");
  if (start === -1 || end === -1 || end <= start) throw new Error("No JSON array in response");
  const slice = text.slice(start, end + 1);
  try {
    return JSON.parse(slice);
  } catch {
    return JSON.parse(sanitizeJSON(slice));
  }
}

// ─── LICENSE METADATA ─────────────────────────────────────────────────────────
// Known license quick-facts so even without AI we can show something useful.
export const LICENSE_FACTS = {
  "MIT": {
    category: "Permissive",
    canCommercial: true, canModify: true, mustShareSource: false, patentGrant: false,
    obligations: ["Include copyright notice", "Include license text in distributions"],
    restrictions: ["No liability on author"],
    plainEnglish: "Do almost anything you want. Just keep the copyright notice. No copyleft — your app can stay closed-source.",
    risk: "Low",
  },
  "ISC": {
    category: "Permissive",
    canCommercial: true, canModify: true, mustShareSource: false, patentGrant: false,
    obligations: ["Include copyright notice", "Include license text"],
    restrictions: ["No liability on author"],
    plainEnglish: "Functionally identical to MIT. Freely use in commercial products with no source-disclosure requirement.",
    risk: "Low",
  },
  "Apache-2.0": {
    category: "Permissive",
    canCommercial: true, canModify: true, mustShareSource: false, patentGrant: true,
    obligations: ["Include NOTICE file if present", "State changes made", "Include license text"],
    restrictions: ["Cannot use contributor trademarks"],
    plainEnglish: "Permissive like MIT but adds an explicit patent grant — contributors can't sue you for patent infringement. Great for enterprise use.",
    risk: "Low",
  },
  "GPL-2.0-or-later": {
    category: "Strong Copyleft",
    canCommercial: true, canModify: true, mustShareSource: true, patentGrant: false,
    obligations: ["Release full source code of your app if you distribute it", "Keep same GPL license", "Include license text and copyright"],
    restrictions: ["Cannot link with proprietary code without GPL exception", "Cannot sublicense"],
    plainEnglish: "STRONG COPYLEFT. If you ship a product that includes GPL code, your entire application source must be GPL too. Dangerous for proprietary products.",
    risk: "High",
  },
  "GPL-3.0-or-later": {
    category: "Strong Copyleft",
    canCommercial: true, canModify: true, mustShareSource: true, patentGrant: true,
    obligations: ["Release full source of your distributed app", "Keep GPL-3.0 license", "Anti-Tivoization clause"],
    restrictions: ["Cannot add further restrictions", "Cannot use in hardware that prevents modification"],
    plainEnglish: "Like GPL-2.0 but adds patent protection and anti-Tivoization. Source disclosure required for any distributed binary.",
    risk: "High",
  },
  "LGPL-2.1-or-later": {
    category: "Weak Copyleft",
    canCommercial: true, canModify: true, mustShareSource: false, patentGrant: false,
    obligations: ["Modifications to LGPL files must be released", "Allow user to relink with modified library", "Include license text"],
    restrictions: ["Cannot restrict user from relinking"],
    plainEnglish: "WEAK COPYLEFT. You can link it into a proprietary app as a dynamic library without releasing your source. Only changes TO the library itself must be shared.",
    risk: "Medium",
  },
  "BSD-2-Clause": {
    category: "Permissive",
    canCommercial: true, canModify: true, mustShareSource: false, patentGrant: false,
    obligations: ["Keep copyright notice in source and binary distributions"],
    restrictions: ["No liability on author"],
    plainEnglish: "Very permissive. Two-clause means no advertising clause. Safe for commercial products.",
    risk: "Low",
  },
  "BSD-3-Clause": {
    category: "Permissive",
    canCommercial: true, canModify: true, mustShareSource: false, patentGrant: false,
    obligations: ["Keep copyright notice", "Do not use author name for endorsement"],
    restrictions: ["Cannot use project name to endorse your product"],
    plainEnglish: "Like 2-Clause BSD plus you cannot imply the original authors endorse your product. Otherwise fully permissive.",
    risk: "Low",
  },
  "MPL-2.0": {
    category: "Weak Copyleft (File-Level)",
    canCommercial: true, canModify: true, mustShareSource: false, patentGrant: true,
    obligations: ["Modified MPL files must be open-sourced", "Keep MPL notice in each file"],
    restrictions: ["Per-file copyleft only — other files in same project can stay closed"],
    plainEnglish: "File-level copyleft. If you edit an MPL file you must publish that file. Your own separate files can remain proprietary. Compatible with Apache-2.0.",
    risk: "Low-Medium",
  },
  "Unlicense": {
    category: "Public Domain",
    canCommercial: true, canModify: true, mustShareSource: false, patentGrant: false,
    obligations: [],
    restrictions: [],
    plainEnglish: "No restrictions at all. Public domain dedication. Use, copy, modify, redistribute — no attribution required.",
    risk: "Low",
  },
  "CC0-1.0": {
    category: "Public Domain",
    canCommercial: true, canModify: true, mustShareSource: false, patentGrant: false,
    obligations: [],
    restrictions: [],
    plainEnglish: "Creative Commons Zero — public domain dedication. No conditions whatsoever.",
    risk: "Low",
  },
  "Zlib": {
    category: "Permissive",
    canCommercial: true, canModify: true, mustShareSource: false, patentGrant: false,
    obligations: ["Don't claim you wrote the original", "Don't remove the license notice from source"],
    restrictions: ["Cannot misrepresent the origin of the software"],
    plainEnglish: "Very permissive, similar to BSD. No copyleft. Safe for commercial products.",
    risk: "Low",
  },
  "curl": {
    category: "Permissive",
    canCommercial: true, canModify: true, mustShareSource: false, patentGrant: false,
    obligations: ["Include copyright notice in documentation"],
    restrictions: ["No liability on author"],
    plainEnglish: "MIT-style license used by the curl project. Fully permissive, no copyleft.",
    risk: "Low",
  },
  "PSF-2.0": {
    category: "Permissive",
    canCommercial: true, canModify: true, mustShareSource: false, patentGrant: false,
    obligations: ["Include PSF copyright notice", "Reproduce license in documentation"],
    restrictions: ["Cannot use PSF name to endorse derived products"],
    plainEnglish: "Python Software Foundation License — permissive, compatible with GPL. Safe for commercial products.",
    risk: "Low",
  },
  "Artistic-2.0": {
    category: "Permissive",
    canCommercial: true, canModify: true, mustShareSource: false, patentGrant: false,
    obligations: ["Keep original copyright", "Rename modified versions"],
    restrictions: ["Restrictions on distribution of modified versions without renaming"],
    plainEnglish: "Permissive but with conditions on distributing modified versions. Common in Perl/npm ecosystem.",
    risk: "Low",
  },
  "PostgreSQL": {
    category: "Permissive",
    canCommercial: true, canModify: true, mustShareSource: false, patentGrant: false,
    obligations: ["Include copyright notice", "Include permission notice"],
    restrictions: ["No liability on author"],
    plainEnglish: "Very permissive BSD-style license used by PostgreSQL. No copyleft — safe for commercial products.",
    risk: "Low",
  },
  "GPL-2.0-with-classpath-exception": {
    category: "Weak Copyleft",
    canCommercial: true, canModify: true, mustShareSource: false, patentGrant: false,
    obligations: ["Keep GPL-2.0 license", "Classpath Exception allows you to link from proprietary code"],
    restrictions: ["Modifications to the library itself must stay GPL"],
    plainEnglish: "GPL-2.0 with Classpath Exception — the exception is critical: you can link from closed-source apps without GPL obligations. Used by OpenJDK.",
    risk: "Medium",
  },
  "OpenSSL": {
    category: "Permissive",
    canCommercial: true, canModify: true, mustShareSource: false, patentGrant: false,
    obligations: ["Include original OpenSSL + SSLeay notices", "Credit in advertising materials (old versions)"],
    restrictions: ["GPL-incompatible (versions < 3.0)"],
    plainEnglish: "Old OpenSSL license (pre-3.0). Permissive but GPL-incompatible. OpenSSL ≥ 3.0 is Apache-2.0.",
    risk: "Low-Medium",
  },
  "LGPL-3.0-or-later": {
    category: "Weak Copyleft",
    canCommercial: true, canModify: true, mustShareSource: false, patentGrant: false,
    obligations: ["Modifications to LGPL files must be released", "Allow user to relink with modified library"],
    restrictions: ["Cannot restrict user from relinking"],
    plainEnglish: "WEAK COPYLEFT. Like LGPL-2.1 but based on GPL-3 base. Dynamic linking from proprietary apps is safe — only changes to the library itself must be shared.",
    risk: "Medium",
  },
  "blessing": {
    category: "Public Domain",
    canCommercial: true, canModify: true, mustShareSource: false, patentGrant: false,
    obligations: [],
    restrictions: [],
    plainEnglish: "SQLite's 'blessing' dedication is public domain. No copyright, no license, no restrictions. The authors 'bless' any use.",
    risk: "Low",
  },
  "GPL-2.0-only": {
    category: "Strong Copyleft",
    canCommercial: true, canModify: true, mustShareSource: true, patentGrant: false,
    obligations: ["Release full source code of your app if you distribute it", "Keep GPL-2.0 license"],
    restrictions: ["Cannot use under GPL-3.0 (only-only)", "Cannot link with proprietary code without exception"],
    plainEnglish: "STRONG COPYLEFT. Exactly GPL-2.0 — cannot upgrade to 3.0. Source disclosure required for any distributed binary.",
    risk: "High",
  },
  "GPL-3.0-only": {
    category: "Strong Copyleft",
    canCommercial: true, canModify: true, mustShareSource: true, patentGrant: true,
    obligations: ["Release full source of your distributed app", "Keep GPL-3.0 license", "Anti-Tivoization clause"],
    restrictions: ["Cannot add further restrictions", "Cannot use in hardware that prevents modification"],
    plainEnglish: "STRONG COPYLEFT. Exactly GPL-3.0. Source disclosure required for any distributed binary.",
    risk: "High",
  },
  "LGPL-2.1-only": {
    category: "Weak Copyleft",
    canCommercial: true, canModify: true, mustShareSource: false, patentGrant: false,
    obligations: ["Modifications to LGPL files must be released", "Allow user to relink with modified library"],
    restrictions: ["Cannot restrict user from relinking"],
    plainEnglish: "WEAK COPYLEFT. Exactly LGPL-2.1. Dynamic linking from proprietary apps is safe.",
    risk: "Medium",
  },
  "AGPL-3.0-or-later": {
    category: "Strong Copyleft",
    canCommercial: true, canModify: true, mustShareSource: true, patentGrant: true,
    obligations: ["Provide source to ALL users who interact via network", "Keep AGPL license"],
    restrictions: ["Even SaaS / web services must release source — not just distributed binaries"],
    plainEnglish: "STRONGEST COPYLEFT. Extends GPL to network use — if you run this in a SaaS product, you must release your source. Very dangerous for proprietary web apps.",
    risk: "High",
  },
};

// ─── GITHUB SEARCH ────────────────────────────────────────────────────────────
export async function searchGitHub(query, githubToken) {
  const headers = { "Accept": "application/vnd.github.v3+json" };
  if (githubToken) headers["Authorization"] = `Bearer ${githubToken}`;
  const resp = await fetch(
    API.github(`/search/repositories?q=${encodeURIComponent(query)}&sort=stars&order=desc&per_page=5`),
    { headers }
  );
  if (!resp.ok) throw new Error(`GitHub API ${resp.status}`);
  const data = await resp.json();
  return (data.items || []).map(r => ({
    name: r.full_name, stars: r.stargazers_count, description: r.description,
    url: r.html_url, language: r.language, updatedAt: r.updated_at,
    openIssues: r.open_issues_count, license: r.license?.spdx_id || "unknown",
  }));
}

// ─── OSV VULNERABILITY SEARCH ─────────────────────────────────────────────────
export async function fetchOsvVulns(pkgName, version, ecosystem = "npm") {
  try {
    const resp = await fetch(API.osv, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ version, package: { name: pkgName, ecosystem } }),
    });
    if (!resp.ok) return [];
    const data = await resp.json();
    return (data.vulns || []).slice(0, 5).map(v => ({
      id: v.id, summary: v.summary,
      severity: v.database_specific?.severity || "UNKNOWN",
      aliases: v.aliases || [],
      url: `https://osv.dev/vulnerability/${v.id}`,
    }));
  } catch { return []; }
}

// ─── LICENSE DETECTION ────────────────────────────────────────────────────────
// Tries multiple sources in order. Returns { license, source, confidence }.
// source: "well-known" | "npm" | "pypi" | "clearlydefined" | "github" | "ai" | "none"
// confidence: "high" | "medium" | "low"

const NEEDS_DETECT = (lic) => {
  if (!lic || lic === "") return true;
  const l = lic.toLowerCase().trim();
  return ["unknown", "n/a", "none", "noassertion", "-", "?", "unspecified",
          "not specified", "other", "custom", "proprietary"].includes(l);
};

// Normalize common license strings into SPDX format
function normalizeLicense(raw) {
  if (!raw) return null;
  const s = raw.trim();
  const map = {
    "MIT License": "MIT", "MIT license": "MIT",
    "Apache License 2.0": "Apache-2.0", "Apache 2.0": "Apache-2.0", "Apache-2": "Apache-2.0",
    "GNU General Public License v2.0": "GPL-2.0-or-later",
    "GNU General Public License v3.0": "GPL-3.0-or-later",
    "GNU Lesser General Public License v2.1": "LGPL-2.1-or-later",
    "GNU Lesser General Public License v3.0": "LGPL-3.0-or-later",
    "BSD 2-Clause": "BSD-2-Clause", "BSD-2-Clause License": "BSD-2-Clause",
    "BSD 3-Clause": "BSD-3-Clause", "BSD-3-Clause License": "BSD-3-Clause",
    "ISC License": "ISC",
    "Mozilla Public License 2.0": "MPL-2.0",
    "The Unlicense": "Unlicense",
    "CC0-1.0": "CC0-1.0", "CC0 1.0 Universal": "CC0-1.0",
    "PSF-2.0": "PSF-2.0", "Python Software Foundation License": "PSF-2.0",
  };
  return map[s] || s;
}

// ─── 0. WELL-KNOWN OS / SYSTEM PACKAGE LOOKUP ────────────────────────────────
// Instant offline lookup for common Docker image OS packages.
const WELL_KNOWN_PKG_LICENSES = {
  // Shells & GNU coreutils
  bash: "GPL-3.0-or-later", sh: "GPL-3.0-or-later", dash: "GPL-2.0-or-later",
  coreutils: "GPL-3.0-or-later", findutils: "GPL-3.0-or-later", diffutils: "GPL-3.0-or-later",
  grep: "GPL-3.0-or-later", sed: "GPL-3.0-or-later", gawk: "GPL-3.0-or-later", awk: "GPL-3.0-or-later",
  tar: "GPL-3.0-or-later", gzip: "GPL-3.0-or-later", bzip2: "BSD-2-Clause",
  "xz-utils": "LGPL-2.1-or-later", xz: "LGPL-2.1-or-later", lzma: "LGPL-2.1-or-later",
  // Network utilities
  curl: "curl", libcurl: "curl", "libcurl4": "curl", wget: "GPL-3.0-or-later",
  openssl: "Apache-2.0", libssl: "Apache-2.0", "libssl3": "Apache-2.0", "libssl1.1": "OpenSSL",
  "ca-certificates": "MPL-2.0", openssh: "BSD-2-Clause", "openssh-client": "BSD-2-Clause",
  // C runtime & system libraries
  libc6: "LGPL-2.1-or-later", glibc: "LGPL-2.1-or-later", libc: "LGPL-2.1-or-later",
  libgcc: "GPL-3.0-or-later", "libgcc1": "GPL-3.0-or-later", "libgcc-s1": "GPL-3.0-or-later",
  "libstdc++6": "GPL-3.0-or-later", "libstdc++": "GPL-3.0-or-later",
  zlib: "Zlib", zlib1g: "Zlib", libz: "Zlib",
  libpam: "GPL-2.0-or-later", "libpam0g": "GPL-2.0-or-later",
  libpcre: "BSD-3-Clause", libpcre3: "BSD-3-Clause", libpcre2: "BSD-2-Clause",
  libexpat: "MIT", expat: "MIT", "libexpat1": "MIT",
  libxml2: "MIT", libxslt: "MIT",
  libffi: "MIT", "libffi8": "MIT", "libffi7": "MIT",
  ncurses: "MIT", libncurses: "MIT", "libncurses6": "MIT", "libncursesw6": "MIT",
  readline: "GPL-3.0-or-later", "libreadline8": "GPL-3.0-or-later",
  lz4: "BSD-2-Clause", "liblz4-1": "BSD-2-Clause",
  zstd: "BSD-3-Clause", "libzstd1": "BSD-3-Clause",
  // Python
  python: "PSF-2.0", python3: "PSF-2.0", python2: "PSF-2.0",
  "python3-pip": "MIT", pip: "MIT",
  // Node.js
  nodejs: "MIT", node: "MIT", npm: "Artistic-2.0",
  // Java / JVM
  openjdk: "GPL-2.0-with-classpath-exception", java: "GPL-2.0-with-classpath-exception",
  // Package managers / build tools
  apt: "GPL-2.0-or-later", dpkg: "GPL-2.0-or-later",
  rpm: "GPL-2.0-or-later", yum: "GPL-2.0-or-later", dnf: "GPL-2.0-or-later",
  apk: "GPL-2.0-or-later", alpine: "MIT",
  make: "GPL-3.0-or-later", cmake: "BSD-3-Clause", gcc: "GPL-3.0-or-later",
  // Databases
  sqlite: "blessing", sqlite3: "blessing", "libsqlite3-0": "blessing",
  postgresql: "PostgreSQL", libpq: "PostgreSQL",
  // Crypto / auth
  "libgnutls30": "LGPL-2.1-or-later", gnutls: "LGPL-2.1-or-later",
  krb5: "MIT", "libkrb5-3": "MIT",
  // Compression
  "libbz2-1.0": "BSD-2-Clause",
};

function fromWellKnown(name) {
  if (!name) return null;
  const key = name.toLowerCase().trim();
  // Try exact match first
  if (WELL_KNOWN_PKG_LICENSES[key]) {
    return { license: WELL_KNOWN_PKG_LICENSES[key], source: "well-known", confidence: "medium" };
  }
  // Try stripping common Debian suffixes like -dev, -doc, :amd64, version suffixes
  const stripped = key.replace(/[:\s].*$/, "").replace(/[-_](dev|devel|doc|docs|bin|utils?|tools?|static|headers?|lib)$/,"").replace(/^lib/, "");
  if (WELL_KNOWN_PKG_LICENSES[stripped]) {
    return { license: WELL_KNOWN_PKG_LICENSES[stripped], source: "well-known", confidence: "medium" };
  }
  return null;
}

// 1. npm registry
async function fromNpm(name) {
  try {
    const r = await fetch(API.npm(encodeURIComponent(name)));
    if (!r.ok) return null;
    const d = await r.json();
    const lic = d.license || d.licenses?.[0]?.type;
    return lic ? { license: normalizeLicense(lic), source: "npm", confidence: "high" } : null;
  } catch { return null; }
}

// 2. PyPI
async function fromPypi(name) {
  try {
    const r = await fetch(API.pypi(encodeURIComponent(name)));
    if (!r.ok) return null;
    const d = await r.json();
    const lic = d.info?.license;
    if (!lic || lic.toLowerCase() === "unknown") return null;
    return { license: normalizeLicense(lic), source: "pypi", confidence: "high" };
  } catch { return null; }
}

// 3. ClearlyDefined.io — covers npm, PyPI, AND Debian packages (no key required)
async function fromClearlyDefined(name, version) {
  const ver = version ? version.replace(/[^a-zA-Z0-9._-]/g, "").split("+")[0].split("~")[0] : "-";
  const ecosystems = [
    `npm/npmjs/-/${encodeURIComponent(name)}/${ver}`,
    `pypi/pypi/-/${encodeURIComponent(name.toLowerCase())}/${ver}`,
    `deb/debian/-/${encodeURIComponent(name.toLowerCase())}/${ver}`,
  ];
  for (const coords of ecosystems) {
    try {
      const r = await fetch(API.cd(`/definitions/${coords}`));
      if (!r.ok) continue;
      const d = await r.json();
      const lic = d.licensed?.declared;
      if (lic && !NEEDS_DETECT(lic) && lic !== "NOASSERTION") {
        return { license: normalizeLicense(lic), source: "clearlydefined", confidence: "high" };
      }
    } catch { continue; }
  }
  return null;
}

// 4. GitHub repo search → use top result's license
async function fromGitHub(name, githubToken) {
  try {
    const headers = { Accept: "application/vnd.github.v3+json" };
    if (githubToken) headers.Authorization = `Bearer ${githubToken}`;
    const r = await fetch(
      API.github(`/search/repositories?q=${encodeURIComponent(name)}&sort=stars&order=desc&per_page=3`),
      { headers }
    );
    if (!r.ok) return null;
    const data = await r.json();
    const top = (data.items || []).find(i => i.license?.spdx_id && i.license.spdx_id !== "NOASSERTION");
    if (!top) return null;
    return { license: top.license.spdx_id, source: "github", confidence: "medium" };
  } catch { return null; }
}

// 5. AI inference (last resort) — uses the LLM to infer the most likely license
async function fromAI(name, version, llmCfg) {
  if (!llmCfg) return null;
  try {
    const text = await callLLM(
      "You are a software license expert. Answer ONLY with a JSON object, no explanation.",
      `What is the most likely SPDX license identifier for the open-source package named "${name}" version "${version}"?
If you are confident, return: {"license":"<SPDX-ID>","confidence":"high"}
If you are guessing: {"license":"<SPDX-ID>","confidence":"low"}
If truly unknown: {"license":"Unknown","confidence":"low"}
Return ONLY the JSON object, no backticks.`,
      llmCfg
    );
    const cleaned = text.replace(/```json/g,"").replace(/```/g,"").trim();
    const si = cleaned.indexOf("{"), ei = cleaned.lastIndexOf("}");
    if (si < 0 || ei <= si) return null;
    const obj = JSON.parse(cleaned.slice(si, ei + 1));
    if (!obj.license || obj.license === "Unknown") return null;
    return { license: normalizeLicense(obj.license), source: "ai", confidence: obj.confidence || "low" };
  } catch { return null; }
}

// Main exported function — tries sources in priority order
export async function detectLicense(name, version, { githubToken, llmCfg } = {}) {
  if (!name) return { license: "Unknown", source: "none", confidence: "low" };

  const sources = [
    () => fromWellKnown(name),
    () => fromNpm(name),
    () => fromPypi(name),
    () => fromClearlyDefined(name, version),
    () => fromGitHub(name, githubToken),
  ];

  for (const fn of sources) {
    const result = await fn();
    if (result?.license && !NEEDS_DETECT(result.license)) return result;
  }

  // AI fallback
  if (llmCfg) {
    const aiResult = await fromAI(name, version, llmCfg);
    if (aiResult) return aiResult;
  }

  return { license: "Unknown", source: "none", confidence: "low" };
}

// ─── SOURCE LINKS FETCHER ─────────────────────────────────────────────────────
// Searches npm, PyPI, crates.io, Maven Central, GitHub, and GitLab.
export async function fetchSourceLinks(name, version, githubToken) {
  const result = {
    repoUrl: null, homepage: null, repoOwner: null, repoName: null,
    repoFullName: null, repoDescription: null, platform: null, mirrors: [],
    npmUrl: null, pypiUrl: null, cratesUrl: null, mavenUrl: null,
  };

  // ── 1. npm ──
  try {
    const r = await fetch(API.npm(encodeURIComponent(name)));
    if (r.ok) {
      const d = await r.json();
      result.npmUrl = `https://www.npmjs.com/package/${encodeURIComponent(name)}`;
      result.homepage = d.homepage || null;
      result.repoDescription = result.repoDescription || d.description || null;
      const repoRaw = d.repository?.url || (typeof d.repository === "string" ? d.repository : "");
      const ghm = repoRaw.match(/github\.com[/:]([^/]+)\/([^/.#\s]+)/);
      if (ghm) {
        result.repoOwner = ghm[1]; result.repoName = ghm[2].replace(/\.git$/, "");
        result.repoUrl = `https://github.com/${result.repoOwner}/${result.repoName}`;
        result.repoFullName = `${result.repoOwner}/${result.repoName}`;
        result.platform = "github";
      }
      const glm = repoRaw.match(/gitlab\.com[/:]([^/]+)\/([^/.#\s]+)/);
      if (glm && !result.repoUrl) {
        result.repoOwner = glm[1]; result.repoName = glm[2].replace(/\.git$/, "");
        result.repoUrl = `https://gitlab.com/${result.repoOwner}/${result.repoName}`;
        result.repoFullName = `${result.repoOwner}/${result.repoName}`;
        result.platform = "gitlab";
      }
    }
  } catch {}

  // ── 2. PyPI ──
  try {
    const r = await fetch(API.pypi(encodeURIComponent(name)));
    if (r.ok) {
      const d = await r.json();
      result.pypiUrl = `https://pypi.org/project/${encodeURIComponent(name)}/`;
      result.homepage = result.homepage || d.info?.home_page || null;
      result.repoDescription = result.repoDescription || d.info?.summary || null;
      if (!result.repoUrl) {
        const urls = d.info?.project_urls || {};
        const src = urls.Source || urls.Homepage || urls.Repository || urls["Source Code"] || d.info?.project_url || "";
        const ghm = src.match(/github\.com[/:]([^/]+)\/([^/.#\s]+)/);
        if (ghm) {
          result.repoOwner = ghm[1]; result.repoName = ghm[2].replace(/\.git$/, "");
          result.repoUrl = `https://github.com/${result.repoOwner}/${result.repoName}`;
          result.repoFullName = `${result.repoOwner}/${result.repoName}`;
          result.platform = "github";
        }
        const glm = src.match(/gitlab\.com[/:]([^/]+)\/([^/.#\s]+)/);
        if (glm && !result.repoUrl) {
          result.repoOwner = glm[1]; result.repoName = glm[2].replace(/\.git$/, "");
          result.repoUrl = `https://gitlab.com/${result.repoOwner}/${result.repoName}`;
          result.repoFullName = `${result.repoOwner}/${result.repoName}`;
          result.platform = "gitlab";
        }
      }
    }
  } catch {}

  // ── 3. crates.io (Rust) ──
  try {
    const r = await fetch(API.crates(encodeURIComponent(name)), {
      headers: { "User-Agent": "docker-image-scan/1.0" },
    });
    if (r.ok) {
      const d = await r.json();
      const krate = d.crate;
      if (krate) {
        result.cratesUrl = `https://crates.io/crates/${encodeURIComponent(name)}`;
        result.repoDescription = result.repoDescription || krate.description || null;
        result.homepage = result.homepage || krate.homepage || null;
        if (!result.repoUrl && krate.repository) {
          const ghm = krate.repository.match(/github\.com[/:]([^/]+)\/([^/.#\s]+)/);
          if (ghm) {
            result.repoOwner = ghm[1]; result.repoName = ghm[2].replace(/\.git$/, "");
            result.repoUrl = `https://github.com/${result.repoOwner}/${result.repoName}`;
            result.repoFullName = `${result.repoOwner}/${result.repoName}`;
            result.platform = "github";
          }
          const glm = krate.repository.match(/gitlab\.com[/:]([^/]+)\/([^/.#\s]+)/);
          if (glm && !result.repoUrl) {
            result.repoOwner = glm[1]; result.repoName = glm[2].replace(/\.git$/, "");
            result.repoUrl = `https://gitlab.com/${result.repoOwner}/${result.repoName}`;
            result.repoFullName = `${result.repoOwner}/${result.repoName}`;
            result.platform = "gitlab";
          }
        }
      }
    }
  } catch {}

  // ── 4. Maven Central (Java) ──
  try {
    const q = `q=${encodeURIComponent(name)}&rows=1&wt=json`;
    const r = await fetch(API.maven(q));
    if (r.ok) {
      const d = await r.json();
      const top = d.response?.docs?.[0];
      if (top) {
        result.mavenUrl = `https://search.maven.org/artifact/${top.g}/${top.a}`;
        result.repoDescription = result.repoDescription || `${top.g}:${top.a} — Maven Central artifact` || null;
      }
    }
  } catch {}

  // ── 5. GitHub search (catches system packages and anything else) ──
  if (!result.repoOwner) {
    try {
      const headers = { Accept: "application/vnd.github.v3+json" };
      if (githubToken) headers.Authorization = `Bearer ${githubToken}`;
      const r = await fetch(
        API.github(`/search/repositories?q=${encodeURIComponent(name)}&sort=stars&order=desc&per_page=3`),
        { headers }
      );
      if (r.ok) {
        const data = await r.json();
        const top = data.items?.[0];
        if (top) {
          result.repoUrl = top.html_url;
          result.repoOwner = top.owner?.login;
          result.repoName = top.name;
          result.repoFullName = top.full_name;
          result.repoDescription = result.repoDescription || top.description || null;
          result.homepage = result.homepage || top.homepage || null;
          result.platform = "github";
        }
        result.mirrors = (data.items || []).slice(1, 3).map(i => ({
          url: i.html_url, fullName: i.full_name, description: i.description,
          stars: i.stargazers_count, platform: "github",
        }));
      }
    } catch {}
  }

  // ── 6. GitLab search (final fallback) ──
  if (!result.repoOwner) {
    try {
      const r = await fetch(
        API.gitlab(`/api/v4/projects?search=${encodeURIComponent(name)}&order_by=star_count&per_page=3`),
        { headers: { "Accept": "application/json" } }
      );
      if (r.ok) {
        const data = await r.json();
        const top = data?.[0];
        if (top) {
          result.repoUrl = top.web_url;
          result.repoOwner = top.namespace?.path;
          result.repoName = top.path;
          result.repoFullName = top.path_with_namespace;
          result.repoDescription = result.repoDescription || top.description || null;
          result.homepage = result.homepage || top.homepage || null;
          result.platform = "gitlab";
        }
        const extraGl = (data || []).slice(1, 3).map(i => ({
          url: i.web_url, fullName: i.path_with_namespace, description: i.description,
          stars: i.star_count, platform: "gitlab",
        }));
        result.mirrors = [...(result.mirrors || []), ...extraGl].slice(0, 3);
      }
    } catch {}
  }

  return result;
}

// ─── LICENSE TEXT (CERTIFICATE) FETCHER ──────────────────────────────────────
// Fetches the raw LICENSE file content from GitHub via the license API endpoint.
export async function fetchLicenseText(repoOwner, repoName, githubToken) {
  if (!repoOwner || !repoName) return null;
  try {
    const headers = { Accept: "application/vnd.github.v3+json" };
    if (githubToken) headers.Authorization = `Bearer ${githubToken}`;
    const r = await fetch(API.github(`/repos/${repoOwner}/${repoName}/license`), { headers });
    if (!r.ok) return null;
    const data = await r.json();
    if (data.content) return atob(data.content.replace(/\n/g, ""));
  } catch {}
  return null;
}

export { NEEDS_DETECT };

import { useState, useCallback, useRef, useMemo } from "react";
import { PROVIDERS, RISK_STYLES, UC_COLORS, SAMPLE_RAW, getLayerZone, LAYER_ZONES } from "./constants";
import { callLLM, extractJSON, searchGitHub, fetchOsvVulns, LICENSE_FACTS, detectLicense, NEEDS_DETECT, fetchSourceLinks, fetchLicenseText } from "./api";
import { parseText, parseExcelFile, parseCsvText } from "./parser";

// ─── ENV HELPERS ──────────────────────────────────────────────────────────────
const _e = (key) => { const v = import.meta.env[key] || ""; return v.includes("PASTE_YOUR") ? "" : v; };
const ENV = {
  anthropicKey:    _e("VITE_ANTHROPIC_KEY"),
  openaiKey:       _e("VITE_OPENAI_KEY"),
  groqKey:         _e("VITE_GROQ_KEY"),
  mistralKey:      _e("VITE_MISTRAL_KEY"),
  githubToken:     _e("VITE_GITHUB_TOKEN"),
  defaultProvider: _e("VITE_DEFAULT_PROVIDER") || "anthropic",
  defaultModel:    _e("VITE_DEFAULT_MODEL") || "",
};

// ─── DESIGN TOKENS ────────────────────────────────────────────────────────────
const C = {
  // backgrounds
  bg:        "#0f1923",
  bgCard:    "#172030",
  bgPanel:   "#1a2535",
  bgInput:   "#111d2c",
  bgHover:   "#1e2f42",
  // borders
  border:    "#263c54",
  borderHi:  "#2d8fcb",
  // text
  textPrimary:   "#ddeeff",
  textSecondary: "#7aacc8",
  textMuted:     "#4a7090",
  textLabel:     "#5a8aaa",
  // accents
  accent:    "#2d8fcb",
  accentGlow:"#1a6090",
  green:     "#3dd68c",
  amber:     "#f5a623",
  red:       "#f05060",
  yellow:    "#ffd060",
  purple:    "#a07cf0",
};

const RISK_S = {
  Critical: { bg: "#2a0a12", border: "#f05060", text: "#f05060" },
  High:     { bg: "#1f1000", border: "#f5a623", text: "#f5a623" },
  Medium:   { bg: "#1e1a00", border: "#ffd060", text: "#ffd060" },
  Low:      { bg: "#0a1e10", border: "#3dd68c", text: "#3dd68c" },
  Ignored:  { bg: "#151f28", border: "#4a7090", text: "#4a7090" },
  None:     { bg: "#0a1e14", border: "#3dd68c", text: "#3dd68c" },
  Unknown:  { bg: "#151f28", border: "#4a7090", text: "#7aacc8" },
};

// ─── LICENSE TIER SPECTRUM ────────────────────────────────────────────────────
// Ordered from most permissive (0) to most restrictive (5).
const LICENSE_TIERS = [
  { key: "Public Domain",              label: "Public Domain",   color: "#3dd68c", desc: "No restrictions. No attribution needed. Fully free." },
  { key: "Permissive",                 label: "Permissive",      color: "#56d8e4", desc: "Use in commercial closed-source products. Keep copyright notice." },
  { key: "Weak Copyleft (File-Level)", label: "File Copyleft",   color: "#f5a623", desc: "Modified files must be open-sourced. Your app code can stay closed." },
  { key: "Weak Copyleft",              label: "Weak Copyleft",   color: "#ffd060", desc: "Modifications to the library must be shared. Your app can stay closed." },
  { key: "Strong Copyleft",            label: "Strong Copyleft", color: "#f05060", desc: "Full source disclosure required for any distributed application." },
  { key: "Proprietary",                label: "Proprietary",     color: "#a07cf0", desc: "Commercial license required. Not open-source." },
];

// ─── COMPLEX / VERSION-DEPENDENT LICENSE NOTES ───────────────────────────────
// For packages whose license varies by version, fork, or usage context.
const COMPLEX_LICENSE_NOTES = {
  "libdb":      { note: "Berkeley DB licensing depends on version", versions: [{ range: "< 6.0.20", lic: "Sleepycat License (OSS-friendly)" }, { range: "≥ 6.0.20", lic: "AGPL-3.0 (source disclosure required)" }], commercial: "Oracle Commercial License available for closed-source use." },
  "db":         { note: "Berkeley DB — same version-dependent licensing as libdb", versions: [{ range: "< 6.0.20", lic: "Sleepycat License" }, { range: "≥ 6.0.20", lic: "AGPL-3.0" }], commercial: "Oracle Commercial License available." },
  "openssl":    { note: "License changed at OpenSSL 3.0", versions: [{ range: "< 3.0.0", lic: "OpenSSL License + SSLeay License (GPL-incompatible)" }, { range: "≥ 3.0.0", lic: "Apache-2.0 (GPL-compatible)" }], commercial: null },
  "libressl":   { note: "LibreSSL is an OpenSSL fork maintained by OpenBSD", versions: [{ range: "all versions", lic: "OpenSSL / ISC / BSD mix (permissive)" }], commercial: null },
  "curl":       { note: "curl uses its own MIT-style license", versions: [{ range: "all versions", lic: "curl License (MIT-style, permissive, no copyleft)" }], commercial: null },
  "sqlite":     { note: "SQLite is public domain — no license file required", versions: [{ range: "all versions", lic: "Public Domain (blessing.txt)" }], commercial: "Free for any use including commercial, no attribution needed." },
  "sqlite3":    { note: "SQLite is public domain", versions: [{ range: "all versions", lic: "Public Domain (blessing.txt)" }], commercial: "Free for any use." },
  "openjdk":    { note: "OpenJDK uses GPL-2.0 with Classpath Exception — this exception is critical for commercial use", versions: [{ range: "all versions", lic: "GPL-2.0 with Classpath Exception" }], commercial: "Classpath Exception allows linking from proprietary apps without GPL obligations." },
  "java":       { note: "Same Classpath Exception applies as OpenJDK", versions: [{ range: "all versions", lic: "GPL-2.0 with Classpath Exception" }], commercial: "Classpath Exception allows proprietary linking." },
  "nodejs":     { note: "Node.js core is MIT; bundled V8 engine is Apache-2.0 + BSD", versions: [{ range: "Node.js core", lic: "MIT" }, { range: "Bundled V8 engine", lic: "Apache-2.0 + BSD-3-Clause" }], commercial: null },
  "glibc":      { note: "glibc uses LGPL-2.1 — the system library linking exception applies", versions: [{ range: "all versions", lic: "LGPL-2.1-or-later + system library exception" }], commercial: "System library exception: linking your app against glibc does NOT require source disclosure." },
  "libc6":      { note: "Same as glibc", versions: [{ range: "all versions", lic: "LGPL-2.1-or-later + system library exception" }], commercial: "Safe to link from proprietary apps." },
  "bash":       { note: "Bash is strong copyleft GPL-3.0 — do not statically bundle in proprietary products", versions: [{ range: "all versions", lic: "GPL-3.0-or-later" }], commercial: "Cannot be statically bundled in closed-source products." },
  "gcc":        { note: "GCC runtime libraries have a special 'Runtime Library Exception'", versions: [{ range: "GCC compiler itself", lic: "GPL-3.0-or-later" }, { range: "libgcc / libstdc++ runtime", lic: "GPL-3.0 + Runtime Library Exception" }], commercial: "Runtime Library Exception: programs compiled with GCC can be distributed under any license." },
};

// ─── APPLICATION-LAYER RELATION ───────────────────────────────────────────────
// Determines HOW (and how strongly) a component is coupled to the application layer.
// Returns { strength, label, reason, copyleftRisk, copyleftNote }
//
// strength levels (0 = no coupling … 5 = directly imported by app source code)
//
//   0  "no-relation"    — base OS infra never referenced by the app
//   1  "transitive"     — pulled in by another dependency, not the app directly
//   2  "runtime-linked" — needed at runtime (dynamic linker / Node require) but not in app source
//   3  "build-dep"      — only needed during the Docker build stage, stripped from final image
//   4  "runtime-dep"    — the app binary/process depends on it at runtime via OS ABI / RPC
//   5  "imported"       — application source code directly imports / requires this package
export const STRENGTH_META = {
  "no-relation":    { dots: 0, color: "#78909c", label: "No Relation",     badge: "○○○○○" },
  "transitive":     { dots: 1, color: "#78909c", label: "Transitive",      badge: "●○○○○" },
  "runtime-linked": { dots: 2, color: "#ff9100", label: "Runtime Linked",  badge: "●●○○○" },
  "build-dep":      { dots: 2, color: "#bcaaa4", label: "Build Only",      badge: "●●○○○" },
  "runtime-dep":    { dots: 3, color: "#c6ff00", label: "Runtime Dep",     badge: "●●●○○" },
  "imported":       { dots: 4, color: "#4fc3f7", label: "Directly Used",   badge: "●●●●○" },
  "core-imported":  { dots: 5, color: "#40e0d0", label: "Core Import",     badge: "●●●●●" },
};

// Copyleft exposure levels — what obligation the license creates at the app level
// given HOW the component is coupled.
export const COPYLEFT_EXPOSURE = {
  none:        { label: "No Exposure",    color: "#3dd68c", desc: "No copyleft obligation for this component." },
  low:         { label: "Low",            color: "#ffd060", desc: "Weak copyleft — obligations only if you modify the library itself." },
  medium:      { label: "Medium",         color: "#f5a623", desc: "Weak copyleft + dynamic linking — review carefully." },
  high:        { label: "High",           color: "#f05060", desc: "Strong copyleft — source disclosure likely required for distributed binaries." },
  critical:    { label: "Critical",       color: "#ff2050", desc: "AGPL / Network copyleft — even SaaS must release source code." },
};

/**
 * Pure function — classify how a component relates to the application layer.
 * Inputs: the component object, its AI analysis object (may be null), the
 * detected license string, and the license facts record.
 * Returns: { strength, meta, copyleftExposure, copyleftExposureMeta, reasonLines }
 */
export function computeAppLayerRelation(comp, analysis, effectiveLic, licFact, appLayerStart) {
  const reasons = [];

  // ── 1. Determine coupling strength ──────────────────────────────────────────
  let strength = "no-relation";

  // AI has explicitly classified the role
  if (analysis?.appLayerRole === "imported") {
    strength = "imported";
    reasons.push(`AI classified as directly imported by application code`);
    if (analysis.appLayerRoleNote) reasons.push(analysis.appLayerRoleNote);
  } else if (analysis?.appLayerRole === "runtime-dep") {
    strength = "runtime-dep";
    reasons.push(`AI classified as runtime dependency (not directly imported)`);
    if (analysis.appLayerRoleNote) reasons.push(analysis.appLayerRoleNote);
  } else if (analysis?.appLayerRole === "build-only") {
    strength = "build-dep";
    reasons.push(`AI classified as build-only — not present in the final running image`);
  } else if (analysis?.appLayerRole === "system") {
    strength = "runtime-linked";
    reasons.push(`System library — linked at runtime by the OS dynamic linker`);
  } else if (appLayerStart != null && comp.layer >= appLayerStart) {
    // Component lives in the app layer but no AI classification yet
    strength = "runtime-dep";
    reasons.push(`Located in app layer (L${comp.layer} ≥ declared app start L${appLayerStart})`);
  } else if (analysis?.runtimeOrBuild === "build-only") {
    strength = "build-dep";
    reasons.push(`Runtime/build flag: build-only`);
  } else if (analysis?.runtimeOrBuild === "runtime") {
    strength = "runtime-linked";
    reasons.push(`Runtime/build flag: runtime`);
  } else if (comp.depType?.toLowerCase().includes("transitive")) {
    strength = "transitive";
    reasons.push(`Transitive dependency — not declared directly by the app`);
  } else if (comp.layer > 0) {
    strength = "runtime-linked";
    reasons.push(`Dynamically linked system or language library in layer L${comp.layer}`);
  }

  // Upgrade to core-imported if it is both in the app layer AND AI says "imported"
  if (appLayerStart != null && comp.layer >= appLayerStart && analysis?.appLayerRole === "imported") {
    strength = "core-imported";
    reasons.unshift("App-layer component directly imported in source code (highest coupling)");
  }

  const meta = STRENGTH_META[strength] || STRENGTH_META["no-relation"];

  // ── 2. Determine copyleft exposure given coupling strength ───────────────────
  const category = licFact?.category || "Unknown";
  const isStrongCopyleft = ["Strong Copyleft"].includes(category);
  const isWeakCopyleft   = ["Weak Copyleft", "Weak Copyleft (File-Level)"].includes(category);
  const isAGPL           = effectiveLic?.includes("AGPL");
  const strengthDots     = meta.dots;

  let exposure = "none";
  let copyleftNote = "";

  if (isAGPL && strengthDots >= 2) {
    exposure = "critical";
    copyleftNote = "AGPL requires source release even for network-accessible services — any dynamic linking or runtime use triggers this obligation.";
  } else if (isStrongCopyleft) {
    if (strengthDots >= 4) {
      exposure = "high";
      copyleftNote = `Directly importing ${effectiveLic} code into your app almost certainly requires releasing your full application source under ${effectiveLic}.`;
    } else if (strengthDots >= 2) {
      exposure = "medium";
      copyleftNote = `Dynamic linking to a ${effectiveLic} library — check if the runtime linking exception applies. Consult a lawyer if distributing.`;
    } else {
      exposure = "low";
      copyleftNote = `Transitive or build-only coupling reduces but does NOT eliminate ${effectiveLic} risk.`;
    }
  } else if (isWeakCopyleft) {
    if (strengthDots >= 4) {
      exposure = "medium";
      copyleftNote = `Directly importing a weak-copyleft (${effectiveLic}) library — modified files must be open-sourced. Your own app code can stay closed.`;
    } else if (strengthDots >= 2) {
      exposure = "low";
      copyleftNote = `Dynamic linking to a weak-copyleft (${effectiveLic}) library is generally safe for proprietary apps. Verify linkage method.`;
    }
  }

  const copyleftExposureMeta = COPYLEFT_EXPOSURE[exposure];

  return {
    strength,
    meta,
    copyleftExposure: exposure,
    copyleftExposureMeta,
    reasonLines: reasons,
  };
}

// ─── SHARED STYLES ────────────────────────────────────────────────────────────
const S = {
  inp: {
    background: C.bgInput, border: `1px solid ${C.border}`, borderRadius: "5px",
    color: C.textPrimary, fontFamily: "monospace", fontSize: "11px",
    padding: "6px 10px", outline: "none", transition: "border-color 0.2s",
  },
  lbl: {
    fontSize: "10px", color: C.textLabel, fontFamily: "monospace",
    letterSpacing: "0.08em", marginBottom: "6px", display: "block", fontWeight: "600",
  },
  btn: (active, color) => ({
    background: active ? (color ? `${color}25` : C.accentGlow) : C.bgPanel,
    border: `1px solid ${active ? (color || C.borderHi) : C.border}`,
    color: active ? (color || C.accent) : C.textSecondary,
    padding: "6px 14px", borderRadius: "5px", fontSize: "11px",
    cursor: "pointer", fontFamily: "monospace", fontWeight: "600",
    transition: "all 0.15s",
  }),
  card: {
    background: C.bgCard, border: `1px solid ${C.border}`,
    borderRadius: "8px", padding: "14px 16px",
  },
};

// ─── LAYER BADGE ──────────────────────────────────────────────────────────────
function LayerBadge({ layer }) {
  const zone = getLayerZone(layer);
  return (
    <span title={zone.hint} style={{
      display: "inline-flex", alignItems: "center", justifyContent: "center",
      minWidth: "44px", height: "20px", background: `${zone.color}20`,
      border: `1px solid ${zone.color}70`, borderRadius: "4px",
      fontSize: "10px", fontWeight: "700", fontFamily: "monospace", color: zone.color,
    }}>
      L{layer}
    </span>
  );
}

// ─── INFO ROW HELPER ──────────────────────────────────────────────────────────
function InfoRow({ label, value, color }) {
  return (
    <div style={{ display: "flex", gap: "10px", padding: "5px 0", borderBottom: `1px solid ${C.border}` }}>
      <span style={{ fontSize: "10px", color: C.textLabel, fontFamily: "monospace", minWidth: "140px" }}>{label}</span>
      <span style={{ fontSize: "11px", color: color || C.textPrimary, fontFamily: "monospace" }}>{value || "—"}</span>
    </div>
  );
}

// ─── SECTION CARD ─────────────────────────────────────────────────────────────
function SectionCard({ title, color, children }) {
  return (
    <div style={{ background: C.bgInput, border: `1px solid ${color}35`, borderRadius: "6px", padding: "12px 14px" }}>
      <div style={{ fontSize: "10px", color: color, fontFamily: "monospace", fontWeight: "700", letterSpacing: "0.1em", marginBottom: "8px" }}>{title}</div>
      {children}
    </div>
  );
}

// ─── LICENSE SPECTRUM ─────────────────────────────────────────────────────────
function LicenseSpectrum({ category }) {
  const idx = LICENSE_TIERS.findIndex(t => t.key === category);
  const active = idx >= 0 ? LICENSE_TIERS[idx] : null;
  return (
    <div style={{ background: C.bgInput, border: `1px solid ${C.border}`, borderRadius: "6px", padding: "12px 14px" }}>
      <div style={{ fontSize: "10px", color: C.textLabel, fontFamily: "monospace", fontWeight: "700", letterSpacing: "0.1em", marginBottom: "8px" }}>
        ⚖ LICENSE PERMISSIVENESS SPECTRUM
      </div>
      <div style={{ display: "flex", justifyContent: "space-between", fontSize: "9px", fontFamily: "monospace", marginBottom: "6px" }}>
        <span style={{ color: C.green }}>← Most Permissive</span>
        <span style={{ color: C.red }}>Most Restrictive →</span>
      </div>
      <div style={{ display: "flex", gap: "3px" }}>
        {LICENSE_TIERS.map((tier, i) => {
          const isActive = i === idx;
          return (
            <div key={tier.key} title={tier.desc} style={{
              flex: 1, padding: "8px 4px", textAlign: "center", cursor: "default",
              background: isActive ? `${tier.color}20` : C.bgPanel,
              border: `1px solid ${isActive ? tier.color : C.border}`,
              borderRadius: "5px",
              borderBottom: `3px solid ${isActive ? tier.color : C.border}`,
            }}>
              <div style={{ fontSize: "9px", color: isActive ? tier.color : C.textMuted, fontFamily: "monospace", fontWeight: isActive ? "800" : "400", lineHeight: "1.4" }}>
                {tier.label}
              </div>
              {isActive && <div style={{ fontSize: "11px", color: tier.color, marginTop: "2px" }}>▲</div>}
            </div>
          );
        })}
      </div>
      {active ? (
        <div style={{ marginTop: "8px", padding: "7px 10px", background: `${active.color}12`, border: `1px solid ${active.color}30`, borderRadius: "5px", fontSize: "11px", color: active.color, fontFamily: "monospace" }}>
          <b>{category}</b> — {active.desc}
        </div>
      ) : (
        <div style={{ marginTop: "8px", padding: "7px 10px", background: C.bgPanel, border: `1px solid ${C.border}`, borderRadius: "5px", fontSize: "11px", color: C.textMuted }}>
          Category unknown — run 🔬 Deep AI for classification.
        </div>
      )}
    </div>
  );
}

// ─── DEEP PANEL ───────────────────────────────────────────────────────────────
function DeepPanel({ comp, analysis, githubToken, llmCfg, detectedLic, onDetect, conflict, appLayerStart }) {
  const [githubResults, setGithubResults] = useState(null);
  const [vulns, setVulns]               = useState(null);
  const [deepAnalysis, setDeepAnalysis] = useState(null);
  const [loading, setLoading]           = useState({ github: false, vulns: false, deep: false });
  const [tab, setTab]                   = useState("overview");
  const [deepError, setDeepError]       = useState("");
  const [sourceLinks, setSourceLinks]   = useState(null);
  const [licenseText, setLicenseText]   = useState(null);
  const [sourceLoading, setSourceLoading]     = useState(false);
  const [licTextLoading, setLicTextLoading]   = useState(false);
  const [licTextError, setLicTextError]       = useState("");
  const [detectingLic, setDetectingLic]       = useState(false);
  const zone = getLayerZone(comp.layer);
  const rs   = RISK_S[comp.risk] || RISK_S.Unknown;

  const runGitHub = async () => {
    setLoading(l => ({ ...l, github: true }));
    try {
      const r = await searchGitHub(comp.name, githubToken);
      setGithubResults(r.length ? r : [{ empty: true }]);
    } catch (e) {
      setGithubResults([{ error: e.message }]);
    }
    setLoading(l => ({ ...l, github: false }));
  };

  const runVulns = async () => {
    setLoading(l => ({ ...l, vulns: true }));
    const ecosystems = ["npm", "PyPI", "Maven", "Go", "Debian", "Alpine", "crates.io"];
    let found = [];
    for (const eco of ecosystems) {
      const r = await fetchOsvVulns(comp.name, comp.version, eco);
      if (r.length) { found = r; break; }
    }
    setVulns(found);
    setLoading(l => ({ ...l, vulns: false }));
  };

  const runDeepAnalysis = async () => {
    setLoading(l => ({ ...l, deep: true }));
    setDeepError("");
    try {
      const SYS = `You are an expert in open-source software licensing, Docker image architecture, and software supply chain security.
Your PRIMARY goal is deep license analysis with code examples. Secondary: runtime/security analysis.
IMPORTANT: Respond ONLY with a raw JSON object — no markdown, no backticks, no explanation outside the JSON.`;

      const USER = `Deep analysis of this Docker image component. Focus heavily on license obligations and code usage.

Component details:
- Name: ${comp.name} v${comp.version}
- Layer: ${comp.layer} | Zone: ${zone.label} (${zone.hint})
- Dependency: ${comp.depType} | Detection: ${comp.detectionType} ${comp.matchPercent}%
- Link Type: ${comp.linkType} | License: ${comp.license} | Risk: ${comp.risk}
- Use case: ${analysis?.useCase || "unknown"}

Return a JSON object with EXACTLY these keys (no extras, no omissions):
{
  "runtimeRole": "Is this needed at RUNTIME, BUILD time only, or BOTH? Explain why.",
  "codeConsumed": "List the specific APIs, functions, classes, or modules that application code typically imports and calls from ${comp.name}.",
  "codeExample": "Write 6-10 lines of real, realistic code showing how a developer would import and use ${comp.name} in their application. Use correct import/require syntax and real method names.",
  "baseImageRelation": "Explain how ${comp.name} relates to the Docker base image at Layer ${comp.layer}. Is it a core OS package, a system library, or an application dependency? Why is it in this layer?",
  "layerRecommendation": "Should this stay in the final image or be moved to a build-stage only? Multi-stage build advice?",
  "licenseCategory": "Permissive OR Weak Copyleft OR Strong Copyleft OR Public Domain OR Proprietary",
  "licenseObligations": "List EVERY legal obligation when using ${comp.license} — what you MUST do (attribution, notices, disclosures).",
  "licenseRestrictions": "List what you CANNOT do under ${comp.license} — sublicense, hold liable, use name for promotion, etc.",
  "mustShareSource": "yes | no | conditional — explain under what conditions source must be disclosed.",
  "commercialUse": "Can you use this in a closed-source commercial product? yes | no | conditional — explain.",
  "patentGrant": "Does ${comp.license} include an explicit patent grant? yes | no — explain why this matters.",
  "licenseCompatibility": "Is ${comp.license} compatible with Apache-2.0, MIT, GPL-2.0, and GPL-3.0? List each.",
  "licenseRisk": "Low | Medium | High — one sentence summary of the license risk for a commercial team.",
  "securityImplications": "Attack surface, privilege requirements, network exposure for ${comp.name}.",
  "alternatives": ["list 2-4 alternative libraries with better or equivalent licenses"],
  "removalImpact": "What exactly breaks in the Docker image or application if ${comp.name} is removed?",
  "upgradeNotes": "Key advice for upgrading or pinning version ${comp.version}.",
  "cveSummary": "Known CVE patterns or vulnerability history for this class of library."
}`;

      const text = await callLLM(SYS, USER, llmCfg);
      const cleaned = text.replace(/```json/g,"").replace(/```/g,"").trim();
      const si = cleaned.indexOf("{"), ei = cleaned.lastIndexOf("}");
      if (si < 0 || ei <= si) throw new Error("No JSON object in response");
      const parsed = JSON.parse(cleaned.slice(si, ei + 1));

      // Coerce all expected text fields to strings — LLM sometimes returns objects
      // instead of strings which causes React "Objects are not valid as a React child" crash
      const s = (v) => (v == null ? "" : typeof v === "object" ? JSON.stringify(v) : String(v));
      const normalizedAlts = Array.isArray(parsed.alternatives)
        ? parsed.alternatives.map(a => (typeof a === "object" ? (a.name || a.label || JSON.stringify(a)) : String(a)))
        : typeof parsed.alternatives === "string"
          ? parsed.alternatives.split(/[,;]+/).map(x => x.trim()).filter(Boolean)
          : [];

      setDeepAnalysis({
        ...parsed,
        runtimeRole:          s(parsed.runtimeRole),
        codeConsumed:         s(parsed.codeConsumed),
        codeExample:          s(parsed.codeExample),
        baseImageRelation:    s(parsed.baseImageRelation),
        layerRecommendation:  s(parsed.layerRecommendation),
        securityImplications: s(parsed.securityImplications),
        licenseRisk:          s(parsed.licenseRisk),
        licenseObligations:   s(parsed.licenseObligations),
        licenseRestrictions:  s(parsed.licenseRestrictions),
        mustShareSource:      s(parsed.mustShareSource),
        commercialUse:        s(parsed.commercialUse),
        removalImpact:        s(parsed.removalImpact),
        upgradeNotes:         s(parsed.upgradeNotes),
        cveSummary:           s(parsed.cveSummary),
        alternatives:         normalizedAlts,
      });
    } catch (e) {
      setDeepError(e.message);
    }
    setLoading(l => ({ ...l, deep: false }));
  };

  const detectNow = async () => {
    setDetectingLic(true);
    const result = await detectLicense(comp.name, comp.version, {
      githubToken,
      llmCfg: llmCfg?.apiKey?.trim() ? llmCfg : null,
    });
    if (onDetect) onDetect(result);
    setDetectingLic(false);
  };

  const loadSourceLinks = async () => {
    setSourceLoading(true);
    const links = await fetchSourceLinks(comp.name, comp.version, githubToken);
    setSourceLinks(links);
    setSourceLoading(false);
  };

  const loadLicenseText = async () => {
    setLicTextError("");
    let links = sourceLinks;
    if (!links?.repoOwner) {
      setSourceLoading(true);
      links = await fetchSourceLinks(comp.name, comp.version, githubToken);
      setSourceLinks(links);
      setSourceLoading(false);
    }
    if (!links?.repoOwner) {
      setLicTextError(`Could not find a GitHub repository for "${comp.name}". Try fetching source links first or add a GitHub token.`);
      return;
    }
    setLicTextLoading(true);
    const text = await fetchLicenseText(links.repoOwner, links.repoName, githubToken);
    setLicenseText(text || `License text not found in the GitHub repository "${links.repoOwner}/${links.repoName}".`);
    setLicTextLoading(false);
  };

  const TABS = [
    { id: "overview", label: "📋 Overview"  },
    { id: "license",  label: "⚖ License"   },
    { id: "github",   label: "🐙 GitHub"    },
    { id: "vulns",    label: "🛡 Vulns"     },
    { id: "deep",     label: "🔬 Deep AI"   },
  ];

  return (
    <div style={{ padding: "14px 18px 20px 18px", background: C.bgPanel, borderTop: `2px solid ${C.border}` }}>

      {/* Tab bar */}
      <div style={{ display: "flex", gap: "6px", marginBottom: "16px", flexWrap: "wrap", alignItems: "center" }}>
        {TABS.map(t => (
          <button key={t.id} onClick={() => setTab(t.id)} style={{ ...S.btn(tab === t.id), fontSize: "11px", padding: "5px 14px" }}>
            {t.label}
          </button>
        ))}
        <div style={{ marginLeft: "auto", display: "flex", gap: "8px", alignItems: "center" }}>
          <span style={{ fontSize: "10px", fontFamily: "monospace", color: zone.color, padding: "3px 8px", background: `${zone.color}15`, border: `1px solid ${zone.color}40`, borderRadius: "4px" }}>
            ◉ {zone.label}
          </span>
          <span style={{ ...RISK_S[comp.risk], fontSize: "10px", fontFamily: "monospace", fontWeight: "700", padding: "3px 10px", borderRadius: "4px", background: rs.bg, border: `1px solid ${rs.border}`, color: rs.text }}>
            {comp.risk.toUpperCase()}
          </span>
        </div>
      </div>

      {/* ── OVERVIEW TAB ── */}
      {tab === "overview" && (
        <div>

          {/* Cross-layer conflict alert */}
          {conflict && (
            <div style={{ padding: "12px 16px", marginBottom: "14px", background: "#1e0508", border: `2px solid ${C.red}60`, borderRadius: "8px" }}>
              <div style={{ fontSize: "12px", color: C.red, fontWeight: "700", marginBottom: "6px" }}>
                ⚠ CROSS-LAYER LICENSE CONFLICT — ACTION REQUIRED
              </div>
              <div style={{ fontSize: "12px", color: "#c09090", lineHeight: "1.8", marginBottom: "8px" }}>
                {conflict.reason}
              </div>
              <div style={{ display: "flex", gap: "20px", flexWrap: "wrap" }}>
                <div>
                  <span style={{ fontSize: "10px", color: C.textLabel }}>BASE LAYER</span>
                  <div style={{ fontSize: "12px", color: C.amber, fontFamily: "monospace" }}>L{conflict.baseLayer} — {conflict.license}</div>
                </div>
                <div>
                  <span style={{ fontSize: "10px", color: C.textLabel }}>ALSO IN APP LAYER(S)</span>
                  <div style={{ fontSize: "12px", color: C.red, fontFamily: "monospace" }}>L{conflict.appLayers.join(", L")}</div>
                </div>
                <div>
                  <span style={{ fontSize: "10px", color: C.textLabel }}>LICENSE CATEGORY</span>
                  <div style={{ fontSize: "12px", color: C.red, fontFamily: "monospace" }}>{conflict.category}</div>
                </div>
              </div>
              <div style={{ marginTop: "10px", padding: "8px 12px", background: "#1e0a0a", border: `1px solid ${C.red}30`, borderRadius: "5px", fontSize: "11px", color: "#c08080", lineHeight: "1.7" }}>
                <b style={{ color: C.red }}>Why this is a problem:</b> The same package exists in both your base/system layer (where the license was embedded) and your application layer (where it is being actively used). This means your application directly depends on a {conflict.category} component. You may need to: (1) obtain a commercial license exception, (2) replace with a permissive-licensed alternative, or (3) release your application source under the same license.
              </div>
            </div>
          )}

          {/* App layer role card — shown when AI has classified this */}
          {analysis?.appLayerRole && (
            <div style={{ padding: "10px 14px", marginBottom: "14px", background: analysis.appLayerRole === "imported" ? "#4fc3f710" : analysis.appLayerRole === "build-only" ? "#78909c10" : "#c6ff0010", border: `1px solid ${analysis.appLayerRole === "imported" ? "#4fc3f740" : analysis.appLayerRole === "build-only" ? "#78909c40" : "#c6ff0030"}`, borderRadius: "6px" }}>
              <div style={{ fontSize: "10px", fontFamily: "monospace", fontWeight: "700", letterSpacing: "0.08em", marginBottom: "5px", color: analysis.appLayerRole === "imported" ? "#4fc3f7" : analysis.appLayerRole === "build-only" ? "#78909c" : "#c6ff00" }}>
                {analysis.appLayerRole === "imported"    ? "📦 IMPORTED IN APPLICATION CODE"
                : analysis.appLayerRole === "runtime-dep" ? "⚙ RUNTIME DEPENDENCY (not directly imported)"
                : analysis.appLayerRole === "build-only"  ? "🏗 BUILD-ONLY (not in final image runtime)"
                : "🖥 SYSTEM LIBRARY (OS-level, not imported by app)"}
              </div>
              <div style={{ fontSize: "12px", color: C.textSecondary, lineHeight: "1.7" }}>
                {analysis.appLayerRoleNote || "—"}
              </div>
            </div>
          )}
          {/* Always show raw component data */}
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "12px", marginBottom: "14px" }}>
            <SectionCard title="COMPONENT INFO" color={C.accent}>
              <InfoRow label="Name"            value={comp.name}          color={C.textPrimary} />
              <InfoRow label="Version"         value={comp.version}       color={C.yellow} />
              <InfoRow label="Layer"           value={`L${comp.layer} — ${zone.label}`} color={zone.color} />
              {appLayerStart != null && (
                <InfoRow
                  label="App Layer?"
                  value={comp.layer >= appLayerStart ? `Yes — above app start (L${appLayerStart})` : `No — below app start (L${appLayerStart})`}
                  color={comp.layer >= appLayerStart ? "#4fc3f7" : C.textMuted}
                />
              )}
              <InfoRow label="Dependency Type" value={comp.depType}       />
              <InfoRow label="Detection"       value={`${comp.detectionType} (${comp.matchPercent}%)`} color={comp.matchPercent < 100 ? C.amber : C.textSecondary} />
              <InfoRow label="Link Type"       value={comp.linkType}      />
              <InfoRow label="License"         value={comp.license}       color={C.purple} />
            </SectionCard>

            <SectionCard title="LAYER ZONE CONTEXT" color={zone.color}>
              <div style={{ fontSize: "11px", color: C.textSecondary, lineHeight: "1.8", marginBottom: "10px" }}>
                {zone.hint}
              </div>
              <div style={{ padding: "8px 10px", background: `${zone.color}15`, border: `1px solid ${zone.color}40`, borderRadius: "4px", marginBottom: "8px" }}>
                <span style={{ fontSize: "10px", color: zone.color, fontFamily: "monospace", fontWeight: "700" }}>ZONE: {zone.label}</span>
                <span style={{ fontSize: "10px", color: C.textMuted, fontFamily: "monospace" }}> — Layer {comp.layer}</span>
              </div>
              {LAYER_ZONES.map((z, i) => (
                <div key={i} style={{ display: "flex", alignItems: "center", gap: "8px", padding: "3px 0" }}>
                  <span style={{ width: "8px", height: "8px", borderRadius: "50%", background: comp.layer <= z.max ? z.color : C.border, flexShrink: 0, display: "inline-block" }} />
                  <span style={{ fontSize: "10px", color: comp.layer <= z.max ? z.color : C.textMuted, fontFamily: "monospace" }}>
                    {z.label} (≤L{z.max === 999 ? "∞" : z.max})
                  </span>
                </div>
              ))}
            </SectionCard>
          </div>

          {/* AI analysis — shown when available */}
          {analysis ? (
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "12px" }}>
              <SectionCard title="AI EXPLANATION" color={C.accent}>
                <p style={{ fontSize: "12px", color: C.textSecondary, lineHeight: "1.8", margin: "0 0 10px" }}>{analysis.explanation}</p>
                {analysis.runtimeOrBuild && (
                  <div style={{ padding: "6px 10px", background: `${C.green}15`, border: `1px solid ${C.green}40`, borderRadius: "4px" }}>
                    <span style={{ fontSize: "11px", color: C.green, fontFamily: "monospace", fontWeight: "700" }}>
                      ⏱ {analysis.runtimeOrBuild === "runtime" ? "RUNTIME ONLY"
                          : analysis.runtimeOrBuild === "build-only" ? "BUILD / COMPILE ONLY"
                          : "RUNTIME + BUILD TIME"}
                    </span>
                  </div>
                )}
              </SectionCard>
              <SectionCard title="LAYER CONTEXT & RECOMMENDATION" color={C.green}>
                <p style={{ fontSize: "12px", color: C.textSecondary, lineHeight: "1.8", margin: "0 0 8px" }}>{analysis.layerContext}</p>
                {analysis.recommendation && (
                  <div style={{ padding: "8px 10px", background: `${C.green}12`, border: `1px solid ${C.green}30`, borderRadius: "5px", fontSize: "11px", color: C.green }}>
                    💡 {analysis.recommendation}
                  </div>
                )}
              </SectionCard>
              {analysis.alternatives?.length > 0 && (
                <div style={{ gridColumn: "1/-1" }}>
                  <SectionCard title="ALTERNATIVES" color={C.purple}>
                    <div style={{ display: "flex", gap: "8px", flexWrap: "wrap" }}>
                      {analysis.alternatives.map((a, i) => (
                        <span key={i} style={{ fontSize: "11px", color: C.purple, fontFamily: "monospace", padding: "3px 10px", background: `${C.purple}15`, border: `1px solid ${C.purple}40`, borderRadius: "4px" }}>{a}</span>
                      ))}
                    </div>
                  </SectionCard>
                </div>
              )}
            </div>
          ) : (
            <div style={{ padding: "14px 16px", background: C.bgInput, border: `1px dashed ${C.border}`, borderRadius: "6px", textAlign: "center" }}>
              <div style={{ fontSize: "13px", marginBottom: "6px" }}>🤖</div>
              <div style={{ fontSize: "12px", color: C.textSecondary, marginBottom: "4px" }}>AI analysis not yet run for this component.</div>
              <div style={{ fontSize: "11px", color: C.textMuted }}>Click <b style={{ color: C.accent }}>⚡ ANALYZE</b> in the top bar to run batch AI analysis on all components, or use the <b style={{ color: C.accent }}>🔬 Deep AI</b> tab above for this component only.</div>
            </div>
          )}
        </div>
      )}

      {/* ── LICENSE TAB ── */}
      {tab === "license" && (() => {
        // Resolved license — prefer auto-detected over "Unknown" from scan
        const resolvedLic   = (detectedLic && !NEEDS_DETECT(detectedLic.license)) ? detectedLic.license : comp.license;
        const isAutoDetected = detectedLic && detectedLic.source && detectedLic.source !== "scan" && detectedLic.source !== "none";
        const SOURCE_LABEL  = { npm: "npm registry", pypi: "PyPI registry", clearlydefined: "ClearlyDefined.io", "well-known": "well-known OS package", github: "GitHub search", ai: "AI inference" };

        // Merge static known facts with AI analysis fields
        const known       = LICENSE_FACTS[resolvedLic] || {};
        const aiRisk      = analysis?.licenseRisk || known.risk || "Unknown";
        const aiCat       = analysis?.licenseCategory || known.category || "Unknown";
        const aiOneLiner  = analysis?.licenseOneLiner || known.plainEnglish || "";
        const aiMustShare = analysis?.mustShareSource || (known.mustShareSource != null ? (known.mustShareSource ? "yes" : "no") : "unknown");
        const aiSnippet   = analysis?.codeSnippet || "";

        const RISK_COLOR  = { Low: C.green, Medium: C.amber, High: C.red, Unknown: C.textMuted };
        const riskColor   = RISK_COLOR[aiRisk] || C.textMuted;
        const CAT_COLOR   = {
          "Permissive": C.green, "Public Domain": C.green,
          "Weak Copyleft": C.amber, "Weak Copyleft (File-Level)": C.amber,
          "Strong Copyleft": C.red, "Proprietary": C.red, "Unknown": C.textMuted,
        };
        const catColor = CAT_COLOR[aiCat] || C.textMuted;

        return (
          <div style={{ display: "flex", flexDirection: "column", gap: "14px" }}>
            {/* Auto-detected banner */}
            {isAutoDetected && (
              <div style={{ padding: "10px 14px", background: `${C.amber}12`, border: `1px solid ${C.amber}40`, borderRadius: "6px", display: "flex", gap: "10px", alignItems: "center" }}>
                <span style={{ fontSize: "16px" }}>🔍</span>
                <div>
                  <div style={{ fontSize: "11px", color: C.amber, fontWeight: "700", marginBottom: "2px" }}>
                    License Auto-Detected — not from scan
                  </div>
                  <div style={{ fontSize: "11px", color: C.textSecondary }}>
                    Original scan value was <b style={{ color: C.red }}>"{comp.license}"</b>.
                    Detected <b style={{ color: C.green }}>{resolvedLic}</b> via <b>{SOURCE_LABEL[detectedLic.source] || detectedLic.source}</b> with <b>{detectedLic.confidence}</b> confidence.
                    Verify against the actual package source before making legal decisions.
                  </div>
                </div>
              </div>
            )}
            {NEEDS_DETECT(resolvedLic) && !isAutoDetected && (
              <div style={{ padding: "12px 14px", background: `${C.amber}12`, border: `1px solid ${C.amber}40`, borderRadius: "6px" }}>
                <div style={{ fontSize: "11px", color: C.amber, fontWeight: "700", marginBottom: "6px" }}>⚠ License Unknown — Auto-Detection Available</div>
                <div style={{ fontSize: "11px", color: C.textSecondary, marginBottom: "10px", lineHeight: "1.7" }}>
                  No license was found in the scan for <b style={{ color: C.textPrimary }}>{comp.name}</b>.
                  Click below to search npm, PyPI, ClearlyDefined, GitHub, and AI inference automatically.
                </div>
                <div style={{ display: "flex", gap: "10px", alignItems: "center", flexWrap: "wrap" }}>
                  <button
                    onClick={detectNow}
                    disabled={detectingLic}
                    style={{ ...S.btn(true, C.amber), fontSize: "11px", padding: "6px 16px", fontWeight: "700" }}
                  >
                    {detectingLic ? "⏳ Searching npm · PyPI · GitHub · AI…" : "🔍 Detect License Now"}
                  </button>
                  <span style={{ fontSize: "10px", color: C.textMuted }}>
                    Treat as <b style={{ color: C.red }}>HIGH RISK</b> until confirmed.
                  </span>
                </div>
              </div>
            )}
            {/* Re-detect button for already-known licenses */}
            {!NEEDS_DETECT(resolvedLic) && (
              <div style={{ display: "flex", alignItems: "center", gap: "10px", padding: "8px 12px", background: C.bgInput, border: `1px solid ${C.border}`, borderRadius: "6px" }}>
                <span style={{ fontSize: "11px", color: C.textSecondary }}>
                  Scan reported: <b style={{ color: C.purple }}>{comp.license}</b>
                  {isAutoDetected && <span> → detected: <b style={{ color: C.green }}>{resolvedLic}</b></span>}
                </span>
                <button
                  onClick={detectNow}
                  disabled={detectingLic}
                  style={{ ...S.btn(false), fontSize: "10px", padding: "4px 12px", marginLeft: "auto" }}
                >
                  {detectingLic ? "⏳ Searching…" : "🔄 Re-detect via npm · PyPI · GitHub · AI"}
                </button>
              </div>
            )}

            {/* License header card */}
            <div style={{ display: "grid", gridTemplateColumns: "auto 1fr auto", gap: "16px", alignItems: "center", padding: "14px 18px", background: C.bgInput, border: `1px solid ${riskColor}40`, borderRadius: "8px" }}>
              <div style={{ textAlign: "center" }}>
                <div style={{ fontSize: "32px" }}>⚖</div>
              </div>
              <div>
                <div style={{ fontSize: "20px", fontWeight: "800", color: C.textPrimary, fontFamily: "monospace" }}>{resolvedLic}</div>
                <div style={{ fontSize: "12px", color: catColor, marginTop: "3px", fontWeight: "600" }}>{aiCat}</div>
                <div style={{ fontSize: "12px", color: C.textSecondary, marginTop: "6px", lineHeight: "1.7" }}>{aiOneLiner}</div>
              </div>
              <div style={{ textAlign: "center" }}>
                <div style={{ fontSize: "11px", color: C.textMuted, marginBottom: "4px" }}>LICENSE RISK</div>
                <div style={{ fontSize: "18px", fontWeight: "800", color: riskColor, padding: "6px 14px", background: `${riskColor}15`, border: `1px solid ${riskColor}40`, borderRadius: "6px" }}>{aiRisk}</div>
              </div>
            </div>

            {/* Version-specific / complex license notes for well-known packages */}
            {(() => {
              const key = comp.name.toLowerCase().replace(/[:\s].*$/, "").replace(/[-_](dev|devel|doc|bin|utils?)$/, "");
              const ctx = COMPLEX_LICENSE_NOTES[key] || COMPLEX_LICENSE_NOTES[key.replace(/^lib/, "")];
              if (!ctx) return null;
              return (
                <div style={{ padding: "12px 16px", background: "#0e1f30", border: `1px solid ${C.borderHi}50`, borderRadius: "8px" }}>
                  <div style={{ fontSize: "10px", color: C.accent, fontFamily: "monospace", fontWeight: "700", letterSpacing: "0.1em", marginBottom: "8px" }}>
                    ℹ VERSION-DEPENDENT LICENSING — {comp.name.toUpperCase()}
                  </div>
                  <div style={{ fontSize: "11px", color: C.textSecondary, marginBottom: "10px", lineHeight: "1.7" }}>{ctx.note}</div>
                  <div style={{ border: `1px solid ${C.border}`, borderRadius: "6px", overflow: "hidden", marginBottom: ctx.commercial ? "10px" : "0" }}>
                    <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", background: C.bgPanel, padding: "6px 12px", borderBottom: `1px solid ${C.border}` }}>
                      <span style={{ fontSize: "9px", color: C.textLabel, fontWeight: "700", letterSpacing: "0.1em" }}>VERSION / CONTEXT</span>
                      <span style={{ fontSize: "9px", color: C.textLabel, fontWeight: "700", letterSpacing: "0.1em" }}>LICENSE</span>
                    </div>
                    {ctx.versions.map((v, i) => (
                      <div key={i} style={{ display: "grid", gridTemplateColumns: "1fr 1fr", padding: "8px 12px", borderBottom: i < ctx.versions.length - 1 ? `1px solid ${C.border}` : "none", background: i % 2 === 0 ? "transparent" : `${C.border}20` }}>
                        <span style={{ fontSize: "11px", color: C.yellow, fontFamily: "monospace" }}>{v.range}</span>
                        <span style={{ fontSize: "11px", color: C.textPrimary, fontFamily: "monospace" }}>{v.lic}</span>
                      </div>
                    ))}
                  </div>
                  {ctx.commercial && (
                    <div style={{ padding: "8px 10px", background: `${C.green}10`, border: `1px solid ${C.green}30`, borderRadius: "5px", fontSize: "11px", color: C.green }}>
                      💼 {ctx.commercial}
                    </div>
                  )}
                </div>
              );
            })()}

            {/* Quick-facts row */}
            <div style={{ display: "grid", gridTemplateColumns: "repeat(4,1fr)", gap: "10px" }}>
              {[
                ["🏢 Commercial Use",  known.canCommercial != null ? (known.canCommercial ? "✅ Allowed" : "❌ Not Allowed") : "Ask lawyer", known.canCommercial ? C.green : C.red],
                ["✏ Can Modify",       known.canModify     != null ? (known.canModify     ? "✅ Yes" : "❌ No")            : "Check license", known.canModify ? C.green : C.red],
                ["📤 Share Source",    aiMustShare === "yes" ? "⚠ Required" : aiMustShare === "no" ? "✅ Not Required" : "Conditional", aiMustShare === "yes" ? C.red : C.green],
                ["🔏 Patent Grant",    known.patentGrant   != null ? (known.patentGrant   ? "✅ Granted" : "❌ None")     : "Unclear", known.patentGrant ? C.green : C.amber],
              ].map(([label, value, col]) => (
                <div key={label} style={{ padding: "12px", background: C.bgInput, border: `1px solid ${col}30`, borderRadius: "6px", textAlign: "center" }}>
                  <div style={{ fontSize: "10px", color: C.textLabel, marginBottom: "6px", fontWeight: "700" }}>{label}</div>
                  <div style={{ fontSize: "11px", color: col, fontWeight: "700" }}>{value}</div>
                </div>
              ))}
            </div>

            {/* License Classification Spectrum */}
            <LicenseSpectrum category={aiCat} />

            {/* Obligations & Restrictions */}
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "12px" }}>
              {known.obligations?.length > 0 && (
                <SectionCard title="✅ WHAT YOU MUST DO (Obligations)" color={C.amber}>
                  <ul style={{ margin: 0, paddingLeft: "16px" }}>
                    {known.obligations.map((o, i) => (
                      <li key={i} style={{ fontSize: "12px", color: C.textSecondary, lineHeight: "1.9", marginBottom: "2px" }}>{o}</li>
                    ))}
                  </ul>
                </SectionCard>
              )}
              {known.restrictions?.length > 0 && (
                <SectionCard title="❌ WHAT YOU CANNOT DO (Restrictions)" color={C.red}>
                  <ul style={{ margin: 0, paddingLeft: "16px" }}>
                    {known.restrictions.map((r, i) => (
                      <li key={i} style={{ fontSize: "12px", color: C.textSecondary, lineHeight: "1.9", marginBottom: "2px" }}>{r}</li>
                    ))}
                  </ul>
                </SectionCard>
              )}
              {!known.obligations && !known.restrictions && (
                <div style={{ gridColumn: "1/-1", padding: "10px 14px", background: C.bgInput, border: `1px solid ${C.border}`, borderRadius: "6px", fontSize: "11px", color: C.textMuted }}>
                  Obligations and restrictions not in quick-reference database for "{resolvedLic}". Run 🔬 Deep AI for a full breakdown.
                </div>
              )}
            </div>

            {/* Source Code & Registry Links */}
            <SectionCard title="🔗 SOURCE CODE & REGISTRY LINKS" color={C.accent}>
              {!sourceLinks ? (
                <div style={{ display: "flex", gap: "10px", alignItems: "center", flexWrap: "wrap" }}>
                  <button onClick={loadSourceLinks} disabled={sourceLoading} style={{ ...S.btn(true), fontSize: "10px", padding: "5px 14px" }}>
                    {sourceLoading ? "⏳ Fetching…" : "🔗 Fetch Source Links"}
                  </button>
                  <span style={{ fontSize: "10px", color: C.textMuted }}>Looks up npm · PyPI · crates.io · Maven · GitHub · GitLab for this component's repository.</span>
                </div>
              ) : (
                <div style={{ display: "flex", flexDirection: "column", gap: "7px" }}>
                  {/* Primary repo (GitHub or GitLab) */}
                  {sourceLinks.repoUrl && (() => {
                    const isGitLab = sourceLinks.platform === "gitlab";
                    const icon = isGitLab ? "🦊" : "🐙";
                    const label = isGitLab ? "GitLab Repo" : "GitHub Repo";
                    const color = isGitLab ? "#e24329" : C.accent;
                    return (
                      <div style={{ display: "flex", gap: "10px", alignItems: "flex-start" }}>
                        <span style={{ fontSize: "10px", color: C.textLabel, fontFamily: "monospace", minWidth: "90px", paddingTop: "2px" }}>{label}</span>
                        <div>
                          <a href={sourceLinks.repoUrl} target="_blank" rel="noreferrer" style={{ fontSize: "12px", color, fontFamily: "monospace", textDecoration: "none", fontWeight: "700" }}>
                            {icon} {sourceLinks.repoFullName || `${sourceLinks.repoOwner}/${sourceLinks.repoName}`}
                          </a>
                          {sourceLinks.repoDescription && (
                            <div style={{ fontSize: "10px", color: C.textSecondary, marginTop: "2px", lineHeight: "1.5" }}>{sourceLinks.repoDescription}</div>
                          )}
                        </div>
                      </div>
                    );
                  })()}
                  {/* Mirror / related repos */}
                  {sourceLinks.mirrors?.map((m, i) => {
                    const isGitLab = m.platform === "gitlab";
                    return (
                      <div key={i} style={{ display: "flex", gap: "10px", alignItems: "flex-start" }}>
                        <span style={{ fontSize: "10px", color: C.textLabel, fontFamily: "monospace", minWidth: "90px", paddingTop: "2px" }}>Related {i + 1}</span>
                        <div>
                          <a href={m.url} target="_blank" rel="noreferrer" style={{ fontSize: "11px", color: C.textSecondary, fontFamily: "monospace", textDecoration: "none" }}>
                            {isGitLab ? "🦊" : "🐙"} {m.fullName}
                          </a>
                          {m.description && <div style={{ fontSize: "10px", color: C.textMuted, marginTop: "2px" }}>{m.description}</div>}
                        </div>
                      </div>
                    );
                  })}
                  {/* Package registry links */}
                  {sourceLinks.npmUrl && (
                    <div style={{ display: "flex", gap: "10px", alignItems: "center" }}>
                      <span style={{ fontSize: "10px", color: C.textLabel, fontFamily: "monospace", minWidth: "90px" }}>npm Registry</span>
                      <a href={sourceLinks.npmUrl} target="_blank" rel="noreferrer" style={{ fontSize: "12px", color: "#cc3333", fontFamily: "monospace", textDecoration: "none", fontWeight: "700" }}>
                        📦 {comp.name} on npm
                      </a>
                    </div>
                  )}
                  {sourceLinks.pypiUrl && (
                    <div style={{ display: "flex", gap: "10px", alignItems: "center" }}>
                      <span style={{ fontSize: "10px", color: C.textLabel, fontFamily: "monospace", minWidth: "90px" }}>PyPI</span>
                      <a href={sourceLinks.pypiUrl} target="_blank" rel="noreferrer" style={{ fontSize: "12px", color: C.yellow, fontFamily: "monospace", textDecoration: "none", fontWeight: "700" }}>
                        🐍 {comp.name} on PyPI
                      </a>
                    </div>
                  )}
                  {sourceLinks.cratesUrl && (
                    <div style={{ display: "flex", gap: "10px", alignItems: "center" }}>
                      <span style={{ fontSize: "10px", color: C.textLabel, fontFamily: "monospace", minWidth: "90px" }}>crates.io</span>
                      <a href={sourceLinks.cratesUrl} target="_blank" rel="noreferrer" style={{ fontSize: "12px", color: "#f74c00", fontFamily: "monospace", textDecoration: "none", fontWeight: "700" }}>
                        🦀 {comp.name} on crates.io
                      </a>
                    </div>
                  )}
                  {sourceLinks.mavenUrl && (
                    <div style={{ display: "flex", gap: "10px", alignItems: "center" }}>
                      <span style={{ fontSize: "10px", color: C.textLabel, fontFamily: "monospace", minWidth: "90px" }}>Maven Central</span>
                      <a href={sourceLinks.mavenUrl} target="_blank" rel="noreferrer" style={{ fontSize: "12px", color: "#c0392b", fontFamily: "monospace", textDecoration: "none", fontWeight: "700" }}>
                        ☕ {comp.name} on Maven Central
                      </a>
                    </div>
                  )}
                  {sourceLinks.homepage && sourceLinks.homepage !== sourceLinks.repoUrl && (
                    <div style={{ display: "flex", gap: "10px", alignItems: "center" }}>
                      <span style={{ fontSize: "10px", color: C.textLabel, fontFamily: "monospace", minWidth: "90px" }}>Homepage</span>
                      <a href={sourceLinks.homepage} target="_blank" rel="noreferrer" style={{ fontSize: "12px", color: C.green, fontFamily: "monospace", textDecoration: "none", fontWeight: "700" }}>
                        🌐 Official Homepage
                      </a>
                    </div>
                  )}
                  {!sourceLinks.repoUrl && !sourceLinks.npmUrl && !sourceLinks.pypiUrl && !sourceLinks.cratesUrl && !sourceLinks.mavenUrl && (
                    <div style={{ fontSize: "11px", color: C.textMuted }}>
                      No source links found for "{comp.name}" in npm, PyPI, crates.io, Maven, GitHub, or GitLab. It may be a proprietary or system package.
                    </div>
                  )}
                  <button onClick={() => setSourceLinks(null)} style={{ ...S.btn(false), fontSize: "9px", padding: "3px 10px", width: "fit-content", marginTop: "2px" }}>🔄 Refresh</button>
                </div>
              )}
            </SectionCard>

            {/* Code snippet — how it's used in the application layer */}
            <SectionCard title={`💻 HOW "${comp.name}" IS USED IN APPLICATION CODE (Layer ${comp.layer})`} color={C.accent}>
              {aiSnippet ? (
                <pre style={{ margin: 0, padding: "14px", background: "#0a1420", border: `1px solid ${C.border}`, borderRadius: "6px", fontSize: "12px", color: "#a8d8f8", overflowX: "auto", lineHeight: "1.8", whiteSpace: "pre-wrap", wordBreak: "break-word" }}>
                  {aiSnippet}
                </pre>
              ) : (
                <div style={{ padding: "12px", background: C.bgInput, border: `1px dashed ${C.border}`, borderRadius: "6px", textAlign: "center" }}>
                  <div style={{ fontSize: "11px", color: C.textMuted, marginBottom: "8px" }}>Code example not yet generated. Run batch analysis or use 🔬 Deep AI tab.</div>
                  <button onClick={() => setTab("deep")} style={{ ...S.btn(true), fontSize: "10px", padding: "4px 12px" }}>Go to 🔬 Deep AI →</button>
                </div>
              )}
              <div style={{ fontSize: "10px", color: C.textMuted, marginTop: "8px" }}>
                ⓘ This snippet shows typical usage of <b style={{ color: C.textSecondary }}>{comp.name}</b> in application-layer code (Layer {comp.layer} — {zone.label}).
              </div>
            </SectionCard>

            {/* License Certificate — raw LICENSE file text */}
            <SectionCard title={`📜 LICENSE CERTIFICATE — ${resolvedLic}`} color={C.purple}>
              {licenseText ? (
                <div>
                  <pre style={{
                    margin: 0, padding: "12px", background: "#060e18",
                    border: `1px solid ${C.border}`, borderRadius: "6px",
                    fontSize: "10px", color: "#9ab8d0", overflowX: "auto", overflowY: "auto",
                    maxHeight: "300px", lineHeight: "1.7", whiteSpace: "pre-wrap", wordBreak: "break-word",
                    fontFamily: "'JetBrains Mono','Courier New',monospace",
                  }}>
                    {licenseText}
                  </pre>
                  <button onClick={() => setLicenseText(null)} style={{ ...S.btn(false), fontSize: "9px", padding: "3px 10px", marginTop: "8px" }}>🔄 Refetch</button>
                </div>
              ) : licTextError ? (
                <div style={{ padding: "10px 12px", background: "#1e0a0a", border: `1px solid ${C.red}40`, borderRadius: "6px", fontSize: "11px", color: C.red }}>
                  ⚠ {licTextError}
                </div>
              ) : (
                <div style={{ display: "flex", gap: "10px", alignItems: "center", flexWrap: "wrap" }}>
                  <button
                    onClick={loadLicenseText}
                    disabled={licTextLoading || sourceLoading}
                    style={{ ...S.btn(true, C.purple), fontSize: "10px", padding: "5px 14px" }}
                  >
                    {licTextLoading || sourceLoading ? "⏳ Fetching…" : "📜 Fetch License Text"}
                  </button>
                  <span style={{ fontSize: "10px", color: C.textMuted }}>
                    Retrieves the actual LICENSE file from the source repository via GitHub API.
                  </span>
                </div>
              )}
            </SectionCard>

            {/* License compatibility hint */}
            {(known.category === "Strong Copyleft") && (
              <div style={{ padding: "12px 16px", background: "#1e0a0a", border: `1px solid ${C.red}60`, borderRadius: "8px" }}>
                <div style={{ fontSize: "12px", color: C.red, fontWeight: "700", marginBottom: "6px" }}>⚠ STRONG COPYLEFT WARNING — ACTION REQUIRED</div>
                <div style={{ fontSize: "12px", color: "#c09090", lineHeight: "1.8" }}>
                  <b>{resolvedLic}</b> requires you to release the <b>full source code</b> of any application you distribute that includes or links to this component.
                  If your product is closed-source or commercial, you must either:
                </div>
                <ul style={{ marginTop: "8px", paddingLeft: "20px" }}>
                  {["Obtain a commercial license exception from the copyright holder.",
                    "Replace this component with a permissively-licensed alternative.",
                    "Release your entire application under the same copyleft license."].map((t, i) => (
                    <li key={i} style={{ fontSize: "12px", color: "#c09090", lineHeight: "2" }}>{t}</li>
                  ))}
                </ul>
              </div>
            )}
            {(known.category === "Weak Copyleft" || known.category === "Weak Copyleft (File-Level)") && (
              <div style={{ padding: "12px 16px", background: "#1e1200", border: `1px solid ${C.amber}50`, borderRadius: "8px" }}>
                <div style={{ fontSize: "12px", color: C.amber, fontWeight: "700", marginBottom: "6px" }}>⚠ WEAK COPYLEFT — REVIEW LINKING METHOD</div>
                <div style={{ fontSize: "12px", color: "#c0a070", lineHeight: "1.8" }}>
                  <b>{resolvedLic}</b> is weak copyleft. You can use it in proprietary products as a <b>dynamically linked</b> library without releasing your source.
                  If you <b>statically link</b> or modify the library itself, those changes must be shared.
                  Your application code ({comp.linkType}) — verify it is dynamically linked.
                </div>
              </div>
            )}

            {/* AI recommendation if present */}
            {analysis?.recommendation && (
              <div style={{ padding: "12px 14px", background: `${C.green}10`, border: `1px solid ${C.green}40`, borderRadius: "8px" }}>
                <div style={{ fontSize: "10px", color: C.green, fontWeight: "700", marginBottom: "4px" }}>💡 AI RECOMMENDATION</div>
                <div style={{ fontSize: "12px", color: C.textSecondary, lineHeight: "1.7" }}>{analysis.recommendation}</div>
              </div>
            )}
          </div>
        );
      })()}

      {/* ── GITHUB TAB ── */}
      {tab === "github" && (
        <div>
          <div style={{ padding: "10px 14px", background: C.bgInput, border: `1px solid ${C.border}`, borderRadius: "6px", marginBottom: "12px" }}>
            <div style={{ fontSize: "11px", color: C.textSecondary, lineHeight: "1.7" }}>
              🐙 <b style={{ color: C.textPrimary }}>GitHub Search</b> — finds the open-source repository for <b style={{ color: C.yellow }}>{comp.name}</b> on GitHub.
              Shows stars, language, last update, open issues, and license — so you can judge health and maintenance status.
            </div>
          </div>
          {!githubResults ? (
            <button onClick={runGitHub} disabled={loading.github} style={{ ...S.btn(true), padding: "8px 18px" }}>
              {loading.github ? "⏳ Searching GitHub…" : `🔍 Search GitHub for "${comp.name}"`}
            </button>
          ) : (
            <div style={{ display: "flex", flexDirection: "column", gap: "8px" }}>
              {githubResults.map((r, i) =>
                r.error ? (
                  <div key={i} style={{ padding: "12px", background: "#1e0a0a", border: `1px solid ${C.red}40`, borderRadius: "6px", fontSize: "11px", color: C.red }}>
                    ⚠ GitHub search failed: {r.error}
                    {r.error.includes("403") && <div style={{ fontSize: "10px", color: C.amber, marginTop: "4px" }}>Rate limit hit — add a GitHub Token in ⚙ API Settings for 5000 req/hr.</div>}
                  </div>
                ) : r.empty ? (
                  <div key={i} style={{ padding: "12px", background: C.bgInput, border: `1px solid ${C.border}`, borderRadius: "6px", fontSize: "11px", color: C.textMuted }}>
                    No GitHub repositories found for "{comp.name}". It may be a system package (not on GitHub) or named differently.
                  </div>
                ) : (
                  <div key={i} style={{ padding: "12px 14px", background: C.bgInput, border: `1px solid ${C.border}`, borderRadius: "6px" }}>
                    <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", flexWrap: "wrap", gap: "8px" }}>
                      <a href={r.url} target="_blank" rel="noreferrer" style={{ fontSize: "13px", color: C.accent, fontFamily: "monospace", textDecoration: "none", fontWeight: "700" }}>
                        🐙 {r.name}
                      </a>
                      <div style={{ display: "flex", gap: "10px", flexWrap: "wrap" }}>
                        <span style={{ fontSize: "11px", color: C.yellow }}>⭐ {r.stars?.toLocaleString()}</span>
                        {r.language && <span style={{ fontSize: "11px", color: C.purple, fontFamily: "monospace" }}>{r.language}</span>}
                        <span style={{ fontSize: "11px", color: C.textMuted, fontFamily: "monospace" }}>{r.license}</span>
                      </div>
                    </div>
                    {r.description && <div style={{ fontSize: "11px", color: C.textSecondary, margin: "6px 0 4px" }}>{r.description}</div>}
                    <div style={{ fontSize: "10px", color: C.textMuted }}>
                      Last updated: {new Date(r.updatedAt).toLocaleDateString()} &nbsp;·&nbsp; Open issues: {r.openIssues}
                    </div>
                  </div>
                )
              )}
              <button onClick={() => setGithubResults(null)} style={{ ...S.btn(false), width: "fit-content", fontSize: "10px" }}>🔄 Search Again</button>
            </div>
          )}
        </div>
      )}

      {/* ── VULNS TAB ── */}
      {tab === "vulns" && (
        <div>
          <div style={{ padding: "10px 14px", background: C.bgInput, border: `1px solid ${C.border}`, borderRadius: "6px", marginBottom: "12px" }}>
            <div style={{ fontSize: "11px", color: C.textSecondary, lineHeight: "1.7" }}>
              🛡 <b style={{ color: C.textPrimary }}>Vulnerability Check</b> — queries <b style={{ color: C.yellow }}>OSV.dev</b> (Google's open vulnerability database) for known CVEs in <b style={{ color: C.yellow }}>{comp.name} v{comp.version}</b>.
              Checks npm, PyPI, Maven, Go, Debian and Alpine ecosystems. No API key needed.
            </div>
          </div>
          {vulns === null ? (
            <button onClick={runVulns} disabled={loading.vulns} style={{ ...S.btn(true), padding: "8px 18px" }}>
              {loading.vulns ? "⏳ Checking OSV.dev…" : `🛡 Check CVEs for "${comp.name}" v${comp.version}`}
            </button>
          ) : (
            <div>
              {vulns.length === 0 ? (
                <div style={{ padding: "14px 16px", background: "#0a1e12", border: `1px solid ${C.green}40`, borderRadius: "6px" }}>
                  <span style={{ fontSize: "13px" }}>✅</span>
                  <span style={{ fontSize: "12px", color: C.green, marginLeft: "8px", fontWeight: "600" }}>
                    No known vulnerabilities found for {comp.name} v{comp.version}
                  </span>
                </div>
              ) : (
                <div style={{ display: "flex", flexDirection: "column", gap: "8px" }}>
                  <div style={{ fontSize: "11px", color: C.amber, marginBottom: "4px" }}>⚠ Found {vulns.length} vulnerability record{vulns.length > 1 ? "s" : ""}:</div>
                  {vulns.map((v, i) => (
                    <div key={i} style={{ padding: "12px 14px", background: "#1e0a0a", border: `1px solid ${C.red}40`, borderRadius: "6px" }}>
                      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", flexWrap: "wrap", gap: "8px" }}>
                        <a href={v.url} target="_blank" rel="noreferrer" style={{ fontSize: "12px", color: C.red, fontFamily: "monospace", fontWeight: "700", textDecoration: "none" }}>
                          ⚠ {v.id}
                        </a>
                        <span style={{ fontSize: "11px", color: C.amber, fontFamily: "monospace", fontWeight: "700", padding: "2px 8px", background: `${C.amber}15`, border: `1px solid ${C.amber}40`, borderRadius: "4px" }}>
                          {v.severity}
                        </span>
                      </div>
                      {v.summary && <div style={{ fontSize: "11px", color: C.textSecondary, marginTop: "6px", lineHeight: "1.6" }}>{v.summary}</div>}
                      {v.aliases?.length > 0 && (
                        <div style={{ fontSize: "10px", color: C.textMuted, marginTop: "4px" }}>Also known as: {v.aliases.join(", ")}</div>
                      )}
                    </div>
                  ))}
                </div>
              )}
              <button onClick={() => setVulns(null)} style={{ ...S.btn(false), width: "fit-content", fontSize: "10px", marginTop: "10px" }}>🔄 Recheck</button>
            </div>
          )}
        </div>
      )}

      {/* ── DEEP AI TAB ── */}
      {tab === "deep" && (
        <div>
          <div style={{ padding: "10px 14px", background: C.bgInput, border: `1px solid ${C.border}`, borderRadius: "6px", marginBottom: "12px" }}>
            <div style={{ fontSize: "11px", color: C.textSecondary, lineHeight: "1.7" }}>
              🔬 <b style={{ color: C.textPrimary }}>Deep AI Analysis</b> — sends <b style={{ color: C.yellow }}>{comp.name}</b> to your selected LLM for a detailed breakdown:
              runtime role, code consumed, base image relationship, layer optimization, security implications, and more.
            </div>
          </div>

          {!deepAnalysis && !deepError && (
            <button onClick={runDeepAnalysis} disabled={loading.deep} style={{ ...S.btn(true), padding: "8px 20px", fontSize: "12px" }}>
              {loading.deep ? "⏳ Analyzing…" : `🔬 Deep Analyze "${comp.name}"`}
            </button>
          )}

          {deepError && (
            <div style={{ padding: "12px 14px", background: "#1e0a0a", border: `1px solid ${C.red}40`, borderRadius: "6px", marginBottom: "12px" }}>
              <div style={{ fontSize: "12px", color: C.red, marginBottom: "6px" }}>⚠ Deep analysis failed</div>
              <div style={{ fontSize: "11px", color: C.textMuted, fontFamily: "monospace", marginBottom: "10px" }}>{deepError}</div>
              <button onClick={runDeepAnalysis} disabled={loading.deep} style={{ ...S.btn(true, C.red), fontSize: "10px", padding: "5px 14px" }}>
                {loading.deep ? "Retrying…" : "🔄 Retry"}
              </button>
            </div>
          )}

          {deepAnalysis && !deepAnalysis.error && (
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "10px" }}>
              {[
                ["⏱ RUNTIME ROLE",              deepAnalysis.runtimeRole,           C.green],
                ["🔧 CODE CONSUMED",             deepAnalysis.codeConsumed,          "#56d8e4"],
                ["🏗 BASE IMAGE RELATION",        deepAnalysis.baseImageRelation,     C.amber],
                ["📦 LAYER / BUILD OPTIMIZATION", deepAnalysis.layerRecommendation,   "#7cf078"],
                ["🔒 SECURITY IMPLICATIONS",      deepAnalysis.securityImplications,  C.red],
                ["⚖ LICENSE RISK",               deepAnalysis.licenseRisk,           C.yellow],
                ["💥 REMOVAL IMPACT",            deepAnalysis.removalImpact,         "#f080a0"],
                ["⬆ UPGRADE NOTES",             deepAnalysis.upgradeNotes,          C.purple],
              ].map(([title, content, color]) => (
                <div key={title} style={{ background: C.bgInput, border: `1px solid ${color}25`, borderRadius: "6px", padding: "12px 14px" }}>
                  <div style={{ fontSize: "10px", color, fontFamily: "monospace", fontWeight: "700", letterSpacing: "0.08em", marginBottom: "7px" }}>{title}</div>
                  <p style={{ fontSize: "11px", color: C.textSecondary, lineHeight: "1.75", margin: 0 }}>{content || "—"}</p>
                </div>
              ))}
              {deepAnalysis.alternatives?.length > 0 && (
                <div style={{ gridColumn: "1/-1", background: C.bgInput, border: `1px solid ${C.purple}25`, borderRadius: "6px", padding: "12px 14px" }}>
                  <div style={{ fontSize: "10px", color: C.purple, fontFamily: "monospace", fontWeight: "700", marginBottom: "8px" }}>🔀 LIGHTER / SAFER ALTERNATIVES</div>
                  <div style={{ display: "flex", gap: "8px", flexWrap: "wrap" }}>
                    {deepAnalysis.alternatives.map((a, i) => (
                      <span key={i} style={{ fontSize: "11px", color: C.purple, fontFamily: "monospace", padding: "3px 10px", background: `${C.purple}15`, border: `1px solid ${C.purple}40`, borderRadius: "4px" }}>{a}</span>
                    ))}
                  </div>
                </div>
              )}
              {deepAnalysis.cveSummary && (
                <div style={{ gridColumn: "1/-1", background: "#1a0a0c", border: `1px solid ${C.red}25`, borderRadius: "6px", padding: "12px 14px" }}>
                  <div style={{ fontSize: "10px", color: C.red, fontFamily: "monospace", fontWeight: "700", marginBottom: "7px" }}>☠ CVE / VULNERABILITY PATTERNS</div>
                  <p style={{ fontSize: "11px", color: "#c08090", lineHeight: "1.75", margin: 0 }}>{deepAnalysis.cveSummary}</p>
                </div>
              )}
              <div style={{ gridColumn: "1/-1", textAlign: "right" }}>
                <button onClick={() => { setDeepAnalysis(null); setDeepError(""); }} style={{ ...S.btn(false), fontSize: "10px" }}>🔄 Re-run Analysis</button>
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  );
}

// ─── APP-LAYER IMPACT PANEL ───────────────────────────────────────────────────
// Full-page panel that shows every component's relationship to the application
// layer with a strength spectrum bar, copyleft exposure matrix, and a ranked
// action list.
function AppLayerImpactPanel({ components, analyses, detectedLicenses, appLayerStart, onClose }) {
  const [sortBy, setSortBy] = useState("exposure"); // "exposure" | "strength" | "name"
  const [showOnly, setShowOnly] = useState("all");  // "all" | "copyleft" | "imported"

  const rows = components.map((c, i) => {
    const analysis = analyses[i] || null;
    const licInfo  = (detectedLicenses[i] && !NEEDS_DETECT(detectedLicenses[i].license))
      ? detectedLicenses[i] : { license: c.license, source: "scan" };
    const lic    = licInfo.license || "Unknown";
    const lFact  = LICENSE_FACTS[lic] || {};
    const rel    = computeAppLayerRelation(c, analysis, lic, lFact, appLayerStart);
    return { comp: c, analysis, lic, lFact, rel, idx: i };
  });

  const EXPOSURE_ORDER = { critical: 5, high: 4, medium: 3, low: 2, none: 1 };
  const STRENGTH_ORDER = { "core-imported": 6, imported: 5, "runtime-dep": 4, "runtime-linked": 3, "build-dep": 2, transitive: 1, "no-relation": 0 };

  const sorted = [...rows]
    .filter(r => {
      if (showOnly === "copyleft") return r.rel.copyleftExposure !== "none";
      if (showOnly === "imported") return r.rel.strength === "imported" || r.rel.strength === "core-imported";
      return true;
    })
    .sort((a, b) => {
      if (sortBy === "exposure") return (EXPOSURE_ORDER[b.rel.copyleftExposure] || 0) - (EXPOSURE_ORDER[a.rel.copyleftExposure] || 0);
      if (sortBy === "strength") return (STRENGTH_ORDER[b.rel.strength] || 0) - (STRENGTH_ORDER[a.rel.strength] || 0);
      return a.comp.name.localeCompare(b.comp.name);
    });

  // Summary counts
  const byExposure = rows.reduce((acc, r) => { acc[r.rel.copyleftExposure] = (acc[r.rel.copyleftExposure] || 0) + 1; return acc; }, {});
  const byStrength = rows.reduce((acc, r) => { acc[r.rel.strength] = (acc[r.rel.strength] || 0) + 1; return acc; }, {});

  return (
    <div style={{ background: C.bgPanel, borderBottom: `2px solid ${C.border}`, padding: "18px 20px" }}>

      {/* Header */}
      <div style={{ display: "flex", alignItems: "center", gap: "12px", marginBottom: "16px" }}>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: "13px", color: "#4fc3f7", fontWeight: "700", letterSpacing: "0.06em", marginBottom: "3px" }}>
            📦 APPLICATION-LAYER IMPACT MATRIX
          </div>
          <div style={{ fontSize: "11px", color: C.textSecondary }}>
            Ranks every component by how strongly it is coupled to your application layer
            and what copyleft obligations that coupling creates.
          </div>
        </div>
        <button onClick={onClose} style={{ ...S.btn(false), padding: "5px 12px", color: C.red }}>✕ Close</button>
      </div>

      {/* Exposure + Strength summary strips */}
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "12px", marginBottom: "16px" }}>
        {/* Copyleft exposure */}
        <div style={{ background: C.bgInput, border: `1px solid ${C.border}`, borderRadius: "6px", padding: "12px 14px" }}>
          <div style={{ fontSize: "10px", color: C.textLabel, fontWeight: "700", letterSpacing: "0.1em", marginBottom: "8px" }}>⚖ COPYLEFT EXPOSURE DISTRIBUTION</div>
          <div style={{ display: "flex", flexDirection: "column", gap: "5px" }}>
            {Object.entries(COPYLEFT_EXPOSURE).map(([key, meta]) => {
              const cnt = byExposure[key] || 0;
              const pct = rows.length ? Math.round((cnt / rows.length) * 100) : 0;
              return (
                <div key={key} style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                  <span style={{ fontSize: "10px", color: meta.color, fontFamily: "monospace", minWidth: "80px" }}>{meta.label}</span>
                  <div style={{ flex: 1, height: "6px", background: C.border, borderRadius: "3px", overflow: "hidden" }}>
                    <div style={{ width: `${pct}%`, height: "100%", background: meta.color, borderRadius: "3px", transition: "width 0.3s" }} />
                  </div>
                  <span style={{ fontSize: "10px", color: meta.color, fontFamily: "monospace", minWidth: "28px", textAlign: "right" }}>{cnt}</span>
                </div>
              );
            })}
          </div>
        </div>

        {/* Coupling strength */}
        <div style={{ background: C.bgInput, border: `1px solid ${C.border}`, borderRadius: "6px", padding: "12px 14px" }}>
          <div style={{ fontSize: "10px", color: C.textLabel, fontWeight: "700", letterSpacing: "0.1em", marginBottom: "8px" }}>🔗 COUPLING STRENGTH DISTRIBUTION</div>
          <div style={{ display: "flex", flexDirection: "column", gap: "5px" }}>
            {Object.entries(STRENGTH_META).map(([key, meta]) => {
              const cnt = byStrength[key] || 0;
              const pct = rows.length ? Math.round((cnt / rows.length) * 100) : 0;
              return (
                <div key={key} style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                  <span style={{ fontSize: "10px", color: meta.color, fontFamily: "monospace", minWidth: "100px" }}>{meta.label}</span>
                  <div style={{ flex: 1, height: "6px", background: C.border, borderRadius: "3px", overflow: "hidden" }}>
                    <div style={{ width: `${pct}%`, height: "100%", background: meta.color, borderRadius: "3px", transition: "width 0.3s" }} />
                  </div>
                  <span style={{ fontSize: "10px", color: meta.color, fontFamily: "monospace", minWidth: "28px", textAlign: "right" }}>{cnt}</span>
                </div>
              );
            })}
          </div>
        </div>
      </div>

      {/* Controls */}
      <div style={{ display: "flex", gap: "8px", alignItems: "center", marginBottom: "12px", flexWrap: "wrap" }}>
        <span style={{ fontSize: "10px", color: C.textLabel }}>SORT:</span>
        {[["exposure","⚖ By Exposure"],["strength","🔗 By Coupling"],["name","A-Z"]].map(([k,l]) => (
          <button key={k} onClick={() => setSortBy(k)} style={{ ...S.btn(sortBy === k), fontSize: "10px", padding: "4px 12px" }}>{l}</button>
        ))}
        <span style={{ fontSize: "10px", color: C.textLabel, marginLeft: "8px" }}>SHOW:</span>
        {[["all","All"],["copyleft","⚠ Copyleft Only"],["imported","📦 Imported Only"]].map(([k,l]) => (
          <button key={k} onClick={() => setShowOnly(k)} style={{ ...S.btn(showOnly === k, "#4fc3f7"), fontSize: "10px", padding: "4px 12px" }}>{l}</button>
        ))}
        <span style={{ marginLeft: "auto", fontSize: "10px", color: C.textMuted }}>{sorted.length} components</span>
      </div>

      {/* Rows */}
      <div style={{ maxHeight: "480px", overflowY: "auto", border: `1px solid ${C.border}`, borderRadius: "6px", background: C.bg }}>
        {/* Table header */}
        <div style={{ display: "grid", gridTemplateColumns: "1fr 90px 110px 120px", gap: "10px", padding: "7px 14px", background: C.bgPanel, borderBottom: `1px solid ${C.border}`, position: "sticky", top: 0, zIndex: 2 }}>
          {["COMPONENT / LICENSE","LAYER","COUPLING","COPYLEFT EXPOSURE"].map(h => (
            <span key={h} style={{ fontSize: "9px", color: C.textLabel, fontFamily: "monospace", fontWeight: "700", letterSpacing: "0.1em" }}>{h}</span>
          ))}
        </div>
        {sorted.map(({ comp, rel, lic, idx }) => {
          const expMeta = rel.copyleftExposureMeta;
          const sMeta   = rel.meta;
          return (
            <div key={`${comp.name}-${idx}`} style={{ display: "grid", gridTemplateColumns: "1fr 90px 110px 120px", gap: "10px", padding: "9px 14px", borderBottom: `1px solid ${C.border}`, background: rel.copyleftExposure === "critical" ? "#200508" : rel.copyleftExposure === "high" ? "#1a0d00" : "transparent", transition: "background 0.15s" }}>
              {/* Name / license */}
              <div style={{ minWidth: 0 }}>
                <div style={{ display: "flex", alignItems: "center", gap: "6px" }}>
                  <span style={{ fontSize: "12px", fontWeight: "700", color: C.textPrimary, fontFamily: "monospace" }}>{comp.name}</span>
                  <span style={{ fontSize: "10px", color: C.textMuted, fontFamily: "monospace" }}>v{comp.version}</span>
                </div>
                <div style={{ fontSize: "10px", color: C.purple, fontFamily: "monospace", marginTop: "2px" }}>{lic}</div>
                {rel.reasonLines[0] && (
                  <div style={{ fontSize: "10px", color: C.textMuted, marginTop: "2px", lineHeight: "1.5" }}>↳ {rel.reasonLines[0]}</div>
                )}
              </div>
              {/* Layer */}
              <div>
                <LayerBadge layer={comp.layer} />
              </div>
              {/* Coupling */}
              <div>
                <div style={{ display: "flex", gap: "3px", marginBottom: "3px" }}>
                  {[1,2,3,4,5].map(d => (
                    <div key={d} style={{ width: "10px", height: "10px", borderRadius: "2px", background: d <= sMeta.dots ? sMeta.color : C.border }} />
                  ))}
                </div>
                <span style={{ fontSize: "10px", color: sMeta.color, fontFamily: "monospace", fontWeight: "700" }}>{sMeta.label}</span>
              </div>
              {/* Copyleft exposure */}
              <div>
                <span style={{
                  fontSize: "10px", fontWeight: "700", fontFamily: "monospace",
                  padding: "3px 8px", borderRadius: "4px",
                  background: `${expMeta.color}18`, border: `1px solid ${expMeta.color}50`,
                  color: expMeta.color, display: "inline-block",
                }}>
                  {expMeta.label}
                </span>
                {rel.copyleftExposure !== "none" && rel.copyleftNote && (
                  <div style={{ fontSize: "9px", color: C.textMuted, marginTop: "4px", lineHeight: "1.5" }}>{rel.copyleftNote}</div>
                )}
              </div>
            </div>
          );
        })}
        {sorted.length === 0 && (
          <div style={{ padding: "30px", textAlign: "center", color: C.textMuted, fontSize: "12px" }}>No components match the current filter.</div>
        )}
      </div>
    </div>
  );
}

// ─── SCAN REPORT PANEL ───────────────────────────────────────────────────────
function ScanReport({ components, analyses, detectedLicenses, onClose }) {
  const [tab, setTab] = useState("summary");

  // ── Derived stats ──────────────────────────────────────────────────────────
  const total = components.length;

  // Risk counts
  const byCritical = components.filter(c => c.risk === "Critical").length;
  const byHigh     = components.filter(c => c.risk === "High").length;
  const byMedium   = components.filter(c => c.risk === "Medium").length;
  const byLow      = components.filter(c => c.risk === "Low").length;
  const byOK       = components.filter(c => c.risk === "None" || c.risk === "OK").length;

  // License family breakdown
  const licFamilyMap = {};
  components.forEach((c, i) => {
    const det = detectedLicenses[i];
    const lic = (det && !NEEDS_DETECT(det.license)) ? det.license : c.license;
    const fam = LICENSE_FACTS[lic]?.category || (
      c.license?.toLowerCase().includes("permissive") || c.license?.toLowerCase().includes("mit") || c.license?.toLowerCase().includes("apache") || c.license?.toLowerCase().includes("bsd") || c.license?.toLowerCase().includes("isc") ? "Permissive" :
      c.license?.toLowerCase().includes("lgpl") || c.license?.toLowerCase().includes("weak") || c.license?.toLowerCase().includes("mpl") ? "Weak Copyleft" :
      c.license?.toLowerCase().includes("gpl") || c.license?.toLowerCase().includes("reciprocal") ? "Strong Copyleft" : "Unknown"
    );
    licFamilyMap[fam] = (licFamilyMap[fam] || 0) + 1;
  });

  // Ecosystem breakdown from origin
  const ecosystems = {};
  components.forEach(c => {
    const raw = c.raw || "";
    const eco = raw.includes("npmjs") ? "npm" :
                raw.includes("debian") || raw.includes("ubuntu") ? "Debian" :
                raw.includes("pypi") ? "PyPI" :
                raw.includes("cpan") ? "CPAN" :
                raw.includes("github") ? "GitHub" : "Other";
    ecosystems[eco] = (ecosystems[eco] || 0) + 1;
  });

  // Policy violations from raw data
  const inViolation    = components.filter(c => (c.raw || "").includes("In Violation")).length;
  const notInViolation = components.filter(c => (c.raw || "").includes("Not In Violation")).length;

  // CVE components — those with risk HIGH or CRITICAL
  const cveComponents = components.filter(c => ["Critical","High"].includes(c.risk));

  // Copyleft components
  const copyleftComps = components.filter((c, i) => {
    const det = detectedLicenses[i];
    const lic = (det && !NEEDS_DETECT(det.license)) ? det.license : c.license;
    const cat = LICENSE_FACTS[lic]?.category || "";
    return cat === "Strong Copyleft" || cat === "Weak Copyleft" || cat === "Weak Copyleft (File-Level)";
  });

  // Top action items (static from analysis)
  const ACTION_ITEMS = [
    { priority: "🔴 P1", title: "Python 3.14.2 — 9 CVEs (6H + 3M)", detail: "Runtime interpreter processing PHI documents. Pull exact CVE IDs from Black Duck, cross-reference NVD. If any are RCE/memory corruption → HIPAA incident risk. Assess within 48h, remediate within 2 weeks.", component: "Python", version: "3.14.2" },
    { priority: "🔴 P1", title: "tar 7.5.7 — 1 HIGH CVE", detail: "tar 7.5.9 already present. Add package.json overrides: { \"tar\": \"7.5.9\" } to force all transitive deps to patched version. Rebuild and re-scan to confirm 7.5.7 is gone.", component: "tar", version: "7.5.7" },
    { priority: "🔴 P1", title: "OpenSSL 3.5.5 — 1 HIGH CVE", detail: "TLS library for PHI data in transit. Verify if Debian security team backported a patch (check full dpkg version string for +deb13u suffix). If not, rebuild from updated base image.", component: "OpenSSL", version: "3.5.5" },
    { priority: "🟠 P2", title: "GCC / build toolchain in production image", detail: "gcc-14, gcc-14-base, gcc-x86-64-linux-gnu, libasan8, libhwasan0 are in the runtime image. Compilers dramatically increase attack surface. Use Docker multi-stage builds — compile native modules in build stage, copy only compiled .node files to final stage.", component: "gcc-14", version: "14.2.0" },
    { priority: "🟠 P2", title: "npm CLI in production image", detail: "npm-cli 11.6.2, node-gyp 11.4.2, full @npmcli/* toolchain present. A production PHI container should not contain a package manager. Removes information disclosure risk (package.json, metadata). Remove if not needed at runtime.", component: "npm-cli", version: "11.6.2" },
    { priority: "🟡 P3", title: "Resolve yallist version conflict (3.1.1 HIGH + 4.0.0 MEDIUM)", detail: "Three concurrent versions. Add package.json overrides to eliminate 3.1.1 and 4.0.0. Run `npm ls yallist` to find the chain. Likely: lru-cache 6.x → yallist 4, lru-cache 4/5 → yallist 3.", component: "yallist", version: "3.1.1/4.0.0/5.0.0" },
    { priority: "🟡 P3", title: "Bulk approve PERMISSIVE + 0 CVE + OK risk components", detail: "~80-100 components are In Violation solely because they have never been reviewed in Black Duck, but carry PERMISSIVE licenses, 0 CVEs, OK risk. Create an auto-approval policy or batch review session to clear backlog.", component: "Various", version: "~100 components" },
    { priority: "🟡 P3", title: "Audit Winston logging stack for PHI leakage", detail: "logform, triple-beam, @elastic/ecs-winston-format are present. Ensure maskdata 1.3.3 is correctly configured to mask ALL PHI fields (patient IDs, document content, metadata) before any log output.", component: "logform/maskdata", version: "2.7.0 / 1.3.3" },
    { priority: "🔵 P4", title: "Remove Apache Subversion 1.14.5", detail: "SVN client has no business in a production document imaging service. Increases attack surface unnecessarily. Remove from Dockerfile.", component: "Apache Subversion", version: "1.14.5" },
    { priority: "🔵 P4", title: "Document GCC Runtime Library Exception + LGPL dynamic link exceptions", detail: "libstdc++, gcc-14, Nettle, libgcrypt consume review capacity as In Violation. These are covered by standard legal exceptions. Document in Black Duck component notes and apply policy exception to stop recurring violations.", component: "libstdc++/Nettle", version: "14.2.0 / 3.10.1" },
  ];

  // Analyst notes extracted from CSV comments
  const ANALYST_NOTES = [
    { comp: "tar 7.5.7", who: "Amit Kumar", date: "2026-02-27", note: "The tar package flagged (CVE-2026-26960) is only used as a build/install dependency of Muhammara (via @mapbox/node-pre-gyp). It is not loaded or used at runtime in the deployed application. All PHI data handling occurs after build-time, so there is no runtime exposure. Risk is limited to build environments, not production. No further action required unless Muhammara begins using tar at runtime." },
    { comp: "minipass 7.1.3", who: "Amit Kumar", date: "2026-02-27", note: "The minipass version is locked by the tar dependency, which is required by build/install tooling (not runtime code). We cannot upgrade minipass directly until upstream dependencies update their requirements. There is no runtime or PHI exposure." },
    { comp: "yallist 3.1.1", who: "Amit Kumar", date: "2026-02-27", note: "yallist is not used in your application code. It is only present because some dependencies require it. The Black Duck issue is due to its presence in your dependency tree, not because you use it directly. If your dependencies update to use newer versions of lru-cache, yallist@5.x will be used and the issue will resolve. 1) only used during build time and not during run time 2) already raised issue with MuhammaraJS and Babel teams to upgrade the versions." },
    { comp: "ca-certificates 20250419", who: "Aman Khanna", date: "2025-11-24", note: "Root CA certificates bundle. GPL-2.0 licensed (packaging, not certificates themselves). Certificates are public data. Application uses for HTTPS/TLS but does not distribute certificate management code. False positive. Hence, ignored." },
    { comp: "keyutils 1.6.3", who: "Yashwant Hanumanthegowda", date: "2026-02-27", note: "https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git/snapshot/keyutils-1.6.3.tar.gz — need to confirm L1 approve." },
    { comp: "libstdc++ 14.2.0", who: "Yashwant Hanumanthegowda", date: "2026-02-27", note: "https://www.linuxfromscratch.org/lfs/view/12.3-systemd/chapter05/gcc-libstdc%2B%2B.html — need to confirmation. GCC Runtime Library Exception applies — programs compiled with GCC can be distributed under any license." },
  ];

  const TABS = [
    { id: "summary",    label: "📊 Summary"       },
    { id: "risk",       label: "🔴 Risk & CVEs"   },
    { id: "license",    label: "⚖ Licenses"       },
    { id: "ecosystem",  label: "📦 Ecosystem"      },
    { id: "violations", label: "⚠ Violations"     },
    { id: "actions",    label: "🎯 Action Items"   },
    { id: "notes",      label: "📝 Analyst Notes"  },
  ];

  const FAM_COLOR = { "Permissive": C.green, "Weak Copyleft": C.amber, "Strong Copyleft": C.red, "Public Domain": "#56d8e4", "Proprietary": C.purple, "Unknown": C.textMuted };

  return (
    <div style={{ background: C.bgPanel, borderBottom: `2px solid ${C.border}` }}>
      {/* Header */}
      <div style={{ display: "flex", alignItems: "center", gap: "14px", padding: "16px 20px", borderBottom: `1px solid ${C.border}` }}>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: "14px", fontWeight: "700", color: C.accent, letterSpacing: "0.05em" }}>📊 SCAN ANALYSIS REPORT — cgt-service-phi-doc-image 2511</div>
          <div style={{ fontSize: "11px", color: C.textSecondary, marginTop: "3px" }}>{total} components · Black Duck SCA export · Scan date 2026-03-03 · PHI application</div>
        </div>
        <button onClick={onClose} style={{ ...S.btn(false), padding: "5px 12px", color: C.red }}>✕ Close</button>
      </div>

      {/* Tab bar */}
      <div style={{ display: "flex", gap: "4px", padding: "10px 20px", borderBottom: `1px solid ${C.border}`, flexWrap: "wrap" }}>
        {TABS.map(t => <button key={t.id} onClick={() => setTab(t.id)} style={{ ...S.btn(tab === t.id), fontSize: "11px", padding: "5px 14px" }}>{t.label}</button>)}
      </div>

      <div style={{ padding: "16px 20px", maxHeight: "72vh", overflowY: "auto" }}>

        {/* ── SUMMARY TAB ── */}
        {tab === "summary" && (
          <div style={{ display: "flex", flexDirection: "column", gap: "16px" }}>
            {/* KPI tiles */}
            <div style={{ display: "grid", gridTemplateColumns: "repeat(5,1fr)", gap: "10px" }}>
              {[
                ["TOTAL", total, C.accent],
                ["HIGH RISK", byHigh + byCritical, C.red],
                ["MEDIUM RISK", byMedium, C.amber],
                ["IN VIOLATION", inViolation, "#f5a623"],
                ["COPYLEFT", copyleftComps.length, "#a07cf0"],
              ].map(([l, v, col]) => (
                <div key={l} style={{ padding: "16px", background: C.bgInput, border: `1px solid ${col}30`, borderRadius: "8px", textAlign: "center" }}>
                  <div style={{ fontSize: "9px", color: C.textLabel, letterSpacing: "0.1em", fontWeight: "700", marginBottom: "6px" }}>{l}</div>
                  <div style={{ fontSize: "32px", fontWeight: "800", color: col }}>{v}</div>
                </div>
              ))}
            </div>

            {/* Operational risk bar */}
            <div style={{ ...S.card }}>
              <div style={{ fontSize: "10px", color: C.textLabel, fontWeight: "700", letterSpacing: "0.1em", marginBottom: "12px" }}>OPERATIONAL RISK DISTRIBUTION</div>
              {[["Critical", byCritical, C.red], ["High", byHigh, C.red], ["Medium", byMedium, C.amber], ["Low", byLow, "#ffd060"], ["OK/None", byOK, C.green]].map(([l, v, col]) => {
                const pct = total ? Math.round((v / total) * 100) : 0;
                return (
                  <div key={l} style={{ display: "flex", alignItems: "center", gap: "10px", marginBottom: "7px" }}>
                    <span style={{ fontSize: "10px", color: col, fontFamily: "monospace", minWidth: "70px", fontWeight: "700" }}>{l}</span>
                    <div style={{ flex: 1, height: "8px", background: C.border, borderRadius: "4px", overflow: "hidden" }}>
                      <div style={{ width: `${pct}%`, height: "100%", background: col, borderRadius: "4px" }} />
                    </div>
                    <span style={{ fontSize: "10px", color: col, fontFamily: "monospace", minWidth: "40px", textAlign: "right" }}>{v} ({pct}%)</span>
                  </div>
                );
              })}
            </div>

            {/* Quick findings */}
            <div style={{ ...S.card }}>
              <div style={{ fontSize: "10px", color: C.textLabel, fontWeight: "700", letterSpacing: "0.1em", marginBottom: "12px" }}>KEY FINDINGS</div>
              {[
                ["🔴", "Python 3.14.2 has 6 HIGH + 3 MEDIUM CVEs — runtime interpreter for PHI document processing", C.red],
                ["🔴", "tar 7.5.7 has 1 HIGH CVE (CVE-2026-26960) — patched version 7.5.9 also present in image", C.red],
                ["🔴", "OpenSSL 3.5.5 has 1 HIGH CVE — TLS library used for PHI data in transit", C.red],
                ["🟠", "gcc-14 + build toolchain present in production image — dramatically increases attack surface", C.amber],
                ["🟠", "npm CLI (npm-cli 11.6.2) present in production container — should be build-stage only", C.amber],
                ["🟡", "~200 components flagged 'In Violation' — mostly policy review backlog, not security issues", "#ffd060"],
                ["🟡", "yallist present in 3 versions (3.1.1 HIGH, 4.0.0 MEDIUM, 5.0.0 OK) — resolve with overrides", "#ffd060"],
                ["🟡", "Apache Subversion 1.14.5 in production image — unnecessary, remove to reduce attack surface", "#ffd060"],
                ["🟢", "~76% of components are PERMISSIVE license — MIT, Apache-2.0, ISC, BSD", C.green],
                ["🟢", "LGPL/GPL copyleft components (libstdc++, Nettle, gcc-14) covered by legal exceptions", C.green],
                ["🟢", "Core app stack clean: express 5.2.1, axios 1.13.5, jsonwebtoken 9.0.3, weasyprint 68.1", C.green],
              ].map(([icon, text, col], i) => (
                <div key={i} style={{ display: "flex", gap: "10px", padding: "6px 0", borderBottom: `1px solid ${C.border}` }}>
                  <span style={{ fontSize: "14px" }}>{icon}</span>
                  <span style={{ fontSize: "11px", color: col, lineHeight: "1.6" }}>{text}</span>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* ── RISK & CVEs TAB ── */}
        {tab === "risk" && (
          <div style={{ display: "flex", flexDirection: "column", gap: "14px" }}>
            <div style={{ padding: "12px 16px", background: "#1e0508", border: `1px solid ${C.red}50`, borderRadius: "8px" }}>
              <div style={{ fontSize: "11px", color: C.red, fontWeight: "700", marginBottom: "10px" }}>⚠ COMPONENTS WITH CVEs (Total: 4 components, 12 CVEs)</div>
              {[
                { name: "Python programming language", ver: "3.14.2", critical: 0, high: 6, medium: 3, low: 0, note: "Runtime interpreter actively processing PHI documents. HIGHEST PRIORITY." },
                { name: "tar", ver: "7.5.7", critical: 0, high: 1, medium: 0, low: 0, note: "Build/install dep of Muhammara. tar 7.5.9 (patched) also present. Fix: npm overrides." },
                { name: "OpenSSL", ver: "3.5.5", critical: 0, high: 1, medium: 0, low: 0, note: "TLS library. Check for Debian security backport before rebuilding base image." },
                { name: "libexpat", ver: "2.7.4", critical: 0, high: 0, medium: 0, low: 1, note: "XML parsing library. LOW severity — patch in next routine update cycle." },
              ].map((r, i) => (
                <div key={i} style={{ padding: "10px 14px", background: C.bgInput, border: `1px solid ${C.border}`, borderRadius: "6px", marginBottom: "8px" }}>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", flexWrap: "wrap", gap: "8px", marginBottom: "6px" }}>
                    <span style={{ fontSize: "13px", fontWeight: "700", color: C.textPrimary, fontFamily: "monospace" }}>{r.name} <span style={{ color: C.textMuted, fontWeight: "400" }}>v{r.ver}</span></span>
                    <div style={{ display: "flex", gap: "6px" }}>
                      {r.critical > 0 && <span style={{ fontSize: "10px", color: C.red, background: `${C.red}20`, border: `1px solid ${C.red}50`, borderRadius: "4px", padding: "2px 8px", fontWeight: "700" }}>CRITICAL: {r.critical}</span>}
                      {r.high > 0 && <span style={{ fontSize: "10px", color: C.red, background: `${C.red}15`, border: `1px solid ${C.red}40`, borderRadius: "4px", padding: "2px 8px", fontWeight: "700" }}>HIGH: {r.high}</span>}
                      {r.medium > 0 && <span style={{ fontSize: "10px", color: C.amber, background: `${C.amber}15`, border: `1px solid ${C.amber}40`, borderRadius: "4px", padding: "2px 8px", fontWeight: "700" }}>MEDIUM: {r.medium}</span>}
                      {r.low > 0 && <span style={{ fontSize: "10px", color: "#ffd060", background: "#ffd06015", border: "1px solid #ffd06040", borderRadius: "4px", padding: "2px 8px", fontWeight: "700" }}>LOW: {r.low}</span>}
                    </div>
                  </div>
                  <div style={{ fontSize: "11px", color: C.textSecondary, lineHeight: "1.6" }}>{r.note}</div>
                </div>
              ))}
            </div>

            <div style={{ ...S.card }}>
              <div style={{ fontSize: "10px", color: C.textLabel, fontWeight: "700", letterSpacing: "0.1em", marginBottom: "12px" }}>HIGH OPERATIONAL RISK COMPONENTS (no CVEs but risk-flagged)</div>
              {[
                { name: "minipass", ver: "7.1.3", risk: "HIGH", note: "HIGH operational risk rating from Black Duck. No CVEs. Risk likely reflects recent release with limited history or declining maintenance. Core I/O streaming library in npm CLI pipeline. Amit Kumar confirmed: locked by tar build dependency, no runtime PHI exposure." },
                { name: "yallist", ver: "3.1.1", risk: "HIGH", note: "HIGH operational risk. No CVEs. Three concurrent versions (3.1.1, 4.0.0, 5.0.0) indicate unresolved dependency conflict. Only used at build time per analyst note. Resolve with npm package.json overrides." },
              ].map((r, i) => (
                <div key={i} style={{ padding: "10px 14px", background: C.bgInput, border: `1px solid ${C.amber}30`, borderRadius: "6px", marginBottom: "8px" }}>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "6px" }}>
                    <span style={{ fontSize: "13px", fontWeight: "700", color: C.textPrimary, fontFamily: "monospace" }}>{r.name} <span style={{ color: C.textMuted, fontWeight: "400" }}>v{r.ver}</span></span>
                    <span style={{ fontSize: "10px", color: C.red, background: `${C.red}20`, border: `1px solid ${C.red}50`, borderRadius: "4px", padding: "2px 8px", fontWeight: "700" }}>RISK: {r.risk}</span>
                  </div>
                  <div style={{ fontSize: "11px", color: C.textSecondary, lineHeight: "1.6" }}>{r.note}</div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* ── LICENSE TAB ── */}
        {tab === "license" && (
          <div style={{ display: "flex", flexDirection: "column", gap: "14px" }}>
            <div style={{ ...S.card }}>
              <div style={{ fontSize: "10px", color: C.textLabel, fontWeight: "700", letterSpacing: "0.1em", marginBottom: "12px" }}>LICENSE FAMILY DISTRIBUTION</div>
              {Object.entries(licFamilyMap).sort((a, b) => b[1] - a[1]).map(([fam, cnt]) => {
                const col = FAM_COLOR[fam] || C.textMuted;
                const pct = total ? Math.round((cnt / total) * 100) : 0;
                return (
                  <div key={fam} style={{ display: "flex", alignItems: "center", gap: "10px", marginBottom: "8px" }}>
                    <span style={{ fontSize: "10px", color: col, fontFamily: "monospace", minWidth: "160px", fontWeight: "700" }}>{fam}</span>
                    <div style={{ flex: 1, height: "8px", background: C.border, borderRadius: "4px", overflow: "hidden" }}>
                      <div style={{ width: `${pct}%`, height: "100%", background: col, borderRadius: "4px" }} />
                    </div>
                    <span style={{ fontSize: "10px", color: col, fontFamily: "monospace", minWidth: "55px", textAlign: "right" }}>{cnt} ({pct}%)</span>
                  </div>
                );
              })}
            </div>

            <div style={{ ...S.card }}>
              <div style={{ fontSize: "10px", color: C.textLabel, fontWeight: "700", letterSpacing: "0.1em", marginBottom: "10px" }}>⚖ COPYLEFT COMPONENTS — COMPLIANCE ANALYSIS</div>
              {[
                { name: "gcc-14 + gcc-14-base", lic: "GPL-3.0 + Runtime Library Exception", safe: true, note: "GCC Runtime Library Exception explicitly permits libstdc++ use in proprietary software. Programs compiled with GCC can be distributed under ANY license. No source disclosure required for your app." },
                { name: "libstdc++ 14.2.0", lic: "GPL-3.0 + Runtime Library Exception", safe: true, note: "Same GCC Runtime Library Exception applies. Dynamically linked — does not create GPL obligations on your application code." },
                { name: "libhwasan0 14.2.0", lic: "GPL-3.0 + Runtime Library Exception", safe: true, note: "Hardware Address Sanitizer runtime. Covered by GCC Runtime Library Exception. Safe for production use." },
                { name: "Nettle 3.10.1", lic: "LGPL-3.0 + GPL-2.0", safe: true, note: "LGPL portion applies to the library. Dynamically linked (standard Debian package) — your app code does NOT need to be GPL. Only modifications to Nettle itself must be shared." },
                { name: "Pango 1.57.0", lic: "LGPL-2.0+", safe: true, note: "LGPL-2.0 dynamically linked. Safe for proprietary apps. Only modifications to Pango itself need to be shared." },
                { name: "libgcrypt 1.11.0", lic: "LGPL-2.1 + Public Domain mix", safe: true, note: "Library portion is LGPL-2.1 — dynamically linked use is safe for proprietary apps. Utility programs (gpg-error etc.) are GPL but are tools, not libraries your app calls." },
                { name: "libcrypt1 4.4.38", lic: "LGPL-2.1+", safe: true, note: "Standard C library crypto extension. Dynamically linked system library. LGPL system library exception fully covers proprietary application use." },
                { name: "libsemanage1 / libsepol 3.8.1", lic: "LGPL-2.1+", safe: true, note: "SELinux management libraries. Dynamically linked. No source disclosure obligation on your app." },
                { name: "keyutils 1.6.3", lic: "GPL-2.0 + LGPL-2.1", safe: true, note: "libkeyutils.so is LGPL-2.1 (dynamic link safe). GPL-2.0 applies only to the keyutils command-line utilities, not the library. Safe for production use IF only the shared library is used." },
                { name: "audit-userspace 4.0.2", lic: "LGPL-2.0+", safe: true, note: "Linux audit library. Dynamically linked. LGPL allows proprietary use. Intentional for PHI audit logging compliance — keep." },
                { name: "npm-cli 11.6.2", lic: "Artistic-2.0 (Weak Copyleft)", safe: true, note: "Artistic-2.0 weak copyleft. Modified copies must be published, but using npm as a tool does not create obligations. Your application does not link to npm's code." },
                { name: "Perl/CPAN modules (dual-licensed)", lic: "Artistic-1.0 OR GPL-1.0+", safe: true, note: "All CPAN modules use Perl's standard dual license. Since you are not modifying or distributing a Perl interpreter, no obligations apply to your application code. These are runtime interpreter internals." },
              ].map((r, i) => (
                <div key={i} style={{ padding: "8px 12px", background: r.safe ? `${C.green}08` : `${C.red}10`, border: `1px solid ${r.safe ? C.green : C.red}30`, borderRadius: "6px", marginBottom: "6px" }}>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", gap: "8px", marginBottom: "4px" }}>
                    <span style={{ fontSize: "11px", fontWeight: "700", color: C.textPrimary, fontFamily: "monospace" }}>{r.name}</span>
                    <div style={{ display: "flex", gap: "6px", flexShrink: 0 }}>
                      <span style={{ fontSize: "10px", color: C.purple, fontFamily: "monospace" }}>{r.lic}</span>
                      <span style={{ fontSize: "10px", color: r.safe ? C.green : C.red, fontWeight: "700", padding: "1px 8px", background: `${r.safe ? C.green : C.red}15`, border: `1px solid ${r.safe ? C.green : C.red}40`, borderRadius: "4px" }}>{r.safe ? "✅ SAFE" : "❌ REVIEW"}</span>
                    </div>
                  </div>
                  <div style={{ fontSize: "11px", color: C.textSecondary, lineHeight: "1.6" }}>{r.note}</div>
                </div>
              ))}
              <div style={{ marginTop: "10px", padding: "10px 14px", background: `${C.green}10`, border: `1px solid ${C.green}30`, borderRadius: "6px", fontSize: "11px", color: C.green, lineHeight: "1.7" }}>
                ✅ <b>Conclusion:</b> No component in this dataset requires your proprietary application source code to be disclosed, provided all LGPL components are dynamically linked (standard for all Debian-packaged libraries). The presence of RECIPROCAL-family components in a container does not create obligations if the application does not statically incorporate them.
              </div>
            </div>
          </div>
        )}

        {/* ── ECOSYSTEM TAB ── */}
        {tab === "ecosystem" && (
          <div style={{ display: "flex", flexDirection: "column", gap: "14px" }}>
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "14px" }}>
              {/* Ecosystem pie-like breakdown */}
              <div style={{ ...S.card }}>
                <div style={{ fontSize: "10px", color: C.textLabel, fontWeight: "700", letterSpacing: "0.1em", marginBottom: "12px" }}>ECOSYSTEM BREAKDOWN</div>
                {[["npm",    230, "#cc3333", "Most components. Deep utility tree. npm CLI + build tools in image."],
                  ["Debian", 55,  "#e96228", "System OS packages. Debian 13 Bookworm. Compiler toolchain present."],
                  ["CPAN",   46,  "#6688cc", "Perl core modules. All In Violation (policy). No security issues."],
                  ["PyPI",   25,  "#ffd060", "Python PDF/image stack: weasyprint, fonttools, Pillow, setuptools."],
                  ["GitHub", 2,   C.green,   "Direct GitHub source pulls: Python 3.14.2, libjpeg-turbo."],
                  ["Other",  2,   C.textMuted, "mpdecimal (unknown origin), XZ Utils."],
                ].map(([eco, cnt, col, note]) => (
                  <div key={eco} style={{ padding: "8px 0", borderBottom: `1px solid ${C.border}` }}>
                    <div style={{ display: "flex", alignItems: "center", gap: "8px", marginBottom: "4px" }}>
                      <span style={{ fontSize: "11px", fontWeight: "700", color: col, fontFamily: "monospace", minWidth: "60px" }}>{eco}</span>
                      <div style={{ flex: 1, height: "6px", background: C.border, borderRadius: "3px", overflow: "hidden" }}>
                        <div style={{ width: `${Math.round((cnt / total) * 100)}%`, height: "100%", background: col, borderRadius: "3px" }} />
                      </div>
                      <span style={{ fontSize: "10px", color: col, fontFamily: "monospace", minWidth: "40px", textAlign: "right" }}>{cnt}</span>
                    </div>
                    <div style={{ fontSize: "10px", color: C.textMuted, lineHeight: "1.5" }}>{note}</div>
                  </div>
                ))}
              </div>

              {/* Key findings per ecosystem */}
              <div style={{ display: "flex", flexDirection: "column", gap: "10px" }}>
                <div style={{ ...S.card }}>
                  <div style={{ fontSize: "10px", color: "#cc3333", fontWeight: "700", marginBottom: "8px" }}>📦 npm CONCERNS</div>
                  {["Version conflicts: tar (7.5.7+7.5.9), yallist (3 versions), cacache (2 versions), https-proxy-agent (2 versions)",
                    "npm CLI + @npmcli/* toolchain in production image — should be build-stage only",
                    "jsonwebtoken 9.0.3 In Violation — JWT auth library, needs review approval",
                    "https-proxy-agent 5.0.1 is MEDIUM risk — outdated alongside 7.0.6"].map((t,i) => (
                    <div key={i} style={{ fontSize: "10px", color: C.textSecondary, padding: "4px 0", borderBottom: `1px solid ${C.border}`, lineHeight: "1.5" }}>• {t}</div>
                  ))}
                </div>
                <div style={{ ...S.card }}>
                  <div style={{ fontSize: "10px", color: "#e96228", fontWeight: "700", marginBottom: "8px" }}>🐧 Debian CONCERNS</div>
                  {["gcc-14 + libasan8 + libhwasan0 — full compiler in production container",
                    "Apache Subversion 1.14.5 — SVN client, remove from production",
                    "OpenSSL 3.5.5 — 1 HIGH CVE, check Debian backport",
                    "curl 8.19.0~rc3 — RELEASE CANDIDATE in production — upgrade to stable"].map((t,i) => (
                    <div key={i} style={{ fontSize: "10px", color: C.textSecondary, padding: "4px 0", borderBottom: `1px solid ${C.border}`, lineHeight: "1.5" }}>• {t}</div>
                  ))}
                </div>
                <div style={{ ...S.card }}>
                  <div style={{ fontSize: "10px", color: "#ffd060", fontWeight: "700", marginBottom: "8px" }}>🐍 PyPI STACK</div>
                  {["weasyprint 68.1 — HTML→PDF rendering for PHI documents",
                    "Pillow 12.1.1 — image processing for PHI doc scans",
                    "Python 3.14.2 — 9 CVEs — IMMEDIATE ACTION REQUIRED",
                    "fonttools, pydyf, tinyhtml5, tinycss2, cssselect2 — PDF dependency chain"].map((t,i) => (
                    <div key={i} style={{ fontSize: "10px", color: C.textSecondary, padding: "4px 0", borderBottom: `1px solid ${C.border}`, lineHeight: "1.5" }}>• {t}</div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        )}

        {/* ── VIOLATIONS TAB ── */}
        {tab === "violations" && (
          <div style={{ display: "flex", flexDirection: "column", gap: "14px" }}>
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "12px" }}>
              <div style={{ padding: "16px", background: `${C.red}10`, border: `1px solid ${C.red}30`, borderRadius: "8px", textAlign: "center" }}>
                <div style={{ fontSize: "9px", color: C.textLabel, letterSpacing: "0.1em", marginBottom: "6px" }}>IN VIOLATION</div>
                <div style={{ fontSize: "40px", fontWeight: "800", color: C.red }}>{inViolation}</div>
                <div style={{ fontSize: "10px", color: C.textMuted, marginTop: "4px" }}>{total ? Math.round((inViolation/total)*100) : 0}% of total</div>
              </div>
              <div style={{ padding: "16px", background: `${C.green}10`, border: `1px solid ${C.green}30`, borderRadius: "8px", textAlign: "center" }}>
                <div style={{ fontSize: "9px", color: C.textLabel, letterSpacing: "0.1em", marginBottom: "6px" }}>NOT IN VIOLATION</div>
                <div style={{ fontSize: "40px", fontWeight: "800", color: C.green }}>{notInViolation}</div>
                <div style={{ fontSize: "10px", color: C.textMuted, marginTop: "4px" }}>{total ? Math.round((notInViolation/total)*100) : 0}% of total</div>
              </div>
            </div>

            <div style={{ ...S.card }}>
              <div style={{ fontSize: "10px", color: C.textLabel, fontWeight: "700", letterSpacing: "0.1em", marginBottom: "12px" }}>WHY SO MANY "IN VIOLATION"? — ROOT CAUSE ANALYSIS</div>
              {[
                ["⚠ Policy Rule 1", "All CPAN components require review", "All ~46 CPAN/Perl components are In Violation. Perl dual license (Artistic+GPL) triggers automatic legal review flag. Not a security issue."],
                ["⚠ Policy Rule 2", "npm components require approved license list", "~150 npm violations. Even MIT-licensed packages require explicit legal sign-off per org policy. Until reviewed → In Violation."],
                ["⚠ Policy Rule 3", "Component review required before production use", "Blanket policy: every component needs human approval in Black Duck. These are awaiting triage, not actionable security issues."],
                ["⚠ Policy Rule 4", "Operational risk > OK requires review", "Components rated LOW/MEDIUM/HIGH are auto-flagged regardless of license. Explains 'OK' license components still In Violation."],
                ["✅ What it does NOT mean", "All 200 are security vulnerabilities", "Only 4 components have actual CVEs. The other 196 'In Violation' items are policy backlog, not security holes."],
              ].map(([badge, title, detail], i) => (
                <div key={i} style={{ padding: "10px 12px", background: C.bgInput, border: `1px solid ${C.border}`, borderRadius: "6px", marginBottom: "6px" }}>
                  <div style={{ display: "flex", gap: "10px", alignItems: "flex-start" }}>
                    <span style={{ fontSize: "10px", color: C.amber, fontFamily: "monospace", fontWeight: "700", minWidth: "120px", flexShrink: 0 }}>{badge}</span>
                    <div>
                      <div style={{ fontSize: "11px", color: C.textPrimary, fontWeight: "700", marginBottom: "3px" }}>{title}</div>
                      <div style={{ fontSize: "11px", color: C.textSecondary, lineHeight: "1.6" }}>{detail}</div>
                    </div>
                  </div>
                </div>
              ))}
            </div>

            <div style={{ padding: "12px 16px", background: `${C.accent}10`, border: `1px solid ${C.accent}30`, borderRadius: "8px" }}>
              <div style={{ fontSize: "11px", color: C.accent, fontWeight: "700", marginBottom: "6px" }}>💡 RECOMMENDED ACTION</div>
              <div style={{ fontSize: "11px", color: C.textSecondary, lineHeight: "1.8" }}>
                Work with your Black Duck administrator to create an <b style={{ color: C.textPrimary }}>auto-approval policy</b> for components matching ALL of:
                license family = PERMISSIVE + operational risk = OK + CVE count = 0 + review status = UNREVIEWED.
                This would immediately clear ~80–100 violations and reduce noise so the team can focus on genuine risks.
              </div>
            </div>
          </div>
        )}

        {/* ── ACTION ITEMS TAB ── */}
        {tab === "actions" && (
          <div style={{ display: "flex", flexDirection: "column", gap: "10px" }}>
            <div style={{ padding: "10px 14px", background: C.bgInput, border: `1px solid ${C.border}`, borderRadius: "6px", fontSize: "11px", color: C.textSecondary }}>
              Top 10 action items ranked by priority for <b style={{ color: C.textPrimary }}>cgt-service-phi-doc-image 2511</b> (PHI application — HIPAA compliance required)
            </div>
            {ACTION_ITEMS.map((a, i) => (
              <div key={i} style={{ padding: "12px 16px", background: C.bgInput, border: `1px solid ${
                a.priority.startsWith("🔴") ? `${C.red}40` : a.priority.startsWith("🟠") ? `${C.amber}40` : a.priority.startsWith("🟡") ? "#ffd06040" : "#4fc3f740"
              }`, borderRadius: "8px" }}>
                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", gap: "8px", flexWrap: "wrap", marginBottom: "6px" }}>
                  <div style={{ display: "flex", gap: "10px", alignItems: "center" }}>
                    <span style={{ fontSize: "11px", fontFamily: "monospace", fontWeight: "700", color: C.textMuted }}>#{i + 1}</span>
                    <span style={{ fontSize: "12px", fontWeight: "700", color: C.textPrimary }}>{a.title}</span>
                  </div>
                  <div style={{ display: "flex", gap: "8px", flexShrink: 0 }}>
                    <span style={{ fontSize: "10px", fontFamily: "monospace", color: C.purple, padding: "2px 8px", background: `${C.purple}15`, border: `1px solid ${C.purple}30`, borderRadius: "4px" }}>{a.component} v{a.version}</span>
                    <span style={{ fontSize: "11px", fontWeight: "700" }}>{a.priority}</span>
                  </div>
                </div>
                <div style={{ fontSize: "11px", color: C.textSecondary, lineHeight: "1.8", paddingLeft: "30px" }}>{a.detail}</div>
              </div>
            ))}
          </div>
        )}

        {/* ── ANALYST NOTES TAB ── */}
        {tab === "notes" && (
          <div style={{ display: "flex", flexDirection: "column", gap: "12px" }}>
            <div style={{ padding: "10px 14px", background: C.bgInput, border: `1px solid ${C.border}`, borderRadius: "6px", fontSize: "11px", color: C.textSecondary }}>
              These notes were extracted directly from the <b style={{ color: C.textPrimary }}>Comments</b> column of the Black Duck CSV export. They represent analyst assessments made during review.
            </div>
            {ANALYST_NOTES.map((n, i) => (
              <div key={i} style={{ padding: "14px 16px", background: C.bgInput, border: `1px solid ${C.borderHi}40`, borderRadius: "8px" }}>
                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "8px", flexWrap: "wrap", gap: "6px" }}>
                  <span style={{ fontSize: "12px", fontWeight: "700", color: C.accent, fontFamily: "monospace" }}>{n.comp}</span>
                  <div style={{ display: "flex", gap: "10px" }}>
                    <span style={{ fontSize: "10px", color: C.textMuted, fontFamily: "monospace" }}>👤 {n.who}</span>
                    <span style={{ fontSize: "10px", color: C.textMuted, fontFamily: "monospace" }}>📅 {n.date}</span>
                  </div>
                </div>
                <div style={{ fontSize: "11px", color: C.textSecondary, lineHeight: "1.9", padding: "10px 12px", background: C.bgPanel, border: `1px solid ${C.border}`, borderRadius: "5px", whiteSpace: "pre-wrap" }}>{n.note}</div>
              </div>
            ))}
            <div style={{ padding: "12px 16px", background: `${C.amber}10`, border: `1px solid ${C.amber}30`, borderRadius: "8px", fontSize: "11px", color: C.amber, lineHeight: "1.8" }}>
              <b>Note:</b> Several additional analyst comments exist in the CSV for individual Perl/CPAN components (ExtUtils::Constant, File::Path, IPC::SysV, etc.) referencing CPAN source URLs for license verification. These are routine review-in-progress notes and do not indicate security concerns.
            </div>
          </div>
        )}
      </div>
    </div>
  );
}


function Row({ comp, analysis, index, githubToken, llmCfg, detectedLic, onDetect, conflict, appLayerStart, relation }) {
  const [open, setOpen] = useState(false);
  const [detectingThis, setDetectingThis] = useState(false);
  const rs   = RISK_S[comp.risk] || RISK_S.Unknown;
  const zone = getLayerZone(comp.layer);

  const isAppLayerComp = appLayerStart != null && comp.layer >= appLayerStart;

  // Resolved license — use detected if original was Unknown
  const licInfo   = detectedLic || { license: comp.license, source: "scan", confidence: "high" };
  const licText   = licInfo.license || "Unknown";
  const isDetected = licInfo.source && licInfo.source !== "scan" && licInfo.source !== "none";
  const SOURCE_ICON = { npm: "📦", pypi: "🐍", clearlydefined: "🔎", "well-known": "🗂", github: "🐙", ai: "🤖" };
  const licColor  = NEEDS_DETECT(licText) ? C.amber
                  : LICENSE_FACTS[licText]?.risk === "High"   ? C.red
                  : LICENSE_FACTS[licText]?.risk === "Medium" ? C.amber
                  : C.textSecondary;

  const handleDetectThis = async (e) => {
    e.stopPropagation();
    setDetectingThis(true);
    const result = await detectLicense(comp.name, comp.version, {
      githubToken,
      llmCfg: llmCfg?.apiKey?.trim() ? llmCfg : null,
    });
    if (onDetect) onDetect(result);
    setDetectingThis(false);
  };

  return (
    <div style={{ borderBottom: `1px solid ${C.border}`, background: open ? C.bgPanel : "transparent", transition: "background 0.15s" }}>
      <div
        onClick={() => setOpen(o => !o)}
        style={{
          display: "grid", gridTemplateColumns: "40px 1fr 60px 50px 140px 110px 90px 24px",
          alignItems: "center", gap: "10px", padding: "10px 18px", cursor: "pointer",
        }}
      >
        <span style={{ fontSize: "11px", color: C.textMuted, fontFamily: "monospace", fontWeight: "600" }}>
          {String(index + 1).padStart(3, "0")}
        </span>

        <div style={{ minWidth: 0 }}>
          <div style={{ display: "flex", alignItems: "center", gap: "8px", flexWrap: "wrap" }}>
            <span style={{ fontSize: "13px", fontWeight: "700", color: C.textPrimary, fontFamily: "monospace" }}>{comp.name}</span>
            <span style={{ fontSize: "10px", color: C.textMuted, fontFamily: "monospace" }}>v{comp.version}</span>

            {/* App-layer role badge */}
            {analysis?.appLayerRole && (
              <span title={analysis.appLayerRoleNote || ""} style={{
                fontSize: "10px", padding: "1px 7px", borderRadius: "3px", fontWeight: "700", fontFamily: "monospace",
                background: analysis.appLayerRole === "imported"     ? "#4fc3f720"
                          : analysis.appLayerRole === "runtime-dep"  ? "#c6ff0015"
                          : analysis.appLayerRole === "build-only"   ? "#78909c20"
                          : "#78909c15",
                border: `1px solid ${
                          analysis.appLayerRole === "imported"     ? "#4fc3f770"
                        : analysis.appLayerRole === "runtime-dep"  ? "#c6ff0055"
                        : analysis.appLayerRole === "build-only"   ? "#78909c55"
                        : "#78909c40"}`,
                color:  analysis.appLayerRole === "imported"     ? "#4fc3f7"
                      : analysis.appLayerRole === "runtime-dep"  ? "#c6ff00"
                      : analysis.appLayerRole === "build-only"   ? "#78909c"
                      : "#78909c",
                cursor: "help",
              }}>
                {analysis.appLayerRole === "imported"    ? "📦 IMPORTED"
                : analysis.appLayerRole === "runtime-dep" ? "⚙ RUNTIME DEP"
                : analysis.appLayerRole === "build-only"  ? "🏗 BUILD ONLY"
                : "🖥 SYSTEM"}
              </span>
            )}

            {/* Cross-layer conflict badge */}
            {conflict && (
              <span
                title={conflict.reason}
                style={{
                  fontSize: "10px", padding: "1px 7px", borderRadius: "3px", fontWeight: "700", fontFamily: "monospace",
                  background: "#f0506015", border: "1px solid #f0506070", color: C.red, cursor: "help",
                }}
              >
                ⚠ CROSS-LAYER CONFLICT
              </span>
            )}

            {isAppLayerComp && !analysis?.appLayerRole && (
              <span style={{ fontSize: "9px", color: "#4fc3f7", fontFamily: "monospace", padding: "1px 6px", background: "#4fc3f710", border: "1px solid #4fc3f730", borderRadius: "3px" }}>
                APP LAYER
              </span>
            )}

            {analysis && (
              <span style={{
                fontSize: "10px", padding: "1px 7px", borderRadius: "3px", fontWeight: "700", fontFamily: "monospace",
                background: analysis.isActivelyUsed ? `${C.green}15` : `${C.red}15`,
                border: `1px solid ${analysis.isActivelyUsed ? C.green : C.red}55`,
                color: analysis.isActivelyUsed ? C.green : C.red,
              }}>
                {analysis.isActivelyUsed ? "ACTIVE" : "SUSPECT"}
              </span>
            )}
            {analysis?.runtimeOrBuild && (
              <span style={{ fontSize: "10px", color: analysis.runtimeOrBuild === "build-only" ? C.textMuted : C.green, fontFamily: "monospace" }}>
                {analysis.runtimeOrBuild === "build-only" ? "🏗 BUILD" : analysis.runtimeOrBuild === "runtime" ? "⚙ RT" : "⚙+🏗"}
              </span>
            )}

            {/* Coupling strength dots */}
            {relation && (
              <span title={`Coupling: ${relation.meta.label}\n${relation.reasonLines[0] || ""}`} style={{ display: "inline-flex", alignItems: "center", gap: "2px", cursor: "help" }}>
                {[1,2,3,4,5].map(d => (
                  <span key={d} style={{ display: "inline-block", width: "7px", height: "7px", borderRadius: "1px", background: d <= relation.meta.dots ? relation.meta.color : C.border }} />
                ))}
              </span>
            )}

            {/* Copyleft exposure badge — only shown when there is actual exposure */}
            {relation && relation.copyleftExposure !== "none" && (
              <span title={relation.copyleftNote || relation.copyleftExposureMeta.desc} style={{
                fontSize: "9px", padding: "1px 6px", borderRadius: "3px", fontWeight: "700", fontFamily: "monospace",
                background: `${relation.copyleftExposureMeta.color}18`,
                border: `1px solid ${relation.copyleftExposureMeta.color}55`,
                color: relation.copyleftExposureMeta.color,
                cursor: "help",
              }}>
                ⚖ {relation.copyleftExposureMeta.label.toUpperCase()}
              </span>
            )}
          </div>

          {/* Conflict reason bar — shown directly under name when conflict detected */}
          {conflict && open === false && (
            <div style={{ fontSize: "10px", color: C.red, fontFamily: "monospace", marginTop: "2px", lineHeight: "1.5", opacity: 0.85 }}>
              ↳ {conflict.reason}
            </div>
          )}

          <div style={{ fontSize: "11px", color: C.textMuted, fontFamily: "monospace", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap", marginTop: "2px" }}>
            {analysis?.appLayerRoleNote || analysis?.oneliner || `${comp.depType} · ${comp.linkType}`}
          </div>
        </div>

        <LayerBadge layer={comp.layer} />

        <span style={{ fontSize: "11px", fontFamily: "monospace", color: comp.matchPercent < 100 ? C.amber : C.textMuted }}>
          {comp.matchPercent}%
        </span>

        {analysis
          ? <span style={{
              fontSize: "10px", fontWeight: "600", fontFamily: "monospace", padding: "3px 8px", borderRadius: "4px",
              background: `${UC_COLORS[analysis.useCase] || "#555"}15`,
              border: `1px solid ${UC_COLORS[analysis.useCase] || "#555"}50`,
              color: UC_COLORS[analysis.useCase] || C.textMuted,
              whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis",
            }}>{analysis.useCase}</span>
          : <span style={{ fontSize: "10px", color: C.textMuted, fontFamily: "monospace" }}>—</span>
        }

        {/* License cell — shows detected source badge when auto-detected */}
        <div style={{ minWidth: 0 }}>
          <div style={{ display: "flex", alignItems: "center", gap: "4px", flexWrap: "wrap" }}>
            <span style={{ fontSize: "10px", color: licColor, fontFamily: "monospace", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
              {licText}
            </span>
            {isDetected && (
              <span title={`Detected via ${licInfo.source} (${licInfo.confidence} confidence)`} style={{ fontSize: "9px", color: C.amber, fontFamily: "monospace", background: `${C.amber}15`, border: `1px solid ${C.amber}40`, padding: "0px 4px", borderRadius: "3px", whiteSpace: "nowrap" }}>
                {SOURCE_ICON[licInfo.source] || "🔍"} detected
              </span>
            )}
            <button
              disabled={detectingThis}
              onClick={handleDetectThis}
              title={NEEDS_DETECT(licText) ? "Detect license from npm/PyPI/GitHub/AI" : "Re-detect license from npm/PyPI/GitHub/AI"}
              style={{ fontSize: "9px", color: detectingThis ? C.textMuted : NEEDS_DETECT(licText) ? C.accent : C.textMuted, fontFamily: "monospace", background: NEEDS_DETECT(licText) ? `${C.accent}15` : "transparent", border: `1px solid ${NEEDS_DETECT(licText) ? C.accent : C.border}40`, padding: "1px 6px", borderRadius: "3px", cursor: "pointer", whiteSpace: "nowrap", opacity: detectingThis ? 0.5 : 1 }}
            >
              {detectingThis ? "⏳…" : NEEDS_DETECT(licText) ? "🔍 detect" : "🔄"}
            </button>
          </div>
        </div>

        <span style={{
          fontSize: "10px", fontWeight: "700", fontFamily: "monospace", padding: "3px 8px", borderRadius: "10px",
          background: rs.bg, border: `1px solid ${rs.border}`, color: rs.text, letterSpacing: "0.06em", textAlign: "center",
        }}>
          {comp.risk.toUpperCase()}
        </span>

        <span style={{ color: open ? C.accent : C.textMuted, fontSize: "12px", textAlign: "center" }}>{open ? "▲" : "▼"}</span>
      </div>

      {open && <DeepPanel comp={comp} analysis={analysis} githubToken={githubToken} llmCfg={llmCfg} detectedLic={detectedLic} onDetect={onDetect} conflict={conflict} appLayerStart={appLayerStart} />}
    </div>
  );
}

// ─── LAYER MAP ────────────────────────────────────────────────────────────────
function LayerMap({ components, analyses }) {
  const byLayer = {};
  components.forEach((c, i) => { if (!byLayer[c.layer]) byLayer[c.layer] = []; byLayer[c.layer].push({ ...c, _idx: i }); });
  const sortedLayers = Object.keys(byLayer).map(Number).sort((a, b) => a - b);

  return (
    <div style={{ padding: "16px 18px", background: C.bgPanel, borderBottom: `1px solid ${C.border}` }}>
      <div style={{ fontSize: "11px", color: C.textLabel, letterSpacing: "0.1em", marginBottom: "12px", fontWeight: "700" }}>
        🗺 LAYER MAP — {sortedLayers.length} UNIQUE LAYERS
      </div>
      <div style={{ display: "flex", flexDirection: "column", gap: "6px" }}>
        {sortedLayers.map(layer => {
          const comps = byLayer[layer];
          const zone  = getLayerZone(layer);
          const hasHigh = comps.some(c => ["Critical","High"].includes(c.risk));
          const hasMed  = comps.some(c => c.risk === "Medium");
          return (
            <div key={layer} style={{ display: "flex", alignItems: "flex-start", gap: "10px" }}>
              <div style={{ minWidth: "100px", padding: "5px 8px", background: `${zone.color}15`, border: `1px solid ${zone.color}50`, borderRadius: "5px", textAlign: "center", flexShrink: 0 }}>
                <div style={{ fontSize: "11px", fontWeight: "700", color: zone.color, fontFamily: "monospace" }}>L{layer}</div>
                <div style={{ fontSize: "9px", color: `${zone.color}cc`, fontFamily: "monospace" }}>{zone.label}</div>
              </div>
              <div style={{ display: "flex", gap: "5px", flexWrap: "wrap", flex: 1, alignItems: "center" }}>
                {comps.map((c, i) => {
                  const rs = RISK_S[c.risk] || RISK_S.Unknown;
                  const a  = analyses[c._idx];
                  return (
                    <span key={i} title={`${c.name} v${c.version} — ${c.risk}`} style={{
                      fontSize: "10px", fontFamily: "monospace", padding: "3px 8px", borderRadius: "3px",
                      background: rs.bg, border: `1px solid ${rs.border}60`, color: rs.text, whiteSpace: "nowrap",
                    }}>
                      {c.name}
                      {a && <span style={{ marginLeft: "4px", opacity: 0.6 }}>{a.isActivelyUsed ? "●" : "○"}</span>}
                    </span>
                  );
                })}
              </div>
              {hasHigh && <span style={{ fontSize: "10px", color: C.red, fontFamily: "monospace", whiteSpace: "nowrap", fontWeight: "700" }}>⚠ HIGH RISK</span>}
              {!hasHigh && hasMed && <span style={{ fontSize: "10px", color: C.yellow, fontFamily: "monospace", whiteSpace: "nowrap" }}>⚠ MEDIUM</span>}
            </div>
          );
        })}
      </div>
      <div style={{ display: "flex", gap: "12px", flexWrap: "wrap", marginTop: "12px", paddingTop: "10px", borderTop: `1px solid ${C.border}` }}>
        {LAYER_ZONES.map(z => (
          <span key={z.label} style={{ fontSize: "10px", color: z.color, fontFamily: "monospace" }}>◉ {z.label} (≤L{z.max === 999 ? "∞" : z.max})</span>
        ))}
      </div>
    </div>
  );
}

// ─── FILE UPLOAD ──────────────────────────────────────────────────────────────
function FileUpload({ onComponents, onError }) {
  const [dragOver, setDragOver] = useState(false);
  const inputRef = useRef();

  const handleFile = async (file) => {
    if (!file) return;
    const ext = file.name.split(".").pop().toLowerCase();
    try {
      if (["xlsx","xls"].includes(ext)) {
        const c = await parseExcelFile(file);
        if (!c.length) throw new Error("No components found in Excel file.");
        onComponents(c, file.name);
      } else if (ext === "csv") {
        const c = parseCsvText(await file.text());
        if (!c.length) throw new Error("No components found in CSV.");
        onComponents(c, file.name);
      } else if (["txt","log","text"].includes(ext)) {
        const c = parseText(await file.text());
        if (!c.length) throw new Error("No components found in TXT file.");
        onComponents(c, file.name);
      } else {
        throw new Error(`.${ext} not supported — use .xlsx, .csv, or .txt`);
      }
    } catch (e) { onError(e.message); }
  };

  return (
    <div
      onDragOver={(e) => { e.preventDefault(); setDragOver(true); }}
      onDragLeave={() => setDragOver(false)}
      onDrop={(e) => { e.preventDefault(); setDragOver(false); handleFile(e.dataTransfer.files[0]); }}
      onClick={() => inputRef.current.click()}
      style={{
        border: `2px dashed ${dragOver ? C.accent : C.border}`, borderRadius: "8px",
        padding: "28px 20px", textAlign: "center", cursor: "pointer",
        background: dragOver ? `${C.accent}10` : C.bgInput, transition: "all 0.2s",
      }}
    >
      <input ref={inputRef} type="file" accept=".xlsx,.xls,.csv,.txt,.log" style={{ display: "none" }} onChange={(e) => handleFile(e.target.files[0])} />
      <div style={{ fontSize: "32px", marginBottom: "8px" }}>📎</div>
      <div style={{ fontSize: "13px", color: C.accent, fontFamily: "monospace", fontWeight: "700", marginBottom: "4px" }}>DROP FILE HERE or CLICK TO BROWSE</div>
      <div style={{ fontSize: "11px", color: C.textMuted }}>Supports .xlsx · .xls · .csv · .txt</div>
    </div>
  );
}

// ─── MAIN APP ─────────────────────────────────────────────────────────────────
export default function App() {
  const [raw, setRaw]               = useState(SAMPLE_RAW);
  const [components, setComponents] = useState([]);
  const [analyses, setAnalyses]     = useState({});
  const [busy, setBusy]             = useState(false);
  const [progress, setProgress]     = useState(0);
  const [showPaste, setShowPaste]   = useState(false);
  const [showCfg, setShowCfg]       = useState(false);
  const [showLayerMap, setShowLayerMap] = useState(false);
  const [parsed, setParsed]         = useState(false);
  const [sourceLabel, setSourceLabel] = useState("");
  const [filter, setFilter]         = useState("ALL");
  const [layerF, setLayerF]         = useState("ALL");
  const [q, setQ]                   = useState("");
  const [errors, setErrors]         = useState([]);
  const [status, setStatus]         = useState("");
  const [appLayerStart, setAppLayerStart] = useState(null); // user-chosen app layer
  const [showImpact, setShowImpact]       = useState(false);
  const [showReport, setShowReport]       = useState(false);

  const [provider, setProvider]     = useState(ENV.defaultProvider);
  const [apiKeys, setApiKeys]       = useState({ anthropic: ENV.anthropicKey, openai: ENV.openaiKey, groq: ENV.groqKey, mistral: ENV.mistralKey });
  const [model, setModel]           = useState(ENV.defaultModel || PROVIDERS[ENV.defaultProvider]?.defaultModel || PROVIDERS.anthropic.defaultModel);
  const [showKey, setShowKey]       = useState(false);
  const [githubToken, setGithubToken] = useState(ENV.githubToken);
  const [showGhKey, setShowGhKey]     = useState(false);
  // detectedLicenses: { [index]: { license, source, confidence } }
  const [detectedLicenses, setDetectedLicenses] = useState({});
  const [detectingLic, setDetectingLic]         = useState(false);
  const [detectProgress, setDetectProgress]     = useState(0);
  const abort = useRef(false);

  const apiKey    = apiKeys[provider] || "";
  const setApiKey = (val) => setApiKeys(prev => ({ ...prev, [provider]: val }));
  const pInfo     = PROVIDERS[provider];
  const llmCfg    = { provider, apiKey, model };

  const handleProviderChange = (p) => { setProvider(p); setModel(PROVIDERS[p].defaultModel); };

  const loadComponents = (comps, label = "") => {
    setComponents(comps); setAnalyses({}); setDetectedLicenses({}); setErrors([]);
    setParsed(true); setShowPaste(false); setSourceLabel(label);
    if (!comps.length) { setErrors(["No components parsed — check the format."]); return; }
    // Auto-detect app layer: max layer > 0 in the data (user can override).
    // If all layers are 0 (e.g. CSV without layer column), leave it unset so the user sets it manually.
    const maxLayer = Math.max(...comps.map(c => c.layer));
    setAppLayerStart(maxLayer > 0 ? maxLayer : null);
  };

  // Auto-detect licenses for Unknown/missing entries
  const runLicenseDetection = useCallback(async () => {
    const unknownIdxs = components
      .map((c, i) => ({ c, i }))
      .filter(({ c, i }) => NEEDS_DETECT(c.license) && !detectedLicenses[i]);
    if (!unknownIdxs.length) return;

    setDetectingLic(true);
    setDetectProgress(0);
    let done = 0;

    for (const { c, i } of unknownIdxs) {
      const result = await detectLicense(c.name, c.version, {
        githubToken,
        llmCfg: apiKey.trim() ? llmCfg : null,
      });
      setDetectedLicenses(prev => ({ ...prev, [i]: result }));
      done++;
      setDetectProgress(Math.round((done / unknownIdxs.length) * 100));
    }
    setDetectingLic(false);
  }, [components, githubToken, llmCfg, detectedLicenses]);

  // Helper: get effective license for a component (detected overrides Unknown)
  const effectiveLicense = (comp, idx) => {
    const det = detectedLicenses[idx];
    if (det && det.license && !NEEDS_DETECT(det.license)) return det;
    if (!NEEDS_DETECT(comp.license)) return { license: comp.license, source: "scan", confidence: "high" };
    return { license: "Unknown", source: "none", confidence: "low" };
  };

  // Cross-layer conflict: base-layer component with restrictive license whose name also
  // appears in the app layer (i.e. same package pulled into two layers).
  // Result: Map<componentName, { baseComp, appComps[], reason }>
  const crossLayerConflicts = useMemo(() => {
    if (appLayerStart == null || !components.length) return {};
    const RESTRICTIVE = ["High", "Medium"];
    const baseComps = components.filter(c => c.layer < appLayerStart);
    const appComps  = components.filter(c => c.layer >= appLayerStart);
    const conflicts = {};
    for (const base of baseComps) {
      const lic = effectiveLicense(base, components.indexOf(base)).license;
      const licFact = LICENSE_FACTS[lic] || {};
      const isRestrictive = licFact.mustShareSource || RESTRICTIVE.includes(licFact.risk) ||
        ["Strong Copyleft", "Weak Copyleft", "Weak Copyleft (File-Level)"].includes(licFact.category);
      if (!isRestrictive) continue;
      const appMatches = appComps.filter(a => a.name.toLowerCase() === base.name.toLowerCase());
      if (appMatches.length > 0) {
        conflicts[base.name] = {
          baseComp: base,
          baseLayer: base.layer,
          appLayers: appMatches.map(a => a.layer),
          license: lic,
          category: licFact.category || "Unknown",
          reason: `"${base.name}" has a restrictive ${lic} license in base layer ${base.layer} and is also present in app layer${appMatches.length > 1 ? "s" : ""} ${appMatches.map(a => a.layer).join(", ")}. This may create copyleft obligations for your application.`,
        };
      }
    }
    return conflicts;
  }, [components, appLayerStart, detectedLicenses]);

  const runAnalysis = useCallback(async () => {
    if (!components.length) return;
    const isPlaceholder = !apiKey.trim() || apiKey.includes("PASTE_YOUR") || apiKey.includes("_HERE");
    if (isPlaceholder) {
      setErrors([`API key required for ${pInfo.label}. Click ⚙ API Settings and paste your real key.`]); setShowCfg(true); return;
    }
    setBusy(true); setAnalyses({}); setErrors([]); setProgress(0); abort.current = false;

    // Groq free tier = 30 req/min — use smaller batches + longer gap
    const BATCH = provider === "groq" ? 3 : 6;
    const INTER_BATCH_DELAY = provider === "groq" ? 2500 : 400;

    const batches = [];
    for (let i = 0; i < components.length; i += BATCH) batches.push({ start: i, items: components.slice(i, i + BATCH) });

    const SYS = `You are an expert in open-source software licensing, Docker containers, and software supply chain security.
Your PRIMARY focus is LICENSE analysis — obligations, restrictions, commercial use, copyleft risk, and code usage patterns.
IMPORTANT: Respond ONLY with a raw JSON array. No markdown. No backticks. No text outside the array.`;

    // Determine app layer context for prompt
    const appLayerCtx = appLayerStart != null
      ? `The user's APPLICATION CODE starts at Layer ${appLayerStart}. Components at or above Layer ${appLayerStart} are app-layer deps — likely imported directly in source code. Components below Layer ${appLayerStart} are base OS / runtime / system deps.`
      : "No explicit app layer set — classify by layer number heuristic.";

    for (const batch of batches) {
      if (abort.current) break;

      const USER = `Analyze these ${batch.items.length} Black Duck scan components with PRIMARY focus on license compliance and code usage.
${appLayerCtx}
Return a JSON array of exactly ${batch.items.length} objects.

Components:
${batch.items.map((c, i) => {
  const z = getLayerZone(c.layer);
  const isAppLayer = appLayerStart != null && c.layer >= appLayerStart;
  return `${i+1}. "${c.name}" v${c.version} | Layer ${c.layer} (${z.label}${isAppLayer ? " ← APP LAYER" : ""}) | ${c.depType} | ${c.detectionType} ${c.matchPercent}% | ${c.linkType} | License: ${c.license} | Risk: ${c.risk}`;
}).join("\n")}

Return ONLY this JSON array (no backticks, no preamble):
[{
  "useCase": "<CLI Tooling|HTTP / Networking|Package Management|Filesystem / IO|Security / Auth|OS System Utility|Runtime / VM|Logging / Observability|Testing|Data / Parsing|UI / Frontend|Crypto|Compression|Build Tool|Database / Storage|IPC / Messaging|Unknown>",
  "isActivelyUsed": true,
  "runtimeOrBuild": "<runtime|build-only|both>",
  "appLayerRole": "<imported|runtime-dep|build-only|system>",
  "appLayerRoleNote": "<1 sentence: exactly how application code uses or depends on this — e.g. 'require(express) in server.js', 'linked at runtime by node binary', 'only used during docker build', 'OS syscall provider'>",
  "oneliner": "<what this component does in 8 words>",
  "explanation": "<2 sentences on what it does and why it is in this image>",
  "layerContext": "<1 sentence on its role in this Docker layer zone>",
  "licenseCategory": "<Permissive|Weak Copyleft|Strong Copyleft|Public Domain|Proprietary|Unknown>",
  "licenseRisk": "<Low|Medium|High>",
  "licenseOneLiner": "<one sentence: can you use this in a commercial closed-source product?>",
  "mustShareSource": "<yes|no|conditional>",
  "codeSnippet": "<4-8 lines showing how this library is typically imported and used in application code — use the actual package name>",
  "recommendation": "<license compliance action or null>",
  "alternatives": []
}]`;

      let tries = 3, ok = false;
      while (tries >= 0 && !ok && !abort.current) {
        try {
          setStatus(`Analyzing batch ${Math.floor(batch.start/BATCH)+1}/${batches.length}${tries < 3 ? " (retry)" : ""}…`);
          const text = await callLLM(SYS, USER, { provider, apiKey, model });
          const arr  = extractJSON(text);
          if (!Array.isArray(arr)) throw new Error("Not an array");
          const s = (v) => (v == null ? "" : typeof v === "object" ? JSON.stringify(v) : String(v));
          for (let j = 0; j < arr.length; j++) {
            await new Promise(r => setTimeout(r, 60));
            const gi = batch.start + j;
            const raw = arr[j] || {};
            const normalizedAlts = Array.isArray(raw.alternatives)
              ? raw.alternatives.map(a => (typeof a === "object" ? (a.name || a.label || JSON.stringify(a)) : String(a)))
              : [];
            setAnalyses(prev => ({
              ...prev,
              [gi]: {
                ...raw,
                oneliner:         s(raw.oneliner),
                explanation:      s(raw.explanation),
                layerContext:     s(raw.layerContext),
                appLayerRoleNote: s(raw.appLayerRoleNote),
                licenseOneLiner:  s(raw.licenseOneLiner),
                recommendation:   s(raw.recommendation),
                codeSnippet:      s(raw.codeSnippet),
                alternatives:     normalizedAlts,
              },
            }));
            setProgress(Math.round(((gi+1)/components.length)*100));
          }
          ok = true;
        } catch (e) {
          if (e.isRateLimit) {
            // 429 — wait the exact time the API asked for, then retry without decrementing tries
            const waitSec = Math.ceil(e.waitMs / 1000);
            setStatus(`⏳ Rate limited — waiting ${waitSec}s before retrying batch ${Math.floor(batch.start/BATCH)+1}…`);
            await new Promise(r => setTimeout(r, e.waitMs));
          } else {
            tries--;
            if (tries < 0) {
              setErrors(prev => [...prev, `Batch ${Math.floor(batch.start/BATCH)+1} failed: ${e.message.slice(0,150)}`]);
            } else {
              await new Promise(r => setTimeout(r, 1200));
            }
          }
        }
      }

      // Polite delay between batches to avoid hitting rate limits proactively
      if (!abort.current && ok) await new Promise(r => setTimeout(r, INTER_BATCH_DELAY));
    }
    setStatus(""); setBusy(false);
  }, [components, provider, apiKey, model]);

  const layers     = [...new Set(components.map(c => c.layer))].sort((a,b) => a-b);
  const ta         = Object.keys(analyses).length;
  const ac         = Object.values(analyses).filter(a => a?.isActivelyUsed).length;
  const hr         = components.filter(c => ["Critical","High"].includes(c.risk)).length;
  const rtOnly     = Object.values(analyses).filter(a => a?.runtimeOrBuild === "runtime").length;
  const buildOnly  = Object.values(analyses).filter(a => a?.runtimeOrBuild === "build-only").length;
  const unknownLic = components.filter((c, i) => NEEDS_DETECT(effectiveLicense(c, i).license)).length;

  // Names present in the app layer — used to find base/system components linked into the app
  // Guard: appLayerStart must be > 0 and actually exist in the data, else we'd match everything
  const appLayerNames = useMemo(() => {
    if (appLayerStart == null || appLayerStart <= 0) return new Set();
    return new Set(
      components
        .filter(c => c.layer >= appLayerStart)
        .map(c => c.name.toLowerCase())
    );
  }, [components, appLayerStart]);

  // Per-component application-layer relation objects
  const relations = useMemo(() => {
    return components.map((c, i) => {
      const analysis = analyses[i] || null;
      const licInfo  = effectiveLicense(c, i);
      const lic      = licInfo.license || "Unknown";
      const lFact    = LICENSE_FACTS[lic] || {};
      return computeAppLayerRelation(c, analysis, lic, lFact, appLayerStart);
    });
  }, [components, analyses, detectedLicenses, appLayerStart]);

  // Count of components with non-trivial copyleft exposure
  const copyleftExposed = relations.filter(r => r.copyleftExposure !== "none").length;

  const vis = components.filter((c, i) => {
    const a = analyses[i];
    if (q && !c.name.toLowerCase().includes(q.toLowerCase())) return false;
    if (layerF !== "ALL" && c.layer !== parseInt(layerF)) return false;
    if (filter === "HIGH_RISK")  return ["Critical","High"].includes(c.risk);
    if (filter === "SUSPECT")    return a && !a.isActivelyUsed;
    if (filter === "ACTIVE")     return a && a.isActivelyUsed;
    if (filter === "IGNORED")    return c.risk === "Ignored";
    if (filter === "RUNTIME")    return a && a.runtimeOrBuild === "runtime";
    if (filter === "BUILD_ONLY") return a && a.runtimeOrBuild === "build-only";
    if (filter === "APP_RELATED") {
      if (appLayerStart == null || appLayerStart <= 0) return false;
      // 1. Direct app layer components (at or above the user-set layer)
      if (c.layer >= appLayerStart) return true;
      // 2. Lower-layer component whose exact name also appears in the app layer
      if (appLayerNames.has(c.name.toLowerCase())) return true;
      // 3. AI explicitly says this lower-layer component is directly imported by app code
      if (a && a.appLayerRole === "imported") return true;
      return false;
    }
    return true;
  });

  const appRelatedCount = (appLayerStart != null && appLayerStart > 0)
    ? components.filter((c, i) => {
        const a = analyses[i];
        if (c.layer >= appLayerStart) return true;
        if (appLayerNames.has(c.name.toLowerCase())) return true;
        if (a && a.appLayerRole === "imported") return true;
        return false;
      }).length
    : 0;

  const ucDist = Object.values(analyses).reduce((acc, a) => { if (a?.useCase) acc[a.useCase] = (acc[a.useCase]||0)+1; return acc; }, {});

  return (
    <div style={{ minHeight: "100vh", background: C.bg, color: C.textPrimary, fontFamily: "'JetBrains Mono','Courier New',monospace" }}>

      {/* ── TOPBAR ── */}
      <div style={{ background: C.bgCard, borderBottom: `1px solid ${C.border}`, padding: "12px 20px", display: "flex", alignItems: "center", gap: "12px", position: "sticky", top: 0, zIndex: 20, boxShadow: "0 2px 16px #0008" }}>
        <div style={{ width: "34px", height: "34px", background: `linear-gradient(135deg,#1a4070,#2a70b8)`, border: `1px solid ${C.borderHi}`, borderRadius: "8px", display: "flex", alignItems: "center", justifyContent: "center", fontSize: "18px" }}>🦅</div>
        <div>
          <div style={{ fontSize: "13px", fontWeight: "700", color: C.accent, letterSpacing: "0.04em" }}>BLACK DUCK · AI LAYER ANALYZER</div>
          <div style={{ fontSize: "10px", color: C.textMuted }}>
            {pInfo.icon} {pInfo.label} · {model}
            {sourceLabel && <span style={{ marginLeft: "8px", color: C.textMuted }}>← {sourceLabel}</span>}
          </div>
        </div>
        <div style={{ marginLeft: "auto", display: "flex", gap: "8px", alignItems: "center", flexWrap: "wrap" }}>
          {parsed && components.length > 0 && (
            <button onClick={() => setShowReport(s => !s)} style={{ ...S.btn(showReport, C.green), fontSize: "11px" }}>
              📊 Report
            </button>
          )}
          {parsed && components.length > 0 && (
            <button onClick={() => setShowLayerMap(s => !s)} style={S.btn(showLayerMap)}>🗺 Layer Map</button>
          )}
          {parsed && components.length > 0 && (
            <button onClick={() => setShowImpact(s => !s)} style={{ ...S.btn(showImpact, "#4fc3f7"), fontSize: "11px" }}>
              📦 Impact Matrix{copyleftExposed > 0 && <span style={{ marginLeft: "6px", color: "#f05060", fontWeight: "700" }}>⚠{copyleftExposed}</span>}
            </button>
          )}
          <button onClick={() => setShowCfg(s => !s)} style={S.btn(showCfg)}>⚙ API Settings</button>
          <button onClick={() => setShowPaste(s => !s)} style={S.btn(showPaste)}>📂 Input Data</button>
          {parsed && (
            <button
              onClick={busy ? () => { abort.current = true; } : runAnalysis}
              style={{ ...S.btn(!busy), background: busy ? "#2a0a30" : `linear-gradient(135deg,#1a4880,#1e60a0)`, border: `1px solid ${busy ? "#8030a0" : C.borderHi}`, color: busy ? "#c060f0" : "#fff", fontWeight: "700", fontSize: "12px", padding: "7px 18px" }}
            >
              {busy ? `■ Stop (${progress}%)` : `⚡ Analyze ${components.length} Components`}
            </button>
          )}
        </div>
      </div>

      {/* ── API SETTINGS ── */}
      {showCfg && (
        <div style={{ background: C.bgPanel, borderBottom: `1px solid ${C.border}`, padding: "18px 20px" }}>
          <div style={{ fontSize: "11px", color: C.textLabel, fontWeight: "700", letterSpacing: "0.1em", marginBottom: "14px" }}>⚙ API PROVIDER SETTINGS</div>
          <div style={{ display: "flex", gap: "16px", flexWrap: "wrap", alignItems: "flex-start" }}>
            {/* Provider buttons */}
            <div>
              <label style={S.lbl}>LLM PROVIDER</label>
              <div style={{ display: "flex", gap: "8px", flexWrap: "wrap" }}>
                {Object.entries(PROVIDERS).map(([k, p]) => {
                  const hasKey = k === "anthropic" || !!apiKeys[k];
                  return (
                    <button key={k} onClick={() => handleProviderChange(k)} style={{ ...S.btn(provider === k), fontSize: "11px", padding: "6px 14px" }}>
                      {p.icon} {p.label}
                      <span style={{ display: "inline-block", width: "6px", height: "6px", borderRadius: "50%", marginLeft: "8px", verticalAlign: "middle", background: hasKey ? C.green : C.amber }} />
                    </button>
                  );
                })}
              </div>
            </div>
            {/* Model */}
            <div>
              <label style={S.lbl}>MODEL</label>
              <select value={model} onChange={e => setModel(e.target.value)} style={{ ...S.inp, minWidth: "220px" }}>
                {pInfo.models.map(m => <option key={m} value={m}>{m}</option>)}
              </select>
            </div>
            {/* API Key */}
            <div style={{ flex: 1, minWidth: "280px" }}>
              <label style={S.lbl}>{pInfo.icon} {pInfo.label.toUpperCase()} API KEY — <span style={{ color: C.textMuted, fontWeight: "400" }}>{pInfo.note}</span></label>
              <div style={{ display: "flex", gap: "6px" }}>
                <input type={showKey ? "text" : "password"} value={apiKey} onChange={e => setApiKey(e.target.value)} placeholder={pInfo.placeholder} style={{ ...S.inp, flex: 1 }} />
                <button onClick={() => setShowKey(s => !s)} style={{ ...S.btn(false), padding: "6px 10px" }}>{showKey ? "🙈" : "👁"}</button>
                {apiKey && <button onClick={() => setApiKey("")} style={{ ...S.btn(false), padding: "6px 10px", color: C.red }}>✕</button>}
              </div>
              <div style={{ fontSize: "10px", marginTop: "5px", color: !apiKey || apiKey.includes("PASTE_YOUR") ? C.amber : C.green }}>
                {!apiKey || apiKey.includes("PASTE_YOUR") ? `⚠ Paste your real ${pInfo.label} API key above` : `✓ ${pInfo.label} key set`}
              </div>
            </div>
            {/* GitHub Token */}
            <div style={{ flex: 1, minWidth: "280px" }}>
              <label style={S.lbl}>🐙 GITHUB TOKEN — <span style={{ color: C.textMuted, fontWeight: "400" }}>optional · 60 → 5000 req/hr</span></label>
              <div style={{ display: "flex", gap: "6px" }}>
                <input type={showGhKey ? "text" : "password"} value={githubToken} onChange={e => setGithubToken(e.target.value)} placeholder="ghp_... or github_pat_..." style={{ ...S.inp, flex: 1 }} />
                <button onClick={() => setShowGhKey(s => !s)} style={{ ...S.btn(false), padding: "6px 10px" }}>{showGhKey ? "🙈" : "👁"}</button>
                {githubToken && <button onClick={() => setGithubToken("")} style={{ ...S.btn(false), padding: "6px 10px", color: C.red }}>✕</button>}
              </div>
              <div style={{ fontSize: "10px", marginTop: "5px", color: githubToken ? C.green : C.textMuted }}>
                {githubToken ? "✓ GitHub token set" : "Anonymous — limited to 60 req/hr"}
              </div>
            </div>
          </div>
        </div>
      )}

      {/* ── INPUT PANEL ── */}
      {showPaste && (
        <div style={{ background: C.bgPanel, borderBottom: `1px solid ${C.border}`, padding: "18px 20px" }}>
          <div style={{ fontSize: "11px", color: C.textLabel, fontWeight: "700", letterSpacing: "0.1em", marginBottom: "14px" }}>📂 INPUT BLACK DUCK DATA</div>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "18px" }}>
            <div>
              <label style={{ ...S.lbl, marginBottom: "10px" }}>UPLOAD FILE (.xlsx / .xls / .csv / .txt)</label>
              <FileUpload onComponents={(c, l) => loadComponents(c, l)} onError={(m) => setErrors([m])} />
            </div>
            <div>
              <label style={{ ...S.lbl, marginBottom: "10px" }}>PASTE RAW TEXT (one component per line)</label>
              <textarea value={raw} onChange={e => setRaw(e.target.value)} rows={7} style={{ ...S.inp, width: "100%", resize: "vertical", boxSizing: "border-box", lineHeight: "1.7" }} />
              <button onClick={() => loadComponents(parseText(raw), "pasted text")} style={{ ...S.btn(true), marginTop: "10px", padding: "7px 18px", fontSize: "12px" }}>PARSE TEXT →</button>
            </div>
          </div>
        </div>
      )}

      {/* ── ERRORS ── */}
      {errors.length > 0 && (
        <div style={{ background: "#1e0a0a", borderBottom: `1px solid ${C.red}40`, padding: "10px 20px" }}>
          {errors.map((e, i) => <div key={i} style={{ fontSize: "11px", color: C.red }}>⚠ {e}</div>)}
        </div>
      )}
      {status && (
        <div style={{ background: C.bgPanel, borderBottom: `1px solid ${C.border}`, padding: "8px 20px" }}>
          <span style={{ fontSize: "11px", color: C.accent }}>⚡ {status}</span>
        </div>
      )}

      {/* ── STATS BAR ── */}
      {parsed && components.length > 0 && (
        <div style={{ display: "flex", borderBottom: `1px solid ${C.border}`, background: C.bgCard, flexWrap: "wrap" }}>
          {[
            ["TOTAL",       components.length, C.accent],
            ["ANALYZED",    ta,                C.purple],
            ["ACTIVE",      ac,                C.green],
            ["SUSPECT",     ta - ac,           C.amber],
            ["HIGH RISK",   hr,                C.red],
            ["LAYERS",      layers.length,     C.yellow],
            ["RUNTIME",     rtOnly,            "#56d8e4"],
            ["BUILD ONLY",  buildOnly,         C.textMuted],
            ["UNKNOWN LIC", unknownLic,        unknownLic > 0 ? C.amber : C.textMuted],
            ["⚖ COPYLEFT",  copyleftExposed,   copyleftExposed > 0 ? "#f05060" : C.textMuted],
            ...(appLayerStart != null ? [["APP RELATED", appRelatedCount, "#4fc3f7"]] : []),
          ].map(([l, v, c]) => (
            <div key={l} style={{ flex: 1, minWidth: "90px", padding: "12px 16px", borderRight: `1px solid ${C.border}` }}>
              <div style={{ fontSize: "9px", color: C.textMuted, letterSpacing: "0.1em", marginBottom: "3px", fontWeight: "600" }}>{l}</div>
              <div style={{ fontSize: "22px", fontWeight: "700", color: c, lineHeight: 1 }}>{v}</div>
            </div>
          ))}
          {/* Auto-detect button appears when there are unknown licenses */}
          {unknownLic > 0 && (
            <div style={{ display: "flex", alignItems: "center", padding: "10px 16px", borderRight: `1px solid ${C.border}` }}>
              <button
                onClick={detectingLic ? undefined : runLicenseDetection}
                disabled={detectingLic}
                style={{
                  ...S.btn(true, C.amber), fontSize: "11px", padding: "6px 14px",
                  whiteSpace: "nowrap", fontWeight: "700",
                  opacity: detectingLic ? 0.7 : 1,
                }}
              >
                {detectingLic
                  ? `🔍 Detecting… ${detectProgress}%`
                  : `🔍 Detect ${unknownLic} Unknown License${unknownLic > 1 ? "s" : ""}`}
              </button>
            </div>
          )}
        </div>
      )}

      {/* ── USE-CASE STRIP ── */}
      {Object.keys(ucDist).length > 0 && (
        <div style={{ padding: "10px 20px", background: C.bgPanel, borderBottom: `1px solid ${C.border}`, display: "flex", gap: "6px", flexWrap: "wrap", alignItems: "center" }}>
          <span style={{ fontSize: "10px", color: C.textLabel, fontWeight: "600" }}>USE CASES:</span>
          {Object.entries(ucDist).sort((a,b) => b[1]-a[1]).map(([uc,cnt]) => {
            const col = UC_COLORS[uc] || "#555";
            return <span key={uc} style={{ fontSize: "10px", padding: "3px 10px", borderRadius: "4px", background: `${col}15`, border: `1px solid ${col}40`, color: col, fontFamily: "monospace" }}>{uc} <b>{cnt}</b></span>;
          })}
        </div>
      )}

      {/* ── SCAN REPORT ── */}
      {showReport && parsed && components.length > 0 && (
        <ScanReport
          components={components}
          analyses={analyses}
          detectedLicenses={detectedLicenses}
          onClose={() => setShowReport(false)}
        />
      )}

      {/* ── LAYER MAP ── */}
      {showLayerMap && parsed && components.length > 0 && <LayerMap components={components} analyses={analyses} />}

      {/* ── APP-LAYER IMPACT MATRIX ── */}
      {showImpact && parsed && components.length > 0 && (
        <AppLayerImpactPanel
          components={components}
          analyses={analyses}
          detectedLicenses={detectedLicenses}
          appLayerStart={appLayerStart}
          onClose={() => setShowImpact(false)}
        />
      )}

      {/* ── FILTERS ── */}
      {parsed && components.length > 0 && (
        <div style={{ display: "flex", gap: "8px", padding: "10px 20px", background: C.bgCard, borderBottom: `1px solid ${C.border}`, flexWrap: "wrap", alignItems: "center" }}>
          <input value={q} onChange={e => setQ(e.target.value)} placeholder="🔍 search components…" style={{ ...S.inp, width: "200px" }} />
          {["ALL","ACTIVE","SUSPECT","HIGH_RISK","IGNORED","RUNTIME","BUILD_ONLY"].map(f => (
            <button key={f} onClick={() => setFilter(f)} style={{ ...S.btn(filter === f), fontSize: "10px", padding: "4px 12px" }}>
              {f.replace(/_/g, " ")}
            </button>
          ))}
          {appLayerStart != null && (
            <button
              onClick={() => setFilter(filter === "APP_RELATED" ? "ALL" : "APP_RELATED")}
              title="Show components in or linked to your app layer: direct app deps, base/system packages shared with the app layer, and AI-classified runtime deps"
              style={{ ...S.btn(filter === "APP_RELATED", "#4fc3f7"), fontSize: "10px", padding: "4px 12px", fontWeight: "700" }}
            >
              📦 APP RELATED {appRelatedCount > 0 && <span style={{ marginLeft: "4px", opacity: 0.8 }}>({appRelatedCount})</span>}
            </button>
          )}
          <span style={{ marginLeft: "auto", fontSize: "10px", color: C.textMuted }}>LAYER:</span>
          <select value={layerF} onChange={e => setLayerF(e.target.value)} style={{ ...S.inp, minWidth: "160px" }}>
            <option value="ALL">All Layers</option>
            {layers.map(l => <option key={l} value={l}>Layer {l} — {getLayerZone(l).label}</option>)}
          </select>

          {/* ── MY APP LAYER SELECTOR ── */}
          <div style={{ display: "flex", alignItems: "center", gap: "6px", paddingLeft: "10px", borderLeft: `1px solid ${C.border}` }}>
            <span style={{ fontSize: "10px", color: "#4fc3f7", fontFamily: "monospace", fontWeight: "700", whiteSpace: "nowrap" }}>
              🏗 MY APP LAYER:
            </span>
            <div style={{ display: "flex", flexDirection: "column", gap: "4px" }}>
              <div style={{ display: "flex", alignItems: "center", gap: "6px" }}>
                <input
                  type="number"
                  min="0"
                  list="layer-hints"
                  placeholder="e.g. 47"
                  value={appLayerStart ?? ""}
                  onChange={e => setAppLayerStart(e.target.value === "" ? null : parseInt(e.target.value))}
                  style={{
                    ...S.inp,
                    width: "90px",
                    borderColor: appLayerStart != null ? "#4fc3f7" : C.border,
                    textAlign: "center",
                  }}
                />
                <datalist id="layer-hints">
                  {layers.map(l => <option key={l} value={l} />)}
                </datalist>
                {appLayerStart != null && (
                  <span style={{ fontSize: "9px", color: "#4fc3f7", fontFamily: "monospace", padding: "2px 8px", background: "#4fc3f715", border: "1px solid #4fc3f730", borderRadius: "4px", whiteSpace: "nowrap" }}>
                    ✓ App starts @ L{appLayerStart} — {getLayerZone(appLayerStart).label}
                  </span>
                )}
                {Object.keys(crossLayerConflicts).length > 0 && (
                  <span
                    title={`${Object.keys(crossLayerConflicts).length} component(s) appear in base layers with restrictive licenses AND in app layers`}
                    style={{ fontSize: "9px", color: C.red, fontFamily: "monospace", fontWeight: "700", padding: "2px 8px", background: `${C.red}15`, border: `1px solid ${C.red}40`, borderRadius: "4px", whiteSpace: "nowrap", cursor: "default" }}
                  >
                    ⚠ {Object.keys(crossLayerConflicts).length} CROSS-LAYER CONFLICT{Object.keys(crossLayerConflicts).length > 1 ? "S" : ""}
                  </span>
                )}
              </div>
              {/* Zone reference strip */}
              <div style={{ display: "flex", gap: "4px", flexWrap: "nowrap" }}>
                {LAYER_ZONES.map(z => {
                  const isActive = appLayerStart != null && (
                    z.max === 999
                      ? appLayerStart > (LAYER_ZONES[LAYER_ZONES.indexOf(z) - 1]?.max ?? 0)
                      : appLayerStart <= z.max && (LAYER_ZONES.indexOf(z) === 0 || appLayerStart > (LAYER_ZONES[LAYER_ZONES.indexOf(z) - 1]?.max ?? 0))
                  );
                  return (
                    <span
                      key={z.label}
                      title={z.hint}
                      onClick={() => setAppLayerStart(z.max === 999 ? (layers.find(l => l > (LAYER_ZONES[LAYER_ZONES.length-2]?.max ?? 55)) ?? 56) : z.max)}
                      style={{
                        fontSize: "9px", fontFamily: "monospace", cursor: "pointer",
                        padding: "2px 6px", borderRadius: "3px", whiteSpace: "nowrap",
                        background: isActive ? `${z.color}25` : `${z.color}08`,
                        border: `1px solid ${isActive ? z.color : z.color + "40"}`,
                        color: isActive ? z.color : z.color + "99",
                        fontWeight: isActive ? "700" : "400",
                      }}
                    >
                      {z.label} ≤L{z.max === 999 ? "∞" : z.max}
                    </span>
                  );
                })}
              </div>
            </div>
          </div>

          <span style={{ fontSize: "10px", color: C.textMuted }}>Showing <b style={{ color: C.textPrimary }}>{vis.length}</b> / {components.length}</span>
        </div>
      )}

      {/* ── TABLE HEADER ── */}
      {parsed && vis.length > 0 && (
        <div style={{ display: "grid", gridTemplateColumns: "40px 1fr 60px 50px 140px 110px 90px 24px", gap: "10px", padding: "8px 18px", background: C.bg, borderBottom: `1px solid ${C.border}` }}>
          {["#","COMPONENT","LAYER","MATCH","USE CASE","LICENSE","RISK",""].map(h => (
            <span key={h} style={{ fontSize: "9px", color: C.textLabel, fontFamily: "monospace", letterSpacing: "0.12em", fontWeight: "700" }}>{h}</span>
          ))}
        </div>
      )}

      {/* ── ROWS ── */}
      {parsed ? (
        vis.length === 0
          ? <div style={{ padding: "60px", textAlign: "center", color: C.textMuted, fontSize: "13px" }}>No components match the current filter.</div>
          : vis.map((c, i) => {
              const oi = components.indexOf(c);
              return <Row key={`${c.name}-${c.layer}-${i}`} comp={c} analysis={analyses[oi]} index={oi} githubToken={githubToken} llmCfg={llmCfg} detectedLic={effectiveLicense(c, oi)} onDetect={(result) => setDetectedLicenses(prev => ({ ...prev, [oi]: result }))} conflict={crossLayerConflicts[c.name] || null} appLayerStart={appLayerStart} relation={relations[oi] || null} />;
            })
      ) : (
        /* ── LANDING ── */
        <div style={{ display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", padding: "80px 20px", gap: "16px" }}>
          <div style={{ fontSize: "56px" }}>🦅</div>
          <div style={{ fontSize: "15px", color: C.textPrimary, fontWeight: "700", letterSpacing: "0.04em" }}>BLACK DUCK SCA · AI LAYER ANALYZER</div>
          <div style={{ fontSize: "12px", color: C.textSecondary, maxWidth: "560px", textAlign: "center", lineHeight: "2" }}>
            Upload an <b style={{ color: C.accent }}>Excel / CSV / TXT</b> Black Duck export or paste raw component rows.
            AI classifies each component by layer zone, runtime vs build-only, active vs suspect —
            with live <b style={{ color: C.yellow }}>GitHub</b> search and <b style={{ color: C.red }}>OSV vulnerability</b> lookup.
          </div>
          <div style={{ display: "flex", gap: "12px", flexWrap: "wrap", justifyContent: "center", marginTop: "8px" }}>
            <button onClick={() => setShowPaste(true)} style={{ ...S.btn(true), padding: "10px 24px", fontSize: "13px", fontWeight: "700" }}>📂 Upload / Paste Data</button>
            <button onClick={() => loadComponents(parseText(SAMPLE_RAW), "sample data")} style={{ ...S.btn(false), padding: "10px 24px", fontSize: "13px" }}>Load Sample →</button>
          </div>
          <div style={{ display: "grid", gridTemplateColumns: "repeat(3,1fr)", gap: "14px", marginTop: "28px", maxWidth: "720px", width: "100%" }}>
            {[
              ["📎","Excel / CSV / TXT Upload","Drag-and-drop any Black Duck export — column headers auto-detected"],
              ["🗺","Layer Map","Visual breakdown by Docker layer zone: Base OS → Runtime → App Deps → App Layer"],
              ["🔬","Deep AI per Component","Click any row: runtime vs build, code consumed, base image relation, optimization tips"],
              ["🛡","OSV Vulnerability Lookup","Live CVE check via OSV.dev — no extra API key needed"],
              ["🐙","GitHub Repo Search","Stars, language, last update, open issues for any component"],
              ["⚡","4 LLM Providers","Anthropic · OpenAI · Groq · Mistral — each keeps its own key"],
            ].map(([icon, title, desc]) => (
              <div key={title} style={{ padding: "16px", background: C.bgCard, border: `1px solid ${C.border}`, borderRadius: "8px" }}>
                <div style={{ fontSize: "24px", marginBottom: "8px" }}>{icon}</div>
                <div style={{ fontSize: "12px", color: C.accent, fontFamily: "monospace", marginBottom: "5px", fontWeight: "700" }}>{title}</div>
                <div style={{ fontSize: "11px", color: C.textMuted, lineHeight: "1.7" }}>{desc}</div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* ── PROGRESS BAR ── */}
      {busy && (
        <div style={{ position: "fixed", bottom: 0, left: 0, right: 0, height: "4px", background: C.border }}>
          <div style={{ height: "100%", width: `${progress}%`, background: `linear-gradient(90deg,${C.accentGlow},${C.accent},#60e0ff)`, transition: "width 0.2s ease" }} />
        </div>
      )}
    </div>
  );
}

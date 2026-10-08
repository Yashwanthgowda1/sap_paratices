// ─── PROVIDERS ───────────────────────────────────────────────────────────────
export const PROVIDERS = {
  anthropic: {
    label: "Anthropic Claude",
    icon: "🤖",
    placeholder: "sk-ant-api03-...",
    models: ["claude-sonnet-4-5", "claude-opus-4-5", "claude-haiku-4-5"],
    defaultModel: "claude-sonnet-4-5",
    note: "Leave blank to use built-in key",
  },
  openai: {
    label: "OpenAI GPT",
    icon: "🟢",
    placeholder: "sk-proj-...",
    models: ["gpt-4o", "gpt-4o-mini", "gpt-4-turbo"],
    defaultModel: "gpt-4o",
    note: "Get key at platform.openai.com",
  },
  groq: {
    label: "Groq (Fast!)",
    icon: "⚡",
    placeholder: "gsk_...",
    models: ["llama-3.3-70b-versatile", "llama-3.1-8b-instant", "mixtral-8x7b-32768"],
    defaultModel: "llama-3.3-70b-versatile",
    note: "Free tier at console.groq.com",
  },
  mistral: {
    label: "Mistral AI",
    icon: "🌊",
    placeholder: "your-mistral-key",
    models: ["mistral-large-latest", "mistral-small-latest", "open-mixtral-8x22b"],
    defaultModel: "mistral-large-latest",
    note: "Get key at console.mistral.ai",
  },
};

export const RISK_STYLES = {
  Critical: { bg: "#2a0a0a", border: "#ef5350", text: "#ef5350" },
  High:     { bg: "#1a0d00", border: "#ff6d00", text: "#ff8f00" },
  Medium:   { bg: "#1a1500", border: "#ffd600", text: "#ffd600" },
  Low:      { bg: "#0d1a00", border: "#76ff03", text: "#76ff03" },
  Ignored:  { bg: "#111",    border: "#333",    text: "#555"    },
  None:     { bg: "#0a1a0a", border: "#00c853", text: "#00c853" },
  Unknown:  { bg: "#111",    border: "#444",    text: "#aaa"    },
};

export const UC_COLORS = {
  "CLI Tooling":            "#00d4ff",
  "HTTP / Networking":      "#00bcd4",
  "Package Management":     "#7c4dff",
  "Filesystem / IO":        "#ff9100",
  "Security / Auth":        "#ef5350",
  "OS System Utility":      "#78909c",
  "Runtime / VM":           "#c6ff00",
  "Logging / Observability":"#ff4081",
  "Testing":                "#40c4ff",
  "Data / Parsing":         "#69f0ae",
  "UI / Frontend":          "#f48fb1",
  "Crypto":                 "#ffd740",
  "Compression":            "#80cbc4",
  "Build Tool":             "#bcaaa4",
  "Database / Storage":     "#a5d6a7",
  "IPC / Messaging":        "#ce93d8",
  "Unknown":                "#555",
};

// ─── LAYER CLASSIFICATION ─────────────────────────────────────────────────────
// Heuristic: lower layers → base OS/runtime; higher layers → app code
export const LAYER_ZONES = [
  { max: 10,  label: "Base OS",          color: "#78909c", hint: "Core OS packages (scratch/alpine/debian base)" },
  { max: 20,  label: "Runtime",          color: "#c6ff00", hint: "Language runtime, VM, interpreter" },
  { max: 35,  label: "System Deps",      color: "#ff9100", hint: "System-level libraries installed by RUN apt/apk" },
  { max: 55,  label: "App Deps",         color: "#7c4dff", hint: "App-level deps installed by npm/pip/mvn" },
  { max: 999, label: "App Layer",        color: "#4fc3f7", hint: "Application source code and final COPY layers" },
];

export function getLayerZone(layer) {
  return LAYER_ZONES.find(z => layer <= z.max) || LAYER_ZONES[LAYER_ZONES.length - 1];
}

export const SAMPLE_RAW = `abbrev 3.0.1 Layer 49 Direct Dependency Binary 100% Dynamically Linked ISC
abbrev 4.0.0 Layer 7 Direct Dependency Binary 100% Dynamically Linked ISC
abortcontroller 3.0.0 Layer 49 Direct Dependency Binary 100% Dynamically Linked MIT
acl (access control list) 2.3.2 Layer 37 Direct Dependency Binary 98% Dynamically Linked LGPL-2.1-or-later High
adduser 3.152 Layer 37 Direct Dependency Binary 100% Ignored GPL-2.0-or-later
bash 5.2.15 Layer 7 Direct Dependency Binary 100% Dynamically Linked GPL-3.0-or-later
openssl 3.1.4 Layer 12 Direct Dependency Binary 100% Dynamically Linked Apache-2.0 Medium
node 20.10.0 Layer 15 Direct Dependency Binary 100% Dynamically Linked MIT
express 4.18.2 Layer 49 Direct Dependency Binary 100% Dynamically Linked MIT
lodash 4.17.21 Layer 49 Direct Dependency Binary 100% Dynamically Linked MIT
axios 1.6.2 Layer 49 Direct Dependency Binary 100% Dynamically Linked MIT
winston 3.11.0 Layer 49 Direct Dependency Binary 100% Dynamically Linked MIT
jest 29.7.0 Layer 49 Direct Dependency Binary 100% Dynamically Linked MIT
libc6 2.37 Layer 5 Direct Dependency Binary 100% Dynamically Linked LGPL-2.1-or-later`;

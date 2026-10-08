import * as XLSX from "xlsx";

// ─── TEXT / TXT PARSER ────────────────────────────────────────────────────────
function parseBlackDuckLine(line) {
  line = line.trim();
  if (!line) return null;

  const layerMatch = line.match(/Layer\s+(\d+)/i);
  const layer = layerMatch ? parseInt(layerMatch[1]) : 0;
  const pctMatch = line.match(/(\d+)%/);
  const matchPercent = pctMatch ? parseInt(pctMatch[1]) : 100;
  const riskMatch = line.match(/\b(Critical|High|Medium|Low)\b/i);
  const risk = riskMatch
    ? riskMatch[1][0].toUpperCase() + riskMatch[1].slice(1).toLowerCase()
    : line.match(/Ignored/i) ? "Ignored" : "None";
  const linkMatch = line.match(/(Dynamically Linked|Statically Linked|Not Linked)/i);
  const linkType = linkMatch ? linkMatch[1] : "Unknown";
  const detMatch = line.match(/\b(Binary|Source|Signature|Manual)\b/i);
  const detectionType = detMatch ? detMatch[1] : "Binary";
  const depMatch = line.match(/(Direct Dependency|Transitive|Development)/i);
  const depType = depMatch ? depMatch[1] : "Direct Dependency";
  const licenseMatch = line.match(
    /(MIT|ISC|Apache-[\d.]+(?:-or-later)?|GPL-[\d.]+(?:-or-later|-only)?|LGPL-[\d.]+(?:-or-later|-only)?|BSD-[\d]+-Clause|MPL-[\d.]+|CC0-[\d.]+|Unlicense|CDDL-[\d.]+|EPL-[\d.]+)/i
  );
  const license = licenseMatch ? licenseMatch[1] : "Unknown";

  const beforeLayer = line.split(/Layer\s+\d+/i)[0].trim();
  const tokens = beforeLayer.split(/\s+/);
  let version = "?", nameParts = tokens;
  for (let i = tokens.length - 1; i >= 0; i--) {
    if (/^\d[\d.]+/.test(tokens[i])) {
      version = tokens[i];
      nameParts = tokens.slice(0, i);
      break;
    }
  }
  const name = nameParts.join(" ").replace(/\s*\(.*?\)/, "").trim() || beforeLayer;
  return { name, version, layer, depType, detectionType, matchPercent, linkType, license, risk, raw: line };
}

export function parseText(text) {
  return text.split("\n").map(parseBlackDuckLine).filter(Boolean);
}

// ─── EXCEL / CSV PARSER ───────────────────────────────────────────────────────
// Handles .xlsx, .xls, .csv files.
// Tries to map columns by header name, then falls back to positional mapping.
export function parseExcelFile(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = (e) => {
      try {
        const data = new Uint8Array(e.target.result);

        // Some tools export .xls files that are actually HTML — try array first,
        // then fall back to string (HTML) mode if xlsx signals an HTML parse error.
        let wb;
        try {
          wb = XLSX.read(data, { type: "array" });
        } catch (firstErr) {
          const msg = firstErr.message || "";
          if (msg.toLowerCase().includes("html")) {
            try {
              const text = new TextDecoder().decode(data);
              wb = XLSX.read(text, { type: "string" });
            } catch {
              throw new Error(
                "This .xls file appears to be an HTML export but could not be parsed. " +
                "Open it in Excel or Google Sheets and re-save as .xlsx or .csv, then upload again."
              );
            }
          } else {
            throw firstErr;
          }
        }

        const sheet = wb.Sheets[wb.SheetNames[0]];
        const rows = XLSX.utils.sheet_to_json(sheet, { header: 1, defval: "" });

        if (!rows.length) { resolve([]); return; }

        // Try to find header row (first row that looks like headers)
        let headerIdx = 0;
        const firstRow = rows[0].map(c => String(c).toLowerCase().trim());
        const hasHeaders = firstRow.some(h =>
          ["name", "component", "version", "layer", "risk", "license", "type"].some(k => h.includes(k))
        );

        const headers = hasHeaders ? firstRow : null;
        const dataRows = hasHeaders ? rows.slice(1) : rows;

        const colIdx = (names) => {
          if (!headers) return -1;
          for (const n of names) {
            const i = headers.findIndex(h => h.includes(n));
            if (i !== -1) return i;
          }
          return -1;
        };

        const nameCol    = colIdx(["component", "name", "pkg", "package"]);
        const verCol     = colIdx(["version", "ver"]);
        const layerCol   = colIdx(["layer"]);
        const riskCol    = colIdx(["risk", "severity", "vuln"]);
        const licCol     = colIdx(["license", "lic"]);
        const depCol     = colIdx(["dep", "dependency type", "type"]);
        const linkCol    = colIdx(["link", "linked"]);
        const matchCol   = colIdx(["match", "confidence", "%"]);
        const detCol     = colIdx(["detect", "method"]);

        const get = (row, idx, fallback = "") =>
          idx >= 0 && row[idx] != null ? String(row[idx]).trim() : fallback;

        const components = [];
        dataRows.forEach((row, ri) => {
          if (!row || row.every(c => !c)) return;

          // Positional fallback: col0=name, col1=version, col2=layer...
          const rawName    = nameCol  >= 0 ? get(row, nameCol)  : get(row, 0);
          const rawVersion = verCol   >= 0 ? get(row, verCol)   : get(row, 1);
          const rawLayer   = layerCol >= 0 ? get(row, layerCol) : get(row, 2);
          const rawRisk    = riskCol  >= 0 ? get(row, riskCol)  : get(row, 5, "None");
          const rawLic     = licCol   >= 0 ? get(row, licCol)   : get(row, 6, "Unknown");
          const rawDep     = depCol   >= 0 ? get(row, depCol)   : get(row, 3, "Direct Dependency");
          const rawDet     = detCol   >= 0 ? get(row, detCol)   : get(row, 4, "Binary");
          const rawLink    = linkCol  >= 0 ? get(row, linkCol)  : "Dynamically Linked";
          const rawMatch   = matchCol >= 0 ? get(row, matchCol) : "100";

          if (!rawName) return;

          const layerNum = parseInt(rawLayer) || 0;
          const pctNum   = parseInt(String(rawMatch).replace(/[^0-9]/g, "")) || 100;
          const riskNorm = ["Critical","High","Medium","Low","Ignored","None"].find(
            r => rawRisk.toLowerCase().includes(r.toLowerCase())
          ) || "None";

          const raw = `${rawName} ${rawVersion} Layer ${layerNum} ${rawDep} ${rawDet} ${pctNum}% ${rawLink} ${rawLic} ${riskNorm}`;
          components.push({
            name: rawName,
            version: rawVersion || "?",
            layer: layerNum,
            depType: rawDep || "Direct Dependency",
            detectionType: rawDet || "Binary",
            matchPercent: pctNum,
            linkType: rawLink || "Dynamically Linked",
            license: rawLic || "Unknown",
            risk: riskNorm,
            raw,
          });
        });

        resolve(components);
      } catch (err) {
        reject(new Error("Excel parse failed: " + err.message));
      }
    };
    reader.onerror = () => reject(new Error("File read error"));
    reader.readAsArrayBuffer(file);
  });
}

// ─── RFC-4180 CSV TOKENISER ───────────────────────────────────────────────────
// Handles quoted fields, escaped quotes (""), embedded commas and newlines.
function parseCSVRow(line) {
  const fields = [];
  let cur = "", inQ = false, i = 0;
  while (i < line.length) {
    const ch = line[i];
    if (inQ) {
      if (ch === '"') {
        if (line[i + 1] === '"') { cur += '"'; i += 2; }  // escaped quote
        else { inQ = false; i++; }
      } else { cur += ch; i++; }
    } else {
      if (ch === '"') { inQ = true; i++; }
      else if (ch === ',') { fields.push(cur.trim()); cur = ""; i++; }
      else { cur += ch; i++; }
    }
  }
  fields.push(cur.trim());
  return fields;
}

// Split CSV text into logical rows (a quoted field can span multiple lines).
function splitCSVRows(text) {
  const rows = [];
  let cur = "", inQ = false;
  for (let i = 0; i < text.length; i++) {
    const ch = text[i];
    if (ch === '"') { inQ = !inQ; cur += ch; }
    else if ((ch === '\n' || ch === '\r') && !inQ) {
      if (ch === '\r' && text[i + 1] === '\n') i++;
      if (cur.trim()) rows.push(cur);
      cur = "";
    } else { cur += ch; }
  }
  if (cur.trim()) rows.push(cur);
  return rows;
}

// ─── CSV TEXT PARSER ──────────────────────────────────────────────────────────
export function parseCsvText(text) {
  const rows = splitCSVRows(text);
  if (!rows.length) return [];

  // Always parse first row as headers — Black Duck CSVs always have them.
  const rawHeaders = parseCSVRow(rows[0]).map(h => h.toLowerCase().replace(/[^a-z0-9]/g, " ").trim());

  // Find column index by trying a list of candidate substrings in order.
  const col = (...candidates) => {
    for (const c of candidates) {
      const idx = rawHeaders.findIndex(h => h.includes(c));
      if (idx !== -1) return idx;
    }
    return -1;
  };

  // ── Black Duck column name mapping ──
  // "Component name" | "Component" | "name" | "pkg"
  const nameCol    = col("component name", "component", "name", "pkg", "package");
  const verCol     = col("component version name", "version name", "version", "ver");
  const layerCol   = col("layer");
  // Black Duck uses "Operational Risk" for severity — not "Risk" alone in header
  const riskCol    = col("operational risk", "risk", "severity", "vuln");
  // "License names" is the human-readable column; "License ids" is SPDX
  const licCol     = col("license names", "license name", "license families", "license ids", "license");
  const depCol     = col("match type", "dependency type", "dep", "type");
  const linkCol    = col("usage", "link", "linked");
  const matchCol   = col("file match count", "match", "confidence", "%");
  const detCol     = col("source", "detect", "method");
  // "In use" column (TRUE/FALSE) — used to derive isActive hint
  const inUseCol   = col("in use");

  // Normalise risk values from Black Duck vocabulary
  const normalizeRisk = (raw) => {
    if (!raw) return "None";
    const r = raw.toLowerCase().trim();
    if (r === "critical") return "Critical";
    if (r === "high")     return "High";
    if (r === "medium" || r === "med") return "Medium";
    if (r === "low")      return "Low";
    if (r === "ok" || r === "none" || r === "") return "None";
    if (r === "ignored")  return "Ignored";
    // Black Duck sometimes writes "NOT_IN_VIOLATION" in policy status — treat as None
    return "None";
  };

  // Normalise license — strip doubled quotes from Black Duck's BSD name style
  const normLic = (raw) => {
    if (!raw) return "Unknown";
    // Take the first license if multiple are listed (comma-separated inside field)
    const first = raw.split(/\s*,\s*/)[0].trim();
    if (!first || first.toLowerCase() === "unknown") return "Unknown";
    // Map verbose names to short SPDX
    const MAP = {
      "mit license": "MIT", "mit": "MIT",
      "isc license": "ISC", "isc": "ISC",
      "apache license 2.0": "Apache-2.0", "apache 2.0": "Apache-2.0", "apache-2.0": "Apache-2.0",
      "bsd 3-clause new or revised license": "BSD-3-Clause",
      "bsd 3-clause": "BSD-3-Clause",
      "bsd 2-clause simplified license": "BSD-2-Clause",
      "bsd 2-clause": "BSD-2-Clause",
      "gnu general public license v2.0 or later": "GPL-2.0-or-later",
      "gnu general public license v3.0 or later": "GPL-3.0-or-later",
      "gnu lesser general public license v2.1 or later": "LGPL-2.1-or-later",
      "gnu lesser general public license v2.1 only": "LGPL-2.1-only",
      "gnu lesser general public license v3.0 or later": "LGPL-3.0-or-later",
      "gnu library general public license v2 or later": "LGPL-2.0-or-later",
      "mozilla public license 2.0": "MPL-2.0",
      "artistic license 1.0 perl": "Artistic-1.0-Perl",
      "artistic license 1.0": "Artistic-1.0",
      "artistic license 2.0": "Artistic-2.0",
      "public domain": "Unlicense",
      "python software foundation license 2.0": "PSF-2.0",
      "python imaging library software license": "PIL",
      "curl license": "curl",
      "freetype project license": "FTL",
      "blue oak model license 1.0.0": "BlueOak-1.0.0",
    };
    const key = first.toLowerCase().replace(/[""]/g, "").replace(/\s+/g, " ").trim();
    return MAP[key] || first;
  };

  const get = (row, idx, fallback = "") =>
    idx >= 0 && row[idx] != null ? String(row[idx]).trim() : fallback;

  const components = [];
  for (let ri = 1; ri < rows.length; ri++) {
    const row = parseCSVRow(rows[ri]);
    if (!row.length || row.every(c => !c)) continue;

    const rawName = get(row, nameCol);
    if (!rawName) continue; // skip rows with no component name

    const rawVer  = get(row, verCol);
    const rawRisk = get(row, riskCol);
    const rawLic  = get(row, licCol);
    const rawDep  = get(row, depCol,  "Direct Dependency");
    const rawDet  = get(row, detCol,  "Binary");
    const rawLink = get(row, linkCol, "Dynamically Linked");
    const rawMatch= get(row, matchCol,"100");

    // Layer: Black Duck doesn't have a layer column — default 0
    // (real layer comes from the Docker scan tool export; Black Duck SCA uses 0)
    const layerNum  = layerCol >= 0 ? (parseInt(get(row, layerCol)) || 0) : 0;
    const pctNum    = parseInt(String(rawMatch).replace(/[^0-9]/g, "")) || 100;
    const riskNorm  = normalizeRisk(rawRisk);
    const licNorm   = normLic(rawLic);

    // Normalise dependency/detection type from Black Duck vocabulary
    const depNorm   = rawDep.includes("Direct") ? "Direct Dependency"
                    : rawDep.includes("Transitive") ? "Transitive"
                    : rawDep || "Direct Dependency";
    const detNorm   = rawDet.includes("KB_COMPONENT") ? "Binary"
                    : rawDet.includes("KB_MODIFIED")   ? "Modified Binary"
                    : rawDet || "Binary";
    const linkNorm  = rawLink === "DYNAMICALLY_LINKED" ? "Dynamically Linked"
                    : rawLink === "STATICALLY_LINKED"  ? "Statically Linked"
                    : rawLink === "SEPARATE_WORK"      ? "Separate Work"
                    : rawLink || "Dynamically Linked";

    const raw = `${rawName} ${rawVer} ${depNorm} ${detNorm} ${pctNum}% ${linkNorm} ${licNorm} ${riskNorm}`;
    components.push({
      name: rawName,
      version: rawVer || "?",
      layer: layerNum,
      depType: depNorm,
      detectionType: detNorm,
      matchPercent: pctNum,
      linkType: linkNorm,
      license: licNorm,
      risk: riskNorm,
      raw,
    });
  }
  return components;
}

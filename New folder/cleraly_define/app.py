"""
DepLens – License & Dependency Scanner backend

Ecosystems : npm, PyPI, Maven (Central), Go (module proxy), RubyGems, NuGet, Debian
Repo scan  : GitHub & GitLab (auto-detects manifest, resolves every dep)
License    : ClearlyDefined.io (primary) + registry-reported license (fallback)

Run : uvicorn app:app --reload
"""
import asyncio, json, re
from typing import Optional

import httpx
from fastapi import FastAPI, Query
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse, StreamingResponse

app = FastAPI(title="DepLens")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])


# ── License classification ─────────────────────────────────────────────────
PERMISSIVE  = ["MIT","Apache","BSD","ISC","Unlicense","CC0","WTFPL","Zlib","Boost",
               "Python-2","PSF","BlueOak","0BSD","AFL","MPL-2","LGPL-2.1",
               "MS-PL","MS-RL","Artistic","OpenSSL"]
COPYLEFT    = ["GPL","LGPL-3","AGPL","OSL","RPL","CPAL","CPL","EPL","SISSL","EUPL","CDDL","MPL-1"]
RESTRICTIVE = ["BUSL","Commons-Clause","SSPL","BSL","Proprietary"]

def classify_license(spdx: Optional[str]) -> str:
    if not spdx or spdx.strip() in ("", "NOASSERTION", "NONE"):
        return "unk"
    s = spdx.upper().lstrip("(").rstrip(")")
    for p in RESTRICTIVE:
        if s.startswith(p.upper()): return "bad"
    for p in COPYLEFT:
        if s.startswith(p.upper()): return "warn"
    for p in PERMISSIVE:
        if s.startswith(p.upper()): return "ok"
    return "unk"


# ── Registry URLs per ecosystem ────────────────────────────────────────────
def registry_url(eco: str, name: str) -> Optional[str]:
    if eco == "npm":    return f"https://www.npmjs.com/package/{name}"
    if eco == "pypi":   return f"https://pypi.org/project/{name}/"
    if eco == "go":     return f"https://pkg.go.dev/{name}"
    if eco == "debian": return f"https://packages.debian.org/search?keywords={name}"
    if eco == "gem":    return f"https://rubygems.org/gems/{name}"
    if eco == "nuget":  return f"https://www.nuget.org/packages/{name}"
    if eco == "maven":
        p = name.split(":", 1)
        return f"https://mvnrepository.com/artifact/{p[0]}/{p[1]}" if len(p) == 2 else None
    return None


# ── ClearlyDefined coordinates per ecosystem ───────────────────────────────
def cd_coord(eco: str, name: str, version: str) -> str:
    v = version or "latest"
    if eco == "npm":
        if name.startswith("@"):
            scope, pkg = name[1:].split("/", 1)
            return f"npm/npmjs/{scope}/{pkg}/{v}"
        return f"npm/npmjs/-/{name}/{v}"
    if eco == "pypi":   return f"pypi/pypi/-/{name.lower()}/{v}"
    if eco == "gem":    return f"gem/rubygems/-/{name}/{v}"
    if eco == "nuget":  return f"nuget/nuget/-/{name.lower()}/{v}"
    if eco == "debian": return f"deb/debian/-/{name}/{v}"
    if eco == "maven":
        g, a = (name.split(":", 1) + ["?"])[:2]
        return f"maven/mavencentral/{g}/{a}/{v}"
    if eco == "go":
        pts = name.split("/")
        ns  = "/".join(pts[:2]) if len(pts) >= 2 else "-"
        pkg = "/".join(pts[2:]) if len(pts) > 2  else "-"
        return f"go/golang/{ns}/{pkg}/{v}"
    return f"{eco}/{eco}/-/{name}/{v}"

async def fetch_cd(client: httpx.AsyncClient, eco: str, name: str, version: str) -> dict:
    try:
        coord = cd_coord(eco, name, version)
        r = await client.get(f"https://api.clearlydefined.io/definitions/{coord}", timeout=12)
        if r.status_code != 200:
            return {"license": None, "score": 0, "cd_url": None}
        d = r.json()
        lic = (d.get("licensed", {}).get("declared") or
               d.get("licensed", {}).get("facets", {}).get("core", {}).get("declared"))
        score = d.get("scores", {}).get("effective") or d.get("scores", {}).get("tool") or 0
        return {"license": lic, "score": round(float(score)),
                "cd_url": f"https://clearlydefined.io/definitions/{coord}"}
    except Exception:
        return {"license": None, "score": 0, "cd_url": None}


# ── Per-ecosystem registry fetchers ───────────────────────────────────────
async def fetch_npm(client, name, req_ver="latest") -> dict:
    tag = "latest"
    if req_ver and req_ver not in ("*", "latest", "") and req_ver[0] not in ("^", "~", ">", "<", "=", "!"):
        tag = req_ver
    try:
        r = await client.get(f"https://registry.npmjs.org/{name.strip()}/{tag}", timeout=12)
        if r.status_code != 200:
            r = await client.get(f"https://registry.npmjs.org/{name.strip()}/latest", timeout=12)
        if r.status_code != 200:
            return {"name": name, "version": "?", "deps": {}, "fallback_lic": None}
        d = r.json()
        return {"name": name, "version": d.get("version", "?"),
                "deps": d.get("dependencies", {}), "fallback_lic": d.get("license")}
    except Exception:
        return {"name": name, "version": "?", "deps": {}, "fallback_lic": None}

_DEP_RE = re.compile(r"^([A-Za-z0-9_\-\.]+)")

async def fetch_pypi(client, name, **_) -> dict:
    try:
        r = await client.get(f"https://pypi.org/pypi/{name}/json", timeout=12)
        if r.status_code != 200:
            return {"name": name, "version": "?", "deps": [], "fallback_lic": None}
        d = r.json()
        raw = d["info"].get("requires_dist") or []
        deps = list({m.group(1)
                     for dep in raw if "extra ==" not in dep.lower()
                     for m in [_DEP_RE.match(dep.strip())] if m})
        return {"name": d["info"].get("name", name), "version": d["info"].get("version", "?"),
                "deps": deps, "fallback_lic": d["info"].get("license")}
    except Exception:
        return {"name": name, "version": "?", "deps": [], "fallback_lic": None}

async def fetch_gem(client, name, **_) -> dict:
    try:
        r = await client.get(f"https://rubygems.org/api/v1/gems/{name}.json", timeout=12)
        if r.status_code != 200:
            return {"name": name, "version": "?", "deps": [], "fallback_lic": None}
        d = r.json()
        deps = [x["name"] for x in d.get("dependencies", {}).get("runtime", [])]
        lics = d.get("licenses") or []
        return {"name": name, "version": d.get("version", "?"),
                "deps": deps, "fallback_lic": lics[0] if lics else None}
    except Exception:
        return {"name": name, "version": "?", "deps": [], "fallback_lic": None}

async def fetch_nuget(client, name, **_) -> dict:
    try:
        # Step 1: latest version list
        r = await client.get(
            f"https://api.nuget.org/v3-flatcontainer/{name.lower()}/index.json", timeout=12)
        if r.status_code != 200:
            return {"name": name, "version": "?", "deps": [], "fallback_lic": None}
        versions = r.json().get("versions", [])
        if not versions:
            return {"name": name, "version": "?", "deps": [], "fallback_lic": None}
        ver = versions[-1]

        # Step 2: registration entry → dependencyGroups
        r2 = await client.get(
            f"https://api.nuget.org/v3/registration5/{name.lower()}/{ver}.json", timeout=12)
        deps = []
        if r2.status_code == 200:
            catalog = r2.json().get("catalogEntry", {})
            seen_d: set = set()
            for group in catalog.get("dependencyGroups", []):
                for dep in group.get("dependencies", []):
                    dep_id = (dep.get("id") or dep.get("Id", "")).strip()
                    if dep_id and dep_id.lower() not in seen_d:
                        deps.append(dep_id)
                        seen_d.add(dep_id.lower())
        return {"name": name, "version": ver, "deps": deps, "fallback_lic": None}
    except Exception:
        return {"name": name, "version": "?", "deps": [], "fallback_lic": None}

async def fetch_maven(client, name, **_) -> dict:
    try:
        g, a = (name.split(":", 1) + ["?"])[:2]

        # Step 1: latest version from Maven Central search
        r = await client.get(
            f"https://search.maven.org/solrsearch/select?q=g:{g}+AND+a:{a}&rows=1&wt=json",
            timeout=12)
        if r.status_code != 200:
            return {"name": name, "version": "?", "deps": [], "fallback_lic": None}
        docs = r.json().get("response", {}).get("docs", [])
        if not docs:
            return {"name": name, "version": "?", "deps": [], "fallback_lic": None}
        ver = docs[0].get("latestVersion", "?")
        if ver == "?":
            return {"name": name, "version": "?", "deps": [], "fallback_lic": None}

        # Step 2: fetch POM from repo1.maven.org → parse <dependency> elements
        g_path = g.replace(".", "/")
        r2 = await client.get(
            f"https://repo1.maven.org/maven2/{g_path}/{a}/{ver}/{a}-{ver}.pom", timeout=12)
        deps = []
        if r2.status_code == 200:
            # Strip test/provided/optional deps before parsing
            pom = re.sub(
                r"<dependency>(?:(?!</dependency>).)*?<scope>(?:test|provided)</scope>.*?</dependency>",
                "", r2.text, flags=re.DOTALL)
            matches = re.findall(
                r"<dependency>\s*<groupId>([^<]+)</groupId>\s*<artifactId>([^<]+)</artifactId>",
                pom, re.DOTALL)
            deps = [f"{gid.strip()}:{aid.strip()}" for gid, aid in matches]
        return {"name": name, "version": ver, "deps": deps, "fallback_lic": None}
    except Exception:
        return {"name": name, "version": "?", "deps": [], "fallback_lic": None}

async def fetch_go(client, name, **_) -> dict:
    try:
        # Step 1: latest version from module proxy
        r = await client.get(f"https://proxy.golang.org/{name}/@latest", timeout=12)
        if r.status_code != 200:
            return {"name": name, "version": "?", "deps": [], "fallback_lic": None}
        ver = r.json().get("Version", "?")
        if ver == "?":
            return {"name": name, "version": "?", "deps": [], "fallback_lic": None}

        # Step 2: fetch go.mod for that version → parse require blocks
        r2 = await client.get(
            f"https://proxy.golang.org/{name}/@v/{ver}.mod", timeout=12)
        deps = []
        if r2.status_code == 200:
            in_req = False
            for line in r2.text.splitlines():
                s = line.strip()
                if s in ("require (", "require("):
                    in_req = True
                elif s == ")":
                    in_req = False
                elif in_req and not s.startswith("//"):
                    m = re.match(r"([\w.\-/]+(?:/v\d+)?)\s+v[\d.]", s)
                    if m:
                        deps.append(m.group(1))
                elif s.startswith("require ") and "require (" not in s:
                    m = re.match(r"require\s+([\w.\-/]+)\s+v", s)
                    if m:
                        deps.append(m.group(1))
        return {"name": name, "version": ver, "deps": deps, "fallback_lic": None}
    except Exception:
        return {"name": name, "version": "?", "deps": [], "fallback_lic": None}

async def fetch_debian(client, name, **_) -> dict:
    try:
        # madison API: version info
        r = await client.get(
            f"https://api.ftp-master.debian.org/madison?package={name}&f=json", timeout=10)
        if r.status_code == 200:
            data = r.json()
            # response: [{name: {suite: {arch: version}}}]
            if isinstance(data, list) and data:
                entry = list(data[0].values())[0] if data[0] else {}
                # grab any stable version
                for suite in ("stable", "bookworm", "bullseye", "buster"):
                    if suite in entry:
                        arches = entry[suite]
                        ver = list(arches.values())[0] if arches else "?"
                        return {"name": name, "version": ver, "deps": [], "fallback_lic": None}
    except Exception:
        pass
    return {"name": name, "version": "?", "deps": [], "fallback_lic": None}

_FETCHERS = {
    "npm": fetch_npm, "pypi": fetch_pypi, "gem": fetch_gem,
    "nuget": fetch_nuget, "maven": fetch_maven, "go": fetch_go, "debian": fetch_debian,
}


# ── Resolver with dep_type + parent tracking ───────────────────────────────
async def resolve(client, root: str, eco: str, max_depth: int = 2, max_pkgs: int = 30) -> list:
    seen: dict = {}
    results: list = []
    sem = asyncio.Semaphore(8)

    async def crawl(name: str, depth: int, parent: Optional[str] = None, req_ver: str = "latest"):
        key = name.lower()
        if key in seen or len(results) >= max_pkgs:
            return
        seen[key] = True

        async with sem:
            if eco == "npm":
                pkg = await fetch_npm(client, name, req_ver)
            else:
                pkg = await _FETCHERS[eco](client, name)

        dep_type = "root" if depth == 0 else "direct" if depth == 1 else "transitive"
        results.append({
            "name": pkg["name"], "version": pkg["version"],
            "depth": depth, "dep_type": dep_type, "parent": parent,
            "fallback_lic": pkg.get("fallback_lic"),
        })

        if depth < max_depth and len(results) < max_pkgs:
            deps = pkg.get("deps", [])
            if isinstance(deps, dict):   # npm: {name: semver}
                items = [(d, v) for d, v in list(deps.items())[:12] if d.lower() not in seen]
                await asyncio.gather(*[crawl(d, depth + 1, name, v) for d, v in items])
            elif isinstance(deps, list):  # pypi / gem
                items = [d for d in deps[:12] if d.lower() not in seen]
                await asyncio.gather(*[crawl(d, depth + 1, name) for d in items])

    await crawl(root, 0)
    return results


# ── VCS repo scanner (GitHub + GitLab) ────────────────────────────────────
def detect_vcs(raw: str):
    s = raw.strip().rstrip("/")
    if "gitlab.com" in s:
        repo = re.sub(r"https?://gitlab\.com/", "", s)
        return "gitlab", repo
    repo = re.sub(r"https?://github\.com/", "", s)
    return "github", repo

async def fetch_vcs_file(client, platform: str, repo: str, branch: str, path: str) -> Optional[str]:
    if platform == "github":
        url = f"https://raw.githubusercontent.com/{repo}/{branch}/{path}"
    else:
        url = f"https://gitlab.com/{repo}/-/raw/{branch}/{path}"
    try:
        r = await client.get(url, timeout=10)
        return r.text if r.status_code == 200 else None
    except Exception:
        return None

_MANIFEST_ORDER = [
    ("package.json",    "npm"),
    ("requirements.txt","pypi"),
    ("go.mod",          "go"),
    ("pom.xml",         "maven"),
    ("Gemfile",         "gem"),
    ("debian/control",  "debian"),
]

def parse_manifest(eco: str, text: str) -> list:
    deps = []
    if eco == "npm":
        try:
            j = json.loads(text)
            deps = list({**j.get("dependencies", {}), **j.get("devDependencies", {})}.keys())
        except Exception:
            pass
    elif eco == "pypi":
        for line in text.splitlines():
            line = line.strip()
            if not line or line.startswith(("#", "-")):
                continue
            raw = re.split(r"[>=<!;\s#\[]", line)[0]
            m = _DEP_RE.match(raw)
            if m:
                deps.append(m.group(1))
    elif eco == "go":
        in_req = False
        for line in text.splitlines():
            s = line.strip()
            if s in ("require (", "require("):
                in_req = True
            elif s == ")":
                in_req = False
            elif in_req and not s.startswith("//"):
                m = re.match(r"([\w.\-/]+)\s+v[\d.]", s)
                if m:
                    deps.append(m.group(1))
            elif s.startswith("require ") and "require (" not in s:
                m = re.match(r"require\s+([\w.\-/]+)\s+v", s)
                if m:
                    deps.append(m.group(1))
    elif eco == "maven":
        matches = re.findall(
            r"<groupId>([^<]+)</groupId>\s*<artifactId>([^<]+)</artifactId>", text)
        deps = [f"{g}:{a}" for g, a in matches[1:41]]
    elif eco == "gem":
        deps = re.findall(r"""gem\s+['"]([^'"]+)['"]""", text)
    elif eco == "debian":
        m = re.search(r"Depends:\s*([^\n]+)", text)
        if m:
            deps = [d.strip().split()[0].split("(")[0] for d in m.group(1).split(",") if d.strip()]
    return [d for d in deps if d][:40]

async def scan_vcs_repo(client, platform: str, repo: str, branch: str):
    for path, eco in _MANIFEST_ORDER:
        text = await fetch_vcs_file(client, platform, repo, branch, path)
        if text:
            deps = parse_manifest(eco, text)
            if deps:
                return eco, path, deps
    return None, None, []


# ── SSE helpers ────────────────────────────────────────────────────────────
def _sse(obj: dict) -> str:
    return f"data: {json.dumps(obj)}\n\n"

async def _enrich(client, eco: str, pkg: dict) -> str:
    cd  = await fetch_cd(client, eco, pkg["name"], pkg["version"])
    lic = cd["license"] or pkg.get("fallback_lic") or "Unknown"
    return _sse({"type": "package", "pkg": {
        **{k: v for k, v in pkg.items() if k != "fallback_lic"},
        "license":      lic,
        "lic_class":    classify_license(cd["license"] or pkg.get("fallback_lic")),
        "score":        cd["score"],
        "cd_url":       cd["cd_url"],
        "registry_url": registry_url(eco, pkg["name"]),
    }})


# ── Package scan stream ────────────────────────────────────────────────────
async def _pkg_stream(package: str, ecosystem: str):
    async with httpx.AsyncClient(follow_redirects=True) as client:
        yield _sse({"type": "progress", "pct": 5,
                    "stage": f'Resolving {ecosystem} deps for "{package}"…'})
        try:
            pkgs = await resolve(client, package, ecosystem)
        except Exception as exc:
            yield _sse({"type": "error", "message": str(exc)}); return

        if not pkgs:
            yield _sse({"type": "error",
                        "message": f'Package "{package}" not found on {ecosystem}.'}); return

        yield _sse({"type": "progress", "pct": 28,
                    "stage": f"Found {len(pkgs)} packages — fetching licenses from ClearlyDefined…"})
        for i, pkg in enumerate(pkgs):
            pct = 28 + round(((i + 1) / len(pkgs)) * 67)
            yield _sse({"type": "progress", "pct": pct,
                        "stage": f'[{i+1}/{len(pkgs)}] Checking {pkg["name"]}…'})
            yield await _enrich(client, ecosystem, pkg)
        yield _sse({"type": "done"})


# ── Repo scan stream (GitHub / GitLab) ────────────────────────────────────
async def _repo_stream(raw_repo: str, branch: str):
    async with httpx.AsyncClient(follow_redirects=True) as client:
        platform, repo = detect_vcs(raw_repo)
        yield _sse({"type": "progress", "pct": 5,
                    "stage": f"Probing {platform}.com/{repo} @ {branch}…"})

        eco, manifest, deps = await scan_vcs_repo(client, platform, repo, branch)
        if not eco and branch == "main":   # retry with master
            eco, manifest, deps = await scan_vcs_repo(client, platform, repo, "master")
        if not eco:
            yield _sse({"type": "error",
                        "message": (f"No manifest found in {repo}. "
                                    "Tried: package.json, requirements.txt, go.mod, "
                                    "pom.xml, Gemfile, debian/control")}); return

        yield _sse({"type": "detected", "eco": eco, "file": manifest,
                    "count": len(deps), "platform": platform})
        yield _sse({"type": "progress", "pct": 12,
                    "stage": f"Detected {eco} via {manifest} — {len(deps)} deps found"})

        # Yield root repo entry (use last segment of repo path as name)
        root_name = repo.split("/")[-1]
        root_cd = await fetch_cd(client, eco, root_name, "latest")
        yield _sse({"type": "package", "pkg": {
            "name": repo, "version": "root", "depth": 0,
            "dep_type": "root", "parent": None,
            "license": root_cd["license"] or "Unknown",
            "lic_class": classify_license(root_cd["license"]),
            "score": root_cd["score"], "cd_url": root_cd["cd_url"],
            "registry_url": f"https://{platform}.com/{repo}",
        }})

        for i, dep in enumerate(deps):
            pct = 12 + round(((i + 1) / len(deps)) * 83)
            yield _sse({"type": "progress", "pct": pct,
                        "stage": f"[{i+1}/{len(deps)}] Checking {dep}…"})
            fetch_fn = _FETCHERS.get(eco, fetch_debian)
            try:
                meta = (await fetch_npm(client, dep) if eco == "npm"
                        else await fetch_fn(client, dep))
            except Exception:
                meta = {"name": dep, "version": "?", "fallback_lic": None}

            pkg = {"name": dep, "version": meta.get("version", "?"),
                   "depth": 1, "dep_type": "direct", "parent": repo,
                   "fallback_lic": meta.get("fallback_lic")}
            yield await _enrich(client, eco, pkg)

        yield _sse({"type": "done"})


# ── Routes ─────────────────────────────────────────────────────────────────
_SSE_HEADERS = {"Cache-Control": "no-cache", "X-Accel-Buffering": "no"}

@app.get("/api/scan")
async def api_scan(
    package:   str = Query(..., min_length=1),
    ecosystem: str = Query(..., pattern="^(npm|pypi|maven|go|gem|nuget|debian)$"),
):
    return StreamingResponse(_pkg_stream(package, ecosystem),
                             media_type="text/event-stream", headers=_SSE_HEADERS)

@app.get("/api/scan-repo")
async def api_scan_repo(
    repo:   str = Query(..., min_length=1),
    branch: str = Query(default="main"),
):
    return StreamingResponse(_repo_stream(repo, branch),
                             media_type="text/event-stream", headers=_SSE_HEADERS)

@app.get("/")
async def root():
    return FileResponse("index.html")

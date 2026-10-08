# CPP — Citizen Policy Portal
## Spanish Government Digital Governance Platform
### Complete Resume & Interview Preparation Guide

---

## PROJECT OVERVIEW

**Project Name:** CPP (Citizen Policy Portal)
**Client:** Spanish Government (Public Sector)
**Role:** SDET / Automation Engineer
**Domain:** Government Digital Transformation
**Scale:** Millions of Citizens | Enterprise Grade

### What the Platform Does:
CPP is a large-scale Spanish Government digital platform built to centralize, manage,
and distribute government information, policies, and public services to citizens.

**Dual-Model Architecture:**
1. Policy Feed (Twitter-like) — Government bodies push new policies, circulars, and
   announcements to targeted citizen groups based on category
   (Healthcare, Education, Taxation, Housing, Agriculture, etc.)

2. DocuSafe Vault (DigiLocker-like) — Citizens securely store, access, and share
   government-issued documents (ID, licenses, certificates) digitally

---

## USER JOURNEY (Explain in Interview)

```
Citizen Registers
       ↓
Government Identity Verified (Spain DNI / OAuth SSO - Cl@ve)
       ↓
Profile Created → Category/Group Assigned
(Healthcare / Education / Tax / Housing / Agriculture)
       ↓
User joins Group (targeted policy delivery)
       ↓
Government publishes Policy → Only that Group sees it
       ↓
User can Download / Upload Documents related to that policy
       ↓
Document stored in encrypted private vault
```

---

## FULL TECH STACK

| Category              | Technologies                                              |
|-----------------------|-----------------------------------------------------------|
| Test Automation (Web) | Python, Robot Framework, Selenium WebDriver               |
| Mobile Automation     | Appium, Android Studio, ADB, UIAutomator2, Python         |
| Web UI Testing        | Selenium Grid, Cross-Browser Testing, Page Object Model   |
| API Testing           | Python Requests, REST API, JSON Schema Validation         |
| CI/CD                 | GitHub Actions, Self-Hosted Runners, Docker               |
| Infrastructure (IaC)  | Terraform, Kubernetes (K8s), Ansible                      |
| Reporting             | Allure Reports, Robot Framework HTML Reports              |
| Version Control       | Git, GitHub                                               |
| Cloud                 | AWS / Azure (Government Cloud)                            |
| Security Testing      | RBAC, OWASP, PII Validation, JWT Testing                  |
| Project Management    | Agile / Scrum — Government Enterprise                     |

---

## RESUME BULLET POINTS (Copy-Paste Ready)

### Automation & Testing (Web UI)
- Designed and implemented end-to-end test automation framework using Python +
  Robot Framework + Selenium covering UI, API, and regression test suites for
  a citizen-facing government portal serving millions of users
- Built keyword-driven and data-driven test suites in Robot Framework with 200+
  test cases covering policy publishing, citizen notifications, document
  upload/download, and category-based access control
- Implemented Page Object Model (POM) design pattern for maintainable, scalable
  Web UI test suites across the citizen portal and government admin dashboard
- Executed cross-browser testing (Chrome, Firefox, Edge, Safari) using Selenium
  Grid ensuring compatibility across all citizen devices
- Automated end-to-end Web UI flows: user registration, group assignment, policy
  feed rendering, document vault access, and download verification

### Mobile Automation (Android)
- Built Android mobile automation framework using Appium + Python + UIAutomator2
  for the CPP citizen mobile app available on Google Play Store
- Automated critical Android user journeys: government SSO login, group-based
  policy notifications, push notification delivery, document upload via camera
  capture, and offline document access
- Performed Android-specific testing: deep link validation, push notification
  triggers, background app refresh, biometric authentication (fingerprint/face),
  and low-network condition document loading
- Integrated Appium tests into GitHub Actions CI/CD pipeline using Android emulators
  (AVD) running on self-hosted agents for automated mobile regression on every build
- Validated Android permissions handling (camera, storage, notifications) required
  for document scanning and secure vault access
- Tested Android app on multiple API levels (API 29 to API 34) ensuring backward
  compatibility across older citizen devices
- Automated Google Play Store deep-link flows and government SSO redirect handling
  within the Android WebView component

### API Testing
- Automated REST API testing using Python Requests library validating government
  policy feed endpoints, document vault APIs, and citizen authentication flows
- Implemented JSON Schema validation for all API responses ensuring contract
  compliance between microservices
- Validated role-based API responses — confirmed Group A citizen cannot access
  Group B policies even with direct API endpoint knowledge (returns 403 Forbidden)

### CI/CD & DevOps
- Configured GitHub Actions pipelines with self-hosted agents deployed inside
  secure government network to trigger Web UI + Android automated test suites
  on every pull request and deployment event
- Built Infrastructure as Code (IaC) using Terraform to provision and manage
  cloud infrastructure for staging and production government environments
- Deployed microservices on Kubernetes (K8s) clusters ensuring high availability
  and zero-downtime deployments for citizen-critical services
- Used Ansible playbooks for configuration management, automating server setup,
  environment patching, and security hardening across government servers
- Full CI/CD pipeline: Commit → GitHub Actions → API Tests → Web UI Tests →
  Android Tests → Docker Build → K8s Deploy → Health Check → Allure Report

### Security Testing
- Validated Role Based Access Control (RBAC) — ensured only authorized government
  bodies can publish policies to specific citizen categories
- Automated document integrity checks verifying AES-256 encryption, digital
  signatures, and tamper detection in the document vault
- Performed security regression testing: RBAC bypass attempts, JWT token expiry
  validation, SQL injection on login, pre-signed URL expiry (15-min window),
  and PII data protection compliance
- Tested Android biometric authentication fallback and secure token storage
  using Android Keystore system validation

---

## KEY ACHIEVEMENTS

- Automated 200+ test cases covering Web UI + Android + API + Security layers
- 70% reduction in regression testing time through full automation
- Zero-downtime K8s deployments for citizen-critical government services
- Self-hosted GitHub Actions runners inside secure government network
- Full IaC using Terraform — complete infrastructure reproducibility
- RBAC automation — category-specific policy delivery validated at API level
- Cross-browser + cross-device Android compatibility verified
- Integrated CI/CD pipeline from commit to production with automated gates
- Appium Android suite running on CI with Android emulators on self-hosted agents
- Pre-signed URL expiry security verified — 15-minute document access window

---

## SECURITY DEEP DIVE

### Authentication & Identity
```
Citizen Login
    ↓
OAuth 2.0 / SSO (Spain's Cl@ve system - Govt SSO)
    ↓
JWT Token issued (expires in 1 hour)
    ↓
Refresh Token stored in HttpOnly Cookie (not JS accessible)
    ↓
Every API call validated with token
```

### Group & Policy Access Control (RBAC)
```
Government Admin
    ↓
Creates Policy → Assigns to Group: "Healthcare_Spain_2024"
    ↓
Only users with role = "Healthcare" can VIEW this policy
    ↓
Other groups: Policy is INVISIBLE (API returns 403 — not just hidden in UI)
```

### Document Vault Security Flow
```
User uploads document
      ↓
Malware scan (ClamAV / AWS Macie)
      ↓
File encrypted using AES-256
      ↓
Stored in Private S3 Bucket (no public access)
      ↓
Metadata saved in DB (owner, group, expiry, checksum)
      ↓
User requests download
      ↓
Backend generates Pre-Signed URL (valid 15 mins only)
      ↓
URL expires automatically — link cannot be shared or reused
```

### Android Security
```
App Launch
    ↓
Certificate Pinning (prevents MITM attacks)
    ↓
Biometric Auth (Fingerprint / Face ID)
    ↓
JWT stored in Android Keystore (not SharedPreferences)
    ↓
Document download triggers pre-signed URL (15 min expiry)
    ↓
Downloaded file stored in app-private storage (not accessible to other apps)
```

---

## WHAT WE TESTED AS SDET — Full Test Scenarios

| Test Scenario                  | What We Validated                                              |
|-------------------------------|----------------------------------------------------------------|
| RBAC bypass attempt            | Group A user accessing Group B policy → must get 403          |
| Token expiry test              | After 1 hour, API must reject old JWT                         |
| Document access control        | User A cannot download User B's document                      |
| Pre-signed URL expiry          | Download link must fail after 15 minutes                      |
| Malware upload test            | Infected file upload → system must reject                     |
| SQL Injection on login         | Input ' OR 1=1 -- → must not bypass auth                     |
| Group assignment validation    | New user assigned correct group based on profile              |
| Policy visibility test         | Healthcare policy invisible to Education group                |
| Android deep link validation   | Govt SSO redirect handled correctly in WebView                |
| Android push notification      | Policy notification delivered to correct group only           |
| Android biometric fallback     | PIN fallback works when biometric fails                       |
| Android camera document scan   | Document captured and uploaded to vault successfully          |
| Android offline access         | Previously downloaded docs accessible without network         |
| Android low-network test       | App handles 2G/3G gracefully during document load             |
| Cross-browser Web UI           | Chrome, Firefox, Edge, Safari — same policy feed rendering    |
| Android multi-version          | App works on API 29, 30, 31, 33, 34                          |

---

## INTERVIEW READY ANSWERS

**Q: How was data secured?**
"AES-256 encryption at rest, TLS 1.3 in transit, pre-signed URLs for document
access with 15-min expiry. On Android, tokens stored in Android Keystore —
never in SharedPreferences."

**Q: How did group-based access work?**
"RBAC at API level — JWT token carried user's group claims. Backend validated
on every request. UI hiding was just cosmetic — real security was enforced
in the API layer returning 403 for unauthorized access."

**Q: What security testing did you do?**
"We automated RBAC bypass tests, token expiry validation, SQL injection checks,
document access control, and Android certificate pinning verification using
Python + Robot Framework in CI/CD — every deploy triggered these security suites."

**Q: How was Android automation integrated in CI/CD?**
"We ran Appium tests on Android emulators (AVD) hosted on self-hosted GitHub
Actions runners inside the government network. Every build triggered the mobile
regression suite — results published to Allure Reports."

**Q: Why self-hosted GitHub Actions runners?**
"Government security policy doesn't allow code or test execution on public cloud
runners. We set up self-hosted agents inside the secure government network —
this also gave us access to internal staging URLs not publicly accessible."

**Q: How did you handle Android permissions in tests?**
"Appium's UIAutomator2 driver allowed us to automate Android permission dialogs.
We used desired capabilities to pre-grant permissions for camera and storage
in emulator setup, and also tested the actual permission grant/deny flows."

---

## LINKEDIN SUMMARY (Short Version)

"Led SDET automation for CPP — a Spanish Government platform managing citizen
policy distribution and digital document storage. Built Python + Robot Framework
+ Selenium + Appium automation suite covering Web UI, Android mobile, and API
testing layers. Full CI/CD via GitHub Actions (self-hosted), Terraform, K8s,
and Ansible. Achieved 70%+ regression time reduction across 200+ automated
test cases. Implemented security test automation covering RBAC, JWT validation,
and document access control."

---

## POWER PHRASES FOR INTERVIEWS

- "I worked on a government-scale platform serving millions of citizens"
  → shows enterprise-level scale

- "I built the automation framework from scratch covering Web, Android, and API"
  → shows full-stack testing ownership

- "I set up self-hosted GitHub Actions runners inside a secure government network"
  → shows DevSecOps knowledge

- "The platform had both a social-feed model and a document vault"
  → shows complex domain understanding

- "We used Terraform + Ansible + K8s together for the full deployment pipeline"
  → shows full DevOps stack

- "Android tokens were stored in Android Keystore — never in SharedPreferences"
  → shows mobile security depth

- "Pre-signed URLs with 15-minute expiry — no permanent document links existed"
  → shows security-first thinking

- "RBAC was enforced at API level, not just hidden in UI"
  → shows backend security understanding


using the cmds :

adb shell getprop ro.build.version.release   # Android version
adb shell getprop ro.build.version.sdk 
  return int(result.decode().strip())


granting access to diffrnet level of the api andriod device:

def grant(permission):
    cmd = f"adb shell pm grant {PACKAGE} {permission}"
    subprocess.run(cmd, shell=True)
    print(f"Granted: {permission}")
grant("android.permission.CAMERA")
grant("android.permission.ACCESS_FINE_LOCATION")
grant("android.permission.ACCESS_COARSE_LOCATION")

# For Android 13+ (notifications)
grant("android.permission.POST_NOTIFICATIONS")


---

*Generated for Interview Preparation — CPP Project*
*Role: SDET / Automation Engineer | Domain: Spanish Government*

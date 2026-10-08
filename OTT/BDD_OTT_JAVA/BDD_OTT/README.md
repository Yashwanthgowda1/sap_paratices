# JioHotstar OTT — BDD Automation Framework

Cucumber + TestNG + Appium + Java 21 BDD framework for JioHotstar OTT application.

---

## Project Structure

```
BDD_OTT/
├── src/test/java/
│   ├── feature/               → Cucumber feature files
│   ├── stepDefinitions/       → Step definition classes
│   ├── hooks/                 → Before/After hooks
│   ├── Testngrunners/         → Smoke and Regression runners
│   └── utilities/             → RetryAnalyzer, RetryListener
├── src/main/java/
│   └── utilities/             → DriverFactory, ConfigReader, ExtentManager
├── src/test/resources/
│   └── Test_data/config.json  → Device caps, credentials
├── testng.xml                 → Full suite (smoke + regression parallel)
├── testng-smoke.xml           → Smoke suite only
├── testng-regression.xml      → Regression suite only
└── .github/workflows/
    └── ott-tests.yml          → GitHub Actions pipeline
```

---

## Tech Stack

| Tool | Version |
|---|---|
| Java | 21 |
| Appium | 2.x |
| Selenium | 4.10.0 |
| Cucumber | 7.15.0 |
| TestNG | 7.10.2 |
| ExtentReports | 5.1.1 |
| UiAutomator2 | Android automation |

---

## Run Tests Locally

```bash
# Full suite (smoke + regression parallel)
mvn test -DsuiteXmlFile=testng.xml

# Smoke only
mvn test -DsuiteXmlFile=testng-smoke.xml

# Regression only
mvn test -DsuiteXmlFile=testng-regression.xml
```

---

## CI/CD — GitHub Actions

### Pipeline File
`.github/workflows/ott-tests.yml`

### Architecture

```
┌─────────────────────────────────────────┐
│         ON-PREMISE (Local Setup)        │
│                                         │
│  Self-Hosted Runner → "local-runner"    │
│  Physical Android Device (USB/WiFi)     │
│  Appium Server on port 4730             │
│  Android + Web Test Cases               │
│                                         │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│         EC2 SERVER (Cloud)              │
│                                         │
│  Self-Hosted Runner → "ec2-runner"      │
│  Android Emulator (API 33)              │
│  Web Test Cases (headless)              │
│                                         │
└─────────────────────────────────────────┘
```

### Triggers

| Trigger | What Runs |
|---|---|
| Push to main/develop | Smoke Tests |
| PR raised to main | Smoke Tests |
| PR Approved | Regression Tests |
| Manual (workflow_dispatch) | Choose: smoke / regression / all |

### Job Flow

```
Push / PR Raised
      │
      ▼
Smoke Tests (Job 1)
      │ passes ✅
      ▼
Regression Tests (Job 2)  ← only on PR Approved
      │
      ▼
Reports uploaded as Artifacts (7 days)
```

### Setup Self-Hosted Runner (Local PC)

```bash
# Step 1 — Go to GitHub
# Repo → Settings → Actions → Runners → New self-hosted runner

# Step 2 — GitHub gives commands, run on your PC:
./config.cmd --url https://github.com/your-org/your-repo --token YOUR_TOKEN

# Step 3 — Start runner
./run.cmd

# Step 4 — Use in pipeline
runs-on: [self-hosted, local-runner]
```

### Setup Self-Hosted Runner (EC2)

```bash
# SSH into EC2
ssh -i key.pem ubuntu@ec2-public-ip

# Go to GitHub
# Repo → Settings → Actions → Runners → New self-hosted runner

# Run commands GitHub provides on EC2:
./config.sh --url https://github.com/your-org/your-repo --token YOUR_TOKEN

# Start runner
./run.sh

# Use in pipeline
runs-on: [self-hosted, ec2-runner]
```

### Connect Physical Android Device over WiFi

```bash
# Step 1 — Connect USB once, enable TCP mode
adb tcpip 5555

# Step 2 — Disconnect USB, connect over WiFi
adb connect 192.168.1.100:5555

# Step 3 — Verify
adb devices
# 192.168.1.100:5555   device ✅

# Step 4 — Store as GitHub Secret
# Repo → Settings → Secrets → DEVICE_IP = 192.168.1.100
```

### GitHub Secrets Required

| Secret | Value |
|---|---|
| `DEVICE_IP` | Android device IP (e.g. 192.168.1.100) |
| `APK_DOWNLOAD_URL` | URL to download hotstar.apk |

---

## CI/CD — Jenkins

### Architecture

```
EC2 Server                    Office PC
│                             │
│  Jenkins Master             │  agent.jar (one file only)
│  (full install)             │  Android Device (USB/WiFi)
│  port 8080                  │  Appium Server
│  UI + Pipelines             │  Java + Maven
│                             │
└──── JNLP connection ────────┘
      communicates both ways
```

### Jenkins Master Setup on EC2

```bash
# SSH into EC2
ssh -i key.pem ubuntu@ec2-public-ip

# Install Java
sudo apt update
sudo apt install -y openjdk-21-jdk

# Install Jenkins
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install -y jenkins

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Access Jenkins UI
http://ec2-public-ip:8080
```

### Jenkins Agent Setup on Local Office PC

```
Step 1 — Jenkins UI → Manage Jenkins → Manage Nodes → New Node
    Node name     → local-android-node
    Type          → Permanent Agent
    Remote dir    → C:\jenkins-agent
    Labels        → local-node android
    Launch method → Launch agent by connecting to controller (JNLP)

Step 2 — Jenkins gives you a command like:
    java -jar agent.jar -url http://ec2-ip:8080 -secret abc123 -name local-android-node

Step 3 — On Office PC:
    mkdir C:\jenkins-agent
    Download agent.jar from http://ec2-ip:8080/jnlpJars/agent.jar
    Run the command Jenkins gave you

Step 4 — Verify in Jenkins
    Manage Nodes → local-android-node → Status: Connected ✅
```

### Jenkinsfile

```groovy
pipeline {

    agent none

    parameters {
        choice(
            name: 'TEST_SUITE',
            choices: ['smoke', 'regression', 'all'],
            description: 'Which test suite to run?'
        )
    }

    stages {

        stage('Web + Emulator Tests') {
            agent { label 'ec2-node' }
            when {
                expression {
                    params.TEST_SUITE == 'smoke' || params.TEST_SUITE == 'all'
                }
            }
            steps {
                checkout scm
                sh 'mvn test -DsuiteXmlFile=testng-smoke.xml'
            }
            post {
                always {
                    publishHTML(target: [
                        reportDir: 'test-output',
                        reportFiles: 'ExtentReport.html',
                        reportName: 'Smoke Extent Report'
                    ])
                }
            }
        }

        stage('Physical Android Tests') {
            agent { label 'local-node' }
            when {
                expression {
                    params.TEST_SUITE == 'regression' || params.TEST_SUITE == 'all'
                }
            }
            steps {
                checkout scm
                sh 'adb connect ${DEVICE_IP}:5555'
                sh 'adb wait-for-device'
                sh 'appium --port 4730 --log appium.log &'
                sh 'sleep 5'
                sh 'mvn test -DsuiteXmlFile=testng-regression.xml'
            }
            post {
                always {
                    publishHTML(target: [
                        reportDir: 'test-output',
                        reportFiles: 'ExtentReport.html',
                        reportName: 'Regression Extent Report'
                    ])
                }
                failure {
                    archiveArtifacts artifacts: 'appium.log'
                }
            }
        }

    }
}
```

### Jenkins Node Status

```
Jenkins → Manage Jenkins → Manage Nodes

Name                    Status        Location
local-android-node      ✅ Connected  Office PC (local-node label)
ec2-node                ✅ Connected  AWS EC2   (ec2-node label)
```

### Job Routing

```
TEST_SUITE = smoke      → ec2-node (emulator)
TEST_SUITE = regression → local-node (physical device)
TEST_SUITE = all        → both nodes run sequentially
```

---

## Retry Mechanism

| Class | Role |
|---|---|
| `RetryAnalyzer` | Retries failed test up to 2 times |
| `RetryListener` | Auto-wires RetryAnalyzer to every @Test via testng.xml |

No manual annotation needed on each test — listener handles it globally.

---

## Reports

| Report | Location |
|---|---|
| Extent Report | `test-output/ExtentReport/` |
| Surefire Report | `target/surefire-reports/` |
| GitHub Artifacts | Actions → Run → Artifacts (7 days) |
| Jenkins HTML Report | Jenkins → Job → Extent Report |

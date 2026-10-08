# Restful API Test Automation (Robot Framework)

This project contains automated tests for the **Restful Booker API** using **Robot Framework**.

---

## 📦 Setup Instructions

### 1️⃣ Create Virtual Environment
```bash
# Create venv
python -m venv venv
 ```

2️⃣ Activate Virtual Environment

# On Windows (cmd)
venv\Scripts\activate



# On Windows (PowerShell)
.\venv\Scripts\Activate.ps1

# On Linux / Mac
source venv/bin/activate



## Install Dependencies
```bash
pip install -r requirements.txt

```

# Verify Installation

```bash
After installing dependencies, check if Robot Framework libraries are available:

pip list

Restart the terminal, or

Use shortcut:
    1.  Ctrl + Shift + P → Robot Framework: Clear caches and restart



Running Tests

To run tests and store results in the results folder:

robot -d results tests/


Run with tag filter:

robot -d results -i 53633 tests/

```

🌐 Remote Development (EC2 + VS Code)

Create EC2 instance (Ubuntu recommended).

Open VS Code → Ctrl + Shift + P → Remote-SSH: Connect to Host.

Enter connection string:

ssh -i <pem_file> ubuntu@<public_ip>


Once connected, install Python & dependencies on EC2.

📂 Project Structure
RestApi/
│── venv/                 # Virtual environment
│── requirements.txt       # Dependencies
│── tests/                 # Robot Framework test suites
│   ├── Restful-Booker_API.robot
│── resources/             # Test data, JSON schemas, variables
│   ├── json_schema/
│── results/               # Test run logs & reports
│── README.md              # Setup guide (this file)
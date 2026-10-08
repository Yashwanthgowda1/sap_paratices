-- ============================================================
-- INSURANCE DOMAIN DATABASE SCHEMA
-- Database: SQLite
-- ============================================================

PRAGMA foreign_keys = ON;

-- ============================================================
-- 1. BRANCHES
-- ============================================================
CREATE TABLE IF NOT EXISTS branches (
    branch_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    branch_name     TEXT NOT NULL,
    region          TEXT NOT NULL,
    address         TEXT,
    contact_phone   TEXT,
    contact_email   TEXT,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 2. USERS (System login — Admin, Agent, Customer, Assessor)
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    user_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    email           TEXT NOT NULL UNIQUE,
    name            TEXT NOT NULL UNIQUE,
    password_hash   TEXT NOT NULL,
    role            TEXT  DEFAULT 'Customer' CHECK(role IN ('Admin','Agent','Customer','Assessor','Underwriter')),
    is_active       INTEGER DEFAULT 1,
    last_login      DATETIME,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 3. AGENTS
-- ============================================================
CREATE TABLE IF NOT EXISTS agents (
    agent_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id         INTEGER REFERENCES users(user_id),
    first_name      TEXT NOT NULL,
    last_name       TEXT NOT NULL,
    email           TEXT NOT NULL UNIQUE,
    phone           TEXT,
    license_no      TEXT UNIQUE ,
    branch_id       INTEGER REFERENCES branches(branch_id),
    commission_rate REAL DEFAULT 5.0,
    status          TEXT DEFAULT 'Active' CHECK(status IN ('Active','Inactive','Suspended')),
    joined_date     DATE,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 4. CUSTOMERS (Policyholders)
-- ============================================================
CREATE TABLE IF NOT EXISTS customers (
    customer_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id         INTEGER REFERENCES users(user_id),
    first_name      TEXT NOT NULL,
    last_name       TEXT NOT NULL,
    dob             DATE NOT NULL,
    gender          TEXT CHECK(gender IN ('Male','Female','Other')),
    email           TEXT NOT NULL UNIQUE,
    phone           TEXT,
    address         TEXT,
    city            TEXT,
    state           TEXT,
    pincode         TEXT,
    pan_number      TEXT UNIQUE,
    aadhar_number   TEXT UNIQUE,
    kyc_status      TEXT DEFAULT 'Pending' CHECK(kyc_status IN ('Pending','Verified','Rejected')),
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 5. INSURANCE PRODUCTS (Life / Health / Auto / Property)
-- ============================================================
CREATE TABLE IF NOT EXISTS insurance_products (
    product_id          INTEGER PRIMARY KEY AUTOINCREMENT,
    product_name        TEXT NOT NULL,
    product_code        TEXT NOT NULL UNIQUE,
    insurance_type      TEXT NOT NULL CHECK(insurance_type IN ('Life','Health','Auto','Property','Travel')),
    description         TEXT,
    min_premium         REAL,
    max_sum_assured     REAL,
    policy_term_years   INTEGER,
    is_active           INTEGER DEFAULT 1,
    created_at          DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 6. POLICIES (Core policy table)
-- ============================================================
CREATE TABLE IF NOT EXISTS policies (
    policy_id           INTEGER PRIMARY KEY AUTOINCREMENT,
    policy_number       TEXT NOT NULL UNIQUE,
    customer_id         INTEGER NOT NULL REFERENCES customers(customer_id),
    product_id          INTEGER NOT NULL REFERENCES insurance_products(product_id),
    agent_id            INTEGER REFERENCES agents(agent_id),
    start_date          DATE NOT NULL,
    end_date            DATE NOT NULL,
    sum_assured         REAL NOT NULL,
    annual_premium      REAL NOT NULL,
    payment_frequency   TEXT DEFAULT 'Annual' CHECK(payment_frequency IN ('Monthly','Quarterly','Half-Yearly','Annual')),
    status              TEXT DEFAULT 'Active' CHECK(status IN ('Active','Lapsed','Expired','Cancelled','Surrendered')),
    issued_at           DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_updated        DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 7. POLICY COVERAGE (What is covered under each policy)
-- ============================================================
CREATE TABLE IF NOT EXISTS policy_coverage (
    coverage_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    policy_id           INTEGER NOT NULL REFERENCES policies(policy_id),
    coverage_type       TEXT NOT NULL,
    coverage_limit      REAL,
    deductible          REAL DEFAULT 0,
    exclusions          TEXT,
    created_at          DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 8. POLICY RIDERS (Add-ons to base policy)
-- ============================================================
CREATE TABLE IF NOT EXISTS policy_riders (
    rider_id            INTEGER PRIMARY KEY AUTOINCREMENT,
    policy_id           INTEGER NOT NULL REFERENCES policies(policy_id),
    rider_type          TEXT NOT NULL,
    coverage_amount     REAL,
    additional_premium  REAL DEFAULT 0,
    created_at          DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 9. BENEFICIARIES (Nominees)
-- ============================================================
CREATE TABLE IF NOT EXISTS beneficiaries (
    beneficiary_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    policy_id           INTEGER NOT NULL REFERENCES policies(policy_id),
    full_name           TEXT NOT NULL,
    relationship        TEXT NOT NULL,
    dob                 DATE,
    percentage_share    REAL DEFAULT 100,
    contact_phone       TEXT,
    created_at          DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 10. PREMIUMS (Scheduled premium dues)
-- ============================================================
CREATE TABLE IF NOT EXISTS premiums (
    premium_id          INTEGER PRIMARY KEY AUTOINCREMENT,
    policy_id           INTEGER NOT NULL REFERENCES policies(policy_id),
    due_date            DATE NOT NULL,
    amount              REAL NOT NULL,
    frequency           TEXT NOT NULL,
    status              TEXT DEFAULT 'Due' CHECK(status IN ('Paid','Due','Overdue','Waived')),
    grace_period_end    DATE,
    created_at          DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 11. PAYMENTS (Actual payment transactions)
-- ============================================================
CREATE TABLE IF NOT EXISTS payments (
    payment_id          INTEGER PRIMARY KEY AUTOINCREMENT,
    policy_id           INTEGER NOT NULL REFERENCES policies(policy_id),
    premium_id          INTEGER REFERENCES premiums(premium_id),
    amount_paid         REAL NOT NULL,
    payment_date        DATETIME NOT NULL,
    payment_mode        TEXT CHECK(payment_mode IN ('Cash','Card','UPI','NEFT','RTGS','Cheque','NetBanking')),
    transaction_ref     TEXT UNIQUE,
    status              TEXT DEFAULT 'Success' CHECK(status IN ('Success','Failed','Pending','Refunded')),
    created_at          DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 12. PAYMENT RECEIPTS
-- ============================================================
CREATE TABLE IF NOT EXISTS payment_receipts (
    receipt_id          INTEGER PRIMARY KEY AUTOINCREMENT,
    payment_id          INTEGER NOT NULL REFERENCES payments(payment_id),
    receipt_number      TEXT NOT NULL UNIQUE,
    issued_date         DATE NOT NULL,
    pdf_path            TEXT,
    created_at          DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 13. RISK PROFILES
-- ============================================================
CREATE TABLE IF NOT EXISTS risk_profiles (
    risk_id             INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id         INTEGER NOT NULL REFERENCES customers(customer_id),
    risk_score          REAL,
    risk_category       TEXT CHECK(risk_category IN ('Low','Medium','High','Very High')),
    assessment_notes    TEXT,
    assessed_on         DATE,
    assessed_by         INTEGER REFERENCES users(user_id),
    created_at          DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 14. UNDERWRITING DECISIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS underwriting_decisions (
    decision_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    policy_id           INTEGER NOT NULL REFERENCES policies(policy_id),
    underwriter_id      INTEGER REFERENCES users(user_id),
    decision            TEXT NOT NULL CHECK(decision IN ('Approved','Declined','Modified','Deferred')),
    premium_loading     REAL DEFAULT 0,
    remarks             TEXT,
    decided_at          DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 15. CLAIMS (Core claim record)
-- ============================================================
CREATE TABLE IF NOT EXISTS claims (
    claim_id            INTEGER PRIMARY KEY AUTOINCREMENT,
    claim_number        TEXT NOT NULL UNIQUE,
    policy_id           INTEGER NOT NULL REFERENCES policies(policy_id),
    customer_id         INTEGER NOT NULL REFERENCES customers(customer_id),
    incident_date       DATE NOT NULL,
    claim_date          DATE NOT NULL,
    claim_type          TEXT NOT NULL,
    claim_amount        REAL NOT NULL,
    description         TEXT,
    status              TEXT DEFAULT 'Submitted' CHECK(status IN ('Submitted','Under Review','Approved','Rejected','Settled','Withdrawn')),
    created_at          DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_updated        DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 16. CLAIM DOCUMENTS
-- ============================================================
CREATE TABLE IF NOT EXISTS claim_documents (
    doc_id              INTEGER PRIMARY KEY AUTOINCREMENT,
    claim_id            INTEGER NOT NULL REFERENCES claims(claim_id),
    doc_type            TEXT NOT NULL,
    file_name           TEXT NOT NULL,
    file_path           TEXT,
    uploaded_by         INTEGER REFERENCES users(user_id),
    uploaded_at         DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_verified         INTEGER DEFAULT 0
);

-- ============================================================
-- 17. CLAIM ASSESSMENTS (Surveyor evaluation)
-- ============================================================
CREATE TABLE IF NOT EXISTS claim_assessments (
    assessment_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    claim_id            INTEGER NOT NULL REFERENCES claims(claim_id),
    assessor_id         INTEGER REFERENCES users(user_id),
    assessment_date     DATE NOT NULL,
    assessed_amount     REAL,
    remarks             TEXT,
    recommendation      TEXT CHECK(recommendation IN ('Approve','Reject','Partial Approval','Escalate')),
    created_at          DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 18. CLAIM SETTLEMENTS (Final payout)
-- ============================================================
CREATE TABLE IF NOT EXISTS claim_settlements (
    settlement_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    claim_id            INTEGER NOT NULL REFERENCES claims(claim_id),
    settled_amount      REAL NOT NULL,
    settled_date        DATE NOT NULL,
    payment_mode        TEXT,
    bank_account        TEXT,
    bank_ifsc           TEXT,
    transaction_ref     TEXT,
    settled_by          INTEGER REFERENCES users(user_id),
    created_at          DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 19. VEHICLES (Auto insurance detail)
-- ============================================================
CREATE TABLE IF NOT EXISTS vehicles (
    vehicle_id          INTEGER PRIMARY KEY AUTOINCREMENT,
    policy_id           INTEGER NOT NULL REFERENCES policies(policy_id),
    make                TEXT NOT NULL,
    model               TEXT NOT NULL,
    manufacture_year    INTEGER,
    registration_no     TEXT UNIQUE,
    chassis_no          TEXT UNIQUE,
    engine_no           TEXT,
    fuel_type           TEXT CHECK(fuel_type IN ('Petrol','Diesel','CNG','Electric','Hybrid')),
    vehicle_type        TEXT CHECK(vehicle_type IN ('2-Wheeler','4-Wheeler','Commercial','Heavy Vehicle')),
    idv_value           REAL,
    created_at          DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 20. PROPERTIES (Property insurance detail)
-- ============================================================
CREATE TABLE IF NOT EXISTS properties (
    property_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    policy_id           INTEGER NOT NULL REFERENCES policies(policy_id),
    property_type       TEXT CHECK(property_type IN ('Residential','Commercial','Industrial','Land')),
    address             TEXT NOT NULL,
    city                TEXT,
    state               TEXT,
    pincode             TEXT,
    construction_type   TEXT,
    built_year          INTEGER,
    sq_ft               REAL,
    market_value        REAL,
    created_at          DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 21. HEALTH MEMBERS (Health insurance family floater)
-- ============================================================
CREATE TABLE IF NOT EXISTS health_members (
    member_id               INTEGER PRIMARY KEY AUTOINCREMENT,
    policy_id               INTEGER NOT NULL REFERENCES policies(policy_id),
    full_name               TEXT NOT NULL,
    relationship            TEXT NOT NULL,
    dob                     DATE,
    gender                  TEXT,
    sum_insured             REAL,
    pre_existing_conditions TEXT,
    created_at              DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 22. LIFE INSURED (Life insurance specific)
-- ============================================================
CREATE TABLE IF NOT EXISTS life_insured (
    insured_id          INTEGER PRIMARY KEY AUTOINCREMENT,
    policy_id           INTEGER NOT NULL REFERENCES policies(policy_id),
    full_name           TEXT NOT NULL,
    dob                 DATE NOT NULL,
    occupation          TEXT,
    annual_income       REAL,
    smoker              INTEGER DEFAULT 0,
    medical_history     TEXT,
    created_at          DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 23. DOCUMENTS (Central document store)
-- ============================================================
CREATE TABLE IF NOT EXISTS documents (
    doc_id              INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_type         TEXT NOT NULL CHECK(entity_type IN ('Policy','Claim','Customer','Payment')),
    entity_id           INTEGER NOT NULL,
    doc_type            TEXT NOT NULL,
    file_name           TEXT NOT NULL,
    file_path           TEXT,
    uploaded_by         INTEGER REFERENCES users(user_id),
    uploaded_at         DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 24. NOTIFICATIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS notifications (
    notification_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id         INTEGER NOT NULL REFERENCES customers(customer_id),
    notification_type   TEXT CHECK(notification_type IN ('SMS','Email','Push','WhatsApp')),
    subject             TEXT,
    message             TEXT NOT NULL,
    sent_at             DATETIME,
    status              TEXT DEFAULT 'Pending' CHECK(status IN ('Pending','Sent','Failed','Delivered')),
    created_at          DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 25. AUDIT LOGS (Full change history)
-- ============================================================
CREATE TABLE IF NOT EXISTS audit_logs (
    log_id              INTEGER PRIMARY KEY AUTOINCREMENT,
    table_name          TEXT NOT NULL,
    record_id           INTEGER NOT NULL,
    action              TEXT NOT NULL CHECK(action IN ('INSERT','UPDATE','DELETE')),
    changed_by          INTEGER REFERENCES users(user_id),
    changed_at          DATETIME DEFAULT CURRENT_TIMESTAMP,
    old_value           TEXT,
    new_value           TEXT
);

-- ============================================================
-- INDEXES for performance
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_policies_customer    ON policies(customer_id);
CREATE INDEX IF NOT EXISTS idx_policies_status      ON policies(status);
CREATE INDEX IF NOT EXISTS idx_claims_policy        ON claims(policy_id);
CREATE INDEX IF NOT EXISTS idx_claims_status        ON claims(status);
CREATE INDEX IF NOT EXISTS idx_premiums_policy      ON premiums(policy_id);
CREATE INDEX IF NOT EXISTS idx_premiums_status      ON premiums(status);
CREATE INDEX IF NOT EXISTS idx_payments_policy      ON payments(policy_id);
CREATE INDEX IF NOT EXISTS idx_customers_email      ON customers(email);
CREATE INDEX IF NOT EXISTS idx_audit_table_record   ON audit_logs(table_name, record_id);

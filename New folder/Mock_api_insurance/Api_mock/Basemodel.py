from pydantic import BaseModel
from typing import Optional
from datetime import date, datetime


# ── USERS ─────────────────────────────────────────────────────
class UserCreate(BaseModel):
    email:         str
    name:           str
    password_hash: str
    role:           Optional[str] = "Customer"

class UserResponse(BaseModel):
    user_id:    int
    email:      str
    role:       str
    is_active:  int
    last_login: Optional[datetime] = None
    created_at: datetime


# ── BRANCHES ──────────────────────────────────────────────────
class BranchCreate(BaseModel):
    branch_name:   str
    region:        str
    address:       Optional[str] = None
    contact_phone: Optional[str] = None
    contact_email: Optional[str] = None

class BranchResponse(BaseModel):
    branch_id:     int
    branch_name:   str
    region:        str
    address:       Optional[str] = None
    contact_phone: Optional[str] = None
    contact_email: Optional[str] = None
    created_at:    datetime


# ── AGENTS ────────────────────────────────────────────────────
class AgentCreate(BaseModel):
    user_id:         Optional[int] = None
    first_name:      str
    last_name:       str
    email:           str
    phone:           Optional[str] = None
    license_no:      Optional[str] = None
    branch_id:       Optional[int] = None
    commission_rate: Optional[float] = 5.0
    joined_date:     Optional[date] = None

class AgentResponse(BaseModel):
    agent_id:        int
    user_id:         Optional[int] = None
    first_name:      str
    last_name:       str
    email:           str
    phone:           Optional[str] = None
    license_no:      Optional[str] = None
    branch_id:       Optional[int] = None
    commission_rate: Optional[float] = None
    status:          str
    joined_date:     Optional[date] = None
    created_at:      datetime

class AgentTokenResponse(BaseModel):
    """Returned by POST /agent — carries the agent data + a token bound to that agent_id."""
    agent:        AgentResponse
    access_token: str
    token_type:   str = "bearer"

class AgentUpdate(BaseModel):
    """PUT /agent/{agent_id} — full replacement of mutable fields."""
    first_name:      str
    last_name:       str
    email:           str
    phone:           Optional[str] = None
    license_no:      Optional[str] = None
    branch_id:       Optional[int] = None
    commission_rate: Optional[float] = None

class AgentPartialUpdate(BaseModel):
    """PATCH /agent/{agent_id} — change only the fields you send."""
    first_name:      Optional[str] = None
    last_name:       Optional[str] = None
    email:           Optional[str] = None
    phone:           Optional[str] = None
    license_no:      Optional[str] = None
    branch_id:       Optional[int] = None
    commission_rate: Optional[float] = None


# ── CUSTOMERS ─────────────────────────────────────────────────
class CustomerCreate(BaseModel):
    user_id:       Optional[int] = None
    first_name:    str
    last_name:     str
    dob:           date
    gender:        Optional[str] = None
    email:         str
    phone:         Optional[str] = None
    address:       Optional[str] = None
    city:          Optional[str] = None
    state:         Optional[str] = None
    pincode:       Optional[str] = None
    pan_number:    Optional[str] = None
    aadhar_number: Optional[str] = None

class CustomerResponse(BaseModel):
    customer_id:   int
    user_id:       Optional[int] = None
    first_name:    str
    last_name:     str
    dob:           date
    gender:        Optional[str] = None
    email:         str
    phone:         Optional[str] = None
    address:       Optional[str] = None
    city:          Optional[str] = None
    state:         Optional[str] = None
    pincode:       Optional[str] = None
    pan_number:    Optional[str] = None
    aadhar_number: Optional[str] = None
    kyc_status:    str
    created_at:    datetime


# ── INSURANCE PRODUCTS ────────────────────────────────────────
class InsuranceProductCreate(BaseModel):
    product_name:      str
    product_code:      str
    insurance_type:    str        # Life / Health / Auto / Property / Travel
    description:       Optional[str] = None
    min_premium:       Optional[float] = None
    max_sum_assured:   Optional[float] = None
    policy_term_years: Optional[int] = None

class InsuranceProductResponse(BaseModel):
    product_id:        int
    product_name:      str
    product_code:      str
    insurance_type:    str
    description:       Optional[str] = None
    min_premium:       Optional[float] = None
    max_sum_assured:   Optional[float] = None
    policy_term_years: Optional[int] = None
    is_active:         int
    created_at:        datetime


# ── POLICIES ──────────────────────────────────────────────────
class PolicyCreate(BaseModel):
    policy_number:     str
    customer_id:       int
    product_id:        int
    agent_id:          Optional[int] = None
    start_date:        date
    end_date:          date
    sum_assured:       float
    annual_premium:    float
    payment_frequency: Optional[str] = "Annual"

class PolicyResponse(BaseModel):
    policy_id:         int
    policy_number:     str
    customer_id:       int
    product_id:        int
    agent_id:          Optional[int] = None
    start_date:        date
    end_date:          date
    sum_assured:       float
    annual_premium:    float
    payment_frequency: str
    status:            str
    issued_at:         datetime
    last_updated:      datetime


# ── POLICY COVERAGE ───────────────────────────────────────────
class PolicyCoverageCreate(BaseModel):
    policy_id:      int
    coverage_type:  str
    coverage_limit: Optional[float] = None
    deductible:     Optional[float] = 0
    exclusions:     Optional[str] = None

class PolicyCoverageResponse(BaseModel):
    coverage_id:    int
    policy_id:      int
    coverage_type:  str
    coverage_limit: Optional[float] = None
    deductible:     Optional[float] = None
    exclusions:     Optional[str] = None
    created_at:     datetime


# ── POLICY RIDERS ─────────────────────────────────────────────
class PolicyRiderCreate(BaseModel):
    policy_id:          int
    rider_type:         str
    coverage_amount:    Optional[float] = None
    additional_premium: Optional[float] = 0

class PolicyRiderResponse(BaseModel):
    rider_id:           int
    policy_id:          int
    rider_type:         str
    coverage_amount:    Optional[float] = None
    additional_premium: Optional[float] = None
    created_at:         datetime


# ── BENEFICIARIES ─────────────────────────────────────────────
class BeneficiaryCreate(BaseModel):
    policy_id:        int
    full_name:        str
    relationship:     str
    dob:              Optional[date] = None
    percentage_share: Optional[float] = 100
    contact_phone:    Optional[str] = None

class BeneficiaryResponse(BaseModel):
    beneficiary_id:   int
    policy_id:        int
    full_name:        str
    relationship:     str
    dob:              Optional[date] = None
    percentage_share: Optional[float] = None
    contact_phone:    Optional[str] = None
    created_at:       datetime


# ── PREMIUMS ──────────────────────────────────────────────────
class PremiumCreate(BaseModel):
    policy_id:        int
    due_date:         date
    amount:           float
    frequency:        str
    grace_period_end: Optional[date] = None

class PremiumResponse(BaseModel):
    premium_id:       int
    policy_id:        int
    due_date:         date
    amount:           float
    frequency:        str
    status:           str
    grace_period_end: Optional[date] = None
    created_at:       datetime


# ── PAYMENTS ──────────────────────────────────────────────────
class PaymentCreate(BaseModel):
    policy_id:       int
    premium_id:      Optional[int] = None
    amount_paid:     float
    payment_date:    datetime
    payment_mode:    str       # Cash / Card / UPI / NEFT / RTGS / Cheque
    transaction_ref: Optional[str] = None

class PaymentResponse(BaseModel):
    payment_id:      int
    policy_id:       int
    premium_id:      Optional[int] = None
    amount_paid:     float
    payment_date:    datetime
    payment_mode:    str
    transaction_ref: Optional[str] = None
    status:          str
    created_at:      datetime


# ── CLAIMS ────────────────────────────────────────────────────
class ClaimCreate(BaseModel):
    claim_number:  str
    policy_id:     int
    customer_id:   int
    incident_date: date
    claim_date:    date
    claim_type:    str
    claim_amount:  float
    description:   Optional[str] = None

class ClaimResponse(BaseModel):
    claim_id:      int
    claim_number:  str
    policy_id:     int
    customer_id:   int
    incident_date: date
    claim_date:    date
    claim_type:    str
    claim_amount:  float
    description:   Optional[str] = None
    status:        str
    created_at:    datetime
    last_updated:  datetime


# ── CLAIM DOCUMENTS ───────────────────────────────────────────
class ClaimDocumentCreate(BaseModel):
    claim_id:    int
    doc_type:    str
    file_name:   str
    file_path:   Optional[str] = None
    uploaded_by: Optional[int] = None

class ClaimDocumentResponse(BaseModel):
    doc_id:      int
    claim_id:    int
    doc_type:    str
    file_name:   str
    file_path:   Optional[str] = None
    uploaded_by: Optional[int] = None
    uploaded_at: datetime
    is_verified: int


# ── CLAIM ASSESSMENTS ─────────────────────────────────────────
class ClaimAssessmentCreate(BaseModel):
    claim_id:        int
    assessor_id:     Optional[int] = None
    assessment_date: date
    assessed_amount: Optional[float] = None
    remarks:         Optional[str] = None
    recommendation:  Optional[str] = None   # Approve / Reject / Partial / Escalate

class ClaimAssessmentResponse(BaseModel):
    assessment_id:   int
    claim_id:        int
    assessor_id:     Optional[int] = None
    assessment_date: date
    assessed_amount: Optional[float] = None
    remarks:         Optional[str] = None
    recommendation:  Optional[str] = None
    created_at:      datetime


# ── CLAIM SETTLEMENTS ─────────────────────────────────────────
class ClaimSettlementCreate(BaseModel):
    claim_id:        int
    settled_amount:  float
    settled_date:    date
    payment_mode:    Optional[str] = None
    bank_account:    Optional[str] = None
    bank_ifsc:       Optional[str] = None
    transaction_ref: Optional[str] = None
    settled_by:      Optional[int] = None

class ClaimSettlementResponse(BaseModel):
    settlement_id:   int
    claim_id:        int
    settled_amount:  float
    settled_date:    date
    payment_mode:    Optional[str] = None
    bank_account:    Optional[str] = None
    bank_ifsc:       Optional[str] = None
    transaction_ref: Optional[str] = None
    settled_by:      Optional[int] = None
    created_at:      datetime


# ── VEHICLES ──────────────────────────────────────────────────
class VehicleCreate(BaseModel):
    policy_id:        int
    make:             str
    model:            str
    manufacture_year: Optional[int] = None
    registration_no:  Optional[str] = None
    chassis_no:       Optional[str] = None
    engine_no:        Optional[str] = None
    fuel_type:        Optional[str] = None   # Petrol / Diesel / CNG / Electric
    vehicle_type:     Optional[str] = None   # 2-Wheeler / 4-Wheeler / Commercial
    idv_value:        Optional[float] = None

class VehicleResponse(BaseModel):
    vehicle_id:       int
    policy_id:        int
    make:             str
    model:            str
    manufacture_year: Optional[int] = None
    registration_no:  Optional[str] = None
    chassis_no:       Optional[str] = None
    engine_no:        Optional[str] = None
    fuel_type:        Optional[str] = None
    vehicle_type:     Optional[str] = None
    idv_value:        Optional[float] = None
    created_at:       datetime


# ── PROPERTIES ────────────────────────────────────────────────
class PropertyCreate(BaseModel):
    policy_id:         int
    property_type:     Optional[str] = None   # Residential / Commercial
    address:           str
    city:              Optional[str] = None
    state:             Optional[str] = None
    pincode:           Optional[str] = None
    construction_type: Optional[str] = None
    built_year:        Optional[int] = None
    sq_ft:             Optional[float] = None
    market_value:      Optional[float] = None

class PropertyResponse(BaseModel):
    property_id:       int
    policy_id:         int
    property_type:     Optional[str] = None
    address:           str
    city:              Optional[str] = None
    state:             Optional[str] = None
    pincode:           Optional[str] = None
    construction_type: Optional[str] = None
    built_year:        Optional[int] = None
    sq_ft:             Optional[float] = None
    market_value:      Optional[float] = None
    created_at:        datetime


# ── HEALTH MEMBERS ────────────────────────────────────────────
class HealthMemberCreate(BaseModel):
    policy_id:               int
    full_name:               str
    relationship:            str
    dob:                     Optional[date] = None
    gender:                  Optional[str] = None
    sum_insured:             Optional[float] = None
    pre_existing_conditions: Optional[str] = None

class HealthMemberResponse(BaseModel):
    member_id:               int
    policy_id:               int
    full_name:               str
    relationship:            str
    dob:                     Optional[date] = None
    gender:                  Optional[str] = None
    sum_insured:             Optional[float] = None
    pre_existing_conditions: Optional[str] = None
    created_at:              datetime


# ── LIFE INSURED ──────────────────────────────────────────────
class LifeInsuredCreate(BaseModel):
    policy_id:       int
    full_name:       str
    dob:             date
    occupation:      Optional[str] = None
    annual_income:   Optional[float] = None
    smoker:          Optional[int] = 0
    medical_history: Optional[str] = None

class LifeInsuredResponse(BaseModel):
    insured_id:      int
    policy_id:       int
    full_name:       str
    dob:             date
    occupation:      Optional[str] = None
    annual_income:   Optional[float] = None
    smoker:          Optional[int] = None
    medical_history: Optional[str] = None
    created_at:      datetime


# ── NOTIFICATIONS ─────────────────────────────────────────────
class NotificationCreate(BaseModel):
    customer_id:       int
    notification_type: str        # SMS / Email / Push / WhatsApp
    subject:           Optional[str] = None
    message:           str

class NotificationResponse(BaseModel):
    notification_id:   int
    customer_id:       int
    notification_type: str
    subject:           Optional[str] = None
    message:           str
    sent_at:           Optional[datetime] = None
    status:            str
    created_at:        datetime

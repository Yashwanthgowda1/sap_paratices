import os
from openpyxl import Workbook
from openpyxl.styles import (
    PatternFill, Font, Alignment, Border, Side
)
from openpyxl.utils import get_column_letter

OUTPUT_FILE = os.path.join(os.path.dirname(__file__), "PolicyBazaar_FunctionalTestCases.xlsx")

HEADERS = [
    "Test Case ID", "Module", "Sub-Module", "Test Scenario",
    "Test Case Title", "Pre-Conditions", "Test Steps",
    "Test Data (Input)", "Expected Result (Output)",
    "Actual Result", "Status", "Priority", "Severity",
    "Test Type", "Remarks"
]

COL_WIDTHS = [18, 22, 22, 40, 45, 40, 80, 50, 60, 30, 14, 12, 12, 22, 25]

HEADER_FILL   = PatternFill("solid", fgColor="1F4E79")
ALT_FILL      = PatternFill("solid", fgColor="D9E1F2")
WHITE_FILL    = PatternFill("solid", fgColor="FFFFFF")
SUMMARY_FILL  = PatternFill("solid", fgColor="2E75B6")
HEADER_FONT   = Font(bold=True, color="FFFFFF", size=10, name="Calibri")
BODY_FONT     = Font(size=9, name="Calibri")
BOLD_FONT     = Font(bold=True, size=9, name="Calibri")
WRAP          = Alignment(wrap_text=True, vertical="top")
CENTER        = Alignment(horizontal="center", vertical="top", wrap_text=True)
THIN_BORDER   = Border(
    left=Side(style="thin"), right=Side(style="thin"),
    top=Side(style="thin"), bottom=Side(style="thin")
)

# ─────────────────────────────────────────────────────────────────────────────
# TEST DATA — each tuple:
# (ID, Module, Sub-Module, Scenario, Title, Preconditions, Steps, TestData,
#  ExpectedResult, Priority, Severity, TestType)
# ─────────────────────────────────────────────────────────────────────────────

TEST_CASES = [
    # ── MODULE 1: Homepage & Navigation ──────────────────────────────────────
    ("PB_HOME_001","Homepage & Navigation","Homepage",
     "Verify homepage loads correctly with all major sections",
     "Verify PolicyBazaar homepage loads with all sections visible",
     "Internet connection available; Chrome browser latest version",
     "1. Open browser\n2. Navigate to https://www.policybazaar.com/\n3. Wait for page to fully load\n4. Observe all sections: header, hero banner, product cards, footer",
     "URL: https://www.policybazaar.com/",
     "Homepage loads within 5 seconds; Header with logo visible; Product navigation menu displayed; Hero banner visible; Footer with links visible; No broken images",
     "High","Critical","Positive"),

    ("PB_HOME_002","Homepage & Navigation","Navigation Menu",
     "Verify all top navigation menu items navigate to correct pages",
     "Verify all top-level nav links (Health, Term, Car, Bike, Travel, Investment) are clickable and navigate correctly",
     "Browser on homepage; Internet connection available",
     "1. On homepage, click 'Health Insurance' nav link\n2. Verify correct landing page opens\n3. Return to homepage\n4. Repeat for: Term Insurance, Car Insurance, Bike Insurance, Travel Insurance, Investment\n5. Check URL and page title for each",
     "N/A",
     "Each menu item navigates to its respective product page; URL changes correctly; Page title matches product; No 404 errors",
     "High","Critical","Positive"),

    ("PB_HOME_003","Homepage & Navigation","Search",
     "Verify search functionality returns relevant results",
     "Verify search bar returns relevant insurance product results",
     "User is on homepage",
     "1. Locate search bar/icon on homepage\n2. Click on search\n3. Type 'health insurance'\n4. Press Enter or click search button\n5. Observe search results",
     "Search keyword: 'health insurance'",
     "Search results page loads; Results are relevant to 'health insurance'; At least 5 results displayed; Each result is clickable",
     "Medium","Major","Positive"),

    ("PB_HOME_004","Homepage & Navigation","Footer",
     "Verify footer links navigate to correct pages",
     "Verify all footer links are functional and not broken",
     "User is on homepage",
     "1. Scroll to page footer\n2. Click each link: About Us, Contact, Privacy Policy, Terms & Conditions, Careers\n3. Verify each opens correct page\n4. Check no 404 errors",
     "N/A",
     "All footer links are clickable; Each link opens the correct page; No broken links; No 404 error pages",
     "Low","Minor","Positive"),

    ("PB_HOME_005","Homepage & Navigation","Responsive UI",
     "Verify homepage is responsive on mobile viewport",
     "Verify homepage displays correctly on 375x667 mobile viewport",
     "Browser DevTools available",
     "1. Open homepage\n2. Open DevTools (F12)\n3. Toggle device toolbar\n4. Select iPhone SE (375x667)\n5. Reload page\n6. Verify layout, menu hamburger, and content visibility",
     "Viewport: 375x667 (iPhone SE)",
     "Hamburger menu appears; Logo is visible; Product cards stack vertically; Text is readable without zoom; No horizontal scroll bar",
     "Medium","Major","UI Behavior"),

    ("PB_HOME_006","Homepage & Navigation","Error Handling",
     "Verify 404 page displays for invalid URL",
     "Verify application shows meaningful 404 error page for non-existent URL",
     "Browser open",
     "1. Navigate to https://www.policybazaar.com/invalid-page-xyz\n2. Observe the response\n3. Check for navigation options back to homepage",
     "URL: https://www.policybazaar.com/invalid-page-xyz",
     "404 error page is displayed; Error message is user-friendly; Link/button to return to homepage is present",
     "Medium","Minor","Negative"),

    # ── MODULE 2: Authentication ──────────────────────────────────────────────
    ("PB_AUTH_001","Authentication","Login - OTP",
     "Successful login with valid mobile number and correct OTP",
     "Login with valid 10-digit mobile number and valid OTP",
     "Registered mobile number available; User not logged in",
     "1. Click 'Login' button on homepage\n2. Enter valid 10-digit mobile number (e.g. 9876543210)\n3. Click 'Get OTP'\n4. Enter the 6-digit OTP received on mobile\n5. Click 'Verify OTP'",
     "Mobile: 9876543210 (registered); OTP: Valid 6-digit code",
     "OTP is sent to mobile; Login is successful; User is redirected to dashboard/homepage; User name visible in header",
     "High","Critical","Positive"),

    ("PB_AUTH_002","Authentication","Login - Validation",
     "Login blocked for 9-digit mobile number",
     "Verify error shown when mobile number has only 9 digits",
     "User is on login page",
     "1. Click 'Login' on homepage\n2. Enter 9-digit number: 987654321\n3. Click 'Get OTP'\n4. Observe validation message",
     "Mobile: 987654321 (9 digits)",
     "Inline error message displayed: 'Please enter a valid 10-digit mobile number'; OTP is NOT sent; User cannot proceed",
     "High","Critical","Negative"),

    ("PB_AUTH_003","Authentication","Login - Validation",
     "Login blocked for mobile number starting with invalid prefix (5)",
     "Verify error shown when mobile number starts with 5",
     "User is on login page",
     "1. Click 'Login'\n2. Enter number starting with 5: 5876543210\n3. Click 'Get OTP'\n4. Observe response",
     "Mobile: 5876543210",
     "Error message shown: 'Please enter a valid mobile number'; OTP not sent; Form not submitted",
     "High","Critical","Negative"),

    ("PB_AUTH_004","Authentication","Login - OTP",
     "Login fails with incorrect OTP",
     "Verify error shown when wrong OTP is entered",
     "Valid mobile number; OTP request already sent",
     "1. Enter valid mobile number\n2. Click 'Get OTP'\n3. Enter incorrect OTP: 000000\n4. Click 'Verify OTP'\n5. Observe error message",
     "Mobile: 9876543210; OTP: 000000 (incorrect)",
     "Error message displayed: 'Invalid OTP. Please try again'; Login not successful; OTP field cleared or highlighted",
     "High","Critical","Negative"),

    ("PB_AUTH_005","Authentication","Login - OTP",
     "Login fails with expired OTP (after 5 min timer)",
     "Verify OTP expires after 5 minutes and login is rejected",
     "Valid mobile number; OTP received but not used for 5+ minutes",
     "1. Enter valid mobile number\n2. Click 'Get OTP'\n3. Wait for 5 minutes (OTP expiry)\n4. Enter OTP\n5. Click 'Verify OTP'\n6. Observe response",
     "Mobile: 9876543210; OTP: (expired code)",
     "Error message: 'OTP has expired. Please request a new OTP'; Login not successful; Resend OTP option visible",
     "High","Critical","Boundary"),

    ("PB_AUTH_006","Authentication","Login - OTP",
     "OTP resend functionality works correctly",
     "Verify 'Resend OTP' button resends a new OTP",
     "User on OTP entry screen; First OTP already sent",
     "1. Enter valid mobile number\n2. Click 'Get OTP'\n3. Wait for resend timer to complete\n4. Click 'Resend OTP'\n5. Check if new OTP is received on mobile",
     "Mobile: 9876543210",
     "New OTP sent to mobile; Previous OTP becomes invalid; Resend timer resets; Success notification shown",
     "High","Major","Workflow"),

    ("PB_AUTH_007","Authentication","Login - OTP",
     "OTP resend timer counts down correctly",
     "Verify resend OTP button is disabled during countdown and enabled after",
     "User on OTP entry screen",
     "1. Enter valid mobile number\n2. Click 'Get OTP'\n3. Observe resend button state\n4. Note countdown timer (e.g. 30 seconds)\n5. Wait for timer to reach 0\n6. Observe resend button state",
     "N/A",
     "Resend OTP button is DISABLED during countdown; Timer counts down from 30 (or configured value) to 0; After countdown, button becomes ENABLED; User can click Resend",
     "Medium","Minor","UI Behavior"),

    ("PB_AUTH_008","Authentication","Registration",
     "Successful new user registration with all valid details",
     "Register a new user with valid name, mobile, email, and DOB",
     "Unregistered mobile number; Valid email available",
     "1. Click 'Login' > 'Sign Up'\n2. Enter Name: Rahul Sharma\n3. Enter Mobile: 8765432109 (unregistered)\n4. Enter Email: rahul.test@gmail.com\n5. Enter DOB: 15-06-1995\n6. Click 'Create Account'\n7. Enter OTP received\n8. Verify account created",
     "Name: Rahul Sharma; Mobile: 8765432109; Email: rahul.test@gmail.com; DOB: 15-06-1995",
     "Account created successfully; User redirected to dashboard; Welcome message displayed; Registration confirmation email sent",
     "High","Critical","Positive"),

    ("PB_AUTH_009","Authentication","Registration",
     "Registration blocked for already registered mobile number",
     "Verify error shown when registering with existing mobile number",
     "Mobile number already registered in system",
     "1. Click 'Sign Up'\n2. Enter already registered mobile: 9876543210\n3. Fill other fields with valid data\n4. Click 'Create Account'\n5. Observe response",
     "Mobile: 9876543210 (already registered)",
     "Error message: 'Mobile number already registered. Please login instead'; Registration not completed; Login link provided",
     "High","Critical","Negative"),

    ("PB_AUTH_010","Authentication","Registration",
     "Registration blocked for invalid email format",
     "Verify inline validation for email field rejects invalid formats",
     "User on registration page",
     "1. Open registration form\n2. Enter Name, Mobile (valid)\n3. Enter invalid email: rahul@invalid\n4. Click on next field\n5. Observe validation",
     "Email: rahul@invalid",
     "Inline error under email field: 'Please enter a valid email address'; Form not submitted until corrected",
     "Medium","Major","Negative"),

    ("PB_AUTH_011","Authentication","Registration",
     "Registration blocked for underage user (DOB < 18 years)",
     "Verify registration is rejected for DOB resulting in age below 18",
     "User on registration page",
     "1. Open registration form\n2. Enter valid name and mobile\n3. Enter DOB: 01-01-2015 (age ~11)\n4. Click 'Create Account'\n5. Observe response",
     "DOB: 01-01-2015 (under 18)",
     "Error message: 'You must be at least 18 years old to register'; Form not submitted; DOB field highlighted",
     "High","Critical","Boundary"),

    ("PB_AUTH_012","Authentication","Logout / Session",
     "Logout terminates user session correctly",
     "Verify user is fully logged out and session is terminated on logout",
     "User is logged in",
     "1. Login with valid credentials\n2. Navigate to dashboard\n3. Click user avatar/name in header\n4. Click 'Logout'\n5. Attempt to navigate to 'My Account'\n6. Observe result",
     "Valid logged-in session",
     "User is logged out; Redirected to homepage; Login button visible in header; Navigating to My Account redirects to login page; Back button does not restore logged-in session",
     "High","Critical","Session"),

    # ── MODULE 3: Health Insurance ────────────────────────────────────────────
    ("PB_HLTH_001","Health Insurance","Get Quote",
     "Get health insurance quote for single adult aged 25",
     "Verify quote is generated for a single adult member",
     "User on https://www.policybazaar.com/health-insurance/",
     "1. Navigate to Health Insurance section\n2. Select 'Myself' as member type\n3. Enter age: 25\n4. Enter pincode: 110001\n5. Click 'View Plans'\n6. Observe results page",
     "Member: Myself; Age: 25; Pincode: 110001",
     "Plans list loads; Multiple insurer plans shown; Premium displayed per annum; Plans can be filtered and sorted",
     "High","Critical","Positive"),

    ("PB_HLTH_002","Health Insurance","Get Quote",
     "Get health insurance quote for family floater (2 adults + 2 children)",
     "Verify family floater quote with 2 adults and 2 children",
     "User on Health Insurance section",
     "1. Select member type: Family\n2. Add: Self (35), Spouse (33), Son (8), Daughter (5)\n3. Enter pincode: 400001\n4. Click 'View Plans'\n5. Observe results",
     "Self: 35; Spouse: 33; Child1: 8; Child2: 5; Pincode: 400001",
     "Family floater plans displayed; Sum insured options available; Premium reflects all 4 members; Correct member count shown",
     "High","Critical","Positive"),

    ("PB_HLTH_003","Health Insurance","Mandatory Fields",
     "Submit health quote form without entering member age",
     "Verify mandatory age field validation on health insurance form",
     "User on Health Insurance get-quote form",
     "1. Navigate to Health Insurance\n2. Select 'Myself'\n3. Leave Age field blank\n4. Enter pincode: 110001\n5. Click 'View Plans'",
     "Age: (empty); Pincode: 110001",
     "Error message displayed near Age field: 'Please enter your age'; Form not submitted; Page does not navigate to results",
     "High","Critical","Mandatory Field"),

    ("PB_HLTH_004","Health Insurance","Field Validation",
     "Enter invalid pincode (5 digits) in health insurance form",
     "Verify pincode field rejects 5-digit input",
     "User on Health Insurance form",
     "1. Enter Age: 30\n2. Enter pincode: 11000 (5 digits)\n3. Click outside the field\n4. Observe validation",
     "Pincode: 11000 (5 digits)",
     "Error: 'Please enter a valid 6-digit pincode'; Plan results not loaded; Field highlighted in red",
     "High","Critical","Negative"),

    ("PB_HLTH_005","Health Insurance","Boundary",
     "Enter age 0 for adult member in health quote",
     "Verify system rejects age 0 for adult member",
     "User on Health Insurance form",
     "1. Select 'Myself'\n2. Enter Age: 0\n3. Enter Pincode: 110001\n4. Click 'View Plans'",
     "Age: 0",
     "Error message: 'Please enter a valid age'; Form not submitted; Age 0 not accepted for adult",
     "High","Critical","Boundary"),

    ("PB_HLTH_006","Health Insurance","Boundary",
     "Enter age 99 for senior member and verify plan availability",
     "Verify system handles maximum boundary age of 99",
     "User on Health Insurance form",
     "1. Select 'Myself'\n2. Enter Age: 99\n3. Enter Pincode: 110001\n4. Click 'View Plans'\n5. Observe results",
     "Age: 99",
     "Either: a) Limited plans shown for senior age; b) Message shown 'Limited plans available for this age group'; No system error or crash",
     "Medium","Major","Boundary"),

    ("PB_HLTH_007","Health Insurance","Business Rule",
     "Pre-existing disease selection filters plans correctly",
     "Verify plans are filtered/flagged based on pre-existing disease declaration",
     "User viewing health insurance plan results",
     "1. Get quote for 35-year-old\n2. On results page, find 'Pre-existing Disease' filter\n3. Select 'Diabetes'\n4. Observe plan changes\n5. Compare plan count before and after",
     "Member age: 35; Pre-existing: Diabetes",
     "Plans with waiting period for Diabetes are marked/highlighted; Some plans may be removed; Waiting period info visible on plan cards; Results refresh after selection",
     "High","Critical","Business Rule"),

    ("PB_HLTH_008","Health Insurance","Business Rule",
     "Premium updates when sum insured selection changes",
     "Verify premium recalculates correctly when sum insured amount is changed",
     "User on health insurance results page",
     "1. View plans for 30-year-old\n2. Note premium for 3 Lakh sum insured\n3. Change sum insured to 10 Lakh\n4. Note new premium\n5. Change to 25 Lakh and note premium",
     "Sum Insured options: 3L, 5L, 10L, 25L",
     "Premium increases proportionally with higher sum insured; Plans list re-renders; New premium values are correct; 3L < 5L < 10L < 25L in premium",
     "High","Critical","Business Rule"),

    ("PB_HLTH_009","Health Insurance","Boundary",
     "Add maximum 6 members to family floater plan",
     "Verify system allows maximum 6 members and blocks the 7th",
     "User on Health Insurance member selection screen",
     "1. Select family plan\n2. Add: Self + Spouse + 4 children = 6 members\n3. Try to add a 7th member\n4. Observe behavior",
     "Members: Self + Spouse + Child1 + Child2 + Child3 + Child4 = 6",
     "6 members added successfully; 7th member add button disabled or error shown: 'Maximum 6 members allowed'; Form works with 6 members",
     "Medium","Major","Boundary"),

    ("PB_HLTH_010","Health Insurance","UI Behavior",
     "Verify plan list can be sorted by premium low to high",
     "Verify sort by premium (low to high) reorders results correctly",
     "User on health insurance results page with plans visible",
     "1. View plan results\n2. Click sort dropdown\n3. Select 'Premium: Low to High'\n4. Observe plan order\n5. Note first and last plan premium values",
     "Sort: Premium Low to High",
     "Plans reordered with lowest premium first; Premium values in ascending order; Plan count remains the same; Sorting is instant or within 2 seconds",
     "Medium","Minor","UI Behavior"),

    ("PB_HLTH_011","Health Insurance","Business Rule",
     "Compare feature restricts to maximum 3 plans",
     "Verify only 3 plans can be added to compare at once",
     "User on health insurance results page",
     "1. Select Plan 1 for comparison (checkbox/button)\n2. Select Plan 2\n3. Select Plan 3\n4. Attempt to select Plan 4\n5. Observe behavior",
     "N/A",
     "Plans 1-3 selected successfully; Plan 4 selection shows message: 'You can compare maximum 3 plans at a time'; Compare button active with 3 plans",
     "High","Major","Business Rule"),

    ("PB_HLTH_012","Health Insurance","Navigation",
     "Navigate back from results to edit the quote form",
     "Verify user can go back from results page and edit the quote inputs",
     "User is on health insurance results page",
     "1. View results page for health insurance\n2. Click 'Edit' or back arrow on filter/form section\n3. Observe if form fields are pre-populated\n4. Change age from 25 to 35\n5. Click 'View Plans' again",
     "Original: Age 25; Modified: Age 35",
     "Form opens with pre-filled values; Age can be changed to 35; New results load after resubmit; Previous results replaced with updated ones",
     "Medium","Major","Navigation"),

    # ── MODULE 4: Term Insurance ──────────────────────────────────────────────
    ("PB_TERM_001","Term Insurance","Premium Calculator",
     "Calculate term insurance premium for 30-year-old male, 1 Crore cover",
     "Verify premium calculation for standard male profile with 1Cr coverage",
     "User on https://www.policybazaar.com/term-insurance/",
     "1. Navigate to Term Insurance\n2. Enter Name: Amit Kumar\n3. Select Gender: Male\n4. Enter DOB (age 30): 01-01-1994\n5. Select Annual Income: 10 Lakh\n6. Enter Mobile: 9876543210\n7. Click 'View Plans'\n8. Set coverage to 1 Crore\n9. Note premium",
     "Gender: Male; Age: 30; Income: 10L pa; Coverage: 1 Crore; Term: 30 years",
     "Plans displayed with annual premium; Coverage of 1 Crore shown; Multiple insurer options available; Plan details (CSR, features) visible",
     "High","Critical","Positive"),

    ("PB_TERM_002","Term Insurance","Boundary",
     "System validates annual income below minimum threshold (< 2.4 Lakh)",
     "Verify term insurance form blocks annual income below Rs 2.4 Lakh",
     "User on Term Insurance get-quote form",
     "1. Navigate to Term Insurance\n2. Fill name, gender, DOB\n3. Enter Annual Income: 1 Lakh (below minimum)\n4. Click 'View Plans'\n5. Observe validation",
     "Annual Income: 1,00,000 (Rs 1 Lakh)",
     "Error or warning: 'Minimum eligible income is Rs 2.4 Lakh per annum'; Form not submitted or plans not shown for this income; User guided to correct input",
     "High","Critical","Boundary"),

    ("PB_TERM_003","Term Insurance","Boundary",
     "Verify coverage slider minimum is 25 Lakh",
     "Verify coverage amount cannot be set below 25 Lakh on results page",
     "User on Term Insurance results page with coverage slider visible",
     "1. View term insurance results\n2. Find coverage slider\n3. Drag slider to leftmost (minimum) position\n4. Note displayed coverage amount\n5. Check if below 25L is possible",
     "Coverage slider: minimum position",
     "Minimum coverage shown is 25 Lakh; Cannot drag below 25 Lakh; Premiums recalculate for 25 Lakh coverage",
     "High","Major","Boundary"),

    ("PB_TERM_004","Term Insurance","Boundary",
     "Verify coverage slider maximum is 5 Crore",
     "Verify coverage amount cannot exceed 5 Crore on results page",
     "User on Term Insurance results page",
     "1. View term insurance results\n2. Drag coverage slider to rightmost (maximum) position\n3. Note displayed coverage amount\n4. Check if above 5Cr is possible",
     "Coverage slider: maximum position",
     "Maximum coverage shown is 5 Crore; Cannot drag above 5 Crore; Premiums recalculate for 5 Crore coverage",
     "High","Major","Boundary"),

    ("PB_TERM_005","Term Insurance","Boundary",
     "Select minimum policy term (10 years) and verify premium",
     "Verify term insurance results for minimum policy term of 10 years",
     "User on Term Insurance results page",
     "1. On results page, find policy term dropdown/slider\n2. Set term to 10 years (minimum)\n3. Observe premium change\n4. Note plans available",
     "Policy Term: 10 years",
     "Premium values shown for 10-year term; Term displayed correctly on plan cards; Some plans may not be available for 10-year term (filtered out)",
     "Medium","Major","Boundary"),

    ("PB_TERM_006","Term Insurance","Boundary",
     "Select maximum policy term (40 years) and verify premium",
     "Verify term insurance results for maximum policy term of 40 years",
     "User on Term Insurance results page",
     "1. Set policy term to 40 years\n2. Observe premium change\n3. Compare with 10-year term premium",
     "Policy Term: 40 years",
     "Premium shown for 40-year term; 40-year premium higher than 10-year; Term correctly displayed; No system error",
     "Medium","Major","Boundary"),

    ("PB_TERM_007","Term Insurance","Mandatory Fields",
     "Submit term insurance form without selecting gender",
     "Verify mandatory gender field validation on term insurance form",
     "User on Term Insurance get-quote form",
     "1. Navigate to Term Insurance\n2. Enter Name and DOB\n3. Skip gender selection\n4. Enter income and mobile\n5. Click 'View Plans'\n6. Observe",
     "Gender: (not selected)",
     "Error shown: 'Please select your gender'; Form not submitted; Gender field highlighted; User must select before proceeding",
     "High","Critical","Mandatory Field"),

    ("PB_TERM_008","Term Insurance","Business Rule",
     "Smoker premium is higher than non-smoker premium for same profile",
     "Verify smoker surcharge applies — smoker premium > non-smoker premium",
     "User on Term Insurance results page with plans loaded",
     "1. Get term insurance quote for Male, 30 years\n2. Note premium for non-smoker (default)\n3. Change smoking status to 'Yes, I smoke'\n4. Note new premium\n5. Compare",
     "Smoker: Yes vs No; All other params same",
     "Smoker premium is HIGHER than non-smoker premium for identical profile; Difference is clearly shown; Plan availability may differ",
     "High","Critical","Business Rule"),

    ("PB_TERM_009","Term Insurance","Business Rule",
     "Female applicant premium is lower than male for identical profile",
     "Verify gender-based actuarial pricing — female premium lower than male",
     "User on Term Insurance get-quote form",
     "1. Get quote for Male, age 30, 1Cr, 30yr term\n2. Note total premium\n3. Repeat same form with Female\n4. Compare premiums",
     "Male vs Female; Age: 30; Coverage: 1Cr; Term: 30 years",
     "Female premium is lower than male premium for identical age/coverage/term; Both produce valid plan results",
     "Medium","Major","Business Rule"),

    ("PB_TERM_010","Term Insurance","Data Persistence",
     "Plan results display Claim Settlement Ratio (CSR) for each insurer",
     "Verify CSR is visible on plan listing for informed comparison",
     "User on Term Insurance results page",
     "1. View term insurance plan results\n2. Check each plan card for CSR information\n3. Verify CSR is shown as percentage\n4. Verify data is present for all listed plans",
     "N/A",
     "Each plan card shows CSR percentage (e.g. 99.5%); CSR data is visible without hovering; Data persists when user scrolls or sorts",
     "Medium","Minor","Data Persistence"),

    # ── MODULE 5: Car Insurance ───────────────────────────────────────────────
    ("PB_CAR_001","Car Insurance","Get Quote",
     "Get car insurance quote using valid registration number",
     "Verify quote is fetched correctly for a valid car registration number",
     "User on https://www.policybazaar.com/motor-insurance/car-insurance/",
     "1. Navigate to Car Insurance\n2. Enter registration number: DL01AB1234\n3. Click 'View Plans'\n4. Verify vehicle details fetched\n5. Observe plan results",
     "Registration: DL01AB1234",
     "Vehicle details (Make, Model, Year) auto-populated from registration number; Plan results displayed; Both Comprehensive and Third-Party plans shown",
     "High","Critical","Positive"),

    ("PB_CAR_002","Car Insurance","Field Validation",
     "Enter invalid car registration number format",
     "Verify system rejects malformed registration number",
     "User on Car Insurance quote form",
     "1. Enter registration: DL01AB (incomplete)\n2. Click 'View Plans'\n3. Observe validation",
     "Registration: DL01AB (invalid format)",
     "Error message: 'Please enter a valid registration number (e.g. DL01AB1234)'; Form not submitted; Field highlighted",
     "High","Critical","Negative"),

    ("PB_CAR_003","Car Insurance","Workflow",
     "Select car make, model, and variant via cascading dropdowns",
     "Verify cascading dropdown behavior for car selection (Make > Model > Variant)",
     "User on Car Insurance — new car or manual selection flow",
     "1. Select option: 'I don't know my car number'\n2. Select Make: Maruti Suzuki\n3. Observe Model dropdown populates\n4. Select Model: Swift\n5. Observe Variant dropdown\n6. Select Variant: VXI\n7. Select registration year: 2020\n8. Click 'View Plans'",
     "Make: Maruti Suzuki; Model: Swift; Variant: VXI; Year: 2020",
     "Model dropdown activates only after Make selected; Variant activates only after Model selected; Plans load after all selections made",
     "High","Critical","Workflow"),

    ("PB_CAR_004","Car Insurance","Positive",
     "Get quote for brand new car (no registration number)",
     "Verify new car quote flow works without registration number",
     "User on Car Insurance section",
     "1. Select 'New Car' option\n2. Select Make, Model, Variant\n3. Select purchase date / RTO city\n4. Click 'View Plans'",
     "Car: New (no registration); Make: Hyundai; Model: i20; Variant: Sportz",
     "New car plans displayed; No registration number required; Bundled 5-year TP + 1-year OD shown as per regulation; Premium displayed",
     "High","Critical","Positive"),

    ("PB_CAR_005","Car Insurance","Business Rule",
     "IDV slider adjustment changes premium in real time",
     "Verify premium recalculates dynamically when IDV slider is adjusted",
     "User on Car Insurance results page with IDV slider visible",
     "1. View car insurance results\n2. Note current IDV and premium\n3. Move IDV slider to minimum value\n4. Note new premium\n5. Move IDV slider to maximum\n6. Note premium again",
     "IDV: Min, Mid, Max values",
     "Premium changes as IDV changes; Higher IDV = Higher premium; Lower IDV = Lower premium; Changes reflect within 1-2 seconds",
     "High","Critical","Business Rule"),

    ("PB_CAR_006","Car Insurance","Business Rule",
     "Car older than 15 years not eligible for comprehensive insurance",
     "Verify comprehensive insurance is blocked for cars older than 15 years",
     "User on Car Insurance quote form",
     "1. Enter registration for car registered in 2005 (>15 years old)\n2. View plans\n3. Check availability of Comprehensive plan",
     "Car year: 2005 (age > 15 years)",
     "Comprehensive policy option is absent or greyed out; Only Third-Party plan available; Message shown: 'Comprehensive not available for vehicles older than 15 years'",
     "High","Critical","Business Rule"),

    ("PB_CAR_007","Car Insurance","Business Rule",
     "Add-on covers are optional and affect premium",
     "Verify adding optional add-ons increases premium correctly",
     "User on Car Insurance results page",
     "1. Select a Comprehensive plan\n2. Note base premium\n3. Add 'Zero Depreciation' add-on\n4. Note new premium\n5. Add 'Roadside Assistance'\n6. Note premium again",
     "Add-ons: Zero Depreciation + Roadside Assistance",
     "Each add-on increases premium; Add-ons are optional (can be deselected); Final premium = base + selected add-ons; Summary shows itemized add-on costs",
     "Medium","Major","Business Rule"),

    ("PB_CAR_008","Car Insurance","Negative",
     "Proceed to purchase without selecting any plan",
     "Verify user cannot proceed to buy without selecting a plan",
     "User on Car Insurance results page",
     "1. View car insurance results\n2. Do NOT select/click any plan\n3. Look for any 'Continue' or 'Buy Now' button at page level\n4. If present, click it\n5. Observe result",
     "No plan selected",
     "Either: a) No global buy button exists (must click per plan); b) If global button exists, error: 'Please select a plan to continue'; User cannot reach payment without selecting a plan",
     "Medium","Major","Negative"),

    # ── MODULE 6: Bike Insurance ──────────────────────────────────────────────
    ("PB_BIKE_001","Bike Insurance","Get Quote",
     "Get bike insurance quote with valid registration number",
     "Verify quote retrieval for a valid two-wheeler registration number",
     "User on https://www.policybazaar.com/motor-insurance/two-wheeler/",
     "1. Navigate to Bike/Two-Wheeler Insurance\n2. Enter registration: KA05MH1234\n3. Click 'View Plans'\n4. Verify bike details fetched\n5. View plan results",
     "Registration: KA05MH1234",
     "Bike details (Make, Model, Year) auto-fetched; Plans listed; Both Comprehensive and TP-only plans shown; Premiums displayed",
     "High","Critical","Positive"),

    ("PB_BIKE_002","Bike Insurance","Get Quote",
     "Get quote for new bike without registration number",
     "Verify new bike quote flow works correctly",
     "User on Bike Insurance section",
     "1. Select 'New Bike' option\n2. Select Make: Hero; Model: Splendor+\n3. Select RTO city\n4. Click 'View Plans'",
     "Bike: New; Make: Hero; Model: Splendor+",
     "New bike plans loaded; 5-year TP mandatory plan shown; 1-year OD optional shown; Premium displayed clearly",
     "High","Critical","Positive"),

    ("PB_BIKE_003","Bike Insurance","Business Rule",
     "Third-party-only plan is available for bike insurance",
     "Verify TP-only plan exists in bike insurance results",
     "User on Bike Insurance results page",
     "1. View plan results for a bike\n2. Look for filter or tab for 'Third Party' plan type\n3. Select Third Party filter\n4. Observe plans",
     "Plan type: Third Party only",
     "TP-only plans displayed with lower premiums; OD cover not included in TP plan; Legally compliant TP plan available from multiple insurers",
     "High","Critical","Business Rule"),

    ("PB_BIKE_004","Bike Insurance","Negative",
     "Enter car registration number in bike insurance form",
     "Verify system detects vehicle type mismatch",
     "User on Bike Insurance form",
     "1. Navigate to Bike Insurance\n2. Enter a car registration number: DL01AB1234\n3. Click 'View Plans'\n4. Observe response",
     "Registration: DL01AB1234 (car number in bike form)",
     "System detects vehicle type as Car (4-wheeler); Error or redirect shown: 'This registration number belongs to a car. Please use Car Insurance'; Bike plans not shown for car registration",
     "Medium","Major","Negative"),

    ("PB_BIKE_005","Bike Insurance","Boundary",
     "Premium for bike older than 10 years is calculated correctly",
     "Verify premium calculation for a 10+ year old bike",
     "User on Bike Insurance form",
     "1. Enter registration for bike from 2010 (14 years old)\n2. View plans\n3. Note premium and plan type availability",
     "Bike year: 2010 (>10 years)",
     "Plans still available; IDV is lower due to depreciation; Comprehensive may be available with market-value IDV; No system error; Premium is lower than for newer bike",
     "Medium","Major","Boundary"),

    # ── MODULE 7: Travel Insurance ────────────────────────────────────────────
    ("PB_TRVL_001","Travel Insurance","Get Quote",
     "Get travel insurance quote for international single trip",
     "Verify quote for single international trip to US",
     "User on https://www.policybazaar.com/travel-insurance/",
     "1. Navigate to Travel Insurance\n2. Select trip type: International\n3. Destination: USA\n4. Departure date: (tomorrow's date)\n5. Return date: (departure + 10 days)\n6. Number of travellers: 1, Age: 30\n7. Click 'View Plans'",
     "Trip: International; Destination: USA; Duration: 10 days; Travellers: 1; Age: 30",
     "International travel plans displayed; Coverage amounts shown in USD; Plans include medical cover, trip cancellation; Multiple insurer options",
     "High","Critical","Positive"),

    ("PB_TRVL_002","Travel Insurance","Get Quote",
     "Get travel insurance quote for domestic travel",
     "Verify quote for a domestic trip within India",
     "User on Travel Insurance section",
     "1. Select trip type: Domestic\n2. Enter travel dates\n3. Number of travellers: 2\n4. Click 'View Plans'",
     "Trip: Domestic; Travellers: 2",
     "Domestic travel plans shown; Coverage in INR; Plans include personal accident cover; Lower premiums vs international",
     "High","Major","Positive"),

    ("PB_TRVL_003","Travel Insurance","Negative",
     "Select a past date as travel start date",
     "Verify past departure date is rejected",
     "User on Travel Insurance form",
     "1. In departure date field, enter: yesterday's date\n2. Attempt to proceed\n3. Observe validation",
     "Departure date: yesterday",
     "Error message: 'Departure date must be a future date'; Past dates are disabled in datepicker; Form cannot be submitted with past date",
     "High","Critical","Negative"),

    ("PB_TRVL_004","Travel Insurance","Negative",
     "Select return date before departure date",
     "Verify system rejects return date earlier than departure date",
     "User on Travel Insurance form",
     "1. Enter Departure date: 2026-09-01\n2. Enter Return date: 2026-08-28 (before departure)\n3. Attempt to proceed",
     "Departure: 2026-09-01; Return: 2026-08-28",
     "Error: 'Return date must be after departure date'; Return date picker should disable dates before departure; Form not submitted",
     "High","Critical","Negative"),

    ("PB_TRVL_005","Travel Insurance","Get Quote",
     "Get family travel insurance quote (2 adults + 1 child)",
     "Verify family travel insurance quote with 3 members",
     "User on Travel Insurance form",
     "1. Select International trip\n2. Add travellers: Adult1 (35), Adult2 (33), Child (8)\n3. Enter travel dates\n4. Click 'View Plans'",
     "Travellers: Adult (35), Adult (33), Child (8); Destination: Thailand",
     "Family plans shown; Premium covers all 3 members; Child included in family cover; Per-person premium breakdown visible",
     "Medium","Major","Positive"),

    ("PB_TRVL_006","Travel Insurance","Boundary",
     "Verify senior citizen age limit — above 70 years restricted",
     "Verify system blocks or warns for travellers above 70 years",
     "User on Travel Insurance form",
     "1. Add one traveller with age: 72\n2. Proceed to view plans",
     "Traveller age: 72",
     "System either: a) Shows limited plans for 70+ with warning; b) Displays message 'Senior citizen plans available with special terms'; No crash or error page",
     "High","Major","Boundary"),

    ("PB_TRVL_007","Travel Insurance","Business Rule",
     "Schengen-specific plan appears for European destination",
     "Verify Schengen visa travel plans are shown for European destinations",
     "User on Travel Insurance form",
     "1. Select trip type: International\n2. Destination: Germany (Schengen)\n3. Enter travel dates\n4. Click 'View Plans'\n5. Check for Schengen-compliant plans",
     "Destination: Germany (Schengen area)",
     "Plans labeled as 'Schengen Compliant' appear; Minimum €30,000 cover plans shown (Schengen visa requirement); Plans clearly marked for Schengen applicability",
     "High","Critical","Business Rule"),

    # ── MODULE 8: Investment / ULIP ───────────────────────────────────────────
    ("PB_INV_001","Investment / ULIP","Calculator",
     "Calculate investment returns for 30yr, 10k/month, 20 year tenure",
     "Verify ULIP/investment calculator produces correct projected returns",
     "User on https://www.policybazaar.com/investment/",
     "1. Navigate to Investment Plans\n2. Enter Age: 30\n3. Monthly investment: 10,000\n4. Tenure: 20 years\n5. Risk profile: Moderate\n6. Click 'View Plans' or 'Calculate'\n7. Note projected value",
     "Age: 30; Monthly: Rs 10,000; Tenure: 20 years; Risk: Moderate",
     "Projected maturity value shown; Breakdown of premium paid vs returns; Multiple fund options shown; Comparison with FD/PPF may be shown",
     "High","Critical","Positive"),

    ("PB_INV_002","Investment / ULIP","Business Rule",
     "High-risk profile shows aggressive equity fund options",
     "Verify risk profile selection changes the fund allocation recommendation",
     "User on Investment calculator results",
     "1. Select Risk Profile: High\n2. View recommended fund allocation\n3. Change Risk Profile: Low\n4. View recommended allocation\n5. Compare",
     "Risk profile: High vs Low",
     "High risk: Higher equity fund % (e.g. 80-100% equity); Low risk: Higher debt fund % (e.g. 80% debt); Different projected returns shown",
     "High","Major","Business Rule"),

    ("PB_INV_003","Investment / ULIP","Boundary",
     "Enter monthly investment amount below minimum (< Rs 1000)",
     "Verify system rejects investment amount below minimum threshold",
     "User on Investment form",
     "1. Enter monthly investment: 500 (below minimum)\n2. Proceed\n3. Observe validation",
     "Monthly amount: Rs 500",
     "Error: 'Minimum monthly investment is Rs 1,000'; Form not submitted; Field highlighted",
     "High","Critical","Boundary"),

    ("PB_INV_004","Investment / ULIP","Business Rule",
     "Projected maturity value increases with longer tenure",
     "Verify longer tenure produces higher projected maturity value (compounding)",
     "User on Investment calculator",
     "1. Set monthly: 5000, Age: 30\n2. Set tenure: 10 years; note projected value\n3. Set tenure: 20 years; note projected value\n4. Compare",
     "Tenure: 10 years vs 20 years; Monthly: Rs 5000",
     "20-year tenure projected value > 10-year projected value; Difference reflects compounding effect; Values are clearly labeled",
     "Medium","Major","Business Rule"),

    ("PB_INV_005","Investment / ULIP","Mandatory Fields",
     "Submit investment form without selecting risk profile",
     "Verify mandatory risk profile selection on investment form",
     "User on Investment form",
     "1. Enter age, monthly amount, tenure\n2. Skip risk profile selection\n3. Click 'View Plans'",
     "Risk profile: (not selected)",
     "Error: 'Please select your risk profile'; Form not submitted; Risk profile field highlighted",
     "High","Major","Mandatory Field"),

    # ── MODULE 9: Compare Plans ───────────────────────────────────────────────
    ("PB_CMP_001","Compare Plans","Health Compare",
     "Compare 2 health insurance plans side by side",
     "Verify 2-plan comparison page shows all feature differences",
     "User on Health Insurance results page",
     "1. Select Plan 1 via 'Compare' checkbox\n2. Select Plan 2 via 'Compare'\n3. Click 'Compare' button\n4. View comparison table",
     "Plans: Any 2 health plans from results",
     "Side-by-side comparison table opens; Plan names in column headers; Features listed in rows (Cover amount, Room rent, Co-pay etc.); Differences visually highlighted",
     "High","Critical","Positive"),

    ("PB_CMP_002","Compare Plans","Boundary",
     "Add maximum 3 plans to comparison",
     "Verify comparison works correctly with 3 plans (maximum)",
     "User on Health Insurance results page",
     "1. Select Plan 1, Plan 2, Plan 3 for compare\n2. Click 'Compare'\n3. Observe comparison table",
     "3 plans selected",
     "All 3 plans shown in comparison; 3-column layout; All features visible; Print/Download option available",
     "High","Critical","Boundary"),

    ("PB_CMP_003","Compare Plans","Boundary",
     "Adding 4th plan to comparison is blocked",
     "Verify compare limit of 3 is enforced — 4th selection blocked",
     "User has 3 plans already selected for compare on results page",
     "1. Select 3 plans for comparison\n2. Attempt to select a 4th plan\n3. Observe UI response",
     "4th plan selection attempt",
     "4th plan checkbox disabled or error toast: 'Maximum 3 plans can be compared. Remove one to add another'; Selection count stays at 3",
     "High","Critical","Boundary"),

    ("PB_CMP_004","Compare Plans","Workflow",
     "Remove a plan from comparison and add a new one",
     "Verify user can modify comparison selection by removing and re-adding",
     "User has 3 plans selected for comparison",
     "1. Have 3 plans selected\n2. Deselect/remove Plan 2\n3. Verify Plan 2 removed from compare bar\n4. Select a different Plan X\n5. Click Compare",
     "Remove Plan 2, add Plan X",
     "Plan 2 removed from comparison bar; Plan X can now be added; New 3-plan comparison works correctly",
     "Medium","Major","Workflow"),

    ("PB_CMP_005","Compare Plans","Data Persistence",
     "Compare table shows all feature differences for health plans",
     "Verify comparison table is complete and data persists while scrolling",
     "User on Compare Plans page with 2+ plans",
     "1. Open comparison of 2 health plans\n2. Scroll down through all comparison rows\n3. Note key features: Room Rent, Maternity, Cashless Hospitals, Co-pay, Waiting Period\n4. Scroll back to top",
     "N/A",
     "All features listed in rows; Data present in all columns for each row; No blank cells for available features; Data does not disappear on scroll",
     "Medium","Major","Data Persistence"),

    # ── MODULE 10: My Account ─────────────────────────────────────────────────
    ("PB_ACC_001","My Account","Dashboard",
     "View all active policies in My Account dashboard",
     "Verify all purchased policies are listed in dashboard",
     "User logged in; At least one policy purchased",
     "1. Login to account\n2. Navigate to 'My Account' or user dashboard\n3. Click 'My Policies'\n4. View listed policies",
     "Valid logged-in account with active policy",
     "All active policies displayed; Policy number, type, expiry date visible; Policy status shown (Active/Expired); Download option available per policy",
     "High","Critical","Positive"),

    ("PB_ACC_002","My Account","Document Download",
     "Download policy document as PDF from My Account",
     "Verify policy PDF download works from My Account section",
     "User logged in with at least one active policy",
     "1. Login and go to My Account\n2. Click 'My Policies'\n3. Select a policy\n4. Click 'Download Policy'\n5. Verify PDF download",
     "Active policy present",
     "PDF file downloads successfully; File name includes policy number; PDF opens and displays correct policy details; No corrupt file",
     "High","Critical","Positive"),

    ("PB_ACC_003","My Account","Profile Update",
     "Update profile — change email address with valid email",
     "Verify user can update email address in profile settings",
     "User logged in",
     "1. Go to My Account > Profile\n2. Click 'Edit' on email field\n3. Enter new email: updated@test.com\n4. Save changes\n5. Verify updated email displayed",
     "New email: updated@test.com",
     "Email updated successfully; Success message shown; New email visible in profile; OTP verification (if required) completed",
     "Medium","Major","Positive"),

    ("PB_ACC_004","My Account","Profile Update",
     "Profile update blocked for invalid email format",
     "Verify inline validation rejects invalid email in profile update",
     "User logged in; On Profile edit page",
     "1. Go to My Account > Profile > Edit\n2. In email field, enter: testuser@invalid\n3. Click Save\n4. Observe validation",
     "Email: testuser@invalid",
     "Error: 'Please enter a valid email address'; Profile not saved; Field highlighted in red",
     "Medium","Major","Negative"),

    ("PB_ACC_005","My Account","Session",
     "Unauthenticated access to My Account redirects to login",
     "Verify My Account is protected and redirects unauthenticated users",
     "User NOT logged in; Browser cookies cleared",
     "1. Without logging in, navigate directly to My Account URL\n2. Observe response",
     "No active session",
     "Redirected to login page; URL changes to login page; My Account content NOT visible; After login, redirected back to My Account",
     "High","Critical","Session"),

    ("PB_ACC_006","My Account","Session",
     "Session times out after 30 minutes of inactivity",
     "Verify auto-logout after 30 min inactivity and re-login required",
     "User logged in; Application open in browser",
     "1. Login to account\n2. Leave browser idle for 30+ minutes\n3. Attempt to navigate within My Account\n4. Observe",
     "Inactivity: 30+ minutes",
     "User is logged out automatically; Login prompt appears or redirect to login page; Session expired message shown; Previous session data cleared",
     "High","Critical","Session"),

    # ── MODULE 11: Policy Renewal ─────────────────────────────────────────────
    ("PB_RNW_001","Policy Renewal","Car Renewal",
     "Renew expired car insurance using policy number",
     "Verify car insurance renewal flow for an expired policy",
     "User has an expired car insurance policy number",
     "1. Navigate to Car Insurance renewal\n2. Enter expired policy number\n3. Click 'Renew'\n4. Verify vehicle/policy details fetched\n5. Review premium\n6. Proceed to payment",
     "Policy number: valid expired car policy",
     "Policy details fetched correctly; Renewal premium shown; Option to continue with same or different insurer; Payment gateway reached",
     "High","Critical","Positive"),

    ("PB_RNW_002","Policy Renewal","Health Renewal",
     "Renew health insurance before expiry date",
     "Verify health insurance renewal works when policy is still active",
     "User has an active health policy expiring within 30 days",
     "1. Go to My Account > My Policies\n2. Find health policy with upcoming expiry\n3. Click 'Renew'\n4. Review renewal premium\n5. Proceed",
     "Health policy: active, expiring in < 30 days",
     "Renewal option available; Renewed policy has new expiry date (original + 1 year); Continuity benefits preserved; Confirmation email sent",
     "High","Critical","Positive"),

    ("PB_RNW_003","Policy Renewal","Validation",
     "Enter invalid policy number in renewal form",
     "Verify system shows error for unrecognized or invalid policy number",
     "User on renewal entry page",
     "1. Navigate to Renew Insurance\n2. Enter policy number: INVALID12345\n3. Click 'Find Policy'\n4. Observe response",
     "Policy number: INVALID12345",
     "Error: 'Policy number not found. Please check and try again'; No policy details loaded; User can re-enter number",
     "High","Critical","Negative"),

    ("PB_RNW_004","Policy Renewal","Business Rule",
     "System handles renewal attempt for non-expiring active policy",
     "Verify behavior when user tries to renew a policy with 11+ months remaining",
     "User has an active policy with over 11 months remaining",
     "1. Go to My Policies\n2. Select an active policy (just renewed, 11 months left)\n3. Attempt to click Renew",
     "Policy: active, 11 months remaining",
     "Either: a) Renew button disabled; b) Message: 'Your policy is active until [date]. Renewal will be available 30 days before expiry'; User not allowed to renew prematurely",
     "Medium","Major","Business Rule"),

    ("PB_RNW_005","Policy Renewal","Data Persistence",
     "Renewal premium is shown before payment confirmation",
     "Verify complete premium breakup is shown on renewal review page before payment",
     "User on renewal review page",
     "1. Initiate policy renewal\n2. Reach the review/summary page before payment\n3. Check premium details shown",
     "Renewal flow initiated",
     "Premium breakup visible: base premium, GST (18%), total payable; Policy start/end dates shown; Insurer name shown; User can review before proceeding to payment",
     "High","Critical","Data Persistence"),

    # ── MODULE 12: Claim Filing ───────────────────────────────────────────────
    ("PB_CLM_001","Claim Filing","Health Claim",
     "File a cashless claim for health insurance",
     "Verify cashless claim initiation flow for health insurance",
     "User logged in; Active health insurance policy; At a network hospital",
     "1. Go to My Account > Claims\n2. Click 'File New Claim'\n3. Select policy\n4. Select claim type: Cashless\n5. Enter hospital name (network hospital)\n6. Enter admission date\n7. Submit claim request",
     "Claim type: Cashless; Hospital: Max Healthcare (network)",
     "Claim request submitted successfully; Claim reference number generated; Email/SMS confirmation sent; Claim status shows 'Under Review'",
     "High","Critical","Positive"),

    ("PB_CLM_002","Claim Filing","Health Claim",
     "File a reimbursement claim with document upload",
     "Verify reimbursement claim with bill/document upload",
     "User logged in; Active health policy; Treatment completed; Bills available",
     "1. Go to Claims > File New Claim\n2. Select Reimbursement\n3. Upload: Hospital Bill (PDF), Discharge Summary (PDF), Prescription (PDF)\n4. Enter claim amount: 45,000\n5. Submit",
     "Claim type: Reimbursement; Amount: Rs 45,000; Documents: 3 PDF files",
     "All documents uploaded successfully; Claim submitted with reference number; Email confirmation received; Status: 'Documents Under Verification'",
     "High","Critical","Positive"),

    ("PB_CLM_003","Claim Filing","Mandatory Fields",
     "Submit claim without uploading mandatory documents",
     "Verify mandatory document upload validation on claim form",
     "User on claim filing form",
     "1. Start new claim\n2. Fill claim type and details\n3. Skip document upload\n4. Click 'Submit Claim'",
     "Documents: (not uploaded)",
     "Error: 'Please upload required documents (Hospital Bill, Discharge Summary)'; Claim not submitted; Document upload field highlighted",
     "High","Critical","Mandatory Field"),

    ("PB_CLM_004","Claim Filing","Negative",
     "Upload unsupported file format for claim document",
     "Verify system rejects files in unsupported formats (e.g. .exe, .mp3)",
     "User on claim filing document upload step",
     "1. In document upload section, attempt to upload a .exe file\n2. Observe\n3. Attempt .mp3 file\n4. Observe",
     "File type: .exe, .mp3",
     "Error: 'Invalid file format. Please upload PDF, JPG, or PNG files only'; File not uploaded; Upload field remains empty; No system error or security issue",
     "High","Critical","Negative"),

    ("PB_CLM_005","Claim Filing","Workflow",
     "Track claim status after submission",
     "Verify claim tracking shows current status and history",
     "User with at least one submitted claim",
     "1. Go to My Account > Claims\n2. Find submitted claim in list\n3. Click on claim to view details\n4. Check status\n5. Check status history/timeline",
     "Submitted claim reference available",
     "Claim status visible (e.g. Under Review / Approved / Rejected); Status history/timeline shown; Last updated date displayed; Contact/escalate option visible",
     "High","Critical","Workflow"),
]

# ─────────────────────────────────────────────────────────────────────────────

def apply_header(ws):
    for col_idx, (header, width) in enumerate(zip(HEADERS, COL_WIDTHS), start=1):
        cell = ws.cell(row=1, column=col_idx, value=header)
        cell.fill = HEADER_FILL
        cell.font = HEADER_FONT
        cell.alignment = CENTER
        cell.border = THIN_BORDER
        ws.column_dimensions[get_column_letter(col_idx)].width = width
    ws.row_dimensions[1].height = 28
    ws.freeze_panes = "A2"


def write_rows(ws, rows):
    for r_idx, row in enumerate(rows, start=2):
        fill = ALT_FILL if r_idx % 2 == 0 else WHITE_FILL
        tc_id, module, sub, scenario, title, pre, steps, data, expected, priority, severity, test_type = row
        values = [tc_id, module, sub, scenario, title, pre, steps, data, expected,
                  "", "", priority, severity, test_type, ""]
        for c_idx, val in enumerate(values, start=1):
            cell = ws.cell(row=r_idx, column=c_idx, value=val)
            cell.fill = fill
            cell.font = BODY_FONT
            cell.alignment = WRAP
            cell.border = THIN_BORDER
        ws.row_dimensions[r_idx].height = 60


def build_module_sheet(wb, sheet_name, module_filter):
    ws = wb.create_sheet(sheet_name)
    apply_header(ws)
    rows = [tc for tc in TEST_CASES if tc[1] == module_filter]
    write_rows(ws, rows)
    return len(rows)


def build_summary(wb, module_counts):
    ws = wb.create_sheet("Summary", 0)
    ws.column_dimensions["A"].width = 35
    ws.column_dimensions["B"].width = 20
    ws.column_dimensions["C"].width = 25

    # Title
    title_cell = ws.cell(row=1, column=1, value="PolicyBazaar — Functional Test Cases Summary")
    title_cell.fill = SUMMARY_FILL
    title_cell.font = Font(bold=True, color="FFFFFF", size=13, name="Calibri")
    title_cell.alignment = CENTER
    ws.merge_cells("A1:C1")
    ws.row_dimensions[1].height = 32

    # Sub-headers
    for col, text in [(1, "Module"), (2, "Test Cases Count"), (3, "Priority Distribution")]:
        c = ws.cell(row=2, column=col, value=text)
        c.fill = HEADER_FILL
        c.font = HEADER_FONT
        c.alignment = CENTER
        c.border = THIN_BORDER
    ws.row_dimensions[2].height = 22

    total = 0
    for i, (module, count, priority_note) in enumerate(module_counts, start=3):
        fill = ALT_FILL if i % 2 == 0 else WHITE_FILL
        ws.cell(row=i, column=1, value=module).fill = fill
        ws.cell(row=i, column=1).font = BODY_FONT
        ws.cell(row=i, column=1).border = THIN_BORDER
        ws.cell(row=i, column=1).alignment = WRAP

        c2 = ws.cell(row=i, column=2, value=count)
        c2.fill = fill; c2.font = BODY_FONT; c2.border = THIN_BORDER; c2.alignment = CENTER

        c3 = ws.cell(row=i, column=3, value=priority_note)
        c3.fill = fill; c3.font = BODY_FONT; c3.border = THIN_BORDER; c3.alignment = WRAP
        total += count

    # Total row
    t_row = 3 + len(module_counts)
    for col in range(1, 4):
        c = ws.cell(row=t_row, column=col)
        c.fill = SUMMARY_FILL
        c.font = Font(bold=True, color="FFFFFF", size=10, name="Calibri")
        c.border = THIN_BORDER
        c.alignment = CENTER
    ws.cell(row=t_row, column=1, value="TOTAL").fill = SUMMARY_FILL
    ws.cell(row=t_row, column=1).font = Font(bold=True, color="FFFFFF", size=10, name="Calibri")
    ws.cell(row=t_row, column=1).alignment = CENTER
    ws.cell(row=t_row, column=1).border = THIN_BORDER
    ws.cell(row=t_row, column=2, value=total).fill = SUMMARY_FILL
    ws.cell(row=t_row, column=2).font = Font(bold=True, color="FFFFFF", size=10, name="Calibri")
    ws.cell(row=t_row, column=2).alignment = CENTER
    ws.cell(row=t_row, column=2).border = THIN_BORDER
    ws.cell(row=t_row, column=3, value="High: 62 | Medium: 18 | Low: 6").fill = SUMMARY_FILL
    ws.cell(row=t_row, column=3).font = Font(bold=True, color="FFFFFF", size=10, name="Calibri")
    ws.cell(row=t_row, column=3).alignment = CENTER
    ws.cell(row=t_row, column=3).border = THIN_BORDER


MODULES = [
    ("Homepage & Navigation",   "TC_01_Homepage",          "High: 4 | Medium: 2 | Low: 1"),
    ("Authentication",          "TC_02_Authentication",    "High: 10 | Medium: 2"),
    ("Health Insurance",        "TC_03_Health_Insurance",  "High: 8 | Medium: 4"),
    ("Term Insurance",          "TC_04_Term_Insurance",    "High: 7 | Medium: 3"),
    ("Car Insurance",           "TC_05_Car_Insurance",     "High: 6 | Medium: 2"),
    ("Bike Insurance",          "TC_06_Bike_Insurance",    "High: 3 | Medium: 2"),
    ("Travel Insurance",        "TC_07_Travel_Insurance",  "High: 5 | Medium: 2"),
    ("Investment / ULIP",       "TC_08_Investment_ULIP",   "High: 4 | Medium: 1"),
    ("Compare Plans",           "TC_09_Compare_Plans",     "High: 3 | Medium: 2"),
    ("My Account",              "TC_10_My_Account",        "High: 4 | Medium: 2"),
    ("Policy Renewal",          "TC_11_Policy_Renewal",    "High: 4 | Medium: 1"),
    ("Claim Filing",            "TC_12_Claim_Filing",      "High: 5"),
]


def main():
    wb = Workbook()
    wb.remove(wb.active)

    module_counts = []
    for module_name, sheet_name, priority_note in MODULES:
        count = build_module_sheet(wb, sheet_name, module_name)
        module_counts.append((module_name, count, priority_note))

    build_summary(wb, module_counts)

    wb.save(OUTPUT_FILE)
    print(f"\n Excel file generated successfully!")
    print(f" Location : {OUTPUT_FILE}")
    print(f" Total TCs: {sum(c for _, c, _ in module_counts)}")
    print(f" Sheets   : {len(MODULES) + 1} (1 Summary + {len(MODULES)} modules)")


if __name__ == "__main__":
    main()

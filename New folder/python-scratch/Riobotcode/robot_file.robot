*** Settings ***
Library    SeleniumLibrary
Library     json


*** Variables ***
${list_singlevalues}    10

@{mutipal_list}    11    22    333    44

&{dictvalues}    key=pair

*** Test Cases ***
Tc1: lanuching and browsring
    [Tags]   @smoke     @sanity
    [Setup]  Open Browser    https://www.amazon.in/        browser==chrome

    Input Text        xpath     valuesinput
    Maximize Browser Window
    Select

# ================================================================
# WAIT FOR METHODS (SeleniumLibrary)
# ================================================================

# ---------------------------------------------------------------
# Wait Until Element Is Visible
# Waits until the element appears on screen (visible to user)
# ---------------------------------------------------------------
#     Wait Until Element Is Visible    id=submitBtn
#     Wait Until Element Is Visible    id=submitBtn       timeout=10s
#     Wait Until Element Is Visible    xpath=//div[@class='popup']    timeout=15s    error=Popup not appeared

# ---------------------------------------------------------------
# Wait Until Element Is Not Visible
# Waits until element disappears (loader, spinner, popup)
# ---------------------------------------------------------------
#     Wait Until Element Is Not Visible    id=loader
#     Wait Until Element Is Not Visible    css=.spinner     timeout=20s

# ---------------------------------------------------------------
# Wait Until Element Is Enabled
# Waits until a disabled button/input becomes clickable
# ---------------------------------------------------------------
#     Wait Until Element Is Enabled    id=submitBtn
#     Wait Until Element Is Enabled    xpath=//button[@type='submit']    timeout=10s

# ---------------------------------------------------------------
# Wait Until Page Contains
# Waits until a text appears anywhere on the page
# ---------------------------------------------------------------
#     Wait Until Page Contains             Welcome John       timeout=10s
#     Wait Until Page Contains             Order Confirmed

# ---------------------------------------------------------------
# Wait Until Page Does Not Contain
# Waits until a text disappears from the page
# ---------------------------------------------------------------
#     Wait Until Page Does Not Contain     Loading...         timeout=15s

# ---------------------------------------------------------------
# Wait Until Page Contains Element
# Waits until element exists in DOM (even if hidden)
# ---------------------------------------------------------------
#     Wait Until Page Contains Element    id=dashboard
#     Wait Until Page Contains Element    xpath=//table[@id='results']    timeout=10s

# ---------------------------------------------------------------
# Wait Until Page Does Not Contain Element
# Waits until element is removed from DOM
# ---------------------------------------------------------------
#     Wait Until Page Does Not Contain Element    id=loadingModal    timeout=10s

# ---------------------------------------------------------------
# Wait Until Element Contains
# Waits until specific element has the expected text
# ---------------------------------------------------------------
#     Wait Until Element Contains    id=message    Success       timeout=10s
#     Wait Until Element Contains    css=.status   Payment Done

# ---------------------------------------------------------------
# Wait Until Element Does Not Contain
# Waits until element no longer has certain text
# ---------------------------------------------------------------
#     Wait Until Element Does Not Contain    id=status    Processing    timeout=15s

# ---------------------------------------------------------------
# Wait Until Keyword Succeeds
# Retries a keyword until it passes or timeout hits
# ---------------------------------------------------------------
#     Wait Until Keyword Succeeds    10s    2s    Element Should Be Visible    id=popup
#     # args: total_timeout  retry_interval  keyword  keyword_args

# ---------------------------------------------------------------
# Wait For Condition (JavaScript condition)
# Waits until a JS expression returns true
# ---------------------------------------------------------------
#     Wait For Condition    return document.readyState=="complete"
#     Wait For Condition    return document.getElementById('btn').disabled==false    timeout=10s

# ---------------------------------------------------------------
# Sleep (hard wait — avoid in real tests, use only for demo)
# ---------------------------------------------------------------
#     Sleep    2s
#     Sleep    500ms


# ================================================================
# SHOULD BE METHODS (BuiltIn + SeleniumLibrary)
# ================================================================

# ---------------------------------------------------------------
# Page level — check text on page
# ---------------------------------------------------------------
#     Page Should Contain              Welcome
#     Page Should Not Contain          Error
#     Page Should Contain Element      id=logo
#     Page Should Not Contain Element  id=errorMsg

# ---------------------------------------------------------------
# Element level — check element state
# ---------------------------------------------------------------
#     Element Should Be Visible        id=submitBtn
#     Element Should Not Be Visible    id=hiddenDiv
#     Element Should Be Enabled        id=inputField
#     Element Should Be Disabled       id=readonlyField
#     Element Should Contain           id=message      Success
#     Element Should Not Contain       id=message      Failed
#     Element Text Should Be           id=header       Dashboard      # exact match

# ---------------------------------------------------------------
# Value / Attribute checks
# ---------------------------------------------------------------
#     ${val}=    Get Value          id=input
#     Should Be Equal    ${val}     John                 # exact match
#     ${attr}=   Get Element Attribute    id=btn    class
#     Should Contain     ${attr}    active

# ---------------------------------------------------------------
# BuiltIn Should Be assertions (work on variables)
# ---------------------------------------------------------------
#     Should Be Equal                  ${actual}         ${expected}
#     Should Be Equal As Integers      ${num}            10
#     Should Be Equal As Strings       ${val}            hello
#     Should Be Equal As Numbers       ${price}          9.99

#     Should Not Be Equal              ${a}              ${b}

#     Should Contain                   ${text}           error
#     Should Not Contain               ${text}           fail
#     Should Start With                ${text}           Hello
#     Should End With                  ${text}           World
#     Should Match Regexp              ${text}           \\d{4}-\\d{2}-\\d{2}   # date pattern
#     Should Not Match Regexp          ${text}           ERROR

#     Should Be True                   ${count} > 0
#     Should Be True                   '${status}' == 'PASS'
#     Should Not Be True               ${flag}

#     Should Be Empty                  ${list}
#     Should Not Be Empty              ${list}

#     Length Should Be                 ${items}          5
#     Should Be Greater Than           ${num}            0
#     Should Be Lesser Than            ${num}            100

# ---------------------------------------------------------------
# Checkbox / Radio
# ---------------------------------------------------------------
#     Checkbox Should Be Selected      id=agreeBox
#     Checkbox Should Not Be Selected  id=agreeBox

# ---------------------------------------------------------------
# Title / URL
# ---------------------------------------------------------------
#     ${title}=    Get Title
#     Should Be Equal    ${title}    Amazon.in: Online Shopping India

#     ${url}=    Get Location
#     Should Contain    ${url}    dashboard

# ================================================================
# WAIT + SHOULD BE COMBINED PATTERN (real usage)
# ================================================================
#     Wait Until Page Contains Element    id=confirmMsg    timeout=10s
#     Element Should Contain              id=confirmMsg    Booking Confirmed
#     Element Should Be Visible           id=confirmMsg

*** Keywords ***


# ================================================================
# TC2: WAIT UNTIL KEYWORD SUCCEEDS — EXAMPLES
# ================================================================
# Syntax:
#   Wait Until Keyword Succeeds    <total_time>    <retry_interval>    <keyword>    <args>
#
#   total_time     = how long to keep trying overall
#   retry_interval = gap between each retry
#   keyword        = any Robot keyword that might fail
#
# Example 1 — wait until element is visible (retry every 2s for 10s total)
#     Wait Until Keyword Succeeds    10s    2s    Element Should Be Visible    id=submitBtn
#
# Example 2 — wait until page contains text
#     Wait Until Keyword Succeeds    15s    3s    Page Should Contain    Order Confirmed
#
# Example 3 — wait until element has expected text
#     Wait Until Keyword Succeeds    10s    1s    Element Should Contain    id=status    Success
#
# Example 4 — wait until element count is correct
#     Wait Until Keyword Succeeds    10s    2s    Check Row Count    5
#
# Example 5 — wait until custom keyword passes
#     Wait Until Keyword Succeeds    20s    2s    Verify Payment Status    PAID
#
# Custom keyword used in Wait Until Keyword Succeeds:
# Verify Payment Status
#     [Arguments]    ${expected_status}
#     ${actual}=    Get Text    id=paymentStatus
#     Should Be Equal    ${actual}    ${expected_status}


# ================================================================
# TC3: CREATE LIST — GET VALUES — SHOULD CONTAIN
# ================================================================
# Create List inside test case:
#     @{fruits}=    Create List    apple    banana    mango    grape
#
# Access by index (0-based):
#     Log    ${fruits}[0]        # apple
#     Log    ${fruits}[1]        # banana
#     Log    ${fruits}[-1]       # grape  (last item)
#
# Get length:
#     ${len}=    Get Length    ${fruits}
#     Log    ${len}             # 4
#
# Should Contain — check if value exists in list:
#     Should Contain    ${fruits}    apple        # PASS
#     Should Contain    ${fruits}    mango        # PASS
#     Should Not Contain    ${fruits}    orange   # PASS
#
# Loop through list:
#     FOR    ${item}    IN    @{fruits}
#         Log    ${item}
#     END
#
# Append item to list:
#     Append To List    ${fruits}    orange
#     Log    ${fruits}[-1]       # orange
#
# Remove item from list:
#     Remove Values From List    ${fruits}    banana
#
# List Should Contain Value:
#     List Should Contain Value    ${fruits}    apple    # pass
#     List Should Not Contain Value    ${fruits}    papaya
#
# List in Variables section (defined at top):
# @{BROWSERS}    chrome    firefox    edge
#     Log    ${BROWSERS}[0]     # chrome


# ================================================================
# TC4: CREATE DICTIONARY — GET VALUES — SHOULD CONTAIN
# ================================================================
# Create Dictionary inside test case:
#     &{user}=    Create Dictionary
#     ...    name=John
#     ...    age=25
#     ...    city=NYC
#     ...    role=admin
#
# OR on one line:
#     &{user}=    Create Dictionary    name=John    age=25    city=NYC
#
# Get value by key:
#     Log    ${user}[name]       # John
#     Log    ${user}[age]        # 25
#     Log    ${user.city}        # NYC  (dot notation also works)
#
# Get all keys:
#     ${keys}=    Get Dictionary Keys    ${user}
#     Log    ${keys}             # ['name', 'age', 'city', 'role']
#
# Get all values:
#     ${vals}=    Get Dictionary Values    ${user}
#     Log    ${vals}             # ['John', 25, 'NYC', 'admin']
#
# Get single value safely:
#     ${name}=    Get From Dictionary    ${user}    name
#     Log    ${name}             # John
#
# Dictionary Should Contain Key:
#     Dictionary Should Contain Key      ${user}    name     # PASS
#     Dictionary Should Contain Key      ${user}    email    # FAIL
#
# Dictionary Should Contain Value:
#     Dictionary Should Contain Value    ${user}    John     # PASS
#     Dictionary Should Contain Value    ${user}    NYC      # PASS
#
# Dictionary Should Contain Item (key + value pair):
#     Dictionary Should Contain Item    ${user}    name    John    # PASS
#     Dictionary Should Contain Item    ${user}    age     25      # PASS
#
# Should Contain on dict keys string:
#     ${keys_str}=    Convert To String    ${user}
#     Should Contain    ${keys_str}    name
#
# Add new key to dict:
#     Set To Dictionary    ${user}    email    john@test.com
#     Log    ${user}[email]      # john@test.com
#
# Remove key from dict:
#     Remove From Dictionary    ${user}    role
#
# Check key exists with Run Keyword If:
#     ${has_key}=    Run Keyword And Return Status
#     ...    Dictionary Should Contain Key    ${user}    email
#     Run Keyword If    ${has_key}    Log    Email exists
#     Run Keyword Unless    ${has_key}    Log    Email missing
#
# Dict in Variables section (defined at top):
# &{CONFIG}    env=staging    browser=chrome    timeout=10
#     Log    ${CONFIG}[env]     # staging


# ================================================================
# FULL REAL EXAMPLE — List + Dict together
# ================================================================
# TC5: List and Dict real usage
#     # Create users list of dicts
#     &{user1}=    Create Dictionary    name=Alice    role=admin
#     &{user2}=    Create Dictionary    name=Bob      role=tester
#     @{users}=    Create List    ${user1}    ${user2}
#
#     # Access nested
#     Log    ${users}[0][name]     # Alice
#     Log    ${users}[1][role]     # tester
#
#     # Check
#     Dictionary Should Contain Value    ${users}[0]    admin
#     Dictionary Should Contain Key      ${users}[1]    role
#     Should Contain    ${users}[0][name]    Alice


# ================================================================
# RUN KEYWORD AND IGNORE ERROR
# ================================================================
# Runs a keyword — if it FAILS, error is swallowed, test continues
# Returns TWO values: status (PASS/FAIL) and message
#
# Syntax:
#   ${status}    ${msg}=    Run Keyword And Ignore Error    <keyword>    <args>
#
# Example 1 — ignore if element not found
#     ${status}    ${msg}=    Run Keyword And Ignore Error
#     ...    Element Should Be Visible    id=popup
#     Log    ${status}       # PASS or FAIL
#     Log    ${msg}          # error message if FAIL, else NONE
#
# Example 2 — try to click, ignore if fails
#     ${status}    ${msg}=    Run Keyword And Ignore Error
#     ...    Click Element    id=closeBtn
#     Log    Status: ${status}
#
# Example 3 — use result to branch logic
#     ${status}    ${msg}=    Run Keyword And Ignore Error
#     ...    Page Should Contain    Welcome
#     Run Keyword If    '${status}'=='PASS'    Log    User is logged in
#     Run Keyword If    '${status}'=='FAIL'    Log    User NOT logged in
#
# Example 4 — ignore error on API call
#     ${status}    ${resp}=    Run Keyword And Ignore Error
#     ...    GET    /booking/999        # non-existent ID
#     Log    ${status}       # FAIL (404)


# ================================================================
# RUN KEYWORD AND RETURN STATUS
# ================================================================
# Runs a keyword — returns ONLY True (pass) or False (fail)
# Simpler than Ignore Error when you only need True/False
#
# Syntax:
#   ${flag}=    Run Keyword And Return Status    <keyword>    <args>
#
# Example 1 — check element exists
#     ${visible}=    Run Keyword And Return Status
#     ...    Element Should Be Visible    id=banner
#     Log    ${visible}      # True or False
#
# Example 2 — use in IF condition
#     ${logged_in}=    Run Keyword And Return Status
#     ...    Page Should Contain    Dashboard
#     IF    ${logged_in}
#         Log    User is on Dashboard
#     ELSE
#         Log    User is NOT logged in
#         Click Element    id=loginBtn
#     END
#
# Example 3 — check key in dict
#     ${has_email}=    Run Keyword And Return Status
#     ...    Dictionary Should Contain Key    ${user}    email
#     Run Keyword If    ${has_email}    Log    Email: ${user}[email]
#     Run Keyword Unless    ${has_email}    Log    No email found
#
# Example 4 — check element before clicking
#     ${btn_exists}=    Run Keyword And Return Status
#     ...    Page Should Contain Element    id=acceptCookies
#     Run Keyword If    ${btn_exists}    Click Element    id=acceptCookies


# ================================================================
# RUN KEYWORD IF — CONDITION + RETURN
# ================================================================
# Runs keyword ONLY if condition is True
# Can return value from the keyword that ran
#
# Syntax:
#   Run Keyword If    <condition>    <keyword>    <args>
#   ...    ELSE IF    <condition>    <keyword>    <args>
#   ...    ELSE                     <keyword>    <args>
#
# Example 1 — simple condition
#     Run Keyword If    '${env}'=='prod'      Log    Running on PRODUCTION
#     Run Keyword If    '${env}'=='staging'   Log    Running on STAGING
#
# Example 2 — IF / ELSE IF / ELSE chain
#     Run Keyword If      '${status}'=='200'    Log    OK
#     ...    ELSE IF      '${status}'=='404'    Log    Not Found
#     ...    ELSE IF      '${status}'=='500'    Log    Server Error
#     ...    ELSE                               Log    Unknown status
#
# Example 3 — run keyword and RETURN its value
#     ${text}=    Run Keyword If    ${visible}
#     ...    Get Text    id=message
#     Log    ${text}     # text from element if visible, else NONE
#
# Example 4 — multiple ELSE IF with element actions
#     ${status}    ${msg}=    Run Keyword And Ignore Error
#     ...    Element Should Be Visible    id=popup
#     Run Keyword If    '${status}'=='PASS'    Click Element    id=closePopup
#
# Example 5 — Run Keyword Unless (opposite of If)
#     Run Keyword Unless    ${is_logged_in}    Click Element    id=loginBtn
#     # runs only if condition is FALSE
#
# Example 6 — combine with Return Status (real usage pattern)
#     ${exists}=    Run Keyword And Return Status
#     ...    Page Should Contain Element    id=cookieBanner
#
#     Run Keyword If    ${exists}
#     ...    Run Keywords
#     ...    Click Element    id=acceptBtn
#     ...    AND    Log    Cookie banner accepted
#
# Run Keywords (run multiple keywords in one line with AND):
#     Run Keywords
#     ...    Click Element    id=btn1
#     ...    AND    Input Text    id=field    hello
#     ...    AND    Click Element    id=submit


# ================================================================
# DIFFERENCE SUMMARY
# ================================================================
# Run Keyword And Ignore Error    → returns PASS/FAIL + message, test continues
# Run Keyword And Return Status   → returns True/False only, test continues
# Run Keyword If                  → runs keyword only when condition is met
# Run Keyword Unless              → runs keyword only when condition is FALSE
# Run Keywords                    → run multiple keywords in sequence (with AND)



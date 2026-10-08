*** Settings ***
Library     SeleniumLibrary



*** Variables ***
${singlevalies}    https://in.bookmyshow.com/explore/home
@{list_values}        ecah    ecah2    ecah3    each4
&{dict_akues}        value=value1    value2=valuue3

*** Test Cases ***
LANUCH TJE BROWSER OF THE CHROME
    [Tags] 566838  SANITY regression smoke
    Open Browser     https://www.amazon.in/    chrome
    Set Selenium Implicit Wait    10
    Handle Alert    action=ACCEPT
    Alert Should Be Present
    Unselect Frame
    ${webelment}        Select Checkbox    xpath="dsjfgdejhfcu
    Should Be Empty     ${webelment}
    Wait Until Page Contains Element    xpath
    FOR    ${JHSDKSKKDEJ}    IN    LISTALS
    ${SINGLERETURNING}    Get WebElement    ${JHSDKSKKDEJ}
        IF    ${SINGLERETURNING}
                Log PASSD ONDTION
        END

    END








TC1: Printing all scenarios of the test cases
    [Tags]    67788
    Log    ${dict_akues}[value2]
    Log    ${dict_akues}[value]
    Open Browser  ${singlevalies}    chrome
    Maximize Browser Window
   # Wait until dropdown is available
    Wait Until Page Contains Element    xpath=//select[@id='dropdown']    10s

    # Select by visible text
    Select From List By Label    xpath=//select[@id='dropdown']    India

    # Validate selected label
    ${selected_label}=    Get Selected List Label    xpath=//select[@id='dropdown']
    Should Be Equal    ${selected_label}    India

    # Select by value
    Select From List By Value    xpath=//select[@id='dropdown']    IN

    # Validate selected value
    ${selected_value}=    Get Selected List Value    xpath=//select[@id='dropdown']
    Should Be Equal    ${selected_value}    IN

    # Get all selected labels
    @{list_of_all_values}=    Get Selected List Labels    xpath=//select[@id='dropdown']

    # Print every selected value
    FOR    ${each}    IN    @{list_of_all_values}
        Log    ${each}
    END

    # Validate at least one value is selected
    ${count}=    Get Length    ${list_of_all_values}
    Should Be True    ${count} > 0


    # 1. Wait for a JavaScript condition
    Wait For Condition    return document.readyState == "complete"    10s


    # 2. Wait until element does NOT contain text
    Wait Until Element Does Not Contain    xpath=//div[@id='status']    Loading    10s


    # 3. Wait until page contains text
    Wait Until Page Contains
    ...    Movies
    ...    10s


    # 4. Wait until page contains an element
    Wait Until Page Contains Element
    ...    xpath=//button[@id='login']
    ...    10s


    # 5. Wait until element is enabled
    Wait Until Element Is Enabled
    ...    xpath=//button[@id='submit']
    ...    10s


    # 6. Wait until element is NOT visible
    Wait Until Element Is Not Visible
    ...    xpath=//div[@class='loader']
    ...    10s


    # 7. Retry a keyword until it succeeds
    Wait Until Keyword Succeeds     20s    2s
    ...    get_text    xpath=//div[@id='message']


    # 8. Get an attribute
    ${single_attributevalue}=    Get Element Attribute
    ...    xpath=//input[@id='username']
    ...    value


    # 9. Validate attribute value
    Element Attribute Value Should Be
    ...    xpath=//input[@id='username']
    ...    value
    ...    Yash


    # 10. Validate element is disabled
    Element Should Be Disabled
    ...    xpath=//button[@id='submit']


    # 11. Validate element is enabled
    Element Should Be Enabled
    ...    xpath=//button[@id='submit']


    # 12. Validate element is visible
    Element Should Be Visible
    ...    xpath=//button[@id='login']


    # 13. Validate element is NOT visible
    Element Should Not Be Visible
    ...    xpath=//div[@class='loader']


    # 14. Validate exact text
    Element Text Should Be
    ...    xpath=//h1
    ...    Movies


    # 15. Exit FOR loop when condition is true
    Exit For Loop If
    ...    '${value}' == 'India'


    # 16. Validate element contains text
    Element Should Contain
    ...    xpath=//div[@id='message']
    ...    Success

        # Accept
    Handle Alert    action=ACCEPT

    # Dismiss
    Handle Alert    action=DISMISS

    # Enter text into prompt
    Input Text Into Alert    mypassword

    # Check alert exists
    Alert Should Be Present

    # Check alert does not exist
    Alert Should Not Be Present
    # Accept alert AND get returned message
    ${message}=    Handle Alert    action=ACCEPT

    Mouse Over        xpathelemnt
    Open Context Menu    contexmenau
    Double Click Element    ELMENET
    Drag And Drop        SRC DST
    Drag And Drop By Offset    1000    20000









    [Teardown]    Log        "test casess completed"





*** Keywords ***
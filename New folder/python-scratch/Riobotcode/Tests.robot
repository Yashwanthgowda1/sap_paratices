*** Settings ***
Library    SeleniumLibrary


*** Variables ***
${browser}    chrome
${inout}        6762772889



*** Test Cases ***
LANUCH BROWSER
    firstrobotocde for the testing     https://www.amazon.in/        ${browser}
    [Teardown]    Close Browser

Serach for the laptops and collect the list of laps and dropdowns
    firstrobotocde for the testing    https://www.amazon.in/        ${browser}
    Sleep   10s

    @{dropdown_items}=    Get List Items    [aria-describedby='searchDropdownDescription']
    Log    Dropdown Values: ${dropdown_items}
    multoslect validation  select all
    ${multiple}=    Get Element Attribute    css:select#searchDropdownDescription    multiple
    IF    not ${multiple}

        Select From List By Label    css:select[aria-describedby='searchDropdownDescription']    Amazon Fashion
        ${selected_label}=    Get Selected List Label    css:select[aria-describedby='searchDropdownDescription']
        Log    Selected Label: ${selected_label}

        # Select by value
        Select From List By Value    css:select[aria-describedby='searchDropdownDescription']    search-alias=nowstore
        ${selected_value}=    Get Selected List Value    css:select[aria-describedby='searchDropdownDescription']
        Log    Selected Value: ${selected_value}
    END
    ${need_to_mouse_hover}        Get WebElement    css:[aria-label*='Choose a language for']:nth-of-type(1)
    Mouse Over        ${need_to_mouse_hover}
    @{list_of_value}      Create List
    ...    //li[@id="p_123/308445"]//i[contains(@class,"a-icon-checkbox")]
    ...    //li[@id="p_123/391242"]//i[contains(@class,"a-icon-checkbox")]
    ...    //li[@id="p_123/241862"]//i[contains(@class,"a-icon-checkbox")]
    ...    //li[@id="p_123/247341"]//i[contains(@class,"a-icon-checkbox")]
    ...    //li[@id="p_123/378555"]//i[contains(@class,"a-icon-checkbox")]
    FOR    ${checkbox}    IN    @{list_of_value}
        Wait Until Element Is Visible    ${checkbox}    15s

        Scroll Element Into View         ${checkbox}
        Click Element                    ${checkbox}
        Log                              Selected checkbox: ${checkbox}
        Sleep  10s



    END
    @{laptop_elements}=    Get WebElements    css:h2[class*="a-size-medium"]
     FOR    ${lap}    IN    @{laptop_elements}
        ${name}=    Get Text    ${lap}
        Log    listofelachlaptops: ${name}
    END
#    scrolling action
#    Scroll Element Into View    id:navBackToTop
#    Sleep  10s
#    Log    elemnt is scroll
#    Execute Javascript    window.scrollTo(100, 200)
#    Sleep    10
#    Execute Javascript        window.scrollTo(0, -200)
#    Sleep  10
#    Execute Javascript        arguments[0].scrollIntoView(true)        id:navBackToTop
    [Teardown]    Close Browser


Scroll Amazon Page Example
    Open Browser        https://www.amazon.in/        ${browser}
    Maximize Browser Window
    Sleep  10s
    ${current_page}=    Get Title
    Log      ${current_page}
#FROM SLENIUM 3+ VERSION IN ROBOT FRAMEWORK IN WILL LIKE THIS AND NOT ALSO

#\$current_page tells RF: don’t substitute yet, treat it as a Python variable inside the expression.

    IF    'Online Shopping site' in $current_page
        Log    Page title contains Online Shopping site : ${current_page}

        # Scroll using Robot keyword
        Scroll Element Into View    id:navBackToTop
        Log    Element scrolled into view
        Sleep  2s

        # Scroll by pixel using JS
        Execute Javascript    window.scrollTo(0, 500)
        Sleep  1s
        Execute Javascript    window.scrollTo(0, 0)
        Sleep  3s


        Wait Until Element Is Visible    id:navBackToTop    15s
        Element Should Be Visible        id:navBackToTop
        # Scroll element into view using JS
        ${elem}=    Get WebElement    id:navBackToTop
        Execute Javascript    arguments[0].scrollIntoView(true)    ${elem}
        Sleep  1s
    END

    [Teardown]    Close Browser

alert handel and draganddrop
    Open Browser    https://the-internet.herokuapp.com/javascript_alerts        ${browser}
    Click Element        //button[text()='Click for JS Prompt']
    Mouse Over        id:element
    Input Text Into Alert        howareyou
#    deafult accept or we can do dismiss
    Handle Alert        action=DISMISS
    Handle Alert        action=ACCEPT
    Sleep  2s
    Alert Should Be Present    "the rewuired text"
    Close Browser



switchtoframe and dragand dropthe elemnt and explixtlywait and verfy ementattribute enable and diabled
    Open Browser     https://www.snapdeal.com/       ${browser}
    Maximize Browser Window
    ${VISIBLE}        Run Keyword And Return Status    Wait Until Element Is Visible        css:[data-cy="personalLogin"]        10s

    IF    ${VISIBLE}
        Input Text        css:[data-cy="userName"]            ${inout}
        ${attribute_values}=    Get Element Attribute    css:[data-cy="userName"]        value
        ${status}        Run Keyword And Return Status        Get Element Attribute    css:[data-cy="continueBtn"]    disabled
        Log     thestatusofthebutton${status}
        IF    '${inout}' == '${attribute_values}'
            Log    theebter things is reflecting:${attribute_values}

            ${status}    Run Keyword And Return Status        Element Should Be Enabled    css:[data-cy="continueBtn"]
            Should Be True    ${status}
        END

    ELSE
        Log   ELEMNT LOGIN IS NOT APPER

    END

    Click Element    css:div.sc-49edc83e-4.hZtcpr:nth-of-type(2)
    ${STATUS}=    Run Keyword And Return Status
    ...    Element Should Be Visible
    ...    css:div.sc-49edc83e-18.dbbJuN
    Should Be True    ${STATUS}
    IF    ${STATUS}
        Click Element        xpath://button[text()='LOGIN']
        Wait Until Element Is Visible        xpath://span[text()="Login/Sign Up On Snapdeal"]    10s
        Input Text    css:[placeholder="Mobile Number/ Email"]    ${inout}
        ${entered}=    Get Value    css:[placeholder="Mobile Number/ Email"]
        Should Be Equal    ${entered}    ${inout}
        Click Element    css:[class="LoginModal_closeButton__CeUI5"]
    END
    Mouse Over    xpath:(//div[text()='Home & Kitchen'])
    Click Element        //*[text()='Kitchen Storage']

    Wait Until Element Is Visible        xpath:(//*[normalize-space()='Storage & Thermoware'])[4]        5s
    Execute Javascript        window.scrollTo(0,  600)
    Capture Page Screenshot
    Mouse Over        css:[class="accountInner"]
    Element Should Be Visible    //div[@class="dropdownAccountNonLoggedIn"]
    Click Element        xpath://a[text()='login']
    Select Frame    id:loginIframe
#    Current Frame Should Contain        usegae for the textonlt
    Wait Until Element Is Visible    //header[text()='login/sign up on snapdeal']    5s
    Sleep  2s
    ${needto_diabled}        Get Element Attribute        xpath://*[contains(@class,"number-prefix-disable")]        class
    Input Text    css:[placeholder="Mobile Number/ Email"]    ${inout}

#lazy evaluation $needto_diabled

    ${attribute}    Get Element Attribute         xpath://*[contains(@class,"number-prefix")]     class
    Should Not Be Equal      ${attribute}     ${needto_diabled}
    Click Element    id:close-pop
    Unselect Frame
    Input Text        id:inputValEnter        ${inout}
    Capture Page Screenshot
    Mouse Over        css:.menuIconBar
    Click Element        xpath://*[text()="Men's Fashion"]
    @{parentwindowinfo}=    Get Window Handles
    ${parentwindowinfo}    Set Variable        ${parentwindowinfo}[0]
    Log   beforeopeningallwinodwithasonlyone:${parentwindowinfo}
    Click Element    xpath://*[text()='Suspenders']


#    helpstoscrolla and wiat for keyword scucessed
    Wait Until Keyword Succeeds    10s    500ms
    ...    Scroll Element Into View
    ...    xpath://img[@alt="Snapdeal Youtube Page"]


    Click Element    xpath://img[@alt="Snapdeal Youtube Page"]

    @{child_window}=    Get Window Handles

    FOR    ${EACH}    IN    @{child_window}
        IF    '${EACH}' != '${parentwindowinfo}'
            Switch Window    ${EACH}
            Wait Until Keyword Succeeds    10s    500ms    Title Should Not Be Empty
            ${child_titles}=    Get Title
            IF    'Suspender' in $child_titles
                Click Element    xpath://span[text()='add to cart']
                Wait Until Element Is Visible    css:.mess-text    5s

             ELSE IF    'YouTube' in $child_titles
                Log    YouTube child window: ${child_titles}
            END
        END
    END
    Switch Window    ${parentwindowinfo}


































*** Keywords ***


Title Should Not Be Empty
    ${title}=    Get Title
    Should Not Be Empty    ${title}

firstrobotocde for the testing
   [Arguments]    ${URL}    ${browser}
   Open Browser     ${URL}    ${browser}
#   Go To        https://www.amazon.in/
   Maximize Browser Window
   Wait Until Element Is Visible    id=twotabsearchtextbox
   Input Text       id=twotabsearchtextbox     laptops
   Click Element    id=nav-search-submit-button
   ${title}        Get Title
   Should Be Equal        ${title}         Amazon.in : laptops
   Title Should Be        ${title}    expected






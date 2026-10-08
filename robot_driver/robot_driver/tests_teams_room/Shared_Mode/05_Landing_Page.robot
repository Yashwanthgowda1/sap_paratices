*** Settings ***
Documentation   Validating the test cases realted to Landing Page feature
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1:[Landing Page] DUT user view the time, User name of the account , DID on the Landing screen
    [Tags]   238008   P2
    [Setup]  Testcase Setup for Meeting User     count=1
    Validate that signin is successfully completed    device_list=device_1     state=Sign in
    Verify user details present on landing page   device=device_1:meeting_user
    [Teardown]   Run Keywords   Capture on Failure   AND    Come back to home screen     device_list=device_1

TC2:[Landing Page] Verify Highlighted background , Teams Icon , Join button for current meeting
    [Tags]   238032   P1
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify home page screen     device=device_1
    View current meeting display on screen    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1

TC3:[Landing Page] DUT user able to navigate settings via Landing Page
    [Tags]  238012   P1
    [Setup]  Testcase Setup for Meeting User    count=1
    Navigate to more button and validate options   device=device_1
    Navigate to settings page   device=device_1
    Verify settings page options and validate   device=device_1:meeting_user
    [Teardown]   Run Keywords    Capture on Failure  AND    Landing Page Teardown   device=device_1

TC4:[Landing Page] DUT user able to increase and decrease the volume via Landing Page using More button
    [Tags]  238011    bvt   bvt_sm  sanity_sm
    [Setup]  Testcase Setup for Meeting User      count=1
    Navigate to more option  device=device_1
    Adjust volume button  device=device_1   state=UP
    Adjust volume button  device=device_1   state=Down
    [Teardown]   Run Keywords    Capture on Failure  AND    Navigate back to home screen page  device=device_1

TC5:[Landing Page] DUT user able navigate "Sign out" via Landing page
    [Tags]  238022    P2
    [Setup]  Testcase Setup for Meeting User      count=1
    Verify home page screen    device=device_1
    Navigate to app settings page   device=device_1
    Verify settings page options and validate   device=device_1:meeting_user
    Navigate back to home screen from settings page     device=device_1
    Sign out method    device=device_1
    [Teardown]  Run Keywords   Capture on Failure  AND   Sign in method     device=device_1     user=meeting_user

# Test obsolete, new cases for new report and isssue will be added
#TC6: [Landing Page] DUT user able navigate "Report an issue " via Landing Screen
#    [Tags]  238018    P2
#    [Setup]  Testcase Setup for Meeting User      count=1
#    Navigate to more button and validate options   device=device_1
#    Navigate to settings page   device=device_1
#    Verify settings page options and validate   device=device_1:meeting_user
#    Report an issue    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Landing Page Teardown   device=device_1

#TC7: [Landing Page] Further meeting should not be having Teams Icon
#    [Tags]  238034    P1   sanity_sm
#    [Setup]  Testcase Setup for Meeting User    count=1
#    Verify meeting display on home screen     device=device_1
#    Verify default option present on landing page and validate   device=device_1
#    Teams icon visibility for future meetings   device=device_1
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC6:[Landing Page] DUT user able navigate "Device Settings" via Landing Page
    [Tags]  238020   P2
    [Setup]  Testcase Setup for Meeting User      count=1
    Verify home page screen    device=device_1
    Navigate to app settings page    device=device_1
    verify option inside settings page   device=device_1:meeting_user
    verify options in device settings   device=device_1
    [Teardown]   Run Keywords   Capture on Failure  AND  Come back to home screen     device_list=device_1

# reference: Feature Test Request 451143: [FTR][MTRA] Remove calling admin settings
#TC9: [Landing Page] DUT user able navigate "calling" via Landing Page
#    [Tags]   238015     P2
#    [Setup]    Testcase Setup for Meeting User   count=1
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    verify options in device settings calling    device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND         Come back to home screen    device_list=device_1

TC7:[Landing Page] DUT user able navigate "about" via Landing page
    [Tags]     238019        bvt_sm      sanity_sm
    [Setup]    Testcase Setup for Meeting User   count=1
    Navigate to about page  device=device_1
    Verify about page  device=device_1
    Click back btn    device=device_1
#   click close btn     device_list=device_1
    [Teardown]   Run Keywords   Capture on Failure  AND    Come back to home screen    device_list=device_1

TC8:[Landing Page] Verify the further meeting.
    [Tags]     238033       P2
    [Setup]    Testcase Setup for Meeting User   count=1
    Verify home page screen    device=device_1
    verify chevron or further meeting     device=device_1
    [Teardown]   Run Keywords   Capture on Failure  AND    Come back to home screen    device_list=device_1

*** Keywords ***
Landing Page Teardown
    [Arguments]     ${device}
    Click close btn    device_list=${device}
    Come back to home screen    device_list=${device}

Verify settings page options and validate
    [Arguments]     ${device}
    Verify option inside settings page  ${device}

Test Case Teardown
    [Arguments]     ${device}
    Click back btn   ${device}
    Click back btn   ${device}
    Come back to home screen    device_list=${device}

Navigate to settings page
    [Arguments]     ${device}
    Click on settings page    ${device}

Verify default option present on landing page and validate
    [Arguments]     ${device}
    Verify home page screen    ${device}

Navigate to more option
    [Arguments]     ${device}
    Click on more option   ${device}

Navigate back to home screen page
    [Arguments]     ${device}
    Click on settings page    ${device}
    Click close btn    device_list=${device}
    Come back to home screen    device_list=${device}

Navigate back to home screen from settings page
    [Arguments]      ${device}
    Click close btn    device_list=${device}
    Come back to home screen    device_list=${device}

verify options in device settings
    [Arguments]      ${device}
    navigate to meetings option in device settings page    ${device}
    come back from admin settings page      device_list=${device}

navigate calling option
    [Arguments]       ${device}
    navigate to teams admin settings   ${device}
    verify calling option in device settings page     ${device}

verify chevron or further meeting
    [Arguments]     ${device}
    Verify meeting display on home screen     ${device}
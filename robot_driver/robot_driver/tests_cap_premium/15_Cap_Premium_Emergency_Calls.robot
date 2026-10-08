*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown      Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Advance calling][Emergency Calling] DUT to auto dial the emergency number once the number is recognized as an emergency number
    # Dial 933 for Emergency Calling
    [Tags]  329314      P1     Sanity_CAPPremium
    [Setup]   Testcase Setup for CAP Premium User     count=1
    Click on calls tab      device=device_1
    Dial emergency num and validate    device=device_1
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1


TC2 : [Advance calling][Emergency Calling] Emergency number dialed is recognized as an Emergency call and appropriate notification is displayed in the call screen.
    # Dial 933 for Emergency Calling
    [Tags]  329313     P1     Sanity_CAPPremium
    [Setup]   Testcase Setup for CAP Premium User     count=1
    Click on calls tab      device=device_1
    Dial emergency num and validate    device=device_1
    Validate notification displayed on the screen     device=device_1:cap_search_enabled
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC3 : [Advance calling][E911] Sign in to make an emergency call
    [Tags]   329309    P1     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User     count=1
    sign out method    device_1
    Verify sign in to make an emergency call    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND     sign in method     device_1     user=cap_search_enabled

TC4 :[Advance calling][E911] Verify E911 call support
    [Tags]   329311     P2
    [Setup]   Testcase Setup for CAP Premium User     count=1
    Click on calls tab     device=device_1
    Dial emergency num and validate    device=device_1
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

*** Keywords ***
Advance calling Setup
    Verify and enable advance calling option       device=device_1

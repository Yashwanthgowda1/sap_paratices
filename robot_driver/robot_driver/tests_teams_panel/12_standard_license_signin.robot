*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1:[Standard license account sign in] Verify the DUT user should be able to sign in with Standard license account
    [Tags]  341675
    [Setup]  Testcase Setup for standard license User for panel  count=1
    verify room parameters      device=device_1:standard_user
    [Teardown]  Capture on Failure

TC2:[Standard license account sign in]Verifying "Standard license information" Displaying in about page.
    [Tags]  341678
    [Setup]  Testcase Setup for standard license User for panel  count=1
    Navigation to settings page in panel  device=device_1
    verify about option in panel  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
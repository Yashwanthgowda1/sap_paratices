*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1:[Premium license account sign in] Verify the DUT user should be able to sign in with Premium license account
    [Tags]  341673
    [Setup]  Testcase Setup for premium license User for panel  count=1
    verify room parameters      device=device_1:premium_user
    [Teardown]  Capture on Failure

TC2:[Premium license account sign in]Verifying "Premium license information" Displaying in about page.
    [Tags]  341674
    [Setup]  Testcase Setup for premium license User for panel  count=1
    Navigation to settings page in panel  device=device_1
    verify about option in panel  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3:[Premium license account sign in]Verify that DUT user should able to sign-in with Premium license account
    [Tags]  393066    sanity
    [Setup]  Testcase Setup for premium license User for panel  count=1
    verify room parameters      device=device_1:premium_user
    [Teardown]  Capture on Failure
*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***
${5_minutes_wait_time} =  5 minutes

*** Test Cases ***
TC1:[Auth] Verify DUT user is Sign in back with the same account via Web Sign after a Manual Sign out from the settings
    [Tags]  435546  sanity
    [Setup]  Testcase Setup  count=1
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    signin method with dcf code    device=device_1    user=user
    [Teardown]  Capture on Failure

TC2:[Auth]Verify Web Sign-In using new DCF code after expiring the existing DCF code.
    [Tags]  435542  sanity      bvt      bvt_panels
    [Setup]  Testcase Setup  count=1
    sign out method  device=device_1
    ${old_dfc_code}=     fetch dfc code      device=device_1
    verify ztp signin ui    device=device_1
    Wait for Some Time    time=${5_minutes_wait_time}
    ${new_dfc_code}=     fetch dfc code      device=device_1
    Validate dfc code    ${old_dfc_code}    ${new_dfc_code}    device=device_1    status=different
    signin method with dcf code    device=device_1    user=user
    [Teardown]  Capture on Failure
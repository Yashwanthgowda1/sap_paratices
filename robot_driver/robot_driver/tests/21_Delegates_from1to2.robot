*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation      Suite Setup Requirements : This suite requires minimum of 2 devices in config
...                Purpose: Device_1 should add Device_2:delegate_user as Delegate.

Suite Setup    Delegates Suite Setup
Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =      5

*** Test Cases ***
TC1: [App Settings] Verify Teams App user able to add delegate
    [Tags]    310349     P2  alt_credentials
    [Setup]    Testcase Setup for Delegate User  count=2
    verify added delegate user with presence in favorites page      from_device=device_1    to_device=device_2:delegate_user
    [Teardown]  run keywords  Capture on Failure       AND    Come back to home screen   device_list=device_1,device_2

TC2: [SLA] Verify that options present inside the triple dot(...) option beside each Your Delegates contacts.
    [Tags]      416823    P1   sanity_tp
    [Setup]  Testcase Setup for Delegate User  count=2
    Verify delegates in favorites page     device=device_1
    verify added delegate user with presence in favorites page      from_device=device_1    to_device=device_2:delegate_user
    Validate delegate view permissions on favorites page    device=device_1
    enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls
    [Teardown]   Run Keywords    Capture on Failure    AND   come back home screen for user   count=2

TC3: [SLA]Verify the options under Delegation Setting page
    [Tags]      416706     P2
    [Setup]  Testcase Setup for Delegate User  count=2
    Navigate to Calls Favorites page    device=device_1
    refresh calls main tab  device=device_1
    verify added delegate user with presence in favorites page      from_device=device_1    to_device=device_2:delegate_user
    Navigate to Calls Favorites page    device=device_2
    favorites module sanity     device_list=device_2
    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC4: [SLA]Verify that DUT user add Delegates sucessfully.
    [Tags]   345591      P2
    [Setup]  Testcase Setup for Delegate User  count=2
    verify added delegate user with presence in favorites page      from_device=device_1    to_device=device_2:delegate_user
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen   device_list=device_1,device_2

TC5: [SLA]Verify boss username should display under "people u support" in delegates user while delegate is added in Boss.
    [Tags]      345632     P2
    [Setup]  Testcase Setup for Delegate User  count=3
    Verify delegates in favorites page     device=device_1
    Navigate to Calls Favorites page    device=device_2
    favorites_module_sanity     device_list=device_2
    verify added delegate user with presence in favorites page      from_device=device_1    to_device=device_2:delegate_user
    verify user in people you support with presence in favorites_page       from_device=device_2    to_device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2


*** Keywords ***
Delegates Suite Setup
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_2:delegate_user
    return to home screen     device_list=device_1
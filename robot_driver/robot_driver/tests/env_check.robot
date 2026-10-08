*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =      10s


*** Test Cases ***
Environment Setup Check
    [Tags]  env_check  alt_credentials    env_check_1       exclude_ftp
    [Setup]  Testcase Setup    count=2
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify name of caller and receiver displayed    from_device=device_1      to_device=device_2
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2

TC1: [Scenarios] Test Signin with other user
    [Tags]  scenarios_2p  alt_credentials      env_check_1      exclude_ftp
    [Setup]  Testcase Setup    count=2
    Signin with other user    device=device_1   other_user_account=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2

TC2: [Scenarios] Signin-P2P Call-SignOut/In other-P2P Call wait 10-SignOut
    [Tags]  scenarios_3p  alt_credentials    env_check_1       exclude_ftp
    [Setup]  Testcase Setup    count=3
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=10s
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Signin with other user    device=device_1   other_user_account=device_3
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=10s
    Verify Call State    device_list=device_1,device_2    state=Connected
    Wait for Some Time    time=10 minutes
    Disconnect call     device=device_1
    Sign out method    device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3

*** Keywords ***
Test Case Teardown
    [Arguments]     ${devices}
    Come back to home screen     ${devices}

*** Settings ***
Documentation    Validating Scenario with two console setup
Library     DateTime
Resource    ../../resources/keywords/common.robot

Suite Setup   Two Console Setup For Shared Mode
Suite Teardown    Teams Console Setup For Shared Mode

*** Variables ***

*** Test Cases ***
TC1:[Escalate to conference] DUT user can add TDC user while in call with another DUT user
    [Tags]    444717    P1     sanity_tc_sm     exclude_ftp_sm
    [Setup]  Testcase Setup for Shared User with consoles   count=3
    Place an outgoing call using dial pad    from_device=console_1     to_device=console_2:user
    Pick up incoming call    console=console_2
    Verify for call state     console_list=console_1,console_2       state=Connected
    Add participant to the conversation using display name   from_device=console_1    to_device=device_3
    Accept incoming call      device=device_3
    Verify for meeting state     console_list=console_1,console_2    device_list=device_3    state=Connected
    Verify and view list of participant     console=console_1
    End the meeting      console=console_1,console_2
    Verify for meeting state    console_list=console_1,console_2      device_list=device_3      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1,console_2   device_list=device_3

TC2:[Escalate to conference] DUT user can add PSTN user while in call with another DUT user
    [Tags]    444720    P1     sanity_tc_sm     exclude_ftp_sm
    [Setup]   Testcase setup for shared mode PSTN Setup with consoles    count=3
    Place an outgoing call using dial pad    from_device=console_1    to_device=console_2
    Pick up incoming call    console=console_2
    Verify for call state     console_list=console_1,console_2       state=Connected
    add participant to the conversation   from_device=console_1    to_device=device_3:pstn_user    method=phone_number
    Accept incoming call      device=device_3
    Verify for meeting state     console_list=console_1,console_2    device_list=device_3    state=Connected
    Verify and view list of participant     console=console_1
    End the meeting      console=console_1,console_2
    Verify for meeting state    console_list=console_1,console_2      device_list=device_3      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1,console_2   device_list=device_3

TC3:[Escalate to conference]DUT user can add another DUT user while in call with PSTN user
    [Tags]    444721    P1     sanity_tc_sm     exclude_ftp_sm
    [Setup]   Testcase setup for shared mode PSTN Setup with consoles    count=3
    Place an outgoing call using dial pad    from_device=console_1     to_device=device_3:pstn_user
    Verify for call state     console_list=console_1    device_list=device_3       state=Connected
    add participant to the conversation   from_device=console_1    to_device=device_2    method=phone_number
    Pick up incoming call    console=console_2
    Verify for meeting state     console_list=console_1    device_list=device_2,device_3    state=Connected
    End the meeting      console=console_1,console_2
    Verify for meeting state    console_list=console_1,console_2      device_list=device_3      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1,console_2   device_list=device_3

*** Keywords ***
Two Console Setup For Shared Mode
    Sign Out Console    console_list=console_2
    Sign Out    device_list=device_2
    Sign In    device_list=device_2    user_list=user
    Sign In Console    console_list=console_2    user_list=user
    Get device pairing code    device_list=device_2    console_list=console_2     user_list=user

Teams Console Setup For Shared Mode
     Sign Out Console    console_list=console_2
     Sign Out    device_list=device_2
     Sign In    device_list=device_2    user_list=user

*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1:[Escalate to conference] DUT user can add another TDC user while in call with TDC user
    [Tags]    444719    sanity_tc_sm    P1
    [Setup]  Testcase Setup for shared User   count=3
    Make outgoing call using dial pad    from_device=console_1     to_device=device_2
    Accept incoming call      device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Add participant to the conversation using display name   from_device=console_1    to_device=device_3
    Accept incoming call      device=device_3
    Wait for Some Time    time=${wait_time}
    Verify for call state     console_list=console_1    device_list=device_2,device_3    state=Connected
    Verify and view list of participant     console=console_1
    Hang up call     console=console_1     device=device_3
    Verify for call state    console_list=console_1    device_list=device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC2:[Escalate to conference] DUT user can add another DUT user while in call with TDC user
    [Tags]    444718    bvt_tc_sm    sanity_tc_sm    P0
    [Setup]  Testcase Setup for shared User   count=3
    Make outgoing call using dial pad    from_device=console_1     to_device=device_2
    Accept incoming call      device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Add participant to the conversation using display name   from_device=console_1    to_device=device_3
    Accept incoming call      device=device_3
    Verify for call state     console_list=console_1    device_list=device_2,device_3    state=Connected
    Verify and view list of participant     console=console_1
    Hang up call     console=console_1     device=device_3
    Verify for call state    console_list=console_1    device_list=device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC3:[Escalate to conference] Check participant's profile while adding to the call
    [Tags]    444723    P2
    [Setup]  Testcase Setup for shared User   count=3
    Make outgoing call using dial pad    from_device=console_1     to_device=device_2
    Accept incoming call           device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Add participant to conversation using display name           from_device=console_1      to_device=device_3
    Accept incoming call          device=device_3
    Close participants screen         device=console_1
    Verify and view list of participant     console=console_1
    Hang up call     console=console_1     device=device_3
    Verify for call state    console_list=console_1    device_list=device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

*** Keywords ***
Hang up call
    [Arguments]    ${console}    ${device}
    Disconnect the call    console=${console}
    Disconnect call     device=${device}
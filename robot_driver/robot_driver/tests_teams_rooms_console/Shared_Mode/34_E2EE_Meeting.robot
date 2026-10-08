*** Settings ***
Documentation   Validating the functionality of E2EE meeting Feature.
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

Suite Setup    set up e2ee meeting    participant=device_1,device_2
Suite Teardown    Run Keywords   Suite Failure Capture    AND       delete the meeting  device=tdc_1:meeting_user    meeting_name=e2ee

*** Test Cases ***
TC1:[E2EE] Verify Non-E2EE meeting UI on console
    [Tags]    444305    sanity_tc_sm    P1
    [Setup]   Testcase Setup for User     count=2
    Start meeting using meet now   from_device=console_1    to_device=device_2
    Accept incoming call    device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Verify ui non e2ee meeting    device=console_1     is_console=True
    End the meeting        console=console_1
    End meeting      device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC2:[E2EE][Pro] Verify the chat panel when TDC created a meeting by enabled E2EE option.
    [Tags]    444315     sanity_tc_sm    P1
    [Setup]      Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=e2ee
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify ui e2ee meeting     device=device_1
    Verify security code e2ee    device=device_1,device_2
    Enable and disable the chat toggle in meeting   device=device_1   state=on
    verify e2ee message popup       device=device_1
    End a meeting     console=console_1       device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC3:[E2EE][Pro] Verify the options in the created meeting with enabled E2EE option.
    [Tags]    444320    bvt_tc_sm       sanity_tc_sm
    [Setup]      Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=e2ee
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify ui e2ee meeting     device=device_1
    Verify security code e2ee    device=device_1,device_2
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC4:[E2EE][Pro] Verify the shield icon with lock in ubar when meeting initiated via meet now
    [Tags]   444379      bvt_tc_sm       sanity_tc_sm
    [Setup]   Testcase Setup for shared User   count=2
    Start meeting using meet now    from_device=console_1    to_device=device_2
    Accept incoming call      device=device_2
    Wait for Some Time    time=${wait_time}
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    verify absence of e2ee shield title and lock        device=device_1
    End a meeting     console=console_1       device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2

*** Keywords ***
set up e2ee meeting
    [Arguments]     ${participant}
    initiate web driver     tdc_1
    perform web signin method       tdc_1:meeting_user
    create TDC meeting on desktop      device=tdc_1      meeting_name=e2ee      participants=${participant}          time_duration=1 hr     all_day_meeting=off        e2ee=on      use_current_time=True

delete the meeting
    [Arguments]         ${device}    ${meeting_name}
    initiate web driver     ${device}
    perform web signin method       ${device}
    right click on created meeting from tdc       ${device}       ${meeting_name}
    delete meeting from tdc    ${device}
    close web driver    ${device}

End a meeting
    [Arguments]    ${console}    ${device}
    End the meeting  ${console}
    End meeting      ${device}
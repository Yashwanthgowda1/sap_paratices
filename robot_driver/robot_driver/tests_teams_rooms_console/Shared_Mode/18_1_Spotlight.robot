*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Test Cases ***
TC1:[Spotlight] TDC user enable spotlight on the DUT user
    [Tags]    315212    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify video preview on screen  device=device_1
    Make a spotlight   from_device=device_2   to_device=console_1:meeting_user      device_type=console
    verify spotlight text on device   device=console_1     text=spotlight
    Close participants screen   device=device_2
    Verify spotlight icon on top left in the meeting  device=device_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC2:[Spotlight] Avatar should be displayed on the screen if the video turned off during the spotlight
    [Tags]    315218    P1    sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=3
    Join a meeting   console=console_1     device=device_2,device_3    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2,device_3    state=Connected
    Verify and view list of participant    console=console_1
    Verify video preview on screen  device=device_1
    make a spotlight   from_device=device_2   to_device=device_3
    verify spotlight text on device   device=device_3   text=spotlight
    verify spotlight icon on main screen in the meeting    device=device_1
    Close participants screen   device=device_2
    disable video call   device=device_3
    verify spotlight icon    device=device_3
    Verify spotlight icon on top left in the meeting  device=device_3
    enable video call    device=device_3
    verify spotlight icon    device=device_3
    End a meeting     console=console_1       device=device_2,device_3
    Verify for meeting state    console_list=console_1      device_list=device_2,device_3      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

*** Keywords ***
End a meeting
    [Arguments]    ${console}    ${device}
    End the meeting  ${console}
    End meeting      ${device}


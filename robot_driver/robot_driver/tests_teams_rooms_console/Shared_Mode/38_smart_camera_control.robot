*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Test Cases ***
TC1:[Automatic Framing] Verify the Automatic Framing toggle button under Room Camera.
    [Tags]    381414    P2
    [Setup]   Testcase Setup for shared User     count=1
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    navigate to automatic framing under teams admin settings     device=console_1
    verify automatic framing options    device=console_1
    Come back from admin settings page    device_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC2:[Automatic Framing] Verify the options under Automatic Framing when DUT user disables the toggle button.
    [Tags]      381415      bvt_tc_sm     sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=1
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    navigate to automatic framing under teams admin settings     device=console_1
    Enable and disable automatic framing toggle     device=console_1    state=off
    verify automatic framing options are disabled       device=console_1
    Come back from admin settings page     device_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC3:[Automatic Framing] Verify the options under the content camera under Teams App Settings.
    [Tags]      381416     P2
    [Setup]   Testcase Setup for shared User     count=1
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    navigate to content camera under teams admin settings     device=console_1
    verify no option is present under content camera    device=console_1
    Come back from admin settings page     device_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC4:[Automatic Framing] Verify the Automatic Framing option when DUT user joined the meeting.
    [Tags]      381417     P2
    [Setup]   Testcase Setup for shared User     count=1
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    navigate to automatic framing under teams admin settings     device=console_1
    Enable and disable automatic framing toggle     device=console_1    state=on
    Come back from admin settings page    device_list=console_1
    Join a meeting   console=console_1     device=device_2   meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    verify and click drop down icon in call control bar      device=console_1
    verify automatic framing options    device=console_1
    End up call     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC5:[Automatic Framing] Verify Automatic Framing option is available in Meet now Meetings.
    [Tags]      381420     P2
    [Setup]   Testcase Setup for shared User     count=2
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    navigate to automatic framing under teams admin settings     device=console_1
    Enable and disable automatic framing toggle     device=console_1    state=on
    Come back from admin settings page    device_list=console_1
    Start meeting using meet now    from_device=console_1    to_device=device_2
    Accept incoming call      device=device_2
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    verify and click drop down icon in call control bar      device=console_1
    verify automatic framing options    device=console_1
    End up call     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC6:[Automatic Framing] Verify DUT is not displaying Camera Drop down option when Disabled from Admin setting.
    [Tags]   381427          P1
    [Setup]   Testcase Setup for shared User     count=2
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    navigate to automatic framing under teams admin settings     device=console_1
    Enable and disable automatic framing toggle     device=console_1    state=off
    verify automatic framing options are disabled       device=console_1
    Come back from admin settings page     device_list=console_1
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    verify drop down icon in call control bar is present or not    device=console_1    state=on
    End up call     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC7:[Automatic Framing] Verify Automatic Framing option, when Composite is selected from admin settings.
    [Tags]   381418     sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=2
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    navigate to automatic framing under teams admin settings     device=console_1
    Enable and disable automatic framing toggle     device=console_1    state=on
    select option under automatic framing    device=console_1    option=composite
    verify selected option under automatic framing      device=console_1    option=composite
    Come back from admin settings page     device_list=console_1
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    verify and click drop down icon in call control bar     device=console_1
    select automatic framing option under call control bar    device=console_1    option=active_speaker
    End up call     console=console_1       device=device_2
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    navigate to automatic framing under teams admin settings     device=console_1
    Enable and disable automatic framing toggle     device=console_1    state=on
    verify selected option under automatic framing      device=console_1    option=composite
    Come back from admin settings page     device_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC8:[Room Camera] Verify Default camera in an ongoing meeting when no external camera is connected.
    [Tags]      381455     P2
    [Setup]   Testcase Setup for shared User     count=2
    ${room_camera_support}   room camera supported devices   device=device_1
    pass execution if   '${room_camera_support}'=='False'  console_1, console_1 is not supported for room camera
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    User click room camera      device=console_1
    Verify default and external cam names   device=console_1     camera_type=default
    Come back from admin settings page     device_list=console_1
    Verify meeting display on home screen     device=console_1
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    verify and click drop down icon in call control bar      device=console_1
    verify default camera       device=console_1
    End up call     console=console_1       device=device_2
    Verify for meeting state     console_list=console_1      device_list=device_2   state=Disconnected
    Come back from admin settings page     device_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1


*** Keywords ***
Verify room camera option under teams admin settings
    [Arguments]     ${console}
    Verify the options inside the devices       device=${console}

Navigate to app settings screen
    [Arguments]   ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Verify content camera option under teams admin settings
    [Arguments]     ${console}
    Verify the options inside the devices       device=${console}

Enable automatic framing toggle
    [Arguments]    ${device}    ${state}
    navigate to automatic framing under teams admin settings    ${device}
    Enable and disable automatic framing toggle     ${device}       ${state}

End up call
    [Arguments]    ${console}    ${device}
    Disconnect the call  ${console}
    Disconnect call     ${device}

Dismiss the pop-up
    [Arguments]    ${device}
    dismiss the popup screen    ${device}
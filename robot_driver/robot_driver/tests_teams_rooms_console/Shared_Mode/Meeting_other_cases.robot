*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1:[Chat Bubbles] Don't show chat bubble enables/Show chat bubbles should be visible on more options in meeting or call on console.
    [Tags]    345336    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=3
    Join a meeting   console=console_1     device=device_2,device_3    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2,device_3     state=Connected
    Verify chat bubbles option on call control bar      console=console_1
    End a meeting     console=console_1       device=device_2,device_3
    Verify for meeting state    console_list=console_1      device_list=device_2,device_3      state=Disconnected
    Make outgoing call using dial pad    from_device=console_1     to_device=device_2
    Accept incoming call      device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Verify chat bubbles option on call control bar      console=console_1
    Disconnect call     device=device_2
    Verify for call state     console_list=console_1     device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC2:[QR Code] Verify the functionality of QR Code when it is disabled from General settings
    [Tags]    452104    P1    sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=1
	Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1  option=general
	Verify option under Wireless connection       device=console_1
	Disable the QR code toggle and verify QR code scanner on device    device=console_1     activity_state=off
	Enable QR code and proximity based meeting      console=console_1
	Come back from admin settings page    device_list=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC4:[Norden][Wallpaper Theme]Verify Wallpapers is available under Admin Settings for shared accounts
    [Tags]    322549    bvt_tc_sm    sanity_tc_sm
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=general
    verify inside general option    console=console_1
    Come back from admin settings page    device_list=console_1
    [Teardown]  Run Keywords   Capture Failure     AND     Come back to home screen page   console_list=console_1

TC5:[Chat Bubbles] Verify during a call or meeting click on more options then by default "Don't show chat bubble" should be seen on console.
    [Tags]    345353    P1    sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=2
    Make outgoing call using dial pad    from_device=console_1     to_device=device_2
    Accept incoming call      device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    verify do not show chat bubbles option on call control bar      console=console_1
    Disconnect call     device=device_2
    Verify for call state     console_list=console_1     device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC6:[Content Camera] Verify TC user is Displaying Content Camera option under Teams Admin Setting
    [Tags]  380916    P1    sanity_tc_sm
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    Verify content camera option under teams admin settings     console=console_1
    Come back from admin settings page    device_list=console_1
    [Teardown]  Run Keywords   Capture Failure     AND     Come back to home screen page   console_list=console_1

TC7:[Automatic Framing] Verify the Room Camera under the Teams App Settings.
    [Tags]    381412    bvt_tc_sm    sanity_tc_sm
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    Verify room camera option under teams admin settings     console=console_1
    Come back from admin settings page    device_list=console_1
    [Teardown]  Run Keywords   Capture Failure     AND     Come back to home screen page   console_list=console_1

TC8:[Content Camera] Verify Options displayed under Teams Admin setting devices.
    [Tags]    380917    P1    sanity_tc_sm
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    Verify the options inside the devices       device=console_1
    Come back from admin settings page    device_list=console_1
    [Teardown]  Run Keywords   Capture Failure     AND     Come back to home screen page   console_list=console_1

TC9:[MTRA+TC] Verify private meeting join From console screen
    [Documentation]  While creating the meeting need to click on private mode
    [Tags]    444756    P2
    [Setup]   Testcase Setup for shared User    count=1
    Verify meeting display on home page   console=console_1
    Join a meeting   console=console_1      meeting=Private meeting
    Verify for call state     console_list=console_1      state=Connected
    End the meeting     console=console_1
    Verify for call state     console_list=console_1      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC10:[Room Camera]Verify DUT is displaying Devices option under the teams admin settings.
    [Tags]    381453    P1    sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=1
	Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1  option=devices
	Verify room camera option under admin settings  device=console_1
    Come back from admin settings page    device_list=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC11:[Wallpaper]Verify default wallpaper
    [Tags]      322569      P2
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=general
    verify inside general option    console=console_1
    verify default wallpaper    device=console_1
    Come back from admin settings page    device_list=console_1
    [Teardown]  Run Keywords   Capture Failure     AND     Come back to home screen page   console_list=console_1

TC12:[Room Remote] Enable Room Remote
    [Tags]    315543    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=1
	Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1  option=general
	verify room remote option under admin settings  device=console_1
	Validate the functionality of room remote toggle btn  device=console_1    state=on
    Come back from admin settings page    device_list=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

*** Keywords ***
End a meeting
    [Arguments]    ${console}    ${device}
    End the meeting  ${console}
    End meeting      ${device}

Navigate to app settings screen
    [Arguments]   ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Disable the QR code toggle and verify QR code scanner on device
    [Arguments]   ${device}     ${activity_state}
    enable and disable qrcode toggle    ${device}     ${activity_state}     device_name=device_1

Enable QR code and proximity based meeting
    [Arguments]     ${console}
	enable and disable qrcode toggle    device=${console}      activity_state=on
	enable and disable proximity based toggle   device=${console}    activity_state=on

Verify content camera option under teams admin settings
    [Arguments]     ${console}
    Verify the options inside the devices       device=${console}

Verify room camera option under teams admin settings
    [Arguments]     ${console}
    Verify the options inside the devices       device=${console}


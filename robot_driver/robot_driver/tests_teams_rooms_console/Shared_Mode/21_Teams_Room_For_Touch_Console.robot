*** Settings ***
Documentation   Validating the functionality of console App settings feature.
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1:[Teams Room for Touch] Under "Front of room display" section "Wallpaper" & "Whiteboard" in console & FoR for shared account
    [Tags]    333373    P2
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to app settings screen page    console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=general
    verify inside general option    console=console_1
    Come back from admin settings page      device_list=console_1
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1

TC2:[Teams Rooms for Touch][Console] Verify that "Enable if the room has touchscreen displays" toggle must be turned off by default when touch screen is not connected.
    [Tags]    325483    P2
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to app settings screen page    console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=general
    Verify enable touchscreen controls with toggle    console=console_1
    Come back from admin settings page      device_list=console_1
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1

TC3:[Teams Rooms for Touch][Console] Verify that "General" section must be present under Admin settings for shared accounts
    [Tags]    325484    P2
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to app settings screen page    console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=general
    Come back from admin settings page      device_list=console_1
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1

TC4:[Teams Room for Touch] Under "General" section "Front of room display" section must be listed in console for shared account
    [Tags]    325485    P2
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to app settings screen page    console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=general
    Come back from admin settings page      device_list=console_1
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1

TC5:[Teams Rooms for Touch] Intent for "Enable Touchscreen Control" toggle On/Off
    [Tags]    345564    P1    sanity_tc_sm
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to app settings screen page    console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=general
    modify touchscreen control toggle state     console=console_1   state=disabled
    verify intents for touchscreen control      device=console_1          state=disabled
    modify touchscreen control toggle state     console=console_1   state=enabled
    verify intents for touchscreen control      device=console_1          state=enabled
    Come back from admin settings page      device_list=console_1
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1

TC6:[Teams Room for Touch] Under "Front of room display" section “Enable touch screen controls” must be listed when console is connected
    [Tags]    334153    P1    sanity_tc_sm
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to app settings screen page    console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=general
    verify inside general option    console=console_1
    Come back from admin settings page      device_list=console_1
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1

TC7:[Teams Room for Touch] “Enable touch screen controls” must have icon and toggle "Enable if the room has touchscreen displays." listed under it
    [Tags]    334154    P2
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to app settings screen page    console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=general
    verify inside general option    console=console_1
    Verify enable touchscreen controls with toggle    console=console_1
    Come back from admin settings page      device_list=console_1
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1

TC8:[Teams room for touch] Check for the accept option on FoR when TDC calls DUT
    [Tags]    348036    P2
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to app settings screen page    console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=general
    modify touchscreen control toggle state     console=console_1   state=enabled
    Come back from admin settings page      device_list=console_1
    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
    Verify incoming call        device=device_1,console_1       status=appear
    Verify accept call on msg should not get on device      device=device_1
    pick up incoming call    console=console_1
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Disconnect the call      console=console_1
    Verify for call state     console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1

TC9:[Pairing without code] Verify toggle option to be enabled by default in console
    [Tags]      437300      P1      sanity_tc_sm
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to app settings screen page    console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    Verify the auto pair toogle in console      console=console_1       state=on
    Come back from admin settings page      device_list=console_1
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1

TC10:[Teams Rooms for Touch][Console] When DUT and console are paired, DUT user must be able to turn ON/OFF toggle "Enable if the room has touchscreen displays". Toggle must be functional.
    [Tags]      325481      P1      sanity_tc_sm
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to app settings screen page    console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=general
    modify touchscreen control toggle state     console=console_1   state=enabled
    Verify home page screen    device=device_1
    Come back from admin settings page      device_list=console_1
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1

TC11:[Teams Rooms for Touch][Console] Under "Front of room display" section "Wallpaper" must be listed in console for shared account
    [Tags]    325482    P2
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to app settings screen page    console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=general
    verify inside general option    console=console_1
    modify touchscreen control toggle state     console=console_1   state=enabled
    Come back from admin settings page      device_list=console_1
    Navigate to teams admin settings page   device=device_1
    verify wallpaper page in teams admin setting    device=device_1
    Click close btn     device_list=device_1
	come back from admin settings page  device_list=device_1
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1

TC12:[Teams Rooms for Touch] DUT user must be able to select and apply any wallpaper from wallpaper section which is listed under Settings > General > Front of room display > wallpaper
    [Tags]    325478    P2
    [Setup]  Testcase Setup for shared User     count=1
    Verify time display on home screen   console=console_1
    Navigate to team admin setting and change wallpaper     wallpaper=seaside_bliss
    Verify Presence Of Intents    device=device_1    feature=seaside_bliss    state=present
    Verify Presence Of Intents    device=console_1    feature=seaside_bliss    state=present
    get screenshot      name=seaside_bliss_applied   device_list=console_1
    [Teardown]  Run Keywords   Capture Failure  AND   Navigate to team admin setting and change wallpaper     wallpaper=vivid    AND    Come back to home screen page   console_list=console_1

TC13:[Teams Room for Touch] When DUT is paired with console and console user turn ON toggle "Enable if the room has touchscreen displays" and non touch display screen is connected then icons must not be displayed on display screen
    [Tags]    333375    P1
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to app settings screen page    console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=general
    verify inside general option    console=console_1
    modify touchscreen control toggle state     console=console_1   state=enabled
    Come back from admin settings page      device_list=console_1
    Verify home page screen    device=device_1
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1

TC14:[Teams Rooms for Touch] Under "Front of room display" section “Enable touch screen controls” must not be listed when console is not connected
    [Tags]    325479    P2
    [Setup]  Testcase Setup for shared User     count=1
    Unpair console    console=console_1
    navigate to teams admin settings page   device=device_1
    navigate to general option    device=device_1
    verify enable touchscreen controls with toggle under general  device=device_1  
	come back from admin settings page  device_list=device_1
    [Teardown]  Run Keywords   Capture Failure  AND   pair console     AND   Come back to home screen page   console_list=console_1

*** Keywords ***
Navigate to app settings screen page
    [Arguments]     ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Navigate back to settings screen
    [Arguments]     ${console}
    come_back_from_admin_settings_page      device_list=${console}

Navigate to app settings page
    [Arguments]     ${device}
    Click on more option   ${device}
    Click on settings page   ${device}

Navigate to teams admin settings page
    [Arguments]    ${device}
    Navigate to app settings page    ${device}
    navigate to teams admin settings      ${device}

Unpair console
   [Arguments]     ${console}
   Navigate to app settings page     device=${console}
   Navigate to meeting and calling options from device settings page       console=${console}  option=devices
   Verify and click on unpairing option    console=${console}

pair console
    Sign In Console    user_list=meeting_user
    Get device pairing code    device_list=device_1    console_list=console_1     user_list=meeting_user
    Verify signin is successful    console_list=console_1     state=Sign in

Navigate to team admin setting and change wallpaper
    [Arguments]     ${wallpaper}
    Navigate to app settings screen page    console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=general
    verify inside general option    console=console_1
    change wallpaper on console    console=console_1    wallpaper=${wallpaper}
    Come back from admin settings page      device_list=console_1

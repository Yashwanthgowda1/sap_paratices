*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_time} =  3
${action_time} =  5

*** Test Cases ***
TC1:[HDMI_Auto share]Verify user set prerequisites are reseted after sign out and Sign in on the device
    [Tags]    344883    P2
    [Setup]  Testcase Setup for shared User      count=1
    navigate to HDMI content sharing option inside admin setting    console=console_1    option=meeting
    Enable and disable hdmi content sharing     device=console_1     state=off
    come back from admin settings page    device_list=console_1
    Console sign out method   console=console_1
    Verify signin is successful    console_list=console_1     state=Sign out
    Sign out method    device=device_1
    Sign in method     device=device_1  user=meeting_user
    console sign in method    console=console_1    user=meeting_user
    Get device pairing code    device_list=device_1    console_list=console_1   user_list=meeting_user
    Verify signin is successful    console_list=console_1     state=sign in
    navigate to HDMI content sharing option inside admin setting     console=console_1      option=meeting
    verify options under hdmi content sharing toggle    device=console_1     state=on
    come back from admin settings page    device_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND    enable HDMI content sharing inside admin setting    console=console_1    option=meeting    state=on    AND    come back from admin settings page    device_list=console_1

TC2:[HDMI Auto share]Verify when DUT user disable "Enable content sharing " Child options should also get disabled
    [Tags]    418693    P2
    [Setup]  Testcase Setup for shared User      count=1
    navigate to HDMI content sharing option inside admin setting    console=console_1    option=meeting
    Enable and disable hdmi content sharing     device=console_1     state=off
    verify options under hdmi content sharing toggle    device=console_1     state=off
    come back from admin settings page    device_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND    enable HDMI content sharing inside admin setting    console=console_1    option=meeting    state=on    AND    come back from admin settings page    device_list=console_1

TC3:[HDMI_Auto share]verify when DUT user enables the child toggle, the parent toggle must auto-enable
    [Tags]    344884    P1    sanity_tc_sm
    [Setup]  Testcase Setup for shared User      count=1
    navigate to HDMI content sharing option inside admin setting    console=console_1    option=meeting
    Enable and disable hdmi content sharing     device=console_1     state=off
    verify options under hdmi content sharing toggle    device=console_1     state=off
    enable and disable automatically share to room display    device=console_1    state=on
    verify options under hdmi content sharing toggle    device=console_1     state=on    child_toggle=automatically_share_toggle
    come back from admin settings page    device_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND    enable HDMI content sharing inside admin setting    console=console_1    option=meeting    state=on    AND    come back from admin settings page    device_list=console_1

TC4:[HDMI Audio]Verify DUT[Console] is displays a message when Audio is disabled by admin
    [Tags]    344674    P2
    [Setup]  Testcase Setup for shared User      count=2
    navigate to HDMI content sharing option inside admin setting    console=console_1    option=meeting
    Enable and disable hdmi content sharing     device=console_1    state=on
    enable and disable share system audio    device=console_1    state=off
    come back from admin settings page    device_list=console_1
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    verify audio share title under share content in meeeting is present   device=console_1    state=disable
    Wait for Some Time    time=${wait_time}
    dismiss the popup screen    device=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND    enable HDMI content sharing inside admin setting    console=console_1    option=meeting    state=on    AND    come back from admin settings page    device_list=console_1

TC5:[HDMI_Audio]Verify when DUT user enables parent toggle “HDMI content sharing”, child toggle “include audio” must be auto-enabled by default
    [Tags]    344678    P1    sanity_tc_sm
    [Setup]  Testcase Setup for shared User      count=1
    navigate to HDMI content sharing option inside admin setting    console=console_1    option=meeting
    Enable and disable hdmi content sharing     device=console_1    state=off
    verify options under hdmi content sharing toggle    device=console_1     state=off
    Enable and disable hdmi content sharing     device=console_1    state=on
    verify options under hdmi content sharing toggle    device=console_1     state=on    child_toggle=include_audio_toggle
    come back from admin settings page    device_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND    enable HDMI content sharing inside admin setting    console=console_1    option=meeting    state=on    AND    come back from admin settings page    device_list=console_1

TC6:[HDMI Audio] Verify DUT is displays a message when Audio is disabled by admin
    [Tags]    418780    P2
    [Setup]  Testcase Setup for shared User      count=2
    navigate to teams admin settings page   device=device_1
    Enable and disable hdmi content sharing     device=device_1    state=on
    enable and disable share system audio    device=device_1    state=off
    Come back from admin settings page     device_list=device_1
    Join a meeting   console=device_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=device_1      device_list=device_2     state=Connected
    verify audio share title under share content in meeeting is present   device=device_1    state=disable
    Wait for Some Time    time=${wait_time}
    dismiss the popup screen    device=device_1
    Disconnect call     device=device_1
    Disconnect call     device=device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords    Capture Failure

TC7:[HDMI Audio]Verify DUT[Console] is displaying HDMI option with Enable/disable audio option when in Meeting
    [Tags]    344669    P2
    [Setup]  Testcase Setup for shared User      count=2
    navigate to HDMI content sharing option inside admin setting    console=console_1    option=meeting
    Enable and disable hdmi content sharing     device=console_1    state=on
    enable and disable share system audio    device=console_1    state=on
    come back from admin settings page    device_list=console_1
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    verify share content hdmi is present    device=console_1
    verify audio share title under share content in meeeting is present   device=console_1    state=enable
    Wait for Some Time    time=${wait_time}
    dismiss the popup screen    device=console_1
    End the meeting       console=console_1
    Disconnect call     device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND    enable HDMI content sharing inside admin setting    console=console_1    option=meeting    state=on    AND    come back from admin settings page    device_list=console_1

TC8:[HDMI Audio]Verify user is able to disable HDMI ingest from Meeting setting
    [Tags]    344662    P2
    [Setup]  Testcase Setup for shared User      count=1
    navigate to HDMI content sharing option inside admin setting    console=console_1    option=meeting
    verify content sharing options is present   device=console_1
    Enable and disable hdmi content sharing    device=console_1    state=off
    come back from admin settings page    device_list=console_1
    verify share option on home screen    device=console_1     state=off
    [Teardown]  Run Keywords    Capture Failure  AND    enable HDMI content sharing inside admin setting    console=console_1    option=meeting    state=on    AND    come back from admin settings page    device_list=console_1

TC9:[HDMI Audio]Verify user is able to enable HDMI ingest from Meeting setting
    [Tags]    344664    P2
    [Setup]  Testcase Setup for shared User      count=1
    navigate to HDMI content sharing option inside admin setting    console=console_1    option=meeting
    verify content sharing options is present   device=console_1
    Enable and disable hdmi content sharing    device=console_1    state=on
    come back from admin settings page    device_list=console_1
    verify share option on home screen    device=console_1     state=on
    [Teardown]  Run Keywords    Capture Failure  AND    come back from admin settings page    device_list=console_1

TC10:[HDMI Audio]Verify DUT[Console] user is not getting HDMI option in meeting when disabled from Meeting settings
    [Tags]    344667    P1    sanity_tc_sm
    [Setup]  Testcase Setup for shared User      count=2
    navigate to HDMI content sharing option inside admin setting    console=console_1    option=meeting
    Enable and disable hdmi content sharing     device=console_1    state=off
    come back from admin settings page    device_list=console_1
    verify share option on home screen    device=console_1     state=off
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    verify share content hdmi is not present    device=console_1
    End a meeting       console=console_1    device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND    enable HDMI content sharing inside admin setting    console=console_1    option=meeting    state=on    AND    come back from admin settings page    device_list=console_1

TC11:[HDMI_Audio]Verify user is able to see HDMI option under Meeting setting
    [Tags]    344661    P2    
    [Setup]  Testcase Setup for shared User      count=1
    navigate to HDMI content sharing option inside admin setting    console=console_1    option=meeting
    Enable and disable white board sharing toggle     device=console_1     state=on
    verify options under hdmi content sharing toggle    device=console_1     state=on
    verify options under hdmi content sharing toggle    device=console_1     state=on    child_toggle=include_audio_toggle
    verify options under hdmi content sharing toggle    device=console_1     state=on    child_toggle=automatically_share_toggle
    come back from admin settings page    device_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND    come back from admin settings page    device_list=console_1

TC12:[HDMI Audio]Verify when DUT[Console] user disable "Share system audio" after joining meeting Audio is not shared
    [Tags]    344672    sanity_tc_sm    bvt_tc_sm
    [Setup]  Testcase Setup for shared User      count=2
    navigate to HDMI content sharing option inside admin setting    console=console_1    option=meeting
    Enable and disable white board sharing toggle     device=console_1     state=on
    Enable and disable hdmi content sharing     device=console_1     state=on
    come back from admin settings page    device_list=console_1
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    enable and disable share system audio under meeting    device=console_1    state=off
    End a meeting       console=console_1    device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND    enable HDMI content sharing inside admin setting    console=console_1    option=meeting    state=on    AND      come back from admin settings page    device_list=console_1

TC13:[HDMI_Audio]Verify "include Audio" is enabled back once DUT ends first Meeting and Joins the Second meeting
    [Tags]    344680    P2
    [Setup]  Testcase Setup for shared User      count=2
    navigate to HDMI content sharing option inside admin setting    console=console_1    option=meeting
    Enable and disable white board sharing toggle     device=console_1     state=on
    Enable and disable hdmi content sharing     device=console_1     state=on
    come back from admin settings page    device_list=console_1
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    enable and disable share system audio under meeting    device=console_1    state=off
    End a meeting       console=console_1    device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    verify share system audio toggle under_meeting   device=console_1    state=on
    End a meeting       console=console_1    device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND    come back from admin settings page    device_list=console_1

TC14:[HDMI Auto sharing] Verify DUT [console] user is able to disable "Automatically share to the room display" option from Meeting setting.
    [Tags]    344874       sanity_tc_sm    bvt_tc_sm
    [Setup]  Testcase Setup for shared User      count=1
    navigate to HDMI content sharing option inside admin setting    console=console_1    option=meeting
    Enable and disable white board sharing toggle     device=console_1     state=off
    Enable and disable hdmi content sharing     device=console_1     state=off
    verify options under hdmi content sharing toggle    device=console_1     state=off
    Wait for Some Time    time=${wait_time}
    Enable and disable hdmi content sharing     device=console_1     state=on
    Enable and disable automatically share to room display      device=console_1     state=off
    come back from admin settings page    device_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND    enable HDMI content sharing inside admin setting    console=console_1    option=meeting    state=on    AND      come back from admin settings page    device_list=console_1

TC15:[HDMI Auto share]Verify when DUT user disables "Child options" Parent HDMI option is not getting disabled
    [Tags]    418694       sanity_tc_sm    P1
    [Setup]  Testcase Setup for shared User      count=1
    navigate to HDMI content sharing option inside admin setting    console=console_1    option=meeting
    verify options under hdmi content sharing toggle    device=console_1     state=on
    enable and disable share system audio    device=console_1    state=off
    Enable and disable automatically share to room display      device=console_1     state=off
    verify options under hdmi content sharing toggle    device=console_1     state=on
    come back from admin settings page    device_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND    enable HDMI content sharing inside admin setting    console=console_1    option=meeting    state=on    AND      come back from admin settings page    device_list=console_1

*** Keywords ***
Navigate to app settings screen
    [Arguments]   ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

navigate to HDMI content sharing option inside admin setting
     [Arguments]    ${console}    ${option}
    Navigate to app settings screen    ${console}
    navigate to meeting and calling options from device settings page    console=${console}   option=${option}

signout and re signin again
    [Arguments]   ${console}
     Console sign out method   console=console_1
     Verify signin is successful    console_list=console_1     state=Sign out
     Verify home page screen   device=device_1
     Sign out method    device=device_1
     Sign in method     device=device_1
     Console sign in method     console=console_1
     Get device pairing code    device_list=device_1    console_list=console_1     user_list=user
     Verify signin is successful    console_list=console_1     state=Sign in

enable HDMI content sharing inside admin setting
    [Arguments]    ${console}    ${option}    ${state}
    navigate to HDMI content sharing option inside admin setting    ${console}    ${option}
    Enable and disable hdmi content sharing    device=${console}     state=off
    Wait for Some Time    time=${wait_time}
    Enable and disable hdmi content sharing    device=${console}     state=${state}

End a meeting
    [Arguments]    ${console}    ${device}
    End the meeting  ${console}
    End meeting      ${device}

navigate to teams admin settings page
    [Arguments]    ${device}
    Click on more option   ${device}
    Click on settings page   ${device}
    Navigate to meetings option in device settings page      ${device}

*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

Suite Setup         Enable third party meetings
Suite Teardown    Run Keywords   Suite Failure Capture    AND   Disable third party meetings    console=console_1

*** Variables ***

*** Test Cases ***
TC1:[Meeting ID] Join Zoom meeting successfully
    [Tags]    454362    bvt_tc_sm    sanity_tc_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for shared User     count=1
    verify join with an meeting id options after enabling third party meetings      device=console_1
    join with an meeting id   device=console_1         meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode}     meeting_type=zoom
    Verify for call state  console_list=console_1   state=Connected
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC2 :[Meeting Id] Verify Teams Enter code working
    [Tags]    454365    P2    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User      count=1
    join with an meeting id   device=console_1         meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode}
    Verify for call state  console_list=console_1   state=Connected
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC3: [Meeting ID] Join Zoom meeting with incorrect meeting detail
    [Tags]    454363    P2    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User      count=1
     verify and join zoom meeting with incorrect meeting details        console=console_1       device=device_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC4:[Meeting Id] Disable Zoom in meeting settings
    [Tags]    454364    bvt_tc_sm    sanity_tc_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for shared User     count=1
    Disable third party meetings        console=console_1
    Verify the join by id on home seceen when zoom meeting toggle is disabled         device=console_1
    [Teardown]  Run Keywords   Capture Failure   AND   Come back to home screen page   console_list=console_1

TC5:[MTRA+TC] Verify third party meeting join from DUT Home screen
    [Tags]    444755    P2      exclude_ftp_sm
    [Setup]  Testcase Setup for shared User     count=1
    Join a meeting   console=console_1     meeting=zoom_meeting
    Verify for call state     console_list=console_1      state=Connected
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC6:[MTRA+TC] Verify more than one All day meetings are visible tapping on bar.
    [Documentation]     create 3p meetings zoom and webex
    [Tags]    444753    P2      exclude_ftp_sm
    [Setup]  Testcase Setup for shared User     count=1
    Tap on all day meetings title bar and validate   device=console_1
    Get meetings details present under all day title bar   device=console_1
    Navigate back to meetings   device=console_1
    Verify 3p meeting in calendar   device=console_1        meeting=zoom_meeting
    [Teardown]   Run Keywords    Capture Failure   AND  Come back to home screen page   console_list=console_1

TC7:[DGJ]Console user joins the displayed Zoom Meeting from the Teams Home screen.
    [Tags]    444958      sanity_tc_sm    bvt_tc_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for shared User     count=1
    Join a meeting   console=console_1     meeting=zoom_meeting
    Verify for call state     console_list=console_1      state=Connected
    verify the docked ubar when third party meeting joins    device=console_1
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]   Run Keywords    Capture Failure   AND  Come back to home screen page   console_list=console_1

TC8:[DGJ]DUT should display connecting screen with Cancel button
    [Tags]    418935  P1     sanity_tc_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for shared User     count=1
    verify cancel button after join dgj meeting    console=console_1     meeting=zoom_meeting
    Verify for call state     console_list=console_1      state=Connected
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]   Run Keywords    Capture Failure   AND  Come back to home screen page   console_list=console_1

TC9:[DGJ]Zoom icon should be displayed for the meeting created with Zoom Link on Calendar
    [Tags]      418937      P1     sanity_tc_sm    exclude_ftp_sm
     [Setup]  Testcase Setup for shared User     count=1
    Verify meeting display on tc home screen    console=console_1
    verify zoom icon on tc calendar tab     console=console_1
    [Teardown]   Run Keywords    Capture Failure   AND  Come back to home screen page   console_list=console_1

TC10:[DGJ]TC user should be able to join Zoom Meeting and access Both the Call controls displayed in Meeting
    [Tags]    445013    P1     sanity_tc_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for shared User     count=1
    Join a meeting   console=console_1     meeting=zoom_meeting
    Verify for call state     console_list=console_1      state=Connected
    verify the docked ubar when third party meeting joins    device=console_1
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]   Run Keywords    Capture Failure   AND  Come back to home screen page   console_list=console_1

TC11:[DGJ]TC user should be able to join Zoom Meeting from Teams and See call control options
    [Tags]    444966    P2    exclude_ftp_sm
    [Setup]  Testcase Setup for shared User     count=1
    Join a meeting   console=console_1     meeting=zoom_meeting
    Verify for call state     console_list=console_1      state=Connected
    verify the docked ubar when third party meeting joins    device=console_1
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]   Run Keywords    Capture Failure   AND  Come back to home screen page   console_list=console_1

TC12:[DGJ zoom]TC user Video should be enabled by default while Joining the meeting
    [Tags]    445015    P1     sanity_tc_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for shared User     count=1
    Join a meeting   console=console_1     meeting=zoom_meeting
    Verify for call state     console_list=console_1      state=Connected
    Check video call On state    device_list=console_1
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]   Run Keywords    Capture Failure   AND  Come back to home screen page   console_list=console_1

TC13:[DGJ]When user is already in Zoom Meeting user should not receive Call or meeting invite
    [Tags]    327986    P2    exclude_ftp_sm
    [Setup]  Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     meeting=zoom_meeting
    Verify for call state     console_list=console_1      state=Connected
    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
    verify user should not get second incoming call     device=console_1
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC14:[DGJ]DUT user joins a Zoom Meeting from console and Try to share content
    [Tags]    444959    P1     sanity_tc_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for shared User     count=1
    Join a meeting   console=console_1     meeting=zoom_meeting
    Verify for call state     console_list=console_1      state=Connected
    verify share and more options absence   device=console_1
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC15:[DGJ]DUT user try to disconnect meeting from Zoom UI when console paired
    [Tags]    444962    P2    exclude_ftp_sm
    [Setup]  Testcase Setup for shared User     count=1
    Join a meeting   console=console_1     meeting=zoom_meeting
    Verify for call state     console_list=console_1      state=Connected
    verify the docked ubar when third party meeting joins    device=console_1    meetting_mode=zoom
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC16:[DGJ]DUT user joins a Zoom Meeting from console and DUT user Mute/Unmute
    [Tags]    327977    P2    exclude_ftp_sm
    [Setup]  Testcase Setup for shared User     count=1
    Join a meeting   console=console_1     meeting=zoom_meeting
    Verify for call state     console_list=console_1      state=Connected
    verify the docked ubar when third party meeting joins    device=console_1    meetting_mode=zoom
    Mute the call      console=console_1
    Verify and check call mute state      console_list=console_1    state=Mute
    Unmute the call    console=console_1
    Verify and check call mute state     console_list=console_1    state=Unmute
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC17:[DGJ]In Zoom Meeting Both Call Controls should be in SYNC
    [Tags]    445014    P1     sanity_tc_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for shared User     count=1
    Join a meeting   console=console_1     meeting=zoom_meeting
    Verify for call state     console_list=console_1      state=Connected
    verify the docked ubar when third party meeting joins    device=console_1    meetting_mode=zoom
    verify the docked ubar when third party meeting joins    device=device_1        meetting_mode=zoom
    Mute the call      console=console_1
    Verify and check call mute state      console_list=console_1    state=Mute
    Verify meeting Mute State    device_list=device_1    state=mute
    Unmutes the phone call  device=device_1
    Verify meeting Mute State    device_list=device_1    state=Unmute
    Verify and check call mute state      console_list=console_1    state=unmute
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC18:[DGJ]Pair console when user already in Zoom Meeting
    [Tags]    444964        sanity_tc_sm    P1    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User      count=1
    Unpair console
    Enable and disable third party webex meetings on norden    device=device_1     state=on
    Join Meeting    device=device_1      meeting=zoom_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1     state=Connected
    Sign In Console    user_list=meeting_user
    Get device pairing code    device_list=device_1    console_list=console_1     user_list=meeting_user
    Verify console paired or not    console=console_1
    Verify meeting state   device_list=device_1     state=Connected
    End meeting     device=device_1
    Verify current time display on home screen    device=device_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

*** Keywords ***
Navigate to app settings screen
    [Arguments]   ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Enable third party meetings
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1  option=meeting
    Enable and disable third party meetings zoom toggle    device=console_1    state=on
    come back from admin settings page      device_list=console_1

Disable third party meetings
    [Arguments]       ${console}
    Navigate to app settings screen    ${console}
    Navigate to meeting and calling options from device settings page       ${console}   option=meeting
    Enable and disable third party meetings zoom toggle     device=${console}       state=off
    come back from admin settings page      device_list=${console}

Navigating back to home page
    [Arguments]     ${console}
    Click on close button    console_list=${console}
    Click on back layout btn   ${console}

Verify meeting display on tc home screen
    [Arguments]    ${console}
    Verify meeting display on home screen     device=${console}

verify zoom icon on tc calendar tab
    [Arguments]    ${console}
    verify zoom icon on calendar tab     device=${console}

Unpair console
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1  option=devices
    Verify and click on unpairing option    console=console_1

Verify console paired or not
    [Arguments]   ${console}
    Navigate to app settings screen     console=${console}
    Navigate to meeting and calling options from device settings page       console=${console}  option=devices
    verify console pairing option   console=${console}
    come back from admin settings page      device_list=${console}

Navigate to app settings page on norden
    [Arguments]     ${device}
    Click on more option   device=device_1
    Click on settings page   device=device_1

Enable and disable third party webex meetings on norden
    [Arguments]     ${device}       ${state}
    Navigate to app settings page on norden   ${device}
    navigate to meetings option in device settings page      ${device}
    Enable and disable third party meetings webex toggle    ${device}     ${state}
    Come back from admin settings page    device_list=${device}
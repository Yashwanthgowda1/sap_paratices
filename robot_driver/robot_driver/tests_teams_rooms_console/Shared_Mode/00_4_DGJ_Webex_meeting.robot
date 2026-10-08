*** Settings ***
Resource    ../../resources/keywords/common.robot

Suite Setup         Enable third party webex meetings
#Suite Teardown      Disable third party webex meetings

*** Test Cases ***
TC1:[DGJ]DUT should display connecting screen with Cancel button
    [Tags]    419621    P2    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User      count=1
    verify cancel button after join dgj meeting    console=console_1     meeting=webex_meeting
    Verify for call state     console_list=console_1      state=Connected
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]   Run Keywords    Capture Failure   AND  Come back to home screen page   console_list=console_1

TC2:[DGJ webex]TC user Video should be enabled by default while Joining the meeting
    [Tags]    419613      sanity_tc_sm    bvt_tc_sm    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User      count=1
    Join a meeting   console=console_1     meeting=webex_meeting
    Verify for call state     console_list=console_1      state=Connected
    Check video call On state    device_list=console_1
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC3:[DGJ]When user is already in Webex Meeting user should not receive Call or meeting invite
    [Tags]    419605    P2    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User      count=2
    Join a meeting   console=console_1     meeting=webex_meeting
    Verify for call state     console_list=console_1      state=Connected
    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
    verify user should not get second incoming call     device=console_1
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC4:[DGJ]Verify Console user should be able to join the displayed Webex meeting from Teams home screen
    [Tags]    444944    sanity_tc_sm    bvt_tc_sm    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User      count=1
    Join a meeting   console=console_1     meeting=webex_meeting
    Verify for call state     console_list=console_1      state=Connected
    verify the docked ubar when third party meeting joins    device=console_1    meetting_mode=webex
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC5:[DGJ]Webex icon should be displayed for the meeting created with Webex Link on Calendar
    [Tags]    444957    P1    sanity_tc_sm
    [Setup]    Testcase Setup for shared User      count=1
    Verify meeting display on home screen     device=console_1
    verify webex icon on calendar tab      device=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC6:[DGJ]DUT user joins a Webex Meeting from console and try to share content
    [Tags]    444945    P1    sanity_tc_sm    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User      count=1
    Join a meeting   console=console_1     meeting=webex_meeting
    Verify for call state     console_list=console_1      state=Connected
    verify the docked ubar when third party meeting joins    device=console_1    meetting_mode=webex
    verify share and more options absence   device=console_1
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC7:[DGJ]Mic should be on by default when TC user joins the meeting
    [Tags]    419617    P1    sanity_tc_sm    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User      count=1
    Join a meeting   console=console_1     meeting=webex_meeting
    Verify for call state     console_list=console_1      state=Connected
    verify the docked ubar when third party meeting joins    device=console_1    meetting_mode=webex
    Verify and check call mute state     console_list=console_1    state=Unmute
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC8:[DGJ]DUT user joins a Webex Meeting from console and DUT user Mute/Unmute
    [Tags]    328349    P2    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User      count=1
    Join a meeting   console=console_1     meeting=webex_meeting
    Verify for call state     console_list=console_1      state=Connected
    verify the docked ubar when third party meeting joins    device=console_1    meetting_mode=webex
    Mute the call      console=console_1
    Verify and check call mute state      console_list=console_1    state=Mute
    Unmute the call    console=console_1
    Verify and check call mute state     console_list=console_1    state=Unmute
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC9:[DGJ]DUT user try to disconnect meeting from Webex UI when console paired.
    [Tags]    444948        sanity_tc_sm    bvt_tc_sm    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User      count=1
    Join a meeting   console=console_1     meeting=webex_meeting
    Verify for call state     console_list=console_1      state=Connected
    verify the docked ubar when third party meeting joins    device=console_1    meetting_mode=webex
    End the meeting     console=console_1
    Verify current time display on home screen    device=device_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC10:[DGJ]Pair console when user already in Webex Meeting
    [Tags]    444950        sanity_tc_sm    P1    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User      count=1
    Unpair console
    Enable and disable third party webex meetings on norden    device=device_1     state=on
    Join Meeting    device=device_1      meeting=webex_meeting
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

TC11:[DGJ]In Webex Meeting Both Call Controls should be in SYNC
    [Tags]    419612        sanity_tc_sm    P1    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User      count=1
    Join a meeting   console=console_1     meeting=webex_meeting
    Verify for call state     console_list=console_1      state=Connected
    verify the docked ubar when third party meeting joins    device=console_1    meetting_mode=webex
    verify the docked ubar when third party meeting joins    device=device_1        meetting_mode=webex
    Mute the call      console=console_1
    Verify and check call mute state      console_list=console_1    state=Mute
    Verify meeting Mute State    device_list=device_1    state=mute
    Unmutes the phone call  device=device_1
    Verify meeting Mute State    device_list=device_1    state=Unmute
    Verify and check call mute state      console_list=console_1    state=unmute
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC12:[DGJ]TC user should be able to join Webex Meeting also could see & access Both the Call controls displayed in Meeting
    [Tags]    444955        sanity_tc_sm    bvt_tc_sm    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User      count=1
    Join a meeting   console=console_1     meeting=webex_meeting
    Verify for call state     console_list=console_1      state=Connected
    verify the docked ubar when third party meeting joins    device=console_1    meetting_mode=webex
    verify the docked ubar when third party meeting joins    device=device_1        meetting_mode=webex
    Mute the call      console=console_1
    Verify and check call mute state      console_list=console_1    state=Mute
    Unmute the call    console=console_1
    Verify and check call mute state     console_list=console_1    state=Unmute
    End the meeting     console=console_1
    Verify for call state    console_list=console_1   state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

*** Keywords ***
Navigate to app settings screen
    [Arguments]   ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Enable third party webex meetings
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1  option=meeting
    enable and disable third party meetings webex toggle    device=console_1    state=on
    come back from admin settings page      device_list=console_1

Disable third party webex meetings
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1  option=meeting
    enable and disable third party meetings webex toggle    device=console_1    state=off
    come back from admin settings page      device_list=console_1

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
*** Settings ***
Documentation   Meeting created as prerequisite before test execution make sure that  Webex meeting is created
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

Suite Setup         Enable and disable third party webex meetings    device=device_1     state=on
#Suite Teardown    Run Keywords   Suite Failure Capture    AND   Disable third party meetings    device=device_1

*** Variables ***
${wait_time} =  3
${action_time} =  5

*** Test Cases ***
TC1:[DGJ]DUT user should be able to join Webex Meeting from Teams
    [Tags]     445044        bvt_sm       sanity_sm     exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Join Meeting    device=device_1      meeting=webex_meeting
    Wait for Some Time    time=${action_time}
    Verify meeting state   device_list=device_1     state=Connected
    verify the docked ubar when third party meeting joins    device=device_1        meetting_mode=webex
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC2:[DGJ]Webex icon should be displayed for the meeting created with Webex Link on Calendar
     [Tags]    445051      bvt_sm       sanity_sm
     [Setup]  Testcase Setup for Meeting User     count=1
    Verify meeting display on home screen     device=device_1
    verify webex icon on calendar tab     device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC3:[DGJ webex]DUT user Video should be enabled by default while Joining the meeting
     [Tags]        445046      bvt_sm       sanity_sm       exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Join Meeting    device=device_1      meeting=webex_meeting
    Wait for Some Time    time=${action_time}
    Verify meeting state   device_list=device_1     state=Connected
    Check video call On state   device_list=device_1
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC4:[DGJ]Create Webex Meeting
     [Tags]        328325      P2
    [Setup]  Testcase Setup for Meeting User     count=1
    verify the home screen and webex meeting reflection     device=device_1     meeting=webex_meeting
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC5:[DGJ]DUT user should be able to join Webex Meeting, could see & access Both the Call controls displayed in Meeting
    [Tags]      328330       bvt_sm   sanity_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Join Meeting    device=device_1      meeting=webex_meeting
    Wait for Some Time    time=${action_time}
    Verify meeting state   device_list=device_1     state=Connected
    verify the docked ubar when third party meeting joins    device=device_1        meetting_mode=webex
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC6:[DGJ]DUT user should not be able to share screen in Webex Meeting
    [Tags]      328335         sanity_sm    P1    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Join Meeting    device=device_1      meeting=webex_meeting
    Wait for Some Time    time=${action_time}
    Verify meeting state   device_list=device_1     state=Connected
    verify the docked ubar when third party meeting joins    device=device_1        meetting_mode=webex
    verify share and more options absence   device=device_1
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC7:[DGJ]DUT user Mute and unmute during Webex Meeting
    [Tags]      328338        sanity_sm    P1    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Join Meeting    device=device_1      meeting=webex_meeting
    Wait for Some Time    time=${action_time}
    Verify meeting state   device_list=device_1     state=Connected
    DUT user Mute and unmute during Webex Meeting     device=device_1       mute_state=mute     video_state=off
    DUT user Mute and unmute during Webex Meeting    device=device_1       mute_state=unmute    video_state=on
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC8:[DGJ]When user is already in Webex Meeting user should not receive Call or meeting invite
    [Tags]     418917    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=2    
    Join Meeting    device=device_1      meeting=webex_meeting
    Wait for Some Time    time=${action_time}
    Verify meeting state   device_list=device_1     state=Connected
    Make outgoing call with phonenumber    from_device=device_2     to_device=device_1:meeting_user
    Verify user should not get second incoming call     device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC9:[3P Meeting] After inviting Teams user, Zoom/Webex Meeting will show on Calender of MTRA
    [Tags]        445042      bvt_sm   sanity_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    verify the home screen and webex meeting reflection     device=device_1     meeting=webex_meeting
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC10:[DGJ]In Webex Meeting Both Call Controls should be in SYNC
    [Tags]        445045      sanity_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Join meeting   device=device_1    meeting=webex_meeting
    Verify meeting state   device_list=device_1    state=Connected
    verify third party meeting both call controls should be in sync     device=device_1     mute_state=mute     video_state=off
    verify third party meeting both call controls should be in sync     device=device_1     mute_state=unmute    video_state=on
    End meeting      device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC11:[DGJ]Mic should be on by default when DUT user joins the meeting
    [Tags]     445047       P2    sanity_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1    meeting=webex_meeting
    Verify meeting state   device_list=device_1    state=Connected
    verify mic is unmuted by default in third party meeting       device=device_1
    End meeting      device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC12:[DGJ]DUT should display connecting screen with Cancel button
     [Tags]   328342    P2    exclude_ftp_sm
    [Setup]    Testcase Setup for Meeting User   count=1
    verify connecting screen with Cancel button when we join the meeting     device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC13:[DGJ]DUT should not highlight Webex Meeting when Webex meeting option is disabled in Meetings
    [Tags]   328341    P2    sanity_sm
    [Setup]    Testcase Setup for Meeting User   count=1
    Enable and disable third party webex meetings    device=device_1     state=off
    verify join button behavior when third party toggle is disabled       device=device_1         meeting_name=webex_meeting
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1    AND   Enable and disable third party webex meetings    device=device_1     state=on

TC14:[DGJ]DUT should not join button for Webex Meeting when Webex meeting option is disabled in Meetings
    [Tags]   445049    P2
    [Setup]    Testcase Setup for Meeting User   count=1
    Enable and disable third party webex meetings        device=device_1     state=off
    verify join button behavior when third party toggle is disabled       device=device_1         meeting_name=webex_meeting
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1     AND   Enable and disable third party webex meetings    device=device_1     state=on

TC15:[DGJ][Chromium support] DUT user to check web view/Chromium support version
    [Tags]      345649    P2
    [Setup]  Testcase Setup for Meeting User     count=1
    verify web view chromium support version   device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

*** Keywords ***
Verify Webex Meeting Should be displayed in Home screen
    Join Meeting    device=device_1     meeting=webex_meeting
    Wait for Some Time    time=${action_time}
    Verify meeting state   device_list=device_1     state=Connected
    End meeting     device=device_1

verify connecting screen with Cancel button when we join the meeting
    [Arguments]     ${device}
    Join meeting   device=device_1    meeting=webex_meeting          dgj=true
    Verify meeting state   device_list=${device}    state=Connected
    End meeting      device=device_1

verify the home screen and webex meeting reflection
    [Arguments]     ${device}       ${meeting}
    Verify home page screen      ${device}
    verify meeting reflected on calendar tab          ${device}       ${meeting}

DUT user Mute and unmute during Webex Meeting
     [Arguments]     ${device}       ${mute_state}    ${video_state}
     verify third party meeting both call controls should be in sync         ${device}       ${mute_state}    ${video_state}
*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

Suite Setup         Enable third party meetings     device=device_1

*** Variables ***

*** Test Cases ***
TC1:[Meeting ID] Join Zoom meeting successfully
    [Tags]   454369     P0      exclude_ftp_sm    sanity_sm
    [Setup]    Testcase Setup for Meeting User   count=1
    verify join with an meeting id options after enabling third party meetings      device=device_1
    join with an meeting id   device=device_1         meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode}      meeting_type=zoom
    Verify meeting state   device_list=device_1    state=Connected
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC2:[Meeting Id] Verify Teams Enter code working
    [Tags]   454372     P0      exclude_ftp_sm
    [Setup]    Testcase Setup for Meeting User   count=1
    join with an meeting id   device=device_1         meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode}
    Verify meeting state   device_list=device_1    state=Connected
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC3:[Meeting ID] Join Zoom meeting with incorrect meeting detail
    [Tags]   454370    P1       exclude_ftp_sm
    [Setup]    Testcase Setup for Meeting User   count=1
    Verify join meeting with incorrect meeting detail   device=device_1     meeting_type=zoom
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC4: [DGJ]In Zoom Meeting Both Call Controls should be in SYNC
    [Tags]       445039    bvt_sm   sanity_sm     exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1    meeting=zoom_meeting
    Verify meeting state   device_list=device_1    state=Connected
    verify the docked ubar when third party meeting joins    device=device_1
    verify third party meeting both call controls should be in sync     device=device_1     mute_state=mute     video_state=off
    verify third party meeting both call controls should be in sync     device=device_1     mute_state=unmute    video_state=on
    End meeting      device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC5:[DGJ]DUT user Mute and unmute during Zoom Meeting
    [Tags]      327967   P1  sanity_sm      exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1    meeting=zoom_meeting
    Verify meeting state   device_list=device_1    state=Connected
    verify the docked ubar when third party meeting joins    device=device_1
    verify third party meeting both call controls should be in sync     device=device_1     mute_state=mute     video_state=off
    verify third party meeting both call controls should be in sync     device=device_1     mute_state=unmute    video_state=on
    End meeting      device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC6:[DGJ]DUT should display connecting screen with Cancel button
    [Tags]         327971    P1   sanity_sm       exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify meeting display on home screen     device=device_1
    verify connecting screen with Cancel button when we join the meeting
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC7:[DGJ]Create Zoom Meeting
    [Tags]      327954      P2    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Join meeting   device=device_1    meeting=zoom_meeting
    Verify meeting state   device_list=device_1    state=Connected
    End meeting      device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
   [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC8:[3P Meeting] After inviting Teams user, Zoom/Webex Meeting will show on Calender of MTR
     [Tags]      317842     P2    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    After inviting Teams user Zoom or Webex Meeting will show on Calender of MTR      device=device_1     meeting=zoom_meeting
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC9:[DGJ]DUT user should be able to join the displayed Zoom Meeting from Teams home screen
    [Tags]      445040  P1    sanity_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Join meeting   device=device_1    meeting=zoom_meeting
    Verify meeting state   device_list=device_1    state=Connected
    End meeting      device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
   [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC10:[3P Meeting] Design of Zoom/Webex Meeting on Failing to Join
    [Tags]      317845   P2    exclude_ftp_sm
    [Setup]    Testcase Setup for Meeting User   count=1
    verify the home screen and zoom meeting reflection      device=device_1     meeting=zoom_meeting
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC11:[DGJ]DUT user should be able to join Zoom Meeting, could see & access Both the Call controls displayed in Meeting
    [Tags]      327959   P1   sanity_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1    meeting=zoom_meeting
    Verify meeting state   device_list=device_1    state=Connected
    Verify Zoom meeting call controls are visible and accessible during the meeting      device=device_1
    End meeting      device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC12:[DGJ]DUT user video should be displayed in Preview screen when other participant joins the meeting
    [Tags]      327963   P2    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    Enable third party meetings    device=device_2
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2     meeting=zoom_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify meeting state    device_list=device_1,device_2    state=Connected
    verify participant preview screen       device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2

TC14:[DGJ]DUT user should not be able to share screen in Zoom Meeting
    [Tags]      327964    P2    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1    meeting=zoom_meeting
    Verify meeting state   device_list=device_1    state=Connected
    verify the docked ubar when third party meeting joins    device=device_1
    verify share and more options absence   device=device_1
    End meeting      device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC15:[DGJ][Chromium support] DUT user to check web view/Chromium support version
    [Tags]     345673    P2
    [Setup]  Testcase Setup for Meeting User     count=1
    verify web view chromium support version   device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC16:[DGJ zoom]DUT user Video should be enabled by default while Joining the meeting
    [Tags]         445038    P1         sanity_sm     exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1      meeting=zoom_meeting
    Verify meeting state   device_list=device_1    state=Connected
    verify video should be enabled by default while Joining the meeting   device=device_1
    End meeting      device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1


TC17:[DGJ]Mic should be on by default when DUT user joins the meeting
    [Tags]         327966   P1         sanity_sm     exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1      meeting=zoom_meeting
    Verify meeting state   device_list=device_1    state=Connected
    Verify meeting Mute State    device_list=device_1    state=unmute
    End meeting      device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1


*** Keywords ***
Zoom Meeting Should be displayed in Home screen
    Join meeting   device=device_1    meeting=zoom_meeting
    Verify meeting state   device_list=device_1    state=Connected
    End meeting      device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected

verify connecting screen with Cancel button when we join the meeting
    Join meeting   device=device_1    meeting=zoom_meeting   dgj=true
    Verify meeting state   device_list=device_1    state=Connected
    End meeting      device=device_1

After inviting Teams user Zoom or Webex Meeting will show on Calender of MTR
    [Arguments]     ${device}       ${meeting}
    verify meeting reflected on calendar tab          ${device}       ${meeting}

verify the home screen and zoom meeting reflection
    [Arguments]     ${device}       ${meeting}
    Verify home page screen      ${device}
    verify meeting reflected on calendar tab          ${device}       ${meeting}

Verify Zoom meeting call controls are visible and accessible during the meeting
    [Arguments]     ${device}
    verify the docked ubar when third party meeting joins     ${device}
    verify third party meeting both call controls should be in sync      ${device}      mute_state=mute     video_state=off
    verify third party meeting both call controls should be in sync      ${device}      mute_state=unmute    video_state=on

verify mic on by default
    [Arguments]     ${device_list}   ${state}
    Verify meeting Mute State    ${device_list}   ${state}

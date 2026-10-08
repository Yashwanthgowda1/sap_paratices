*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation   Suite Setup Requirements : This suite requires minimum of 3 devices in config
...             Purpose : Device_1 should enable lightweight meeting toggle then
...                       Device_2 should create multiple meetings and add Device_1 & Device_3 as participants

Suite Setup    Lightweight Meeting suite Setup
Suite Teardown     Run keyword and ignore error    Lightweight Meeting Suite Teardown

*** Variables ***
${wait_time} =  10


*** Test Cases ***
TC 1:[Light weight meeting] Verfiy that under meeting option, user can enable/ disable the "Enable lightweight meeting experience"
    [Tags]     401808       P1
    [Setup]  Testcase Setup  count=1
    disable lightweight meeting experience     device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    enable lightweight meeting experience   device=device_1     AND   Come back to home screen     device_list=device_1

TC 2:[Lightweight stage]Verify that park call option should be on all the tiles
    [Tags]      416645       p2
    [Setup]  Testcase Setup   count=1
    click on calls tab   device=device_1
    verify unpark call icon      device=device_1
    navigate to people tab      device=device_1
    validate global search and call park icon     device=device_1
    navigate to voicemail tab   device=device_1
    verify unpark call icon     device=device_1
    navigate to calendar tab    device=device_1
    verify unpark call icon      device=device_1
    navigate to walkie talkie tab  device=device_1
    verify call park icon should not present in walkie talkie tab  device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1

TC 3:[Light weight meeting] Verify the Enable lightweight meeting experience" option is present under meeting option.
    [Tags]      401812      P1
    [Setup]    Testcase Setup    count=1
    verify meetings option under app settings page     device=device_1
    [Teardown]  Run Keywords    Capture on Failure     AND   Come back to home screen     device_list=device_1

TC 4:[Light weight meeting] Verify the reactions button while in a meeting.
    [Tags]      401814      P0      bvt_tp   sanity_tp      bvt_pr
    [Setup]    Testcase Setup    count=2
    Clear notification from home screen     device=device_1
    create meeting   device=device_2    meeting=home_screen_meeting    participants=device_1
    verify meeting name and join meeting from home screen  device=device_1    meeting=home_screen_meeting
    Join Meeting    device=device_2     meeting=home_screen_meeting
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    verify presence of reactions button in call control     device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Testcase teardown with delete meeting  device=device_1      to_device=device_2      meeting=home_screen_meeting

TC 5: Verify the UI after joining the meeting from Meet now
    [Tags]      401816     P1        sanity_tp 
    [Setup]    Testcase Setup    count=2
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Add participant to conversation using display name   from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2

TC 6: [Light weight meeting] Verify disable lightweight meeting experience under meeting.
    [Tags]      401821   sanity_tp     P1
    [Setup]    Testcase Setup    count=1
    disable lightweight meeting experience          device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND   Come back to home screen     device_list=device_1   AND    Lightweight meeting experience teardown  device=device_1

TC 7: [Lightweight meeting] Verify the meeting UI when DUT user switches between the meeting.
    [Tags]      401850     P1
    [Setup]    Testcase Setup    count=2
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting_01
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    switch meeting from one meeting to another meeting  device=device_1     current_meeting=lightweight_meeting_01    next_meeting=lightweight_meeting_02
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    end meeting from hold banner        device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2

TC 8: [Lightweight meeting] Verify the meeting UI and toggle button (Resume/Hold) when user switches the meeting.
    [Tags]      401852   sanity_tp     P1
    [Setup]    Testcase Setup    count=2
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting_01
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    switch meeting from one meeting to another meeting  device=device_1     current_meeting=lightweight_meeting_01    next_meeting=lightweight_meeting_02
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    resume the meeting      device=device_1
    Wait for Some Time    time=${wait_time}
    verify meeting title in hold banner  device=device_1        meeting_1=lightweight_meeting_02   meeting_2=lightweight_meeting_01
    end meeting from hold banner        device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2

TC 9:[Lightweight stage] Verify that Lightweight Experience should be enabled by default under meeting option.
    [Tags]     401860       P1
    [Setup]  Testcase Setup  count=1
    verify lightweight meeting experience in meeting option         device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND   Come back to home screen     device_list=device_1

TC 10: [Light weight meeting] Verify All day meeting in calendar.
    [Tags]    401837        P2
    [Setup]   Testcase Setup    count=2
    create meeting   device=device_2    meeting=all_day_lightweight    participants=device_1    all_day_meeting=ON
    navigate to calendar tab    device=device_1
    Verify meeting under all day event  device=device_1     meetings=all_day_lightweight
    Verify meeting under all day event  device=device_2     meetings=all_day_lightweight
    join meeting from all day meeting tab   device=device_1,device_2     meeting=all_day_lightweight
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Delete meeting      devices=device_1,device_2    meeting=all_day_lightweight       all_day_meeting=ON      AND     Come back to home screen     device_list=device_1,device_2

TC 11:[Lightweight stage]Verify transfer button in group call
    [Tags]      416641       p2
    [Setup]  Testcase Setup   count=3
    Click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    Add participant to conversation using display name   from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    verify call transfer option is disabled         device=device_1
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2,device_3

*** Keywords ***
Lightweight Meeting Suite Setup
    Testcase Setup    count=3
    enable lightweight meeting experience   device=device_1
    Return to home screen     device_list=device_1
    clear all day meeting and meeting history from calendar   devices=device_1,device_2,device_3
    create meeting   device=device_2    meeting=lightweight_meeting_01    participants=device_1,device_3
    create meeting   device=device_2    meeting=lightweight_meeting_02   participants=device_1,device_3

Lightweight Meeting Suite Teardown
    Suite Failure Capture
    clear all day meeting and meeting history from calendar   devices=device_1,device_2,device_3

Lightweight meeting experience teardown
    [Arguments]     ${device}
    enable lightweight meeting experience     device=${device}
    return to home screen   ${device}

Testcase teardown with delete meeting
    [Arguments]     ${device}      ${to_device}     ${meeting}
    navigate to calendar tab    ${to_device}
    delete specific meeting     device=${to_device}      meeting=${meeting}
    come back to home screen    device_list=${device},${to_device}
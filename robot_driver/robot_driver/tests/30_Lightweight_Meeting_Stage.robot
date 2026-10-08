*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation   Suite Setup Requirements : This suite requires minimum of 3 devices in config
...             Purpose : Device_1 should enable lightweight meeting toggle then
...                       Device_2 should create meeting and add Device_1 & Device_3 as participants

Suite Setup    Lightweight Meeting suite Setup
Suite Teardown     Run keyword and ignore error    Lightweight Meeting Suite Teardown

*** Variables ***
${wait_time} =  10
${20s_wait_time}=   20


*** Test Cases ***
TC 1:[Light weight meeting] Verify the UI after joining the meeting from meeting join option under calendar.
    [Tags]      401810      P0      bvt_tp   sanity_tp
    [Setup]    Testcase Setup    count=2
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2

TC 2:[Light weight meeting] Verify the UI when the other participant(TDC1/DUT2/or any participant present in the meeting) ask to join the meeting
    [Tags]      401813   sanity_tp      P1
    [Setup]    Testcase Setup    count=3
    Join Meeting    device=device_2,device_3     meeting=lightweight_meeting
    verify meeting state   device_list=device_2,device_3       state=connected
    verify and add participant to conversation by ask to join option and view profile option in meeting    from_device=device_2        to_device=device_1
    pick incoming call  device=device_1
    verify meeting state   device_list=device_1       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2,device_3
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2,device_3

TC 3:[Light weight meeting] Verify more options(...) in a meeting.
    [Tags]      401820      P2
    [Setup]    Testcase Setup    count=2
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2

TC 4: [Lightweight meeting] Verify the meeting UI and toggle button (Resume/Hold) when user switches the meeting.
    [Tags]      401853   sanity_tp     P1
    [Setup]    Testcase Setup    count=2
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Join Meeting    device=device_1     meeting=lightweight_meeting    disconnect=False
    verify meeting state   device_list=device_1       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    verify call hold banner     from_device=device_1        to_device=device_2
    verify call state   device_list=device_2   state=hold
    Disconnect call     device=device_2
    verify call state   device_list=device_2    state=Disconnected
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2

TC 5: [Lightweight meeting] Verify the meeting UI when DUT user rejects the incoming call in an ongoing meeting.
    [Tags]      401854    P1
    [Setup]    Testcase Setup    count=2
    Join Meeting    device=device_1     meeting=lightweight_meeting
    verify meeting state   device_list=device_1       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    Wait for Some Time    time=${wait_time}
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Rejects the incoming call    device_list=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2    state=Disconnected
    verify lightweight meeting ui   device=device_1     participants=device_2
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2

TC 6: [Lightweight meeting] Verify the UI when DUT user disable the "Enable lightweight meeting experience option" under meeting.
    [Tags]     401855      P1
    [Setup]  Testcase Setup  count=2
    disable lightweight meeting experience     device=device_1
    go back to previous page     device=device_1
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
    verify meeting state   device_list=device_1,device_2       state=connected
    verify legacy meeting ui        device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen     device_list=device_1,device_2    AND     Lightweight meeting experience teardown  device=device_1

TC 7: [Light weight meeting] Verify the live caption when DUT user raise hand in a meeting.
    [Tags]   401819      P2
    [Setup]   Testcase Setup    count=2
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
    Wait for Some Time    time=${wait_time}
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1      participants=device_2
    turn on live caption and validate    device=device_1
    Raise hand     device=device_1
    Verify raise hand    from_device=device_1   to_device=device_2    status=on
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure      AND   Come back to home screen     device_list=device_1,device_2

TC 8: [Light weight meeting]"Tap to return to meeting" should display on all the tiles.
    [Tags]   401831      P1
    [Setup]   Testcase Setup    count=2
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
    Wait for Some Time    time=${wait_time}
    verify meeting state   device_list=device_1,device_2       state=connected
    click back    device=device_1
    navigate to calendar tab   device=device_1
    tap to return to meeting  device=device_1     action=verify
    navigate to people tab    device=device_1
    tap to return to meeting  device=device_1     action=verify
    join meeting from tap to return banner   device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2      state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure  AND   Come back to home screen     device_list=device_1,device_2

TC 9: [Light weight meeting] Verify people option in a meeting.
    [Tags]   401832      P1
    [Setup]   Testcase Setup    count=2
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
    Wait for Some Time    time=${wait_time}
    verify meeting state   device_list=device_1,device_2       state=connected
    verify manage audio and video option  device=device_1    count=2     role=presenter
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2

TC 10: [Light weight meeting] Verify stop recording option in a meeting.
    [Tags]   401823      P2
    [Setup]   Testcase Setup    count=2
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
    Wait for Some Time    time=${wait_time}
    verify meeting state   device_list=device_1,device_2       state=connected
    start recording call    device=device_1
    verify recording notification on screen     device=device_1
    Wait for Some Time    time=${wait_time}
    stop recording call     device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2

TC 11: [Lightweight meeting] Verify "Tap to return to meeting" banner in other tabs.
    [Tags]   401847     P2
    [Setup]   Testcase Setup    count=2
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
    Wait for Some Time    time=${wait_time}
    verify meeting state   device_list=device_1,device_2       state=connected
    click back    device=device_1
    navigate to calendar tab   device=device_1
    tap to return to meeting  device=device_1     action=verify
    navigate to people tab    device=device_1
    tap to return to meeting  device=device_1     action=verify
    navigate to walkie talkie tab  device=device_1
    tap to return to meeting  device=device_1     action=verify
    navigate to voicemail tab  device=device_1
    tap to return to meeting  device=device_1     action=verify
    click on home bar icon      device=device_1
    tap to return to meeting  device=device_1     action=verify
    join meeting from tap to return banner   device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2      state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure  AND   Come back to home screen     device_list=device_1,device_2

TC 12: [Light weight meeting]Verify that user should be able to select a meeting participant (Non- Attendee) and view their profile or request them to join the meeting.
    [Tags]      401834        P2
    [Setup]    Testcase Setup    count=3
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    verify and add participant to conversation by ask to join option and view profile option in meeting    from_device=device_1        to_device=device_3       option=view_profile
    Wait for Some Time    time=${wait_time}
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2

TC 13: [Light weight meeting]DUT user to verify the profile of other invited participant in a ongoing meeting
    [Tags]      401835        P2
    [Setup]    Testcase Setup    count=3
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    verify and add participant to conversation by ask to join option and view profile option in meeting    from_device=device_1        to_device=device_3       option=view_profile
    Wait for Some Time    time=${wait_time}
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2

TC 14:[Light weight meeting]Verify that start recording text is displayed under participant account
    [Tags]   401828      P2
    [Setup]   Testcase Setup    count=2
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
    Wait for Some Time    time=${wait_time}
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    start recording call    device=device_1
    verify recording notification on screen     device=device_1
    Wait for Some Time    time=${20s_wait_time}
    verify recording notification in participant     from_device=device_2       to_device=device_1
    stop recording call     device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2

TC 15: [Light weight meeting] Verify that "Your mic has been disabled" message should be displayed.
    [Tags]   401830     P2
    [Setup]   Testcase Setup    count=2
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
    Wait for Some Time    time=${wait_time}
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    Make an attendee    from_device=device_2       to_device=device_1
    Verify you are an attendee now notification     device=device_1
    verify and allow individual permissions to attendees   from_device=device_2       to_device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2

TC 16:[Light weight meeting] Verify that when DUT is an attendee and hand is lowered by the organizer proper message should be displayed.
    [Tags]   401833    P2
    [Setup]   Testcase Setup    count=2
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
    Wait for Some Time    time=${wait_time}
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    Make an attendee    from_device=device_2       to_device=device_1
    Verify you are an attendee now notification     device=device_1
    Raise hand     device=device_1
    Verify raise hand    from_device=device_1   to_device=device_2    status=on
    verify and lower hand for attendee  from_device=device_2   to_device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2

TC 17:[Light weight meeting] Verify that user should be able to select a meeting participant (non-Attendee) and request them to join a meeting.
    [Tags]   401836    P2
    [Setup]   Testcase Setup    count=3
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
    Wait for Some Time    time=${wait_time}
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    verify and add participant to conversation by ask to join option and view profile option in meeting    from_device=device_1        to_device=device_3
    pick incoming call  device=device_3
    verify meeting state   device_list=device_3       state=connected
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2,device_3

TC 18:[Lightweight meeting] Verify lock meeting option when DUT is an organizer.
    [Tags]   401845    P2
    [Setup]   Testcase Setup    count=2
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
    Wait for Some Time    time=${wait_time}
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    verify lock meeting option for organizer  device=device_2
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2

TC 19:[Lightweight stage] Verify no reactions should be present under more option
    [Tags]   416643    P2
    [Setup]   Testcase Setup    count=2
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
    Wait for Some Time    time=${wait_time}
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_2     participants=device_1
    verify reactions options not present in call more options       device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2

TC 20:[Lightweight stage]Verify that Raise hand should be displayed on the main screen as well as in the meeting roaster.
    [Tags]   416644        sanity_tp        bvt_pr
    [Setup]   Testcase Setup    count=2
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
    Wait for Some Time    time=${wait_time}
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    Raise hand     device=device_1
    Verify raise hand    from_device=device_1   to_device=device_2    status=on
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2

TC 21:[Light weight meeting] Verify the reactions invoked by the user should display on the screen.
    [Tags]      401824       p2
    [Setup]  Testcase Setup   count=3
    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
    verify meeting state   device_list=device_1,device_2       state=connected
    verify lightweight meeting ui   device=device_1     participants=device_2
    Verify presence of reactions button in call control     device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2

*** Keywords ***
Lightweight Meeting Suite Setup
    Testcase Setup    count=3
    enable lightweight meeting experience   device=device_1
    Return to home screen     device_list=device_1
    clear all day meeting and meeting history from calendar   devices=device_1,device_2,device_3
    create meeting   device=device_2    meeting=lightweight_meeting    participants=device_1,device_3

Lightweight Meeting Suite Teardown
    Suite Failure Capture
    clear all day meeting and meeting history from calendar   devices=device_1,device_2,device_3

Lightweight meeting experience teardown
    [Arguments]     ${device}
    enable lightweight meeting experience     device=${device}
    return to home screen   ${device}
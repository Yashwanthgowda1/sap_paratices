*** Settings ***
Resource   ../resources/keywords/common.robot
Documentation    Suite Setup Requirements : This suite requires minimum of 3 devices in config
...              Purpose: Device_1 and Device_2 should each create a meeting and add participants as follows:
...                       Device_1 should add Device_2 and Device_3
...                       Device_2 should add Device_1 and Device_3

Suite Setup    Hard Mute and Reaction Suite Setup
Suite Teardown    Run keyword and ignore error    Hard Mute and Reaction Suite Teardown

*** Variables ***
${wait_time} =   10

*** Test Cases ***
TC1 : [Reactions] DUT user to verify the reactions button in docked ubar while in call
    [Tags]  310942   sanity_tp      bvt_pr
    [Setup]    Testcase Setup   count=1
    join meeting   device=device_1    meeting=Hard_and_reaction
    Verify meeting state   device_list=device_1   state=Connected
    Verify reaction button in call control     device=device_1
    Tap on reaction button in call control      device=device_1
    End meeting     device=device_1
    Verify meeting state    device_list=device_1  state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1

TC2 : [Reactions] Reactions invoked by the user should be shown in the local preview
    [Tags]    310960    P2
    [Setup]   Testcase Setup   count=1
    join meeting   device=device_1    meeting=Hard_and_reaction
    Verify meeting state   device_list=device_1   state=Connected
    Verify reaction button in call control     device=device_1
    Tap on reaction button in call control      device=device_1
    Tap on like button     device=device_1
    End meeting     device=device_1
    Verify meeting state    device_list=device_1  state=Disconnected
    [Teardown]   run keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1

TC3 : [Reactions]Observe reactions when DUT rejoins the meeting
    [Tags]      319591   
    [Setup]  Testcase Setup   count=2
    join meeting   device=device_1,device_2    meeting=Hard_and_reaction
    Verify meeting state   device_list=device_1,device_2     state=Connected
    Tap on like button     device=device_1
    End meeting     device=device_1
    Verify meeting state    device_list=device_1    state=Disconnected
    Join Meeting    device=device_1       meeting=Hard_and_reaction
    Verify meeting state    device_list=device_1,device_2      state=Connected
    Tap on like button     device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]   run keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4 : [Hard Mute] Verify Organizer/presenter-can turn on hard mute, it disables mic for attendees with toggle
    [Tags]    437684   P1    bvt_tp    sanity_tp    smoke_tp      bvt_pr
    [Setup]  Testcase Setup   count=2
    join meeting   device=device_1,device_2    meeting=Hard_and_reaction
    Wait for Some Time   ${wait_time}
    Verify meeting state   device_list=device_1,device_2   state=Connected
    verify manage audio and video option    device=device_1    count=2   role=organiser
    Make an attendee    from_device=device_1       to_device=device_2
    Verify you are an attendee now notification     device=device_2
    Disable camera and mic for attendees   from_device=device_1   to_device=device_2    mic=off   camera=on
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC5 : [Hard Mute] verify "Manage audio and video" option in meeting
    [Tags]  437681   P1
    [Setup]  Testcase Setup   count=2
    join meeting   device=device_1,device_2    meeting=Hard_and_reaction
    Wait for Some Time   ${wait_time}
    Verify meeting state   device_list=device_1,device_2   state=Connected
    verify manage audio and video option    device=device_1    count=2   role=organiser
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC6 : [Hard Mute] verify "Manage audio and video" option not available for attendee.
    [Tags]  437682    P1
    [Setup]  Testcase Setup   count=2
    join meeting   device=device_1,device_2    meeting=Hard_and_reaction
    Wait for Some Time   ${wait_time}
    Verify meeting state   device_list=device_1,device_2   state=Connected
    verify manage audio and video option    device=device_1    count=2   role=organiser
    verify manage audio and video option    device=device_2    count=2    role=presenter
    Make an attendee    from_device=device_1       to_device=device_2
    Verify you are an attendee now notification     device=device_2
    verify manage audio and video option    device=device_2    count=2    role=attendee
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC7 : [Hard Mute] Verify "Disable mic for attendees", "Disable camera for attendees" option should be available in "manage audio or video."
    [Tags]  437683    P1
    [Setup]  Testcase Setup   count=2
    join meeting   device=device_1,device_2    meeting=Hard_and_reaction
    Wait for Some Time   ${wait_time}
    Verify meeting state   device_list=device_1,device_2   state=Connected
    verify manage audio and video option    device=device_1    count=2   role=organiser
    verify options to manage audio and video   device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

# Whiteboard sharing is not applicable on phones
#TC22 : [Reactions] DUT user to verify the reaction of TDC user when TDC user is not displayed on the main stage
#    [Tags]    310975    P2
#    [Setup]   Testcase Setup   count=2
#    join meeting   device=device_1,device_2    meeting=Hard_and_reaction
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify whiteboard sharing option under more option for ipphone      device=device_2
#    Tap on whiteboard sharing option    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify whiteboard successfully loaded     devices=device_1,device_2
#    Click back    device=device_1,device_2
#    Verify reaction button in call control     device=device_1
#    Tap on reaction button in call control      device=device_1
#    Tap on like button     device=device_2
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2  state=Disconnected
#    [Teardown]   run keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
Hard Mute and Reaction Suite Setup
    Testcase Setup    count=3
    clear all day meeting and meeting history from calendar   devices=device_1,device_2,device_3
    create meeting   device=device_1    meeting=Hard_and_reaction    participants=device_2,device_3
    create meeting   device=device_2    meeting=Meeting_with_tdc    participants=device_1,device_3

Hard Mute and Reaction Suite Teardown
    Suite Failure Capture
    Teardown meeting test case      devices=device_1,device_2,device_3
    clear all day meeting and meeting history from calendar   devices=device_1,device_2,device_3
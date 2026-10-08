*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation    Suite Setup Requirements : This suite requires minimum of 3 devices in config
...              Purpose: Device_2 should create meeting and add Device_3 as participant

Suite Setup     Meeting Suite Setup
Suite Teardown    Run keyword and ignore error    Meeting Suite Teardown

*** Variables ***
${wait_time} =  10

*** Test Cases ***

TC01 : [Phones] [Consent Recording] Should see agreement dialog when recording is initiated
    [Tags]  464882     sanity_tp
    [Setup]    Testcase Setup   count=3
    Join Meeting    device=device_2,device_3    meeting=test_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_2,device_3    state=Connected
    verify agreement dialog when recording is initiated     device=device_2
    Wait for Some Time    time=${wait_time}
    verify consent dialog     device=device_3     option=Ok
    End meeting     device=device_2,device_3
    Verify meeting state    device_list=device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3

TC02 : [Phones] [Consent Recording] Should be shown consent dialog when someone in the meeting starts recording.
    [Tags]  464883     sanity_tp
    [Setup]    Testcase Setup   count=3
    Join Meeting    device=device_2,device_3    meeting=test_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_2,device_3    state=Connected
    verify agreement dialog when recording is initiated     device=device_2
    Wait for Some Time    time=${wait_time}
    verify consent dialog    device=device_3     option=cancel
    verify consent dialog     device=device_3     option=ok
    End meeting     device=device_2,device_3
    Verify meeting state    device_list=device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3

TC03 : [Phones][ConsentRecording] Participant should be able to initiate recording of a meeting when consent is required
    [Tags]  464903        sanity_tp
    [Setup]    Testcase Setup   count=3
    Join Meeting    device=device_2,device_3    meeting=test_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_2,device_3    state=Connected
    verify agreement dialog when recording is initiated     device=device_2
    verify recording notification on screen     device=device_2
    End meeting     device=device_2,device_3
    Verify meeting state    device_list=device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3

TC04 : [Phones][ConsentRecording] Join a meeting that has already started recording
    [Tags]  464908   sanity_tp    
    [Setup]    Testcase Setup   count=3
    Join Meeting    device=device_2    meeting=test_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_2    state=Connected
    verify agreement dialog when recording is initiated     device=device_2
    verify recording notification on screen     device=device_2
    Join Meeting    device=device_3    meeting=test_meeting
    Wait for Some Time    time=${wait_time}
    verify consent recording dialog after joining meeting       device=device_3
    End meeting     device=device_2,device_3
    Verify meeting state    device_list=device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3

TC05 : [Phones][ConsentRecording] Use hard keys to unmute when in a meeting that is being recorded
    [Tags]  464909   P1
    [Setup]    Testcase Setup   count=3
    Join Meeting    device=device_2,device_3    meeting=test_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_2,device_3    state=Connected
    verify agreement dialog when recording is initiated     device=device_2
    Wait for Some Time    time=${wait_time}
    verify consent dialog     device=device_3     option=Ok   key=hard_key
    End meeting     device=device_2,device_3
    Verify meeting state    device_list=device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3

TC06 : [Phones][ConsentRecording] Consent dialog should be shown based on the policy of the organizer of the meeting
    [Tags]  464915   P1
    [Setup]    Testcase Setup   count=3
    Join Meeting    device=device_2,device_3    meeting=test_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_2,device_3    state=Connected
    verify agreement dialog when recording is initiated     device=device_2
    Wait for Some Time    time=${wait_time}
    verify consent dialog     device=device_3     option=Ok
    End meeting     device=device_2,device_3
    Verify meeting state    device_list=device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3

TC07 : [Phones][ConsentRecording] Should be able to unmute only after giving consent to recording
	[Tags]  464905      P2
	[Setup]     Testcase Setup   count=3
	Join Meeting    device=device_2,device_3    meeting=test_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_2,device_3    state=Connected
    verify agreement dialog when recording is initiated     device=device_3
    Wait for Some Time    time=${wait_time}
    verify consent dialog     device=device_2     option=Ok
    End meeting     device=device_2,device_3
    Verify meeting state    device_list=device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3


*** Keywords ***
Meeting Suite Setup
    Testcase Setup    count=2
    clear all day meeting and meeting history from calendar   devices=device_2,device_3
    Create Meeting  device=device_2      meeting=test_meeting     participants=device_3

Meeting Suite Teardown
    Suite Failure Capture
    Teardown meeting test case      devices=device_2
    clear all day meeting and meeting history from calendar   devices=device_2,device_3



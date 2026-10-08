*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***

${wait_time}    2 minutes

*** Test Cases ***
TC1:[Maintenance Restart] Verify the options under Device restart once DUT user enables toggle button under Teams admin settings
    [Tags]     438349       P2
    [Setup]    Testcase Setup for Meeting User   count=1
	Navigate to device option under teams admin setting   device=device_1
	enable and disable restart toggle    device=device_1     activity_state=on
	Verify Device restart options when DUT user enables the toggle in Teams admin settings     device=device_1
	Come back from admin settings page     device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND     desable Restart     device=device_1     AND     Come back to home screen    device_list=device_1

TC2:[Maintenance Restart] Verify the Device restart toggle button under teams admin settings
    [Tags]     438348       P2
    [Setup]    Testcase Setup for Meeting User   count=1
	Navigate to device option under teams admin setting   device=device_1
    Verify the Device restart toggle button under teams admin settings       device=device_1
	Come back from admin settings page     device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND     desable Restart     device=device_1     AND     Come back to home screen    device_list=device_1

TC3:[Maintenance Restart] Verify DUT user is able to schedule Maintenance Restart
    [Tags]     438339       bvt_sm      sanity_sm
    [Setup]    Testcase Setup for Meeting User   count=1
	Navigate to device option under teams admin setting   device=device_1
	enable and disable restart toggle    device=device_1     activity_state=on
	Verify DUT user is able to schedule Maintenance Restart          device=device_1            start_timer_after=1 min         end_timer_after=20 min
	Come back from admin settings page     device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND     desable Restart     device=device_1     AND     Come back to home screen    device_list=device_1

TC4:[Maintenance Restart] Verify Maintenance Restart is not happening when DUT is in Active call/Meeting
    [Tags]    438342     bvt_sm      sanity_sm
    [Setup]    Testcase Setup for Meeting User   count=1
    Navigate to device option under teams admin setting   device=device_1
	enable and disable restart toggle    device=device_1     activity_state=on
	Verify DUT user is able to schedule Maintenance Restart          device=device_1            start_timer_after=1 min         end_timer_after=20 min
	Come back from admin settings page     device_list=device_1
    Initiates conference meeting using Meet option     from_device=device_1     to_device=device_2
    Accept incoming call    device=device_2
    Close participants screen   device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Wait for Some Time    time=${wait_time}
    Check video call On state   device_list=device_1,device_2
    End meeting   device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND     desable Restart     device=device_1     AND     Come back to home screen    device_list=device_1

*** Keywords ***
Navigate to device option under teams admin setting
    [Arguments]    ${device}
    Navigate to teams admin settings page       ${device}
    navigate and verify teams setting option from device settings page      ${device}   option=general

Verify DUT user is able to Cancel the Restart
    [Arguments]     ${device}
    enable and disable restart toggle    device=device_1     activity_state=off

Verify the Device restart toggle button under teams admin settings
     [Arguments]     ${device}
    enable and disable restart toggle    device=device_1     activity_state=off

desable Restart
    [Arguments]     ${device}
    Come back from admin settings page     device_list=device_1
    Navigate to device option under teams admin setting     ${device}
    Verify DUT user is able to Cancel the Restart        ${device}

Verify DUT user is able to schedule Maintenance Restart
    [Arguments]     ${device}   ${start_timer_after}    ${end_timer_after}
    verify schedule maintenance restart        ${device}   ${start_timer_after}    ${end_timer_after}

Initiates conference meeting using Meet option
     [Arguments]     ${from_device}     ${to_device}
    Initiates conference meeting using Meet now option   ${from_device}     ${to_device}

disable Maintenance Restart toggle
    Navigate to device option under teams admin setting   device=device_1
    Verify the Device restart toggle button under teams admin settings       device=device_1
	Come back from admin settings page     device_list=device_1
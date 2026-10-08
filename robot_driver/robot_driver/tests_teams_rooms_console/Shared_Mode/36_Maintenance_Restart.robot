*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***

${wait_time}    2 minutes

*** Test Cases ***
TC1:[Maintenance Restart] Verify the options under Device restart once DUT user enables toggle button under Teams admin settings
    [Tags]      438188      P2
    [Setup]  Testcase Setup for shared User      count=1
    Navigate to app settings screen    console=console_1
    Navigate to meeting and calling options from device settings page   console=console_1   option=general
    enable and disable restart toggle    device=console_1     activity_state=on
	Verify Device restart options when DUT user enables the toggle in Teams admin settings     device=console_1
    Come back from admin settings page    device_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC2:[Maintenance Restart] Verify the Device restart toggle button under teams admin settings
    [Tags]      438187    P2
    [Setup]  Testcase Setup for shared User      count=1
    Navigate to app settings screen    console=console_1
    Navigate to meeting and calling options from device settings page   console=console_1   option=general
    Verify the Device restart toggle button under teams admin settings      device=console_1
    Come back from admin settings page    device_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC3:[Maintenance Restart] Verify DUT user is able to schedule Maintenance Restart
    [Tags]     437929   bvt_tc_sm    sanity_tc_sm
    [Setup]     Testcase Setup for shared User   count=1
	Navigate to app settings screen    console=console_1
    Navigate to meeting and calling options from device settings page   console=console_1   option=general
	enable and disable restart toggle    device=console_1     activity_state=on
	Verify DUT user is able to schedule Maintenance Restart          device=console_1             start_timer_after=1 min         end_timer_after=20 min
	Come back from admin settings page    device_list=console_1
    [Teardown]  Run Keywords    Capture Failure   AND    disable Maintenance Restart toggle   AND    Come back to home screen page   console_list=console_1

TC4:[Maintenance Restart] Verify Maintenance Restart is not happening when Console is in Active call/Meeting
    [Tags]     437932   bvt_tc_sm    sanity_tc_sm
    [Setup]     Testcase Setup for shared User   count=2
    Navigate to app settings screen    console=console_1
    Navigate to meeting and calling options from device settings page   console=console_1   option=general
	enable and disable restart toggle    device=console_1     activity_state=on
	Verify DUT user is able to schedule Maintenance Restart          device=console_1             start_timer_after=1 min         end_timer_after=20 min
	Come back from admin settings page    device_list=console_1
    Start meeting using meet now   from_device=console_1    to_device=device_2
    Accept incoming call   device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Wait for Some Time    time=${wait_time}
    Verify call control bar options     console=console_1
    End up call     console=console_1       device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure     AND    disable Maintenance Restart toggle   AND    Come back to home screen page   console_list=console_1   device_list=device_2


*** Keywords ***
Navigate to app settings screen
    [Arguments]   ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Verify the Device restart toggle button under teams admin settings
     [Arguments]     ${device}
    enable and disable restart toggle        ${device}     activity_state=off

Verify DUT user is able to schedule Maintenance Restart
    [Arguments]     ${device}   ${start_timer_after}    ${end_timer_after}
    verify schedule maintenance restart        ${device}   ${start_timer_after}    ${end_timer_after}


Verify DUT user is able to Cancel the Restart
    [Arguments]     ${device}
    enable and disable restart toggle    device=console_1     activity_state=off

Verify call control bar options
    [Arguments]    ${console}
    Verify docked ubar options      ${console}

End up call
    [Arguments]    ${console}    ${device}
    Disconnect the call  ${console}
    Disconnect call     ${device}

disable Maintenance Restart toggle
    Navigate to app settings screen    console=console_1
    Navigate to meeting and calling options from device settings page   console=console_1   option=general
    Verify the Device restart toggle button under teams admin settings      device=console_1
    Come back from admin settings page    device_list=console_1
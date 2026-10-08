#*** Settings ***
#Documentation   Meeting created as prerequisite before test execution
#Library     DateTime
#Resource    ../../resources/keywords/common.robot
#*** Variables ***
#*** Test Cases ***
#TC1:[Meetings]Verify that no meeting name is shown for All day meeting when "Show meeting names" option is disabled
#    [Tags]  303656  p2
#    [Setup]    Testcase Setup for Meeting User   count=1
#    tap on all day meetings title bar and validate  device=device_1
#    ${meeting_name_before_disabling_show_meeting_names}=  Get meeting name   device=device_1
#    Navigate to app settings page    device=device_1
#    navigate to meetings option in device settings page      device=device_1
#    hide or unhide meeting names     device=device_1   state=off
#    Come back from admin settings page      device_list=device_1
#    ${meeting_name_after_disabling_show_meeting_names}=  Get meeting name    device=device_1
#    Verify meeting name on homescreen after disabling   device_1    ${meeting_name_before_disabling_show_meeting_names}    ${meeting_name_after_disabling_show_meeting_names}
#    [Teardown]  Run Keywords    Capture on Failure  AND     Modify show meeting names option     device=device_1   state=on
#
#TC5:[Meetings]Verify that while connecting meeting ,meeting name must be displayed
#    [Tags]  260632    P2
#    [Setup]  Testcase Setup for Meeting User    count=1
#    ${meeting_name_before_disabling_show_meeting_names}=  Get meeting name    device=device_1
#    Modify show meeting names option     device=device_1   state=off
#    ${meeting_name_after_disabling_show_meeting_names}=  Get meeting name    device=device_1
#    Verify meeting name on homescreen after disabling   device_1    ${meeting_name_before_disabling_show_meeting_names}    ${meeting_name_after_disabling_show_meeting_names}
#    join rooms meeting after hiding the title name   device=device_1    organizer_name=device_1:meeting_user
#    Verify meeting state   device_list=device_1   state=Connected
#    End meeting   device=device_1
#    Verify meeting state   device_list=device_1   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure     AND  Come back to home screen    device_list=device_1   AND  Modify show meeting names option     device=device_1   state=on

#*** Keywords ***

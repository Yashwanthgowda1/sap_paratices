#*** Settings ***
#Documentation   Meeting created as prerequisite before test execution
#Force Tags    sm_meetings     sm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../../resources/keywords/common.robot
#*** Test Cases ***
#TC5:[Meeting] While the meeting is being joined, a progress screen and list of participants is displayed
#    [Tags]    315041    bvt_tc_sm    sanity_tc_sm
#    [Setup]   Testcase Setup for shared User     count=2
#    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Verify and view list of participant    console=console_1
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2
#
#*** Keywords ***

#*** Settings ***
#Documentation   Meeting created as prerequisite before test execution
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#*** Variables ***
#*** Test Cases ***
#TC4:[DGJ]Zoom Meeting Should be displayed in Home screen
#    [Tags]   327956     bvt_sm   sanity_sm      exclude_ftp_sm
#    [Setup]  Testcase Setup for Meeting User     count=1
#    Verify meeting display on home screen     device=device_1
#    Zoom Meeting Should be displayed in Home screen
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1
#
#TC5:[DGJ]DUT user should be able to join Zoom Meeting from Teams
#    [Tags]  327957    bvt_sm   sanity_sm        exclude_ftp_sm
#    [Setup]  Testcase Setup for Meeting User     count=1
#    Verify meeting display on home screen     device=device_1
#    Join meeting   device=device_1    meeting=zoom_meeting
#    Verify meeting state   device_list=device_1    state=Connected
#    End meeting      device=device_1
#    Verify meeting state    device_list=device_1   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1
#
#TC8:[DGJ]DUT user should be able to join Zoom Meeting from Teams and See call control options
#    [Tags]      327958   P1     sanity_sm   exclude_ftp_sm
#    [Setup]  Testcase Setup for Meeting User     count=1
#    Verify meeting display on home screen     device=device_1
#    Join meeting   device=device_1     meeting=zoom_meeting
#    Verify meeting state   device_list=device_1    state=Connected
#    verify the docked ubar when third party meeting joins    device=device_1
#    End meeting      device=device_1
#    Verify meeting state    device_list=device_1   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1
#
#TC11:[DGJ]Zoom icon should be displayed for the meeting created with Zoom Link on Calendar
#    [Tags]      327973   445034      P1   sanity_sm       exclude_ftp_sm
#    [Setup]  Testcase Setup for Meeting User     count=1
#    Verify meeting display on home screen     device=device_1
#    verify zoom icon on calendar tab     device=device_1
#    Zoom Meeting Should be displayed in Home screen
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1
#
#*** Keywords ***

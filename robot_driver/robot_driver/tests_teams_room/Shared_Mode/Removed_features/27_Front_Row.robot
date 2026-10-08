#*** Settings ***
#Resource    ../../resources/keywords/common.robot
#
#*** Variables ***
#*** Test Cases ***
#TC15:[Front Row] Verify Top bar in the meeting when DUT user selects Front Row Layout
#    [Tags]     445165         P1    sanity_sm
#    [Setup]    Testcase Setup for Meeting User      count=2
#    Verify meeting display on home screen     device=device_1
#    Join meeting   device=device_1,device_2    meeting=lock_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    verify Front Row mode and Top bar in the meeting     device=device_1
#    End meeting      device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2        state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#

#TC14:[Front Row] Verify Front row option is present under Layout option on call control bar.
#     [Tags]      445152         P0
#    [Setup]    Testcase Setup for Meeting User      count=2
#    Verify meeting display on home screen     device=device_1
#    Join meeting   device=device_1,device_2    meeting=lock_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify front row on call control bar    device=device_1    mode=front_row
#    End meeting      device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2        state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC13:[Front row] Verify the toggle of "Default to front Row.
#    [Tags]      382265       P2
#     [Setup]    Testcase Setup for Meeting User      count=1
#    Navigate to app settings page    device=device_1
#    navigate to meetings option in device settings page      device=device_1
#    verify front row toggle from device setting     device=device_1
#    device setting back  device=device_1
#    device setting back  device=device_1
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1
#
#TC12:[Front Row] Check for the Front row behavior at the Teams admin settings page
#     [Tags]      382003        P2
#    [Setup]    Testcase Setup for Meeting User      count=3
#    Navigate to app settings page    device=device_1
#    navigate to meetings option in device settings page      device=device_1
#    Enable front row toggle from device setting     device=device_1         default_state_layout=front_row
#    Join meeting   device=device_2,device_3    meeting=lock_meeting
#    Verify meeting state   device_list=device_2,device_3    state=Connected
#    Add participant to conversation using display name     from_device=device_2      to_device=device_1:meeting_user
#    Accept incoming call    device=device_1
#    Close participants screen   device=device_2
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    verify front row mode      device=device_1
#    End meeting      device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_2,device_3        state=Disconnected
#    Enable front row toggle from device setting     device=device_1         default_state_layout=Content_Gallery
#    Navigate back from the device settings page     device=device_1
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3
#

#*** Keywords ***

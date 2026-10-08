#*** Settings ***
#Resource    ../resources/keywords/common.robot
#*** Variables ***
#*** Test Cases ***
#TC3 : [Spotlight] Remove spotlight option should be displayed for spotlighted participant
#    [Tags]  237969    p1    sanity_sm
#    [Setup]    Testcase Setup for Meeting User   count=3
#    Join Meeting    device=device_1,device_2,device_3     meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    make a spotlight   from_device=device_2   to_device=device_1:meeting_user
#    verify spotlight text on device   device=device_1   text=spotlight
#    Close participants screen   device=device_2
#    verify spotlight icon    device=device_3
#    Remove spotlight from other user    from_device=device_2   to_device=device_1:meeting_user
#    verify spotlight text on device   device=device_1   text=no_spotlight
#    Close participants screen   device=device_2
#    verify spotlight icon disable       device=device_3
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3
#
#TC4 : [Spotlight] Spotlight should end once the spotlighted user leaves the meeting
#    [Tags]      237971      bvt     bvt_sm  sanity_sm
#    [Setup]    Testcase Setup for Meeting User   count=3
#    Join Meeting    device=device_1,device_2,device_3    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    make a spotlight   from_device=device_2   to_device=device_3
#    verify spotlight text on device   device=device_3   text=spotlight
#    Close participants screen   device=device_2
#    verify spotlight icon    device=device_1
#    End meeting     device=device_3
#    Verify meeting state    device_list=device_3    state=Disconnected
#    Join Meeting    device=device_3        meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    spotlight icon should not present    device=device_3
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3
#
#TC2:[Spotlight] TDC user spotlight the remote participant during meeting
#    [Tags]       237963      p2
#    [Setup]    Testcase Setup for Meeting User   count=3
#    Join Meeting    device=device_1,device_2,device_3     meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    make a spotlight   from_device=device_2   to_device=device_1:meeting_user
#    verify spotlight text on device   device=device_1   text=spotlight
#    Close participants screen   device=device_2
#    verify spotlight icon    device=device_3
#    verify spotlight icon on main screen in the meeting  device=device_3
#    Remove spotlight from other user    from_device=device_2   to_device=device_1:meeting_user
#    verify spotlight text on device   device=device_1   text=no_spotlight
#    Close participants screen   device=device_2
#    verify spotlight icon disable      device=device_3
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND         Come back to home screen    device_list=device_1,device_2,device_3

#*** Keywords ***

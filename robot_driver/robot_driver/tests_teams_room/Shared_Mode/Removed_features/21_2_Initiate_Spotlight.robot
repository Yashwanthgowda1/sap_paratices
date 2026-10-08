#*** Settings ***
#Resource    ../../resources/keywords/common.robot
#*** Variables ***
#*** Test Cases ***
#TC1:[Initiate Spotlight] Verify that start spotlight is available.
#    [Tags]    379720       bvt_sm      sanity_sm
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Join Meeting    device=device_1,device_2    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    verify the start spotlight   from_device=device_1       to_device=device_2
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2
#
#TC3:[Initiate Spotlight] Verify that spotlighted participant is spotlighted locally.
#     [Tags]      379725        P2    sanity_sm
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Join Meeting    device=device_1,device_2    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    make a spotlight   from_device=device_1      to_device=device_1:meeting_user
#    verify spotlight text on device   device=device_1   text=spotlight
#    Close participants screen   device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2  state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2
#
#TC5:[Initiate Spotlight] Verify spotlighted participant after rejoining call.
#    [Tags]     379729      bvt_sm      sanity_sm
#    [Setup]    Testcase Setup for Meeting User   count=3
#    Join Meeting    device=device_1,device_2,device_3    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    make a spotlight   from_device=device_1          to_device=device_2
#    verify spotlight text on device   device=device_2   text=spotlight
#    Close participants screen   device=device_1
#    verify spotlight icon    device=device_1
#    End meeting     device=device_1
#    Verify meeting state    device_list=device_1    state=Disconnected
#    Join Meeting    device=device_1        meeting=cnf_device_meeting
#    verify spotlight icon       device=device_1
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3
#
#
#TC4:[Initiate Spotlight] Verify stop spotlight locally.
#    [Tags]     379731    P2
#    [Setup]    Testcase Setup for Meeting User   count=3
#    Join Meeting    device=device_1,device_2,device_3    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    make a spotlight   from_device=device_1          to_device=device_1:meeting_user
#    verify spotlight text on device   device=device_1   text=spotlight
#    Close participants screen   device=device_1
#    remove spotlight     from_device=device_1         to_device=device_1:meeting_user
#    verify spotlight text on device   device=device_1   text=no_spotlight
#    Close participants screen   device=device_1
#    verify spotlight icon disable      device=device_1
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3
#
#TC3:[Initiate Spotlight] Verify stop spotlight is available in roster.
#    [Tags]     379730      P2
#    [Setup]    Testcase Setup for Meeting User   count=3
#    Join Meeting    device=device_1,device_2,device_3     meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    make a spotlight   from_device=device_1       to_device=device_2
#    verify spotlight text on device   device=device_2   text=spotlight
#    Close participants screen   device=device_1
#    verify spotlight icon    device=device_1
#    remove spotlight  from_device=device_1         to_device=device_2
#    Close participants screen   device=device_1
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3
#
#TC1:[Initiate Spotlight] Verify that start spotlight pop is displayed.
#    [Tags]      379721      P2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Join Meeting    device=device_1,device_2    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    make a spotlight   from_device=device_1      to_device=device_2
#    verify spotlight text on device   device=device_2   text=spotlight
#    Close participants screen   device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2


#*** Keywords ***

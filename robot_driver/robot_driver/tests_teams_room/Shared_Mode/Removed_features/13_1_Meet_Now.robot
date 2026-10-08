#*** Settings ***
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#*** Variables ***
#*** Test Cases ***
#TC1: [Meet now] Meet now icon should be present on Home screen after Sign-in
#    [Tags]   259695     bvt_sm      sanity_sm
#    [Setup]   Testcase Setup for Meeting User    count=1
#    Validate that signin is successfully completed    device_list=device_1     state=Sign in
#    Verify Meet now icon present on home screen  device=device_1
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1
#
#TC3: [Meet now] DUT user invites TDC user into meeting using DID number
#     [Tags]   259700   bvt   bvt_sm  sanity_sm
#    [Setup]   Testcase Setup for Meeting User     count=2
#    Initiates meeting using Meet now option using DID    from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Close participants screen   device=device_1
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Disconnect call   device=device_2
#    End meeting   device=device_1
#    Verify meeting state    device_list=device_1,device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#TC6: [Meet now] Verify DUT user is able to view the Live caption during meeting
#    [Tags]   259711   sanity_sm
#    [Setup]   Testcase Setup for Meeting User     count=3
#    Initiates conference meeting using Meet now option    from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Close participants screen   device=device_1
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    Accept incoming call      device=device_3
#    Close participants screen   device=device_1
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Connected
#    Check video call On state    device_list=device_1,device_2,device_3
#    Verify live captions visibility   device=device_1
#    End meeting   device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#TC7:[Meet now] Start Meet now and Far mute Participants in call
#    [Tags]   259713   P2
#    [Setup]   Testcase Setup for Meeting User     count=3
#    Initiates conference meeting using Meet now option   from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Close participants screen   device=device_1
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    Accept incoming call      device=device_3
#    Close participants screen   device=device_1
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Connected
#    Check video call On state   device_list=device_1,device_2,device_3
#    Farmute the call and validate   from_device=device_1     to_device=device_2
#    Verify meeting Mute State    device_list=device_2    state=mute
#    Unmutes the meeting    device=device_2
#    Verify meeting Mute State    device_list=device_2    state=Unmute
#    Close participants screen   device=device_1
#    End meeting   device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#TC5:[Meet now] Start Meet now, Remove Participants from call
#    [Tags]   259699   P2
#    [Setup]   Testcase Setup for Meeting User     count=3
#    Initiates conference meeting using Meet now option    from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Close participants screen   device=device_1
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Check video call On state   device_list=device_1,device_2
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    Accept incoming call      device=device_3
#    Close participants screen   device=device_1
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Connected
#    Remove user from meeting call   from_device=device_1      to_device=device_3
#    Verify someone removed you from the meeting call  device=device_3
#    Close participants screen   device=device_1
#    Verify meeting state    device_list=device_1,device_2    state=Connected
#    End meeting   device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#TC11:[Meet now] Start Meet now, Verify mute UI on DUT in meeting
#     [Tags]    259694       P2
#    [Setup]   Testcase Setup for Meeting User     count=3
#    Initiates conference meeting using Meet now option     from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Close participants screen   device=device_1
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    Accept incoming call      device=device_3
#    Close participants screen   device=device_1
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    Farmute the call and validate   from_device=device_1     to_device=device_2
#    verify farmute text on device   device=device_2     text=you have been muted
#    verify mute off icon      device=device_2
#    Close participants screen  device=device_1
#    Farmute the call and validate   from_device=device_1     to_device=device_3
#    verify farmute text on device     device=device_3     text=you have been muted
#    verify mute off icon      device=device_3
#    Close participants screen   device=device_1
#    End meeting   device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3

#*** Keywords ***




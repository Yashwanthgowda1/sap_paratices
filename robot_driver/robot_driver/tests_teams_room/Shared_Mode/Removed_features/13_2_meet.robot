#*** Settings ***
#Resource    ../resources/keywords/common.robot
#
#*** Variables ***
#*** Test Cases ***
#TC3:[Meet]Verify the educational message when user arrives is ad-hoc meeting
#    [Tags]       344892      P1     sanity_sm
#    [Setup]   Testcase Setup for Meeting User     count=2
#    Verify Meet icon present on home screen      device=device_1
#    verify educational message when user arrives is ad-hoc meeting     device=device_1
#    verify that after clicking the meetnow it will join the meeting directly        device=device_1
#    Initiates conference meeting using Meet option     from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Close participants screen   device=device_1
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Check video call On state   device_list=device_1
#    End meeting   device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#TC5:[Meet] Verify the DUT can share whiteboard during 1:1 meet now
#    [Tags]   344895     P2
#    [Setup]   Testcase Setup for Meeting User     count=2
#    Initiates conference meeting using Meet now option     from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Close participants screen   device=device_1
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Check video call On state   device_list=device_1,device_2
#    verify whiteboard sharing option under more option   device=device_1
#    Wait for Some Time    time=${action_time}
#    Check for whiteboard visibility of participants and validate    from_device=device_1    connected_device_list=device_1,device_2
#    Stop presenting whiteboard share screen     device=device_1
#    Wait for Some Time    time=${wait_time}
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC4:[Meet] Verify the UI after Selecting Meet button on the home screen
#    [Tags]      344888     P2
#    [Setup]   Testcase Setup for Meeting User     count=2
#    Initiates conference meeting using Meet option     from_device=device_1     to_device=device_2
#    Wait for Some Time    time=${action_time}
#    Close participants screen   device=device_1
#    Verify meeting state   device_list=device_1    state=Connected
#    Check video call On state   device_list=device_1
#    End meeting   device=device_1
#    Verify meeting state    device_list=device_1   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2

#*** Keywords ***

#*** Settings ***
#Resource    ../../resources/keywords/common.robot
#*** Variables ***
#*** Test Cases ***
#TC4:[Chat]Verify the chat option in P2P incoming call when show meeting chat is disabled in admin settings.
#    [Tags]   379972       P1         sanity_sm
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Disable the show meeting chat option    device=device_1
#    Make outgoing call with phonenumber    from_device=device_2     to_device=device_1:meeting_user
#    Accept incoming call  device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    verify that chat toggle button is not present    device=device_1
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2  AND     Enable the show meeting chat option     device=device_1
#
#TC11:[Chat]Verify the chat option in P2P outgoing call when show meeting chat is disabled in admin settings.
#    [Tags]    379975     P2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Disable the show meeting chat option    device=device_1
#    Make outgoing call with phonenumber    from_device=device_2     to_device=device_1:meeting_user
#    Accept incoming call  device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    verify that chat toggle button is not present    device=device_1
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure    AND  Come back to home screen    device_list=device_1,device_2    AND     Enable the show meeting chat option     device=device_1
#
#TC10:[Chat]Verify the chat option in P2P outgoing call when user enables chat option.
#    [Tags]    379974      P2
#    [Setup]  Testcase Setup for Meeting User     count=2
#    Make outgoing call with phonenumber    from_device=device_2     to_device=device_1:meeting_user
#    Accept incoming call  device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Verify that chat toggle button should be disabled by default    device=device_1
#    Enable and disable the chat toggle in meeting   device=device_1   state=on
#    Verify the chat options in meeting      device=device_1
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC8:[Chat]Verify the chat option in P2P incoming call when user enables chat option.
#    [Tags]     379971       P2
#    [Setup]  Testcase Setup for Meeting User     count=2
#    Make outgoing call with phonenumber    from_device=device_2     to_device=device_1:meeting_user
#    Accept incoming call  device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Verify that chat toggle button should be disabled by default    device=device_1
#    Enable and disable the chat toggle in meeting   device=device_1   state=on
#    Verify the chat options in meeting      device=device_1
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2


#*** Keywords ***

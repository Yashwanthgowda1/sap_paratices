#*** Settings ***
#Documentation   Validating the test cases realted to Landing Page feature
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#*** Test Cases ***
#TC6: [Landing Page] Verify No meeting schedule for the day
#    [Tags]   238030     sanity_sm       P1
#    [Setup]  Testcase Setup for Meeting User     count=1
#    Verify no meeting schedule on landing page    device=device_1
#    [Teardown]   Run Keywords   Capture on Failure   AND    Come back to home screen     device_list=device_1
#
#TC2:[Landing Page] DUT user rejects the incoming call from Teams Desktop Client
#    [Tags]   238026   P2
#    [Setup]  Testcase Setup for Meeting User     count=2
#    Verify home page screen     device=device_1
#    Make outgoing call with phonenumber    from_device=device_2     to_device=device_1:meeting_user
#    Reject incoming call     device_list=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2
#

#TC4:[Landing Page] DUT user to verify incoming video call
#    [Tags]   238025   P1
#    [Setup]  Testcase Setup for Meeting User     count=2
#    Make Video call using display name   from_device=device_2     to_device=device_1:meeting_user
#    Accept incoming call      device=device_1
#    Close participants screen   device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Verify participants list during call      device=device_1
#    Disconnect call      device=device_1,device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2
#
#TC5:[Landing Page] DUT user to view and able start meeting using Meet now
#    [Tags]   238010   P1
#    [Setup]  Testcase Setup for Meeting User     count=2
#    Initiates conference meeting using Meet now option    from_device=device_1     to_device=device_2
#    Reject incoming call      device_list=device_2
#    Close participants screen   device=device_1
#    Verify Call State    device_list=device_2     state=Disconnected
#    Disconnect call      device=device_1
#    Verify Call State    device_list=device_1    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2
#
#TC6:[Landing Page]DUT user able to view dial-pad on Landing screen
#    [Tags]   238009   P1
#    [Setup]  Testcase Setup for Meeting User      count=2
#    Verify dial pad present on landing page   device=device_1
#    Dial number from dial pad     from_device=device_1      to_device=device_2
#    Accept incoming call   device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen   device_list=device_1,device_2

#*** Keywords ***

#*** Settings ***
#Documentation   Call Controls
#Library     DateTime
#Library     OperatingSystem
#Resource    ../../resources/keywords/common.robot
#*** Variables ***
#*** Test Cases ***
#
#TC12:[Call]DUT user able to raise /lower hand in the Call.
#    [Tags]     444821    P1       sanity_sm
#    [Setup]   Testcase Setup for Meeting User  count=3
#    Make outgoing call with displayname   from_device=device_1     to_device=device_2
#    Accept incoming call      device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    Accept incoming call    device=device_3
#    Close participants screen   device=device_1
#    Verify list of participants   from_device=device_1      connected_device_list=device_1:meeting_user,device_2,device_3
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    select raise hand option    device=device_3
#    verify raise hand reaction  device=device_3
#    lower the raised hand from another user     from_device=device_1   to_device=device_3
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC21:[Call-App] Verify the call button behavior after contacts selected and number dialed.
#    [Tags]         444765      P2
#    [Setup]  Testcase Setup for Meeting User    count=1
#    test call button behavior with and without displayname    device=device_1
#    verify multiple displayname entry       device=device_1
#    [Teardown]    Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1

#*** Keywords ***

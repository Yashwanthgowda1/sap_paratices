*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${60_minutes_wait_time} =   60 minutes

*** Test Cases ***
#TC1 : [Call Hold] DUT holds the call with PSTN user for 60 minutes
#    [Tags]  148747      P2
#    [Setup]  Testcase Setup for CAP PSTN User    count=2
#    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2:pstn_user
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Hold the call   device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Hold
#    Wait for Some Time    time=${60_minutes_wait_time}
#    Resume the call   device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Resume
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2


TC2 : [Multiple Call Banner] DUT user can hold the muted call with the PSTN user
    [Tags]   314028     bvt_cap  sanity_cap
    [Setup]    Testcase Setup for CAP PSTN User   count=2
    click on calls tab    device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_1
    Verify Call mute State    device_list=device_1    state=mute
    Wait for Some Time    time=${wait_time}
    Hold the call    device=device_1
    Verify Call State    device_list=device_1     state=Hold
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3 : [Multiple Call Banner] DUT user to tap on back button when call is on hold with PSTN user
    [Tags]   314032      P2
    [Setup]   Testcase Setup for CAP PSTN User   count=2
    click on calls tab    device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call     device=device_1
    Verify Call State    device_list=device_1    state=Hold
    Disconnect call      device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC4 : [Call hand off] Verify that DUT to add PSTN to the call
    [Tags]   316138     p2
    [Setup]  Testcase Setup for CAP PSTN User    count=4
    Signin with other user    device=device_3   other_user_account=device_1:cap_search_enabled
    click on calls tab    device=device_4
    Make outgoing call using phonenumber    from_device=device_4      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_3
    Verify Call State     device_list=device_3,device_4    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Add this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3,device_4    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Connected
    Disconnect call     device=device_1,device_2,device_4
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4


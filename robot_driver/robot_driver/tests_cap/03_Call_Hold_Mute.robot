*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10
${60s_wait_time} =  60
${action_time} =  3
${10_minutes_wait_time} =  10 minutes
${60_minutes_wait_time} =   60 minutes
${30_minutes_wait_time} =  30 minutes

*** Test Cases ***
TC1 : [Call Mute] User to test Mute/unmute the call from UI
    [Tags]  148798   P1    bvt_cap   sanity_cap        Certification_cap
    [Setup]  Testcase Setup for CAP User    count=2
    click on people tab     device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_1
    Verify meeting Mute State    device_list=device_1    state=mute
    Unmutes the phone call  device=device_1
    Verify meeting Mute State    device_list=device_1    state=Unmute
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : [Call Hold] DUT user hold the call with Teams Desktop Client
    [Tags]  150047    P1    bvt_cap  sanity_cap        Certification_cap
    [Setup]  Testcase Setup for CAP User    count=2
    click on people tab     device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Hold
    Resume the call   device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2     state=Resume
    repeat keyword   4 times    Hold and Resume the call
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3 : [Call Hold] DUT user toggle hold/resume between two teams client users
    [Tags]  148691    P2        Certification_cap
    [Setup]  Testcase Setup for CAP User    count=3
    click on people tab     device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    click on calls tab    device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1:cap_search_enabled
    Verify call notification    device=device_1     status=appear
    Pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2     state=Hold
    Resume call from call hold banner     device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify Call State    device_list=device_3     state=Hold
    Resume call from call hold banner     device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2     state=Hold
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4: [Call Hold] DUT user to hold the call with another DUT user
    [Tags]  148978    P2
    [Setup]  Testcase Setup for CAP User    count=2
    click on people tab     device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    repeat keyword  4 times     Hold and Resume the call
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC5 : [Call Hold] DUT user can hold the call when is already on hold from far end
    [Tags]  150003      P2
    [Setup]  Testcase Setup for CAP User    count=2
    click on calls tab    device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call   device=device_2
    Verify Call State    device_list=device_1,device_2    state=Hold
    Hold the call   device=device_1
    Verify Call State    device_list=device_1    state=Hold
    Resume the call   device=device_2
    Verify Call State    device_list=device_1    state=Hold
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

#Removed below Test Case as it required hard key intervention as per test plan
#TC6 : [Call Hold] DUT user can disconnect the call when is already on hold from farend
#    [Tags]  150004   P2
#    [Setup]  Testcase Setup for CAP User    count=2
#    click on calls tab    device=device_2
#    Make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Hold the call   device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Hold
#    Hold the call   device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Hold
#    Wait for Some Time    time=${10_minutes_wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Hold
#    Disconnect call     device=device_1,device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC7 : [Call Hold] DUT user can hold the call when is already on mute from far end
    [Tags]  150005     P2
    [Setup]   Testcase Setup for CAP User    count=2
    click on calls tab    device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_2
    Verify Call mute State     device_list=device_2    state=mute
    Hold the call   device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    Verify call mute state    device_list=device_2    state=mute
    Unmutes the phone call  device=device_2
    Verify Call mute State    device_list=device_2    state=Unmute
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC8 : [Call Mute] DUT user can mute the call when is already on mute from far-end
    [Tags]  150006    P2
    [Setup]   Testcase Setup for CAP User    count=2
    click on calls tab    device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_2
    Verify Call mute State    device_list=device_2    state=mute
    Mutes the phone call    device=device_1
    Verify Call mute State    device_list=device_1,device_2    state=mute
    Unmutes the phone call  device=device_1
    Verify Call mute State    device_list=device_1    state=Unmute
    Unmutes the phone call  device=device_2
    Verify Call mute State    device_list=device_2    state=Unmute
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC9 : [Call Mute] DUT user can mute the call when is already on hold from far end
    [Tags]  150007    P2
    [Setup]   Testcase Setup for CAP User    count=2
    click on calls tab    device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call   device=device_2
    Verify Call State    device_list=device_1,device_2     state=Hold
    Mutes the phone call    device=device_1
    Verify Call mute State    device_list=device_1    state=mute
    Resume the call   device=device_2
    Verify Call State    device_list=device_1,device_2     state=Resume
    Verify Call mute State    device_list=device_1   state=mute
    Unmutes the phone call  device=device_1
    Verify Call mute State    device_list=device_1    state=Unmute
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC10 : [Call Hold] DUT user can hold the muted call
    [Tags]  150008    P2     sanity_cap
    [Setup]   Testcase Setup for CAP User    count=2
    click on calls tab    device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_1
    Verify Call mute State    device_list=device_1    state=mute
    Hold the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Hold
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    Verify Call mute State    device_list=device_1   state=mute
    Unmutes the phone call  device=device_1
    Verify Call mute State    device_list=device_1    state=Unmute
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC11 : [Call Mute] DUT user mutes/unmutes the call with Teams client for 30 mins
    [Tags]  148688  P2
    [Setup]  Testcase Setup for CAP User    count=2
    click on people tab    device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_1
    Verify meeting Mute State    device_list=device_1    state=mute
    Wait for Some Time    time=${30_minutes_wait_time}
    Unmutes the phone call  device=device_1
    Verify meeting Mute State    device_list=device_1    state=Unmute
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC12 : [Call Hold] DUT holds the call with Teams client for 60 minutes
    [Tags]  148690  P2
    [Setup]  Testcase Setup for CAP User    count=2
    click on people tab    device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Hold
    Wait for Some Time    time=${60_minutes_wait_time}
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
Hold and Resume the call
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Hold
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume

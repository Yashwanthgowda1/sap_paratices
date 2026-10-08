*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10
${wait_time2} =  25
${action_time} =  3
${30_minutes_wait_time} =  30 minutes
${2_minutes_wait_time} =  2 minutes

*** Test Cases ***
TC1 : [Call Hold] DUT user can hold the muted call
    [Tags]   306071  sanity_tpc  P1
    [Setup]   Testcase Setup for Meeting User    count=2
    Navigate to people tab    device=device_1
    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_1
    Verify meeting Mute State    device_list=device_1    state=mute
    Hold the call   device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    Verify meeting Mute State    device_list=device_1    state=mute
    Unmutes the phone call  device=device_1
    Verify meeting Mute State    device_list=device_1    state=Unmute
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : DUT user can mute the call when it is already on hold from far-end
    [Tags]      306070
    [Setup]   Testcase Setup for Meeting User    count=2
    Navigate to people tab    device=device_1
    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    Mutes the phone call    device=device_2
    Verify meeting Mute State    device_list=device_2    state=mute
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    Unmutes the phone call  device=device_2
    Verify meeting Mute State    device_list=device_2    state=Unmute
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3 : [Call Mute] DUT user mutes/unmutes the call with TDC for 30 mins
    [Tags]   306064   P2
    [Setup]  Testcase Setup for Meeting User    count=2
    Navigate to people tab    device=device_1
    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_1
    Verify meeting Mute State    device_list=device_1    state=mute
    Wait for Some Time    time=${30_minutes_wait_time}
    Unmutes the phone call  device=device_1
    Verify meeting Mute State    device_list=device_1    state=Unmute
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC4 : [Call Mute] User to test Mute/unmute the call from UI
    [Tags]  306063   bvt_tpc     sanity_tpc  P0
    [Setup]  Testcase Setup for Meeting User    count=2
    Navigate to people tab    device=device_1
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

TC5 : [Call Hold] DUT user to hold the call with another DUT user
    [Tags]  306060
    [Setup]  Testcase Setup for Meeting User    count=2
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    repeat keyword  4 times     Verify hold resume scenario
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC6 : [Call Hold] DUT user toggle hold/resume between two TDC users
    [Tags]  306061   P2
    [Setup]  Testcase Setup for Meeting User    count=3
    Navigate to people tab    device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call from call notification    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2     state=Hold
    resume call from call hold banner     device=device_1
    Wait for Some Time    time=${action_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify Call State    device_list=device_3     state=Hold
    resume call from call hold banner     device=device_1
    Wait for Some Time    time=${action_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2     state=Hold
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC7 :[Call Hold] DUT user hold the call with TDC
    [Tags]  306072     bvt_tpc   sanity_tpc  P0
    [Setup]   Testcase Setup for Meeting User    count=2
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    repeat keyword  4 times     Verify hold resume scenario
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC8 : [Calls] Verify Back button, tap to return to call and End button during P2P call.
    [Tags]  380100     bvt_tpc   sanity_tpc  P0
    [Setup]   Testcase Setup for Meeting User    count=2
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    click back    device=device_1
    tap to return to call   device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC9 : [Calls] Verify DUT user able to navigate the Device Settings page and stay there 2-3 minutes while on a P2P Call.
    [Tags]  402704     P1    sanity_tpc
    [Setup]   Testcase Setup for Meeting User    count=2
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    click back   device=device_1
    Opens partner settings page     device=device_1
    Wait for Some Time    time=${2_minutes_wait_time}
    device setting back    device=device_1
    tap to return to meeting     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2

TC10 : [Call Park] DUT user able to resume the call, when call is parked for second time.
    [Tags]      401410   P1     sanity_tpc
    [Setup]   Testcase Setup for Meeting User    count=2
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    click call park    device=device_1
    go back to previous page      device=device_1
    verify and click in call park banner     from_device=device_1     to_device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    click call park    device=device_1
    go back to previous page      device=device_1
    verify and click in call park banner     from_device=device_1     to_device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen   device_list=device_1,device_2

TC11 : [Call Park] DUT user to park and retrieve the incoming call from TDC
    [Tags]  313745   bvt_tpc  sanity_tpc
    [Setup]   Testcase Setup for Meeting User    count=2
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Wait for Some Time    time=${wait_time}
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1   AND  Come back to home screen   device_list=device_1,device_2

TC12 : [Call Mute] Teams App user can mute the call when is already on mute from far-end
    [Tags]  306069    P2
    [Setup]   Testcase Setup for Meeting User    count=2
    Navigate to people tab    device=device_1
    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_1
    Verify meeting Mute State    device_list=device_1    state=mute
    Mutes the phone call    device=device_2
    Verify meeting Mute State    device_list=device_2    state=mute
    Unmutes the phone call  device=device_1
    Verify meeting Mute State    device_list=device_1    state=Unmute
    Unmutes the phone call  device=device_2
    Verify meeting Mute State    device_list=device_2    state=Unmute
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
Test Case Teardown
    [Arguments]     ${devices}
    Come back to home screen     ${devices}

Unanswered call Teardown
    [Arguments]     ${devices}
    verify call state and disconnect      ${devices}
    Come back to home screen     ${devices}
    Disable unanswered call    device=device_1      contact_device=device_2

Verify hold resume scenario
    Hold the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Hold
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
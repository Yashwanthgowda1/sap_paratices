*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${action_time} =  3
${wait_time} =  5
${60s_wait_time} =  60
${10_minutes_wait_time} =  10 minutes
${30_minutes_wait_time} =  30 minutes

*** Test Cases ***
TC1 : [Call Mute] User to test Mute/unmute the call from UI/hard mute key
    [Tags]  309770   bvt_tp  sanity_tp    bvt_pr  alt_credentials       Certification_audio
    [Setup]  Testcase Setup    count=2
    click on calls tab   device=device_1
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

TC2 : [Call Hold] DUT user toggle hold/resume between two TDC users
    [Tags]  309760     P2  alt_credentials        Certification_audio
    [Setup]  Testcase Setup    count=3
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
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

TC3 : [Call Hold] DUT user can hold the call when it is already on hold from far-end
    [Tags]  309783        P2  alt_credentials
    [Setup]  Testcase Setup    count=3
    Click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_3,device_2    state=Connected
    Hold the call   device=device_3
    Verify Call State    device_list=device_2,device_3   state=Hold
    Hold the call   device=device_2
    Verify Call State    device_list=device_2    state=Hold
    Resume the call   device=device_3
    Verify Call State    device_list=device_3,device_2    state=Hold
    Resume the call   device=device_2
    Verify Call State    device_list=device_3,device_2     state=Resume
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_3,device_2

TC4 : [Call Hold] DUT user can hold the call when call is already on mute from far-end
    [Tags]  309786      P2  alt_credentials
    [Setup]   Testcase Setup    count=2
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_1
    Verify meeting Mute State    device_list=device_1    state=mute
    Hold the call   device=device_2
    Verify Call State    device_list=device_1,device_2    state=Hold
    Resume the call   device=device_2
    Verify Call State    device_list=device_1,device_2     state=Resume
    Verify meeting Mute State    device_list=device_1    state=mute
    Unmutes the phone call  device=device_1
    Verify meeting Mute State    device_list=device_1    state=Unmute
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC5 : [Call Hold] TDC user hold the call with DUT user
    [Tags]    309800    P2
    [Setup]   Testcase Setup    count=2
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call   device=device_2
    Verify Call State    device_list=device_1,device_2    state=Hold
    Mutes the phone call    device=device_1
    Verify Call mute State     device_list=device_1    state=mute
    Unmutes the phone call  device=device_1
    Verify Call mute State     device_list=device_1    state=Unmute
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    verify call mute state    device_list=device_1    state=mute
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    verify call mute state    device_list=device_1    state=unmute
    Add participant to conversation using display name   from_device=device_1      to_device=device_3
    Pick incoming call     device=device_3
    verify call state     device_list=device_1,device_2,device_3     state=Connected
    Verify Call State    device_list=device_2    state=Hold
    Verify Call State    device_list=device_1,device_3     state=Resume
    resume call from call hold banner     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Resume
    Verify hold resume scenario in group call    device_1
    Verify hold resume scenario in group call    device_1
    Verify hold resume scenario in group call    device_1
    Verify hold resume scenario in group call    device_1
    disconnect call       device=device_2,device_3
    Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC6 : [Call Mute] DUT user can mute the call when it is already on hold from far-end and disconnects the call during on hold.
    [Tags]    309793
    [Setup]    Testcase Setup    count=2
    Make Outgoing Call Using Display Name    from_device=device_2    to_device=device_1
    Pick Incoming Call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold The Call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Hold
    Mutes The Phone Call    device=device_1
    Verify Call Mute State    device_list=device_1    state=Mute
    Resume The Call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=resume
    Verify Call Mute State    device_list=device_1    state=mute
    Unmutes The Phone Call    device=device_1
    Verify Call Mute State    device_list=device_1    state=unmute
    verify call state    device_list=device_1,device_2    state=connected
    Hold The Call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Hold
    Wait For Some Time    time=10 minutes
    Verify Call State    device_list=device_1,device_2    state=Hold
    Disconnect Call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]    Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
Verify hold resume scenario
    Hold the call   device=device_1
    Wait for Some Time    time=${action_time}
    Verify Call State    device_list=device_1,device_2     state=Hold
    Wait for Some Time    time=${action_time}
    Resume the call   device=device_1
    Wait for Some Time    time=${action_time}
    Verify Call State    device_list=device_1,device_2     state=Resume

Verify hold resume scenario in group call
    [Arguments]     ${device}
    Hold the call    ${device}
    Verify Call State    device_list=${device}    state=Hold
    Resume the call    ${device}
    Verify Call State    device_list=device_1,device_2,device_3     state=Resume
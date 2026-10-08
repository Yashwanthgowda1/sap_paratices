*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown     Run Keywords    Suite Failure Capture    AND   Call Park Teardown

*** Variables ***
${wait_time} =      7
${3_minutes_wait_time} =  3 minutes


*** Test Cases ***
TC1 : [Call Park] DUT user to park and retrieve the incoming call from TDC
    [Documentation]  Devices are already signed-in in Suite Setup
    [Tags]  308598   bvt_tp  sanity_tp    bvt_pr      alt_blocked
    [Setup]  Testcase Setup    count=2
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1   AND  Come back to home screen   device_list=device_1,device_2

TC2 : [Call Park] Multiple parked calls
    [Tags]  308615  sanity_tp            alt_blocked
    [Setup]  Testcase Setup    count=3
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code1}=    call park and get the code    device=device_1
    click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    ${call_park_code2}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code1}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Unpark Call    ${call_park_code2}    device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2   state=Hold
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen   device_list=device_1,device_2,device_3

TC3 : [Call Park] DUT user try to retrieve the parked call with wrong code
    [Tags]  308606   P2  alt_blocked
    [Setup]  Testcase Setup    count=2
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    ${wrong_call_park_code}=   Evaluate    ${call_park_code}+10
    Unpark Call    ${wrong_call_park_code}    device_1
    Verify Call State    device_list=device_1     state=Disconnected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen   device_list=device_1,device_2

TC4 : [Call Park] Reject ring back to retrieve the parked call
    [Tags]  308612   P2  alt_blocked
    [Setup]  Testcase Setup    count=2
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    dismiss multiple call park banner   device=device_1
    Wait for Some Time    time=${3_minutes_wait_time}
    verify ring back to retrieve the parked call    device=device_1
    Rejects the incoming call    device_list=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Navigate To Calls Tab        device=device_1
    verify call park cancel button    ${call_park_code}   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen   device_list=device_1,device_2

TC5 : [Call Park] DUT user park one of the multiple call
    [Tags]  309051   P1  alt_blocked
    [Setup]  Testcase Setup    count=4
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2   state=Hold
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_4
    Verify Call State    device_list=device_3,device_4    state=Connected
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen   device_list=device_1,device_2,device_3,device_4

TC6 : [Call Park] DUT user able to resume the call, when call is parked for second time.
    [Tags]      401406   P1
    [Setup]  Testcase Setup    count=2
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
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

TC7 : [Migrate to new call park architecture] Verify DUT (V2 enabled) user able to Park and un park the incoming call from the V2 enabled user.
    [Tags]    482449    P0     sanity_tp    bvt_tp
    [Setup]  Testcase Setup    count=2
    Making out going call        from_device=device_1      to_device=device_2
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    return to home screen    device_list=device_1
    unpark call from people tab   ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    return to home screen    device_list=device_1
    Navigate to calendar tab    device=device_1
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen   device_list=device_1,device_2

TC8 : [Migrate to new call park architecture]Verify DUT2 (V2 enabled) user able to unpark the Parked call from the V1 enabled user(DUT1)
    [Tags]    482451    P1     sanity_tp
    [Setup]  Testcase Setup    count=3
    Making out going call    from_device=device_1      to_device=device_2
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3   state=Disconnected
    return to home screen    device_list=device_1
    dismiss multiple call park banner   device=device_1
    Making out going call    from_device=device_1      to_device=device_2
    ${call_park_code}=    call park and get the code    device=device_1
    return to home screen    device_list=device_3
    unpark call from people tab   ${call_park_code}    device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3   state=Disconnected
    return to home screen    device_list=device_1
    dismiss multiple call park banner   device=device_1
    Making out going call    from_device=device_1      to_device=device_2
    ${call_park_code}=    call park and get the code    device=device_1
    return to home screen    device_list=device_3
    Navigate to calendar tab    device=device_3
    Unpark Call    ${call_park_code}    device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen   device_list=device_1,device_2,device_3

TC9 : [Migrate to new call park architecture] DUT/Other user should be able park and retrieve(unpark) the Single call from TDC
    [Tags]    482446    P1     sanity_tp
    [Setup]  Testcase Setup    count=3
    Making out going call    from_device=device_1      to_device=device_2
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_1
    ${call_park_code}=    call park and get the code    device=device_1
    return to home screen    device_list=device_1
    unpark call from people tab   ${call_park_code}    device_1
    ${call_park_code}=    call park and get the code    device=device_1
    return to home screen    device_list=device_1
    Navigate to calendar tab    device=device_1
    Unpark Call    ${call_park_code}    device_1
    ${call_park_code}=    call park and get the code    device=device_1
    return to home screen    device_list=device_1
    Navigate to voicemail tab    device=device_1
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    dismiss multiple call park banner   device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3   state=Disconnected
    return to home screen    device_list=device_1
    dismiss multiple call park banner   device=device_1 
    Making out going call    from_device=device_1      to_device=device_2
    ${call_park_code}=    call park and get the code    device=device_1
    return to home screen    device_list=device_3
    unpark call from people tab   ${call_park_code}    device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3   state=Disconnected
    return to home screen    device_list=device_1
    dismiss multiple call park banner   device=device_1
    Making out going call    from_device=device_1      to_device=device_2
    ${call_park_code}=    call park and get the code    device=device_1
    return to home screen    device_list=device_3
    Navigate to calendar tab    device=device_3
    Unpark Call    ${call_park_code}    device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3   state=Disconnected
    return to home screen    device_list=device_1
    dismiss multiple call park banner   device=device_1
    Making out going call    from_device=device_1      to_device=device_2
    ${call_park_code}=    call park and get the code    device=device_1
    return to home screen    device_list=device_3
    Navigate to voicemail tab    device=device_3
    Unpark Call    ${call_park_code}    device_3
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]    Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen   device_list=device_1,device_2,device_3

TC10 : [Migrate to new call park architecture]DUT user able to park and retrieve the Single Call from other DUT
    [Tags]    482445    P0     sanity_tp    bvt_tp
    [Setup]  Testcase Setup    count=2
    Making out going call        from_device=device_1      to_device=device_2
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    return to home screen    device_list=device_1
    unpark call from people tab   ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    return to home screen    device_list=device_1
    Navigate to calendar tab    device=device_1
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    return to home screen    device_list=device_1
    Navigate to voicemail tab    device=device_1
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen   device_list=device_1,device_2

*** Keywords ***
Call Park Teardown
    Cancel Parked Call  device=device_1

Making out going call
    [Arguments]     ${from_device}   ${to_device}
    click on calls tab   device=${from_device}
    Make outgoing call using display name    ${from_device}      ${to_device}
    Pick incoming call    device=${to_device}
    Verify Call State    device_list=${from_device},${to_device}    state=Connected

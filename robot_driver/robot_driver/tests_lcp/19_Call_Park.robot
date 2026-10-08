*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***
${5_minutes_wait_time} =  5 minutes

*** Test Cases ***
TC1: [Call Park] DUT user to park and retrieve the incoming call from TDC
    [Tags]  452458    bvt_lcp    sanity_lcp
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2: [Call Park] DUT user to park and retrieve the outgoing call with TDC
    [Tags]  452469
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3: [Call Park] DUT user able to resume the call, when call is parked for second time.
    [Tags]  452531    sanity_lcp
    [Setup]  Testcase Setup     count=2
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC4: [Call Park] Multiple parked calls
    [Tags]  452504    bvt_lcp    sanity_lcp
    [Setup]  Testcase Setup     count=2
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code1}=    call park and get the code    device=device_1
    navigate to people tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    ${call_park_code2}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code1}    device_4
    Verify Call State    device_list=device_2,device_4    state=Connected
    repeat keyword  2 times     device setting back     device=device_4
    Unpark Call    ${call_park_code2}    device_4
    Verify Call State    device_list=device_3,device_4    state=Connected
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC5 : [Call Park] DUT user park one of the multiple call
    [Tags]  452518
    [Setup]  Testcase Setup    count=4
    navigate to people tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    navigate to people tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2   state=Hold
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_4
    Verify Call State    device_list=device_3,device_4    state=Connected
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen   device_list=device_1,device_2,device_3,device_4

TC6 : [Call Park] Verify DUT should see the parked call banner across all the screen.
    [Tags]  452527
    [Setup]  Testcase Setup    count=2
    navigate to people tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    click call park    device=device_1
    repeat keyword  2 times     device setting back     device=device_1
    verify call park banner     from_device=device_1     to_device=device_2
    navigate to people tab      device=device_1
    verify call park banner     from_device=device_1     to_device=device_2
    repeat keyword  2 times     device setting back     device=device_1
    navigate to voicemail tab   device=device_1
    verify call park banner     from_device=device_1     to_device=device_2
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    close call park banner      device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen   device_list=device_1,device_2

TC7 : [Call Park] Parked call terminated before retrieval
    [Tags]  452487
    [Setup]  Testcase Setup    count=3
    navigate to people tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    Unpark Call    ${call_park_code}    device_3
    #Due to bug the text is not appearing
    #Validate could not complete the call   device=device_3
    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen   device_list=device_1,device_2,device_3

TC8 : [Call Park]DUT user try to retrive the parked call with wrong code
    [Tags]  452477
    [Setup]  Testcase Setup    count=2
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    ${wrong_call_park_code}=   Evaluate    ${call_park_code}+10
    Unpark Call    ${wrong_call_park_code}    device_3
    #Due to bug the text is not appearing
    #Validate could not complete the call   device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen   device_list=device_1,device_2,device_3

TC9 : [Call Park] Reject ring back to retrieve the parked call
    [Tags]  452501
    [Setup]  Testcase Setup    count=2
    navigate to people tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    dismiss multiple call park banner   device=device_1
    Wait for Some Time    time=${5_minutes_wait_time}
    verify ring back to retrieve the parked call    device=device_1
    Rejects the incoming call    device_list=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen   device_list=device_1,device_2


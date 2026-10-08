*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown     Suite Failure Capture

*** Variables ***
${wait_time} =      10s
${3_minutes_wait_time} =  3 minutes
${5_minutes_wait_time} =  5 minutes

*** Test Cases ***
TC1 : [Call Park] TDC user to park and retrieve the incoming call from DUT
    [Tags]  262304   P1    sanity_cap    bvt_cap
    [Setup]  Testcase Setup for CAP User    count=2
    click on people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_2
    Unpark Call    ${call_park_code}    device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND   dismiss multiple call park banner   device=device_1   AND    Come back to home screen   device_list=device_1,device_2

TC2 : [Call Park] DUT user to park and retrieve the outgoing call with TDC
    [Tags]  149441   P1    sanity_cap     bvt_cap   
    [Setup]  Testcase Setup for CAP User    count=2
    click on people tab     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND   dismiss multiple call park banner   device=device_1   AND    Come back to home screen   device_list=device_1,device_2

TC3 : [Call Park] DUT user try to retrieve the parked call with wrong code
    [Tags]  149443   P3
    [Setup]  Testcase Setup for CAP User    count=2
    click on calls tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    ${wrong_call_park_code}=   Evaluate    ${call_park_code}+10
    Unpark Call    ${wrong_call_park_code}    device_1
    Validate could not complete the call   device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND   dismiss multiple call park banner   device=device_1   AND    Come back to home screen   device_list=device_1,device_2

TC4 : [Call Park] Parked call terminated before retrieval
    [Tags]  149444   P2
    [Setup]  Testcase Setup for CAP User    count=2
    click on calls tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    Unpark Call    ${call_park_code}    device_1
    Validate could not complete the call   device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND   dismiss multiple call park banner   device=device_1   AND    Come back to home screen   device_list=device_1,device_2

TC5 : [Call Park] cancel call park icon
    [Tags]  150016   P2
    [Setup]  Testcase Setup for CAP User    count=2
    click on calls tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code1}=    call park and get the code    device=device_1
    Cancel call park    ${call_park_code1}    device_1
    Verify ui returns to home page   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND   dismiss multiple call park banner   device=device_1   AND    Come back to home screen   device_list=device_1,device_2

TC6 : [Call Park] Multiple parked calls
    [Tags]  149446   P2    bvt_cap    sanity_cap
    [Setup]  Testcase Setup for CAP User   count=3
    click on calls tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code1}=    call park and get the code    device=device_1
    click on calls tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    ${call_park_code2}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code1}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Wait for Some Time    time=${wait_time}
    Unpark Call    ${call_park_code2}    device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2   state=Hold
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND   dismiss multiple call park banner   device=device_1   AND    Come back to home screen   device_list=device_1,device_2,device_3

TC7 : [Call Park] DUT user park one of the multiple call
    [Tags]  150030   P2
    [Setup]  Testcase Setup for CAP User    count=4
    click on calls tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    click on calls tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1:cap_search_enabled
    Pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2   state=Hold
    ${call_park_code}=    call park and get the code    device=device_1
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    Unpark Call    ${call_park_code}    device_4
    Verify Call State    device_list=device_3,device_4    state=Connected
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND   dismiss multiple call park banner   device=device_1   AND    Come back to home screen   device_list=device_1,device_2,device_3,device_4

*** Keywords ***
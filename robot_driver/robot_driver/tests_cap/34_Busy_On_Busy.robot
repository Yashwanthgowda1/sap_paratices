*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***

*** Test Cases ***
TC1 : [Busy on Busy] Verify DUT user able to Select options present inside the "When in another call" under calling
    [Tags]  451964    bvt_cap  sanity_cap   phonesCY23_4
    [Setup]  Testcase Setup for CAP User    count=1
    navigate to calling page    device=device_1
    verify default setting under call forwarding section    device=device_1     status=off
    select the options inside when in another call option   device=device_1     option=play_a_busy_signal
    select the options inside when in another call option   device=device_1     option=new_calls_ring_me
    select the options inside when in another call option   device=device_1     option=redirect_unanswered_call
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2 : [Busy on Busy][Calls] Verify DUT user is receiving the incoming call,When user selects, Let New calls ring me under When in another call in Calling
    [Tags]  451974    bvt_cap  sanity_cap
    [Setup]  Testcase Setup for CAP User    count=3
    navigate to calling page    device=device_1
    verify default setting under call forwarding section    device=device_1     status=off
    select the options inside when in another call option   device=device_1     option=new_calls_ring_me
    Come back to home screen    device_list=device_1
    click on people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Make outgoing call using display name    from_device=device_3      to_device=device_1:cap_search_enabled
    Pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2     state=Hold
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3    AND     change to default state   device=device_1

TC3 : [Busy on Busy]DUT user to verify "Play a Busy signal" option is selected by default under "When in another call".
    [Tags]  451966
    [Setup]  Testcase Setup for CAP User    count=1
    navigate to calling page    device=device_1
    verify when in another call option inside calling    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC4 : [Busy on Busy][Call] Verify Unanswered Call is forwarded to Voicemail, When user selects Redirect as if a call is unanswered under When in another call in Calling
    [Tags]  451977    bvt_cap  sanity_cap
    [Setup]  Testcase Setup for CAP User    count=3
    navigate to calling page    device=device_1
    verify default setting under call forwarding section    device=device_1     status=off
    select the options inside when in another call option   device=device_1     option=redirect_unanswered_call
    Come back to home screen    device_list=device_1
    click on people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Make outgoing call using display name    from_device=device_3      to_device=device_1:cap_search_enabled
    Verify incoming call    device=device_1     status=disappear
    Disconnect call     device=device_1,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3     AND     change to default state   device=device_1


*** Keywords ***
navigate to calling page
    [Arguments]     ${device}
    navigate to calling option for CAP policy user for audio phones   device=${device}

change to default state
   [Arguments]     ${device}
   navigate to calling page    device=device_1
   select the options inside when in another call option   device=device_1     option=play_a_busy_signal
   Come back to home screen    device_list=device_1
*** Settings ***
Resource    ../resources/keywords/common.robot


Suite Teardown    Run keywords      Suite Failure Capture   AND      select the options inside when in another call option   device=device_1     option=new_calls_ring_me        AND    Come back to home screen    device_list=device_1
*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC01 : [Busy on Busy]Verify that DUT user able to select options present inside the "When in another call" under calling
    [Tags]  451965     bvt_tpc       sanity_tpc    P0     phonesCY23_4
    [Setup]   Testcase Setup for Meeting User   count=1
    Navigate to device setting page   device=device_1
    advance calling option oem      device=device_1
    verify default setting under call forwarding section    device=device_1     status=off
    select the options inside when in another call option   device=device_1     option=play_a_busy_signal
    select the options inside when in another call option   device=device_1     option=new_calls_ring_me
    select the options inside when in another call option   device=device_1     option=redirect_unanswered_call
    select the options inside when in another call option   device=device_1     option=play_a_busy_signal
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1

TC02 : [Busy on Busy] DUT user to verify "When in another call" option should present under calling.
    [Tags]    451955     P2     phonesCY23_4
    [Setup]   Testcase Setup for Meeting User   count=1
    Navigate to device setting page   device=device_1
    advance calling option oem      device=device_1
    verify when in another call option inside calling    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC03 : [Busy on Busy] DUT user to verify the options present inside the "When in another call" under calling
    [Tags]     451956        P2     phonesCY23_4
    [Setup]   Testcase Setup for Meeting User   count=1
    Navigate to device setting page   device=device_1
    advance calling option oem      device=device_1
    verify default setting under call forwarding section    device=device_1     status=off
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC04 : [Busy on Busy]DUT user to verify "Play a Busy signal" option should be selected by default in "When in another call" under calling
    [Tags]    451967    P1    phonesCY23_4
    [Setup]   Testcase Setup for Meeting User   count=1
    Navigate to device setting page   device=device_1
    advance calling option oem      device=device_1
    verify when in another call option inside calling    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC05: [Busy on Busy][Call] Verify Unanswered Call should be forwarded to Voicemail,When user selects Redirect as if a call is unanswered under When in another call in Calling
    [Tags]      451999      bvt_tpc       sanity_tpc    P0      phonesCY23_4
    [Setup]  Run Keywords     Testcase Setup for Meeting User   count=3    AND  Enable unanswered call to voicemail   from_device=device_1    contact_device=device_2
    Navigate to device setting page   device=device_1
    advance calling option oem      device=device_1
    verify default setting under call forwarding section    device=device_1     status=off
    select the options inside when in another call option   device=device_1     option=redirect_unanswered_call
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Navigate to people tab    device=device_3
    verify voicemail forwarding message text while already in call    device=device_3   to_device=device_1:meeting_user
    verify incoming call    device=device_1    status=disappear
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_1,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    select the options inside when in another call option   device=device_1     option=new_calls_ring_me   AND  Disable unanswered call    device=device_1      contact_device=device_2    AND   Come back to home screen    device_list=device_1,device_2,device_3

TC06 : [Busy on Busy] Verify Busy on Busy meaasge should disappear within 5 sec on DUT screen.
    [Tags]    452015      bvt_tpc     sanity_tpc      P0        phonesCY23_4
    [Setup]   Testcase Setup for Meeting User   count=3
    Navigate to device setting page   device=device_1
    advance calling option oem      device=device_1
    verify default setting under call forwarding section    device=device_1     status=off
    select the options inside when in another call option   device=device_1     option=play_a_busy_signal
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Navigate to people tab    device=device_3
    verify busy on busy error message while already in call  device=device_3         to_device=device_1:meeting_user    method=display_name
    verify incoming call    device=device_1    status=disappear
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND      select the options inside when in another call option   device=device_1     option=new_calls_ring_me   AND    Come back to home screen    device_list=device_1,device_2,device_3

*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown      Run Keywords    Suite Failure Capture

*** Variables ***
${wait_time} =  5

*** Test Cases ***
TC1 : [Busy on Busy]Verify that DUT user able to select options present inside the "When in another call" under calling
    [Tags]   451980      BVT_CAPPremium     Sanity_CAPPremium      phonesCY23_4
    [Setup]   Testcase Setup for CAP Premium User     count=1
    Navigate to device setting page   device=device_1
    advance calling option oem      device=device_1
    verify default setting under call forwarding section    device=device_1     status=off
    select the options inside when in another call option   device=device_1     option=play_a_busy_signal
    select the options inside when in another call option   device=device_1     option=new_calls_ring_me
    select the options inside when in another call option   device=device_1     option=redirect_unanswered_call
    select the options inside when in another call option   device=device_1     option=play_a_busy_signal
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1

TC2 : [Busy on Busy] DUT user to verify "When in another call" option should present under calling.
    [Tags]   451958     P2    phonesCY23_4
    [Setup]    Testcase Setup for CAP Premium User   count=1
    Navigate to device setting page   device=device_1
    advance calling option oem      device=device_1
    verify when in another call option inside calling    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3 : [Busy on Busy] DUT user to verify the options present inside the "When in another call" under calling
    [Tags]    451975   P2    phonesCY23_4
    [Setup]   Testcase Setup for CAP Premium User   count=1
    Navigate to device setting page   device=device_1
    advance calling option oem      device=device_1
    verify default setting under call forwarding section    device=device_1     status=off
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC4 : [Busy on Busy]DUT user to verify "Play a Busy signal" option should be selected by default in "When in another call" under calling
    [Tags]   451982   P1    phonesCY23_4
    [Setup]   Testcase Setup for CAP Premium User   count=1
    Navigate to device setting page   device=device_1
    advance calling option oem      device=device_1
    verify default status for when in another call option    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC5 :[Busy on Busy][Calls] Verify DUT user should get the incoming call,When user selects New calls ring me under When in another call in Calling
    [Tags]  451987    BVT_CAPPremium     Sanity_CAPPremium      phonesCY23_4
    [Setup]   Testcase Setup for CAP Premium User    count=3
    Navigate to device setting page   device=device_1
    advance calling option oem      device=device_1
    verify default setting under call forwarding section    device=device_1     status=off
    select the options inside when in another call option   device=device_1     option=new_calls_ring_me
    Come back to home screen    device_list=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify Call State    device_list=device_3   state=Hold
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3      state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND  Select status for when in another call  device=device_1   option=play_a_busy_signal   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC6 : [Busy on Busy][Esc to Conf.] Verify that Busy on Busy is working,when DUT user in Esc to Conf call.
    [Tags]  452008    BVT_CAPPremium     Sanity_CAPPremium      phonesCY23_4
    [Setup]   Testcase Setup for CAP Premium User    count=4
    Select status for when in another call  device=device_1   option=play_a_busy_signal
    Make outgoing call using display name    from_device=device_1     to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_4
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_1,device_3,device_4     state=Connected
    click on calls tab  device=device_2
    verify busy on busy error message while already in call    device=device_2        to_device=device_1:cap_search_enabled      method=display_name
    Disconnect call     device=device_1,device_3
    Verify Call State    device_list=device_1,device_2,device_3      state=Disconnected
    Select status for when in another call    device=device_1    option=new_calls_ring_me
    navigate to calls tab     device=device_3
    call first participant from log    device=device_3
    Pick incoming call    device=device_1,device_4
    Make outgoing call using display name    from_device=device_2    to_device=device_1:cap_search_enabled
    Verify incoming call    device=device_1     status=appear
    Disconnect call     device=device_1,device_2,device_3
    Select status for when in another call    device=device_1     option=redirect_unanswered_call
    Enable unanswered call to voicemail      from_device=device_1     contact_device=device_2
    Make outgoing call using display name    from_device=device_2    to_device=device_1:cap_search_enabled
    Wait for Some Time    time=${wait_time}
    verify voicemail forwarding message text    device=device_2
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4   AND  Disable unanswered call    device=device_1      contact_device=device_2  AND  Select status for when in another call  device=device_1   option=play_a_busy_signal

TC7 : [Busy on Busy][Call] Verify Call should be forwarded to Voicemail,When user selects Ridirect as if a call is unanswered under When in another call in Calling
    [Tags]  451989    BVT_CAPPremium     Sanity_CAPPremium      phonesCY23_4
    [Setup]   Run Keywords  Testcase Setup for CAP Premium User    count=3    AND  Enable unanswered call to voicemail   from_device=device_1    contact_device=device_2
    Navigate to device setting page   device=device_1
    advance calling option oem      device=device_1
    verify default setting under call forwarding section    device=device_1     status=off
    select the options inside when in another call option   device=device_1     option=redirect_unanswered_call
    Come back to home screen    device_list=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
     click on calls tab  device=device_2
    verify voicemail forwarding message text while already in call    device=device_2   to_device=device_1:cap_search_enabled
    verify incoming call    device=device_1    status=disappear
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3   AND  Disable unanswered call    device=device_1      contact_device=device_2  AND  Select status for when in another call   device=device_1   option=play_a_busy_signal

TC8 : [Busy on Busy][Call] Verify TDC call should be forwarded to Contact,When user selects Ridirect as if a call is unanswered under When in another call in Calling
    [Tags]  451992     P1    phonesCY23_4
    [Setup]  Run Keywords   Testcase Setup for CAP Premium User    count=4   AND  Enable unanswered call and add contact    from_device=device_1    contact_device=device_3
    Navigate to device setting page   device=device_1
    advance calling option oem      device=device_1
    verify default setting under call forwarding section    device=device_1     status=off
    select the options inside when in another call option   device=device_1     option=redirect_unanswered_call
    Come back to home screen    device_list=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Make outgoing call using display name    from_device=device_4      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_2,device_3,device_4      state=Connected
    Disconnect call     device=device_1,device_3
    Verify Call State    device_list=device_1,device_2,device_3,device_4      state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4    AND  Disable unanswered call    device=device_1      contact_device=device_2    AND  Select status for when in another call   device=device_1   option=play_a_busy_signal

TC9 : [Busy on Busy]Verfiy second incoming call should be forwarding to voicemail,when user set unanswered call to voicemail
    [Tags]  452013     P1    phonesCY23_4
    [Setup]  Run Keywords   Testcase Setup for CAP Premium User    count=3   AND   Enable unanswered call to voicemail   from_device=device_1    contact_device=device_2
    Make outgoing call using display name    from_device=device_3     to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    click on calls tab  device=device_2
    verify voicemail forwarding message text while already in call   device=device_2  to_device=device_1:cap_search_enabled
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3    AND  Disable unanswered call    device=device_1      contact_device=device_2

TC10 : [Busy on Busy][Call] Verify DUT user able to dismiss Busy on Busy message on DUT screen by pressing Back arrow.
    [Tags]  451978    P2       phonesCY23_4
    [Setup]  Testcase Setup for CAP Premium User    count=3
    Navigate to device setting page   device=device_1
    advance calling option oem      device=device_1
    verify default setting under call forwarding section    device=device_1     status=off
    select the options inside when in another call option   device=device_1     option=play_a_busy_signal
    Come back to home screen    device_list=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    click on calls tab  device=device_2
    verify busy on busy error message while already in call    device=device_2        to_device=device_1:cap_search_enabled     method=display_name
    click back    device=device_2
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3

*** Keywords ***

Select status for when in another call
    [Arguments]     ${device}      ${option}
    Open settings page       device=${device}
    Click device settings      device=${device}
    advance calling option oem       device=${device}
    select the options inside when in another call option    device=${device}     option=${option}
    Come back to home screen    device_list=device_1
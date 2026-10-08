*** Settings ***
Library    perf_keywords
Resource    ../resources/keywords/common.robot

Suite Setup    Perf Setup
Suite Teardown    Run keywords    Suite Failure Capture
*** Variables ***
${iteration_count} =  6
${wait_time_in_between_iteration} =  4
${iteration_end_wait_time} =  6
${meet_now_wait_time} =  20
${wait_time} =  10

*** Test Cases ***
TC1 : Incoming P2P Call Hold and Resume
	[Tags]   perf_tc1
    [Setup]  Testcase Setup for Meeting User     count=2
    FOR    ${i}    IN RANGE    1    ${iteration_count}
        run keyword and ignore error        TC1 : Incoming P2P Call Hold and Resume   ${i}
    END
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : Outgoing P2P Call Hold and Resume
	[Tags]   perf_tc2
    [Setup]  Testcase Setup for Meeting User     count=2
    FOR    ${i}    IN RANGE    1    ${iteration_count}
        run keyword and ignore error        TC2 : Outgoing P2P Call Hold and Resume   ${i}
    END
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3 : Join meeting and hangup
	[Tags]   perf_tc3
    [Setup]  Testcase Setup for Meeting User     count=2
    FOR    ${i}    IN RANGE    1    ${iteration_count}
        run keyword and ignore error        TC3 : Join meeting and hangup   ${i}
    END
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2


*** Keywords ***
Perf Setup
	pass the automation flag  device=device_1


TC1 : Incoming P2P Call Hold and Resume
	[Arguments]     ${i}
    ${name} =   catenate  ${TEST NAME}  ${i}
    set test variable  ${status_flag}    ${False}
    reset logs capture  devices=device_1
    Make outgoing call with phonenumber    from_device=device_2      to_device=device_1:meeting_user
    Accept incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Hold
    Wait for Some Time    time=${wait_time_in_between_iteration}
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Wait for Some Time    time=${iteration_end_wait_time}
    Logcat capture for perf analysis    device=device_1    name=${TEST NAME}    iteration=${i}
    set test variable  ${status_flag}    ${True}
    [Teardown]    run keyword if   '${status_flag}' == 'False'    capture screenshot logcats and app crash  name=${name}


TC2 : Outgoing P2P Call Hold and Resume
	[Arguments]     ${i}
    ${name} =   catenate  ${TEST NAME}  ${i}
    set test variable  ${status_flag}    ${False}
    reset logs capture  devices=device_1
    Make outgoing call with phonenumber    from_device=device_1      to_device=device_2
    Accept incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Hold
    Wait for Some Time    time=${wait_time_in_between_iteration}
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Wait for Some Time    time=${iteration_end_wait_time}
    Logcat capture for perf analysis    device=device_1    name=${TEST NAME}    iteration=${i}
    set test variable  ${status_flag}    ${True}
    [Teardown]    run keyword if   '${status_flag}' == 'False'    capture screenshot logcats and app crash  name=${name}


TC3 : Join meeting and hangup
	[Arguments]     ${i}
    ${name} =   catenate  ${TEST NAME}  ${i}
    set test variable  ${status_flag}    ${False}
    reset logs capture  devices=device_1
    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify call control bar   device_list=device_1
    Wait for Some Time    time=${wait_time_in_between_iteration}
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    Come back to home screen    device_list=device_1,device_2
    Wait for Some Time    time=${iteration_end_wait_time}
    Logcat capture for perf analysis    device=device_1    name=${TEST NAME}    iteration=${i}
    set test variable  ${status_flag}    ${True}
    [Teardown]    run keyword if   '${status_flag}' == 'False'    capture screenshot logcats and app crash  name=${name}
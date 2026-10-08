*** Settings ***
Library    perf_keywords
Resource    ../resources/keywords/common.robot

Suite Setup    Perf Setup
Suite Teardown    Suite Failure Capture

*** Variables ***
${iteration_count} =  6
${wait_time_in_between_iteration} =  4
${iteration_end_wait_time} =  6
${meet_now_wait_time} =   20
${navigation_capture_wait} =  30


*** Test Cases ***
TC1 : Navigation on conf phones
    [Tags]      perf_tc1    perf_conf   exclude_ftp
    [Setup]  Testcase Setup for Meeting User    count=1
    FOR    ${i}    IN RANGE    1    ${iteration_count}
        run keyword and ignore error    TC1 : Navigation_on_conf_phones    ${i}
    END
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2 : Start meet now meeting
    [Tags]         perf_tc2       perf_conf     exclude_ftp
    [Setup]  Testcase Setup for Meeting User    count=1
    FOR    ${i}    IN RANGE    1    ${iteration_count}
        run keyword and ignore error    TC2 : Start meet now meeting       ${i}
    END
    [Teardown]  Run Keywords    Capture on Failure  AND    Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1

TC3 : Incoming P2P Call Hold and Resume
    [Tags]      perf_tc3        perf_conf       exclude_ftp
    [Setup]  Testcase Setup for Meeting User    count=2
    FOR    ${i}    IN RANGE    1    ${iteration_count}
        run keyword and ignore error        TC3 : Incoming P2P Call Hold and Resume   ${i}
    END
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
Perf Setup
    pass the automation flag  device=device_1


TC1 : Navigation on conf phones
    [Arguments]     ${i}
    ${name} =   catenate  ${TEST NAME}  ${i}
    set test variable  ${status_flag}    ${False}
    reset logs capture  devices=device_1
    Wait for Some Time      time=${navigation_capture_wait}
    navigate to people tab   device=device_1
    wait for some time   ${wait_time_in_between_iteration}
    Come back to home screen    device_list=device_1
    navigate to calendar tab    device=device_1
    Wait for Some Time    time=${wait_time_in_between_iteration}
    Come back to home screen    device_list=device_1
    Wait for Some Time    time=${iteration_end_wait_time}
    Logcat capture for perf analysis    device=device_1    name=${TEST NAME}    iteration=${i}
    set test variable  ${status_flag}    ${True}
    [Teardown]    run keyword if   '${status_flag}' == 'False'    capture screenshot logcats and app crash  name=${name}

TC2 : Start meet now meeting
    [Arguments]     ${i}
    ${name} =   catenate  ${TEST NAME}  ${i}
    set test variable  ${status_flag}    ${False}
    reset logs capture  devices=device_1
    navigate to calendar tab    device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${meet_now_wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    verify call control bar in meeting for cnf device  device=device_1
    End meeting     device=device_1
    Verify meeting state   device_list=device_1   state=Disconnected
    Wait for Some Time    time=${iteration_end_wait_time}
    Logcat capture for perf analysis    device=device_1    name=${TEST NAME}    iteration=${i}
    set test variable  ${status_flag}    ${True}
    [Teardown]    run keyword if   '${status_flag}' == 'False'    capture screenshot logcats and app crash  name=${name}

TC3 : Incoming P2P Call Hold and Resume
    [Arguments]     ${i}
    ${name} =   catenate  ${TEST NAME}  ${i}
    set test variable  ${status_flag}    ${False}
    reset logs capture  devices=device_1
    Make outgoing call using display name   from_device=device_2           to_device=device_1:meeting_user
    verify incoming call  device=device_1    status=appear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call control visibility  device_list=device_1
    hold the call   device=device_1
    Verify Call State    device_list=device_1    state=Hold
    Wait for Some Time    time=${wait_time_in_between_iteration}
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    verify call control visibility      device_list=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Come back to home screen    device_list=device_1,device_2
    Wait for Some Time    time=${iteration_end_wait_time}
    Logcat capture for perf analysis    device=device_1    name=${TEST NAME}    iteration=${i}
    set test variable  ${status_flag}    ${True}
    [Teardown]    run keyword if   '${status_flag}' == 'False'    capture screenshot logcats and app crash  name=${name}
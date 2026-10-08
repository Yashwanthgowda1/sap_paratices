*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Setup    Run keyword and ignore error    Perf Setup
Suite Teardown    Run keyword and ignore error    Perf Teardown

*** Variables ***
${iteration_count} =  6
${wait_time_in_between_iteration} =  4
${iteration_end_wait_time} =  6
${meet_now_wait_time} =  20
${navigation_capture_wait} =    30

*** Test Cases ***
TC1 : Navigation scenarios
    [Tags]    perf_tc1    perf_audio      exclude_ftp
    [Setup]  run keywords    Testcase Setup    count=1    AND   pass the automation flag  device=device_1
    FOR    ${i}    IN RANGE    1    ${iteration_count}
        run keyword and ignore error    TC1 : Navigation scenarios    ${i}
    END
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : Incoming P2P Call Hold Resume and Park
    [Tags]   perf_tc2   perf_audio      exclude_ftp
    [Setup]  Testcase Setup    count=2
    FOR    ${i}    IN RANGE    1    ${iteration_count}
        run keyword and ignore error        TC2 : Incoming P2P Call Hold Resume and Park   ${i}
    END
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3 : Outgoing P2P Call Hold Resume and Park
    [Tags]  perf_tc3    perf_audio      exclude_ftp
    [Setup]  Testcase Setup    count=2
    FOR    ${i}    IN RANGE    1    ${iteration_count}
        run keyword and ignore error        TC3 : Outgoing P2P Call Hold Resume and Park     ${i}
    END
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC4 : Access Meeting Details Join meeting and Hangup
    [Tags]  perf_tc4    perf_audio      exclude_ftp
    [Setup]  run keywords    Testcase Setup  count=1    AND    create meeting    device=device_1    meeting=perf_meeting
    FOR    ${i}    IN RANGE    1    ${iteration_count}
        run keyword and ignore error        TC4 : Access Meeting Details Join meeting and Hangup       ${i}
    END
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1

TC5 : Start meet now meeting
    [Tags]  perf_tc5    perf_audio      exclude_ftp
    [Setup]  Testcase Setup  count=1
    FOR    ${i}    IN RANGE    1    ${iteration_count}
        run keyword and ignore error    TC5 : Start meet now meeting       ${i}
    END
    [Teardown]  Run Keywords    Capture on Failure  AND    Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1

TC6 : Signout and Refresh DCF Code
    [Tags]  perf_tc6    perf_audio      exclude_ftp
    FOR    ${i}    IN RANGE    1    ${iteration_count}
        run keyword and ignore error    TC6 : Signout and Refresh DCF Code     ${i}
    END
    [Teardown]  Capture on Failure

TC7 : Incoming PSTN Call Hold Resume and Park
    [Tags]  perf_tc7    perf_audio      exclude_ftp
    [Setup]  Testcase Setup for PSTN User    count=2
    FOR    ${i}    IN RANGE    1    ${iteration_count}
        run keyword and ignore error    TC7 : Incoming PSTN Call Hold Resume and Park     ${i}
    END
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC8 : Outgoing PSTN Call Hold Resume and Park
    [Tags]  perf_tc8    perf_audio      exclude_ftp
    [Setup]  Testcase Setup for PSTN User    count=2
    FOR    ${i}    IN RANGE    1    ${iteration_count}
        run keyword and ignore error    TC8 : Outgoing PSTN Call Hold Resume and Park     ${i}
    END
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC9 : Enable and Disable Dark Theme
    [Tags]  perf_tc9    perf_audio      exclude_ftp
    [Setup]  Testcase Setup  count=1
    FOR    ${i}    IN RANGE    1    ${iteration_count}
        run keyword and ignore error        TC9 : Enable and Disable Dark Theme        ${i}
    END
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1   AND    verify and disable dark theme     device_1


*** Keywords ***
Test Case Teardown without deleting meeting
    [Arguments]     ${devices}
    Come back to home screen    ${devices}
    Teardown Meeting Test Case     ${devices}


Perf Setup
    come back to home screen   device_list=device_1
    pass the automation flag  device=device_1
    Testcase Setup   count=1
    Remove all delegates on device   devices=device_1
    return to home screen   device_list=device_1


Perf Teardown
    Suite Failure Capture
    come back to home screen   device_list=device_1
    Add new delegates with both permission and validate   from_device=device_1     to_device=device_2:delegate_user
    return to home screen   device_list=device_1


TC1 : Navigation scenarios
    [Arguments]     ${i}
    ${name} =   catenate  ${TEST NAME}  ${i}
    set test variable  ${status_flag}    ${False}
    reset logs capture  devices=device_1
    Wait for Some Time      time=${navigation_capture_wait}
    navigate to calls tab    device=device_1
    wait for some time   ${wait_time_in_between_iteration}
    navigate to calls favorites page    device=device_1
    wait for some time   ${wait_time_in_between_iteration}
    come back to home screen page and verify    device=device_1
    navigate to people tab   device=device_1
    wait for some time   ${wait_time_in_between_iteration}
    come back to home screen page and verify    device=device_1
    navigate to voicemail tab    device=device_1
    wait for some time   ${wait_time_in_between_iteration}
    come back to home screen page and verify    device=device_1
    navigate to calendar tab    device=device_1
    Wait for Some Time    time=${wait_time_in_between_iteration}
    come back to home screen page and verify    device=device_1
    Wait for Some Time    time=${iteration_end_wait_time}
    Logcat capture for perf analysis    device=device_1    name=${TEST NAME}    iteration=${i}
    set test variable  ${status_flag}    ${True}
    [Teardown]    run keyword if   '${status_flag}' == 'False'    capture screenshot logcats and app crash  name=${name}

TC2 : Incoming P2P Call Hold Resume and Park
    [Arguments]     ${i}
    ${name} =   catenate  ${TEST NAME}  ${i}
    set test variable  ${status_flag}    ${False}
    reset logs capture  devices=device_1
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    verify incoming call  device=device_1    status=appear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call control visibility  device_list=device_1
    hold the call   device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    Wait for Some Time    time=${wait_time_in_between_iteration}
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    verify call control visibility  device_list=device_1
    ${call_park_code}=    call park and get the code    device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    dismiss multiple call park banner   device=device_1
    Come back to home screen    device_list=device_1,device_2
    Wait for Some Time    time=${iteration_end_wait_time}
    Logcat capture for perf analysis    device=device_1    name=${TEST NAME}    iteration=${i}
    set test variable  ${status_flag}    ${True}
    [Teardown]    run keyword if   '${status_flag}' == 'False'    capture screenshot logcats and app crash  name=${name}

TC3 : Outgoing P2P Call Hold Resume and Park
    [Arguments]     ${i}
    ${name} =   catenate  ${TEST NAME}  ${i}
    set test variable  ${status_flag}    ${False}
    reset logs capture  devices=device_1
    Make outgoing call using display name    from_device=device_1    to_device=device_2
    verify incoming call  device=device_2    status=appear
    pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call control visibility  device_list=device_1
    hold the call   device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    Wait for Some Time    time=${wait_time_in_between_iteration}
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    verify call control visibility  device_list=device_1
    ${call_park_code}=    call park and get the code    device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    dismiss multiple call park banner   device=device_1
    Come back to home screen    device_list=device_1,device_2
    Wait for Some Time    time=${iteration_end_wait_time}
    Logcat capture for perf analysis    device=device_1    name=${TEST NAME}    iteration=${i}
    set test variable  ${status_flag}    ${True}
    [Teardown]    run keyword if   '${status_flag}' == 'False'    capture screenshot logcats and app crash  name=${name}

TC4 : Access Meeting Details Join meeting and Hangup
    [Arguments]     ${i}
    ${name} =   catenate  ${TEST NAME}  ${i}
    set test variable  ${status_flag}    ${False}
    reset logs capture  devices=device_1
    Navigate to Calendar tab   device=device_1
    Select Meeting      device=device_1    meeting=perf_meeting
    Wait for Some Time    time=${wait_time_in_between_iteration}
    verify meeting has join button    device=device_1
    join meeting    device=device_1    meeting=perf_meeting
    Wait for Some Time    time=${wait_time_in_between_iteration}
    verify call control bar in meeting  device=device_1
    End meeting     device=device_1
    Verify meeting state   device_list=device_1   state=Disconnected
    Wait for Some Time    time=${iteration_end_wait_time}
    Logcat capture for perf analysis    device=device_1    name=${TEST NAME}    iteration=${i}
    set test variable  ${status_flag}    ${True}
    [Teardown]    run keyword if   '${status_flag}' == 'False'    capture screenshot logcats and app crash  name=${name}

TC5 : Start meet now meeting
    [Arguments]     ${i}
    ${name} =   catenate  ${TEST NAME}  ${i}
    set test variable  ${status_flag}    ${False}
    reset logs capture  devices=device_1
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${meet_now_wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    verify call control bar in meeting  device=device_1
    End meeting     device=device_1
    Verify meeting state   device_list=device_1   state=Disconnected
    Wait for Some Time    time=${iteration_end_wait_time}
    Logcat capture for perf analysis    device=device_1    name=${TEST NAME}    iteration=${i}
    set test variable  ${status_flag}    ${True}
    [Teardown]    run keyword if   '${status_flag}' == 'False'    capture screenshot logcats and app crash  name=${name}

TC6 : Signout and Refresh DCF Code
    [Arguments]     ${i}
    ${name} =   catenate  ${TEST NAME}  ${i}
    set test variable  ${status_flag}    ${False}
    reset logs capture  devices=device_1
    sign out method    device_1
    Wait for Some Time    time=${wait_time_in_between_iteration}
    wait and click refresh code button   device=device_1
    Wait for Some Time    time=${iteration_end_wait_time}
    Logcat capture for perf analysis    device=device_1    name=${TEST NAME}    iteration=${i}
    set test variable  ${status_flag}    ${True}
    [Teardown]    run keyword if   '${status_flag}' == 'False'    capture screenshot logcats and app crash  name=${name}

TC7 : Incoming PSTN Call Hold Resume and Park
    [Arguments]     ${i}
    ${name} =   catenate  ${TEST NAME}  ${i}
    set test variable  ${status_flag}    ${False}
    reset logs capture  devices=device_1
    make outgoing call using phonenumber    from_device=device_2      to_device=device_1
    verify incoming call  device=device_1    status=appear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call control visibility  device_list=device_1
    hold the call   device=device_1
    Verify Call State    device_list=device_1    state=Hold
    Wait for Some Time    time=${wait_time_in_between_iteration}
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    verify call control visibility  device_list=device_1
    ${call_park_code}=    call park and get the code    device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    dismiss multiple call park banner   device=device_1
    Come back to home screen    device_list=device_1,device_2
    Wait for Some Time    time=${iteration_end_wait_time}
    Logcat capture for perf analysis    device=device_1    name=${TEST NAME}    iteration=${i}
    set test variable  ${status_flag}    ${True}
    [Teardown]    run keyword if   '${status_flag}' == 'False'    capture screenshot logcats and app crash  name=${name}

TC8 : Outgoing PSTN Call Hold Resume and Park
    [Arguments]     ${i}
    ${name} =   catenate  ${TEST NAME}  ${i}
    set test variable  ${status_flag}    ${False}
    reset logs capture  devices=device_1
    make outgoing call using phonenumber    from_device=device_1    to_device=device_2:pstn_user
    verify incoming call  device=device_2    status=appear
    pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call control visibility  device_list=device_1
    hold the call   device=device_1
    Verify Call State    device_list=device_1    state=Hold
    Wait for Some Time    time=${wait_time_in_between_iteration}
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    verify call control visibility  device_list=device_1
    ${call_park_code}=    call park and get the code    device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    dismiss multiple call park banner   device=device_1
    Come back to home screen    device_list=device_1,device_2
    Wait for Some Time    time=${iteration_end_wait_time}
    Logcat capture for perf analysis    device=device_1    name=${TEST NAME}    iteration=${i}
    set test variable  ${status_flag}    ${True}
    [Teardown]    run keyword if   '${status_flag}' == 'False'    capture screenshot logcats and app crash  name=${name}

TC9 : Enable and Disable Dark Theme
    [Arguments]     ${i}
    ${name} =   catenate  ${TEST NAME}  ${i}
    set test variable  ${status_flag}    ${False}
    reset logs capture  devices=device_1
    pass the automation flag  device=device_1
    verify and enable dark theme     device_1
    verify and disable dark theme     device_1
    Wait for Some Time    time=${iteration_end_wait_time}s
    Logcat capture for perf analysis    device=device_1    name=${TEST NAME}    iteration=${i}
    set test variable  ${status_flag}    ${True}
    [Teardown]    run keyword if   '${status_flag}' == 'False'    capture screenshot logcats and app crash  name=${name}

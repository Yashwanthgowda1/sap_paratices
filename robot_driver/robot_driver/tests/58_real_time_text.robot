*** Settings ***
Resource    resources/keywords/common.robot


Suite Setup    create new real time text meeting

Suite Teardown     Run Keywords     Suite Failure Capture     AND         Delete real time text meeting and close driver


*** Test Cases ***
TC1 :Verify Turn OFF Live caption from more option when RTT view is displaying
    [Tags]      557287
    [Setup]      Testcase Setup    count=2
    Join TDC meeting    device=tdc_1:device2user    edit_meeting_name=test_meeting
    Join Meeting    device=device_1     meeting=test_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify call state in TDC and DUT    device=tdc_1:device2user     state=connected        device_list=device_1
    enable real time text meeting web    device=tdc_1:device2user
    share rtt message from chat option in TDC    device=tdc_1:device2user
    verify_rtt_text_box_appearance      devices=device_1,device_2
    verify message from desktop user reflected in Dut    devices=device_1,device_2       from_device=tdc_1:device2user
    Wait for Some Time    time=120s
    verify disable of rtt message after a minute    devices=device_1,device_2
    verify and make enable and disable cc button in rtt     devices=device_1
    verify call state in TDC AND DUT in rtt     device=tdc_1:device2user     state=connected        devices=device_1,device_2
    share rtt message from chat option in TDC    device=tdc_1:device2user
    verify message from desktop user reflected in Dut    devices=device_1,device_2        from_device=tdc_1:device2user
    verify and make enable and disable cc button in rtt     devices=device_1        status=off
    Disconnect the call on TDC      device=tdc_1:device2user
    End call during meeting in DUT    device_lists=device_1,device_2
    verify call state in TDC and DUT    device=tdc_1:device2user     state=disconnected        device_list=device_1,device_2
    create a meeting using meet now in tdc      device=tdc_1:device2user
    search participate in people tab request to join    device=tdc_1:device2user    to_device=device_1,device_2
    Wait for Some Time    time=5s
    Pick incoming call    device=device_1,device_2
    enable real time text meeting web    device=tdc_1:device2user
    share rtt message from chat option in TDC    device=tdc_1:device2user
    verify rtt text box appearance      devices=device_1,device_2
    verify message from desktop user reflected in Dut    devices=device_1,device_2        from_device=tdc_1:device2user
    Wait for Some Time    time=120s
    verify disable_of_rtt_message_after_a_minute    devices=device_1,device_2
    verify and make enable and disable cc button in rtt     devices=device_1
    verify call state in TDC AND DUT in rtt     device=tdc_1:device2user     state=connected        devices=device_1,device_2
    share rtt message from chat option in TDC    device=tdc_1:device2user
    verify message from desktop user reflected in Dut    devices=device_1,device_2        from_device=tdc_1:device2user
    verify and make enable and disable cc button in rtt     devices=device_1        status=off
    Disconnect the call on TDC      device=tdc_1:device2user
    End call during meeting in DUT    device_lists=device_1,device_2
    verify call state in TDC and DUT    device=tdc_1:device2user     state=disconnected        device_list=device_1,device_2
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC2: Verify the turn on RTT for this meeting option in DUT
    [Tags]      557257
    [Setup]      Testcase Setup    count=1
    Join TDC meeting    device=tdc_1:device2user    edit_meeting_name=test_meeting
    Join Meeting    device=device_1     meeting=test_meeting
    Verify meeting state   device_list=device_1    state=Connected
    verify call state in TDC and DUT    device=tdc_1:device2user     state=connected        device_list=device_1
    enable real time text meeting web    device=tdc_1:device2user
    enable rtt option during meeting in Dut    device=device_1
    verify rtt text box appearance      devices=device_1
    share rtt message from chat option in TDC    device=tdc_1:device2user
    verify message from desktop user reflected in Dut    devices=device_1       from_device=tdc_1:device2user
    Wait for Some Time    time=1 minutes
    verify disable of rtt message after a minute    devices=device_1
    Disconnect the call on TDC      device=tdc_1:device2user
    End call during meeting in DUT    device_lists=device_1
    create a meeting using meet now in tdc      device=tdc_1:device2user
    search participate in people tab request to join    device=tdc_1:device2user    to_device=device_1
    Wait for Some Time    time=5s
    Pick incoming call    device=device_1
    enable rtt option during meeting in Dut    device=device_1
    enable real time text meeting web    device=tdc_1:device2user
    verify rtt text box appearance      devices=device_1
    share rtt message from chat option in TDC    device=tdc_1:device2user
    verify message from desktop user reflected in Dut    devices=device_1       from_device=tdc_1:device2user
    Wait for Some Time    time=1 minutes
    verify disable of rtt message after a minute    devices=device_1
    Disconnect the call on TDC      device=tdc_1:device2user
    End call during meeting in DUT    device_lists=device_1
    verify call state in TDC and DUT    device=tdc_1:device2user     state=disconnected        device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1  

TC3 : Verify old RTT text should not be display for late joinees
    [Tags]      557282
    [Setup]      Testcase Setup    count=3
    Join TDC meeting    device=tdc_1:device2user    edit_meeting_name=test_meeting
    Join Meeting    device=device_1,device_2     meeting=test_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify call state in TDC and DUT    device=tdc_1:device2user     state=connected        device_list=device_1
    enable real time text meeting web    device=tdc_1:device2user
    share rtt message from chat option in TDC    device=tdc_1:device2user
    verify rtt text box appearance      devices=device_1,device_2
    verify message from desktop user reflected in Dut    devices=device_1,device_2       from_device=tdc_1:device2user
    Join Meeting    device=device_3     meeting=test_meeting
    enable rtt option during meeting in Dut    device=device_3
    verify rtt text box appearance      devices=device_3
    verify disable of rtt message after a minute    devices=device_3
    share rtt message from chat option in TDC    device=tdc_1:device2user
    verify message from desktop user reflected in Dut    devices=device_3       from_device=tdc_1:device2user
    Wait for Some Time    time=1 minutes
    verify disable of rtt message after a minute    devices=device_3
    Disconnect the call on TDC      device=tdc_1:device2user
    End call during meeting in DUT    device_lists=device_1,device_2,device_3
    create a meeting using meet now in tdc      device=tdc_1:device2user
    search participate in people tab request to join    device=tdc_1:device2user    to_device=device_1,device_2
    Wait for Some Time    time=5s
    Pick incoming call    device=device_1,device_2
    enable real time text meeting web    device=tdc_1:device2user
    share rtt message from chat option in TDC    device=tdc_1:device2user
    verify rtt text box appearance      devices=device_1,device_2
    verify message from desktop user reflected in Dut    devices=device_1,device_2       from_device=tdc_1:device2user
    search_participate_in_people_tab_request_to_join    device=tdc_1:device2user    to_device=device_3
    Pick incoming call    device=device_3
    enable rtt option during meeting in Dut    device=device_3
    verify rtt text box appearance      devices=device_3
    verify disable of rtt message after a minute    devices=device_3
    share rtt message from chat option in TDC    device=tdc_1:device2user
    verify message from desktop user reflected in Dut    devices=device_3       from_device=tdc_1:device2user
    Wait for Some Time    time=1 minutes
    verify disable of rtt message after a minute    devices=device_3
    Disconnect the call on TDC      device=tdc_1:device2user
    End call during meeting in DUT    device_lists=device_1,device_2,device_3
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4 : Verify the RTT view when DUT user disconnect the meeting and joins back the same meeting while RTT is enabled and vice versa
    [Tags]      557284
    [Setup]      Testcase Setup    count=2
    Join TDC meeting    device=tdc_1:device2user    edit_meeting_name=test_meeting
    Join Meeting    device=device_1,device_2     meeting=test_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify call state in TDC and DUT    device=tdc_1:device2user     state=connected        device_list=device_1,device_2
    enable real time text meeting web    device=tdc_1:device2user
    share rtt message from chat option in TDC    device=tdc_1:device2user
    verify message from desktop user reflected in Dut    devices=device_1,device_2      from_device=tdc_1:device2user
    End call during meeting in DUT    device_lists=device_1
    Come back to home screen    device_list=device_1
    Join Meeting    device=device_1     meeting=test_meeting
    verify disable of rtt message after a minute    devices=device_1
    share rtt message from chat option in TDC    device=tdc_1:device2user
    verify message from desktop user reflected in Dut    devices=device_1       from_device=tdc_1:device2user
    Disconnect the call on TDC      device=tdc_1:device2user
    Join TDC meeting    device=tdc_1:device2user    edit_meeting_name=test_meeting
    verify Rtt text box availability    device=tdc_1:device2user
    enable real time text meeting web    device=tdc_1:device2user
    share rtt message from chat option in TDC    device=tdc_1:device2user
    verify message from desktop user reflected in Dut    devices=device_1,device_2       from_device=tdc_1:device2user
    Wait for Some Time    time=1 minutes
    verify disable of rtt message after a minute    devices=device_1,device_2
    Disconnect the call on TDC      device=tdc_1:device2user
    End call during meeting in DUT    device_lists=device_1,device_2
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC5: [Meet now] Verify RTT view in meet now
    [Tags]      557285      sanity_tp
    [Setup]      Testcase Setup    count=2
    create a meeting using meet now in tdc      device=tdc_1:device2user
    search participate in people tab request to join    device=tdc_1:device2user    to_device=device_1
    Wait for Some Time    time=5s
    Pick incoming call    device=device_1
    enable real time text meeting web    device=tdc_1:device2user
    share rtt message from chat option in TDC    device=tdc_1:device2user
    verify rtt text box appearance      devices=device_1
    verify message from desktop user reflected in Dut    devices=device_1       from_device=tdc_1:device2user
    verify call control visibility    device_list=device_1    rtt=on
    verify disable real time text meeting web       device=tdc_1:device2user
    Disconnect the call on TDC      device=tdc_1:device2user
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC6 : Verify RTT (Real Time Text) View in Meetings on 1st RTT message received from other clients
    [Tags]      557286
    [Setup]      Testcase Setup    count=1
    Join TDC meeting    device=tdc_1:device2user    edit_meeting_name=test_meeting
    Join Meeting    device=device_1     meeting=test_meeting
    Verify meeting state   device_list=device_1    state=Connected
    verify call state in TDC and DUT    device=tdc_1:device2user     state=connected        device_list=device_1
    enable real time text meeting web    device=tdc_1:device2user
    share rtt message from chat option in TDC    device=tdc_1:device2user
    verify rtt text box appearance      devices=device_1
    verify message from desktop user reflected in Dut    devices=device_1       from_device=tdc_1:device2user
    Wait for Some Time    time=1 minutes
    verify disable of rtt message after a minute    devices=device_1
    verify call control visibility    device_list=device_1    rtt=on
    verify disable real time text meeting web       device=tdc_1:device2user
    Disconnect the call on TDC      device=tdc_1:device2user
    End call during meeting in DUT    device_lists=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

*** Keywords ***
create new real time text meeting
    clear all day meeting and meeting history from calendar   devices=device_1,device_2,device_3
    initiate web driver     tdc_1:device2user
    perform web signin method     tdc_1:device2user
    create TDC meeting on desktop    device=tdc_1:device2user     meeting_name=test_meeting     participants=device_1,device_2,device_3    time_duration=30 mintues        use_current_time=True


Join TDC meeting
    [Arguments]    ${device}    ${edit_meeting_name}
    right click on created meeting from tdc     device=${device}       edit_meeting_name=${edit_meeting_name}      click=left
    join the meeting in TDC     device=${device}

End meeting
    Disconnect the call on TDC      device=tdc_1:device2user
    End call during meeting in DUT    device=device_1


Delete real time text meeting and close driver
    right click on created meeting from tdc       tdc_1:device2user     edit_meeting_name=test_meeting
    delete meeting from tdc     tdc_1:device2user
    clear all day meeting and meeting history from calendar   devices=device_1,device_2,device_3
    close web driver    tdc_1:device2user

verify call state in TDC and DUT
    [Arguments]     ${device}   ${state}   ${device_list}
    verify call state in tdc     ${device}     ${state}
    Verify Call State   ${device_list}   ${state}

verify call state in TDC AND DUT in rtt
    [Arguments]     ${device}   ${state}   ${devices}
    verify call state in tdc     ${device}     ${state}
    verify call connected state during rtt in dut       devices=${devices}
   


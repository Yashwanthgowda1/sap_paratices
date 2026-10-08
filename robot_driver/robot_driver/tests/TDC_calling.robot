*** Settings ***
Resource    resources/keywords/common.robot

Suite Setup     Setup for teams desktop client
Suite Teardown    Run Keywords     Suite Failure Capture    AND   close driver

*** Test Cases ***

TC1 : [Call Merge] DUT user receives multiple calls and merges call one by one
    [Tags]    309887        sanity_tp       p1
    [Setup]    Testcase Setup   count=4
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call   device=device_2
    verify call state    device_list=device_1,device_2     state=Connected
    Make outgoing call using display name    from_device=device_1     to_device=device_3
    Pick incoming call   device=device_3
    verify call state    device_list=device_1,device_3    state=Connected
    verify call state    device_list=device_2   state=hold
    Make outgoing call using display name    from_device=device_1    to_device=device_4
    Pick incoming call   device=device_4
    verify call state     device_list=device_1,device_4      state=Connected
    verify call state    device_list=device_3    state=hold
    Make outgoing call using display name    from_device=device_1    to_device=tdc_1:user
    accept_incoming_calls_in_tdc    device=tdc_1:user
    verify call state in TDC and DUT    device=tdc_1:user     state=connected        device_list=device_1
    verify call state     device_list=device_2,device_3,device_4    state=Hold
    verify multiple calls on hold in banner     from_device=device_1     to_device=device_2,device_3,device_4
    tap to return to call       device=device_1
    Verify and merge call   device=device_1    from_device=device_2     count=5
    verify call state in TDC and DUT    device=tdc_1:user     state=connected        device_list=device_1,device_2,device_3,device_4
    handle_teams_popup_during_accept_call       device=tdc_1:user
    Wait for Some Time    time=10
    Verify header of call roster   device=device_2    from_device=device_1,tdc_1:user
    resume one of the multiple calls   device=device_1    count=4       number_devices=5
    Verify and merge call   device=device_1    from_device=device_4     count=5
    verify call state in TDC and DUT    device=tdc_1:user     state=connected        device_list=device_1,device_2,device_3,device_4
    disconnect call    device=device_1,device_2,device_3,device_4
    verify call state in TDC and DUT    device=tdc_1:user     state=disconnected        device_list=device_1,device_2,device_3,device_4
    [Teardown]      Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC2: [Reactions] User to verify the reactions when the user is displayed on the main stage of TDC user
    [Tags]    310963     P2
    [Setup]    Testcase Setup   count=1
    create new meeting
    Join TDC meeting    device=tdc_1:user    edit_meeting_name=test_meeting
    Join Meeting    device=device_1     meeting=test_meeting
    Verify meeting state    device_list=device_1    state=Connected
    verify call state in tdc    device=tdc_1:user     state=connected
    verify_the_pin_option_in_tdc        device=tdc_1:user     to_device=device_1
    verify presence of reactions button in call control     device=device_1
    Verify reaction button in call control     device=device_1
    Tap on reaction button in call control      device=device_1
    Raise hand     device=device_1
    verify raise hand in tdc    device=tdc_1:user
    End meeting
    [Teardown]    Run Keywords    Capture on Failure    AND   Delete create meeting     AND      Come back to home screen    device_list=device_1

TC3 : [OBO] DUT user has multiple boss and able to receive calls on behalf of them_ also ring
    [Tags]   308681       sanity_tp   p1
    [Setup]   Run Keywords   Testcase Setup for Delegate User  count=4  AND     Enable Also Ring delegates during five devices and add delegate
    Make outgoing call using display name    from_device=device_4    to_device=device_1
    Verify Incoming call    device=device_1,device_2     status=appear
    Pick incoming call    device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_4    state=Connected
    make_outgoing_call_from_tdc_using_number       device=tdc_1:user     to_device=device_3
    Verify Incoming call    device=device_3,device_2     status=appear
    Pick incoming call    device=device_2
    Verify Incoming call    device=device_3     status=disappear
    verify call state in TDC and DUT        device=tdc_1:user     state=connected        device_list=device_2
    resume call from call hold banner   device=device_2
    verify call state in tdc    device=tdc_1:user     state=hold
    disconnect the call in tdc      device=tdc_1:user
    Wait for Some Time    time=5
    Verify call state and disconnect     device=device_2
    verify call state in TDC and DUT    device=tdc_1:user     state=disconnected        device_list=device_2,device_4
    [Teardown]  Run Keywords    Capture on Failure    AND   disable and remove delegate during five devices    AND   Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC4 : [OBO]DUT user has multiple boss and able to receive calls on behalf of them_ call forwarding
    [Tags]   308707       sanity_tp   p1
    [Setup]   Run Keywords   Testcase Setup for Delegate User  count=4      AND     Enable call forward to delegates during five devices and add delegate
    Make outgoing call using display name    from_device=device_4    to_device=device_1
    Verify Incoming call    device=device_1     status=disappear
    Pick incoming call    device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_4    state=Connected
    make_outgoing_call_from_tdc_using_number       device=tdc_1:user     to_device=device_3
    Verify Incoming call    device=device_3     status=disappear
    Pick incoming call    device=device_2
    verify call state in TDC and DUT        device=tdc_1:user     state=connected        device_list=device_2
    resume call from call hold banner   device=device_2
    verify call state in tdc    device=tdc_1:user     state=hold
    disconnect the call in tdc      device=tdc_1:user
    Verify call state and disconnect     device=device_2
    verify call state in TDC and DUT    device=tdc_1:user     state=disconnected        device_list=device_2,device_4
    [Teardown]  Run Keywords    Capture on Failure    AND   disable call forward and remove delegate during five devices    AND   Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC5 : [GCP] DUT user accepts 3 forwarded GCP calls and toggles between them
    [Tags]   308627      P1
    [Setup]     Run Keywords     Testcase Setup for GCP User  count=4      AND     Enable call forwarding to call group     from_device=device_1    contact_device=device_2
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify call notification    device=device_2     status=appear
    Pick incoming call from call notification    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    click on calls tab   device=device_4
    Make outgoing call using phonenumber    from_device=device_4      to_device=device_1
    Verify incoming call    device=device_2     status=appear
    Pick incoming call from call notification     device=device_2
    Verify Call State    device_list=device_2,device_4    state=Connected
    Verify Call State    device_list=device_3     state=Hold
    make_outgoing_call_from_tdc_using_number       device=tdc_1:user     to_device=device_1
    Verify incoming call    device=device_2     status=appear
    Pick incoming call from call notification     device=device_2
    verify call state in TDC and DUT    device=tdc_1:user     state=connected        device_list=device_2
    Wait for Some Time    time=5
    Resume the call   device=device_2
    Verify Call State    device_list=device_2,device_4    state=Connected
    Disconnect the call on TDC      device=tdc_1:user
    Verify call state and disconnect     device=device_2,device_3,device_4
    verify call state in TDC and DUT    device=tdc_1:user     state=disconnected        device_list=device_2,device_3,device_4
    [Teardown]  Run Keywords    Capture on Failure    AND    verify and disable call forwarding     device=device_1     AND   Come back to home screen    device_list=device_1,device_2,device_3,device_4

*** Keywords ***
Setup for teams desktop client
    initiate web driver     tdc_1:user
    perform web signin method     tdc_1:user      new_calander_toggle=False


close driver
    close web driver    tdc_1:user

verify call state in TDC and DUT
    [Arguments]     ${device}   ${state}   ${device_list}
    verify call state in tdc     ${device}     ${state}
    Verify Call State   ${device_list}   ${state}

Enable Also Ring delegates during five devices and add delegate
    Add new delegates with both permission and validate   from_device=device_3    to_device=device_2:delegate_user
    Enable Also Ring delegates     device=device_3
    Enable Also Ring delegates     device=device_1


disable and remove delegate during five devices
    Delete delegate from manage delegate   from_device=device_3    to_device=device_2:delegate_user
    Disable Also Ring    device=device_1
    Disable Also Ring    device=device_3

Enable call forward to delegates during five devices and add delegate
    Add new delegates with both permission and validate   from_device=device_3    to_device=device_2:delegate_user
    Enable call forwarding to delegates     from_device=device_3    contact_device=device_2
    Enable call forwarding to delegates     from_device=device_1    contact_device=device_2

disable call forward and remove delegate during five devices
    Delete delegate from manage delegate   from_device=device_3    to_device=device_2:delegate_user
    verify and disable call forwarding      device=device_1,device_3


create new meeting
    verify and modify new calender toggle       device=tdc_1:user
    create TDC meeting on desktop    device=tdc_1:user    meeting_name=test_meeting     participants=device_1,device_2,device_3,device_4      time_duration=30 mintues        use_current_time=True


Join TDC meeting
    [Arguments]    ${device}    ${edit_meeting_name}
    right click on created meeting from tdc     device=${device}       edit_meeting_name=${edit_meeting_name}      click=left
    join the meeting in TDC     device=${device}

End meeting
    Disconnect the call on TDC      device=tdc_1:user
    disconnect call    device=device_1


Delete create meeting
    right click on created meeting from tdc       tdc_1:user    edit_meeting_name=test_meeting
    delete meeting from tdc     tdc_1:user

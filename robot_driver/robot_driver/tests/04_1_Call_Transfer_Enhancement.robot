*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation      Suite Setup Requirements : This suite requires minimum of 3 devices in config
...                Purpose: Device_3 should be added as a favorite on Device_1 from recent call history

Suite Setup     Call Transfer Setup
Suite Teardown     Run Keywords    Suite Failure Capture    AND   Call Transfer Teardown

*** Test Cases ***
TC1: [CallTransferEnhancements] consult transfer search screen > shows speed dials
    [Tags]  456322    sanity_tp
    [Setup]  Testcase Setup    count=3
    Click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call transfer UI when in call   from_device=device_1   to_device=device_2   speed_dial_user=device_3    option=consult_first
    resume the call      device=device_1
    transfer call using speed dial from call transfer UI   device=device_1   speed_dial_user=device_3   transfer_option=consult_first
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3,device_1    state=Connected
    Verify Call State    device_list=device_2    state=Hold
    Completes the consultation to accept the call     from_device=device_1      to_device=device_2
    Verify Call State    device_list=device_1     state=Disconnected
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2: [CallTransferEnhancements] [landscape] blind transfer search screen > shows speed dials
    [Tags]   456364   sanity_tp    bvt_tp
    [Setup]   Testcase Setup    count=3
    ${landscape_mode_flag}   is portrait mode cnf device  device=device_1
    pass execution if   '${landscape_mode_flag}'=='True'  device_1, device is not a landscape mode device
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call transfer UI when in call   from_device=device_1   to_device=device_2    speed_dial_user=device_3   option=transfer_now
    resume the call      device=device_1
    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3: [CallTransferEnhancements] blind transfer search screen > shows speed dials
    [Tags]   456311   P1        bvt_pr      sanity_tp
    [Setup]   Testcase Setup    count=3
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call transfer UI when in call   from_device=device_1   to_device=device_2    speed_dial_user=device_3   option=transfer_now
    resume the call      device=device_1
    transfer call using speed dial from call transfer UI   device=device_1   speed_dial_user=device_3   transfer_option=transfer_now
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_3
    Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4:[CallTransferEnhancements] [landscape] blind transfer search screen > can search for users > touchscreen transfer
    [Tags]    456375         sanity_tp    bvt_tp
    [Setup]   Testcase Setup    count=3
    ${landscape_mode_flag}   is portrait mode cnf device  device=device_1
    pass execution if   '${landscape_mode_flag}'=='True'  device_1, device is not a landscape mode device
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call transfer UI when in call   from_device=device_1   to_device=device_2    speed_dial_user=device_3   option=transfer_now
    resume the call      device=device_1
    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC5 :[CallTransferEnhancements] hard key > initiate consult transfer
    [Tags]      456321      sanity_tp
    [Setup]    Testcase Setup   count=3
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call transfer UI when in call   from_device=device_1   to_device=device_2   speed_dial_user=device_3    option=consult_first     key=hard_key
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC6 :[CallTransferEnhancements] hard key > initiate blind transfer
    [Tags]      456309  P2
    [Setup]    Testcase Setup   count=3
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call transfer UI when in call   from_device=device_1   to_device=device_2   speed_dial_user=device_3    option=transfer_now     key=hard_key
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC7 :[CallTransferEnhancements] discoverability > has physical transfer key
    [Tags]      456323  P1
    [Setup]    Testcase Setup   count=2
    ${call_transfer_button}   has hardkey call transfer button present   device=device_1
    pass execution if   '${call_transfer_button}'=='False'  device_1, device is not have call transfer button
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify hints on transfer options    device=device_1     option=present
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC8 :[CallTransferEnhancements] discoverability > has NO physical transfer key
    [Tags]      456324      P2
    [Setup]    Testcase Setup   count=2
    ${call_transfer_button}   has hardkey call transfer button present   device=device_1
    pass execution if   '${call_transfer_button}'=='true'  device_1, device have call transfer button
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify options when click on transfer btn in call UI        device=device_1
    verify hints on transfer options    device=device_1     option=absent
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC9 :[CallTransferEnhancements] hard key > complete consult transfer
    [Tags]      456341      P0     sanity_tp
    [Setup]    Testcase Setup   count=3
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_2
    Verify Call State    device_list=device_2     state=Hold
    consult first to transfer the call  from_device=device_1      to_device=device_3    method=display_name     option=hard_key
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3    state=Connected
    transfer call from banner using hardkey     device=device_1
    Wait for Some Time    time=3s
    Verify Call State    device_list=device_1    state=Disconnected
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC10 :[CallTransferEnhancements] consult transfer search screen > can search for users > physical key transfer
    [Tags]      456379      P1
    [Setup]    Testcase Setup   count=3
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_2
    Verify Call State    device_list=device_2     state=Hold
    consult first to transfer the call  from_device=device_1      to_device=device_3    method=display_name     option=hard_key
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3    state=Connected
    transfer call from banner using hardkey     device=device_1
    Verify Call State    device_list=device_1    state=Disconnected
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC11 :[CallTransferEnhancements] [landscape] consult transfer search screen > can search for users > physical key transfer
    [Tags]      456380      P2
    [Setup]    Testcase Setup   count=3
    ${landscape_mode_flag}   is portrait mode cnf device  device=device_1
    pass execution if   '${landscape_mode_flag}'=='True'  device_1, device is not a landscape mode device
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_2
    Verify Call State    device_list=device_2     state=Hold
    consult first to transfer the call  from_device=device_1      to_device=device_3    method=display_name     option=hard_key
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3    state=Connected
    transfer call from banner using hardkey     device=device_1
    Verify Call State    device_list=device_1    state=Disconnected
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC12 :[CallTransferEnhancements] blind transfer search screen > can search for users > physical key transfer
    [Tags]      456376      P0  bvt_tp  sanity_tp
    [Setup]    Testcase Setup   count=3
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_2
    Verify Call State    device_list=device_2     state=Hold
    Blindtransfers the call   from_device=device_1      to_device=device_3      method=display_name     option=hard_key
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1    state=Disconnected
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC13 :[CallTransferEnhancements] [landscape] blind transfer search screen > can search for users > physical key transfer
    [Tags]      456377      P1
    [Setup]    Testcase Setup   count=3
    ${landscape_mode_flag}   is portrait mode cnf device  device=device_1
    pass execution if   '${landscape_mode_flag}'=='True'  device_1, device is not a landscape mode device
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_2
    Verify Call State    device_list=device_2     state=Hold
    Blindtransfers the call   from_device=device_1      to_device=device_3      method=display_name     option=hard_key
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1    state=Disconnected
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC14 :[Call Transfer] DUT User to test the transfer hard button
    [Tags]      309842      P0  bvt_tp  sanity_tp
    [Setup]    Testcase Setup   count=3
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call   from_device=device_1      to_device=device_3      method=display_name     option=hard_key
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1    state=Disconnected
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC15 :[Call transfer] Verify DUT user able to re-generate the call summary by tapping on Refresh icon.
   [Tags]   557913
   [Setup]   Testcase Setup    count=2
   Make outgoing call using phonenumber    from_device=device_1            to_device=device_2
   Pick incoming call   device=device_2
   click_on_call_transfer_and_enable_copilot    devices=device_1
   verify_options_inside_ai_contents_refresh    devices=device_1
   get summery from ai generate copilot  device=device_1
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2


*** Keywords ***
Call Transfer Setup
    navigate to calls favorites page      device=device_1
    remove favorite contacts from favorites tab   device=device_1
    click on calls tab     device=device_1
    Make outgoing call using display name      from_device=device_1      to_device=device_3
    Pick incoming call      device=device_3
    verify call state and disconnect        device=device_3,device_1
    Come back to home screen    device_list=device_1,device_3
    click on calls tab   device=device_1
    Refresh calls main tab    device=device_1
    Select call list item   device=device_1     item=favorite


Call Transfer Teardown
   Remove favorite user from favorites page    from_device=device_1     to_device=device_3
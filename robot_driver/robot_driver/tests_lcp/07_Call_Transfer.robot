*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1: [Call Transfer] DUT user blind transfer one Teams Client call to another Teams client
    [Tags]  244102      P1
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
    Verify display name on call toast   to_device=device_3    from_device=device_2
    Pick incoming call    device=device_3
    Verify call state and disconnect   device=device_1
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2: [Call Transfer] DUT user consultative transfer the TDC's call to another TDC
    [Tags]  244108      P1
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_2
    Verify display name on call toast   to_device=device_2    from_device=device_1
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_1    state=Connected
    Verify Call State    device_list=device_3    state=Hold
    Completes the consultation to accept the call     from_device=device_1      to_device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify Call State    device_list=device_1    state=Disconnected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3: [Call Transfer] DUT user to consult transfer the Desktop Teams Client call to another DUT user
    [Tags]  244113      P1
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_2
    Verify display name on call toast   to_device=device_2    from_device=device_1
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_1    state=Connected
    Verify Call State    device_list=device_3    state=Hold
    Completes the consultation to accept the call     from_device=device_1      to_device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify Call State    device_list=device_1    state=Disconnected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4: [Call Transfer] DUT user to blind transfer the TDC's call to another TDC who is on DND
    [Tags]  244107      P2
    [Setup]     run keywords     Testcase Setup     count=3     AND     Select user presence     device=device_3     state=DND
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3     status=Disappear
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND  Select user presence   device=device_3     state=available    AND   Come back to home screen    device_list=device_1,device_2,device_3

TC5: [Call Transfer] DUT user call transfer section should show "Contacts" option
    [Tags]  244100      P1    sanity_lcp
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify contacts option in call transfer section     device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC6: [Call Transfer] Initial list contacts in the call transfer section.
    [Tags]  244101    sanity_lcp
    [Setup]  Testcase Setup    count=3
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify initial list contacts in the call transfer section     from_device=device_1      to_device=device_3
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC7: [Call Transfer] Search option should be available in the call transfer section
    [Tags]   244099    tp_lcp
    [Setup]  Testcase Setup    count=2
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify search option in call transfer section     device=device_1
    Wait For Some Time    time=3s
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC8: [Call Transfer] User to test the transfer hard button
    [Tags]    244111      P2
    [Setup]    Testcase Setup   count=3
    ${intents_support}   has hardkey call transfer button present   device=device_1
    pass execution if   '${intents_support}'=='False'  device_1, device is not have call transfer button present
    Reset Logcat Capture    device=device_1
    Navigate To People Tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call   from_device=device_1      to_device=device_3      method=phone_number     option=hard_key
    Pick incoming call    device=device_3
    Verify presence of Intents     device=device_1      feature=KEYCODE_BUTTON_12      state=present
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify Call State     device_list=device_1    state=DisConnected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    Wait for Some Time    time=${wait_time}
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3


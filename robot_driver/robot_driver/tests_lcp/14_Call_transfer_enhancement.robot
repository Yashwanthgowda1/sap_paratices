*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Setup     Call Transfer Setup
Suite Teardown     Run Keywords    Suite Failure Capture    AND   Call Transfer Teardown

*** Test Cases ***
TC1: [Call Transfer Enhancements] blind transfer search screen > can search for users.
    [Tags]  456302      P1  Sanity_LCP
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify transfer target search screen for lcp    device=device_1     to_device=device_3      speed_dial_user=device_3    option=transfer_now
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2: [Call Transfer Enhancements] consult transfer search screen > can search for users.
    [Tags]  456304      P1  Sanity_LCP
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify transfer target search screen for lcp    device=device_1     to_device=device_3      speed_dial_user=device_3    option=consult_first
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3: [Call Transfer Enhancements] blind transfer search screen > shows speed dials
    [Tags]   456300
    [Setup]   Testcase Setup    count=3
    navigate to people tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call transfer UI when in call   from_device=device_1   to_device=device_2    speed_dial_user=device_3   option=transfer_now
    resume the call      device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State     device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4: [Call Transfer Enhancements] consult transfer search screen > shows speed dials.
    [Tags]   456301
    [Setup]   Testcase Setup    count=3
    navigate to people tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call transfer UI when in call   from_device=device_1   to_device=device_2    speed_dial_user=device_3   option=consult_first
    resume the call      device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State     device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC5 :[CallTransferEnhancements] discoverability > has NO physical transfer key
    [Tags]      456298      P2    sanity_lcp    bvt_lcp
    [Setup]    Testcase Setup   count=2
    ${call_transfer_button}   has hardkey call transfer button present   device=device_1
    pass execution if   '${call_transfer_button}'=='True'  device_1, device have call transfer button
    navigate to people tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify options when click on transfer btn in call UI        device=device_1
    verify hints on transfer options    device=device_1     option=absent
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC6 :[CallTransferEnhancements] discoverability > has physical transfer key
    [Tags]      456297  P1  Sanity_lcp
    [Setup]    Testcase Setup   count=2
    ${call_transfer_button}   has hardkey call transfer button present   device=device_1
    pass execution if   '${call_transfer_button}'=='False'  device_1, device  dont  have transfer button
    navigate to people tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify hints on transfer options    device=device_1     option=present
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
Call Transfer Setup
    navigate to people tab    device=device_1
    Make outgoing call using display name      from_device=device_1      to_device=device_3
    Pick incoming call      device=device_3
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    Come back to home screen    device_list=device_1,device_3
    click on calls tab   device=device_1
    Refresh calls main tab    device=device_1
    Select call list item   device=device_1     item=favorite

Call Transfer Teardown
   Remove favorite user from favorites page    from_device=device_1     to_device=device_3
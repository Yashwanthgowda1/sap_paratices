*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***


*** Test Cases ***
TC1 : Validate that call banner have 'private line' label
    [Tags]      459072
    [Setup]  Testcase Setup  count=2
    navigate to calls tab  device=device_2
    Make outgoing call using privateline number    from_device=device_2      to_device=device_1
    verify privateline label on call screen     device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2

TC2 : Validate that outgoing call work normally (not using private line)
    [Tags]      459071
    [Setup]  Testcase Setup  count=2
    navigate to calls tab  device=device_2
    Make outgoing call using privateline number    from_device=device_2      to_device=device_1
    verify privateline label on call screen     device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Verify call entries are synced in call log    from_device=device_1      to_device=device_2
    verify privateline on recent tab  device=device_1
    Select call list item    device=device_1     item=call
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2

TC3 : Validate that call banner have 'private line' label
    [Tags]      459073   bvt_lcp    sanity_lcp      phonesCY23_4
    [Setup]  Testcase Setup   count=3
    navigate to calls tab  device=device_2
    Make outgoing call using privateline number    from_device=device_2      to_device=device_1
    verify privateline label on call screen     device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2,device_3

TC4 : Verify DUT user able to Hold and Resume the Private line call
    [Tags]      476764
    [Setup]  Testcase Setup  count=2
    navigate to calls tab  device=device_2
    Make outgoing call using privateline number    from_device=device_2      to_device=device_1
    verify privateline label on call screen     device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1     state=Hold
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2

TC5 : Verify DUT user able to blind transfer the Private line call from TDC user to another DUT user
    [Tags]      476765    sanity_lcp
    [Setup]  Testcase Setup  count=3
    navigate to calls tab  device=device_2
    Make outgoing call using privateline number    from_device=device_2      to_device=device_1
    verify privateline label on call screen     device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
    Verify display name on call toast   to_device=device_3    from_device=device_2
    verify privateline label on call screen     device=device_3     status=disappear
    Pick incoming call    device=device_3
    Verify call state and disconnect   device=device_1
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2,device_3

TC6 : Verify DUT user able to consult transfer the Private line call from TDC user to another DUT user
    [Tags]      476766     bvt_lcp    sanity_lcp
    [Setup]  Testcase Setup  count=3
    navigate to calls tab  device=device_2
    Make outgoing call using privateline number    from_device=device_2      to_device=device_1
    verify privateline label on call screen     device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
    Verify display name on call toast   to_device=device_3    from_device=device_1
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3,device_1    state=Connected
    Verify Call State    device_list=device_2    state=Hold
    Completes the consultation to accept the call     from_device=device_1      to_device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify Call State    device_list=device_1    state=Disconnected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2,device_3

TC7 : Verify DUT user should get the Private line call from TDC user when DUT user set the Call forwarding to another DUT user
    [Tags]  476767      sanity_lcp
    [Setup]     run keywords   Testcase Setup    count=3   AND     Enable call forwarding and add contact     from_device=device_1    contact_device=device_2
    navigate to calls tab  device=device_3
    Make outgoing call using privateline number    from_device=device_3      to_device=device_1
    verify privateline label on call screen     device=device_1
    Verify incoming call    device=device_2     status=disappear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND    come back to home screen  device_list=device_1,device_2,device_3    AND     Disable Call forward lcp    devices=device_1

TC8 : Verify DUT user able to forward the Private line call from TDC user to Voicemail
    [Tags]      476768
    [Setup]    run keywords   Testcase Setup    count=2   AND    Set Call Forwarding    device=device_1
    navigate to calls tab  device=device_2
    Make outgoing call using privateline number    from_device=device_2      to_device=device_1
    verify privateline label on call screen     device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   run keywords  Capture on Failure    AND    come back to home screen  device_list=device_1,device_2     AND     Disable Call forward lcp   devices=device_1

*** Keywords ***
Disable Call forward lcp
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    open settings page  device=device_1
    disable call forwarding    device=device_1
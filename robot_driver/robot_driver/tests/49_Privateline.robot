*** Settings ***
Resource    ../resources/keywords/common.robot


Suite Teardown  Suite Failure Capture

*** Variables ***

*** Test Cases ***
TC1 : Validate that call banner have 'private line' label
    [Tags]      459066         phonesCY23_4
    [Setup]  Testcase Setup  count=2
    click on calls tab  device=device_2
    Make outgoing call using privateline number    from_device=device_2      to_device=device_1
    verify privateline label on call screen     device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2

TC2 : Validate that outgoing call work normally (not using private line)
    [Tags]      459065          phonesCY23_4
    [Setup]  Testcase Setup  count=2
    click on calls tab  device=device_2
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

TC3 : Verify basic call scenario for 'private line' call
    [Tags]      459067   sanity_tp      bvt_tp          phonesCY23_4
    [Setup]  Testcase Setup   count=3
    click on calls tab  device=device_2
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

TC4 :Verify DUT user able to blind transfer the Private line call from TDC user to another DUT user
    [Tags]       476398    P2       sanity_tp
    [Setup]   Testcase Setup    count=3
    Click on calls tab   device=device_2
    Make outgoing call using privateline number    from_device=device_2      to_device=device_1
    verify privateline label on call screen     device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time      time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
    verify privateline label on call screen     device=device_3         status=disappear
    Pick incoming call    device=device_3
    Wait for Some Time      time=${wait_time}
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure        AND     Come back to home screen    device_list=device_1,device_2,device_3

TC5 :Verify DUT user able to consult transfer the Private line call from TDC user to another DUT user
    [Tags]       476401    P0       bvt_tp       sanity_tp         bvt_pr
    [Setup]   Testcase Setup    count=3
    Click on calls tab   device=device_2
    Make outgoing call using privateline number    from_device=device_2      to_device=device_1
    verify privateline label on call screen     device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time      time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
    verify privateline label on call screen     device=device_3         status=disappear
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3,device_1    state=Connected
    Verify Call State    device_list=device_2    state=Hold
    Completes the consultation to accept the call     from_device=device_1      to_device=device_2
    Verify Call State    device_list=device_1     state=Disconnected
    Verify Call State    device_list=device_3,device_2    state=Connected
    verify privateline label on call screen     device=device_3         status=disappear
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure        AND     Come back to home screen    device_list=device_1,device_2,device_3

TC6 : Verify DUT user able to Hold and Resume the Private line call
    [Tags]       476394
    [Setup]   Testcase Setup    count=2
    Click on calls tab   device=device_2
    Make outgoing call using privateline number    from_device=device_2      to_device=device_1
    verify privateline label on call screen     device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time      time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    Disconnect call     device=device_2
    verify call state and disconnect        device=device_1
    Verify Call State    device_list=device_2,device_1     state=Disconnected
    [Teardown]  run keywords  Capture on Failure        AND     Come back to home screen    device_list=device_1,device_2

*** Settings ***
Resource    ../resources/keywords/common.robot
Suite Setup         Voicemail Setup
Suite Teardown      Run Keywords    Suite Failure Capture   AND     Voicemail Teardown

*** Variables ***
${wait_time_20s} =    20
${wait_time} =    10

*** Test Cases ***
TC1 : [Voicemail] User to test the Voicemail Hard button when user is on VM tab already
    [Tags]    243076    tp_lcp    p2
    [Setup]  Testcase Setup     count=1
    Navigate to voicemail tab    device=device_1
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_BUTTON_15
    verify voicemail tab    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC2 : [Voicemail] User to test the voicemail hard button when user is on any tab other than VM tab
    [Tags]    243075    tp_lcp    Smoke_LCP    Sanity_LCP    BVT_LCP
    [Setup]  Testcase Setup     count=1
    navigate to people tab    device=device_1
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_BUTTON_15
    verify voicemail tab    device=device_1
    Come back to home screen    device_list=device_1
    Navigate to calls tab       device=device_1
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_BUTTON_15
    verify voicemail tab    device=device_1
    Come back to home screen    device_list=device_1
    open settings page  device=device_1
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_BUTTON_15
    verify voicemail tab    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC3 : [Voicemail] DUT user delete the message while playing it.
    [Tags]    243838    tp_lcp    Smoke_LCP    Sanity_LCP    FTP_Scope    P1
    [Setup]   Testcase Setup    count=2
    Send Voicemail      from_device=device_2   to_device=device_1    time=120s
    Navigate to voicemail tab    device=device_1
    verify first voicemail displayname    to_device=device_1    from_device=device_2
    Delete voicemail while playing it    device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC4 : [Voicemail] DUT user should receive the VM, while playing other VM's.
    [Tags]    243914    tp_lcp    P2
    [Setup]   Testcase Setup    count=2
    Send Voicemail      from_device=device_2   to_device=device_1    time=150s
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_BUTTON_15
    verify voicemail tab    device=device_1
    Play voicemail    device=device_1
    Send Voicemail      from_device=device_2   to_device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC5 : [Voicemail] DUT user can toggle between VM and call
    [Tags]    243206    FTP_Scope    tp_lcp    p1
    [Setup]   Testcase Setup    count=3
    Send Voicemail      from_device=device_2   to_device=device_1    time=120s
    verify and disable call forwarding   device=device_1
    Navigate to voicemail tab    device=device_1
    verify first voicemail displayname    to_device=device_1    from_device=device_2
    Play voicemail    device=device_1
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    verify incoming call        device=device_1         status=appear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1    state=Hold
    Click back btn  device=device_1
    Resume voicemail    device=device_1
    Wait for Some Time    time=${wait_time_20s}
    Click on call action bar  device=device_1
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC6 : [Voicemail] Verify DUT user is able to access voicemail list.
    [Tags]    438337    tp_lcp    FTP_Scope    p1
    [Setup]  Testcase Setup    count=1
    Navigate To Calls Tab    device=device_1
    Wait for Some Time    time=${wait_time}
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_BUTTON_15
    verify voicemail tab    device=device_1
    Play voicemail    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC7 : [Voicemail] DUT user dial numbers in voicemail tab.
    [Tags]    438336    tp_lcp    p2
    [Setup]  Testcase Setup    count=1
    Navigate to voicemail tab    device=device_1
    dial hardkeys   device=device_1    hardkeys=0123456789
    verify daipad text box    device=device_1    text=0123456789
    Come back to home screen    device_list=device_1
    Navigate To Calls Tab    device=device_1
    dial hardkeys   device=device_1    hardkeys=0123456789
    verify daipad text box    device=device_1    text=0123456789
    Come back to home screen    device_list=device_1
    navigate to people tab      device=device_1
    dial hardkeys   device=device_1    hardkeys=0123456789
    verify daipad text box    device=device_1    text=0123456789
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC8 : [Voicemail] DUT user to play the voicemails from the list
    [Tags]    242919    p2
    [Setup]      Testcase Setup    count=2
    Send Voicemail      from_device=device_2   to_device=device_1
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_BUTTON_15
    verify voicemail tab    device=device_1
    verify first voicemail displayname    to_device=device_1    from_device=device_2
    Play Voicemail With Hard Button    device=device_1    hardkey_intent=66
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2


*** Keywords ***
Voicemail Setup
    Enable call forwarding to voicemail    from_device=device_1   contact_device=device_2

Voicemail Teardown
    Come back to home screen    device_list=device_1,device_2
    verify and disable call forwarding    device=device_1

Send Voicemail
    [Arguments]     ${from_device}   ${to_device}    ${time}=30s
    Navigate to calls tab    ${from_device}
    Make outgoing call using display name    ${from_device}      ${to_device}
    Verify Call State    device_list=${from_device}   state=Connected
    Wait for Some Time    time=${time}
    Disconnect call    device=${from_device}
	Verify Call State    device_list=${from_device}    state=disconnected

Play Voicemail With Hard Button
    [Arguments]     ${device}   ${hardkey_intent}
    press hardkeys   device=${device}    hardkey_intent=${hardkey_intent}
    Wait for Some Time    time=3s
    press hardkeys   device=${device}    hardkey_intent=${hardkey_intent}
    verify voicemail playing    device=${device}
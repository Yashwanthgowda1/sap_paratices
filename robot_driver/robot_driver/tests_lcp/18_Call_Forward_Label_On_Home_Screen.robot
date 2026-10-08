*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1 : [Call forward on home screen] Verify Display on Home screen with toggle option should be present under calling and it is Disabled by default.
    [Tags]      452086
    [Setup]   Testcase Setup     count=1
    verify display home screen toggle status under calling        device=device_1      status=off
    [Teardown]   run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1

TC2 : [Call forward on home screen] Verify DUT should display most recent forwarding setting in Call forwarding section to be fetched once we login.
    [Tags]      452191      bvt_lcp    sanity_lcp
    [Setup]   run keywords  Testcase Setup     count=1    AND     enable call forwarding display on home screen         device=device_1
    verify call forwarding icon     device=device_1
    verify call forwarding option in call forward icon      device=device_1
    [Teardown]   run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1   AND     disable call forwarding display on home screen   device=device_1

TC3 : [Call forward on home screen] Verify Call forwarding section should not be present on Home screen after unchecking the Display on Home screen option under Calling.
    [Tags]      452140
    [Setup]    Testcase Setup     count=1
    verify display home screen toggle status under calling        device=device_1      status=off
    enable call forwarding display on home screen         device=device_1
    disable call forwarding display on home screen   device=device_1
    verify call forwarding icon should not appear on home screen     device=device_1
    [Teardown]   run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1

TC4: [Call forward on home screen] Verify the options present inside the Call forwarding section on Home screen.
    [Tags]  452095      sanity_lcp
    [Setup]      Testcase Setup    count=1
    verify display home screen toggle status under calling        device=device_1      status=off
    enable call forwarding display on home screen         device=device_1
    verify call forwarding icon     device=device_1
    verify call forwarding option in call forward icon      device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1    AND     disable call forwarding display on home screen   device=device_1

TC5: [Call forward on home screen] Verify the DUT user should receive the Incoming call from TDC, When DUT user select Don't forward calls option from Call Forwarding section.
    [Tags]    452106        sanity_lcp      bvt_lcp
    [Setup]   run keywords  Testcase Setup    count=2     AND     enable call forwarding display on home screen         device=device_1
    verify and set call forwarding on home screen      device=device_1         option=off
    navigate to people tab     device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2   AND     disable call forwarding display on home screen   device=device_1

TC6 : [Call forward on home screen] Verify DUT should retain, Display on Home screen option is in enabled state when we re-sign in with the same account.
    [Tags]      452235       sanity_lcp
    [Setup]   run keywords  Testcase Setup     count=1    AND     enable call forwarding display on home screen         device=device_1
    open settings page      device=device_1
    Set Call Forwarding    device=device_1
    verify call forwarding status on calling            device=device_1         option=voicemail
    verify display home screen toggle status under calling        device=device_1      status=on
    Sign out  device_list=device_1
    signin method for lcp   device=device_1
    verify display home screen toggle status under calling        device=device_1      status=on
    verify call forwarding label status on home screen lcp      device=device_1         status=voicemail
    [Teardown]   run keywords  Capture on Failure    AND     Come back to home screen     device_list=device_1     AND   Disable Call forward   devices=device_1    AND     disable call forwarding display on home screen   device=device_1

*** Keywords ***

enable call forwarding display on home screen
    [Arguments]     ${device}
    verify and change toggle status for call forwarding display on home screen    device=${device}      status=on

disable call forwarding display on home screen
    [Arguments]     ${device}
    verify and change toggle status for call forwarding display on home screen    device=${device}      status=off

Disable Call forward
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    verify and disable call forwarding    device=device_1
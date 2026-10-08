*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Setup     call forward on home screen setup      from_device=device_1     to_device=device_2:delegate_user
Suite Teardown    run keywords  Suite Failure Capture   AND     verify and disable call forwarding    device=device_1   AND   Delete delegate from manage delegate    from_device=device_1    to_device=device_2:delegate_user

*** Variables ***
${wait_time} =  10
${wait_time2} =  5
${wait_time3} =  15

*** Test Cases ***

TC1: [Call forward on Home screen] Verify the DUT user should receive the Incoming call from TDC, When Don't forward calls, option should select in Call forwarding section on Homescreen.
    [Tags]    452664     BVT_CAPPremium     Sanity_CAPPremium     phonesCY23_4
    [Setup]    Testcase Setup for CAP Premium User    count=2
    verify and set call forwarding on home screen      device=device_1         option=off
    click on calls tab      device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   run keywords  Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC2: [Call forward on home screen] Verify the options present inside the Call forwarding section on Home screen
    [Tags]    452655     Sanity_CAPPremium     phonesCY23_4
    [Setup]   run keywords    Testcase Setup for CAP Premium User    count=2       AND    enable call forwarding display on home screen         device=device_1
    verify call forwarding option in call forward icon      device=device_1
    click on calls tab           device=device_1
    verify call forwarding option in call forward icon      device=device_1
    [Teardown]   run keywords  Capture on Failure    AND        dismiss call forwarding pop up on home screen       device=device_1    AND    Come back to home screen    device_list=device_1

TC3: [Call forward on home screen] Verify Display on Home screen with toggle button should be present under Calling and it is enabled by default.
    [Tags]    452483    P1   phonesCY23_4
    [Setup]   Testcase Setup for CAP Premium User    count=1
    verify display home screen toggle status under calling        device=device_1       status=on
    [Teardown]   run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1

TC4: [Call forward on home screen] Verify Display on Home screen with toggle button should be present under Calling.
    [Tags]  452481      P2
    [Setup]   Testcase Setup for CAP Premium User    count=1
    verify display home screen toggle status under calling        device=device_1       status=on
    [Teardown]   run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1

TC5: [Call forward on home screen] Verify Call forwarding section should not be present on home screen after disabling the Display on home screen option under Calling
    [Tags]   452712     P1     phonesCY23_4
    [Setup]    Testcase Setup for CAP Premium User   count=1
    disable call forwarding display on home screen    device=device_1
    verify home screen tiles       device=device_1      device_type=cap_home_screen_enabled
    verify call forwarding icon should not appear on home screen     device=device_1
    [Teardown]   run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1       AND     enable call forwarding display on home screen   device=device_1

TC6: [Call forward on home screen] Verify Display on Home screen is in enabled state by default when we re-sign in with the different account and is not retaining the previous account state.
    [Tags]   452779    P2    phonesCY23_4
    [Setup]  Testcase Setup for CAP Premium User   count=1
    verify display home screen toggle status under calling        device=device_1       status=on
    disable call forwarding display on home screen   device=device_1
    verify call forwarding icon should not appear on home screen     device=device_1
    Sign out method    device_1
    Wait for Some Time    time=${wait_time}
    Sign in method     device_1
    verify call forwarding icon     device=device_1
    verify display home screen toggle status under calling        device=device_1       status=on
    Sign out method    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND     sign in method     device=device_1    user=cap_search_enabled

TC7: [Call forward on home screen] Verify DUT should retain the Display on Home screen option enabled state when we are re-sign in with the same account.
    [Tags]   452772    Sanity_CAPPremium    phonesCY23_4
    [Setup]  Testcase Setup for CAP Premium User   count=1
    verify display home screen toggle status under calling        device=device_1       status=on
    verify home screen tiles       device=device_1      device_type=cap_home_screen_enabled
    verify call forwarding icon     device=device_1
    Sign out method    device_1
    Wait for Some Time    time=${wait_time}
    Sign in method      device=device_1      user=cap_search_enabled
    Wait for Some Time    time=${wait_time}
    verify call forwarding icon     device=device_1
    verify display home screen toggle status under calling        device=device_1       status=on
    [Teardown]   run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1

TC8: [Call forward on home screen] Verify DUT should display most recent forwarding setting in Call forwarding section to be fetched once we login.
    [Tags]      452492    BVT_CAPPremium     Sanity_CAPPremium    phonesCY23_4
    [Setup]   Testcase Setup for CAP Premium User    count=1
    Sign out method    device_1
    Wait for Some Time    time=${wait_time}
    Sign in method      device=device_1      user=cap_search_enabled
    verify display home screen toggle status under calling        device=device_1       status=on
    verify call forwarding icon     device=device_1
    navigate to calls tab      device=device_1
    verify call forwarding icon     device=device_1
    [Teardown]   run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1

TC9: [Call forward on home screen] Verify DUT, when DUT user changes the call forwarding setting from home screen it should reflect in calling setting.
    [Tags]     452752     Sanity_CAPPremium     phonesCY23_4
    [Setup]   run keywords     Testcase Setup for CAP Premium User    count=2       AND    enable call forwarding display on home screen         device=device_1
    verify and set call forwarding on home screen      device=device_1         option=off
    verify call forwarding status on calling            device=device_1         option=off
    verify and set call forwarding on home screen     device=device_1         option=voicemail
    verify call forwarding status on calling            device=device_1         option=voicemail
    verify and set call forwarding on home screen     device=device_1         option=contact_or_number        to_device=device_2
    verify call forwarding status on calling            device=device_1         option=contact_or_number        to_device=device_2
    verify and set call forwarding on home screen     device=device_1         option=delegate           to_device=device_2:delegate_user
    verify call forwarding status on calling            device=device_1         option=delegate
    Disable Call forward   devices=device_1
    verify call forwarding label status on home screen      device=device_1         status=off
    open settings page      device=device_1
    Set Call Forwarding    device=device_1
    verify call forwarding label status on home screen      device=device_1         status=voicemail
    Enable Also Ring and add contact     device=device_1   contact_device=device_2
    verify call forwarding label status on home screen      device=device_1         status=contact_or_number        to_device=device_2
    Enable Also Ring delegates    device=device_1
    verify call forwarding label status on home screen      device=device_1         status=delegate
    Enable Also Ring Call group     device=device_1
    verify call forwarding label status on home screen      device=device_1         status=call_group
    [Teardown]   run keywords  Capture on Failure    AND        dismiss call forwarding pop up on home screen       device=device_1    AND     Disable Call forward   devices=device_1

*** Keywords ***
Disable Call forward
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    verify and disable call forwarding    device=device_1

enable call forwarding display on home screen
    [Arguments]     ${device}
    verify and change toggle status for call forwarding display on home screen    device=${device}      status=on

disable call forwarding display on home screen
    [Arguments]     ${device}
    verify and change toggle status for call forwarding display on home screen    device=${device}      status=off

call forward on home screen setup
    [Arguments]     ${from_device}   ${to_device}
    open settings page      ${from_device}
    open manage delegate page    ${from_device}
    Add new delegate   from_device=${from_device}    to_device=${to_device}
    Come back to home screen     ${from_device}
    navigate to calls tab    ${to_device}
    refresh calls main tab    ${to_device}

Add new delegates with both permission and validate
    [Arguments]     ${from_device}     ${to_device}
    open_settings_page      ${from_device}
    open_manage_delegate_page    ${from_device}
    Add new delegate      ${from_device}      ${to_device}
    validate added delegate user name      ${from_device}      ${to_device}
    Come back to home screen    ${from_device}
    navigate to calls favorites page  ${to_device}
    refresh calls main tab  ${to_device}
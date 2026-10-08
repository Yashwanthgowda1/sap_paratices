*** Settings ***
Resource    ../resources/keywords/common.robot


Suite Teardown    run keywords  Suite Failure Capture   AND     verify and disable call forwarding    device=device_1

*** Variables ***
${wait_time} =  10
${wait_time2} =  5
${wait_time3} =  15

*** Test Cases ***
TC1 :[Call forward on home screen] Verify DUT should display most recent forwarding setting to be fetched once we enable the Display on Homescreen option.
    [Tags]      452082       sanity_tp    phonesCY23_4
    [Setup]   Testcase Setup    count=1
    Sign out method    device_1
    Wait for Some Time    time=${wait_time}
    Sign in method     device_1
    verify display home screen toggle status under calling        device=device_1       status=off
    [Teardown]   run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1

TC2 :[Call forward on home screen] Verify Display on Home screen with toggle button should be present under Calling page and it is Disabled by default.
    [Tags]      452078      phonesCY23_4
    [Setup]   Testcase Setup    count=1
    verify display home screen toggle status under calling        device=device_1       status=off
    verify call forwarding icon should not appear on home screen     device=device_1
    navigate to calls tab      device=device_1
    verify call forwarding icon should not appear on home screen     device=device_1
    [Teardown]   run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1

TC3 :Verify Call forwarding section should not be present on Home screen after unchecking the Display on Home screen option under Calling.
    [Tags]      452109          phonesCY23_4
    [Setup]   Testcase Setup    count=1
    disable call forwarding display on home screen  device=device_1
    navigate to calls tab      device=device_1
    verify call forwarding icon should not appear on home screen     device=device_1
    [Teardown]   run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1       AND     enable call forwarding display on home screen   device=device_1

TC4 : [Call forward on home screen] Verify DUT, when DUT user changes the call forwarding setting from home screen it should reflect in calling setting.
    [Tags]      452144      sanity_tp     phonesCY23_4     bvt_pr
    [Setup]   run keywords      Testcase Setup    count=2       AND    enable call forwarding display on home screen         device=device_1
    verify and set call forwarding on home screen      device=device_1         option=off
    verify call forwarding status on calling            device=device_1         option=off
    verify and set call forwarding on home screen     device=device_1         option=voicemail
    verify call forwarding status on calling            device=device_1         option=voicemail
    verify and set call forwarding on home screen     device=device_1         option=contact_or_number        to_device=device_2
    verify call forwarding status on calling            device=device_1         option=contact_or_number        to_device=device_2
    verify and set call forwarding on home screen     device=device_1         option=delegate           to_device=device_2:delegate_user
    verify call forwarding status on calling            device=device_1         option=delegate
    verify and set call forwarding on home screen      device=device_1         option=call_group
    verify call forwarding status on calling            device=device_1         option=call_group
    Disable Call forward   devices=device_1
    verify call forwarding label status on home screen      device=device_1         status=off
    open settings page      device=device_1
    Set Call Forwarding    device=device_1
    verify call forwarding label status on home screen      device=device_1         status=voicemail
    Enable call forwarding to contacts     from_device=device_1   contact_device=device_2
    verify call forwarding label status on home screen      device=device_1         status=contact_or_number        to_device=device_2
    Enable call forwarding to delegates    from_device=device_1         contact_device=device_2:delegate_user
    verify call forwarding label status on home screen      device=device_1         status=delegate
    Enable call forwarding to call group     from_device=device_1           contact_device=device_2:gcp_user
    verify call forwarding label status on home screen      device=device_1         status=call_group
    [Teardown]   run keywords  Capture on Failure    AND        dismiss call forwarding pop up on home screen       device=device_1    AND     Disable Call forward   devices=device_1

TC5 : Verify DUT user should receive the Incoming call from TDC, When Don't forward calls option is selected in Call forwarding section on Home screen.
    [Tags]       452093      sanity_tp     phonesCY23_4         bvt_pr
    [Setup]   run keywords      Testcase Setup    count=2       AND    enable call forwarding display on home screen         device=device_1
    verify and set call forwarding on home screen      device=device_1         option=off
    click on calls tab      device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   run keywords  Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC6 : [Call forward on home screen] Verify the options present inside the Call forwarding section on Home screen.
    [Tags]      452090      sanity_tp     phonesCY23_4
    [Setup]   run keywords      Testcase Setup    count=2       AND    enable call forwarding display on home screen         device=device_1
    verify call forwarding option in call forward icon      device=device_1
    click on calls tab           device=device_1
    verify call forwarding option in call forward icon      device=device_1
    [Teardown]   run keywords  Capture on Failure    AND        dismiss call forwarding pop up on home screen       device=device_1    AND    Come back to home screen    device_list=device_1

TC7 :[Call forward on home screen] Verify Call forward icon in calls tab.
    [Tags]      452549      phonesCY23_4        sanity_tp
    [Setup]   run keywords      Testcase Setup    count=2       AND    enable call forwarding display on home screen         device=device_1
    navigate to calls tab      device=device_1
    verify call forwarding option in call forward icon      device=device_1
    [Teardown]   run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1

TC8 :[Call forward on home screen] Verify DUT should retain, Display on Home screen option is in enabled state when we re-sign in with the same account.
    [Tags]  452462      P1      sanity_tp
    [Setup]  Testcase Setup    count=1
    verify display home screen toggle status under calling        device=device_1       status=on
    verify home screen tiles        device=device_1
    verify call forwarding icon     device=device_1
    Sign out method    device_1
    Wait for Some Time    time=${wait_time}
    Sign in method     device_1
    verify call forwarding icon     device=device_1
    click on calls tab      device=device_1
    verify call forwarding icon     device=device_1
    verify display home screen toggle status under calling        device=device_1       status=on
    [Teardown]   run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1

TC9 :[Call forward on home screen] Verify DUT should retain Display on Home screen is in enabled state even after disabling and re-sign in with the same account.
    [Tags]  452547      P2
    [Setup]  Testcase Setup  count=1
    verify display home screen toggle status under calling        device=device_1       status=on
    disable call forwarding display on home screen  device=device_1
    verify call forwarding icon should not appear on home screen     device=device_1
    Sign out method    device_1
    Wait for Some Time    time=${wait_time}
    Sign in method     device_1
    verify call forwarding icon     device=device_1
    verify display home screen toggle status under calling        device=device_1       status=on
    [Teardown]  run keywords    capture on failure      AND     come back to home screen    device_list=device_1

TC10 :[Call forward on home screen] Verify Forward to my delegates option should not display in the call forwarding section & by default Don't Forward Calls should get update in call forwarding section, when user DUT user removes the delegates.
    [Tags]  452529      P0      phonesCY23_4        bvt_pr
    [Setup]   run keywords      Testcase Setup    count=3       AND    enable call forwarding display on home screen         device=device_2
    Add new delegates with both permission and validate   from_device=device_2    to_device=device_3
    verify call forwarding option in call forward icon    device=device_2    verify_call_group=off
    verify and set call forwarding on home screen     device=device_2        option=delegate           to_device=device_3
    Delete delegate from manage delegate    from_device=device_2     to_device=device_3
    verify call forwarding label status on home screen      device=device_2         status=off
    verify call forwarding option when no delegate present on device   device=device_2
   [Teardown]   run keywords  Capture on Failure    AND      dismiss call forwarding pop up on home screen       device=device_2     AND    verify and disable call forwarding    device=device_2    AND     Come back to home screen    device_list=device_1,device_3

TC11 :[Call forward on home screen] Verify DUT user should receive the Voicemail from the TDC, When DUT user selects Forward to Voicemail from the Call forwarding section on Home screen
    [Tags]  452094    P2
    [Setup]   run keywords      Testcase Setup    count=3       AND    enable call forwarding display on home screen         device=device_1
    verify call forwarding option in call forward icon    device=device_1
    Verify And Set Call Forwarding On Home Screen    device=device_1     option=voicemail
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=disappear
    Wait for Some Time    time=${wait_time3}
    Verify Call State    device_list=device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2    state=Disconnected
    Verify call entries are synced in call log               from_device=device_1      to_device=device_2      state=forwarded_to
    [Teardown]   run keywords  Capture on Failure    AND    dismiss call forwarding pop up on home screen       device=device_1    AND    Come back to home screen    device_list=device_1,device_2

TC12 :[Call forward on home screen] Verify that DUT user call should be forwarded to another TDC user, When DUT user selects Forward to contact or number from the Call forwarding section on home screen.
    [Tags]  452107    P2
    [Setup]   run keywords      Testcase Setup    count=2       AND    enable call forwarding display on home screen         device=device_1
    verify call forwarding option in call forward icon    device=device_1
    verify and set call forwarding on home screen     device=device_1         option=contact_or_number        to_device=device_2
    click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_1     status=disappear
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time3}
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3    state=Disconnected
    Verify call entries are synced in call log    from_device=device_1      to_device=device_3      state=forwarded_to
    [Teardown]   run keywords  Capture on Failure    AND    dismiss call forwarding pop up on home screen       device=device_1    AND    Come back to home screen    device_list=device_1,device_2

TC13 :[Call forward on home screen] Verify Display on Home screen is in enabled state by default when we re-sign in with the different account and is not retaining the previous account state.
    [Tags]  452463      P2
    [Setup]  Testcase Setup    count=2
    Disable Call Forwarding Display On Home Screen        device=device_1
    verify call forwarding icon should not appear on home screen     device=device_1
    Wait for Some Time    time=${wait_time}
    Signin with other user    device=device_1   other_user_account=device_2
    verify display home screen toggle status under calling        device=device_1       status=on
    verify call forwarding icon     device=device_1
    [Teardown]   run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1      AND       Testcase Setup    count=2

TC14 :Verify DUT user should get the Private line call from TDC user when DUT user set the Call forwarding to another DUT user
    [Tags]      476402      sanity_tp       P1
    [Setup]  Testcase Setup    count=3
    Enable call forwarding to contacts     from_device=device_1   contact_device=device_3
    Click on calls tab   device=device_2
    Make outgoing call using privateline number    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_3     status=disappear
    verify privateline label on call screen     device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time      time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   run keywords  Capture on Failure       AND    Come back to home screen    device_list=device_1,device_2,device_3

TC15 :[Call forward on home screen] Verify that DUT user call should be forwarded to call group, When DUT user selects Forward to call group from the Call forwarding section on home screen
    [Tags]      452117
    [Setup]    run keywords      Testcase Setup    count=4     AND    enable call forwarding display on home screen         device=device_1
    verify and set call forwarding on home screen      device=device_1         option=call_group         to_device=device_2
    Click on calls tab      device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify incoming call    device=device_3     status=appear
    Verify incoming call    device=device_4     status=appear
    Pick incoming call   device=device_3
    Verify incoming call    device=device_4     status=disappear
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    Verify call entries are synced in call log    from_device=device_1      to_device=device_2      state=forwarded_to
    [Teardown]  run keywords  Capture on Failure    AND    Come back to home screen   device_list=device_1,device_2,device_3,device_4    AND    verify and disable call forwarding     device=device_1


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

Add new delegates with both permission and validate
    [Arguments]     ${from_device}     ${to_device}
    open_settings_page      ${from_device}
    open_manage_delegate_page    ${from_device}
    Add new delegate      ${from_device}      ${to_device}
    validate added delegate user name      ${from_device}      ${to_device}
    Come back to home screen    ${from_device}
    navigate to calls favorites page  ${to_device}
    refresh calls main tab  ${to_device}
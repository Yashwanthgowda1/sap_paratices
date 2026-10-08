*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Setup     Advance calling Setup for SLA      from_device=device_1     to_device=device_2:delegate_user
Suite Teardown    run keywords   Suite Failure Capture   AND   Delete delegate from manage delegate    from_device=device_1    to_device=device_2:delegate_user

*** Variables ***
${wait_time} =  10

*** Test Cases ***
# TC1 to TC6 doesn't support in U3-2023, Hence removed.

#TC1 : [SLA]Verify that Boss is kicked out of the call when the Delegate resume the call from resume banner.
#    [Documentation]  Precondition : device_2 and device_3 should contain delegate users in the config.
#    [Tags]  346055       P1     Sanity_CAPPremium
#    [Setup]  Testcase Setup for CAP 2 Delegate User   count=4
#    open settings page      device=device_1
#    open manage delegate page    device=device_1
#    Add new delegate    from_device=device_1    to_device=device_3:delegate_user
#    navigate to calls tab    device=device_1
#    Make outgoing call using display name   from_device=device_1      to_device=device_4
#    Pick incoming call    device=device_4
#    Verify Call State    device_list=device_1,device_4    state=Connected
#    hold the call     device=device_1
#    Wait for Some Time    time=${wait_time}
#    verify resume banner   device_list=device_2,device_3
#    resume the call   device=device_3
#    Verify Call State      device_list=device_1    state=Disconnected
#    Verify Call State      device_list=device_3,device_4     state=Connected
#    Disconnect call     device=device_3
#    Verify Call State      device_list=device_3,device_4    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2,device_3,device_4   AND  Delete delegate from manage delegate    from_device=device_1    to_device=device_3:delegate_user
#
#TC2 : [SLA]verify boss is able to access all call control bars when resuming the call from boss
#    [Documentation]  Precondition : device_2 and device_3 should contain delegate users in the config.
#    [Tags]  346060       P1     Sanity_CAPPremium
#    [Setup]  Testcase Setup for CAP 2 Delegate User    count=4
#    click on calls tab     device=device_4
#    Make outgoing call using display name   from_device=device_4     to_device=device_1:cap_search_enabled
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_4    state=Connected
#    hold the call     device=device_1
#    Wait for Some Time    time=${wait_time}
#    resume the call   device=device_2
#    Verify Call State      device_list=device_2,device_4      state=Connected
#    hold the call     device=device_2
#    Wait for Some Time    time=${wait_time}
#    resume the call   device=device_1
#    verify call control visibility   device_list=device_1
#    Disconnect call     device=device_1
#    Verify Call State      device_list=device_1,device_4    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2,device_3
#
#TC3 : [SLA]Verify that DUT user add Delegates sucessfully.
#    [Documentation]  Precondition : device_2 and device_3 should contain delegate users in the config.
#    [Tags]   346047      P2
#    [Setup]  Testcase Setup for CAP 2 Delegate User   count=3
#    open settings page      device=device_1
#    validate added delegate user name     from_device=device_1     to_device=device_2:delegate_user
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2,device_3
#
#TC4 : [SLA]Verify boss should display under "people u support" in delegates user while delegate is added in Boss.
#    [Documentation]  Precondition : device_2 and device_3 should contain delegate users in the config.
#    [Tags]   346048      P2
#    [Setup]  Testcase Setup for CAP 2 Delegate User    count=3
#    open settings page      device=device_1
#    validate added delegate user name     from_device=device_1     to_device=device_2:delegate_user
#    verify people you support in favorites page    from_device=device_2     to_device=device_1:cap_search_enabled
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2,device_3
#
#TC5 : [SLA]Verify that "Call in Progress" icon should be display under “people you support” , when the Boss is in call with another Boss.
#    [Documentation]  Precondition : device_2 and device_3 should contain delegate users in the config.
#    [Tags]   346049     P2
#    [Setup]  Testcase Setup for CAP 2 Delegate User    count=4
#    Make outgoing call using display name   from_device=device_1     to_device=device_4
#    Pick incoming call    device=device_4
#    Verify Call State    device_list=device_1,device_4    state=Connected
#    Wait for Some Time    time=${wait_time}
#    navigate to calls favorites page   device=device_2
#    refresh calls main tab    device=device_2
#    verify call dropdown from favorites tab  device=device_2   from_device=device_4   to_device=device_1:cap_search_enabled    tile=user
#    disconnect call    device=device_1
#    Verify Call State      device_list=device_1,device_4    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2,device_3,device_4
#
#TC6 : [SLA]Verify that Resume banner should be disappear from other delegates when one of the delegate "Resumes" the call.
#    [Documentation]  Precondition : device_2 and device_3 should contain delegate users in the config.
#    [Tags]   346054      P2
#    [Setup]  Testcase Setup for CAP 2 Delegate User   count=4
#    open settings page      device=device_1
#    open manage delegate page    device=device_1
#    Add new delegate    from_device=device_1    to_device=device_3:delegate_user
#    navigate to calls tab    device=device_1
#    Make outgoing call using display name   from_device=device_1      to_device=device_4
#    Pick incoming call    device=device_4
#    Verify Call State    device_list=device_1,device_4    state=Connected
#    hold the call     device=device_1
#    Wait for Some Time    time=${wait_time}
#    verify resume banner   device_list=device_2,device_3
#    resume the call   device=device_2
#    Verify Call State      device_list=device_1    state=Disconnected
#    Verify Call State      device_list=device_2,device_4     state=Connected
#    verify no resume banner present in home screen    device=device_3
#    Disconnect call     device=device_2
#    Verify Call State      device_list=device_2,device_4    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2,device_3,device_4   AND  Delete delegate from manage delegate    from_device=device_1    to_device=device_3:delegate_user

TC1 : Verify that DUT user able to join the call by using Resume button Present inside the more info icon beside the username of Delegates under You delegates section,when Delegate user is in call on behalf of boss with other user.
    [Tags]     417218      BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium Delegate User   count=3
    navigate to manage delegate page    device=device_1
    disable option in delegates permission    device=device_1     to_device=device_2:delegate_user           option=Join_active_calls
    Initiate OBO call and verify boss list  from_device=device_2     to_device=device_3     obo_option=device_1:cap_search_enabled     boss_list=device_1:cap_search_enabled
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    Hold the call   device=device_2
    Verify Call State    device_list=device_2    state=Hold
    navigate to calls favorites page   device=device_1
    resume the call       device=device_1
    Verify Call State    device_list=device_2     state=Disconnected
    Verify Call State    device_list=device_1,device_3     state=Connected
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND  enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls     AND  Come back to home screen    device_list=device_1,device_2,device_3

TC2 : Verify that DUT (Delegate) should display join and resume button, When Boss enabled "Join active call" and "Pick up held calls" option.
    [Tags]    417219     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]   Testcase Setup for CAP Premium Delegate User   count=3
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    navigate to calls favorites page   device=device_2
    verify and join call using join button with boss   from_device=device_2      to_device=device_1:cap_search_enabled
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call    device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    verify and join call using join button with boss   from_device=device_2      to_device=device_1:cap_search_enabled
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1    state=Hold
    resume the call       device=device_1
    Disconnect call    device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure     AND      Come back to home screen    device_list=device_1,device_2,device_3

TC3 : Verify that DUT user able to join the call when DUT user tap on Resume call option Present inside the more info icon beside the username of Delegates under Your delegates,when Delegate user is in call with other useron behalf of boss
    [Tags]    417217      BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium Delegate User   count=3
    navigate to manage delegate page    device=device_1
    disable option in delegates permission    device=device_1     to_device=device_2:delegate_user           option=Join_active_calls
    Come back to home screen    device_list=device_1
    Initiate OBO call and verify boss list  from_device=device_2     to_device=device_3     obo_option=device_1:cap_search_enabled     boss_list=device_1:cap_search_enabled
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    Hold the call   device=device_2
    Verify Call State    device_list=device_2    state=Hold
    navigate to calls favorites page   device=device_1
    resume the call       device=device_1
    Verify Call State    device_list=device_2     state=Disconnected
    Verify Call State    device_list=device_1,device_3     state=Connected
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure      AND      Come back to home screen    device_list=device_1,device_2,device_3

TC4 : Verify that DUT is not displaying Resume call option beside the username of boss under People you support, and inside more info when Pickup held calls option is disabled for Delegates.
    [Tags]   417212      BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium Delegate User   count=3
    navigate to manage delegate page    device=device_1
    disable option in delegates permission    device=device_1     to_device=device_2:delegate_user           option=Pick_up_held_calls
    Come back to home screen    device_list=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Hold the call   device=device_1
    verify delegate options inside call info with boss when boss is in call with other user   from_device=device_2    boss=device_1:cap_search_enabled
    Disconnect call    device=device_1,device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure      AND      Come back to home screen    device_list=device_1,device_2,device_3

TC5 : Verify that DUT is displaying Resume call option is present inside the more info icon beside the delegates under your delegates, when the delegate user is in call with other user on behalf of boss.
    [Tags]   417211     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium Delegate User   count=3
    navigate to manage delegate page    device=device_1
    disable option in delegates permission    device=device_1     to_device=device_2:delegate_user           option=Pick_up_held_calls
    Come back to home screen    device_list=device_1
    Initiate OBO call and verify boss list  from_device=device_2     to_device=device_3     obo_option=device_1:cap_search_enabled     boss_list=device_1:cap_search_enabled
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    Hold the call   device=device_2
    verify boss options inside call info with delegate when delegate is in call with other user   from_device=device_1    delegate=device_2:delegate_user
    Disconnect call    device=device_2,device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure      AND      Come back to home screen    device_list=device_1,device_2,device_3

TC6 : Verify the Delegate user able to Resume the call from the Resume call option present inside the more info icon beside the username of the boss under the People you support ,when Boss put the call on hold.
    [Tags]    417209      BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium Delegate User   count=3
    Delete delegate from manage delegate    from_device=device_1     to_device=device_2:delegate_user
    open settings page       device=device_2
    open manage delegate page      device=device_2
    Add new delegate   from_device=device_2     to_device=device_1:cap_search_enabled
    Make outgoing call using display name    from_device=device_2    to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Hold the call   device=device_2
    Verify Call State    device_list=device_2    state=Hold
    navigate to calls favorites page   device=device_1
    verify and resume call using resume call in more option with boss or delegate  from_device=device_1    to_device=device_2:delegate_user
    Verify Call State    device_list=device_2     state=Disconnected
    Verify Call State    device_list=device_1,device_3     state=Connected
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND  Come back to home screen    device_list=device_1,device_2,device_3  AND    Delete delegate from manage delegate    from_device=device_1     to_device=device_2:delegate_user   AND    Advance calling Setup for SLA   from_device=device_1   to_device=device_2:delegate_user

TC7 : [SLA]Verify that DUT user able to join the call when DUT user tap on Join call option Present inside the more info icon beside the username of the Delegates under the Your delegates when Delegate user is in call on behalf of boss with other user
    [Tags]   417208      BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium Delegate User   count=3
    Initiate OBO call and verify boss list  from_device=device_2     to_device=device_3     obo_option=device_1:cap_search_enabled     boss_list=device_1:cap_search_enabled
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    navigate to calls favorites page   device=device_1
    verify and join call using join call in more option with boss and delegate   from_device=device_1    to_device=device_2:delegate_user   option=join_call
    Verify Call State    device_list=device_1,device_2,device_3      state=Connected
    Disconnect call    device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3      state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND  Come back to home screen    device_list=device_1,device_2,device_3

TC8 : [SLA]Verify that DUT user able to join the call when DUT user tap on Join button Present beside the username of the boss under the People you support when Boss is in call with other user
    [Tags]    417206      BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium Delegate User   count=3
    Delete delegate from manage delegate    from_device=device_1     to_device=device_2:delegate_user
    open settings page      device=device_2
    open manage delegate page        device=device_2
    Add new delegate   from_device=device_2     to_device=device_1:cap_search_enabled
    navigate to manage delegate page    device=device_2
    disable option in delegates permission    device=device_2     to_device=device_1:cap_search_enabled          option=Pick_up_held_calls
    Come back to home screen    device_list=device_2
    Make outgoing call using display name    from_device=device_2    to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    verify and join call using join call in more option with boss and delegate   from_device=device_1    to_device=device_2   option=join_call
    Verify Call State    device_list=device_1,device_2,device_3      state=Connected
    Disconnect call    device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3      state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND  Come back to home screen    device_list=device_1,device_2,device_3

TC9 :[SLA]Verify that join call option should not present inside the more info icon beside the username of boss under People you support if join active call option is disabled for Delegates.
    [Tags]    417202      BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium Delegate User   count=3
    navigate to manage delegate page    device=device_1
    disable option in delegates permission    device=device_1     to_device=device_2:delegate_user           option=Join_active_calls
    Come back to home screen    device_list=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    verify delegate options inside call info with boss when boss is in call with other user   from_device=device_2    boss=device_1:cap_search_enabled
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND  Come back to home screen    device_list=device_1,device_2,device_3

TC10 :[SLA]Verify the options under Delegation Setting page
    [Tags]     417191    P2
    [Setup]  Testcase Setup for CAP Premium Delegate User   count=3
    verify default options present in delegate settings page    from_device=device_1    to_device=device_3
    verify default options enabled while adding delegate in delegate settings page    device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND  Come back to home screen    device_list=device_1

TC11 :[call forward on home screen] Verify DUT after adding delegates from TDC.
    [Tags]     452898        phonesCY23_4        BVT_CAPPremium     Sanity_CAPPremium
    [Setup]      Testcase Setup for CAP Premium Delegate User   count=3
    verify call forwarding option in call forward icon    device=device_1
    verify and set call forwarding on home screen     device=device_1         option=delegate           to_device=device_2:delegate_user
    Click on calls tab      device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1:cap_search_enabled
    Verify incoming call    device=device_1     status=disappear
    Pick incoming call   device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    Verify call entries are synced in call log    from_device=device_1      to_device=device_3      state=forwarded_to
    [Teardown]  run keywords  Capture on Failure    AND    Come back to home screen   device_list=device_1,device_2,device_3

TC12 :[Call forward on home screen] Verify that DUT user call should be forwarded to delegates, When DUT user selects Forward to my delegates option from the Call forwarding section.
    [Tags]    452674      phonesCY23_4      BVT_CAPPremium     Sanity_CAPPremium
    [Setup]        Testcase Setup for CAP Premium Delegate User    count=4
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_4
    verify call forwarding option in call forward icon    device=device_1
    verify and set call forwarding on home screen     device=device_1         option=delegate           to_device=device_2:delegate_user
    Click on calls tab      device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1:cap_search_enabled
    Verify incoming call    device=device_1     status=disappear
    Verify incoming call    device=device_4     status=appear
    Pick incoming call   device=device_2
    Wait for Some Time    time=${wait_time}
    Verify incoming call    device=device_4     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    Verify call entries are synced in call log    from_device=device_1      to_device=device_3      state=forwarded_to
    [Teardown]  run keywords  Capture on Failure    AND    Come back to home screen   device_list=device_1,device_2,device_3,device_4    AND     Delete delegate from manage delegate   from_device=device_1    to_device=device_4

*** Keywords ***
Advance calling Setup for SLA
    [Arguments]     ${from_device}   ${to_device}
    open settings page      ${from_device}
    open manage delegate page    ${from_device}
    Add new delegate   from_device=${from_device}    to_device=${to_device}
    validate added delegate user name      ${from_device}      ${to_device}
    Come back to home screen    ${from_device}
    navigate to calls tab  ${to_device}
    refresh calls main tab  ${to_device}

Add new delegates with both permission and validate
    [Arguments]     ${from_device}     ${to_device}
    open_settings_page      ${from_device}
    open_manage_delegate_page    ${from_device}
    Add new delegate      ${from_device}      ${to_device}
    validate added delegate user name      ${from_device}      ${to_device}
    Come back to home screen    ${from_device}
    navigate to calls favorites page  ${to_device}
    refresh calls main tab  ${to_device}
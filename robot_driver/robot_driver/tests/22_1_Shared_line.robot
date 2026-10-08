*** Settings ***
Resource    ../resources/keywords/common.robot


*** Variables ***
${wait_time} =  5
*** Test Cases ***
TC1 : Verify that Delegate user able to join the call by tapping on Resume button under Ongoing section Shared lines app/View shared line,When Boss is in Call with other user .
    [Tags]  435431     bvt_tp     sanity_tp
    [Setup]   Testcase Setup for Delegate User    count=3
    Clear notification from home screen     device=device_1
    click on calls tab  device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1    state=Hold
    navigate to calls favorites page    device=device_2
    verify and resume call using resume call in more option with boss or delegate    from_device=device_2    to_device=device_1    option=verify       shared_line=enabled
    verify and resume call using resume call in more option with boss or delegate    from_device=device_2    to_device=device_1    option=join_call    shared_line=enabled
    Verify Call State    device_list=device_1    state=Disconnected
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    Navigate to calls tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1    state=Hold
    verify and resume call using resume call in more option with boss or delegate    from_device=device_2    to_device=device_1    option=verify     shared_line=enabled
    tap and verify shared line ui on boss or delegate from call tab when other users are in call    from_device=device_2   to_device=device_1    users_in_call=device_1,device_3
    verify and resume call using resume call in more option with boss or delegate    from_device=device_2    to_device=device_1    option=join_call    shared_line=enabled
    Verify Call State    device_list=device_1    state=Disconnected
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2 : Verify Delegate should display ongoing section under recent tab by navigating shared lines app through view shared line option,when Boss is in call with other user.
    [Tags]  435413   P1   sanity_tp
    [Setup]   Testcase Setup for Delegate User   count=3
    navigate to manage delegate page    device=device_1
    disable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls
    disable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Pick_up_held_calls
    go back to previous page     device=device_1
    Clear notification from home screen     device=device_1
    click on calls tab  device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    verify added delegate user in favorites page     from_device=device_2    to_device=device_1
    verify join call option should not present in call favorites page   from_device=device_2     to_device=device_1
    Hold the call   device=device_1
    Verify Call State    device_list=device_1,device_3    state=Hold
    verify resume call option should not present inside the more icon of boss      from_device=device_2     to_device=device_1
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3 : Verify that Delegate user able to join the call by tapping on Join button under Ongoing section Shared lines app/View shared line,When Boss is in Call with other user .
    [Tags]  435424     bvt_tp     sanity_tp
    [Setup]  Testcase Setup for Delegate User   count=3
    navigate to manage delegate page    device=device_1
    disable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Pick_up_held_calls
    go back to previous page     device=device_1
    Clear notification from home screen     device=device_1
    click on calls tab  device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    navigate to recent tab from shared lines app and join ongoing call   from_device=device_2    to_device=device_1   users_in_call=device_1,device_3
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    Verify Call State    device_list=device_1,device_3    state=Connected
    return to home screen    device_list=device_2
    Navigate to Calls Favorites page    device=device_2
    verify and join call using join button with boss    from_device=device_2     to_device=device_1
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4 : Verify other Delegate able to Join the call by using Join call option and Resume call options persent inside the More info icon on Ongoing section under recrent tab in Shared lines app,When Delegate user is in call with other user on behalf of boss.
    [Tags]  435433     P1
    [Setup]   Testcase Setup for Delegate User    count=3
    Clear notification from home screen     device=device_1
    click on calls tab  device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    navigate to recent tab from shared lines app and join ongoing call   from_device=device_2    to_device=device_1   users_in_call=device_1,device_3
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    Verify Call State    device_list=device_1,device_3    state=Connected
    return to home screen    device_list=device_2
    Hold the call   device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Hold
    navigate to recent tab from shared lines app and join ongoing call   from_device=device_2    to_device=device_1   users_in_call=device_1,device_3
    Verify Call State    device_list=device_1     state=Disconnected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC5 : Verify Delegate should display ongoing section with Join button and resume button for ongoing active and held calls correspondingly under recent tab by navigating shared lines app through view shared line option,when Boss is in call with other user.
    [Tags]   435422     P2
    [Setup]   Testcase Setup for Delegate User     count=3
    Clear notification from home screen     device=device_1
    click on calls tab  device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    verify join or resume call using shared line option from calls tab   from_device=device_2    to_device=device_1   users_in_call=device_1,device_3    join_option=verify
    Hold the call   device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Hold
    verify join or resume call using shared line option from calls tab   from_device=device_2    to_device=device_1   users_in_call=device_1,device_3    resume_option=verify
    verify call state and disconnect     device=device_1,device_2,device_3
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC6 : Verify the Delegate should get only View Profile option inside the more info icon on Ongoing section under recrent tab in Shared lines app and While adding the Delegates ,boss should disable the Pick up held calls and Join active call options
    [Tags]  435434     P2
    [Setup]   Testcase Setup for Delegate User    count=4
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_3
    click on calls tab  device=device_2
    Initiate OBO call using display name    from_device=device_2      to_device=device_4     obo_option=device_1
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_2,device_4    state=Connected
    navigate to recent tab from shared lines app and verify view profile option in more info    from_device=device_3    to_device=device_1   users_in_call=device_2:delegate_user,device_4    call_state=active_call
    return to home screen    device_list=device_3
    Hold the call   device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_2,device_4    state=Hold
    navigate to recent tab from shared lines app and verify view profile option in more info    from_device=device_3    to_device=device_1   users_in_call=device_2:delegate_user,device_4    call_state=on_hold
    return to home screen    device_list=device_3
    Disconnect call     device=device_4
    Verify Call State    device_list=device_2,device_4     state=Disconnected
    click on calls tab  device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_4
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_1,device_4   state=Connected
    navigate to recent tab from shared lines app and verify view profile option in more info    from_device=device_2    to_device=device_1   users_in_call=device_1,device_4    call_state=active_call
    return to home screen    device_list=device_2
    Hold the call   device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_4    state=Hold
    navigate to recent tab from shared lines app and verify view profile option in more info    from_device=device_2    to_device=device_1   users_in_call=device_1,device_4    call_state=on_hold
    return to home screen    device_list=device_3
    Disconnect call     device=device_1
    verify call state and disconnect        device=device_2,device_3,device_4
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4    AND  Delete delegate from manage delegate    from_device=device_1    to_device=device_3

TC7 : Verify that delegate user able to join the call by tapping on Join button under Ongoing section Shared lines app, When other delegate is in Call with other user on behalf of boss
    [Tags]  435425    P1   sanity_tp
    [Setup]   Testcase Setup for Delegate User     count=4
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_3
    click on calls tab  device=device_1
    Initiate OBO call using display name    from_device=device_2      to_device=device_4     obo_option=device_1
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_2,device_4    state=Connected
    navigate to recent tab from shared lines app and join ongoing call   from_device=device_3   to_device=device_1   users_in_call=device_2:delegate_user,device_4
    Verify Call State    device_list=device_2,device_3,device_4   state=Connected
    Disconnect call     device=device_2,device_4
    verify call state and disconnect        device=device_1,device_2,device_3,device_4
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4     AND   Delete delegate from manage delegate    from_device=device_1    to_device=device_3

TC8 : Verify delegate should display ongoing section under recent tab with Join button and resume button for ongoing active and held calls correspondigly by navigating to shared lines app through view shared line option,when other delegate is in call with other
    [Tags]  435423    bvt_tp     sanity_tp
    [Setup]    Testcase Setup for Delegate User   count=4
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_3
    Clear notification from home screen     device=device_1
    click on calls tab  device=device_3
    Initiate OBO call using display name    from_device=device_3      to_device=device_4     obo_option=device_1
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_3,device_4    state=Connected
    Navigate to Calls Favorites page    device=device_2
    verify join or resume call using shared line option from calls tab    from_device=device_2     to_device=device_1   users_in_call=device_3,device_4     join_option=verify
    Hold the call   device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_3,device_4    state=Hold
    verify join or resume call using shared line option from calls tab    from_device=device_2     to_device=device_1    users_in_call=device_3,device_4    resume_option=resume
    Verify Call State    device_list=device_2,device_4   state=Connected
    Disconnect call     device=device_4
    verify call state and disconnect        device=device_1,device_2,device_3
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4     AND   Delete delegate from manage delegate    from_device=device_1    to_device=device_3

TC9 : Verify Delegate should display ongoing section under recent tab by navigating shared lines app through view shared line option,when delegate is in call with other user on behalf of boss, having join option and pick up held call disabled
    [Tags]   435419    P2    sanity_tp
    [Setup]   Testcase Setup for Delegate User   count=4
    navigate to manage delegate page    device=device_1
    disable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls
    disable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Pick_up_held_calls
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_3
    navigate to manage delegate page    device=device_1
    disable option in delegates permission    device=device_1     to_device=device_3        option=Join_active_calls
    disable option in delegates permission    device=device_1     to_device=device_3        option=Pick_up_held_calls
    Clear notification from home screen     device=device_1
    click on calls tab  device=device_2
    Initiate OBO call using display name    from_device=device_2      to_device=device_4     obo_option=device_1
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_2,device_4    state=Connected
    verify user in people you support page     from_device=device_3    to_device=device_1
    verify join or resume call using shared line option from calls tab   from_device=device_3    to_device=device_1   users_in_call=device_2:delegate_user,device_4    join_option=absent
    Hold the call   device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_2,device_4    state=Hold
    verify join or resume call using shared line option from calls tab   from_device=device_3    to_device=device_1   users_in_call=device_2:delegate_user,device_4    resume_option=absent
    verify call state and disconnect    device=device_1,device_2,device_3,device_4
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC11 : Verify Incoming Call info in the Shared line Recent tab of delegate and Calls recent tab of Boss when Delegator(Boss) doesn't answers the call.
    [Tags]    557238
    [Setup]    Testcase Setup    count=3
    Add New Delegates With Both Permission And Validate    from_device=device_2    to_device=device_1
    Make Outgoing Call Using Display Name    from_device=device_3    to_device=device_2
    Wait For Some Time    time=45s
    Disconnect Call    device=device_3
    Verify Call State    device_list=device_3    state=Disconnected
    Navigate To Calls Tab    device=device_2
    Verify Forwarded Call In Recent Tab    device=device_2    forward_to_voicemail=True
    Tap And Verify Shared Line Ui From People You Support In Call Favorites Tab    from_device=device_1    to_device=device_2       tab_required=True
    Verify Users List In Recent Tab From Shared Line Option    from_device=device_1    to_device=device_2    users_in_call=device_3
    Verify More Info Of Contact In Shared Line Recent Tab    from_device=device_1    to_device=device_3    call_status=missed
    Navigate Back Once    device=device_1
    Return To Home Screen    device_list=device_1
    Verify Users List In Recent Tab From Shared Line Option    from_device=device_1    to_device=device_2    users_in_call=device_3
    Verify More Info Of Contact In Shared Line Recent Tab    from_device=device_1    to_device=device_3    call_status=missed
    [Teardown]  Run Keywords    Capture on Failure     AND    Delete Delegate From Manage Delegate    from_device=device_2    to_device=device_1    AND     Come Back To Home Screen    device_list=device_1,device_2,device_3

TC12 : Verify Incoming Call info in the Shared line Recent tab of delegate and Calls Recent tab of Boss when Delegator(Boss) receives the call.
    [Tags]    557127        bvt_tp      sanity_tp
    [Setup]    Testcase Setup    count=3
    Add New Delegates With Both Permission And Validate    from_device=device_2    to_device=device_1
    Make Outgoing Call Using Display Name    from_device=device_3    to_device=device_2
    Pick Incoming Call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect Call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Disconnected
    Navigate To Calls Tab    device=device_2
    Verify Incoming Call In Recent Tab    device=device_2    caller_device=device_3
    Tap And Verify Shared Line Ui From People You Support In Call Favorites Tab    from_device=device_1    to_device=device_2
    Verify Users List In Recent Tab From Shared Line Option    from_device=device_1    to_device=device_2    users_in_call=device_3
    Verify More Info Of Contact In Shared Line Recent Tab    from_device=device_1    to_device=device_3    dialed_by=non delegate user   dialed_user=device_2
    Navigate Back Once    device=device_1
    Return To Home Screen    device_list=device_1
    Verify Users List In Recent Tab From Shared Line Option    from_device=device_1    to_device=device_2    users_in_call=device_3    user=Boss
    Verify More Info Of Contact In Shared Line Recent Tab    from_device=device_1    to_device=device_3    dialed_by=non delegate user   dialed_user=device_2
    [Teardown]  Run Keywords    Capture on Failure    AND    Delete Delegate From Manage Delegate    from_device=device_2    to_device=device_1     AND     Come Back To Home Screen    device_list=device_1,device_2,device_3

TC13 : Verify Incoming Call info in the Recent tab of Calls and Shared line app, when Delegate recieves a also ring call set by the boss.
    [Tags]    sh-4
    [Setup]    Testcase Setup    count=3
    Add New Delegates With Both Permission And Validate    from_device=device_2    to_device=device_1
    Enable Also Ring Delegates    device=device_2
    Make Outgoing Call Using Display Name    from_device=device_3    to_device=device_2
    Verify Incoming Call    device=device_1,device_2    status=Appear
    Pick Incoming Call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Incoming Call    device=device_2    status=Disappear
    Disconnect Call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Disconnected
    Navigate To Calls Tab    device=device_1
    Verify Forwarded Call In Recent Tab    device=device_1    forwarded_device=device_2
    Tap And Verify Shared Line Ui From People You Support In Call Favorites Tab    from_device=device_1    to_device=device_2
    Verify Users List In Recent Tab From Shared Line Option    from_device=device_1    to_device=device_2    users_in_call=device_3
    Verify More Info Of Contact In Shared Line Recent Tab    from_device=device_1    to_device=device_3    call_status=Answered on this device
    Navigate Back Once    device=device_1
    Return To Home Screen    device_list=device_1
    Verify Users List In Recent Tab From Shared Line Option    from_device=device_1    to_device=device_2    users_in_call=device_3
    Verify More Info Of Contact In Shared Line Recent Tab    from_device=device_1    to_device=device_3    call_status=Answered on this device
    Verify Incoming Call In Recent Tab    device=device_2    caller_device=device_3    answered_by_delegate=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Disable Also Ring    device=device_2    AND    Delete Delegate From Manage Delegate    from_device=device_2    to_device=device_1    AND    Come Back To Home Screen    device_list=device_1,device_2,device_3

TC14 : Verify Incoming Call info in the Recent tab of Shared line and Calls app when another Delegate recieves a also ring call set by the boss.
    [Tags]    sh-5
    [Setup]    Testcase Setup    count=4
    Add New Delegates With Both Permission And Validate    from_device=device_3    to_device=device_1
    Add New Delegates With Both Permission And Validate    from_device=device_3    to_device=device_2
    Enable Also Ring Delegates    device=device_3
    Make Outgoing Call Using Display Name    from_device=device_4    to_device=device_3
    Verify Incoming Call    device=device_1,device_2,device_3    status=Appear
    Pick Incoming Call    device=device_1
    Verify Call State    device_list=device_1,device_4    state=Connected
    Verify Incoming Call    device=device_2,device_3    status=Disappear
    Disconnect Call    device=device_1
    Verify Call State    device_list=device_1,device_4    state=Disconnected
    Navigate To Calls Tab    device=device_2
    Verify Forwarded Call In Recent Tab    device=device_2    forwarded_device=device_3    answered_by_delegate=device_1
    Navigate Back Once    device=device_2
    Tap And Verify Shared Line Ui From People You Support In Call Favorites Tab    from_device=device_2    to_device=device_3
    Verify Users List In Recent Tab From Shared Line Option    from_device=device_2    to_device=device_3    users_in_call=device_4
    Verify More Info Of Contact In Shared Line Recent Tab    from_device=device_2    to_device=device_1    dialed_by=non delegate user    dialed_user=device_4
    Navigate Back Once    device=device_2
    Return To Home Screen    device=device_2
    Verify Users List In Recent Tab From Shared Line Option    from_device=device_2    to_device=device_3    users_in_call=device_4
    Verify More Info Of Contact In Shared Line Recent Tab    from_device=device_2    to_device=device_1    dialed_by=non delegate user    dialed_user=device_4
    Verify Incoming Call In Recent Tab    device=device_3    caller_device=device_4    answered_by_delegate=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND    Disable Also Ring    device=device_3    AND    Delete Delegate From Manage Delegate    from_device=device_3    to_device=device_1    AND    Delete Delegate From Manage Delegate    from_device=device_3    to_device=device_2    AND    Come Back To Home Screen    device_list=device_1,device_2,device_3,device_4

TC15 : Verify Incoming Call info in the Recent tab of shared line app and Calls app of a delegate when Delegate receives a forwarded call from the TDC user
    [Tags]    sh-9
    [Setup]    Testcase Setup    count=3
    Add New Delegates With Both Permission And Validate    from_device=device_2    to_device=device_1
    Enable Call Forwarding To Delegates    from_device=device_2    contact_device=device_1
    Make Outgoing Call Using Display Name    from_device=device_3    to_device=device_2
    Pick Incoming Call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect Call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Disconnected
    Navigate To Calls Tab    device=device_1
    Verify Forwarded Call In Recent Tab    device=device_1    forwarded_device=device_2
    Navigate Back Once    device=device_1
    Tap And Verify Shared Line Ui From People You Support In Call Favorites Tab    from_device=device_1    to_device=device_2
    Verify Users List In Recent Tab From Shared Line Option    from_device=device_1    to_device=device_2    users_in_call=device_3
    Verify More Info Of Contact In Shared Line Recent Tab    from_device=device_1    to_device=device_2    call_status=forwarded
    Navigate Back Once    device=device_1
    Return To Home Screen    device_list=device_1
    Verify Users List In Recent Tab From Shared Line Option    from_device=device_1    to_device=device_2    users_in_call=device_3
    Verify More Info Of Contact In Shared Line Recent Tab    from_device=device_1    to_device=device_2    call_status=forwarded
    Verify Forwarded Call In Recent Tab    device=device_2    forwarded_device=device_2    answered_by_delegate=device_1
    Navigate Back Once    device=device_2
    [Teardown]    Run Keywords    Capture On Failure    AND    Verify And Disable Call Forwarding    device=device_2    AND    Delete Delegate From Manage Delegate    from_device=device_2    to_device=device_1    AND    Come Back To Home Screen    device_list=device_1,device_2,device_3

TC16 : Verify Incoming Call info in the Recent tab of Shared line,Calls app when another Delegate in the Same delegation receives a forwarded call from the TDC user
    [Tags]    sh-10
    [Setup]    Testcase Setup    count=4
    Add New Delegates With Both Permission And Validate    from_device=device_2    to_device=device_1
    Add New Delegates With Both Permission And Validate    from_device=device_2    to_device=device_4
    Enable Call Forwarding To Delegates    from_device=device_2    contact_device=device_1
    Make Outgoing Call Using Display Name    from_device=device_3    to_device=device_2
    Verify Incoming Call    device=device_1,device_4    status=Appear
    Pick Incoming Call    device=device_4
    Verify Call State    device_list=device_4,device_3    state=Connected
    Disconnect Call    device=device_4
    Verify Call State    device_list=device_4,device_3    state=Disconnected
    Navigate To Calls Tab    device=device_1
    Verify Forwarded Call In Recent Tab    device=device_1    forwarded_device=device_2    answered_by_delegate=device_4
    Navigate Back Once    device=device_1
    Tap And Verify Shared Line Ui From People You Support In Call Favorites Tab    from_device=device_1    to_device=device_2
    Verify Users List In Recent Tab From Shared Line Option    from_device=device_1    to_device=device_2    users_in_call=device_3
    Verify More Info Of Contact In Shared Line Recent Tab    from_device=device_1    to_device=device_2    call_status=forwarded
    Navigate Back Once    device=device_1
    Return To Home Screen    device_list=device_1
    Verify Users List In Recent Tab From Shared Line Option    from_device=device_1    to_device=device_2    users_in_call=device_3
    Verify More Info Of Contact In Shared Line Recent Tab    from_device=device_1    to_device=device_2    call_status=forwarded
    Verify Forwarded Call In Recent Tab    device=device_2    forwarded_device=device_2    answered_by_delegate=device_4
    Navigate Back Once    device=device_2
    [Teardown]    Run Keywords    Capture On Failure    AND    Verify And Disable Call Forwarding    device=device_2    AND    Delete Delegate From Manage Delegate    from_device=device_2    to_device=device_1    AND    Delete Delegate From Manage Delegate    from_device=device_2    to_device=device_4    AND    Come Back To Home Screen    device_list=device_1,device_2,device_3,device_4

TC17 : Verify Incoming Call info in the Recent tab of Calls,Shared line app when delegate is not recieved forwarded call from the TDC user
    [Tags]    sh-11
    [Setup]    Testcase Setup    count=3
    Add New Delegates With Both Permission And Validate    from_device=device_2    to_device=device_1
    Enable Call Forwarding To Delegates    from_device=device_2    contact_device=device_1
    Make Outgoing Call Using Display Name    from_device=device_3    to_device=device_2
    Verify Incoming Call    device=device_1    status=Appear
    Wait For Some Time    time=45s
    Disconnect Call    device=device_3
    Verify Call State    device_list=device_3    state=Disconnected
    Navigate To Calls Tab    device=device_1
    Verify Missed Forward Call In Recent Tab    device=device_1    forwarded_device=device_2
    Navigate Back Once    device=device_1
    Tap And Verify Shared Line Ui From People You Support In Call Favorites Tab    from_device=device_1    to_device=device_2
    Verify Users List In Recent Tab From Shared Line Option    from_device=device_1    to_device=device_2    users_in_call=device_3
    Verify More Info Of Contact In Shared Line Recent Tab    from_device=device_1    to_device=device_2    call_status=missed forward
    Navigate Back Once    device=device_1
    Return To Home Screen    device_list=device_1
    Verify Users List In Recent Tab From Shared Line Option    from_device=device_1    to_device=device_2    users_in_call=device_3
    Verify More Info Of Contact In Shared Line Recent Tab    from_device=device_1    to_device=device_2    call_status=missed forward
    Verify Forwarded Call In Recent Tab    device=device_2    forward_to_voicemail=yes
    [Teardown]    Run Keywords    Capture On Failure    AND    Verify And Disable Call Forwarding    device=device_2    AND    Delete Delegate From Manage Delegate    from_device=device_2    to_device=device_1    AND    Come Back To Home Screen    device_list=device_1,device_2,device_3

TC18 : Verify Incoming Call info in the Recent tab of Calls app,Shared line app when Caller ended the call before Delegate receives Forwarded call set by the boss.
    [Tags]    sh-13
    [Setup]    Testcase Setup    count=3
    Add New Delegates With Both Permission And Validate    from_device=device_2    to_device=device_1
    Enable Call Forwarding To Delegates    from_device=device_2    contact_device=device_1
    Make Outgoing Call Using Display Name    from_device=device_3    to_device=device_2
    Verify Incoming Call    device=device_1    status=Appear
    Disconnect Call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Disconnected
    Navigate To Calls Tab    device=device_1
    Verify Missed Forward Call In Recent Tab    device=device_1    forwarded_device=device_2
    Navigate Back Once    device=device_1
    Tap And Verify Shared Line Ui From People You Support In Call Favorites Tab    from_device=device_1    to_device=device_2
    Verify Users List In Recent Tab From Shared Line Option    from_device=device_1    to_device=device_2    users_in_call=device_3
    Verify More Info Of Contact In Shared Line Recent Tab    from_device=device_1    to_device=device_2    call_status=missed forward
    Navigate Back Once    device=device_1
    Return To Home Screen    device_list=device_1
    Verify Users List In Recent Tab From Shared Line Option    from_device=device_1    to_device=device_2    users_in_call=device_3
    Verify More Info Of Contact In Shared Line Recent Tab    from_device=device_1    to_device=device_2    call_status=missed forward
    Verify Forwarded Call In Recent Tab    device=device_2    forwarded_device=device_2
    [Teardown]    Run Keywords    Capture On Failure    AND    Verify And Disable Call Forwarding    device=device_2    AND    Delete Delegate From Manage Delegate    from_device=device_2    to_device=device_1    AND    Come Back To Home Screen    device_list=device_1,device_2,device_3

TC19 : Verify the Outgoing Call info in the Shared line Recent tab When Delegate make call to other user on behalf of boss
    [Tags]    sh-14
    [Setup]    Testcase Setup    count=3
    Add New Delegates With Both Permission And Validate    from_device=device_1    to_device=device_2
    Click On Calls Tab    device=device_2
    Initiate OBO Call Using Display Name    from_device=device_2    to_device=device_3    obo_option=device_1
    Pick Incoming Call    device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect Call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Disconnected
    Verify Outgoing Call In Recent Tab    device=device_2    call_received_device=device_3
    Tap And Verify Shared Line Ui From People You Support In Call Favorites Tab    from_device=device_2    to_device=device_1
    Verify Users List In Recent Tab From Shared Line Option    from_device=device_2    to_device=device_1    users_in_call=device_3
    Verify More Info Of Contact In Shared Line Recent Tab    from_device=device_2    to_device=device_3
    Verify Outgoing Call In Recent Tab    device=device_1    call_received_device=device_3    called_by_delegate=device_2
    Navigate Back Once    device=device_2
    Return To Home Screen    device_list=device_2
    Verify Users List In Recent Tab From Shared Line Option    from_device=device_2    to_device=device_1    users_in_call=device_3
    Verify More Info Of Contact In Shared Line Recent Tab    from_device=device_2    to_device=device_3
    [Teardown]    Run Keywords    Capture On Failure    AND    Delete Delegate From Manage Delegate    from_device=device_1    to_device=device_2    AND    Come Back To Home Screen    device_list=device_1,device_2,device_3

TC20 : Verify the Outgoing Call info in the Shared line Recent tab When another Delegate make call to other user on behalf of boss
    [Tags]    sh-15
    [Setup]    Testcase Setup    count=4
    Add New Delegates With Both Permission And Validate    from_device=device_1    to_device=device_2
    Add New Delegates With Both Permission And Validate    from_device=device_1    to_device=device_4
    Click On Calls Tab    device=device_4
    Initiate OBO Call Using Display Name    from_device=device_4    to_device=device_3    obo_option=device_1
    Pick Incoming Call    device=device_3
    Verify Call State    device_list=device_3,device_4    state=Connected
    Disconnect Call    device=device_4
    Verify Call State    device_list=device_3,device_4    state=Disconnected
    Tap And Verify Shared Line Ui From People You Support In Call Favorites Tab    from_device=device_2    to_device=device_1
    Verify Users List In Recent Tab From Shared Line Option    from_device=device_2    to_device=device_1    users_in_call=device_3
    Verify More Info Of Contact In Shared Line Recent Tab    from_device=device_2    to_device=device_3    dialed_by=delegate user    dialed_user=device_4
    Verify Outgoing Call In Recent Tab    device=device_1    call_received_device=device_3    called_by_delegate=device_4
    Navigate Back Once    device=device_2
    Return To Home Screen    device_list=device_2
    Verify Users List In Recent Tab From Shared Line Option    from_device=device_2    to_device=device_1    users_in_call=device_3
    Verify More Info Of Contact In Shared Line Recent Tab    from_device=device_2    to_device=device_3    dialed_by=delegate user    dialed_user=device_4
    [Teardown]    Run Keywords    Capture On Failure    AND    Delete Delegate From Manage Delegate    from_device=device_1    to_device=device_2    AND    Delete Delegate From Manage Delegate    from_device=device_1    to_device=device_4    AND    Come Back To Home Screen    device_list=device_1,device_2,device_3

*** Keywords ***




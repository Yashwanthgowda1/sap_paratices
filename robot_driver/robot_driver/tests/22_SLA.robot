*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation      Suite Setup Requirements : This suite requires minimum of 3 devices in config
...                Purpose: Verify 'People You Support' Tab in  Device_2


Suite Setup      OBO Setup
Suite Teardown      Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [SLA]Verify that join call option should not present inside the more info icon beside the username of boss under People you support if join active call option is disabled for Delegates.
    [Tags]      416875     P0   bvt_tp   sanity_tp
    [Setup]  Testcase Setup for Delegate User  count=3
    navigate to manage delegate page    device=device_1
    disable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls
    go back to previous page     device=device_1
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    navigate to calls favorites page   device=device_2
    Verify join call option should not present inside the more icon of boss     from_device=device_2      to_device=device_1
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls      AND      Come back to home screen    device_list=device_1,device_2,device_3

TC2 : [SLA]Verify that DUT user able to join the call when DUT user tap on Join button Present beside the username of the boss under the People you support when Boss is in call with other user
    [Tags]      416928     P0   bvt_tp   sanity_tp      bvt_pr
    [Setup]  Testcase Setup for Delegate User  count=3
    enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls
    go back to previous page     device=device_1
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    navigate to calls favorites page   device=device_2
    verify and join call using join button with boss   from_device=device_2      to_device=device_1
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call    device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure     AND      Come back to home screen    device_list=device_1,device_2,device_3

TC3 : Verify the Delegate user able to Resume the call from the Resume call option present inside the more info icon beside the username of the boss under the People you support ,when Boss put the call on hold.
    [Tags]      417058     P0   bvt_tp   sanity_tp      bvt_pr
    [Setup]  Testcase Setup for Delegate User  count=3
    enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Pick_up_held_calls
    go back to previous page     device=device_1
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1     state=Hold
    navigate to calls favorites page   device=device_2
    verify and resume call using resume call in more option with boss or delegate  from_device=device_2      to_device=device_1
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify Call State    device_list=device_1   state=Disconnected
    Disconnect call    device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure      AND      Come back to home screen    device_list=device_1,device_2,device_3

TC4 : Verify that DUT is displaying Resume call option is present inside the more info icon beside the delegates under your delegates, when the delegate user is in call with other user on behalf of boss.
    [Tags]      417061     P0   bvt_tp   sanity_tp
    [Setup]  Testcase Setup for Delegate User  count=3
    enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Pick_up_held_calls
    go back to previous page     device=device_1
    click on calls tab   device=device_2
    Initiate OBO call using display name    from_device=device_2      to_device=device_3    obo_option=device_1
    Verify Incoming call    device=device_3    status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    Hold the call   device=device_3
    Verify Call State    device_list=device_2     state=Hold
    navigate to calls favorites page   device=device_1
    verify and resume call using resume call in more option with boss or delegate  from_device=device_1      to_device=device_2:delegate_user     option=verify     role=delegate
    Disconnect call    device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure      AND      Come back to home screen    device_list=device_1,device_2,device_3

TC5 : Verify that DUT is not displaying Resume call option beside the username of boss under People you support, and inside more info when Pickup held calls option is disabled for Delegates.
    [Tags]      417062     P0   bvt_tp   sanity_tp
    [Setup]  Testcase Setup for Delegate User  count=3
    navigate to manage delegate page    device=device_1
    disable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Pick_up_held_calls
    go back to previous page     device=device_1
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3    status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_3     state=Hold
    navigate to calls favorites page   device=device_2
    verify resume call option should not present inside the more icon of boss     from_device=device_2      to_device=device_1
    Disconnect call    device=device_1
    verify call state and disconnect       device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Pick_up_held_calls      AND      Come back to home screen    device_list=device_1,device_2,device_3

TC6 : Verify that Resume call option should not present inside the more info icon beside the username of Delegates under Your Delegates, if Pick up held calls option is disabled for Delegates.
    [Tags]      417063     P1
    [Setup]  Testcase Setup for Delegate User  count=3
    navigate to manage delegate page    device=device_1
    disable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Pick_up_held_calls
    return to home screen     device_list=device_1
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3    status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_3     state=Hold
    navigate to calls favorites page   device=device_2
    verify resume call option should not present inside the more icon of boss     from_device=device_2      to_device=device_1
    Resume the call     device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Pick_up_held_calls      AND      Come back to home screen    device_list=device_1,device_2,device_3

TC7 : [SLA]Verify DUT user is able to enable "join active calls" toggle under delegation Setting page.
    [Tags]      416710     P2
    [Setup]  Testcase Setup for Delegate User  count=2
    enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls
    [Teardown]   Run Keywords    Capture on Failure      AND      Come back to home screen    device_list=device_1,device_2

TC8 : [SLA] Verify DUT user is able to enable "pick up held calls" toggle under delegation Setting page
    [Tags]      416715     P2
    [Setup]  Testcase Setup for Delegate User  count=2
    enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Pick_up_held_calls
    [Teardown]   Run Keywords    Capture on Failure      AND      Come back to home screen    device_list=device_1,device_2

TC9 : [SLA]Verify that DUT is displaying join button with more info icon beside the username of the delegates under your delegates section ,when the delegate user is in call with other user
    [Tags]      416768    P2
    [Setup]  Testcase Setup for Delegate User  count=3
    enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls
    go back to previous page     device=device_1
    click on calls tab   device=device_2
    Initiate OBO call using display name    from_device=device_2      to_device=device_3    obo_option=device_1
    Verify Incoming call    device=device_3    status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    navigate to calls favorites page   device=device_1
    verify and join call using join call in more option with boss and delegate   from_device=device_1      to_device=device_2:delegate_user        option=verify
    wait for some time      time=${wait_time}
    Disconnect call    device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure     AND      Come back to home screen    device_list=device_1,device_2,device_3

TC10 :[SLA]Verify that DUT should display join button with more info icon beside user name of boss under People you support ,when Boss is in call with other user
    [Tags]      416775    P2
    [Setup]  Testcase Setup for Delegate User  count=3
    enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls
    go back to previous page     device=device_1
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3    status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    navigate to calls favorites page   device=device_2
    verify and join call using join call in more option with boss and delegate   from_device=device_2      to_device=device_1        option=verify
    wait for some time      time=${wait_time}
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure     AND      Come back to home screen    device_list=device_1,device_2,device_3

TC11 :[SLA]Verify that options present inside the more info icon beside the username of boss under People you support ,when Boss is in call with other user
    [Tags]      416776    P2
    [Setup]  Testcase Setup for Delegate User  count=3
    enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls
    go back to previous page     device=device_1
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3    status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    navigate to calls favorites page   device=device_2
    verify and join call using join call in more option with boss and delegate   from_device=device_2      to_device=device_1        option=verify
    wait for some time      time=${wait_time}
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure     AND      Come back to home screen    device_list=device_1,device_2,device_3

TC12 : [SLA]Verify that DUT shouldn't display join button beside the username of boss under People you support ,when Join active call option is disabled for Delegates.
    [Tags]      416826    P2
    [Setup]  Testcase Setup for Delegate User  count=3
    navigate to manage delegate page    device=device_1
    disable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls
    go back to previous page     device=device_1
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    navigate to calls favorites page   device=device_2
    Verify join call option should not present inside the more icon of boss     from_device=device_2      to_device=device_1
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls      AND      Come back to home screen    device_list=device_1,device_2,device_3

TC13 : [SLA]Verify DUT2 should display “Active call” and timer for active SLA call with more info icon. Also Verify Join button shouldn't display on beside username of DUT1
    [Tags]      416828     P2
    [Setup]  Testcase Setup for Delegate User  count=3
    navigate to manage delegate page    device=device_1
    disable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls
    go back to previous page     device=device_1
    click on calls tab   device=device_2
    Initiate OBO call using display name    from_device=device_2      to_device=device_3    obo_option=device_1
    Verify Incoming call    device=device_3    status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_3,device_3    state=Connected
    navigate to calls favorites page   device=device_1
    Verify join call option should not present inside the more icon of boss     from_device=device_1      to_device=device_2:delegate_user
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls      AND      Come back to home screen    device_list=device_1,device_2,device_3

TC14 : [SLA]Verify that join call option should not present inside the more info icon beside the username of Delegates under Your Delegates ,if join active call option is disabled for Delegates.
    [Tags]      416889     P2
    [Setup]  Testcase Setup for Delegate User  count=3
    navigate to manage delegate page    device=device_1
    disable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls
    go back to previous page     device=device_1
    click on calls tab   device=device_2
    Initiate OBO call using display name    from_device=device_2      to_device=device_3    obo_option=device_1
    Verify Incoming call    device=device_3    status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    navigate to calls favorites page   device=device_1
    Verify join call option should not present inside the more icon of boss     from_device=device_1      to_device=device_2:delegate_user
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls      AND      Come back to home screen    device_list=device_1,device_2,device_3

TC15 : [SLA]Verify that DUT user able to join the call when DUT user tap on Join call option Present inside the more info icon beside the username of the Delegates under the Your delegates when Delegate user is in call on behalf of boss with other user
    [Tags]      416935     P0   bvt_tp   sanity_tp
    [Setup]  Testcase Setup for Delegate User  count=3
    enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls
    go back to previous page     device=device_1
    click on calls tab   device=device_2
    Initiate OBO call using display name    from_device=device_2      to_device=device_3    obo_option=device_1
    Verify Incoming call    device=device_3    status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    navigate to calls favorites page   device=device_1
    verify and join call using join call in more option with boss and delegate   from_device=device_1      to_device=device_2:delegate_user        option=join_call
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call    device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure     AND      Come back to home screen    device_list=device_1,device_2,device_3

TC16 : Verify that DUT user able to join the call when DUT user tap on Resume call option Present inside the more info icon beside the username of Delegates under Your delegates,when Delegate user is in call with other useron behalf of boss
    [Tags]      417113     P0   bvt_tp   sanity_tp
    [Setup]  Testcase Setup for Delegate User  count=3
    enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls
    go back to previous page     device=device_1
    click on calls tab   device=device_2
    Initiate OBO call using display name    from_device=device_2      to_device=device_3    obo_option=device_1
    Verify Incoming call    device=device_3    status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    Hold the call   device=device_2
    Verify Call State    device_list=device_2     state=Hold
    navigate to calls favorites page   device=device_1
    verify and resume call using resume call in more option with boss or delegate  from_device=device_1      to_device=device_2:delegate_user     role=delegate
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2   state=Disconnected
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure     AND      Come back to home screen    device_list=device_1,device_2,device_3

TC17 : Verify that DUT user able to join the call by using Resume button Present inside the more info icon beside the username of Delegates under You delegates section,when Delegate user is in call on behalf of boss with other user.
    [Tags]      417114     P0   bvt_tp   sanity_tp
    [Setup]  Testcase Setup for Delegate User  count=3
    enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls
    go back to previous page     device=device_1
    click on calls tab   device=device_2
    Initiate OBO call using display name    from_device=device_2      to_device=device_3    obo_option=device_1
    Verify Incoming call    device=device_3    status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    navigate to calls favorites page   device=device_1
    Hold the call   device=device_2
    Verify Call State    device_list=device_2     state=Hold
    navigate to calls favorites page   device=device_1
    verify and resume call using resume call in more option with boss or delegate  from_device=device_1      to_device=device_2:delegate_user     role=delegate
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2   state=Disconnected
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure     AND      Come back to home screen    device_list=device_1,device_2,device_3

TC18 : [SLA]Verify that DUT is displaying Resume button with more info icon beside the username of the boss under the People you support when the Boss put the call on hold
    [Tags]      416896     P2
    [Setup]  Testcase Setup for Delegate User  count=3
    enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Pick_up_held_calls
    go back to previous page     device=device_1
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3    status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1     state=Hold
    navigate to calls favorites page   device=device_2
    verify and resume call using resume call in more option with boss or delegate  from_device=device_2      to_device=device_1     option=verify
    Disconnect call    device=device_1
    verify call state and disconnect       device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure      AND      Come back to home screen    device_list=device_1,device_2,device_3

TC19 : Verify that DUT (Delegate) should display join and resume button, When Boss enabled "Join active call" and "Pick up held calls" option.
    [Tags]      417115     P0       bvt_tp   sanity_tp
    [Setup]  Testcase Setup for Delegate User  count=3
    enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Pick_up_held_calls
    enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls
    go back to previous page     device=device_1
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    navigate to calls favorites page   device=device_2
    verify and join call using join button with boss   from_device=device_2      to_device=device_1
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call    device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1     state=Hold
    verify and resume call using resume button with boss  from_device=device_2      to_device=device_1
    Verify Call State    device_list=device_1    state=Disconnected
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call    device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure      AND      Come back to home screen    device_list=device_1,device_2,device_3

TC20 : [Advance Calling]The empty voicemail screen should now be shown with simple message “No voicemails yet.”
    [Tags]      420662   P2
    [Setup]  Testcase Setup for Delegate User  count=1
    navigate to voicemail tab   device=device_1
    delete all voicemails    device=device_1
    verify voicemail tab empty      device=device_1
    [Teardown]  run keywords  Capture on Failure      AND    Come back to home screen   device_list=device_1

TC21 : [SLA]Verify that "Active call with timer" icon is displayed under “your delegates”, when the delegates is in call with another user.
    [Tags]      345639     P2
    [Setup]  Testcase Setup for Delegate User  count=3
    Initiate OBO call using display name    from_device=device_2      to_device=device_3    obo_option=device_1
    Verify Incoming call    device=device_3    status=appear
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Navigate to Calls Favorites page    device=device_1
    refresh calls main tab  device=device_1
    Verify delegates in favorites page     device=device_1
    verify added delegate user with presence in favorites page      from_device=device_1    to_device=device_2:delegate_user
    verify and join call using join call in more option with boss and delegate   from_device=device_1      to_device=device_2:delegate_user        option=verify
    Disconnect call    device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC22 : [SLA]Verify that "Active call with timer" should be display under “people you support”, when the Boss is in call with another Boss.
    [Tags]      345636     P2
    [Setup]  Testcase Setup for Delegate User  count=3
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Navigate to Calls Favorites page    device=device_2:delegate_user
    refresh calls main tab  device=device_2
    favorites_module_sanity     device_list=device_2
    verify and join call using join call in more option with boss and delegate   from_device=device_2      to_device=device_1        option=verify
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC23 : [SLA]Verify that "Resume banner" and resume button should display on Delegates user, when Boss is on hold.
    [Tags]      345656     P0   sanity_tp
    [Setup]  Testcase Setup for Delegate User  count=4
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_4
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1     state=Hold
    navigate to calls favorites page   device=device_2
    verify and resume call using resume call in more option with boss or delegate  from_device=device_2      to_device=device_1
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify Call State    device_list=device_1     state=Disconnected
    verify resume banner  device_list=device_2,device_4     state=disappear
    Disconnect call    device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure     AND    come back home screen for user   count=4

TC24 : [SLA]Verify that Boss should be kicked out when the Delegate resume the call from resume banner.
    [Tags]      345653     P1   sanity_tp
    [Setup]  Testcase Setup for Delegate User  count=4
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1     state=Hold
    navigate to calls favorites page   device=device_2
    favorites_module_sanity     device_list=device_2
    verify user in people you support with presence in favorites_page       from_device=device_2    to_device=device_1
    verify and resume call using resume call in more option with boss or delegate  from_device=device_2      to_device=device_1
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify Call State    device_list=device_1     state=Disconnected
    verify resume banner  device_list=device_2,device_4     state=disappear
    Disconnect call    device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    come back home screen for user   count=4

TC25 : [SLA]Verify that Resume banner and resume button should be disappear from other delegates when one of the delegate "Resumes" the call.
    [Tags]      345651     P2
    [Setup]  Testcase Setup for Delegate User  count=4
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1     state=Hold
    verify resume banner  device_list=device_2,device_4
    navigate to calls favorites page   device=device_2
    favorites_module_sanity     device_list=device_2
    verify user in people you support with presence in favorites_page       from_device=device_2    to_device=device_1
    verify and resume call using resume call in more option with boss or delegate  from_device=device_2      to_device=device_1
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify Call State    device_list=device_1     state=Disconnected
    verify resume banner  device_list=device_2,device_4     state=disappear
    Disconnect call    device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure     AND     Delete delegate from manage delegate   from_device=device_1    to_device=device_4     AND    come back home screen for user   count=4

TC26 : Verify the Delegate user able to Resume the call from the Resume button present beside the username of boss under People you support, when Boss put the call on hold.
    [Tags]      417067     P2
    [Setup]  Testcase Setup for Delegate User  count=3
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1     state=Hold
    navigate to calls favorites page   device=device_2
    verify resume banner  device_list=device_2
    favorites_module_sanity     device_list=device_2
    verify user in people you support with presence in favorites_page       from_device=device_2    to_device=device_1
    verify and resume call using resume call in more option with boss or delegate  from_device=device_2      to_device=device_1
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify Call State    device_list=device_1     state=Disconnected
    Disconnect call    device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND    come back home screen for user   count=3

TC27 : [SLA]Verify that DUT[Delegates] user is able to join the call when DUT user tap on Join call option Present inside the more info icon beside the username of the boss under the People you support when Boss is in call with other user
    [Tags]      416931    P2
    [Setup]  Testcase Setup for Delegate User  count=3
    enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls
    go back to previous page     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    navigate to calls favorites page   device=device_2
    favorites_module_sanity     device_list=device_2
    verify user in people you support with presence in favorites_page       from_device=device_2    to_device=device_1
    verify and join call using join call in more option with boss and delegate   from_device=device_2      to_device=device_1
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call    device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure     AND      come back home screen for user   count=3

TC28 : Verify that Resume button should not present beside the username of Delegates under Your Delegates, if Pick up held calls option is disabled for Delegates.
    [Tags]      417065     P2
    [Setup]  Testcase Setup for Delegate User  count=3
    navigate to manage delegate page    device=device_1
    disable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Pick_up_held_calls
    go back to previous page     device=device_1
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3    status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_3     state=Hold
    verify resume call option should not present in call favorites page    from_device=device_2     to_device=device_1
    Disconnect call    device=device_1
    verify call state and disconnect       device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Pick_up_held_calls      AND      Come back to home screen    device_list=device_1,device_2,device_3

TC29 : [Advanced Calling] DUT user taps on More info icon on delegate.
    [Tags]      420606     P2
    [Setup]  Testcase Setup for Delegate User  count=3
    Make outgoing call using display name       from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    Navigate to Calls Favorites page    device=device_1
    refresh calls main tab  device=device_1
    verify added delegate user with presence in favorites page      from_device=device_1    to_device=device_2:delegate_user
    verify and join call using join button with boss   from_device=device_1      to_device=device_2:delegate_user     option=verify
    verify and join call using join call in more option with boss and delegate   from_device=device_1      to_device=device_2:delegate_user     option=verify
    Disconnect call    device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC30 : [Advanced Calling] DUT user taps on the dropdown More info icon on Boss.
    [Tags]      420607     P1
    [Setup]  Testcase Setup for Delegate User  count=3
    Make outgoing call using display name       from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Navigate to Calls Favorites page    device=device_2
    refresh calls main tab  device=device_2
    favorites_module_sanity     device_list=device_2
    verify user in people you support with presence in favorites_page       from_device=device_2    to_device=device_1
    verify and join call using join call in more option with boss and delegate   from_device=device_2      to_device=device_1       option=verify
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC31 : [SLA] Verify that Active Call with a timer should display when delegate is in call with other user on behalf of boss.
    [Tags]      345643     P2
    [Setup]  Testcase Setup for Delegate User  count=3
    Initiate OBO call using display name    from_device=device_2      to_device=device_3     obo_option=device_1
    Verify calling behalf of device text    device=device_2  to_device=device_3     from_device=device_1
    Verify Incoming call    device=device_3     status=appear
    Verify on behalf of call text   device=device_3   from_device=device_2:delegate_user    obo_user=device_1
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    navigate to calls favorites page   device=device_1
    Verify delegates in favorites page     device=device_1
    verify and join call using join call in more option with boss and delegate   from_device=device_1      to_device=device_2:delegate_user       option=verify
    Disconnect call    device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure     AND      Come back to home screen    device_list=device_1,device_2,device_3

TC32 : [Advance Calling] Boss should be able to get SLA pop up when delegates put their call on hold.
    [Tags]      420663     P2
    [Setup]  Testcase Setup for Delegate User  count=3
    Initiate OBO call using display name    from_device=device_2      to_device=device_3     obo_option=device_1
    Verify calling behalf of device text    device=device_2  to_device=device_3    from_device=device_1
    Verify Incoming call    device=device_3     status=appear
    Verify on behalf of call text   device=device_3   from_device=device_2:delegate_user    obo_user=device_1
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    Hold the call   device=device_2
    Verify Call State    device_list=device_2     state=Hold
    verify resume banner  device_list=device_2
    verify resume banner  device_list=device_1
    Disconnect call    device=device_2
    verify call state and disconnect        device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND    come back home screen for user   count=3

TC33 : Verify that Resume button should not present beside the username of boss under People you support, if Pickup held calls option is disabled for Delegates.
    [Tags]      417064     P2
    [Setup]  Testcase Setup for Delegate User  count=3
    navigate to manage delegate page    device=device_1
    disable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Pick_up_held_calls
    go back to previous page     device=device_1
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1     state=Hold
    verify resume call option should not present in call favorites page    from_device=device_2     to_device=device_1
    Disconnect call    device=device_1
    verify call state and disconnect        device=device_3
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls      AND      Come back to home screen    device_list=device_1,device_2,device_3

TC34 : [SLA]Verify the Resume call option is present inside the more info icon beside the username of the boss under the People you support when Boss put the call on hold
    [Tags]      416908     P2
    [Setup]  Testcase Setup for Delegate User  count=3
    Make outgoing call using display name       from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1     state=Hold
    Navigate to Calls Favorites page    device=device_2
    refresh calls main tab  device=device_2
    favorites_module_sanity     device_list=device_2
    verify user in people you support with presence in favorites_page       from_device=device_2    to_device=device_1
    verify and resume call using resume call in more option with boss or delegate   from_device=device_2      to_device=device_1       option=verify
    Disconnect call    device=device_1
    verify call state and disconnect        device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC35 : Verify that DUT is displaying resume button with more info icon beside the username of delegates under your delegates, when the delegate user is in call with other user on behalf of boss.
    [Tags]      417059   P2
    [Setup]  Testcase Setup for Delegate User  count=3
    Initiate OBO call using display name    from_device=device_2      to_device=device_3     obo_option=device_1
    Verify calling behalf of device text    device=device_2  to_device=device_3    from_device=device_1
    Verify Incoming call    device=device_3     status=appear
    Verify on behalf of call text   device=device_3   from_device=device_2:delegate_user    obo_user=device_1
    Pick incoming call    device=device_3
    wait for some time      time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    Hold the call   device=device_2
    Verify Call State    device_list=device_2     state=Hold
    verify resume banner  device_list=device_1
    navigate to calls favorites page   device=device_1
    Verify delegates in favorites page     device=device_1
    verify added delegate user with presence in favorites page      from_device=device_1    to_device=device_2:delegate_user
    verify boss options inside call info with delegate when delegate is in call with other user   from_device=device_1      delegate=device_2:delegate_user
    Disconnect call    device=device_2
    verify call state and disconnect        device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND    come back home screen for user   count=3

TC36 : [SLA] Verify that options present inside the triple dot(...) option beside each People you support contacts.
    [Tags]  416824   P1     sanity_tp
    [Setup]    Testcase Setup for Delegate User  count=3
    navigate to calls favorites page   device=device_2
    favorites_module_sanity     device_list=device_2
    verify user in people you support with presence in favorites_page       from_device=device_2    to_device=device_1
    verify people you support more option at favorites page     from_device=device_2    to_device=device_1
    Change delegates for boss and verify    device=device_2   boss=device_1   delegate=device_3
    navigate to calls favorites page   device=device_2
    favorites_module_sanity     device_list=device_2
    Change call settings for boss and verify    device=device_2:delegate_user     boss=device_1    call_setting=call_forward      contact_point=voicemail
    navigate to calls favorites page   device=device_2
    favorites_module_sanity     device_list=device_2
    Change call settings for boss and verify    device=device_2:delegate_user     boss=device_1    call_setting=call_forward      contact_point=my_delegates
    navigate to calls favorites page   device=device_2
    favorites_module_sanity     device_list=device_2
    Change call settings for boss and verify    device=device_2:delegate_user     boss=device_1    call_setting=call_forward      contact_point=device_3
    navigate to calls favorites page   device=device_2
    favorites_module_sanity     device_list=device_2
    Change call settings for boss and verify    device=device_2:delegate_user     boss=device_1    call_setting=call_forward      contact_point=off
    [Teardown]  run keywords  Capture on Failure    AND   Delete delegate from manage delegate   from_device=device_1    to_device=device_3   AND   verify and disable call forwarding    device=device_1    AND    Come back to home screen   device_list=device_1,device_2,device_3

TC37 : Verify Blue background should disappear, and time should stop, When SLA call end.
    [Tags]    417116    tp_audio
    [Setup]    Testcase Setup for Delegate User  count=3
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    navigate to calls favorites page   device=device_2
    verify user in people you support page     from_device=device_2    to_device=device_1  join_option=verify
    Disconnect Call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=disconnected
    verify user in people you support page     from_device=device_2    to_device=device_1   join_option=absent
    [Teardown]  run keywords  Capture on Failure    AND  come back home screen for user   count=3

*** Keywords ***
OBO Setup
    verify device users    user_list=user,delegate_user,user
    Navigate to Calls Favorites page    device=device_2
    refresh calls main tab  device=device_2
    favorites_module_sanity     device_list=device_2


Favorite user setup
    [Arguments]     ${from_device}   ${to_device}
    make outgoing call for call log     from_device=${from_device}      to_device=${to_device}
    Select call list item   device=${from_device}     item=favorite
    Verify added favorite user in favorites page    from_device=${from_device}     to_device=${to_device}



Make outgoing call for call log
    [Arguments]     ${from_device}   ${to_device}
    Make outgoing call using display name    from_device=${from_device}      to_device=${to_device}
    Verify Incoming call    device=${to_device}     status=appear
    Disconnect call     device=${from_device}
    Verify Incoming call    device=${to_device}     status=disappear
    Verify Call State    device_list=${from_device}     state=Disconnected
    Come back to home screen    device_list=${from_device}
    Navigate to calls tab   device=${from_device}
    Refresh calls main tab    device=${from_device}



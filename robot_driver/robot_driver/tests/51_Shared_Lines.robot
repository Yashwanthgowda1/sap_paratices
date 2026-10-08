*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation      Suite Setup Requirements : This suite requires minimum of 3 devices in config
...                Purpose: Device_1 should be added as a Delegate from Device_3


Suite Setup    Shared Line suite Setup
Suite Teardown     Run keyword and ignore error    Shared Line Suite Teardown

*** Variables ***

*** Test Cases ***

TC1 : Verify that delegate should display Ongoing section under recent tab in Shared line app,When Boss is in Call with other user .
    [Tags]  435355     bvt_tp     sanity_tp         bvt_pr
    [Setup]  Testcase Setup  count=3
    verify new badge icon on homescreen       device=device_1
    navigate to manage delegate page    device=device_3
    disable option in delegates permission    device=device_3     to_device=device_1        option=Join_active_calls
    disable option in delegates permission    device=device_3     to_device=device_1        option=Pick_up_held_calls
    go back to previous page     device=device_3
    Clear notification from home screen     device=device_1
    verify added delegate user in favorites page     from_device=device_1   to_device=device_3
    verify shared lines option in more option     device=device_1
    tap and verify shared line ui on boss from more tab    from_device=device_1  to_device=device_3
    click on calls tab  device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    verify join call option should not present in call favorites page   from_device=device_1     to_device=device_3
    Hold the call   device=device_3
    Verify Call State    device_list=device_3,device_2    state=Hold
    verify resume call option should not present in call favorites page    from_device=device_1     to_device=device_3
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2 : Verify that After enabling Join active call permission for the delegates, delegate should display JOIN button under Ongoing section in shared line app ,When other Delegate is in Call with other user on behalf of Boss
    [Tags]  435366    sanity_tp   P1
    [Setup]  Testcase Setup  count=4
    navigate to manage delegate page    device=device_3
    disable option in delegates permission    device=device_3     to_device=device_1        option=Pick_up_held_calls
    go back to previous page     device=device_3
    Add new delegates with both permission and validate   from_device=device_3    to_device=device_2
    navigate to manage delegate page    device=device_3
    disable option in delegates permission    device=device_3     to_device=device_2        option=Pick_up_held_calls
    go back to previous page     device=device_3
    Clear notification from home screen     device=device_1
    verify added delegate user in favorites page     from_device=device_1   to_device=device_3
    verify shared lines option in more option     device=device_1
    tap and verify shared line ui on boss from more tab    from_device=device_1  to_device=device_3
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_4
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_2,device_4    state=Connected
    tap and verify shared line ui on boss or delegate from call tab when other users are in call    from_device=device_1   to_device=device_3    users_in_call=device_2,device_4    call_state=Active
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3,device_4      state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3 : Verify DUT should display all the delegates of the Selected Boss under Delegates and all the Shared lines calls made by the other delegates on behalf of the selected boss under “recent” tab when user tap on shared lines app.
    [Tags]   435352     sanity_tp
    [Setup]  Testcase Setup   count=3
    Add new delegates with both permission and validate   from_device=device_3    to_device=device_2
    Clear notification from home screen     device=device_2
    verify user in people you support page     from_device=device_2    to_device=device_3
    verify shared lines option in more option     device=device_2
    tap and verify shared line ui on boss from more tab    from_device=device_2   to_device=device_3
    go back to previous page     device=device_2
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3    AND    Delete delegate from manage delegate    from_device=device_3    to_device=device_2

TC4 : Verify that delegate user should display Resume button under Ongoing section in Shared lines app,When other Delegate is in Call with other user on behalf of Boss and Put the call on hold.
    [Tags]   435371     P1
    [Setup]  Testcase Setup   count=4
    Add new delegates with both permission and validate   from_device=device_3    to_device=device_2
    verify user in people you support page     from_device=device_1    to_device=device_3
    verify shared lines option in more option     device=device_1
    tap and verify shared line ui on boss from more tab    from_device=device_1   to_device=device_3
    go back to previous page     device=device_1
    click on calls tab  device=device_2
    Initiate OBO call using display name    from_device=device_2      to_device=device_4     obo_option=device_3
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_2,device_4     state=Connected
    Hold the call   device=device_2
    Verify Call State    device_list=device_2,device_4    state=Hold
    verify join or resume call using shared line option from calls tab   from_device=device_1    to_device=device_3   users_in_call=device_2,device_4    resume_option=verify
    verify call state and disconnect    device=device_1,device_2,device_3,device_4
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4   AND    Delete delegate from manage delegate    from_device=device_3    to_device=device_2

TC5 : Verify that delegate should display Ongoing section without Join button under recent tab in Shared lines app,When another Delegate is in Call with other user on behalf of Boss.
    [Tags]    435354    P1
    [Setup]  Testcase Setup   count=4
    navigate to manage delegate page    device=device_3
    disable option in delegates permission    device=device_3     to_device=device_1        option=Join_active_calls
    disable option in delegates permission    device=device_3     to_device=device_1        option=Pick_up_held_calls
    go back to previous page     device=device_3
    Clear notification from home screen     device=device_1
    Add new delegates with both permission and validate   from_device=device_3    to_device=device_2
	Clear notification from home screen     device=device_1
	verify user in people you support page     from_device=device_1    to_device=device_3
	verify shared lines option in more option     device=device_1
	tap and verify shared line ui on boss from more tab    from_device=device_1  to_device=device_3
    click on calls tab  device=device_2
	Initiate OBO call using display name    from_device=device_2      to_device=device_4    obo_option=device_3
	Pick incoming call    device=device_4
	Verify Call State    device_list=device_2,device_4    state=Connected
	tap and verify shared line ui on boss or delegate from call tab when other users are in call    from_device=device_1   to_device=device_3    users_in_call=device_2,device_4    call_state=Active
	Hold the call   device=device_2
	Verify Call State    device_list=device_2,device_4    state=Hold
	verify join or resume call using shared line option from calls tab    from_device=device_1     to_device=device_3    users_in_call=device_2,device_4    resume_option=absent
	Disconnect call     device=device_2
	verify call state and disconnect    device=device_1,device_2,device_3,device_4
	[Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4    AND    Delete delegate from manage delegate    from_device=device_3    to_device=device_2


TC6 : Verify the options present under Delegation Setting page
    [Tags]    451469    Sanity_tP
    [Setup]    Testcase Setup   count=2
    Navigate to manage delegate page    device=device_1
    verify delegate permission      from_device=device_1      to_device=device_2
    [Teardown]  Run Keywords    Capture on Failure     AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
Shared Line suite Setup
    Add new delegates with both permission and validate   from_device=device_3    to_device=device_1
    Open settings page      device=device_1
    Open manage delegate page    device=device_1
    Return To Home Screen    device_list=device_1

Shared Line Suite Teardown
    Suite Failure Capture
    Delete delegate from manage delegate    from_device=device_3    to_device=device_1
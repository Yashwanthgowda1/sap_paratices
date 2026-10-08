*** Settings ***
Resource    ../resources/keywords/common.robot


Suite Teardown  Suite Failure Capture

*** Variables ***

*** Test Cases ***
TC1 : Verify that Delegate user able to join the call by tapping on Resume button under Ongoing section Shared lines app/View shared line,When Boss is in Call with other user .
    [Tags]  476137     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]   Run Keywords   Testcase Setup for CAP Premium User  count=3   AND   Add new delegates with both permission and validate   from_device=device_1    to_device=device_2
    Clear notification from home screen     device=device_1
    click on calls tab  device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1    state=Hold
    navigate to calls favorites page     device=device_2
    verify and resume call using resume call in more option with boss or delegate    from_device=device_2    to_device=device_1:cap_search_enabled    option=verify       shared_line=enabled
    verify and resume call using resume call in more option with boss or delegate    from_device=device_2     to_device=device_1:cap_search_enabled    option=join_call    shared_line=enabled
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
    verify and resume call using resume call in more option with boss or delegate    from_device=device_2    to_device=device_1:cap_search_enabled    option=verify     shared_line=enabled
    tap and verify shared line ui on boss or delegate from call tab when other users are in call    from_device=device_2   to_device=device_1:cap_search_enabled    users_in_call=device_1:cap_search_enabled,device_3
    verify and resume call using resume call in more option with boss or delegate    from_device=device_2    to_device=device_1:cap_search_enabled    option=join_call    shared_line=enabled
    Verify Call State    device_list=device_1    state=Disconnected
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3   AND  Delete delegate from manage delegate    from_device=device_1    to_device=device_2

TC2 : Verify that delegate should display Ongoing section under recent tab in Shared line app,When Boss is in Call with other user .
    [Tags]  476122     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User  count=3
    Add new delegates with both permission and validate   from_device=device_3    to_device=device_1:cap_search_enabled
    navigate to manage delegate page    device=device_3
    disable option in delegates permission    device=device_3     to_device=device_1:cap_search_enabled       option=Join_active_calls
    disable option in delegates permission    device=device_3     to_device=device_1:cap_search_enabled       option=Pick_up_held_calls
    go back to previous page     device=device_3
    Clear notification from home screen     device=device_1
    verify added delegate user in favorites page     from_device=device_1   to_device=device_3
    verify new badge icon on homescreen       device=device_1
    verify shared lines option in more option     device=device_1
    tap and verify shared line ui on boss from more tab    from_device=device_1   to_device=device_3
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
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3    AND  Delete delegate from manage delegate    from_device=device_3    to_device=device_1:cap_search_enabled

*** Keywords ***

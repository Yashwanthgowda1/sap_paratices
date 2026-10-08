*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation      Suite Setup Requirements : This suite requires minimum of 3 devices in config
...                Purpose: Device_1 & Device_3 should add Device_2:delegate_user & Device_1 as Delegates respectively

Suite Setup         OBO Setup
Suite Teardown    Run keyword and ignore error   OBO Teardown


*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Advanced Calling] Verify that active call with timer disappear when the call is disconnected
    [Tags]      311373   P0
    [Setup]  Testcase Setup for Delegate User  count=3
    click on calls tab  device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_2:delegate_user
    Verify Incoming call    device=device_2    status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    wait for some time  ${wait_time}
    navigate to calls favorites page   device=device_1
    verify and join call using join call in more option with boss and delegate   from_device=device_1      to_device=device_2:delegate_user        option=verify
    disconnect call    device=device_3
    Verify Call State    device_list=device_2,device_3    state=disconnected
    wait for some time  ${wait_time}
    go back to previous page   device=device_1
    Verify join call option should not present inside the more icon of boss     from_device=device_1      to_device=device_2:delegate_user
    [Teardown]  run keywords  Capture on Failure    AND    check call dropdown menu state   device=device_1    AND    Come back to home screen   device_list=device_1,device_2,device_3

TC2 : [Advance Calling]DUT user able to initiate a call to recent call user from the Recent tab
    [Tags]      311519       bvt_tp   sanity_tp
    [Setup]  Testcase Setup for Delegate User  count=3
    navigate to calls tab  device=device_1
    Make outgoing call using display name   from_device=device_1   to_device=device_2:delegate_user
    disconnect call    device=device_1
    call from recent tab using call history  from_device=device_1      to_device=device_2:delegate_user
    Verify Incoming call    device=device_2    status=appear
    wait for some time  ${wait_time}
    disconnect call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=disconnected
    wait for some time  ${wait_time}
    verify latest call details      from_device=device_1     to_device=device_2
    [Teardown]  run keywords  Capture on Failure    AND    check call dropdown menu state   device=device_1    AND    Come back to home screen   device_list=device_1,device_2,device_3

TC3 : [Advance Calling] Delegates should be able to get SLA pop up when boss put their call on hold
    [Tags]      311524      P2
    [Setup]  Testcase Setup for Delegate User  count=4
    click on calls tab  device=device_3
    Make outgoing call using display name   from_device=device_3   to_device=device_2:delegate_user
    Verify Incoming call    device=device_2    status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    wait for some time  ${wait_time}
    hold the call   device=device_3
    verify call state   device_list=device_2   state=hold
    navigate to calls favorites page   device=device_1
    refresh calls main tab    device=device_1
    verify call hold banner for delegates   from_device=device_1   to_device=device_3
    click on calls tab  device=device_4
    Make outgoing call using display name   from_device=device_4   to_device=device_2:delegate_user
    Verify Incoming call    device=device_2    status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_4    state=Connected
    wait for some time  ${wait_time}
    hold the call   device=device_2
    verify call state   device_list=device_4   state=hold
    verify call hold banner for delegates   from_device=device_1   to_device=device_3
    disconnect call   device=device_4,device_2
    verify call state   device_list=device_2,device_3,device_4    state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND    Come back to home screen   device_list=device_1,device_2,device_3,device_4

TC4 : [Advance Calling] Boss must be able to see, active call with timer should display two entries if Delegate is in two calls OBO boss
    [Tags]      311531      P2
    [Setup]  Testcase Setup for Delegate User  count=4
    click on calls tab  device=device_2
    Initiate OBO call and verify boss list  from_device=device_2     to_device=device_3     obo_option=device_1     boss_list=device_1
    Verify Incoming call    device=device_3    status=appear
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    wait for some time  ${wait_time}
    return to home screen    device_list=device_2
    click on calls tab  device=device_2
    Initiate OBO call and verify boss list  from_device=device_2     to_device=device_4     obo_option=device_1     boss_list=device_1
    Verify Incoming call    device=device_4    status=appear
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_2,device_4    state=Connected
    Verify Call State    device_list=device_3    state=Hold
    wait for some time  ${wait_time}
    navigate to calls favorites page   device=device_1
    verify and resume call using resume call in more option with boss or delegate   from_device=device_1      to_device=device_3        option=verify
    disconnect call    device=device_3,device_2
    verify call state   device_list=device_2,device_3,device_4    state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND    check call dropdown menu state   device=device_1    AND    Come back to home screen   device_list=device_1,device_2,device_3

TC5 : [Advance Calling]The empty voicemail screen should now be shown with simple message “No voicemails yet.”
    [Tags]      311520   P2
    [Setup]  Testcase Setup for Delegate User  count=1
    navigate to voicemail tab   device=device_1
    delete all voicemails    device=device_1
    verify voicemail tab empty      device=device_1
    [Teardown]  run keywords  Capture on Failure      AND    Come back to home screen   device_list=device_1

TC6 : [Advance Calling] Active call with timer should display active call entries if Boss in on two calls
    [Tags]  311542   P2
    [Setup]  Testcase Setup for Delegate User  count=4
    click on calls tab  device=device_3
    Make outgoing call using display name   from_device=device_3   to_device=device_2:delegate_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    navigate to calls favorites page   device=device_1
    verify and join call using join call in more option with boss and delegate   from_device=device_1      to_device=device_3        option=verify
    click on calls tab  device=device_4
    Make outgoing call using display name   from_device=device_4   to_device=device_2:delegate_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_4    state=Connected
    Verify Call State    device_list=device_3    state=hold
    verify and resume call using resume call in more option with boss or delegate   from_device=device_1      to_device=device_3        option=verify
    disconnect call    device=device_3,device_4
    Verify Call State    device_list=device_2,device_3,device_4    state=disconnected
    [Teardown]  run keywords  Capture on Failure     AND    check call dropdown menu state   device=device_1     AND    Come back to home screen   device_list=device_1,device_2,device_3,device_4

TC7 : [Advance Calling] Delegates should be able to see a active call with timer &Join option over Boss's profile, when Boss make an outgoing call
    [Tags]      311544      P2
    [Setup]  Testcase Setup for Delegate User  count=3
    click on calls tab  device=device_3
    Make outgoing call using display name   from_device=device_3   to_device=device_2:delegate_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    navigate to calls favorites page   device=device_1
    verify and join call using join call in more option with boss and delegate   from_device=device_1      to_device=device_3        option=verify
    disconnect call    device=device_3
    Verify Call State    device_list=device_2,device_3    state=disconnected
    [Teardown]  run keywords  Capture on Failure     AND    check call dropdown menu state   device=device_1     AND    Come back to home screen   device_list=device_1,device_2,device_3

TC8 : [Advance Calling] Boss is in call & Delegate user tap on More info icon beside the username of Boss, it should display "Call" option
    [Tags]      311548   P2
    [Setup]  Testcase Setup for Delegate User  count=3
    click on calls tab  device=device_3
    Make outgoing call using display name   from_device=device_3   to_device=device_2:delegate_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    navigate to calls favorites page   device=device_1
    verify and join call using join call in more option with boss and delegate   from_device=device_1      to_device=device_3        option=verify
    disconnect call    device=device_3
    Verify Call State    device_list=device_2,device_3    state=disconnected
    [Teardown]  run keywords  Capture on Failure     AND    check call dropdown menu state   device=device_1    AND    Come back to home screen   device_list=device_1,device_2,device_3

TC9 : [Manage Delegates] User should be able to view the permissions of existing delegates
    [Tags]      318731   P2
    [Setup]  Testcase Setup for Delegate User  count=3
    navigate to manage delegate page    device=device_1
    verify delegate permission option in manage delegates    device=device_1      to_device=device_2:delegate_user
    [Teardown]  run keywords  Capture on Failure     AND    Come back to home screen   device_list=device_1

TC10 : [Manage Delegates] DUT should be able to search delegates at Manage delegates screen
    [Tags]      318855   P2
    [Setup]  Testcase Setup for Delegate User  count=3
    navigate to manage delegate page    device=device_1
    verify search results for delegates at Manage delegates screen      device=device_1     to_device=device_1:meeting_user
    return to home screen    device_list=device_1
    [Teardown]  run keywords  Capture on Failure    AND    Come back to home screen   device_list=device_1,device_2,device_3

TC11 : [Manage Delegate] DUT should not be able to view call settings of Boss if boss hasn't provided the change call settings permission
    [Tags]      320254   P2
    [Setup]  Testcase Setup for Delegate User  count=3
    navigate to manage delegate page    device=device_3
    disable option in delegates permission    device=device_3     to_device=device_1        option=Change_call_and_delegate_settings
    return to home screen    device_list=device_3
    navigate to calls favorites page  device=device_1
    verify people you support more option at favorites page  from_device=device_1   to_device=device_3
    navigate to manage delegate page    device=device_1
    verify delegate permissions selectively     device=device_1      from_device=device_3        exclude_permission=change_call_settings
    [Teardown]  run keywords  Capture on Failure     AND    enable option in delegates permission       device=device_3     to_device=device_1      option=Change_call_and_delegate_settings   AND     Come back to home screen   device_list=device_1,device_2,device_3

TC12 : [Advance Calling] Delegates should able to see a active call with timer &Join option disappeared over Boss's profile, after call disconnects
    [Tags]     320268   P2
    [Setup]  Testcase Setup for Delegate User  count=3
    click on calls tab  device=device_3
    Make outgoing call using display name   from_device=device_3   to_device=device_2:delegate_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    navigate to calls favorites page   device=device_1
    refresh calls main tab    device=device_1
    verify and join call using join call in more option with boss and delegate   from_device=device_1      to_device=device_3        option=verify
    disconnect call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=disconnected
    go back to previous page    device=device_1
    refresh calls main tab    device=device_1
    Verify join call option should not present inside the more icon of boss     from_device=device_1      to_device=device_3
    [Teardown]  run keywords  Capture on Failure     AND    check call dropdown menu state   device=device_1     AND    Come back to home screen   device_list=device_1,device_2,device_3

TC13 : [Advance Calling]Call should initiate to delegate when user select " Call to { boss} from More info
    [Tags]  320291   P2
    [Setup]  Testcase Setup for Delegate User  count=3
    click on calls tab  device=device_3
    Make outgoing call using display name   from_device=device_3   to_device=device_2:delegate_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    navigate to calls favorites page   device=device_1
    refresh calls main tab    device=device_1
    verify and join call using join call in more option with boss and delegate   from_device=device_1      to_device=device_3        option=call
    verify incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1    state=Connected
    disconnect call    device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3   state=disconnected
    [Teardown]  run keywords  Capture on Failure     AND    check call dropdown menu state   device=device_1     AND    Come back to home screen   device_list=device_1,device_2,device_3

TC14 : [Manage Delegates] User should be able to view already existing delegates and delegators
    [Tags]  321211   P2
    [Setup]  Testcase Setup for Delegate User  count=4
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_4
    navigate to manage delegate page    device=device_1
    verify existing delegates and delegators in manage delegates    device=device_1     people_you_support=device_3     your_delegates=device_4
    [Teardown]  run keywords  Capture on Failure    AND    Come back to home screen   device_list=device_1,device_2,device_3,device_4   AND     Delete delegate from manage delegate   from_device=device_1    to_device=device_4

TC15 : [Manage Delegates] User should be able to update the permissions of existing delegates
    [Tags]      318852   P2
    [Setup]  Testcase Setup for Delegate User  count=4
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_4
    navigate to manage delegate page    device=device_1
    verify delegate permission option in manage delegates    device=device_1     to_device=device_4
    disable option in delegates permission    device=device_1     to_device=device_4        option=Make_calls
    disable option in delegates permission    device=device_1     to_device=device_4        option=Receive_calls
    disable option in delegates permission    device=device_1     to_device=device_4        option=Change_call_and_delegate_settings
    disable option in delegates permission    device=device_1     to_device=device_4        option=Join_active_calls
    return to home screen    device_list=device_1
    [Teardown]  run keywords  Capture on Failure      AND    Come back to home screen   device_list=device_1,device_2,device_3,device_4    AND     Delete delegate from manage delegate   from_device=device_1    to_device=device_4

TC16 : [Manage Delegates] User should be able to remove already existing delegates
    [Tags]      318858   P2
    [Setup]  Testcase Setup for Delegate User  count=4
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_4
    Delete delegate from manage delegate   from_device=device_1    to_device=device_4
    [Teardown]  run keywords  Capture on Failure     AND    Come back to home screen   device_list=device_1,device_2,device_3,device_4

TC17 : [Call Transfer] DUT user consult transfer on behalf of boss
    [Tags]   309845    call_transfer    bvt_tp   sanity_tp            alt_blocked      Certification_audio
    [Setup]     Testcase Setup for Delegate User   count=3
    Click on calls tab      device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2:delegate_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult transfer OBO call using display name    from_device=device_2      to_device=device_3    obo_option=device_1
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_1,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC18 : [OBO] Active call pill count notification on boss's tile under people you support section
    [Tags]   309413    P2
    [Setup]  Testcase Setup for Delegate User  count=3
    Navigate to Manage delegate page    device=device_1
    return to home screen   device_list=device_1
    Initiate OBO call and verify boss list  from_device=device_2     to_device=device_3     obo_option=myself     boss_list=device_1
    verify incoming call   device=device_3    status=appear
    pick incoming call    device=device_3
    wait for some time   ${wait_time}
    verify call state   device_list=device_2,device_3    state=Connected
    navigate to calls favorites page   device=device_1
    refresh calls main tab    device=device_1
    verify and join call using join call in more option with boss and delegate   from_device=device_1      to_device=device_3        option=verify
    disconnect call    device=device_3
    verify call state   device_list=device_2,device_3    state=Disconnected
    wait for some time  ${wait_time}
    Navigate to calendar tab   device=device_1
    navigate to calls favorites page   device=device_1
    Verify join call option should not present inside the more icon of boss     from_device=device_1      to_device=device_3
    [Teardown]  run keywords  Capture on Failure    AND    check call dropdown menu state   device=device_1    AND    Come back to home screen   device_list=device_1,device_2,device_3

TC19 : [Manage Delegates] User should be able to add delegates successfully
    [Tags]      318849    tp_audio 
    [Setup]  Testcase Setup for Delegate User  count=4
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_4
    Delete delegate from manage delegate   from_device=device_1    to_device=device_4
    [Teardown]  run keywords  Capture on Failure     AND    Come back to home screen   device_list=device_1,device_2,device_3,device_4

TC20 : [OBO] DUT user 1 adds DUT user 2 as delegate with both Make and receive call permission
    [Tags]      309357      
    [Setup]    Testcase Setup for Delegate User   count=3
    Edit added delegates with both permission and validate   from_device=device_1    to_device=device_2
    Refresh page for delegate user config changes visibility    device=device_2
    Initiate OBO call using display name    from_device=device_2      to_device=device_3    obo_option=device_1
    Verify calling behalf of device text    device=device_2   to_device=device_3     from_device=device_1
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3

*** Keywords ***
OBO Setup
    verify device users    user_list=user,delegate_user,user
    Remove all delegates on device   devices=device_1,device_2,device_3
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_2:delegate_user
    Add new delegates with both permission and validate   from_device=device_3    to_device=device_1
    Navigate to Calls Favorites page    device=device_1
    navigate to manage delegate page    device=device_1
    return to home screen    device_list=device_1
    navigate to calls favorites page    device=device_1
    refresh calls main tab  device=device_1
    favorites_module_sanity     device_list=device_1

OBO Teardown
    Suite Failure Capture
    come back to home screen   device_list=device_1,device_2,device_3
    click on calls tab   device=device_3
    Delete delegate from manage delegate   from_device=device_3    to_device=device_1
    return to home screen    device_list=device_3
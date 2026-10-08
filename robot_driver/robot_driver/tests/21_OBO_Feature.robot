*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation      Suite Setup Requirements : This suite requires minimum of 3 devices in config
...                Purpose: Device_1 should add Device_2:delegate_user as Delegate.

Suite Setup       OBO Suite Setup
Suite Teardown    Run keyword and ignore error      OBO Suite Teardown


*** Variables ***
${wait_time} =  10
${wait_time2} =  25

*** Test Cases ***
TC1 :[OBO] DUT user to set "If unanswered" of delegate.
    [Tags]  309333   P2  alt_blocked
    [Setup]    Testcase Setup for Delegate User  count=3
    Enable unanswered call to delegates     from_device=device_1    contact_device=device_2
    Click on calls tab      device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Wait for Some Time    time=${wait_time2}
    Verify Incoming call    device=device_2     status=appear
    Disconnect call     device=device_3
    Verify Incoming call    device=device_2     status=disappear
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2,device_3    AND   Disable unanswered call    device=device_1      contact_device=device_2

TC2 : [OBO] DUT user should not be able to add self as delegate.
    [Tags]    309340     P2  alt_blocked
    [Setup]    Testcase Setup for Delegate User  count=1
    Validate user should not be able to add self as delegate   device=device_1
    [Teardown]  run keywords  Capture on Failure   AND   Come back to home screen   device_list=device_1

TC4 : [OBO] DUT user to display with permissions, when enabled from the boss.
    [Tags]  309316   P2  alt_blocked
    [Setup]   Testcase Setup for Delegate User  count=2
    Navigate to Calls Favorites page    device=device_2
    favorites_module_sanity     device_list=device_2
    Validate delegate view permissions on favorites page    device=device_2
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2

TC5 : [OBO] Teams to display with permissions on DUT for delegate.
    [Tags]  309319   P2  alt_blocked
    [Setup]   Testcase Setup for Delegate User  count=2
    Navigate to Calls Favorites page    device=device_2
    favorites_module_sanity     device_list=device_2
    Validate delegate view permissions on favorites page    device=device_2
    Verify user unable to toggle the permissions    device=device_2
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1

TC6 : [OBO] DUT user to change the delegates
    [Tags]    309323   sanity_tp       bvt_pr      
    [Setup]   Testcase Setup for Delegate User  count=3
    Open settings page      device=device_2
    Open manage delegate page    device=device_2
    Return To Home Screen    device_list=device_2
    Navigate to Calls Favorites page    device=device_2
    favorites_module_sanity     device_list=device_2
    Validate delegate view permissions on favorites page    device=device_2
    return to home screen   device_list=device_2
    Navigate to Change delegates page   device=device_2
    Add new delegate      from_device=device_2      to_device=device_3
    Validate added delegate user visibility     from_device=device_1      to_device=device_3
    [Teardown]  run keywords  Capture on Failure   AND   Delete delegate from manage delegate   from_device=device_1    to_device=device_3    AND    Come back to home screen   device_list=device_1,device_2,device_3

TC7 : [OBO] DUT user has multiple boss and able to make calls another boss on behalf of himself.
    [Tags]  308674   bvt_tp  sanity_tp   P0  alt_blocked
    [Setup]   Testcase Setup for Delegate User  count=3
    Add new delegates with both permission and validate   from_device=device_3    to_device=device_2:delegate_user
    Initiate OBO call and verify boss list  from_device=device_2     to_device=device_1     obo_option=myself     boss_list=device_3
    Verify Incoming call    device=device_1    status=appear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_2,device_1    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_1     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND   Come back to home screen   device_list=device_1,device_2,device_3    AND    Delete delegate from manage delegate   from_device=device_3    to_device=device_2:delegate_user

TC8 : [OBO]DUT user to display with permission on DUT for People you support
    [Tags]  310234   P2  alt_blocked
    [Setup]   Testcase Setup for Delegate User  count=2
    Navigate to Manage delegate page    device=device_2
    Navigate to Calls Favorites page    device=device_2
    favorites_module_sanity     device_list=device_2
    Validate permissions for people you support    from_device=device_2   to_device=device_1
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2

TC9 : [OBO] DUT user has 2 bosses
    [Tags]  309085   p2  alt_blocked
    [Setup]   Testcase Setup for Delegate User  count=4
    Add new delegates with both permission and validate   from_device=device_3    to_device=device_2:delegate_user
    Initiate OBO call and verify boss list  from_device=device_2     to_device=device_4     obo_option=device_1     boss_list=device_1,device_3
    Verify Incoming call    device=device_4    status=appear
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_2,device_4    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_4     state=Disconnected
    [Teardown]  run keywords  Capture on Failure  AND  Come back to home screen   device_list=device_2,device_3,device_4   AND    Delete delegate from manage delegate   from_device=device_3    to_device=device_2:delegate_user

TC10 : [Call Hold] DUT user to hold the call with another Teams client user when delegate is configured
    [Tags]  310449    P2  alt_credentials
    [Setup]  Testcase Setup for Delegate User  count=3
    Click on calls tab   device=device_2
    Make outgoing call using from call icon    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC11 :[Call forward on home screen] Verify DUT after adding delegates from TDC /DUT.
    [Tags]     452542         phonesCY23_4        sanity_tp
    [Setup]  run keywords       Testcase Setup for Delegate User   count=3     AND    enable call forwarding display on home screen         device=device_1
    verify and set call forwarding on home screen     device=device_1         option=delegate           to_device=device_2:delegate_user
    Click on calls tab      device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify incoming call    device=device_2     status=appear
    Pick incoming call   device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    Verify call entries are synced in call log    from_device=device_1      to_device=device_3      state=forwarded_to
    [Teardown]  run keywords  Capture on Failure    AND    Come back to home screen   device_list=device_1,device_2,device_3

TC12 : [Busy on Busy] Verify Unanswered call should be forwarded to Delegates, When user selects Redirect as if a call is unanswered under When in another call in Calling
    [Tags]      451979    sanity_tp  phonesCY23_4
    [Setup]    run keywords    Testcase Setup for Delegate User   count=3  AND    Enable unanswered call to delegates     from_device=device_1    contact_device=device_2
    select the options inside when in another call option   device=device_1     option=redirect_unanswered_call
    return to home screen    device_list=device_1
    click on calls tab  device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    click on calls tab  device=device_4
    Make outgoing call using display name    from_device=device_4      to_device=device_1
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Connected
    Disconnect call     device=device_1,device_4
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     busy on busy testcase teardown    devices=device_1,device_4

*** Keywords ***
OBO Suite Setup
    Testcase Setup for Delegate User  count=3
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_2:delegate_user

OBO Suite Teardown
    Suite Failure Capture
    come back to home screen   device_list=device_1,device_2,device_3

verify devices and teardown
    Capture on Failure
    Come back to home screen   device_list=device_2,device_3,device_4,device_5
    Delete delegate from manage delegate   from_device=device_3    to_device=device_2:delegate_user
    Delete delegate from manage delegate   from_device=device_4    to_device=device_2:delegate_user

verify device criteria and teardown
    Run Keyword If      ${tc_flag}==True    run keyword     verify devices and teardown

Unanswered call Teardown
    [Arguments]     ${devices}
    verify call state and disconnect      ${devices}
    Come back to home screen     ${devices}
    Disable unanswered call    device=device_1      contact_device=device_2

enable call forwarding display on home screen
    [Arguments]     ${device}
    verify and change toggle status for call forwarding display on home screen    device=${device}      status=on

disable call forwarding display on home screen
    [Arguments]     ${device}
    verify and change toggle status for call forwarding display on home screen    device=${device}      status=off

busy on busy testcase teardown
    [Arguments]     ${devices}
    verify call state and disconnect      ${devices}
    Disable unanswered call    device=device_1      contact_device=device_2
    select the options inside when in another call option   device=device_1     option=new_calls_ring_me
    Come back to home screen    ${devices}
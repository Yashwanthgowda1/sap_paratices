*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation      Suite Setup Requirements : This suite requires minimum of 3 devices in config
...                Purpose: Device_1 should be added as a Delegate from Device_2

Suite Setup    Shared Line suite Setup
Suite Teardown     Run keyword and ignore error    Shared Line Suite Teardown

*** Variables ***

*** Test Cases ***
TC1 : Verify that delegate should display Resume button under Ongoing section in shared lines app ,When Boss is in Call with other user .
     [Tags]  435375   P1   sanity_tp
     [Setup]   Testcase Setup  count=3
     Clear notification from home screen     device=device_1
     verify new badge icon on homescreen       device=device_1
     verify added delegate user in favorites page     from_device=device_1   to_device=device_2
     verify shared lines option in more option     device=device_1
     tap and verify shared line ui on boss from more tab    from_device=device_1  to_device=device_2
     click on calls tab  device=device_2
     Make outgoing call using display name    from_device=device_2      to_device=device_3
     Pick incoming call    device=device_3
     Verify Call State    device_list=device_3,device_2    state=Connected
     Hold the call   device=device_2
     Verify Call State    device_list=device_2,device_3    state=Hold
     Navigate to calls tab    device=device_1
     verify and resume call using resume call in more option with boss or delegate    from_device=device_1    to_device=device_2    option=verify    shared_line=enabled
     Disconnect call     device=device_2
     Verify Call State    device_list=device_2,device_3     state=Disconnected
     [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2 : Verify that New badge should present on more app with irrespective of badge count of other apps present inside the more app.
    [Tags]  435342    P1
    [Setup]    Testcase Setup  count=2
    Clear notification from home screen     device=device_1
    verify user in people you support page     from_device=device_1    to_device=device_2
    verify shared lines option in more option     device=device_1
    verify home screen tabs and more option tabs      device=device_1    shared_line=Enabled
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3 : Verify that DUT should display an error message "Your no longer a delegate for shared line with a got it option" when DUT user tap on Shared line app Present inside the More app/Homescreen after Boss removed the DUT user as delegate
    [Tags]  435347    P2
    [Setup]   Testcase Setup  count=2
    Clear notification from home screen     device=device_1
    verify user in people you support page     from_device=device_1    to_device=device_2
    verify shared lines option in more option     device=device_1
    Delete delegate from manage delegate    from_device=device_2    to_device=device_1
    navigate to shared lines tab        device=device_1
    verify shared line error message after removing delegate      device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    Add new delegates with both permission and validate   from_device=device_2    to_device=device_1

TC4 : Verify DUT user should not display with New badge(Blue color) on More app once DUT user open the shared lines app.
    [Tags]  435345    sanity_tp
    [Setup]    Testcase Setup  count=2
    Clear notification from home screen     device=device_1
    verify user in people you support page     from_device=device_1    to_device=device_2
    verify shared lines option in more option     device=device_1
    tap and verify shared line ui on boss from more tab    from_device=device_1    to_device=device_2
    verify home screen tiles     device=device_1
    verify new badge icon on homescreen       device=device_1     new_badge=Absent
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC5 : Verify that Shared line app with New badge should Present on the Homescreen,when DUT user Move Shared line app outside of the More app while re-ordering.
    [Tags]  435343     bvt_tp     sanity_tp
    [Setup]    Testcase Setup  count=2
    Clear notification from home screen     device=device_1
    verify user in people you support page     from_device=device_1    to_device=device_2
    verify shared lines option in more option     device=device_1
    Navigate to reorder tab     device=device_1
    Verfy and reorder homescreen tiles   device=device_1    tab=Shared lines    destination=voicemail
    return to home screen      device_list=device_1
    verify shared lines app in home screen   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC6 : Verify badge count is not increasing when delagators are added by TDC User.
    [Tags]  435412    P2
    [Setup]    Testcase Setup   count=3
    Clear notification from home screen     device=device_1
    verify user in people you support page     from_device=device_1    to_device=device_2
    verify shared lines option in more option     device=device_1
    Add new delegates with both permission and validate   from_device=device_3     to_device=device_1
    verify user in people you support page     from_device=device_1    to_device=device_3
    verify shared lines option in more option     device=device_1     new_badge=Present
    verify new badge count not increased on homescreen    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3    AND  Delete delegate from manage delegate    from_device=device_3    to_device=device_1

TC7 : Verify Shared line apps with new badge should not present under more app/Homescreen, when TDC user removes the DUT user from delegate
    [Tags]  435346   P1   sanity_tp
    [Setup]    Testcase Setup   count=2
    Clear notification from home screen     device=device_1
    verify user in people you support page     from_device=device_1    to_device=device_2
    verify shared lines option in more option     device=device_1
    Delete delegate from manage delegate    from_device=device_2    to_device=device_1
    verify user in people you support page     from_device=device_1    to_device=device_2    user_presence=Absent
    Verify home screen page     device=device_1
    verify new badge icon on homescreen       device=device_1     new_badge=Absent
    verify shared lines option in more option     device=device_1    new_badge=Absent
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    Add new delegates with both permission and validate   from_device=device_2    to_device=device_1

TC8 : Verify that DUT should not display shared line app on More app,When there is no Boss(Delegator) present on signed in user.
    [Tags]  435349    P1
    [Setup]   Run Keywords   Testcase Setup   count=2    AND    Delete delegate from manage delegate    from_device=device_2    to_device=device_1
    Clear notification from home screen     device=device_1
    verify user in people you support page     from_device=device_1    to_device=device_2    user_presence=Absent
    Verify home screen page     device=device_1
    verify new badge icon on homescreen       device=device_1     new_badge=Absent
    verify shared lines option in more option     device=device_1    new_badge=Absent
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    Add new delegates with both permission and validate   from_device=device_2    to_device=device_1

#Bug 3908009: [Phones]DUT user not able to access the Shared line app.
TC9 : Verify that DUT should not display New badge on Shared line app once DUT user opened shared lines app,When Multiple user added DUT as delegate .
    [Tags]  435378    P2
    [Setup]    Testcase Setup   count=3
    Clear notification from home screen     device=device_1
    verify user in people you support page     from_device=device_1    to_device=device_2
    verify shared lines option in more option     device=device_1
    tap and verify shared line ui on boss from more tab    from_device=device_1  to_device=device_2
    Verify home screen page     device=device_1
    Add new delegates with both permission and validate   from_device=device_3     to_device=device_1
    Clear notification from home screen     device=device_1
    verify new badge icon on homescreen       device=device_1     new_badge=Absent
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3    AND  Delete delegate from manage delegate    from_device=device_3    to_device=device_1

TC10 : Verify DUT should navigate to the Shared line app,when user tap on View shared line option under favorites tab.
    [Tags]   435350    P2
    [Setup]    Testcase Setup  count=2
    Clear notification from home screen     device=device_1
    verify user in people you support page     from_device=device_1    to_device=device_2
    verify people you support more option at favorites page   from_device=device_1   to_device=device_2
    tap and verify shared line ui from people you support in call favorites tab    from_device=device_1   to_device=device_2
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC11 : Verify that View shared line option should not present for delegates under Your delegates section
    [Tags]    435432    P2
    [Setup]    Testcase Setup  count=3
    verify user options under your delegates in favorites page    from_device=device_2    to_device=device_1
    click on calls tab  device=device_1
    Initiate OBO call using display name    from_device=device_1      to_device=device_3     obo_option=device_2
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    verify view shared lines should not present in your delegates more icon    from_device=device_2   to_device=device_1
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC12 : Verify that Delegate should display Join button under Ongoing section in Shared lines app,When Boss is in Call with other user .
    [Tags]   435370    bvt_tp     sanity_tp
    [Setup]  Testcase Setup  count=3
    Clear notification from home screen     device=device_1
    verify user in people you support page     from_device=device_1    to_device=device_2
    verify shared lines option in more option     device=device_1
    tap and verify shared line ui on boss from more tab    from_device=device_1  to_device=device_2
    Verify home screen page     device=device_1
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    verify join or resume call using shared line option from calls tab   from_device=device_1    to_device=device_2   users_in_call=device_2,device_3    join_option=verify
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC13 : Verify DUT should display all the Delegates under delegates tab and able to select any delegator among the drop down, and also verify Shared lines calls under recent tab of the selected Boss from the dropdown icon in view shared line option under favorite
    [Tags]    435353     sanity_tp
    [Setup]    Testcase Setup   count=3
    Add new delegates with both permission and validate   from_device=device_3   to_device=device_1
    Clear notification from home screen     device=device_1
    verify user in people you support page     from_device=device_1    to_device=device_2
    verify people you support more option at favorites page   from_device=device_1   to_device=device_2
    verify multiple bosses in shared line option from people you support page     from_device=device_1   to_device=device_2     bosses_list=device_3
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3    AND     Delete delegate from manage delegate    from_device=device_3    to_device=device_1

TC14 : Verify DUT should display all the delegates of the selected Boss from the dropdown icon under Delegate and all the calls made by the delegate on behalf of the selected boss under “recent” tab when user selects View shared line option.
    [Tags]   435351     P2
    [Setup]    Testcase Setup   count=2
    Clear notification from home screen     device=device_1
    verify user in people you support page     from_device=device_1    to_device=device_2
    verify people you support more option at favorites page     from_device=device_1    to_device=device_2
    tap and verify shared line ui on boss from more tab    from_device=device_1   to_device=device_2
    verify delegate list for boss from shared line ui     from_device=device_1     to_device=device_2
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC15 : Verify Shared lines app is displayed under More section with New badge, when delagators add/remove the DUT as delegate Multiple times
    [Tags]    435380   P1
    [Setup]    Testcase Setup   count=2
    Clear notification from home screen     device=device_1
    verify user in people you support page     from_device=device_1    to_device=device_2
    verify shared lines option in more option     device=device_1
    Delete delegate from manage delegate    from_device=device_2    to_device=device_1
    verify user in people you support page     from_device=device_1    to_device=device_2    user_presence=Absent
    verify shared lines option in more option     device=device_1    new_badge=Absent
    Add new delegates with both permission and validate   from_device=device_2    to_device=device_1
    verify user in people you support page     from_device=device_1    to_device=device_2
    verify shared lines option in more option     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC:16 Verify DUT should navigate to Homescreen/Calls tab and doesn't display Shared line app in Homescreen/More app,When DUT user tap on Got it option in error message
	[Tags]    435348       sanity_tp
	[Setup]    Testcase Setup	count=2
    clear notification from home screen    device=device_1
	verify added delegate user in favorites page    from_device=device_1    to_device=device_2
    verify shared lines option in more option    device=device_1
    Navigate to reorder tab    device=device_1
    Verfy and reorder homescreen tiles     device=device_1    tab=Shared lines    destination=Voicemail
    return to home screen    device_list=device_1
	Delete delegate from manage delegate    from_device=device_2    to_device=device_1
    navigate to shared lines tab    device=device_1
    verify shared line error message after removing delegate    device=device_1
	[Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    Add new delegates with both permission and validate   from_device=device_2    to_device=device_1
    
*** Keywords ***
Shared Line suite Setup
     Add new delegates with both permission and validate   from_device=device_2    to_device=device_1

Shared Line Suite Teardown
    Suite Failure Capture
    Delete delegate from manage delegate    from_device=device_2    to_device=device_1
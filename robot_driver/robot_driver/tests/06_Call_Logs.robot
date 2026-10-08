*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =      7

*** Test Cases ***
TC1 : [Calls] Adding contacts to favorites
    [Tags]  309289       bvt_pr    alt_credentials     bvt_tp    sanity_tp
    [Setup]  Run keywords   Testcase Setup    count=3   AND     Make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1  item=favorite
    Verify added favorite user in favorites page    from_device=device_1     to_device=device_2
    Make group call     from_device=device_1     to_device=device_2     new_participant=device_3
    Verify favorite icon should not display for group call   device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2 : [Calls] DUT user's call log in the recent tab entry displays the correct time stamp
    [Tags]  308303        bvt_pr  alt_credentials
    [Setup]    Testcase Setup    count=1
    click on calls tab   device=device_1
    Verify call history log    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3 : [Calls] DUT user's call log in the recent tab gets synced after receiving a missed call from TDC user
    [Documentation]  Devices are already signed-in in Suite Setup
    [Tags]  308301   bvt_tp  sanity_tp    bvt_pr  alt_bug
    [Setup]  Testcase Setup    count=2
    Make outgoing call for call log    from_device=device_2   to_device=device_1
    Verify call entries are synced in call log    from_device=device_1      to_device=device_2      state=missed
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2

TC4 : [Calls] Placeholder text and image should be properly visible when there is no favorite contact added
    [Tags]  318716       sanity_tp
    [Setup]   Testcase Setup    count=2
    navigate to calls favorites page    device=device_2
    remove favorite contacts from favorites tab  device=device_2
    verify favorite page when there are no favorite contacts      device=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_2

TC5 : [Calls] Verify that user can view the favorite contact profile using "View profile" icon in more option appear with contact image and presence
    [Tags]  318728    P2
    [Setup]   run keywords   Testcase Setup    count=2  AND   Make outgoing call for call log   from_device=device_2     to_device=device_1
    Select call list item   device=device_1  item=favorite
    Verify added favorite user in favorites page    from_device=device_1     to_device=device_2
    verify favorites user option    from_device=device_1     to_device=device_2
    verify view profile options in favorites page   from_device=device_1     to_device=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC6 : [Calls] Verify "Make a call" by tapping "+"from Favorites
    [Tags]  334089       sanity_tp
    [Setup]     Testcase Setup    count=1
    verify is portrait device       device=device_1
    navigate to calls favorites page    device=device_1
    verify options in make call icon    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC7 : [Calls] Verify Dialpad is displayed in Recent call tab
    [Tags]  334087    sanity_tp
    [Setup]     Testcase Setup    count=1
    verify is portrait device       device=device_1
    click on calls tab    device=device_1
    verify options in make call icon    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC8 : [Calls] Verify adding searched contact in People tab from make a call UI
    [Tags]  334092    P2        sanity_tp
    [Setup]     Testcase Setup    count=2
    verify is portrait device       device=device_1
    click on calls tab   device=device_1
    verify options in make call icon    device=device_1
    click back      device=device_1
    verify and navigate to call plus icon people tab    device=device_1
    verify search text     from_device=device_1    to_device=device_2       verify_make_a_call_people_tab=on
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC9 : [Calls] Verify outgoing call from DUT to TDC using Contact
    [Tags]  334101            sanity_tp
    [Setup]     Testcase Setup    count=2
    verify is portrait device       device=device_1
    verify and navigate to call plus icon people tab    device=device_1
    navigate to calls tab   device=device_1
    make outgoing call using from call icon     from_device=device_1    to_device=device_2
    verify outgoing call ui     device=device_1     state=connecting
    pick incoming call  device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify outgoing call ui     device=device_1     state=connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC10 : [Calls] Favorite contacts
    [Tags]      309292         Certification_audio     sanity_tp    bvt_tp      bvt_pr
    [Setup]  run keywords   Testcase Setup    count=2    AND    Make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1  item=favorite
    Verify favorites user option    from_device=device_1     to_device=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC11 : [Calls] DUT user's call log in the recent tab gets synced after receiving an incoming call from TDC user
    [Documentation]  Devices are already signed-in in Suite Setup
    [Tags]  308298   P1  alt_credentials
    [Setup]  run keywords  Testcase Setup    count=2    AND     Click on calls tab   device=device_1,device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Refresh calls main tab    device=device_1
    Verify call entries are synced in call log    from_device=device_1      to_device=device_2      state=duration
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2

TC12 : [Calls] Refreshing the screen for "favorites", "delegates" in Calls tab.
    [Tags]  310256    P3  alt_bug
    [Setup]    run keywords   Testcase Setup    count=2    AND    Make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1  item=favorite
    Verify favorites user option    from_device=device_1     to_device=device_2
    Verify delegates in favorites page     device=device_1
    Navigate to Calls Favorites page    device=device_2
    Verify favorite page when there are no delegate user added     device=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC13: [Calls] Verify Back button, tap to return to call and End button during P2P call.
    [Tags]      380093    P0   sanity_tp
    [Setup]  Testcase Setup    count=2
    click on calls tab      device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    click back    device=device_1
    tap to return to call   device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC14: [SLA] Verify Add your speed dial numbers message should display with retry button when Favorites tab does not have any content
    [Tags]      416760    P0    bvt_tp   sanity_tp
    [Setup]  Testcase Setup    count=2
    Navigate to Calls Favorites page    device=device_2
    Verify favorite page when there are no delegate user added     device=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND    come back home screen for user   count=2

TC15 : [SLA] Verify that DUT should display all the Speed Dial Contacts in a list under speed dial section in Favorites tab.
    [Tags]    416767    P1
    [Setup]  run keywords   Testcase Setup    count=3   AND     Make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1  item=favorite
    Make outgoing call for call log   from_device=device_1     to_device=device_3
    Select call list item   device=device_1  item=favorite
    verify added favorite user presence in favorites_page    from_device=device_1     to_device=device_2
    verify added favorite user presence in favorites page    from_device=device_1     to_device=device_3
    [Teardown]   Run Keywords    Capture on Failure  AND        Remove favorite user from favorites page    from_device=device_1     to_device=device_2    AND  Remove favorite user from favorites page    from_device=device_1     to_device=device_3   AND       come back home screen for user   count=3

TC16: [SLA] Verify that options present inside the triple dot(...) option beside each speed dial contacts
    [Tags]      416820    P2
    [Setup]  run keywords   Testcase Setup    count=2   AND     Make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1  item=favorite
    Verify added favorite user in favorites page    from_device=device_1     to_device=device_2
    verify favorites user option    from_device=device_1     to_device=device_2
    Calling from favorite page   from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Remove favorite user from favorites page    from_device=device_1     to_device=device_2     AND    come back home screen for user   count=2

TC17: [SLA] Verify that View Profile option should present inside the triple dot(...) beside of each speed dial contact
    [Tags]      416821    P2
    [Setup]  run keywords   Testcase Setup    count=2   AND     Make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1  item=favorite
    Verify added favorite user in favorites page    from_device=device_1     to_device=device_2
    verify favorites user option    from_device=device_1     to_device=device_2
    verify view profile options in favorites page   from_device=device_1     to_device=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND        Remove favorite user from favorites page    from_device=device_1     to_device=device_2     AND    come back home screen for user   count=2

TC18 : [SLA] Verify that DUT should display all the Speed Dial Contacts in a list under speed dial section in Favorites tab.
    [Tags]    416822    P1      sanity_tp
    [Setup]  run keywords   Testcase Setup    count=2   AND     Make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1  item=favorite
    verify added favorite user presence in favorites_page    from_device=device_1     to_device=device_2
    Remove favorite user from favorites page    from_device=device_1     to_device=device_2
    [Teardown]   Run Keywords    Capture on Failure   AND       come back home screen for user   count=2

TC19: [SLA] Verify that DUT user should display all the Boss's in a list under people you support section in Favorites tab.
    [Tags]      416765      P1
    [Setup]  Testcase Setup    count=3
    Add new delegates with both permission and validate   from_device=device_2    to_device=device_1
    Add new delegates with both permission and validate   from_device=device_3    to_device=device_1
    Navigate to Calls Favorites page    device=device_1
    favorites_module_sanity     device_list=device_1
    verify user in people you support with presence in favorites_page       from_device=device_1    to_device=device_2
    verify user in people you support with presence in favorites_page       from_device=device_1    to_device=device_3
    [Teardown]   Run Keywords    Capture on Failure  AND    Delete delegate from manage delegate   from_device=device_2    to_device=device_1   AND     Delete delegate from manage delegate   from_device=device_3    to_device=device_1       AND       come back home screen for user   count=3

TC20: [SLA] Verify that DUT doesn't show the entire section, if the user doesn't have any Delegates or People you support or favorites
    [Tags]      416817    P0    bvt_tp   sanity_tp
    [Setup]  run keywords   Testcase Setup  count=3   AND     Favorite user setup    from_device=device_2     to_device=device_3
    refresh calls main tab  device=device_2
    Add new delegates with both permission and validate   from_device=device_3    to_device=device_2
    Navigate to Calls Favorites page    device=device_2
    favorites_module_sanity     device_list=device_2
    Verify added favorite user in favorites page    from_device=device_2     to_device=device_3
    Verify favorite page when there are no delegate user added     device=device_2
    Delete delegate from manage delegate   from_device=device_3    to_device=device_2
    refresh calls main tab  device=device_2
    verify user in people you support page     from_device=device_2    to_device=device_3    user_presence=Absent
    Remove favorite user from favorites page    from_device=device_2     to_device=device_3
    refresh calls main tab  device=device_2
    verify favorite page when there are no favorite contacts      device=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND    Remove all delegates on device   devices=device_3   AND   come back home screen for user   count=3

TC21: [SLA] Verify DUT should display call delegation options if the current user is a delegate of any boss
    [Tags]      416830      sanity_tp
    [Setup]  Testcase Setup    count=3
    Favorite user setup    from_device=device_1     to_device=device_2
    Add new delegates with both permission and validate   from_device=device_2    to_device=device_1
    Add new delegates with both permission and validate   from_device=device_3    to_device=device_1
    Calling from favorite page      from_device=device_1      to_device=device_4    obo_option=device_3
    Verify calling behalf of device text    device=device_1  to_device=device_4    from_device=device_3
    Verify Incoming call    device=device_4     status=appear
    Verify on behalf of call text   device=device_4   from_device=device_1    obo_user=device_3
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_1,device_4    state=Connected
    verify call state and disconnect        device=device_4,device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Delete delegate from manage delegate   from_device=device_2    to_device=device_1        AND    Delete delegate from manage delegate   from_device=device_3    to_device=device_1       AND     Refresh calls main tab    device=device_1    AND       Remove favorite user from favorites page    from_device=device_1     to_device=device_2    AND    come back home screen for user   count=3

TC22: [SLA] Verify that triple dot (...) option should be present beside each contacts under Your delegates, People you support and Speed dial contacts in Favorites tab.
    [Tags]      416818      P2
    [Setup]  Testcase Setup   count=3
    Favorite user setup     from_device=device_1    to_device=device_2
    Favorite user setup     from_device=device_1    to_device=device_3
    Add new delegates with both permission and validate   from_device=device_2    to_device=device_1
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_3
    Navigate to Calls Favorites page    device=device_1
    favorites_module_sanity     device_list=device_1
    verify added delegate user with presence in favorites page      from_device=device_1    to_device=device_3
    verify user in people you support with presence in favorites_page       from_device=device_1    to_device=device_2
    Verify added favorite user in favorites page    from_device=device_1     to_device=device_2
    Verify added favorite user in favorites page    from_device=device_1     to_device=device_3
    [Teardown]   Run Keywords    Capture on Failure  AND    Remove favorite user from favorites page    from_device=device_1     to_device=device_2     AND     Delete delegate from manage delegate   from_device=device_1    to_device=device_3     AND     Delete delegate from manage delegate   from_device=device_2    to_device=device_1       AND     come back home screen for user   count=3

TC23: [SLA] Verify that DUT user should be able to collapse and expand each section by the arrow.
    [Tags]      416816      P0
    [Setup]  Testcase Setup    count=4
    Favorite user setup     from_device=device_1    to_device=device_4
    Add new delegates with both permission and validate   from_device=device_3    to_device=device_1
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_2
    Navigate to Calls Favorites page    device=device_1
    verify the functionality of collapse and expand button in favorites page    from_device=device_1    to_device=device_2      tab=delegate
    verify the functionality of collapse and expand button in favorites page    from_device=device_1    to_device=device_3      tab=people you support
    verify the functionality of collapse and expand button in favorites page    from_device=device_1    to_device=device_4      tab=speed dial
    [Teardown]   Run Keywords    Capture on Failure  AND    Remove favorite user from favorites page    from_device=device_1     to_device=device_4     AND     Delete delegate from manage delegate   from_device=device_3    to_device=device_1       AND     Delete delegate from manage delegate   from_device=device_1    to_device=device_2       AND     come back home screen for user   count=4

TC24 : [SLA]Verify DUT user is able to navigate back after enabling "Pick up held calls" toggle under delegate without saving the changes
    [Tags]      416764     P3
    [Setup]  Testcase Setup    count=2
    open settings page      device=device_1
    open manage delegate page    device=device_1
    Add new Delegate       from_device=device_1    to_device=device_2       action=discard
    [Teardown]   Run Keywords    Capture on Failure      AND      Come back to home screen    device_list=device_1,device_2

TC25 : [SLA]Verify DUT user is able to navigate back after enabling "join active calls" toggle under delegate without saving the change
    [Tags]      416724     P3
    [Setup]  Testcase Setup    count=2
    open settings page      device=device_1
    open manage delegate page    device=device_1
    Add new Delegate       from_device=device_1    to_device=device_2       action=discard
    [Teardown]   Run Keywords    Capture on Failure      AND      Come back to home screen    device_list=device_1,device_2

TC26 : [Calls] DUT user's call log in the recent tab entry displays group name and unnamed group in the call entry with the participants list.
   [Tags]      308307
   [Setup]  Run keywords   Testcase Setup    count=3   AND     Make group call    from_device=device_1     to_device=device_2     new_participant=device_3
   Select call list item   device=device_1  item=View Profile
   Verify group call participant details in contact card page    device=device_1   device_list=device_2,device_3
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC27 : [Manage Delegates] [SLA] Hold call banner should display to Boss as well as DUT, when DUT place any call on hold on behalf of Boss
    [Tags]    321034    Sanity_TP
    [Setup]    Run Keywords    Testcase Setup    count=4    AND    Clear Notification From Home Screen    device=device_2      #clear notification added to check in homescreen
    Add New Delegates With Both Permission And Validate    from_device=device_2    to_device=device_1
    Make OBO Call And Verify Text    from_device=device_1    to_device=device_3    obo_option=device_2
    Hold The Call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Hold
    Verify Call Hold Banner    from_device=device_1    to_device=device_3
    Verify Call Hold Banner    from_device=device_2    to_device=device_3
    Make OBO Call And Verify Text    from_device=device_1    to_device=device_4    obo_option=device_2
    Hold The Call    device=device_1
    Verify Call State    device_list=device_1,device_4    state=Hold
    Verify Multiple Calls On Hold In Banner    from_device=device_1    to_device=device_3,device_4
    Verify Multiple Calls On Hold In Banner    from_device=device_2    to_device=device_3,device_1    current_device=boss
    Resume The Call and Disconnect    from_device=device_1    to_device=device_3
    Resume The Call And Disconnect    from_device=device_1    to_device=device_4
    Make OBO Call And Verify Text    from_device=device_1    to_device=device_3    obo_option=device_2
    Hold The Call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Hold
    Verify Call Hold Banner    from_device=device_1    to_device=device_3
    Verify Call Hold Banner    from_device=device_2    to_device=device_3
    Make OBO Call And Verify Text    from_device=device_1    to_device=device_4    obo_option=device_2
    Hold The Call    device=device_1
    Verify Call State    device_list=device_1,device_4    state=Hold
    Verify Multiple Calls On Hold In Banner    from_device=device_1    to_device=device_3,device_4
    Verify Multiple Calls On Hold In Banner    from_device=device_2    to_device=device_3,device_1    current_device=boss
    Resume The Call And Disconnect    from_device=device_2    to_device=device_3
    Resume The Call And Disconnect    from_device=device_2    to_device=device_4
    [Teardown]    Run Keywords    Capture On Failure    AND    Delete Delegate From Manage Delegate    from_device=device_2    to_device=device_1

*** Keywords ***
Make group call
    [Arguments]     ${from_device}   ${to_device}   ${new_participant}
    Navigate to calls tab   device=${from_device}
    Make outgoing call using display name    from_device=${from_device}      to_device=${to_device}
    Pick incoming call    device=${to_device}
    Verify Call State   device_list=${from_device},${to_device}   state=Connected
    Add participant to conversation using display name   from_device=${from_device}      to_device=${new_participant}
    Pick incoming call    device=${new_participant}
    Wait for Some Time    time=${wait_time}
    Verify Call State   device_list=${from_device},${to_device},${new_participant}    state=Connected
    Disconnect call     device=${from_device},${to_device}
    Verify Call State   device_list=${from_device},${to_device},${new_participant}    state=Disconnected
    return to home screen  device_list=${from_device}
    click on calls tab   device=${from_device}
    Refresh calls main tab    device=${from_device}

Make outgoing call for call log
    [Arguments]     ${from_device}   ${to_device}
    Navigate to calls tab   device=${from_device}
    Make outgoing call using display name    from_device=${from_device}      to_device=${to_device}
    Verify Incoming call    device=${to_device}     status=appear
    Disconnect call     device=${from_device}
    Verify Incoming call    device=${to_device}     status=disappear
    Verify Call State    device_list=${from_device}     state=Disconnected
    return to home screen  device_list=${from_device}
    click on calls tab   device=${from_device}
    Refresh calls main tab    device=${from_device}

Favorite user setup
    [Arguments]     ${from_device}   ${to_device}
    make outgoing call for call log     from_device=${from_device}      to_device=${to_device}
    Select call list item   device=${from_device}     item=favorite
    Verify added favorite user in favorites page    from_device=${from_device}     to_device=${to_device}

Make OBO Call and Verify Text
    [Arguments]    ${from_device}    ${to_device}    ${obo_option}
    Initiate OBO Call Using Display Name    from_device=${from_device}    to_device=${to_device}    obo_option=${obo_option}
    Verify Calling Behalf Of Device Text    device=${from_device}    to_device=${to_device}    from_device=${obo_option}
    Verify On Behalf Of Call Text    device=${to_device}    from_device=${from_device}    obo_user=${obo_option}
    Pick Incoming Call    device=${to_device}
    Verify Call State    device_list=${from_device},${to_device}    state=Connected

Resume The Call and Disconnect
    [Arguments]    ${from_device}    ${to_device}
    Resume The Call    device=${from_device}
    Verify Call State    device_list=${from_device},${to_device}    state=Resume
    Disconnect Call    device=${from_device}
    Verify Call State    device_list=device_3    state=Disconnected
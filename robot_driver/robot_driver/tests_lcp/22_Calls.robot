*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture


*** Test Cases ***
TC1: [Calls] Remove contacts from favorites
    [Tags]  452577    sanity_lcp
    [Setup]  Run keywords   Testcase Setup    count=2   AND     Make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1  item=favorite
    Verify added favorite user in favorites page    from_device=device_1     to_device=device_2
    Remove favorite user from favorites page    from_device=device_1     to_device=device_2
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2: Verify favorite contacts are retained after re-sign in with same user
    [Tags]  452607    sanity_lcp
    [Setup]  Run keywords   Testcase Setup    count=2   AND     Make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1  item=favorite
    Sign out  device_list=device_1
    signin method for lcp   device=device_1
    Verify added favorite user in favorites page    from_device=device_1     to_device=device_2
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3: [Calls] DUT user's call log in the recent tab gets synced after receiving a missed call from TDC user
    [Documentation]  Devices are already signed-in in Suite Setup
    [Tags]  243595      bvt_lcp    sanity_lcp
    [Setup]  Testcase Setup    count=2
    Make outgoing call for call log    from_device=device_2   to_device=device_1
    Verify call entries are synced in call log    from_device=device_1      to_device=device_2      state=missed
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC4 : [Calls] Favorites & Recent tabs
    [Tags]      452570
    [Setup]    Testcase Setup    count=1
    Click on calls tab   device=device_1
    Verify call history log    device=device_1
    Navigate to Calls Favorites page    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC5: [Calls] Favorite contacts
    [Tags]      452573
    [Setup]  run keywords   Testcase Setup    count=2    AND    Make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1  item=favorite
    Verify favorites user option    from_device=device_1     to_device=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC6: [Calls] Adding contacts to favorites via TDC should reflect on DUT
    [Tags]  452582
    [Setup]  Run keywords   Testcase Setup    count=2   AND     Make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1  item=favorite
    Verify added favorite user in favorites page    from_device=device_1     to_device=device_2
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC7: [Calls] Refreshing the screen for "favorites", "delegates" in Calls tab.
    [Tags]  452589
    [Setup]    run keywords   Testcase Setup    count=2    AND    Make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1  item=favorite
    Verify favorites user option    from_device=device_1     to_device=device_2
    Verify delegates in favorites page     device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC8: [Calls] Access contact profile from Recent
    [Tags]  452580
    [Setup]     run keywords   Testcase Setup    count=2   AND  Make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1  item=view profile
    Verify contact card page and call   device=device_1
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC9 : [Calls] Access contact profile from favorites
    [Tags]      452578
    [Setup]   run keywords    Testcase Setup    count=2    AND   Make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1  item=favorite
    Verify added favorite user in favorites page    from_device=device_1     to_device=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC10: [Calls] Placeholder text and image should be properly visible when there is no favorite contact added
    [Tags]  452590
    [Setup]   Testcase Setup    count=2
    navigate to calls favorites page    device=device_2
    remove favorite contacts from favorites tab  device=device_2
    verify favorite page when there are no favorite contacts      device=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_2

TC11 : [Calls] DUT user's call log in the recent tab gets synced after receiving an incoming call from TDC user
    [Tags]  243593
    [Setup]  Testcase Setup    count=2
    navigate to people tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    navigate to calls tab   device=device_1
    Refresh calls main tab    device=device_1
    Verify call entries are synced in call log    from_device=device_1      to_device=device_2      state=duration
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2

TC12: [Calls] DUT user's call log in the recent tab gets synced after making an outbound call to TDC user
    [Tags]  243594
    [Setup]  Testcase Setup    count=2
    navigate to people tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Come back to home screen   device_list=device_1
    navigate to calls tab   device=device_1
    Refresh calls main tab    device=device_1
    Verify call entries are synced in call log    from_device=device_1      to_device=device_2      state=duration
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2

TC13 : [Calls] Calling from Recent tab
    [Tags]  243944
    [Setup]     run keywords   Testcase Setup    count=2   AND     Make outgoing call for call log   from_device=device_1     to_device=device_2
    Navigate to calls tab   device=device_1
    Call first participant from log    device=device_1
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC14 : [Calls] Verify Back button, tap to return to call and End button during P2P call.
    [Tags]    380097    bvt_lcp   sanity_lcp
    [Setup]    Testcase Setup    count=2
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    click back    device=device_1
    tap to return to call   device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    navigate to people tab   device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    click back    device=device_1
    tap to return to call   device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC15: [Calls] Adding contacts to favorites
   [Tags]  314016    bvt_lcp    sanity_lcp
   [Setup]  Run keywords   Testcase Setup    count=3   AND     Make outgoing call for call log   from_device=device_1     to_device=device_2
   Select call list item   device=device_1  item=favorite
   Verify added favorite user in favorites page    from_device=device_1     to_device=device_2
   Make group call     from_device=device_1     to_device=device_2     new_participant=device_3
   Verify favorite icon should not display for group call   device=device_1
   [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC16 : [Calls] DUT user's call log in the recent tab entry displays the correct time stamp
    [Tags]      243596
    [Setup]    Testcase Setup    count=1
    click on calls tab   device=device_1
    Verify call history log    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC17: [Calls] Calling from favorites tab
   [Tags]      243940    bvt_lcp    sanity_lcp
   [Setup]  Run keywords   Testcase Setup    count=2   AND     Make outgoing call for call log   from_device=device_1     to_device=device_2
   Select call list item   device=device_1  item=favorite
   Calling from favorite page   from_device=device_1     to_device=device_2
   Pick incoming call    device=device_2
   Verify Call State    device_list=device_1,device_2    state=Connected
   Disconnect call     device=device_2
   Verify Call State    device_list=device_1,device_2     state=Disconnected
   [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

*** Keywords ***
Make outgoing call for call log
    [Arguments]     ${from_device}   ${to_device}
    navigate to people tab   device=${from_device}
    Make outgoing call using display name    from_device=${from_device}      to_device=${to_device}
    Verify Incoming call    device=${to_device}     status=appear
    Disconnect call     device=${from_device}
    Verify Incoming call    device=${to_device}     status=disappear
    Verify Call State    device_list=${from_device}     state=Disconnected
    return to home screen  device_list=${from_device}
    click on calls tab   device=${from_device}
    Refresh calls main tab    device=${from_device}

Make group call
    [Arguments]     ${from_device}   ${to_device}   ${new_participant}
    navigate to people tab   device=${from_device}
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
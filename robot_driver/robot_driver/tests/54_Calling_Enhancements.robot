*** Settings ***
Documentation   Device_4:User should assign secondary contact number of Device_3:User as prerequisite before test execution
...                AND  Device_3:pstn_user should assign secondary contact number of Device_2:pstn_user
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***

*** Test Cases ***
TC1: Delegate should able to Call the Call Work/ Call mobile/ Call home number from option present inside the more info icon of the Boss in People you support section.
     [Tags]   453041
     [Setup]  run keywords   Testcase Setup    count=4    AND    Add new delegates with both permission and validate   from_device=device_4    to_device=device_1
     click on calls tab  device=device_4
     Make outgoing call using display name    from_device=device_4      to_device=device_2
     Pick incoming call    device=device_2
     Verify Call State    device_list=device_2,device_4    state=Connected
     Navigate to Calls Favorites page    device=device_1
     refresh calls main tab    device=device_1
     verify and join call using join button with boss   from_device=device_1      to_device=device_4     option=verify
     verify and make call from people you support when DID is configured   from_device=device_1      to_device=device_4   to_device_contact_number=device_3    call_option=call_work
     Pick incoming call    device=device_3
     Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Connected
     Disconnect call     device=device_3
     verify call state and disconnect    device=device_1,device_2,device_3,device_4
     [Teardown]  run keywords  Capture on Failure   AND     come back home screen for user   count=4   AND     Delete delegate from manage delegate    from_device=device_4    to_device=device_1

TC2: Verify the options present inside More info icon for the contact who is having Multiple Secondary Contact numbers in Recent tab.
     [Tags]  453026    P1
     [Setup]   run keywords   Testcase Setup    count=4   AND    make outgoing call for call log     from_device=device_1      to_device=device_4
     verify call list details for user when DID is configured    from_device=device_1    to_device=device_3   call_options=["call_work", "call_mobile"]
     [Teardown]  run keywords  Capture on Failure   AND     come back home screen for user   count=4

TC3: Verify the options present inside triple dot on speed dial contact
     [Tags]  452907   P1
     [Setup]  Run keywords   Testcase Setup    count=4   AND     make outgoing call for call log   from_device=device_1     to_device=device_4
     Select call list item   device=device_1   item=favorite
     verify call list details from speed dial for user when DID is configured   from_device=device_1    to_device=device_4   to_device_contact_number=device_3  call_options=["call_work", "call_mobile"]
     [Teardown]  run keywords  Capture on Failure     AND     Remove favorite user from favorites page    from_device=device_1     to_device=device_4     AND     come back home screen for user   count=4

TC4: Verify Boss user able to see the Call Work,Call Home and Call Mobile option should present inside the more info icon of the delegates in Delegation section when delegate ongoing call on behalf of boss is in progress.
     [Tags]   453037    P2
     [Setup]  run keywords   Testcase Setup    count=4    AND    Add new delegates with both permission and validate   from_device=device_1    to_device=device_4
     click on calls tab  device=device_4
     Initiate OBO call using display name    from_device=device_4      to_device=device_2    obo_option=device_1
     Pick incoming call    device=device_2
     Verify Call State    device_list=device_2,device_4    state=Connected
     Navigate to Calls Favorites page    device=device_1
     verify and join call using join button with boss   from_device=device_1      to_device=device_4     option=verify
     verify call list details from your delegates for user when DID is configured    from_device=device_1      to_device=device_4   to_device_contact_number=device_3     call_options=["call_work", "call_mobile"]
     [Teardown]  run keywords  Capture on Failure    AND    come back home screen for user   count=4    AND    Delete delegate from manage delegate    from_device=device_1    to_device=device_4

TC5: Verify the options present inside more info icon who is not having Multiple Secondary Contact numbers in Recent tab.
     [Tags]   453030    P2
     [Setup]  run keywords   Testcase Setup    count=2   AND    make outgoing call for call log     from_device=device_1      to_device=device_2
     verify call list details for user when DID is not configured    device=device_1
     [Teardown]  run keywords  Capture on Failure   AND     come back home screen for user   count=2

TC6: Verify the options present inside triple dot on speed dial contact who is not having Multiple Seconady Contact numbers in Favorites tab.
     [Tags]  453025    P2
     [Setup]  Run keywords   Testcase Setup    count=2   AND     Make outgoing call for call log   from_device=device_1     to_device=device_2
     Select call list item   device=device_1   item=favorite
     verify call list details from speed dial for user when DID is not configured     from_device=device_1      to_device=device_2
     [Teardown]  run keywords  Capture on Failure     AND     Remove favorite user from favorites page    from_device=device_1     to_device=device_2     AND     come back home screen for user   count=2

TC7: Boss should able to Call the Call Work/Call Home/Call Mobile number from option present inside the more info icon of the delegates in Delegation section.
     [Tags]   453039    P1   sanity_tp
     [Setup]  run keywords   Testcase Setup    count=4    AND    Add new delegates with both permission and validate   from_device=device_1    to_device=device_4
     click on calls tab  device=device_4
     Initiate OBO call using display name    from_device=device_4      to_device=device_2     obo_option=device_1
     Pick incoming call    device=device_2
     Verify Call State    device_list=device_2,device_4    state=Connected
     Navigate to Calls Favorites page    device=device_1
     refresh calls main tab    device=device_1
     verify and join call using join button with boss   from_device=device_1      to_device=device_4     option=verify
     verify and make call from your delegates when DID is configured  from_device=device_1      to_device=device_4   to_device_contact_number=device_3    call_option=call_work
     Pick incoming call    device=device_3
     Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Connected
     Disconnect call     device=device_3
     verify call state and disconnect    device=device_1,device_2,device_3,device_4
     [Teardown]  run keywords  Capture on Failure   AND     come back home screen for user   count=4   AND     Delete delegate from manage delegate    from_device=device_1    to_device=device_4

TC8: DUT user able to view and initiate a call with Work number,Mobile phone number and Home phone number, when user search the contact who is having multiple secondary contact number
     [Tags]   453035    P1
     [Setup]    Testcase Setup    count=4
     navigate to calls tab  device=device_1
     validate when user search for a contact in search result when secondary contact is added   from_device=device_1      to_device=device_4   to_device_contact_number=device_3
     dial configured secondary number    from_device=device_1      to_device=device_4   to_device_contact_number=device_3   call_option=work_phone
     Pick incoming call    device=device_3
     Verify Call State    device_list=device_1,device_3    state=Connected
     verify call state and disconnect    device=device_1,device_4
     navigate to people tab      device=device_1
     validate when user search for a contact in search result when secondary contact is added   from_device=device_1      to_device=device_4   to_device_contact_number=device_3
     dial configured secondary number    from_device=device_1      to_device=device_4   to_device_contact_number=device_3   call_option=work_phone
     Pick incoming call    device=device_3
     Verify Call State    device_list=device_1,device_3    state=Connected
     verify call state and disconnect    device=device_1,device_4
     Navigate to calendar tab    device=device_1
     validate when user search for a contact in search result when secondary contact is added   from_device=device_1      to_device=device_4   to_device_contact_number=device_3
     dial configured secondary number    from_device=device_1      to_device=device_4   to_device_contact_number=device_3   call_option=work_phone
     Pick incoming call    device=device_3
     Verify Call State    device_list=device_1,device_3    state=Connected
     Disconnect call     device=device_1
     verify call state and disconnect    device=device_1,device_4
     [Teardown]  run keywords  Capture on Failure   AND     come back home screen for user   count=4

TC9: Verify DUT should initiate a PSTN call when DUT user tap on Call work number from Recent tab.
     [Tags]   453027   P1
     [Setup]   Run keywords     Testcase Setup     count=4    AND     make outgoing call for call log   from_device=device_1     to_device=device_4
     verify and make call for recent call from recent tab when DID is configured    from_device=device_1      to_device=device_4    to_device_contact_number=device_3    call_option=call_work
     Pick incoming call    device=device_3
     Verify Call State    device_list=device_1,device_3    state=Connected
     Disconnect call     device=device_1
     verify call state and disconnect    device=device_1,device_3
     [Teardown]  run keywords  Capture on Failure   AND     come back home screen for user   count=4

TC10: Verify placing calls using the call option present inside triple dot on speed dial contact
    [Tags]  451562     bvt_tp
    [Setup]   Testcase Setup    count=2
    Calling from favorite page      from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]    Run keywords    Capture on Failure    AND     come back home screen for user   count=2

TC11: Verify DUT should initiate a PSTN call when DUT user tap on Call Mobile number from Recent tab.
     [Tags]      453028    bvt_pr
     [Setup]   Run keywords     Testcase Setup     count=4    AND     make outgoing call for call log   from_device=device_1     to_device=device_4
     verify and make call for recent call from recent tab when DID is configured    from_device=device_1      to_device=device_4    to_device_contact_number=device_3    call_option=call_mobile
     Pick incoming call    device=device_3
     Verify Call State    device_list=device_1,device_3    state=Connected
     Disconnect call     device=device_1
     verify call state and disconnect    device=device_1,device_3
     [Teardown]  run keywords  Capture on Failure   AND     come back home screen for user   count=4

TC12: Verify the call option present inside info menu on recent call.
    [Tags]  451558      P0      tp_audio     bvt_tp
    [Setup]   Run keywords     Testcase Setup     count=2    AND     make outgoing call for call log   from_device=device_1     to_device=device_2
    verify call list details for user when DID is not configured     device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC13: Verify the "work" options present inside info menu on recent call.
    [Tags]  451556      P0      tp_audio         bvt_tp
    [Setup]   Run keywords     Testcase Setup     count=2    AND     make outgoing call for call log   from_device=device_1     to_device=device_2
    verify call list details for user when DID is configured     from_device=device_1    to_device=device_2     call_options=["call_work"]
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC14: Verify the call option present inside triple dot on speed dial contact.
    [Tags]  451554      P0      tp_audio    bvt_tp
    [Setup]   Run keywords     Testcase Setup     count=2    AND     make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1   item=favorite
    verify call list details from speed dial for user when DID is not configured     from_device=device_1      to_device=device_2
    [Teardown]  run keywords  Capture on Failure     AND     Remove favorite user from favorites page    from_device=device_1     to_device=device_2     AND     come back home screen for user   count=2
   
TC15: Verify the "work" option present inside triple dot on speed dial contact.
    [Tags]  451552      P0      tp_audio    bvt_tp
    [Setup]   Run keywords     Testcase Setup     count=2    AND     make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1   item=favorite
    verify call list details from speed dial for user when DID is configured     from_device=device_1      to_device=device_2    to_device_contact_number=device_2   call_options=["call_work"]
    [Teardown]  run keywords  Capture on Failure     AND     Remove favorite user from favorites page    from_device=device_1     to_device=device_2     AND     come back home screen for user   count=2

TC16: Verify the "work" and "mobile" options present inside triple dot on speed dial contact.
    [Tags]  451471      tp_audio
    [Setup]   Run keywords     Testcase Setup     count=2    AND     make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1   item=favorite
    verify call list details from speed dial for user when DID is configured     from_device=device_1      to_device=device_2    to_device_contact_number=device_2   call_options=["call_work", "call_mobile"]
    [Teardown]  run keywords  Capture on Failure     AND     Remove favorite user from favorites page    from_device=device_1     to_device=device_2     AND     come back home screen for user   count=2

*** Keywords ***
make outgoing call for call log
    [Arguments]     ${from_device}   ${to_device}
    navigate to calls tab  device=${from_device}
    Make outgoing call using display name    from_device=${from_device}      to_device=${to_device}
    Verify Incoming call    device=${to_device}     status=appear
    Disconnect call     device=${from_device}
    Verify Incoming call    device=${to_device}     status=disappear
    Verify Call State    device_list=${from_device}     state=Disconnected
    Navigate to calls tab   device=${from_device}
    Refresh calls main tab    device=${from_device}
*** Settings ***
Library     DateTime
Resource    ../resources/keywords/common.robot
Documentation      Suite Setup Requirements : This suite requires minimum of 4 devices in config
...                Purpose: Device_4 should be added as a favorite on Device_1 from recent call history

Suite Setup      Speed dial Setup
Suite Teardown     Run Keywords    Suite Failure Capture    AND   Speed dial Teardown


*** Test Cases ***
TC1: Verify DUT should initialte a call when DUT user tap on Call Mobile number from Favorites tab.
     [Tags]      452911
     [Setup]  Testcase Setup     count=4
     verify and make call from speed dial when DID is configured  device=device_1   to_device=device_4   to_device_contact_number=device_3   call_option=call_mobile
     Pick incoming call    device=device_3
     Verify Call State    device_list=device_1,device_3    state=Connected
     Disconnect call     device=device_3
     Verify Call State    device_list=device_1,device_3     state=Disconnected
     [Teardown]  run keywords  Capture on Failure    AND    come back home screen for user   count=4

TC2: Verify DUT should navigate to Contact card of the user,when user tap on view profile option from favorites
     [Tags]      453023        sanity_tp    bvt_pr
     [Setup]  Testcase Setup    count=2
     Navigate to calls tab    device=device_1
     verify call list details from speed dial for user when DID is configured   from_device=device_1    to_device=device_4   to_device_contact_number=device_3  call_options=["call_work", "call_mobile"]
     verify view profile options in favorites page   from_device=device_1    to_device=device_4
     [Teardown]  run keywords   Capture on Failure    AND    come back home screen for user   count=2

TC3: Verify DUT should initiate a Voicemail call, when user tap on Leave voicemail option in Favorites tab.
     [Tags]      453024        sanity_tp 
     [Setup]  Testcase Setup    count=4
     Navigate to calls tab    device=device_1
     verify call list details from speed dial for user when DID is configured   from_device=device_1    to_device=device_4   to_device_contact_number=device_3  call_options=["call_work", "call_mobile"]
     verify and click leave voice option in favorites page  from_device=device_1    to_device=device_4
     Wait for Some Time    time=10s
     Navigate to voicemail tab    device=device_4
     refresh the page    device=device_4
     Play multiple voicemail from list     on_device=device_4    from_device=device_1
     [Teardown]  run keywords   Capture on Failure    AND    come back home screen for user   count=4

TC4: Verify DUT should initialte a PSTN call when DUT user tap on Call work number from Favorites tab.
     [Tags]  452910   P1
     [Setup]  Testcase Setup     count=4
     verify and make call from speed dial when DID is configured  device=device_1   to_device=device_4   to_device_contact_number=device_3   call_option=call_work
     Pick incoming call    device=device_3
     Verify Call State    device_list=device_1,device_3    state=Connected
     Disconnect call     device=device_3
     Verify Call State    device_list=device_1,device_3     state=Disconnected
     [Teardown]  run keywords  Capture on Failure    AND    come back home screen for user   count=4

TC5: Verify DUT should initialte a call when DUT user tap on Call option.
     [Tags]  452909   P2
     [Setup]  Testcase Setup     count=4
     Navigate to calls tab    device=device_1
     verify call list details from speed dial for user when DID is configured   from_device=device_1    to_device=device_4   to_device_contact_number=device_3  call_options=["call_work", "call_mobile"]
     Calling from favorite page   from_device=device_1     to_device=device_4
     Pick incoming call    device=device_4
     Verify Call State    device_list=device_1,device_4    state=Connected
     Disconnect call     device=device_1
     Verify Call State    device_list=device_1,device_4     state=Disconnected
     [Teardown]  run keywords  Capture on Failure    AND    come back home screen for user   count=4

TC6: Verify the options present inside the triple dot for PSTN user who is having Multiple Secondary Contact numbers in Favorites tab
     [Tags]  453034   sanity_tp
     [Setup]  Testcase Setup     count=4
     Navigate to calls tab    device=device_1
     verify call list details from speed dial for user when DID is configured   from_device=device_1    to_device=device_4   to_device_contact_number=device_3  call_options=["call_work", "call_mobile"]
     [Teardown]  run keywords  Capture on Failure    AND    come back home screen for user   count=4

TC7: Verify the options present inside more info icon for PSTN user who is having Multiple Secondary Contact numbers in Recent tab.
     [Tags]  453033   P1
     [Setup]    run keywords   Testcase Setup    count=4   AND    make outgoing call for call log     from_device=device_1      to_device=device_4
     verify call list details for user when DID is configured    from_device=device_1    to_device=device_3   call_options=["call_work", "call_mobile"]
     [Teardown]  run keywords  Capture on Failure   AND     come back home screen for user   count=4

*** Keywords ***
Speed dial Setup
     make outgoing call for call log   from_device=device_1     to_device=device_4
     Select call list item   device=device_1   item=favorite

Speed dial Teardown
     Remove favorite user from favorites page    from_device=device_1     to_device=device_4


make outgoing call for call log
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
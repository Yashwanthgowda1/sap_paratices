*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10
${wait_time2} =  25
${action_time} =  3
${15_minutes_wait_time} =  15 minutes
${10_minutes_wait_time} =  10 minutes

*** Test Cases ***
TC1 : [Incoming Calls] TDC user receives call from DUT using DID
    [Tags]   305782   P0     bvt_tpc     sanity_tpc
    [Setup]   Testcase Setup for Meeting User    count=2
    click on calls tab     device=device_2
    Make outgoing call using phonenumber   from_device=device_2     to_device=device_1:meeting_user
    Verify display name on call toast   to_device=device_1    from_device=device_2
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2

TC2 : [Incoming Calls] DUT user rejects the incoming call from TDC user
    [Tags]  305785   sanity_tpc  P1
    [Setup]  Testcase Setup for Meeting User    count=2
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:meeting_user
    Rejects the incoming call   device_list=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_2

TC3 : [Incoming Calls] TDC user calls to DUT user which is set to "DND"
    [Tags]    305786       bvt_tpc     sanity_tpc
    [Setup]  run keywords   Testcase Setup for Meeting User    count=2   AND  check presence feature   device=device_1     state=Available  AND  Select user presence   device=device_1     state=DND
    check presence feature  device=device_1     state=Available
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:meeting_user
    Verify Incoming call    device=device_1     status=Disappear
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND  check presence feature  device=device_1     state=Available  AND   Select user presence     device=device_1     state=Available    AND    Come back to home screen    device_list=device_1,device_2

TC4 : [Incoming Calls] DUT user receives call from TDC.
    [Tags]     305919
    [Setup]  Testcase Setup for Meeting User    count=2
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify name of caller and receiver displayed    from_device=device_2      to_device=device_1:meeting_user
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_2

TC5 : [Incoming Calls] DUT user to answer second incoming call
    [Tags]  305882    bvt_tpc    sanity_tpc  P0
    [Setup]  Testcase Setup for Meeting User    count=3
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2     state=Hold
    Disconnect call     device=device_2,device_3
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_2,device_3

TC6 : [Incoming Calls] DUT user to receive the call when UI view is in Device settings
    [Tags]  305912    P0     bvt_tpc     sanity_tpc
    [Setup]  Testcase Setup for Meeting User    count=2
    Opens partner settings page     device=device_1
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    [Teardown]   Run Keywords    Capture on Failure   AND    device setting back    device=device_1   AND   Come back to home screen    device_list=device_1,device_2    AND    Verify Call State    device_list=device_1,device_2     state=Disconnected

TC7 :[Incoming Calls] TDC user hangs up the call before DUT user picks up
    [Tags]       305784
    [Setup]  Testcase Setup for Meeting User     count=2
    click on calls tab     device=device_2
    Make outgoing call using display name   from_device=device_2     to_device=device_1:meeting_user
    Verify display name on call toast   to_device=device_1    from_device=device_2
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    verify home screen for cnf device    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2

TC8 :[Incoming Call] DUT user must be able to pick the incoming call on "Admin Only (Enter Password)"
    [Tags]  320266  P2
    [Setup]  Testcase Setup for Meeting User  count=2
    verify admin pwd field  device=device_1
    click on calls tab     device=device_2
    Make outgoing call using display name  from_device=device_2    to_device=device_1:meeting_user
    pick incoming call  device=device_1
    disconnect call  device=device_1
    Verify Call State   device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords   Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC9 : [Incoming Calls] DUT user to reject the call when UI view is in Device settings
    [Tags]  341835    P2
    [Setup]   Testcase Setup for Meeting User    count=2
    Opens partner settings page     device=device_1
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:meeting_user
    verify incoming call    device=device_1      status=appear
    Rejects the incoming call   device_list=device_1
    verify call state and disconnect  device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND    device setting back    device=device_1   AND   Come back to home screen    device_list=device_1,device_2

TC10 :[Auto Dial][Calling] To verify call auto-dial on entering the less than 5-digits of extension number
    [Tags]  320981  P2
    [Setup]  Testcase Setup for Meeting User  count=2
    auto dial edited valid num from dial pad  from_device=device_1    to_device=device_2
    [Teardown]   Run Keywords   Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC11 :[Auto Dial][Calling]To verify call auto-dial on entering the full extension number
    [Tags]  320986  P2
    [Setup]  Testcase Setup for Meeting User  count=2
    auto dial with valid num from dial pad  from_device=device_1    to_device=device_2
    pick incoming call  device=device_2
    disconnect call  device=device_1
    Verify Call State   device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords   Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC12 : [Outgoing Calls] DUT user call is rejected by TDC
    [Tags]   306053  sanity_tpc  P1
    [Setup]   Testcase Setup for Meeting User   count=2
    Navigate to people tab    device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2
    Rejects the incoming call    device_list=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC13 : [Outgoing Calls] DUT user calls TDC user for which VM is enabled and VM is disabled
    [Tags]  318560     P2
    [Setup]  Testcase Setup for Meeting User     count=2
    enable unanswered call to voicemail     from_device=device_2   contact_device=device_1:meeting_user
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    verify incoming call   device=device_2   status=appear
    wait for some time      time=${wait_time2}
    verify call state   device_list=device_1    state=connected
    verify call state   device_list=device_2    state=disconnected
    disconnect call     device=device_1
    Disable unanswered call    device=device_2      contact_device=device_1:meeting_user
    go back to previous page   device=device_1
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    verify incoming call   device=device_2   status=appear
    disconnect call     device=device_1
    verify call state   device_list=device_1,device_2    state=disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2

TC14 : [Outgoing Calls] DUT user to make 2nd call
    [Tags]  306054     bvt_tpc   sanity_tpc  P0
    [Setup]  Testcase Setup for Meeting User    count=3
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Come back to home screen    device_list=device_1    disconnect=False
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2     state=Hold
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC15: [Outgoing Calls] Call controls during the call
    [Tags]   306055  sanity_tpc  P1
    [Setup]  Testcase Setup for Meeting User    count=2
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify call control visibility    device_list=device_1,device_2
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2

TC16 : [Outgoing Calls] User to test soft key dial Pad
    [Tags]   306057  sanity_tpc  P1
    [Setup]  Testcase Setup for Meeting User    count=1
    Dial and verify the numbers from 0 to 9    device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    click_close_btn    device_list=device_1

TC17 : [Outgoing Calls] DUT user cancel the outgoing call with TDC
    [Tags]  306052   P2
    [Setup]  Testcase Setup for Meeting User    count=2
    Navigate to people tab    device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
Disable Call forward
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    verify and disable call forwarding    device=device_3

Unanswered call Teardown
    [Arguments]     ${devices}
    Come back to home screen     ${devices}
    Disable unanswered call    device=device_1      contact_device=device_2

Test Case Teardown
    [Arguments]     ${devices}
    Come back to home screen     ${devices}
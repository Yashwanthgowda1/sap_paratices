*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown   Run Keywords   Suite Failure Capture   AND    auto dismiss suite teardown    device=device_1

*** Variables ***
${wait_time} =  10
${5m_wait_time} =  5 minutes

*** Test Cases ***
TC1 : [Auto Dismiss] Rating screen should be dismissed automatically if the user does not submit the rating within 5 seconds
    [Tags]   306042     P2
    [Setup]  Testcase Setup for Meeting User    count=2
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Wait for Some Time    time=${5m_wait_time}
    Disconnect call and verify call rating screen     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : [Auto Dismiss] Verify call decline screen auto dismissed within seconds
    [Tags]   306044  sanity_tpc  P1
    [Setup]   Run Keywords    Testcase Setup for Meeting User     count=2    AND    Disable unanswered call    device=device_2      contact_device=device_1
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Rejects the incoming call   device_list=device_2
    Verify call decline screen  device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3 : [Auto Dismiss] Verify that “Dismiss Rate My Call” option with toggle is present in "User survey settings".
    [Tags]  320208      P2
    [Setup]  Testcase Setup for Meeting User    count=1
    navigate to user survey for conf    device=device_1
    verify dismiss rate my call toggle    device=device_1       toggle=off
    come back to home screen from calling settings for conf   device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen        device_list=device_1

TC4 : [Auto Dismiss] Verify that rate my call screen should not appear if “Dismiss Rate My Call” Toggle is OFF
     [Tags]  320220     P2
    [Setup]  Testcase Setup for Meeting User    count=2
    navigate to user survey for conf    device=device_1
    verify dismiss rate my call toggle    device=device_1       toggle=off
    come back to home screen from calling settings for conf   device=device_1
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call rating screen after disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen        device_list=device_1,device_2

TC5 : [Auto Dismiss] Verify selected Dismiss Rate My Call options should not get changed when tap on back button on call setting page.
    [Tags]   320226    P2
    [Setup]  Testcase Setup for Meeting User    count=1
    navigate to user survey for conf    device=device_1
    verify dismiss rate my call toggle    device=device_1       toggle=off
    enable dismiss rate my call option      device=device_1
    verify dismiss rate my call toggle    device=device_1       toggle=on
    come back to home screen from calling settings for conf   device=device_1
    verify dismiss rate my call toggle    device=device_1       toggle=on
    click on dismiss rate my call option toggle     device=device_1
    [Teardown]   Run Keywords    Capture on Failure     AND    Come back to home screen    device_list=device_1

TC6 : [Auto Dismiss] Verify "Dismiss Rate My Call" toggle is turned ON/OFF
    [Tags]  320238      P2
    [Setup]  Testcase Setup for Meeting User    count=1
    navigate to user survey for conf    device=device_1
    verify dismiss rate my call toggle    device=device_1       toggle=off
    click on dismiss rate my call option toggle     device=device_1
    verify dismiss rate my call toggle state    device=device_1       toggle=on
    click on dismiss rate my call option toggle     device=device_1
    come back to home screen from calling settings for conf   device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen        device_list=device_1

TC7 : [Auto Dismiss] Verify that rate my call screen should appear if “Dismiss Rate My Call” Toggle is ON .
    [Tags]  320214   P2
    [Setup]   Testcase Setup for Meeting User    count=2
    navigate to user survey for conf    device=device_1
    verify dismiss rate my call toggle    device=device_1       toggle=off
    click on dismiss rate my call option toggle     device=device_1
    verify dismiss rate my call toggle state    device=device_1       toggle=on
    come back to home screen from calling settings for conf   device=device_1
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call rating screen after disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    disable dismiss rate my call toggle     device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen        device_list=device_1,device_2

TC8 : [Auto Dismiss] Verify that rate my call screen should appear if “Dismiss Rate My Call” Toggle is ON and User ends the Meeting.
    [Tags]  320267     P2
    [Setup]  Testcase Setup for Meeting User    count=2
    navigate to user survey for conf    device=device_1
    verify dismiss rate my call toggle    device=device_1       toggle=off
    enable dismiss rate my call option      device=device_1
    verify dismiss rate my call toggle state    device=device_1       toggle=on
    come back to home screen from calling settings for conf   device=device_1
    create meeting  device=device_2       participants=device_1:meeting_user    meeting=cnf_device_meeting
    Join Meeting    device=device_1,device_2     meeting=cnf_device_meeting      join_styles=conference,None
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify call rating screen after disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    disable dismiss rate my call toggle     device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen        device_list=device_1,device_2

TC9 : [Auto Dismiss] Verify call cancelled screen auto dismiss with 5 seconds
    [Tags]   306046   P2
    [Setup]   Run Keywords    Testcase Setup for Meeting User     count=2    AND    Disable unanswered call    device=device_2      contact_device=device_1
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Rejects the incoming call   device_list=device_2
    validate call cancelled     device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
auto dismiss suite teardown
    [Arguments]     ${device}
    disable dismiss rate my call toggle     ${device}
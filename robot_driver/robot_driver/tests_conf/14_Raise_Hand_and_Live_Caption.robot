*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot


Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10


*** Test Cases ***
TC1 : [Raisehand]DUT user able to raise hand in the meeting
    [Tags]    306048    bvt_tpc  sanity_tpc  P0
    [Setup]   run keywords    Testcase Setup for Meeting User    count=2    AND    Meeting Setup    count=2
    create meeting  device=device_2       participants=device_1:meeting_user    meeting=raise_hand_meeting
    Wait for Some Time    time=${wait_time}
    Join Meeting    device=device_1,device_2     meeting=raise_hand_meeting      join_styles=conference,None
    Raise hand     device=device_1
    Verify raise hand    from_device=device_1   to_device=device_2    status=on
    [Teardown]   run keywords   Capture on Failure    AND    Lower hand Teardown     AND    Test Case Teardown     devices=device_2     count=2

TC2 : [Livecaption]Verify DUT user able to view the Live caption during meeting
    [Tags]    306050
    [Setup]   Testcase Setup for Meeting User    count=2
    create meeting  device=device_2       participants=device_1:meeting_user       meeting=live_caption_meeting
    Wait for Some Time    time=${wait_time}
    Join Meeting    device=device_1,device_2     meeting=live_caption_meeting        join_styles=conference,None
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify Live Caption visibility      device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   run keywords   Capture on Failure    AND    Test Case Teardown     devices=device_2     count=2

TC3 : [Livecaption] DUT user able to on and off the Live caption during the meeting
    [Tags]    306051    bvt_tpc  sanity_tpc  P0
    [Setup]   Testcase Setup for Meeting User    count=2
    create meeting  device=device_2       participants=device_1:meeting_user       meeting=live_caption_meeting2
    Refresh cnf device for meeting visibility   device=device_1
    Join Meeting    device=device_1,device_2     meeting=live_caption_meeting2       join_styles=conference,None
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Turn on live caption      device=device_1
    Wait for Some Time    time=${wait_time}
    Turn off live caption      device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   run keywords   Capture on Failure    AND    Test Case Teardown     devices=device_1    count=2

TC4 : [Raisehand]DUT/TDC able to lower hand from the meeting
    [Tags]   306049  sanity_tpc  P1
    [Setup]   run keywords    Testcase Setup for Meeting User    count=2    AND    Meeting Setup    count=2
    create meeting  device=device_2       participants=device_1:meeting_user    meeting=lower_hand_meeting
    Wait for Some Time    time=${wait_time}
    Join Meeting    device=device_1,device_2     meeting=lower_hand_meeting      join_styles=conference,None
    Raise hand     device=device_1
    Verify raise hand    from_device=device_1   to_device=device_2    status=on
    Lower hand     device=device_1
    Verify raise hand    from_device=device_1   to_device=device_2    status=off
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   run keywords   Capture on Failure    AND    Test Case Teardown     devices=device_2   count=2

TC5 : [Live Caption 1:1 call] Verify that user is getting "Turn On Live Captions" option in the more(...) option of 1:1 call
    [Tags]    306463
    [Setup]   Testcase Setup for Meeting User    count=2
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify Live Caption visibility      device=device_1
    disconnect call       device=device_1
    Verify Call State     device_list=device_1,device_2     state=Disconnected
    [Teardown]   run keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
Meeting Setup
    [Arguments]     ${count}
    Remove meeting from calender for meeting policy test      ${count}

Lower hand Teardown
    Lower hand     device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected

Test Case Teardown
    [Arguments]     ${devices}      ${count}
    check for device count      count=${count}
    Come back to home screen    device_list=${devices}
    Close dial pad  device=device_1
    Teardown Meeting Test Case     ${devices}
    Remove meeting from calender for meeting policy test      ${count}


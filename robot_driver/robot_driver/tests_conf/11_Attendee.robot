*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Setup     Meeting Setup
Suite Teardown   Run Keywords   Suite Failure Capture  AND     attendee suite teardown    devices=device_2      count=2

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Attendee] Add participant option should be available for DUT user when made as a presenter
    [Tags]  306321   bvt_tpc     sanity_tpc  P0  
    [Setup]     Testcase Setup for Meeting User   count=2
    Join Meeting    device=device_2,device_1     meeting=attendee_meeting        join_styles=None,conference
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Make an attendee    from_device=device_2       to_device=device_1:meeting_user
    Verify add participant button should not visible for attendee    device=device_1
    Make an presenter    from_device=device_2       to_device=device_1:meeting_user
    Verify add participant button should visible for presenter    device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND   Test Case Teardown without deleting meeting     devices=device_1,device_2    count=2

TC2 : [Attendee] Add participant option should not be available for DUT user when made as an attendee
    [Tags]  306318    bvt_tpc    sanity_tpc  P0
    [Setup]    Testcase Setup for Meeting User   count=2
    Join Meeting    device=device_2,device_1    meeting=attendee_meeting        join_styles=None,conference
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Make an attendee    from_device=device_2       to_device=device_1:meeting_user
    Verify add participant button should not visible for attendee    device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting     devices=device_1,device_2    count=2

TC3 :[Attendee] DUT user to make TDC user as a presenter
    [Tags]   306322    P1
    [Setup]    Testcase Setup for Meeting User   count=2
    Join Meeting    device=device_2,device_1     meeting=attendee_meeting        join_styles=None,conference
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Make an attendee    from_device=device_2       to_device=device_1:meeting_user
    Verify you are an attendee now notification     device=device_1
    Verify add participant button should not visible for attendee    device=device_1
    Make an presenter    from_device=device_2       to_device=device_1:meeting_user
    Verify you are an presenter now notification     device=device_1
    Verify add participant button should visible for presenter    device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND   Test Case Teardown without deleting meeting     devices=device_1,device_2    count=2

TC4 : [Attendee] DUT user to make TDC user as a attendee
    [Tags]  306320     bvt_tpc   sanity_tpc  P0
    [Setup]    Testcase Setup for Meeting User   count=3
    Join Meeting    device=device_1,device_3    meeting=attendee_meeting     join_styles=conference,None
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_3    state=Connected
    Make an attendee    from_device=device_1       to_device=device_3
    Verify you are an attendee now notification     device=device_3
    Verify add participant button should not visible for attendee    device=device_3
    Make an presenter    from_device=device_1       to_device=device_3
    Verify you are an presenter now notification     device=device_3
    Verify add participant button should visible for presenter    device=device_3
    End meeting     device=device_1,device_3
    Verify meeting state    device_list=device_1,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3    count=3

*** Keywords ***
Meeting Setup
    clear meetings from calendar tab    devices=device_2
    create meeting   device=device_2       participants=device_1:meeting_user,device_3     meeting=attendee_meeting


Test Case Teardown
    [Arguments]     ${devices}      ${count}
    check for device count      count=${count}
    Come back to home screen    device_list=${devices}
    Close dial pad  device=device_1
    Teardown Meeting Test Case     ${devices}
    Remove meeting from calender for meeting policy test      ${count}

Test Case Teardown without deleting meeting
    [Arguments]     ${devices}   ${count}
    check for device count      count=${count}
    Come back to home screen    ${devices}
    Close dial pad  device=device_1
    Teardown Meeting Test Case     ${devices}

attendee suite teardown
    [Arguments]     ${devices}      ${count}
    Teardown Meeting Test Case     ${devices}
    remove meeting from calender for user   ${count}
    Come back to home screen    ${devices}
*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

#Suite Setup     Meeting Setup
Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =      10s
${5m_wait_time} =    5 minutes

*** Test Cases ***
TC1 : [Calendar] Verify Calendar tab UI when a new user sign in on DUT
    [Tags]  305876  bvt_tpc  sanity_tpc  P0
    [Setup]    Testcase Setup for Meeting User   count=1
    Verify meeting object for new user   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1     count=1

TC2 : [Calendar] DUT has global search option in calendar tab
    [Tags]  305869
    [Setup]    Testcase Setup for Meeting User   count=1
    Verify teams app has global search option   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1     count=1

TC3 : [Calendar] Verify that No meetings displayed when there are no scheduled meetings for the day
    [Tags]  305804   sanity_tpc  P1
    [Setup]    Testcase Setup for Meeting User   count=1
    Verify no meetings scheduled on saturday    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1     count=1

TC4 : [Calendar] Calendar should refresh automatically and sync the new meeting entry
    [Tags]  305851   bvt_tpc     sanity_tpc  P0
    [Setup]    Testcase Setup for Meeting User   count=2
    create meeting  device=device_2     meeting=Sync_meeting    participants=device_1:meeting_user
    Wait for Some Time    time=${5m_wait_time}
    Wait until Meeting is Reflected     device=device_1    meeting=Sync_meeting
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_2    count=2

TC5 : [Home screen] DUT user to be displayed with options on Notification screen, along with Meeting name
    [Tags]  464973   bvt_tpc     sanity_tpc  P0
    [Setup]    Testcase Setup for Meeting User   count=2
    create meeting  device=device_2     meeting=Home_screen_meeting    participants=device_1:meeting_user
    Wait for Some Time    time=${wait_time}
    Refresh cnf device for meeting visibility   device=device_1
    verify home screen meeting notification     device=device_1     meeting=Home_screen_meeting
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_2    count=2

TC6 : [PersonalExperienceForMeetingUsers] Validate home screen for meeting users
    [Tags]  464955   bvt_tpc     sanity_tpc  P0
    [Setup]    Testcase Setup for Meeting User   count=2
    create meeting  device=device_2     meeting=calander_meeting    participants=device_1:meeting_user
    Navigate to calendar tab    device=device_1
    verify options in calendar tab      device=device_1     meeting=calander_meeting    phone_number=device_1:meeting_user
    verify home screen for cnf device   device=device_1
    Click on people tab     device=device_1
    Navigate to calendar tab    device=device_1
    verify dialpad in calendar tab     device=device_1
    return to home screen    device_list=device_1
    Navigate to calendar tab    device=device_1
    verify meet now icon     device=device_1
    Tap on Meet Now icon and validate   device=device_1
    close meet now conference page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_2    count=2

*** Keywords ***
Meeting Setup
    [Arguments]     ${count}
    Remove meeting from calender for meeting policy test      ${count}

Test Case Teardown
    [Arguments]     ${devices}      ${count}
    check for device count      count=${count}
    Come back to home screen    device_list=${devices}
    Close dial pad  device=device_1
    Teardown Meeting Test Case     ${devices}
    Remove meeting from calender for meeting policy test      ${count}

Test Case Teardown without deleting meeting
    [Arguments]     ${devices}    ${count}
    check for device count      count=${count}
    Come back to home screen    ${devices}
    Close dial pad  device=device_1
    Teardown Meeting Test Case     ${devices}



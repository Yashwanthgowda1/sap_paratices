*** Settings ***
Documentation  No Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot


*** Test Cases ***
TC1:[MTRA] Verify Focus tile in available state.
    [Documentation]     should not create any meeting for device_1:user
    [Tags]     444988      P2
    [Setup]  Testcase Setup    count=1
    Verify the available focus tile bar     device=device_1
    Verify available all day visible in calendar ui     device=device_1
    [Teardown]  Capture Failure

TC2:[MTRA] Verify Focus tile when there is Room availability on the current day in Ambient screen.
    [Documentation]     should not create any meeting for device_1:user
   [Tags]     444987     P3
   [Setup]  Testcase Setup    count=1
   Verify available all day visible in calendar ui     device=device_1
   [Teardown]  Capture Failure

TC3:[Meetings]Verify the no meeting name shown in calendar or notification for the new scheduled meeting
   [Documentation]     should not create any meeting for device_1:user
   [Tags]     260627     bvt_sm      sanity_sm
   [Setup]  Testcase Setup    count=1
   verify no meeting on view     device=device_1
   Navigate to app settings page    device=device_1
   navigate to meetings option in device settings page      device=device_1
   hide or unhide meeting names     device=device_1   state=off
   Come back from admin settings page      device_list=device_1
   create TDC meeting name as test meeting
   Verify meeting names show meeting organizer name   device=device_1   organizer=device_1
   [Teardown]  Run Keywords    Capture on Failure   AND     Modify show meeting names option     device=device_1   state=on   AND    Delete all meetings if exist with timegap and create cuttent meeting


*** Keywords ***
Modify show meeting names option
    [Arguments]       ${device}   ${state}
    Navigate to app settings page  ${device}
    navigate to meetings option in device settings page   ${device}
    hide or unhide meeting names    ${device}    ${state}
    Come back from admin settings page      device_list=${device}

create TDC meeting name as test meeting
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=test_meeting          time_duration=1 hr      use_current_time=True
    close web driver        tdc_1

Delete all meetings if exist with timegap and create cuttent meeting
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user_1
    delete all meetings from tdc     device=tdc_1
    close web driver        tdc_1

verify no meeting on view
    [Arguments]       ${device}
    Verify available all day visible in calendar ui     device=device_1

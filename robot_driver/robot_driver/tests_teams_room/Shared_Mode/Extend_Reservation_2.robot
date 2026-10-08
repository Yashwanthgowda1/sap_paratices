*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

Suite Setup       Enable extend room reservation    device=device_1
Suite Teardown    Run Keywords  Suite Failure Capture   AND     Disable extend room reservation     device=device_1

*** Variables ***
${25s_wait_time} =  25s

*** Test Cases ***
TC1:[Checkout and extend reservation] Verify the DUT user gets a notification banner when only 5 minutes are left before their meeting ends
    [Tags]     332996    P1   sanity_sm
    [Setup]    Testcase Setup for Meeting User   count=2
    Create extend TDC Meetings     meeting_name=extend_meeting     participants=device_2:user       time_duration=5 min       use_current_time=True
    Join Meeting    device=device_1,device_2    meeting=extend_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify notification banner when meeting about to end  device=device_1    state=on
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2    AND     Delete extend meeting

TC2:[Checkout and extend reservation] Verify The notification banner is dismissed once user has extended the meeting.
    [Tags]     332997    P1   sanity_sm
    [Setup]    Testcase Setup for Meeting User   count=2
    Create extend TDC Meetings     meeting_name=extend_meeting     participants=device_2:user       time_duration=7 min       use_current_time=True
    Join Meeting    device=device_1,device_2    meeting=extend_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Wait for Some Time    time=${25s_wait_time}
    verify meeting warning notification banner with time left    device_list=device_1    time_left_in_min=5
    Verify and extend reservation   device=device_1     time_in_minutes=10
    verify notification banner when meeting about to end  device=device_1    state=off
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2    AND     Delete extend meeting

TC3:[Checkout and extend reservation] verify the notification banner text should also update if user never dismissed it
    [Tags]     332998    P1   sanity_sm
    [Setup]    Testcase Setup for Meeting User   count=2
    Create extend TDC Meetings     meeting_name=extend_meeting     participants=device_2:user       time_duration=7 min       use_current_time=True
    Join Meeting    device=device_1,device_2    meeting=extend_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Wait for Some Time    time=${25s_wait_time}
    verify meeting warning notification banner with time left    device_list=device_1    time_left_in_min=5
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2    AND     Delete extend meeting

TC4:[Checkout and extend reservation] PSTN user to check for the extend reservation feature.
     [Tags]     381974    P2
    [Setup]  Testcase Meeting PSTN Setup Main  count=2
    Initiates meeting using Meet now option using DID   from_device=device_2:pstn_user     to_device=device_1:meeting_user
    Accept incoming call    device=device_1
    Close participants screen   device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify error banner for extend meeting while using meetnow    device=device_1
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND     Come back to home screen    device_list=device_1,device_2

TC5:[Checkout and extend reservation] Verify On Tapping the Extend Reservation option It should show an error dialog if the room is not available to book
    [Tags]    332989     bvt_sm     sanity_sm
    [Setup]    Testcase Setup for Meeting User   count=2
    create consecutive extend meeting       start_meeting_time_after=10
    Join Meeting    device=device_1,device_2    meeting=test_meeting_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify error banner for extend meeting while using meetnow    device=device_1
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND     Come back to home screen    device_list=device_1,device_2    AND     Delete consecutive extend meeting

TC6:[Checkout and extend reservation] Verify whether the suggested time is displayed when the meeting is reserved between the available time and the next meeting start time
    [Tags]    333000    P2
    [Setup]    Testcase Setup for Meeting User   count=2
    create consecutive extend meeting       start_meeting_time_after=40
    Join Meeting    device=device_1,device_2    meeting=test_meeting_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify and extend reservation   device=device_1    time_in_minutes=15
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND     Come back to home screen    device_list=device_1,device_2    AND     Delete consecutive extend meeting

*** Keywords ***
Enable extend room reservation
    [Arguments]     ${device}
    Navigate to app settings page    device=${device}
    navigate to meetings option in device settings page      device=${device}
    extend room reservation toggle   device=${device}    state=on
    Come back from admin settings page    device_list=${device}

Disable extend room reservation
    [Arguments]     ${device}
    Navigate to app settings page     ${device}
    navigate to meetings option in device settings page      ${device}
    extend room reservation toggle   ${device}    state=off
    Come back from admin settings page    device_list=${device}

Create extend TDC Meetings
    [Arguments]          ${meeting_name}      ${participants}           ${time_duration}    ${use_current_time}
    initiate web driver     tdc_1
    perform web signin method     tdc_1:meeting_user
    create TDC meeting on desktop   device=tdc_1    meeting_name=${meeting_name}     participants=${participants}    time_duration=${time_duration}      use_current_time=${use_current_time}    roundup_end_time=off
    close web driver    tdc_1
    refresh calender tab    device=device_1,device_2

Delete extend meeting
    initiate web driver     tdc_1
    perform web signin method     tdc_1:meeting_user
    right click on created meeting from tdc       tdc_1:meeting_user     edit_meeting_name=extend_meeting
    delete meeting from tdc     tdc_1
    close web driver    tdc_1
    refresh calender tab    device=device_1,device_2
    
create consecutive extend meeting
    [Arguments]     ${start_meeting_time_after}
    initiate web driver     tdc_1
    perform web signin method     tdc_1:meeting_user
    create TDC meeting on desktop    device=tdc_1:meeting_user     meeting_name=test_meeting_1        time_duration=10 min       participants=device_2:user      use_current_time=True      roundup_end_time=off
    create TDC meeting on desktop    device=tdc_1:meeting_user     meeting_name=test_meeting_2        time_duration=10 min       participants=device_2:user       start_meeting_time=on       start_meeting_time_after=${start_meeting_time_after}    roundup_end_time=off
    refresh calender tab    device=device_1,device_2

Delete consecutive extend meeting
    right click on created meeting from tdc       tdc_1:meeting_user     edit_meeting_name=test_meeting_1
    delete meeting from tdc     tdc_1
    right click on created meeting from tdc       tdc_1:meeting_user     edit_meeting_name=test_meeting_2
    delete meeting from tdc     tdc_1
    close web driver    tdc_1
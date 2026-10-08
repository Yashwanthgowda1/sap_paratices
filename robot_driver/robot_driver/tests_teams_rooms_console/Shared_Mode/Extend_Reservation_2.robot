*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

Suite Setup         Enable extend room reservation toggle btn
Suite Teardown    Run Keywords   Suite Failure Capture    AND   Disable extend room reservation toggle btn

*** Variables ***

${wait_time} =  1 minutes
${25s_wait_time} =  25s
*** Test Cases ***
TC1:[Checkout and Extend Reservation] Verify the Touch console gets a notification banner when only 5 minutes are left before their meeting ends
    [Tags]    333014    P1    tr_tc_sm    sanity_tc_sm
    [Setup]    Testcase Setup for shared User   count=2
    Create extend TDC Meetings     meeting_name=extend_meeting     participants=device_2:user       time_duration=5 min       use_current_time=True
    Join a meeting   console=console_1     device=device_2    meeting=extend_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    verify notification banner when meeting about to end  device=console_1    state=on
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1   device_list=device_2    AND    Delete extend meeting    meeting=extend_meeting

TC2:[Checkout and Extend Reservation] Verify The notification banner is dismissed once user has extended the meeting.
    [Tags]    333015    P2     tr_tc_sm
    [Setup]    Testcase Setup for shared User   count=2
    Create extend TDC Meetings     meeting_name=extend_meeting     participants=device_2:user       time_duration=7 min       use_current_time=True
    Join a meeting   console=console_1     device=device_2    meeting=extend_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Wait for Some Time    time=${25s_wait_time}
    verify meeting warning notification banner with time left    device_list=console_1,device_1    time_left_in_min=5
    Verify and extend reservation   device=console_1     time_in_minutes=10
    verify notification banner when meeting about to end  device=console_1    state=off
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1   device_list=device_2    AND    Delete extend meeting    meeting=extend_meeting

TC3:[Checkout and Extend Reservation] verify the notification banner text should auto update in both Norden and touch console if the user never extend the meeting
    [Tags]    333016    P2     tr_tc_sm
    [Setup]    Testcase Setup for shared User   count=2
    Enable touch screen controls    console=console_1
    Create extend TDC Meetings     meeting_name=extend_meeting     participants=device_2:user       time_duration=7 min       use_current_time=True
    Join a meeting   console=console_1     device=device_2    meeting=extend_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Wait for Some Time    time=${25s_wait_time}
    verify meeting warning notification banner with time left    device_list=console_1,device_1    time_left_in_min=5
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1   device_list=device_2    AND    Delete extend meeting    meeting=extend_meeting    AND     Disable touch screen controls      console=console_1

TC4:[Checkout and extend reservation] PSTN user to check for the extend reservation feature.
     [Tags]    382124    P2
    [Setup]    Testcase Shared Mode PSTN Setup Main    count=2
    Meet now meeting   from_device=device_2     to_device=console_1:meeting_user        method=phone_number
    Pick up incoming call    console=console_1
    Close participants screen   device=device_2
    Wait for Some Time    time=${wait_time}
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    verify error banner for extend meeting while using meetnow    device=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1   device_list=device_2

TC5:[Checkout and Extend Reservation] Verify On Tapping the Extend Reservation option It should show an error dialog if the room is not available to book
    [Tags]    333006    sanity_tc_sm    bvt_tc_sm
    [Setup]    Testcase Setup for shared User   count=2
    create consecutive extend meeting       start_meeting_time_after=10
    Join a meeting   console=console_1     device=device_2    meeting=test_meeting_1
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    verify error banner for extend meeting while using meetnow    device=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1   device_list=device_2    AND    Delete consecutive extend meeting

TC6:[Checkout and Extend Reservation] Verify whether the suggested time is displayed when the meeting is reserved between the available time and the next meeting start time
    [Tags]    333017    P2
    [Setup]    Testcase Setup for shared User   count=2
    create consecutive extend meeting       start_meeting_time_after=40
    Join a meeting   console=console_1     device=device_2    meeting=test_meeting_1
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and extend reservation   device=console_1    time_in_minutes=15
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1   device_list=device_2    AND    Delete consecutive extend meeting

*** Keywords ***
Create extend TDC Meetings
    [Arguments]          ${meeting_name}      ${participants}           ${time_duration}    ${use_current_time}
    initiate web driver     tdc_1
    perform web signin method     tdc_1:meeting_user
    create TDC meeting on desktop   device=tdc_1    meeting_name=${meeting_name}     participants=${participants}    time_duration=${time_duration}      use_current_time=${use_current_time}    roundup_end_time=off
    close web driver    tdc_1
    refresh calender tab    device=console_1,device_2

Enable extend room reservation toggle btn
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1  option=meeting
    extend room reservation toggle    device=console_1    state=on
    come back from admin settings page      device_list=console_1

Disable extend room reservation toggle btn
    Navigate to app settings screen    console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1      option=meeting
    extend room reservation toggle      device=console_1       state=off
    come back from admin settings page    device_list=console_1

Navigate to app settings screen
    [Arguments]   ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Delete extend meeting
    [Arguments]   ${meeting}
    initiate web driver     tdc_1
    perform web signin method     tdc_1:meeting_user
    right click on created meeting from tdc       tdc_1:meeting_user     edit_meeting_name=${meeting}
    delete meeting from tdc     tdc_1
    close web driver    tdc_1
    refresh calender tab    device=console_1,device_1,device_2

End a meeting
    [Arguments]    ${console}    ${device}
    End the meeting  ${console}
    End meeting      ${device}

Enable touch screen controls
    [Arguments]   ${console}
    Navigate to app settings screen     console=${console}
    Navigate to meeting and calling options from device settings page       console=${console}   option=general
    modify touchscreen control toggle state     console=${console}   state=enabled
    Come back from admin settings page      device_list=${console}

Disable touch screen controls
    [Arguments]   ${console}
    Navigate to app settings screen     console=${console}
    Navigate to meeting and calling options from device settings page       console=${console}   option=general
    modify touchscreen control toggle state     console=${console}   state=disabled
    Come back from admin settings page      device_list=${console}

Navigate to app settings page on device
    [Arguments]     ${device}
    Click on more option   ${device}
    Click on settings page   ${device}

Enable extend room reservation on device
    [Arguments]     ${device}
    Navigate to app settings page on device    device=${device}
    navigate to meetings option in device settings page      device=${device}
    extend room reservation toggle   device=${device}    state=on
    Come back from admin settings page    device_list=${device}

Disable extend room reservation on device
    [Arguments]     ${device}
    Navigate to app settings page on device     ${device}
    navigate to meetings option in device settings page      ${device}
    extend room reservation toggle   ${device}    state=off
    Come back from admin settings page    device_list=${device}
    
create consecutive extend meeting
    [Arguments]     ${start_meeting_time_after}
    initiate web driver     tdc_1
    perform web signin method     tdc_1:meeting_user
    create TDC meeting on desktop    device=tdc_1:meeting_user     meeting_name=test_meeting_1        time_duration=10 min       participants=device_2:user      use_current_time=True      roundup_end_time=off
    create TDC meeting on desktop    device=tdc_1:meeting_user     meeting_name=test_meeting_2        time_duration=10 min       participants=device_2:user       start_meeting_time=on       start_meeting_time_after=${start_meeting_time_after}    roundup_end_time=off
    refresh calender tab    device=console_1,device_2

Delete consecutive extend meeting
    right click on created meeting from tdc       tdc_1:meeting_user     edit_meeting_name=test_meeting_1
    delete meeting from tdc     tdc_1
    right click on created meeting from tdc       tdc_1:meeting_user     edit_meeting_name=test_meeting_2
    delete meeting from tdc     tdc_1
    close web driver    tdc_1

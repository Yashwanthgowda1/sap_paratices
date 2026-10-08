*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Test Cases ***
TC1:[Meeting Id] Disable Zoom in meeting settings
    [Tags]   454371     P0      exclude_ftp_sm    sanity_sm
    [Setup]    Testcase Setup for Meeting User   count=1
    verify that third party meetings is Disabled default    device=device_1
    Verify the join by id on home seceen when zoom meeting toggle is disabled      device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC2:[DGJ]DUT user should have option to enable Zoom meeting
    [Tags]   327955      bvt_sm   sanity_sm     exclude_ftp_sm
    [Setup]    Testcase Setup for Meeting User   count=1
    DUT user should have option to enable Zoom meeting    device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC3:[Meetings]Verify that the meeting name is not displayed when created from Outlook while "show meeting names" option is disable
    [Tags]   260629     P1    sanity_sm
    [Setup]    Testcase Setup for Meeting User   count=1
    Enable and disable zoom meeting toggle      device=device_1    state=on
    ${meeting_name_before_disabling_show_meeting_names}=  Get meeting name   device=device_1
    Navigate to app settings page    device=device_1
    navigate to meetings option in device settings page      device=device_1
    hide or unhide meeting names     device=device_1   state=off
    Come back from admin settings page      device_list=device_1
    ${meeting_name_after_disabling_show_meeting_names}=  Get meeting name    device=device_1
    Verify meeting name on homescreen after disabling   device_1    ${meeting_name_before_disabling_show_meeting_names}    ${meeting_name_after_disabling_show_meeting_names}
    Verify meeting names show meeting organizer name   device=device_1   organizer=device_1:meeting_user
    [Teardown]  Run Keywords    Capture on Failure      AND   Come back to home screen    device_list=device_1           AND      Modify show meeting names option     device=device_1   state=on

TC4:[Meetings]Verify that the meeting name is displayed when created from Outlook while "show meeting names" option is enable
    [Tags]   303659    P2
    [Setup]    Testcase Setup for Meeting User   count=1
    navigate to admin setting under device setting page     device=device_1
    hide or unhide meeting names     device=device_1   state=on
    Enable and disable third party meetings zoom toggle         device=device_1   state=on
    Come back from admin settings page    device_list=device_1
    verify meeting name displayed on preview screen       device=device_1     meeting=zoom_meeting
    [Teardown]  Run Keywords    Capture on Failure      AND   Come back to home screen    device_list=device_1       AND      Modify show meeting names option     device=device_1   state=on

TC5:[Meetings]Show meeting names toggle is turned OFF already and TDC2 schedules meeting from outlook with DUT user, meeting must sync automatically and Meeting name must not be displayed, Organizer name must be displayed above meeting time.
    [Tags]      304446     P2
    [Setup]    Testcase Setup for Meeting User   count=1
    navigate to admin setting under device setting page     device=device_1
    hide or unhide meeting names     device=device_1   state=on
    Enable and disable third party meetings zoom toggle         device=device_1   state=on
    Come back from admin settings page    device_list=device_1
    verify meeting name displayed on preview screen       device=device_1     meeting=zoom_meeting
    [Teardown]  Run Keywords    Capture on Failure      AND   Come back to home screen    device_list=device_1      AND      Modify show meeting names option     device=device_1   state=on

TC6:[DGJ]Zoom icon should be displayed for the meeting created with Zoom Link on Calendar
     [Tags]   445034     P1    sanity_sm
    [Setup]    Testcase Setup for Meeting User   count=1
    Enable and disable zoom meeting toggle    device=device_1    state=on
    verify Zoom icon should be displayed on calandertab    device=device_1     meeting=zoom_meeting
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC7:[DGJ]DUT not able to join meeting when Zoom meeting option disabled from Meeting option
    [Tags]   445037     P2
    [Setup]    Testcase Setup for Meeting User   count=1
    Enable and disable zoom meeting toggle    device=device_1     state=off
    verify join button behavior when third party toggle is disabled    device=device_1    meeting_name=zoom_meeting
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

*** Keywords ***
Zoom and Outlook Meeting Creation Workflow using TDC
    initiate driver for zoom meeting      tdc_1
    perform web signin method for zoom      tdc_1:zoom_user
    create zoom meeting          device=tdc_1:zoom_user   meeting_name=Automation_zoom_meeting         duration= 5 hr
    zoom meeting copy clipboard     device=tdc_1
    close web driver    tdc_1
    Sleep    5s
    initiate driver for outlook meeting          tdc_1
    perform web signin method        tdc_1:meeting_user     outlook=True
    outlook meeting creation        tdc_1:meeting_user      meeting_name=outlook_meeting    participants=device_1       time_duration=20 hr         external_meetings=on

Navigate to app settings page
    [Arguments]     ${device}
    Click on more option   ${device}
    Click on settings page   ${device}

verify that third party meetings is Disabled default
    [Arguments]     ${device}
    Navigate to app settings page     ${device}
    navigate to meetings option in device settings page      ${device}
    verify third party zoom meetings toggle disable default   ${device}
    Come back from admin settings page    device_list=${device}

DUT user should have option to enable Zoom meeting
    [Arguments]     ${device}
    Navigate to app settings page     ${device}
    navigate to meetings option in device settings page      ${device}
    Enable and disable third party meetings zoom toggle  ${device}  state=on
    Come back from admin settings page    device_list=${device}
    Enable and disable third party meetings zoom toggle  ${device}  state=off
    Come back from admin settings page    device_list=${device}

verify Zoom icon should be displayed on calandertab
    [Arguments]     ${device}   ${meeting}
    verify meeting reflected on calendar tab            ${device}   ${meeting}
    verify meeting display on home screen      ${device}

verify meeting name displayed on preview screen
    [Arguments]     ${device}       ${meeting}
    verify meeting reflected on calendar tab    ${device}       ${meeting}

navigate to admin setting under device setting page
    [Arguments]     ${device}
    Navigate to app settings page     ${device}
    navigate to meetings option in device settings page      ${device}

Modify show meeting names option
    [Arguments]       ${device}   ${state}
    Navigate to app settings page  ${device}
    navigate to meetings option in device settings page   ${device}
    hide or unhide meeting names    ${device}    ${state}
    Come back from admin settings page      device_list=${device}
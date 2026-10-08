*** Settings ***
Documentation   Create three all-day meetings as prerequisites before test execution, named all_day_meeting, all_day_meeting1, and all_day_meeting2..
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Test Cases ***
TC1:[Landing Page] DUT should navigate back to meetings when DUT user tap on All-day meeting title bar
    [Tags]    314948    P1    sanity_tc_sm
    [Setup]  Testcase Setup for shared User     count=1
    Verify Home page options   console=console_1:meeting_user
    Tap on all day meetings title bar and validate   device=console_1
    Get meetings details present under all day title bar   device=console_1
    [Teardown]   Run Keywords    Capture Failure  AND   Navigate back to meetings   device=console_1    AND  Come back to home screen page   console_list=console_1

TC2:[Meetings]Verify that while connecting and after joined to meeting/all-day meeting, meeting name must be displayed
    [Tags]    315533    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User    count=1
    ${before_toggle_show_meeting_names}=    Get meeting details    console=console_1
    Navigate to show meeting names page     console=console_1
    ${after_toggle_show_meeting_names}=     Get meeting details    console=console_1
    run keyword if   '${before_toggle_show_meeting_names}' != '${after_toggle_show_meeting_names}'   Log   Meeting name is showing as the meeting organizer name
    ...  ELSE  fail   Meeting is not showing the name of organizer.
    Join the meeting     console=console_1     organizer_name=console_1:meeting_user
    Verify for call state      console_list=console_1       state=Connected
    End the meeting   console=console_1
    Verify for call state   console_list=console_1      state=Disconnected
    Tap on all day meetings title bar and validate   device=console_1
    Join the meeting     console=console_1     organizer_name=console_1:meeting_user
    Verify for call state      console_list=console_1       state=Connected
    End the meeting   console=console_1
    Verify for call state   console_list=console_1      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND   Navigate back to meetings   device=console_1    AND     Come back to home screen page   console_list=console_1     AND     Enable show meeting names toggle btn    console=console_1

TC3:[MTRA+TC] Verify more than one All day meetings & count is visible.
    [Tags]    444752    P2
    [Setup]  Testcase Setup for shared User     count=1
    Verify Home page options   console=console_1:meeting_user
    Tap on all day meetings title bar and validate   device=console_1
    Get meetings details present under all day title bar   device=console_1
    [Teardown]   Run Keywords    Capture Failure   AND   Navigate back to meetings   device=console_1   AND   Come back to home screen page   console_list=console_1

TC4:[MTRA+TC] Verify All day & Non-all day meetings
    [Documentation]  Create non_allday_meeting more than 24 hours
    [Tags]    444762    P1    sanity_tc_sm
    [Setup]  Testcase Setup for shared User     count=1
    Verify Home page options   console=console_1:meeting_user
    Tap on all day meetings title bar and validate   device=console_1
    Get meetings details present under all day title bar   device=console_1
    Navigate back to meetings   device=console_1
    verify start and end time display on calendar tab     device=console_1     meeting=non_allday_meeting
    [Teardown]   Run Keywords    Capture Failure   AND  Come back to home screen page   console_list=console_1

TC5:[MTRA+TC] Verify calendar showing meetings till next day EOD.
    [Documentation]  Create non_all_day_meeting more than 24 hours
    [Tags]    444649    P1    sanity_tc_sm
    [Setup]  Testcase Setup for shared User     count=1
    Verify Home page options   console=console_1:meeting_user
    Verify satrt day and end day shown in calendar     console=console_1     meeting=non_allday_meeting
    [Teardown]   Run Keywords    Capture Failure   AND  Come back to home screen page   console_list=console_1

TC6:[MTRA+TC] Verify meetings are displayed for Today and Tomorrow.
    [Documentation]  Create non_all_day_meeting more than 24 hours
    [Tags]    444650    P2
    [Setup]  Testcase Setup for shared User     count=1
    Verify meeting display on home page   console=console_1
    Verify meeting displayed for today and tomorrow     console=console_1     meeting=non_allday_meeting
    [Teardown]   Run Keywords    Capture Failure   AND  Come back to home screen page   console_list=console_1

TC7:[MTRA] Verify all day meeting name with same title.
    [Tags]    444785    P3
    [Setup]  Testcase Setup for shared User     count=1
    Tap on all day meetings title bar and validate   device=console_1
    Get meetings details present under all day title bar   device=console_1
    Navigate back to meetings   device=console_1
    [Teardown]   Run Keywords    Capture Failure   AND  Come back to home screen page   console_list=console_1

TC8:[MTRA]Verify Non-all day meetings.
    [Documentation]  Create non_all_day_meeting more than 24 hours
    [Tags]    444797    P2
    [Setup]  Testcase Setup for shared User     count=1
    Verify meeting display on home page   console=console_1
    Verify meeting displayed for today and tomorrow     console=console_1     meeting=non_allday_meeting
    [Teardown]   Run Keywords    Capture Failure   AND  Come back to home screen page   console_list=console_1

TC9:[MTRA+TC] Verify notifications are sent to dock.
    [Tags]    468374    P3
    [Setup]  Testcase Setup for shared User     count=1
    Verify meeting display on home page   console=console_1
    Verify meetings synced on peripheral        console=console_1
    [Teardown]   Run Keywords    Capture Failure   AND  Come back to home screen page   console_list=console_1

*** Keywords ***
Verify Home page options
    [Arguments]     ${console}
    validate user details along with home screen options        ${console}

Navigate to app settings screen
    [Arguments]   ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Navigate to show meeting names page
    [Arguments]       ${console}
    Navigate to app settings screen    ${console}
    Navigate to meeting and calling options from device settings page       ${console}  option=meeting
    Disable show meeting names toggle btn   ${console}
    come back from admin settings page      device_list=${console}

Enable show meeting names toggle btn
    [Arguments]    ${console}
    Navigate to app settings screen    ${console}
    Navigate to meeting and calling options from device settings page       ${console}  option=meeting
    Enable show meeting names toggle button    ${console}
    come back from admin settings page      device_list=${console}

Verify satrt day and end day shown in calendar
    [Arguments]    ${console}       ${meeting}
    verify start and end time display on calendar tab     device=${console}     meeting=${meeting}

Verify meeting displayed for today and tomorrow
    [Arguments]    ${console}       ${meeting}
    verify start and end time display on calendar tab     device=${console}     meeting=${meeting}

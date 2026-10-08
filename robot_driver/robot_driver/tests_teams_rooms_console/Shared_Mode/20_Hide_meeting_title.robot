*** Settings ***
Library     DateTime
Resource    ../../resources/keywords/common.robot

*** Test Cases ***
TC1:[Meetings]Verify the no meeting name show in calender or notification when "Show meeting names" option is disabled
    [Tags]    315529    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User    count=1
    ${before_toggle_show_meeting_names}=    Get meeting details    console=console_1
    disable the show meeting names     console=console_1
    ${after_toggle_show_meeting_names}=     Get meeting details    console=console_1
    run keyword if   '${before_toggle_show_meeting_names}' != '${after_toggle_show_meeting_names}'   Log   Meeting name is showing as the meeting organizer name
    ...  ELSE  fail   Meeting is not showing the name of organizer.
    Verify meeting names show meeting organizer name   device=device_1   organizer=device_1:meeting_user
    [Teardown]   Run Keywords    Capture Failure   AND    Enable show meeting names toggle btn   console=console_1

TC2:[Meetings]Verify that while connecting meeting ,meeting name must be displayed
    [Tags]    315541    P2
    [Setup]   Testcase Setup for shared User    count=1
    ${before_toggle_show_meeting_names}=    Get meeting details    console=console_1
    disable the show meeting names     console=console_1
    ${after_toggle_show_meeting_names}=     Get meeting details    console=console_1
    run keyword if   '${before_toggle_show_meeting_names}' != '${after_toggle_show_meeting_names}'   Log   Meeting name is showing as the meeting organizer name
    ...  ELSE  fail   Meeting is not showing the name of organizer.
    Join the meeting     console=console_1     organizer_name=console_1:meeting_user
    Verify for call state      console_list=console_1       state=Connected
    End the meeting   console=console_1
    Verify for call state   console_list=console_1      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Enable show meeting names toggle btn   console=console_1

TC3:[Meetings]Verify the no meeting name showin in calander or notification for the new scheduled meeting
    [Tags]    315531    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User    count=1
    ${before_toggle_show_meeting_names}=    Get meeting details    console=console_1
    disable the show meeting names     console=console_1
    ${after_toggle_show_meeting_names}=     Get meeting details    console=console_1
    run keyword if   '${before_toggle_show_meeting_names}' != '${after_toggle_show_meeting_names}'   Log   Meeting name is showing as the meeting organizer name
    ...  ELSE  fail   Meeting is not showing the name of organizer.
    [Teardown]   Run Keywords    Capture Failure  AND     Enable show meeting names toggle btn     console=console_1     AND     Come back to home screen page   console_list=console_1

TC4:[Meetings]Verify the meeting name showing in Calander or notification when the "show meeting names" option enabled
    [Tags]    315536    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User    count=1
    ${before_toggle_show_meeting_names}=    Get meeting details    console=console_1
    Enable show meeting names toggle btn     console=console_1
    ${after_toggle_show_meeting_names}=     Get meeting details    console=console_1
    run keyword if   '${before_toggle_show_meeting_names}' == '${after_toggle_show_meeting_names}'   Log   Meeting name is showing in the calendar
    ...  ELSE  fail   Meeting name is not showing in the calendar
    [Teardown]   Run Keywords    Capture Failure     AND     Come back to home screen page   console_list=console_1

TC5:[Meetings] Verify meeting name on meeting detail screen when user enable & disable "Show meeting names"
    [Tags]    323040    P1    sanity_tc_sm
    [Setup]   Testcase Setup for shared User    count=1
    ${before_toggle_show_meeting_names}=    Get meeting details    console=console_1
    disable the show meeting names     console=console_1
    ${after_toggle_show_meeting_names}=     Get meeting details    console=console_1
    run keyword if   '${before_toggle_show_meeting_names}' != '${after_toggle_show_meeting_names}'   Log   Meeting name is showing as the meeting organizer name
    ...  ELSE  fail   Meeting is not showing the name of organizer.
    Verify meeting names show meeting organizer name   device=device_1   organizer=device_1:meeting_user
    ${before_toggle_show_meeting_names}=    Get meeting details    console=console_1
    Enable show meeting names toggle btn    console=console_1
    ${after_toggle_show_meeting_names}=     Get meeting details    console=console_1
    run keyword if   '${before_toggle_show_meeting_names}' != '${after_toggle_show_meeting_names}'   Log   Meeting name is showing as the meeting organizer name
    ...  ELSE  fail   Meeting is not showing the name of organizer.
    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC6:[Meetings]Verify the meeting name showing in Calander or notification for the new scheduled meeting
    [Tags]    315538    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User    count=1
    ${before_toggle_show_meeting_names}=    Get meeting details    console=console_1
    Enable show meeting names toggle btn     console=console_1
    ${after_toggle_show_meeting_names}=     Get meeting details    console=console_1
    run keyword if   '${before_toggle_show_meeting_names}' == '${after_toggle_show_meeting_names}'   Log   Meeting name is showing in the calendar
    ...  ELSE  fail   Meeting name is not showing in the calendar
    [Teardown]   Run Keywords    Capture Failure     AND     Come back to home screen page   console_list=console_1

TC7:[Meetings] Verify when user enable & disable "Show meeting names" toggle multiple times, changes must reflect accordingly
    [Tags]    323037    P2
    [Setup]   Testcase Setup for shared User    count=1
    repeat keyword  2 times     Enabling and disabling the toggle button       console=console_1
    [Teardown]   Run Keywords    Capture Failure     AND     Come back to home screen page   console_list=console_1

*** Keywords ***
disable the show meeting names
    [Arguments]    ${console}
    Navigate to app settings screen    ${console}
    Navigate to meeting and calling options from device settings page       ${console}  option=meeting
    Disable show meeting names toggle btn   ${console}
    come_back_from_admin_settings_page      device_list=${console}

Navigate to app settings screen
    [Arguments]    ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Enable show meeting names toggle btn
    [Arguments]    ${console}
    Navigate to app settings screen    ${console}
    Navigate to meeting and calling options from device settings page       ${console}  option=meeting
    Enable show meeting names toggle button    ${console}
    come_back_from_admin_settings_page      device_list=${console}

Verify meeting title name on header
    [Arguments]    ${console}   ${meeting}
    Verify meeting title with meeting time  ${console}   ${meeting}

Enabling and disabling the toggle button
    [Arguments]    ${console}
    ${before_toggle_show_meeting_names}=    Get meeting details    ${console}
    Enable show meeting names toggle btn     ${console}
    ${after_toggle_show_meeting_names}=     Get meeting details    ${console}
    run keyword if   '${before_toggle_show_meeting_names}' == '${after_toggle_show_meeting_names}'   Log   Meeting name is showing in the calendar
    ...  ELSE  fail   Meeting name is not showing in the calendar
    ${before_toggle_show_meeting_names}=    Get meeting details    ${console}
    disable the show meeting names     ${console}
    ${after_toggle_show_meeting_names}=     Get meeting details    ${console}
    run keyword if   '${before_toggle_show_meeting_names}' != '${after_toggle_show_meeting_names}'   Log   Meeting name is showing as the meeting organizer name
    ...  ELSE  fail   Meeting is not showing the name of organizer.
    Enable show meeting names toggle btn     ${console}

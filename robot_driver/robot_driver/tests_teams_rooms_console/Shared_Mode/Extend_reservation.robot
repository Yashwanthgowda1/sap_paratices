*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

Suite Setup         Enable extend room reservation toggle btn
Suite Teardown    Run Keywords   Suite Failure Capture    AND   Disable extend room reservation toggle btn     console=console_1

*** Test Cases ***
# Adding exclude_ftp_sm in all test till TASK 3895814 is complete
TC1:[Checkout and Extend Reservation] Verify extend reservation option is seen in More option when user joins the meeting .
    [Tags]    333005    bvt_tc_sm    sanity_tc_sm    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User   count=2
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify extend reservation in call more options  device=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1   device_list=device_2

TC2:[Checkout and extend reservation] Verify On Tapping the Extend reservation option, user should see a dialog with appropriate suggestions so that user can extend the reservation
     [Tags]    333007    P1    sanity_tc_sm    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User   count=2
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify extend reservation options   device=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1   device_list=device_2

TC3:[Checkout and Extend Reservation] Verify On clicking confirm, successful notification is seen at the bottom of the screen
    [Tags]    333011    P1    sanity_tc_sm    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User   count=2
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and extend reservation   device=console_1     time_in_minutes=30
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1   device_list=device_2

TC4:[Checkout and Extend Reservation] Verify the meeting can be extended more than twice if the meeting room is the organizer
    [Tags]    333012    P1    sanity_tc_sm    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User   count=2
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify and extend reservation   device=console_1    time_in_minutes=15
    Verify and extend reservation   device=console_1     time_in_minutes=30
    Verify and extend reservation   device=console_1     time_in_minutes=45
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1   device_list=device_2

TC5:[Checkout and Extend Reservation] Verify the first suggestion should always be selected by default.
    [Tags]    333009    P2    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User   count=2
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify tick symbol at right side along with the confirm button      device=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1   device_list=device_2

TC6:[Checkout and Extend Reservation] Verify the meeting can be extended more than twice if the meeting room is not the organizer.
    [Tags]    333013    P2    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User   count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    verify and extend reservation   device=console_1     time_in_minutes=15
    verify and extend reservation   device=console_1     time_in_minutes=30
    verify and extend reservation   device=console_1     time_in_minutes=45
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1   device_list=device_2

TC7:[Extend Reservation] Verify when user extends a meeting using meet now, it should show an error banner to the user.
    [Tags]    379923    P2    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User   count=1
    Verify precall screen after clicking on meetnow     device=device_1     console=console_1
    Verify error banner for extend meeting while using meetnow     device=console_1
    End the meeting     console=console_1
    Verify for call state    console_list=console_1      state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC8:[Extend Reservation] Verify checkout and extend reservation options are available under Meeting settings.
    [Tags]    379921    P2    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User   count=1
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1  option=meeting
    Verify extend room reservation option inside meeting settings       device=console_1
    Navigate back from metting settings page        console=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC9:[Checkout and extend reservation] Verify the suggestions shown should be 15 minutes apart
    [Tags]    333010    P2    exclude_ftp_sm
    [Setup]    Testcase Setup for shared User   count=2
    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Extend meeting suggestions should show 15min apart of time       device=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1   device_list=device_2

TC10:[Checkout and Extend reservation] User to check for the extend room reservation when user joined by using code.
    [Tags]     382123    P2    tr_tc_sm
    [Setup]    Testcase Setup for shared User   count=1
    Join with an meeting id with extend meeting details   device=console_1
    Verify meeting state   device_list=console_1    state=Connected
    verify error banner for extend meeting while using meetnow       device=console_1
    End meeting     device=console_1
    Verify meeting state    device_list=console_1    state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC11:[Extend Reservation] Verify 'Pro' tag in the admin settings for Basic Accounts.
    [Documentation]    Keep this basic license test case at the end of the suite. If you wish to add any additional test cases, please position them before this one.
    [Tags]    379924    P2
    [Setup]     Testcase console setup for basic user      count=1
    Navigate to app settings screen   console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1    option=meeting
    Verify pro tags under meetings     device=console_1    option=require_id_and_passcode
    come back from admin settings page      device_list=console_1
    Testcase Console teardown for basic user
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

*** Keywords ***
Enable extend room reservation toggle btn
    Navigate to app settings screen     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1  option=meeting
    extend room reservation toggle    device=console_1    state=on
    come back from admin settings page      device_list=console_1

Disable extend room reservation toggle btn
    [Arguments]       ${console}
    Navigate to app settings screen    ${console}
    Navigate to meeting and calling options from device settings page       ${console}  option=meeting
    extend room reservation toggle      device=${console}       state=off
    come back from admin settings page      device_list=${console}

Navigate to app settings screen
    [Arguments]   ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

End a meeting
    [Arguments]    ${console}    ${device}
    End the meeting  ${console}
    End meeting      ${device}

Navigate back from metting settings page
    [Arguments]    ${console}
    device setting back btn     ${console}
    Click on back layout btn   ${console}
    Come back to home screen page   console_list=${console}

Navigating back to home page
    [Arguments]     ${console}
    Click on close button    console_list=${console}
    Click on back layout btn   ${console}

Console setup for basic user
    Sign Out Console
    Sign Out
    Sign In    user_list=basic_user
    Sign In Console    user_list=basic_user
    Get device pairing code    device_list=device_1    console_list=console_1     user_list=basic_user

Testcase console setup for basic user
    [Arguments]    ${count}
    Console setup for basic user
    Testcase Setup for basic User   ${count}

Testcase Console teardown for basic user
    Console sign out method   console=console_1
    Sign out method    device=device_1
    Verify signin is successful    console_list=console_1     state=Sign out
    Sign in method     device=device_1      user=meeting_user
    Console sign in method     console=console_1    user=meeting_user
    Get device pairing code    device_list=device_1    console_list=console_1   user_list=meeting_user
    Verify signin is successful    console_list=console_1     state=Sign in
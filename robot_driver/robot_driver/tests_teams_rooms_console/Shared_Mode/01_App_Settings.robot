*** Settings ***
Documentation   Validating the functionality of console App settings feature.
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1:[App settings] Touch Console user has the option to sign out
    [Tags]    315461    bvt_tc_sm    sanity_tc_sm
    [Setup]  Testcase Setup for Shared User     count=1
    Console sign out method   console=console_1
    Verify signin is successful    console_list=console_1     state=Sign out
    [Teardown]  Run Keywords   Capture Failure  AND  console sign in method    console=console_1        user=meeting_user   AND   Get device pairing code    device_list=device_1    console_list=console_1     user_list=meeting_user

TC2:[App settings] User checks the about option in app settings
    [Tags]    315463    bvt_tc_sm     sanity_tc_sm
    [Setup]  Testcase Setup for shared User    count=1
    Navigate to about page     console=console_1
    Verify about page      device=console_1
    [Teardown]  Run Keywords   Capture Failure  AND    App Settings Teardown    console=console_1

TC3:[App settings] User should have the option to navigate to device settings
    [Tags]    315467    P1
    [Setup]  Testcase Setup for shared User    count=1
    Navigate to app settings screen page  console=console_1
    Tap on device settings page     console=console_1
    Come back from admin settings page      device_list=console_1
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1

TC4:[App settings] User checks there is no help option in Sign in screen and app settings
    [Tags]    322663    P1
    [Setup]  Testcase Setup for shared User    count=1
    Console sign out method   console=console_1
    Verify signin is successful    console_list=console_1     state=Sign out
    Verify no help option on sign in screen     device=console_1
    Console sign in method     console=console_1        user=meeting_user
    Get device pairing code    device_list=device_1    console_list=console_1     user_list=meeting_user
    Verify signin is successful    console_list=console_1     state=Sign in
    verify no help option on app settings   device=console_1
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1

TC5:[App Settings] Teams see and define Privacy and cookies
    [Tags]    322662    P2
    [Setup]  Testcase Setup for shared User   count=1
    Navigate to about page     console=console_1
    verify privacy cookies     device=console_1
    navigate back to more option page    device=console_1
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1

TC6:[App Settings] Teams App User to see the terms of use
    [Tags]    322661    P2
    [Setup]  Testcase Setup for shared User   count=1
    Navigate to about page   console=console_1
    verify microsoft software license terms  device=console_1
    navigate back to more option page    device=console_1
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1

# reference: Feature Test Request 451143: [FTR][MTRA] Remove calling admin settings
#TC8: [App settings] User checks the Calling option in app settings
#    [Tags]  314887    P2
#    [Setup]  Testcase Setup for shared User   count=1
#    Navigate to app settings screen page    console=console_1
#    Navigate to meeting and calling options from device settings page       console=console_1   option=calling
#    verify options inside calling   console=console_1
#    Navigate back to settings screen    console=console_1
#    [Teardown]  Run Keywords   Capture Failure  AND    Click on back layout btn   console=console_1     AND     Come back to home screen page   console_list=console_1

TC7:[App Settings] Pairing option should be added to Admin settings after Pairing for Shared account.
    [Tags]    325014    P2
    [Setup]  Testcase Setup for shared User   count=1
    Navigate to app settings screen page     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1  option=devices
    verify console pairing option   console=console_1
    Come back from admin settings page      device_list=console_1
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1

TC8:[App Settings] User Un-Pairing DUT from Touch Console
    [Tags]    315473    P2
    [Setup]  Testcase Setup for shared User   count=1
    Navigate to app settings screen page     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1  option=devices
    Verify and click on unpairing option    console=console_1
    [Teardown]  Run Keywords   Capture Failure  AND     Console sign in method     console=console_1    user=meeting_user   AND     Get device pairing code     device_list=device_1    console_list=console_1     user_list=meeting_user

TC9:[App Settings] User Un-Pairing DUT from Touch Console
    [Tags]    315471    P2
    [Setup]  Testcase Setup for shared User   count=1
    Navigate to app settings screen page     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1  option=devices
    Verify and reset the device pairing     console=console_1
    Navigate to app settings screen page     console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1  option=devices
    Verify and click on unpairing option    console=console_1
    [Teardown]  Run Keywords   Capture Failure  AND     Console sign in method     console=console_1    user=meeting_user   AND     Get device pairing code  device_list=device_1    console_list=console_1     user_list=meeting_user

TC10:[Call-App] Verify the soft keyboard after dialing on the dial pad
    [Tags]    444610    P2
    [Setup]  Testcase Setup for shared User   count=1
    Verify soft keyboard hiding on while search and calling function        console=console_1
    Click on back layout btn    console=console_1
    [Teardown]  Run Keywords   Capture Failure  AND     Come back to home screen page   console_list=console_1

TC11:[App settings] User checks 'Report an issue' option in app settings
    [Tags]      315465    bvt_tc_sm    sanity_tc_sm
    [Setup]  Testcase Setup for shared User    count=1
    Navigate to app settings screen page    console=console_1
    Verify report an issue should not present under settings    device=console_1
    [Teardown]  Run Keywords   Capture Failure  AND    App Settings Teardown    console=console_1

TC12:[App Settings] Teams App User to view the third-party Notices of use
    [Tags]      322660    P2
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to about page   console=console_1
    verify third party software and information     device=console_1
    navigate back to more option page    device=console_1
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1

*** Keywords ***
Navigate to app settings screen page
    [Arguments]     ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

App Settings Teardown
    [Arguments]     ${console}
    Click on close button    console_list=${console}
    Click on back layout btn   ${console}
    Come back to home screen page   console_list=${console}

Navigate to about page
    [Arguments]     ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}
    click on about page  device=${console}

Navigate back to settings screen
    [Arguments]     ${console}
    Tap on device right corner  ${console}
    Click back btn   ${console}
    device setting back btn     ${console}
    Click on close button    console_list=${console}







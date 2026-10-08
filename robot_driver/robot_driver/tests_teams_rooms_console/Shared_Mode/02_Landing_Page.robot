*** Settings ***
Documentation   Validating the functionality of Console Landing Page feature.
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1:[Landing Page] DUT user able to increase and decrease the volume on landing page using more button
    [Tags]    314903    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User     count=1
    Tap on more option   console=console_1
    Verify functionality of volume button    console=console_1   button=UP
    Verify functionality of volume button    console=console_1   button=Down
    [Teardown]   Run Keywords    Capture Failure  AND    Test Case Teardown    console=console_1

TC2:[Landing Page] Verify Highlighted background , Teams Icon , Join button for current meeting
    [Tags]     314935    P1
    [Setup]   Testcase Setup for shared User     count=1
    Verify Home page options   console=console_1:meeting_user
    verify meeting display on home page    console=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC3:[Landing Page] DUT user able navigate "about" via Landing page
    [Tags]      314915      bvt_tc_sm      sanity_tc_sm
    [Setup]  Testcase Setup for shared User     count=1
    Tap on more option     console=console_1
    Navigate to settings page and verify options    console=console_1
    Navigate and verify about page  console=console_1
    [Teardown]   Run Keywords   Capture Failure  AND   App Settings Teardown    console=console_1

TC4:[Landing Page] DUT user able to navigate settings via Landing Page
    [Tags]     314905    P2
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to more button and validate options    console=console_1
    Navigate to settings page and verify options   console=console_1
    [Teardown]   Run Keywords   Capture Failure  AND   App Settings Teardown    console=console_1

#TC5: [Landing Page] DUT user able navigate "calling" via Landing Page
#    [Tags]     314909    P2
#    [Setup]  Testcase Setup for shared User     count=1
#    Navigate to more button and validate options    console=console_1
#    Navigate to settings page and verify options   console=console_1
#    Navigate to meeting and calling options from device settings page   console=console_1   option=calling
#    Come back from admin settings page      device_list=console_1
#    [Teardown]  Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC5:[Landing Page] DUT user is able to navigate "Sign out" via Landing page
    [Tags]     314920    P2
    [Setup]  Testcase Setup for shared User     count=1
    Console sign out method   console=console_1
    Verify signin is successful    console_list=console_1     state=Sign out
    [Teardown]  Run Keywords   Capture Failure    AND   console sign in method    console=console_1    user=meeting_user  AND  Get device pairing code    device_list=device_1    console_list=console_1   user_list=meeting_user

TC6:[Proximity Join] DUT user able enable or disable the Proximity Join via Landing Page
    [Tags]     314907    P2
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to more button and validate options        console=console_1
    Navigate to settings page and verify options      console=console_1
    Navigate to meeting and calling options from device settings page   console=console_1   option=general
    Verify proximity join meeting enabling and disabling state      console=console_1       state=off
    Verify proximity join meeting enabling and disabling state      console=console_1       state=on
    Come back from admin settings page      device_list=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC7:[Landing Page] DUT user is able to navigate "Device Settings" via Landing Page
    [Tags]     314918   P2
    [Setup]  Testcase Setup for shared User     count=1
    Navigate to more button and validate options        console=console_1
    Navigate to settings page and verify options      console=console_1
    Navigate to meeting and calling options from device settings page   console=console_1   option=settings_page
    Come back from admin settings page      device_list=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

*** Keywords ***
Test Case Teardown
    [Arguments]     ${console}
    Click on back layout btn   ${console}
    Come back to home screen page   console_list=${console}

Navigate to more button and validate options
    [Arguments]     ${console}
    Tap on more option  ${console}
    Verify more options   ${console}

Navigate to settings page and verify options
    [Arguments]     ${console}
    Tap on settings page   ${console}
    Verify options inside settings page     console=console_1:meeting_user

App Settings Teardown
    [Arguments]     ${console}
    Click on close button    console_list=${console}
    Click on back layout btn   ${console}
    Come back to home screen page   console_list=${console}

Verify Home page options
    [Arguments]     ${console}
    validate user details along with home screen options        ${console}

End up call
    [Arguments]    ${console}    ${device}
    Disconnect the call  ${console}
    Disconnect call     ${device}

Navigate to about page
    [Arguments]     ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}
    click on about page  device=${console}

Navigate and verify about page
    [Arguments]     ${console}
    click on about page  device=${console}
    Verify about page  device=${console}

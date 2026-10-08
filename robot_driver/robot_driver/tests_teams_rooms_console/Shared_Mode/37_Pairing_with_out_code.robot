*** Settings ***
Documentation   Validating the functionality of console pairing with and without code.
Resource    ../../resources/keywords/common.robot

Suite Setup     Console sign out method   console=console_1
Suite Teardown   Suite Failure Capture

*** Test Cases ***
TC1:[Pairing without code] Verify Auto pairing message displaying on console after detecting device
    [Tags]      437304      bvt_tc_sm       sanity_tc_sm
    [Setup]  Testcase Setup for ZTP    count=1
    User checking the auto pairing message     console=console_1       user=meeting_user    pairing=auto
    Verify signin is successful   console_list=console_1     state=Sign in
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1   AND     Console sign out method   console=console_1

TC2:[Pairing without code] Verify console screen when No available FoR devices
    [Tags]      437302      P2
    [Setup]  Testcase Setup for ZTP    count=1
    User checking no available FoR device on console screen     console=console_1
    [Teardown]  Run Keywords   Capture Failure  AND     Console sign out method     console=console_1

TC3:[Pairing without code] Verify Pairing code when Auto-pairing starts
    [Tags]      437649      P2
    [Setup]  Testcase Setup for ZTP    count=1
    Console sign in method for pairing without code     console=console_1   user=meeting_user
    Verify user auto and manual pairing     console=console_1   pairing=auto    clicking=True
    Verify signin is successful   console_list=console_1     state=Sign in
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1   AND     Console sign out method     console=console_1

TC4:[Pairing without code] Verify Auto pairing in 10 secs after detecting DUT
    [Tags]      437638      P1      sanity_tc_sm
    [Setup]  Testcase Setup for ZTP    count=1
    User checking the auto pairing message     console=console_1    user=meeting_user    pairing=auto
    Verify signin is successful   console_list=console_1     state=Sign in
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1   AND     Console sign out method     console=console_1

TC5:[Pairing without code] Verify Manual pairing before Auto pairing time out.
    [Tags]      437648      bvt_tc_sm       sanity_tc_sm
    [Setup]  Testcase Setup for ZTP    count=1
    Console sign in method for pairing without code     console=console_1   user=meeting_user
    Verify user auto and manual pairing     console=console_1   pairing=auto    clicking=True
    Verify signin is successful   console_list=console_1     state=Sign in
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1

TC6:[Pairing without code] Verify Auto-pairing when more than one DUT available
    [Tags]     437650        bvt_tc_sm       sanity_tc_sm
    [Setup]  Testcase Setup for ZTP    count=1
    Signin with other user    device=device_2     other_user_account=device_1:meeting_user
    Verify Auto-pairing when more than one DUT available     device_list=device_1    console_list=console_1     user_list=meeting_user      multi_pair=True
    Verify signin is successful    console_list=console_1     state=Sign in
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1   AND     Console sign out method   console=console_1

TC7:[Pairing without code] Verify Manual pairing when more than one DUT available
    [Tags]      437651
    [Setup]  Testcase Setup for ZTP    count=1
    Signin with other user    device=device_2     other_user_account=device_1:meeting_user
    Verify Auto-Pairing When Multiple DUTs Are Available and Perform Manual Pairing     device_list=device_1    console_list=console_1     user_list=meeting_user
    Verify signin is successful   console_list=console_1     state=Sign in
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1   AND     Console sign out method   console=console_1

TC8:[Pairing without code] Verify search again button when Auto pairing timer starts
    [Tags]      437653
    [Setup]  Testcase Setup for ZTP    count=1
    Verify search again button when Auto pairing timer starts    console=console_1
    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1   AND     Console sign out method   console=console_1

*** Keywords ***
Navigate to app settings screen page
    [Arguments]     ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

User checking the auto pairing message
    [Arguments]     ${console}      ${user}     ${pairing}
    Console sign in method for pairing without code     ${console}      ${user}
    Verify user auto and manual pairing     ${console}      ${pairing}

User checking no available FoR device on console screen
    [Arguments]     ${console}
    Console sign in method for pairing without code     ${console}
    Verify user not able to find any device message with search button     ${console}

Verify Auto-pairing when more than one DUT available
    [Arguments]     ${device_list}      ${console_list}     ${user_list}     ${multi_pair}
    console sign in method    console=console_1       user=meeting_user
    Get device pairing code    ${device_list}      ${console_list}          ${user_list}        ${multi_pair}

Verify Auto-Pairing When Multiple DUTs Are Available and Perform Manual Pairing
    [Arguments]     ${device_list}      ${console_list}     ${user_list}
    console sign in method    console=console_1       user=meeting_user
    Get device pairing code    ${device_list}      ${console_list}          ${user_list}

Verify search again button when Auto pairing timer starts
    [Arguments]     ${console}
    Console sign in method for pairing without code     ${console}
    verify pairing should stop when click on search     ${console}
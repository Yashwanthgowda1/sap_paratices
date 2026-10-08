*** Settings ***
Documentation   Emergency Calls
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_10s_to_display_emergency_location} =    10

*** Test Cases ***
TC1:[Emergency call] Check auto -dial for emergency number
    # Dial 933 for Emergency Calling
    [Tags]    315449    bvt    bvt_tc_sm    sanity_tc_sm
    [Setup]  Testcase Setup for shared User      count=1
    Verify should not autodial the emergency number  console=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC2:[Emergency call] User must sign in to make an emergency call
    [Tags]    315447    P1    sanity_tc_sm
    [Setup]  Testcase Setup for shared User      count=1
    Console sign out method   console=console_1
    Verify signin is successful    console_list=console_1     state=Sign out
    Verify sign in to make an emergency call    device=console_1
    Sign out method    device=device_1
    Verify sign in to make an emergency call    device=device_1
    Sign in method    device=device_1    user=meeting_user
    [Teardown]   Run Keywords    Capture Failure  AND  console sign in method    console=console_1       user=meeting_user   AND   Get device pairing code    device_list=device_1    console_list=console_1   user_list=meeting_user

TC3:[Emergency call] Location support in emergency call
    [Tags]    237791
    [Setup]   Testcase Setup for shared User      count=1
    Dial emergency number      console=console_1
    Wait for Some Time    time=${wait_10s_to_display_emergency_location}
    Verify emergency call location and number    device=device_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1


TC4:[Emergency call] App must share emergency data to firmware after registration
    [Tags]    313030
    [Setup]   Testcase Setup for shared User      count=1
    Verify emergency info after register             device=console_1
    [Teardown]   Run Keywords    Capture Failure     AND    Come back to home screen page   console_list=console_1

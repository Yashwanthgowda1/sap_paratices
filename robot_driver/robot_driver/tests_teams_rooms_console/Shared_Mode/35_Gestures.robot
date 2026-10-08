*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Test Cases ***
TC1:[Gestures] Touch console user should not be allowed to swipe out the Teams App by swiping left/right when DUT is in Kiosk mode
    [Tags]    322432    P1    sanity_tc_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for shared User      count=1
    verify Homescreen on Console    console=console_1:meeting_user
    perform gestures on homescreen    device=console_1    action=swipe_right
    verify Homescreen on Console    console=console_1:meeting_user
    perform gestures on homescreen    device=console_1    action=swipe_left
    verify Homescreen on Console    console=console_1:meeting_user
    [Teardown]  Capture on Failure

TC2:[Gestures] Touch console user should not be allowed to swipe out the Teams App by swiping Up/down when DUT is in Kiosk mode.
    [Tags]    322433    P1
    [Setup]  Testcase Setup for shared User      count=1
    verify Homescreen on Console    console=console_1:meeting_user
    perform gestures on homescreen   device=console_1    action=swipe_down
    verify Homescreen on Console    console=console_1:meeting_user
    perform gestures on homescreen    device=console_1    action=swipe_up
    verify Homescreen on Console    console=console_1:meeting_user
    [Teardown]  Capture on Failure

TC3:[Gestures] Touch console user should not be allowed to kill the Teams App by long press drag on screen when DUT is in Kiosk mode
    [Tags]    322434    P1
    [Setup]  Testcase Setup for shared User      count=1
    verify Homescreen on Console    console=console_1:meeting_user
    perform gestures on homescreen    device=console_1    action=drag_and_drop
    verify Homescreen on Console    console=console_1:meeting_user
    [Teardown]  Capture on Failure

TC4:[Gestures] Touch console user should not be allowed to exit Teams App by using any hard key combinations
    [Tags]    322435    P2
    [Setup]  Testcase Setup for shared User      count=1
    verify Homescreen on Console    console=console_1:meeting_user
    perform gestures on homescreen    device=console_1    action=swipe_down
    perform gestures on homescreen    device=console_1    action=swipe_top_to_bottom
    verify Homescreen on Console    console=console_1:meeting_user
    [Teardown]  Capture on Failure

*** Keywords ***
verify Homescreen on Console
    [Arguments]     ${console}
    validate user details along with home screen options        ${console}


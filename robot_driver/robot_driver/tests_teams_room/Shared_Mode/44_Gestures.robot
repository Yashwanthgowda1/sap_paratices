*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_time} =  3
${action_time} =  5

*** Test Cases ***
TC1:[Gestures] DUT user try to swipe out the App by swiping left/right when device is in Kiosk mode
    [Tags]      304788       bvt_sm     sanity_sm
    [Setup]    Testcase Setup for Meeting User   count=1
    Verify home page screen    device=device_1
    perform gestures on homescreen    device=device_1    action=swipe_right
    Verify home page screen    device=device_1
    perform gestures on homescreen    device=device_1    action=swipe_left
    Verify home page screen    device=device_1
    [Teardown]  Capture on Failure

TC2:[Gestures] DUT user try to swipe out the App by swiping Up/down when device is in Kiosk mode.
    [Tags]      304789      P1
    [Setup]    Testcase Setup for Meeting User   count=1
    Verify home page screen    device=device_1
    perform gestures on homescreen   device=device_1    action=swipe_down
    Verify home page screen    device=device_1
    perform gestures on homescreen    device=device_1    action=swipe_up
    Verify home page screen    device=device_1
    [Teardown]  Capture on Failure

TC3:[Gestures] DUT user try to kill the App by long press drag on screen when device is in Kiosk mode
    [Tags]      304790       P1
    [Setup]    Testcase Setup for Meeting User   count=1
    Verify home page screen    device=device_1
    perform gestures on homescreen    device=device_1    action=drag_and_drop
    Verify home page screen    device=device_1
    [Teardown]  Capture on Failure

TC4:[Gestures] DUT user should not be allowed to exit Teams App by using any hard key combinations
    [Tags]  304791      P2
    [Setup]    Testcase Setup for Meeting User   count=1
    Verify home page screen    device=device_1
    perform gestures on homescreen    device=device_1    action=swipe_down
    perform gestures on homescreen    device=device_1    action=swipe_top_to_bottom
    Verify home page screen    device=device_1
    [Teardown]  Capture on Failure

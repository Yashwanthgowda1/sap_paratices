*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1:[Gestures] DUT user try to swipe out the App by swiping left/right when device is in Kiosk mode
    [Tags]  307603
    [Setup]  Testcase Setup   count=1
    verify room parameters  device=device_1
    perform gestures on homescreen    device=device_1    action=swipe_right
    verify room parameters  device=device_1
    perform gestures on homescreen    device=device_1    action=swipe_left
    verify room parameters  device=device_1
    [Teardown]  Capture on Failure

TC2:[Gestures] DUT user try to swipe out the App by swiping Up/down when device is in Kiosk mode.
    [Tags]  307605
    [Setup]  Testcase Setup   count=1
    verify room parameters  device=device_1
    perform gestures on homescreen    device=device_1    action=swipe_down
    verify room parameters  device=device_1
    perform gestures on homescreen    device=device_1    action=swipe_up
    verify room parameters  device=device_1
    [Teardown]  Capture on Failure

TC3:[Gestures] DUT user try to kill the App by long press drag on screen when device is in Kiosk mode
    [Tags]  307607
    [Setup]  Testcase Setup   count=1
    verify room parameters  device=device_1
    perform gestures on homescreen    device=device_1    action=drag_and_drop
    verify room parameters  device=device_1
    [Teardown]  Capture on Failure

TC4:[Gestures] DUT user try to split the App by swiping from top to bottom of the screen when device is in Kiosk mode
    [Tags]  307609
    [Setup]  Testcase Setup   count=1
    verify room parameters  device=device_1
    perform gestures on homescreen    device=device_1    action=swipe_top_to_bottom
    verify room parameters  device=device_1
    [Teardown]  Capture on Failure

TC5:[Gestures] DUT user try to zoom-in the App by double touch on the screen when device is in Kiosk mode
    [Tags]  307613
    verify room parameters  device=device_1
    perform gestures on homescreen    device=device_1    action=double_tap
    verify room parameters  device=device_1
    [Teardown]  Capture on Failure
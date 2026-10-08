#*** Settings ***
#Resource    ../resources/keywords/common.robot
#*** Variables ***
#*** Test Cases ***
#TC4: [Landing Page] All-day meetings list should be display after tapping on the All-day title bar
#    [Tags]  238037    bvt   bvt_sm      sanity_sm
#    [Setup]  Testcase Setup for Meeting User      count=1
#    Verify default option present on landing page and validate   device=device_1
#    Tap on all day meetings title bar and validate   device=device_1
#    Get meetings details present under all day title bar   device=device_1
#    [Teardown]  Run Keywords   Capture on Failure   AND   Navigate back to meetings   device=device_1   AND   Come back to home screen    device_list=device_1
#
#TC4:[Landing Page]All-day meeting tittle should be hide when there are no All-day meetings
#    [Tags]  238036   P2
#    [Setup]  Testcase Setup for Meeting User      count=1
#    Verify home page screen    device=device_1
#    tap on all day meetings title bar and validate    device=device_1
#   [Teardown]   Run Keywords   Capture on Failure  AND  Navigate back to meetings   device=device_1     AND  Come back to home screen     device_list=device_1
#
#TC3:[Landing Page] All-day meeting should be display in landing page
#    [Tags]  238035    P2
#    [Setup]  Testcase Setup for Meeting User   count=1
#    Verify default option present on landing page and validate   device=device_1
#    Tap on all day meetings title bar and validate  device=device_1
#    [Teardown]  Run Keywords   Capture on Failure   AND   Navigate back to meetings   device=device_1  AND   Come back to home screen    device_list=device_1

#*** Keywords ***

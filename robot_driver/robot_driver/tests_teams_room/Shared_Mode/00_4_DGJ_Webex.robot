*** Settings ***
Documentation   Meeting created as prerequisite before test execution make sure that  Webex meeting is created
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Test Cases ***
TC1:[DGJ]DUT user should have option to enable Webex meeting
    [Tags]     328326        bvt_sm       sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    DUT user should have option to enable Webex meeting     device=device_1  state=off
    Come back from admin settings page    device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

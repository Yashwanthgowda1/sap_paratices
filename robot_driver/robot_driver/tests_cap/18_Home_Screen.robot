*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Touch and Navigation] CAP user UI verification
    [Tags]   402408    sanity_cap   bvt_cap    P0
    [Setup]  Testcase Setup for CAP User    count=1
    verify home screen UI for cap     device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC2 : [Touch and Navigation]Verify DUT should navigate to Dialpad when user tab on Dialpad from People tab.
    [Tags]   402411     sanity_cap   bvt_cap    P0
    [Setup]  Testcase Setup for CAP User     count=1
    navigate to dial pad tab for cap    device=device_1
    navigate to people tab from home screen for cap    device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

*** Keywords ***

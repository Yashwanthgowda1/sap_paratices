*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Setup     CAP Setup Main
Suite Teardown   Run keywords    Suite Failure Capture  AND  Disable advance calling option       device=device_1

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1: [Advance calling] [Settings] [Home screen] DUT user to enable Advance calling
    [Tags]   452601   bvt_lcp     sanity_lcp          phonesCY23_4
    [Setup]   Testcase Setup for CAP Premium User      count=1
    verify ui post signin       device=device_1:cap_search_enabled
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2: [Advance calling] [People] DUT user verify the people tab.
    [Tags]   452615   bvt_lcp     sanity_lcp        phonesCY23_4
    [Setup]   Testcase Setup for CAP Premium User    count=2
    navigate to people tab    device=device_1
    verify options inside people tab for lcp   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3: [Advance calling] [Home Screen] DUT user to verify tiles on the home screen.
    [Tags]   452603   bvt_lcp     sanity_lcp         phonesCY23_4
    [Setup]   Testcase Setup for CAP Premium User     count=1
    verify ui post signin       device=device_1:cap_search_enabled
    verify date and time on lcp homescreen   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

*** Keywords ***
CAP Setup Main
   Testcase Setup for CAP User      count=1
   Verify and enable advance calling option       device=device_1
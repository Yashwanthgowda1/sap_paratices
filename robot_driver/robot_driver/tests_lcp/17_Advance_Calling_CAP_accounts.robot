*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1: [CAP Policy] Verify the call apps.
    [Tags]  452579    sanity_lcp        phonesCY23_4
    [Setup]   Testcase Setup for CAP User      count=1
    verify ui post signin     device=device_1:cap_search_enabled
    verify calls tab when signed in with cap account      device=device_1
    Device Setting Back     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2: [People] DUT user verify the people tab
    [Tags]  452585     sanity_lcp       phonesCY23_4
    [Setup]   Testcase Setup for CAP User      count=1
    navigate to people tab    device=device_1
    verify options inside people tab for lcp   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3: [Settings Consistency] Meeting settings should not be shown for LCP with CAP or advanced CAP
    [Tags]  464949  bvt_lcp     sanity_lcp
    [Setup]  Testcase Setup for CAP User    count=1
    verify meetings btn not present under app settings      device=device_1
    verify and enable advance calling option     device=device_1
    verify meetings btn not present under app settings      device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

*** Keywords ***

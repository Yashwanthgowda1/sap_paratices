*** Settings ***
Resource    ../resources/keywords/common.robot


*** Test Cases ***
TC1: [Device Properties] Check device type
    [Tags]  261892   P1  sanity_cap        Certification_cap
    [Setup]  Testcase Setup for CAP User     count=1
    Check device type   device=device_1
    [Teardown]   Run Keywords   Capture on Failure   AND    Come back to home screen   device_list=device_1

TC2: [Device Properties] Check device capabilities
    [Tags]  261893   P2        Certification_cap    sanity_cap    bvt_cap
    [Setup]  Testcase Setup for CAP User     count=1
    Check device capabilities   device=device_1
    [Teardown]   Run Keywords   Capture on Failure   AND    Come back to home screen   device_list=device_1


*** Keywords ***

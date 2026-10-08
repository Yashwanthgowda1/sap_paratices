*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Test Cases ***
TC1:[Device Properties] Check device type
    [Tags]    322328    P1    sanity_tc_sm
    [Setup]  Testcase Setup for shared User     count=1
    Check device type and validate    device=device_1
    User checks device type     console=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1


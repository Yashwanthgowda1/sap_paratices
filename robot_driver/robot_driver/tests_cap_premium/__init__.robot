*** Settings ***
Resource    ../resources/keywords/common.robot


Suite Setup      Run Keywords    Cap User Setup    AND    Verify and enable advance calling option    device=device_1
Suite Teardown      Run keyword and ignore error    System Teardown for CAP Premium


*** Variables ***


*** Keywords ***

*** Settings ***
Resource  ../../library/common_web.robot
Library  ../../resource/keywords/sigin.py
Library    SeleniumLibrary


*** Test Cases ***
Signin To OrangeHRM
    [Tags]    56754    smoke
    Open Web Browser And Go To URL
	Wait Until Page Contains Element    //input[@name="username"]    10s
    [Teardown]

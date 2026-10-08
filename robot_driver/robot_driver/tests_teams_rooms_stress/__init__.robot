*** Settings ***
Resource    ../resources/keywords/common.robot
Suite Setup     Teams Room Setup


*** Variables ***


*** Keywords ***
Teams Room Setup
    ${config} =     Read Config
    set suite variable      ${config}   ${config}
    ${status}   capture config details
    Run keyword if  '${status}' == 'True'    Log    ${config}
    ...  ELSE   Log   Partner Devices doesn't capture config details
    Setup Devices
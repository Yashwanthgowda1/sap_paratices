*** Settings ***
Resource    ../resources/keywords/common.robot

*** Test Cases ***
TC1: [Device Properties] Check firmware version
    [Tags]  306152   bvt_tpc     sanity_tpc  P0
    check device firmware version  device=device_1


TC2: [Device Properties] Check device type
    [Tags]  306153   sanity_tpc  P1
    Check device type    device=device_1


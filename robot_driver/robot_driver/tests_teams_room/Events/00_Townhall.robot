*** Settings ***
Documentation    Validating the functionality of Room Townhall features
Resource    resources/keywords/common.robot

*** Variables ***

*** Test Cases ***
TC1:[Townhall] Verify Townhall Experience in MTRA
    [Tags]    400001    tr_th_bvt    tr_th_sanity    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Join meeting    device=device_1     meeting=town_hall
    Wait for Some Time    time=5s
    turn on live caption  device=device_1   call_more_options=False
    Wait for Some Time    time=30s
    turn off live caption    device=device_1  call_more_options=False
    Wait for Some Time    time=5s
    Verify reactions buttons in call control     device=device_1    check_raise_hand=False
    Tap on like button     device=device_1
    Tap on clap button     device=device_1
    Tap on heart button     device=device_1
    Tap on laugh button     device=device_1
    Tap on surprise button     device=device_1
    Verify functionality of volume button    console=console_1   button=UP     state=In_meeting
    Verify functionality of volume button    console=console_1   button=Down   state=In_meeting
    Wait for Some Time    time=5s
    End meeting   device=device_1
    [Teardown]  Capture on Failure

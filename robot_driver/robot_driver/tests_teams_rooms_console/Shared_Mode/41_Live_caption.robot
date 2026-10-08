*** Settings ***
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_time} =  3s

*** Test Cases ***
TC1:[Live Caption 1:1 call] Verify DUT user is able to on and off the Live caption during the Call.
    [Tags]     444743    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User   count=2
    Make outgoing call using dial pad    from_device=console_1     to_device=device_2
    Wait for Some Time    time=${wait_time}
    Accept incoming call      device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Wait for Some Time    time=${wait_time}
    Turn on live captions and validate   device=console_1
    Turn off live captions and validate  device=console_1
    Disconnect the call      console=console_1
    Verify for call state     console_list=console_1     device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

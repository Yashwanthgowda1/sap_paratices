*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Setup     Idle mode recovery optimization and presence resilience setup
Suite Teardown    Run Keywords        Suite Failure Capture        AND        Sign out method       device=device_2        AND        Wait for Some Time    time=20        AND        signin method for lcp        device=device_2 

*** Variables ***
${action_time} =  10
${wait_time_20s}=   20

*** Test Cases ***
TC1 : [Presence] Verify that if DUT changes Presence, it should reflect on both TDC and DUT
    [Tags]      243344      sanity_lcp        Certification_lcp
    [Setup]     Testcase Setup for idle mode recovery optimization and presence resilience     count=3
    Signin with other user    device=device_2     other_user_account=device_1
    Select user presence   device=device_1     state=Available
    Verify user presence   device=device_1     state=Available
    Select user presence   device=device_1     state=Busy
    Wait for Some Time    time=${wait_time}
    navigate to calls tab  device=device_2
    click on home bar icon      device=device_2
    Verify user presence   device=device_2     state=Busy
    Verify user presence from other user    from_device=device_3      to_device=device_1     state=Busy
    [Teardown]  Run Keywords    Capture on Failure   AND   Select user presence   device=device_1     state=available    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2 : [Presence] Verify that if TDC changes Presence, it should reflect at both TDC and DUT
    [Tags]      243346      sanity_lcp
    [Setup]     Testcase Setup for idle mode recovery optimization and presence resilience     count=3
    Signin with other user    device=device_2   other_user_account=device_1
    Select user presence   device=device_1     state=Available
    Verify user presence   device=device_1     state=Available
    Select user presence   device=device_1     state=DND
    Wait for Some Time    time=${wait_time}
    Wait for Some Time    time=${wait_time}
    navigate to calls tab  device=device_2
    click on home bar icon      device=device_2
    Verify user presence   device=device_2     state=DND
    Verify user presence from other user    from_device=device_3      to_device=device_1     state=DND
    [Teardown]  Run Keywords    Capture on Failure   AND   Select user presence   device=device_1     state=available    AND    Come back to home screen    device_list=device_1,device_2,device_3


*** Keywords ***
Idle mode recovery optimization and presence resilience setup
    Testcase Setup   count=3
    Signin with other user    device=device_2   other_user_account=device_1

*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Setup     Idle mode recovery optimization and presence resilience setup
Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Presence] Verify the DUT user presence should be as "In a call" when TDC1 user is in Call with TDC2
    [Tags]   416961        bvt_cap    sanity_cap
    [Setup]   Testcase Setup for idle mode recovery optimization and presence resilience      count=3
    Make outgoing call using display name     from_device=device_2     to_device=device_3
    Pick incoming call     device=device_3
    Wait for Some Time      time=${wait_time}
    verify call state     device_list=device_2,device_3     state=Connected
    Verify user presence    device=device_1     state=In a call
    Disconnect call     device=device_2
    verify call state     device_list=device_2,device_3     state=disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3


*** Keywords ***
Idle mode recovery optimization and presence resilience setup
    Testcase Setup for CAP User   count=3
    Signin with other user    device=device_2   other_user_account=device_1:cap_search_enabled
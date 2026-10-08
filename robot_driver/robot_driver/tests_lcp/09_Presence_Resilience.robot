*** Settings ***

Resource    ../resources/keywords/common.robot

Suite Setup     Idle mode recovery optimization and presence resilience setup
Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Presence] Verify that if TDC changes Presence, it should reflect on DUT home screen.
    [Tags]     417083    tp_lcp    P2
    [Setup]     Testcase Setup for idle mode recovery optimization and presence resilience     count=3
    Select user presence   device=device_2     state=DND
    Verify user presence   device=device_2     state=DND
    open settings page      device=device_1
    click back      device=device_1
    Verify user presence   device=device_1     state=DND
    [Teardown]   Run Keywords    Capture on Failure    AND    close the hamburger menu    device=device_1   AND    Select user presence   device=device_2     state=available    AND      Come back to home screen    device_list=device_1,device_2,device_3

TC2 : [Presence] Verify the DUT user presence should be as "In a call" when TDC1 user is in Call with TDC2
    [Tags]    417084     P0    bvt_lcp    sanity_lcp    ftp_scope
    [Setup]     Testcase Setup for idle mode recovery optimization and presence resilience     count=3
    click on calls tab   device=device_2
    Make outgoing call using display name     from_device=device_2     to_device=device_3
    Pick incoming call     device=device_3
    Wait for Some Time      time=${wait_time}
    verify call state     device_list=device_2,device_3     state=Connected
    open settings page      device=device_1
    click back      device=device_1
    Verify user presence    device=device_1     state=In a call
    Disconnect call     device=device_2
    verify call state     device_list=device_2,device_3     state=disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND    close the hamburger menu    device=device_1   AND   Come back to home screen    device_list=device_1,device_2

*** Keywords ***

Idle mode recovery optimization and presence resilience setup
    Testcase Setup   count=3
    Signin with other user    device=device_2   other_user_account=device_1

Test Case Teardown
    [Arguments]     ${devices}      ${count}
    come_back_home_screen_for_user    ${count}
    Teardown Meeting Test Case     ${devices}
    remove_meeting_from_calender_for_user   ${count}
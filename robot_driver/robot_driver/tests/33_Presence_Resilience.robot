*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation   Suite Setup Requirements : This suite requires minimum of 3 devices in config
...             Purpose : Device_2 should sign-in with Device_1 account


Suite Setup     Idle mode recovery optimization and presence resilience setup
Suite Teardown    Run Keywords    Suite Failure Capture    AND    verify and enable presence to Available    AND    Sign out and sign in device 2

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC01 :[Presence] Verify the DUT user presence should be as "In a call" when TDC1 user is in Call with TDC2
    [Tags]  416949     P0       bvt_tp   sanity_tp      bvt_pr
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
    [Teardown]   Run Keywords    Capture on Failure  AND    close the hamburger menu    device=device_1   AND   Come back to home screen    device_list=device_1,device_2

TC02 :[Presence] Verify that if TDC changes Presence, it should reflect on DUT home screen.
    [Tags]     416948    P2
    [Setup]     Testcase Setup for idle mode recovery optimization and presence resilience     count=3
    Select user presence   device=device_2     state=DND
    Verify user presence   device=device_2     state=DND
    open settings page      device=device_1
    click back      device=device_1
    Verify user presence   device=device_1     state=DND
    [Teardown]   Run Keywords    Capture on Failure  AND    close the hamburger menu    device=device_1   AND    Select user presence   device=device_2     state=available    AND      Come back to home screen    device_list=device_1,device_2,device_3

TC03 :[Call forward on home screen] Verify the DUT user should display the changes done for call forwarding in another TDC user /DUT user.
    [Tags]     452519    P1    phonesCY23_4
    [Setup]     Testcase Setup for idle mode recovery optimization and presence resilience     count=2
    open settings page      device=device_1
    Set Call Forwarding    device=device_1
    verify and change toggle status for call forwarding display on home screen    device=device_1      status=on
    verify call forwarding label status on home screen      device=device_1         status=voicemail
    verify call forwarding status on calling            device=device_2         option=voicemail
    verify call forwarding label status on home screen      device=device_2         status=voicemail
    Enable call forwarding to contacts     from_device=device_1   contact_device=device_2
    verify call forwarding label status on home screen      device=device_1         status=contact_or_number        to_device=device_2
    verify call forwarding status on calling            device=device_2         option=contact_or_number        to_device=device_2
    verify call forwarding label status on home screen      device=device_2         status=contact_or_number        to_device=device_2
    Enable call forwarding to delegates    from_device=device_1         contact_device=device_2
    verify call forwarding label status on home screen      device=device_1         status=delegate
    verify call forwarding status on calling            device=device_2         option=delegate
    verify call forwarding label status on home screen      device=device_2         status=delegate
    Enable call forwarding to call group     from_device=device_1       contact_device=device_2
    verify call forwarding label status on home screen      device=device_1         status=call_group
    verify call forwarding status on calling            device=device_2         option=call_group
    verify call forwarding label status on home screen      device=device_2         status=call_group
    [Teardown]   run keywords  Capture on Failure    AND        dismiss call forwarding pop up on home screen       device=device_1    AND     Disable Call forward   devices=device_1,device_2     AND     verify and change toggle status for call forwarding display on home screen    device=device_1      status=off

*** Keywords ***
Idle mode recovery optimization and presence resilience setup
    Testcase Setup   count=3
    Signin with other user    device=device_2   other_user_account=device_1

Test Case Teardown
    [Arguments]     ${devices}      ${count}
    come_back_home_screen_for_user    ${count}
    Teardown Meeting Test Case     ${devices}
    remove_meeting_from_calender_for_user   ${count}

Disable Call forward
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    verify and disable call forwarding    device=device_1

Sign out and sign in device 2
    Sign out method    device_2
    Sign in method     device_2

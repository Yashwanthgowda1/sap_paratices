*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown     Suite Failure Capture

*** Variables ***
${wait_time_20s} =  20


*** Test Cases ***
TC1 : Verify that missed call notification has "private line" badge if the call was on private line.
    [Tags]  456485  Sanity_CAPPremium    P1
    [Setup]    Testcase Setup for CAP Premium User   count=2
    Clear notification from home screen     device=device_1
    Click on calls tab   device=device_2
    Make outgoing call using privateline number    from_device=device_2      to_device=device_1:cap_search_enabled
    verify privateline label on call screen     device=device_1
    Verify Incoming call    device=device_1     status=Appear
    Wait for Some Time    time=${wait_time_20s}
    wait until call disconnected    device=device_1
    verify home screen missed call notification     device=device_1     to_device=device_2      call_type=private_line
    [Teardown]  run keywords  Capture on Failure        AND     Come back to home screen    device_list=device_1,device_2

TC2 : Verify the new design for missed call home screen notification.
    [Tags]  456484   BVT_CAPPremium     Sanity_CAPPremium  P0
    [Setup]    Testcase Setup for CAP Premium User   count=2
    Clear notification from home screen     device=device_1
    Click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Verify Incoming call    device=device_1     status=Appear
    Wait for Some Time    time=${wait_time_20s}
    wait until call disconnected    device=device_1
    verify home screen missed call notification     device=device_1     to_device=device_2      call_type=missed_call
    Verify Call State    device_list=device_2     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC3 : Verify the title of missed transferred call home screen notification.
    [Tags]  456486  P1
    [Setup]    Testcase Setup for CAP Premium User   count=3
    Clear notification from home screen     device=device_1
    Click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Blindtransfers the call using display name  from_device=device_2      to_device=device_1:cap_search_enabled
    Verify Incoming call    device=device_1     status=Appear
    Wait for Some Time    time=${wait_time_20s}
    wait until call disconnected    device=device_1
    verify home screen missed call notification     device=device_1     to_device=device_3      call_type=missed_transfer
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4 : Verify the title of missed forwarded call home screen notification
    [Tags]  456487    P2
    [Setup]   Testcase Setup for CAP Premium User   count=3
    Clear notification from home screen     device=device_1
    Enable call forwarding and add contact     from_device=device_2    contact_device=device_1:cap_search_enabled
    Click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_2
    Verify Incoming call    device=device_1     status=Appear
    Wait for Some Time    time=${wait_time_20s}
    wait until call disconnected    device=device_1
    verify home screen missed call notification     device=device_1     to_device=device_3      call_type=missed_forward
    Verify Call State    device_list=device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Disable Call forward   devices=device_2     AND     Come back to home screen    device_list=device_1,device_2,device_3


*** Keywords ***
Disable Call forward
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    verify and disable call forwarding    device=device_1


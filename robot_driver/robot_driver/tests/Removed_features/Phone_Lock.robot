*** Settings ***
Force Tags    phone_lock
Resource    ../resources/keywords/common.robot

#Suite Setup     Phone lock Setup
#Suite Teardown  Phone lock Teardown

*** Variables ***
${wait_time} =      10s
${device_lock_time} =  35


*** Test Cases ***
#TC1 : [Phone Lock] Phone to get lock only after idle time-out
#    [Tags]  146757    146704    bvt     42_bvt
#    [Setup]    Testcase Setup    count=1
#    Enable device lock and set password    device=device_1
#    Wait for Some Time    time=${device_lock_time}
#    Log     Phone got locked after idle time-out
#    [Teardown]  run keywords  Capture on Failure    AND     Phone Lock Teardown    device=device_1
#
#TC2 : [Incoming Calls] Teams App user receives incoming call in locked state
#    [Tags]  146855  calls_feature_p2    P2
#    [Setup]  Run Keywords    Testcase Setup    count=2    AND    IC Phone lock Setup
#    Make outgoing call using display name   from_device=device_2     to_device=device_1
#    Verify display name on call toast   to_device=device_1    from_device=device_2
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Wait for Some Time    time=${wait_time}
#    Disconnect call     device=device_2
#    [Teardown]  run keywords  Capture on Failure    AND     IC TestCase Teardown    device=device_1
#
#TC3 : [GCP] Lock screen group call notification
#    [Tags]  156849   bvt    42_bvt
#    [Setup]  Run Keywords    Testcase Setup for GCP User    count=3    AND    Enable call forwarding to call group     from_device=device_1    contact_device=device_2   AND   Phone lock setup
#    Wait for Some Time    time=${device_lock_time}
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
#    Verify call notification    device=device_2     status=appear
#    Pick incoming call from call notification    device=device_2
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]  run keywords  Capture on Failure    AND     Phone unlock setup    device=device_2   AND   verify and disable call forwarding    device=device_1
#
#TC4 : [Emergency Calling] Teams app user to have an emergency call icon on the unlock code screen.
#    [Tags]  146945    bvt    42_bvt
#    [Setup]  Run Keywords    Testcase Setup    count=1    AND    EC Phone lock Setup
#    Select emergency call while phone lock  device=device_1
#    [Teardown]  run keywords  Capture on Failure    AND     TestCase Teardown    device=device_1    AND     Phone lock Teardown   device=device_1
#

#
#*** Keywords ***
#Phone Lock Teardown
#    [Arguments]     ${device}
#    Device setting back     ${device}
#    Unlock phone    ${device}
#    Verify device is unlocked   ${device}
#    Disable device lock    ${device}
#
#IC Phone lock Setup
#    Enable device lock and set password    device=device_1
#    Wait for Some Time    time=${device_lock_time}
#
#IC TestCase Teardown
#    [Arguments]     ${device}
#    verify call state and disconnect      ${device}
#    Device setting back     ${device}
#    Unlock phone    ${device}
#    Verify device is unlocked   ${device}
#    Disable device lock    ${device}
#
#Phone lock setup
#    Enable call forwarding to call group     from_device=device_1    contact_device=device_2
#    Enable device lock and set password    device=device_2
#
#Phone unlock setup
#    [Arguments]     ${device}
#    verify call state and disconnect      ${device}
#    Device setting back     ${device}
#    Unlock phone    ${device}
#    Verify device is unlocked   ${device}
#    Disable device lock    ${device}
#    Disable Call forward    devices=device_1,device_2,device_3
#
#Disable Call forward
#    [Arguments]     ${devices}
#    #device_setting_back     device=device_2
#    Come back to home screen    device_list=${devices}
#    verify and disable call forwarding    device=device_1
#
#EC Phone lock Setup
#    Enable device lock and set password    device=device_1
#
#TestCase Teardown
#    [Arguments]     ${device}
#    verify call state and disconnect      ${device}
#    Device setting back     ${device}
#    Unlock phone    ${device}
#    Verify device is unlocked   ${device}

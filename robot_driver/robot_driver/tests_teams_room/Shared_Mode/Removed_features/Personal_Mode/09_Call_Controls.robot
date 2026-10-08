#*** Settings ***
#Documentation   Call Controls
#Force Tags    pm_call_hold_and_call_mute     pm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#
#*** Variables ***
#${wait_time} =  10
#${1_minutes_wait_time} =  60
#
#*** Test Cases ***
#TC1: [Audio - Call Hold] DUT puts call on hold with Teams Desktop Client
#    [Tags]  194759   bvt  bvt_pm     sanity_pm
#    [Setup]  Testcase Setup     count=2
#    Make outgoing call with phonenumber    from_device=device_2      to_device=device_1
#    Accept incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Hold the call   device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Hold
#    Resume the call   device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Resume
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#TC2: [Audio - Mute Call] DUT puts the call on Mute with Teams Desktop Client
#    [Tags]  194763   bvt   bvt_pm   sanity_pm
#    [Setup]  Testcase Setup     count=2
#    Make outgoing call with phonenumber    from_device=device_2      to_device=device_1
#    Accept incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Mutes the phone call    device=device_1
#    Verify meeting Mute State    device_list=device_1    state=mute
#    Unmutes the phone call  device=device_1
#    Verify meeting Mute State    device_list=device_1    state=Unmute
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#TC3: [Video - Call Hold] DUT puts call on hold with Teams Desktop Client
#    [Tags]  194760   bvt  bvt_pm    sanity_pm
#    [Setup]  Testcase Setup     count=2
#    Make Video call using display name  from_device=device_2     to_device=device_1
#    Accept incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Hold the call   device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Hold
#    Resume the call   device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Resume
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#TC4: [Video - Mute Call] DUT puts the call on Mute with Teams Desktop Client
#    [Tags]  194765    bvt   bvt_pm    sanity_pm
#    [Setup]  Testcase Setup     count=2
#    Make Video call using display name  from_device=device_2     to_device=device_1
#    Accept incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Mutes the phone call    device=device_1
#    Verify meeting Mute State    device_list=device_1    state=mute
#    Unmutes the phone call  device=device_1
#    Verify meeting Mute State    device_list=device_1    state=Unmute
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#TC5: [Second incoming call] DUT should not get second incoming call
#    [Tags]  194783   P1
#    [Setup]  Testcase Setup    count=3
#    Make Video call using display name  from_device=device_2     to_device=device_1
#    Accept incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Mutes the phone call    device=device_1
#    Verify meeting Mute State    device_list=device_1    state=mute
#    Make outgoing call with phonenumber    from_device=device_3      to_device=device_1
#    Verify second incoming call     device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#TC6: [Call control]”View profile” option in call
#    [Tags]  224392   P1
#    [Setup]  Testcase Setup    count=2
#    Make outgoing call with phonenumber    from_device=device_2      to_device=device_1
#    Accept incoming call      device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Press long tap on screen  device=device_1
#    Select view profile option    device=device_1
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#
#
#
#
#*** Keywords ***
#Test Case Teardown
#    [Arguments]     ${devices}
#    Come back to home screen     ${devices}
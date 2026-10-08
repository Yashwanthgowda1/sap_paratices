#*** Settings ***
#Force Tags    pm_auto_dismiss      pm
#Library     DateTime
#Library     OperatingSystem
#Resource   ../resources/keywords/common.robot
#
#
#*** Test Cases ***
#TC1: [Auto Dismiss] Verify call ended screen will disappear within 3 seconds
#    [Tags]  194968   P1
#    [Setup]  Testcase Setup      count=2
#    Make outgoing call with phonenumber    from_device=device_1     to_device=device_2
#    Accept incoming call      device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Validate call cancelled   device=device_1
#    [Teardown]    Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC2: [Auto Dismiss] Verify call decline screen auto dismissed within 5 seconds
#    [Tags]  194969   P2
#    [Setup]  Testcase Setup      count=2
#    Make outgoing call with phonenumber    from_device=device_1     to_device=device_2
#    Reject incoming call   device_list=device_2
#    Verify for call decline screen  device=device_1
#    [Teardown]    Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2
#
#TC3:[Auto Dismiss] Verify call cancelled screen auto dismissed within 5 seconds
#    [Tags]  194973   P2
#    [Setup]  Testcase Setup      count=2
#    Make outgoing call with phonenumber   from_device=device_1     to_device=device_2
#    Wait for Some Time    time=10
#    Validate call cancelled   device=device_1
#    [Teardown]    Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2
#
#TC4: [Auto Dismiss] Verify the Dismiss button in rating screen
#    [Tags]  221981   bvt   bvt_pm  sanity_pm
#    [Setup]  Testcase Setup     count=2
#    Make outgoing call with phonenumber   from_device=device_1     to_device=device_2
#    Accept incoming call      device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    Come back to home screen   device_list=device_1
#    [Teardown]    Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2

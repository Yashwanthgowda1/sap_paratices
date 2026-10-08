#*** Settings ***
#Force Tags    pm_Incoming_calls     pm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#*** Test Cases ***
#TC1: [Incoming Call] Audio call to DUT
#    [Tags]  194845  bvt  bvt_pm  sanity_pm
#    [Setup]  Testcase Setup      count=2
#    Make outgoing call with phonenumber    from_device=device_2     to_device=device_1
#    Accept incoming call  device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#TC2: [Incoming Call] Video call to DUT
#    [Tags]  194846   bvt  bvt_pm   sanity_pm
#    [Setup]  Testcase Setup     count=2
#    Make Video call using display name  from_device=device_2     to_device=device_1
#    Accept incoming call   device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#TC3: [Incoming Call] DUT does not answer the incoming call
#    [Tags]  194848   sanity_pm
#    [Setup]  Testcase Setup    count=2
#    Make outgoing call with phonenumber    from_device=device_2     to_device=device_1
#    verify incoming call  device=device_1   status=appear
#    reject incoming call  device=device_1
#    Come back to home screen  device_list=device_1,device_2
#    Make Video call using display name  from_device=device_2     to_device=device_1
#    verify incoming call  device=device_1   status=appear
#    reject incoming call  device=device_1
#    disconnect call  device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#TC4: [Incoming Call] DUT declines the incoming call
#    [Tags]  194847  P2
#    [Setup]  Testcase Setup    count=2
#    Make outgoing call with phonenumber    from_device=device_2     to_device=device_1
#    Reject incoming call   device_list=device_1
#    Come back to home screen  device_list=device_1,device_2
#    Make Video call using display name  from_device=device_2     to_device=device_1
#    Reject incoming call   device_list=device_1
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#
#
#*** Keywords ***
#Test Case Teardown
#    [Arguments]     ${devices}
#    Come back to home screen     ${devices}
#
#Wait untill call completes
#    [Arguments]        ${time}
#    Wait for Some Time    time=${wait_time}

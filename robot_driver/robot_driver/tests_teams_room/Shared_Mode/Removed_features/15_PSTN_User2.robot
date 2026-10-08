#*** Settings ***
#Resource    ../../resources/keywords/common.robot
#*** Variables ***
#*** Test Cases ***
#TC1:[Outgoing Call] DUT calls to PSTN user from home screen dialpad
#    [Tags]  237606   bvt   bvt_sm    sanity_sm
#    [Setup]  Testcase Meeting PSTN Setup Main   count=2
#    Make outgoing call with phonenumber   from_device=device_1     to_device=device_2:pstn_user
#    Accept incoming call     device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2


#TC14:[Call] Start new Call from Home screen
#    [Tags]       444806   P2
#    [Setup]  Testcase Meeting PSTN Setup Main   count=2
#    verify dial pad present on landing page          device=device_1
#    Make outgoing call with phonenumber   from_device=device_1     to_device=device_2:pstn_user
#    Accept incoming call     device=device_2
#    Wait for Some Time    time=${wait_time}
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
*** Keywords ***


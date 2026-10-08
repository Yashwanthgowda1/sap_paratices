#*** Settings ***
#Resource    ../../resources/keywords/common.robot
#*** Variables ***
#*** Test Cases ***
#TC1 : [Live Caption 1:1 call]Verify that user is getting "Turn On Live Captions" option in the more(...) option of 1:1 call
#    [Tags]  260615   bvt   bvt_sm   sanity_sm
#    [Setup]  Testcase Setup for Meeting User     count=2
#    Make outgoing call with phonenumber    from_device=device_2     to_device=device_1:meeting_user
#    Accept incoming call  device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Verify live captions option visibility    device=device_1
#    Disconnect call     device=device_2
#    Verify Call State     device_list=device_1,device_2    state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#*** Keywords ***

*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Live Caption 1:1 call] Verify that user is getting "Turn On Live Captions" option in the more(...) option of 1:1 call
    [Tags]  261629   P1   bvt_cap    sanity_cap        Certification_cap
    [Setup]  Testcase Setup for CAP User      count=2
    click on people tab     device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify live captions option visibility    device=device_1
    Disconnect call     device=device_2
    Verify Call State     device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC2: [Live Caption ] Verify that user is getting "Turn On Live Captions" option in the more(...) option of group call
    [Tags]  261636   P1
    [Setup]  Testcase Setup for CAP User     count=3
    click on calls tab  device=device_3
    Make outgoing call using phonenumber   from_device=device_3     to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_2,device_3   state=Connected
    Add participant to conversation using display name   from_device=device_3      to_device=device_1:cap_search_enabled
    Pick incoming call  device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Verify live captions option visibility    device=device_1
    Turn on live captions and validate   device=device_1
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3


*** Keywords ***


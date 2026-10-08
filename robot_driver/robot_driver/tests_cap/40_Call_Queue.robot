*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

#Suite Setup         Teams CQ User Setup
Suite Teardown     Suite Failure Capture

*** Variables ***
${wait_time} =  10
${wait_time2} =  20


*** Test Cases ***
TC1 : [CQ] Agent picks up the call from a TDC user
    [Tags]  261695    sanity_cap
    [Setup]  Testcase Setup for CQ Cap User   count=3
    Place call to phone num    from_device=device_2      phone_num=CQ_no
    Wait till incoming call visibility    device=device_1,device_3
    Pick incoming call    device=device_1
    Verify Any Incoming Call Disappeared    device=device_3
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2 : [CQ] Agent picks up the call from PSTN number
    [Tags]   261681    sanity_cap
    [Setup]  Testcase Setup for CQ PSTN User   count=3
    click on calls tab   device=device_2
    Place call to phone num    from_device=device_2      phone_num=CQ_no
    Wait till incoming call visibility    device=device_1,device_3
    Pick incoming call    device=device_1
    Verify Any Incoming Call Disappeared    device=device_3
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2,device_3

TC3 : [CQ] CQ agent Transfer the call to the user via PSTN
    [Tags]   261688     bvt_cap    sanity_cap
    [Setup]  Testcase Setup for CQ PSTN User   count=4
    click on calls tab   device=device_2
    Place call to phone num    from_device=device_2      phone_num=CQ_no
    Wait till incoming call visibility    device=device_1,device_3
    Pick incoming call    device=device_1
    Verify Incoming call    device=device_3     status=disappear
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using phonenumber  from_device=device_1      to_device=device_4
    Pick incoming call    device=device_4
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_4,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_4,device_2    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2,device_3,device_4

*** Keywords ***
Test Case Teardown
    [Arguments]     ${devices}
    Come back to home screen     ${devices}
*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown      Suite Failure Capture

*** Variables ***


*** Test Cases ***
TC1 : [Advance calling][CQ] Guest user to call the CQ number with auto attendant as an agent
    [Tags]   329261      P2
    [Setup]  Testcase Setup for CQ User   count=3
    click on calls tab   device=device_2
    Place call to phone num    from_device=device_2      phone_num=CQ_no
    Wait till incoming call visibility    device=device_1,device_3
    Pick incoming call    device=device_1
    Verify Incoming call    device=device_3     status=disappear
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen   device_list=device_1,device_2,device_3

TC2 : [Advance calling][CQ] Agent picks up the call from PSTN number
    [Tags]   329260     P1     Sanity_CAPPremium
    [Setup]  Testcase Setup for CQ PSTN User   count=3
    click on calls tab   device=device_2
    Place call to phone num    from_device=device_2      phone_num=CQ_no
    Wait till incoming call visibility    device=device_1,device_3
    Pick incoming call    device=device_1
    Verify Incoming call    device=device_3     status=disappear
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure      AND     Come back to home screen   device_list=device_1,device_2,device_3

TC3 : [Advance calling][CQ] CQ agent Transfer the call to the user via PSTN
    [Tags]    329262     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CQ PSTN User   count=4
    click on calls tab   device=device_2
    Place call to phone num    from_device=device_2      phone_num=CQ_no
    Wait till incoming call visibility    device=device_1,device_3
    Pick incoming call    device=device_1
    Verify Incoming call    device=device_3     status=disappear
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using display name  from_device=device_1      to_device=device_4
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_2,device_4    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_4    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen   device_list=device_1,device_2,device_3,device_4

*** Keywords ***
Advance calling Setup
    Verify and enable advance calling option       device=device_1
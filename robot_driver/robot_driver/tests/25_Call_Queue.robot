*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown     Suite Failure Capture

*** Variables ***
${wait_time} =  10
${wait_time2} =  20


*** Test Cases ***
TC1 : [CQ] Guest user to call the CQ number with auto attendant as an agent
    [Tags]  308826  P0
    [Setup]  Testcase Setup for CQ User   count=3
    click on calls tab   device=device_2
    Place call to phone num    from_device=device_2      phone_num=CQ_no
    Wait till incoming call visibility    device=device_1,device_3
    Pick incoming call    device=device_1
    Verify Incoming call    device=device_3     status=disappear
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Test Case Teardown    devices=device_1,device_2,device_3

TC2 : [CQ] Agent picks up the call from PSTN number
    [Tags]   308788         bvt_tp    sanity_tp    bvt_pr      31_bvt  alt_blocked       Certification_audio
    [Setup]  Testcase Setup for CQ PSTN User   count=3
    click on calls tab   device=device_2
    Place call to phone num    from_device=device_2      phone_num=CQ_no
    Wait till incoming call visibility    device=device_1,device_3
    Pick incoming call    device=device_1
    Verify Any Incoming Call Disappeared    device=device_3
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Test Case Teardown    devices=device_1,device_2,device_3

TC3 : [CQ] CQ agents to ring till "wait time in queue"
    [Tags]  308841       P1  alt_blocked
    [Setup]  Testcase Setup for CQ PSTN User   count=3
    click on calls tab   device=device_2
    Place call to phone num    from_device=device_2      phone_num=CQ_no
    Wait till incoming call visibility    device=device_1,device_3
    Rejects the incoming call   device_list=device_1
    verify outgoing call from PSTN to CQ  device=device_2
    Verify Incoming call    device=device_3     status=appear
    Verify Incoming call    device=device_1     status=disappear
    Wait for Some Time    time=40s
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Test Case Teardown    devices=device_1,device_2,device_3

TC4 : [CQ] Call Transfer by CQ Agent to a user not answered
    [Tags]  308831        P2  alt_blocked
    [Setup]  Testcase Setup for CQ PSTN User   count=4
    click on calls tab   device=device_2
    Place call to phone num    from_device=device_2      phone_num=CQ_no
    Wait till incoming call visibility    device=device_1,device_3
    Pick incoming call    device=device_1
    Verify Incoming call    device=device_3     status=disappear
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using phonenumber  from_device=device_1      to_device=device_4
    Wait for Some Time    time=${wait_time2}
    Verify Call State    device_list=device_1    state=Hold
    Wait for Some Time    time=${wait_time}
    Resume the call   device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2     state=Resume
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Test Case Teardown    devices=device_1,device_2,device_3,device_4

TC5 : [CQ]When a user is already in a call, second incoming call move to notification
    [Tags]      311030   sanity_tp      P0    bvt_tp
    [Setup]  Testcase Setup for CQ 2PSTN User    count=4
    click on calls tab   device=device_2
    Place call to phone num    from_device=device_2      phone_num=CQ_no
    click on calls tab   device=device_4
    Place call to phone num    from_device=device_4      phone_num=CQ_no
    Verify Incoming call    device=device_1     status=appear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1    state=Connected
    Verify Incoming call    device=device_1     status=appear
    Disconnect call     device=device_2,device_4
    Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Test Case Teardown    devices=device_1,device_2,device_3,device_4

TC6: [CQ] CQ agent with no PSTN capabilities
    [Tags]    308838
    [Setup]    Testcase Setup for CQ PSTN User   count=3
    click on calls tab   device=device_2
    Place call to phone num    from_device=device_2      phone_num=CQ_no
    Verify Incoming call    device=device_1,device_3     status=appear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1    state=Connected
    Verify Incoming call    device=device_3     status=disappear
    Disconnect Call    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Test Case Teardown    devices=device_1,device_2,device_3

TC7 :[CQ] Agent set call forwarding to TDC user
    [Tags]    318436
    [Setup]    Testcase Setup for CQ PSTN User   count=4
    Enable call forwarding to contacts     from_device=device_1   contact_device=device_4
    click on calls tab   device=device_2
    Place call to phone num    from_device=device_2      phone_num=CQ_no
    Verify Incoming call    device=device_4     status=disappear
    Verify Incoming call    device=device_1     status=appear
    disconnect call  device=device_2
    Verify Call State   device_list=device_1,device_2,device_3    state=disconnected
    verify and change toggle status for call forwarding display on home screen    device=device_1      status=off
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3,device_4

TC8 : [CQ]If the call queue name is too big, the notification can be extended to 2 lines.
    [Tags]    311080
    [Setup]  Testcase Setup for CQ User   count=3
    click on calls tab   device=device_2
    Place call to phone num    from_device=device_2      phone_num=CQ_no
    verify call queue name on agent    device=device_1,device_3
    Verify Incoming call    device=device_1,device_3     status=appear
    disconnect call  device=device_2
    Verify Call State   device_list=device_1,device_2,device_3    state=disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3

*** Keywords ***
Test Case Teardown
    [Arguments]     ${devices}
    Come back to home screen     ${devices}
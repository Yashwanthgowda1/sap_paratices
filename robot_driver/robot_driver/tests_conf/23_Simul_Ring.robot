*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown     Run Keywords        Suite Failure Capture        AND     Call Ring Suite Teardown    devices=device_1

*** Variables ***
${wait_time1} =  10
${wait_time2} =  25

*** Test Cases ***
TC1 : [Simul-ring] DUT user can configure a PSTN user to ring simultaneously for an incoming call from another PSTN user
    [Tags]   316042    P1    sanity_tpc
    [Setup]    Run Keywords    Testcase Meeting 2 PSTN Setup Main     count=3    AND     Enable Also Ring and add contact     device=device_1   contact_device=device_2:pstn_user
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Verify Incoming call    device=device_1,device_2     status=appear
    Pick incoming call    device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Call Ring Test Teardown    devices=device_1,device_2,device_3

TC28 : [Simul-ring] DUT user can configure a PSTN user to ring simultaneously for an incoming call from TDC user
    [Tags]  316043    P0    bvt_tpc     sanity_tpc
    [Setup]   Testcase Meeting PSTN Setup Main      count=3
    Enable Also Ring and add contact     device=device_1    contact_device=device_2:pstn_user
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Verify incoming call    device=device_1,device_2     status=appear
    Pick incoming call      device=device_2
    Verify incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Call Ring Test Teardown    devices=device_1,device_2,device_3



*** Keywords ***
Call Ring Test Teardown
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}


Call Ring Suite Teardown
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    Disable Also Ring    device=device_1
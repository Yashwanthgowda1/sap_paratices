*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown     Suite Failure Capture

*** Test Cases ***
TC1 : [No Soft Dialpad with Physical Present] [Device without physical Dialpad] Soft Dialpad should be shown on calls tab.
    [Tags]  456363    P0    bvt_tp   sanity_tp
    [Setup]  Testcase Setup   count=1
    navigate to dial pad tab from home screen     device=device_1
    [Teardown]  Run Keywords   Capture on Failure    AND   Come back to home screen   device_list=device_1

TC2 : [No Soft Dialpad With Physical Present] [Device without physical Dialpad] Soft Dialpad should be shown on in-call Dialpad screen.
    [Tags]  456365    P0    bvt_tp   sanity_tp     bvt_pr
    [Setup]  Testcase Setup   count=2
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    click and verify dial pad from call control UI     device_list=device_1
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure    AND   Come back to home screen   device_list=device_1,device_2



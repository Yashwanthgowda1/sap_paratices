*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown     Suite Failure Capture

*** Test Cases ***
TC1 : [No Soft Dialpad with Physical Present] [Device with physical Dialpad] Soft Dialpad should not be shown on calls tab.
    [Tags]   456360
    [Setup]     Testcase Setup      count=1
    Click on calls tab   device=device_1
    open and verify dialpad from calls tab    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown   devices=device_1

TC2 : [No Soft Dialpad with Physical Present] [Device with physical Dialpad] Soft Dialpad should not be shown on in-call Dialpad screen.
    [Tags]   456361
    [Setup]     Testcase Setup      count=2
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_2    to_device=device_1
    Pick incoming call    device=device_1
    verify call state     device_list=device_1,device_2        state=Connected
    click and verify dial pad from call control UI    device_list=device_1
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown   devices=device_1

*** Keywords ***
Test Case Teardown
    [Arguments]     ${devices}
    Come back to home screen     ${devices}
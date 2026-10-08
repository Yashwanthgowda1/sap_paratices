*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Auto Dismiss] Rating screen should be dismissed automatically if the user does not submit the rating within 5 seconds
    [Tags]   309601           alt_credentials
    [Setup]  Testcase Setup    count=2
    Click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call and verify call rating screen     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : [Auto Dismiss] Verify call decline screen auto dismissed within seconds
    [Tags]   309611    sanity_tp    alt_blocked
    [Setup]   Run Keywords    Testcase Setup    count=2    AND    Disable unanswered call    device=device_2      contact_device=device_1
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Rejects the incoming call   device_list=device_2
    Verify call decline screen  device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3 : [Auto Dismiss] Verify "Dismiss Rate My Call" toggle is turned ON/OFF
    [Tags]   320234    P2
    [Setup]  Testcase Setup    count=1
    navigate to user survey        device=device_1
    click on dismiss rate my call option toggle     device=device_1
    verify dismiss rate my call toggle    device=device_1       toggle=on
    [Teardown]   Run Keywords    Capture on Failure     AND    Come back to home screen    device_list=device_1       AND     disable dismiss rate my call toggle    device=device_1
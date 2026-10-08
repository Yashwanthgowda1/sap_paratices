*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Test Cases ***
TC1:[Chat Bubbles] Verify during a call or meeting click on more options than by default "Show chat bubble" is enabled.
    [Tags]      317660     P1     sanity_sm
    [Setup]  Testcase Setup for Meeting User   count=2
    Make outgoing call with phonenumber    from_device=device_1     to_device=device_2
    Accept incoming call  device=device_2
    verify show chat bubble is enabled default      device=device_1
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]    Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2

TC2:[Chat Bubbles] Verify toggling from Norden meeting settings fragment
    [Tags]      317666     P2
    [Setup]  Testcase Setup for Meeting User   count=1
    Navigate to app settings page   device=device_1
    Enable and disable the chat bubble option   device=device_1
    [Teardown]    Run Keywords    Capture on Failure  AND    Enable the chat bubble option in teardown      device=device_1     AND     Come back to home screen     device_list=device_1

*** Keywords ***
Enable and disable the chat bubble option
    [Arguments]       ${device}
    navigate to meetings option in device settings page   ${device}
    Enable and disable the chat toggle in admin setting     ${device}   state=off        toggle=chat_bubble
    Enable and disable the chat toggle in admin setting     ${device}   state=on       toggle=chat_bubble
    come back from admin settings page     device_list=${device}

Enable the chat bubble option in teardown
    [Arguments]       ${device}
    Navigate to app settings page       ${device}
    navigate to meetings option in device settings page   ${device}
    Enable and disable the chat toggle in admin setting     ${device}   state=on       toggle=chat_bubble
    come back from admin settings page     device_list=${device}

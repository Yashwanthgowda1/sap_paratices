*** Settings ***
Resource    ../resources/keywords/common.robot


Suite Teardown  Suite Failure Capture

*** Variables ***

*** Test Cases ***
TC1: Verify that DUT user should be able to accept the call/meeting in "What's new" page under the settings.
    [Tags]    346180      P2
    [Setup]   Testcase Setup      count=2
    navigate to whats new page from home screen   device=device_1
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2: Verify that DUT user should be able answer a call/meeting from "Third party software notices and information" page under About in settings.
    [Tags]  346194   P2
    [Setup]    Testcase Setup    count=2
    verify options inside about page     device=device_1
    navigate to third party software notices from about page    device=device_1
    click on calls tab     device=device_2
    make outgoing call using display name    from_device=device_2     to_device=device_1
    Pick incoming call      device=device_1
    Verify Call State    device_list=device_1,device_2     state=Connected
    Disconnect call    device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    navigate to home screen from about page  device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3: Verify that DUT should not have "Connected Experiences" option under About in settings.
    [Tags]  346168    P1
    [Setup]  Testcase Setup   count=1
    verify options inside about page     device=device_1
    verify connected experiences does not present in about page       device=device_1
    navigate to home screen from about page    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1


*** Keywords ***
verify third party software notices and information
    [Arguments]     ${device}
    verify third party software notices     ${device}
    scroll up secondary tab     ${device}
    click back  ${device}
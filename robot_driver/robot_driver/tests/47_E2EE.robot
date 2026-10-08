*** Settings ***
Resource    ../resources/keywords/common.robot


Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 :[E2EE] User to verify End to end encrypted calls option under calling page
    [Tags]   319216     P2
    [Setup]  Testcase Setup    count=1
    verify E2EE option inside calling option     device=device_1
    [Teardown]  Run Keywords   Capture on Failure     AND   Come back to home screen    device_list=device_1

TC2 :[E2EE] DUT user check for Ubar and overflow options for encrypted call
    [Tags]  319217    P1      bvt_pr
    [Setup]  Testcase Setup    count=2
    Enable E2EE    device=device_1,device_2
    click on calls tab     device=device_2
    Make outgoing call using display name   from_device=device_2     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call UI when e2ee is enabled     device=device_1
    verify search option not present in add participant when e2ee enabled   device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure    AND    Disable E2EE    device=device_1,device_2

TC3 :[E2EE] DUT user checks for encryption when another user is non-E2EE enabled user
    [Tags]   319218   P2
    [Setup]  Testcase Setup    count=2
    Enable E2EE    device=device_1
    click on calls tab     device=device_2
    Make outgoing call using display name   from_device=device_2     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify E2EE icon is not displaying in call UI   device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure    AND  Disable E2EE    device=device_1

TC4 :[E2EE] DUT user to enable/disable end-to-end encrypted option
    [Tags]  319233   P2
    [Setup]  Testcase Setup    count=1
    enable E2EE option inside calling option       device=device_1
    disable E2EE option inside calling option    device=device_1
    enable E2EE option inside calling option       device=device_1
    disable E2EE option inside calling option     device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND  Disable E2EE    device=device_1

TC5 :[E2EE] DUT user to check the "Learn more" option under Encryption
    [Tags]   319246    P2
    [Setup]  Testcase Setup    count=1
    navigate to learn more link under E2EE calls     device=device_1
    [Teardown]   Run Keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1

TC6 : [E2EE] Verify when both users are non-E2EE users
    [Tags]     319220    P2
    [Setup]  Testcase Setup    count=2
    click on calls tab     device=device_2
    Make outgoing call using display name   from_device=device_2     to_device=device_1
    verify incoming call    device=device_1   status=appear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify add participant button should visible for presenter    device=device_1
    verify call control visibility     device_list=device_1
    verify and click e2ee icon in call ui    device_list=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure    AND    Disable E2EE    device=device_1,device_2

TC7 : [E2EE] DUT user to check for start recording option in meeting
    [Tags]   319242    P2
    [Setup]  Testcase Setup    count=2
    Enable E2EE    device=device_1
    create meeting   device=device_2    meeting=e2ee_meeting     participants=device_1
    Join Meeting    device=device_1,device_2     meeting=e2ee_meeting
    Wait for Some Time    time=${wait_time}
    verify meeting state   device_list=device_1,device_2       state=connected
    start recording call    device=device_1
    verify recording notification on screen     device=device_1
    Wait for Some Time    time=${wait_time}
    stop recording call     device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2    AND  Disable E2EE    device=device_1

*** Keywords ***
Enable E2EE
    [Arguments]     ${device}
    enable E2EE option inside calling option      ${device}
    come back to home screen    ${device}

Disable E2EE
    [Arguments]     ${device}
    disable E2EE option inside calling option     ${device}
    Come back to home screen    ${device}
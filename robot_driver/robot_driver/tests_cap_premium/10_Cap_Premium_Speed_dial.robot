*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown      Suite Failure Capture

*** Variables ***


*** Test Cases ***
TC1 : [Advance calling][Speed Dial] Verify Speed Dial on DUT
    [Tags]   329228     P2
    [Setup]  run keywords   Testcase Setup for CAP Premium User    count=2   AND     Make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1  item=favorite
    Verify Speed dial header    device=device_1
    Remove favorite user from favorites page    from_device=device_1     to_device=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : [Advance calling][Speed Dial] contacts from people tab should reflect under favorites section in calls tab
    [Tags]  329230      BVT_CAPPremium     Sanity_CAPPremium
    [Setup]    Testcase Setup for CAP Premium User     count=2
    Add from directory   from_device=device_1    to_device=device_2     group_name=Speed dial
    Verify Speed dial contacts from people tab should reflect under calls favorites tab    from_device=device_1     to_device=device_2
    Navigate to people tab    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=Speed dial

TC3 : [Advance calling][Speed Dial] Verify adding contacts to favorites
    [Tags]   329229      P2
    [Setup]  Run keywords    Testcase Setup for CAP Premium User     count=3   AND     Make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1  item=favorite
    Verify added favorite user in favorites page    from_device=device_1     to_device=device_2
    Make group call     from_device=device_1     to_device=device_2     new_participant=device_3
    Verify favorite icon should not display for group call   device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND   Remove favorite user from favorites page    from_device=device_1     to_device=device_2

TC4 : [Advance calling][Calls] Remove contacts from favorites
    [Tags]   329231      P1    Sanity_CAPPremium
    [Setup]    Testcase Setup for CAP Premium User    count=2
    Add from directory   from_device=device_1    to_device=device_2     group_name=Speed dial
    verify added favorite user in favorites page    from_device=device_1     to_device=device_2
    navigate to calls favorites page      device=device_1
    remove favorite contacts from favorites tab     device=device_1
    [Teardown]  Run Keywords   Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2   

*** Keywords ***
Advance calling Setup
    Verify and enable advance calling option       device=device_1

Verify Speed dial header
    [Arguments]     ${device}
    Speed dial performtransition    ${device}

Make outgoing call for call log
    [Arguments]     ${from_device}   ${to_device}
    click on calls tab     device=${from_device}
    Make outgoing call using display name      from_device=${from_device}      to_device=${to_device}
    Verify Incoming call    device=${to_device}     status=appear
    Pick incoming call      device=${to_device}
    Disconnect call     device=${from_device}
    Verify Call State    device_list=${from_device}     state=Disconnected
    Come back to home screen    device_list=${from_device}
    click on calls tab   device=${from_device}
    Refresh calls main tab    device=${from_device}

Make group call
    [Arguments]     ${from_device}   ${to_device}   ${new_participant}
    click on calls tab     device=${from_device}
    Make outgoing call using display name    from_device=${from_device}      to_device=${to_device}
    Pick incoming call    device=${to_device}
    Verify Call State   device_list=${from_device},${to_device}   state=Connected
    Add participant to conversation using display name   from_device=${from_device}      to_device=${new_participant}
    Pick incoming call    device=${new_participant}
    Verify Call State   device_list=${from_device},${to_device},${new_participant}    state=Connected
    Disconnect call     device=${from_device},${to_device}
    Verify Call State   device_list=${from_device},${to_device},${new_participant}    state=Disconnected
    Come back to home screen    device_list=${from_device}
    Navigate to calls tab   device=${from_device}
    Refresh calls main tab    device=${from_device}
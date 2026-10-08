*** Comments ***
# Feature Removed in 2024 U2
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Setup    spotlight suite Setup
Suite Teardown    Run Keyword and ignore error   spotlight suite teardown



TC 1 : [Spotlight] TDC user able to enable and disable spotlight during the meeting
    [Tags]  310483      bvt_tp   sanity_tp     P0
    [Setup]    Testcase Setup   count=2
    Join Meeting    device=device_1,device_2     meeting=spotlight_meeting
    Verify meeting state   device_list=device_1,device_2   state=Connected
    make an spotlight   from_device=device_2   to_device=device_1
    verify spotlight icon for user   device=device_1
    verify spotlight avatar   device_list=device_2
    remove spotlight  from_device=device_2    to_device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1,device_2      count=2

TC 2 : [Spotlight] Spotlight overrides the Pin in the meeting
    [Tags]  310519      bvt_tp   sanity_tp     P0
    [Setup]    Testcase Setup   count=4
    Join Meeting    device=device_1,device_2,device_3,device_4     meeting=spotlight_meeting
    Verify meeting state   device_list=device_1,device_2,device_3,device_4    state=Connected
    make an pin   from_device=device_1  to_device=device_3
    verify participant name which is pinned in main stage       device_list=device_1
    make an spotlight   from_device=device_2   to_device=device_4
    verify participant name which is spotlighted in main stage    device_list=device_1
    remove spotlight  from_device=device_1    to_device=device_4
    verify participant name which is pinned in main stage       device_list=device_1
    End meeting     device=device_1,device_2,device_3,device_4
    Verify meeting state    device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3,device_4      count=4

TC 3 : [Spotlight] Remove spotlight option should be displayed for spotlighted participant
    [Tags]   310536     P2
    [Setup]    Testcase Setup   count=3
    Join Meeting    device=device_1,device_2,device_3    meeting=spotlight_meeting
    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
    make an spotlight   from_device=device_2   to_device=device_1
    verify participant name which is spotlighted in main stage    device_list=device_2
    verify remove spotlight option    from_device=device_3       to_device=device_1
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3     count=3

TC 4 : [Spotlight] User clicking on spotlight icon there should not be any popup/Notification
    [Tags]  310551     P2
    [Setup]    Testcase Setup   count=3
    Join Meeting    device=device_1,device_2,device_3    meeting=spotlight_meeting
    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
    make an spotlight   from_device=device_2   to_device=device_1
    verify participant name which is spotlighted in main stage     device_list=device_2
    check display when clicked on spotlight icon    device=device_1
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3     count=3

TC 5 : [Spotlight] Spotlighted should end once the spotlighted user leave the meeting
    [Tags]  310582     P2
    [Setup]    Testcase Setup   count=3
    Join Meeting    device=device_1,device_2,device_3    meeting=spotlight_meeting
    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
    make an pin   from_device=device_2  to_device=device_1
    make an spotlight   from_device=device_2   to_device=device_3
    verify participant name which is spotlighted in main stage    device_list=device_1
    End meeting       device=device_3
    Join Meeting    device=device_3    meeting=spotlight_meeting
    verify user not having spotlight avatar option     device=device_1
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3     count=3

TC 6 : [Spotlight]Verify that Pin icon should not replaces Spotlight icon if participant that user has pinned was Spotlight by organizer
    [Tags]  319118     P2
    [Setup]    Testcase Setup   count=3
    Join Meeting    device=device_1,device_2,device_3    meeting=spotlight_meeting
    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
    make an spotlight   from_device=device_2   to_device=device_1
    verify participant name which is spotlighted in main stage    device_list=device_3
    verify spotlighted participant can not pin from other participant   from_device=device_3      to_device=device_1
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3     count=3



spotlight suite Setup
    Testcase Setup   count=4
    clear all day meeting and meeting history from calendar   devices=device_1,device_2,device_3
    create meeting   device=device_2   meeting=spotlight_meeting    participants=device_1,device_3,device_4

spotlight suite teardown
    Suite Failure Capture
    clear all day meeting and meeting history from calendar   devices=device_1,device_2,device_3

Test Case Teardown without deleting meeting
    [Arguments]     ${devices}   ${count}
    check for device count      count=${count}
    Come back to home screen    ${devices}
    Teardown Meeting Test Case     ${devices}
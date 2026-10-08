*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown      Suite Failure Capture

*** Variables ***
${wait_time} =   10s

*** Test Cases ***
TC1 : [Advance calling][People] DUT user to create new group in people tab
    [Tags]    329327     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]   Testcase Setup for CAP Premium User     count=1
    Create new group    device=device_1   group_name=edit_group
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND     Delete group    device=device_1   group_name=edit_group

TC2 : [Advance calling][People] DUT to edit the group name in people tab
    [Tags]  329330     P1     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User    count=1
    Create new group    device=device_1   group_name=edit_group
    Edit group name     device=device_1   old_group_name=edit_group     new_group_name=edited_group
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND     Delete group    device=device_1   group_name=edited_group

TC3 : [Advance calling][People] DUT user to delete the groups in people tab
    [Tags]  329329    P1     Sanity_CAPPremium
    [Setup]   Run Keywords    Testcase Setup for CAP Premium User    count=1      AND     Create new group    device=device_1   group_name=delete_group
    Delete group    device=device_1   group_name=delete_group
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC4 : [Advance calling][People] DUT user to add a contact into multiple groups in people tab
    [Tags]    329332       BVT_CAPPremium     Sanity_CAPPremium
    [Setup]   Testcase Setup for CAP Premium User    count=2
    Add from directory   from_device=device_1    to_device=device_2     group_name=Favorites
    Add from directory   from_device=device_1    to_device=device_2     group_name=Tagged
    Verify multiple group name for one user     from_device=device_1    to_device=device_2     group_name=Favorites, Tagged
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    Remove user from group   from_device=device_1    to_device=device_2    group_names=Favorites,Tagged

TC5 :[Advance calling][People] DUT user to accept the incoming call while in "Add to directory" page in people tab
    [Tags]  329334      P2
    [Setup]  Testcase Setup for CAP Premium User    count=2
    Navigate to Add from directory screen     device=device_1
    click on calls tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Verify add from directory page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC6 : [Advance calling][People] Favorite contacts from calls tab should reflect under speed dial group in people tab
    [Tags]  329338    P2
    [Setup]  Run keywords   Testcase Setup for CAP Premium User   count=2   AND     Make outgoing call for call log   from_device=device_1     to_device=device_2
    select call list item  device=device_1      item=favorite
    Verify plus icon on people tab   device=device_1
    Click plus icon and Verify its two options    device=device_1
    Close add contact on people tab     device=device_1
    Click drop down menu and verify list of groups   device=device_1
    Verify default group name from drop down    device=device_1
    Select group from drop down     device=device_1     group_name=Speed dial
    Verify favorite contacts under speed dial group     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND   Remove favorite user from favorites page    from_device=device_1     to_device=device_2

TC7 : [Advance calling][People] DUT user should be able to add a contact to a newly created group in people tab
    [Tags]   329335    P2
    [Setup]  Testcase Setup for CAP Premium User    count=2
    Add user to newly created group from add contact page   from_device=device_1     to_device=device_2   group_name=New_group
    verify added group name for user     from_device=device_1    to_device=device_2     group_name=New_group
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND     Delete group    device=device_1   group_name=New_group

TC8 : [Advance calling][People] DUT user should be able to view the group participants in people tab
    [Tags]   329333     P2
    [Setup]  Testcase Setup for CAP Premium User    count=2
    Add from directory   from_device=device_1    to_device=device_2     group_name=Other contacts
    Select created group from drop down     device=device_1     group_name=Other contacts
    Validate selected group users name on people tab     device=device_1    participant_device=device_2     group_name=Other contacts
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND     Remove user from group  from_device=device_1    to_device=device_2     group_names=Other contacts

TC9 : [Advance calling][People] Group names to be displayed in the contact card of a user in people tab
    [Tags]  329331     P2
    [Setup]   Testcase Setup for CAP Premium User    count=2
    Navigate to people tab   device=device_1
    Add from directory   from_device=device_1    to_device=device_2     group_name=Tagged
    Clicked first contact   device=device_1
    verify contact card details on people app page  device=device_1
    Verify selected usergroup name    from_device=device_1      group_name=Tagged
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND    Remove user from group  from_device=device_1    to_device=device_2     group_names=Tagged

TC10 : [Advance calling][People] DUT to create group without entering any characters in people tab
    [Tags]  329328     P2
    [Setup]   Testcase Setup for CAP Premium User    count=1
    Validate create new group with empty name    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC11 : [Advance calling][People] DUT user to receive/reject meeting invite call in people tab
    [Tags]   329337   P2
    [Setup]  run keywords   Testcase Setup for CAP Premium User   count=3    AND     Remove meeting from calender for meeting policy test    count=3
    Navigate to people tab    device=device_1
    Navigate to people tab    device=device_3
    create meeting  device=device_2       meeting=people_tab_test_meeting
    Join Meeting    device=device_2     meeting=people_tab_test_meeting
    Add participant to conversation using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Verify Incoming call    device=device_1     status=appear
    Pick incoming call    device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    End meeting     device=device_1
    Verify Call State    device_list=device_1   state=Disconnected
    Add participant to conversation using display name    from_device=device_2      to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Rejects the incoming call    device_list=device_3
    End meeting     device=device_2
    Verify Call State    device_list=device_2   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Meeting Teardown     devices=device_2    meeting=people_tab_test_meeting   count=3


*** Keywords ***
Advance calling Setup
    Verify and enable advance calling option       device=device_1
    
Remove Meeting
    [Arguments]     ${devices}
    Remove meeting from calender   ${devices}

Meeting Teardown
    [Arguments]     ${devices}      ${meeting}    ${count}
    Come back home screen for user    ${count}
    Teardown Meeting Test Case     ${devices}
    Delete meeting      ${devices}    ${meeting}

Make outgoing call for call log
    [Arguments]     ${from_device}   ${to_device}
    click on calls tab     device=${from_device}
    Make outgoing call using display name    from_device=${from_device}      to_device=${to_device}
    Verify Incoming call    device=${to_device}     status=appear
    Disconnect call     device=${from_device}
    Verify Incoming call    device=${to_device}     status=disappear
    Verify Call State    device_list=${from_device}     state=Disconnected
    Come back to home screen    device_list=${from_device}
    Navigate to calls tab   device=${from_device}
    Refresh calls main tab    device=${from_device}
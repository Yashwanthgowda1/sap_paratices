*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation      Suite Setup Requirements : This suite requires minimum of 3 devices in config
...                Purpose: Device_1 will be navigated to people tab

Suite Setup         People App Setup    count=3
Suite Teardown      Suite Failure Capture


*** Variables ***
${wait_time} =      20s
${long_grop_name}=      gggggggggggggggggggggggggggggggggggggggggggggggggggggggrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrooooooooooooooooooooooooooooooouuupppppp
${wait_time2} =      10

*** Test Cases ***
TC1 : [People] DUT user to create new group in people tab
    [Tags]  309467   bvt_tp  sanity_tp        alt_credentials     Certification_audio
    [Setup]  Testcase Setup    count=1
    Verify plus icon on people tab   device=device_1
    Click plus icon and Verify its two options    device=device_1
    Select people app option and verify     device=device_1    option=Create new group
    Click cancel btn    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND     check and close create new group window  device=device_1    AND     Come back to home screen    device_list=device_1

#Changed according to new test plan
TC2 : [People] DUT user to receive a voicemail while creating a group
    [Tags]  309662           alt_bug
    [Setup]   Run Keywords    Testcase Setup    count=2    AND     Set Call Forwarding    device=device_1
    ${voicemail_count_before_new_voicemail}=    Get unread voicemail count    device=device_1
    Navigate to Create group screen     device=device_1
    Send Voicemail      from_device=device_2   to_device=device_1
    Wait for Some Time    time=${wait_time}
    Verify create new group page    device=device_1
    Click cancel btn    device=device_1
    ${voicemail_count_after_new_voicemail}=    Get unread voicemail count    device=device_1
    run keyword if  ${voicemail_count_before_new_voicemail}+1 == ${voicemail_count_after_new_voicemail}    Log   voicemail count got increased
    ...   ELSE   fail   Unable to refresh automatically because Voicemail count didn't increase.
    [Teardown]  Run Keywords    Capture on Failure  AND     check and close create new group window  device=device_1    AND    Come back to home screen    device_list=device_1,device_2    AND     verify and disable call forwarding      device=device_1

TC3 : [People] Favorite contacts from calls tab should reflect under speed dial group in people tab
    [Tags]  309666       bvt_pr       alt_credentials
    [Setup]  Testcase Setup    count=1
    Verify plus icon on people tab   device=device_1
    Click plus icon and Verify its two options    device=device_1
    Close add contact on people tab     device=device_1
    Click drop down menu and verify list of groups   device=device_1
    Verify default group name from drop down    device=device_1
    Select group from drop down     device=device_1     group_name=Speed dial
    Verify favorite contacts under speed dial group     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC4 : [People] DUT user to add a contact into multiple groups in people tab
    [Tags]  309507  bvt_tp   sanity_tp     alt_bug
    [Setup]  Testcase Setup    count=2
    Add from directory   from_device=device_1    to_device=device_2     group_name=Favorites
    Add from directory   from_device=device_1    to_device=device_2     group_name=Tagged
    Verify multiple group name for one user     from_device=device_1    to_device=device_2     group_name=Favorites, Tagged
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=Favorites,Tagged     failTest=False

TC5 : [People] DUT user to be displayed with contact card of a user in people tab
    [Tags]  309513              alt_bug
    [Setup]  Testcase Setup    count=2
    Click on people tab    device=device_1
    Add from directory   from_device=device_1    to_device=device_2     group_name=Tagged
    verify contact card details on people app page  from_device=device_1    to_device=device_2   group_name=Tagged
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=Tagged

TC6 : [People] DUT to edit the group name in people tab
    [Tags]  309482   sanity_tp               alt_credentials
    [Setup]  Testcase Setup    count=1
    Create new group    device=device_1   group_name=edit_group
    Edit group name     device=device_1   old_group_name=edit_group     new_group_name=edited_group
    verify error message after removing group_name       device=device_1   group_name=edited_group
    [Teardown]  Run Keywords    Capture on Failure  AND     check and close create new group window  device=device_1    AND    Come back to home screen    device_list=device_1    AND     Delete group    device=device_1   group_name=edited_group

TC7 : [People] DUT user to delete the groups in people tab
    [Tags]  309476               alt_credentials
    [Setup]   Run Keywords    Testcase Setup    count=1      AND     Create new group    device=device_1   group_name=delete_group
    Delete group    device=device_1   group_name=delete_group
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC8 : [People] DUT user should be able to create group with lengthy name and should not distort UI
    [Tags]  309672           alt_credentials
    [Setup]  Testcase Setup    count=1
    Create new group    device=device_1   group_name=${long_grop_name}
    [Teardown]  Run Keywords    Capture on Failure  AND     check and close create new group window  device=device_1    AND    Come back to home screen    device_list=device_1    AND     Delete group    device=device_1   group_name=${long_grop_name}


TC9 : [People] DUT user to have Global search icon and Call park icon in people tab
    [Tags]  309586   P2 alt_bug
    [Setup]  Testcase Setup    count=1
    Click on people tab    device=device_1
    Validate global search and call park icon   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC10 : [People] DUT user to accept the incoming call while in "Add to directory" page in people tab
    [Tags]  309614   P2  alt_credentials
    [Setup]  Testcase Setup    count=2
    Navigate to Add from directory screen     device=device_1
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Verify add from directory page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC11 : [People] DUT user to receive forwarded calls and group calls in people tab.
    [Tags]  309633   P2  alt_credentials
    [Setup]   Run Keywords   Testcase Setup    count=3   AND    Enable call forwarding and add contact     from_device=device_2     contact_device=device_1
    Click on people tab    device=device_1
    click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_2
    Verify incoming call    device=device_1     status=appear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND   Disable Call forward    device=device_2   AND   Come back to home screen    device_list=device_1,device_2,device_3

TC12 : [People] DUT to create group without entering any characters in people tab
    [Tags]  309471   P1  alt_credentials
    [Setup]  Testcase Setup    count=1
    Validate create new group with empty name    device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND     check and close create new group window  device=device_1   AND    Come back to home screen    device_list=device_1

# Feature changed. We cannot add any contact by global contact search
#TC18 : [People] Teams user to add a contact to a group by contact search
#    [Tags]  175378   P2  alt_bug
#    [Setup]  Testcase Setup    count=2
#    Add contact to group by global contact search icon   from_device=device_1    to_device=device_2     group_name=Speed dial
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC13 : [People]DUT should not be allowed to duplicate group names in people tab
    [Tags]  309592   P2  alt_credentials
    [Setup]  Testcase Setup    count=1
    Create new group    device=device_1   group_name=DuplicateGroup
    Create new group    device=device_1   group_name=DuplicateGroup     group_creation_result=duplicate
    [Teardown]  Run Keywords    Capture on Failure  AND    Delete group    device=device_1   group_name=DuplicateGroup  AND    Come back to home screen    device_list=device_1

TC14 : [People] Group names to be displayed in the contact card of a user in people tab
    [Tags]  309501   P2  alt_bug
    [Setup]  Testcase Setup    count=2
    Click on people tab    device=device_1
    Add from directory   from_device=device_1    to_device=device_2     group_name=Tagged
    verify added group name for user     from_device=device_1    to_device=device_2     group_name=Tagged
    verify contact card details on people app page  from_device=device_1    to_device=device_2   group_name=Tagged
    Verify selected usergroup name    from_device=device_1    group_name=Tagged
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND    Remove user from group  from_device=device_1    to_device=device_2     group_names=Tagged

TC15 : [People] DUT user to be displayed with appropriate banner when no users are added into a group
    [Tags]  309510   P2  alt_credentials
    [Setup]  Testcase Setup    count=1
    Create new group    device=device_1   group_name=no_user_group
    Select created group from drop down     device=device_1     group_name=no_user_group
    Verify group page when no user added    device=device_1     group_name=no_user_group
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND     Delete group    device=device_1   group_name=no_user_group

TC16 : [People] DUT user should be able to view the group participants in people tab
    [Tags]  309532   P2 alt_bug
    [Setup]  Testcase Setup    count=2
    Add from directory   from_device=device_1    to_device=device_2     group_name=Other contacts
    Select created group from drop down     device=device_1     group_name=Other contacts
    Validate selected group users name on people tab     device=device_1    participant_device=device_2     group_name=Other contacts
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=Other contacts

TC17 : [People] DUT user to view the presence of the user in contact card from people tab
    [Tags]  309543   P2  alt_bug
    [Setup]  Testcase Setup    count=1
    Click on people tab    device=device_1
    Add from directory   from_device=device_1    to_device=device_2     group_name=Other contacts
    Select created group from drop down     device=device_1     group_name=Other contacts
    verify contact card details on people app page  from_device=device_1    to_device=device_2      group_name=Other contacts
    Verify presence in contact card page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=Other contacts

TC18 : [People] To verify DUT user to access the main settings via hamburger menu from people tab.
    [Tags]  309595   P2  alt_credentials
    [Setup]  Testcase Setup    count=1
    Click on people tab    device=device_1
    return to home screen    device_list=device_1
    Navigate to hamburger menu    device=device_1
    Verify hamburger menu    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC19 : [People] Designation of contacts should be displayed in people tab
    [Tags]  309627   P2  alt_bug
    [Setup]  Testcase Setup    count=2
    Add from directory   from_device=device_1    to_device=device_2     group_name=Favorites
    Select created group from drop down     device=device_1     group_name=Favorites
    Validate username and designation on people tab     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=Favorites

TC20 : [People] DUT user to switch between the tabs while in people tab..
    [Tags]   309636     P2  alt_credentials
    [Setup]  Testcase Setup    count=1
    Click on people tab    device=device_1
    Navigate to calls tab       device=device_1
    Navigate to calendar tab    device=device_1
    Navigate to voicemail tab    device=device_1
    Navigate to people tab    device=device_1
    [Teardown]  Capture on Failure

TC21 : [People] DUT user should be able to add a contact to a newly created group in people tab
    [Tags]   309644     P2  alt_credentials
    [Setup]  Testcase Setup    count=2
    Add user to newly created group from add contact page   from_device=device_1     to_device=device_2   group_name=New_group
    verify added group name for user     from_device=device_1    to_device=device_2     group_name=New_group
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND     Delete group    device=device_1   group_name=New_group

TC22 : [People] DUT user to receive/reject meeting invite call in people tab
    [Tags]   309659             alt_credentials
    [Setup]  run keywords   Testcase Setup    count=3    AND     clear all meetings except test meeting    device=device_2
    Click on people tab    device=device_1
    Click on people tab    device=device_3
    create meeting  device=device_2       meeting=people_tab_test_meeting
    Join Meeting    device=device_2     meeting=people_tab_test_meeting
    Verify meeting state    device_list=device_2    state=Connected
    Add participant to conversation using display name    from_device=device_2      to_device=device_1
    Wait for Some Time    time=${wait_time2}
    Verify Incoming call    device=device_1     status=appear
    Pick incoming call    device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    End meeting     device=device_1
    Verify Call State    device_list=device_1   state=Disconnected
    Add participant to conversation using display name    from_device=device_2      to_device=device_3
    Wait for Some Time    time=${wait_time2}
    Verify Incoming call    device=device_3     status=appear
    Rejects the incoming call    device_list=device_3
    End meeting     device=device_2
    Verify Call State    device_list=device_2   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Meeting Teardown     devices=device_2    meeting=people_tab_test_meeting   count=3

TC23 : [People] Speed dial contacts from people tab should reflect under favorites section in calls tab
    [Tags]   309921     P2  alt_bug
    [Setup]   Testcase Setup    count=2
    Add from directory   from_device=device_1    to_device=device_2     group_name=Speed dial
    Verify Speed dial contacts from people tab should reflect under calls favorites tab    from_device=device_1     to_device=device_2
    Navigate to people tab    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=Speed dial

TC24 : [People] DUT user to remove a contact from a group in people tab
    [Tags]   309924    P2  alt_bug
    [Setup]   Testcase Setup    count=2
    Add from directory   from_device=device_1    to_device=device_2     group_name=Tagged
    Remove user from group   from_device=device_1    to_device=device_2     group_names=Tagged
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC25 : [People] To verify user should be able to view contacts of any group at People tab and switch groups on people screen
    [Tags]  319002  P2
    [Setup]  Testcase Setup    count=2
    Add from directory   from_device=device_1    to_device=device_2     group_name=Favorites
    Add from directory   from_device=device_1    to_device=device_2     group_name=Tagged
    Click drop down menu and verify list of groups   device=device_1
    select group from drop down  device=device_1    group_name=Favorites
    Click drop down menu and verify list of groups   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=Favorites,Tagged

TC26 : [People] To verify added contact appears in specific group's contacts list on people screen
    [Tags]  319193  P2
    [Setup]  Testcase Setup    count=2
    Add from directory   from_device=device_1    to_device=device_2     group_name=Favorites
    Click drop down menu and verify list of groups   device=device_1
    select group from drop down  device=device_1    group_name=Favorites
    Click drop down menu and verify list of groups   device=device_1
    select group from drop down  device=device_1    group_name=Favorites
    select group from drop down  device=device_1    group_name=all contacts
    verify user in all contacts     from_device=device_1    to_device=device_2
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=Favorites

TC27 : [People] To verify user should be able to create a group at the select a group screen when adding a contact to the group
    [Tags]  319198  P2
    [Setup]  Testcase Setup    count=2
    Add from directory   from_device=device_1    to_device=device_2     group_name=Favorites
    Create new group    device=device_1   group_name=no_user_group
    Select created group from drop down     device=device_1     group_name=no_user_group
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=Favorites    AND     Delete group    device=device_1   group_name=no_user_group

TC28 : [People] To verify user's profile avatar with presence should display in contact list
    [Tags]  319315  P2
    [Setup]  Testcase Setup    count=2
    Add from directory   from_device=device_1    to_device=device_2     group_name=Favorites
    Click drop down menu and verify list of groups   device=device_1
    select group from drop down  device=device_1    group_name=all contacts
    verify user profile avatar   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=Favorites

TC29 : [People App] Validating the three dots in details page.
    [Tags]      321038      P2
    [Setup]  Testcase Setup    count=2
    Add from directory   from_device=device_1    to_device=device_2     group_name=Favorites
    Click drop down menu and verify list of groups   device=device_1
    select group from drop down  device=device_1    group_name=all contacts
    Remove user from group   from_device=device_1    to_device=device_2     group_names=Favorites
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC30: [People App] To verify user should be able to add contact to any group via "Add from directory" and search for contact from directory
    [Tags]    319178        tp_audio      sanity_tp
    [Setup]    Testcase Setup    count=2
    Add from directory   from_device=device_1    to_device=device_2     group_name=Favorites
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=Favorites

TC31:[People] Teams user to add the contacts to groups in people tab
    [Tags]  309503
    [Setup]  Testcase Setup    count=2
    Add from directory   from_device=device_1    to_device=device_2     group_name=Tagged
    verify added group name for user     from_device=device_1    to_device=device_2     group_name=Tagged
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    Remove user from group  from_device=device_1    to_device=device_2     group_names=Tagged

*** Keywords ***
People App Setup
    [Arguments]   ${count}
    Testcase Setup   count=${count}
    Navigate to people tab    device=device_1

Disable Call forward
    [Arguments]     ${device}
    Come back to home screen    device_list=${device}
    verify and disable call forwarding    device=${device}

Send Voicemail
    [Arguments]     ${from_device}   ${to_device}
    Click on calls tab    ${from_device}
    Make outgoing call using display name    ${from_device}      ${to_device}
    Verify Call State    device_list=${from_device}   state=Connected
    Wait for Some Time    time=35s
    Disconnect call     ${from_device}
    Verify Call State    device_list=${from_device}     state=Disconnected

Meeting Teardown
    [Arguments]     ${devices}      ${meeting}    ${count}
    Come back home screen for user    ${count}
    Teardown Meeting Test Case     ${devices}
    clear meetings from calendar tab  ${devices}
*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Setup         People App Setup
Suite Teardown      Suite Failure Capture


*** Variables ***
${wait_time} =      20s
${long_grop_name}=      gggggggggggggggggggggggggggggggggggggggggggggggggggggggrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrooooooooooooooooooooooooooooooouuupppppp
${wait_time2} =      10

*** Test Cases ***
TC1 : [People] DUT user to receive/reject meeting invite call in people tab
    [Tags]   306430     bvt_tpc  sanity_tpc  P0
    [Setup]  run keywords   Testcase Setup for Meeting User    count=3    AND     Remove meeting from calender for meeting policy test    count=3
    Navigate to people tab    device=device_1
    Navigate to people tab    device=device_3
    create meeting  device=device_2       meeting=people_tab_test_meeting
    Join Meeting    device=device_2     meeting=people_tab_test_meeting
    Add participant to conversation using display name    from_device=device_2      to_device=device_1:meeting_user
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

TC2 : [People] Teams user to be displayed with list of groups in people tab
    [Tags]   306406  sanity_tpc  P1
    [Setup]   Testcase Setup for Meeting User    count=1
    Navigate to people tab    device=device_1
    Click drop down menu and verify list of groups   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3 : [People] To verify DUT user to access the main settings via hamburger menu from people tab.
    [Tags]  306417  p2
    [Setup]   Testcase Setup for Meeting User    count=1
    Navigate to people tab    device=device_1
    verify hamburger menu for conf devices       device=device_1     status=on
    verify options inside hamburger menu for cnf device  device=device_1
    open settings page     device=device_1
    verify options under settings for cnf device   device=device_1
    click device settings   device=device_1
    device setting back     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC4 : [People]DUT user to have Global search icon in people tab
    [Tags]  306414
    [Setup]   Testcase Setup for Meeting User    count=1
    Navigate to people tab    device=device_1
    Click drop down menu and verify list of groups    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC5 : [People]DUT should be able to receive the incoming call while in people tab
	[Tags]  319344    P2
    [Setup]   Testcase Setup for Meeting User    count=2
    Navigate to people tab    device=device_1
    Click drop down menu and verify list of groups   device=device_1
    Make outgoing call using display name    from_device=device_2      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC6 : [People]DUT to display "Favorites", "Speed dial" and "other contacts" as default groups under "All Contacts".
	[Tags]  319449    P2
    [Setup]   Testcase Setup for Meeting User    count=1
    Navigate to people tab    device=device_1
    Click drop down menu and verify list of groups   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC7 : [People] - Search
    [Tags]  465974  bvt_tpc     sanity_tpc  P0
    [Setup]   Testcase Setup for Meeting User    count=2
    verify search icon in people tab    device=device_1
    verify list of group names in people tab    device=device_1
    verify all contacts group name is in first group    device=device_1
    validate when user search for a contact in search result    from_device=device_1   to_device=device_2
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC8: [People] - Create new group
    [Tags]  465980  bvt_tpc     sanity_tpc  P0
    [Setup]   Testcase Setup for Meeting User    count=2
    Create new group    device=device_1    group_name=new_group
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND     Delete group    device=device_1   group_name=new_group

TC9 : [People] - Edit Group
    [Tags]  465983  bvt_tpc     sanity_tpc  P0
    [Setup]   Testcase Setup for Meeting User    count=1
    Click on people tab     device=device_1
    verify search icon in people tab    device=device_1
    verify list of group names in people tab    device=device_1
    verify all contacts group name is in first group    device=device_1
    Create new group    device=device_1   group_name=edit_group
    Edit group name     device=device_1   old_group_name=edit_group     new_group_name=edited_group
    [Teardown]  Run Keywords    Capture on Failure  AND     check and close create new group window  device=device_1    AND    Come back to home screen    device_list=device_1    AND     Delete group    device=device_1   group_name=edited_group

TC10 : [People] - Delete Group
    [Tags]  465984
    [Setup]   Testcase Setup for Meeting User    count=1
    Click on people tab     device=device_1
    verify search icon in people tab    device=device_1
    verify list of group names in people tab    device=device_1
    verify all contacts group name is in first group    device=device_1
    Create new group    device=device_1   group_name=delete_group
    Delete group    device=device_1   group_name=delete_group
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC11 : [People] - Add contact to speed dial
    [Tags]  465986
    [Setup]     run keywords    Testcase Setup for Meeting User    count=2    AND    Add from directory   from_device=device_1     to_device=device_2     group_name=Other contacts
    Navigate to people tab    device=device_1
    verify search icon in people tab    device=device_1
    verify list of group names in people tab    device=device_1
    verify all contacts group name is in first group    device=device_1
    select option from more option inside all contact group     device=device_1     to_device=device_2      option=add_speed_dial
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=speed dial,Other contacts

TC12 : [People] - General
    [Tags]  465972  bvt_tpc     sanity_tpc  P0
    [Setup]   Testcase Setup for Meeting User    count=2
    Navigate to people tab    device=device_1
    verify list of group names in people tab    device=device_1
    verify all contacts group name is in first group    device=device_1
    Add from directory   from_device=device_1     to_device=device_2     group_name=Favorites
    refresh the page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=Favorites

TC13 : [People] - Remove contact from speed dial
    [Tags]  465987  bvt_tpc     sanity_tpc  P0
    [Setup]     run keywords    Testcase Setup for Meeting User    count=2    AND    Add from directory   from_device=device_1     to_device=device_2     group_name=Other contacts
    Navigate to people tab    device=device_1
    verify search icon in people tab    device=device_1
    verify list of group names in people tab    device=device_1
    verify all contacts group name is in first group    device=device_1
    select option from more option inside all contact group     device=device_1     to_device=device_2      option=add_speed_dial
    Remove user from group   from_device=device_1    to_device=device_2     group_names=Speed dial
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2     AND     Remove user from group   from_device=device_1    to_device=device_2     group_names=Other contacts

TC14 : [People] - Call
    [Tags]    465985
    [Setup]     run keywords    Testcase Setup for Meeting User    count=2    AND    Add from directory   from_device=device_1     to_device=device_2     group_name=Other contacts
    Navigate to people tab    device=device_1
    verify search icon in people tab    device=device_1
    verify list of group names in people tab    device=device_1
    verify all contacts group name is in first group    device=device_1
    select option from more option inside all contact group     device=device_1     to_device=device_2      option=call
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2     AND     Remove user from group   from_device=device_1    to_device=device_2     group_names=Other contacts


*** Keywords ***
People App Setup
    Navigate to people tab    device=device_1

Disable Call forward
    [Arguments]     ${device}
    Come back to home screen    device_list=${device}
    verify and disable call forwarding    device=${device}

Send Voicemail
    [Arguments]     ${from_device}   ${to_device}
    Make outgoing call using display name    ${from_device}      ${to_device}
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=${from_device}   state=Connected
    Disconnect call     ${from_device}
    Verify Call State    device_list=${from_device}     state=Disconnected

Remove Meeting
    [Arguments]     ${devices}
    Remove meeting from calender   ${devices}

Meeting Teardown
    [Arguments]     ${devices}      ${meeting}    ${count}
    Come back home screen for user    ${count}
    Teardown Meeting Test Case     ${devices}
    Delete meeting      ${devices}    ${meeting}
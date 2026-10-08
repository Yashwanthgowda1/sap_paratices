*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown      Suite Failure Capture


*** Variables ***
${wait_time} =    10

*** Test Cases ***
TC1 : [People] - Search
    [Tags]  465095     bvt_tp  sanity_tp
    [Setup]  Testcase Setup    count=2
    verify search icon in people tab    device=device_1
    validate when user search for a contact in search result    from_device=device_1   to_device=device_2
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : [People] - Unpark call
    [Tags]   465096    bvt_tp  sanity_tp
    [Setup]  Testcase Setup    count=2
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    return to home screen    device_list=device_1
    unpark call from people tab   ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2     state=Connected
    verify call state and disconnect        device=device_1,device_2
    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1   AND  Come back to home screen   device_list=device_1,device_2

TC3 : [People] - Create new group
    [Tags]  465100     bvt_tp  sanity_tp
    [Setup]   Run Keywords  Testcase Setup    count=2   AND   Delete group if exist    device=device_1  group_names=new_group
    Create new group    device=device_1   group_name=new_group
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND     Delete group    device=device_1   group_name=new_group

TC4 : [People] - Add from directory by searching for contact
    [Tags]  465099     bvt_tp  sanity_tp
    [Setup]  Testcase Setup    count=2
    Add from directory   from_device=device_1    to_device=device_2     group_name=Tagged
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=Tagged

TC5 : [People] - General
    [Tags]  465093     bvt_tp  sanity_tp
    [Setup]  Testcase Setup    count=2
    Click on people tab     device=device_1
    verify list of group names in people tab    device=device_1
    verify all contacts group name is in first group    device=device_1
    Add from directory   from_device=device_1     to_device=device_2     group_name=Favorites
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=Favorites

TC6 : [People] - Edit Group
    [Tags]  465105     bvt_tp  sanity_tp
    [Setup]   Run Keywords  Testcase Setup    count=1   AND   Delete group if exist    device=device_1  group_names=edit_group,edited_group
    Click on people tab     device=device_1
    verify list of group names in people tab    device=device_1
    verify all contacts group name is in first group    device=device_1
    Create new group    device=device_1   group_name=edit_group
    Edit group name     device=device_1   old_group_name=edit_group     new_group_name=edited_group
    [Teardown]  Run Keywords    Capture on Failure  AND     check and close create new group window  device=device_1    AND    Come back to home screen    device_list=device_1    AND     Delete group    device=device_1   group_name=edited_group

TC7 : [People] - Delete Group
    [Tags]   465107     P1
    [Setup]   Run Keywords  Testcase Setup    count=1  AND   Delete group if exist    device=device_1  group_names=delete_group
    Click on people tab     device=device_1
    verify list of group names in people tab    device=device_1
    verify all contacts group name is in first group    device=device_1
    Create new group    device=device_1   group_name=delete_group
    Delete group    device=device_1   group_name=delete_group
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC8 : [People] - Add contact to speed dial
    [Tags]  465110     P1
    [Setup]  Testcase Setup    count=2
    Click on people tab     device=device_1
    verify list of group names in people tab    device=device_1
    verify all contacts group name is in first group    device=device_1
    Add from directory   from_device=device_1     to_device=device_2     group_name=Speed dial
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=Speed dial

TC9 : [People] - Remove contact from speed dial
    [Tags]   465111     bvt_tp  sanity_tp
    [Setup]  Testcase Setup    count=2
    Click on people tab     device=device_1
    verify list of group names in people tab    device=device_1
    verify all contacts group name is in first group    device=device_1
    Add from directory   from_device=device_1     to_device=device_2     group_name=Speed dial
    Remove user from group   from_device=device_1    to_device=device_2     group_names=Speed dial
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC10 : [People] DUT user should be able to receive the incoming call while creating new group in people tab
    [Tags]      309598      sanity_tp
    [Setup]  Testcase Setup    count=2
    Navigate to Create group screen     device=device_1
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Verify create new group page    device=device_1
    click cancel btn    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND     check and close create new group window  device=device_1    AND    Come back to home screen    device_list=device_1,device_2

TC12 : [People] DUT user should not be displayed with any search results when searching for own name in people tab
    [Tags]  309589
    [Setup]  Testcase Setup    count=1
    Validate when user search for its own name in search result     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC13 : [People] - Remove from group
    [Tags]  465119    bvt_tp   sanity_tp
    [Setup]   Testcase Setup       count=2
    Add from directory   from_device=device_1    to_device=device_2     group_name=Tagged
    return to home screen    device_list=device_1
    Remove user from group   from_device=device_1    to_device=device_2     group_names=Tagged
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC14 : [People] - Add contact to group
    [Tags]  465112    bvt_tp   sanity_tp
    [Setup]   Run Keywords    Testcase Setup    count=2    AND    Add existing contact to group setup   from_device=device_1      to_device=device_2
    Click on people tab     device=device_1
    verify list of group names in people tab    device=device_1
    verify all contacts group name is in first group    device=device_1
    add user to a group from all contacts page    from_device=device_1   to_device=device_2    group_name=Other contacts
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2   AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=Tagged,Other contacts

TC15 : [People] - Add contact to a new group
    [Tags]  465114    bvt_tp   sanity_tp
    [Setup]   Run Keywords   Testcase Setup     count=2    AND   Add from directory   from_device=device_1    to_device=device_2     group_name=Other contacts
    Click on people tab     device=device_1
    verify list of group names in people tab    device=device_1
    verify all contacts group name is in first group     device=device_1
    add user to a group from all contacts page    from_device=device_1   to_device=device_2     create_new_group=test_group
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND     Delete group    device=device_1   group_name=test_group
    
TC16 : [People] - Call
    [Tags]  465108   P1
    [Setup]     run keywords     Testcase Setup    count=2    AND    Add from directory   from_device=device_1     to_device=device_2     group_name=Other contacts
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

TC17 : [People] DUT user to switch from people tab to voicemail tab by pressing voicemail hard key
    [Tags]    309640
    [Setup]  Testcase Setup    count=1
    ${voicemail_button}   has hardkey voicemail button supported device   device=device_1
    pass execution if   '${voicemail_button}'=='False'  device_1, device is not have voicemail button
    Navigate to people tab    device=device_1
    verify search icon in people tab    device=device_1
    press hardkeys   device=device_1    hardkey_intent=500
    refresh the page    device=device_1
    verify voicemail tab        device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC18 : [Calls App] Validating recent call history on the recents screen
    [Tags]    320963    P2     sanity_tp
    [Setup]  Testcase Setup     count=1
    Navigate to calls tab   device=device_1
    open and verify dialpad from calls tab    device=device_1
    ${return_first_user_call_person}      search random user and make call   from_device=device_1      to_device=device_2
    Disconnect call     device=device_1
    Navigate to calls tab   device=device_1
    verify and get first recent call in recent tab    device=device_1     first_username_is=${return_first_user_call_person}
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC19 : [People] To verify user should see the SLA banner at the top of the screen at peoples tab also
    [Tags]    319346
    [Setup]    Testcase Setup    count=2
    Click On Calls Tab    device=device_1
    Make Outgoing Call Using Display Name    from_device=device_1    to_device=device_2
    Pick Incoming Call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold The Call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    Verify Resume Banner    device_list=device_1
    Return To Home Screen    device_list=device_1
    Navigate To People Tab    device=device_1
    Verify People Navigation    device=device_1
    Verify Plus Icon On People Tab    device=device_1
    Verify Search Icon In People Tab    device=device_1
    Verify Resume Banner    device_list=device_1
    Disconnect Call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]    Run Keywords    Capture On Failure    AND    Come Back To Home Screen    device_list=device_1

TC20 : [Calls App] Search a user from the Calls App screen
    [Tags]   320966
    [Setup]    Testcase Setup    count=1
    Navigate to calls tab   device=device_1
    open and verify dialpad from calls tab    device=device_1
    Search Text   from_device=device_1      to_device=device_2
    verify searched random user inside directory      from_device=device_1    to_device=device_2
    [Teardown]    Run Keywords    Capture On Failure    AND    Come Back To Home Screen    device_list=device_1

TC19 : [People] Verify DUT is not able to add a contact to a group by contact search
    [Tags]    309675
    [Setup]    Testcase Setup    count=1
    Navigate To People Tab    device=device_1
    Verify People Navigation    device=device_1
    Verify Plus Icon On People Tab    device=device_1
    Verify Search Icon In People Tab    device=device_1
    Verify All Contacts Group Name Is In First Group    device=device_1
    Validate When User Search For A Contact In Search Result    from_device=device_1    to_device=device_2
    [Teardown]    Run Keywords    Capture On Failure    AND    Come Back To Home Screen    device_list=device_1

#   Disabling this test until the service is ready for these changes in R4
#TC18 : [People] - Add external contact
#    [Tags]  532398   534048  bvt_tp   sanity_tp
#    [Setup]     run keywords    Testcase Setup    count=1  AND    Delete external contact   from_device=device_1    to_device=device_2:pstn_user   failTest=False
#    Navigate to people tab    device=device_1
#    Create new contact      from_device=device_1    to_device=device_2:pstn_user      group_name=Other contacts
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2     AND    Delete external contact   from_device=device_1    to_device=device_2:pstn_user

#TC19 : [People] - Edit external contact
#    [Tags]  532403  bvt_tp   sanity_tp
#    [Setup]     run keywords    Testcase Setup    count=1  AND    Edit external contact setup   from_device=device_1    to_device=device_2:pstn_user
#    Navigate to people tab    device=device_1
#    Edit external contact    from_device=device_1    to_device=device_2:pstn_user     updated_name=updated_name
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2     AND    Delete external contact by name   from_device=device_1    user_to_be_removed=updated_name

*** Keywords ***

Add existing contact to group setup
   [Arguments]     ${from_device}      ${to_device}
   Remove user from group   from_device=${from_device}    to_device=${to_device}     group_names=Tagged,Other contacts  failTest=False
   Add from directory   from_device=${from_device}    to_device=${to_device}     group_name=Tagged

Edit external contact setup
    [Arguments]     ${from_device}      ${to_device}
    Delete external contact   from_device=${from_device}    to_device=${to_device}      failTest=False
    Create new contact   from_device=${from_device}    to_device=${to_device}     group_name=Tagged
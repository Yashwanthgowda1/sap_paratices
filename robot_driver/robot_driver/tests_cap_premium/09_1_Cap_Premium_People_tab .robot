*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown      Suite Failure Capture


*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [People] - Search
    [Tags]  465106     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User  count=2
    verify search icon in people tab    device=device_1
    verify list of group names in people tab    device=device_1
    validate when user search for a contact in search result    from_device=device_1   to_device=device_2
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : [People] - Create new group
    [Tags]  465117    BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User    count=2
    Create new group    device=device_1    group_name=new_group
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND     Delete group    device=device_1   group_name=new_group

TC3 : [People] - Unpark call
    [Tags]   465109    BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User     count=2
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    return to home screen    device_list=device_1
    unpark call from people tab   ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2     state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1   AND  Come back to home screen   device_list=device_1,device_2

TC4 : [People] - Edit Group
    [Tags]  465122    BVT_CAPPremium     Sanity_CAPPremium
    [Setup]   Testcase Setup for CAP Premium User    count=1
    Click on people tab     device=device_1
    verify list of group names in people tab    device=device_1
    verify all contacts group name is in first group    device=device_1
    Create new group    device=device_1   group_name=edit_group
    Edit group name     device=device_1   old_group_name=edit_group     new_group_name=edited_group
    [Teardown]  Run Keywords    Capture on Failure  AND     check and close create new group window  device=device_1    AND    Come back to home screen    device_list=device_1    AND     Delete group    device=device_1   group_name=edited_group

TC5 : [People] - Delete Group
    [Tags]  465123    BVT_CAPPremium     Sanity_CAPPremium
    [Setup]   Testcase Setup for CAP Premium User    count=1
    Click on people tab     device=device_1
    verify list of group names in people tab    device=device_1
    verify all contacts group name is in first group    device=device_1
    Create new group    device=device_1   group_name=delete_group
    Delete group    device=device_1   group_name=delete_group
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC6 : [People] - Add contact to speed dial
    [Tags]  465125     P2
    [Setup]   Testcase Setup for CAP Premium User   count=2
    Click on people tab     device=device_1
    verify list of group names in people tab    device=device_1
    verify all contacts group name is in first group    device=device_1
    Add from directory   from_device=device_1     to_device=device_2     group_name=Speed dial
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=Speed dial

TC7 : [People] - General
    [Tags]  465104     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User    count=2
    Click on people tab     device=device_1
    verify list of group names in people tab    device=device_1
    verify all contacts group name is in first group    device=device_1
    Add from directory   from_device=device_1     to_device=device_2     group_name=Favorites
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=Favorites

TC8 : [People] - Add contact to group
    [Tags]  465128    BVT_CAPPremium     Sanity_CAPPremium
    [Setup]    Testcase Setup for CAP Premium User    count=2
    Add from directory   from_device=device_1    to_device=device_2     group_name=other contacts
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=other contacts

TC9 : [People] - Remove from group
    [Tags]  465131   BVT_CAPPremium     Sanity_CAPPremium
    [Setup]   Testcase Setup for CAP Premium User    count=2
    Add from directory   from_device=device_1    to_device=device_2     group_name=Tagged
    return to home screen    device_list=device_1
    Remove user from group   from_device=device_1    to_device=device_2     group_names=Tagged
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC10 : [People] - Add from directory by searching for contact
    [Tags]  465115   BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User   count=2
    Add from directory   from_device=device_1    to_device=device_2     group_name=Tagged
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=Tagged

*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***


*** Test Cases ***
TC1: [Create Group][People] DUT to create group without entering any characters in people tab
    [Tags]  451513    sanity_lcp
    [Setup]  Testcase Setup     count=1
    Validate create new group with empty name    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2: [People] - Search
    [Tags]  465934   bvt_lcp      sanity_lcp
    [Setup]  Testcase Setup    count=2
    navigate to people tab      device=device_1
    verify options inside people tab for lcp    device=device_1
    validate when user search for a contact in search result    from_device=device_1   to_device=device_2
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3: [People] - Unpark call
    [Tags]  465940   bvt_lcp      sanity_lcp
    [Setup]  Testcase Setup    count=2
    navigate to people tab      device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    repeat keyword  3 times     device setting back     device=device_1
    navigate to people tab      device=device_1
    verify options inside people tab for lcp    device=device_1
    unpark call from people tab   ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2     state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1   AND  Come back to home screen   device_list=device_1,device_2

TC4 :[People] DUT should be able to receive the incoming call while in people tab
    [Tags]  244032      bvt_lcp      sanity_lcp
    [Setup]  Testcase Setup    count=2
    navigate to people tab      device=device_1
    verify options inside people tab for lcp    device=device_1
    navigate to people tab      device=device_1
    navigate to people tab      device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC5: [Create Group][People] DUT user to create new group in people tab
    [Tags]  451512    bvt_lcp
    [Setup]  Testcase Setup     count=1
    Create new group    device=device_1   group_name=new_group
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND     Delete group    device=device_1   group_name=new_group

TC6 : [People] To verify user should see the call hold banner at the top of the screen at people tab.
    [Tags]  319401
    [Setup]  Testcase Setup     count=2
    navigate to people tab      device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Hold the call   device=device_1
    Verify Call State    device_list=device_1,device_2    state=hold
    verify resume banner  device_list=device_1
    device setting back     device=device_1
    navigate to people tab      device=device_1
    verify call hold banner   from_device=device_1   to_device=device_2
    Verify Call State    device_list=device_1,device_2    state=hold
    Resume Call From Call Hold Banner    device=device_1
    Verify Call State    device_list=device_1,device_2    state=connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC7 : [People] DUT to accept and decline the incoming call while searching for a contact in people tab
    [Tags]  244037
    [Setup]    Testcase Setup     count=2
    navigate to people tab      device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=disconnected
    verify ui post signin   device=device_2
    Click Back    device=device_1
    verify search page      device=device_1
    Click Back    device=device_1
    come back to home screen page and verify    device=device_1
    navigation search page in people tab    device=device_1
    navigate to people tab      device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    verify incoming call  device=device_1   status=appear
    Disconnect call     device=device_1
    verify search page      device=device_1
    Disconnect call     device=device_2
    Click Back    device=device_1
    come back to home screen page and verify    device=device_1
    Verify Call State    device_list=device_1,device_2    state=disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC8 : [People] DUT to switch from people tab to voicemail tab by pressing voicemail hard key
    [Tags]    244045    
    [Setup]    Testcase Setup    count=1
    navigate to people tab      device=device_1
    ${voicemail_button}   has hardkey voicemail button supported device   device=device_1
    pass execution if   '${voicemail_button}'=='False'  device_1, device is not have voicemail button
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_BUTTON_15
    Wait for Some Time    time=${wait_time}
    ${voicemail_page}=    verify voicemail navigation    device=device_1
    should be true    ${voicemail_page}
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC9 : [People] DUT to have Global search icon in people tab
    [Tags]  244028
    [Setup]    Testcase Setup     count=2
    navigate to people tab      device=device_1
    verify options inside people tab for lcp    device=device_1
    validate when user search for a contact in search result    from_device=device_1   to_device=device_2
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC10 : [People] DUT to be displayed with list of groups in people tab
    [Tags]    244001    sanity_lcp    p1
    [Setup]    run Keywords    Testcase Setup     count=1    AND    Create new group    device=device_1    group_name=list_of_groups
    ${contact_button}   has hardkey contact button supported device    device=device_1
    pass execution if   '${contact_button}'=='False'  device_1, device is not have contact button
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_CONTACTS
    ${people_navigation_result}=     verify people navigation    device=device_1
    should be true    ${people_navigation_result}
    Click drop down menu and verify list of groups   device=device_1
    Select group from drop down     device=device_1     group_name=All Contacts
    [Teardown]    Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND     Delete group    device=device_1   group_name=list_of_groups

TC11: [People] - Create new group
    [Tags]  465938     bvt_lcp  sanity_lcp    p0
    [Setup]  Testcase Setup    count=1
    navigate to people tab    device=device_1
    Create new group    device=device_1   group_name=new_group1
    [Teardown]  Run Keywords    Capture on Failure    AND     Come back to home screen    device_list=device_1    AND    Delete group    device=device_1     group_name=new_group1

TC12 : [People] DUT user to receive forwarded calls and group calls in people tab
    [Tags]    244043    tp_lcp    p2
    [Setup]   Run Keywords   Testcase Setup    count=3   AND    Enable call forwarding and add contact     from_device=device_2     contact_device=device_1
    navigate to people tab    device=device_1
    verify options inside people tab for lcp    device=device_1
    click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_2
    Verify incoming call    device=device_1     status=appear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND   verify and disable call forwarding    device=device_2    AND   Come back to home screen    device_list=device_1,device_2,device_3
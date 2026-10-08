*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation      Suite Setup Requirements : This suite requires minimum of 2 devices in config
...                Purpose: Device_1 should receive voicemail from Device_2

Suite Setup         Voicemail Setup
Suite Teardown      Run Keywords    Suite Failure Capture   AND     Voicemail Teardown

*** Variables ***
${wait_time} =  10
${new_vm_num} =     4

*** Test Cases ***
TC1 : [Voicemail] DUT user to refresh the VM tab manually
    [Tags]  307707    vm    P2  alt_bug
    [Setup]  Testcase Setup    count=2
    ${voicemail_count_before_new_voicemail}=    Get unread voicemail count    device=device_1
    Send Voicemail      from_device=device_2   to_device=device_1
    Refresh for voicemail visibility    device=device_1
    ${voicemail_count_after_new_voicemail}=    Get unread voicemail count    device=device_1
    run keyword if  ${voicemail_count_before_new_voicemail}+1 == ${voicemail_count_after_new_voicemail}    Log   voicemail count got increased
    ...   ELSE   fail   Unable to refresh automatically because Voicemail count didn't increase.
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : [Voicemail] DUT user to scroll through the voicemails and Search user from the voicemail page
    [Tags]  306774   vm     P2  alt_credentials
    [Setup]  Testcase Setup    count=1
    Navigate to voicemail tab    device=device_1
    Scroll through voicemails   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3 : [Voicemail] DUT user can decline the incoming call while playing VM
    [Tags]  307073   vm     P2  alt_credentials
    [Setup]  run keywords  Testcase Setup    count=2   AND   verify and disable call forwarding    device=device_1
    Send Voicemail      from_device=device_2    to_device=device_1
    Send Voicemail      from_device=device_2    to_device=device_1
    Wait for Some Time    time=${wait_time}
    Refresh for voicemail visibility    device=device_1
    Verify 1st voicemail    device=device_1
    Navigate to voicemail tab    device=device_1
    Play voicemail    device=device_1
    Navigate to calls tab   device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Wait for Some Time    time=${wait_time}
    Rejects the incoming call    device_list=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    Resume voicemail    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2   AND   Set Call Forwarding    device=device_1

TC4 : [Voicemail] DUT displays the count of unread messages on voicemail tab (UI)
    [Documentation]  Devices are already signed-in in Suite Setup
    [Tags]  306776   P1  alt_bug        Certification_audio
    [Setup]  Run keywords    Testcase Setup    count=2    AND    Enable call forwarding to voicemail    from_device=device_1     contact_device=device_2
    Clear notification from home screen     device=device_1
    ${vm_count_before}=    Get unread voicemail count    device=device_1
    Navigate to calendar tab     device=device_1
    Repeat Keyword    3 times    Send Voicemail      from_device=device_2    to_device=device_1
    Wait for Some Time    time=10
    Return to home screen    device_list=device_1
    Verify voicemail notification     to_device=device_1     from_device=device_2
    ${vm_count_after}=    Get unread voicemail count    device=device_1
    navigate to voicemail tab    device=device_1
    play voicemail    device=device_1
    run keyword if  ${vm_count_before} + 3 == ${vm_count_after}    Log   voicemail count has increased
    ...   ELSE   fail   Voicemail count didn't increase
    ${vm_count_post_reading}=    Get unread voicemail count    device=device_1
    run keyword if  ${vm_count_post_reading} == 0    Log   voicemail count has decreased
    ...   ELSE   fail   Voicemail count didn't decrease
    [Teardown]   Run Keywords    Capture on Failure    AND     Disable Call forward   devices=device_1,device_2

TC5 : [Voicemail] DUT user to call the user who left the VM from the voicemail tab
    [Tags]  307003    vm    P2  alt_bug
    [Setup]  Testcase Setup    count=2
    Send Voicemail      from_device=device_2   to_device=device_1
    Navigate to voicemail tab    device=device_1
    refresh the page    device=device_1
    Click on voicemail play button and validate    device=device_1
    Call user who left voice mail   device=device_1
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC6 : [Voicemail] DUT user to see the details of the user who left the VM using the contact card option in the voicemail
    [Tags]  307006    vm    P2  alt_bug
    [Setup]  Testcase Setup    count=2
    Send Voicemail      from_device=device_2   to_device=device_1
    Navigate to voicemail tab    device=device_1
    Refresh for voicemail visibility    device=device_1
    Verify user contact details who left voice mail    device=device_1    from_device=device_2
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC7 : [Voicemail] DUT user should receive the VM, while playing other VM's.
    [Tags]  309219    vm    P2  alt_bug
    [Setup]  Testcase Setup    count=2
    Navigate to voicemail tab    device=device_1
    Play voicemail    device=device_1
    ${voicemail_count_before_new_voicemail}=    Get unread voicemail count    device=device_1
    Send Voicemail      from_device=device_2   to_device=device_1
    Refresh for voicemail visibility    device=device_1
    ${voicemail_count_after_new_voicemail}=    Get unread voicemail count    device=device_1
    run keyword if  ${voicemail_count_before_new_voicemail}+1 == ${voicemail_count_after_new_voicemail}    Log   Got new VM whileplaying other VM
    ...   ELSE   fail   Didn't get new VM whileplaying other VM.
    [Teardown]  Capture on Failure

TC8 : [Voicemail] DUT user can toggle between VM and call
    [Tags]  307075   vm1    P2  alt_bug
    [Setup]  run keywords  Testcase Setup    count=2   AND    verify and disable call forwarding    device=device_1
    Navigate to voicemail tab    device=device_1
    Play voicemail    device=device_1
    navigate to calls tab   device_1
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call   device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1    state=Hold
    Click back btn  device=device_1
    Resume voicemail    device=device_1
    Click on call action bar  device=device_1
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    Resume voicemail    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2   AND   Set Call Forwarding    device=device_1

TC9 : [Voicemail] DUT user should not display any messages in voicemail tab when all VMs are deleted from device
    [Tags]  307120   vm     P2  alt_credentials
    [Setup]  Testcase Setup    count=1
    Navigate to voicemail tab    device=device_1
    Delete all voicemails   device=device_1
    Verify voicemail object for new user   device=device_1
    [Teardown]  Capture on Failure

TC10 : [Voicemail] DUT user receives the first message when VM box is empty
    [Tags]  309048   vm     P2  alt_credentials
    [Setup]  Run Keywords  Testcase Setup    count=2  AND     Navigate to voicemail tab    device=device_1    AND     Delete all voicemails   device=device_1
    Verify voicemail object for new user   device=device_1
    Send Voicemail      from_device=device_2   to_device=device_1
    Wait for Some Time    time=${wait_time}
    Refresh for voicemail visibility    device=device_1
    Verify 1st voicemail    device=device_1
    [Teardown]  Capture on Failure

TC11 : [Voicemail] DUT user plays the message by off hook
    [Tags]       309030       P2
    [Setup]    Testcase Setup   count=1
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK      status=ON
    Wait for Some Time    time=${wait_time}
    verify dialpad after clicking speaker or handsethook button    device=device_1
    Navigate to voicemail tab    device=device_1
    Verify 1st voicemail    device=device_1
    Click on voicemail play button and validate    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC12 : [Voicemail] Verify the voicemail showing all the elements as expected in collapsed mode and expanded mode
    [Tags]    318712          sanity_tp
    [Setup]     Testcase Setup    count=2
    Navigate to voicemail tab    device=device_1
    verify voicemail option before collapse after collapse    from_device=device_1    to_device=device_2
    click on home bar icon        device=device_1
    verify voicemail option remains in collapse state     device=device_1
    verify voicemail option before collapse after collapse    from_device=device_1    to_device=device_2      condition=after_collaps
    play specific voicemail      from_device=device_1    to_device=device_2    play_voicemail_no=2
    verify voicemail option before collapse after collapse    from_device=device_1    to_device=device_2
    [Teardown]    Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC13 : [Voicemail] Verify "Work voicemail" option during consult transfer
    [Tags]      310897   P0   bvt_tp     sanity_tp
    [Setup]  Testcase Setup   count=3
    Make outgoing call using display name   from_device=device_2   to_device=device_1
    verify incoming call   device=device_1    status=appear
    pick incoming call   device=device_1
    verify call state   device_list=device_1,device_2     state=Connected
    verify work voicemail during call transfer   from_device=device_1   to_device=device_3   transfer_method=consult
    resume call from call hold banner     device=device_1
    disconnect call  device=device_1
    verify call state    device_list=device_1,device_2     state=Disconnected
    [Teardown]  run keywords    Capture on Failure   AND   come back to home screen    device_list=device_1,device_2,device_3

*** Keywords ***
Voicemail Setup
    Testcase Setup   count=2
    Set Call Forwarding    device=device_1
    Send Voicemail      from_device=device_2    to_device=device_1
    Wait for Some Time    time=${wait_time}
    Refresh for voicemail visibility    device=device_1
    Verify 1st voicemail    device=device_1
    ${vm_status}    Verify vm tab status    device=device_1
    run keyword if   ${vm_status} == False    Send Voicemail      from_device=device_2    to_device=device_1
    ...   ELSE   log   Voicemail available in VM Tab no need to send new VM.
    return to home screen   device_1

Voicemail Teardown
    Come back to home screen    device_list=device_1,device_2
    verify and disable call forwarding    device=device_1

Send Voicemail
    [Arguments]     ${from_device}   ${to_device}
    Navigate to calls tab    ${from_device}
    Make outgoing call using display name    ${from_device}      ${to_device}
    Verify Call State    device_list=${from_device}   state=Connected
    Wait for Some Time    time=45s
    verify call state and disconnect    ${from_device}

Disable Call forward
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    verify and disable call forwarding    device=device_1
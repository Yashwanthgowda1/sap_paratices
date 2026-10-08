*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation      Suite Setup Requirements : This suite requires minimum of 2 devices in config
...                Purpose: Device_1 should receive voicemail from Device_2

Suite Setup         Voicemail Setup
Suite Teardown      Run Keywords    Suite Failure Capture   AND     Voicemail Teardown


*** Variables ***


*** Test Cases ***
TC1 : [Voicemail] DUT User can receive Voicemail
    [Tags]  306773   sanity_tp   bvt_tp    bvt_pr  alt_bug
    [Setup]  Testcase Setup    count=2
    Send Voicemail      from_device=device_2   to_device=device_1
    Navigate to voicemail tab    device=device_1
    refresh the page    device=device_1
    Click on voicemail play button and validate    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : [Voicemail] DUT user's Voicemail tab should refresh automatically
    [Tags]  307088   sanity_tp        bvt_pr  alt_bug       Certification_audio
    [Setup]  Testcase Setup    count=2
    ${voicemail_count_before_new_voicemail}=    Get unread voicemail count    device=device_1
    ${voicemail_time_before_new_voicemail}=    get first voicemail time    device=device_1
    Send Voicemail      from_device=device_2   to_device=device_1
    Wait for Some Time    time=10s
    ${voicemail_count_after_new_voicemail}=    Get unread voicemail count    device=device_1
    ${voicemail_time_after_new_voicemail}=    get first voicemail time    device=device_1
    run keyword if  ${voicemail_count_before_new_voicemail}+1 == ${voicemail_count_after_new_voicemail}    Log   voicemail count got increased
    ...   ELSE   fail   Unable to refresh automatically because Voicemail count didn't increase.
    run keyword if  '${voicemail_time_before_new_voicemail}' != '${voicemail_time_after_new_voicemail}'    Log   First voicemail time got updated
    ...   ELSE   fail   Unable to refresh automatically because first voicemail time is not updated
    verify first voicemail displayname       to_device=device_1    from_device=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3 : [Voicemail] DUT user can Play/pause the message (VM) multiple times
    [Tags]  307098   sanity_tp    vm      alt_bug       Certification_audio
    [Setup]  Testcase Setup    count=1
    Navigate to voicemail tab    device=device_1
    refresh the page    device=device_1
    Play voicemail    device=device_1
    Pause voicemail     device=device_1
    Resume voicemail    device=device_1
    Pause voicemail     device=device_1
    Resume voicemail    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC4 : [Voicemail] DUT user can Play the message (VM) with different speed
    [Tags]  307105   sanity_tp    vm      alt_credentials
    [Setup]  Testcase Setup    count=1
    Navigate to voicemail tab    device=device_1
    Play vm with diff speed     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC5 :[Voicemail] User should be able to open the voicemail sender profile
    [Tags]  318713     vm      p2
    [Setup]  Testcase Setup    count=2
    Send Voicemail      from_device=device_2   to_device=device_1
    Navigate to voicemail tab    device=device_1
    refresh the page    device=device_1
    Verify user contact details who left voice mail    device=device_1    from_device=device_2
    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC6 : [Voicemail] DUT user delete the message while playing it.
    [Tags]  309004   sanity_tp    vm      alt_bug
    [Setup]  Testcase Setup    count=2
    Send Voicemail      from_device=device_2   to_device=device_1
    Navigate to voicemail tab    device=device_1
    refresh the page    device=device_1
    Delete voicemail while playing it    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC7 : [Voicemail] DUT user to delete the voicemail from the list
    [Tags]  306777   vm       alt_credentials       Certification_audio
    [Setup]  Testcase Setup    count=1
    Navigate to voicemail tab    device=device_1
    Delete voicemail while playing it    device=device_1
    refresh the page    device=device_1
    Delete all voicemails   device=device_1
    [Teardown]    Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1

TC8 : [Voicemail Greetings] Change voicemail greetings link should visible in calling settings page if voicemail is enabled for the logged in user
    [Tags]   321026   P2
    [Setup]  Testcase Setup    count=1
    Verify settings calling option     device=device_1
    verify change voicemail greetings option inside calling     device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC9 : [Volume] DUT user to control the Volume from Hard Button while playing a Voicemail
    [Tags]    306799    certification_audio
    [Setup]  Testcase Setup    count=2
    Send Voicemail      from_device=device_2   to_device=device_1
    Navigate to voicemail tab    device=device_1
    refresh the page    device=device_1
    Play voicemail    device=device_1
    increase volume and verify    device=device_1    volume_stream=music
    decrease volume and verify    device=device_1    volume_stream=music
    pause voicemail    device=device_1
    [Teardown]    Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1

TC10 : [Auto Restart] DUT user verify auto restart while playing the voicemail
    [Tags]    319341
    [Setup]   Testcase Setup  count=2
    Send Voicemail      from_device=device_2   to_device=device_1
    open settings page       device=device_1
    verify auto restart option inside settings page      device=device_1
    Click on toggle btn    device=device_1    status=on
    verify options after enabling auto restart toggle btn     device=device_1
    enable disable automatically toggle btn inside app restart      device=device_1
    verify options after disabling automatically toggle btn    device=device_1
    set timer for app restart    device=device_1    time_=3
    return to home screen    device_list=device_1
    Navigate to voicemail tab    device=device_1
    refresh the page    device=device_1
    Play voicemail    device=device_1
    verify app restarting at set time    device=device_1
    return to home screen    device_list=device_1
    open settings page       device=device_1
    verify auto restart option inside settings page      device=device_1
    Click on toggle btn    device=device_1    status=off
    [Teardown]    Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1

TC11 : [Voicemail] Verify transfer should have option to choose to send voicemail to transfer target directly
    [Tags]    310894    bvt_tp    sanity_tp    smoke_tp
    [Setup]   Testcase Setup  count=3
    Navigate to voicemail tab    device=device_2
    Delete all voicemails   device=device_2
    return to home screen    device_list=device_2
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify initial list contacts in the call transfer section     from_device=device_1      to_device=device_2
    click contact menu in transfer now screen    device=device_1
    select favorites user option    device=device_1    option=leave voicemail
    Verify Call State     device_list=device_1     state=Disconnected
    Verify Call State     device_list=device_3     state=Connected
    Disconnect call     device=device_3
    Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
    Navigate to voicemail tab    device=device_2
    refresh the page    device=device_2
    Play voicemail    device=device_2
    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC12 : [Call Transfer]Transfer target person must be able to play that voicemail message
    [Tags]    320964
    [Setup]   Testcase Setup  count=3
    Click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify initial list contacts in the call transfer section     from_device=device_3      to_device=device_1
    click contact menu in transfer now screen    device=device_3
    select favorites user option    device=device_3    option=leave voicemail
    Verify Call State     device_list=device_3     state=Disconnected
    Verify Call State     device_list=device_2     state=Connected
    Disconnect call     device=device_2
    Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
    Navigate to voicemail tab    device=device_1
    refresh the page    device=device_1
    Play voicemail    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3


*** Keywords ***
Voicemail Setup
    Testcase Setup   count=2
    Set Call Forwarding    device=device_1
    Navigate to voicemail tab    device=device_1
    Delete all voicemails   device=device_1
    Send Voicemail      from_device=device_2    to_device=device_1
    Wait for Some Time    time=${wait_time}
    Refresh for voicemail visibility    device=device_1
    Verify 1st voicemail    device=device_1
    ${vm_status}    Verify vm tab status    device=device_1
    run keyword if   ${vm_status} == False    run keyword     Send Voicemail      from_device=device_2    to_device=device_1
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


*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10
${wait_time1} =  50
${wait_time2} =  15


*** Test Cases ***
TC1 : [Call Merge] DUT user merge PSTN user call with TDC user
    [Tags]   309880    bvt_tp    sanity_tp    bvt_pr        alt_blocked
    [Setup]     Testcase Setup for PSTN User   count=3
    Click on calls tab   device=device_1
    Make outgoing call using phonenumber     from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call     device=device_2
    Verify Call State     device_list=device_1,device_2     state=Connected
    return to home screen    device_list=device_1
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_3
    Pick incoming call      device=device_3
    wait for some time   time=${wait_time}
    Verify call state      device_list=device_1,device_3     state=Connected
    Verify and merge call  device=device_1     from_device=device_2:pstn_user
    Verify call state   device_list=device_1,device_2,device_3   state=Connected
    disconnect call    device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    Come back to home screen   device_list=device_1,device_2,device_3
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3

TC2 : [Calls] DUT user to display Phone numbers instead of names, when added PSTN number into speed dial.
    [Tags]      309927    P2  alt_blocked         sanity_tp
    [Setup]   Run Keywords    Testcase Setup for PSTN User    count=2   AND   Make outgoing call for call log   from_device=device_2     to_device=device_1
    Select call list item   device=device_1  item=favorite
    Calling from favorite page   from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND   Remove favorite user from favorites page    from_device=device_1     to_device=device_2:pstn_user

TC3 : [Call Hold] DUT user hold the muted call with PSTN user
    [Tags]  310288    P2  alt_blocked
    [Setup]  Testcase Setup for PSTN User    count=2
    Click on calls tab   device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_1
    Verify Call mute State    device_list=device_1    state=mute
    Hold the call   device=device_1
    Verify Call State    device_list=device_1    state=Hold
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    Verify Call mute State    device_list=device_1    state=mute
    Unmutes the phone call  device=device_1
    Verify Call mute State    device_list=device_1    state=Unmute
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC4 : [App Settings] DUT user block calls with no caller ID
    [Tags]  307675   P2  alt_credentials
    [Setup]  run keywords   Testcase Setup for PSTN User    count=2    AND   verify and block calls with no caller id   device=device_1     block_user=device_2:pstn_user
    Click on calls tab   device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=Disappear
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     verify and unblock calls with no caller id   device=device_1

TC5 : [Esc to Conf.] DUT user in P2P call with TDC, adds PSTN user
    [Documentation]  Devices are already signed-in in Suite Setup
    [Tags]  307107  esc_conf_pstn   sanity_tp      alt_blocked       Certification_audio
    [Setup]  Testcase Setup for PSTN User   count=3
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Mute all participants       device=device_1
    Verify meeting Mute State    device_list=device_3    state=mute
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC6 : [Esc to Conf.] DUT user in P2P call with another DUT user, adds PSTN user to call
    [Tags]  307113   sanity_tp      esc_to_cnf          bvt_pr  alt_blocked
    [Setup]  Testcase Setup for PSTN User    count=3
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    verify participant list     from_device=device_1      connected_device_list=device_1,device_2:pstn_user,device_3
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3     state=Disconnected
    Verify Call State    device_list=device_1,device_2     state=Connected
    verify participant list     from_device=device_1      connected_device_list=device_1,device_2:pstn_user
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC7 : [CallTransferEnhancements] consult transfer search screen > place consult call using dialpad
    [Tags]   456345   bvt_tp   sanity_tp     bvt_pr
    [Setup]   Testcase Setup for PSTN User     count=3
    Click on calls tab   device=device_3
    Make outgoing call using display name   from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    verify options when click on transfer btn in call UI    device=device_1
    transfer call using dial pad     from_device=device_1   to_device=device_2:pstn_user   option=consult_first
    Pick incoming call    device=device_2
    verify call state     device_list=device_3     state=Hold
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC8: [CallTransferEnhancements] blind transfer search screen > transfer using dialpad
    [Tags]   456358    P1
    [Setup]   Testcase Setup for PSTN User    count=3
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    transfer call using dial pad     from_device=device_1   to_device=device_2:pstn_user   option=transfer_now
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC9: [Busy on Busy] Verify that Busy on Busy is working for PSTN call.
    [Tags]      452077      sanity_tp
    [Setup]  Testcase Setup for PSTN User   count=4
    select the options inside when in another call option   device=device_1     option=play_a_busy_signal
    click on calls tab        device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    navigate to calls tab  device=device_2
    verify busy on busy error message while already in call  device=device_2        to_device=device_1      method=phone_number
    select the options inside when in another call option   device=device_1     option=new_calls_ring_me
    go back to previous page    device=device_1
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    Verify Call State    device_list=device_1     state=Hold
    resume the call      device=device_1
    select the options inside when in another call option   device=device_1     option=redirect_unanswered_call
    Enable unanswered call and add contact   from_device=device_1    contact_device=device_2:pstn_user
    click on calls tab  device=device_4
    Make outgoing call using display name    from_device=device_4     to_device=device_1
    Wait for Some Time    time=${wait_time2}
    Verify Incoming call    device=device_2     status=appear
    Wait for Some Time    time=${wait_time1}
    Disconnect call     device=device_4
    Enable unanswered call to voicemail      from_device=device_1     contact_device=device_4
    navigate to calls tab   device=device_4
    Make outgoing call using display name    from_device=device_4     to_device=device_1
    Wait for Some Time    time=${wait_time2}
    Disconnect call     device=device_4
    Navigate to voicemail tab    device=device_1
    Wait for Some Time    time=${wait_time}
    refresh the page    device=device_1
    verify first voicemail displayname  to_device=device_1  from_device=device_4
    go back to previous page    device=device_1
    Disable unanswered call    device=device_1      contact_device=device_4
    navigate to calls tab   device=device_4
    Make outgoing call using display name    from_device=device_4     to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    Wait for Some Time    time=${wait_time1}
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND  select the options inside when in another call option   device=device_1     option=new_calls_ring_me   AND     Disable unanswered call    device=device_1      contact_device=device_2     AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC10: [Outgoing Calls] User to auto dial, when edited the invalid number.
    [Tags]  309754    p2
    [Setup]   Testcase Setup for PSTN User    count=2
    click on calls tab    device=device_1
    Auto dial edited valid num from dial pad   from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC11: [Outgoing Calls] Auto dial PSTN number from on-hook and off -hook
    [Tags]    309741    bvt_tp         sanity_tp
    [Setup]    Testcase Setup for PSTN User   count=2
    navigate to dial pad tab from home screen    device=device_1
    auto dial with valid num from dial pad    from_device=device_1    to_device=device_2:pstn_user     method=phonenumber
    Verify Incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2   state=Disconnected
    return to home screen    device_list=device_1
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON
    verify dialpad after clicking speaker or handsethook button   device=device_1
    auto dial with valid num from dial pad    from_device=device_1    to_device=device_2:pstn_user     method=phonenumber
    Verify Incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC12 : [Call views] DUT user makes an outgoing call
    [Tags]   310030     P2  sanity_tp
    [Setup]    Testcase Setup for PSTN User   count=2
    ${prt_mode_flag}   is portrait mode cnf device  device=device_1
    pass execution if   '${prt_mode_flag}'=='False'  device_1, device is not a portrait mode device
    Select default view value     device=device_1   option=dialpad
    Validate calls tab after default value change    device=device_1      default_option=dialpad
    go back to previous page     device=device_1
    Make outgoing call using from dial pad   from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Select default view value     device=device_1     option=recent call history
    Navigate to calls tab   device=device_1
    Call first participant from log    device=device_1
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2      AND      Select default view value     device=device_1   option=speed dial

TC13 : [Call Hold] DUT holds the call with TDC and PSTN for 15 and 60 minutes
    [Tags]    306768    P1    Sanity_TP
    [Setup]    Testcase Setup for PSTN User    count=3
    Click On Calls Tab    device=device_1
    Make Outgoing Call Using Display Name    from_device=device_1    to_device=device_3
    Pick Incoming Call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=connected
    Verify Hold Resume Scenario    hold_time=15 minutes
    Wait For Some Time    time=60s
    Verify Hold Resume Scenario    hold_time=2 minutes
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    Come back to home screen    device_list=device_1
    Click on calls tab   device=device_1
    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2:pstn_user
    Pick Incoming Call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify Hold Resume Scenario    hold_time=15 minutes
    Wait For Some Time    time=60s
    Verify Hold Resume Scenario    hold_time=2 minutes
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

*** Keywords ***
Test Case Teardown
    [Arguments]     ${devices}
    Come back to home screen     ${devices}

Make outgoing call for call log
    [Arguments]     ${from_device}   ${to_device}
    Click on calls tab   device=${from_device}
    Make outgoing call using phonenumber    from_device=${from_device}      to_device=${to_device}
    Wait for Some Time    time=${wait_time}
    Verify Incoming call    device=${to_device}     status=appear
    Disconnect call     device=${from_device}
    Verify Incoming call    device=${to_device}     status=disappear
    Verify Call State    device_list=${from_device}     state=Disconnected
    return to home screen   device_list=${from_device}
    Click on calls tab   device=${from_device}
    Refresh calls main tab    device=${from_device}

Verify hold resume scenario
    [Arguments]    ${hold_time}
    Hold the call   device=device_1
    Verify Call State    device_list=device_1     state=Hold
    Wait for Some Time    time=${hold_time}
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume


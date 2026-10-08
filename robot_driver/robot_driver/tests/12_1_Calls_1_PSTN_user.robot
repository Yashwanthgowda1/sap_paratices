*** Settings ***
Resource    resources/keywords/common.robot

#Suite Setup     PSTN Setup Main
Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10
${15_minutes_wait_time} =  15 minutes
${60s_wait_time} =  60
${2_minutes_wait_time} =  2 minutes
${wait_time_20s} =     20


*** Test Cases ***
TC1 : [Call Park] Verify that PSTN user should listen to music on hold when call is parked
    [Documentation]  Devices are already signed-in in Suite Setup
    [Tags]      308603      call_park_pstn      bvt_tp   sanity_tp    bvt_pr         alt_blocked      Certification_audio
    [Setup]  Testcase Setup for PSTN User   count=2
    Click on calls tab   device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    return to home screen   device_list=device_2
    # Work around "Dismiss call park banner" before starting next call for [Bug 2143076]
    Dismiss Multiple Call Park Banner	device=device_1
    Click on calls tab   device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Wait for Some Time    time=${wait_time}
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen    device_list=device_1,device_2

TC2 : [Outgoing Calls] DUT user calls PSTN user from Dialpad
    [Tags]  308488      outgoing_calls    bvt_tp    sanity_tp       bvt_pr
    [Setup]  Testcase Setup for PSTN User    count=2
    Click on calls tab   device=device_1
    Make outgoing call using from dial pad   from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3 : [Call Transfer] DUT user blind transfers the PSTN call to TDC
    [Tags]   309820           call_transfer       bvt_pr         alt_blocked      Certification_audio
    [Setup]  Testcase Setup for PSTN User    count=3
    Click on calls tab   device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4 : [Home Screen] Verify that user should be able to dial a PSTN number using dial pad
    [Tags]  319044      P2
    [Setup]  Testcase Setup for PSTN User   count=2
    Click on calls tab   device=device_1
    make outgoing call using phonenumber  from_device=device_1   to_device=device_2:pstn_user
    verify incoming call  device=device_2   status=appear
    pick incoming call  device=device_2
    verify call state  device_list=device_1,device_2   state=connected
    disconnect call   device_1
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=2

TC5 : [Call Park] DUT user parks and retrieve a PSTN call
    [Tags]  321235   P2
    [Setup]     Testcase Setup for PSTN User    count=2
    Click on calls tab   device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Wait for Some Time    time=${2_minutes_wait_time}
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND   verify and close call park banner    device=device_1    AND    Come back to home screen   device_list=device_1,device_2

TC6 : [Call Merge] Verify an user should be able to merge PSTN call with another DUT user, another DUT's call is on hold
   [Tags]   318519     P2
   [Setup]   Testcase Setup for PSTN User    count=3
   Click on calls tab   device=device_1
   Make outgoing call using display name    from_device=device_1            to_device=device_3
   Pick incoming call    device=device_3
   verify call state   device_list=device_1,device_3   state=Connected
   Click on calls tab   device=device_2
   Make outgoing call using phonenumber    from_device=device_2            to_device=device_1
   Pick incoming call from call notification    device=device_1
   verify call state    device_list=device_1,device_2     state=Connected
   verify call state    device_list=device_3     state=hold
   Verify and merge call    device=device_1     from_device=device_3
   verify call state     device_list=device_1,device_2,device_3     state=Connected
   disconnect call       device=device_1,device_3
   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC7 : [Call Merge] Verify that DUT user is able to Merge two PSTN calls
   [Tags]   318455     P2
   [Setup]  Testcase Setup for 2 PSTN User   count=3
   Click on calls tab   device=device_1
   Make outgoing call using phonenumber    from_device=device_2            to_device=device_1
   Pick incoming call    device=device_1
   verify call state   device_list=device_1,device_2   state=Connected
   Click on calls tab   device=device_3
   Make outgoing call using phonenumber    from_device=device_3            to_device=device_1
   Pick incoming call from call notification    device=device_1
   verify call state    device_list=device_1,device_3     state=Connected
   Verify and merge call    device=device_1     from_device=device_2:pstn_user
   verify call state     device_list=device_1,device_2,device_3     state=Connected
   disconnect call       device=device_1,device_2
   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC8 : [Multiple Call Banner] DUT user can hold the muted call with the PSTN user
    [Tags]  311902    P0    bvt_tp   sanity_tp       bvt_pr
    [Setup]     Testcase Setup for PSTN User    count=2
    Click on calls tab   device=device_2
    Make outgoing call using phonenumber    from_device=device_2     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_1
    verify call mute state    device_list=device_1    state=mute
    Hold the call    device=device_1
    Verify Call State    device_list=device_1    state=Hold
    click back      device=device_1
    tap on the banner    device=device_1
    verify call state and disconnect        device=device_1,device_2
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC9 : [Multiple Call Banner] DUT user can hold the muted call with the PSTN user
    [Tags]  311911    P2
    [Setup]     Testcase Setup for PSTN User    count=2
    Click on calls tab   device=device_2
    Make outgoing call using phonenumber    from_device=device_2     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1    state=Hold
    click back      device=device_1
    tap on the banner    device=device_1
    Disconnect call      device=device_1,device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC10 : [Meet now] Verify DUT user can initiate meeting with multiple participants, PSTN user and initiated from Meet now
    [Tags]  320184    P2
    [Setup]     Testcase Setup for PSTN User    count=4
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn_user
    pick incoming call    device=device_2
    Add participant to conversation using display name   from_device=device_1      to_device=device_3,device_4
    pick incoming call    device=device_3
    pick incoming call    device=device_4
    Verify meeting state   device_list=device_1,device_2,device_3,device_4    state=Connected
    end meeting  device=device_1,device_2,device_3,device_4
    Verify meeting state   device_list=device_1,device_2,device_3,device_4    state=disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC11 : [Call Transfer] DUT user to transfer the PSTN call to another DUT user
    [Tags]   309823  sanity_tp    p1      call_transfer
    [Setup]  Testcase Setup for PSTN User    count=3
    Click on calls tab   device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1   state=Disconnected
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC12 : [Call Transfer] DUT user resume while consultative transfers the PSTN call to TDC
    [Tags]      339411   sanity_tp      p1      call_transfer
    [Setup]  Testcase Setup for PSTN User   count=3
    Click on calls tab   device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    resume the call         device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3     state=Disconnected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC13 : [Call Transfer] DUT user End the call while consultative transfers the PSTN call to TDC
    [Tags]      339412       p2      call_transfer
    [Setup]  Testcase Setup for PSTN User   count=3
    click on calls tab      device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC14 : [Call Transfer] TDC user End the call while consultative transfers the PSTN call from DUT
    [Tags]      339413       p2      call_transfer
    [Setup]    Testcase Setup for PSTN User   count=3
    click on calls tab      device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
    verify incoming call    device=device_3      status=appear
    reject incoming call    device_list=device_3
    Verify Call State    device_list=device_3     state=Disconnected
    resume call from call hold banner   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure        AND    Come back to home screen    device_list=device_1,device_2,device_3

TC15 : [Call Transfer] Call transfer icon should not be shown in call banner after rejecting the PSTN transferred call from DUT in TDC.
    [Tags]      380723       p2      call_transfer
    [Setup]    Testcase Setup for PSTN User   count=3
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
    rejects the incoming call   device_list=device_3
    Verify Call State    device_list=device_3    state=Disconnected
    verify call transfer option is disabled when first transferred call is rejected    device=device_1
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure        AND    Come back to home screen    device_list=device_1,device_2,device_3

TC16 : [E2EE] E2EE user calls to PSTN user
    [Tags]   315949   P0
    [Setup]     Testcase Setup for PSTN User    count=2
    Enable E2EE    device=device_1
    click on calls tab     device=device_1
    Make outgoing call using phonenumber   from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify E2EE icon is not displaying in call UI   device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure    AND    Disable E2EE    device=device_1     AND    Come back to home screen    device_list=device_1,device_2

TC17 :DUT user able to receive the voicemail from the PSTN user by tapping on Send to voicemail option in Incoming call UI.
    [Tags]      452932   sanity_tp           phonesCY23_4
    [Setup]     Testcase Setup for PSTN User    count=2
    click on calls tab  device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
    verify incoming call        device=device_1         status=appear
    verify and click send to voicemail option for incoming call          device=device_1
    Verify Call State    device_list=device_2    state=Connected
    Verify Call State    device_list=device_1    state=disconnected
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    Wait for Some Time    time=${wait_time}
    Navigate to voicemail tab    device=device_1
    verify first voicemail displayname  to_device=device_1  from_device=device_2:pstn_user
    Play voicemail    device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2

TC18 : DUT user able to send the voicemail by tapping Leave voicemail option in Recent tab.
    [Tags]      452880   sanity_tp  bvt_tp           phonesCY23_4       bvt_pr
    [Setup]     Testcase Setup for PSTN User    count=3
    click on calls tab  device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    pick incoming call      device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    Select call list item   device=device_1     item=leave_voicemail
    verify incoming call        device=device_3         status=disappear
    Wait for Some Time    time=${wait_time_20s}
    Verify Call State    device_list=device_1    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    Wait for Some Time    time=${wait_time}
    click back      device=device_3
    Navigate to voicemail tab    device=device_3
    verify first voicemail displayname  to_device=device_3  from_device=device_1
    Play voicemail    device=device_3
    Make outgoing call using username    from_device=device_1      to_device=device_2:pstn_user
    pick incoming call      device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Select call list item   device=device_1     item=leave_voicemail
    verify incoming call        device=device_2         status=disappear
    Wait for Some Time    time=${wait_time_20s}
    Verify Call State    device_list=device_1    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    Wait for Some Time    time=${wait_time}
    Navigate to voicemail tab    device=device_2
    verify first voicemail displayname  to_device=device_2  from_device=device_1
    Play voicemail    device=device_2
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2,device_3

TC19 : Verify that 'private line' label present after incoming call
    [Tags]      459064   sanity_tp      bvt_tp          phonesCY23_4        bvt_pr
    [Setup]  Testcase Setup for PSTN User   count=3
    click on calls tab  device=device_3
    Make outgoing call using privateline number    from_device=device_3      to_device=device_1
    verify privateline label on call screen     device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    navigate to calls tab  device=device_1
    verify privateline on recent tab  device=device_1
    come back to home screen  device_list=device_1
    click on calls tab  device=device_2
    Make outgoing call using privateline number    from_device=device_2      to_device=device_1
    verify privateline label on call screen     device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    navigate to calls tab  device=device_1
    verify privateline on recent tab  device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2,device_3

TC20 : [Incoming Calls] DUT displays the phone number of PSTN user
    [Tags]      314132
    [Setup]  Testcase Setup for PSTN User   count=2
    Click on calls tab   device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify number of caller and receiver displayed    from_device=device_1      to_device=device_2:pstn_user
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Verify home screen page     device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC21 : [HID_Call Control] Dial from Soft Key and redial from hard Key
    [Tags]      306870            Certification_audio       
    [Setup]  Testcase Setup for PSTN User   count=2
    ${redial_button}   Has Hardkey Redial Button Present  device=device_1
    pass execution if   '${redial_button}'=='False'  device_1, device is not have redial button
    click on calls tab  device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_13
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC22 : [Hard key] Verify DUT user able to hold & Resume the call using hard hold key
    [Tags]      438717           Certification_audio        sanity_tp 
    [Setup]  Testcase Setup for PSTN User   count=3
    ${call_hold_button}   has hardkey call hold button present   device=device_1
    pass execution if   '${call_hold_button}'=='False'  device_1, device is not have call hold button
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_14
    Verify Call State    device_list=device_1,device_3        state=Hold
    Wait for Some Time    time=${wait_time}
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_14
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3        state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    navigate to calls tab  device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_14
    Verify Call State    device_list=device_1        state=Hold
    Wait for Some Time    time=${wait_time}
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_14
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2        state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC23 :[Hard Keypad] Dialing digits through hard keypad should provide DTMF tone and also digit shouldn't be missed on the DUT screen
    [Tags]    308987    bvt_tp    Certification_Audio       Sanity_tp    Smoke_TP 
    [Setup]     Testcase Setup for PSTN User   count=2 
    ${dailpad_device}   Is Hard Dial Pad Present   device=device_1 
    pass execution if   '${dailpad_device}'=='False'  device_1, device is not have dailpad 
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON 
    dail phone number from hard keys   device=device_1    to_device=device_2:pstn_user 
    Pick incoming call    device=device_2 
    Wait for Some Time    time=${wait_time} 
    Verify Call State    device_list=device_1,device_2    state=Connected 
    Disconnect call     device=device_1 
    Verify Call State    device_list=device_1,device_2    state=Disconnected 
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2 

TC24 : [Call Merge] Verify an active call with another DUT user can be merged into an MoH call.
   [Tags]   318518
   [Setup]   Testcase Setup for PSTN User    count=3
   click on calls tab  device=device_2
   Make outgoing call using phonenumber    from_device=device_2            to_device=device_1
   Pick incoming call   device=device_1
   verify call state    device_list=device_1,device_2     state=Connected
   click on calls tab  device=device_3
   Make outgoing call using display name    from_device=device_3            to_device=device_1
   Pick incoming call    device=device_1
   verify call state   device_list=device_1,device_3   state=Connected
   Verify and merge call    device=device_1     from_device=device_2:pstn_user
   verify call state     device_list=device_1,device_2,device_3     state=Connected
   disconnect call       device=device_2,device_3
   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC25: [Call transfer] Verify DUT user Check Generate call summary for recipient option in the ongoing call and also verify the status of Generate call summary for recipient option when we reboot
   [Tags]   557914
   [Setup]   Testcase Setup for PSTN User    count=3
   Make outgoing call using phonenumber    from_device=device_1            to_device=device_3
   Pick incoming call   device=device_3
   click_on_call_transfer_and_enable_copilot    devices=device_1
   verify_options_inside_ai_contents_refresh    devices=device_1
   disconnect call       device=device_3
   Make outgoing call using phonenumber    from_device=device_3            to_device=device_1
   Pick incoming call   device=device_1
   Blindtransfers the call    from_device=device_1      to_device=device_2:pstn_user      method=phone_number     ai_summery_copilot=on
   Pick incoming call   device=device_2
   Verify Call State     device_list=device_1     state=Disconnected
   disconnect call       device=device_3
   Verify Call State     device_list=device_3,device_2     state=Disconnected
   Make outgoing call using phonenumber    from_device=device_1          to_device=device_2:pstn_user
   Pick incoming call   device=device_2
   click on call transfer and enable copilot    devices=device_1
   verify options inside ai contents refresh    devices=device_1
   disconnect call       device=device_1
   Come back to home screen    device_list=device_1,device_2,device_3
   Make outgoing call using phonenumber    from_device=device_2:pstn_user            to_device=device_1
   Pick incoming call   device=device_1
   Blindtransfers the call    from_device=device_2:pstn_user       to_device=device_3      method=phone_number     ai_summery_copilot=on
   Pick incoming call   device=device_3
   Verify Call State     device_list=device_2     state=Disconnected
   Verify Call State     device_list=device_3,device_1     state=connected
   disconnect call       device=device_3
   Verify Call State     device_list=device_3,device_2,device_1     state=Disconnected
   Make outgoing call using phonenumber    from_device=device_1            to_device=device_3
   Pick incoming call   device=device_3
   click on call transfer and enable copilot    devices=device_1
   verify options inside ai contents refresh    devices=device_1
   disconnect call       device=device_3
   Reboot Phones    device=device_1
   Wait For Some Time  time=5 minutes
   Make outgoing call using phonenumber    from_device=device_3            to_device=device_1
   Pick incoming call   device=device_1
   Blindtransfers the call    from_device=device_1      to_device=device_2:pstn_user      method=phone_number     ai_summery_copilot=on
   Pick incoming call   device=device_2
   Verify Call State     device_list=device_1     state=Disconnected
   disconnect call       device=device_3
   Verify Call State     device_list=device_3,device_2     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC26: [Call transfer] Verify DUT user should retain Generate call summary for recipient in unchecked state after checking and re-sign in with the same account.
   [Tags]   Ai_summery_3
   [Setup]   Testcase Setup for PSTN User    count=3
   Make outgoing call using phonenumber    from_device=device_1            to_device=device_3
   Pick incoming call   device=device_3
   click on call transfer and enable copilot    devices=device_1
   verify options inside ai contents refresh    devices=device_1
   disconnect call       device=device_3
   Sign out method    device_1
   Wait for Some Time    time=15s
   Sign in method     device_1
   Make outgoing call using phonenumber    from_device=device_3            to_device=device_1
   Pick incoming call   device=device_1
   click on call transfer and enable copilot    devices=device_1    verify=on
   device setting back     device=device_1
   disconnect call       device=device_3
   Verify Call State     device_list=device_3,device_2,device_1     state=Disconnected
   Make outgoing call using phonenumber    from_device=device_1          to_device=device_2:pstn_user
   Pick incoming call   device=device_2
   click on call transfer and enable copilot    devices=device_1
   verify options inside ai contents refresh    devices=device_1
   device setting back     device=device_1
   disconnect call       device=device_1
   Sign out method    device_1
   Wait for Some Time    time=15s
   Sign in method     device_1
   Make outgoing call using phonenumber    from_device=device_2:pstn_user            to_device=device_1
   Pick incoming call   device=device_1
   click on call transfer and enable copilot    devices=device_1    verify=on
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC27: [Call transfer] Verify DUT should display Transferred Call Summary under Call summary option inside the More (...)after receiving the blind transferred PSTN call.
   [Tags]   557919
   [Setup]   Testcase Setup for PSTN User    count=3
   Make outgoing call using phonenumber    from_device=device_2:pstn_user    to_device=device_1
   Pick Incoming Call    device=device_1
   Verify Call State    device_list=device_1,device_2    state=Connected
   click on call transfer and enable copilot    devices=device_1
   verify options inside ai contents refresh    devices=device_1
   device setting back     device=device_1
   Blindtransfers The Call Using Display Name    from_device=device_1    to_device=device_3
   verify_rtt_banner_option_inside_call_page   device=device_3
   Pick Incoming Call    device=device_3
   Verify Call State    device_list=device_3,device_2    state=Connected
   Verify Call State    device_list=device_1   state=disConnected
   verify_option_after_transfer_the_ai_summary_call        device=device_3
   Disconnect Call    device=device_2
   Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC28: [Call transfer] Verify DUT should display Transferred Call Summary under Call summary option inside the More (...)after receiving the Consult transferred PSTN call.
    [Tags]    557918
    [Setup]    Testcase Setup for PSTN User   count=3
    Make outgoing call using phonenumber    from_device=device_2:pstn_user    to_device=device_1
    Pick Incoming Call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    click on call transfer and enable copilot    devices=device_1
    verify options inside ai contents refresh    devices=device_1
    device setting back     device=device_1
    Consult first to transfer the call using display name    from_device=device_1    to_device=device_3
    Pick Incoming Call    device=device_3
    click transfer button when using ai summery enable      device=device_1
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify Call State    device_list=device_1   state=disConnected
    verify option after transfer the ai summary call        device=device_3
    Disconnect Call    device=device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords   Capture on Failure  AND   Come back to home screen   device_list=device_1,device_2,device_3

TC29 : [Call transfer] Verify Generate copilot summary for recipient with check box is present inside the Transfer button for ongoing call and DUT should generate the call summary
   [Tags]   557912      bvt_tp      sanity_tp
   [Setup]   Testcase Setup for PSTN User    count=3
   Make outgoing call using phonenumber    from_device=device_3            to_device=device_1
   Pick incoming call   device=device_1
   click on call transfer and enable copilot    devices=device_1
   verify options inside ai contents refresh    devices=device_1
   disconnect call       device=device_3
   Make outgoing call using phonenumber    from_device=device_2:pstn_user            to_device=device_1
   Pick incoming call   device=device_1
   click on call transfer and enable copilot    devices=device_1
   verify options inside ai contents refresh    devices=device_1
   disconnect call       device=device_2
   Verify Call State     device_list=device_3,device_2,device_1     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2


*** Keywords ***
Enable E2EE
    [Arguments]     ${device}
    enable E2EE option inside calling option      ${device}
    come back to home screen    ${device}

Disable E2EE
    [Arguments]     ${device}
    disable E2EE option inside calling option     ${device}

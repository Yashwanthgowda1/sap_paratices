*** Settings ***
Documentation  Here we are validating the stress scenerio's of teams phones
...  The goal is ensure that all the feature related to teams app should work properly with mutiple iteration run.
Resource    ../resources/keywords/common.robot


Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =   10
${wait_time_2s} =   2
${wait_time_6s} =   6
${iteration} =   30

*** Test Cases ***
TC1: Call from call logs
    [Tags]    tp_stress        exclude_ftp        tp_stress_1      485106
    [Setup]    run keywords   Testcase Setup    count=2    AND    Make outgoing call for call log   from_device=device_1     to_device=device_2
    call from call logs
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen     device_list=device_1,device_2

TC2: Call from favorites page
    [Tags]    tp_stress        exclude_ftp        tp_stress_2        485108
    [Setup]    run keywords   Testcase Setup    count=2        AND     Setup for make out going call from favorites page           from_device=device_1     to_device=device_2     
    Call from favorites page
    [Teardown]   Run Keywords    Capture on Failure  AND     Teardown for out going call from favorites page       AND     Capture on Failure  

TC3: Call hold, call mute and call merge
    [Tags]    tp_stress        exclude_ftp        tp_stress_3     485099
    [Setup]    run keywords   Testcase Setup    count=3        AND      Setup for Call hold, call mute and call merge
    Call hold, call mute and call merge
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen     device_list=device_1,device_2,device_3

TC4: Navigation scenarios
    [Tags]    tp_stress        exclude_ftp         tp_stress_4      485159
    [Setup]    Testcase Setup    count=1    
    Navigation scenarios
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen     device_list=device_1

TC5: initiate simultaneous incoming call
    [Tags]    tp_stress        exclude_ftp         tp_stress_5      485161
    [Setup]    run keywords   Testcase Setup    count=3        AND      Setup for Call hold, call mute and call merge
    initiate simultaneous incoming call
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen     device_list=device_1,device_2,device_3

TC6: Call transfer
    [Tags]    tp_stress        exclude_ftp         tp_stress_6      488047
    [Setup]    run keywords   Testcase Setup    count=3        AND      Setup for Call transfer
    Call transfer
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen     device_list=device_1,device_2,device_3

TC7 : DUT user in P2P call with TDC, adds another DUT user
    [Tags]    tp_stress       tp_stress_7        exclude_ftp      485151
    [Setup]    run keywords   Testcase Setup    count=3        AND      Setup escalate to confrence call      from_device=device_1     to_device=device_2
    DUT user in P2P call with TDC adds another DUT user
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen     device_list=device_1,device_2,device_3

TC8: verify the meet now options
    [Tags]    tp_stress     exclude_ftp   tp_stress_8      485155
    [Setup]    run keywords   Testcase Setup    count=2     AND     Setup user for meeting now      from_device=device_1    to_device=device_2
    verify the meet now options
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen     device_list=device_1,device_2

TC9 : verify the calender meeting
    [Tags]    tp_stress     exclude_ftp   tp_stress_9      485156
    [Setup]    run keywords   Testcase Setup    count=2     AND     Meeting Setup    from_device=device_1    to_device=device_2
    verify the calender meeting
    [Teardown]   Run Keywords    Capture on Failure     AND    Meeting clear history   AND     Come back to home screen     device_list=device_1,device_2

TC10 : Call from Dial pad
    [Tags]    tp_stress    exclude_ftp    tp_stress_10      485160
    [Setup]    run keywords    Testcase Setup    count=3    AND    Navigate To Calls Tab    device=device_1
    Call From Dial Pad
    [Teardown]    Run Keywords    Capture On Failure    AND    Come back to home screen    device_list=device_1,device_3

TC11 : Call from Dial pad
    [Tags]    tp_stress    exclude_ftp    tp_stress_11      451541
    [Setup]   Testcase Setup for PSTN User   count=2
    navigate to calls tab    device=device_1
    Call from dial pad to pstn user
    [Teardown]    Run Keywords    Capture On Failure    AND    Come back to home screen    device_list=device_1,device_2

# TC1: Sign_in
#  [Tags]    tp_stress        exclude_ftp        tp_stress_1
#     [Setup]  Testcase Setup    count=1
#     sign-in multiple times with same user
#     [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

*** Keywords ***
sign-in multiple times with same user
    FOR   ${INDEX}   IN RANGE    0   ${iteration}
        Log   ${INDEX}
        Sign out method    device_1
        Wait for Some Time    time=${wait_time}
        Sign in method     device_1
    END

Call from call logs
    FOR  ${INDEX}   IN RANGE   0    ${iteration}
        Log   ${INDEX}
        call from call logs in recent tab       device=device_1
        Pick incoming call    device=device_2
        Wait for Some Time    time=${wait_time}
        Verify Call State    device_list=device_1,device_2    state=Connected
        Disconnect call     device=device_1
        Verify Call State    device_list=device_1,device_2    state=Disconnected
    END

Call from favorites page
    FOR  ${INDEX}   IN RANGE   0    ${iteration}
        Log   ${INDEX}
        click on user name in favorites page      from_device=device_1      to_device=device_2
        Pick incoming call    device=device_2
        Wait for Some Time    time=${wait_time}
        Verify Call State    device_list=device_1,device_2    state=Connected
        Disconnect call     device=device_1
        Verify Call State    device_list=device_1,device_2    state=Disconnected
    END

Call hold, call mute and call merge
    FOR  ${INDEX}   IN RANGE   0    ${iteration}
        Log   ${INDEX}
        Place a call from search results page   from_device=device_2      to_device=device_1
        Pick incoming call    device=device_1
        Wait for Some Time    time=${wait_time_6s}
        Verify Call State    device_list=device_1,device_2    state=Connected
        Hold the call   device=device_1
        Verify Call State    device_list=device_1    state=Hold
        Resume the call   device=device_1
        Verify Call State    device_list=device_1,device_2     state=Resume
        Unmutes the phone call  device=device_1
        Verify meeting Mute State    device_list=device_1    state=Unmute
        mutes the phone call  device=device_1
        Verify meeting Mute State    device_list=device_1    state=mute
        Place a call from search results page   from_device=device_3      to_device=device_1
        Pick incoming call from call notification    device=device_1
        Wait for Some Time          time=${wait_time_6s}
        verify call state      device_list=device_1,device_3      state=Connected
        verify call state      device_list=device_2       state=hold
        Verify and merge call      device=device_1     from_device=device_2
        Wait for Some Time     time=${wait_time_6s}
        verify call state       device_list=device_1,device_2,device_3         state=Connected
        disconnect call       device=device_3,device_2
        Verify Call State     device_list=device_1,device_2,device_3      state=Disconnected
    END

Navigation scenarios
    FOR  ${INDEX}   IN RANGE   0    ${iteration}
        Log   ${INDEX}
        navigate to calls tab    device=device_1
        wait for some time   time=${wait_time_2s}
        navigate to calls favorites page    device=device_1
        wait for some time   time=${wait_time_2s}
        come back to home screen page and verify    device=device_1
        navigate to people tab   device=device_1
        wait for some time   time=${wait_time_2s}
        come back to home screen page and verify    device=device_1
        navigate to voicemail tab    device=device_1
        wait for some time   time=${wait_time_2s}
        come back to home screen page and verify    device=device_1
        navigate to calendar tab    device=device_1
        Wait for Some Time    time=${wait_time_2s}
        come back to home screen page and verify    device=device_1
        Wait for Some Time    time=${wait_time_2s}
        navigate to walkie talkie tab  device=device_1
        come back to home screen page and verify    device=device_1
        Wait for Some Time    time=${wait_time_2s}
    END

initiate simultaneous incoming call
    FOR  ${INDEX}   IN RANGE   0    ${iteration}
        Log   ${INDEX}
        initiate simultaneous call from search results page  devices=device_2,device_3   target_device=device_1
        verify multiple incoming calls  device=device_1
        accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept    count=3
        verify call state and disconnect        device=device_2,device_3,device_1
        initiate simultaneous call from search results page  devices=device_2,device_3   target_device=device_1
        verify multiple incoming calls  device=device_1
        accept multiple incoming calls  device=device_1   full_screen_call=reject    notification_call=accept
        verify call state and disconnect        device=device_2,device_3,device_1
        initiate simultaneous call from search results page  devices=device_2,device_3   target_device=device_1
        verify multiple incoming calls  device=device_1
        accept multiple incoming calls   device=device_1    full_screen_call=accept     notification_call=reject       count=3
        verify call state and disconnect        device=device_2,device_3,device_1
    END

Call transfer
    FOR  ${INDEX}   IN RANGE   0    ${iteration}
        Log   ${INDEX}
        Place a call from search results page   from_device=device_2      to_device=device_1
        Pick incoming call    device=device_1
        Verify Call State    device_list=device_1,device_2    state=Connected
        Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
        Pick incoming call    device=device_3
        Verify Call State    device_list=device_3,device_1    state=Connected
        Verify Call State    device_list=device_2    state=Hold
        Completes the consultation to accept the call     from_device=device_1      to_device=device_2
        Verify Call State    device_list=device_3,device_2    state=Connected
        Disconnect call     device=device_2
        Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
        Place a call from search results page   from_device=device_2      to_device=device_1
        Pick incoming call    device=device_1
        Verify Call State    device_list=device_1,device_2    state=Connected
        Blindtransfers the call using display name  from_device=device_1      to_device=device_3
        Pick incoming call    device=device_3
        Verify Call State    device_list=device_3,device_2    state=Connected
        Disconnect call     device=device_2
        Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    END

DUT user in P2P call with TDC adds another DUT user
    FOR  ${INDEX}   IN RANGE   0    ${iteration}
        Log   ${INDEX}
        verify contact card page and call      device=device_1
        Pick incoming call    device=device_2
        Wait for Some Time    time=${wait_time}
        Verify Call State    device_list=device_1,device_2    state=Connected
        Add participant to conversation using display name   from_device=device_1      to_device=device_3
        Pick incoming call    device=device_3
        Wait for Some Time    time=${wait_time}
        Verify Call State    device_list=device_1,device_2,device_3    state=Connected
        verify participant list     from_device=device_1      connected_device_list=device_1,device_2,device_3
        Disconnect call     device=device_2
        Verify Call State    device_list=device_2     state=Disconnected
        Verify Call State    device_list=device_1,device_3     state=Connected
        verify participant list     from_device=device_1      connected_device_list=device_1,device_3
        Disconnect call     device=device_1
        Verify Call State    device_list=device_1,device_3     state=Disconnected
        Wait for Some Time    time=${wait_time}
    END

verify the meet now options
    FOR  ${INDEX}   IN RANGE   0    ${iteration}
        Log   ${INDEX}
        Initiated a conference call from Meet now    device=device_1
        Verify meeting state   device_list=device_1    state=Connected
        Add participant to conversation using display name   from_device=device_1      to_device=device_2
        pick incoming call    device=device_2
        Verify meeting state   device_list=device_1,device_2    state=Connected
        verify lightweight meeting ui    device=device_1     participants=device_2
        verify presence of reactions button in call control     device=device_1
        Raise hand     device=device_1
        Verify raise hand    from_device=device_1  to_device=device_2    status=on
        lower hand      device=device_1
        Verify raise hand    from_device=device_1  to_device=device_2    status=off
        Mutes the meeting     device=device_1
        Verify meeting Mute State    device_list=device_1    state=mute
        Unmutes the meeting    device=device_1
        Verify meeting Mute State    device_list=device_1    state=unmute
        Remove user from meeting    from_device=device_1      to_device=device_2
        click back btn  device=device_1
        Verify meeting state    device_list=device_2    state=Disconnected
        Verify meeting state   device_list=device_1     state=Connected
        end meeting  device=device_1
        Verify meeting state   device_list=device_1    state=disconnected
        Tap on Meet Now icon and validate       device=device_1
    END

verify the calender meeting
    FOR  ${INDEX}   IN RANGE   0    ${iteration}
        Log   ${INDEX}
        Join Meeting    device=device_1,device_2    meeting=stress_testing
        Wait for Some Time    time=${wait_time}
        Verify meeting state   device_list=device_1,device_2    state=Connected
        Verify Lightweight Meeting Ui    device=device_1     participants=device_2
        verify presence of reactions button in call control     device=device_1
        Raise hand     device=device_1
        Verify raise hand    from_device=device_1  to_device=device_2    status=on
        lower hand      device=device_1
        Verify raise hand    from_device=device_1  to_device=device_2    status=off
        Mutes the meeting     device=device_1
        Verify meeting Mute State    device_list=device_1    state=mute
        Unmutes the meeting    device=device_1
        Verify meeting Mute State    device_list=device_1    state=Unmute
        Verify meeting state   device_list=device_1,device_2    state=Connected
        End meeting     device=device_1,device_2
        Verify Call State    device_list=device_1,device_2    state=Disconnected
    END

Call from dial pad
    FOR    ${INDEX}    IN RANGE    0    ${iteration}
        Log    ${INDEX}
        Auto Dial With Valid Num From Dial Pad    from_device=device_1    to_device=device_3
        Verify Incoming Call    device=device_3    status=appear
        Pick incoming call    device=device_3
        Wait for Some Time    time=${wait_time}
        Verify Call State    device_list=device_1,device_3    state=Connected
        verify call state and disconnect        device=device_1,device_3
    END

Call from dial pad to pstn user
    FOR    ${INDEX}    IN RANGE    0    ${iteration}
        Log    ${INDEX}
        Auto Dial With Valid Num From Dial Pad    from_device=device_1    to_device=device_2:pstn_user 
        Verify Incoming Call    device=device_2    status=appear
        Pick incoming call    device=device_2
        Verify Call State    device_list=device_1,device_2    state=Connected
        verify call state and disconnect        device=device_1,device_2
    END
    
Make outgoing call for call log
    [Arguments]     ${from_device}   ${to_device}
    Navigate to calls tab   device=${from_device}
    Make outgoing call using display name    from_device=${from_device}      to_device=${to_device}
    Verify Incoming call    device=${to_device}     status=appear
    Disconnect call     device=${from_device}
    Verify Incoming call    device=${to_device}     status=disappear
    Verify Call State    device_list=${from_device}     state=Disconnected
    return to home screen  device_list=${from_device}
    click on calls tab   device=${from_device}
    Refresh calls main tab    device=${from_device}

Setup for make out going call from favorites page
    [Arguments]     ${from_device}   ${to_device}             
    Select call list item   device=${from_device}  item=favorite       
    Verify added favorite user in favorites page    from_device=${from_device}     to_device=${to_device}

Teardown for out going call from favorites page              
    remove favorite contacts from favorites tab  device=device_1
    Come back to home screen     device_list=device_1,device_2

Setup for Call hold, call mute and call merge
    Click On Calls Tab  device=device_2
    Click On Calls Tab   device=device_3
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    verify call state and disconnect        device=device_2
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    verify call state and disconnect        device=device_3

Setup for Call transfer
    Click On Calls Tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    verify call state and disconnect        device=device_2

Meeting Setup
    [Arguments]     ${from_device}   ${to_device}
    clear all day meeting and meeting history from calendar   devices=${from_device},${to_device}
    create meeting      device=${from_device}    meeting=stress_testing    participants=${to_device}     meeting_time=on      meeting_duration=60
    create meeting      device=${from_device}    meeting=stress_testing    participants=${to_device}     meeting_time=on      meeting_duration=60       consecutive_meeting=on
    verify meeting has meeting name     device=${from_device}     meeting=stress_testing

Meeting clear history
    clear all day meeting and meeting history from calendar   devices=device_1,device_2

Setup escalate to confrence call
    [Arguments]     ${from_device}   ${to_device}
    Click On Calls Tab  device=${from_device}
    Make outgoing call using display name    from_device=${from_device}     to_device=${to_device}
    verify call state and disconnect        device=${from_device}

Setup user for meeting now
    [Arguments]     ${from_device}      ${to_device}
    Navigate to Calendar tab    device=${from_device}
    Tap on Meet Now icon and validate       device=${from_device}

*** Settings ***
Documentation  Here we are validating the stress scenerio's of teams rooms on shared mode
...  The goal is ensure that all the feature related to teams app should work properly with mutiple iteration run.
Resource    ../../resources/keywords/common.robot
Library    Collections
Library    random
*** Variables ***
${wait_time} =      2s
${iteration}=   30
${stress_iteration}=   4
${10_sec_wait_time} =  10s
&{TYPE_MAPPING}       volume_control=adjust_volume    mic_control=mute_and_unmute_local_mic    live_caption_control=live_caption_on_and_off    video_control=local_video_on_and_off    emoji_control=emoji_reaction    change_layout_and_pin=pin_participants_change_layout    tdc_chat_panel_on=tdc_Sending_Chat_with_chat_panel_on
#white_board=white_board_sharing

*** Test Cases ***
TC1: Verify DUT user and other participants can joins the same meeting multiple times without any failure
    [Tags]    stress_sm
    [Setup]  Testcase Setup for Meeting User    count=3
    Verify DUT user join teams room meeting with participants      device=device_1      meeting=cnf_device_meeting
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2: Verify DUT user can turn off/on the video icon mutiple times during the meeeting.
    [Tags]    stress_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Get screenshot     name=verify_particpants_preview   device_list=device_1,device_2
    DUT user turn off/on video icon mutiple times   device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen     device_list=device_1,device_2

TC3: Verify DUT user can mute/unmute itself multiple times while in a meeting.
    [Tags]    stress_sm
    [Setup]  Testcase Setup for Meeting User      count=2
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify DUT user mute and unmute in a meeting   device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2

#Feature change: Video call UI has changed to meeting UI, so, hold option is removed
#TC4: Verify DUT user can hold/resume and mute/unmute the TDC user video call multiple times.
#    [Tags]    stress_sm
#    [Setup]  Testcase Setup for Meeting User     count=2
#    Make Video call using display name  from_device=device_2     to_device=device_1:meeting_user
#    Accept incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify DUT user hold and resume & mute and unmute the call multiple times  device=device_1
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2

TC4: Verify DUT user can mute/unmute participants multiple times during a meeting.
    [Tags]    stress_sm
    [Setup]  Testcase Setup for Meeting User      count=3
    Join meeting    device=device_1,device_2,device_3    meeting=cnf_device_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
    Verify participants list in meeting    device=device_1
    Verify DUT user mute other participants while in a meeting     device=device_1
    End meeting   device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2,device_3

TC5: Verify DUT user can make video call to TDC and turn off/on the video icon mutiple times.
    [Tags]    stress_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    Make Video call using display name  from_device=device_1     to_device=device_2
    Accept incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Get screenshot     name=verify_particpants_preview   device_list=device_1,device_2
    DUT user turn off/on video icon mutiple times     device=device_1
    End meeting   device=device_1,device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2

TC6: Verify DUT user can hold/resume and mute/unmute outgoing voice call to TDC multiple times without any failure.
    [Tags]    stress_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    Verify DUT user make an outgoing voice call to TDC user multiple times     from_device=device_1     to_device=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2

TC7: Verify DUT user can increase/decrease the volume in a meeting.
    [Tags]    stress_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    Join meeting    device=device_1,device_2   meeting=cnf_device_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2   state=Connected
    Verify participants list in meeting    device=device_1
    Verify Increase/decrease volume button    device=device_1
    End meeting   device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2

TC8: Verify DUT user can dial the number from 0_to_9 without any failure.
    [Tags]    stress_sm     0_9
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify DUT user can dial the number from 0_to_9    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1

TC9: Verify the DUT user can turn off/on incoming video mutiple times and check for the self preview display properly on the screen.
    [Tags]    stress_sm
    [Setup]  Testcase Setup for Meeting User    count=3
    Join meeting    device=device_1,device_2,device_3    meeting=cnf_device_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
    Verify participants list in meeting    device=device_1
    Verify DUT user can turn off and on incoming video    device=device_1
    End meeting   device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2,device_3

TC10: Verify DUT user can enable/disabled raise hand in the meeting.
    [Tags]    stress_sm
    [Setup]  Testcase Setup for Meeting User    count=2
    DUT user can enable and disable raise hand in a meeting    device=device_1      meeting=cnf_device_meeting
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2

TC11:Verify meeting last 1 hour and do random action
    [Documentation]  Verify meeting UI [mute control,Layout,Chat,live caption Etc..]
    [Tags]    stress_sm    123
    [Setup]  Testcase Setup for Meeting User    count=3
    create new whiteboard meeting
    initiate web driver in setup for non pro user
    Join TDC meeting        device=tdc_1:non_pro_user      edit_meeting_name=whiteboard_sharing_meeting
    Wait for Some Time    time=${wait_time}
    Join meeting   device=device_1,device_2,device_3        meeting=whiteboard_sharing_meeting
    Verify multiple actions in meeting
    Disconnect the call on TDC      device=tdc_1:non_pro_user
    End meeting                   device=device_1,device_2,device_3
    Verify meeting state          device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2,device_3
*** Keywords ***
Verify DUT user join teams room meeting with participants
    [Arguments]       ${device}     ${meeting}
    FOR   ${INDEX}   IN RANGE    0   ${iteration}
        Log   ${INDEX}
        Join meeting    device=device_1,device_2,device_3    meeting=${meeting}
        Wait for Some Time    time=${wait_time}
        Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
        Verify participants list in meeting    device=${device}
        End meeting   device=device_1,device_2,device_3
        Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
        Come back to home screen   device_list=device_1,device_2,device_3
    END

DUT user turn off/on video icon mutiple times
    [Arguments]      ${device}
    FOR  ${INDEX}   IN RANGE   0    ${iteration}
        Log   ${INDEX}
        Disable video call   device=${device}
        Get screenshot       name=verify_self_preview_after_disable_video   device_list=${device}
        Enable video call    device=${device}
        Get screenshot       name=verify_self_preview_after_enable_video   device_list=${device}
    END

Verify DUT user mute and unmute in a meeting
    [Arguments]      ${device}
    FOR  ${INDEX}   IN RANGE   0   ${iteration}
        Log   ${INDEX}
        Mutes the phone call    device=${device}
        Verify meeting Mute State   device_list=${device}    state=mute
        Unmutes the phone call   device=${device}
        Verify meeting Mute State    device_list=${device}    state=unmute
    END

Verify DUT user hold and resume & mute and unmute the call multiple times
    [Arguments]      ${device}
    FOR  ${INDEX}   IN RANGE   0   ${iteration}
         Log   ${INDEX}
         Hold the call   device=${device}
         Verify Call State    device_list=device_1,device_2     state=Hold
         Resume the call   device=${device}
         Verify Call State    device_list=device_1,device_2     state=Resume
         Mutes the phone call    device=${device}
         Verify meeting Mute State   device_list=${device}    state=mute
         Unmutes the phone call   device=${device}
         Verify meeting Mute State    device_list=${device}    state=unmute
    END

Verify DUT user mute other participants while in a meeting
    [Arguments]      ${device}
    FOR  ${INDEX}   IN RANGE   0    ${iteration}
        Log   ${INDEX}
        Mute all participants    device=${device}
        Unmutes the phone call   device=device_2
    END

Verify DUT user make an outgoing voice call to TDC user multiple times
    [Arguments]     ${from_device}      ${to_device}
    FOR  ${INDEX}   IN RANGE   0    ${iteration}
        Log   ${INDEX}
        Make outgoing call with phonenumber    from_device=${from_device}     to_device=${to_device}
        Accept incoming call      device=${to_device}
        Wait for Some Time    time=${wait_time}
        Verify Call State    device_list=${from_device}   state=Connected
        Hold the call   device=${from_device}
        Verify Call State    device_list=device_1,device_2     state=Hold
        Resume the call   device=${from_device}
        Verify Call State    device_list=device_1,device_2     state=Resume
        Mutes the phone call    device=${from_device}
        Verify meeting Mute State   device_list=${from_device}   state=mute
        Unmutes the phone call   device=${from_device}
        Verify meeting Mute State    device_list=${from_device}    state=unmute
        Disconnect call     device=${to_device}
        Verify Call State    device_list=${from_device}      state=Disconnected
    END

Verify Increase/decrease volume button
     [Arguments]       ${device}
     FOR  ${INDEX}   IN RANGE   0    ${iteration}
        Adjust volume button   ${device}    state=UP     functionality=In_meeting
        Adjust volume button   ${device}    state=Down   functionality=In_meeting
     END

Verify DUT user make outgoing call using auto dial
    [Arguments]     ${from_device}     ${to_device}
    FOR  ${INDEX}   IN RANGE   0    ${iteration}
        Log   ${INDEX}
        Place a call    ${from_device}     ${to_device}    method=phone_number    dial_mode=auto_dial
        Accept incoming call      device=${to_device}
        Wait for Some Time    time=${wait_time}
        Verify Call State    device_list=${from_device}   state=Connected
        Disconnect call     device=${to_device}
        Verify Call State    device_list=${from_device}      state=Disconnected
    END

Verify DUT user can dial the number from 0_to_9
     [Arguments]        ${device}
     FOR  ${INDEX}   IN RANGE   0    ${iteration}
        Log   ${INDEX}
        Dial and verify the numbers from 0 to 9    device_list=${device}
#        Close dial pad screen       ${device}
     END

DUT user can enable and disable raise hand in a meeting
    [Arguments]       ${device}     ${meeting}
    FOR   ${INDEX}   IN RANGE    0   ${iteration}
        Log   ${INDEX}
        Join meeting    device=device_1,device_2    meeting=${meeting}
        Wait for Some Time    time=${wait_time}
        Verify meeting state   device_list=device_1,device_2   state=Connected
        Check video call On state   device_list=device_1,device_2
        Select raise hand option   ${device}
        Verify raise hand notification   device_list=device_2
        Select Lower hand option    ${device}
        End meeting   device=device_1,device_2
        Verify meeting state    device_list=device_1,device_2   state=Disconnected
    END

Verify DUT user can turn off and on incoming video
    [Arguments]       ${device}
    FOR   ${INDEX}   IN RANGE    0   ${iteration}
        Log   ${INDEX}
        Turn off incoming call   device_list=${device}
        Get screenshot    name=verify_self_preview_after_turn_off_incoming_video   device_list=device_1,device_2,device_3
        Turn on incoming call    device_list=${device}
        Get screenshot   name=verify_self_preview_after_turn_on_incoming_video   device_list=device_1,device_2,device_3
    END

Verify multiple actions in meeting
        adjust_volume
        verify call connected state
        mute_and_unmute_local_mic
        verify call connected state
        live_caption_on_and_off
        verify call connected state
        local_video_on_and_off
        verify call connected state
        emoji_reaction
        verify call connected state
        pin_participants_change_layout
        verify call connected state
        tdc_Sending_Chat_with_chat_panel_on
        verify call connected state
        #white_board_sharing
        Make A Pin And Unpin       from_device=device_1  to_device=device_3    action=unpin
        FOR   ${INDEX}   IN RANGE    0   ${stress_iteration}
            Log   ${INDEX}
            validating random scenario        ${TYPE_MAPPING}
        END

verify call connected state
     Wait for Some Time    time=${5_sec_wait_time}
     Verify meeting state   device_list=device_1,device_2,device_3   state=Connected

Join TDC meeting
    [Arguments]    ${device}    ${edit_meeting_name}
    right click on created meeting from tdc     device=${device}       edit_meeting_name=${edit_meeting_name}      click=left
    join_the_meeting_in_TDC     device=${device}

create new whiteboard meeting
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user
    delete all meetings from tdc        device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=whiteboard_sharing_meeting     participants=device_1:meeting_user,tdc_1:non_pro_user,device_3       time_duration=10 hr        use_current_time=True
    close web driver        tdc_1

initiate web driver in setup for non pro user
    initiate web driver     tdc_1
    perform web signin method     tdc_1:non_pro_user
    remove canceled meeting    device=tdc_1    meeting_name=Canceled: whiteboard_sharing_meeting

validating random scenario
    [Arguments]    ${type_mapping}
    ${shuffled_keys}    Shuffle Keys From Dictionary    ${type_mapping}
    FOR    ${random_key}    IN    @{shuffled_keys}
        ${kw_name}    Map Type To Keyword Name    ${random_key}
        Run Keyword And Continue On Failure    ${kw_name}
        verify call connected state 10 sec wait time
    END

Shuffle Keys From Dictionary
    [Arguments]    ${dict}
    ${keys}    Get Dictionary Keys    ${dict}
    ${shuffled_keys}    Evaluate    random.shuffle(${keys})    # Shuffle the keys list
    Return From Keyword    ${keys}

Map Type To Keyword Name
    [Arguments]    ${type}
    ${result}    ${value}    Run Keyword And Ignore Error    Get From Dictionary    ${TYPE_MAPPING}    ${type.lower()}
    Run Keyword If    '${result}' == 'FAIL'    Fail    msg=Was not able to map type "${type}" to keyword name
    Return From Keyword    ${value}

adjust_volume
    Adjust volume button   device=device_1      state=UP         functionality=In_meeting
    Adjust volume button   device=device_1      state=Down       functionality=In_meeting

mute_and_unmute_local_mic
    Mutes the phone call        device=device_1
    Verify meeting Mute State   device_list=device_1    state=mute
    Unmutes the phone call      device=device_1
    Verify meeting Mute State   device_list=device_1      state=unmute

local_video_on_and_off
     verify video call state     device_list=device_1      state=ON
     Disable video call          device=device_1
     Enable video call           device=device_1
     verify video call state     device_list=device_1      state=off

live_caption_on_and_off
    Turn on live captions and validate   device=device_1
    Turn off live captions and validate  device=device_1

emoji_reaction
    Click like button     device=device_1
    Verify reaction button on screen after tap on it   device=device_2
    Tap on laugh button     device=device_1
    Verify reaction button on screen after tap on it        device=device_2
    Tap on clap button     device=device_1
    Verify reaction button on screen after tap on it       device=device_2
    Tap on heart button     device=device_1
    Verify reaction button on screen after tap on it   device=device_2
    Select raise hand option  device=device_1
    Verify raise hand notification   device_list=device_2
    Select Lower hand option  device=device_1

pin_participants_change_layout
    Make A Pin And Unpin       from_device=device_1  to_device=device_3    action=pin
    Close participants screen   device=device_1
    verify pin icon      device=device_1
    change meeting mode     device=device_1     mode=together
    verify changed mode    device=device_1      changed_mode=together_mode
    verify pin icon      device=device_1
    verify together mode participant list  from_device=device_1    connected_device_list=device_2
    change meeting mode     device=device_1     mode=large_gallery
    verify changed mode  device=device_1      changed_mode=large_gallery
    verify pin icon      device=device_1
    change meeting mode     device=device_1     mode=gallery
    verify pin icon      device=device_1
    verify together mode participant list  from_device=device_1    connected_device_list=device_2
    change meeting mode     device=device_1     mode=front_row
    verify front row participant  from_device=device_1    connected_device_list=device_2
    verify pin icon      device=device_1
    Verify front row mode   device=device_1
    change meeting mode     device=device_1     mode=gallery

verify together mode participant list
    [Arguments]       ${from_device}   ${connected_device_list}
    verify front row participant   ${from_device}   ${connected_device_list}

white_board_sharing
    Verify and click on white board sharing in call control bar   device=device_1
    Wait for Some Time    time=${wait_time}
    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
    Verify whiteboard tools display on screen    device=device_1
    Stop presenting whiteboard share screen   device=device_1

Verify and click on white board sharing in call control bar
    [Arguments]    ${device}
    Verify whiteboard sharing option under more option   ${device}

tdc_Sending_Chat_with_chat_panel_on
    Verify chat on the front row ui     device=device_1
    Send the message from chat option in TDC  device=tdc_1:non_pro_user     message=checking for the testing purpose
    Verify messages on chat layers      device=device_1     message=checking for the testing purpose

verify call connected state 10 sec wait time
	Wait for Some Time    time=${10_sec_wait_time}
    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
*** Settings ***
Resource    ../resources/keywords/common.robot


Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  6
${5_minutes_wait_time} =   5 minutes
${wait_time_15min} =     15 minutes

*** Test Cases ***
TC1 :[Hard Key] DUT user to test the contacts hard button when People tab is not opened /open
    [Tags]      306832            Certification_audio
    [Setup]    Testcase Setup   count=1
    ${contact_button}   has hardkey contact button supported device   device=device_1
    pass execution if   '${contact_button}'=='False'  device_1, device is not have contact button
    press hardkeys   device=device_1             hardkey_intent=207
    Wait for Some Time    time=3s
    ${people_navigation_result}=     verify people navigation    device=device_1
    should be true    ${people_navigation_result}
    press hardkeys   device=device_1             hardkey_intent=207
    ${people_navigation_result}=     verify people navigation    device=device_1
    should be true    ${people_navigation_result}
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2 :[T9 Input] Teams App should display T9 IME candidate characters for Hard keys
    [Tags]      316187            Certification_audio       bvt_tp      sanity_tp      bvt_pr  
    [Setup]    Testcase Setup   count=1
    ${dailpad}   is hard dial pad present   device=device_1
    pass execution if   '${dailpad}'=='False'  device_1, device is not have hard dial pad
    click on calls tab   device=device_1
    T9 input search text       device=device_1       input=0123456789*#
    Navigate to calendar tab    device=device_1
    T9 input search text       device=device_1       input=0123456789*#
    Navigate to people tab    device=device_1
    T9 input search text       device=device_1       input=0123456789*#
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3 :[T9 Input] Teams App T9 IME behavior when no characters are entered in search bar
    [Tags]      316188            Certification_audio       bvt_tp   sanity_tp   
    [Setup]    Testcase Setup   count=1
    ${dailpad}   is hard dial pad present   device=device_1
    pass execution if   '${dailpad}'=='False'  device_1, device is not have hard dial pad
    click on calls tab   device=device_1
    T9 input search text       device=device_1       input=0123456789*#
    verify search close btn    device=device_1
    Navigate to calendar tab    device=device_1
    T9 input search text       device=device_1       input=0123456789*#
    verify search close btn    device=device_1
    Navigate to people tab    device=device_1
    T9 input search text       device=device_1       input=0123456789*#
    verify search close btn    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC4 :[Hard Key] DUT user to test redial button when UI view is in device settings page
    [Tags]      308140            Certification_audio       
    [Setup]    Testcase Setup   count=2
    ${redial_button}   has hardkey redial button present   device=device_1
    pass execution if   '${redial_button}'=='False'  device_1, device is not have redial button
    click on calls tab  device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    go back to previous page     device=device_1
    open settings page      device=device_1
    click device settings       device=device_1   
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_13
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC5 :[HID_Call Control] DUT user to Test the redial hard button
    [Tags]      306834            Certification_audio       
    [Setup]    Testcase Setup   count=2
    ${redial_button}   has hardkey redial button present   device=device_1
    pass execution if   '${redial_button}'=='False'  device_1, device is not have redial button
    click on calls tab  device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
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

TC6 :[HID_Call Control] Transfer the call using Transfer hard key on the device.
    [Tags]      306861            Certification_audio
    [Setup]    Testcase Setup   count=3
    ${call_transfer_button}   has hardkey call transfer button present   device=device_1
    pass execution if   '${call_transfer_button}'=='False'  device_1, device is not have call transfer button
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call   from_device=device_1      to_device=device_3      method=display_name     option=hard_key
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify Call State    device_list=device_1     state=Disconnected
    Disconnect call     device=device_2
    verify call state and disconnect    device=device_2,device_3
    click on calls tab   device=device_1
    Place a Call From Search Results Page    from_device=device_2    to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Click Back    device=device_1
    Blindtransfers the call   from_device=device_1      to_device=device_3      method=display_name     option=hard_key
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify Call State    device_list=device_1     state=Disconnected
    Disconnect call     device=device_2
    verify call state and disconnect    device=device_2,device_3
    Place a Call From Search Results Page    from_device=device_2    to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Click Back    device=device_1
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_15
    Wait for Some Time    time=${wait_time}
    Blindtransfers the call   from_device=device_1      to_device=device_3      method=display_name     option=hard_key
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify Call State    device_list=device_1     state=Disconnected
    Disconnect call     device=device_2
    verify call state and disconnect    device=device_2,device_3
    Place a Call From Search Results Page    from_device=device_2    to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Click Back    device=device_1
    open settings page      device=device_1
    click device settings       device=device_1 
    Wait for Some Time    time=${wait_time}
    Blindtransfers the call   from_device=device_1      to_device=device_3      method=display_name     option=hard_key
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify Call State    device_list=device_1     state=Disconnected
    Disconnect call     device=device_2
    verify call state and disconnect    device=device_2,device_3
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC7 :[HID_Call Control] Hold/Resume in Conference/P2P Call using hard/soft button
    [Tags]      306846            Certification_audio        bvt_tp   sanity_tp      bvt_pr   
    [Setup]    Testcase Setup   count=2
    ${call_transfer_button}   has hardkey call hold button present   device=device_1
    pass execution if   '${call_transfer_button}'=='False'  device_1, device is not have call hold button
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_14
    Verify Call State    device_list=device_1,device_2        state=Hold
    Wait for Some Time    time=${wait_time}
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_14
    Verify Call State    device_list=device_1,device_2        state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC8 :[HID_Call Control]DUT user presses hard hold key when call is put on hold by far end user
    [Tags]      308990            Certification_audio
    [Setup]    Testcase Setup   count=2
    ${call_transfer_button}   has hardkey call hold button present   device=device_1
    pass execution if   '${call_transfer_button}'=='False'  device_1, device is not have call hold button
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call   device=device_2
    Verify Call State    device_list=device_2    state=Hold
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_14
    Verify Call State    device_list=device_1,device_2        state=Hold
    Resume the call   device=device_2
    Wait for Some Time    time=${wait_time}
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_14
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2        state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC9 :[HID_Call Control] Hold/Transfer the call using hard key during call
    [Tags]      309027            Certification_audio
    [Setup]    Testcase Setup   count=3
    ${call_transfer_button}   has hardkey call hold button present   device=device_1
    pass execution if   '${call_transfer_button}'=='False'  device_1, device is not have call hold button
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_14
    Verify Call State    device_list=device_1,device_2        state=Hold
    Wait for Some Time    time=${wait_time}
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_14
    Verify Call State    device_list=device_1,device_2        state=Connected
    Blindtransfers the call   from_device=device_1      to_device=device_3      method=display_name     option=hard_key
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify Call State    device_list=device_1     state=Disconnected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC10 :[Hard Key] Pressing VM hard key during incoming and outgoing call should not reject the call 
    [Tags]    309039    Certification_Audio     
    [Setup]   Testcase Setup   count=2 
     ${VM_button}   has hardkey voicemail button supported device   device=device_1 
    pass execution if   '${VM_button}'=='False'  device_1, device is not have Voicemail button 
    click on calls tab   device=device_2 
    Make outgoing call using display name    from_device=device_2      to_device=device_1 
    Verify Incoming call    device=device_1     status=appear 
    press hardkeys    device=device_1    hardkey_intent=KEYCODE_BUTTON_15 
    Verify Incoming call    device=device_1     status=appear 
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON 
    Verify Call State    device_list=device_1,device_2    state=Connected 
    Disconnect call     device=device_1 
    Verify Call State    device_list=device_1,device_2    state=Disconnected 
    click on calls tab   device=device_1 
    Make outgoing call using display name    from_device=device_1      to_device=device_2 
    Verify Incoming call    device=device_2     status=appear 
    press hardkeys    device=device_1    hardkey_intent=KEYCODE_BUTTON_15 
    verify outgoing call ui    device=device_1    state=connecting 
    Pick incoming call    device=device_2 
    Wait for Some Time    time=${wait_time} 
    Verify Call State    device_list=device_1,device_2    state=Connected 
    Disconnect call     device=device_2 
    Verify Call State    device_list=device_1,device_2     state=Disconnected 
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2 
 
TC11 :[HID] DUT user to test hard Speaker button, headset and handset while cilcking back button navigates to home screen 
    [Tags]    476018    bvt_tp    Sanity_tp    
    [Setup]   Testcase Setup   count=1 
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON 
    Wait for Some Time    time=${wait_time} 
    verify dialpad after clicking speaker or handsethook button    device=device_1 
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=OFF 
    Wait for Some Time    time=${wait_time} 
    verify dialpad after clicking speaker or handsethook button    device=device_1 
    return to home screen    device_list=device_1 
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON 
    verify dialpad after clicking speaker or handsethook button    device=device_1 
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=OFF 
    verify dialpad after clicking speaker or handsethook button    device=device_1 
    return to home screen    device_list=device_1 
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1 

TC12 :[Audio Channel] DUT user to Test call accept/terminate by on hook/off hook the Handset to Cradle 
    [Tags]    306915    Certification_Audio       bvt_tp       bvt_pr
    [Setup]  Testcase Setup    count=2 
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1 
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON 
    Verify Call State    device_list=device_1,device_2    state=Connected 
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=OFF 
    Verify Call State    device_list=device_1,device_2     state=Disconnected 
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2 

TC13 :[Audio Channel] DUT user to test Dial-tone by pressing the Speaker button 
    [Tags]    306866            sanity_tp    bvt_tp
    [Setup]    Testcase Setup    count=2 
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON 
    verify dialpad after clicking speaker or handsethook button    device=device_1 
    auto dial with valid num from dial pad  from_device=device_1    to_device=device_2     method=phonenumber 
    pick incoming call  device=device_2 
    Verify Call State    device_list=device_1,device_2    state=Connected 
    Disconnect call    device=device_1 
    Verify Call State    device_list=device_1,device_2     state=Disconnected 
    [Teardown]   Run Keywords   Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC14 :[Audio Channel] Putting back handset should end dial-tone and return to home view 
    [Tags]    308145            sanity_tp 
    [Setup]    Testcase Setup   count=1 
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON 
    verify dialpad after clicking speaker or handsethook button    device=device_1 
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=OFF 
    verify dialpad after clicking speaker or handsethook button    device=device_1 
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1 

TC15 :[Audio Channel] DUT user tries to Accept second call through handset 
    [Tags]    309045    Certification_AUdio     
    [Setup]    Testcase Setup    count=3 
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1 
    Verify Incoming call    device=device_1     status=appear 
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON 
    Verify Call State    device_list=device_1,device_2    state=Connected 
    click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1 
    verify options in call notification banner      device=device_1
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON 
    verify options in call notification banner      device=device_1
    verify outgoing call ui    device=device_3    state=connecting 
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=OFF 
    Verify Call State    device_list=device_1,device_2     state=Disconnected 
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3 

TC16 :[HID] DUT user to test Speaker button 
    [Tags]    306816    bvt_tp    Certification_Audio       Sanity_tp      bvt_pr 
    [Setup]   Testcase Setup    count=2 
    Make outgoing call using display name    from_device=device_2      to_device=device_1 
    Verify Incoming call    device=device_1     status=appear 
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON 
    Verify Call State    device_list=device_1,device_2    state=Connected 
    Verify presence of Intents    device=device_1    feature=volume_music_speaker    state=present 
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=OFF 
    Verify Call State    device_list=device_1,device_2     state=Disconnected 
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2 

TC17 :[Audio Channel] DUT user can switch from speaker to handset in a P2P call 
    [Tags]   306939    Certification_Audio     
    [Setup]    Testcase Setup    count=2 
    Make outgoing call using display name    from_device=device_2      to_device=device_1 
    Verify Incoming call    device=device_1     status=appear 
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON 
    Verify Call State    device_list=device_1,device_2    state=Connected 
    volume up using keyevent    device=device_1 
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON 
    Verify Multiple Intents    device=device_1     features_list=PHONE_STATE_UPDATED   intents_list=speaker_off,headset_off,handset_on 
    Wait for Some Time    time=${5_minutes_wait_time} 
    Verify Call State    device_list=device_1,device_2    state=Connected 
    Disconnect call     device=device_1 
    Verify Call State    device_list=device_1,device_2     state=Disconnected 
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC18 : [Audio outPut]call should flow with speaker when user dial any number 
    [Tags]    321094         sanity_tp
    [Setup]    Testcase Setup    count=2 
    Click on calls tab   device=device_1 
    auto dial with valid num from dial pad  from_device=device_1    to_device=device_2     method=phonenumber 
    pick incoming call  device=device_2 
    Verify Call State    device_list=device_1,device_2    state=Connected 
    Verify Multiple Intents    device=device_1     features_list=PHONE_STATE_UPDATED   intents_list=speaker_on,headset_off,handset_off 
    Disconnect call    device=device_1 
    Verify Call State    device_list=device_1,device_2     state=Disconnected 
    [Teardown]   Run Keywords   Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2 

TC19 : [Outgoing Calls] DUT user disconnect the call before call established with TDC user and disconnect the call after TDC user accepted. 
    [Tags]    310229        
    [Setup]    Testcase Setup    count=2 
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON 
    verify dialpad after clicking speaker or handsethook button    device=device_1 
    auto dial with valid num from dial pad  from_device=device_1    to_device=device_2     method=phonenumber 
    Verify Incoming call    device=device_2     status=appear 
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=OFF 
    Verify Call State    device_list=device_1,device_2     state=Disconnected 
    verify dialpad after clicking speaker or handsethook button    device=device_1 
    return to home screen    device_list=device_1 
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON 
    verify dialpad after clicking speaker or handsethook button    device=device_1 
    auto dial with valid num from dial pad  from_device=device_1    to_device=device_2     method=phonenumber 
    Verify Incoming call    device=device_2     status=appear 
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=OFF 
    Verify Call State    device_list=device_1,device_2     state=Disconnected 
    [Teardown]   Run Keywords   Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2 

TC20 :[Audio Route Change] DUT user to make, receive, the call through handset
    [Tags]    310682        sanity_tp
    [Setup]    Testcase Setup    count=2
    Click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON
    Verify Multiple Intents    device=device_1     features_list=APP_AUDIO_STATE   intents_list=handset_on
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    return to home screen    device_list=device_1
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON
    verify dialpad after clicking speaker or handsethook button    device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2
    Verify Incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC21 :[Audio Route Change] DUT user to make, receive the call through headset
    [Tags]    310685        sanity_tp
    [Setup]    Testcase Setup    count=2
    Click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    press specific hardkey    device=device_1    hard_key=HEADSETHOOK    status=ON
    Verify Multiple Intents    device=device_1     features_list=APP_AUDIO_STATE   intents_list=headset_on
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    return to home screen    device_list=device_1
    press specific hardkey    device=device_1    hard_key=HEADSETHOOK    status=ON
    verify_dialpad_after_clicking_speaker_or_handsethook_button    device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2
    Verify Incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2


TC22 :[Audio Route Change] DUT user to make, receive the call through speaker
    [Tags]    310688        sanity_tp
    [Setup]    Testcase Setup    count=2
    Click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
    Verify Multiple Intents    device=device_1     features_list=APP_AUDIO_STATE   intents_list=speaker_on
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    return to home screen    device_list=device_1
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
    verify_dialpad_after_clicking_speaker_or_handsethook_button    device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2
    Verify Incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC23 :[HID]DUT user to test the Teams buttons
    [Tags]    309975    certification_audio    
    [Setup]    Testcase Setup    count=2
    ${Teams_button}    has hardkey teams button supported device   device=device_1
    pass execution if   '${Teams_button}'=='False'  device_1, device is not have Teams button
    Click on calls tab   device=device_2
    Make outgoing call using display name   from_device=device_2     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    press hardkeys    device=device_1    hardkey_intent=KEYCODE_BUTTON_12
    Verify home screen page    device=device_1
    Verify presence of Intents    device=device_1    feature=KEYCODE_BUTTON_12    state=present
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC24 :[Audio Channel] DUT user can switch from speaker to headset in a P2P call
    [Tags]   306935    Certification_Audio        sanity_tp    bvt_tp
    [Setup]    Testcase Setup    count=2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    increase volume and verify    device=device_1    volume_stream=calling
    press specific hardkey    device=device_1    hard_key=HEADSETHOOK    status=ON
    Verify Multiple Intents    device=device_1     features_list=PHONE_STATE_UPDATED   intents_list=speaker_off,headset_on,handset_off
    Wait for Some Time    time=${5_minutes_wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC25 :[Audio Channel] DUT user can switch from handset to headset in a P2P call
    [Tags]   306943    Certification_Audio          sanity_tp    bvt_tp
    [Setup]    Testcase Setup    count=2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON
    Verify Call State    device_list=device_1,device_2    state=Connected
    increase volume and verify    device=device_1    volume_stream=calling
    press specific hardkey    device=device_1    hard_key=HEADSETHOOK    status=ON
    Verify Multiple Intents    device=device_1     features_list=PHONE_STATE_UPDATED   intents_list=speaker_off,headset_on,handset_off
    Wait for Some Time    time=${5_minutes_wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC26 :[Audio Channel] Device gets the call while being on another call with audio channel set to speaker/Headset/handset
    [Tags]    306951    certification_audio        sanity_tp
    [Setup]    Testcase Setup    count=3
    ${Cvolume}    current volume level    device=device_1    volume_stream=calling
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    press specific hardkey    device=device_1    hard_key=SPEAKER      status=on
    Verify Call State    device_list=device_1,device_2    state=Connected
    compare volume    device=device_1    volume=${Cvolume}    volume_stream=calling    volume_state=constant
    press specific hardkey    device=device_1    hard_key=HEADSETHOOK      status=on
    compare volume    device=device_1    volume=${Cvolume}    volume_stream=calling    volume_state=constant
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK      status=on
    compare volume    device=device_1    volume=${Cvolume}    volume_stream=calling    volume_state=constant
    click on calls tab  device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify incoming call notification    device=device_1
    pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2    state=hold
    verify call hold banner    from_device=device_1      to_device=device_2
    Disconnect call      device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    Verify Multiple Intents    device=device_1     features_list=PHONE_STATE_UPDATED   intents_list=headset_on,speaker_on,handset_on
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC27 :[Audio Channel] DUT user can switch between Headset, handset and Speaker in a conference call
    [Tags]    306947    acceptance_audio    certification_audio    smoke_tp
    [Setup]    Testcase Setup    count=3
    clear all day meeting and meeting history from calendar   devices=device_1,device_2
    Create Meeting  device=device_1      meeting=test_meeting1     participants=device_2,device_3
    Join Meeting    device=device_1,device_2,device_3     meeting=test_meeting1
    Verify meeting state    device_list=device_1,device_2,device_3   state=connected
    ${Cvolume}    current volume level    device=device_1    volume_stream=calling
    press specific hardkey    device=device_1    hard_key=HEADSETHOOK    status=ON
    Wait for Some Time    time=${wait_time}
    compare volume    device=device_1    volume=${Cvolume}    volume_stream=calling    volume_state=constant
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON
    Wait for Some Time    time=${wait_time}
    compare volume    device=device_1    volume=${Cvolume}    volume_stream=calling    volume_state=constant
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
    Wait for Some Time    time=${wait_time}
    compare volume    device=device_1    volume=${Cvolume}    volume_stream=calling    volume_state=constant
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Wait for Some Time    time=${wait_time_15min}
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    Verify Multiple Intents    device=device_1     features_list=PHONE_STATE_UPDATED   intents_list=headset_on,speaker_on,handset_off
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3    AND    Teardown meeting test case    devices=device_1    AND    clear all day meeting and meeting history from calendar   devices=device_1,device_2,device_3

TC28: [Audio Channel] DUT user disconnects the call by pressing speaker after minimizing the call roaster
    [Tags]    309033    certification_audio        sanity_tp
    [Setup]  Testcase Setup    count=2
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    go back to previous page   device=device_1
    verify calls recent tab     device=device_1
    Verify Call State    device_list=device_2    state=Connected
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=OFF
    Verify Call State    device_list=device_1,device_2   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC29 :[Audio Channel] DUT user to test call accept/terminate by Touch Screen on the Microsoft Teams application and redirect to speaker by default
    [Tags]    309968    Certification_Audio        sanity_tp    bvt_tp
    [Setup]    Testcase Setup    count=2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Wait for Some Time    time=${wait_time}
    press specific hardkey    device=device_1    hard_key=HEADSETHOOK      status=ON
    Verify Call State    device_list=device_1,device_2    state=Connected
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK      status=ON
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Verify Multiple Intents    device=device_1     features_list=PHONE_STATE_UPDATED   intents_list=speaker_on,headset_on,handset_on
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC30: [HID] DUT user to test Headset button
    [Tags]      306814            Certification_audio
    [Setup]    Testcase Setup   count=2
    Click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
    Verify Multiple Intents    device=device_1     features_list=PHONE_STATE_UPDATED   intents_list=speaker_on
    Verify Call State    device_list=device_1,device_2    state=Connected
    press specific hardkey    device=device_1    hard_key=HEADSETHOOK    status=ON
    Verify Multiple Intents    device=device_1     features_list=PHONE_STATE_UPDATED   intents_list=headset_on
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC31: [HID] DUT user to test by lifting the Handset, by using Headset, by pressing speaker button
    [Tags]      306825            Certification_audio
    [Setup]    Testcase Setup   count=2
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    # Receive the incoming call on device_1 by pressing the speaker button
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
    Verify Multiple Intents    device=device_1     features_list=PHONE_STATE_UPDATED   intents_list=speaker_on
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    # Receive the incoming call on device_1 by lifting the handset
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON
    Verify Multiple Intents    device=device_1     features_list=PHONE_STATE_UPDATED   intents_list=handset_on
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    # Receive the incoming call on device_1 using headset
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    press specific hardkey    device=device_1    hard_key=HEADSETHOOK    status=ON
    Verify Multiple Intents    device=device_1     features_list=PHONE_STATE_UPDATED   intents_list=headset_on
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC32: [HID] DUT user to test Redial Button
    [Tags]      306811            Certification_audio
    [Setup]    Testcase Setup   count=2
    ${redial_button}   has hardkey redial button present   device=device_1
    pass execution if   '${redial_button}'=='False'  device_1, device does not have redial button
    click on calls tab  device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    verify incoming call  device=device_2   status=appear
    Rejects the incoming call    device_list=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    Reset Logcat Capture    device=device_1
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_13
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=KEYCODE_BUTTON_13       state=present
    verify outgoing call ui     device=device_1     state=connecting
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

#PORTRAIT mode phone test case
TC33 :[5 inch and above] Verify the Dialpad UI by tapping on Hard speaker button, dial all digits and delete them
    [Tags]    417232                       Certification_audio
    [Setup]     Testcase Setup    count=1
    ${prt_mode_flag}   is portrait mode cnf device  device=device_1
    pass execution if   '${prt_mode_flag}'=='False'  device_1, device is not a portrait mode device
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
    verify dialpad after clicking speaker or handsethook button   device=device_1
    dial and verify all numbers from dialpad    device=device_1
    return to home screen    device_list=device_1
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON
    verify dialpad after clicking speaker or handsethook button   device=device_1
    dial and verify all numbers from dialpad    device=device_1
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1

#PORTRAIT mode phone test case
TC34 :[Portrait] [5 inch and above] Verify user can Dial all the numeric digits successfully.
    [Tags]          417233         
    [Setup]     Testcase Setup    count=1
    ${prt_mode_flag}   is portrait mode cnf device  device=device_1
    pass execution if   '${prt_mode_flag}'=='False'  device_1, device is not a portrait mode device
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
    verify dialpad after clicking speaker or handsethook button   device=device_1
    dial and verify all numbers from dialpad    device=device_1
    return to home screen    device_list=device_1
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON
    verify dialpad after clicking speaker or handsethook button   device=device_1
    dial and verify all numbers from dialpad    device=device_1
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1

#PORTRAIT mode phone test case
TC35 :[Portrait] [5 inch and above] Verify user can delete the numeric digits successfully.
    [Tags]          417236      
    [Setup]     Testcase Setup    count=1
    ${prt_mode_flag}   is portrait mode cnf device  device=device_1
    pass execution if   '${prt_mode_flag}'=='False'  device_1, device is not a portrait mode device
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
    verify dialpad after clicking speaker or handsethook button   device=device_1
    dial and verify all numbers from dialpad    device=device_1
    return to home screen    device_list=device_1
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON
    verify dialpad after clicking speaker or handsethook button   device=device_1
    dial and verify all numbers from dialpad    device=device_1
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1

TC36: [Audio Channel] DUT user to Test call accept/terminate by on hook/off hook the Handset to Cradle.
    [Tags]    417238    Certification_audio
    [Setup]    Testcase Setup    count=2
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    # Receive the incoming call on device_1 by lifting the handset
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${is_dialpad_present}     is dialpad open    device=device_1
    pass execution if   '${is_dialpad_present}'=='True'  device_1, dialpad is being shown
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=OFF
    # place the handset back, which should disconnect the call
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC37: [Outgoing Calls] DUT user to dial from hard key pad irrespective of the UI view
    [Tags]    309727    certification_audio        sanity_tp    bvt_tp
    [Setup]    Testcase Setup    count=2
    Navigate to calendar tab   device=device_1
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
    verify dialpad after clicking speaker or handsethook button   device=device_1
    auto dial with valid num from dial pad  from_device=device_1    to_device=device_2     method=phonenumber
    Verify Incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2   state=Disconnected
    is user on calendar tab     device=device_1
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON
    verify dialpad after clicking speaker or handsethook button   device=device_1
    auto dial with valid num from dial pad  from_device=device_1    to_device=device_2     method=phonenumber
    Verify Incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2   state=Disconnected
    is user on calendar tab     device=device_1
    press specific hardkey    device=device_1    hard_key=HEADSETHOOK    status=ON
    verify dialpad after clicking speaker or handsethook button   device=device_1
    auto dial with valid num from dial pad  from_device=device_1    to_device=device_2     method=phonenumber
    Verify Incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2   state=Disconnected
    is user on calendar tab     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC38: [Calls] Verify user is able to make a call by pressing speaker button on What's new page.
    [Tags]    311894
    [Setup]    Testcase Setup    count=2
    navigate to whats new page from home screen     device=device_1
    Wait for Some Time    time=3s
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
    verify dialpad after clicking speaker or handsethook button   device=device_1
    dail phone number from hard keys  device=device_1    to_device=device_2
    Verify Incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC39: [Make a Call] Verify that "Make a call" pop-up screen appears on People, Voicemail and Calendar tabs when the speaker button is pressed.
    [Tags]    320249    p1          sanity_tp    bvt_tp
    [Setup]    Testcase Setup    count=1
    Navigate to people tab    device=device_1
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
    verify dialpad after clicking speaker or handsethook button   device=device_1
    return to home screen    device_list=device_1
    Navigate to voicemail tab    device=device_1
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
    verify dialpad after clicking speaker or handsethook button   device=device_1
    return to home screen    device_list=device_1
    Navigate to calendar tab    device=device_1
    Navigate to voicemail tab    device=device_1
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
    verify dialpad after clicking speaker or handsethook button   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC40: [Audio outPut]receive call in headphone, press speaker button, call should switch to speaker
    [Tags]    321093    p2       sanity_tp
    [Setup]    Testcase Setup    count=2
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    press specific hardkey    device=device_1    hard_key=HEADSETHOOK    status=ON
    Verify Call State    device_list=device_1,device_2    state=Connected
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
    Wait for Some Time    time=3s
    Verify Multiple Intents    device=device_1     features_list=PHONE_STATE_UPDATED   intents_list=speaker_on,headset_off
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC41: [Audio outPut]call should switch to headphone when user dial a number or initiate a outgoing call, call was on speaker and press headphone button
    [Tags]    321100    p2
    [Setup]    Testcase Setup    count=2
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Verify Incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    press specific hardkey    device=device_1    hard_key=HEADSETHOOK    status=ON
    Wait for Some Time    time=3s
    Verify Multiple Intents    device=device_1     features_list=PHONE_STATE_UPDATED   intents_list=speaker_off,headset_on
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
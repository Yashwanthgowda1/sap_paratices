*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  6
${wait_time_3s} =  3

*** Test Cases ***
TC1 : [HID] DUT user to test standard Dial Pad keys from 0 to 9
    [Tags]      306812              Certification_audio
    [Setup]    Testcase Setup   count=1
    ${intents_support}   is dailpad intents supported device   device=device_1
    pass execution if   '${intents_support}'=='True'  device_1, device is not have dailpad intents support
    Reset Logcat Capture    device=device_1
    Click on calls tab   device=device_1
    dial hardkeys   device=device_1             hardkeys=0123456789
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=DIALPAD_KEYCODE       state=present
    verify daipad text box      device=device_1         text=0123456789
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2 :[HID] DUT user to test for dialing “+” from Keypad
    [Tags]      306813              Certification_audio
    [Setup]    Testcase Setup   count=1
    ${intents_support}   is dailpad intents supported device   device=device_1
    pass execution if   '${intents_support}'=='True'  device_1, device is not have dailpad intents support
    Reset Logcat Capture    device=device_1
    Click on calls tab   device=device_1
    dial hardkeys   device=device_1             hardkeys=+
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=KEYCODE_0       state=present
    verify daipad text box      device=device_1         text=+
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3 :[HID] DUT user to test * and # keys
    [Tags]      306822             Certification_audio
    [Setup]    Testcase Setup   count=1
    ${intents_support}   is dailpad intents supported device   device=device_1
    pass execution if   '${intents_support}'=='True'  device_1, device is not have dailpad intents support
    Reset Logcat Capture    device=device_1
    Click on calls tab   device=device_1
    dial hardkeys   device=device_1             hardkeys=*
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=KEYCODE_STAR       state=present
    Reset Logcat Capture    device=device_1
    dial hardkeys   device=device_1             hardkeys=#
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=KEYCODE_POUND      state=present
    verify daipad text box      device=device_1         text=*#
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC4 :[HID] DUT user to Test volume from Volume button
    [Tags]      306809            Certification_audio
    [Setup]    Testcase Setup   count=1
    Reset Logcat Capture    device=device_1
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_VOLUME_UP
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=KEYCODE_VOLUME_UP       state=present
    Reset Logcat Capture    device=device_1
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_VOLUME_DOWN
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=KEYCODE_VOLUME_DOWN      state=present
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC5 :[HID] DUT user to test Call Transfer button
    [Tags]      306820            Certification_audio
    [Setup]    Testcase Setup   count=3
    Reset Logcat Capture    device=device_1
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call   from_device=device_1      to_device=device_3      method=display_name     option=hard_key
    Pick incoming call    device=device_3
    Verify presence of Intents     device=device_1      feature=KEYCODE_BUTTON_16      state=present
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    Wait for Some Time    time=${wait_time}
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC6 :[HID] DUT user to Test Mute from Mute button
    [Tags]      306810            Certification_audio      sanity_tp
    [Setup]    Testcase Setup   count=1
    Reset Logcat Capture    device=device_1
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=KEYCODE_MUTE       state=present
    Reset Logcat Capture    device=device_1
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=KEYCODE_MUTE       state=present
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC7 :[HID] DUT user to Hold/Resume from Hold button
    [Tags]      306819            Certification_audio
    [Setup]    Testcase Setup   count=1
    Reset Logcat Capture    device=device_1
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_14
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=KEYCODE_BUTTON_14       state=present
    Reset Logcat Capture    device=device_1
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_14
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=KEYCODE_BUTTON_14       state=present
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC8 :[HID] DUT user to Test Contacts from contacts button
    [Tags]      306823            Certification_audio
    [Setup]    Testcase Setup   count=1
    ${contact_button}   has hardkey contact button supported device   device=device_1
    pass execution if   '${contact_button}'=='False'  device_1, device is not have contact button
    Reset Logcat Capture    device=device_1
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_CONTACTS
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=KEYCODE_CONTACTS       state=present
    ${people_navigation_result}=     verify people navigation    device=device_1
    should be true    ${people_navigation_result}
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC9: [HID] DUT user to test Voicemail button
    [Tags]      306821            Certification_audio
    [Setup]    Testcase Setup   count=1
    Reset Logcat Capture    device=device_1
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_15
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=KEYCODE_BUTTON_15       state=present
    navigate to voicemail tab    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC10 :[HID] DUT user to test Handset by off hook from cradle
    [Tags]    306817    certification_audio    
    [Setup]    Testcase Setup    count=2
    Click on calls tab   device=device_2
    Make outgoing call using display name   from_device=device_2     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK      status=ON
    Verify presence of Intents    device=device_1    feature=KEYCODE_507    state=present
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC11 : [Teams Button] Pressing on Teams button, user should land on Home Screen
    [Tags]    310379    certification_audio    p1
    [Setup]    Testcase Setup    count=1
    ${Teams_button}    has hardkey teams button supported device   device=device_1
    pass execution if   '${Teams_button}'=='False'  device_1, device is not have Teams button
    open settings page      device=device_1
    click device settings       device=device_1
    press hardkeys    device=device_1    hardkey_intent=KEYCODE_BUTTON_12
    Verify home screen page    device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC12 : [Teams Button] Pressing on Teams button while in call ,should land on Call roster
    [Tags]    310101        smoke_tp    p0
    [Setup]    Testcase Setup    count=2
    ${Teams_button}    has hardkey teams button supported device   device=device_1
    pass execution if   '${Teams_button}'=='False'  device_1, device is not have Teams button
    Click on calls tab   device=device_1
    Make outgoing call using display name   from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    press hardkeys    device=device_1    hardkey_intent=KEYCODE_BUTTON_12
    Verify home screen page    device=device_1
    press hardkeys    device=device_1    hardkey_intent=KEYCODE_BUTTON_14
    Verify Call State    device_list=device_1,device_2    state=Hold
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_14
    tap to return to call   device=device_1
    Verify Call State    device_list=device_1     state=Resume
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=disConnected
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC13 : [Portrait] [5 inch and above] Verify user can close the Dialpad by tapping on back button.
    [Tags]    417239    bvt_cap       p1
    [Setup]    Testcase Setup    count=1
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
    verify dialpad after clicking speaker or handsethook button    device=device_1
    return to home screen    device_list=device_1
    Verify home screen page     device=device_1
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON
    verify dialpad after clicking speaker or handsethook button    device=device_1
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=OFF
    verify dialpad after clicking speaker or handsethook button    device=device_1
    return to home screen    device_list=device_1
    Verify home screen page     device=device_1
    verify and enable dark theme     device=device_1
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
    verify dialpad after clicking speaker or handsethook button    device=device_1
    return to home screen    device_list=device_1
    Verify home screen page     device=device_1
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON
    verify dialpad after clicking speaker or handsethook button    device=device_1
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=OFF
    verify dialpad after clicking speaker or handsethook button    device=device_1
    return to home screen    device_list=device_1
    Verify home screen page     device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND  verify and disable dark theme     device_1    AND   Come back to home screen    device_list=device_1

TC14 : [HID_Call Control] Check synchronization between Mute soft and Hard Key in second call where its muted call is hold by End-party
    [Tags]    308992    Certification_Audio       p1
    [Setup]    Testcase Setup    count=3
    Click on calls tab   device=device_2
    Make outgoing call using display name   from_device=device_2     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Click on calls tab   device=device_3
    Make outgoing call using display name   from_device=device_3     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2    state=Hold
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    verify call mute state    device_list=device_1    state=mute
    Hold the call   device=device_3
    Verify Call State    device_list=device_3,device_1,device_2    state=Hold
    resume call from call hold banner     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    Verify Call State    device_list=device_3    state=Hold
    Resume the call   device=device_3
    Verify Call State    device_list=device_3    state=Hold
    resume call from call hold banner     device=device_1
    verify call mute state    device_list=device_1    state=mute
    Verify Call State    device_list=device_3,device_1    state=Connected
    Verify Call State    device_list=device_2    state=Hold
    Disconnect call     device=device_1
    Verify Call State    device_list=device_3     state=Disconnected
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

15 : [Landscape] [7 inch and above] Verify Dialpad is launched on lifting handset when Recent call history is selected as default view.
    [Tags]    417257
    [Setup]    Testcase Setup    count=1
    ${landscape_mode_flag}   is screen size 7 inch or more  device=device_1
    pass execution if   '${landscape_mode_flag}'=='False'  device_1, device screen size have less then 7 inch
    Selecting default view values    device=device_1    option=expanded_dialpad
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
    verify calls tab after selecting expanded dialpad view    device=device_1
    return to home screen    device_list=device_1
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON
    verify calls tab after selecting expanded dialpad view    device=device_1
    [Teardown]    Run Keywords   Capture on Failure    AND   Selecting default view values    device=device_1    option=speed dial    AND   Come back to home screen    device_list=device_1

TC16 : [Teams Button] Pressing on Teams button, user should land on Home Screen
    [Tags]    310441
    [Setup]    Testcase Setup    count=1
    ${Teams_button}    has hardkey teams button supported device   device=device_1
    pass execution if   '${Teams_button}'=='False'  device_1, device is not have Teams button
    change default home view    device=device_1     option=dial_pad
    open and verify dialpad from calls tab    device=device_1
    return to home screen    device_list=device_1
    open settings page      device=device_1
    press hardkeys    device=device_1    hardkey_intent=503
    Verify home screen page    device=device_1
    change default home view    device=device_1     option=default
    Verify home screen page    device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC17 : [Voicemail] DUT user to test the voicemail hard button when user is on VM tab and any tab other than VM tab and Pressing Voice mail hard button should redirect user to voice mail tab when Voice mail App is not in the main screen
    [Tags]    306901
    [Setup]  Testcase Setup    count=1
    ${voicemail_button}   has hardkey voicemail button supported device   device=device_1
    pass execution if   '${voicemail_button}'=='False'  device_1, device is not have voicemail button
    Navigate to people tab    device=device_1
    verify search icon in people tab    device=device_1
    press hardkeys   device=device_1    hardkey_intent=500
    verify voicemail tab        device=device_1
    return to home screen    device_list=device_1
    Click on calls tab   device=device_1
    press hardkeys   device=device_1    hardkey_intent=500
    verify voicemail tab        device=device_1
    press hardkeys   device=device_1    hardkey_intent=500
    verify voicemail tab        device=device_1
    return to home screen    device_list=device_1
    ${before_home_screen_tiles}=    get home screen tiles    device=device_1
    Navigate to reorder tab    device=device_1
    Verfy and reorder homescreen tiles   device=device_1    tab=voicemail    destination=Walkie Talkie
    ${after_home_screen_tiles}=    get home screen tiles    device=device_1
    verify updated home screen tile after editing       before_changing=${before_home_screen_tiles}         after_changing=${after_home_screen_tiles}
    Navigate to people tab    device=device_1
    verify search icon in people tab    device=device_1
    press hardkeys   device=device_1    hardkey_intent=500
    verify voicemail tab        device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1


*** Keywords ***
Selecting default view values
    [Arguments]     ${device}    ${option}
    Select default view value   ${device}     ${option}
    Validate calls tab after default value change    ${device}      ${option}
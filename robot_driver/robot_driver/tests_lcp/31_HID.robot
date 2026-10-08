*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture
*** Variables ***
${wait_time} =  6

*** Test Cases ***
TC1 : [HID] DUT user to test standard Dial Pad keys from 0 to 9
    [Tags]      242991    Certification_lcp    tp_lcp
    [Setup]    Testcase Setup   count=1
    ${intents_support}   is dailpad intents supported device   device=device_1
    pass execution if   '${intents_support}'=='True'  device_1, device is not have dailpad intents support
    Reset Logcat Capture    device=device_1
    Navigate To People Tab   device=device_1
    dial hardkeys   device=device_1             hardkeys=0123456789
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=DIALPAD_KEYCODE       state=present
    verify daipad text box      device=device_1         text=0123456789
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
    
TC2 :[HID] DUT user to test * and # keys
    [Tags]      243007    Certification_Lcp    tp_lcp
    [Setup]    Testcase Setup   count=1
    ${intents_support}   is dailpad intents supported device   device=device_1
    pass execution if   '${intents_support}'=='True'  device_1, device is not have dailpad intents support
    Reset Logcat Capture    device=device_1
    Navigate To People Tab   device=device_1
    dial hardkeys   device=device_1             hardkeys=*
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=KEYCODE_STAR       state=present
    Reset Logcat Capture    device=device_1
    dial hardkeys   device=device_1             hardkeys=#
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=KEYCODE_POUND      state=present
    verify daipad text box      device=device_1         text=*#
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3 :[HID] DUT user to Test volume from Volume button
    [Tags]      242986    Certification_Lcp    tp_lcp
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

TC4 : [Hard key] Verify Dialpad from voicemail tab
    [Tags]    438233    bvt_lcp    sanity_lcp
    [Setup]    Testcase Setup   count=1
    Navigate to voicemail tab    device=device_1
    Wait For Some Time    time=${wait_time}
    dial hardkeys   device=device_1    hardkeys=0123456789
    verify daipad text box    device=device_1    text=0123456789
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
    
TC5 : [HID] DUT user to test Contacts button
    [Tags]      243009    Certification_Lcp
    [Setup]    Testcase Setup   count=1
    ${contact_button}   has hardkey contact button supported device   device=device_1
    pass execution if   '${contact_button}'=='False'  device_1, device is not have contact button
    Reset Logcat Capture    device=device_1
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_CONTACTS
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=KEYCODE_CONTACTS       state=Present
    ${people_navigation_result}=     verify people navigation    device=device_1
    should be true    ${people_navigation_result}
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC6 :[HID] DUT us2er to Hold/Resume from Hold button
    [Tags]      243001            Certification_Lcp
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


TC7 :[HID] DUT user to test Redial Button
    [Tags]      242989    Certification_lcp
    [Setup]    Testcase Setup   count=2
    ${redial_button}   has hardkey redial button present   device=device_1
    pass execution if   '${redial_button}'=='False'  device_1, device is not have redial button
    navigate to calls tab  device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_BUTTON_13
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC8 : [Hard Key] DUT user test hard redial button when DUT initiates a call to recent outgoing call user.
    [Tags]      446800
    [Setup]    Testcase Setup   count=3
    ${redial_button}   has hardkey redial button present   device=device_1
    pass execution if   '${redial_button}'=='False'  device_1, device is not have redial button
    navigate to calls tab  device=device_1
    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State       device_list=device_1,device_2     state=Disconnected
    Navigate To People Tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_BUTTON_13
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC9 : [Hard Key] DUT user to test the contact hard button when People tab is already opened
    [Tags]    243138    certification_lcp
    [Setup]     run keywords    Testcase Setup   count=1    AND    navigate to people tab    device=device_1   
    ${contact_button}   has hardkey contact button supported device   device=device_1
    pass execution if   '${contact_button}'=='False'  device_1, device is not have contact button
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_CONTACTS
    Wait for Some Time    time=${wait_time}
    ${people_navigation_result}=     verify people navigation    device=device_1
    should be true    ${people_navigation_result}
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC10 : [Hard Key] DUT user to test the contacts hard button when People tab is not already opened
    [Tags]    243017    certification_lcp
    [Setup]    Testcase Setup   count=1
    ${contact_button}   has hardkey contact button supported device   device=device_1
    pass execution if   '${contact_button}'=='False'  device_1, device is not have contact button
    verify ui post signin      device=device_1
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_CONTACTS
    Wait for Some Time    time=${wait_time}
    ${people_navigation_result}=     verify people navigation    device=device_1
    should be true    ${people_navigation_result}
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1


TC11: [Hard Key] DUT user to test redial button when UI view is in device settings page
    [Tags]      243568    Certification_lcp    sanity_lcp
    [Setup]    Testcase Setup   count=2
    ${redial_button}   has hardkey redial button present   device=device_1
    pass execution if   '${redial_button}'=='False'  device_1, device is not have redial button
    Navigate To People Tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Device Setting Back     device=device_1
    open settings page      device=device_1
    click device settings       device=device_1
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_BUTTON_13
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC12 : [Hard key] Pressing VM hard key on calls tab
    [Tags]      438235    bvt_lcp    sanity_lcp
    [Setup]    Testcase Setup   count=1
    navigate to calls tab    device=device_1
    ${voicemail_button}   has hardkey voicemail button supported device   device=device_1
    pass execution if   '${voicemail_button}'=='False'  device_1, device is not have voicemail button
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_BUTTON_15
    Wait for Some Time    time=${wait_time}
    ${voicemail_page}=    verify voicemail navigation    device=device_1
    should be true    ${voicemail_page}
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
     
TC13 : [HID] DUT user to test Voicemail button
    [Tags]      243005    certification_lcp
    [Setup]    Testcase Setup   count=1
    ${voicemail_button}   has hardkey voicemail button supported device   device=device_1
    pass execution if   '${voicemail_button}'=='False'  device_1, device is not have voicemail button
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_BUTTON_15
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=KEYCODE_BUTTON_15      state=present
    ${voicemail_page}=    verify voicemail navigation    device=device_1
    should be true    ${voicemail_page}
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
      
TC14 :[HID] DUT user to test Call Transfer button
    [Tags]      243003    P2
    [Setup]     Testcase Setup   count=3
    ${intents_support}   has hardkey call transfer button present   device=device_1
    pass execution if   '${intents_support}'=='False'  device_1, device dont have have call transfer button present
    Reset Logcat Capture    device=device_1
    Navigate To People Tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    press hardkeys   device=device_1    hardkey_intent=4
    Blindtransfers the call   from_device=device_1      to_device=device_3      method=display_name     option=hard_key
    Pick incoming call    device=device_3
    Verify presence of Intents     device=device_1      feature=KEYCODE_BUTTON_16      state=present
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify Call State     device_list=device_1    state=Disconnected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure      AND    Come back to home screen    device_list=device_1,device_2,device_3

TC15: [Hard Key]DUT user to press Left/Right Navigation Key
    [Tags]  244763  
    [Setup]  Testcase Setup    count=1
    press hardkeys   device=device_1    hardkey_intent=22
    Verify presence of Intents     device=device_1      feature=KEYCODE_DPAD_RIGHT      state=present
    press hardkeys       device=device_1    hardkey_intent=21
    Verify presence of Intents     device=device_1      feature=KEYCODE_DPAD_LEFT      state=present
    [Teardown]  Run Keywords    Capture on Failure    AND     Come back to home screen    device_list=device_1

TC6 :[HID] DUT user to test Mute button
    [Tags]      242988   p2    sanity_lcp
    [Setup]    Testcase Setup   count=1
    Reset Logcat Capture    device=device_1
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=KEYCODE_MUTE       state=present
    Reset Logcat Capture    device=device_1
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=KEYCODE_MUTE       state=present
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC7 : [HID] DUT user to test Handset by off hook from cradle
    [Tags]      242999     ftp_lcp
    [Setup]   Testcase Setup   count=2
    navigate to people tab    device=device_2
    Make outgoing call using display name   from_device=device_2     to_device=device_1
    verify incoming call    device=device_1     status=appear
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK      status=ON
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify presence of Intents    device=device_1    feature=KEYCODE_507    state=present
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC8 : [HID] DUT user to test Speaker button
    [Tags]      242997    bvt_lcp    sanity_lcp
    [Setup]    Testcase Setup   count=1
    Reset Logcat Capture    device=device_1
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify presence of Intents    device=device_1    feature=KEYCODE_506    state=present
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC19: [Hard Key] Pressing VM hard key during incoming and outgoing call should not reject the call
    [Tags]      243850      p2
    [Setup]   Testcase Setup   count=2
    ${VM_button}   has hardkey voicemail button supported device   device=device_1
    pass execution if   '${VM_button}'=='True'  device_1, device is not have Voicemail button
    Navigate To People Tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    press hardkeys    device=device_1    hardkey_intent=KEYCODE_BUTTON_15
    Verify Incoming call    device=device_1     status=appear
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    Navigate To People Tab      device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Verify Incoming call    device=device_2     status=appear
    press hardkeys    device=device_1    hardkey_intent=KEYCODE_BUTTON_15
    Verify Incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

T20 : [HID] DUT user to test the Teams buttons
    [Tags]      244156    ftp_lcp   P2
    [Setup]   Testcase Setup   count=2
    ${teams_button}   has hardkey teams button supported device   device=device_1
    pass execution if   '${teams_button}'=='False'  device_1, device is not have teams button
    Navigate To People Tab   device=device_1
    Make outgoing call using display name   from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    press hardkeys    device=device_1    hardkey_intent=KEYCODE_BUTTON_12
    verify ui post signin       device=device_1
    Verify presence of Intents     device=device_1      feature=KEYCODE_BUTTON_12      state=Present
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2    state=DisConnected
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2
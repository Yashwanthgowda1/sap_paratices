*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Test Cases ***

TC1 : [HID_Call Control] Hold/Resume in P2P Call using hard button
    [Tags]    261811    Certification_CAP    bvt_cap    Sanity_CAP    p1
    [Setup]    Testcase Setup for CAP User   count=2
    click on people tab     device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_14
    Verify Call State    device_list=device_1    state=Hold
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_14
    Verify Call State    device_list=device_1     state=Resume
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC2 : [HID_Call Control] DUT user to test the mute hard button
    [Tags]    261808    Certification_CAP    Sanity_CAP    p1
    [Setup]    Testcase Setup for CAP User   count=2
    click on people tab     device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    verify call mute state    device_list=device_1    state=mute
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    verify call mute state    device_list=device_1    state=unmute
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    verify call mute state    device_list=device_1    state=mute
    Unmutes the phone call  device=device_1
    verify call mute state    device_list=device_1    state=unmute
    Mutes the phone call    device=device_1
    verify call mute state    device_list=device_1    state=mute
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    verify call mute state    device_list=device_1    state=unmute
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC3 : [HID_Call Control] Mute/Unmute button sync with DUT in P2P call
    [Tags]    261809    Certification_CAP    p2
    [Setup]    Testcase Setup for CAP User   count=2
    click on people tab     device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    verify call mute state    device_list=device_1    state=mute
    Unmutes the phone call  device=device_1
    verify call mute state    device_list=device_1    state=unmute
    Mutes the phone call    device=device_1
    verify call mute state    device_list=device_1    state=mute
    press hardkeys    device=device_1    hardkey_intent=KEYCODE_MUTE
    verify call mute state    device_list=device_1    state=unmute
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC4 : [HID_Call Control] Mute/Unmute in P2P call using hard mute button
    [Tags]    261822    Certification_CAP    Smoke_CAP    p2
    [Setup]    Testcase Setup for CAP User   count=2
    click on people tab     device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    verify call mute state    device_list=device_1    state=mute
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    verify call mute state    device_list=device_1    state=unmute
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC5 : [HID] DUT user to test standard Dial Pad keys from 0 to 9
    [Tags]    261737    Certification_CAP    p1
    [Setup]    Testcase Setup for CAP User   count=1
    ${dailpad}   is hard dial pad present   device=device_1
    pass execution if   '${dailpad}'=='False'  device_1, device is not have hard dial pad
    verify dial pad UI for CAP     device=device_1
    dial hardkeys   device=device_1             hardkeys=0123456789
    verify daipad text box      device=device_1         text=0123456789
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1
    
TC6 : [HID] DUT user to test for dialing “+” from Keypad
    [Tags]    261738    Certification_CAP    p1
    [Setup]    Testcase Setup for CAP User   count=1
    ${dailpad}   is hard dial pad present   device=device_1
    pass execution if   '${dailpad}'=='False'  device_1, device is not have hard dial pad
    verify dial pad UI for CAP     device=device_1
    dial hardkeys   device=device_1             hardkeys=+
    verify daipad text box      device=device_1         text=+
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC8 : [HID] DUT user to test the Teams buttons
    [Tags]    261746    Certification_CAP    p1
    [Setup]    Testcase Setup for CAP User   count=2
    ${Teams_button}    has hardkey teams button supported device   device=device_1
    pass execution if   '${Teams_button}'=='False'  device_1, device is not have Teams button
    click on people tab     device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    press hardkeys    device=device_1    hardkey_intent=KEYCODE_BUTTON_12
    Verify presence of Intents    device=device_1    feature=KEYCODE_BUTTON_12    state=present
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC9 : [HID_Call Control] DUT user presses hard hold key when call is put on hold by far end user
    [Tags]    261826    Certification_CAP    p1
    [Setup]    Testcase Setup for CAP User   count=2
    click on people tab     device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call   device=device_2
    Verify Call State    device_list=device_2    state=Hold
    press hardkeys    device=device_1    hardkey_intent=KEYCODE_BUTTON_14
    Verify Call State    device_list=device_1,device_2    state=Hold
    Resume the call   device=device_2
    Verify Call State    device_list=device_2     state=Resume
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_14
    Verify Call State    device_list=device_1     state=Resume
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC10 : [Teams Button] Pressing on Teams button, user should land on Home Screen
    [Tags]    468718
    [Setup]    Testcase Setup for CAP User    count=1
    ${Teams_button}    has hardkey teams button supported device   device=device_1
    pass execution if   '${Teams_button}'=='False'  device_1, device is not have Teams button
    open settings page      device=device_1
    click device settings       device=device_1
    press hardkeys    device=device_1    hardkey_intent=KEYCODE_BUTTON_12
    Verify home screen page    device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

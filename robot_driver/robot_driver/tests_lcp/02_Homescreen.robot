*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1: [Home screen] DUT user to view Date, Day, Month and Time on Home screen
    [Tags]  244164
    [Setup]  Testcase Setup     count=1
    verify ui post signin  device=device_1
    verify date and time on lcp homescreen   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2: [Home screen] DUT user to verify Calls on Home screen
    [Tags]  244168
    [Setup]  Testcase Setup     count=1
    verify ui post signin  device=device_1
    navigate to calls tab  device=device_1
    navigate to calls favorites page  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3: [Home screen] Validate the options in the hamburger menu
    [Tags]  321060
    [Setup]  Testcase Setup     count=1
    verify ui post signin  device=device_1
    verify option present inside hamburger menu of lcp homescreen     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC4: [Home Screen] UI should not distorted in portrait/Landscape devices
    [Tags]  319080
    [Setup]  Testcase Setup     count=1
    verify ui post signin  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC5: [Home screen] DUT user has the option to exit/come back to home screen
    [Tags]  244207
    [Setup]  Testcase Setup     count=1
    verify ui post signin  device=device_1
    Verify device setting page from Home Screen enable page and come back   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC6: [Home screen] DUT user should have Home screen enabled by default.
    [Tags]  244210
    [Setup]  Testcase Setup     count=1
    Verify home screen enabled after sign in      device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC7: [Home screen] DUT user navigates to App settings from Home screen
    [Tags]  244221
    [Setup]  Testcase Setup     count=1
    verify ui post signin  device=device_1
    Navigate to app setting page from home screen   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC8: [Home screen] DUT user to verify incoming call on Home screen
    [Tags]  244212
    [Setup]  Testcase Setup     count=2
    verify ui post signin  device=device_1
    navigate to people tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC9: [Home screen] DUT user rejects the incoming call from Teams Desktop Client
    [Tags]  244213
    [Setup]  Testcase Setup     count=2
    verify ui post signin  device=device_1
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Rejects the incoming call    device_list=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC10: [Home screen] DUT user to be displayed with presence on Home screen with Display picture of the user
    [Tags]  244167
    [Setup]  Testcase Setup     count=1
    verify ui post signin  device=device_1
    verify user presence along with profile picture on homescreen  device=device_1
    Select user presence   device=device_1     state=DND
    verify user presence along with profile picture on homescreen  device=device_1  presence_status=dnd
    [Teardown]  Run Keywords    Capture on Failure   AND   Select user presence   device=device_1     state=available    AND    Come back to home screen    device_list=device_1

TC11: [Home screen] DUT user to answer second incoming call on Home screen
    [Tags]  244214
    [Setup]  Testcase Setup     count=3
    verify ui post signin  device=device_1
    navigate to people tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    navigate to people tab  device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2    state=Hold
    Disconnect Call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3


TC12: [Home Screen]Verify that user can navigate back to home screen in between of a call and navigate to the different apps
    [Tags]  319599
    [Setup]  Testcase Setup     count=2
    navigate to people tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    device setting back     device=device_1
    click on calls tab  device=device_1
    tap to return to call       device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect Call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC13: [Home Screen]Verify that user should be able to see the hold banner (SLA) at home screen
    [Tags]  319598
    [Setup]  Testcase Setup     count=2
    navigate to people tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    device setting back     device=device_1
    verify call hold banner   from_device=device_1   to_device=device_2
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC14 : [Home screen] DUT user to verify hard dial pad keys from 0 to 9 on Home screen
    [Tags]      244241
    [Setup]      run keywords    Testcase Setup        count=1     AND     verify ui post signin  device=device_1
    ${intents_support}   is dailpad intents supported device   device=device_1
    pass execution if   '${intents_support}'=='True'  device_1, device is not have dailpad intents support
    Reset Logcat Capture    device=device_1
    Navigate To People Tab   device=device_1
    dial hardkeys   device=device_1             hardkeys=0123456789
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=DIALPAD_KEYCODE       state=present
    Wait for Some Time    time=${wait_time}
    verify daipad text box      device=device_1         text=0123456789
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
    
TC15: [Home screen] DUT user to verify hard contact button on Home screen
    [Tags]      244309
    [Setup]    run Keywords    Testcase Setup   count=1    AND     verify ui post signin      device=device_1
    ${contact_button}   has hardkey contact button supported device   device=device_1
    pass execution if   '${contact_button}'=='False'  device_1, device is not have contact button
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_CONTACTS
    Wait for Some Time    time=${wait_time}
    ${people_navigation_result}=     verify people navigation    device=device_1
    should be true    ${people_navigation_result}
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC16 : [Home screen] DUT user to verify volume hard buttons on Home screen
    [Tags]      244240
    [Setup]    run Keywords    Testcase Setup   count=1    AND     verify ui post signin       device=device_1
    Reset Logcat Capture    device=device_1
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_VOLUME_UP
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=KEYCODE_VOLUME_UP       state=present
    Reset Logcat Capture    device=device_1
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_VOLUME_DOWN
    Wait for Some Time    time=${wait_time}
    Verify presence of Intents     device=device_1      feature=KEYCODE_VOLUME_DOWN      state=present
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC17 : [Home screen] DUT user to verify hard voicemail button on Home screen
    [Tags]      244308
    [Setup]    run Keywords    Testcase Setup   count=1    AND     verify ui post signin  device=device_1
    ${voicemail_button}   has hardkey voicemail button supported device   device=device_1
    pass execution if   '${voicemail_button}'=='False'  device_1, device is not have voicemail button
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_BUTTON_15
    Wait for Some Time    time=${wait_time}
    ${voicemail_page}=    verify voicemail navigation    device=device_1
    should be true    ${voicemail_page}
    Verify presence of Intents     device=device_1      feature=KEYCODE_BUTTON_15      state=present
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC18: [Home screen] DUT user should be able to navigate to Calling screen when clicked on redial button
    [Tags]    244239
    [Setup]    run Keywords    Testcase Setup   count=2    AND     verify ui post signin  device=device_1
    ${redial_button}   has hardkey redial button present   device=device_1
    pass execution if   '${redial_button}'=='False'  device_1, device is not have redial button
    navigate to calls tab  device=device_1
    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State       device_list=device_1,device_2     state=Disconnected
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_BUTTON_13
    Pick incoming call    device=device_2
    verify call control visibility  device_list=device_1,device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
Verify home screen enabled after sign in
    [Arguments]     ${device}
    verify ui post signin  ${device}

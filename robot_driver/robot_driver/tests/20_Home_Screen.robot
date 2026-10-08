*** Settings ***
Resource    resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10
${wait_time2} =  15
${wait_time3} =  25


*** Test Cases ***
TC1 :[Home screen] DUT user to verify tiles on the Home screen and able to navigate inside all the tiles/tabs and check options present inside all tiles.
    [Tags]      310008    P0     bvt_tp   sanity_tp
    [Setup]   Testcase Setup    count=1
    verify home screen tabs and more option tabs  device=device_1
    click on calls tab   device=device_1
    verify calls recent tab     device=device_1
    verify calls favorites tab      device=device_1
    click on home bar icon      device=device_1
    Navigate to Calendar tab   device=device_1
    verify options in calendar tab      device=device_1        phone_number=device_1
    click on home bar icon      device=device_1
    navigate to people tab          device=device_1
    Verify plus icon on people tab   device=device_1
    verify search icon in people tab    device=device_1
    verify list of group names in people tab    device=device_1
    Navigate to voicemail tab    device=device_1
    verify voicemail tab        device=device_1
    click on home bar icon      device=device_1
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=1

TC2 : [Home screen] DUT user to view Date, Day, Month and Time on Home screen
    [Tags]   310001     P2  alt_credentials
    [Setup]   Testcase Setup    count=1
    Verify home screen time dates     device=device_1
    [Teardown]    Capture on Failure

TC3 : [Home screen] DUT user to be displayed with presence on Home screen with Display picture of the user
    [Tags]   310011     P2  alt_credentials
    [Setup]   Run Keywords   Testcase Setup    count=2    AND   Select user presence   device=device_1     state=DND
    Verify user profile picture on Home screen     device=device_1
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=Disappear
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    [Teardown]    Run Keywords   Capture on Failure    AND     Select user presence     device=device_1     state=Available    AND    Come back to home screen    device_list=device_1,device_2

TC4 : [Home screen] DUT user has the option to exit/come back to home screen
    [Tags]   310126     P3  alt_credentials
    [Setup]   Testcase Setup    count=1
    Verify device setting page from Home Screen enable page and come back   device=device_1
    Verify home screen page     device=device_1
    [Teardown]    Capture on Failure

TC5 : [Home screen] DUT user to verify Home screen once Hot Desk user Signs out
    [Tags]   310136     P2  alt_bug
    [Setup]  Testcase Setup    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Come back to home screen    device_list=device_1
    Verify hot desking mode    device=device_1
    End hot desk without disable home screen    device=device_1
    Verify home screen page     device=device_1
    [Teardown]   Capture on Failure

TC6 : [Home screen] verify DUT user can accept/reject incoming call from TDC on Home screen.
    [Tags]   310139     P2  alt_credentials
    [Setup]   Testcase Setup    count=2
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Verify home screen page     device=device_1
    click back      device=device_2
    click back      device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Rejects the incoming call    device_list=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    Verify home screen page     device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC7 : [Home screen] DUT user to answer second incoming call on Home screen
    [Tags]   310144     P2  alt_credentials
    [Setup]   Testcase Setup    count=3
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2     state=Hold
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    Verify home screen page     device=device_1
    [Teardown]    Capture on Failure

TC8 : [Home screen] DUT user navigates to App settings from Home screen
    [Tags]   310163     P3  alt_credentials
    [Setup]   Testcase Setup    count=1
    Navigate to app setting page from home screen   device=device_1
    [Teardown]    Run Keywords   Capture on Failure    AND    Come back to home screen     device_list=device_1

TC9 : [Home screen]DUT user to set status message from Home screen
    [Tags]   310158     P2  alt_bug
    [Setup]   Testcase Setup    count=1
    Clear user status message    device=device_1
    Set status message and validate     device=device_1
    Verify home screen page     device=device_1
    [Teardown]    Run Keywords   Capture on Failure    AND   Clear user status message    device=device_1

TC10 : [Home screen] DUT user does not save the status message from Home screen.
    [Tags]   310162     P2  alt_credentials
    [Setup]   Testcase Setup    count=1
    Set status message and cancel     device=device_1
    Verify home screen page     device=device_1
    [Teardown]    Capture on Failure

TC11 : [Home screen] DUT user clears notifications in Home screen
    [Tags]   310152     P3  alt_credentials
    [Setup]   Testcase Setup    count=2
    Give a miss call    from_device=device_2      to_device=device_1
    Wait for Some Time    time=${wait_time}
    Clear notification from home screen     device=device_1
    Verify clear notification button while user donot have notification    device=device_1
    [Teardown]    Capture on Failure

TC12 : [Home screen] DUT user to display missed call notification with date on Notification screen
    [Tags]   310112     P2  alt_credentials
    [Setup]   Run Keywords   Testcase Setup    count=2    AND     Clear notification from home screen     device=device_1
    Give a miss call    from_device=device_2      to_device=device_1
    Wait for Some Time    time=${wait_time}
    Verify missed call notification     to_device=device_1    from_device=device_2
    Call back from miss call notification    device=device_1
    Verify Incoming call    device=device_2     status=Appear
    Disconnect call     device=device_1
    Verify Incoming call    device=device_2     status=Disappear
    [Teardown]    Run Keywords   Capture on Failure    AND    Come back to home screen     device_list=device_1,device_2

TC13 : [Home screen] DUT user joins meeting from Home screen and meeting notification should auto refresh at Home screen
    [Tags]   310147     P2  alt_bug
    [Setup]   Run Keywords   Testcase Setup    count=2    AND     Clear notification from home screen     device=device_1
    create meeting   device=device_1    meeting=meeting2    participants=device_2
    Wait for Some Time    time=${wait_time}
    navigate to calendar tab    device=device_1
    return to home screen   device_list=device_1
    Verify meeting notification    device=device_1
    Join meeting from Home Screen    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_1    state=Connected
    Disconnect call     device=device_1
    Verify home screen page     device=device_1
    [Teardown]    Run Keywords   Capture on Failure    AND    Meeting Teardown     devices=device_1    meeting=meeting2   count=2

TC14 : [Home Screen]Verify that user should be able to see the hold banner (SLA) at home screen
    [Tags]   319340     P2
    [Setup]   Testcase Setup    count=2
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    return to home screen   device_list=device_1
    verify call hold banner   from_device=device_1   to_device=device_2
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC15 : [[Home Screen]DUT user is on home screen, receives 3 calls on the same time.
    [Tags]  310365
    [Setup]  Testcase Setup    count=4
    initiate simultaneous call   devices=device_2,device_3,device_4   target_device=device_1    method=display_name
    verify 3 incomming call  device=device_1
    verify call state and disconnect        device=device_2,device_3,device_4
    [Teardown]  Run Keywords   Capture on Failure    AND   come back home screen for user    count=3

TC16 : [Home Screen] DUT user on home screen, receives multiple calls and accept both the calls.
    [Tags]  310370
    [Setup]  Testcase Setup    count=3
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept    count=3
    disconnect call   device=device_1
    [Teardown]  Run Keywords   Capture on Failure    AND   come back home screen for user    count=3

TC17 : [Home Screen] DUT user on home screen, receives second call simultaneously from two user
    [Tags]  310373
    [Setup]  Testcase Setup   count=4
    make outgoing call using display name  from_device=device_4   to_device=device_1
    verify incoming call  device=device_1   status=appear
    pick incoming call  device=device_1
    wait for some time  ${wait_time}
    verify call state  device_list=device_1,device_4   state=connected
    initiate simultaneous call   devices=device_2,device_3   target_device=device_1    method=display_name
    verify multiple incoming calls  device=device_1
    accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept    count=4
    disconnect call   device_1
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4

TC18 : [Home Screen]verify that user can turn ON/OFF the showing notification
    [Tags]  319483      P2
    [Setup]   Testcase Setup    count=2
    traverse to settings notification  device=device_1
    disable notification    device=device_1
    give a miss call    from_device=device_2     to_device=device_1
    verify clear notification button on home screen     device=device_1     status=disappear
    traverse to settings notification  device=device_1
    enable notification    device=device_1
    wait for some time  ${wait_time}
    verify clear notification button on home screen     device=device_1     status=appear
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=2

TC19 : [Home Screen]Verify that user can receive incoming meeting invite at Home screen
    [Tags]  319327     P2
    [Setup]   Testcase Setup    count=3
    create meeting  device=device_2       participants=device_3    meeting=tests_meetings
    join meeting    device=device_2,device_3    meeting=tests_meetings
    Verify meeting state   device_list=device_2,device_3    state=Connected
    Add participant to conversation using display name   from_device=device_2      to_device=device_1
    verify incoming call    device=device_1     status=appear
    accept incoming call   device=device_1
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    end meeting     device=device_1,device_2,device_3
    Verify meeting state   device_list=device_1,device_2,device_3    state=disconnected
    [Teardown]  run keywords    Capture on Failure   AND   test case teardown    devices=device_1,device_2,device_3    count=3

TC20 : [Home Screen] DUT user to verify voice mail notification
    [Tags]  319454     P2
    [Setup]   Run Keywords   voicemail setup   count=2     AND     Clear notification from home screen     device=device_1
    Send Voicemail      from_device=device_2   to_device=device_1
    wait for some time  ${wait_time}
    play voicemail from home screen      from_device=device_2    to_device=device_1
    place call on home screen by call back button   device=device_1
    verify incoming call    device=device_2     status=appear
    accept incoming call    device=device_2
    verify call state   device_list=device_1,device_2       state=connected
    disconnect call   device_1
    delete voicemail from home screen    from_device=device_2      to_device=device_1
    verify clear notification button on home screen     device=device_1     status=disappear
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=1    AND   verify and disable call forwarding    device=device_1

TC21 : [Home screen] Validate the options in the hamburger menu
    [Tags]  321057     P2
    [Setup]   Testcase Setup    count=1
    verify options inside hamburger menu on home screen     device=device_1
    [Teardown]  run keywords    Capture on Failure   AND    close the hamburger menu   device=device_1    AND    come back home screen for user    count=1

TC22 : [Home Screen]Verify that user can navigate back to home screen in between of a call and navigate to the different apps
    [Tags]  319345     P2
    [Setup]   Testcase Setup    count=2
    verify home screen tiles     device=device_1
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    verify incoming call  device=device_1   status=appear
    pick incoming call   device=device_1
    verify call state   device_list=device_1,device_2   state=connected
    Verify user can navigate back to home screen in call and navigate to different apps   device=device_1
    verify call state   device_list=device_1,device_2   state=connected
    disconnect call     device=device_2
    verify call state   device_list=device_1,device_2   state=disconnected
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=2

TC23 : [Device Settings] User has the option to navigate to device settings from Home screen
    [Tags]  307262     P1       Certification_audio
    [Setup]   Testcase Setup    count=1
    verify home screen tiles     device=device_1
    navigate to device setting page     device=device_1
    device setting back     device=device_1
    click back      device=device_1
    verify home screen tiles     device=device_1
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=1

TC24 : [Home Screen] UI should not distorted in portrait/Landscape devices
    [Tags]  319069     P2
    [Setup]   Testcase Setup    count=1
    verify home screen tiles     device=device_1
    verify user profile picture on home screen      device=device_1
    verify home screen time dates   device=device_1
    verify user did num on home screen      device=device_1
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=1

TC25 :[Calls App] Validate make a call button
    [Tags]  320953     sanity_tp 
    [Setup]   Testcase Setup    count=2
    make multiple outgoing calls using call icon    from_device=device_1      to_devices=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=2

TC26 :[Home Screen]Verify that Pill count over the Calls app for unread missed calls
    [Tags]  320912   sanity_tp  P1
    [Setup]     Testcase Setup  count=2
    Give a miss call    from_device=device_2    to_device=device_1
    Wait for Some Time  time=${wait_time}
    ${calls_pill_count_before}=     verify home screen calls pill count     device=device_1
    Give a miss call    from_device=device_2    to_device=device_1
    Wait for Some Time  time=${wait_time}
    ${calls_pill_count_after}=      verify home screen calls pill count     device=device_1
    run keyword if  ${calls_pill_count_before}+1 == ${calls_pill_count_after}     Log   calls pill count got increased
    ...     ELSE    fail    Missed calls pill count didn't increase on home-screen.
    [Teardown]      run keywords    Capture on Failure      AND     come back home screen for user  count=2

TC27 : [Home Screen]Verify that Pill count over the Voicemail app for unread voicemails
    [Tags]       320918      P2
    [Setup]     Run Keywords    Testcase Setup  count=2     AND      Enable call forwarding to voicemail     from_device=device_1    contact_device=device_2
    Send Voicemail   from_device=device_2    to_device=device_1
    Wait for Some Time  time=${wait_time}
    ${voicemail_pill_count_before}=     verify home screen voicemail pill count     device=device_1
    Send Voicemail   from_device=device_2    to_device=device_1
    Wait for Some Time  time=${wait_time}
    ${voicemail_pill_count_after}=     verify home screen voicemail pill count     device=device_1
    run keyword if  ${voicemail_pill_count_before}+1 == ${voicemail_pill_count_after}     Log   voicemail pill count got increased
    ...     ELSE    fail    Missed voicemail count didn't increase on home-screen.
    [Teardown]      run keywords    Capture on Failure      AND     come back home screen for user  count=2  AND     verify and disable call forwarding    device=device_1

TC28 : [Phone Licensing][Homescreen] Calls,People,Calendar & Voicemail Tab Should be present in Homescreen.
    [Tags]   381538     bvt_tp   sanity_tp    auth_audio_p0    auth_audio
    [Setup]   Testcase Setup    count=1
    Verify home screen page     device=device_1
    [Teardown]     Capture on Failure

TC29 : [Meeting Reminder] DUT user join the meeting from the Home screen
    [Tags]   311583     P1  sanity_tp
    [Setup]   Run Keywords   Testcase Setup    count=2    AND     Clear notification from home screen     device=device_1
    create meeting   device=device_1    meeting=meeting2    participants=device_2
    Wait for Some Time    time=${wait_time}
    navigate to calendar tab    device=device_1
    return to home screen   device_list=device_1
    Verify home screen page     device=device_1
    Verify meeting notification    device=device_1
    verify time is decreasing in home screen meeting notification   device=device_1
    Join meeting from Home Screen    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_1    state=Connected
    Disconnect call     device=device_1
    Verify home screen page     device=device_1
    [Teardown]    Run Keywords   Capture on Failure    AND    Meeting Teardown     devices=device_1    meeting=meeting2   count=2

TC30 : [Meeting Reminder] Upcoming meeting notification should be removed when organizer cancels the meeting
    [Tags]   310192     P2
    [Setup]   Run Keywords   Testcase Setup    count=2    AND     Clear notification from home screen     device=device_1
    create meeting   device=device_1    meeting=meeting2    participants=device_2
    Wait for Some Time    time=${wait_time}
    navigate to calendar tab    device=device_1
    return to home screen   device_list=device_1
    Verify home screen page     device=device_1
    Verify meeting notification    device=device_1
    Delete meeting      devices=device_2    meeting=meeting2
    Wait for Some Time    time=${wait_time}
    navigate to calendar tab    device=device_1
    return to home screen   device_list=device_1
    verify meeting notification     device=device_1     status=disappear
    [Teardown]    Run Keywords   Capture on Failure    AND    Meeting Teardown     devices=device_1    meeting=meeting2   count=2

TC31 :[Home screen] DUT user to verify hard contact button on Home screen
    [Tags]      310437    P2
    [Setup]   Testcase Setup    count=1
    ${contact_button}   has hardkey contact button supported device   device=device_1
    pass execution if   '${contact_button}'=='False'  device_1, device is not have contact button
    verify home screen tabs and more option tabs  device=device_1
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_CONTACTS
    Wait for Some Time  time=${wait_time}
    Verify plus icon on people tab   device=device_1
    verify search icon in people tab    device=device_1
    verify list of group names in people tab    device=device_1
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=1

TC32 :[Home screen] DUT user to verify hard voicemail button on Home screen
    [Tags]     310437     310432    P2
    [Setup]   Testcase Setup    count=1
    ${vm_button}   has hardkey voicemail button supported device   device=device_1
    pass execution if   '${vm_button}'=='False'  device_1, device is not have voicemail button
    verify home screen tabs and more option tabs  device=device_1
    press hardkeys   device=device_1    hardkey_intent=KEYCODE_BUTTON_15
    Wait for Some Time  time=${wait_time}
    verify voicemail tab     device=device_1
    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=1

TC33 :[Home screen] DUT user to verify hard dial pad keys from 0 to 9 on Home screen
    [Tags]      310222    P2
    [Setup]   Testcase Setup    count=2
    ${dailpad_device}   Is Hard Dial Pad Present   device=device_1
    pass execution if   '${dailpad_device}'=='False'  device_1, device is not have dailpad
    navigate to dial pad tab from home screen     device=device_1
    dail phone number from hard keys   device=device_1    to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC34 :[Home screen] DUT user should navigate to dial pad when speaker button is pressed or lifted handset from home screen
    [Tags]    310120    bvt_tp    Sanity_tp     P0
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

TC35 :[Home screen] DUT user to verify volume hard buttons on Home screen
    [Tags]      310219
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

TC36 :[Home screen] DUT user should be able to navigate to Calling screen when clicked on redial button
    [Tags]      310216      P1
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

TC37: [Home Screen] User should remains on Home screen after device reboot
    [Tags]   319074    P2
    [Setup]     Run KeywordS      Testcase Setup    count=1     AND     Home Screen Enable     device=device_1
    Verify home screen page     device=device_1
    reboot phones    device=device_1
    Verify Home Screen Page    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

# Feature not implemented, hence commented the case
#TC27 : [Home screen] Teams App user to verify floating Dial pad on Home screen
#    [Tags]   204970     bvt     20_bvt  alt_bug
#    [Setup]   Run Keywords   Testcase Setup    count=1    AND    Home Screen Enable     device=device_1
#    Verify home screen page     device=device_1
#    Navigate to calls tab from home screen      device=device_1
#    [Teardown]  run keywords    Capture on Failure      AND   Home screen Disable    device=device_1

# Feature change: Home screen cannot be disbaled
#TC38 :[Home Screen]Setting to disable home screen should get discard after signout, user should land to home screen when user login again after signout
#    [Tags]  320927     P1
#    [Setup]   Testcase Setup    count=1
#    Home screen Disable    device=device_1
#    Sign out method    device_1
#    Wait for Some Time    time=${wait_time}
#    Sign in method     device_1     verify_home_screen_enabled=on
#    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=1

#Home screen disable feature removed
#TC15 : [Home screen] DUT user to disable Home screen from Settings
#    [Tags]   310155     P2  alt_credentials
#    [Setup]    Run Keywords   Testcase Setup    count=1    AND    Home Screen Enable     device=device_1
#    Home screen Disable    device=device_1
#    [Teardown]    Capture on Failure

#Home screen disable feature removed
#TC16 : [Home screen] DUT user to verify notifications when Home screen is disabled
#    [Tags]   310189     P2  alt_credentials
#    [Setup]   Run Keywords   Testcase Setup    count=1    AND    Home Screen Enable     device=device_1
#    Verify notification option from app settings page   device=device_1    status=enable
#    Home screen Disable    device=device_1
#    Verify notification option from app settings page   device=device_1    status=disable
#    [Teardown]    Run Keywords   Capture on Failure    AND    Come back to home screen     device_list=device_1

#Feature chnage: Cannot disable home screen
#TC10 : [Home screen] DUT user can enable/disable Home screen option
#    [Tags]   310133     P2  alt_credentials
#    [Setup]    Testcase Setup    count=1
#    Home Screen Enable     device=device_1
#    Home screen Disable    device=device_1
#    [Teardown]    Capture on Failure
#Feature chnage: Cannot disable home screen
# TC23 : [Home Screen] DUT user should get the Home screen option when it is enabled by the Admin
#     [Tags]   310613  sanity_tp   221524        20_bvt  alt_credentials
#     [Setup]   Testcase Setup    count=1
#     Verify home screen page     device=device_1
#     Home screen Disable    device=device_1
#     [Teardown]   Capture on Failure
*** Keywords ***
Meeting Teardown
    [Arguments]     ${devices}      ${meeting}    ${count}
    come_back_home_screen_for_user    ${count}
    Teardown Meeting Test Case     ${devices}
    remove_meeting_from_calender_for_user   ${count}

Send Voicemail
    [Arguments]     ${from_device}   ${to_device}
    Make outgoing call using display name    ${from_device}      ${to_device}
    Wait for Some Time    time=${wait_time2}
    Verify Call State    device_list=${from_device}   state=Connected
    Disconnect call     ${from_device}
    Verify Call State    device_list=${from_device}     state=Disconnected
    Come back to home screen     ${from_device}

Give a miss call
    [Arguments]     ${from_device}   ${to_device}
    Make outgoing call using display name    ${from_device}      ${to_device}
    Wait for Some Time    time=${wait_time}
    Verify Incoming call    device=${to_device}     status=Appear
    Disconnect call     device=${from_device}
    Verify Incoming call    device=${to_device}     status=Disappear
    Come back to home screen     ${from_device}

Receive GCP call TC setup
    Add new delegates with both permission and validate   from_device=device_2    to_device=device_1
    Enable call forwarding to delegates     from_device=device_2    contact_device=device_1

Receive GCP call TC teardown
    Delete delegate from manage delegate   from_device=device_2    to_device=device_1
    Come back to home screen    device_list=device_1,device_2,device_3
    verify and disable call forwarding    device=device_2

Test Case Teardown
    [Arguments]     ${devices}      ${count}
    check for device count      count=${count}
    Come back to home screen    device_list=${devices}
    Close dial pad  device=device_1
    Teardown Meeting Test Case     ${devices}
    Remove meeting from calender for meeting policy test      ${count}

Voicemail Setup
    [Arguments]   ${count}
    Testcase Setup   count=${count}
    Set Call Forwarding    device=device_1
    return to home screen    device_list=device_1,device_2
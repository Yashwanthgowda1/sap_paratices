*** Settings ***
Resource    resources/keywords/common.robot

Suite Teardown    run keywords    Suite Failure Capture    AND    verify and enable presence to Available

*** Variables ***
${wait_time} =      10s
${10m_wait_time} =      10 minutes

*** Test Cases ***
TC1 : [Presence] DUT user changes the presence to DND and Available
    [Tags]  307360    bvt_tp     sanity_tp         bvt_pr
    [Setup]  run keywords    Testcase Setup    count=4    AND    clear meetings from calendar tab    devices=device_3
    Signin with other user    device=device_2   other_user_account=device_1
    create meeting    device=device_3     participants=device_1       meeting=presence_meeting
    Select user presence   device=device_1     state=DND
    Verify user presence   device=device_1     state=DND
    #while presence is checking 1st after second device is signed in with device_1:user it's taking time to reflect presence, so adding wait time
    Wait for Some Time    time=2 minutes              
    Navigate To Calls Tab    device=device_2
    Return To Home Screen    device_list=device_2
    Verify user presence   device=device_2     state=DND
    Verify user presence from other user    from_device=device_4      to_device=device_1     state=DND
    Select user presence   device=device_1     state=Available
    Verify user presence   device=device_1     state=Available
    Wait for Some Time    time=${wait_time}
    Verify user presence   device=device_2     state=Available
    Verify user presence from other user    from_device=device_4      to_device=device_1     state=Available
    Make outgoing call using from call icon    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify user presence from other user    from_device=device_4      to_device=device_1     state=In call
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    Wait for Some Time    time=${wait_time}
    Verify user presence from other user    from_device=device_4      to_device=device_1     state=Available
    Join Meeting    device=device_1     meeting=presence_meeting
    Verify meeting state   device_list=device_1    state=Connected
    Wait for Some Time    time=${wait_time}
    Verify user presence   device=device_2     state=in a call
    Verify user presence from other user    from_device=device_4      to_device=device_1     state=In call
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    Wait for Some Time    time=${wait_time}
    Verify user presence from other user    from_device=device_4      to_device=device_1     state=Available
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2,device_3,device_4   AND   clear all meetings except test meeting     device=device_3    AND    verify and enable presence to Available


TC2 : [Presence] Verify the TDC user presence should be as "In a call" under Speed dial section in Favorites tab.
    [Tags]  416955     P2      sanity_tp
    [Setup]  Run Keywords    Testcase Setup    count=2    AND    Make outgoing call from call log
    Calling from favorite page   from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Navigate Back once    device=device_1
    Verify User Presence In favorite and people Page    from_device=device_1     to_device=device_2    state=in_call
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2    state=disConnected
    [Teardown]   Run Keywords    Capture on Failure  AND     Remove favorite user from favorites page     from_device=device_1    to_device=device_2    AND    Come back to home screen    device_list=device_1,device_2

TC3 : [Presence] Verify that if TDC user changes the Presence, it should reflect under "Speed dial" section in Favorites tab and in people tab.
    [Tags]    416952    P0     sanity_tp
    [Setup]     Run Keywords     Testcase Setup    count=2    AND    Make outgoing call from call log
    Select user presence   device=device_2     state=Busy
    Verify User Presence In favorite and people Page    from_device=device_1     to_device=device_2    state=Busy
    Navigate To People Tab      device=device_1
    Tap on dropdown icon next to all contacts     device=device_1
    Verify User Presence In favorite and people Page    from_device=device_1     to_device=device_2    state=Busy
    [Teardown]   Run Keywords    Capture on Failure      AND     Remove favorite user from favorites page     from_device=device_1    to_device=device_2    AND    Select user presence   device=device_2     state=available

TC4 : [Presence] User to show presence correctly after device reboot/restart
    [Tags]    307698    p2    sanity_tp
    [Setup]     Testcase Setup      count=2
    click on calls tab   device=device_2
    Make outgoing call using display name     from_device=device_2     to_device=device_1
    Pick incoming call     device=device_1
    verify call state     device_list=device_1,device_2     state=Connected
    reboot phones    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Verify user presence   device=device_1     state=Available
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC5: [Presence] verify that if the DUT and TDC change their presence, it should reflect on both the TDC and DUT.
    [Tags]  307341    sanity_tp      tp_audio       Certification_audio
    [Setup]   Run Keywords   Testcase Setup     count=3     AND     Signin with other user    device=device_2   other_user_account=device_1
    Select user presence   device=device_1     state=Busy
    Verify user presence   device=device_1     state=Busy
    Wait for Some Time    time=${wait_time}
    Verify user presence   device=device_2     state=Busy
    Verify user presence from other user    from_device=device_3      to_device=device_1     state=Busy
    Select user presence   device=device_2     state=DND
    Verify user presence   device=device_2     state=DND
    Wait for Some Time    time=${wait_time}
    Verify user presence   device=device_1     state=DND
    Verify user presence from other user    from_device=device_3      to_device=device_1     state=DND
    [Teardown]   Run Keywords    Capture on Failure     AND    Select user presence   device=device_2     state=available    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC6: [Presence] Presence changes to "In a call" and "Busy" from available when the user makes a call/Meeting
    [Tags]    307316    Sanity_tp
    [Setup]     Testcase Setup      count=3
    create meeting  device=device_2       participants=device_1    meeting=tests_meetings
    Return To Home Screen    device_list=device_2
    click on calls tab   device=device_1
    Make outgoing call using display name     from_device=device_1     to_device=device_2
    Pick incoming call     device=device_2
    verify call state     device_list=device_1,device_2     state=Connected
    Verify user presence from other user    from_device=device_3      to_device=device_1     state=In call
    Disconnect Call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=disconnected
    join meeting    device=device_1,device_2    meeting=tests_meetings
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify user presence from other user    from_device=device_3      to_device=device_1     state=In call
    End Meeting    device=device_1,device_2
    Verify Meeting State    device_list=device_1,device_2    state=disconnected
    [Teardown]    Run Keywords    Capture On Failure    AND     Come Back To Home Screen    device_list=device_1,device_2,device_3

TC7 : [Presence] Teams App user can see the correct presence in Voice mail tab (in the form of presence icon only)
    [Tags]  307338    p1  alt_credentials
    [Setup]   Run Keywords     Testcase Setup    count=2    AND     Voicemail Setup
    Navigate to voicemail tab    device=device_1
    Verify 1st vm presence status      device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND     Voicemail Teardown

TC8 : [Presence] Presence should not change from "Away" to "In a call" when the user makes a call
    [Tags]  307324    p1  alt_credentials
    [Setup]  Testcase Setup    count=2
    Select user presence   device=device_1     state=Away
    Verify user presence   device=device_1     state=Away
    click on calls tab   device=device_1
    Make outgoing call using from call icon    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify user presence from other user    from_device=device_2      to_device=device_1     state=Away
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Wait for Some Time    time=${wait_time}
    Verify user presence from other user    from_device=device_2      to_device=device_1     state=Away
    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2     AND    Select user presence   device=device_1     state=Available

TC9 : [Presence] Presence should change to the previous state at the end of Conference call
   [Tags]     307355
   [Setup]  Testcase Setup    count=3
   click on calls tab   device=device_1
   Make outgoing call using display name    from_device=device_1      to_device=device_3
   Pick incoming call    device=device_3
   Verify Call State    device_list=device_1,device_3    state=Connected
   Add participant to conversation using display name   from_device=device_1      to_device=device_2
   Pick incoming call    device=device_2
   Verify Call State    device_list=device_1,device_2,device_3    state=Connected
   verify participant list     from_device=device_1      connected_device_list=device_1,device_2,device_3
   Verify user presence from other user    from_device=device_2      to_device=device_1     state=In call
   Disconnect call     device=device_1,device_3
   Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
   Wait for Some Time    time=${wait_time}
   Verify user presence from other user    from_device=device_2      to_device=device_1     state=Available
   [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC10 : [Presence] Presence changes to Available from Idle-Inactive in case of any user activity on DUT
   [Tags]      307313        p1      alt_bug
   [Setup]  Testcase Setup    count=2
   Select user presence   device=device_1     state=Available
   Verify user presence from other user    from_device=device_2      to_device=device_1     state=Available
   Wait for Some Time    time=${10m_wait_time}
   Verify user presence from other user    from_device=device_2      to_device=device_1     state=Away
   Come back to home screen    device_list=device_1
   Verify user presence from other user    from_device=device_2      to_device=device_1     state=Available
   [Teardown]    Run Keywords    Capture on Failure   AND   close the hamburger menu     device=device_1

TC11 : [Presence] Teams App user can see the correct presence in call logs screen (in the form of presence icon only)
   [Tags]      307333
   [Setup]     Testcase Setup      count=2
   click on calls tab   device=device_1
   Make outgoing call using display name     from_device=device_1     to_device=device_2
   Pick incoming call     device=device_2
   Wait for Some Time      time=${wait_time}
   verify call state     device_list=device_1,device_2     state=Connected
   Disconnect call     device=device_1
   Verify user presence   device=device_2     state=Available
   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC12 : [Presence] Presence should not change to offline if DUT user sign out but same user is still signed in on TDC
    [Tags]      307349
    [Setup]  Testcase Setup     count=3
    Select user presence   device=device_1     state=Available
    Verify user presence   device=device_1     state=Available
    Signin with other user    device=device_2   other_user_account=device_1
    sign out method    device_1
    Verify user presence from other user    from_device=device_3      to_device=device_1     state=Available
    [Teardown]  Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2,device_3   AND      sign in method     device_1   

TC13 : [Presence] Presence should not change to offline if TDC user sign out but same user is still signed in on DUT
    [Tags]      307352
    [Setup]     Testcase Setup for idle mode recovery optimization and presence resilience     count=2
    Signin with other user    device=device_2   other_user_account=device_1
    Select user presence   device=device_1     state=Available
    Verify user presence   device=device_1     state=Available
    sign out method    device_2
    Click on calls tab      device=device_1
    Verify user presence   device=device_1     state=Available
    Verify user presence from other user    from_device=device_3      to_device=device_1     state=Available
    [Teardown]   Run Keywords    Capture on Failure   AND    sign in method     device_2

TC14 : [Presence] User can view the self presence in the form of Presence icon on the hamburger menu
   [Tags]        307329    bvt_pr      
   [Setup]  run keywords   Testcase Setup    count=1    AND   Select user presence   device=device_1     state=Available
   Verify user presence   device=device_1     state=Available
   [Teardown]   run keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

*** Keywords ***
Test Case Teardown
    [Arguments]     ${devices}      ${count}
    come_back_home_screen_for_user    ${count}
    Teardown Meeting Test Case     ${devices}
    remove_meeting_from_calender_for_user   ${count}

Voicemail Setup
    Set Call Forwarding    device=device_1
    Send Voicemail      from_device=device_2    to_device=device_1
    Come back to home screen    device_list=device_1,device_2

Send Voicemail
    [Arguments]     ${from_device}   ${to_device}
    Make outgoing call using display name    ${from_device}      ${to_device}
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=${from_device}   state=Connected
    Disconnect call     ${from_device}
    Verify Call State    device_list=${from_device}     state=Disconnected

Voicemail Teardown
    Navigate to calls tab       device=device_1
    verify and disable call forwarding    device=device_1
    Come back to home screen    device_list=device_1,device_2

Make outgoing call from call log
    click on calls tab   device=device_1
    Make Outgoing Call Using Display Name     from_device=device_1     to_device=device_2
    Pick incoming call     device=device_2
    Disconnect Call    device=device_1
    Come Back To Home Screen    device_list=device_1
    Select call list item   device=device_1  item=favorite
    Verify added favorite user in favorites page    from_device=device_1     to_device=device_2
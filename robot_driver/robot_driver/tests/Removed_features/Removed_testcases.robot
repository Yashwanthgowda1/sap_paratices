#TC5 : [Call Hold] DUT holds the call with PSTN user for 15 and 60 minutes
#    [Tags]  309763    bvt_pr        alt_blocked
#    [Setup]     Testcase Setup for PSTN User    count=2
#    Click on calls tab   device=device_1
#    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2:pstn_user
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Hold the call   device=device_1
#    Verify Call State    device_list=device_1     state=Hold
#    #Wait for Some Time    time=${15_minutes_wait_time}
#    Wait for Some Time    time=${60s_wait_time}
#    Resume the call   device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Resume
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC1 : [Call Mute] DUT user to mute/unmute itself while in a call with PSTN user
#    [Tags]  309776                  alt_blocked
#    [Setup]  Testcase Setup for PSTN User   count=2
#    Click on calls tab   device=device_1
#    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2:pstn_user
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Mutes the phone call    device=device_1
#    Verify Call mute State    device_list=device_1    state=mute
#    Unmutes the phone call  device=device_1
#    Verify Call mute State    device_list=device_1    state=unmute
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#
#TC2 : [Call Hold] DUT user can hold the muted call
#    [Tags]  309796             alt_credentials
#    [Setup]   Testcase Setup    count=2
#    click on calls tab   device=device_1
#    Make outgoing call using display name    from_device=device_1     to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Mutes the phone call    device=device_1
#    Verify meeting Mute State    device_list=device_1    state=mute
#    Hold the call   device=device_1
#    Verify Call State    device_list=device_1    state=Hold
#    Resume the call   device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Resume
#    Verify meeting Mute State    device_list=device_1    state=mute
#    Unmutes the phone call  device=device_1
#    Verify meeting Mute State    device_list=device_1    state=Unmute
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#
#TC5 : [Calls] Verify More[...] on home screen.
#    [Tags]      401959    P0
#    [Setup]  Testcase Setup    count=1
#    verify home screen tabs and more option tabs  device=device_1
#    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen     device_list=device_1
#
#
#TC6 :[E2EE] User to verify end to end encryption enabled for calls
#    [Tags]      315947    P0
#    [Setup]  Testcase Setup    count=2
#    Enable E2EE    device=device_1,device_2
#    click on calls tab     device=device_2
#    Make outgoing call using display name   from_device=device_2     to_device=device_1
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    verify e2ee security code on user  device_list=device_1,device_2
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure    AND    Disable E2EE    device=device_1,device_2
#
#TC24 : [SLA]Verify that "Resume banner" and resume button should display on Delegates user, when Boss is on hold.
#    [Tags]      345646   P0
#    [Setup]  Testcase Setup for Delegate User  count=3
#    Make outgoing call using display name    from_device=device_1      to_device=device_3
#    Verify Incoming call    device=device_3     status=appear
#    Pick incoming call    device=device_3
#    wait for some time      time=${wait_time}
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Hold the call   device=device_1
#    Verify Call State    device_list=device_1     state=Hold
#    navigate to calls favorites page   device=device_2
#    Validate People you support tab     device=device_2
#    verify user in people you support with presence in favorites_page       from_device=device_2    to_device=device_1
#    verify and resume call using resume button with boss  from_device=device_2      to_device=device_1     option=verify
#    Disconnect call    device=device_1
#    verify call state and disconnect        device=device_3
#    Verify Call State    device_list=device_1,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure    AND    come back home screen for user   count=3
#
#
#TC2 : [Calls] Calling from favorites tab
#    [Tags]   309295    bvt_pr  alt_bug
#    [Setup]   run keywords   Testcase Setup    count=2  AND   Make outgoing call for call log   from_device=device_2     to_device=device_1
#    Click on calls tab   device=device_1
#    Refresh calls main tab  device=device_1
#    Select call list item   device=device_2  item=favorite
#    Calling from favorite page   from_device=device_2     to_device=device_1
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#
#TC3 : Verify that DUT user able to access "What's new" page under the settings.
#    [Tags]      346160
#    [Setup]  Testcase Setup     count=1
#    navigate to whats new page from home screen   device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#
#TC3 : [Call Transfer] DUT user call transfer section should show "Contacts" option
#    [Tags]  309807   bvt_pr    alt_credentials
#    [Setup]  Testcase Setup    count=2
#    click on calls tab   device=device_2
#    Select call list item   device=device_1  item=favorite
#    navigate to calls favorites page    device=device_1
#    refresh calls main tab    device=device_1
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Verify contacts option in call transfer section     device=device_1
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC1 : [Call Transfer] DUT user blind transfer one PSTN user call to another PSTN user
#    [Tags]  309826   call_transfer_pstn2         bvt_pr       30_bvt  alt_blocked        Certification_audio
#    [Setup]  Testcase Setup for 2 PSTN User   count=3
#    Click on calls tab   device=device_2
#    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Blindtransfers the call using phonenumber  from_device=device_1      to_device=device_3:pstn_user
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC1 : [Calendar] Verify Join option for Teams Meeting scheduled from outlook
#    [Tags]  307056   146501         alt_bug        Certification_audio
#    [Setup]  Testcase Setup    count=1
#    Join meeting    device=device_1     meeting=test_meeting1
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1    state=Connected
#    End meeting     device=device_1
#    Verify UI returns to home page      device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen     device_list=device_1
#
#TC1 : [Incoming Calls] DUT user receives call from TDC.
#    [Tags]   308294   alt_credentials      Certification_audio
#    [Setup]  Testcase Setup    count=2
#    click on calls tab  device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Verify name of caller and receiver displayed    from_device=device_2      to_device=device_1
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_2
#
#TC1 : Verify that DUT user should be able to answer the call/meeting from "Privacy & Cookies" page under About in settings.
#    [Tags]      346184
#    [Setup]  Testcase Setup  count=2
#    verify options inside about page     device=device_1
#    navigate to privacy and cookies from about page    device=device_1
#    navigate to people tab    device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2,device_1     state=Disconnected
#    navigate to home screen from about page  device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#
#TC1 : [Advanced Calling] DUT user tap on More info icon on delegate.
#    [Tags]     311369     P0
#    [Setup]    Testcase Setup for Delegate User  count=3
#    click on calls tab  device=device_2
#    Initiate OBO call and verify boss list  from_device=device_2     to_device=device_3     obo_option=device_1     boss_list=device_1
#    Verify Incoming call    device=device_3    status=appear
#    Pick incoming call    device=device_3
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    wait for some time  ${wait_time}
#    navigate to calls favorites page  device=device_1
#    verify and join call using join call in more option with boss and delegate   from_device=device_1      to_device=device_2:delegate_user        option=verify
#    disconnect call    device=device_2
#    Verify Call State    device_list=device_2,device_3    state=disconnected
#    [Teardown]  run keywords  Capture on Failure    AND    check call dropdown menu state   device=device_1    AND    Come back to home screen   device_list=device_1,device_2,device_3
#
#
#TC2 : [Call Transfer] DUT user consultative transfers the PSTN call to TDC
#    [Tags]  309836  call_transfer_pstn     bvt_pr       alt_blocked        Certification_audio
#    [Setup]  Testcase Setup for PSTN User   count=3
#    Click on calls tab   device=device_2
#    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Completes the consultation to accept the call     from_device=device_1      to_device=device_2
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#
#TC2 : Verify that DUT user should be able to access "Third party software notices and information" page under About in settings.
#    [Tags]      346192
#    [Setup]  Testcase Setup     count=1
#    verify third party software notices and information     device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC3 : [Calendar] DUT user joins the scheduled meeting and Mute/unmute & verify hold option
#    [Tags]  306772   bvt_pr  alt_bug        Certification_audio
#    [Setup]  Testcase Setup    count=2
#    Join meeting   device=device_1,device_2    meeting=test_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Unmutes the meeting    device=device_1
#    Verify meeting Mute State    device_list=device_1    state=Unmute
#    Mutes the meeting     device=device_1
#    Verify meeting Mute State    device_list=device_1    state=mute
#    End meeting     device=device_1,device_2
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2
#
#
#TC18 : [Call Forward]DUT user redirects unanswered calls to delegates
#    [Tags]  308316   bvt_pr  alt_blocked
#    [Setup]  run keywords   Testcase Setup for Delegate User   count=3  AND   Enable unanswered call to delegates     from_device=device_1    contact_device=device_2
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
#    Wait for Some Time    time=${wait_time2}
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND     Unanswered call Teardown    devices=device_1,device_2,device_3
#
#TC1 : [Call Merge] Merge option should only be available for the current active call
#    [Tags]   309857      alt_bug
#    [Setup]     Testcase Setup      count=3
#    Click on calls tab   device=device_1
#    Make outgoing call using display name    from_device=device_1    to_device=device_2
#    Pick incoming call    device=device_2
#    verify call state     device_list=device_1,device_2        state=Connected
#    Click on calls tab   device=device_3
#    Make outgoing call using display name    from_device=device_3    to_device=device_1
#    Pick incoming call from call notification    device=device_1
#    Wait for Some Time          time=${wait_time}
#    verify call state      device_list=device_1,device_3      state=Connected
#    verify call state      device_list=device_2       state=hold
#    Verify and merge call      device=device_1     from_device=device_2
#    Wait for Some Time          time=${wait_time}
#    disconnect call        device=device_2,device_3
#    Verify Call State           device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown   devices=device_1,device_2,device_3
#
#
#TC5 : [Calendar] DUT user to cancel the scheduled meeting from the device
#    [Tags]  308322    alt_bug        Certification_audio
#    [Setup]  Testcase Setup    count=2
#    create meeting  device=device_1       participants=device_2     meeting=Cancel_meeting3
#    Refresh for Meeting Visibility      device=device_2
#    delete specific meeting    device=device_1    meeting=Cancel_meeting3
#    Refresh for Meeting Visibility      device=device_2
#    verify canceled meeting should not visible for organizer     device=device_1   meeting=Canceled: Cancel_meeting3
#    Verify meeting has meeting name     device=device_2  meeting=Canceled: Cancel_meeting3
#    [Teardown]   Run Keywords    Capture on Failure     AND     Test Case Teardown without deleting meeting   devices=device_1,device_2
#
#
#TC6 : [Call Transfer] DUT user blind transfer the TDC call to PSTN
#    [Tags]   306786     call_transfer    alt_blocked      Certification_audio
#    [Setup]  Testcase Setup for PSTN User    count=3
#    Click on calls tab   device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Blindtransfers the call using phonenumber  from_device=device_1      to_device=device_2:pstn_user
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC7 : [CQ] CQ agent Transfer the call to the user via PSTN
#    [Tags]  308835       P2  alt_blocked
#    [Setup]  Testcase Setup for CQ PSTN User   count=4
#    click on calls tab   device=device_2
#    Place call to phone num    from_device=device_2      phone_num=CQ_no
#    Wait till incoming call visibility    device=device_1,device_3
#    Pick incoming call    device=device_1
#    Verify Incoming call    device=device_3     status=disappear
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Blindtransfers the call using phonenumber  from_device=device_1      to_device=device_4
#    Pick incoming call    device=device_4
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_4,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_4,device_2    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND     Test Case Teardown    devices=device_1,device_2,device_3,device_4
#
#TC7 : [Calendar] DUT user to delete the meeting entry from the Calendar tab
#    [Tags]  308330   alt_bug        Certification_audio
#    [Setup]  Testcase Setup    count=2
#    create meeting  device=device_2       participants=device_1     meeting=Cancel_meeting4
#    Refresh for Meeting Visibility      device=device_1
#    delete specific meeting    device=device_2    meeting=Cancel_meeting4
#    Refresh for Meeting Visibility      device=device_1
#    Verify meeting has meeting name     device=device_1  meeting=Canceled: Cancel_meeting4
#    [Teardown]   Run Keywords    Capture on Failure     AND     Test Case Teardown without deleting meeting   devices=device_1,device_2
#
#TC10 : [Call Forward] DUT user to forward the call to delegates - Call from TDC user
#    [Tags]  307827   bvt_pr  alt_blocked
#    [Setup]  Testcase Setup for Delegate User   count=3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify incoming call    device=device_2     status=appear
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen   device_list=device_1,device_2,device_3
#
#
#TC2 :[Search] Recent search result should display on top of recent search history
#    [Tags]    306807   bvt_pr        alt_credentials
#    [Setup]     Testcase Setup     count=3
#    Click on calls tab       device=device_1
#    verify search text             from_device=device_1           to_device=device_2
#    go back to previous page    device=device_1
#    verify search text             from_device=device_1           to_device=device_3
#    go back to previous page    device=device_1
#    verify recent search item      from_device=device_1   to_device=device_3
#    [Teardown]   Run Keywords      Capture on Failure   AND    Come back to home screen    device_list=device_1
#
#TC 1 : [Multiple Calls] DUT user is on calls tab, receives multiple calls and accept full screen call
#    [Tags]  308859   P1     Certification_audio
#    [Setup]  Testcase Setup  count=3
#    click on calls tab    device=device_1,device_2,device_3
#    initiate simultaneous call  devices=device_2,device_3   target_device=device_1    method=display_name
#    verify multiple incoming calls  device=device_1
#    accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=verify
#    disconnect call   device_1
#    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3
#
#TC1: [CallTransferEnhancements] blind transfer search screen > can search for users > touchscreen transfer
#    [Tags]   456316
#    [Setup]  Testcase Setup    count=3
#    Click on calls tab   device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#
#TC4 : [Hard Mute] Verify Organizer/presenter-can turn on hard mute, it disables mic for attendees with toggle
#    [Tags]  311421   P1
#    [Setup]  Testcase Setup   count=2
#    join meeting   device=device_1,device_2    meeting=Hard_and_reaction
#    Wait for Some Time   ${wait_time}
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    verify manage audio and video option    device=device_1    count=2   role=organiser
#    Make an attendee    from_device=device_1       to_device=device_2
#    Verify you are an attendee now notification     device=device_2
#    Disable camera and mic for attendees   from_device=device_1   to_device=device_2    mic=off   camera=on
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC4: [CallTransferEnhancements] consult transfer search screen > can search for users > touchscreen transfer
#    [Tags]  456328   P1
#    [Setup]   Testcase Setup    count=3
#    click on calls tab   device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Verify Call State    device_list=device_3,device_1    state=Connected
#    Verify Call State    device_list=device_2    state=Hold
#    Completes the consultation to accept the call     from_device=device_1      to_device=device_2
#    Verify Call State    device_list=device_1     state=Disconnected
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC5 : [Hard Mute] Verify "your mic has been disabled" message display on main stage to participant/attendee
#    [Tags]  311433   P1
#    [Setup]  Testcase Setup   count=2
#    join meeting   device=device_1,device_2    meeting=Hard_and_reaction
#    Wait for Some Time   ${wait_time}
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    verify manage audio and video option    device=device_1    count=2   role=organiser
#    Make an attendee    from_device=device_1       to_device=device_2
#    Verify you are an attendee now notification     device=device_2
#    Disable camera and mic for attendees   from_device=device_1      to_device=device_2     mic=off   camera=on
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#
#TC5: [CallTransferEnhancements] consult transfer search screen > launch dialpad
#    [Tags]  456332   P1
#    [Setup]  Testcase Setup    count=3
#    click on calls tab   device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    verify call transfer UI when in call   from_device=device_1   to_device=device_2   speed_dial_user=device_3    option=consult_first
#    resume the call      device=device_1
#    click and verify dial pad in call transfer   device=device_1   option=consult_first
#    Disconnect call     device=device_2
#    verify call state and disconnect   device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC6 : [Hard Mute] Presenter/organizer can provide individual restrictions to users. Allow to Unmute
#    [Tags]  311441   P1
#    [Setup]  Testcase Setup   count=2
#    join meeting   device=device_1,device_2    meeting=Hard_and_reaction
#    Wait for Some Time   ${wait_time}
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    verify manage audio and video option    device=device_1    count=2   role=organiser
#    Make an attendee    from_device=device_1       to_device=device_2
#    Verify you are an attendee now notification     device=device_2
#    Disable camera and mic for attendees   from_device=device_1   to_device=device_2    mic=off   camera=on
#    verify and allow individual permissions to attendees  from_device=device_1    to_device=device_2
#    Unmutes the phone call  device=device_2
#    Mutes the phone call    device=device_2
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#
#TC3 : [Presence] Verify that if TDC changes Presence, it should reflect at both TDC and DUT
#    [Tags]      307532      307345   40_bvt  alt_credentials       Certification_audio
#    [Setup]   Testcase Setup    count=1
#    Select user presence   device=device_1     state=Available
#    Verify user presence   device=device_1     state=Available
#    Select user presence   device=device_1     state=DND
#    Verify user presence   device=device_1     state=DND
#    [Teardown]   run keywords    Capture on Failure    AND   Select user presence   device=device_1     state=Available    AND    Come back to home screen    device_list=device_1
#
#
#TC15 : [Reactions] DUT user to verify the presence of reactions button in docked ubar while in call
#    [Tags]  310939
#    [Setup]    Testcase Setup   count=1
#    join meeting   device=device_1    meeting=Hard_and_reaction
#    Verify meeting state   device_list=device_1   state=Connected
#    Verify reaction button in call control     device=device_1
#    End meeting     device=device_1
#    Verify meeting state    device_list=device_1   state=Disconnected
#    [Teardown]    Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#
#TC17 : [Reactions] DUT user to verify the reactions in the reaction window
#    [Tags]  310944
#    [Setup]    Testcase Setup   count=1
#    join meeting   device=device_1    meeting=Hard_and_reaction
#    Verify meeting state   device_list=device_1   state=Connected
#    Verify reaction button in call control     device=device_1
#    Tap on reaction button in call control      device=device_1
#    Verify presence of reactions button in call control     device=device_1
#    End meeting     device=device_1
#    Verify meeting state    device_list=device_1   state=Disconnected
#    [Teardown]   run keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1
#
#TC8 : [Walkie-Talkie] Verify that there is no Walkie talkie option present in Home screen.
#    [Tags]   311971     P1
#    [Setup]   Run Keywords   Testcase Setup    count=1    AND    Home Screen Enable     device=device_1
#    Verify home screen page     device=device_1
#    verify walkie talkie is not present on home screen    device=device_1
#    navigate to calls tab  device=device_1
#    navigate to walkie talkie tab  device=device_1
#    [Teardown]    Run Keywords   Capture on Failure    AND   Home screen Disable    device=device_1
#
#
#TC18 : [Reactions] Raise hand should not be displayed separately when reactions button is available in docked ubar
#    [Tags]  310947
#    [Setup]    Testcase Setup   count=1
#    join meeting   device=device_1    meeting=Hard_and_reaction
#    Verify meeting state   device_list=device_1   state=Connected
#    Verify reaction button in call control     device=device_1
#    Tap on reaction button in call control      device=device_1
#    Verify presence of reactions button in call control     device=device_1
#    verify raise hand reaction     device=device_1
#    End meeting     device=device_1
#    Verify meeting state    device_list=device_1   state=Disconnected
#    [Teardown]   run keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1
#
#TC2 : [Walkie-Talkie] Verify the mic button to "press and hold" to talk.
#    [Tags]  311984  bvt_pr
#    [Setup]  Testcase Setup  count=2
#    navigate to walkie talkie tab  device=device_1,device_2
#    verify connect when no channel is selected  device=device_1,device_2
#    select the channel  device=device_1,device_2     channel=Channel_1
#    click on connect and verify mic  device=device_1,device_2
#    verify connected paricipant list  device=device_1      connected_device_list=device_1,device_2
#    press and hold the mic button  from_device=device_1    to_device=device_2
#    click on disconnect and verify mic  device=device_1,device_2
#    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2
#
#TC6: [CallTransferEnhancements] [landscape] consult transfer search screen > shows speed dials
#    [Tags]  456369   P1
#    [Setup]  Testcase Setup    count=3
#    ${landscape_mode_flag}   is portrait mode cnf device  device=device_1
#    pass execution if   '${landscape_mode_flag}'=='True'  device_1, device is not a landscape mode device
#    Click on calls tab   device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    verify call transfer UI when in call   from_device=device_1   to_device=device_2   speed_dial_user=device_3    option=consult_first
#    resume the call      device=device_1
#    transfer call using speed dial from call transfer UI   device=device_1   speed_dial_user=device_3   transfer_option=consult_first
#    Pick incoming call    device=device_3
#    Verify Call State    device_list=device_3,device_1    state=Connected
#    Verify Call State    device_list=device_2    state=Hold
#    Completes the consultation to accept the call     from_device=device_1      to_device=device_2
#    Verify Call State    device_list=device_1     state=Disconnected
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC02 :[Presence] Verify the DUT user presence should be as "In a call" when TDC1 user is in meeting with TDC2.
#    [Tags]     416950    P0
#    [Setup]     Testcase Setup for idle mode recovery optimization and presence resilience     count=3
#    create meeting    device=device_3     participants=device_1       meeting=presence_resilience
#    Join meeting    device=device_2     meeting=presence_resilience
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_2    state=Connected
#    open settings page      device=device_1
#    click back      device=device_1
#    Verify user presence    device=device_1     state=In a call
#    End meeting     device=device_2
#    Verify meeting state    device_list=device_2   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown     devices=device_1,device_2,device_3   count=3     AND      Come back to home screen    device_list=device_1,device_2,device_3
#
#TC3: [Device Properties] Check device type
#    [Tags]  310457
#    [Setup]  Testcase Setup  count=1
#    Check device type    device=device_1
#    [Teardown]  Capture on Failure
#
#TC4: [Device Properties] Check device capabilities
#    [Tags]  310462     P0     Certification_audio
#    [Setup]  Testcase Setup  count=1
#    Check device capabilities   device=device_1
#    [Teardown]   Capture on Failure
#
#TC2: [Meetings]Verify the meeting name is shown in calendar or notification when the "show meeting names" option enabled
#    [Tags]  311488         P0
#    [Setup]    Testcase Setup   count=2
#    Enable show meeting names     device=device_1
#    Join Meeting    device=device_1,device_2     meeting=hide_meeting_names
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    navigate to calendar tab        device=device_1
#    navigate to calendar tab        device=device_2
#    Verify meeting under all day event  device=device_1     meetings=hide_meeting
#    Verify meeting under all day event  device=device_2     meetings=hide_meeting
#    join meeting from all day meeting tab   device=device_1,device_2     meeting=hide_meeting
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Test Case Teardown   devices=device_1,device_2
#
#
#TC11 :[CAP Policy] CAP user sign out
#    [Tags]  308934     bvt_pr      32_bvt  alt_blocked
#    [Setup]   Testcase Setup for CAP User   count=1
#    sign out method    device=device_1
#    [Teardown]  Run Keywords  Capture on Failure     AND    sign in method     device_1     user=cap_search_enabled
#
#
#TC4 : [CAP Policy] CAP user receives call from another user
#    [Documentation]  Primary CAP account
#    [Tags]  308942   P1  alt_blocked
#    [Setup]   Testcase Setup for CAP User   count=2
#    click on calls tab   device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC1 : [CAP Policy] CAP user makes a call to PSTN user
#    [Documentation]  Primary CAP account, Secondary PSTN Account
#    [Tags]  308948  cap_policy_pstn   bvt_pr       33_bvt  alt_blocked
#    [Setup]   Testcase Setup for CAP PSTN User   count=2
#    navigate to people tab from home screen for cap    device=device_1
#    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC2 : [CAP Policy] CAP user receives a call from PSTN user
#    [Tags]  308951   cap_policy_pstn         bvt_pr       33_bvt  alt_blocked
#    [Setup]   Testcase Setup for CAP PSTN User   count=2
#    click on calls tab   device=device_2
#    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC8 : [CAP Policy] CAP user blind transfers TDC call to another TDC user
#    [Tags]  308956      32_bvt  alt_blocked
#    [Setup]   Testcase Setup for CAP User   count=3
#    navigate to people tab from home screen for cap    device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Verify Call State    device_list=device_1    state=Disconnected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC4 : [CAP Policy] CAP user consult transfer TDC call to PSTN user
#    [Tags]  308958   cap_policy_pstn                33_bvt  alt_blocked
#    [Setup]   Testcase Setup for CAP PSTN User   count=3
#    navigate to people tab from home screen for cap    device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Consult first to transfer the call using phonenumber  from_device=device_1      to_device=device_2:pstn_user
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Completes the consultation to accept the call     from_device=device_1      to_device=device_3
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC10 :[CAP Policy] CAP user parks and retrieve a TDC call
#    [Documentation]  Devices are already signed-in in Suite Setup
#    [Tags]  308965      32_bvt  alt_blocked
#    [Setup]   Testcase Setup for CAP User   count=2
#    click on calls tab   device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    ${call_park_code}=    call park and get the code    device=device_1
#    Unpark Call    ${call_park_code}    device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords  Capture on Failure  AND   Cancel Parked Call  device=device_1    AND    Come back to home screen    device_list=device_1,device_2
#
#TC4 : [Call views] Calls App should change to respective view as per the option selected in "Default view"
#    [Tags]   309995     P1   alt_credentials
#    [Setup]    Testcase Setup    count=1
#    Select default view value     device=device_1     option=recent call history
#    Validate calls tab after default value change    device=device_1     default_option=recent call history
#    go back to previous page     device=device_1
#    Select default view value     device=device_1     option=speed dial
#    Validate calls tab after default value change    device=device_1      default_option=speed dial
#    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1
#
#TC2 : [CAP Policy] User SignIn and sign out intent.
#    [Tags]      308975   P0      Certification_audio
#    [Setup]    Testcase Setup   count=1
#    Reset Logcat Capture    device=device_1
#    Sign Out    device_list=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Intents      device=device_1     intent=sign_out     user=user
#
#    Sign In     device_list=device_1    user_list=cap_search_enabled
#    Wait for Some Time    time=${wait_time}
#    Verify Intents      device=device_1     intent=sign_in     user=cap_search_enabled
#
#    Sign Out    device_list=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Intents      device=device_1     intent=sign_out     user=cap_search_enabled
#
#    [Teardown]  Run Keywords    Capture on Failure  AND     Sign In     device_list=device_1    user_list=user
#
#TC2 : [People] DUT to be displayed with list of groups in people tab
#    [Tags]  309495     bvt_pr        alt_credentials        Certification_audio
#    [Setup]  Testcase Setup    count=1
#    Click on people tab    device=device_1
#    Click drop down menu and verify list of groups   device=device_1
#    Select group from drop down     device=device_1     group_name=All Contacts
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC1 : [Call hand off] Verify the banner "You're in a call on another device. Want to join on this one?" on DUT
#    [Tags]   311033     alt_credentials
#    [Setup]  Testcase Setup for Call hand off    count=3
#    click on calls tab   device=device_3
#    Make outgoing call using display name    from_device=device_3      to_device=device_2
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Verify call hand off banner     device=device_1
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2,device_3
#
#TC9 : [CQ]When another CQ agent picks up the call, that the call ended notification should not display
#    [Tags]  311036       alt_blocked
#    [Setup]  Testcase Setup for CQ PSTN User   count=3
#    click on calls tab   device=device_2
#    Place call to phone num    from_device=device_2      phone_num=CQ_no
#    Wait till incoming call visibility    device=device_1,device_3
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND     Test Case Teardown    devices=device_1,device_2,device_3
#
#TC2 : [CAP] Search option should not be present when DUT user signed in to search disabled account
#    [Tags]  312062   P0
#    [Setup]   Testcase Setup for CAP Search Disable User    count=2
#    Verify search option is disabled    device=device_1
#    auto dial edited valid num from dial pad    from_device=device_1     to_device=device_2
#    accept incoming call    device=device_2
#    verify call state   device_list=device_1,device_2       state=connected
#    verify call transfer option in CAP search disabled user     device=device_1
#    disconnect call     device=device_2
#    verify call state   device_list=device_1,device_2       state=disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2
#
#TC22 : [ODS] - All policies enabled
#    [Tags]      453405     bvt_pr     phonesCY23_4
#    [Setup]  Testcase Setup  count=1
#    verify send feedback page   device=device_1
#    give feedback to microsoft  device=device_1
#    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1
#
#TC5 : [Presence] Presence changes to "In a call" from available when the user makes a call
#    [Tags]  307518    40_bvt  alt_credentials
#    [Setup]  Testcase Setup    count=2
#    Select user presence   device=device_1     state=Available
#    Verify user presence   device=device_1     state=Available
#    click on calls tab   device=device_1
#    Make outgoing call using from call icon    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Verify user presence from other user    from_device=device_2      to_device=device_1     state=In call
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    Wait for Some Time    time=${wait_time}
#    Verify user presence from other user    from_device=device_2      to_device=device_1     state=Available
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC1 : [Appearance] DUT user can enable Dark/Light theme on the device
#    [Documentation]  Devices are already signed-in in Suite Setup
#    [Tags]  309060     bvt_pr     14_bvt  alt_credentials        Certification_audio
#    [Setup]  Testcase Setup    count=1
#    verify and enable dark theme     device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND    verify and disable dark theme     device=device_1
#
#TC15 : [Home Screen] DUT user should not get the Home screen option when it is disabled by the Admin
#    [Tags]   310607     20_bvt  alt_blocked
#    [Setup]   Testcase Setup for CAP User   count=1
#    Verify home screen is disabled     device=device_1
#    Verify teams app have global search option   device_list=device_1
#    [Teardown]   Capture on Failure
#
#TC6 : [Docked uBar] User to verify the show/hide behavior of call control bar
#    [Tags]    316255   P0
#    [Setup]  Testcase Setup    count=2
#    Join Meeting    device=device_1,device_2     meeting=meeting_dut
#    verify meeting state   device_list=device_1,device_2       state=connected
#    verify call control bar in meeting   device=device_1
#    End meeting        device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]    Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2
#
#TC1 : [CQ] Agent picks up the call from a TDC user
#    [Tags]  309088                31_bvt  alt_blocked      Certification_audio
#    [Setup]  Testcase Setup for CQ User   count=3
#    click on calls tab   device=device_2
#    Place call to phone num    from_device=device_2      phone_num=CQ_no
#    Wait till incoming call visibility    device=device_1,device_3
#    Pick incoming call    device=device_1
#    Verify Any Incoming Call Disappeared    device=device_3
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND     Test Case Teardown    devices=device_1,device_2,device_3
#
#TC2 : [Calendar] Verify the details for a meeting entry
#    [Tags]  307061   bvt_pr  alt_bug
#    [Setup]  Testcase Setup    count=1
#    Navigate to Calendar tab   device=device_1
#    Select Meeting      device=device_1
#    Select See More Option      device=device_1
#    Verify Meeting has description     device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1
#
#TC4 : [Calendar] Calendar tab should refresh automatically and sync the new meeting entry
#    [Tags]  307067   bvt_pr  alt_bug        Certification_audio
#    [Setup]  Testcase Setup    count=2
#    create meeting  device=device_2     participants=device_1       meeting=Sync_meeting_2
#    Wait for Some Time    time=${wait_time}
#    Refresh for Meeting Visibility      device=device_1
#    Wait until Meeting is Reflected     device=device_1    meeting=Sync_meeting_2
#    [Teardown]  Run Keywords    Capture on Failure      AND     Test Case Teardown without deleting meeting   devices=device_1,device_2
#
#TC6 : [Hot Desking] Check user warning message for Hot Desk time remaining.
#    [Tags]   309121      alt_blocked
#    [Setup]  Testcase Setup    count=2
#    Hot desking signin   device=device_1     hot_desk_account=device_2
#    Wait for Some Time    time=${6m_wait_time}
#    Verify hotdesking automatic timeout warning    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND   End hot desk    device=device_1
#
#TC1 : [GCP] DUT user gets the incoming forwarded group call notification
#    [Tags]  308618   GCP          alt_blocked
#    [Setup]     Testcase Setup for GCP User   count=3
#    click on calls tab   device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
#    Verify call notification    device=device_2     status=appear
#    Pick incoming call from call notification    device=device_2
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]  run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1,device_2,device_3
#
#
#TC4 : [Calendar] DUT user can Far mute TDC in a conference call
#    [Tags]  307083    alt_bug        Certification_audio
#    [Setup]  Testcase Setup    count=2
#    join meeting   device=device_1      meeting=test_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state    device_list=device_1    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Unmutes the meeting    device=device_1
#    Farmute the call    from_device=device_1      to_device=device_2
#    Verify meeting Mute State    device_list=device_2    state=mute
#    End meeting     device=device_1,device_2
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2
#
#TC22:[Busy on Busy][Meeting] Verify DUT user should get the incoming call,When user selects New calls ring me under When in another call in Calling
#    [Tags]      451986    phonesCY23_4
#    [Setup]  Testcase Setup    count=3
#    select the options inside when in another call option   device=device_1     option=new_calls_ring_me
#    Come back to home screen    device_list=device_1
#    Join Meeting    device=device_1,device_2     meeting=tdc_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Make outgoing call using display name    from_device=device_3     to_device=device_1
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    verify meeting hold banner when user in call  device=device_1            meeting=tdc_meeting
#    Disconnect call     device=device_2,device_3,device_1
#    Verify Call State    device_list=device_1,device_2,device_3      state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND  select the options inside when in another call option   device=device_1     option=new_calls_ring_me   AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC27:[Busy on Busy][Call] Verify Unanswered Call is forwarded to Voicemail, When user selects Redirect as if a call is unanswered under When in another call in Calling
#    [Tags]      451988    phonesCY23_4
#    [Setup]   Run Keywords   Testcase Setup    count=4   AND    Enable unanswered call to voicemail      from_device=device_1     contact_device=device_2
#    select the options inside when in another call option   device=device_1     option=redirect_unanswered_call
#    Come back to home screen    device_list=device_1
#    navigate to calendar tab    device=device_1
#    Join Meeting    device=device_1,device_3     meeting=tdc_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_3   state=Connected
#    click on calls tab        device=device_2
#    Make outgoing call using display name    from_device=device_3      to_device=device_1
#    Verify Call State    device_list=device_3   state=Connected
#    Wait for Some Time    time=${wait_time}
#    Disconnect call     device=device_3,device_1
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    go back to previous page  device=device_1
#    navigate to calls tab  device=device_1
#    Verify call entries are synced in call log    from_device=device_1      to_device=device_3      state=forwarded_to
#    Navigate to voicemail tab    device=device_1
#    verify first voicemail displayname  to_device=device_1  from_device=device_3
#    [Teardown]   Run Keywords    Capture on Failure    AND      select the options inside when in another call option   device=device_1     option=new_calls_ring_me   AND      verify and disable call forwarding    device=device_1   AND         Come back to home screen    device_list=device_1,device_2,device_3,device_4
#
#TC2 : [Hot Desking] Hot desk user can access app settings option
#    [Tags]   309146       alt_blocked
#    [Setup]  Testcase Setup    count=2
#    Hot desking signin   device=device_1     hot_desk_account=device_2
#    Verify hot desking mode  device=device_1
#    Verify settings page in HD mode    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2     AND   End hot desk    device=device_1
#
#TC 13: [Light weight meeting] Verify start recording option in a meeting.
#    [Tags]   401822      P1
#    [Setup]   Testcase Setup    count=2
#    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
#    Wait for Some Time    time=${wait_time}
#    verify meeting state   device_list=device_1,device_2       state=connected
#    start recording call    device=device_1
#    verify recording notification on screen     device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2
#
#TC5 : [Structured Meetings] No other user "Presenter/Attendee" can change the role of organizer
#    [Tags]   320942    p0  sanity_tp
#    [Setup]  Testcase Setup    count=3
#    Join Meeting    device=device_1,device_2,device_3     meeting=test_meeting1
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    verify no option to change organizer role  from_device=device_1    to_device=device_2
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3
#
#TC14 : [Esc to Conf.] DUT user to add TDC again to the call
#    [Tags]  307126    esc_to_cnf        alt_blocked
#    [Setup]  Testcase Setup for PSTN User    count=3
#    Click on calls tab   device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn_user
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    verify participant list     from_device=device_1      connected_device_list=device_1,device_2:pstn_user,device_3
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_3     state=Disconnected
#    Verify Call State    device_list=device_1,device_2     state=Connected
#    verify participant list     from_device=device_1      connected_device_list=device_1,device_2:pstn_user
#    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_3
#    Wait for Some Time    time=${wait_time2}
#    Pick incoming call    device=device_3
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Disconnect call     device=device_1,device_3
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC1 : [CAP Policy] Sign in with CAP user
#    [Tags]  309691    bvt_pr      32_bvt  alt_blocked
#    [Setup]   Testcase Setup for CAP User   count=1
#    Verify that sign in is successful   device_list=device_1     state=Sign in
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1
#
#TC7 : [Outgoing Calls] DUT user calls multiple users [group call]
#    [Tags]  309709   P1
#    [Setup]  Testcase Setup    count=3
#    verify is portrait device       device=device_1
#    click on calls tab   device=device_1
#    make multiple outgoing calls using call icon     from_device=device_1        to_devices=device_2,device_3
#    pick incoming call      device=device_2
#    pick incoming call      device=device_3
#    verify call state   device_list=device_1,device_2,device_3    state=connected
#    disconnect call     device=device_1,device_2
#    verify call state   device_list=device_1,device_2,device_3    state=disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2,device_3
#
#TC2 : [Outgoing Calls] DUT user call is rejected by TDC
#    [Tags]  309719    bvt_pr  alt_credentials
#    [Setup]  Testcase Setup    count=2
#    click on calls tab  device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    verify incoming call  device=device_2   status=appear
#    Rejects the incoming call    device_list=device_2
#    Verify Call State    device_list=device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC4 : [Outgoing Calls] Call controls during the call
#    [Tags]  309730   bvt_pr  alt_bug
#    [Setup]  Testcase Setup    count=2
#    click on calls tab   device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Verify call control visibility    device_list=device_1,device_2
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2
#
#TC18 : [7 inch and above] Verify DUT user can select Expanded Dialpad as default view under Calling setting.
#    [Tags]      417251    P0
#    [Setup]     Testcase Setup    count=1
#    ${landscape_mode_flag}   is screen size 7 inch or more  device=device_1
#    pass execution if   '${landscape_mode_flag}'=='False'  device_1, device screen size have less then 7 inch
#    Verify Default view relaunches after changing the value     device=device_1     option=expanded_dialpad
#    Validate calls tab after default value change    device=device_1     default_option=expanded_dialpad
#    [Teardown]    Check device screen size and teardown
#
#TC12 : [OBO]DUT user to change call settings from DUT for People you support
#    [Tags]  310241   bvt_pr        alt_blocked
#    [Setup]   Testcase Setup for Delegate User  count=3
#    Click on calls tab   device=device_2
#    Validate People you support tab     device=device_2
#    Change call settings for boss and verify    device=device_2:delegate_user     boss=device_1    call_setting=call_forward      contact_point=voicemail
#    Validate People you support tab     device=device_2
#    Change call settings for boss and verify    device=device_2:delegate_user     boss=device_1    call_setting=call_forward      contact_point=my_delegates
#    Validate People you support tab     device=device_2
#    Change call settings for boss and verify    device=device_2:delegate_user     boss=device_1    call_setting=call_forward      contact_point=device_3
#    Validate People you support tab     device=device_2
#    Change call settings for boss and verify    device=device_2:delegate_user     boss=device_1    call_setting=call_forward      contact_point=off
#    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2    AND     verify and disable call forwarding    device=device_1
#
#TC19 : [7inch and above] Verify Home screen when Expanded Dialpad is selected as default view.
#    [Tags]      417256    P0
#    [Setup]     Testcase Setup    count=1
#    ${landscape_mode_flag}   is screen size 7 inch or more  device=device_1
#    pass execution if   '${landscape_mode_flag}'=='False'  device_1, device screen size have less then 7 inch
#    Verify Default view relaunches after changing the value     device=device_1     option=expanded_dialpad
#    Validate calls tab after default value change    device=device_1     default_option=expanded_dialpad
#    go back to previous page     device=device_1
#    verify call tab in expanded dialpad     device=device_1
#    [Teardown]    Check device screen size and teardown
#
#TC20 : [7 inch and above] Verify Numeric Dialpad is working fine when Expanded dial pad is selected as default view.
#    [Tags]      417259    P0
#    [Setup]     Testcase Setup    count=1
#    ${landscape_mode_flag}   is screen size 7 inch or more  device=device_1
#    pass execution if   '${landscape_mode_flag}'=='False'  device_1, device screen size have less then 7 inch
#    Verify Default view relaunches after changing the value     device=device_1     option=expanded_dialpad
#    Validate calls tab after default value change    device=device_1     default_option=expanded_dialpad
#    go back to previous page     device=device_1
#    dial and verify the numbers from 0 to 9     device_list=device_1
#    [Teardown]    Check device screen size and teardown
#
#TC32 : [7 inch and above] Verify user able to make PSTN call when Expanded dial pad is selected as default view.
#    [Tags]      417260    P0
#    [Setup]  Testcase Setup for PSTN User   count=2
#    ${landscape_mode_flag}   is screen size 7 inch or more  device=device_1
#    pass execution if   '${landscape_mode_flag}'=='False'  device_1, device screen size have less then 7 inch
#    Verify Default view relaunches after changing the value     device=device_1     option=expanded_dialpad
#    Validate calls tab after default value change    device=device_1     default_option=expanded_dialpad
#    go back to previous page     device=device_1
#    calling with dailpad        from_device=device_1     to_device=device_2:pstn_user
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Wait for Some Time    time=${wait_time}
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]    Check device screen size and teardown
#
#TC21 :[7 inch and above] Verify that Dark theme works fine in in-call dial pad.
#    [Tags]      417265    P0
#    [Setup]     Testcase Setup    count=2
#    ${landscape_mode_flag}   is screen size 7 inch or more  device=device_1
#    pass execution if   '${landscape_mode_flag}'=='False'  device_1, device screen size have less then 7 inch
#    Verify Default view relaunches after changing the value     device=device_1     option=expanded_dialpad
#    Validate calls tab after default value change    device=device_1     default_option=expanded_dialpad
#    go back to previous page     device=device_1
#    verify and enable dark theme     device=device_1
#    Make outgoing call using from dial pad   from_device=device_1     to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Wait for Some Time    time=${wait_time}
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]    Run Keywords   Capture on Failure    AND      Teardown for Dark Theme Disable
#
#TC5 : [Calendar] DUT user to mute all the audience
#    [Tags]  307710    alt_bug      Certification_audio
#    [Setup]   Testcase Setup    count=3
#    Join Meeting   device=device_1      meeting=test_meeting
#    Wait for Some Time    time=${wait_time}
#    Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3
#    Pick incoming call    device=device_2,device_3
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    Mute all participants       device=device_1
#    Verify meeting Mute State    device_list=device_2,device_3    state=Mute
#    Unmutes the meeting     device=device_2
#    Verify meeting Mute State    device_list=device_2    state=unmute
#    End meeting     device=device_1,device_2,device_3
#    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3
#
#TC2 : [Call Hold] Teams App holds the call with Teams client for 1 minutes
#    [Tags]  146235     alt_credentials
#    [Setup]  Testcase Setup    count=2
#    click on calls tab   device=device_1
#    Make outgoing call using display name    from_device=device_1     to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Hold the call   device=device_1
#    Verify Call State    device_list=device_1     state=Hold
#    Wait for Some Time    time=${60s_wait_time}
#    Resume the call   device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2     state=Resume
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC6 : [Emergency Calling] DUT should not have call parking option for Emergency calls.
#    # Dial 933 for Emergency Calling
#    [Tags]  309280   P3  alt_blocked
#    [Setup]  Testcase Setup    count=1
#    Click on calls tab   device=device_1
#    Dial emergency num and validate    device=device_1
#    Validate Call Park for Emergency Calling     device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1
#
#TC10 : [CAP] CAP user to search for TDC user
#    [Tags]   311328   P2
#    [Setup]   Testcase Setup for CAP User   count=1
#    navigate to people tab from home screen for cap    device=device_1
#    Search for TDC user    from_device=device_1      to_device=device_2
#    Verify contact page details   device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC15 : [Calls] Favorites & Recent tabs
#    [Tags]  309286      calls   P2  alt_credentials     Certification_audio
#    [Setup]    Testcase Setup    count=1
#    Click on calls tab   device=device_1
#    Verify call history log    device=device_1
#    Navigate to Calls Favorites page    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC11 :[CAP] User to verify the Call Park option
#    [Tags]  311338    P1
#    [Setup]   Testcase Setup for CAP User   count=2
#    navigate to people tab from home screen for cap    device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    ${call_park_code}=    call park and get the code    device=device_1
#    Unpark Call    ${call_park_code}    device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    verify call park cancel button    ${call_park_code}   device=device_1
#    [Teardown]  Run Keywords  Capture on Failure  AND   Cancel Parked Call  device=device_1    AND    Come back to home screen    device_list=device_1,device_2
#
#TC1 : [CAP Policy] CAP user UI verification
#    [Tags]  311342   P1  bvt_pr  alt_blocked
#    [Setup]   Testcase Setup for CAP User   count=1
#    Verify user have dial pad on screen     device_list=device_1
#    navigate to people tab from home screen for cap  device=device_1
#    Verify teams app have global search option   device_list=device_1
#    Verify teams app have call park capability   device_list=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1
#
#TC17 : [Calls] Remove contacts from favorites
#    [Tags]    309297    156788    calls     P2  alt_bug
#    [Setup]  run keywords   Testcase Setup    count=2   AND     Make outgoing call for call log   from_device=device_1     to_device=device_2
#    Select call list item   device=device_1  item=favorite
#    Verify added favorite user in favorites page    from_device=device_1     to_device=device_2
#    Remove favorite user from favorites page    from_device=device_1     to_device=device_2
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC18 : [Calls] Access contact profile from favorites
#    [Tags]      309300    calls     P2  alt_bug
#    [Setup]   run keywords    Testcase Setup    count=2    AND   Make outgoing call for call log   from_device=device_1     to_device=device_2
#    Select call list item   device=device_1  item=favorite
#    Verify added favorite user in favorites page    from_device=device_1     to_device=device_2
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC13 : [Calls] Calling from Recent tab
#    [Tags]  309306      calls   P2  alt_credentials
#    [Setup]     run keywords   Testcase Setup    count=2   AND     Make outgoing call for call log   from_device=device_1     to_device=device_2
#    Navigate to calls tab   device=device_1
#    Call first participant from log    device=device_1
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC12 : [Call view] Verify that Default view screen settings should not work for CAP policy user
#    [Tags]  319549    P2
#    [Setup]   Testcase Setup for CAP User   count=1
#    verify call views option under calling settings for CAP policy user for audio phones    device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC14 : [Calls] Access contact profile from Recent
#    [Tags]  309309      calls   P2  alt_credentials
#    [Setup]     run keywords   Testcase Setup    count=2   AND  Make outgoing call for call log   from_device=device_1     to_device=device_2
#    Select call list item   device=device_1  item=view profile
#    Verify contact card page and call   device=device_1
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC3 : [OBO] DUT user to display the delegates on the favorites screen.
#    [Tags]  309313   P1  alt_blocked        Certification_audio
#    [Setup]   Testcase Setup for Delegate User  count=2
#    Navigate to Calls Favorites page    device=device_2
#    Validate People you support tab     device=device_2
#    Navigate to Calls Favorites page    device=device_1
#    Validate delegates tab     device=device_1
#    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2
#
#TC1 : [Advanced Calling] DUT(Delegate) user tap on the More info icon on Boss.
#    [Tags]   311371      P1
#    [Setup]  Testcase Setup for Delegate User  count=3
#    click on calls tab  device=device_2
#    Initiate OBO call and verify boss list  from_device=device_2     to_device=device_3     obo_option=device_1     boss_list=device_1
#    Verify Incoming call    device=device_3    status=appear
#    Pick incoming call    device=device_3
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    wait for some time  ${wait_time}
#    navigate to calls favorites page   device=device_1
#    verify and join call using join call in more option with boss and delegate   from_device=device_1      to_device=device_3        option=verify
#    disconnect call    device=device_2
#    Verify Call State    device_list=device_2,device_3    state=disconnected
#    [Teardown]  run keywords  Capture on Failure    AND    check call dropdown menu state   device=device_1    AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC3 : [Advanced Calling] DUT user tap on More info icon
#    [Tags]      311375      P1
#    [Setup]  Testcase Setup for Delegate User  count=3
#    click on calls tab  device=device_3
#    Make outgoing call using display name    from_device=device_3     to_device=device_2:delegate_user
#    Verify Incoming call    device=device_2    status=appear
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    wait for some time  ${wait_time}
#    navigate to calls favorites page   device=device_1
#    verify and join call using join call in more option with boss and delegate   from_device=device_1      to_device=device_3        option=verify
#    wait for some time  ${wait_time}
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    disconnect call    device=device_3
#    Verify Call State    device_list=device_2,device_3    state=disconnected
#    [Teardown]  run keywords  Capture on Failure    AND    check call dropdown menu state   device=device_1    AND    Come back to home screen   device_list=device_1,device_2,device_3
#
#TC4 : [Advanced Calling] DUT user tap on join call option
#    [Tags]      311377   P1
#    [Setup]  Testcase Setup for Delegate User  count=3
#    click on calls tab  device=device_3
#    Make outgoing call using display name    from_device=device_3     to_device=device_2:delegate_user
#    Verify Incoming call    device=device_2    status=appear
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    wait for some time  ${wait_time}
#    navigate to calls favorites page   device=device_1
#    verify and join call using join call in more option with boss and delegate   from_device=device_1      to_device=device_2:delegate_user
#    wait for some time  ${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    disconnect call    device=device_1,device_2
#    Verify Call State    device_list=device_1,device_2,device_3    state=disconnected
#    [Teardown]  run keywords  Capture on Failure    AND    check call dropdown menu state   device=device_1    AND    Come back to home screen   device_list=device_1,device_2,device_3
#
#TC3 : [OBO] DUT user to set delegates.
#    [Tags]    309336     P1  alt_blocked        Certification_audio
#    [Setup]    Testcase Setup for Delegate User  count=3
#    verify added delegate user with presence in favorites page      from_device=device_1    to_device=device_3
#    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1
#
#TC7 : [Calendar] Teams App user remove the cancelled meeting from meeting tab
#    [Tags]  147562     P2  alt_bug
#    [Setup]       Testcase Setup   count=2
#    Create meeting   device=device_2    meeting=device_meeting1     participants=device_1
#    Refresh for Meeting Visibility      device=device_1
#    delete specific meeting    device=device_2    meeting=device_meeting1
#    Refresh main tab    device=device_1
#    Select Meeting      device=device_1    meeting=Canceled: device_meeting1
#    Remove meeting from calender   devices=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND     Test Case Teardown without deleting meeting   devices=device_1,device_2
#
#TC12 : [OBO] DUT user to delete the delegates from change delegates.
#    [Tags]    309360     P1  alt_blocked
#    [Setup]    Testcase Setup for Delegate User  count=3
#    Navigate to Calls Favorites page    device=device_2,device_3
#    Validate People you support tab     device=device_2,device_3
#    change delegates for boss and verify    device=device_2    boss=device_1    delegate=device_3    action=delete
#    [Teardown]  run keywords  Capture on Failure   AND   Come back to home screen     device_list=device_1,device_2,device_3
#
#TC10 : [Calendar] Teams App user joins the meeting scheduled by another Teams App user by dialing into meeting info
#    [Tags]  147568  P1  alt_bug
#    [Setup]    Testcase Setup   count=2
#    navigate to calendar tab    device=device_1
#    Wait for Some Time    time=${wait_time}
#    ${phone_no}     ${conference_id}     Get meeting conference id   device=device_1    meeting=meeting_dut
#    Join meeting   device=device_1    meeting=meeting_dut
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1    state=Connected
#    join meeting by dial in conference   device_2     ${phone_no}     ${conference_id}
#    Wait for Some Time    time=${20s_wait_time}
#    Verify lobby notification    devices=device_1
#    View lobby and select option    from_device=device_1     option=admit
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2
#
#TC13 : [OBO] DUT user to change the delegate of the delegate user.
#    [Tags]  309369   P2
#    [Setup]   Testcase Setup for Delegate User  count=3
#    Click on calls tab   device=device_2
#    Validate People you support tab     device=device_2
#    Change delegates for boss and verify    device=device_2   boss=device_1   delegate=device_3
#    [Teardown]  run keywords  Capture on Failure   AND   Delete delegate from manage delegate   from_device=device_1    to_device=device_3    AND    Come back to home screen   device_list=device_1,device_2
##PORTRAIT mode phone test case
#TC28 : [Call views] Teams App user makes an outgoing call
#    [Tags]   204929     P2  alt_blocked
#    [Setup]    Testcase Setup for PSTN User   count=2
#    ${prt_mode_flag}   is portrait mode cnf device  device=device_1
#    pass execution if   '${prt_mode_flag}'=='False'  device_1, device is not a portrait mode device
#    Select default view value     device=device_1   option=dialpad
#    Validate calls tab after default value change    device=device_1      default_option=dialpad
#    go back to previous page     device=device_1
#    Make outgoing call using from dial pad   from_device=device_1     to_device=device_2:pstn_user
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    Select default view value     device=device_1     option=recent call history
#    Navigate to calls tab   device=device_1
#    Call first participant from log    device=device_1
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]    Check device orientation and teardown
#
#TC5 : [Hard Mute] Verify when hard mute is turned on display mic state clearly next to all participants
#    [Tags]    311427    p2
#    [Setup]  Testcase Setup   count=2
#    Join Meeting    device=device_1,device_2       meeting=Hard_and_reaction
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    verify manage audio and video option    device=device_2    count=2   role=presenter
#    verify manage audio and video option    device=device_1    count=2   role=organiser
#    verify participant list     from_device=device_1      connected_device_list=device_1,device_2
#    Verify meeting Mute State    device_list=device_1    state=mute
#    Verify meeting Mute State    device_list=device_2    state=mute
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC11 : [Hard Mute] Verify One attendee can view hand raised by another attendee
#    [Tags]      311435       p2
#    [Setup]  Testcase Setup   count=2
#    join meeting   device=device_1,device_2    meeting=Hard_and_reaction
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    verify participant list   from_device=device_1  connected_device_list=device_1,device_2
#    Make an attendee    from_device=device_1      to_device=device_2
#    Verify you are an attendee now notification     device=device_2
#    Raise hand     device=device_2
#    Verify raise hand    from_device=device_2    to_device=device_1      status=on
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC 25: [Hard Mute] Verify that attendee get a proper message when hand is lowered by organizer.
#    [Tags]      311437       p2
#    [Setup]  Testcase Setup   count=2
#    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
#    Wait for Some Time    time=${wait_time}
#    verify meeting state   device_list=device_1,device_2       state=connected
#    verify lightweight meeting ui   device=device_1     participants=device_2
#    Make an attendee    from_device=device_2       to_device=device_1
#    Verify you are an attendee now notification     device=device_1
#    Raise hand     device=device_1
#    Verify raise hand    from_device=device_1   to_device=device_2    status=on
#    verify and lower hand for attendee  from_device=device_2   to_device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2
#
#TC6 : [Hard Mute] Presenter/organizer can provide individual restrictions to users
#    [Tags]  311439   p2
#    [Setup]  Testcase Setup   count=2
#    Join Meeting    device=device_1,device_2       meeting=Hard_and_reaction
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    verify manage audio and video option    device=device_2    count=2   role=presenter
#    verify manage audio and video option    device=device_1    count=2   role=organiser
#    Make an attendee    from_device=device_1       to_device=device_2
#    Verify you are an attendee now notification     device=device_2
#    verify and allow individual permissions to attendees   from_device=device_1       to_device=device_2
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC1 : [Dark Theme] DUT user can disable Dark theme on the device
#    [Documentation]  Devices are already signed-in in Suite Setup
#    [Tags]  319636      319636    P2  alt_credentials
#    [Setup]   Run Keywords   Testcase Setup    count=1   AND    verify and enable dark theme     device=device_1
#    verify and disable dark theme     device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC4 : [Hard Mute] Verify the participants mic and camera status in the meeting
#    [Tags]  311446   p2
#    [Setup]  Testcase Setup   count=2
#    Join Meeting    device=device_1,device_2       meeting=Hard_and_reaction
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    verify participant list   from_device=device_1   connected_device_list=device_1,device_2
#    Verify meeting Mute State    device_list=device_1,device_2    state=mute
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC7 : [Live Caption 1:1 call] Verify that user is getting "Turn On Live Captions" option in the more(...) option of 1:1 call
#    [Tags]  311447   P1
#    [Setup]  Testcase Setup    count=2
#    Make outgoing call using display name  from_device=device_1   to_device=device_2
#    pick incoming call  device=device_2
#    wait for some time  ${wait_time}
#    verify call state    device_list=device_1,device_2    state=Connected
#    wait for some time  ${wait_time}
#    Verify Live Caption visibility      device=device_1
#    disconnect call  device_1
#    verify call state    device_list=device_1,device_2    state=Disconnected
#    [Teardown]  run keywords  Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2
#
#TC5 : [Hot Desking] Display of Hot Desking mode on Home screen, when clicked on settings.
#    [Tags]   147609     P1  alt_blocked
#    [Setup]  Testcase Setup    count=2
#    Hot desking signin   device=device_1     hot_desk_account=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify hot desking mode  device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND     End hot desk    device=device_1
#
#TC16 : [Hot Desking] Different user can sign out Hot Desking session.
#    [Tags]   147625     P2  alt_blocked
#    [Setup]  Testcase Setup    count=2
#    Hot desking signin    device=device_1     hot_desk_account=device_2
#    Wait for some time   time=${wait_time}
#    Verify hot desking mode     device=device_1
#    Sign out from settings page    device=device_1
#    Validate username after signed out from settings page    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC1 : [Emergency Calling] DUT to auto dial the emergency number once the number is recognized as an emergency number
#    # Dial 933 for Emergency Calling
#    [Tags]  308524   147628    146949        bvt_pr  alt_blocked
#    [Setup]  Testcase Setup    count=1
#    Click on calls tab   device=device_1
#    Dial emergency num and validate    device=device_1
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1
#
#TC8 : [Hot Desking] Host user details should not be displayed, when signed in with Hot Desk User.
#    [Tags]   147630     P3  alt_blocked
#    [Setup]  Testcase Setup    count=2
#    Hot desking signin    device=device_1     hot_desk_account=device_2
#    Wait for some time   time=${wait_time}
#    Verify hot desking mode     device=device_1
#    Verify HD user details     device=device_1    hd_user=device_2
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1   AND    End hot desk    device=device_1
#
#TC8: [Meetings]Verify that no meeting name is shown in calendar or notification
#    [Tags]    311482        P2
#    [Setup]    Testcase Setup   count=2
#    navigate to calendar tab    device=device_1
#    verify meeting title shows meeting organizer name  device=device_1      organizer=device_2
#    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2
#
#TC20 : [Calendar] Teams App should not be displayed with event created for the recurring week, when no meeting is scheduled
#    [Tags]  147668   P2  alt_bug
#    [Setup]    Testcase Setup   count=1
#    create meeting  device=device_1   meeting=recurring_meeting3    repeat=Every week   date=forward date
#    Verify meeting should not be displayed   device=device_1      meeting=recurring_meeting3
#    [Teardown]  Run Keywords    Capture on Failure  AND   Test Case Teardown     devices=device_1
#
#TC14 : [Calendar] Teams App user should sync automatically when edited the meeting
#    [Tags]  147669   P2  alt_bug
#    [Setup]    Testcase Setup    count=3
#    create meeting   device=device_1    meeting=edit_meeting2   participants=device_2
#    Select Meeting      device=device_1        meeting=edit_meeting2
#    Verify invited user list in Meeting Details     from_device=device_1     participants=device_2
#    Edit meeting name and validate    device=device_1    new_meeting=edit_meeting2_edited
#    Wait for Some Time    time=${wait_time}
#    Select Meeting      device=device_1        meeting=edit_meeting2_edited
#    Edit the meeting and add new participant    device=device_1     participants=device_3
#    Select Meeting      device=device_1        meeting=edit_meeting2_edited
#    Verify invited user list in Meeting Details     from_device=device_1     participants=device_2,device_3
#    [Teardown]  Run Keywords    Capture on Failure  AND     Test Case Teardown without deleting meeting   devices=device_1
#
#TC19 : [Calendar] DUT user should receive any updates, after declining the meeting
#    [Tags]  147671   P2  alt_bug
#    [Setup]  Testcase Setup    count=2
#    create meeting  device=device_2     participants=device_1       meeting=Decline_meeting2
#    Navigate to Calendar tab   device=device_1
#    Refresh for Meeting Visibility      device=device_1
#    Select Meeting      device=device_1    meeting=Decline_meeting2
#    Check rsvp status   device=device_1
#    Respond to meeting     device=device_1     respond_option=Decline
#    Verify declined meeting should not visible    device=device_1    meeting=Decline_meeting2
#    Select Meeting      device=device_2    meeting=Decline_meeting2
#    Edit meeting name and validate    device=device_2    new_meeting=Decline_meeting2_edited
#    Refresh for Meeting Visibility      device=device_1
#    verify meeting is visible    device=device_1    meeting=Decline_meeting2_edited
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1,device_2

#TC27 : [Calendar] DUT user should not be allowed to create meeting in past time.
#    [Tags]  147673   P1  alt_bug
#    [Setup]    Testcase Setup   count=1
#    Verify user should not be allowed to create meeting in past time   device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND   Test Case Teardown without deleting meeting     devices=device_1
#
#TC15 : [Calendar] DUT user as participant should not be displayed with "Edit"and "Cancel"option
#    [Tags]  147674   P2  alt_bug
#    [Setup]     Testcase Setup   count=1
#    navigate to calendar tab    device=device_1
#    Refresh for Meeting Visibility      device=device_1
#    Select Meeting      device=device_1    meeting=test_meeting1
#    Verify user as participant should not be displayed with edit and cancel option    device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen     device_list=device_1
#
#TC6 : [Calendar] DUT user not allowed to save meeting, after removing all objects in edit mode.
#    [Tags]  147675   P1  alt_bug
#    [Setup]    Testcase Setup    count=2
#    create meeting  device=device_1       participants=device_2    meeting=device_meeting3
#    Select Meeting      device=device_1    meeting=device_meeting3
#    Verify user not allowed to save meeting after removing all objects in edit mode    device=device_1
#    [Teardown]  Run Keywords    Capture on Failure    AND    Test Case Teardown without deleting meeting     devices=device_1
#
#TC26 : [Calendar] DUT as organizer should not be allowed to be added as participant in meeting
#    [Tags]  147677   P2  alt_bug
#    [Setup]  Testcase Setup    count=2
#    Verify organizer should not be allowed to be added as participant in meeting     device=device_1     participant=device_1   meeting=organizer_meeting
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting   devices=device_1
#
#TC15 : [Calendar] DUT user should not be allowed to add participant who are already added into meeting
#    [Tags]  147678   P2  alt_bug
#    [Setup]    Testcase Setup   count=2
#    Verify user should not be allowed to add participant who are already added into meeting    device=device_1      participant=device_2        meeting=test_meeting
#    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen     device_list=device_1
#

#TC18 : [Calendar] Participant count updates, when organizer adds the participant after meeting is started
#    [Tags]  147680   P2  alt_bug
#    [Setup]   Testcase Setup    count=3
#    create meeting   device=device_1    meeting=add_Participant_meeting     participants=device_2
#    Join Meeting    device=device_1     meeting=add_Participant_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1    state=Connected
#    Check participant count in call     device=device_1      participant_list=device_1
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    pick incoming call    device=device_3
#    Verify meeting state   device_list=device_1,device_3    state=Connected
#    Check participant count in call     device=device_1      participant_list=device_1,device_3
#    End meeting     device=device_1,device_3
#    Verify Call State    device_list=device_1,device_3    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND     Test Case Teardown   devices=device_1,device_3
#
#TC6 :[Advance Calling] Boss should be able to get SLA pop up (Resume banner and Resume button)when delegates put their call on hold on behalf of boss
#    [Tags]      311522   P2
#    [Setup]  Testcase Setup for Delegate User  count=3
#    click on calls tab  device=device_3
#    Make outgoing call using display name   from_device=device_3   to_device=device_2:delegate_user
#    Verify Incoming call    device=device_2    status=appear
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    wait for some time  ${wait_time}
#    hold the call   device=device_2
#    verify call state   device_list=device_3   state=hold
#    wait for some time  ${wait_time}
#    navigate to calls favorites page   device=device_1
#    refresh calls main tab    device=device_1
#    verify and resume call using resume call in more option with boss or delegate   from_device=device_1      to_device=device_3       option=verify
#    disconnect call   device=device_3
#    verify call state   device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]  run keywords  Capture on Failure    AND    Come back to home screen   device_list=device_1,device_2,device_3
#
#TC9 : [Advance Calling]In delegates, Active call with a timer should disappear under the boss username after call disconnect from the boss
#    [Tags]      311534     P2
#    [Setup]  Testcase Setup for Delegate User  count=3
#    click on calls tab  device=device_2
#    Initiate OBO call and verify boss list  from_device=device_2     to_device=device_3     obo_option=myself     boss_list=device_1
#    Verify Incoming call    device=device_3    status=appear
#    Pick incoming call    device=device_3
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    wait for some time  ${wait_time}
#    navigate to calls favorites page   device=device_1
#    verify and join call using join call in more option with boss and delegate   from_device=device_1      to_device=device_3        option=verify
#    disconnect call    device=device_3
#    verify call state   device_list=device_2,device_3    state=Disconnected
#    wait for some time  ${wait_time}
#    Navigate to calendar tab   device=device_1
#    navigate to calls favorites page   device=device_1
#    verify join call option should not present inside the more icon of boss     from_device=device_1      to_device=device_3
#    [Teardown]  run keywords  Capture on Failure    AND    check call dropdown menu state   device=device_1    AND    Come back to home screen   device_list=device_1,device_2,device_3
#
#TC21 :[Advance Calling] When there are multiple boss, active call icon should display to the right boss
#    [Tags]      311540   P2
#    [Setup]  Testcase Setup for Delegate User  count=4
#    Add new delegates with both permission and validate   from_device=device_4    to_device=device_1
#    click on calls tab  device=device_2
#    Make outgoing call using display name    from_device=device_2     to_device=device_4
#    Pick incoming call    device=device_4
#    Verify Call State    device_list=device_2,device_4    state=Connected
#    navigate to calls favorites page   device=device_1
#    refresh calls main tab    device=device_1
#    verify and join call using join call in more option with boss and delegate   from_device=device_1      to_device=device_4        option=verify
#    disconnect call    device=device_2
#    Verify Call State    device_list=device_2,device_4    state=disconnected
#    [Teardown]  run keywords  Capture on Failure     AND    check call dropdown menu state   device=device_1    AND    Come back to home screen   device_list=device_1,device_2,device_3,device_4       AND      Delete delegate from manage delegate   from_device=device_4    to_device=device_1
#
#TC14 : [Advance Calling] Delegates must see active call with timer &Join option with dropdown over Boss's profile, when Boss receives an incoming call
#    [Tags]      311550   P2
#    [Setup]  Testcase Setup for Delegate User  count=3
#    click on calls tab  device=device_2
#    Make outgoing call using display name   from_device=device_2   to_device=device_3
#    Pick incoming call    device=device_3
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    navigate to calls favorites page   device=device_1
#    verify and join call using join call in more option with boss and delegate   from_device=device_1      to_device=device_3        option=verify
#    disconnect call    device=device_3
#    Verify Call State    device_list=device_2,device_3    state=disconnected
#    [Teardown]  run keywords  Capture on Failure     AND    check call dropdown menu state   device=device_1    AND    Come back to home screen   device_list=device_1,device_2,device_3
#TC7 : [HardMute]Verify that Hard mute slider availability (Organizer/Presenter) only
#    [Tags]  311558   p2
#    [Setup]  Testcase Setup   count=3
#    join meeting   device=device_1,device_2,device_3    meeting=Hard_and_reaction
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    verify participant list   from_device=device_1  connected_device_list=device_1,device_2,device_3
#    verify options to manage audio and video   device=device_1
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC12 : [Calls] Verify user contact from Recent tab
#    [Tags]  334088    P2
#    [Setup]     run keywords     Testcase Setup    count=2   AND     Make outgoing call for call log   from_device=device_2     to_device=device_1
#    verify latest call details     from_device=device_1    to_device=device_2
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#    TC8 :[Hard Mute]Verify that Hard mute slider is not available to Attendee
#    [Tags]  311560   p2
#    [Setup]  Testcase Setup   count=3
#    join meeting   device=device_1,device_2,device_3    meeting=Meeting_with_tdc
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    verify manage audio and video option    device=device_1    count=3   role=presenter
#    Make an attendee    from_device=device_2       to_device=device_1
#    Verify you are an attendee now notification     device=device_1
#    verify manage audio and video option  device=device_1    count=3     role=attendee
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#    TC9 :[Hard Mute]Verify that DUT user (Organizer/Presenter) Able to toggle hard mute slider
#    [Tags]  311562   p2
#    [Setup]  Testcase Setup   count=3
#    join meeting   device=device_1,device_2,device_3    meeting=Hard_and_reaction
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    verify manage audio and video option    device=device_1    count=3   role=organiser
#    Make an attendee    from_device=device_1       to_device=device_2
#    Verify you are an attendee now notification     device=device_2
#    Disable camera and mic for attendees    from_device=device_1      to_device=device_2    mic=off   camera=on
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC9 : [Calls] Verify DUT user able to search a contact from People tab
#    [Tags]  334091    P2
#    [Setup]     Testcase Setup    count=2
#    verify is portrait device       device=device_1
#    click on calls tab    device=device_1
#    verify options in make call icon    device=device_1
#    click back      device=device_1
#    verify and navigate to call plus icon people tab    device=device_1
#    get search text validate     from_device=device_1    to_device=device_2     verify_make_a_call_people_tab=on
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC10 :[HardMute]Verify Changes over at users when hard mute slider toggled ON(Presenter/Organizer)
#    [Tags]  311564     p2
#    [Setup]  Testcase Setup   count=3
#    join meeting   device=device_1,device_2,device_3    meeting=Hard_and_reaction
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    verify manage audio and video option    device=device_2    count=3   role=presenter
#    verify manage audio and video option    device=device_1    count=3   role=organiser
#    Make an attendee    from_device=device_1       to_device=device_2
#    Verify you are an attendee now notification     device=device_2
#    Disable camera and mic for attendees    from_device=device_1      to_device=device_2    mic=off   camera=on
#    verify participant list   from_device=device_1  connected_device_list=device_1,device_2,device_3
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC8 : [Calls] Verify people tab from Make a call tab
#    [Tags]  334096    P2
#    [Setup]     Testcase Setup    count=1
#    verify is portrait device       device=device_1
#    click on calls tab    device=device_1
#    verify options in make call icon    device=device_1
#    click back      device=device_1
#    verify and navigate to call plus icon people tab    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC11 : [People] DUT user should be able to decline the incoming call while creating new group in people tab
#    [Tags]  309604   P2  alt_credentials
#    [Setup]  Testcase Setup    count=2
#    Navigate to Create group screen     device=device_1
#    click on calls tab   device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Rejects the incoming call    device_list=device_1
#    Verify Call State    device_list=device_2     state=Disconnected
#    Verify create new group page    device=device_1
#    click cancel btn    device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND     check and close create new group window  device=device_1    AND    Come back to home screen    device_list=device_1,device_2
#
#TC13 : [People]DUT user to decline the incoming call while in "Add from Directory" page in people tab
#    [Tags]  309624   P2  alt_credentials
#    [Setup]  Testcase Setup    count=2
#    Navigate to Add from directory screen     device=device_1
#    click on calls tab   device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Rejects the incoming call    device_list=device_1
#    Verify Call State    device_list=device_2     state=Disconnected
#    Verify add from directory page    device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC 4: [Light weight meeting] Verify the raise hand in a meeting
#    [Tags]      401815     P2
#    [Setup]    Testcase Setup    count=2
#    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
#    verify meeting state   device_list=device_1,device_2       state=connected
#    verify lightweight meeting ui   device=device_1     participants=device_2
#    verify presence of reactions button in call control     device=device_1
#    Raise hand     device=device_1
#    Verify raise hand    from_device=device_1   to_device=device_2    status=on
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2
#
#TC 8: Verify Turn off live captions in a meeting
#    [Tags]   401818      P2
#    [Setup]   Testcase Setup    count=2
#    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
#    Wait for Some Time    time=${wait_time}
#    verify meeting state   device_list=device_1,device_2       state=connected
#    verify lightweight meeting ui   device=device_1      participants=device_2
#    turn on live caption and validate    device=device_1
#    turn off live caption and validate    device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2
#
#TC27 : [People] DUT user to receive a voicemail while adding contacts to group in people tab
#    [Tags]  309669   P2  alt_bug
#    [Setup]   Run Keywords    Testcase Setup    count=2    AND     Set Call Forwarding    device=device_1
#    ${voicemail_count_before_new_voicemail}=    Get unread voicemail count    device=device_1
#    Navigate to Add from directory screen     device=device_1
#    Send Voicemail      from_device=device_2   to_device=device_1
#    Wait for Some Time    time=${wait_time2}
#    Verify add from directory page    device=device_1
#    return to home screen    device_list=device_1
#    ${voicemail_count_after_new_voicemail}=    Get unread voicemail count    device=device_1
#    run keyword if  ${voicemail_count_before_new_voicemail}+1 == ${voicemail_count_after_new_voicemail}    Log   voicemail count got increased
#    ...   ELSE   fail   Unable to refresh automatically because Voicemail count didn't increase.
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND     verify and disable call forwarding   device=device_1
#
#TC 10: [Light weight meeting] Verify the mic status in a meeting.
#    [Tags]   401829      P1
#    [Setup]   Testcase Setup    count=2
#    Join Meeting    device=device_1,device_2     meeting=lightweight_meeting
#    Wait for Some Time    time=${wait_time}
#    verify meeting state   device_list=device_1,device_2       state=connected
#    verify lightweight meeting ui   device=device_1      participants=device_2
#    Verify meeting Mute State    device_list=device_1,device_2    state=mute
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2
#
#TC 20:[Lightweight meeting] Verify DUT has an option to spotlight DUT user.
#    [Tags]   401840    P2
#    [Setup]   Testcase Setup    count=3
#    Join Meeting    device=device_1,device_2,device_3     meeting=lightweight_meeting
#    Wait for Some Time    time=${wait_time}
#    verify meeting state   device_list=device_1,device_2,device_3       state=connected
#    verify lightweight meeting ui   device=device_1     participants=device_2
#    make an spotlight   from_device=device_2   to_device=device_1
#    verify spotlight icon for user   device=device_1
#    verify spotlight avatar   device_list=device_2
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen     device_list=device_1,device_2,device_3
#
#TC6 : [Livecaption]DUT user able to on and off the Live caption during the meeting
#    [Tags]    309688    P2  alt_bug     Certification_audio
#    [Setup]   Testcase Setup    count=2
#    Join Meeting    device=device_1,device_2     meeting=test_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Turn on live caption     device=device_1
#    Wait for Some Time    time=${wait_time}
#    Turn off live caption     device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]   run keywords   Capture on Failure    AND    Come back to home screen     device_list=device_1,device_2
#
#TC6 :[Outgoing Calls] DUT user calls Teams Client user from favorites tab
#    [Tags]  309693      outgoing_calls   P2  alt_credentials
#    [Setup]  Testcase Setup    count=2
#    Make outgoing call using from call icon    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC7: [Outgoing Calls] DUT user calls Teams Client user using Dialpad
#    [Tags]  309700      outgoing_calls  P2  alt_credentials
#    [Setup]   Run Keywords    Testcase Setup    count=2   AND    Click on calls tab   device=device_1
#    Make outgoing call using from dial pad   from_device=device_1     to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Verify Call control visibility      device_list=device_1
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    Verify Calls Navigation     device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC1: [Outgoing Calls] DUT user calls PSTN user from favorites tab
#    [Tags]  309703      outgoing_calls    P2  alt_blocked
#    [Setup]  Testcase Setup for PSTN User    count=2
#    Navigate to Calls Favorites page    device=device_1
#    Make outgoing call using from call icon    from_device=device_1      to_device=device_2:pstn_user
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    click back      device=device_1
#    Call first participant from log     device=device_1
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC2: [Outgoing Calls] DUT user calls PSTN user from Recent tab
#    [Tags]  309706      outgoing_calls  P2  alt_blocked
#    [Setup]  Testcase Setup for PSTN User    count=2
#    Click on calls tab   device=device_1
#    Make outgoing call using from call icon    from_device=device_1      to_device=device_2:pstn_user
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC3 : [Outgoing Calls] DUT user calls Teams Client user who does not answer the call
#    [Tags]  309712     P2  alt_bug
#    [Setup]     run keywords   Testcase Setup    count=2   AND    Enable unanswered call to voicemail      from_device=device_1     contact_device=device_2
#    ${voicemail_count_before_new_voicemail}=    Get unread voicemail count    device=device_1
#    click on calls tab  device=device_2
#    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
#    Verify incoming call    device=device_1     status=appear
#    Wait for Some Time    time=${wait_time2}
#    Verify Incoming call    device=device_1     status=disappear
#    Verify Call State    device_list=device_2   state=Connected
#    Wait for Some Time    time=${wait_time3}
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2     state=Disconnected
#    Refresh for voicemail visibility    device=device_1
#    ${voicemail_count_after_new_voicemail}=    Get unread voicemail count    device=device_1
#    run keyword if  ${voicemail_count_before_new_voicemail} + 1 == ${voicemail_count_after_new_voicemail}    Log   voicemail count got increased
#    ...   ELSE   fail   Voicemail count didn't increased
#    [Teardown]    run keywords  Capture on Failure    AND     Unanswered call Teardown   devices=device_1,device_2
#
#TC8 : [Outgoing Calls] DUT user cancel the outgoing call with teams client
#    [Tags]  309716      outgoing_calls   P2  alt_credentials
#    [Setup]  Testcase Setup    count=2
#    Click on calls tab   device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC9 :[Search] DUT user is on Voicemail Tab and search for the other users
#    [Tags]  311778
#    [Setup]  Testcase Setup    count=2
#    navigate to voicemail tab   device=device_1
#    Search text   from_device=device_1    to_device=device_2
#    Validate search results presented    device=device_1
#    [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1
#
#TC10 : [Outgoing Calls] Verify call history for a newly created user
#    [Tags]  309732      outgoing_calls  P2  alt_credentials
#    [Setup]  Testcase Setup    count=1
#    Verify calls object for new user    device=device_1
#    Verify meeting object for new user   device=device_1
#    Verify voicemail object for new user   device=device_1
#    [Teardown]  Run Keywords    Capture on Failure     AND     Come back to home screen    device_list=device_1
#
#TC10 :[Search] DUT user is on People Tab and search for the other users
#    [Tags]  311780
#    [Setup]  Testcase Setup    count=2
#    Click on people tab   device=device_1
#    Search text   from_device=device_1    to_device=device_2
#    Validate search results presented    device=device_1
#    [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1
#
#TC3 : [E911] Location support in emergency call
#    # Dial 933 for Emergency Calling
#    [Tags]  309175   P2  alt_blocked
#    [Setup]  Testcase Setup    count=1
#    Click on calls tab   device=device_1
#    Dial emergency num and validate    device=device_1
#    Validate address information on the screen     device=device_1
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1
#
#TC22 :[Outgoing Calls] auto dial with valid PSTN number.
#    [Tags]      309750
#    [Setup]  Testcase Setup for PSTN User   count=2
#    ${hard_key_flag}   is hard dial pad present  device=device_1
#    pass execution if   '${hard_key_flag}'=='False'  device_1, device is not a hard key present device
#    Click on calls tab   device=device_1
#    auto dial with valid num from dial pad  from_device=device_1    to_device=device_2:pstn_user
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC8 : [Call Hold] DUT user to hold the call with another DUT user
#    [Tags]  309757    P1  alt_credentials
#    [Setup]  Testcase Setup    count=2
#    Click on calls tab   device=device_1
#    Make outgoing call using display name    from_device=device_1     to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    repeat keyword  4 times     Verify hold resume scenario
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC2 : [Call Mute] DUT user mutes/unmutes the call with Teams client for 30 mins
#    [Tags]  309773     P2  alt_credentials
#    [Setup]  Testcase Setup    count=2
#    Click on calls tab      device=device_1
#    Make outgoing call using display name    from_device=device_1     to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Mutes the phone call    device=device_1
#    Verify meeting Mute State    device_list=device_1    state=mute
#    Wait for Some Time    time=${30_minutes_wait_time}
#    Unmutes the phone call  device=device_1
#    Verify meeting Mute State    device_list=device_1    state=Unmute
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC3 : [Call Hold] DUT user can disconnect the call when it is already on hold from far-end
#    [Tags]  309780        P2  alt_credentials
#    [Setup]  Testcase Setup    count=3
#    Click on calls tab      device=device_2
#    Make outgoing call using display name    from_device=device_2     to_device=device_3
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Hold the call   device=device_2
#    Verify Call State    device_list=device_2    state=Hold
#    Hold the call   device=device_3
#    Verify Call State    device_list=device_2,device_3    state=Hold
#    Wait for Some Time    time=${10_minutes_wait_time}
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_2,device_3
#
#TC7 : [Call Mute] DUT user can mute the call when is already on mute from far-end
#    [Tags]  309789        P2  alt_credentials
#    [Setup]   Testcase Setup    count=2
#    Click on calls tab   device=device_1
#    Make outgoing call using display name    from_device=device_1     to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Mutes the phone call    device=device_1
#    Verify meeting Mute State    device_list=device_1    state=mute
#    Mutes the phone call    device=device_2
#    Verify meeting Mute State    device_list=device_2    state=mute
#    Unmutes the phone call  device=device_1
#    Verify meeting Mute State    device_list=device_1    state=Unmute
#    Unmutes the phone call  device=device_2
#    Verify meeting Mute State    device_list=device_2    state=Unmute
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC30 : Verify that DUT shouldn't display join button beside the user name of Delegate under Your Delegates,when Join active call option is disabled for Boss.
#    [Tags]      434730     P2
#    [Setup]  Testcase Setup for Delegate User  count=3
#    navigate to manage delegate page    device=device_1
#    disable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls
#    go back to previous page     device=device_1
#    click on calls tab   device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_3
#    Verify Incoming call    device=device_3     status=appear
#    Pick incoming call    device=device_3
#    wait for some time      time=${wait_time}
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    verify join call option should not present in call favorites page   from_device=device_2     to_device=device_1
#    Disconnect call    device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls      AND      Come back to home screen    device_list=device_1,device_2,device_3
#
#TC6 : [Call Transfer] Search option should be available in the call transfer section
#    [Tags]   309804   P2  alt_credentials
#    [Setup]  Testcase Setup    count=3
#    Click on calls tab   device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Verify search option in call transfer section     device=device_1
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC4 : [Call Transfer] DUT user to transfer the TDC call to another DUT user
#    [Tags]   309818     call_transfer   P2  alt_credentials
#    [Setup]  Testcase Setup    count=3
#    Click on calls tab   device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC2 : [Call Transfer] DUT user do consultative transfer one PSTN user call to another PSTN user
#    [Tags]   309839     call_transfer    P2  alt_blocked        Certification_audio
#    [Setup]     Testcase Setup for 2 PSTN User    count=3
#    Click on calls tab   device=device_2
#    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Consult first to transfer the call using phonenumber  from_device=device_1      to_device=device_3:pstn_user
#    Pick incoming call    device=device_3
#    Verify Call State    device_list=device_3,device_1    state=Connected
#    Completes the consultation to accept the call     from_device=device_1      to_device=device_3:pstn_user
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Verify Call State    device_list=device_1    state=Disconnected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC8 : [Call Merge] Teams app user is in merge call and PSTN user is added as a participant
#    [Tags]   180821         alt_blocked
#    [Setup]     Testcase Setup for PSTN User    count=4
#    Click on calls tab   device=device_1
#    Make outgoing call using display name       from_device=device_1    to_device=device_3
#    Pick incoming call   device=device_3
#    Wait for Some Time    time=${wait_time}
#    verify call state    device_list=device_1,device_3      state=Connected
#    Click on calls tab   device=device_4
#    Make outgoing call using display name       from_device=device_4    to_device=device_1
#    Pick incoming call     device=device_1
#    Wait for Some Time     time=${wait_time}
#    Verify Call State     device_list=device_1,device_4      state=Connected
#    verify call state     device_list=device_3     state=Hold
#    Verify and merge call    device=device_1  from_device=device_3
#    verify call state    device_list=device_1,device_3,device_4     state=Connected
#    Add participant to conversation using phonenumber      from_device=device_1    to_device=device_2:pstn_user
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    verify call state   device_list=device_1,device_2,device_3,device_4    state=Connected
#    verify participant list   from_device=device_1    connected_device_list=device_1,device_2:pstn_user,device_3,device_4
#    disconnect call   device=device_1,device_2,device_3
#    verify Call State   device_list=device_1,device_2,device_3,device_4    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3,device_4
#
#TC8: [Call Merge] Verify call merge option shows up in more options (…)
#   [Tags]   309850     P2  alt_credentials      Certification_audio
#   [Setup]   Testcase Setup      count=3
#   Click on calls tab   device=device_1
#   Make outgoing call using display name    from_device=device_1     to_device=device_2
#   Pick incoming call   device=device_2
#   verify call state    device_list=device_1,device_2     state=Connected
#   Click on calls tab   device=device_3
#   Make outgoing call using display name    from_device=device_3     to_device=device_1
#   Pick incoming call from call notification    device=device_1
#   verify call state     device_list=device_1,device_3      state=Connected
#   verify call state     device_list=device_2     state=Hold
#   Verify merge call option    from_device=device_1     to_device=device_2
#   disconnect call       device=device_2,device_1
#   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
#   [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#TC11: [Call Merge] Name in call roster header should update after merging two 1:1 calls successfully
#   [Tags]   309854     P2  alt_credentials
#   [Setup]     Testcase Setup      count=3
#   Click on calls tab   device=device_1
#   Make outgoing call using display name    from_device=device_1   to_device=device_2
#   Pick incoming call    device=device_2
#   verify call state      device_list=device_1,device_2      state=Connected
#   Click on calls tab   device=device_3
#   Make outgoing call using display name    from_device=device_3   to_device=device_1
#   Pick incoming call from call notification    device=device_1
#   verify call state   device_list=device_1,device_3    state=Connected
#   verify call state    device_list=device_2     state=Hold
#   Verify and merge call  device=device_1    from_device=device_2
#   Verify transition screen during call merge   device=device_1
#   verify call state   device_list=device_1,device_2,device_3    state=Connected
#   Verify header of call roster   device=device_1    from_device=device_2,device_3
#   disconnect call       device=device_1,device_2
#   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
#   [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#TC9 : [Call Merge] Verify merge transition screen is displayed properly
#   [Tags]   309860     P2  alt_credentials
#   [Setup]   Testcase Setup      count=3
#   Click on calls tab   device=device_1
#   Make outgoing call using display name    from_device=device_1     to_device=device_2
#   Pick incoming call    device=device_2
#   verify call state    device_list=device_1,device_2     state=Connected
#   Click on calls tab   device=device_3
#   Make outgoing call using display name    from_device=device_3     to_device=device_1
#   Pick incoming call from call notification    device=device_1
#   verify call state     device_list=device_1,device_3      state=Connected
#   verify call state     device_list=device_2     state=Hold
#   Verify and merge call    device=device_1     from_device=device_2
#   Verify transition Screen during Call merge  device=device_1
#   verify call state     device_list=device_1,device_2,device_3      state=Connected
#   disconnect call       device=device_1,device_2
#   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
#   [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#TC10 : [Call Merge] Verify active call ends and merged call appears on the screen after merge completion
#   [Tags]   309866     P2  alt_credentials
#   [Setup]   Testcase Setup      count=3
#   Click on calls tab   device=device_1
#   Make outgoing call using display name    from_device=device_1     to_device=device_2
#   Pick incoming call   device=device_2
#   verify call state    device_list=device_1,device_2     state=Connected
#   Click on calls tab   device=device_3
#   Make outgoing call using display name    from_device=device_3     to_device=device_1
#   Pick incoming call from call notification    device=device_1
#   verify call state     device_list=device_1,device_3      state=Connected
#   verify call state     device_list=device_2     state=Hold
#   Verify and merge call    device=device_1     from_device=device_2
#   verify call state     device_list=device_1,device_2,device_3     state=Connected
#   disconnect call       device=device_1,device_2
#   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
#   [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#TC3 : [Simul-ring] DUT user can configure a second DUT user to ring simultaneously for an incoming call from PSTN user
#    [Tags]  316017    146729    advance_calling     P2  alt_blocked
#    [Setup]     run keywords  Testcase Setup for PSTN User    count=3    AND     Enable Also Ring and add contact     device=device_1   contact_device=device_3
#    Click on calls tab   device=device_2
#    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
#    Verify Incoming call    device=device_1,device_3     status=appear
#    Pick incoming call    device=device_3
#    Verify Incoming call    device=device_1     status=disappear
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Call Ring Teardown    devices=device_1,device_2,device_3
#
#TC9 : [Call Forward] DUT user to forward the call to delegates - Call from another DUT user
#    [Tags]  307832      advance_calling     P2  alt_blocked
#    [Setup]  Testcase Setup for Delegate User   count=3
#    Click on calls tab      device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
#    Verify incoming call    device=device_2     status=appear
#    Pick incoming call   device=device_2
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]  run keywords  Capture on Failure    AND     Come back to home screen   device_list=device_1,device_2,device_3
#
#TC2 :[Call Forward] DUT user to forward the call to Call Group - Call from another DUT user
#    [Tags]  307846      146745      advance_calling         bvt_pr  alt_blocked
#    [Setup]  Run Keywords   Testcase Setup for GCP User   count=3    AND     Enable call forwarding to call group     from_device=device_1    contact_device=device_2
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
#    Verify call notification    device=device_2     status=appear
#    Pick incoming call from call notification    device=device_2
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]  run keywords  Capture on Failure    AND     Disable Call forward    devices=device_1,device_2,device_3
#
#TC6 : [Simul-ring] DUT user can configure a PSTN user to ring simultaneously for an incoming call from another DUT user
#    [Tags]  307904    advance_calling       bvt_pr  alt_blocked
#    [Setup]     Run Keywords   Testcase Setup for 2 PSTN User    count=3    AND     Enable Also Ring and add contact     device=device_1   contact_device=device_2:pstn_user
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
#    Verify Incoming call    device=device_1,device_2     status=appear
#    Pick incoming call    device=device_2
#    Verify Incoming call    device=device_1     status=disappear
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Call Ring Teardown    devices=device_1,device_2,device_3
#

#TC3 : [Auto Dismiss] Verify that “Dismiss Rate My Call” option with toggle is present in "User survey settings".
#    [Tags]   320205    P2
#    [Setup]  Testcase Setup    count=1
#    navigate to user survey     device=device_1
#    verify dismiss rate my call toggle    device=device_1       toggle=off
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC4 : [Auto Dismiss] Verify that rate my call screen should appear if “Dismiss Rate My Call” Toggle is ON ..
#    [Tags]   320210    P2
#    [Setup]  Testcase Setup    count=2
#    enable dismiss rate my call toggle   device=device_1
#    verify dismiss rate my call toggle    device=device_1       toggle=on
#    return to home screen    device_list=device_1
#    Click on calls tab   device=device_1
#    make outgoing call using display name   from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    verify call rating screen after disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2       AND     disable dismiss rate my call toggle    device=device_1
#
#TC5 :[Auto Dismiss] Verify that rate my call screen should not appear if “Dismiss Rate My Call” Toggle is OFF .
#    [Tags]   320215    P2
#    [Setup]  Testcase Setup    count=2
#    disable dismiss rate my call toggle   device=device_1
#    verify dismiss rate my call toggle    device=device_1       toggle=off
#    go back to previous page    device=device_1
#    Click on calls tab   device=device_1
#    make outgoing call using display name   from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    verify call rating screen after disconnect call     device=device_1     status=disappear
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC13 : [ Call view] Verify that Dark theme works fine for the default view screens
#    [Tags]   319463     P2
#    [Setup]     run keywords    Testcase Setup    count=1   AND    verify and enable dark theme     device=device_1
#    Verify call views option under callings settings       device=device_1      verify_options_under_default_view=on
#    return to home screen    device_list=device_1
#    Select default view value     device=device_1     option=recent call history
#    Validate calls tab after default value change    device=device_1     default_option=recent call history
#    [Teardown]    Run Keywords   Capture on Failure    AND      Teardown for Dark Theme Disable
#
#TC1 : [Esc to Conf.] DUT user in P2P call with TDC, adds another DUT user
#    [Tags]  307111    146539      esc_to_cnf    P2  alt_credentials
#    [Setup]  Testcase Setup    count=3
#    Click on calls tab   device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    verify participant list     from_device=device_1      connected_device_list=device_1,device_2,device_3
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2     state=Disconnected
#    Verify Call State    device_list=device_1,device_3     state=Connected
#    verify participant list     from_device=device_1      connected_device_list=device_1,device_3
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC16:[Call forward on home screen] Verify call forwarding section on home screen in dark theme.
#    [Tags]  452466      P2
#    [Setup]   run keywords      Testcase Setup    count=1       AND    enable call forwarding display on home screen         device=device_1
#    verify and enable dark theme     device=device_1
#    verify home screen tiles        device=device_1
#    verify call forwarding icon     device=device_1
#    verify call forwarding option in call forward icon    device=device_1
#    click on calls tab      device=device_1
#    verify call forwarding icon     device=device_1
#    verify and disable dark theme    device=device_1
#    [Teardown]   run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1
#
#TC7 :[GCP] DUT accept group call and perform Mute/hold
#    [Tags]     380769      P2       Certification_audio
#    [Setup]   Testcase Setup for GCP User  count=3
#    click on calls tab   device=device_3
#    Make outgoing call using display name    from_device=device_3      to_device=device_1
#    Pick incoming call from call notification    device=device_2
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Mutes the phone call    device=device_2
#    Verify meeting Mute State    device_list=device_2    state=mute
#    Unmutes the phone call  device=device_2
#    Verify meeting Mute State    device_list=device_2    state=Unmute
#    Hold the call   device=device_2
#    Verify Call State    device_list=device_2,device_3    state=Hold
#    Resume the call   device=device_2
#    Verify Call State    device_list=device_2,device_3     state=Resume
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]  run keywords  Capture on Failure   AND   Come back to home screen   device_list=device_2,device_3
#
#TC6 :[GCP] DUT gets the incoming group call notification
#    [Tags]     380768      P2       Certification_audio
#    [Setup]   Testcase Setup for GCP User  count=4
#    click on calls tab   device=device_3
#    Make outgoing call using display name    from_device=device_3      to_device=device_1
#    Pick incoming call from call notification    device=device_2
#    Verify call notification    device=device_4     status=disappear
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]  run keywords  Capture on Failure   AND   Come back to home screen   device_list=device_2,device_3,device_4
#
#TC19: [Private meetings] User to create new meetings when privacy toggle is turned off on the device
#    [Tags]  311116        P2
#    [Setup]    Testcase Setup   count=1
#    disable show meeting names  device=device_1
#    verify meeting title shows meeting organizer name   device=device_1      organizer=device_1
#    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1    AND   enable show meeting names  device=device_1
#
#TC3 : [Incoming Calls] DUT user to reject the call when UI view is in Device settings
#    [Tags]  341830   P2
#    [Setup]   Testcase Setup    count=2
#    Opens partner settings page     device=device_1
#    click on calls tab  device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    verify incoming call    device=device_1      status=appear
#    Rejects the incoming call   device_list=device_1
#    Verify Call State    device_list=device_1     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND    device setting back    device=device_1   AND   Come back to home screen    device_list=device_1,device_2
#
#TC7 :[Calendar] DUT user disconnects the meeting while on add participants page
#    [Tags]   309042   p2
#    [Setup]  Testcase Setup    count=3
#    Join Meeting    device=device_1,device_2,device_3     meeting=test_meeting1
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    navigate to add participant page    device_name=device_1
#    tap to return to meeting        device=device_1
#    End meeting     device=device_1,device_2,device_3
#    verify join meeting screen after end meeting    device=device_1     meeting=test_meeting1
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3
#
#TC6 : [CQ] Call answered notifications can be dismissed manually
#    [Tags]  311076       P2  alt_blocked
#    [Setup]  Testcase Setup for CQ PSTN User   count=3
#    click on calls tab   device=device_2
#    Place call to phone num    from_device=device_2      phone_num=CQ_no
#    Wait till incoming call visibility    device=device_1,device_3
#    Pick incoming call    device=device_1
#    Verify Incoming call    device=device_3     status=disappear
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND     Test Case Teardown    devices=device_1,device_2,device_3
#
#TC7 : [Call Park] cancel call park icon
#    [Tags]  309019   P2  alt_blocked
#    [Setup]  Testcase Setup    count=2
#    click on calls tab   device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    ${call_park_code1}=    call park and get the code    device=device_1
#    click on calls tab  device=device_1
#    verify call park cancel button    ${call_park_code1}    device_1
#    Verify ui returns to home page   device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen   device_list=device_1,device_2
#    TC1 : [CAP Policy] Search is disabled for CAP user
#    [Documentation]  Use account with search disabled CAP Policy
#    [Tags]  308979   P1  alt_blocked
#    [Setup]   Testcase Setup for CAP Search Disable User    count=1
#    Verify search option is disabled    device=device_1
#    [Teardown]  Capture on Failure
#
#firmware
#TC4 :[CAP Policy] User SignIn intent
#    [Tags]       308975     fw_phones          exclude_ftp
#    [Setup]  Testcase Setup     count=1
#    Sign Out    device_list=device_1
#    Wait for Some Time    time=${wait_time}
#    Sign In     device_list=device_1    user_list=cap_search_enabled
#    Wait for Some Time    time=${wait_time}
#    Verify Intents      device=device_1     intent=sign_in     user=cap_search_enabled
#    [Teardown]   Run Keywords   Capture on Failure     AND    Testcase Setup     count=1
#
#TC3 : [CAP Policy] CAP user calls a TDC user and add another PSTN, TDC user to the call
#    [Documentation]  4 Devices are required
#    [Tags]   308974     P1  alt_blocked
#    [Setup]   Testcase Setup for CAP PSTN User   count=4
#    navigate to people tab from home screen for cap    device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Escalating to conference call by using display name   from_device=device_1      to_device=device_4
#    Pick incoming call    device=device_4
#    Click back      device=device_1
#    Verify Call State    device_list=device_1,device_4    state=Connected
#    Escalating to conference call by using phonenumber   from_device=device_1      to_device=device_2:pstn_user
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2,device_3,device_4
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4
#
#TC16 : [Reaction] User to verify the show/hide behavior of call control bar
#    [Tags]  311019   P1
#    [Setup]  Testcase Setup   count=1
#    join meeting   device=device_1    meeting=Hard_and_reaction
#    Verify meeting state   device_list=device_1   state=Connected
#    wait for some time     ${wait_time}
#    verify call control bar in meeting   device=device_1
#    Verify presence of reactions button in call control     device=device_1
#    End meeting     device=device_1
#    Verify meeting state    device_list=device_1   state=Disconnected
#    [Teardown]   run keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1
#
#TC5 : [CAP Policy] CAP user calls a TDC user and checks hold/resume
#    [Tags]  308970   P1  alt_blocked
#    [Setup]   Testcase Setup for CAP User   count=2
#    navigate to people tab from home screen for cap    device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Hold the call   device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Hold
#    Resume the call   device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Resume
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC4 : [CAP Policy] CAP user calls a TDC user and checks mute/un-mute
#    [Tags]  308968   P1  alt_blocked
#    [Setup]   Testcase Setup for CAP User   count=2
#    navigate to people tab from home screen for cap    device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Mutes the phone call    device=device_1
#    Verify meeting Mute State    device_list=device_1    state=mute
#    Unmutes the phone call  device=device_1
#    Verify meeting Mute State    device_list=device_1    state=Unmute
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC3 :[Attendee] DUT user to make TDC user as an attendee
#    [Tags]  311011   p2  alt_bug
#    [Setup]    Testcase Setup   count=2
#    Join Meeting    device=device_1,device_2    meeting=meeting_dut
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Make an attendee    from_device=device_1       to_device=device_2
#    Verify you are an attendee now notification     device=device_2
#    Verify add participant button should not visible for attendee    device=device_2
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]    Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2
#
#TC2 : [CAP Policy] CAP user parks and retrieve a PSTN call
#    [Documentation]  Devices are already signed-in in Suite Setup
#    [Tags]  308963      cap_policy_pstn     P1  alt_blocked
#    [Setup]   Testcase Setup for CAP PSTN User   count=2
#    click on calls tab   device=device_2
#    Make outgoing call using phonenumber  from_device=device_2      to_device=device_1:cap_search_enabled
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    ${call_park_code}=    call park and get the code    device=device_1
#    #Verify Call State    device_list=device_2   state=Hold
#    Unpark Call    ${call_park_code}    device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen    device_list=device_1,device_2
#
#TC6 : [CAP Policy] CAP user consult transfers TDC call to another TDC user
#    [Documentation]     Stuck with issue
#    [Tags]  308961   P1  alt_blocked
#    [Setup]   Testcase Setup for CAP User   count=3
#    navigate to people tab from home screen for cap    device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Verify Call State    device_list=device_2   state=Hold
#    Completes the consultation to accept the call     from_device=device_1      to_device=device_2
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Verify Call State    device_list=device_1    state=Disconnected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#    TC1 : [CAP Policy] CAP user blind transfers TDC call to PSTN user
#    [Tags]  308953   cap_policy_pstn    P2  alt_blocked
#    [Setup]   Testcase Setup for CAP PSTN User   count=3
#    navigate to people tab from home screen for cap    device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Blindtransfers the call using phonenumber  from_device=device_1      to_device=device_2:pstn_user
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1    state=Disconnected
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC3 : [CAP Policy] CAP user makes a call to another user
#    [Documentation]  Primary CAP account
#    [Tags]  308945        bvt_pr     32_bvt  alt_blocked
#    [Setup]   Testcase Setup for CAP User   count=2
#    navigate to people tab from home screen for cap    device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC2 : [CAP Policy] CAP user search for another user
#    [Documentation]  Use account with search enabled CAP Policy
#    [Tags]  308938   P1  alt_blocked
#    [Setup]   Testcase Setup for CAP User   count=2
#    Search for TDC user    from_device=device_1      to_device=device_2
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1
#
#TC6:[CallTransferEnhancements] [landscape] consult transfer search screen > can search for users > touchscreen transfer
#    [Tags]    456378
#    [Setup]   Testcase Setup    count=3
#    ${landscape_mode_flag}   is portrait mode cnf device  device=device_1
#    pass execution if   '${landscape_mode_flag}'=='True'  device_1, device is not a landscape mode device
#    Click on calls tab   device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Verify Call State    device_list=device_3,device_1    state=Connected
#    Verify Call State    device_list=device_2    state=Hold
#    Completes the consultation to accept the call     from_device=device_1      to_device=device_2
#    Verify Call State    device_list=device_1     state=Disconnected
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC15 : [Reactions] DUT user to verify the reaction of TDC user when TDC user is displayed on the main stage
#    [Tags]    310969    P2
#    [Setup]   Testcase Setup   count=1
#    join meeting   device=device_1    meeting=Hard_and_reaction
#    Verify meeting state   device_list=device_1   state=Connected
#    Verify reaction button in call control     device=device_1
#    Tap on reaction button in call control      device=device_1
#    Tap on like button     device=device_1
#    End meeting     device=device_1
#    Verify meeting state    device_list=device_1  state=Disconnected
#    [Teardown]   run keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1
#
#TC17 :[Reactions] DUT user to verify the reaction of TDC user when TDC user is displayed on the main stage of DUT user
#    [Tags]      310969   p2
#    [Setup]  Testcase Setup   count=2
#    join meeting   device=device_1,device_2    meeting=Meeting_with_tdc
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    Verify reaction button in call control     device=device_2
#    Tap on like button     device=device_2
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2  state=Disconnected
#    [Teardown]   run keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2
#
#TC13 : [Reactions] DUT user to verify the raise hand feature from reactions window
#    [Tags]    310957    P2
#    [Setup]     Testcase Setup   count=2
#    join meeting   device=device_1,device_2    meeting=Hard_and_reaction
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    Verify reaction button in call control     device=device_1
#    Tap on reaction button in call control      device=device_1
#    Verify presence of reactions button in call control     device=device_1
#    Raise hand     device=device_1
#    Verify raise hand    from_device=device_1   to_device=device_2    status=on
#    Lower hand     device=device_1
#    Verify raise hand    from_device=device_1   to_device=device_2    status=off
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]   run keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2
#
#TC3: [CallTransferEnhancements] blind transfer search screen > launch dialpad
#    [Tags]  456337     P2
#    [Setup]  Testcase Setup    count=3
#    click on calls tab   device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    verify call transfer UI when in call   from_device=device_1   to_device=device_2   speed_dial_user=device_3    option=transfer_now
#    resume the call      device=device_1
#    click and verify dial pad in call transfer   device=device_1   option=transfer_now
#    Disconnect call     device=device_2
#    verify call state and disconnect   device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#    TC13 : [E911] Verify E911 call support for CAP account
#    [Tags]  321160     P1
#    [Setup]  Testcase Setup for CAP User    count=1
#    navigate to dial pad tab for cap    device=device_1
#    Dial emergency num and validate    device=device_1
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1
#
#TC5 :[Search] Recent search tab is cleared
#    [Tags]  306808            alt_credentials
#    [Setup]   Testcase Setup  count=2
#    Click on calls tab       device=device_1
#    verify search text   from_device=device_1   to_device=device_2
#    go back to previous page  device=device_1
#    verify recent search item    from_device=device_1   to_device=device_2
#    clear search history and validate    device=device_1
#    [Teardown]    Run Keywords   Capture on Failure   AND   Come back to home screen    device_list=device_1
#    TC1 : [Calendar] No meetings displayed when there are no scheduled meetings for the day
#    [Tags]  306800         alt_bug
#    [Setup]    Testcase Setup   count=1
#    Navigate to Calendar tab   device=device_1
#    Verify no meetings scheduled on saturday    device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1
#
#TC1 : [Call Forward] DUT user to forward PSTN user call to TDC
#    [Tags]  306783      advance_calling     P2  alt_blocked
#    [Setup]  run keywords  Testcase Setup for PSTN User    count=3    AND     Enable call forwarding and add contact     from_device=device_1    contact_device=device_3
#    Click on calls tab   device=device_2
#    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify incoming call    device=device_3     status=appear
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_3,device_2     state=Disconnected
#    [Teardown]   run keywords  Capture on Failure    AND     Disable Call forward    devices=device_1,device_2,device_3
#
#TC3 : [Call Forward] DUT user to forward one PSTN call to another PSTN user
#    [Tags]  306782      advance_calling     P2  alt_blocked
#    [Setup]  Run Keywords   Testcase Setup for 2 PSTN User    count=3    AND     Enable call forwarding and add contact     from_device=device_1    contact_device=device_3:pstn_user
#    Click on calls tab   device=device_2
#    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify incoming call    device=device_3     status=appear
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_3,device_2     state=Disconnected
#    [Teardown]   run keywords  Capture on Failure    AND     Disable Call forward   devices=device_1,device_2,device_3
#
#TC2 : [Call Forward] DUT user to forward PSTN call to voicemail
#    [Tags]  306780      advance_calling     P2  alt_blocked
#    [Setup]  run keywords  Testcase Setup for PSTN User    count=2    AND     Set Call Forwarding    device=device_1
#    Clear notification from home screen     device=device_1
#    Send Voicemail      from_device=device_2   to_device=device_1
#    Wait for Some Time    time=20
#    Verify voicemail notification     to_device=device_1     from_device=device_2:pstn_user
#    navigate to voicemail tab    device=device_1
#    play voicemail    device=device_1
#    [Teardown]   run keywords  Capture on Failure    AND     Disable Call forward    devices=device_1
#
#TC3 : [Voicemail] DUT user to play the voicemails from the list
#    [Tags]  306775       bvt_pr  alt_credentials        Certification_audio
#    [Setup]  Testcase Setup    count=3
#    Send Voicemail      from_device=device_2      to_device=device_1
#    Send Voicemail      from_device=device_3      to_device=device_1
#    Wait for Some Time    time=20s
#    Navigate to voicemail tab    device=device_1
#    refresh the page    device=device_1
#    Play multiple voicemail from list    on_device=device_1    from_device=device_2,device_3
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC4 : [CQ] CQ Agent to Transfer the CQ call to TDC user
#    [Tags]  308821       P2  alt_blocked
#    [Setup]  Testcase Setup for CQ PSTN User   count=4
#    click on calls tab   device=device_2
#    Place call to phone num    from_device=device_2      phone_num=CQ_no
#    Wait till incoming call visibility    device=device_1,device_3
#    Pick incoming call    device=device_1
#    Verify Incoming call    device=device_3     status=disappear
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Blindtransfers the call using phonenumber  from_device=device_1      to_device=device_4
#    Pick incoming call    device=device_4
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_4,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_4,device_2    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND     Test Case Teardown    devices=device_1,device_2,device_3,device_4
#
#TC6 : [Incoming Calls] Teams client user hangs up the call before DUT user picks up
#    [Tags]   306765     incoming_call   P2  alt_credentials
#    [Setup]   Testcase Setup    count=2
#    ${calls_count_before_new_call}=    Get missed calls count    device=device_1
#    Make outgoing call using display name   from_device=device_2     to_device=device_1
#    Verify display name on call toast   to_device=device_1    from_device=device_2
#    Disconnect call     device=device_2
#    Wait for Some Time    time=${wait_time}
#    ${calls_count_after_new_call}=    Get missed calls count    device=device_1
#    Navigate to calls tab   device=device_1
#    ${device_call_duration}=    get first call duration    device=device_1
#    run keyword if  '${device_call_duration}' == 'Missed call'    log   Got missed call
#    ...   ELSE   fail   Didn't get missed call
#    run keyword if  ${calls_count_before_new_call}+1 == ${calls_count_after_new_call}    Log   Calls count got increased
#    ...   ELSE   fail   Calls count didn't increase.
#    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2
#
#TC3 :[Search] Search for a contact with complete contact name in DUT
#    [Tags]    306761  P1  alt_credentials       Certification_audio
#    [Setup]   Testcase Setup   count=2
#    Click on calls tab       device=device_1
#    verify search text   from_device=device_1     to_device=device_2
#    [Teardown]    Run Keywords   Capture on Failure  AND   Come back to home screen   device_list=device_1
#
#TC14: [Audio outPut]call should flow with speaker when user initiate outgoing call
#    [Tags]    321097    p2
#    [Setup]   Testcase Setup     count=2
#    click on calls tab  device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Verify Incoming call    device=device_2     status=appear
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Wait for Some Time    time=3s
#    Verify Multiple Intents    device=device_1     features_list=PHONE_STATE_UPDATED   intents_list=speaker_on,headset_off,handset_off
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC8 : [OBO] When DUT user on Device settings page receives delegate call_call forwarding
#    [Tags]  308731   P1  alt_blocked
#    [Setup]   Testcase Setup for Delegate User  count=3
#    Navigate to device setting page     device=device_2
#    Make outgoing call using display name    from_device=device_3      to_device=device_1
#    Verify Incoming call    device=device_2     status=appear
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2,device_3
#
#TC6 : [OBO] DUT user on 'Pick up a parked call ' page receive delegate call_ call forwarding
#    [Tags]  308725   P2  alt_blocked
#    [Setup]   Testcase Setup for Delegate User  count=3
#    Navigate to call park page     device=device_2
#    Make outgoing call using display name    from_device=device_3      to_device=device_1
#    Verify Incoming call    device=device_2     status=appear
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_3
#    Cancel call park page     device=device_2
#    [Teardown]  run keywords  Capture on Failure    AND    cancel parked call    device=device_2   AND    Come back to home screen   device_list=device_1,device_2,device_3
#
#TC9 :[Call forward on home screen] Verify DUT should display Call forwarding section in Home screen, When DUT user Enabled Display on Homescreen option under Calling page
#    [Tags]  452084      P2
#    [Setup]    Testcase Setup    count=1
#    verify display home screen toggle status under calling        device=device_1       status=on
#    open settings page      device=device_1
#    Set Call Forwarding    device=device_1
#    verify call forwarding label status on home screen      device=device_1         status=voicemail
#    [Teardown]   run keywords  Capture on Failure    AND     Disable Call forward   devices=device_1        AND     Come back to home screen    device_list=device_1
#
#TC27 : [7 inch and above] Verify call park option in Expanded dial pad UI.
#    [Tags]      417262    P1
#    [Setup]  Testcase Setup for PSTN User   count=2
#    ${landscape_mode_flag}   is screen size 7 inch or more  device=device_1
#    pass execution if   '${landscape_mode_flag}'=='False'  device_1, device screen size have less then 7 inch
#    Verify Default view relaunches after changing the value     device=device_1     option=expanded_dialpad
#    Validate calls tab after default value change    device=device_1     default_option=expanded_dialpad
#    go back to previous page     device=device_1
#    click on calls tab  device=device_1
#    Make outgoing call using phonenumber      from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    ${call_park_code1}=    call park and get the code    device=device_1
#    Unpark Call    ${call_park_code1}    device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]    Check device screen size and teardown
#
#TC19 :[7 inch and above] Verify user can search Contact from Expanded dial pad UI.
#    [Tags]      417261    P1
#    [Setup]     Testcase Setup    count=2
#    ${landscape_mode_flag}   is screen size 7 inch or more  device=device_1
#    pass execution if   '${landscape_mode_flag}'=='False'  device_1, device screen size have less then 7 inch
#    Verify Default view relaunches after changing the value     device=device_1     option=expanded_dialpad
#    Validate calls tab after default value change    device=device_1     default_option=expanded_dialpad
#    go back to previous page     device=device_1
#    click on calls tab  device=device_1
#    verify profile form search results      from_device=device_1     to_device=device_2
#    [Teardown]    Check device screen size and teardown
#
#TC8 :[Call forward on home screen] Verify Display on Home screen with toggle option should be present under 'Calling' page.
#    [Tags]  452076      P2
#    [Setup]    Testcase Setup    count=1
#    verify display home screen toggle status under calling        device=device_1       status=on
#    [Teardown]   run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1
#
#TC6: [Add participant]Verify whether user able to nudge other users into call when attendee [Group call]
#    [Tags]      321001      P2
#    [Setup]  Testcase Setup     count=3
#    click on calls tab  device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Add participant to conversation using display name  from_device=device_2      to_device=device_3
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    verify participant list     from_device=device_1      connected_device_list=device_1,device_2,device_3
#    Make an attendee    from_device=device_2       to_device=device_1
#    Verify you are an attendee now notification     device=device_1
#    Verify add participant button should not visible for attendee    device=device_1
#    Disconnect call     device=device_1,device_3
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC2 : [OBO] DUT user while on voicemail tab receives a delegate call_call forwarding
#    [Tags]  308713   P2  alt_blocked
#    [Setup]   Testcase Setup for Delegate User  count=3
#    Navigate to voicemail tab   device=device_2
#    Make outgoing call using display name    from_device=device_3      to_device=device_1
#    Verify Incoming call    device=device_2     status=appear
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2,device_3
#
#TC17 :[7 inch and above] Verify DUT user can Cancel Expanded Dialpad as default view under Calling setting.
#    [Tags]      417253    P1
#    [Setup]     Testcase Setup    count=1
#    ${landscape_mode_flag}   is screen size 7 inch or more  device=device_1
#    pass execution if   '${landscape_mode_flag}'=='False'  device_1, device screen size have less then 7 inch
#    Verify Default view relaunches after changing the value     device=device_1     option=speed dial
#    Validate calls tab after default value change    device=device_1     default_option=speed dial
#    go back to previous page     device=device_1
#    Select and cancel default value     device=device_1     option=expanded_dialpad
#    go back to previous page     device=device_1
#    [Teardown]    Check device screen size and teardown
#
#TC8 : [OBO] When DUT user on Device settings page receives delegate call_Also ring
#    [Tags]  308704   P1  alt_blocked
#    [Setup]   Testcase Setup for Delegate User  count=3
#    Navigate to device setting page     device=device_2
#    Click on calls tab    device=device_3
#    Make outgoing call using display name    from_device=device_3      to_device=device_1
#    Verify Incoming call    device=device_1,device_2     status=appear
#    Pick incoming call    device=device_2
#    Verify Incoming call    device=device_1     status=disappear
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2,device_3
#
#TC6 : [OBO] DUT user on 'Pick up a parked call' Page receive delegate call_ Also ring
#    [Tags]  308699   P2  alt_blocked
#    [Setup]   Testcase Setup for Delegate User  count=3
#    Navigate to call park page     device=device_2
#    Click on calls tab    device=device_3
#    Make outgoing call using display name    from_device=device_3      to_device=device_1
#    Verify Incoming call    device=device_1,device_2     status=appear
#    Pick incoming call    device=device_2
#    Verify Incoming call    device=device_1     status=disappear
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_3
#    Cancel call park page     device=device_2
#    [Teardown]  run keywords  Capture on Failure   AND    cancel parked call    device=device_2    AND    Come back to home screen   device_list=device_1,device_2,device_3
#
#TC9 : [Call Park] Verify DUT should see the parked call banner across all the screen.
#    [Tags]  320985   P2
#    [Setup]  Testcase Setup    count=2
#    click on calls tab   device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    click call park    device=device_1
#    go back to previous page      device=device_1
#    verify call park banner     from_device=device_1     to_device=device_2
#    navigate to people tab      device=device_1
#    verify call park banner     from_device=device_1     to_device=device_2
#    navigate to voicemail tab   device=device_1
#    verify call park banner     from_device=device_1     to_device=device_2
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    close call park banner      device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen   device_list=device_1,device_2
#
#TC2 : [OBO] DUT user on VM Tab receive a delegate call_Also ring
#    [Tags]  308687   P2  alt_blocked
#    [Setup]  Testcase Setup for Delegate User  count=3
#    Navigate to voicemail tab   device=device_2
#    Click on calls tab    device=device_3
#    Make outgoing call using display name    from_device=device_3      to_device=device_1
#    Verify Incoming call    device=device_1,device_2     status=appear
#    Pick incoming call    device=device_2
#    Verify Incoming call    device=device_1     status=disappear
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2,device_3
#
#TC5 : [OBO] TDC user adds DUT user as delegate with only receive call permission
#    [Tags]  308669    156777    P2  alt_blocked
#    [Setup]   Testcase Setup for Delegate User   count=3
#    Edit added delegates with Receive call permission and validate   from_device=device_1    to_device=device_3
#    Refresh page for delegate user config changes visibility    device=device_3
#    Initiate OBO call using display name    from_device=device_3      to_device=device_2:delegate_user     obo_option=no_one
#    Verify Incoming call    device=device_2     status=appear
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]  run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1,device_2,device_3   AND    Edit added delegates with both permission and validate   from_device=device_1    to_device=device_3
#
#TC6 : [Structured Meetings] Presenter can change roles of other users except organizer
#    [Tags]   320946  p2
#    [Setup]  Testcase Setup    count=3
#    Join Meeting    device=device_1,device_2,device_3     meeting=test_meeting1
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    verify no option to change organizer role   from_device=device_1   to_device=device_2
#    verify presenter options in meeting from organizer or presenter    from_device=device_1    to_device=device_3
#    make an attendee     from_device=device_1    to_device=device_3
#    verify you are an attendee now notification    device=device_3
#    verify presenter options in meeting from organizer or presenter     from_device=device_1   to_device=device_3
#    make an presenter    from_device=device_1   to_device=device_3
#    verify you are an presenter now notification     device=device_3
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3
#
#TC5 : [Structured Meetings] Attendee user should not have permission to change role of any user
#    [Tags]   320947  p2
#    [Setup]  Testcase Setup    count=3
#    Join Meeting    device=device_1,device_2,device_3     meeting=test_meeting1
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    verify presenter options in meeting from organizer or presenter   from_device=device_1    to_device=device_3
#    make an attendee    from_device=device_2    to_device=device_1
#    verify you are an attendee now notification    device=device_1
#    verify presenter options in meeting from attendee   from_device=device_1     to_device=device_3
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3
#
#TC7 : [Structured Meetings] Verify that meeting roles reset to presenter of all user except Organizer after meeting ends
#    [Tags]   320949   p2
#    [Setup]  Testcase Setup    count=3
#    Join Meeting    device=device_1,device_2,device_3     meeting=meeting_dut
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    make an attendee     from_device=device_1    to_device=device_2
#    verify you are an attendee now notification    device=device_2
#    verify presenter options in meeting from organizer or presenter     from_device=device_1   to_device=device_2
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    Join Meeting    device=device_1,device_2,device_3     meeting=meeting_dut
#    verify you are an attendee now notification      device=device_2        status=off
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3
#
#TC8 : [Structured Meetings] Organizer should have permission to change the roles of the other users in meeting
#    [Tags]   320948   p2
#    [Setup]  Testcase Setup    count=3
#    Join Meeting    device=device_1,device_2,device_3     meeting=meeting_dut
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    make an attendee     from_device=device_1    to_device=device_2
#    verify you are an attendee now notification    device=device_2
#    verify presenter options in meeting from organizer or presenter     from_device=device_1   to_device=device_2
#    make an presenter    from_device=device_1   to_device=device_2
#    verify you are an presenter now notification     device=device_2
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3
#
#TC6 : [GCP]DUT user is on Teams App Settings page and receive forwarded GCP call
#    [Tags]  308659   P2  alt_blocked
#    [Setup]   Testcase Setup for GCP User   count=3
#    Open settings page   device=device_2
#    click on calls tab   device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
#    Verify call notification    device=device_2     status=appear
#    Pick incoming call from call notification    device=device_2
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen    device_list=device_2,device_3
#
#TC3 :[Structured Meetings] Verify joining the meeting as an Attendee shows a banner "You’re joined as an attendee."
#    [Tags]   320945    p2
#    [Setup]  Testcase Setup    count=3
#    Join Meeting    device=device_2,device_1,device_3     meeting=test_meeting1
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    make an attendee     from_device=device_2   to_device=device_1
#    verify you are an attendee now notification    device=device_1
#    End meeting    device=device_1
#    Join Meeting   device=device_1    meeting=test_meeting1
#    verify you are joined as an attendee notification    device=device_1
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3
#
#TC2 :[Structured Meetings] Verify a banner to letting users know that they were either promoted or demoted.
#    [Tags]   320944    p2
#    [Setup]  Testcase Setup    count=3
#    Join Meeting    device=device_1,device_2,device_3     meeting=test_meeting1
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    make an attendee     from_device=device_2   to_device=device_1
#    verify you are an attendee now notification    device=device_1
#    make an presenter    from_device=device_2   to_device=device_1
#    verify you are an presenter now notification    device=device_1
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3
#
#TC8 : [GCP] DUT user while on 'Pick up a parked call ' page receive forwarded GCP call
#    [Tags]  308656   P2  alt_blocked
#    [Setup]   Testcase Setup for GCP User  count=3
#    Navigate to call park page     device=device_2
#    click on calls tab   device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
#    Cancel call park page     device=device_2
#    Verify call notification    device=device_2     status=appear
#    Pick incoming call from call notification    device=device_2
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]  run keywords  Capture on Failure   AND   Come back to home screen   device_list=device_2,device_3
#
#TC4 : [Structured Meetings] Meeting role tag "organizer/Attendee" should display below user name in meeting roster
#    [Tags]   320943   p2
#    [Setup]  Testcase Setup    count=3
#    Join Meeting    device=device_1,device_2,device_3     meeting=test_meeting1
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    verify user role in a meeting  device=device_2    role=Organizer
#    verify presenter options in meeting from organizer or presenter    from_device=device_1  to_device=device_3
#    make an attendee    from_device=device_1     to_device=device_3
#    verify you are an attendee now notification    device=device_3
#    verify user role in a meeting  device=device_3    role=Attendee
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3
#
#TC4 : [GCP] DUT user is on VM Tab and receive a forwarded GCP call
#    [Tags]  308645   P2  alt_blocked
#    [Setup]   Testcase Setup for GCP User  count=3
#    Navigate to voicemail tab   device=device_2
#    click on calls tab   device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
#    Verify call notification    device=device_2     status=appear
#    Pick incoming call from call notification    device=device_2
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen    device_list=device_2,device_3
#
#TC13: [Busy on Busy] [Meeting]Verify unanswered call should be disconnect, When user selects Redirect as if a call is unanswered under When in another call in Calling
#    [Tags]      451990
#    [Setup]  Run Keywords   Testcase Setup    count=3      AND     Disable unanswered call    device=device_1      contact_device=device_2
#    select the options inside when in another call option   device=device_1     option=redirect_unanswered_call
#    Come back to home screen    device_list=device_1
#    Join Meeting    device=device_1,device_2     meeting=tdc_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    click on calls tab        device=device_3
#    verify busy on busy error message while already in call  device=device_3        to_device=device_1  method=display_name
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND  select the options inside when in another call option   device=device_1     option=new_calls_ring_me   AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC1 : [GCP] DUT user ignore the incoming forwarded group call notification
#    [Tags]  308621   P1  alt_blocked
#    [Setup]    Testcase Setup for GCP User  count=3
#    click on calls tab   device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
#    Verify call notification    device=device_2     status=appear
#    Reject incoming call from call notification    device=device_2
#    Verify call notification    device=device_2     status=disappear
#    [Teardown]  run keywords  Capture on Failure
#
#TC19 : [Calls] DUT user's call log in the recent tab entry displays unnamed group call entry with the participants list
#    [Tags]  308461    146821    calls   P2  alt_credentials
#    [Setup]  Run keywords   Testcase Setup    count=3   AND     Make group call    from_device=device_1     to_device=device_2     new_participant=device_3
#    Select call list item   device=device_1  item=View Profile
#    Verify group call participant details in contact card page    device=device_1   device_list=device_2,device_3
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC4 : [Call Park] Parked call terminated before retrieval
#    [Tags]  308609   P2  alt_blocked
#    [Setup]  Testcase Setup    count=2
#    click on calls tab   device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    ${call_park_code}=    call park and get the code    device=device_1
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2     state=Disconnected
#    Unpark Call    ${call_park_code}    device_1
#    Validate could not complete the call   device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen   device_list=device_1,device_2
#
#TC6 : [Call Park] DUT user to park and retrieve the outgoing call with TDC
#    [Tags]  308600   P1  alt_blocked
#    [Setup]  Testcase Setup    count=2
#    click on calls tab   device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    ${call_park_code}=    call park and get the code    device=device_1
#    Unpark Call    ${call_park_code}    device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen   device_list=device_1,device_2
#
#TC18:[Busy on Busy] DUT user to verify the options present inside the "When in another call" under calling
#    [Tags]      451951     P2  phonesCY23_4
#    [Setup]  Testcase Setup    count=1
#    Verify settings calling option      device=device_1
#    verify default setting under call forwarding section    device=device_1     status=off
#    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1
#
#TC27 : [Manage Delegates] Manage Delegates option should be available in settings
#    [Tags]      318785
#    [Setup]  Testcase Setup for Delegate User   count=4
#    Verify that Manage Delegates option is available in settings   from_device=device_1
#    return to home screen    device_list=device_1
#    [Teardown]  run keywords  Capture on Failure     AND    Come back to home screen   device_list=device_1,device_2,device_3,device_4
#
#TC30 : [Call view][Portrait device] User should be able to dial PSTN number using Soft/Hard dialpad, default calls screen is set as "Dialpad"
#    [Tags]      318782    P2
#    [Setup]    run Keywords      Testcase Setup for PSTN User    count=2     AND     Select default view value     device=device_1     option=dialpad
#    ${prt_mode_flag}   is portrait mode cnf device  device=device_1
#    pass execution if   '${prt_mode_flag}'=='False'  device_1, device is not a portrait mode device
#    Validate calls tab after default value change    device=device_1      default_option=dialpad
#    go back to previous page     device=device_1
#    click on calls tab   device=device_1
#    auto dial with valid num from dial pad      from_device=device_1    to_device=device_2:pstn_user
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2    state=DisConnected
#    [Teardown]    Check device orientation and teardown
#
#TC5 : [Simul-ring] Teams App user can configure a call group to ring simultaneously for an incoming call from PSTN user
#    [Tags]  146738     advance_calling    P2  alt_blocked
#    [Setup]     Run Keywords   Testcase Setup for GCP PSTN User    count=3    AND     Enable Also Ring Call group     device=device_1
#    Click on calls tab   device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
#    Verify Incoming call    device=device_1     status=appear
#    Verify call notification    device=device_2     status=appear
#    Pick incoming call    device=device_1
#    Verify call notification    device=device_2     status=disappear
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Call Ring Teardown    devices=device_1,device_2,device_3
##TC4 : [Simul-ring] DUT user can configure a PSTN user to ring simultaneously for an incoming call from another DUT user
#    [Tags]  307772    146727    advance_calling     P2  alt_blocked
#    [Setup]     run keywords  Testcase Setup for PSTN User    count=3    AND     Enable Also Ring and add contact     device=device_1   contact_device=device_2:pstn_user
#    Click on calls tab   device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
#    Verify Incoming call    device=device_1,device_2     status=appear
#    Pick incoming call   device=device_2
#    Verify Incoming call    device=device_1     status=disappear
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Call Ring Teardown    devices=device_1,device_2,device_3
#
#TC17 : [Calendar] Teams App user to reject the meeting invite call from Teams Desktop client
#    [Tags]  146690   P2  alt_bug
#    [Setup]  Testcase Setup    count=2
#    Join Meeting    device=device_2     meeting=test_meeting1
#    Add participant to conversation using display name   from_device=device_2      to_device=device_1
#    Verify Incoming call    device=device_1     status=appear
#    Rejects the incoming call    device_list=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2
#
#TC3 : [Esc to Conf.] Teams app does not display video option when P2P call is escalated to conference
#    [Tags]  146636      esc_to_cnf      P2  alt_credentials
#    [Setup]  Testcase Setup    count=3
#    Make Video call using display name   from_device=device_2     to_device=device_1
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Verify video status     device=device_2     status=ON
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Verify video status     device=device_2     status=OFF
#    verify participant list     from_device=device_2      connected_device_list=device_1,device_2,device_3
#    Disconnect call     device=device_1,device_2
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#

#TC14 : [Calendar] Only online meetings should show join button in meeting object of Teams App
#    [Tags]  146572   P2  alt_bug
#    [Setup]    Testcase Setup   count=1
#    navigate to calendar tab    device=device_1
#    Refresh for Meeting Visibility      device=device_1
#    Select Meeting      device=device_1    meeting=test_meeting1
#    Verify meeting has join button    device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1
#
#TC9 : [Calendar] Clicking on Meeting object in calendar tab should navigate to meeting details
#    [Tags]  146570   P1  alt_bug
#    [Setup]  Testcase Setup    count=1
#    Navigate to Calendar tab   device=device_1
#    Select Meeting      device=device_1
#    Verify Meeting Details    device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1
#
#TC16 : [Calendar] Teams App user gets multiple All Day meeting at same time
#    [Tags]  146558   P2  alt_bug
#    [Setup]    Testcase Setup   count=3
#    create meeting  device=device_2       participants=device_1    meeting=tdc1_all_day_meeting1    all_day_meeting=ON
#    create meeting  device=device_2       participants=device_1    meeting=tdc1_all_day_meeting2    all_day_meeting=ON
#    create meeting  device=device_3       participants=device_1    meeting=tdc2_all_day_meeting1    all_day_meeting=ON
#    create meeting  device=device_3       participants=device_1    meeting=tdc2_all_day_meeting2    all_day_meeting=ON
#    create meeting  device=device_3       participants=device_1    meeting=tdc2_all_day_meeting3    all_day_meeting=ON
#    Refresh for Meeting Visibility      device=device_1
#    Verify meeting under all day event  device=device_1     meetings=tdc1_all_day_meeting1,tdc1_all_day_meeting2,tdc2_all_day_meeting1,tdc2_all_day_meeting2,tdc2_all_day_meeting3
#    Join meeting from all day meeting tab     device=device_1     meeting=tdc2_all_day_meeting3
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1   state=Connected
#    End meeting     device=device_1
#    click back btn  device=device_1
#    [Teardown]  Run Keywords    Capture on Failure   AND     Test Case Teardown   devices=device_1,device_2,device_3
#
#TC14 : [Calendar]Teams App user joins the meeting scheduled without description
#    [Tags]  146556   P2  alt_bug
#    [Setup]    Testcase Setup   count=1
#    navigate to calendar tab    device=device_1
#    Select Meeting      device=device_1        meeting=test_meeting
#    Verify meeting does not have description     device=device_1
#    Join Meeting    device=device_1    meeting=test_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1    state=Connected
#    End meeting     device=device_1
#    Verify meeting state    device_list=device_1   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1
#
#TC22 : [Calendar]Teams App user can respond to single occurrence of recurrence meeting
#    [Tags]  146551   P2  alt_bug
#    [Setup]    Testcase Setup   count=2
#    create meeting  device=device_2       participants=device_1    meeting=recurring_meeting1    repeat=Every week
#    Refresh for Meeting Visibility      device=device_1
#    Select Meeting      device=device_1        meeting=recurring_meeting1
#    Verify meeting recurrence indicator symbol     device=device_1
#    Check rsvp status   device=device_1
#    Respond to meeting     device=device_1     respond_option=Decline
#    [Teardown]  Run Keywords    Capture on Failure  AND   Test Case Teardown     devices=device_1,device_2
#

#TC12 : [Calendar] For Organizer on Teams App, canceled meetings should not be displayed in calendar tab
#    [Tags]  146549  P2  alt_bug
#    [Setup]  Testcase Setup    count=1
#    create meeting  device=device_1       meeting=Cancel_meeting2
#    Wait for Some Time    time=${wait_time}
#    Select Meeting      device=device_1    meeting=Cancel_meeting2
#    delete specific meeting    device=device_1    meeting=Cancel_meeting2
#    Refresh for Meeting Visibility      device=device_1
#    verify canceled meeting should not visible for organizer     device=device_1   meeting=Canceled: Cancel_meeting2
#    [Teardown]   Run Keywords    Capture on Failure  AND     Test Case Teardown without deleting meeting   devices=device_1
#
#TC4 : [OBO] TDC user adds DUT user as delegate with only Make call permission
#    [Tags]  308666    156779    P2  alt_blocked
#    [Setup]   Testcase Setup for Delegate User   count=3
#    Edit added delegates with Make call permission and validate    from_device=device_1    to_device=device_3
#    Refresh page for delegate user config changes visibility    device=device_3
#    Initiate OBO call using display name    from_device=device_3      to_device=device_2:delegate_user     obo_option=device_1
#    Verify calling behalf of device text    device=device_3  to_device=device_2:delegate_user     from_device=device_1
#    Verify Incoming call    device=device_2     status=appear
#    Verify on behalf of call text   device=device_2   from_device=device_3    obo_user=device_1
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]  run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1,device_2,device_3   AND    Edit added delegates with both permission and validate   from_device=device_1    to_device=device_3
#
#TC5 : [Outgoing Calls] [Make a call icon] DUT user calls PSTN user & TDC user from call icon
#    [Tags]  318571      P2
#    [Setup]  Testcase Setup for PSTN User    count=3
#    make outgoing call using from call icon    from_device=device_1      to_device=device_2:pstn_user
#    pick incoming call       device=device_2
#    verify call state   device_list=device_1,device_2    state=connected
#    disconnect call     device=device_1
#    verify call state   device_list=device_1,device_2    state=disconnected
#    make outgoing call using from call icon    from_device=device_1   to_device=device_3
#    pick incoming call       device=device_3
#    verify call state   device_list=device_1,device_3    state=connected
#    disconnect call     device=device_1
#    verify call state   device_list=device_1,device_3    state=disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2,device_3
#
#TC8 : [Calendar] Participant on Teams App can decline the meeting scheduled by teams client
#    [Tags]  146524   P2  alt_bug
#    [Setup]  Testcase Setup    count=2
#    create meeting  device=device_2     participants=device_1       meeting=Decline_meeting
#    Navigate to Calendar tab   device=device_1
#    Refresh for Meeting Visibility      device=device_1
#    Select Meeting      device=device_1    meeting=Decline_meeting
#    Check rsvp status   device=device_1
#    Respond to meeting     device=device_1     respond_option=Decline
#    [Teardown]   Run Keywords    Capture on Failure  AND     Test Case Teardown   devices=device_1,device_2
#
#TC10 : [Call Forward]DUT user redirects unanswered calls to PSTN number
#    [Tags]  308314   Call_forward    P1  alt_blocked
#    [Setup]  run keywords  Testcase Setup for PSTN User   count=3  AND     Enable unanswered call and add contact     from_device=device_1    contact_device=device_2:pstn_user
#    Click on calls tab   device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
#    Wait for Some Time    time=${wait_time3}
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Unanswered call Teardown    devices=device_1,device_2,device_3
#
#TC10 : [App Settings] Teams App user sign-out from the device
#    [Tags]  310356    P2  alt_credentials
#    [Setup]  Testcase Setup    count=1
#    Sign out cancel btn verify    device=device_1
#    Sign out ok btn verify    device=device_1
#    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1   AND     sign in method     device_1
#
#TC21 : [Calls] DUT user's call log in the recent tab entry displays the duration of call
#    [Documentation]  Devices are already signed-in in Suite Setup
#    [Tags]  308305   P1  alt_credentials
#    [Setup]  Testcase Setup    count=1
#    validate call duration or missed call    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1
#
#TC9 : [Outgoing Calls] Teams App user to see the call details for a call
#    [Tags]  146513      outgoing_calls   P2  alt_credentials
#    [Setup]  Testcase Setup    count=2
#    Click on calls tab   device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    go back to previous page    device=device_1
#    verify latest call details     from_device=device_1      to_device=device_2
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC20 : [Calls] DUT user's call log in the recent tab gets synced after making an outbound call to TDC user
#    [Documentation]  Devices are already signed-in in Suite Setup
#    [Tags]  308300   P1  alt_credentials
#    [Setup]  Testcase Setup    count=2
#    Click on calls tab   device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    return to home screen   device_list=device_1
#    Click on calls tab    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify call entries are synced in call log    from_device=device_2      to_device=device_1      state=duration
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2
#
#TC9 : [App Settings] Teams App user able to view the profile
#    [Tags]   310332   P2  alt_credentials
#    [Setup]  Testcase Setup    count=1
#    verify user profile view    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1
#
#TC9 : [CAP Policy] Call Park option disabled for CAP user
#    [Tags]  310299   p2  alt_blocked
#    [Setup]  Testcase Setup for CAP User   count=3
#    navigate to people tab from home screen for cap    device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    ${call_park_code}=    call park and get the code    device=device_1
#    Unpark Call    ${call_park_code}    device_3
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_3,device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1     AND    Come back to home screen   device_list=device_1,device_2,device_3
#TC8 :[CAP Policy] CAP user should not receive a missed call notification on the screen
#    [Tags]  310296    p2  alt_blocked
#    [Setup]   Testcase Setup for CAP User   count=2
#    repeat keyword  4 times     Give a missed call
#    Wait for Some Time    time=${wait_time}
#    verify missed call notification for cap user     device=device_1
#    [Teardown]  Run Keywords  Capture on Failure     AND    Come back to home screen    device_list=device_1,device_2
#
#TC8 : [App Settings] Teams App user to see the Terms of Use
#    [Tags]   146451   P3  alt_credentials
#    [Setup]  Testcase Setup    count=1
#    Verify terms of use view     device=device_1
#    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1
#
#TC10 : [SLA]Verify that options present inside the more info icon beside the delegates username under your delegates ,when delegate user is in call with other user
#    [Tags]      416772    P2
#    [Setup]  Testcase Setup for Delegate User  count=3
#    enable option in delegates permission    device=device_1     to_device=device_2:delegate_user        option=Join_active_calls
#    go back to previous page     device=device_1
#    click on calls tab   device=device_2
#    Initiate OBO call using display name    from_device=device_2      to_device=device_3    obo_option=device_1
#    Verify Incoming call    device=device_3    status=appear
#    Pick incoming call    device=device_3
#    wait for some time      time=${wait_time}
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    navigate to calls favorites page   device=device_1
#    verify and join call using join call in more option with boss and delegate   from_device=device_1      to_device=device_2:delegate_user        option=verify
#    wait for some time      time=${wait_time}
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call    device=device_2
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure     AND      Come back to home screen    device_list=device_1,device_2,device_3
#
#TC13: [App Settings] First thing in menu is the user Account signed-into the Teams app
#    [Tags]   318448     P2
#    [Setup]    Testcase Setup    count=1
#    Verify Device Users     user_list=user
#    [Teardown]    Run Keywords   Capture on Failure    AND   Home screen Disable    device=device_1
#
#TC12 :[OBO]DUT user to change "If unanswered" settings from DUT for People you support
#    [Tags]  310247   P2  alt_blocked
#    [Setup]    Testcase Setup for Delegate User  count=3
#    Click on calls tab   device=device_2
#    Validate People you support tab     device=device_2
#    Change call settings for boss and verify    device=device_2:delegate_user     boss=device_1    call_setting=if_unanswered
#    [Teardown]  run keywords  Capture on Failure    AND    Come back to home screen   device_list=device_1,device_2,device_3
#
#TC10 : [OBO]DUT user to change Also ring settings from DUT for People you support
#    [Tags]  310244   P2  alt_blocked
#    [Setup]   Testcase Setup for Delegate User  count=2
#    Click on calls tab   device=device_2
#    Validate People you support tab     device=device_2
#    Change call settings for boss and verify    device=device_2:delegate_user     boss=device_1    call_setting=also_ring
#    [Teardown]  run keywords  Capture on Failure    AND    Come back to home screen   device_list=device_1,device_2    AND     Disable Also Ring    device=device_1
#
#TC9 : [OBO]DUT user to change the delegates from DUT for People you support
#    [Tags]  310237   P2  alt_blocked
#    [Setup]   Testcase Setup for Delegate User  count=3
#    Click on calls tab   device=device_2
#    Validate People you support tab     device=device_2
#    Change delegates for boss and verify    device=device_2   boss=device_1   delegate=device_3
#    [Teardown]  run keywords  Capture on Failure   AND   Delete delegate from manage delegate   from_device=device_1    to_device=device_3    AND    Come back to home screen   device_list=device_1,device_2
#
#TC17:[Busy on Busy] DUT user to verify "When in another call" option should present under calling
#    [Tags]      451548     P2  phonesCY23_4
#    [Setup]  Testcase Setup    count=1
#    Verify settings calling option      device=device_1
#    verify when in another call option inside calling    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1
#
#TC:13 [Call Merge][1:1 call] Verify that correct name appears with Merge call in more option menu
#   [Tags]   318425     P2
#   [Setup]     Testcase Setup      count=3
#   Click on calls tab   device=device_2
#   Make outgoing call using display name    from_device=device_2   to_device=device_1
#   Pick incoming call    device=device_1
#   verify call state      device_list=device_1,device_2      state=Connected
#   Click on calls tab   device=device_3
#   Make outgoing call using display name    from_device=device_3   to_device=device_1
#   Pick incoming call from call notification    device=device_1
#   verify call state   device_list=device_1,device_3    state=Connected
#   verify call state    device_list=device_2     state=Hold
#   Verify and merge call  device=device_1    from_device=device_2     status=verify
#   resume call from call hold banner    device=device_1
#   Verify and merge call  device=device_1    from_device=device_3       status=verify
#   verify call state   device_list=device_1,device_2    state=Connected
#   verify call state    device_list=device_3     state=Hold
#   disconnect call       device=device_2,device_3
#   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
#   [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#TC10 : [Meeting]Verify that DUT user in a meeting and makes outgoing call
#    [Tags]   338882   p2
#    [Setup]  Testcase Setup    count=3
#    Join Meeting    device=device_1,device_2     meeting=test_meeting1
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    click back      device=device_1
#    navigate to calls tab    device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Disconnect call     device=device_3
#    resume call from call hold banner   device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3
#
#TC 23: [Meeting Reminder] DUT user can scroll the meeting notifications on home screen [landscape device]
#    [Tags]    310166
#    [Setup]    Testcase Setup    count=2
#    ${landscape_mode_flag}    is landscape device 5 inch or above    device=device_1
#    pass execution if    '${landscape_mode_flag}'=='False'  device_1, device screen size have less then 5 inch
#    create meeting   device=device_2    meeting=test_meeting2    participants=device_1,device_3
#    create meeting   device=device_2    meeting=test_meeting3    participants=device_1,device_3
#    Navigate To Calendar Tab    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Come back to home screen page and verify   device=device_1
#    Verify meeting notification scroll  device=device_1
#    Verify meeting present on home screen   device=device_1      meeting=test_meeting1
#    Verify meeting present on home screen   device=device_1      meeting=test_meeting2
#    Verify meeting present on home screen   device=device_1      meeting=test_meeting3
#    [Teardown]  Run Keywords    Capture on Failure  AND    Clear Meetings From Calendar Tab   device_1,device_2,device_3    exclude_meeting=test_meeting2,test_meeting3    AND    Come back to home screen     device_list=device_1,device_2
#
#TC12 : [Home screen] DUT user rejects the incoming call from Teams Desktop Client
#    [Tags]   310142     P2  alt_credentials
#    [Setup]   Testcase Setup    count=2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Rejects the incoming call    device_list=device_1
#    Verify Call State    device_list=device_2     state=Disconnected
#    Verify home screen page     device=device_1
#    [Teardown]    Capture on Failure
#
#TC7 : [Call Transfer] Verify DUT user to consult transfer the TDC user 1 call to another TDC user 2.
#    [Tags]      451452
#    [Setup]  Testcase Setup    count=3
#    click on calls tab   device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Verify Call State    device_list=device_3,device_1    state=Connected
#    Verify Call State    device_list=device_2    state=Hold
#    Completes the consultation to accept the call     from_device=device_1      to_device=device_2
#    Verify Call State    device_list=device_1     state=Disconnected
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC21 : [Home screen] DUT user to verify icons on Notification screen for Missed call, VM and Meeting notifications
#    [Tags]   310118     P2  alt_bug
#    [Setup]   Run Keywords   Testcase Setup    count=2    AND     Clear notification from home screen     device=device_1
#    Give a miss call    from_device=device_2      to_device=device_1
#    Verify missed call notification     to_device=device_1    from_device=device_2
#    Clear notification from home screen     device=device_1
#    Set Call Forwarding    device=device_1
#    Send Voicemail      from_device=device_2   to_device=device_1
#    Verify voicemail notification     to_device=device_1    from_device=device_2
#    Clear notification from home screen     device=device_1
#    Create meeting   device=device_1    meeting=meeting3    participants=device_2
#    Come back to Home Screen page and verify   device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify meeting notification    device=device_1
#    Clear notification from home screen     device=device_1
#    [Teardown]    Run Keywords   Capture on Failure    AND    Meeting Teardown     devices=device_1    meeting=meeting3   count=2    AND   verify and disable call forwarding    device=device_1
#
#TC19 : [Home screen] DUT user to be displayed with options on Notification screen, along with Meeting name
#    [Tags]   310115     P2  alt_bug
#    [Setup]   Run Keywords   Testcase Setup    count=2    AND     Clear notification from home screen     device=device_1
#    create meeting   device=device_1    meeting=meeting1    participants=device_2
#    Come back to Home Screen page and verify   device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify meeting notification    device=device_1
#    [Teardown]    Run Keywords   Capture on Failure    AND    Meeting Teardown     devices=device_1    meeting=meeting1   count=2
#
#
#TC6 : [Docked uBar] User to verify the options on call control bar
#    [Tags]    316256    p1
#    [Setup]  Testcase Setup    count=2
#    Join Meeting    device=device_1,device_2     meeting=meeting_dut
#    verify meeting state   device_list=device_1,device_2       state=connected
#    verify call control bar in meeting    device=device_1
#    End meeting        device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]    Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2
#
#TC8 : [Home screen] DUT user to verify Calendar on Home screen
#    [Tags]   310109     P2  alt_credentials
#    [Setup]   Testcase Setup    count=1
#    Navigate to calendar tab  device=device_1
#    Come back to Home Screen page and verify   device=device_1
#    [Teardown]    Capture on Failure
#
#TC29 : [Calendar App] Validate editing an all day meeting
#    [Tags]   320329   p2
#    [Setup]  Testcase Setup    count=1
#    create meeting      device=device_1    meeting=edit_all_day_meeting      all_day_meeting=on
#    Select Meeting      device=device_1        meeting=edit_all_day_meeting     all_day_meeting=on
#    Edit meeting name and validate    device=device_1    new_meeting=edit_all_day_meeting_edited       all_day_meeting=on
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown     devices=device_1
#
#TC11 : [Incoming calls] Verify there is no black screen while receiving / answering / after call is answered
#    [Tags]   314179
#    [Setup]  Testcase Setup    count=2
#    click on calls tab  device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Verify name of caller and receiver displayed    from_device=device_2      to_device=device_1
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    click on calls tab  device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Verify name of caller and receiver displayed    from_device=device_2      to_device=device_1
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC27 : Verify that Dark theme is accepted by Home screen
#    [Tags]  320297     P2
#    [Setup]   Testcase Setup    count=1
#    Verify and enable dark theme     device=device_1
#    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=1      AND    verify and disable dark theme     device_1
#
#TC11 : [Meetings] Validate the in call screen banner during back press of an ongoing meeting.
#    [Tags]   320283   p2
#    [Setup]  Testcase Setup    count=2
#    Join Meeting    device=device_1,device_2     meeting=test_meeting1
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    click back      device=device_1
#    tap to return to meeting    device=device_1
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2
#    TC8 : [Auto Dismiss] Verify that rate my call screen should appear if “Dismiss Rate My Call” Toggle is ON and User ends the Meeting.
#    [Tags]   320261    P2
#    [Setup]  Testcase Setup    count=2
#    enable dismiss rate my call toggle   device=device_1
#    verify dismiss rate my call toggle    device=device_1       toggle=on
#    return to home screen    device_list=device_1
#    create meeting  device=device_2       participants=device_1    meeting=dismiss_meeting
#    Join Meeting    device=device_1,device_2     meeting=dismiss_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    verify call rating screen after disconnect call     device=device_1
#    end meeting    device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2       AND     disable dismiss rate my call toggle    device=device_1
#
#TC7 : [Home screen] DUT user to verify Voicemail on Home screen
#    [Tags]   310018     P2  alt_credentials
#    [Setup]   Testcase Setup    count=1
#    Navigate to voicemail tab   device=device_1
#    Come back to Home Screen page and verify   device=device_1
#    [Teardown]    Capture on Failure
#
#TC6 : [Home screen] DUT user to verify Contacts on Home screen
#    [Tags]   310016     P2  alt_bug
#    [Setup]   Testcase Setup    count=1
#    Navigate to people tab   device=device_1
#    Come back to Home Screen page and verify   device=device_1
#    [Teardown]    Capture on Failure
#
#TC4 : [Outgoing Calls] DUT user to dial digits on make a call interface and initiate an outgoing call
#    [Tags]  312064
#    [Setup]  Testcase Setup    count=2
#    click on calls tab   device=device_1
#    ${status}    is dialpad supported    device=device_1
#    pass execution if  ${status} is ${false}    device_1, the device doesn't support soft dialpad
#    place outgoing call from soft dialpad    from_device=device_1   to_device=device_2
#    verify incoming call   device=device_2   status=appear
#    pick incoming call   device=device_2
#    verify call state   device_list=device_1,device_2    state=connected
#    disconnect call  device=device_1
#    verify call state   device_list=device_1,device_2    state=disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2
#
#TC5 : [Home screen] DUT user to verify Calls on Home screen
#    [Tags]   310012     P2  alt_credentials
#    [Setup]   Testcase Setup    count=1
#    Navigate to calls tab   device=device_1
#    Come back to Home Screen page and verify   device=device_1
#    [Teardown]    Capture on Failure
#
#TC3 : [Home screen] DUT user should be able to view notifications in Notification screen
#    [Tags]   310004     P2  alt_credentials
#    [Setup]   Run Keywords   Testcase Setup    count=2    AND   Set Call Forwarding    device=device_1
#    Clear notification from home screen     device=device_1
#    Click on calls tab   device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Wait for Some Time    time=${wait_time3}
#    Verify Call State    device_list=device_2   state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2     state=Disconnected
#    Wait for Some Time    time=${wait_time}
#    Verify home screen notification view     device=device_1
#    [Teardown]    Run Keywords   Capture on Failure    AND    verify and disable call forwarding    device=device_1
#
#TC6 : [Auto Dismiss] Verify selected Dismiss Rate My Call options should not get changed when tap on back button on call setting page.
#    [Tags]   320222    P2
#    [Setup]  Testcase Setup    count=1
#    enable dismiss rate my call toggle   device=device_1
#    verify dismiss rate my call toggle    device=device_1       toggle=on
#    click back  device=device_1
#    navigate to user survey     device=device_1
#    verify dismiss rate my call toggle    device=device_1       toggle=on
#    [Teardown]   Run Keywords    Capture on Failure     AND    Come back to home screen    device_list=device_1       AND     disable dismiss rate my call toggle    device=device_1
#
#TC16 : [People] Teams user to add the contacts to groups in people tab
#    [Tags]  174821   P2  alt_bug
#    [Setup]  Testcase Setup    count=2
#    Add from directory   from_device=device_1    to_device=device_2     group_name=Tagged
#    verify added group name for user     from_device=device_1    to_device=device_2     group_name=Tagged
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    Remove user from group  from_device=device_1    to_device=device_2     group_names=Tagged
#
#TC3 : [Call views] DUT user to cancel the selection in Default view and selects other options
#    [Tags]   309991     P2  alt_credentials
#    [Setup]    Run keywords     Testcase Setup    count=1    AND     Verify Default view relaunches after changing the value     device=device_1     option=recent call history
#    Select and cancel default value     device=device_1     option=recent call history
#    Select default view    device=device_1     option=speed dial
#    Validate calls tab after default value change    device=device_1      default_option=speed dial
#    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1   AND     Verify Default view relaunches after changing the value     device=device_1     option=speed dial
#
#TC6: [Private meetings] User to verify the meeting title after joining the meeting when privacy toggle is turned off on the device
#    [Tags]  311122        P1
#    [Setup]    Testcase Setup   count=2
#    disable show meeting names  device=device_1
#    verify and join meeting when show meeting title toggle is off     device=device_1     organizer_name=device_2       meeting=hide_meeting_names
#    Verify meeting state   device_list=device_1   state=Connected
#    End meeting     device=device_1
#    Verify meeting state    device_list=device_1   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2
#
#TC12: [Private meetings] User to verify all-day meetings in calendar tab when privacy toggle is turned off on the device
#    [Tags]  311114        P2
#    [Setup]    Testcase Setup   count=2
#    disable show meeting names  device=device_1
#    verify meeting title shows meeting organizer name   device=device_1      organizer=device_2     all_day_meeting=on
#    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2
#
#TC4: [Private meetings] User to verify "Meetings" option under Teams settings
#    [Tags]    311104        P1
#    [Setup]    Testcase Setup   count=1
#    verify meetings option under app settings page  device=device_1
#    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1
#
#TC3: [Private meetings] User to verify the presence of "Meetings" option under Teams settings
#    [Tags]    311101        P1
#    [Setup]    Testcase Setup   count=1
#    verify meetings btn presence under app settings  device=device_1
#    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1
#
#
#TC 4: [Auto Restart] DUT user checks App Restart option disabled by default.
#    [Tags]  319288   P2
#    [Setup]  Testcase Setup  count=1
#    verify app restart toggle button    device=device_1     toggle=off
#    [Teardown]  Run Keywords    Capture on Failure     AND   Come back to home screen    device_list=device_1
#
#
#TC 5: [Auto Restart] DUT user to verify Auto Restart option in settings page.
#    [Tags]  319287   P2
#    [Setup]  Testcase Setup  count=1
#    open settings page       device=device_1
#    verify auto restart option inside settings page      device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#
#TC29:[Audio Channel] Device gets the call while being on hold with audio channel set to speaker/headset/handset.
#    [Tags]    306957    certification_audio    ftp_scope
#    [Setup]    Testcase Setup    count=3
#    ${Cvolume}    current volume level    device=device_1    volume_stream=calling
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Verify Incoming call    device=device_1     status=appear
#    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    compare volume    device=device_1    volume=${Cvolume}    volume_stream=calling    volume_state=constant
#    press specific hardkey    device=device_1    hard_key=HEADSETHOOK      status=on
#    compare volume    device=device_1    volume=${Cvolume}    volume_stream=calling    volume_state=constant
#    press specific hardkey    device=device_1    hard_key=HANDSETHOOK      status=on
#    compare volume    device=device_1    volume=${Cvolume}    volume_stream=calling    volume_state=constant
#    Hold the call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Hold
#    click on calls tab  device=device_3
#    Make outgoing call using display name    from_device=device_3      to_device=device_1
#    Verify incoming call notification    device=device_1
#    pick incoming call from call notification    device=device_1
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Disconnect call      device=device_2,device_3
#    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
#    Verify Multiple Intents    device=device_1     features_list=PHONE_STATE_UPDATED   intents_list=headset_on,speaker_on,handset_on
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#
#TC25 :[Audio Channel]DUT user can switch from headset to handset in a P2P call
#    [Tags]   306945    Certification_Audio    FTP_Scope
#    [Setup]    Testcase Setup    count=2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Verify Incoming call    device=device_1     status=appear
#    press specific hardkey    device=device_1    hard_key=HEADSETHOOK    status=ON
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    increase volume and verify    device=device_1    volume_stream=calling
#    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON
#    Verify Multiple Intents    device=device_1     features_list=PHONE_STATE_UPDATED   intents_list=speaker_off,headset_off,handset_on
#    Wait for Some Time    time=${5_minutes_wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC32 :[Audio Channel]DUT user can switch from handset to speaker in a P2P call
#    [Tags]   306941    Certification_Audio    FTP_Scope
#    [Setup]    Testcase Setup    count=2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Verify Incoming call    device=device_1     status=appear
#    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    increase volume and verify    device=device_1    volume_stream=calling
#    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
#    Verify Multiple Intents    device=device_1     features_list=PHONE_STATE_UPDATED   intents_list=speaker_on,headset_off,handset_off
#    Wait for Some Time        time=5 minutes
#    decrease volume and verify    device=device_1    volume_stream=calling
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Wait for Some Time        time=5 minutes
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#
#TC6 :[Audio Channel]DUT user can switch from headset to speaker in a P2P call
#    [Tags]   306937    Certification_Audio    FTP_Scope
#    [Setup]    Testcase Setup    count=2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Verify Incoming call    device=device_1     status=appear
#    press specific hardkey    device=device_1    hard_key=HEADSETHOOK    status=ON
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    increase volume and verify    device=device_1    volume_stream=calling
#    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
#    Verify Multiple Intents    device=device_1     features_list=PHONE_STATE_UPDATED   intents_list=speaker_on,headset_off,handset_off
#    Wait for Some Time    time=5 minutes
#    decrease volume and verify    device=device_1    volume_stream=calling
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Wait for Some Time    time=5 minutes
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC1 : [Meetings] DUT user to verify the links in the meeting description page
#    [Tags]  311022   p2  alt_bug
#    [Setup]   Run Keywords   Testcase Setup   count=1    AND    Create meeting   device=device_1
#    Navigate to Calendar tab   device=device_1
#    Verify the meeting description page     device=device_1
#    [Teardown]    Capture on Failure
#
#TC27 :[Audio Channel] DUT user to Test call accept/terminate by pressing the Headset/Speaker Button
#    [Tags]    306919    certification_audio
#    [Setup]   Testcase Setup    count=2
#    Select default view value option    device=device_1    option=call dialpad    verify_options_under_default_view=on
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Verify Incoming call    device=device_1     status=appear
#    press specific hardkey    device=device_1    hard_key=SPEAKER      status=on
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    press specific hardkey    device=device_1    hard_key=SPEAKER      status=off
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Verify Incoming call    device=device_1     status=appear
#    press specific hardkey    device=device_1    hard_key=HEADSETHOOK      status=on
#    verify dialpad after clicking speaker or handsethook button    device=device_1    status=absent
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    press specific hardkey    device=device_1    hard_key=HEADSETHOOK      status=off
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    Verify Multiple Intents    device=device_1     features_list=PHONE_STATE_UPDATED   intents_list=speaker_on,headset_on
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC 7 :[Multiple calls] DUT user on DUT settings page, receives multiple calls.
#    [Tags]  308899    P1
#    [Setup]  Testcase Setup   count=3
#    open settings page   device=device_1
#    initiate simultaneous call  devices=device_2,device_3   target_device=device_1    method=display_name
#    verify multiple incoming calls  device=device_1
#    accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept    count=3
#    disconnect call   device_1
#    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3
#
#TC 14 : [Multiple calls] DUT user on voicemail tab, receives multiple calls.
#    [Tags]  308893   P2
#    [Setup]  Testcase Setup   count=3
#    Navigate to voicemail tab    device=device_1
#    initiate simultaneous call  devices=device_2,device_3   target_device=device_1    method=display_name
#    verify multiple incoming calls  device=device_1
#    accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept    count=3
#    disconnect call   device_1
#    navigate to calls tab   device=device_1
#    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3
#
#TC 12 : [Multiple calls] DUT user on meeting tab, receives multiple calls.
#    [Tags]  308887   P2
#    [Setup]  Testcase Setup   count=3
#    navigate to calendar tab   device=device_1
#    initiate simultaneous call  devices=device_2,device_3   target_device=device_1    method=display_name
#    verify multiple incoming calls  device=device_1
#    accept multiple incoming calls   device=device_1    full_screen_call=accept     notification_call=accept       count=3
#    disconnect call   device_1
#    navigate to calls tab   device=device_1
#    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3
#
#
#TC24 : [Meet now] Verify DUT user can start/stop recording in meeting initiated from Meet now
#    [Tags]    319615    p2
#    [Setup]   Testcase Setup    count=3
#    Navigate to Calendar tab   device=device_1
#    Tap on Meet Now icon and validate   device=device_1
#    Initiated a conference call from Meet now    device=device_1
#    Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3
#    pick incoming call    device=device_3
#    pick incoming call    device=device_2
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    start recording call    device=device_1
#    verify recording notification on screen     device=device_1
#    stop recording call     device=device_1
#    end meeting  device=device_1,device_2,device_3
#    Verify meeting state   device_list=device_1,device_2,device_3    state=disconnected
#    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND   Come back to home screen    device_list=device_1,device_2,device_3
#
#
#TC8: [Meetings]Verify that no meeting name is shown in calendar or notification
#    [Tags]    311482        P2
#    [Setup]    Testcase Setup   count=2
#    navigate to calendar tab    device=device_1
#    verify meeting title shows meeting organizer name  device=device_1      organizer=device_2
#    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2
#
#TC1 : User Sign In and Sign Out Intent for Different Users
#    [Tags]  308923  P1  alt_blocked
#    [Setup]  Testcase Setup     count=1
#    Reset Logcat Capture    device=device_1
#
#    Sign Out    device_list=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Intents      device=device_1     intent=sign_out     user=user
#
#    Sign In     device_list=device_1    user_list=cap_search_enabled
#    Wait for Some Time    time=${wait_time}
#    Verify Intents      device=device_1     intent=sign_in     user=cap_search_enabled
#
#    Sign Out    device_list=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Intents      device=device_1     intent=sign_out     user=cap_search_enabled
#
#    Sign In     device_list=device_1    user_list=user
#    Wait for Some Time    time=${wait_time}
#    Verify Intents      device=device_1     intent=sign_in     user=user
#
#    [Teardown]    Capture on Failure
#
#
#TC5 : [Emergency Calling] DUT user does not have the option to transfer the emergency call to any other user or number.
#    # Dial 933 for Emergency Calling
#    [Tags]  308518   P3  alt_blocked
#    [Setup]  Testcase Setup    count=1
#    Click on calls tab   device=device_1
#    Dial emergency num and validate    device=device_1
#    Validate Transfer for Emergency Calling     device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1
#
#TC2 : [Meet now] Tapping on Meet now should initiate a conference call
#    [Tags]    310565        bvt_pr         alt_credentials
#    [Setup]   Testcase Setup    count=1
#    Navigate to Calendar tab   device=device_1
#    Verify meet now icon    device=device_1
#    Tap on Meet Now icon and validate   device=device_1
#    Close meet now conference page    device=device_1
#    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1
#

#TC2 : [Presence] Verify that if Device (Teams App) changes Presence, it should reflect on both TDC and Teams App
#    [Tags]  146651   P1  alt_credentials
#    [Setup]   Testcase Setup    count=1
#    Select user presence   device=device_1     state=Busy
#    Verify user presence   device=device_1     state=Busy
#    [Teardown]   run keywords    Capture on Failure    AND   Select user presence   device=device_1     state=Available     AND    Come back to home screen    device_list=device_1
#
#
#TC9 : [Presence] Teams App user can see the correct presence in Voice mail tab (in the form of presence icon only)
#    [Tags]  146650    p1  alt_credentials
#    [Setup]   Run Keywords     Testcase Setup    count=2    AND     Voicemail Setup
#    Navigate to voicemail tab    device=device_1
#    Verify 1st vm presence status      device=device_1
#    [Teardown]    Run Keywords    Capture on Failure    AND     Voicemail Teardown
#
#

#TC4 : [Presence] Presence should not change from "Away" to "In a call" when the user makes a call
#    [Tags]  146647    p1  alt_credentials
#    [Setup]  Testcase Setup    count=2
#    Select user presence   device=device_1     state=Away
#    Verify user presence   device=device_1     state=Away
#    click on calls tab   device=device_1
#    Make outgoing call using from call icon    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Verify user presence from other user    from_device=device_2      to_device=device_1     state=Away
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    Wait for Some Time    time=${wait_time}
#    Verify user presence from other user    from_device=device_2      to_device=device_1     state=Away
#    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2     AND    Select user presence   device=device_1     state=Available
#
#
#TC3 : [Presence] Presence changes to "In a call" from "Busy" when the user makes a call
#    [Tags]  146646   p1  alt_credentials
#    [Setup]  Testcase Setup    count=2
#    Select user presence   device=device_1     state=Busy
#    Verify user presence   device=device_1     state=Busy
#    click on calls tab   device=device_1
#    Make outgoing call using from call icon    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Verify user presence from other user    from_device=device_2      to_device=device_1     state=In call
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#

#TC3 : Verify that Shared line app with a New badge should Present inside the More app, when TDC user add DUT user as delegate
#    [Tags]  435339   P2
#    [Setup]   Testcase Setup  count=2
#    Clear notification from home screen     device=device_1
#    verify user in people you support page     from_device=device_1    to_device=device_2
#    verify shared lines option in more option     device=device_1
#    verify home screen tabs and more option tabs      device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#
#TC1 : [Multi Call Banner] DUT user holds the incoming call with TDC user
#    [Tags]  311896    P1
#    [Setup]   Testcase Setup   count=2
#    click on calls tab   device=device_2
#    Make outgoing call using display name    from_device=device_2     to_device=device_1
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Hold the call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Hold
#    verify call hold banner   from_device=device_1   to_device=device_2
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC8 : [Calls] Verify Voicemail app on home screen
#    [Tags]      401961    P2
#    [Setup]  Testcase Setup    count=1
#    Navigate to voicemail tab    device=device_1
#    refresh the page    device=device_1
#    Click on voicemail play button and validate    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1
#
#
#TC6 : [Calls] Verify Dial pad icon on Recent tab
#    [Tags]      401956    P1
#    [Setup]  Testcase Setup    count=1
#    verify is portrait device       device=device_1
#    Select call list item   device=device_1  item=favorite
#    Select default view value   device=device_1     option=recent call history
#    Validate calls tab after default value change    device=device_1      default_option=recent call history
#    navigate to calls tab       device=device_1
#    Verify call history log    device=device_1
#    [Teardown]   Run keywords    verify is portrait device       device=device_1    AND    Select default view and teardown
#

#TC4 : [Multiple Call Banner] DUT user holds the incoming call with another DUT user
#    [Tags]  311904    P1
#    [Setup]   Testcase Setup   count=2
#    click on calls tab   device=device_2
#    Make outgoing call using display name    from_device=device_2     to_device=device_1
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Hold the call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Hold
#    verify call hold banner   from_device=device_1   to_device=device_2
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC8 : [Multiple Call Banner] DUT user to tap on the banner when call is on hold with TDC user
#    [Tags]  311915    P1
#    [Setup]   Testcase Setup   count=2
#    click on calls tab   device=device_1
#    Make outgoing call using display name    from_device=device_1     to_device=device_2
#    Pick incoming call   device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Hold the call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Hold
#    click back      device=device_1
#    verify call hold banner   from_device=device_1    to_device=device_2
#    tap on the banner    device=device_1
#    Disconnect call      device=device_1
#    verify call state and disconnect        device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC13 : [Walkie-Talkie] DUT user to select the channel in Walkie Talkie tab.
#    [Tags]      311924     P2
#    [Setup]  Testcase Setup  count=1
#    navigate to walkie talkie tab  device=device_1
#    select the channel  device=device_1     channel=Channel_1
#    verify selected channel name in walkie talkie tab   device=device_1     channel=Channel_1
#    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1
#
#TC12 : [Multiple Call Banner] DUT user to park the outgoing call with TDC
#    [Tags]  311928   P1
#    [Setup]   Testcase Setup   count=2
#    click on calls tab   device=device_1
#    Make outgoing call using display name    from_device=device_1    to_device=device_2
#    Pick incoming call   device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    call park and get the code   device=device_1
#    verify call park banner    from_device=device_1     to_device=device_2
#    tap on the banner    device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Connected
#    Disconnect call      device=device_2
#    verify call state and disconnect        device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND     dismiss multiple call park banner   device=device_1        AND    Come back to home screen    device_list=device_1,device_2
#
#TC16 : [Walkie-Talkie] DUT user to verify the Walkie talkie screen in disconnected state.
#    [Tags]  311978  P2
#    [Setup]  Testcase Setup  count=1
#    navigate to walkie talkie tab  device=device_1
#    verify connect when no channel is selected  device=device_1
#    select the channel  device=device_1     channel=Channel_1
#    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1
#
#TC27 : [Walkie-Talkie] User to verify the reorder of Walkie Talkie tab
#    [Tags]      311986      P2
#    [Setup]  Testcase Setup  count=1
#    ${before_home_screen_tiles}=    get home screen tiles    device=device_1
#    ${destination_tab}=     get destination tab on home screen except walkie talkie    device=device_1
#    Navigate to reorder tab     device=device_1
#    Verfy and reorder homescreen tiles   device=device_1    tab=walkie talkie    destination=${destination_tab}
#    ${after_home_screen_tiles}=    get home screen tiles    device=device_1
#    verify updated home screen tile after editing       before_changing=${before_home_screen_tiles}         after_changing=${after_home_screen_tiles}
#    Navigate to tab     device=device_1        tab=walkie talkie
#    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen     device_list=device_1
#
#TC18 : [Walkie-Talkie] DUT to Select Channel from the existing channels list
#    [Tags]      311992     P2
#    [Setup]  Testcase Setup  count=1
#    navigate to walkie talkie tab  device=device_1
#    verify suggested channels and your channels     device=device_1     channel=Channel_1,Channel_2
#    select the channel  device=device_1     channel=Channel_1
#    verify selected channel name in walkie talkie tab   device=device_1     channel=Channel_1
#    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1
#

#TC4 : [Walkie-Talkie] DUT user to tap and connect to Walkie Talkie
#    [Tags]  312431      P1
#    [Setup]  Testcase Setup  count=1
#    navigate to walkie talkie tab  device=device_1
#    verify connect when no channel is selected  device=device_1
#    select the channel  device=device_1     channel=Channel_1
#    click on connect and verify mic  device=device_1
#    click on disconnect and verify mic  device=device_1
#    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1
#
#TC 3 : [Multiple calls] DUT user is on calls tab, receives multiple calls and accept from notification
#    [Tags]  308868   P2
#    [Setup]  Testcase Setup  count=3
#    click on calls tab    device=device_1,device_2,device_3
#    initiate simultaneous call  devices=device_2,device_3   target_device=device_1    method=display_name
#    verify multiple incoming calls  device=device_1
#    accept multiple incoming calls  device=device_1   full_screen_call=reject    notification_call=accept
#    verify in call ribbon from main tab  device=device_1
#    disconnect call   device_1
#    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3
#
#TC6 : [Calendar]Teams App user joins the meeting scheduled without any title
#    [Tags]  146525   P2  alt_bug
#    [Setup]    Testcase Setup   count=2
#    create meeting  device=device_2       participants=device_1    meeting=
#    Join Meeting    device=device_2,device_1     meeting=(No title)
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Wait for Some Time    time=${wait_time}
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND     Test Case Teardown without deleting meeting   devices=device_1,device_2

# TC10 : [Meet now] Ending the conference call should redirect Teams App user to homescreen
#     [Tags]    221522    p2  alt_blocked
#     [Setup]   Testcase Setup    count=4
#     Navigate to Calendar tab   device=device_1
#     Tap on Meet Now icon and validate   device=device_1
#     Initiated a conference call from Meet now    device=device_1
#     Wait for Some Time    time=${wait_time}
#     Verify meeting state   device_list=device_1    state=Connected
#     Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3,device_4
#     pick incoming call    device=device_2,device_3,device_4
#     Verify meeting state   device_list=device_1,device_2,device_3,device_4    state=Connected
#     End meeting     device=device_1,device_2,device_3
#     Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
#     [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4


# TC13 : [Meet now] Teams App user can check more options during meeting
#     [Tags]    221532    p1  alt_bug
#     [Setup]   Testcase Setup    count=3
#     Navigate to Calendar tab   device=device_1
#     Tap on Meet Now icon and validate   device=device_1
#     Initiated a conference call from Meet now    device=device_1
#     Wait for Some Time    time=${wait_time}
#     Verify meeting state   device_list=device_1    state=Connected
#     Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3
#     pick incoming call    device=device_2,device_3
#     Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#     Verify meeting more options     device=device_1
#     End meeting     device=device_1,device_2,device_3
#     Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
#     [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3

# TC14 : [Meet now] Verify Teams App user is able to view the Live caption during meeting
#     [Tags]    221538    p2  alt_bug
#     [Setup]   Testcase Setup    count=3
#     Navigate to Calendar tab   device=device_1
#     Tap on Meet Now icon and validate   device=device_1
#     Initiated a conference call from Meet now    device=device_1
#     Wait for Some Time    time=${wait_time}
#     Verify meeting state   device_list=device_1    state=Connected
#     Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3
#     pick incoming call    device=device_2,device_3
#     Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#     Turn on Live caption     device=device_1
#     Wait for Some Time    time=${wait_time}
#     Turn off Live caption     device=device_1
#     End meeting     device=device_1,device_2,device_3
#     Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
#     [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3

# TC3 : [Meet now] Start Meet now and add/remove participant in the meeting
#     [Tags]    310493     bvt_tp  sanity_tp    p0        alt_bug
#     [Setup]   Testcase Setup    count=2
#     Navigate to Calendar tab   device=device_1
#     Tap on Meet Now icon and validate   device=device_1
#     Initiated a conference call from Meet now    device=device_1
#     Wait for Some Time    time=${wait_time}
#     Verify meeting state   device_list=device_1    state=Connected
#     Add participant to conversation using display name   from_device=device_1      to_device=device_2
#     pick incoming call    device=device_2
#     Verify meeting state   device_list=device_1,device_2    state=Connected
#     End meeting     device=device_1,device_2
#     Verify meeting state    device_list=device_1,device_2    state=Disconnected
#     [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1,device_2
#
#TC16 : [Hot Desking] Device settings access should be available for Hot desk user
#    [Tags]  309150   P1
#    [Setup]  Testcase Setup    count=2
#    Hot desking signin   device=device_1     hot_desk_account=device_2
#    Verify hot desking mode  device=device_1
#    Verify settings page in HD mode    device=device_1
#    click device settings       device=device_1
#    device setting back     device=device_1
#    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2     AND   End hot desk    device=device_1
#
#TC3: [Private meetings] User to verify meeting titles in calendar tab when privacy toggle is turned off on the device
#    [Tags]    311111        P1
#    [Setup]    Testcase Setup   count=2
#    disable show meeting names  device=device_1
#    verify meeting title shows meeting organizer name  device=device_1      organizer=device_2
#    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2
#
#TC3: [Add participant]Verify 'Add participant' option on roster when user is a presenter [Group call]
#    [Tags]      321996      P2
#    [Setup]  Testcase Setup     count=3
#    click on calls tab  device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Add participant to conversation using display name  from_device=device_2      to_device=device_3
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    verify participant list     from_device=device_1      connected_device_list=device_1,device_2,device_3
#    Verify add participant button should visible for presenter    device=device_1
#    Disconnect call     device=device_1,device_3
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC2 : [Call hand off] Verify DUT should join the call when clicked on Transfer to this device option
#    [Tags]   247720     p1  alt_credentials
#    [Setup]  Testcase Setup for Call hand off    count=3
#    click on calls tab   device=device_3
#    Make outgoing call using display name    from_device=device_3      to_device=device_2
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Verify call hand off banner     device=device_1
#    Tap on Join Button from banner    device=device_1
#    Validate both options for joining meeting    device=device_1
#    Select option to join meeting    device=device_1     option=Transfer to this device
#    Wait for Some Time    time=${wait_time}
#    Verify your call was transferred text    device=device_2
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3
#
#TC6: [Meetings] Verify when user enable & disable "Show meeting names" toggle multiple times, changes must reflect accordingly
#    [Tags]    311566        P2
#    [Setup]    Testcase Setup   count=1
#    Verify meetings option under App settings page     device=device_1
#    Enable show meeting names option    device=device_1
#    Disable show meeting names option  device=device_1
#    Enable show meeting names option    device=device_1
#    Disable show meeting names option  device=device_1
#    Enable show meeting names option    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure    AND   Come back to home screen    device_list=device_1       AND   disable show meeting names  device=device_1
#
#TC5 : [Customer Love] Verify appbar title when appearance is changed to Dark Theme
#    [Tags]      401623     P2
#    [Setup]   Testcase Setup    count=1
#    verify and enable dark theme     device=device_1
#    verify app bar title with date time and DID number    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1        AND    verify and disable dark theme     device=device_1
#
#
#TC14 :[Call forward on home screen] Verify DUT after adding contact or number from TDC /DUT.
#    [Tags]  452548      P2
#    [Setup]  Testcase Setup    count=3
#    verify display home screen toggle status under calling        device=device_1       status=on
#    verify call forwarding icon     device=device_1
#    verify and set call forwarding on home screen     device=device_1         option=contact_or_number        to_device=device_2
#    click on calls tab   device=device_3
#    Make outgoing call using display name    from_device=device_3      to_device=device_1
#    Verify Incoming call    device=device_1    status=disappear
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_3,device_2    state=Disconnected
#    Verify call entries are synced in call log     from_device=device_1      to_device=device_3      state=forwarded_to
#    [Teardown]   run keywords  Capture on Failure    AND    dismiss call forwarding pop up on home screen       device=device_1    AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC4 : [Call hand off] Verify that DUT to add PSTN to the call
#    [Tags]   247772     p2  alt_blocked
#    [Setup]  Testcase Setup for Call hand off    count=4
#    Sign out method     device=device_3
#    Sign in method    device=device_3   user=pstn_user
#    click on calls tab   device=device_4
#    Make outgoing call using display name    from_device=device_4      to_device=device_2
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_2,device_4    state=Connected
#    Verify call hand off banner     device=device_1
#    Tap on Join Button from banner    device=device_1
#    Validate both options for joining meeting    device=device_1
#    Select option to join meeting    device=device_1     option=Add this device
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_4    state=Connected
#    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_3:pstn_user
#    Pick incoming call    device=device_3
#    Disconnect call     device=device_1,device_2,device_3
#    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4

#Deleted from the test plan
#TC:15 [App bar] CAP account should have only Calls and people apps by default
#    [Tags]  207972  P2
#    [Setup]   Testcase Setup for CAP User   count=1
#    Verify that sign in is successful   device_list=device_1     state=Sign in
#    Validate default app present on main screen  device=device_1
#    Validate reorder of apps    device=device_1    tab=Calls tab   destination=More tab
#    Validate home screen after reorder of apps  device=device_1   tab=Calls tab,People tab
#    [Teardown]    Run Keywords    Capture on Failure    AND   Come back to home screen    device_list=device_1  AND   Device Setting Teardown   device=device_1

#TC18 : [Call hand off] Verify DUT can able tap use dialpad during call
#    [Tags]   260973     p2
#    [Setup]  Testcase Setup for Call hand off    count=3
#    click on calls tab     device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Verify call hand off banner     device=device_1
#    Tap on Join Button from banner    device=device_1
#    Validate both options for joining meeting    device=device_1
#    Select option to join meeting    device=device_1     option=Add this device
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Verify dialpad in call control    device=device_1
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3
#
#TC8 : [Call Handoff] Verify that DUT2 has entered the call and DUT1 has left the call when user tap on “Transfer to this device”.
#    [Tags]   260986     p1
#    [Setup]  Testcase Setup for Call hand off    count=3
#    click on calls tab     device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
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
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3
#
#TC6 : [Incoming Calls] Teams App does not display video option in call toast for an incoming video call
#    [Tags]  196666    P3
#    [Setup]   Testcase Setup for Meeting User    count=2
#    Make Video call using phonenumber   from_device=device_2     to_device=device_1:meeting_user
#    Verify display name on call toast   to_device=device_1    from_device=device_2
#    Verify Incoming call    device=device_1     status=Appear
#    Rejects the incoming call     device_list=device_1
#    [Teardown]  run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1,device_2
#
#TC1 : [Calendar] Teams App should show up recurrence indicator in the Meeting tab for recurrence meeting
#    [Tags]  179963  144826   P1
#    [Setup]    run keywords   Testcase Setup for Meeting User   count=2   AND   Meeting Setup   count=2
#    create meeting  device=device_2       participants=device_1:meeting_user    meeting=recurring_meeting    repeat=Every weekday (Mon-Fri)
#    Refresh cnf device for meeting visibility   device=device_1
#    verify conf meeting recurrence indicator    device=device_1    meeting=recurring_meeting
#    Verify meeting series   device=device_1     meeting=recurring_meeting
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_2    count=2
#
#TC3 :[Search] Search for a contact with complete contact name in Teams App
#     [Tags]    196429  P1
#     [Setup]   Testcase Setup for Meeting User   count=2
#     Navigate to people tab    device=device_1
#     verify search text   from_device=device_1     to_device=device_2
#     Validate search results presented    device=device_1
#     [Teardown]    Run Keywords   Capture on Failure  AND   Come back to home screen   device_list=device_1,device_2
#
#TC4 : [Esc to Conf.] DUT user in P2P call with another DUT user, adds Teams Client to call
#    [Tags]  196613     P1
#    [Setup]  Testcase Setup for Meeting User    count=3
#    Navigate to people tab    device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    disconnect call       device=device_1,device_2
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC16 : Verify that DUT user should be able to answer the call/meeting from "Privacy & Cookies" page under About in settings.
#    [Tags]   348886    P0
#    [Setup]   Testcase Setup for Meeting User   count=2
#    verify options inside about page     device=device_1
#    navigate to privacy and cookies from about page    device=device_1
#    click on calls tab     device=device_2
#    make outgoing call using display name    from_device=device_2     to_device=device_1:meeting_user
#    Pick incoming call      device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2     state=Connected
#    Disconnect call    device=device_2
#    navigate to home screen from about page  device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2


# TC15 : [Call Merge] Verify an active call can be merged into an MoH call.
#     [Tags]       306098
#     [Setup]  Testcase Setup for Meeting User    count=3
#     Navigate to people tab    device=device_1
#     Make outgoing call using display name    from_device=device_1   to_device=device_2
#     Pick incoming call    device=device_2
#     Wait for Some Time    time=${wait_time}
#     verify call state      device_list=device_1,device_2      state=Connected
#     Hold the call   device=device_1
#     Verify Call State    device_list=device_1,device_2     state=Hold
#     Come back to home screen    device_list=device_1    disconnect=False
#     Navigate to people tab    device=device_1
#     Make outgoing call using display name    from_device=device_1            to_device=device_3
#     Pick incoming call   device=device_3
#     Wait for Some Time    time=${wait_time}
#     verify call state    device_list=device_1,device_3     state=Connected
#     verify call state    device_list=device_2              state=Hold
#     Verify and merge call  device=device_1    from_device=device_2
#     Verify call state   device_list=device_1,device_2,device_3    state=Connected
#     disconnect call       device=device_1,device_2
#     Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
#     [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3

#TC6 :[Reactions] DUT user to verify the reaction of TDC user when TDC user is displayed on the main stage of DUT user
#    [Tags]  248195   p2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Join Meeting    device=device_1,device_2     meeting=Reactions       join_styles=conference,None
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    Verify reaction button in call control     device=device_2
#    Tap on reaction button in call control      device=device_2
#    Tap on like button     device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2  state=Disconnected
#    [Teardown]   run keywords   Capture on Failure    AND    test case teardown    devices=device_1,device_2   count=2
#
#TC3 : [Structured Meetings] No other user "Presenter/Attendee" can change the role of organizer
#    [Tags]   312815    P0    sanity_tpc  bvt_tpc
#    [Setup]  Testcase Setup for Meeting User    count=3
#    Join Meeting    device=device_2,device_1,device_3     meeting=structured_meeting     join_styles=None,conference,None
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    verify no option to change organizer role  from_device=device_1    to_device=device_2
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND        Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3     count=3
#
#TC3: [Sign-in] User to sign-in from another device (web sign-in)
#    [Tags]      308380      sanity_tpc    bvt_tpc      auth_tpc    auth_tpc_p0
#    [Setup]  Testcase Setup for Meeting User    count=1
#    sign out method  device=device_1
#    verify teams app signin page    device=device_1
#    signin method with dcf code    device=device_1    user=meeting_user
#    Verify presence of Intents        device=device_1         feature=keycode         state=absent
#    [Teardown]   Run Keywords    Capture on Failure      AND    Come back to home screen    device_list=device_1
#
#TC4 : [Sign-in] Selecting cloud option to provisioning the phone
#    [Tags]  256171    P1    auth_tpc
#    [Setup]  Testcase setup for ztp    count=1
#    verify teams app signin page    device=device_1
#    verify settings from signin page    device_1
#    verify cloud option for provisioning device    device_1
#    verify teams app signin page    device_1
#    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1
#
#TC4 : [Calendar] Teams App to return to home page after meeting/call completion
#    [Tags]  196715   bvt_tpc    sanity_tpc  P0
#    [Setup]    Testcase Setup for Meeting User   count=2
#    create meeting  device=device_2       participants=device_1:meeting_user      meeting=homepage_meeting
#    Join Meeting    device=device_1,device_2         meeting=homepage_meeting        join_styles=conference,None
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    navigate to add participant page    device_name=device_1
#    click back      device=device_1
#    End meeting     device=device_1
#    verify home screen for cnf device    device=device_1
#    End meeting     device=device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown     devices=device_2    count=2
#
#TC3 : [Auto Dismiss] Verify call cancelled screen auto dismiss with 5 seconds
#    [Tags]   197283   P2
#    [Setup]   Run Keywords    Testcase Setup for Meeting User     count=2    AND    Disable unanswered call    device=device_2      contact_device=device_1
#    Navigate to people tab    device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Rejects the incoming call   device_list=device_2
#    validate call cancelled     device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC14 : [Call Handoff] Verify that DUT2 and DUT1 remains in the Group call when DUT user tap on "Add this device"
#    [Tags]   260992     p1
#    [Setup]   Testcase Setup for Call hand off    count=4
#    click on calls tab     device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Add participant to conversation using display name    from_device=device_2      to_device=device_4
#    Pick incoming call    device=device_4
#    Verify call hand off banner     device=device_1
#    Tap on Join Button from banner    device=device_1
#    Validate both options for joining meeting    device=device_1
#    Select option to join meeting    device=device_1       option=Add this device
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Disconnect call      device=device_3,device_4
#    Verify Call State    device_list=device_1,device_2,device_3      state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen    device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4
#
#TC12 :[Meet now] DUT 1 user invites another DUT 2 user into meeting using DID number
#    [Tags]   221838   p2
#    [Setup]   Testcase Setup for Meeting User     count=3
#    Navigate to Calendar tab   device=device_1
#    Tap on Meet Now icon and validate   device=device_1
#    Initiated a conference call from Meet now    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1    state=Connected
#    verify add participant button should visible for presenter   device=device_1
#    Add participant to conversation using phonenumber    from_device=device_1      to_device=device_2
#    pick incoming call    device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_3
#    pick incoming call    device=device_3
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button   device=device_1   AND     Come back to home screen    device_list=device_1,device_2,device_3
#
#TC13 : [Call Mute] DUT user to mute/unmute itself while in a call with PSTN user
#    [Tags]  197344   p1
#    [Setup]  Testcase Meeting PSTN Setup Main   count=2
#    Navigate to people tab    device=device_1
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
#TC6 : [App Settings] DUT user to view the device settings.
#    [Tags]   196825   P1
#    [Setup]  Testcase Setup for Meeting User    count=1
#    Navigate to device setting page   device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Device Setting Back     device=device_1   AND   Come back to home screen    device_list=device_1
#
#TC35 : [Outgoing calls] DUT user to call TDC user using different options (DID, ext., from contacts)
#    [Tags]  318497    P2
#    [Setup]  Testcase Setup for Meeting User     count=2
#    navigate to people tab    device=device_1
#    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call    device=device_1
#    repeat keyword  2 times     go back to previous page    device=device_1
#    auto dial with valid num from dial pad  from_device=device_1    to_device=device_2     method=extension
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call    device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC2 : [Incoming Calls] DUT user receives the forwarded call from Teams client
#    [Tags]  196432    P1
#    [Setup]   run keywords   Testcase Setup for Meeting User    count=3     AND    Enable call forwarding to delegates   from_device=device_3    contact_device=device_1:meeting_user
#    click on calls tab     device=device_3
#    Make outgoing call using display name    from_device=device_3      to_device=device_2
#    Verify display name on call toast   to_device=device_1    from_device=device_3
#    Verify forward by call text     device=device_1    from_device=device_2
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_3     state=Disconnected
#    [Teardown]  run keywords  Capture on Failure     AND     disable call forwarding and verify    device=device_2    AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC7 : [Sign-in] User to Sign-in DUT and TDC simultaneously with same valid user and TDC sign-outs while getting call
#    [Tags]  207418  P1    auth_tpc
#    [Setup]  Testcase Setup for Meeting User    count=3
#    Signin with other user    device=device_2   other_user_account=device_1:meeting_user
#    Navigate to people tab    device=device_1
#    Navigate to calendar tab    device=device_1
#    click on calls tab     device=device_3
#    Make outgoing call using display name    from_device=device_3      to_device=device_1:meeting_user
#    verify incoming call   device=device_1,device_2    status=appear
#    Wait for Some Time    time=${wait_time}
#    Rejects the incoming call     device_list=device_2
#    verify incoming call  device=device_1,device_2    status=disappear
#    sign out method   device=device_2
#    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC1 : [People] Teams user to receive forwarded calls in people tab
#    [Tags]  260810   P2
#    [Setup]   Run Keywords   Testcase Setup for Meeting User    count=3   AND    Enable call forwarding and add contact     from_device=device_2     contact_device=device_1:meeting_user
#    Navigate to people tab    device=device_1
#    Make outgoing call using display name    from_device=device_3      to_device=device_2
#    Verify incoming call    device=device_1     status=appear
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_3     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND   Disable Call forward    device=device_2   AND   Come back to home screen    device_list=device_1,device_2,device_3
#
#TC17 : [Calendar] Teams App user gets multiple All Day meeting at same time
#    [Tags]  179971   P2
#    [Setup]    Testcase Setup for Meeting User   count=3
#    create meeting  device=device_2       participants=device_1:meeting_user    meeting=tdc1_all_day_meeting1    all_day_meeting=ON
#    create meeting  device=device_2       participants=device_1:meeting_user    meeting=tdc1_all_day_meeting2    all_day_meeting=ON
#    create meeting  device=device_3       participants=device_1:meeting_user    meeting=tdc2_all_day_meeting1    all_day_meeting=ON
#    create meeting  device=device_3       participants=device_1:meeting_user    meeting=tdc2_all_day_meeting2    all_day_meeting=ON
#    create meeting  device=device_3       participants=device_1:meeting_user    meeting=tdc2_all_day_meeting3    all_day_meeting=ON
#    Refresh cnf device for meeting visibility   device=device_1
#    Verify meeting under all day event  device=device_1     meetings=tdc1_all_day_meeting1,tdc1_all_day_meeting2,tdc2_all_day_meeting1,tdc2_all_day_meeting2,tdc2_all_day_meeting3
#    Join meeting from all day meeting tab     device=device_1     meeting=tdc2_all_day_meeting3
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1   state=Connected
#    End meeting     device=device_1
#    click back btn  device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Before Delete Meetings   devices=device_1,device_2,device_3    count=3   AND     All Day Event Test Case Teardown     devices=device_2    meeting=tdc1_all_day_meeting1,tdc1_all_day_meeting2    count=3    AND     All Day Event Test Case Teardown     devices=device_3    meeting=tdc2_all_day_meeting1,tdc2_all_day_meeting2,tdc2_all_day_meeting3   count=3
#TC1:[Sign-in][Intune]User should be able to sign-in code using Intune License Account..
#    [Tags]     346197   sanity_tpc    bvt_tpc      auth_tpc    auth_tpc_p0
#    [Setup]  Testcase Setup for Meeting User    count=1
#    Sign out method    device_1
#    Wait for Some Time    time=${wait_time}
#    Sign in method      device=device_1    user=intune_user
#    Wait for Some Time    time=${wait_time}
#    verify home screen for cnf device    device=device_1
#    verify user contact info        device=device_1:intune_user
#    [Teardown]   Run Keywords    Capture on Failure     AND        Sign out method    device_1
#
#TC2 : [Calendar] Teams App user to reject the meeting invite call from Teams Desktop client
#    [Tags]  196709   P2
#    [Setup]    Testcase Setup for Meeting User   count=3
#    create meeting  device=device_2       participants=device_1:meeting_user,device_3    meeting=reject_meeting
#    Join Meeting    device=device_2,device_3      meeting=reject_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_2,device_3    state=Connected
#    Add participant to conversation using display name   from_device=device_2      to_device=device_1:meeting_user
#    rejects the incoming call     device_list=device_1
#    verify home screen for cnf device    device=device_1
#    End meeting     device=device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown     devices=device_2    count=3
#
#TC7 : [Calendar] Teams client user can Far-mute Teams App user in conference
#    [Tags]  144787   P2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    create meeting  device=device_2       participants=device_1:meeting_user    meeting=cnf_device_meeting
#    Join Meeting    device=device_2,device_1     meeting=cnf_device_meeting      join_styles=None,conference
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Unmutes the meeting    device=device_1
#    Farmute the call    from_device=device_2      to_device=device_1:meeting_user
#    Verify meeting Mute State    device_list=device_1    state=mute
#    Unmutes the meeting    device=device_1
#    Verify meeting Mute State    device_list=device_1    state=Unmute
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1,device_2     count=2
#
#TC15 : [Call Transfer] Teams App user blind transfers the PSTN call to Teams client
#    [Tags]   197357     p2
#    [Setup]  Testcase Meeting PSTN Setup Main    count=3
#    Navigate to people tab    device=device_1
#    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC20: [Call Merge] Verify call merge option shows up in more options(...)
#   [Tags]   197367     P2
#   [Setup]   Testcase Setup for Meeting User     count=3
#   Navigate to people tab    device=device_1
#   Make outgoing call using phonenumber    from_device=device_1     to_device=device_2
#   Pick incoming call   device=device_2
#   verify call state    device_list=device_1,device_2     state=Connected
#   click on calls tab     device=device_3
#   Make outgoing call using phonenumber    from_device=device_3     to_device=device_1:meeting_user
#   Pick incoming call from call notification    device=device_1
#   verify call state     device_list=device_1,device_3      state=Connected
#   verify call state     device_list=device_2     state=Hold
#   Verify merge call option    from_device=device_1     to_device=device_2
#   disconnect call       device=device_2,device_1
#   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
#   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC2 : [CP Enrollment] Sending failure cases with invalid password in signin
#    [Tags]  256149    P1    auth_tpc
#    [Setup]  Testcase Setup for ZTP  count=1
#    verify teams app signin page    device=device_1
#    Verify signin with wrong password     device=device_1
#    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1
#
#TC4 : [Search] Newly created user can search for the other users using search option
#    [Tags]    196643   P2
#    [Setup]   Testcase Setup for Meeting User    count=2
#    Navigate to people tab    device=device_1
#    verify search text   from_device=device_1   to_device=device_2
#    Validate search results presented    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2
#
#
#TC18 : [Call Transfer] Teams App user to transfer the Teams Client call to another Teams App user
#    [Tags]   197356   P2
#    [Setup]  Testcase Setup for Meeting User    count=3
#    Navigate to people tab    device=device_1
#    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Blindtransfers the call using phonenumber  from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC19 : [Calendar] Teams App user can Far mute Teams client in a conference call
#    [Tags]  196599   p1
#    [Setup]  Testcase Setup for Meeting User   count=2
#    create meeting  device=device_2       participants=device_1:meeting_user    meeting=far_mute_meeting
#    Join Meeting    device=device_2,device_1     meeting=far_mute_meeting    join_styles=None,conference
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Unmutes the meeting    device=device_1
#    Farmute the call    from_device=device_2      to_device=device_1:meeting_user
#    Verify meeting Mute State    device_list=device_1    state=mute
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2     count=2
#
#TC6 : [Sign-in] User to Sign-in DUT and TDC simultaneously with same valid user
#    [Tags]  207416  P1    auth_tpc
#    [Setup]  Testcase Setup for Meeting User    count=2
#    Signin with other user    device=device_2   other_user_account=device_1:meeting_user
#    Navigate to people tab    device=device_1
#    Navigate to calendar tab    device=device_1
#    Navigate to people tab    device=device_2
#    Navigate to calendar tab    device=device_2
#    sign out  device_list=device_1,device_2
#    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2
#
#TC26 : [Call Handoff] Verify that After disconnecting, user is able to join again from banner in a Meeting
#    [Tags]   260999     p2
#    [Setup]  Testcase Setup for Call hand off    count=3
#    create meeting  device=device_3     meeting=test_meeting    participants=device_1:meeting_user
#    Join Meeting    device=device_2,device_3     meeting=test_meeting        join_styles=conference,None
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_2,device_3    state=Connected
#    verify call hand off banner for meetings    device=device_1
#    Tap on Join Button from banner    device=device_1
#    Validate both options for joining meeting    device=device_1
#    Select option to join meeting    device=device_1     option=Add this device
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Disconnect call     device=device_1
#    verify call hand off banner for meetings    device=device_1
#    Tap on Join Button from banner    device=device_1
#    Validate both options for joining meeting    device=device_1
#    Select option to join meeting    device=device_1     option=Add this device
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1   AND     Come back to home screen    device_list=device_1,device_2,device_3
#
#TC12 : [Call Hold] Teams App user can hold the call when call is already on mute from far-end
#    [Tags]  197347     P2
#    [Setup]   Testcase Setup for Meeting User    count=2
#    Navigate to people tab    device=device_1
#    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Mutes the phone call    device=device_1
#    Verify meeting Mute State    device_list=device_1    state=mute
#    Hold the call   device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Hold
#    Resume the call   device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Resume
#    Verify meeting Mute State    device_list=device_1    state=mute
#    Unmutes the phone call  device=device_1
#    Verify meeting Mute State    device_list=device_1    state=Unmute
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#TC2 :[Sign-in][Intune]User should be able to sign-in using DCF code using Intune License Account..
#    [Tags]      346198     sanity_tpc    bvt_tpc      auth_tpc    auth_tpc_p0
#    [Setup]    Run Keywords    Sign out method    device_1    AND    Testcase Setup for ZTP  count=1
#    signin method with dcf code    device=device_1    user=intune_user
#    Wait for Some Time    time=${wait_time}
#    verify home screen for cnf device    device=device_1
#    verify user contact info        device=device_1:intune_user
#    [Teardown]   Run Keywords    Capture on Failure     AND    Sign out method    device_1    AND     Sign in method     device_1       user=meeting_user
#
#TC15 :[Call Handoff] Verify that After disconnecting, user is able to join again from banner in a Group call
#    [Tags]   260993     p2
#    [Setup]   Testcase Setup for Call hand off    count=4
#    click on calls tab     device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Add participant to conversation using display name    from_device=device_2      to_device=device_4
#    Pick incoming call    device=device_4
#    Verify call hand off banner     device=device_1
#    Tap on Join Button from banner    device=device_1
#    Validate both options for joining meeting    device=device_1
#    Select option to join meeting    device=device_1     option=Add this device
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Connected
#    Disconnect call     device=device_1
#    Verify call hand off banner     device=device_1
#    Tap on Join Button from banner    device=device_1
#    Validate both options for joining meeting    device=device_1
#    Select option to join meeting    device=device_1     option=Add this device
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Connected
#    Disconnect call     device=device_3,device_4
#    Verify Call State    device_list=device_1,device_2,device_3      state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen    device=device_1    AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4
#
#TC13 :[Meeting] After Selecting Audio off, DUT user should be able to get the pop - up notification.
#    [Tags]   438136   p2
#    [Setup]   Testcase Setup for Meeting User  count=2
#    Join Meeting    device=device_1,device_2     meeting=cnf_device_meeting     join_styles=conference,None
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    verify switch audio route options in meeting UI         device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure  AND   Test Case Teardown without deleting meeting     devices=device_1,device_2    count=2
#
#TC12 : [Call Handoff] Verify options available when DUT user tap on Join button on call handoff banner in a group call
#    [Tags]   260990     p1
#    [Setup]   Testcase Setup for Call hand off    count=4
#    click on calls tab     device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Add participant to conversation using display name    from_device=device_2      to_device=device_4
#    Pick incoming call    device=device_4
#    Verify call hand off banner     device=device_1
#    Tap on Join Button from banner    device=device_1
#    Validate both options for joining meeting    device=device_1
#    close call hand off banner     device=device_1
#    Disconnect call     device=device_3,device_4
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen    device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4
#
#TC2 : [Appearance] DUT user can disable Dark theme on the device
#    [Tags]   197077   P2
#    [Setup]  Testcase Setup for Meeting User    count=1
#    verify dark theme option   device=device_1
#    verify and disable dark theme    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC13 : [Call Handoff] Verify that DUT2 has entered the Group call and DUT1 has left the call when user tap on “Transfer to this device”.
#    [Tags]   260991     p1
#    [Setup]   Testcase Setup for Call hand off    count=4
#    click on calls tab     device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Add participant to conversation using display name    from_device=device_2      to_device=device_4
#    Pick incoming call    device=device_4
#    Verify call hand off banner     device=device_1
#    Tap on Join Button from banner    device=device_1
#    Validate both options for joining meeting    device=device_1
#    Select option to join meeting    device=device_1     option=Transfer to this device
#    Wait for Some Time    time=${wait_time}
#    Verify your call was transferred text    device=device_2
#    Verify Call State    device_list=device_1,device_3     state=Connected
#    Disconnect call     device=device_3,device_4
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen    device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4
#
#TC14 : [Call Transfer] Teams App user do consultative transfer one PSTN user call to another PSTN user
#    [Tags]   197363    P2
#    [Setup]     Testcase Meeting 2 PSTN Setup Main    count=3
#    click on calls tab     device=device_2
#    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:meeting_user
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Consult first to transfer the call using phonenumber  from_device=device_1      to_device=device_3:pstn_user
#    Pick incoming call    device=device_3
#    Verify Call State    device_list=device_3,device_1    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC19 : [Call Transfer] Teams app user to blind transfer the Teams client's call to another Teams client who is on DND
#    [Tags]   197360   P2
#    [Setup]     run keywords   Testcase Setup for Meeting User    count=3     AND     Select user presence     device=device_2     state=DND
#    Navigate to people tab    device=device_1
#    Make outgoing call using phonenumber    from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Blindtransfers the call using phonenumber    from_device=device_1      to_device=device_2
#    Verify Incoming call    device=device_2     status=Disappear
#    Disconnect call     device=device_1,device_3
#    Verify Call State    device_list=device_1,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Select user presence     device=device_2     state=Available    AND    Come back to home screen    device_list=device_1,device_2,device_3

#TC17 : [Call hand off] DUT to disconnect the call
#    [Tags]   260971     p2
#    [Setup]  Testcase Setup for Call hand off    count=3
#    click on calls tab     device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Verify call hand off banner     device=device_1
#    Tap on Join Button from banner    device=device_1
#    Validate both options for joining meeting    device=device_1
#    Select option to join meeting    device=device_1     option=Add this device
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1    state=Disconnected
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
#TC11 : [Call Hold] Teams App user can hold the call when it is already on hold from far-end
#    [Tags]  197346    P2
#    [Setup]   Testcase Setup for Meeting User    count=2
#    Navigate to people tab    device=device_1
#    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Hold the call   device=device_1
#    Verify Call State    device_list=device_1    state=Hold
#    Hold the call   device=device_2
#    Verify Call State    device_list=device_2    state=Hold
#    Resume the call   device=device_1
#    Verify Call State    device_list=device_2    state=Hold
#    Resume the call   device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Resume
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC22 : [Call hand off] Verify DUT can able Consult transfer to another teams client
#    [Tags]   260980     p2
#    [Setup]  Testcase Setup for Call hand off    count=4
#    click on calls tab     device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Verify call hand off banner     device=device_1
#    Tap on Join Button from banner    device=device_1
#    Validate both options for joining meeting    device=device_1
#    Select option to join meeting    device=device_1     option=Add this device
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Consult first to transfer the call using display name  from_device=device_1      to_device=device_4
#    Pick incoming call    device=device_4
#    Verify Call State    device_list=device_4,device_1    state=Connected
#    Completes the consultation to accept the call     from_device=device_1      to_device=device_3
#    Verify Call State    device_list=device_3,device_4    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4
#

#TC7 : [Call Hold] Teams App holds the call with Teams client for 15 minutes
#    [Tags]  179756    bvt
#    [Setup]  Testcase Setup for Meeting User    count=2
#    Navigate to people tab    device=device_1
#    Make outgoing call using display name    from_device=device_1     to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Hold the call   device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Hold
#    Wait for Some Time    time=${15_minutes_wait_time}
#    Resume the call   device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Resume
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC2 : [Calendar] Only online meetings should show join button in meeting object of Teams App
#    [Tags]  196640  P2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Create Meeting  device=device_2     meeting=cnf_device_meeting     participants=device_1:meeting_user
#    Refresh cnf device for meeting visibility   device=device_1
#    Scroll till meeting visible     device=device_1      meeting=cnf_device_meeting
#    Verify join button displayed on conf device   device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_2     count=2
#
#TC18 : [Calendar] Teams app user joins Teams meeting using Dial-in info
#    [Tags]  179782      P0
#    [Setup]    run keywords  Testcase Meeting PSTN Setup Main   count=3   AND   Meeting Setup   count=3
#    Create meeting   device=device_3    meeting=pstn_meeting     participants=device_1:meeting_user
#    ${phone_no}     ${conference_id}     Get meeting conference id   device=device_3    meeting=pstn_meeting
#    Join meeting   device=device_3,device_1    meeting=pstn_meeting      join_styles=None,conference
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_3    state=Connected
#    join meeting by dial in conference   device_2     ${phone_no}     ${conference_id}
#    Wait for Some Time    time=${20s_wait_time}
#    Verify lobby notification    devices=device_1,device_3
#    View lobby and select option    from_device=device_1     option=admit
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    Verify participant list from meeting roster     device=device_1      connected_device_list=device_2:pstn_user,device_3
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown     devices=device_1,device_2,device_3     count=3    AND     Come back to home screen    device_list=device_2,device_3
#
#TC16 : [Call Handoff] Verify that Call handoff banner must appear on all the tabs
#    [Tags]   260994     p1
#    [Setup]   Testcase Setup for Call hand off    count=3
#    click on calls tab     device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Verify call hand off banner     device=device_1
#    Navigate to people tab  device=device_1
#    Verify call hand off banner     device=device_1
#    Navigate to calendar tab   device=device_1
#    Verify call hand off banner     device=device_1
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen    device=device_1    AND    Come back to home screen    device_list=device_1,device_2,device_3

#TC10 : [Call Hold] Teams App user can disconnect the call when it is already on hold from far-end
#    [Tags]  197345   P2
#    [Setup]  Testcase Setup for Meeting User    count=2
#    click on calls tab     device=device_2
#    Make outgoing call using phonenumber    from_device=device_2     to_device=device_1:meeting_user
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_2,device_1    state=Connected
#    Hold the call   device=device_2
#    Verify Call State    device_list=device_2    state=Hold
#    Hold the call   device=device_1
#    Verify Call State    device_list=device_2,device_1    state=Hold
#    Wait for Some Time    time=${10_minutes_wait_time}
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2,device_1     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_2,device_1
#

#TC27 :[Call Merge] Verify merge failure messages are displayed properly when call merge fails.
#   [Tags]   197374     P2
#   [Setup]     Testcase Setup for Meeting User      count=3
#   Navigate to people tab    device=device_1
#   Make outgoing call using phonenumber    from_device=device_1   to_device=device_2
#   Pick incoming call    device=device_2
#   verify call state      device_list=device_1,device_2      state=Connected
#   click on calls tab     device=device_3
#   Make outgoing call using phonenumber    from_device=device_3   to_device=device_1:meeting_user
#   Pick incoming call from call notification    device=device_1
#   verify call state   device_list=device_1,device_3    state=Connected
#   verify call state    device_list=device_2     state=Hold
#   verify call merge failure scenario  device=device_1    merge_with_device=device_2    disconnect_from_device=device_3
#   verify call state   device_list=device_1,device_2   state=Connected
#   disconnect call   device=device_2
#   verify Call State  device_list=device_1,device_2,device_3      state=Disconnected
#   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC1 : [Call Mute] Teams App user mutes/unmutes the call with Teams client for 30 mins
#    [Tags]   197343   P2
#    [Setup]  Testcase Setup for Meeting User    count=2
#    Navigate to people tab    device=device_1
#    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2
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
#TC7 : [Outgoing Calls] Teams App user cancel the outgoing call with teams client
#    [Tags]  197318   P2
#    [Setup]  Testcase Setup for Meeting User    count=2
#    Navigate to people tab    device=device_1
#    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC25 : [Call Merge] Verify active call ends and merged call appears on the screen after merge completion
#   [Tags]   197372     P2
#   [Setup]   Testcase Setup for Meeting User      count=3
#   Navigate to people tab    device=device_1
#   Make outgoing call using phonenumber    from_device=device_1     to_device=device_2
#   Pick incoming call   device=device_2
#   verify call state    device_list=device_1,device_2     state=Connected
#   click on calls tab     device=device_3
#   Make outgoing call using phonenumber    from_device=device_3   to_device=device_1:meeting_user
#   Pick incoming call from call notification    device=device_1
#   verify call state     device_list=device_1,device_3      state=Connected
#   verify call state     device_list=device_2     state=Hold
#   Verify and merge call    device=device_1     from_device=device_2
#   verify call state     device_list=device_1,device_2,device_3     state=Connected
#   disconnect call       device=device_2,device_3
#   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
#   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC26 : [Call Merge] Verify call should continue between TDC users when Teams App user drops call after call merge
#    [Tags]   197373     p2
#    [Setup]     Testcase Setup for Meeting User      count=3
#    Navigate to people tab    device=device_1
#    Make outgoing call using phonenumber     from_device=device_1     to_device=device_2
#    Pick incoming call     device=device_2
#    Wait for Some Time      time=${wait_time}
#    verify call state     device_list=device_1,device_2     state=Connected
#    click on calls tab     device=device_3
#    Make outgoing call using phonenumber    from_device=device_3   to_device=device_1:meeting_user
#    Pick incoming call from call notification    device=device_1
#    Wait for Some Time      time=${wait_time}
#    verify call state      device_list=device_1,device_3     state=Connected
#    verify call state      device_list=device_2     state=Hold
#    Verify and merge call      device=device_1      from_device=device_2
#    Wait for Some Time      time=${wait_time}
#    verify call state     device_list=device_1,device_2,device_3      state=Connected
#    disconnect call     device=device_1
#    verify call state    device_list=device_2,device_3      state=Connected
#    verify call state     device_list=device_1      state=Disconnected
#    disconnect call     device=device_2
#    Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC21 : [Call Merge] Verify merge transition screen is displayed properly
#   [Tags]   197370     P2
#   [Setup]     Testcase Setup for Meeting User     count=3
#   Navigate to people tab    device=device_1
#   Make outgoing call using phonenumber    from_device=device_1     to_device=device_2
#   Pick incoming call    device=device_2
#   verify call state    device_list=device_1,device_2     state=Connected
#   click on calls tab     device=device_3
#   Make outgoing call using phonenumber    from_device=device_3     to_device=device_1:meeting_user
#   Pick incoming call    device=device_1
#   verify call state     device_list=device_1,device_3      state=Connected
#   verify call state     device_list=device_2     state=Hold
#   Verify and merge call    device=device_1     from_device=device_2
#   Verify transition Screen during Call merge  device=device_1
#   verify call state     device_list=device_1,device_2,device_3      state=Connected
#   disconnect call       device=device_1,device_2
#   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
#   [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC11 : [Sign-in] Sign-in to DUT with wrong Password
#     [Tags]  196473    P3    auth_tpc
#     [Setup]  Testcase Setup for Meeting User      count=1
#     Sign out method    device=device_1
#     Verify signin with wrong password     device=device_1
#     [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1
#
#TC13 : [Call Mute] Teams App user can mute the call when is already on mute from far-end
#    [Tags]  197348    P2
#    [Setup]   Testcase Setup for Meeting User    count=2
#    Navigate to people tab    device=device_1
#    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2
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
#TC3 : [Calendar] Participant count updates, when organizer adds the participant after meeting is started.
#    [Tags]    197165    p2
#    [Setup]   Testcase Setup for Meeting User    count=3
#    create meeting  device=device_2       participants=device_1:meeting_user,device_3    meeting=participant_count_meeting
#    Join Meeting    device=device_1          meeting=participant_count_meeting      join_styles=conference
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1    state=Connected
#    ${participant_count_before_adding}     Get participant count     from_device=device_1      connected_device_list=device_1:meeting_user
#    Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3
#    pick incoming call    device=device_2,device_3
#    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
#    ${participant_count_after_adding}      Get participant count     from_device=device_1      connected_device_list=device_1:meeting_user,device_2,device_3
#    run keyword if  ${participant_count_before_adding}+2 == ${participant_count_after_adding}    Log   Participant count got increased
#    ...   ELSE   fail   Participant count didn't increased.
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3  state=Disconnected
#    [Teardown]    run keywords   Capture on Failure     AND    Test Case Teardown     devices=device_2    count=3
#
#TC4 : [App Settings] DUT user to see the Terms of Use
#    [Tags]   196575   P3
#    [Setup]  Testcase Setup for Meeting User    count=1
#    Verify terms of use view     device=device_1
#    navigate to home screen from about page  device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC19 : [Call hand off] Verify DUT can able to turn on and off live captions in call
#    [Tags]  260974    p2
#    [Setup]  Testcase Setup for Call hand off    count=3
#    click on calls tab     device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Verify call hand off banner     device=device_1
#    Tap on Join Button from banner    device=device_1
#    Validate both options for joining meeting    device=device_1
#    Select option to join meeting    device=device_1     option=Add this device
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Turn on live caption    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Turn off live caption    device=device_1
#    Disconnect call     device=device_1
#    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND    come back home screen for user    count=3
#
#TC3 : [People] Teams user to switch between the tabs while in people tab.
#    [Tags]   260811     P2
#    [Setup]  Testcase Setup for Meeting User    count=1
#    Navigate to calendar tab    device=device_1
#    Navigate to people tab     device=device_1
#    Navigate to calendar tab    device=device_1
#    [Teardown]  Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1

#TC3 :[App Settings] DUT user to see and define Privacy and cookies
#    [Tags]   196574   P3
#    [Setup]  Testcase Setup for Meeting User    count=1
#    Verify privacy and cookies view     device=device_1
#    navigate to home screen from about page  device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#TC12 : [Call Hold] DUT holds the call with PSTN user for 15 and 60 minutes
#    [Tags]  306062    bvt_tpc    sanity_tpc  P0
#    [Setup]     Testcase Meeting PSTN Setup Main    count=2
#    Navigate to people tab    device=device_1
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
#TC3 : [Esc to Conf.] DUT user in P2P call with Teams client, add another teams client
#    [Tags]  196606    P1
#    [Setup]   Testcase Setup for Meeting User    count=3
#    Navigate to people tab    device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    disconnect call       device=device_1
#    Verify Call State    device_list=device_1     state=Disconnected
#    disconnect call       device=device_2
#    Verify Call State    device_list=device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC5 : [People]DUT user to have Global search icon and Call park icon in people tab
#    [Tags]  260801   p2
#    [Setup]   Testcase Setup for Meeting User    count=1
#    verify teams app has global search option   device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC25 : [Call Handoff] Verify that Call handoff banner must appear on app setting page
#    [Tags]   260996     p2
#    [Setup]  Testcase Setup for Call hand off    count=3
#    click on calls tab     device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Verify call hand off banner     device=device_1
#    open settings page      device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify call hand off banner     device=device_1
#    Come back to home screen    device_list=device_1
#    opens partner settings page     device=device_1
#    Wait for Some Time    time=${wait_time}
#    verify call hand off banner should not visible in device settings page  device=device_1
#    comes out of partner settings page    device=device_1
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3
#
#TC16 : [Call Transfer] Search option should be available in the call transfer section
#    [Tags]   197352   P2
#    [Setup]  Testcase Setup for Meeting User    count=2
#    Navigate to people tab    device=device_1
#    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Verify search option in call transfer section     device=device_1
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC10 : [Call Handoff] Verify that After disconnecting, user is able to join again from banner
#    [Tags]   260988     p2
#    [Setup]  Testcase Setup for Call hand off    count=3
#    click on calls tab     device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Verify call hand off banner     device=device_1
#    Tap on Join Button from banner    device=device_1
#    Validate both options for joining meeting    device=device_1
#    Select option to join meeting    device=device_1     option=Add this device
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Disconnect call     device=device_1
#    Verify call hand off banner     device=device_1
#    Tap on Join Button from banner    device=device_1
#    Validate both options for joining meeting    device=device_1
#    Select option to join meeting    device=device_1     option=Add this device
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1   AND     Come back to home screen    device_list=device_1,device_2,device_3

#TC10: [Outgoing Calls] auto dial with valid PSTN number.
#    [Tags]  197336    p1
#    [Setup]  Testcase Meeting PSTN Setup Main    count=2
#    Auto dial with valid num from dial pad   from_device=device_1     to_device=device_2:pstn_user
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC17 : [Esc to Conf.] DUT user in call with PSTN user, add PSTN user
#    [Tags]  196994  P1
#    [Setup]  Testcase Meeting 2 PSTN Setup Main    count=3
#    Navigate to people tab    device=device_1
#    Make outgoing call using phonenumber    from_device=device_1      to_device=device_3:pstn_user
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn_user
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Disconnect call     device=device_1,device_2
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#

#TC3 : [Calendar] Meeting object on Teams App without location information
#    [Tags]  196634   P2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Create Meeting  device=device_2     meeting=cnf_device_meeting      participants=device_1:meeting_user
#    Refresh cnf device for meeting visibility   device=device_1
#    Scroll till meeting visible     device=device_1      meeting=cnf_device_meeting
#    ${meeting_name}  Get scheduled meeting name on cnf device   device=device_1
#    log  'Meeting name : '${meeting_name}
#    ${meeting_time}  Get scheduled meeting time on cnf device   device=device_1
#    log  'Meeting time : '${meeting_time}
#    ${meeting_organizer_name}  Get scheduled meeting organizer name on cnf device   device=device_1
#    log  'Meeting organizer name : '${meeting_organizer_name}
#    Verify meeting without location_on_cnf_device     device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_2    count=2
#

#TC9 : [Call Hold] Teams App user toggle hold/resume between two teams client users
#    [Tags]  197339   P2
#    [Setup]  Testcase Setup for Meeting User    count=3
#    Navigate to people tab    device=device_1
#    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    click on calls tab     device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
#    Pick incoming call from call notification    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Verify Call State    device_list=device_2     state=Hold
#    resume call from call hold banner     device=device_1
#    Wait for Some Time    time=${action_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Verify Call State    device_list=device_3     state=Hold
#    resume call from call hold banner     device=device_1
#    Wait for Some Time    time=${action_time}
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Verify Call State    device_list=device_2     state=Hold
#    Disconnect call     device=device_2,device_3
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC9 : [Calendar] For Participants on DUT, response options should not be displayed for cancelled meetings
#    [Tags]   314188   p2
#    [Setup]     run keywords   Testcase Setup for Meeting User   count=2   AND   Meeting Setup   count=2
#    Create Meeting  device=device_2     participants=device_1:meeting_user   meeting=test_meeting
#    Refresh cnf device for meeting visibility   device=device_1
#    Get scheduled meeting name on cnf device   device=device_1
#    delete specific meeting   device=device_2    meeting=test_meeting
#    Refresh cnf device for meeting visibility   device=device_1
#    verify meeting should not be displayed  device=device_1      meeting=test_meeting
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC7 :[ZTP]Device login url on Landing page
#    [Tags]  256210    P1    auth_tpc
#    [Setup]  Testcase Setup for ZTP  count=1
#    verify teams app signin page    device=device_1
#    verify settings from signin page    device_1
#    verify cloud option    device_1
#    verify login url with cloud settings as public    device_1
#    verify settings from signin page    device_1
#    verify cloud option    device_1
#    verify login url with cloud setting as gcc    device_1
#    verify settings from signin page    device_1
#    verify cloud option    device_1
#    verify login url with cloud setting as gcc high    device_1
#    verify settings from signin page    device_1
#    verify cloud option    device_1
#    verify login url with cloud setting as gcc dod    device_1
#    verify settings from signin page    device_1
#    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1
#
#TC21 : [Call hand off] Verify DUT can able Blind transfer to another teams client
#    [Tags]   260979     p2
#    [Setup]  Testcase Setup for Call hand off    count=4
#    click on calls tab     device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Verify call hand off banner     device=device_1
#    Tap on Join Button from banner    device=device_1
#    Validate both options for joining meeting    device=device_1
#    Select option to join meeting    device=device_1     option=Add this device
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Blindtransfers the call using display name  from_device=device_1      to_device=device_4
#    Pick incoming call    device=device_4
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_3,device_4    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4
#
#TC24 : [Call Handoff] Verify that Call handoff banner must appear on all the hidden tabs as well
#    [Tags]   260995     p2
#    [Setup]  Testcase Setup for Call hand off    count=3
#    click on calls tab     device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Verify call hand off banner     device=device_1
#    navigate to people tab       device=device_1
#    Verify call hand off banner     device=device_1
#    Come back to home screen    device_list=device_1
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3
#TC3 : [Hot Desking] verify call should not hit device for host user when hot desk user is loggedin
#    [Tags]   318563     P2
#    [Setup]    Testcase Setup for Meeting User   count=3
#    Hot desking signin   device=device_1     hot_desk_account=device_2
#    Verify hot desking mode  device=device_1
#    click on calls tab     device=device_3
#    Make outgoing call using display name    from_device=device_3     to_device=device_1:meeting_user
#    Verify Incoming call    device=device_1     status=Disappear
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_3     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3      AND   End hot desk    device=device_1
#
#TC11 :[Hard Mute]Verify that Hard mute slider is not available to Attendee
#    [Tags]  260889   p2
#    [Setup]  Testcase Setup for Meeting User    count=3
#    Join Meeting    device=device_1,device_2,device_3      meeting=Hard_Mute_Meeting     join_styles=conference,None,None
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    verify manage audio and video option    device=device_1    count=3   role=presenter
#    verify manage audio and video option    device=device_2    count=3   role=organiser
#    Make an attendee    from_device=device_2       to_device=device_1:meeting_user
#    Verify you are an attendee now notification     device=device_1
#    verify manage audio and video option  device=device_1    count=3     role=attendee
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting    devices=device_2      count=3
#
#TC7 : [Meet now] Start Meet now should display New meeting title, Mic is off, Device and join now options on the screen. ( If device supports video call, video is off should be present on screen)
#    [Tags]    221870    p1
#    [Setup]  Testcase Setup for Meeting User       count=3
#    Navigate to Calendar tab   device=device_1
#    Tap on Meet Now icon and validate   device=device_1
#    Initiated a conference call from Meet now    device=device_1
#    Verify meeting state   device_list=device_1    state=Connected
#    End meeting     device=device_1
#    Verify meeting state    device_list=device_1   state=Disconnected
#    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND   Come back to home screen    device_list=device_1
#
#TC8 : [Hard Mute] Presenter/organizer can provide individual restrictions to users
#    [Tags]  260884   p2
#    [Setup]  Testcase Setup for Meeting User    count=2
#    Join Meeting    device=device_1,device_2       meeting=Hard_Mute_Meeting     join_styles=conference,None
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    verify manage audio and video option    device=device_1    count=2   role=presenter
#    verify manage audio and video option    device=device_2    count=2   role=organiser
#    Make an attendee    from_device=device_2       to_device=device_1:meeting_user
#    Verify you are an attendee now notification     device=device_1
#    Disable camera and mic for attendees    from_device=device_2    to_device=device_1    mic=off   camera=on
#    verify and allow individual permissions to attendees   from_device=device_2       to_device=device_1:meeting_user
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting    devices=device_2      count=2
#

#TC8 : [Reactions] DUT user to verify the raise hand feature from reactions window
#    [Tags]  248184   p2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Join Meeting    device=device_1,device_2     meeting=Reactions       join_styles=conference,None
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    Verify reaction button in call control     device=device_1
#    Tap on reaction button in call control      device=device_1
#    Verify presence of reactions button in call control     device=device_1
#    Raise hand     device=device_1
#    Verify raise hand    from_device=device_2    to_device=device_1     status=on
#    Lower hand     device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]   run keywords   Capture on Failure    AND    test case teardown    devices=device_1,device_2   count=2
#
#TC7 : [Hard Mute] Verify when hard mute is turned on display mic state clearly next to all participants
#    [Tags]    260878    p2
#    [Setup]   Testcase Setup for Meeting User    count=2
#    Join Meeting    device=device_1,device_2       meeting=Hard_Mute_Meeting     join_styles=conference,None
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    verify manage audio and video option    device=device_1    count=2   role=presenter
#    verify manage audio and video option    device=device_2    count=2   role=organiser
#    verify participant list     from_device=device_1      connected_device_list=device_1:meeting_user,device_2
#    Verify meeting Mute State    device_list=device_1    state=mute
#    Verify meeting Mute State    device_list=device_2    state=mute
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure  AND    Test Case Teardown without deleting meeting    devices=device_2      count=2
#
#TC9 : [Hard Mute] Presenter/organizer can provide individual restrictions to users. Allow to Unmute
#    [Tags]  260885   p1
#    [Setup]  Testcase Setup for Meeting User    count=2
#    Join Meeting    device=device_1,device_2       meeting=Hard_Mute_Meeting     join_styles=conference,None
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    verify manage audio and video option    device=device_1    count=2   role=presenter
#    verify manage audio and video option    device=device_2    count=2   role=organiser
#    Make an attendee    from_device=device_2       to_device=device_1:meeting_user
#    Verify you are an attendee now notification     device=device_1
#    Disable camera and mic for attendees    from_device=device_2     to_device=device_1    mic=off   camera=on
#    verify and allow individual permissions to attendees   from_device=device_2       to_device=device_1:meeting_user
#    Unmutes the phone call   device=device_1
#    Mutes the phone call     device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting    devices=device_2      count=2
#
#TC4 : [Meet now] DUT user can check more options during meeting
#    [Tags]    221857    p1
#    [Setup]   Testcase Setup for Meeting User    count=4
#    Navigate to Calendar tab   device=device_1
#    Tap on Meet Now icon and validate   device=device_1
#    Initiated a conference call from Meet now    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3,device_4
#    pick incoming call    device=device_2,device_3,device_4
#    Verify meeting state   device_list=device_1,device_2,device_3,device_4    state=Connected
#    Verify meeting more options     device=device_1:meeting_user
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4
#
#TC10 : [HardMute]Verify that Hard mute slider availability (Organizer/Presenter) only
#    [Tags]  260888   p2
#    [Setup]  Testcase Setup for Meeting User    count=2
#    Join Meeting    device=device_1,device_2       meeting=Hard_Mute_Meeting     join_styles=conference,None
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    verify participant list   from_device=device_1  connected_device_list=device_1:meeting_user,device_2
#    verify manage audio and video option  device=device_1    count=2     role=presenter
#    verify manage audio and video option  device=device_1    count=2     role=organiser
#    verify options to manage audio and video   device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure  AND    Test Case Teardown without deleting meeting    devices=device_2      count=2
#
#TC1 : [Structured Meetings] Verify a banner to letting users know that they were either promoted or demoted.
#    [Tags]   312817    p2
#    [Setup]    Testcase Setup for Meeting User   count=3
#    Join Meeting    device=device_2,device_1,device_3     meeting=structured_meeting     join_styles=None,conference,None
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    make an attendee     from_device=device_2   to_device=device_1:meeting_user
#    verify you are an attendee now notification    device=device_1
#    make an presenter    from_device=device_2   to_device=device_1:meeting_user
#    verify you are an presenter now notification    device=device_1
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3     count=3
#
#TC3 : [Structured Meetings] No other user "Presenter/Attendee" can change the role of organizer
#    [Tags]   312815    P0    sanity_tpc  bvt_tpc
#    [Setup]  Testcase Setup for Meeting User    count=3
#    Join Meeting    device=device_2,device_1,device_3     meeting=structured_meeting     join_styles=None,conference,None
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    verify no option to change organizer role  from_device=device_1    to_device=device_2
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND        Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3     count=3
#
#TC6 :[Reactions] DUT user to verify the reaction of TDC user when TDC user is displayed on the main stage of DUT user
#    [Tags]  248195   p2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Join Meeting    device=device_1,device_2     meeting=Reactions       join_styles=conference,None
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    Verify reaction button in call control     device=device_2
#    Tap on reaction button in call control      device=device_2
#    Tap on like button     device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2  state=Disconnected
#    [Teardown]   run keywords   Capture on Failure    AND    test case teardown    devices=device_1,device_2   count=2
#
#TC12 :[Meet now] DUT 1 user invites another DUT 2 user into meeting using DID number
#    [Tags]   221838   p2
#    [Setup]   Testcase Setup for Meeting User     count=3
#    Navigate to Calendar tab   device=device_1
#    Tap on Meet Now icon and validate   device=device_1
#    Initiated a conference call from Meet now    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1    state=Connected
#    verify add participant button should visible for presenter   device=device_1
#    Add participant to conversation using phonenumber    from_device=device_1      to_device=device_2
#    pick incoming call    device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_3
#    pick incoming call    device=device_3
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button   device=device_1   AND     Come back to home screen    device_list=device_1,device_2,device_3
#
#TC14 : [Hard Mute] Verify One attendee can view hand raised by another attendee
#    [Tags]  260882   p2
#    [Setup]  Testcase Setup for Meeting User    count=3
#    Join Meeting    device=device_1,device_2,device_3      meeting=Hard_Mute_Meeting     join_styles=conference,None,None
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    verify participant list   from_device=device_1  connected_device_list=device_1:meeting_user,device_2,device_3
#    Make an attendee    from_device=device_2       to_device=device_1:meeting_user
#    Make an attendee    from_device=device_2       to_device=device_3
#    Verify you are an attendee now notification     device=device_1,device_3
#    Raise hand     device=device_3
#    Verify raise hand    from_device=device_1    to_device=device_3      status=on
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_2      count=3
#
#TC3 :[Hard Mute] Verify "Disable mic for attendees", "Disable camera for attendees" option should be available in "manage audio or video."
#    [Tags]    260874    p1
#    [Setup]   Testcase Setup for Meeting User    count=2
#    Join Meeting    device=device_1,device_2       meeting=Hard_Mute_Meeting     join_styles=conference,None
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    verify manage audio and video option    device=device_1    count=2   role=presenter
#    verify manage audio and video option    device=device_2    count=2   role=organiser
#    verify options to manage audio and video   device=device_2
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting    devices=device_2      count=2
#
#TC15 : [Meet now] Ending the conference call should redirect DUT user to Homescreen
#    [Tags]   221847   p2
#    [Setup]   Testcase Setup for Meeting User     count=4
#    Navigate to Calendar tab   device=device_1
#    Tap on Meet Now icon and validate   device=device_1
#    Initiated a conference call from Meet now    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1    state=Connected
#    Add participant to conversation using display name    from_device=device_1      to_device=device_2,device_3,device_4
#    pick incoming call    device=device_2,device_3,device_4
#    Verify meeting state   device_list=device_1,device_2,device_3,device_4    state=Connected
#    End meeting     device=device_1
#    Verify meeting state    device_list=device_1    state=Disconnected
#    verify home screen for cnf device   device=device_1
#   [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4
#
#TC10 : [Meet now] Start Meet now, Remove Participants from Conference
#    [Tags]    221832    p2
#    [Setup]   Testcase Setup for Meeting User     count=3
#    Navigate to Calendar tab   device=device_1
#    Tap on Meet Now icon and validate   device=device_1
#    Initiated a conference call from Meet now    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1    state=Connected
#    verify add participant button should visible for presenter   device=device_1
#    Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3
#    pick incoming call    device=device_2,device_3
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    Remove user from meeting    from_device=device_1      to_device=device_2
#    Verify someone removed you from the meeting text    device=device_2
#    click back btn  device=device_1
#    End meeting     device=device_1,device_3
#    Verify meeting state    device_list=device_1,device_3   state=Disconnected
#    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3
#
#
#TC2 :[Hard Mute] verify "Manage audio and video" option not available for attendee.
#    [Tags]    306444
#    [Setup]   Testcase Setup for Meeting User    count=2
#    Join Meeting    device=device_1,device_2       meeting=Hard_Mute_Meeting     join_styles=conference,None
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    verify manage audio and video option    device=device_1     count=2    role=presenter
#    Make an attendee    from_device=device_2       to_device=device_1:meeting_user
#    Verify you are an attendee now notification     device=device_1
#    verify manage audio and video option  device=device_1       count=2   role=attendee
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure  AND    Test Case Teardown without deleting meeting    devices=device_2      count=2
#
#TC1 :[Hard Mute] verify "Manage audio and video" option in meeting
#    [Tags]    260872    p1
#    [Setup]   Testcase Setup for Meeting User    count=2
#    Join Meeting    device=device_1,device_2       meeting=Hard_Mute_Meeting     join_styles=conference,None
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    verify manage audio and video option  device=device_1    count=2     role=presenter
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure  AND     Test Case Teardown without deleting meeting    devices=device_2      count=2
#
#TC4 : [Multiple calls] DUT user on meeting tab, receives multiple calls.
#    [Tags]  319277    P2
#    [Setup]  Testcase Setup for Meeting User   count=3
#    navigate to calendar tab    device=device_1
#    initiate simultaneous call  devices=device_2,device_3   target_device=device_1:meeting_user    method=display_name
#    verify multiple incoming calls  device=device_1
#    accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept
#    disconnect call   device_2,device_3
#    Verify Call State   device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3
#
#TC4 : [Structured Meetings] Meeting role tag "organizer/Attendee" should display below user name in meeting roster
#    [Tags]   312816   p2
#    [Setup]   Testcase Setup for Meeting User    count=3
#    Join Meeting    device=device_2,device_1,device_3     meeting=structured_meeting     join_styles=None,conference,None
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    verify user role in a meeting  device=device_2    role=Organizer
#    verify presenter options in meeting from organizer or presenter    from_device=device_1  to_device=device_3
#    make an attendee    from_device=device_1     to_device=device_3
#    verify you are an attendee now notification    device=device_3
#    verify user role in a meeting  device=device_2    role=Attendee
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting    devices=device_1,device_2,device_3     count=3
#
#TC16 : [Meet now] Teams Desktop Client to reject the meeting invite call from DUT user
#    [Tags]   221849   p2
#    [Setup]   Testcase Setup for Meeting User     count=2
#    Navigate to Calendar tab   device=device_1
#    Tap on Meet Now icon and validate   device=device_1
#    Initiated a conference call from Meet now    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1    state=Connected
#    Add participant to conversation using display name    from_device=device_1      to_device=device_2
#    Rejects the incoming call    device_list=device_2
#    verify add participant button should visible for presenter   device=device_1
#    End meeting     device=device_1
#    Verify meeting state    device_list=device_1,device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND    Come back to home screen    device_list=device_1,device_2
#
#TC4 :[Hard Mute] Organizer/presenter-can turn on hard mute, it disables mic for attendees with toggle
#    [Tags]    306446    bvt_tpc  sanity_tpc  P0
#    [Setup]   Testcase Setup for Meeting User    count=2
#    Join Meeting    device=device_1,device_2       meeting=Hard_Mute_Meeting     join_styles=conference,None
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    verify manage audio and video option    device=device_1    count=2   role=presenter
#    verify manage audio and video option    device=device_2    count=2   role=organiser
#    Make an attendee    from_device=device_2       to_device=device_1:meeting_user
#    Verify you are an attendee now notification     device=device_1
#    Disable camera and mic for attendees   from_device=device_2   to_device=device_1     mic=off   camera=on
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure  AND    Test Case Teardown without deleting meeting    devices=device_2      count=2
#
#
#TC6 : [Hard Mute] Verify the participants mic and camera status in the meeting
#    [Tags]  260887   p2
#    [Setup]  Testcase Setup for Meeting User    count=2
#    Join Meeting    device=device_1,device_2       meeting=Hard_Mute_Meeting     join_styles=conference,None
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    verify participant list   from_device=device_1   connected_device_list=device_1:meeting_user,device_2
#    Verify meeting Mute State    device_list=device_1    state=mute
#    Verify meeting Mute State    device_list=device_2    state=mute
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure  AND    Test Case Teardown without deleting meeting    devices=device_2      count=2
#
#
#TC6 : [Structured Meetings] Presenter can change roles of other users except organizer
#    [Tags]   312832  p2
#    [Setup]   Testcase Setup for Meeting User   count=3
#    Join Meeting    device=device_2,device_1,device_3     meeting=structured_meeting     join_styles=None,conference,None
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
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3     count=3
#
#TC2 : [Structured Meetings] Verify joining the meeting as an Attendee shows a banner "You’re joined as an attendee."
#    [Tags]   312831    p2
#    [Setup]    Testcase Setup for Meeting User   count=3
#    Join Meeting    device=device_2,device_1,device_3     meeting=structured_meeting     join_styles=None,conference,None
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    make an attendee     from_device=device_2   to_device=device_1:meeting_user
#    verify you are an attendee now notification    device=device_1
#    End meeting    device=device_1
#    Join Meeting   device=device_1     meeting=cnf_device_meeting        join_styles=conference
#    verify you are joined as an attendee notification    device=device_1
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting     devices=device_1,device_2,device_3     count=3
#
#TC5 : [Hard Mute] Verify "your mic has been disabled" message display on main stage to participant/attendee
#    [Tags]   306452  sanity_tpc  P1
#    [Setup]  Testcase Setup for Meeting User    count=2
#    Join Meeting    device=device_1,device_2       meeting=Hard_Mute_Meeting     join_styles=conference,None
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    verify manage audio and video option    device=device_1    count=2   role=presenter
#    verify manage audio and video option    device=device_2    count=2   role=organiser
#    Make an attendee    from_device=device_2       to_device=device_1:meeting_user
#    Verify you are an attendee now notification     device=device_1
#    Disable camera and mic for attendees    from_device=device_2      to_device=device_1    mic=off   camera=on
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting    devices=device_2      count=2
#
#
#TC17 : [Meet now] Verify DUT user is able to on and off the Live caption during the meeting
#    [Tags]   221852   p2
#    [Setup]   Testcase Setup for Meeting User     count=3
#    Navigate to Calendar tab   device=device_1
#    Tap on Meet Now icon and validate   device=device_1
#    Initiated a conference call from Meet now    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1    state=Connected
#    Add participant to conversation using display name    from_device=device_1      to_device=device_2,device_3
#    pick incoming call    device=device_2,device_3
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    turn on live caption     device=device_1
#    Wait for Some Time    time=${wait_time}
#    turn off live caption     device=device_1
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#
#TC7 : [Reactions] DUT user to verify the auto-play of reactions in the reaction window
#    [Tags]  248181   p2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Join Meeting    device=device_1     meeting=Reactions        join_styles=conference
#    Verify meeting state   device_list=device_1   state=Connected
#    Verify reaction button in call control     device=device_1
#    Tap on reaction button in call control      device=device_1
#    Verify presence of reactions button in call control     device=device_1
#    verify raise hand reaction     device=device_1
#    End meeting     device=device_1
#    Verify meeting state    device_list=device_1   state=Disconnected
#    [Teardown]   run keywords   Capture on Failure    AND    test case teardown    devices=device_1,device_2    count=2
#
#
#TC21 : [Meet now] Participant count updates, when organizer adds the participant after meeting is started.
#    [Tags]   221869   p2
#    [Setup]   Testcase Setup for Meeting User     count=3
#    Navigate to Calendar tab   device=device_1
#    Tap on Meet Now icon and validate   device=device_1
#    Initiated a conference call from Meet now    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1    state=Connected
#    Add participant to conversation using display name    from_device=device_1      to_device=device_2,device_3
#    pick incoming call    device=device_2,device_3
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    Get participant count     from_device=device_1    connected_device_list=device_1:meeting_user,device_2,device_3
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND  Come back to home screen   device_list=device_1,device_2,device_3
#
#
#TC19 : [Meet now] Teams App user adds more participants to conference call
#    [Tags]   221874   p2
#    [Setup]   Testcase Setup for Meeting User     count=3
#    Navigate to Calendar tab   device=device_1
#    Tap on Meet Now icon and validate   device=device_1
#    Initiated a conference call from Meet now    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1    state=Connected
#    Add participant to conversation using display name    from_device=device_1      to_device=device_2
#    pick incoming call    device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Add participant to conversation using display name    from_device=device_1      to_device=device_3
#    pick incoming call    device=device_3
#    Verify meeting state   device_list=device_1,device_3    state=Connected
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button    device=device_1    AND   Come back to home screen    device_list=device_1,device_2,device_3
#
#TC5 : [Structured Meetings] Attendee user should not have permission to change role of any user
#    [Tags]   312833  p2
#    [Setup]   Testcase Setup for Meeting User   count=3
#    Join Meeting    device=device_2,device_1,device_3     meeting=structured_meeting     join_styles=None,conference,None
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    verify presenter options in meeting from organizer or presenter   from_device=device_1    to_device=device_3
#    make an attendee    from_device=device_2    to_device=device_1:meeting_user
#    verify you are an attendee now notification    device=device_1
#    verify presenter options in meeting from attendee   from_device=device_1     to_device=device_3
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting    devices=device_1,device_2,device_3     count=3
#
#TC12 :[Hard Mute]Verify that DUT user (Organizer/Presenter) Able to toggle hard mute slider
#    [Tags]  260890   p2
#    [Setup]  Testcase Setup for Meeting User    count=3
#    Join Meeting    device=device_1,device_2,device_3      meeting=Hard_Mute_Meeting     join_styles=conference,None,None
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    verify manage audio and video option    device=device_1    count=3   role=presenter
#    Make an attendee    from_device=device_2       to_device=device_3
#    Verify you are an attendee now notification     device=device_3
#    Disable camera and mic for attendees    from_device=device_1      to_device=device_3    mic=off   camera=on
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting    devices=device_2      count=3
#
#
#TC13 :[HardMute]Verify Changes over at users when hard mute slider toggled ON(Presenter/Organizer)
#    [Tags]  260891   p2
#    [Setup]  Testcase Setup for Meeting User    count=3
#    Join Meeting    device=device_1,device_2,device_3      meeting=Hard_Mute_Meeting     join_styles=conference,None,None
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    verify manage audio and video option    device=device_1    count=3   role=presenter
#    verify manage audio and video option    device=device_2    count=3   role=organiser
#    Make an attendee    from_device=device_2       to_device=device_3
#    Verify you are an attendee now notification     device=device_3
#    Disable camera and mic for attendees    from_device=device_1      to_device=device_3    mic=off   camera=on
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown without deleting meeting  devices=device_2      count=3
#
#TC12 : [Conference room UI] Verify Search button should appear on people tab.
#    [Tags]   313027   p2
#    [Setup]  Testcase Setup for Meeting User     count=1
#    verify teams app has global search option   device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1
#
#TC13 : [Calendar] DUT user should be allowed to join meeting, when in P2P call.
#    [Tags]  180550   P2
#    [Setup]    run keywords   Testcase Setup for Meeting User   count=3   AND   Meeting Setup   count=3
#    create meeting  device=device_2       participants=device_1:meeting_user    meeting=cnf_device_meeting
#    navigate to calls tab  device=device_3
#    Make outgoing call using phonenumber    from_device=device_3     to_device=device_1:meeting_user
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    click back btn  device=device_1
#    Join Meeting    device=device_1,device_2     meeting=cnf_device_meeting      join_styles=conference,None
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify Call State    device_list=device_3     state=Hold
#    End meeting     device=device_1,device_2
#    Disconnect call     device=device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown     devices=device_1,device_2,device_3     count=3

#This test case is taking 75mins to execute hence removing and moving to manual bucket.
#TC2 : [Call Hold] DUT holds the call with PSTN user for 15 and 60 minutes
#    [Tags]  306062    bvt_tpc    sanity_tpc
#    [Setup]     Testcase Meeting PSTN Setup Main    count=2
#    Navigate to people tab    device=device_1
#    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2:pstn_user
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Hold the call   device=device_1
#    Verify Call State    device_list=device_1     state=Hold
#    Wait for Some Time    time=${15_minutes_wait_time}
#    Resume the call   device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Resume
#    Hold the call   device=device_1
#    Verify Call State    device_list=device_1     state=Hold
#    Wait for Some Time    time=60 minutes
#    Resume the call   device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Resume
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

#Hold feature not available in meetings
#TC10 : [Calendar] Teams App user joins the meeting and do Hold/resume
#    [Tags]  179762   bvt
#    [Setup]    run keywords   Testcase Setup for Meeting User   count=2   AND   Meeting Setup   count=2
#    Create Meeting  device=device_2     meeting=hold_and_resume_meeting
#    Wait for Some Time    time=${wait_time}
#    join meeting   device=device_2      meeting=hold_and_resume_meeting
#    Add participant to conversation using display name   from_device=device_2      to_device=device_1:meeting_user
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Hold the meeting   device=device_1
#    Verify Call State    device_list=device_2     state=Hold
#    Resume the call   device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Resume
#    End meeting     device=device_1,device_2
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown     devices=device_2    meeting=hold_and_resume_meeting    count=2

#This feature is not avaialable 
# TC18: [Expose CP errors during sign-in]DUT user to verify the pop up displayed, when user signs in with CAP limit reached account.
#     [Tags]      348605  bvt_tpc     sanity_tpc  P0    auth_tpc    auth_tpc_p0
#     [Setup]  Testcase Setup for ZTP    count=1
#     verify signin with license is not supported account used for signin phones       device=device_1:cap_limit_reached_account
#     [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

#Test case removed due to following bug - Bug 4100287: [MTRA]Report an issue option is missing under settings.
#TC19 : [ZTP]Teams app user should able to report an issue at sign in page
#      [Tags]   320961      P2    auth_tpc
#      [Setup]  Testcase Setup for ZTP    count=1
#      verify settings from signin page    device=device_1
#      report an issue     device=device_1
#      Verify teams app signin page    device=device_1
#      [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

#Removed because of below Bug:3530266 (Emergency Location is not supported for non personal accounts)
#TC4 : [Emergency Location] Verify “Emergency Location” is available under contacts card (user profile) screen.
#    [Tags]   382127  P0    BVT_TPC  Sanity_TPC
#    [Setup]  Testcase Setup for Meeting User    count=1
#    verify set your emergency location option under user profile    device=device_1:meeting_user
#    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

#Removed beacuse of new UI change for Conference
#TC13 : [Conference Room][People Tab] User to Verify the People tab in DUT
#    [Tags]   306607   p2
#    [Setup]  Testcase Setup for Meeting User     count=1
#    verify conference room UI feature    device=device_1
#    verify apps under more option     device=device_1:meeting_user
#    click back    device=device_1
#    Navigate to people tab    device=device_1
#    Click drop down menu and verify list of groups   device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1

#TC14 : [Conference Room][People Tab] User to Verify the People tab when No contacts are added in DUT
#    [Tags]   306608   p2
#    [Setup]  Testcase Setup for Meeting User     count=1
#    verify conference room UI feature    device=device_1
#    verify apps under more option     device=device_1:meeting_user
#    click back    device=device_1
#    Navigate to people tab    device=device_1
#    verify group page when no user added   device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1

#Removed beacuse of new UI change for Conference
#TC18 : [Conference Room][Home Screen] Tap on More(...) from the Home Screen
#    [Tags]   306604  P2
#    [Setup]  Testcase Setup for Meeting User     count=1
#    verify conference room UI feature    device=device_1
#    verify apps under more option   device=device_1:meeting_user
#    click back   device=device_1
#    verify home screen for cnf device  device=device_1
#    [Teardown]    Capture on Failure
#TC7 : [Call Merge] DUT user receives multiple calls and merges call one by one
#    [Tags]   306096    sanity_tpc    P1
#    [Setup]     Testcase Setup for Meeting User      count=5
#    Navigate to people tab    device=device_1
#    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2
#    Pick incoming call   device=device_2
#    Wait for Some Time    time=${wait_time}
#    verify call state    device_list=device_1,device_2     state=Connected
#    click on calls tab     device=device_3
#    Make outgoing call using phonenumber    from_device=device_3   to_device=device_1:meeting_user
#    Pick incoming call    device=device_1
#    Wait for Some Time   time=${wait_time}
#    verify call state    device_list=device_1,device_3    state=Connected
#    verify call state    device_list=device_2    state=Hold
#    click on calls tab     device=device_4
#    Make outgoing call using phonenumber    from_device=device_4   to_device=device_1:meeting_user
#    Pick incoming call from call notification    device=device_1
#    Wait for Some Time    time=${wait_time}
#    verify call state     device_list=device_1,device_4      state=Connected
#    verify call state     device_list=device_2,device_3      state=Hold
#    click on calls tab     device=device_5
#    Make outgoing call using phonenumber    from_device=device_5   to_device=device_1:meeting_user
#    Pick incoming call     device=device_1
#    Wait for Some Time     time=${wait_time}
#    verify call state      device_list=device_1,device_5      state=Connected
#    verify call state     device_list=device_2,device_3,device_4    state=Hold
#    Verify and merge call  device=device_1    from_device=device_2
#    verify call state     device_list=device_1,device_2,device_3,device_4,device_5    state=Connected
#    disconnect call    device=device_2,device,device_3,device_4,device_5
#    Verify and merge call  device=device_1    from_device=device_3
#    Verify Call State   device_list=device_1,device_2,device_3,device_4,device_5     state=Disconnected
#    [Teardown]   Run Keywords   Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4,device_5

# TC8: [Private meetings] Teams App user to verify "Meetings" option under Admin settings for shared accounts
#     [Tags]   306279     bvt_tpc  sanity_tpc  P0
#     [Setup]  Testcase Setup for Meeting User   count=1
#     verify meetings btn presence under app settings  device=device_1
#     [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1

# TC9: [Private meetings] Teams App user to verify "Meetings" option under App settings
#     [Tags]    306280       P1
#     [Setup]  Testcase Setup for Meeting User  count=1
#     verify meetings option under app settings page   device=device_1
#     [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1

# TC10: [Private meetings] Teams App user to verify meeting titles in calendar tab when privacy toggle is turned off on the device
#     [Tags]   306283        P1
#     [Setup]   Testcase Setup for Meeting User   count=2
#     disable show meeting names   device=device_1
#     Create Meeting   device=device_2     meeting=hide_meeting1     participants=device_1:meeting_user
#     verify meeting title shows meeting organizer name   device=device_1      organizer=device_2
#     [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2     AND     clear all day meeting and meeting history from calendar   devices=device_2

# TC11: [Private meetings] Teams App user to verify all-day meetings in calendar tab when privacy toggle is turned off on the device
#     [Tags]  306323      P2
#     [Setup]   Testcase Setup for Meeting User   count=2
#     disable show meeting names  device=device_1
#     Create Meeting  device=device_2     meeting=all_day_hide1      participants=device_1:meeting_user          all_day_meeting=ON
#     Create Meeting  device=device_2     meeting=all_day_hide2      participants=device_1:meeting_user         all_day_meeting=ON
#     Create Meeting  device=device_2     meeting=all_day_hide3      participants=device_1:meeting_user         all_day_meeting=ON
#     verify meeting title shows meeting organizer name   device=device_1      organizer=device_2     all_day_meeting=on
#     [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2      AND     clear all day meeting and meeting history from calendar   devices=device_2

# TC12: [Private meetings] Teams App user to verify the meeting title after joining the meeting when privacy toggle is turned off on the device
#     [Tags]  306284        P1
#     [Setup]   Testcase Setup for Meeting User    count=2
#     disable show meeting names  device=device_1
#     Create Meeting   device=device_2     meeting=hide_meeting1     participants=device_1:meeting_user
#     verify and join meeting when show meeting title toggle is off     device=device_1     organizer_name=device_2       meeting=hide_meeting1
#     Verify meeting state   device_list=device_1    state=Connected
#     verify meeting has meeting name     device=device_1     meeting=hide_meeting1
#     End meeting     device=device_1
#     Verify meeting state    device_list=device_1   state=Disconnected
#     [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2      AND     clear all day meeting and meeting history from calendar   devices=device_2

# TC13: [Private meetings] Teams App user to disable the "Show meeting names" option on the device
#     [Tags]    306281      P2
#     [Setup]   Testcase Setup for Meeting User  count=2
#     verify meetings option under app settings page   device=device_1
#     disable show meeting names  device=device_1
#     [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2
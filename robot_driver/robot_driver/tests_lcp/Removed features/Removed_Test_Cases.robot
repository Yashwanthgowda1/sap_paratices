#
#TC 4: [Auto Restart] DUT user checks App Restart option disabled by default.
#    [Tags]  452454
#    [Setup]  Testcase Setup  count=1
#    verify app restart toggle button    device=device_1     toggle=off
#    [Teardown]  Run Keywords    Capture on Failure     AND   Come back to home screen    device_list=device_1
#
#TC2: [Call Transfer] DUT user to transfer the TDC call to another DUT user
#    [Tags]  244103      P1
#    [Setup]  Testcase Setup     count=3
#    navigate to people tab    device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
#    Verify display name on call toast   to_device=device_3    from_device=device_2
#    Pick incoming call    device=device_3
#    Verify call state and disconnect   device=device_1
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC18 : [Calls] Verify that user can view the favorite contact profile using "View profile" icon in more option appear with contact image and presence
#    [Tags]      318730
#    [Setup]  run keywords   Testcase Setup    count=2    AND    Make outgoing call for call log   from_device=device_1     to_device=device_2
#    Select call list item   device=device_1  item=favorite
#    Verify added favorite user in favorites page    from_device=device_1     to_device=device_2
#    verify favorites user option    from_device=device_1     to_device=device_2
#    verify view profile options in favorites page   from_device=device_1     to_device=device_2
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC7: [ZTP][Sign-in] DCF code fetching for sign-in from other device either with PC or Phone.
#    [Tags]  250058     bvt_lcp      sanity_lcp    auth_lcp
#    [Setup]  Testcase Setup for LCP ZTP  count=1
#    verify ztp signin ui on lcp  device=device_1
#    [Teardown]  Capture on Failure
#
#TC5: [Calls] DUT user's call log in the recent tab entry displays the duration of call
#    [Tags]  243597      sanity_lcp
#    [Setup]  Testcase Setup    count=1
#    validate call duration or missed call    device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC4: [Home screen] DUT user to verify Contacts on Home screen
#    [Tags]  244169
#    [Setup]  Testcase Setup     count=1
#    verify ui post signin  device=device_1
#    verify and click contacts on lcp homescreen     device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC 3: [Auto Restart] DUT user to verify Auto Restart option in settings page.
#    [Tags]  452450
#    [Setup]  Testcase Setup  count=1
#    open settings page       device=device_1
#    verify auto restart option inside settings page      device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#

#TC3: [Home screen] DUT user to verify Voicemail on Home screen
#    [Tags]  244170
#    [Setup]  Testcase Setup     count=1
#    verify ui post signin  device=device_1
#    navigate to calls tab  device=device_1
#    navigate to voicemail tab  device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC2: [Calls] Calling from favorites tab
#    [Tags]  452574    bvt_lcp    sanity_lcp
#    [Setup]  Run keywords   Testcase Setup    count=2   AND     Make outgoing call for call log   from_device=device_1     to_device=device_2
#    Select call list item   device=device_1  item=favorite
#    Calling from favorite page   from_device=device_1     to_device=device_2
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC4: [Advance calling] [Settings] [Home screen] Verify DUT user disable Advance calling.
#    [Tags]   452606    P1   sanity_lcp        phonesCY23_4
#    [Setup]  Testcase Setup for CAP Premium User     count=1
#    verify ui post signin      device=device_1:cap_search_enabled
#    Disable advance calling option       device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1   AND   Verify and enable advance calling option       device=device_1
#
#TC2: [Esc to Conf.] DUT user in P2P call with Teams client, adds another DUT user
#    [Tags]  243224        Certification_lcp
#    [Setup]  Testcase Setup     count=3
#    navigate to people tab    device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Disconnect call     device=device_1,device_2
#    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC2: [Sign-in] UI verification after Web Sign-in
#    [Tags]  243870    auth_lcp
#    [Setup]  Testcase Setup     count=1
#    verify ui post signin  device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC4: [Incoming Calls] DUT user to reject the call when UI view is in Device settings
#    [Tags]  341833
#    [Setup]  Testcase Setup     count=2
#    Navigate to device setting page from Home Screen enable page    device=device_1
#    navigate to people tab    device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Rejects the incoming call    device_list=device_1
#    Verify Call State    device_list=device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC10: [Calls] Removing contacts from favorites via TDC should reflect on DUT
#    [Tags]  452583
#    [Setup]  Run keywords   Testcase Setup    count=2   AND     Make outgoing call for call log   from_device=device_1     to_device=device_2
#    Select call list item   device=device_1  item=favorite
#    Verify added favorite user in favorites page    from_device=device_1     to_device=device_2
#    Remove favorite user from favorites page    from_device=device_1     to_device=device_2
#    Come back to home screen    device_list=device_1
#    verify favourite user after removing from favourite page    device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC19 : [Calls] DUT user's call log in the recent tab entry displays unnamed group call entry with the participants list
#    [Tags]  243650
#    [Setup]  Run keywords   Testcase Setup    count=3   AND     Make group call    from_device=device_1     to_device=device_2     new_participant=device_3
#    Select call list item   device=device_1  item=View Profile
#    #repeat keyword  2 times     device setting back     device=device_1
#    Verify group call participant details in contact card page    device=device_1   device_list=device_2,device_3
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC2: Verify that DUT user should be able to access "Third party software notices and information" page under About in settings.
#    [Tags]  348868         sanity_lcp
#    [Setup]  Testcase Setup     count=1
#    verify third party software notices for lcp    device=device_1
#    navigate to home screen from about page  device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC2 : [App Settings] DUT user to see and define Privacy and cookies
#    [Tags]  243166
#    [Setup]  Testcase Setup     count=1
#    Verify privacy and cookies view     device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC6: [Incoming Calls] DUT user rejects the incoming call from TDC
#    [Tags]  242894  sanity_lcp        Certification_lcp
#    [Setup]  Testcase Setup     count=2
#    navigate to people tab    device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Verify incoming call    device=device_1     status=appear
#    Rejects the incoming call    device_list=device_1
#    Verify Call State    device_list=device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC13 : [ZTP][Sign-in] Settings must provide options to provision phone
#    [Tags]    480354    CP_LCP    p0
#    [Setup]  Testcase Setup for LCP ZTP  count=1
#    verify signin ui on lcp  device=device_1
#    Verify settings option from signin page    device_1
#    Device setting back     device=device_1
#    verify signin ui on lcp  device=device_1
#    [Teardown]    Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

# TC1: [CAP Policy] Sign-in with CAP user
#    [Tags]  452571       bvt_lcp     sanity_lcp     phonesCY23_4
#    [Setup]   Testcase Setup for CAP User      count=1
#    verify ui post signin      device=device_1:cap_search_enabled
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC5: verify that DUT user able to access "Terms of Use" page under About in settings.
#    [Tags]  348862
#    [Setup]  Testcase Setup     count=1
#    verify options inside about page     device=device_1
#    navigate to terms of use from about page  device=device_1
#    navigate to home screen from about page  device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC3: [Call Forward] DUT user redirects unanswered calls to voicemail
#    [Tags]  243599
#    [Setup]  run keywords   Testcase Setup   count=3   AND     Enable unanswered call to voicemail    from_device=device_1    contact_device=device_2
#    navigate to people tab    device=device_2
#    Make outgoing call using display name    from_device=device_2    to_device=device_1
#    verify incoming call    device=device_1    status=appear
#    Wait for Some Time    time=${wait_time_20s}
#    wait until call disconnected    device=device_1
#    Verify Call State    device_list=device_1     state=Disconnected
#    Verify Call State    device_list=device_2    state=Connected
#    Wait for Some Time    time=${wait_time}
#    Disconnect Call    device=device_2
#    Verify Call State    device_list=device_2    state=disconnected
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=disconnected
#    Navigate to voicemail tab    device=device_1
#    verify first voicemail displayname    to_device=device_1    from_device=device_2
#    Play voicemail    device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Unanswered call Teardown   devices=device_1,device_2,device_3
#
#TC3: [Outgoing Calls] Call controls during the call
#    [Tags]  251367     sanity_lcp        Certification_lcp
#    [Setup]  Testcase Setup     count=2
#    navigate to people tab    device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Verify call control visibility    device_list=device_1
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC5: [Sign-in] Settings must provide options to provision phone
#    [Tags]  250084  bvt_lcp      sanity_lcp    auth_lcp    auth_lcp_p0
#    [Setup]  Testcase Setup for LCP ZTP  count=1
#    verify signin ui on lcp  device=device_1
#    verify settings from signin page    device=device_1
#    Device setting back     device=device_1
#    verify signin ui on lcp  device=device_1
#    [Teardown]    Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1
#
#TC3: [Esc to Conf.] DUT user in P2P call with another DUT user, adds Teams Client to call
#    [Tags]  243231
#    [Setup]  Testcase Setup     count=3
#    navigate to people tab    device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Disconnect call     device=device_1,device_2
#    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#

#TC6: [Sign-in] User to be Signed into DUT within a specified time limit
#    [Tags]  244255   bvt_lcp    sanity_lcp    auth_lcp    auth_lcp_p0
#    [Setup]   Testcase Setup     count=1
#    sign out  device_list=device_1
#    verify signin ui on lcp  device=device_1
#    signin method for lcp   device=device_1
#    verify ui post signin  device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC12 : [ZTP][Sign-in] User should able go back to sign-in page from cloud
#    [Tags]    435889    CP_LCP    p1
#    [Setup]  Testcase Setup for LCP ZTP  count=1
#    verify signin ui on lcp  device=device_1
#    Verify settings from signin page    device_1
#    Verify cloud option   device_1
#    Navigate back to signin page form cloud    device_1
#    verify signin ui on lcp  device=device_1
#    [Teardown]    Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1
#
#TC6: [Call Merge] Verify merge transition screen is displayed properly
#    [Tags]      244117
#    [Setup]  Testcase Setup     count=3
#    navigate to people tab    device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    repeat keyword  3 times     device setting back     device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    verify call state    device_list=device_1,device_3     state=Connected
#    verify call state    device_list=device_2              state=Hold
#    Verify and merge call    device=device_1     from_device=device_2
#    Verify transition Screen during Call merge  device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Disconnect call     device=device_1,device_2
#    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC2: DUT should display Send to voicemail option in Incoming Call UI.
#    [Tags]  452345
#    [Setup]  Testcase Setup     count=2
#    navigate to people tab    device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    verify incoming call        device=device_1         status=appear
#    verify and click send to voicemail option for incoming call          device=device_1    option=appear
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2
#
#TC 5: [Auto Restart] DUT user enables App Restart option.
#    [Tags]  452455
#    [Setup]  Testcase Setup  count=1
#    Enable app restart toggle button    device=device_1    status=on
#    [Teardown]  Run Keywords    Capture on Failure   AND     Disable app restart toggle button    device=device_1   status=off    AND   Come back to home screen    device_list=device_1

#Test case removed due to following bug - Bug 4100287: [MTRA]Report an issue option is missing under settings.
# TC8: [ZTP]Teams app user should able to report an issue at sign in page
#     [Tags]  320960    auth_lcp
#     [Setup]  Testcase Setup for LCP ZTP  count=1
#     verify signin ui on lcp  device=device_1
#     report an issue from signin page    device=device_1
#     [Teardown]  Run keywords    Capture on Failure   AND     come back to home screen    device_list=device_1

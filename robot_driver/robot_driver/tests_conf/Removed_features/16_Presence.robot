*** comment ***

Removed the cases as per the feature: Feature Test Request 3005455: [Phones] [Modularization] [Supportability] Drive consistent user experience to improve supportability
Removed in 1.2.0 (U2 2024)

Resource    ../resources/keywords/common.robot

#Suite Setup     User Setup Main
Suite Teardown    Suite Failure Capture


${wait_time} =      10s
${10m_wait_time} =      10 minutes


TC1 : [Presence] User can view the self presence in the form of Presence icon on the hamburger menu
    [Tags]  305895   bvt_tpc     sanity_tpc  P0
    [Setup]  Testcase Setup for Meeting User    count=1
    Select user presence   device=device_1     state=Available
    Verify user presence   device=device_1     state=Available
    [Teardown]   run keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC2 : [Presence] Verify that if TDC changes Presence, it should reflect at both TDC and DUT
    [Tags]   305897  sanity_tpc  P1
    [Setup]   Testcase Setup for Meeting User    count=1
    Select user presence   device=device_1     state=Available
    Verify user presence   device=device_1     state=Available
    Select user presence   device=device_1     state=DND
    Verify user presence   device=device_1     state=DND
    Select user presence   device=device_1     state=Available
    [Teardown]   run keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1
    
TC3 : [Presence] Presence changes to "In a call" from available when the user makes a call
    [Tags]   305892  sanity_tpc  P1
    [Setup]  Testcase Setup for Meeting User    count=2
    Select user presence   device=device_1     state=Available
    Verify user presence   device=device_1     state=Available
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Wait for Some Time    time=${wait_time}
    Verify user presence from other user    from_device=device_2      to_device=device_1:meeting_user      state=In call
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Wait for Some Time    time=${wait_time}
    Verify user presence from other user    from_device=device_2      to_device=device_1:meeting_user     state=Available
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC4 :[App Settings] DUT user to reset its presence status
    [Tags]    196659    P2
    [Setup]   Testcase Setup for Meeting User    count=1
    Select user presence   device=device_1     state=Away
    Verify user presence   device=device_1     state=Away
    Select user presence   device=device_1     state=reset_status
    Verify user presence   device=device_1     state=Available
    Select user presence   device=device_1     state=Available
    Verify user presence   device=device_1     state=Available
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1


TC5 : [Presence] Verify that if Device (Teams App) changes Presence, it should reflect on both TDC and DUT
    [Tags]  196686   p1
    [Setup]   Testcase Setup for Meeting User    count=3
    Signin with other user    device=device_2   other_user_account=device_1:meeting_user
    Select user presence   device=device_1     state=Busy
    Verify user presence   device=device_1     state=Busy
    Verify user presence   device=device_2     state=Busy
    Verify user presence from other user    from_device=device_3      to_device=device_1:meeting_user     state=Busy
    Select user presence   device=device_1     state=Available
    [Teardown]   run keywords    Capture on Failure    AND       Come back to home screen    device_list=device_1,device_2,device_3

TC6 : [Presence] Presence changes to "In a call" from "Busy" when the user makes a call
    [Tags]  196681   p1
    [Setup]  Testcase Setup for Meeting User    count=2
    Select user presence   device=device_1     state=Busy
    Verify user presence   device=device_1     state=Busy
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify user presence from other user    from_device=device_2      to_device=device_1:meeting_user     state=In call
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC7 : [Presence] Presence should not change from "Away" to "In a call" when the user makes a call
    [Tags]  196682    p1
    [Setup]  Testcase Setup for Meeting User    count=2
    Select user presence   device=device_1     state=Away
    Verify user presence   device=device_1     state=Away
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify user presence from other user    from_device=device_2      to_device=device_1:meeting_user     state=Away
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Wait for Some Time    time=${wait_time}
    Verify user presence from other user    from_device=device_2      to_device=device_1:meeting_user     state=Away
    Select user presence   device=device_1     state=Available
    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen     device_list=device_1,device_2

TC8 : [Presence] Presence should not change to offline if DUT user sign out but same user is still signed in on TDC
    [Tags]  196688   p2
    [Setup]  Testcase Setup for Meeting User    count=3
    Signin with other user    device=device_2   other_user_account=device_1:meeting_user
    Select user presence   device=device_1     state=Available
    Verify user presence   device=device_1     state=Available
    Verify user presence   device=device_2     state=Available
    sign out method    device_1
    Verify user presence from other user    from_device=device_3      to_device=device_2:meeting_user     state=Available
    Sign in method      device=device_1      user=meeting_user
    [Teardown]   Run Keywords    Capture on Failure   AND     Come back to home screen    device_list=device_1,device_2,device_3

TC9 : [Presence] Presence should not change to offline if TDC user sign out but same user is still signed in on DUT
    [Tags]   305899   p2
    [Setup]  Testcase Setup for Meeting User    count=3
    Signin with other user    device=device_2   other_user_account=device_1:meeting_user
    Select user presence   device=device_1     state=Available
    Verify user presence   device=device_1     state=Available
    Verify user presence   device=device_2     state=Available
    Sign out method    device=device_2
    Verify user presence from other user    from_device=device_3     to_device=device_1:meeting_user     state=Available
    Sign in method      device=device_1      user=meeting_user
    [Teardown]   Run Keywords    Capture on Failure   AND     Come back to home screen    device_list=device_1,device_2,device_3

TC10 : [Presence] Presence should change to the previous state at the end of Conference call/P2P call
    [Tags]   305900   p2
    [Setup]  Testcase Setup for Meeting User    count=3
    create meeting  device=device_2     participants=device_1:meeting_user    meeting=cnf_device_meeting
    Join meeting   device=device_2,device_1    meeting=cnf_device_meeting       join_styles=None,conference
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify user presence from other user    from_device=device_3     to_device=device_1:meeting_user     state=In call
    End meeting     device=device_1
    Verify user presence from other user   from_device=device_3     to_device=device_1:meeting_user     state=Available
    End meeting     device=device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   Run Keywords     Capture on Failure  AND   Test Case Teardown without deleting meeting     devices=device_2    count=2



Test Case Teardown without deleting meeting
    [Arguments]     ${devices}   ${count}
    check for device count      count=${count}
    Come back to home screen    ${devices}
    Close dial pad  device=device_1
    Teardown Meeting Test Case     ${devices}
#TC1 : [Call Park] DUT user to park and retrieve the incoming call from TDC
#    [Tags]  149440   P1
#    [Setup]  Testcase Setup for CAP User    count=2
#    click on calls tab    device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    ${call_park_code}=    call park and get the code    device=device_1
#    Unpark Call    ${call_park_code}    device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure   AND   dismiss multiple call park banner   device=device_1   AND    Come back to home screen   device_list=device_1,device_2
#
#TC7 : [Teams Button] Pressing on Teams button, user should land on Home Screen
#    [Tags]    468718    Certification_CAP    p1
#    [Setup]    Testcase Setup for CAP User   count=1
#    ${Teams_button}    has hardkey teams button supported device   device=device_1
#    pass execution if   '${Teams_button}'=='False'  device_1, device is not have Teams button
#    open settings page      device=device_1
#    click on device settings page     device=device_1
#    press hardkeys    device=device_1    hardkey_intent=KEYCODE_BUTTON_12
#    verify home screen UI for cap     device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC24 : [Multiple Call Banner] DUT user to check call hold banner when call hand-off banner is already present
#    [Tags]  314043     P1
#    [Setup]  Testcase Setup for Call hand off    count=4
#    click on people tab    device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_3
#    Pick incoming call    device=device_3
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Verify call hand off banner     device=device_1
#    click on people tab    device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_4
#    Pick incoming call    device=device_4
#    Verify Call State    device_list=device_1,device_4    state=Connected
#    Hold the call   device=device_1
#    Verify Call State    device_list=device_1,device_4     state=Hold
#    click back      device=device_1
#    verify call hold banner    from_device=device_1     to_device=device_4
#    Verify call hand off banner     device=device_1
#    Disconnect call     device=device_2,device_4
#    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1      AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4
#TC1 : [Encryption] Check device encryption
#    [Tags]  261723   P0
#    [Setup]  Testcase Setup for CAP User     count=1
#    Check device encryption state    device=device_1
#    [Teardown]   Run Keywords   Capture on Failure   AND    Come back to home screen   device_list=device_1
#    TC1:[Sign-in][Intune]User should be able to sign-in code using Intune License Account..
#    [Tags]     346197    bvt_cap     sanity_cap    auth_cap    auth_cap_p0
#    [Setup]  Testcase Setup for CAP User    count=1
#    Sign out method    device_1
#    Wait for Some Time    time=${wait_time}
#    Sign in method      device=device_1    user=intune_user
#    verify user contact info        device=device_1:intune_user
#    [Teardown]   Run Keywords    Capture on Failure     AND        Sign out method    device_1
#TC1 : Verify basic call scenario for 'private line' call
#    [Tags]      459073   bvt_cap     sanity_cap
#    [Setup]  Testcase Setup for CAP User   count=3
#    click on calls tab  device=device_2
#    Make outgoing call using privateline number    from_device=device_2      to_device=device_1:cap_search_enabled
#    verify privateline label on call screen     device=device_1
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    ${call_park_code}=    call park and get the code    device=device_1
#    Unpark Call    ${call_park_code}    device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
#    Pick incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_3,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2,device_3
#
#TC17 : [Multiple Call Banner] DUT to hold multiple calls and park the outgoing call with TDC user.
#    [Tags]  314040    P2
#    [Setup]    Testcase Setup for CAP User      count=4
#    click on calls tab    device=device_2
#    Make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    click on calls tab    device=device_3
#    Make outgoing call using display name    from_device=device_3     to_device=device_1:cap_search_enabled
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Verify Call State    device_list=device_2    state=Hold
#    Hold the call    device=device_1
#    Verify Call State    device_list=device_1,device_3    state=Hold
#    verify multiple calls on hold in banner     from_device=device_1    to_device=device_2,device_3
#    click on calls tab    device=device_4
#    Make outgoing call using display name    from_device=device_4     to_device=device_1:cap_search_enabled
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_4    state=Connected
#    click call park    device=device_1
#    wait for some time    time=${wait_time2}
#    verify multiple calls on hold in banner     from_device=device_1    to_device=device_2,device_3,device_4
#    Disconnect call      device=device_2,device_3,device_4
#    close call park banner      device=device_1
#    Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4
#TC2 :[Sign-in][Intune]User should be able to sign-in using DCF code using Intune License Account..
#    [Tags]      346198      bvt_cap     sanity_cap    auth_cap    auth_cap_p0
#    [Setup]    Run Keywords    Sign out method    device_1    AND    Testcase Setup for ZTP  count=1
#    signin method with dcf code    device=device_1    user=intune_user
#    Wait for Some Time    time=${wait_time}
#    navigate to people tab from home screen for cap    device=device_1
#    verify user contact info        device=device_1:intune_user
#    [Teardown]   Run Keywords    Capture on Failure     AND    Sign out method    device_1    AND     Sign in method     device_1       user=cap_search_enabled
#TC1 : [Home screen] Verify DUT should navigate to Home screen when user tap on back button in Dialpad screen
#    [Tags]   402410     P2
#    [Setup]  Testcase Setup for CAP User    count=1
#    verify home screen UI for cap   device=device_1
#    [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1
#TC3: [Sign-in] User to sign-in from another device (web sign-in)
#    [Tags]  308380   bvt_cap     sanity_cap    auth_cap    auth_cap_p0
#    [Setup]  Testcase Setup for CAP User    count=1
#    sign out method  device=device_1
#    verify teams app signin page    device=device_1
#    Wait for Some Time    time=20
#    Reset Logcat Capture    device=device_1
#    signin method with dcf code    device=device_1    user=user
#    Verify presence of Intents        device=device_1         feature=user_password         state=absent
#    [Teardown]   Run Keywords    Capture on Failure      AND    Come back to home screen    device_list=device_1
#
#TC20 : Verify that 'private line' label present after incoming call
#    [Tags]      459064   bvt_cap     sanity_cap
#    [Setup]  Testcase Setup for CAP PSTN User   count=3
#    click on calls tab  device=device_3
#    Make outgoing call using privateline number    from_device=device_3      to_device=device_1:cap_search_enabled
#    verify privateline label on call screen     device=device_1
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_3     state=Disconnected
#    click on calls tab  device=device_2
#    Make outgoing call using privateline number    from_device=device_2      to_device=device_1:cap_search_enabled
#    verify privateline label on call screen     device=device_1
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2,device_3
#
#TC7 : [Call Park] Reject ring back to retrieve the parked call
#    [Tags]  149445   P2
#    [Setup]  Testcase Setup for CAP User   count=2
#    click on calls tab    device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    ${call_park_code}=    call park and get the code    device=device_1
#    Wait for Some Time    time=${5_minutes_wait_time}
#    Verify Incoming call    device=device_1     status=appear
#    Rejects the incoming call    device_list=device_1
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND   dismiss multiple call park banner   device=device_1   AND    Come back to home screen   device_list=device_1,device_2
#

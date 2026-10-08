#TC7 : [Call Merge] DUT user receives multiple calls and merges call one by one
#    [Tags]   309887     p0  alt_blocked     Certification_audio    exclude_ftp    #sanity_tp
#    [Setup]     Testcase Setup      count=5
#    Click on calls tab   device=device_1
#    Make outgoing call using display name    from_device=device_1     to_device=device_2
#    Pick incoming call   device=device_2
#    Wait for Some Time    time=${wait_time}
#    verify call state    device_list=device_1,device_2     state=Connected
#    Click on calls tab   device=device_3
#    Make outgoing call using display name    from_device=device_3     to_device=device_1
#    Pick incoming call from call notification    device=device_1
#    Wait for Some Time   time=${wait_time}
#    verify call state    device_list=device_1,device_3    state=Connected
#    verify call state    device_list=device_2    state=Hold
#    Click on calls tab   device=device_4
#    Make outgoing call using display name    from_device=device_4    to_device=device_1
#    Pick incoming call from call notification    device=device_1
#    Wait for Some Time    time=${wait_time}
#    verify call state     device_list=device_1,device_4      state=Connected
#    verify call state     device_list=device_2,device_3      state=Hold
#    Click on calls tab   device=device_5
#    Make outgoing call using display name    from_device=device_5    to_device=device_1
#    Pick incoming call from call notification    device=device_1
#    Wait for Some Time     time=${wait_time}
#    verify call state      device_list=device_1,device_5      state=Connected
#    verify call state     device_list=device_2,device_3,device_4    state=Hold
#    Verify and merge call  device=device_1    from_device=device_2
#    verify call state     device_list=device_1,device_2,device_3,device_4,device_5    state=Connected
#    disconnect call    device=device_2,device,device_3,device_4,device_5
#    Verify and merge call  device=device_1    from_device=device_3
#    Verify Call State   device_list=device_1,device_2,device_3,device_4,device_5     state=Disconnected
#    [Teardown]   verify device criteria and teardown
#
#TC7 : [OBO] DUT user has multiple boss and able to make call to another user on behalf of himself
#    [Tags]  308995   p0  alt_blocked        Certification_audio     exclude_ftp
#    [Setup]   Testcase Setup for Delegate User  count=5
#    Add new delegates with both permission and validate   from_device=device_3    to_device=device_2:delegate_user
#    Add new delegates with both permission and validate   from_device=device_4    to_device=device_2:delegate_user
#    Initiate OBO call and verify boss list  from_device=device_2     to_device=device_5     obo_option=myself     boss_list=device_1,device_3,device_4
#    Verify Incoming call    device=device_5    status=appear
#    Pick incoming call    device=device_5
#    Verify Call State    device_list=device_2,device_5    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2,device_5     state=Disconnected
#    [Teardown]     verify device criteria and teardown
#
#TC12 : [OBO] DUT user has multiple boss and able to make calls another boss on behalf of a boss.
#    [Tags]  308677   p1  alt_blocked        exclude_ftp
#    [Setup]   Testcase Setup for Delegate User  count=5
#    Add new delegates with both permission and validate   from_device=device_3    to_device=device_2:delegate_user
#    Add new delegates with both permission and validate   from_device=device_4    to_device=device_2:delegate_user
#    Initiate OBO call and verify boss list  from_device=device_2     to_device=device_5     obo_option=device_1     boss_list=device_1,device_3,device_4
#    Verify Incoming call    device=device_5    status=appear
#    Pick incoming call    device=device_5
#    Verify Call State    device_list=device_1,device_5    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_5     state=Disconnected
#    [Teardown]  verify device criteria and teardown
#
#TC11 : [OBO] DUT user has multiple boss and able to receive calls on behalf of them_ also ring
#    [Tags]  308681    exclude_ftp       #sanity_tp   p0  alt_blocked
#    [Setup]    Testcase Setup for Delegate User  count=5
#    Add new delegates with both permission and validate   from_device=device_3    to_device=device_2:delegate_user
#    Enable Also Ring delegates     device=device_3
#    Click on calls tab    device=device_4
#    Make outgoing call using display name    from_device=device_4    to_device=device_1
#    Verify Incoming call    device=device_1,device_2     status=appear
#    Pick incoming call    device=device_2
#    Verify Incoming call    device=device_1     status=disappear
#    Verify Call State    device_list=device_2,device_4    state=Connected
#    Click on calls tab    device=device_5
#    Make outgoing call using display name    from_device=device_5    to_device=device_3
#    Verify Incoming call    device=device_3,device_2     status=appear
#    Pick incoming call    device=device_2
#    Verify Incoming call    device=device_3     status=disappear
#    Verify Call State    device_list=device_2,device_5    state=Connected
#    Resume the hold call     device=device_2
#    Verify Call State    device_list=device_5     state=Hold
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2,device_4,device_5     state=Disconnected
#    [Teardown]  Verify device criteria and also ring teardown
#
#TC9 : [OBO]DUT user has multiple boss and able to receive calls on behalf of them_ call forwarding
#    [Tags]  308707   P1  alt_blocked        exclude_ftp
#    [Setup]   Testcase Setup for Delegate User  count=5
#    Add new delegates with both permission and validate   from_device=device_3    to_device=device_2:delegate_user
#    Enable call forwarding to delegates     from_device=device_3    contact_device=device_2
#    Make outgoing call using display name    from_device=device_4    to_device=device_1
#    Verify incoming call    device=device_2     status=appear
#    Pick incoming call   device=device_2
#    Verify Call State    device_list=device_2,device_4    state=Connected
#    Make outgoing call using display name    from_device=device_5    to_device=device_3
#    Verify incoming call    device=device_2     status=appear
#    Pick incoming call   device=device_2
#    Verify Call State    device_list=device_2,device_5    state=Connected
#    Verify Call State    device_list=device_4     state=Hold
#    Resume the hold call     device=device_2
#    Verify Call State    device_list=device_5     state=Hold
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2,device_4,device_5     state=Disconnected
#    [Teardown]  Verify device criteria and call forward teardown
#
#TC3 : [GCP] DUT user accepts 3 forwarded GCP calls and toggles between them
#    [Tags]  308627      P1  alt_blocked    exclude_ftp       # bvt_tp  sanity_tp
#    [Setup]   Testcase Setup for GCP User  count=5
#    click on calls tab   device=device_3
#    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
#    Verify call notification    device=device_2     status=appear
#    Pick incoming call from call notification    device=device_2
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    click on calls tab   device=device_4
#    Make outgoing call using phonenumber    from_device=device_4      to_device=device_1
#    Verify incoming call    device=device_2     status=appear
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_2,device_4    state=Connected
#    Verify Call State    device_list=device_3     state=Hold
#    click on calls tab   device=device_5
#    Make outgoing call using phonenumber    from_device=device_5      to_device=device_1
#    Verify incoming call    device=device_2     status=appear
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_2,device_5    state=Connected
#    Wait for Some Time    time=${wait_time}
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_2,device_3,device_4,device_5     state=Disconnected
#    [Teardown]  verify device criteria and teardown

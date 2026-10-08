*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Run Keywords    Suite Failure Capture

*** Variables ***
${wait_time} =  10
${6m_wait_time} =  7 minutes
${hd_timeout_time} =  12 minutes



*** Test Cases ***
TC1 : [Hot Desking] Hot Desking - Host user timeout policy
    [Tags]   309199         bvt_pr         alt_blocked
    [Setup]  Testcase Setup    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2   AND   End hot desk    device=device_1

TC2 : [Hot Desking] DUT user navigates back to Host User, when signed out from HD.
    [Tags]   309124     sanity_tp    bvt_pr        alt_blocked
    [Setup]  Testcase Setup    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    sign out from HD mode    device=device_1
    Validate username after signed out from hot desking    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3 : [Hot Desking] Stop hot desking
    [Tags]   309155  sanity_tp         bvt_pr        alt_blocked     Certification_audio
    [Setup]  Testcase Setup    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    End hot desk    device=device_1
    Validate username after signed out from hot desking    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC4 : [Hot Desking] Hot Desking Timeout
    [Tags]   309118     bvt_tp   sanity_tp            alt_blocked
    [Setup]  Testcase Setup    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Wait for Some Time    time=${hd_timeout_time}
    Validate username after signed out from hot desking    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC5 : [Hot Desking] Hot desking behavior when idle time out expires.
    [Tags]   309131     P1  alt_blocked
    [Setup]  Testcase Setup    count=2
    Hot desking signin    device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    navigate to hamburger menu    device=device_1
    Wait for Some Time    time=${hd_timeout_time}
    validate username after signed out from hot desking    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC6 : [Hot Desking] No hot desk option for Hot desking user
    [Tags]   309201     P1  alt_blocked
    [Setup]  Testcase Setup    count=2
    Hot desking signin    device=device_1     hot_desk_account=device_2
    Validate no hot desking option for HD User    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1   AND    End hot desk    device=device_1

TC7 : [Hot Desking] Sign in with valid user with a different organization credentials
    [Tags]   309204     P2  alt_blocked
    [Setup]  Testcase Setup    count=2
    Hot desking signin    device=device_1     hot_desk_account=device_2:pstn_user
    Wait for some time   time=${wait_time}
    Verify hot desking mode     device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1   AND    End hot desk    device=device_1

TC8 :[Hot Desking] Sign-in back to Host user clears all Hot desking user data.
    [Tags]   309164     P2  alt_blocked
    [Setup]  Testcase Setup    count=3
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Come back to home screen    device_list=device_1,device_2
    Hot desking signin    device=device_1     hot_desk_account=device_2
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    Come back to home screen    device_list=device_1,device_3
    ${participant_name_before_HD}   Get first call participant name    device=device_1
    End hot desk    device=device_1
    ${participant_name_after_HD}   Get first call participant name    device=device_1
    run keyword if  '${participant_name_before_HD}' != '${participant_name_after_HD}'    Log   Call log is not matching after ending HD
    ...   ELSE   FAIL   Call log is matching after ending HD
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3      AND    End hot desk    device=device_1

TC9 : [Hot Desking] Sign in with invalid user
    [Tags]   309128     P3  alt_credentials
    [Setup]  Testcase Setup    count=1
    Validate HD signin with invalid user    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   device_setting_back   device=device_1   AND  Come back to home screen    device_list=device_1

TC10 : [Hot Desking] Hot desk and Host user should be the same user.
    [Tags]   309136     P1  alt_credentials
    [Setup]  Testcase Setup    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    sign out from HD mode    device=device_1
    Wait for some time   time=${wait_time}
    Validate username after signed out from hot desking    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC11 : [Hot Desking] Sign out Hot Desk user from DUT
    [Tags]   309158     P1  alt_blocked
    [Setup]  Testcase Setup    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    sign out from HD mode    device=device_1
    Wait for some time   time=${wait_time}
    Validate username after signed out from hot desking    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC12 : [Hot Desking] Hot desk user cancels sign in
    [Tags]   309207	  P3  alt_blocked
    [Setup]  Testcase Setup    count=2
    Validate cancels Hot desking signin   device=device_1     hot_desk_account=device_2
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC13 : [Hot Desking] Hot Desking policy - Disabled
    [Tags]   309196     P1  alt_blocked
    [Setup]  Testcase Setup for HD disabled user   count=2
    Verify HD signin button for HD policy disable user   device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC14 : [Hot Desking] Hot desk user calls TDC user
    [Tags]  311582   P0   bvt_tp     sanity_tp
    [Setup]  Testcase Setup    count=3
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    verify incoming call   device=device_3   status=appear
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    End hot desk    device=device_1
    Wait for some time   time=${wait_time}
    Validate username after signed out from hot desking    device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_3

TC15 : [Hot Desk] verify call should not hit device for host user when hot desk user is loggedin
    [Tags]  318557   P2
    [Setup]  Testcase Setup    count=3
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    click on calls tab   device=device_3
    Initiate and verify call to host user   from_device=device_3     to_device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3      AND   End hot desk    device=device_1

TC16: [ZTP][Sign-in] Hot desking should be supported via username/password flow
    [Tags]    311701    p1
    [Setup]    Testcase Setup    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    Verify Presence Of Intents    device=device_1    feature=user_password    state=absent
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2      AND   End hot desk    device=device_1

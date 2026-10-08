*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot


Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10
${5m_wait_time} =   5 minutes
${hd_timeout_time} =  10 minutes


*** Test Cases ***
TC1 : [Hot Desking] Hot Desking policy - Enabled
    [Tags]   150062     P2        Certification_cap
    [Setup]  Testcase Setup for CAP User    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1  AND   End hot desk    device=device_1

TC2 : [Hot Desking] Display of Hot Desking mode on Home screen, when clicked on settings.
    [Tags]   150064     P2
    [Setup]  Testcase Setup for CAP User    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND     End hot desk    device=device_1

TC3 : [Hot Desking] Sign in with invalid user
    [Tags]   150071     P2
    [Setup]  Testcase Setup for CAP User    count=1
    Validate HD signin with invalid user    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   device_setting_back   device=device_1   AND  Come back to home screen    device_list=device_1

TC4 : [Hot Desking] Sign in with valid user
    [Tags]   150070     P2
    [Setup]  Testcase Setup for CAP User    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1   AND   End hot desk    device=device_1

TC5 : [hot Desking] Sign in with valid user with a different organization credentials
    [Tags]  150117  P2
    [Setup]  Testcase Setup for CAP User    count=2
    Hot desking signin    device=device_1     hot_desk_account=device_2:pstn_user
    Wait for some time   time=${wait_time}
    Verify hot desking mode     device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1   AND    End hot desk    device=device_1

TC6 : [Hot Desking] Hot desk user is able to access settings option
    [Tags]  150076  P2   sanity_cap
    [Setup]  Testcase Setup for CAP User    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    Verify settings page in HD mode    device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2     AND   End hot desk    device=device_1

TC7 : [Hot Desking] Stop hot desking
    [Tags]  150081  P2   sanity_cap        Certification_cap
    [Setup]  Testcase Setup for CAP User    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    End hot desk    device=device_1
    Validate username after signed out from hot desking    device=device_1:cap_search_enabled
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC8 : [Hot Desking] Hot Desking Timeout
    [Tags]   150063     P2   sanity_cap  bvt_cap
    [Setup]  Testcase Setup for CAP User    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode     device=device_1
    Wait for Some Time    time=${hd_timeout_time}
    Validate username after signed out from hot desking    device=device_1:cap_search_enabled
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC9 : [Hot Desking] DUT user navigates back to Host User, when signed out from HD.
    [Tags]   150066     P2
    [Setup]  Testcase Setup for CAP User    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    End hot desk    device=device_1
    Validate username after signed out from hot desking    device=device_1:cap_search_enabled
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC10 : [Hot Desking] sign out Hot Desk user from DUT
    [Tags]   150082     P2
    [Setup]  Testcase Setup for CAP User    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    Verify settings page in HD mode     device=device_1
    sign out from HD mode    device=device_1
    Wait for some time   time=${wait_time}
    Validate username after signed out from hot desking    device=device_1:cap_search_enabled
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC11 : [Hot Desking] Host User details not displayed, when signed in with Hot Desk User.
    [Tags]   150085     P2
    [Setup]  Testcase Setup for CAP User    count=2
    Hot desking signin    device=device_1     hot_desk_account=device_2
    Verify hot desking mode     device=device_1
    Verify HD user details     device=device_1    hd_user=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1   AND    End hot desk    device=device_1

TC12 : [Hot Desking] Hot desk user cancels sign in
    [Tags]   150118	  P2
    [Setup]  Testcase Setup for CAP User    count=2
    Validate cancels Hot desking signin   device=device_1     hot_desk_account=device_2
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC13 : [Hot Desking] Hot Desking - Host user timeout policy
    [Tags]   150115	  P2
    [Setup]  Testcase Setup for CAP User    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify HD timeout    device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2     AND   End hot desk    device=device_1

TC14 : [Hot Desking] Hot Desking policy - Disabled
    [Tags]   150114     P2
    [Setup]  Testcase Setup for HD disabled user   count=2
    Verify HD signin button for HD policy disable user   device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC15 : [Hot Desking] Check User warning for Hot Desk time remaining.
    [Tags]   150065     P2   sanity_cap
    [Setup]  Testcase Setup for CAP User    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Wait for Some Time    time=${5m_wait_time}
    Verify hotdesking automatic timeout warning    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND   End hot desk    device=device_1

TC16 : [Hot Desking] Hot desking behavior when idle time out expires.
    [Tags]   150072     P2
    [Setup]  Testcase Setup for CAP User    count=2
    Hot desking signin    device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    navigate to hamburger menu    device=device_1
    Wait for Some Time    time=${hd_timeout_time}
    validate username after signed out from hot desking    device=device_1:cap_search_enabled
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC17 : [Hot Desking] No hot desk option for Hot desking user
    [Tags]   150116     P2
    [Setup]  Testcase Setup for CAP User    count=2
    Hot desking signin    device=device_1     hot_desk_account=device_2
    Validate no hot desking option for HD User    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1   AND    End hot desk    device=device_1

TC18 : [Hot Desking] Device settings option should be enabled under settings for Hot desk user
    [Tags]   150077     P2
    [Setup]  Testcase Setup for CAP User    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    Verify settings page in HD mode    device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2     AND   End hot desk    device=device_1

TC19 : [Hot Desking] Hot desk and Host user should not be same.
    [Tags]   150073     P2
    [Setup]  Testcase Setup for CAP User   count=1
    Validate HD signin with Host user    device=device_1:cap_search_enabled     hot_desk_account=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND   End hot desk    device=device_1

TC20 : [Hot Desking] No Access to Advance settings/features for Hot desking user.
    [Tags]   150078     P2
    [Setup]  Testcase Setup for CAP User    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hd user access to advance setting page   device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2     AND   End hot desk    device=device_1

TC21 : [Hot Desk] Hot desk user should sign-out if user stop hot desking by taping on "Stop hot desking" option in Menu
    [Tags]   318576     P2
    [Setup]  Testcase Setup for CAP User    count=2
    Hot desking signin   device=device_1      hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    End hot desk    device=device_1
    Validate username after signed out from hot desking    device=device_1:cap_search_enabled
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC22 : [Hot Desk] Host user credential should be saved
    [Tags]   321214    P2
    [Setup]  Testcase Setup for CAP User   count=2
    Hot desking signin   device=device_1      hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    sign out from HD mode    device=device_1
    Wait for some time   time=${wait_time}
    Validate username after signed out from hot desking    device=device_1:cap_search_enabled
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC23 : [Hot Desk] Hot Desk option should not available in menu for the user having hot desking policy disabled
    [Tags]   318585     P2
    [Setup]  Testcase Setup for HD disabled user   count=2
    Verify HD signin button for HD policy disable user   device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC24 : [Hot Desk] verify call should not hit device for host user when hot desk user is loggedin
    [Tags]  321222   P2
    [Setup]   Testcase Setup for CAP User    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    click on calls tab    device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1:cap_search_enabled
    Verify Incoming call    device=device_1     status=Disappear
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3      AND   End hot desk    device=device_1

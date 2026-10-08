*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot


Suite Teardown    Suite Failure Capture

*** Variables ***
${hd_timeout_time} =  9 minutes
${2_minutes_wait_time} =  2 minutes
*** Test Cases ***
TC1 : [Hot Desking] Stop hot desking
    [Tags]  316083   sanity_tpc  P1
    [Setup]    Testcase Setup for Meeting User   count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    End hot desk    device=device_1
    Validate username after signed out from hot desking         device=device_1:meeting_user
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1     AND   End hot desk    device=device_1

TC2 : [Hot Desking] Hot Desking policy - Disabled
    [Tags]   316088     P1
    [Setup]  Testcase Setup for HD disabled user   count=2
    Verify HD signin button for HD policy disable user   device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1        

TC3 : [Hot Desking] Hot desk user calls TDC user
    [Tags]   316095      bvt_tpc     sanity_tpc  P0
    [Setup]  Testcase Setup for Meeting User    count=3
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    click on calls tab     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    verify incoming call   device=device_3   status=appear
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    End hot desk    device=device_1
    Validate username after signed out from hot desking      device=device_1:meeting_user
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_3

TC4 : [Hot Desking] Hot desk user can access app settings option
    [Tags]   316080  sanity_tpc  P1
    [Setup]  Testcase Setup for Meeting User     count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    Verify settings page in HD mode    device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1     AND   End hot desk    device=device_1

TC5 : [Hot Desking] Host user signed in automatically after Hot Desk user signs out.
    [Tags]   316074  sanity_tpc  P1
    [Setup]   Testcase Setup for Meeting User      count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    sign out from HD mode    device=device_1
    Validate username after signed out from hot desking    device=device_1:meeting_user
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC6 : [Hot Desking] Device settings access should be available for Hot desk user
    [Tags]   316081     P1
    [Setup]  Testcase Setup for Meeting User    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    Verify settings page in HD mode    device=device_1
    click device settings       device=device_1
    device setting back     device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1     AND   End hot desk    device=device_1

TC7 : [Hot Desking] No hot desk option for Hot desking user
    [Tags]  316090    P1
    [Setup]  Testcase Setup for Meeting User    count=2
    Hot desking signin    device=device_1     hot_desk_account=device_2
    Validate no hot desking option for HD User    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1   AND    End hot desk    device=device_1

TC8: [Hot Desking] Sign out Hot Desk user from DUT
    [Tags]   316084    P1
    [Setup]   Testcase Setup for Meeting User   count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    sign out from HD mode    device=device_1
    Validate username after signed out from hot desking    device=device_1:meeting_user
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1   AND    End hot desk    device=device_1

TC9 : [Hot Desking] Hot Desking - Host user timeout policy
    [Tags]   316089	  P1
    [Setup]   Testcase Setup for Meeting User     count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify HD timeout    device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1   AND   End hot desk    device=device_1

TC10 : [Hot Desking] Sign in with valid user with a different organization credentials
    [Tags]   316091     P2
    [Setup]   Testcase Setup for Meeting User    count=2
    Hot desking signin    device=device_1     hot_desk_account=device_2:pstn_user
    Verify hot desking mode     device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1   AND    End hot desk    device=device_1

TC11 : [Hot Desk] Host user credential should be saved
    [Tags]   318534    P2
    [Setup]  Testcase Setup for Meeting User   count=2
    Hot desking signin   device=device_1      hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    sign out from HD mode    device=device_1
    Validate username after signed out from hot desking    device=device_1:meeting_user
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC12 : [Hot Desk] Hot desk user should sign-out if user stop hot desking by taping on "Stop hot desking" option in Menu
    [Tags]   318578     P2
    [Setup]  Testcase Setup for Meeting User   count=2
    Hot desking signin   device=device_1      hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    End hot desk    device=device_1
    Validate username after signed out from hot desking    device=device_1:meeting_user
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC13 : [Hot Desking] Sign in with invalid user
    [Tags]   316075     P3
    [Setup]   Testcase Setup for Meeting User   count=1
    Validate HD signin with invalid user    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   device_setting_back   device=device_1   AND  Come back to home screen    device_list=device_1

TC14 : [Hot Desking] Hot desk user cancels sign in
    [Tags]   316092     P3
    [Setup]  Testcase Setup for Meeting User    count=2
    Validate cancels Hot desking signin   device=device_1     hot_desk_account=device_2
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC15 : [Hot Desk] Hot Desk option should not available in menu for the user having hot desking policy disabled
    [Tags]   318586     P2
    [Setup]  Testcase Setup for HD disabled user   count=2
    Verify HD signin button for HD policy disable user   device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC16 : [Hot Desking] Check user warning message for Hot Desk time remaining.
    [Tags]   316073     P1   sanity_tpc
    [Setup]  Testcase Setup for Meeting User    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Wait for Some Time    time=${2_minutes_wait_time}
    Verify hotdesking automatic timeout warning    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1   AND    End hot desk    device=device_1


*** Keywords ***
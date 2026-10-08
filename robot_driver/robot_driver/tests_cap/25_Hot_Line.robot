*** Settings ***
Library     DateTime
Resource    ../resources/keywords/common.robot

Suite Teardown      Run Keywords    Suite Failure Capture

*** Variables ***

*** Test Cases ***
TC1 : Verify hotline option is present in the admin settings
     [Tags]   416679     P2
     [Setup]  Testcase Setup for CAP User     count=1
     verify hotline option       device=device_1
     come back to home screen from hotline page   device=device_1
     [Teardown]   Run Keywords    Capture on Failure    AND   come back to home screen    device_list=device_1

TC2 : Verify DUT user is able to enable the hotline option toggle under admin settings
     [Tags]   416682     P0     bvt_cap  sanity_cap
     [Setup]  Testcase Setup for CAP User     count=1
     verify hotline option       device=device_1
     verify hotline option is disabled by default      device=device_1
     come back to home screen from hotline page   device=device_1
     [Teardown]   Run Keywords    Capture on Failure   AND   come back to home screen    device_list=device_1

TC3 : Verify DUT user is able to add Contact and display name before enabling hotline for the first time.
     [Tags]     416684   P0     bvt_cap  sanity_cap
     [Setup]  Testcase Setup for CAP User     count=2
     verify hotline option       device=device_1
     verify hotline option is disabled by default      device=device_1
     configure contact number in hotline     device=device_1       configured_user=device_2
     verify hotline homescreen UI    device=device_1
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2   AND  Disable Hotline    device=device_1

TC4 : Verify DUT home screen after adding the contact and display name
     [Tags]   416686     P1  sanity_cap
     [Setup]  Testcase Setup for CAP User     count=2
     verify hotline option       device=device_1
     verify hotline option is disabled by default      device=device_1
     configure contact number in hotline     device=device_1       configured_user=device_2
     verify hotline homescreen UI    device=device_1
     verify hotline toggle status for cap    device=device_1    toogle_status=Enabled
     come back to home screen from hotline page   device=device_1
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2    AND  Disable Hotline    device=device_1

TC5 : Verify DUT user is able to edit contact and display name after enabling hotline.
     [Tags]   416689     P1  sanity_cap
     [Setup]  Testcase Setup for CAP User     count=3
     verify hotline option       device=device_1
     verify hotline option is disabled by default      device=device_1
     configure contact number in hotline     device=device_1       configured_user=device_2
     verify hotline homescreen UI    device=device_1
     verify hotline toggle status for cap    device=device_1    toogle_status=Enabled
     edit configured hotline contact details from hotline homescreen    device=device_1    edited_configured_user=device_3
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2,device_3    AND  Disable Hotline    device=device_1

TC6 : Verify that 911/933 is set as hotline configured number
     [Tags]   416713     P1
     [Setup]  Testcase Setup for CAP User     count=1
     verify hotline option       device=device_1
     verify hotline option is disabled by default      device=device_1
     configure emergency number in hotline      device=device_1
     verify hotline homescreen UI    device=device_1
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1    AND   Disable Hotline    device=device_1

TC7 : Verify DUT user add invalid number as Hotline number.
     [Tags]   416729     P1
     [Setup]  Testcase Setup for CAP User     count=1
     verify hotline option       device=device_1
     verify hotline option is disabled by default      device=device_1
     configure invalid contact details in hotline        device=device_1
     verify hotline homescreen UI    device=device_1
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1    AND   Disable Hotline    device=device_1

TC8 : Verify DUT user is able to add contact and display name by disabling hotline.
     [Tags]    416728     P1
     [Setup]  Testcase Setup for CAP User     count=1
     verify hotline option       device=device_1
     verify hotline option is disabled by default      device=device_1
     configure emergency number in hotline      device=device_1
     verify hotline homescreen UI    device=device_1
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1    AND   Disable Hotline    device=device_1

TC9 : Verify app settings page after enabling hotline.
     [Tags]    416748    P1
     [Setup]  Testcase Setup for CAP User     count=2
     verify hotline option       device=device_1
     verify hotline option is disabled by default      device=device_1
     configure contact number in hotline     device=device_1       configured_user=device_2:pstn_user
     verify hotline homescreen UI    device=device_1
     navigate to settings page from hotline home screen   device=device_1
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2    AND   Disable Hotline    device=device_1

TC10 : Verify DUT user is not able to get the call from TDC user
     [Tags]     416722     P1    sanity_cap
     [Setup]  Testcase Setup for CAP User     count=2
     verify hotline option       device=device_1
     configure contact number in hotline     device=device_1       configured_user=device_2
     verify hotline homescreen UI    device=device_1
     click on calls tab     device=device_2
     Make outgoing call using display name   from_device=device_2     to_device=device_1:cap_search_enabled
     verify any incoming call disappeared    device=device_1
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2    AND   Disable Hotline    device=device_1

TC11 : Verify DUT user sign out from the current account and sign in with the same account
     [Tags]     416708     P1
     [Setup]  Testcase Setup for CAP User     count=2
     verify hotline option       device=device_1
     configure contact number in hotline     device=device_1       configured_user=device_2
     verify hotline homescreen UI    device=device_1
     Sign out method    device=device_1      hot_line=enabled
     Wait for Some Time    time=${wait_time}
     Sign in method      device=device_1      user=cap_search_enabled
     verify hotline homescreen UI    device=device_1
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2    AND   Disable Hotline    device=device_1

TC12 : Verify DUT user sign out from the current account
     [Tags]    416712    P2
     [Setup]   Testcase Setup for CAP User    count=2
     verify hotline option       device=device_1
     configure contact number in hotline     device=device_1       configured_user=device_2
     verify hotline homescreen UI    device=device_1
     Sign out method    device=device_1      hot_line=enabled
     Wait for Some Time    time=${wait_time}
     verify that sign in is successful   device_list=device_1     state=sign out
     sign in method     device=device_1    user=cap_search_enabled
     verify hotline homescreen UI    device=device_1
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2    AND   Disable Hotline    device=device_1

TC13 : Verify cancel while adding the contact and display name
     [Tags]    416685    P2
     [Setup]   Testcase Setup for CAP User    count=2
     verify hotline option       device=device_1
     verify cancel btn while adding contact number in hotline     device=device_1       configured_user=device_2
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1

TC14 : Verify Home Screen after edit Contact and display name
     [Tags]    416701    P2
     [Setup]  Testcase Setup for CAP User     count=3
     verify hotline option       device=device_1
     configure contact number in hotline     device=device_1       configured_user=device_2
     verify hotline homescreen UI    device=device_1
     verify hotline toggle status for cap    device=device_1    toogle_status=Enabled
     edit configured hotline contact details from hotline homescreen    device=device_1    edited_configured_user=device_3
     verify hotline homescreen UI    device=device_1
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1    AND  Disable Hotline    device=device_1

TC15 : Verify DUT user sign in with different user after hotline enabled.
     [Tags]    416732    P2
     [Setup]   Testcase Setup for CAP User    count=2
     verify hotline option       device=device_1
     configure contact number in hotline     device=device_1       configured_user=device_2
     verify hotline homescreen UI    device=device_1
     Sign out method    device=device_1      hot_line=enabled
     verify that sign in is successful   device_list=device_1     state=sign out
     sign in method     device=device_1
     Wait for Some Time    time=${wait_time}
     verify hotline homescreen UI    device=device_1     state=Disabled
     Sign out method    device=device_1
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_2    AND    Sign in method      device=device_1     user=cap_search_enabled   AND    Disable Hotline    device=device_1

TC16 : Verify DUT user add/edit the contact and display name under Hotline and select back button.
     [Tags]    416730    P2
     [Setup]   Testcase Setup for CAP User    count=2
     verify hotline option       device=device_1
     verify cancel btn while adding contact number in hotline     device=device_1       configured_user=device_2
     click back    device=device_1
     verify not saved user name in hotline while adding or editing     device=device_1       configured_user=device_2
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2
*** Keywords ***

Disable Hotline
       [Arguments]     ${device}
       disable hotline option from home screen      ${device}
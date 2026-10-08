*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot


Suite Teardown      Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : Verify hotline option is present in the admin settings
     [Tags]   416779   P2
     [Setup]  Testcase Setup for CAP Premium User    count=1
     verify hotline option       device=device_1
     come back to home screen from hotline page   device=device_1
     [Teardown]   Run Keywords    Capture on Failure    AND   come back to home screen    device_list=device_1

TC2 : Verify DUT user is able to enable the hotline option toggle under admin settings
     [Tags]   416780      BVT_CAPPremium     Sanity_CAPPremium
     [Setup]  Testcase Setup for CAP Premium User     count=1
     verify hotline option       device=device_1
     verify hotline option is disabled by default      device=device_1
     come back to home screen from hotline page   device=device_1
     [Teardown]   Run Keywords    Capture on Failure    AND   come back to home screen    device_list=device_1

TC3 : Verify DUT user is able to add Contact and display name before enabling hotline for the first time.
     [Tags]    416781     BVT_CAPPremium     Sanity_CAPPremium
     [Setup]   Testcase Setup for CAP Premium User     count=2
     verify hotline option       device=device_1
     verify hotline option is disabled by default      device=device_1
     configure contact number in hotline     device=device_1       configured_user=device_2
     verify hotline homescreen UI    device=device_1
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_2   AND  Disable Hotline    device=device_1

TC4 : Verify DUT home screen after adding the contact and display name
     [Tags]   416783     P1     Sanity_CAPPremium
     [Setup]   Testcase Setup for CAP Premium User     count=2
     set advance calling     device=device_1     status=ON
     verify hotline option       device=device_1
     verify hotline option is disabled by default      device=device_1
     configure contact number in hotline     device=device_1       configured_user=device_2
     verify hotline homescreen UI    device=device_1
     verify hotline toggle status for cap    device=device_1    toogle_status=Enabled
     come back to home screen from hotline page   device=device_1
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_2    AND  Disable Hotline    device=device_1

TC5 : Verify that 911/933 is set as hotline configured number
     [Tags]   416793     P1     Sanity_CAPPremium
     [Setup]   Testcase Setup for CAP Premium User     count=1
     set advance calling     device=device_1     status=ON
     verify hotline option       device=device_1
     verify hotline option is disabled by default      device=device_1
     configure emergency number in hotline      device=device_1
     verify hotline homescreen UI    device=device_1
     [Teardown]   Run Keywords    Capture on Failure    AND   Disable Hotline    device=device_1

TC6 : Verify DUT user add invalid number as Hotline number.
     [Tags]   416802     P1    Sanity_CAPPremium
     [Setup]  Testcase Setup for CAP Premium User     count=1
     set advance calling     device=device_1     status=ON
     verify hotline option       device=device_1
     verify hotline option is disabled by default      device=device_1
     configure invalid contact details in hotline        device=device_1
     verify hotline homescreen UI    device=device_1
     [Teardown]   Run Keywords    Capture on Failure    AND   Disable Hotline    device=device_1

TC7 : Verify Home Screen after edit Contact and display name
     [Tags]   416785     P2
     [Setup]  Testcase Setup for CAP Premium User     count=3
     set advance calling     device=device_1     status=ON
     verify hotline option       device=device_1
     verify hotline option is disabled by default      device=device_1
     configure contact number in hotline     device=device_1       configured_user=device_2
     verify hotline homescreen UI    device=device_1
     verify hotline toggle status for cap    device=device_1    toogle_status=Enabled
     edit configured hotline contact details from hotline homescreen    device=device_1    edited_configured_user=device_3
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2,device_3    AND  Disable Hotline    device=device_1

TC8 : Verify DUT user is able to add contact and display name by disabling hotline.
     [Tags]   416801     P1    Sanity_CAPPremium
     [Setup]  Testcase Setup for CAP Premium User     count=1
     set advance calling     device=device_1     status=ON
     verify hotline option       device=device_1
     verify hotline option is disabled by default      device=device_1
     configure emergency number in hotline      device=device_1
     verify hotline homescreen UI    device=device_1
     [Teardown]   Run Keywords    Capture on Failure    AND   Disable Hotline    device=device_1

TC9 : Verify settings page after enabling hotline.
     [Tags]   416811    P1    Sanity_CAPPremium
     [Setup]  Testcase Setup for CAP Premium User     count=2
     set advance calling     device=device_1     status=ON
     verify hotline option       device=device_1
     verify hotline option is disabled by default      device=device_1
     configure contact number in hotline     device=device_1       configured_user=device_2:pstn_user
     verify hotline homescreen UI    device=device_1
     navigate to settings page from hotline home screen   device=device_1
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2    AND   Disable Hotline    device=device_1

TC10 : Verify DUT user is not able to get the call from TDC user
     [Tags]     416797     P1    Sanity_CAPPremium
     [Setup]  Testcase Setup for CAP Premium User     count=2
     set advance calling     device=device_1     status=ON
     verify hotline option       device=device_1
     configure contact number in hotline     device=device_1       configured_user=device_2
     verify hotline homescreen UI    device=device_1
     click on calls tab    device=device_2
     Make outgoing call using display name   from_device=device_2     to_device=device_1:cap_search_enabled
     verify any incoming call disappeared    device=device_1
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2    AND   Disable Hotline    device=device_1

TC11 : Verify cancel while adding the contact and display name
     [Tags]    416782    P2
     [Setup]   Testcase Setup for CAP Premium User    count=2
     verify hotline option       device=device_1
     verify cancel btn while adding contact number in hotline     device=device_1       configured_user=device_2
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1

TC12 : Verify DUT user is able to edit contact and display name after enabling hotline.
     [Tags]   416784     P1    Sanity_CAPPremium
     [Setup]  Testcase Setup for CAP Premium User     count=3
     verify hotline option       device=device_1
     configure contact number in hotline     device=device_1       configured_user=device_2
     verify hotline homescreen UI    device=device_1
     edit configured hotline contact details from hotline homescreen    device=device_1    edited_configured_user=device_3
     verify hotline homescreen UI    device=device_1
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1    AND  Disable Hotline    device=device_1

TC13 : Verify DUT user sign out from the current account and sign in with the same account
     [Tags]     416791     P1
     [Setup]  Testcase Setup for CAP Premium User      count=2
     verify hotline option       device=device_1
     configure contact number in hotline     device=device_1       configured_user=device_2
     verify hotline homescreen UI    device=device_1
     Sign out method    device=device_1      hot_line=enabled
     Wait for Some Time    time=${wait_time}
     Sign in method      device=device_1      user=cap_search_enabled
     verify hotline homescreen UI    device=device_1
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2    AND   Disable Hotline    device=device_1

TC14 : Verify Advance calling option should be disabled after enabling the hotline option.
     [Tags]   423667    P2
     [Setup]   Testcase Setup for CAP Premium User    count=2
     verify hotline option       device=device_1
     configure contact number in hotline     device=device_1       configured_user=device_2
     verify hotline homescreen UI    device=device_1
     verify advance calling toggle status for cap      device=device_1      toggle=off
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2    AND    Disable Hotline    device=device_1

TC15 : Verify DUT user sign in with different user after hotline enabled.
     [Tags]    416804    P2
     [Setup]   Testcase Setup for CAP Premium User    count=2
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

TC16 : Verify After disabling hotline option in advance calling, DUT should navigate to cap UI.
     [Tags]    423668     P2
     [Setup]  Testcase Setup for CAP Premium User      count=2
     verify hotline option       device=device_1
     verify hotline option is disabled by default      device=device_1
     configure emergency number in hotline      device=device_1
     verify hotline homescreen UI    device=device_1
     Disable Hotline    device=device_1
     Wait for Some Time    time=${wait_time}
     verify home screen UI for cap       device=device_1
     [Teardown]   Run Keywords    Capture on Failure   AND   come back to home screen    device_list=device_1

*** Keywords ***
Disable Hotline
       [Arguments]     ${device}
       disable hotline option from home screen      ${device}
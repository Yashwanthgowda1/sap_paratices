*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***

TC1:[Teams Shared Devices License] [Sign-in] Sign into DUT with invalid user
    [Tags]  341982
    [Setup]  run keywords    Testcase Setup for CAP User for panel  count=1   AND   sign out method  device=device_1
    verify signin with invalid user  device=device_1
    Device setting back till signin btn visible     device=device_1
    Sign in method     device=device_1      user=cap_user
    [Teardown]  Run Keywords    Capture on Failure

TC2:[Teams Shared Devices License] [Sign-in] Sign-in to DUT with wrong Password
    [Tags]  341983   sanity     bvt_panels_pr
    [Setup]  run keywords    Testcase Setup for CAP User for panel  count=1   AND   sign out method  device=device_1
    verify signin with wrong password  device=device_1
    Device setting back till signin btn visible     device=device_1
    Sign in method     device=device_1      user=cap_user
    [Teardown]  Run Keywords    Capture on Failure

TC3:[Teams Shared Devices License] [Sign-in] Sign-in attempt in DUT with invalid domain name
    [Tags]  341985
    [Setup]  run keywords    Testcase Setup for CAP User for panel  count=1  AND   sign out method  device=device_1
    verify signin with invalid domain  device=device_1
    Device setting back till signin btn visible     device=device_1
    Sign in method     device=device_1      user=cap_user
    [Teardown]  Run Keywords    Capture on Failure

TC4:[Teams Shared Devices License] [Sign-in] User with Intune license can sign-in to DUT
    [Tags]  341996   bvt   sanity	 bvt_panels     bvt_panels_pr
    [Setup]  Testcase Setup for CAP User for panel  count=1
    verify room parameters     device=device_1:cap_user
    [Teardown]  Capture on Failure

TC5:[Teams Shared Devices License][Sign in] UI verification after sign in
    [Tags]  341997   sanity     bvt_panels_pr
    [Setup]  Testcase Setup for CAP User for panel  count=1
    Verify homescreen on panel      device=device_1:cap_user
    [Teardown]  Capture on Failure

TC6:[Teams Shared Devices License] [Sign-in] User to sign-out from existing account and sign-in with a different account
    [Tags]  341998   bvt    sanity	 bvt_panels     bvt_panels_pr
    [Setup]  Testcase Setup for CAP User for panel  count=1
    Verify homescreen on panel      device=device_1:cap_user
    Signin with other user    device=device_1   other_user_account=device_1:cap_user
    [Teardown]  Run Keywords    Capture on Failure     AND   sign out method  device=device_1    AND     sign in method     device_1    user=cap_user

TC7:[Teams Shared Devices License] [Sign-in] User to be signed in to DUT within a specified time limit
    [Tags]  341999
    [Setup]  Testcase Setup for CAP User for panel  count=1
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    sign in method  device_1    user=cap_user
    Verify homescreen on panel      device=device_1:cap_user
    [Teardown]  Capture on Failure

TC8:[Teams Shared Devices License] [Sign-in] User to re-sign-in multiple times to with same user
    [Tags]  342004
    [Setup]  Testcase Setup for CAP User for panel  count=1
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    Sign in method     device=device_1      user=cap_user
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    Sign in method     device=device_1      user=cap_user
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    Sign in method     device=device_1      user=cap_user
    Verify homescreen on panel      device=device_1:cap_user
    [Teardown]  Capture on Failure

TC9:[Teams Shared Devices License] [Sign in] User is signed into the DUT, the application will broadcast an intent
    [Tags]  342010
    [Setup]  Testcase Setup for CAP User for panel  count=1
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    Reset Logcat Capture    device=device_1
    Sign in method     device=device_1      user=cap_user
    Verify Intents      device=device_1     intent=sign_in     user=cap_user
    [Teardown]  Capture on Failure

TC10:[Cap license sign in] Verify the DUT user should be able to sign in with CAP account
    [Tags]  344675   bvt   sanity	 bvt_panels     bvt_panels_pr
    [Setup]  Testcase Setup for CAP User for panel  count=1
    verify room parameters    device=device_1:cap_user
    [Teardown]  Capture on Failure
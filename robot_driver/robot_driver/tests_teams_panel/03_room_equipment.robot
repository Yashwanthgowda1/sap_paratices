*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***
${display_time} =  5

*** Test Cases ***
TC1:[Room Equipment] Verify Show Room Equipment toggle is displayed on “Settings".
    [Tags]  316434   bvt   sanity	 bvt_panels     bvt_panels_pr
    [Setup]  Testcase Setup   count=1
    navigate to meetings option in panel app settings      device=device_1
    Verify room equipment toggle in panel is off    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2:[Room Equipment] Verify Show Room Equipment toggle is turned Off by default.
    [Tags]  321944   bvt   sanity	 bvt_panels     bvt_panels_pr
    [Setup]  Testcase Setup   count=1
    navigate to meetings option in panel app settings      device=device_1
    Verify room equipment toggle in panel is off    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3:[Room Equipment] Verify when Show Room Equipment toggle is turned OFF than Room equipment app should not display on Home screen or on more apps
    [Tags]  316435  321946   bvt   sanity	 bvt_panels     bvt_panels_pr
    [Setup]  Testcase Setup   count=1
    navigate to meetings option in panel app settings      device=device_1
    Verify room equipment toggle in panel is off    device=device_1
    go back to homescreen from admin settings options   device=device_1
    verify room equipment app from homescreen     device=device_1   presence_status=absent
    navigate to meetings option in panel app settings      device=device_1
    enable or disable room equipment toggle in panel      device=device_1       activity_state=on
    go back to homescreen from admin settings options   device=device_1
    verify room equipment app from homescreen     device=device_1   presence_status=present
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC4:[See Room Equipment] Verify that user should be able to turn ON/OFF the toggle
    [Tags]  321292
    [Setup]  Testcase Setup   count=1
    Run Keywords        navigate to meetings option in panel app settings      device=device_1      AND       enable or disable room equipment toggle in panel      device=device_1       activity_state=off       AND     go back to homescreen from admin settings options   device=device_1
    navigate to meetings option in panel app settings      device=device_1
    Verify room equipment toggle in panel is off    device=device_1
    enable or disable room equipment toggle in panel      device=device_1       activity_state=on
    [Teardown]  Run Keywords    Capture on Failure   AND     enable or disable room equipment toggle in panel      device=device_1       activity_state=off     AND    go back to homescreen from admin settings options    device=device_1

TC5:[Room Equipment] Verify when DUT tap on Room equipment app icon from Homescreen than user should navigate to Room Equipment screen.
    [Tags]  321952
    [Setup]  Testcase Setup   count=1
    navigate to meetings option in panel app settings      device=device_1
    enable or disable room equipment toggle in panel      device=device_1       activity_state=on
    go back to homescreen from admin settings options   device=device_1
    verify room equipment app from homescreen     device=device_1   presence_status=present
    navigate inside room equipment app      device=device_1
    verify home page of room equipment app      device=device_1
    [Teardown]  Run Keywords    Capture on Failure      AND    navigate back to home screen from app      device=device_1       AND     disable room equipment toggle    device=device_1

TC6:[Room Equipment] Verify on Room Equipment screen heading with Home action icon, DUT username & current time.
    [Tags]  321963      321966
    [Setup]  Testcase Setup   count=1
    navigate to meetings option in panel app settings      device=device_1
    Verify room equipment toggle in panel is off    device=device_1
    go back to homescreen from admin settings options   device=device_1
    verify room equipment app from homescreen     device=device_1   presence_status=absent
    navigate to meetings option in panel app settings      device=device_1
    enable or disable room equipment toggle in panel      device=device_1       activity_state=on
    go back to homescreen from admin settings options   device=device_1
    verify room equipment app from homescreen     device=device_1   presence_status=present
    navigate inside room equipment app      device=device_1
    navigate back to home screen from app      device=device_1
    [Teardown]  Run Keywords    Capture on Failure      AND    navigate back to home screen from app      device=device_1       AND     disable room equipment toggle    device=device_1

*** Keywords ***

navigate to meetings option in panel app settings
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    go to meetings tab in panel     device=device_1

disable room equipment toggle
    [Arguments]     ${device}
    verify room parameters    device=device_1
    Refresh calls main tab  device=device_1
    navigate to meetings option in panel app settings      device=device_1
    enable or disable room equipment toggle in panel      device=device_1       activity_state=off
    go back to homescreen from admin settings options   device=device_1
    verify room equipment app from homescreen     device=device_1   presence_status=absent
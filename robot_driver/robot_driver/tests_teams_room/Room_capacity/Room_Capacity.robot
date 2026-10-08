*** Settings ***
Documentation   Ensure Panels should be in config as device-4.
Resource    resources/keywords/common.robot
*** Variables ***

*** Test Cases ***
TC1:[Room Capacity] Norden DUT to have Max room occupancy notification in Meetings
    [Tags]      303854      P1    sanity_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Click on more option   device=device_1
    Click on settings page   device=device_1
    navigate to meetings option in device settings page      device=device_1
    verify presence of max room capacity toggle button in panel      device=device_1    presence_status=present
    verify max room capacity toggle in panel is on     device=device_1
    Come back from admin settings page    device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure    AND  Come back from admin settings page    device_list=device_1

TC2:[Room Capacity] Norden DUT to have Max room occupancy notification enabled/disabled in Meetings
    [Tags]      303860      P2    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Click on more option   device=device_1
    Click on settings page   device=device_1
    navigate to meetings option in device settings page      device=device_1
    verify presence of max room capacity toggle button in panel      device=device_1    presence_status=present
    verify max room capacity toggle in panel is on     device=device_1
    verify Max room occupancy notification toggle in Meetings       device=device_1
    Come back from admin settings page    device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure    AND  Come back from admin settings page    device_list=device_1

TC3:[Room Capacity] Panel DUT to have Max. room occupancy notification disabled by default
    [Tags]        303862    P2    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User with panel      count=1
    navigate to meetings option in panel app settings    device=device_4
    verify presence of max room capacity toggle button in panel      device=device_4    presence_status=present
    verify max room capacity toggle in panel is off     device=device_4
    go back to homescreen from admin settings options   device=device_4
    [Teardown]  Run Keywords    Capture on Failure    AND     go back to homescreen from admin settings options   device=device_4

TC4:[Room Capacity] Panel DUT to have Max room occupancy notification in Meetings in paired state
    [Tags]   303859    P2    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User with panel      count=1
    navigate to meetings option in panel app settings    device=device_4
    verify presence of max room capacity toggle button in panel      device=device_4    presence_status=present
    enable or disable max room capacity toggle button in panel      device=device_4       activity_status=on
    go back to homescreen from admin settings options   device=device_4
    [Teardown]  Run Keywords    Capture on Failure    AND     go back to homescreen from admin settings options   device=device_4

TC5:[Room Capacity] Validate that user should be able to turn ON/OFF the "Max. room occupancy notification" settings from Panels app settings
    [Tags]   316651    P2    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User with panel      count=1
    navigate to meetings option in panel app settings    device=device_4
    verify presence of max room capacity toggle button in panel      device=device_4    presence_status=present
    enable or disable max room capacity toggle button in panel      device=device_4       activity_status=on
    go back to homescreen from admin settings options   device=device_4
    Reset device pairing
    navigate to meetings option in panel app settings    device=device_4
    verify presence of max room capacity toggle button in panel      device=device_4    presence_status=absent
    go back to homescreen from admin settings options   device=device_4
    [Teardown]  Run Keywords    Capture on Failure   AND    Pair Panel and Rooms device  AND     go back to homescreen from admin settings options   device=device_4

TC6:[Room Capacity] Panel DUT to have Max room occupancy notification disabled in Meetings after re-pair
    [Tags]   303853     P2    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User with panel      count=1
    navigate to meetings option in panel app settings    device=device_4
    verify presence of max room capacity toggle button in panel      device=device_4    presence_status=present
    enable or disable max room capacity toggle button in panel      device=device_4       activity_status=off
    go back to homescreen from admin settings options   device=device_4
    Reset device pairing
    Pair Panel and Rooms device
    navigate to meetings option in panel app settings    device=device_4
    verify presence of max room capacity toggle button in panel      device=device_4    presence_status=present
    verify max room capacity toggle in panel is off      device=device_4
    go back to homescreen from admin settings options   device=device_4
    [Teardown]  Run Keywords    Capture on Failure    AND     go back to homescreen from admin settings options   device=device_4

TC7:[Room Capacity] Panel DUT to have Max room occupancy notification enabled in Meetings after re-pair
    [Tags]   303856     P2    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User with panel      count=1
    navigate to meetings option in panel app settings    device=device_4
    verify presence of max room capacity toggle button in panel      device=device_4    presence_status=present
    enable or disable max room capacity toggle button in panel      device=device_4       activity_status=on
    go back to homescreen from admin settings options   device=device_4
    Reset device pairing
    Pair Panel and Rooms device
    navigate to meetings option in panel app settings    device=device_4
    verify presence of max room capacity toggle button in panel      device=device_4    presence_status=present
    verify max room capacity toggle in panel is on     device=device_4
    go back to homescreen from admin settings options   device=device_4
    [Teardown]  Run Keywords    Capture on Failure    AND     go back to homescreen from admin settings options   device=device_4

*** Keywords ***
navigate to meetings option in panel app settings
    [Arguments]     ${device}
    Navigation to settings page in panel  device=${device}
    verify device settings option in panel  device=${device}
    verify device settings option in panel  device=${device}
    navigate inside of teams admin settings in panel    device=${device}
    go to meetings tab in panel     device=${device}

Reset device pairing
    navigate to device pairing option in panel app settigs  device=device_4     pair_status=paired
    reset device pairing in panel  device=device_4
    go back to homescreen from admin settings options       device=device_4

Pair Panel and Rooms device
    navigate to device pairing option in panel app settigs   device=device_4    pair_status=unpaired
    select rooms device to pair from panel   from_device=device_4    to_device=device_1
    get pairing code from rooms device    from_device1=device_1  to_device1=device_4
    go back to homescreen from admin settings options       device=device_4

navigate to device pairing option in panel app settigs
    [Arguments]     ${device}   ${pair_status}
    Navigation to settings page in panel  device=${device}
    verify device settings option in panel  device=${device}
    navigate inside of teams admin settings in panel    device=${device}
    navigate to device pairing tab on panel     device=${device}     pair_status=${pair_status}

verify Max room occupancy notification toggle in Meetings
    [Arguments]     ${device}
    enable and disable the max room occupancy notification toggle button      ${device}   state=off
    enable and disable the max room occupancy notification toggle button  ${device}   state=on

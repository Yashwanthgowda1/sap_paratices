*** Settings ***
Resource    ../resources/keywords/common.robot
Force Tags      exclude_pairing
Suite Teardown  Run Keywords    Suite Failure Capture

*** Test Cases ***
TC1:[Room Capacity] Panel DUT not to have Max room occupancy notification in Meetings in unpaired state
    [Tags]  321945
    [Setup]  Testcase Setup  count=2
    navigate to meetings option in panel app settings    device=device_1
    verifying all options in panel admin app settings     device=device_1
    verify presence of max room capacity toggle button in panel      device=device_1    presence_status=absent
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2:[Room Capacity] Panel DUT to have Max room occupancy notification in Meetings in paired state
    [Tags]  321947
    [Setup]  Teams Panel along with Rooms Setup
    navigate to meetings option in panel app settings    device=device_1
    verifying all options in panel admin app settings     device=device_1
    verify presence of max room capacity toggle button in panel      device=device_1    presence_status=present
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2      AND   Reset device pairing

TC3:[Room Capacity] Panel DUT to have Max. room occupancy notification disabled by default
    [Tags]  321950
    [Setup]  Teams Panel along with Rooms Setup
    navigate to meetings option in panel app settings    device=device_1
    verifying all options in panel admin app settings     device=device_1
    verify presence of max room capacity toggle button in panel      device=device_1    presence_status=present
    verify max room capacity toggle in panel is off     device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2    AND    Reset device pairing

TC4:[Room Capacity] Panel DUT to have Max room occupancy notification enabled in Meetings after re-pair
    [Tags]  321994
    [Setup]  Teams Panel along with Rooms Setup
    navigate to meetings option in panel app settings    device=device_1
    verifying all options in panel admin app settings     device=device_1
    verify presence of max room capacity toggle button in panel      device=device_1    presence_status=present
    enable or disable max room capacity toggle button in panel      device=device_1       activity_status=on
    go back to homescreen from admin settings options   device=device_1
    Reset device pairing
    Pair Panel and Rooms device
    Come back to home screen    device_list=device_1
    navigate to meetings option in panel app settings    device=device_1
    verifying all options in panel admin app settings     device=device_1
    verify presence of max room capacity toggle button in panel      device=device_1    presence_status=present
    verify max room capacity toggle in panel is on        device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2    AND    Reset device pairing

TC5:[Room Occupancy Warning] Verify "Max. room occupancy notification" settings from Panels app settings
    [Tags]  322049
    [Setup]  Teams Panel along with Rooms Setup
    navigate to meetings option in panel app settings    device=device_1
    verify presence of max room capacity toggle button in panel      device=device_1    presence_status=present
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2    AND    Reset device pairing

*** Keywords ***

Teams Panel along with Rooms Setup
    Testcase Setup  count=2
    Pair Panel and Rooms device
    Come back to home screen    device_list=device_1

Pair Panel and Rooms device
    navigate to meetings option in panel app settings   device=device_1  
    select rooms device to pair from panel   from_device=device_1    to_device=device_2
    get pairing code from rooms device    from_device1=device_2  to_device1=device_1

navigate to device pairing option in panel app settings
    [Arguments]     ${device}   ${pair_status}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    navigate to device pairing tab on panel     device=device_1     pair_status=${pair_status}

navigate to meetings option in panel app settings
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    go to meetings tab in panel     device=device_1

Reset device pairing
    navigate to device pairing option in panel app settings  device=device_1     pair_status=paired
    reset device pairing in panel  device=device_1
    go back to homescreen from admin settings options       device=device_1
*** Settings ***
Documentation   Ensure Panels should be in config as device-4.
Resource    resources/keywords/common.robot

*** Variables ***

*** Test Cases ***
TC1:[Room Capacity] Norden DUT to have Max room occupancy notification in Meetings When paired Norden with TC
    [Tags]        348351    P1    sanity_tc_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for Shared User with panel      count=1
    Tap on more option  console=console_1
    Verify more options     console=console_1
    Tap on settings page   console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1      option=meeting
    verify presence of max room capacity toggle button in panel      device=console_1    presence_status=present
    enable or disable max room capacity toggle button in panel      device=console_1       activity_status=off
    come back from admin settings page      device_list=console_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_4,device_1

TC2:[Room Capacity] Norden DUT to have Max room occupancy notification enabled in Meetings when panel device paired with Norden+TC
    [Tags]        348356    P2   exclude_ftp_sm
    [Setup]  Testcase Setup for Shared User with panel      count=1
    Tap on more option  console=console_1
    Verify more options     console=console_1
    Tap on settings page   console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1      option=meeting
    verify presence of max room capacity toggle button in panel      device=console_1    presence_status=present
    verify max room capacity toggle in panel is on     device=console_1
    come back from admin settings page      device_list=console_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_4,device_1

TC3:[Room Capacity] Norden DUT to have Max room occupancy notification disabled in Meetings when Panel paired with Norden+TC
    [Tags]        348353    P2    exclude_ftp_sm
    [Setup]  Testcase Setup for Shared User with panel      count=1
    Tap on more option  console=console_1
    Verify more options     console=console_1
    Tap on settings page   console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1      option=meeting
    verify presence of max room capacity toggle button in panel      device=console_1    presence_status=present
    verify max room capacity toggle in panel is on     device=console_1
    enable or disable max room capacity toggle button in panel      device=console_1       activity_status=off
    come back from admin settings page      device_list=console_1
    [Teardown]  Run Keywords    Capture on Failure   AND    enable room capacity toggle    device=console_1     AND   Come back to home screen    device_list=device_4,device_1

TC4:[Room Capacity] Panel DUT to have Max. room occupancy notification disabled by default when paired with Norden+TC
    [Tags]        348358    P2    exclude_ftp_sm
    [Setup]  Testcase Setup for Shared User with panel      count=1
    navigate to meetings option in panel app settings    device=device_4
    verify presence of max room capacity toggle button in panel      device=device_4    presence_status=present
    verify max room capacity toggle in panel is off     device=device_4
    go back to homescreen from admin settings options   device=device_4
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_4,device_1

TC5:[Room Capacity] Panel DUT to have Max room occupancy notification in Meetings in paired state
    [Tags]        348355    P1    sanity_tc_sm        exclude_ftp_sm
    [Setup]  Testcase Setup for Shared User with panel      count=1
    navigate to meetings option in panel app settings    device=device_4
    verify presence of max room capacity toggle button in panel      device=device_4    presence_status=present
    enable or disable max room capacity toggle button in panel      device=device_4       activity_status=on
    go back to homescreen from admin settings options   device=device_4
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_4,device_1

TC6:[Room Capacity] Validate that user should be able to turn ON/OFF the "Max. room occupancy notification" settings from Panels app settings
    [Tags]        348364    P2    exclude_ftp_sm
    [Setup]  Testcase Setup for Shared User with panel      count=1
    navigate to meetings option in panel app settings    device=device_4
    verify presence of max room capacity toggle button in panel      device=device_4    presence_status=present
    enable or disable max room capacity toggle button in panel      device=device_4       activity_status=on
    go back to homescreen from admin settings options   device=device_4
    Reset device pairing
    navigate to meetings option in panel app settings    device=device_4
    verify presence of max room capacity toggle button in panel      device=device_4    presence_status=absent
    go back to homescreen from admin settings options   device=device_4
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_4,device_1    AND    Pair Panel and Rooms device

TC7:[Room Capacity] Panel DUT to have Max room occupancy notification enabled in Meetings after re-pair with Norden+TC
    [Tags]     348352    P2    exclude_ftp_sm
    [Setup]  Testcase Setup for Shared User with panel      count=1
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
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_4,device_1

TC8:[Room Capacity] Panel DUT to have Max room occupancy notification disabled in Meetings after re-pair with Norden+TC
    [Tags]     348350    P2    exclude_ftp_sm
    [Setup]  Testcase Setup for Shared User with panel      count=1
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
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_4,device_1

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
    Come back to home screen    device_list=device_4

navigate to device pairing option in panel app settigs
    [Arguments]     ${device}   ${pair_status}
    Navigation to settings page in panel  device=${device}
    verify device settings option in panel  device=${device}
    navigate inside of teams admin settings in panel    device=${device}
    navigate to device pairing tab on panel     device=${device}     pair_status=${pair_status}

enable room capacity toggle
    [Arguments]     ${device}
    Tap on more option  console=${device}
    Verify more options     console=${device}
    Tap on settings page   console=${device}
    Navigate to meeting and calling options from device settings page       console=${device}      option=meeting
    enable or disable max room capacity toggle button in panel      device=${device}       activity_status=on
    come back from admin settings page      device_list=${device}

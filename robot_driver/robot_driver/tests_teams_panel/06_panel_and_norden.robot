*** Settings ***
Resource    ../resources/keywords/common.robot
Force Tags     exclude_pairing
Suite Setup    Teams Panel along with Rooms Setup
Suite Teardown   Run Keywords        Suite Failure Capture      AND      Reset device pairing

*** Test Cases ***
TC1:[Private meetings] User to Reserve when "Show meeting names" toggle is turned off on the device and Collab bar
    [Tags]  307969   bvt   sanity	 bvt_panels     bvt_panels_pr
    [Setup]  Testcase Setup   count=2
    navigate to meetings option in panel app settings    device=device_1
    enable or disable show meeting name toggle in panel          device=device_1      show_meeting_state=off
    go back to homescreen from admin settings options   device=device_1
    verify room parameters    device=device_1
    validate room availability status   device=device_1   status=available
    check details on scheduling screen  device=device_1
    reserve room    device=device_1
    navigate to meetings option in panel app settings    device=device_1
    verifying meeting name based on show meeting name status     device=device_1     toggle=off
    Modify show meeting names option in norden and check meeting name    device=device_2     toggle=on
    Modify show meeting names option     device=device_2   state=off
    Modify show meeting names option in norden and check meeting name     device=device_2     toggle=off
    cancel the current reserved meeting and disable show meeting name toggle     device=device_1
    [Teardown]  Run Keywords    Capture on Failure      AND     cancel the current reserved meeting and disable show meeting name toggle     device=device_1       AND      Come back to home screen    device_list=device_1

*** Keywords ***

Teams Panel along with Rooms Setup
    Testcase Setup  count=2
    Pair Panel and Rooms device
    Come back to home screen    device_list=device_1

Pair Panel and Rooms device
    navigate to device pairing option in panel app settings   device=device_1    pair_status=unpaired
    select rooms device to pair from panel   from_device=device_1    to_device=device_2
    get pairing code from rooms device    from_device1=device_2  to_device1=device_1

navigate to device pairing option in panel app settings
    [Arguments]     ${device}    ${pair_status}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    navigate to device pairing tab on panel     device=device_1      pair_status=${pair_status}

navigate to meetings option in panel app settings
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    go to meetings tab in panel     device=device_1

cancel the current reserved meeting and disable show meeting name toggle
    [Arguments]     ${device}
    navigate to meetings option in panel app settings       device=device_1
    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=on
    enable or disable show meeting name toggle in panel          device=device_1      show_meeting_state=on
    Come back to home screen    device_list=device_1
    checkout of the reserved meeting   device=device_1
    navigate to meetings option in panel app settings       device=device_1
    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=off
    go back to homescreen from admin settings options   device=device_1
    Refresh calls main tab  device=device_1
    validate room availability status   device=device_1   status=available

Navigate to app settings page
    [Arguments]     ${device}
    Click on more option   ${device}
    Click on settings page   ${device}

Modify show meeting names option
    [Arguments]       ${device}   ${state}
    Navigate to app settings page  ${device}
    navigate to meetings option in device settings page    ${device}
    hide or unhide meeting names    ${device}   ${state}
    come back to home screen  device_list=${device}

Modify show meeting names option in norden and check meeting name
    [Arguments]       ${device}   ${toggle}
    Navigate to app settings page  ${device}
    navigate to meetings option in device settings page    ${device}
    verifying meeting name based on show meeting name status for norden     ${device}   ${toggle}

Reset device pairing
    navigate to device pairing option in panel app settings  device=device_1     pair_status=paired
    reset device pairing in panel  device=device_1
*** Settings ***
Resource    ../resources/keywords/common.robot
Force Tags      exclude_pairing
Suite Teardown  Run Keywords    Suite Failure Capture

*** Test Cases ***
TC1:[Knock-knock] Verify check-in option when device is in unpaired state
    [Tags]  307997
    [Setup]  Teams Panel along with Rooms Setup without pairing
    Verify homescreen on panel   device=device_1
    verify presence of check in button on homescreen     device=device_1    presence_status=absent
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2:[Knock Knock] Verify the error message when invalid code is entered in the panels to pair
    [Tags]  308000
    [Setup]  Testcase Setup   count=2
    navigate to device pairing option in panel app settings   device=device_1    pair_status=unpaired
    select rooms device to pair from panel   from_device=device_1    to_device=device_2
    pass incorrect pairing code to panel    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3:[Knock Knock] Verify click on Back button on Search page navigates to Device Pairing screen
    [Tags]  322054
    [Setup]  Testcase Setup   count=2
    Cancel pairing of Panel and Rooms device
    navigate to device pairing tab on panel     device=device_1     pair_status=unpaired
    select rooms device to pair from panel   from_device=device_1    to_device=device_2
    get pairing code from rooms device    from_device1=device_2  to_device1=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND     Reset device pairing

TC4:[Pairing] Verify DUT signed in with CAP account should not be paired with any collab bar
    [Tags]  342059
    [Setup]  Testcase Setup  count=2
    Signin with other user    device=device_1   other_user_account=device_1:cap_user
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    navigate to device pairing page on panel       device=device_1
    verifying no device is available for pairing    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***

Teams Panel along with Rooms Setup without pairing
    Testcase Setup  count=2
    Cancel pairing of Panel and Rooms device
    Come back to home screen    device_list=device_1

Cancel pairing of Panel and Rooms device
    navigate to device pairing option in panel app settings   device=device_1    pair_status=unpaired
    select rooms device to pair from panel   from_device=device_1    to_device=device_2
    cancel device pairing process in panel  device=device_1

navigate to device pairing option in panel app settings
    [Arguments]     ${device}   ${pair_status}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    navigate to device pairing tab on panel     device=device_1        pair_status=${pair_status}

Reset device pairing
    navigate to device pairing option in panel app settings  device=device_1     pair_status=paired
    reset device pairing in panel  device=device_1
*** Settings ***
Resource    resources/keywords/common.robot
Suite Setup     run keywords  verify device is panel   AND  Teams Console Setup For Shared Mode     AND    Panels Suite Setup with Console

*** Keywords ***
verify device is panel
    is panel    device=device_4

Panels Suite Setup with Console
   Sign in method     device=device_4     user=meeting_user
   Teams Panel along with Rooms Setup

Teams Panel along with Rooms Setup
    Pair Panel and Rooms device
    Come back to home screen    device_list=device_4

Pair Panel and Rooms device
    navigate to device pairing option in panel app settigs   device=device_4    pair_status=unpaired
    select rooms device to pair from panel   from_device=device_4    to_device=device_1
    get pairing code from rooms device    from_device1=device_1  to_device1=device_4

navigate to device pairing option in panel app settigs
    [Arguments]     ${device}   ${pair_status}
    Navigation to settings page in panel  device=${device}
    verify device settings option in panel  device=${device}
    navigate inside of teams admin settings in panel    device=${device}
    navigate to device pairing tab on panel     device=${device}     pair_status=${pair_status}
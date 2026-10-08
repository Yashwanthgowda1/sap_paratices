*** Settings ***
Documentation   Ensure Panels should be in config as device-4.
Resource    resources/keywords/common.robot
Suite Setup     run keywords    verify device is panel   AND     Panels Setup with Norden      AND    Panel pair with Norden

*** Variables ***
${panel}    device_4

*** Keywords ***
verify device is panel
    is panel    device=${panel}
    
Panels Setup with Norden
   Setup Devices   device_list=${panel}
   Sign In     device_list=device_1:meeting_user,${panel}:meeting_user

Panel pair with Norden
    Pair Panel and Rooms device
    go back to homescreen from admin settings options   device=${panel}

Pair Panel and Rooms device
    navigate to device pairing option in panel app settigs   device=${panel}    pair_status=unpaired
    select rooms device to pair from panel   from_device=${panel}    to_device=device_1
    get pairing code from rooms device    from_device1=device_1  to_device1=${panel}

navigate to device pairing option in panel app settigs
    [Arguments]     ${device}   ${pair_status}
    Navigation to settings page in panel  device=${device}
    verify device settings option in panel  device=${device}
    navigate inside of teams admin settings in panel    device=${device}
    navigate to device pairing tab on panel     device=${device}     pair_status=${pair_status}
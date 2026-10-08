*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***
# Temprorily commenting this test case because Nearby Rooms app is not appearing on panel R0 accounts
#TC1: [Extensibility]Time format should appear correct at Extensibility app screen according to setting set in time and date settings
#    [Tags]  322140
#    [Setup]  Testcase Setup   count=1
#    Verify homescreen on panel   device=device_1
#    go inside nearby app and validate time format as 12hr       device=device_1
#    Navigate and modify time format to 24hr in panel admin settings      device=device_1
#    go inside nearby app and validate time format as 24hr       device=device_1
#    [Teardown]  Run Keywords    Capture on Failure      AND      Navigate and modify time format to 12hr in panel admin settings      device=device_1    AND    go inside nearby app and validate time format as 12hr       device=device_1

*** Keywords ***

Navigate and modify time format to 24hr in panel admin settings
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    Navigate and change time and date in admin settings for panel   device=device_1   time_format=24hr
    Come back to home screen    device_list=device_1

Navigate and modify time format to 12hr in panel admin settings
    [Arguments]     ${device}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    Navigate and change time and date in admin settings for panel     device=device_1     time_format=12hr
    Come back to home screen    device_list=device_1

go inside nearby app and validate time format as 12hr
    [Arguments]     ${device}
    verify nearby rooms app on panel homescreen      device=device_1
    navigate inside nearby rooms app      device=device_1
    fetch and validate time format inside or outside app       device=device_1     time_format=12hr     app_state=inside

go inside nearby app and validate time format as 24hr
    [Arguments]     ${device}
    verify nearby rooms app on panel homescreen      device=device_1
    navigate inside nearby rooms app      device=device_1
    fetch and validate time format inside or outside app       device=device_1     time_format=24hr     app_state=inside
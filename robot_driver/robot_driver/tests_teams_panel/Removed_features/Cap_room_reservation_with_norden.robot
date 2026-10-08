#*** Settings ***
#Resource    ../resources/keywords/common.robot
#
#Suite Teardown  Suite Failure Capture
#
#*** Test Cases ***
#TC1: [Teams Shared Devices License] [Checkout and extend reservation] Verify Panel user should be able to see the “Manage” option, in the current ongoing meeting.
#     [Tags]   342040
#     [Setup]  Testcase Setup for CAP User for panel   count=2
#     verify room parameters    device=device_1:cap_user
#     validate room availability status   device=device_1   status=available
#     check details on scheduling screen  device=device_1:cap_user
#     reserve room    device=device_1:cap_user
#     validate room availability status   device=device_1   status=reserved
#     refresh meeting visibility for norden device     device=device_2
#     Verify meeting display on home screen     device=device_2
#     join rooms meeting   device=device_2    meeting=Reserved
#     Verify meeting state   device_list=device_2    state=Connected
#     navigate to meetings option in panel app settigs       device=device_1
#     enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=on
#     enable or disable extend room reservation toggle btn in panel      device=device_1       extend_rr_state=on
#     go back to homescreen from admin settings options       device=device_1
#     verify manage button on homescreen   device=device_1
#     verify presence of check in button on homescreen   device=device_1           presence_status=absent
#    [Teardown]  Run Keywords    Capture on Failure   AND    End meeting   device=device_2    AND   cancel the current reserved meeting   device=device_1
#
#TC7: [Teams Shared Devices License] [Checkout and extend reservation] Verify “Checkout” option in the panel is disabled if the MTRA is in a meeting.
#     [Tags]   342042
#     [Setup]  Testcase Setup for CAP User for panel   count=2
#     verify room parameters    device=device_1:cap_user
#     validate room availability status   device=device_1   status=available
#     check details on scheduling screen  device=device_1:cap_user
#     reserve room    device=device_1:cap_user
#     validate room availability status   device=device_1   status=reserved
#     refresh meeting visibility for norden device     device=device_2
#     Verify meeting display on home screen     device=device_2
#     join rooms meeting   device=device_2    meeting=Reserved
#     Verify meeting state   device_list=device_2    state=Connected
#     Enable check out and extend room reservation toggles   device=device_1
#     verify state of extend room reservation or check out option on homescreen      device=device_1      option=check_out       state=disabled
#    [Teardown]  Run Keywords    Capture on Failure  AND     End meeting   device=device_2   AND     Verify meeting state    device_list=device_2   state=Disconnected    AND   cancel the current reserved meeting   device=device_1
#
#*** Keywords ***
#navigate to meetings option in panel app settigs
#    [Arguments]     ${device}
#    Navigation to settings page in panel  device=device_1
#    verify device settings option in panel  device=device_1
#    navigate inside of teams admin settings in panel    device=device_1
#    go to meetings tab in panel     device=device_1
#
#cancel the current reserved meeting
#    [Arguments]     ${device}
#    navigate to meetings option in panel app settigs       device=device_1
#    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=on
#    Come back to home screen    device_list=device_1
#    checkout of the reserved meeting   device=device_1
#    navigate to meetings option in panel app settigs       device=device_1
#    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=off
#    enable or disable extend room reservation toggle btn in panel      device=device_1       extend_rr_state=off
#    go back to homescreen from admin settings options   device=device_1
#    Refresh calls main tab  device=device_1
#    validate room availability status   device=device_1   status=available
#
#Enable check out and extend room reservation toggles
#    [Arguments]     ${device}
#    navigate to meetings option in panel app settigs       device=device_1
#    enable or disable check out toggle btn in panel         device=device_1       checkout_toggle_status=on
#    enable or disable extend room reservation toggle btn in panel      device=device_1       extend_rr_state=on
#    go back to homescreen from admin settings options       device=device_1
#
#refresh meeting visibility for norden device
#    [Arguments]    ${device}
#     Refresh meeting visibility for conf device  ${device}
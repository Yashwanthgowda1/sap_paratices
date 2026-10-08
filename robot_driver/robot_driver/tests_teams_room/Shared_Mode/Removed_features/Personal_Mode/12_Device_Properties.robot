#*** Settings ***
#Force Tags   pm_device_properties      pm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#*** Test Cases ***
#TC1: [Device Properties] Check firmware version
#    [Tags]  215168   sanity_pm
#    [Setup]  Testcase Setup     count=1
#    Check device firmware version    device=device_1
#    [Teardown]   Run Keywords   Capture on Failure   AND    Come back to home screen   device_list=device_1
#
#TC2: [Device Properties] Check device type
#    [Tags]  215169   P2
#    [Setup]  Testcase Setup     count=1
#    Check device type and validate   device=device_1
#    [Teardown]   Run Keywords   Capture on Failure   AND    Come back to home screen   device_list=device_1
#
#TC3: [Encryption] Check device encryption
#    [Tags]  259060   P1
#    [Setup]  Testcase Setup     count=1
#    Check device encryption state and validate    device=device_1
#    [Teardown]   Run Keywords   Capture on Failure   AND    Come back to home screen   device_list=device_1
#
##Need to modify the test case
##TC3: [Device Properties] Check device capabilities
##    [Tags]  215170   P2
##    [Setup]  Testcase Setup     count=1
##    Check device capabilities   device=device_1
##    [Teardown]   Run Keywords   Capture on Failure   AND    Come back to home screen   device_list=device_1
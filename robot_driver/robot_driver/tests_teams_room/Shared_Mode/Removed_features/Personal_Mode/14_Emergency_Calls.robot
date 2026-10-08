#*** Settings ***
#Documentation   Emergency Calls
#Force Tags    pm_emergency_calls       pm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#*** Variables ***
#${wait_time} =  10
#
#
#*** Test Cases ***
#TC1: [Emergency call] User must sign in to make an emergency call
#    [Tags]  194935   bvt   bvt_pm    sanity_pm
#    [Setup]  Testcase Setup     count=1
#    Sign out method    device=device_1
#    Verify sign in to make an emergency call    device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND     Sign in method    device=device_1
#
#TC2 : [Emergency call] Check auto -dial for emergency number
#    # Dial 933 for Emergency Calling
#    [Tags]  194937  bvt   bvt_pm   sanity_pm
#    [Setup]  Testcase Setup    count=1
#    Navigate to dial pad on home screen   device=device_1
#    Auto dial emergency number and validate   device=device_1
#    Disconnect call   device=device_1
#    Verify Call State   device_list=device_1    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

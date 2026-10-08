*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10


*** Test Cases ***
TC1 : [CAP Policy] CAP user sign in intent
    [Tags]   261855   P1   bvt_cap   sanity_cap    Certification_cap
    [Setup]   Testcase Setup for CAP User   count=1
    Reset Logcat Capture    device=device_1
    Sign Out    device_list=device_1
    Wait for Some Time    time=${wait_time}
    Verify Intents      device=device_1     intent=sign_out     user=cap_search_enabled
    Sign In     device_list=device_1    user_list=cap_search_enabled
    Wait for Some Time    time=${wait_time}
    Verify Intents      device=device_1     intent=sign_in     user=cap_search_enabled
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

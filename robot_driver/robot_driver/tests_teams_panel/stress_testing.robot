*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Variables ***
${iteration_count} =  11

*** Test Cases ***
TC1:[Stress Testing][Sign-in] User to sign-in with username and password
    [Tags]  435535
    [Setup]  Testcase Setup  count=1
    FOR    ${i}    IN RANGE    1    ${iteration_count}
        run keyword and ignore error    TC1: [Stress Testing][Sign-in] User to sign-in with username and password     ${i}
    END
    [Teardown]  Capture on Failure

*** Keywords ***
TC1:[Stress Testing][Sign-in] User to sign-in with username and password
    [Arguments]     ${i}
    ${name} =   catenate  ${TEST NAME}  ${i}
    set test variable  ${status_flag}    ${False}
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    sign in method  device_1
    Verify homescreen on panel       device=device_1
    Verify Intents      device=device_1     intent=sign_in     user=meeting_user
    [Teardown]    run keyword unless   '${status_flag}' == 'True'    capture screenshot logcats and app crash  name=${name}
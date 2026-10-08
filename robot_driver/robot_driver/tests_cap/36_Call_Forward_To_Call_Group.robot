*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Setup      run keywords       Testcase Setup for CAP and GCP User    count=3      AND     Enable call forwarding to call group     from_device=device_1    contact_device=device_2
Suite Teardown    run keywords      Suite Failure Capture       AND     verify and set call forwarding on home screen       device=device_1        option=off


*** Variables ***
${wait_time} =  10
${wait_time2} =  20

*** Test Cases ***
TC1 :Verify Send to Voicemail option should not present for incoming forwarded group call notification
    [Tags]     452847      sanity_cap           phonesCY23_4
    [Setup]   Testcase Setup for CAP and GCP User  count=3
    click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1:cap_search_enabled
    verify group incoming call notification should not contains redirect to voicemail     device=device_2         from_device=device_3      to_device=device_1:cap_search_enabled
    [Teardown]  run keywords  Capture on Failure   AND   Come back to home screen   device_list=device_2,device_3


*** Keywords ***
Disable Call forward
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    verify and disable call forwarding    device=device_1
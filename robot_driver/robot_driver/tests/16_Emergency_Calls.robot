*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown      Suite Failure Capture

*** Variables ***


*** Test Cases ***
TC1 : [E911] Sign in to make an emergency call
    [Tags]  309172      bvt_pr  alt_credentials
    [Setup]  Testcase Setup    count=1
    sign out method    device_1
    Verify sign in to make an emergency call    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND     sign in method     device_1

TC2 : [E911] On user sign out, firmware to remove all emergency call information stored
    # Dial 933 for Emergency Calling
    [Tags]  309188   P3  alt_blocked        Certification_audio
    [Setup]  Testcase Setup    count=1
    Click on calls tab   device=device_1
    Dial emergency num and validate    device=device_1
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    ${participant_name_before_EM_call}   Get first call participant name    device=device_1
    sign out method    device_1
    sign in method     device_1     user=cq_user
    ${participant_name_after_EM_call}   Get first call participant name    device=device_1
    run keyword if  '${participant_name_before_EM_call}' != '${participant_name_after_EM_call}'    Log   Call log is not matching after Signing with other user
    ...   ELSE   FAIL   Call log is matching after Signing with other user
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC3 : [Phone lock] Verify DUT user to set Emergency number as Lock Pin
    [Tags]    317892
    [Setup]    Testcase Setup for Phone Lock    count=1
    set device lock starting with emergency number    device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

*** Keywords ***

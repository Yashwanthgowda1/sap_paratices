*** Settings ***
Resource    ../resources/keywords/common.robot


Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =      10s


*** Test Cases ***
TC1:[Sign-in][Intune]User should be able to sign-in code using Intune License Account..
    [Tags]     346197   sanity_tp      bvt_tp   auth_audio      auth_audio_p0
    [Setup]  Testcase Setup    count=1
    Sign out method    device_1
    Wait for Some Time    time=${wait_time}
    Sign in method      device=device_1    user=intune_user
    Verify home screen page     device=device_1
    verify user contact info        device=device_1:intune_user
    [Teardown]   Run Keywords    Capture on Failure     AND        Sign out method    device_1

TC2 :[Sign-in][Intune]User should be able to sign-in using DCF code using Intune License Account..
    [Tags]      346198     auth_audio_p0    auth_audio     sanity_tp         bvt_tp
    [Setup]    Run Keywords    Sign out method    device_1    AND    Testcase Setup for ZTP  count=1
    signin method with dcf code    device=device_1    user=intune_user
    Wait for Some Time    time=${wait_time}
    Verify home screen page     device=device_1
    verify user contact info        device=device_1:intune_user
    [Teardown]   Run Keywords    Capture on Failure     AND    Sign out method    device_1    AND     Sign in method     device_1

TC3: [Sign-in] User to sign-in from another device (web sign-in)
    [Tags]  308380  auth_audio_p0    auth_audio     sanity_tp         bvt_tp
    [Setup]  Testcase Setup    count=1
    sign out method  device=device_1
    verify teams app signin page    device=device_1
    signin method with dcf code    device=device_1    user=user
    Verify presence of Intents        device=device_1         feature=user_password         state=absent
    [Teardown]   Run Keywords    Capture on Failure      AND    Come back to home screen    device_list=device_1

TC4: [Web UI] User to verify the https support for Web UI
    [Tags]    310880    bvt_tp    sanity_tp
    [Setup]    Testcase Setup    count=1
    Verify Web Sign With Different Protocol    protocol_type=secure     device=device_1
    [Teardown]    Capture On Failure
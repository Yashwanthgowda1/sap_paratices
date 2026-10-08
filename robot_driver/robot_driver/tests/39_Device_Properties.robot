*** Settings ***
Resource    resources/keywords/common.robot

*** Test Cases ***
TC1: [Encryption] Check device encryption, compliance and also validate encryption status in endpoint manager
    [Tags]  309932    sanity_tp    bvt_tp
    [Setup]  Testcase Setup   count=1
    check device encryption state   device=device_1
    [Teardown]  Capture on Failure

TC2: [Device Properties] Check firmware version
    [Tags]  310452   bvt_tp  sanity_tp      Certification_audio
    [Setup]  Testcase Setup  count=1
    check device firmware version  device=device_1
    [Teardown]  Capture on Failure

TC3: [Device Settings] After rebooting DUT should not ask to change service provider.
    [Tags]    402133    bvt_tp     sanity_tp       P0    Acceptance_audio
    [Setup]    Testcase Setup    count=1
    reboot phones    device=device_1
    Navigate to device setting page   device=device_1
    verify service provider is absent       device=device_1
    [Teardown]    Run Keywords     Capture on Failure    AND    Come back to home screen    device_list=device_1

TC4: [Admin Settings] Admin settings are password protected in the DUT
    [Tags]    307258    bvt_tp     sanity_tp
    [Setup]    Testcase Setup    count=1
    Navigate to device setting page   device=device_1
    open admin settings     device=device_1
    Verify Presence Of Intents    device=device_1    feature=admin_password    state=absent
    [Teardown]    Run Keywords     Capture on Failure    AND    Come back to home screen    device_list=device_1

TC5 : [Customer Readiness] Logging option to be enabled by default
    [Tags]    308485    bvt_tp     sanity_tp
    [Setup]    Testcase Setup    count=1
    verify logging option is enabled admin settings    device=device_1
    [Teardown]    Run Keywords     Capture on Failure    AND    Come back to home screen    device_list=device_1

TC6 : [Admin Settings] User to enable logging and set log level from Admin settings
    [Tags]    307225    sanity_tp
    [Setup]    Testcase Setup    count=1
    set log level from Admin settings    device=device_1
    [Teardown]    Run Keywords     Capture on Failure    AND    Come back to home screen    device_list=device_1



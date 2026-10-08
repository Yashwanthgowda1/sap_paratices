*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1: Verify that DUT user should be able to answer the call/meeting from "Privacy & Cookies" page under About in settings.
    [Tags]  348866    bvt_lcp     sanity_lcp
    [Setup]  Testcase Setup     count=2
    verify options inside about page     device=device_1
    navigate to privacy and cookies from about page    device=device_1
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_1     state=Disconnected
    navigate to home screen from about page  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2: Verify that DUT should not have "Connected Experiences" option under About in settings.
    [Tags]  348863        
    [Setup]  Testcase Setup     count=1
    verify options inside about page     device=device_1
    verify connected experiences does not present in about page       device=device_1
    navigate to home screen from about page  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3: Verify that DUT user able to access "Privacy & Cookies" page under About in settings.
    [Tags]  348861
    [Setup]  Testcase Setup     count=1
    verify options inside about page     device=device_1
    navigate to privacy and cookies from about page    device=device_1
    navigate to home screen from about page  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC4: Verify that DUT user should be able to answer the call/meetng from "Terms of Use" page under About in settings.
    [Tags]  348867
    [Setup]  Testcase Setup     count=2
    verify options inside about page     device=device_1
    navigate to terms of use from about page  device=device_1
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_1     state=Disconnected
    navigate to home screen from about page  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC5: Verify that DUT user should be able answer a call/meeting from "Third party software notices and information" page under About in settings.
    [Tags]  348869
    [Setup]  Testcase Setup     count=2
    verify third party software notices for lcp    device=device_1
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_1     state=Disconnected
    navigate to home screen from about page  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
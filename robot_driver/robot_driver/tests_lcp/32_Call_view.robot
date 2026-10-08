*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Setup     Suite Setup
Suite Teardown    Run Keywords    Suite Failure Capture   AND     Suite Teardown    device=device_1

*** Variables ***



*** Test Cases ***
TC1 : [Call views] DUT to have Call views option under Calling settings
    [Tags]   244159     p2    sanity_lcp    bvt_lcp
    [Setup]    Testcase Setup    count=1
    Verify call views option under callings settings     device=device_1
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1

TC2 : [Call views] DUT user to cancel the selection in Default view and selects other options
    [Tags]   244161     P2
    [Setup]    Run keywords     Testcase Setup    count=1    AND     Verify Default view relaunches after changing the value     device=device_1     option=recent call history
    Select and cancel default value     device=device_1     option=recent call history
    Select default view    device=device_1     option=speed dial
    Validate calls tab after default value change    device=device_1      default_option=speed dial
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1   AND     Verify Default view relaunches after changing the value     device=device_1     option=speed dial

TC3 : [Call views] User should be able to access Speed dial tab as default screen is set as "Recent Call history"
    [Tags]   318726     P2
    [Setup]    run keywords     Testcase Setup    count=1   AND     Select default view value     device=device_1     option=recent call history
    Validate calls tab after default value change    device=device_1      default_option=recent call history
    Navigate to calls tab   device=device_1
    verify favorite page lcp    device=device_1
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1    AND     Verify Default view relaunches after changing the value     device=device_1     option=speed dial

*** Keywords ***
Suite Setup
    Navigate to calls tab   device=device_1
    Make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1  item=favorite
    Verify added favorite user in favorites page    from_device=device_1     to_device=device_2

Suite Teardown
    [Arguments]     ${device}
    Come back to home screen     ${device}
    Select default view value     ${device}     option=speed dial

Make outgoing call for call log
    [Arguments]     ${from_device}   ${to_device}
    Make outgoing call using display name    from_device=${from_device}      to_device=${to_device}
    Verify Incoming call    device=${to_device}     status=appear
    Disconnect call     device=${from_device}
    Verify Incoming call    device=${to_device}     status=disappear
    Verify Call State    device_list=${from_device}     state=Disconnected
    Return to home screen       device_list=${from_device}
    Navigate to calls tab   device=${from_device}
    Refresh calls main tab    device=${from_device}


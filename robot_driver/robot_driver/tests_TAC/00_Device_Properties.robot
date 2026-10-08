*** Settings ***
Resource    ../resources/keywords/common.robot
Suite Teardown    Suite Failure Capture

*** Variables ***

*** Test Cases ***
TC1 : [Device properties] User sign-in on phones device and verify its health status in TAC
    [Tags]  0000001  bvt_tac     bvt_pr_tac
    [Setup]  Testcase Setup    count=1
    navigate to manage teams devices in tac    device=tdc_1     device_options=Phones
    navigate to health summary of device in tac   from_device=tdc_1      to_device=device_1:user
    verify health status of device in tac       from_device=tdc_1       expected_health=Non-urgent
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1    AND     refresh tac and navigate to dashboard    device=tdc_1


TC2 : [Device properties] User sign-in on MTRA device and verify its health status in TAC
    [Tags]  0000002  bvt_tac     bvt_pr_tac
    [Setup]  Testcase Setup    count=2
    navigate to manage teams devices in tac    device=tdc_1     device_options=CollaborationBars
    navigate to health summary of device in tac   from_device=tdc_1      to_device=device_2:user
    verify health status of device in tac       from_device=tdc_1       expected_health=Non-urgent
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_2    AND     refresh tac and navigate to dashboard    device=tdc_1
*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown     Run Keywords    Suite Failure Capture    AND    Disable unanswered call    device=device_2      contact_device=device_1

*** Variables ***

*** Test Cases ***
TC1 : [Rich call history] If the transfer target missed the call, on info page, we will show "Missed transfer by: <Transferor>" if it is missed and on recent, we will show “Missed transfer”
    [Tags]  474073    rich_call_history
    [Setup]  Testcase Setup    count=3
    click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Blindtransfers the call using display name  from_device=device_3      to_device=device_1
    Disconnect call     device=device_2
    Disconnect call     device=device_3
    Come Back To Home Screen    device_list=device_1,device_2,device_3
    verify missed transfer call in recent tab   device=device_1   transferor_device=device_3
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_3,device_2

TC2 : [Rich call history] In case of call transfer, for transfer target (who is answering the transferred call), we are updating the text to "Transferred in: <duration>" on info page, we will show “Transferred in: <Transferor>”
    [Tags]  474071    rich_call_history
    [Setup]  Testcase Setup    count=3
    click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Blindtransfers the call using display name  from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Disconnect call     device=device_1
    Come Back To Home Screen    device_list=device_1,device_2,device_3
    verify transferred in call in recent tab   device=device_1   transferor_device=device_3
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_3,device_2

TC3 : [Rich call history] In case of call transfer, for transferee (whose call is getting transferred), we are updating the text to "Transferred out: <duration>" on tab and we will show “Transferred out: <Transferor>” on info page.
    [Tags]  474070    rich_call_history
    [Setup]  Testcase Setup    count=3
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Disconnect call     device=device_3
    Come Back To Home Screen    device_list=device_1,device_2,device_3
    verify transferred out call in recent tab   device=device_1   transferor_device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_3,device_2

TC4 : [Rich call history] Showing "Missed forwarded" on Recent and "Missed forwarded from: Forwarder" on Info page, when the Forwarding target missed the forwarded call.
    [Tags]    474080
    [Setup]  Testcase Setup    count=3
    Enable unanswered call and add contact    from_device=device_2    contact_device=device_1
    Click on calls tab      device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_2
    Verify incoming call    device=device_1     status=appear
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3,device_2,device_1    state=Disconnected
    verify missed forward call in recent tab     device=device_1      forwarded_device=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_3,device_2

TC5 : [Rich call history] Showing "Forwarded: <Duration>" on Recent and "Forwarded by: Forwarder" on Info page, when the Forwarding target accepted the forwarded call.
    [Tags]    474078
    [Setup]  Testcase Setup    count=3
    Click on calls tab      device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_2
    Verify incoming call    device=device_1     status=appear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Wait for Some Time    time=10
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3,device_2,device_1    state=Disconnected
    verify forwarded call in recent tab     device=device_1      forwarded_device=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_3,device_2    AND    Disable unanswered call    device=device_2      contact_device=device_1

TC6 : [Rich call history] Showing "call queue" tag on call history item if the call is from call queue.
    [Tags]    474077
    [Setup]    Testcase Setup for CQ User    count=3
    click on calls tab   device=device_2
    Place call to phone num    from_device=device_2      phone_num=CQ_no
    Wait till incoming call visibility    device=device_1,device_3
    Pick incoming call    device=device_1
    Verify Incoming call    device=device_3     status=disappear
    Verify Call State    device_list=device_1,device_2    state=Connected
    Wait for Some Time    time=10
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Navigate To Calls Tab    device=device_1
    verify cq call log in calls tab    device=device_1    to_device=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_3,device_2

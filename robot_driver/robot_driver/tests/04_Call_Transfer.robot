*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  7

*** Test Cases ***
TC1 : [Call Transfer] DUT user blind transfer one Teams Client call to another Teams client
    [Tags]  309813       bvt_pr  alt_bug
    [Setup]  Testcase Setup    count=3
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Blindtransfers the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2 : [Call Transfer] DUT user consultative transfer the TDC's call to another TDC
    [Tags]  309833       alt_bug
    [Setup]  Testcase Setup    count=3
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3,device_1    state=Connected
    Verify Call State    device_list=device_2    state=Hold
    Completes the consultation to accept the call     from_device=device_1      to_device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3 : [Call Transfer] Initial list contacts in the call transfer section.
    [Tags]  309810       alt_credentials        Certification_audio
    [Setup]  Testcase Setup    count=3
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify initial list contacts in the call transfer section     from_device=device_1      to_device=device_3
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC4 : [Call Transfer] DUT user to blind transfer the TDC's call to another TDC who is on DND
    [Tags]   309829     call_transfer   P2  alt_credentials
    [Setup]     run keywords  Testcase Setup    count=3     AND     Select user presence     device=device_2     state=DND
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Blindtransfers the call using display name  from_device=device_1      to_device=device_2
    Verify Incoming call    device=device_2     status=Disappear
    verify call state and disconnect    device=device_1,device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Select user presence     device=device_2     state=Available    AND    Come back to home screen    device_list=device_1,device_2,device_3


TC5 : [Call Transfer] Verify that DUT user 1 blind transfers and consult transfers the TDC call to DUT user 2.
    [Tags]    309848    tp_audio    P2
    [Setup]    Testcase Setup   count=3
    Click On Calls Tab    device=device_1
    Make Outgoing Call Using Display Name    from_device=device_1    to_device=device_3
    Pick Incoming Call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Blindtransfers The Call Using Display Name    from_device=device_1    to_device=device_2
    Pick Incoming Call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    Navigate To Calls Tab    device=device_1
    Make Outgoing Call Using Display Name    from_device=device_1    to_device=device_3
    Pick Incoming Call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Consult First To Transfer The Call Using Display Name    from_device=device_1    to_device=device_2
    Pick Incoming Call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Completes The Consultation To Accept The Call    from_device=device_1    to_device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect Call    device=device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]    Run Keywords    Capture On Failure    AND    Come Back To Home Screen    device_list=device_1,device_2,device_3

TC6: [Call transfer] Verify DUT should display Transferred call summary under call summary option inside the More (...)after receiving the blind transferred call
    [Tags]    557917
    [Setup]    Testcase Setup   count=3
    Make outgoing call using phonenumber    from_device=device_2    to_device=device_1
    Pick Incoming Call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    click on call transfer and enable copilot    devices=device_1
    verify options inside ai contents refresh    devices=device_1
    device setting back     device=device_1
    Blindtransfers The Call Using Display Name    from_device=device_1    to_device=device_3
    verify_rtt_banner_option_inside_call_page   device=device_3
    Pick Incoming Call    device=device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify Call State    device_list=device_1   state=disConnected
    verify_option_after_transfer_the_ai_summary_call        device=device_3
    Disconnect Call    device=device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]    Run Keywords    Capture On Failure    AND    Come Back To Home Screen    device_list=device_1,device_2,device_3

TC7: [Call transfer] Verify DUT should display Transferred Call Summary under Call summary option inside the More (...)after receiving the Consult transferred call
    [Tags]    557920
    [Setup]    Testcase Setup   count=3
    Make outgoing call using phonenumber    from_device=device_2    to_device=device_1
    Pick Incoming Call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    click on call transfer and enable copilot    devices=device_1
    verify options inside ai contents refresh    devices=device_1
    device setting back     device=device_1
    Consult first to transfer the call using display name    from_device=device_1    to_device=device_3
    Pick Incoming Call    device=device_3
    click_transfer_button_when_using_ai_summery_enable      device=device_1
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify Call State    device_list=device_1   state=disConnected
    verify_option_after_transfer_the_ai_summary_call        device=device_3
    Disconnect Call    device=device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]    Run Keywords    Capture On Failure    AND    Come Back To Home Screen    device_list=device_1,device_2,device_3


*** Comments ***
Removed the cases as per the feature: Feature Test Request 454374: [Phones] Call Transfer Enhancements
Removed in 1.2.0 (U2 2024)

Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

TC1: [Voicemail] Verify "Work voicemail" option during consult transfer
    [Tags]  316416      sanity_lcp      bvt_lcp
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify work voicemail during call transfer   from_device=device_1   to_device=device_3   transfer_method=consult
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2: [Voicemail] Verify transfer should have option to choose to send voicemail to transfer target directly
    [Tags]  316415      sanity_lcp      bvt_lcp
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify work voicemail during call transfer   from_device=device_1   to_device=device_3   transfer_method=blind
    transfer call to work voicemail  device=device_1
    verify incoming call   device=device_3      status=disappear
    verify call state    device_list=device_1    state=Disconnected
    verify call state    device_list=device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
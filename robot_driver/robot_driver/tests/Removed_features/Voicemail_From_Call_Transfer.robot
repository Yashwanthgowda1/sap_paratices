#*** comment ***
Removed the cases as per the feature: Feature Test Request 454374: [Phones] Call Transfer Enhancements
Removed in 1.2.0 (U2 2024)

Resource  ../resources/keywords/common.robot


Suite Teardown    Suite Failure Capture

${wait_time} =  10

TC1 : [Voicemail] Verify transfer should have option to choose to send voicemail to transfer target directly
    [Tags]  310894   P0    bvt_tp    sanity_tp
    [Setup]  Testcase Setup   count=3
    Make outgoing call using display name   from_device=device_2   to_device=device_1
    verify incoming call   device=device_1    status=appear
    pick incoming call   device=device_1
    Wait for Some Time   ${wait_time}
    verify call state    device_list=device_1,device_2     state=Connected
    verify work voicemail during call transfer   from_device=device_1   to_device=device_3   transfer_method=blind
    transfer call to work voicemail  device=device_1
    verify incoming call   device=device_3      status=disappear
    verify call state    device_list=device_1    state=Disconnected
    verify call state    device_list=device_2    state=Connected
    disconnect call   device=device_2
    verify call state    device_list=device_1,device_2     state=Disconnected
    [Teardown]  run keywords    Capture on Failure   AND   come back to home screen    device_list=device_1,device_2,device_3

TC2: [Voicemail] Verify "Work voicemail" option during consult transfer
    [Tags]  310897   P0   bvt_tp     sanity_tp
    [Setup]  Testcase Setup   count=3
    Make outgoing call using display name   from_device=device_2   to_device=device_1
    verify incoming call   device=device_1    status=appear
    pick incoming call   device=device_1
    Wait for Some Time   ${wait_time}
    verify call state   device_list=device_1,device_2     state=Connected
    verify work voicemail during call transfer   from_device=device_1   to_device=device_3   transfer_method=consult
    disconnect call  device=device_1
    verify call state    device_list=device_1,device_2     state=Disconnected
    [Teardown]  run keywords    Capture on Failure   AND   come back to home screen    device_list=device_1,device_2,device_3


TC3 : [Voicemail] Send to transfer the call to voicemail during blind transfer
    [Tags]  310890   P2
    [Setup]  Testcase Setup   count=3
    Make outgoing call using display name   from_device=device_1   to_device=device_3
    verify incoming call   device=device_3    status=appear
    pick incoming call   device=device_3
    verify call state    device_list=device_1,device_3     state=Connected
    verify work voicemail during call transfer   from_device=device_1   to_device=device_2   transfer_method=blind
    transfer call to work voicemail  device=device_1
    verify incoming call   device=device_2      status=disappear
    Wait for Some Time   ${wait_time}
    verify call state    device_list=device_3    state=Connected
    verify call state    device_list=device_1    state=Disconnected
    disconnect call   device=device_3
    verify call state    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  run keywords    Capture on Failure   AND   come back to home screen    device_list=device_1,device_2,device_3
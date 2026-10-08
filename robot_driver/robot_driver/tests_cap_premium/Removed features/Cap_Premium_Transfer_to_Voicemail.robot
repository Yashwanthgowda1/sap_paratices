*** comment ***
Removed the cases as per the feature: Feature Test Request 454374: [Phones] Call Transfer Enhancements
Removed in 1.2.0 (U2 2024)

Library     DateTime
Resource    ../resources/keywords/common.robot

Suite Teardown      Suite Failure Capture


TC1 : [Advance calling][Transfer to voicemail] Send to transfer the call to voicemail during blind transfer
       [Tags]  329303      BVT_CAPPremium     Sanity_CAPPremium
       [Setup]   Testcase Setup for CAP Premium User      count=3
       click on calls tab     device=device_1
       Make outgoing call using display name    from_device=device_1      to_device=device_3
       Pick incoming call    device=device_3
       Verify Call State    device_list=device_1,device_3    state=Connected
       verify work voicemail during call transfer   from_device=device_1   to_device=device_2      transfer_method=blind
       transfer call to work voicemail      device=device_1
       verify incoming call   device=device_2      status=disappear
       verify call state    device_list=device_1    state=Disconnected
       verify call state    device_list=device_3    state=Connected
       disconnect call   device=device_3
       verify call state    device_list=device_1,device_3     state=Disconnected
       [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2,device_3

TC2 : [Advance calling][Voicemail] Verify "Work voicemail" option during consult transfer
       [Tags]   329304     P1     Sanity_CAPPremium
       [Setup]   Testcase Setup for CAP Premium User      count=3
       click on calls tab     device=device_1
       Make outgoing call using display name   from_device=device_1     to_device=device_2
       Pick incoming call   device=device_2
       verify call state   device_list=device_1,device_2     state=Connected
       verify work voicemail during call transfer   from_device=device_1  to_device=device_3   transfer_method=consult
       disconnect call  device=device_1
       verify call state    device_list=device_1,device_2     state=Disconnected
       [Teardown]  run keywords    Capture on Failure   AND   come back to home screen    device_list=device_1,device_2,device_3

Advance calling Setup
    Verify and enable advance calling option       device=device_1
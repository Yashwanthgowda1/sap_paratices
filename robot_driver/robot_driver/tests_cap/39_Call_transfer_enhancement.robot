*** Settings ***
Resource    ../resources/keywords/common.robot



*** Variables ***

*** Test Cases ***
TC1 : [CallTransferEnhancements] blind transfer search screen > can search for users > touchscreen transfer
       [Tags]  456374      bvt_cap     sanity_cap   P0
       [Setup]   Testcase Setup for CAP User    count=3
       Click on calls tab   device=device_2
       Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
       Pick incoming call    device=device_1
       Verify Call State    device_list=device_1,device_2    state=Connected
       Blindtransfers the call using display name  from_device=device_1      to_device=device_3
       Pick incoming call    device=device_3
       Verify Call State    device_list=device_3,device_2    state=Connected
       Disconnect call     device=device_3
       Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
       [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2,device_3

TC2 : [CallTransferEnhancements] consult transfer search screen > can search for users > touchscreen transfer
       [Tags]  456452      sanity_cap   P1
       [Setup]   Testcase Setup for CAP User    count=3
       Click on calls tab   device=device_2
       Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
       Pick incoming call    device=device_1
       Verify Call State    device_list=device_1,device_2    state=Connected
       Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
       Pick incoming call    device=device_3
       Verify Call State    device_list=device_3,device_1    state=Connected
       Verify Call State    device_list=device_2    state=Hold
       Completes the consultation to accept the call     from_device=device_1      to_device=device_2
       Verify Call State    device_list=device_1     state=Disconnected
       Verify Call State    device_list=device_3,device_2    state=Connected
       Disconnect call     device=device_2
       Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
       [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2,device_3


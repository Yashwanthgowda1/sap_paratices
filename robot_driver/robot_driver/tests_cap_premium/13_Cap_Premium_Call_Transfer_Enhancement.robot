*** Settings ***
Library     DateTime
Resource    ../resources/keywords/common.robot

Suite Setup     Call Transfer Setup
Suite Teardown     Run Keywords    Suite Failure Capture    AND   Call Transfer Teardown


*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [CallTransferEnhancements] blind transfer search screen > can search for users > touchscreen transfer
       [Tags]  456312      BVT_CAPPremium     Sanity_CAPPremium
       [Setup]   Testcase Setup for CAP Premium User      count=3
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
       [Tags]  456320      Sanity_CAPPremium
       [Setup]   Testcase Setup for CAP Premium User      count=3
       Click on calls tab   device=device_2
       Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
       Pick incoming call    device=device_1
       Verify Call State    device_list=device_1,device_2    state=Connected
       Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
       Pick incoming call    device=device_3
       Verify Call State    device_list=device_3,device_1    state=Connected
       Verify Call State    device_list=device_2    state=Hold
       Completes the consultation to accept the call     from_device=device_1      to_device=device_2
       Wait for Some Time    time=${wait_time}
       Verify Call State    device_list=device_1     state=Disconnected
       Verify Call State    device_list=device_3,device_2    state=Connected
       Disconnect call     device=device_2
       Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
       [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2,device_3

TC3 : [CallTransferEnhancements] consult transfer search screen > launch dialpad
       [Tags]  456326      Sanity_CAPPremium
       [Setup]   Testcase Setup for CAP Premium User      count=3
        click on calls tab   device=device_2
        Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
        Pick incoming call    device=device_1
        Verify Call State    device_list=device_1,device_2    state=Connected
        verify call transfer UI when in call   from_device=device_1   to_device=device_2   speed_dial_user=device_3    option=consult_first
        resume the call      device=device_1
        click and verify dial pad in call transfer   device=device_1   option=consult_first
        Disconnect call     device=device_2
        Verify Call State    device_list=device_1,device_2     state=Disconnected
       [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2,device_3

TC4 : [CallTransferEnhancements] [landscape] blind transfer search screen > shows speed dials
       [Tags]  456336      BVT_CAPPremium     Sanity_CAPPremium
       [Setup]   Testcase Setup for CAP Premium User      count=3
        click on calls tab   device=device_2
        Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
        Pick incoming call    device=device_1
        Verify Call State    device_list=device_1,device_2    state=Connected
        verify call transfer UI when in call   from_device=device_1   to_device=device_2   speed_dial_user=device_3    option=transfer_now
        resume the call      device=device_1
        Blindtransfers the call using display name  from_device=device_1      to_device=device_3
        Pick incoming call    device=device_3
        Verify Call State    device_list=device_3,device_2    state=Connected
        Disconnect call     device=device_3
        Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
       [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2,device_3

TC5 : [CallTransferEnhancements] [landscape] consult transfer search screen > shows speed dials.
       [Tags]  456338     Sanity_CAPPremium
       [Setup]   Testcase Setup for CAP Premium User      count=3
       click on calls tab   device=device_2
       Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
       Pick incoming call    device=device_1
       Verify Call State    device_list=device_1,device_2    state=Connected
       verify call transfer UI when in call   from_device=device_1   to_device=device_2   speed_dial_user=device_3    option=transfer_now
       resume the call      device=device_1
       transfer call using speed dial from call transfer UI   device=device_1   speed_dial_user=device_3   transfer_option=consult_first
       Pick incoming call    device=device_3
       Verify Call State    device_list=device_3,device_1    state=Connected
       Verify Call State    device_list=device_2    state=Hold
       Completes the consultation to accept the call     from_device=device_1      to_device=device_2
       Wait for Some Time    time=${wait_time}
       Verify Call State    device_list=device_1     state=Disconnected
       Verify Call State    device_list=device_3,device_2    state=Connected
       Disconnect call     device=device_2
       Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
       [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2,device_3

TC6 : [CallTransferEnhancements] consult transfer search screen > shows speed dials
       [Tags]  456317     BVT_CAPPremium     Sanity_CAPPremium
       [Setup]   Testcase Setup for CAP Premium User      count=3
       click on calls tab   device=device_2
       Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
       Pick incoming call    device=device_1
       Verify Call State    device_list=device_1,device_2    state=Connected
       verify call transfer UI when in call   from_device=device_1   to_device=device_2   speed_dial_user=device_3    option=transfer_now
       resume the call      device=device_1
       transfer call using speed dial from call transfer UI   device=device_1   speed_dial_user=device_3   transfer_option=consult_first
       Pick incoming call    device=device_3
       Verify Call State    device_list=device_3,device_1    state=Connected
       Verify Call State    device_list=device_2    state=Hold
       Completes the consultation to accept the call     from_device=device_1      to_device=device_2
       Wait for Some Time    time=${wait_time}
       Verify Call State    device_list=device_1     state=Disconnected
       Verify Call State    device_list=device_3,device_2    state=Connected
       Disconnect call     device=device_2
       Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
       [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2,device_3

*** Keywords ***
Call Transfer Setup
    navigate to calls favorites page      device=device_1
    remove favorite contacts from favorites tab   device=device_1
    click on calls tab     device=device_1
    Make outgoing call using display name      from_device=device_1      to_device=device_3
    Pick incoming call      device=device_3
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    Come back to home screen    device_list=device_1,device_3
    click on calls tab   device=device_1
    Refresh calls main tab    device=device_1
    Select call list item   device=device_1     item=favorite


Call Transfer Teardown
   Remove favorite user from favorites page    from_device=device_1     to_device=device_3
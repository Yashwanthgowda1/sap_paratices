*** Settings ***
Resource    resources/keywords/common.robot

Suite Teardown     Suite Failure Capture

*** Variables ***
${wait_time} =  10
${wait_time_20s} =  20
${wait_time_150} =  150

*** Test Cases ***

TC1 : [Incoming Calls] DUT user to answer second incoming call
    [Tags]  307266    bvt_tp     sanity_tp  bvt_pr  alt_credentials     Certification_audio
    [Setup]  Testcase Setup    count=3
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    click on calls tab  device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2     state=Hold
    Disconnect call     device=device_2,device_3
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_2,device_3

TC1_sanity : Perform sanity checks in favorites module
    [Tags]  bvt_tp     sanity_tp  bvt_pr  Certification_audio
    [Setup]  Testcase Setup    count=2
    navigate_to_calls_favorites_page  device_1,device_2
    favorites_module_sanity     device_list=device_1,device_2
    [Teardown]   Run Keywords    Capture on Failure

TC2 : [Incoming Calls] DUT user to receive and reject the call when UI view is in Device settings
    [Tags]      308137    P1       sanity_tp
    [Setup]   Testcase Setup    count=2
    open settings page      device=device_1
    click device settings       device=device_1
    verify phones device settings back button     device=device_1
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    Verify name of caller and receiver displayed    from_device=device_2      to_device=device_1
    Rejects the incoming call    device_list=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    verify device settings button on settings pages         device=device_1
    [Teardown]  run keywords  Capture on Failure        AND     Come back to home screen    device_list=device_1,device_2

TC3 : [Incoming call] Verify DUT user gets missed call when user is in call with another user.
    [Tags]  413262   P2
    [Setup]   Testcase Setup    count=2
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    verify incoming call    device=device_1      status=appear
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    click on calls tab  device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    verify options in call notification banner      device=device_1
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3     state=Disconnected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    navigate to calls tab   device=device_1
    Verify call entries are synced in call log    from_device=device_1      to_device=device_3      state=missed
    [Teardown]   Run Keywords    Capture on Failure   AND    device setting back    device=device_1   AND   Come back to home screen    device_list=device_1,device_2

TC4 : [Incoming Calls] Verify Incoming call and audio flow to DUT
    [Tags]   306763  bvt_tp   sanity_tp     incoming_call   P0  alt_blocked
    [Setup]   Testcase Setup    count=2
    Click on calls tab   device=device_2
    Make outgoing call using phonenumber   from_device=device_2     to_device=device_1
    Verify display name on call toast   to_device=device_1    from_device=device_2
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call state and disconnect        device=device_2,device_1
    navigate to calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call state and disconnect        device=device_2,device_1
    navigate to calls tab  device=device_1
    Make outgoing call using display name    from_device=device_2     to_device=device_1
    verify incoming call    device=device_1      status=appear
    Rejects the incoming call   device_list=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    Come back to home screen    device_list=device_1,device_2
     ${calls_count_before_new_call}=    Get missed calls count    device=device_1
    Make outgoing call using display name   from_device=device_2     to_device=device_1
    Verify display name on call toast   to_device=device_1    from_device=device_2
    Disconnect call     device=device_2
    Wait for Some Time    time=${wait_time}
    ${calls_count_after_new_call}=    Get missed calls count    device=device_1
    Navigate to calls tab   device=device_1
    ${device_call_duration}=    get first call duration    device=device_1
    run keyword if  '${device_call_duration}' == 'Missed call'    log   Got missed call
    ...   ELSE   fail   Didn't get missed call
    run keyword if  ${calls_count_before_new_call}+1 == ${calls_count_after_new_call}    Log   Calls count got increased
    ...   ELSE   fail   Calls count didn't increase.
    navigate to calls tab  device=device_2
    Make outgoing call using display name   from_device=device_2     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call state and disconnect        device=device_2,device_1
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2

TC5 : [Incoming Calls] TDC user calls to DUT user which is set to "DND"
    [Tags]  306767   bvt_tp  sanity_tp      incoming_call   P2  alt_credentials
    [Setup]  run keywords   Testcase Setup    count=2    AND   Select user presence   device=device_1     state=DND
    Click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=Disappear
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Select user presence     device=device_1     state=Available    AND    Come back to home screen    device_list=device_1,device_2

TC6 : Verify that missed call notification has "private line" badge if the call was on private line.
    [Tags]  456480    P2   
    [Setup]   Testcase Setup    count=2
    Clear notification from home screen     device=device_1
    Click on calls tab   device=device_2
    Make outgoing call using privateline number    from_device=device_2      to_device=device_1
    verify privateline label on call screen     device=device_1
    Verify Incoming call    device=device_1     status=Appear
    Wait for Some Time    time=${wait_time_20s}
    wait until call disconnected    device=device_1
    verify home screen missed call notification     device=device_1     to_device=device_2      call_type=private_line
    [Teardown]  run keywords  Capture on Failure        AND     Come back to home screen    device_list=device_1,device_2

TC7 : Verify the new design for missed call home screen notification.
    [Tags]  456479    bvt_tp  sanity_tp  P0  P1      bvt_pr
    [Setup]   Testcase Setup    count=3
    Clear notification from home screen     device=device_1
    Click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=Appear
    Wait for Some Time    time=${wait_time_20s}
    wait until call disconnected    device=device_1
    Wait for Some Time    time=${wait_time}
    verify home screen missed call notification     device=device_1     to_device=device_2      call_type=missed_call
    return to home screen    device_list=device_2
    Clear notification from home screen     device=device_1
    Click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Blindtransfers the call using display name  from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=Appear
    Wait for Some Time    time=${wait_time_20s}
    wait until call disconnected    device=device_1
    Wait for Some Time    time=${wait_time}
    verify home screen missed call notification     device=device_1     to_device=device_3      call_type=missed_transfer
    verify call state and disconnect  device=device_2,device_3
    return to home screen    device_list=device_2
    Clear notification from home screen     device=device_1
    Enable call forwarding and add contact     from_device=device_2    contact_device=device_1
    Click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_2
    Verify Incoming call    device=device_1     status=Appear
    Wait for Some Time    time=${wait_time_20s}
    wait until call disconnected    device=device_1
    Wait for Some Time    time=${wait_time}
    verify home screen missed call notification     device=device_1     to_device=device_3      call_type=missed_forward
    Verify call state and disconnect     device=device_3
    Verify Call State    device_list=device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND      Disable Call forward   devices=device_1,device_2,device_3

TC8 :[Calls] Verify DUT user able to navigate the Device Settings page and stay there 2-3 minutes while on a P2P Call.
    [Tags]  402700   P1
    [Setup]   Testcase Setup    count=2
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    click back      device=device_1
    open settings page      device=device_1
    click device settings       device=device_1
    verify phones device settings back button     device=device_1
    Wait for Some Time    time=${wait_time_150}
    click on phones device settings back button     device=device_1
    tap to return to call   device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call state and disconnect        device=device_2,device_1
    [Teardown]  run keywords  Capture on Failure        AND     Come back to home screen    device_list=device_1,device_2

TC9 : Verify the title of missed transferred call home screen notification.
    [Tags]  456481  P1    sanity_tp
    [Setup]    Testcase Setup   count=3
    Clear notification from home screen     device=device_1
    Click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Blindtransfers the call using display name  from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=Appear
    Wait for Some Time    time=${wait_time_20s}
    wait until call disconnected    device=device_1
    verify home screen missed call notification     device=device_1     to_device=device_3      call_type=missed_transfer
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC10 : Verify the title of missed forwarded call home screen notification.
    [Tags]    456482    p1
    [Setup]    Testcase Setup    count=3
    Clear notification from home screen     device=device_1
    Enable call forwarding and add contact     from_device=device_2    contact_device=device_1
    Click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_2
    Verify Incoming call    device=device_1     status=Appear
    Wait for Some Time    time=${wait_time_20s}
    wait until call disconnected    device=device_1
    Wait for Some Time    time=${wait_time}
    verify home screen missed call notification     device=device_1     to_device=device_3      call_type=missed_forward
    Verify call state and disconnect     device=device_3
    Verify Call State    device_list=device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND      Disable Call forward   devices=device_1,device_2,device_3


#TC11 : [Incoming Calls] Teams App does not display video option in call toast for an incoming video call
#    [Tags]  146625      incoming_call   P2  alt_credentials
#    [Setup]   Testcase Setup    count=2
#    Make Video call using display name   from_device=device_2     to_device=device_1
#    Verify display name on call toast   to_device=device_1    from_device=device_2
#    Verify Incoming call    device=device_1     status=Appear
#    Rejects the incoming call     device_list=device_1
#    [Teardown]  run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1,device_2

#TC12 : [Incoming Calls] Teams app does not display video option for an incoming connected call dialled using contact card
#    [Tags]  146626      incoming_call   P2  alt_credentials
#    [Setup]   Testcase Setup    count=2
#    Make Video call using display name   from_device=device_2     to_device=device_1
#    Verify display name on call toast   to_device=device_1    from_device=device_2
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    verify_video_status     device=device_1     status=OFF
#    Wait for Some Time    time=${wait_time}
#    Disconnect call     device=device_2
#    [Teardown]  run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1,device_2

# TC4 : [Incoming Calls] DUT user answers the video call from TDC
#     [Tags]  306789   bvt    bvt_pr  alt_credentials
#     [Setup]   Testcase Setup    count=2
#     Make Video call using display name   from_device=device_2     to_device=device_1
#     Verify display name on call toast   to_device=device_1    from_device=device_2
#     Pick incoming call    device=device_1
#     Wait for Some Time    time=${wait_time}
#     Verify Call State    device_list=device_1,device_2    state=Connected
#     Verify video status     device=device_2     status=ON
#     Verify video status     device=device_1     status=OFF
#     Wait for Some Time    time=${wait_time}
#     Disconnect call     device=device_2
#     [Teardown]  run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1,device_2

*** Keywords ***
Disable Call forward
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    verify and disable call forwarding    device=device_2
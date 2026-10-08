*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1: [Outgoing Calls] DUT user makes call to PSTN user from search icon
    [Tags]  148695    P2
    [Setup]  Testcase Setup for CAP PSTN User    count=2
    click on people tab   device=device_1
    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call     device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : [Call Mute] DUT user to mute/unmute itself while in a call with PSTN user
    [Tags]  148964  P1   sanity_cap
    [Setup]  Testcase Setup for CAP PSTN User   count=2
    click on people tab   device=device_1
    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_1
    Verify Call mute State    device_list=device_1    state=mute
    Unmutes the phone call  device=device_1
    Verify Call mute State    device_list=device_1    state=unmute
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2


TC3 : [Call Transfer] DUT user consultative transfers the PSTN call TDC
    [Tags]  148728  P1      bvt_cap  sanity_cap        Certification_cap
    [Setup]  Testcase Setup for CAP PSTN User   count=3
    click on calls tab    device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_3
    Verify user name display on call toast   to_device=device_3    from_device=device_1:cap_search_enabled
    Verify Call State    device_list=device_2     state=Connected
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Completes the consultation to accept the call     from_device=device_1      to_device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4 : [Call Park] DUT user to park the PSTN call.
    [Tags]      149442      P1  bvt_cap  sanity_cap
    [Setup]  Testcase Setup for CAP PSTN User   count=2
    click on people tab     device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Wait for Some Time    time=${wait_time}
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Come back to home screen   device_list=device_2
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC5 : [Esc to Conf.] DUT user in P2P call with Teams client, add PSTN user
    [Tags]  148986  P1   bvt_cap     sanity_cap
    [Setup]  Testcase Setup for CAP PSTN User   count=3
    click on people tab     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Mute all participants       device=device_1
    Verify meeting Mute State    device_list=device_3     state=mute
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC6 : [Esc to Conf.] DUT user in call with PSTN user, add PSTN user
    [Tags]  149938  P1
    [Setup]  Testcase Setup for CAP 2 PSTN User   count=3
    click on people tab   device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_3:pstn_user
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC7 : [Esc to Conf.] DUT user in P2P call with another DUT user, add PSTN user to call
    [Tags]  148991    P2     sanity_cap
    [Setup]  Testcase Setup for CAP PSTN User   count=3
    click on people tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Verify participant list     from_device=device_1      connected_device_list=device_1:cap_search_enabled,device_2:pstn_user,device_3
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC8 : [Esc to Conf.] DUT user to add Teams client again to the call
    [Tags]  148996    P2     sanity_cap
    [Setup]  Testcase Setup for CAP PSTN User     count=3
    click on people tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Verify participant list     from_device=device_1      connected_device_list=device_1:cap_search_enabled,device_2:pstn_user,device_3
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2     state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Verify participant list     from_device=device_1      connected_device_list=device_1:cap_search_enabled,device_2:pstn_user,device_3
    Disconnect call     device=device_1,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=DisConnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC9: [Outgoing Calls] DUT user calls PSTN user from home screen dial pad
    [Tags]  149389  P0  bvt_cap  sanity_cap
    [Setup]  Testcase Setup for CAP PSTN User    count=2
    verify dial pad for cap   device=device_1
    navigate to dial pad tab for cap    device=device_1
    Calling with dailpad   from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC10 : [Multiple calls] DUT user in Multiple calls, Blind Transfer one TDC call to another PSTN user
       [Tags]  149956   P2
       [Setup]  Testcase Setup for CAP 2 PSTN User   count=4
       initiate simultaneous call  devices=device_4,device_3   target_device=device_1:cap_search_enabled    method=phone_number
       verify multiple incoming calls  device=device_1
       accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept        transfer_method=Blind   from_device=device_1   to_device=device_2:pstn_user     method=phone_number
       Pick incoming call   device=device_2
       Resume the call   device=device_1
       Disconnect Call  device=device_1,device_2
       Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Disconnected
       [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4

TC11 : [Multiple calls] DUT user in Multiple calls, Blind Transfer PSTN call to another PSTN user
       [Tags]  149957   P2
       [Setup]  Testcase Setup for CAP 2 PSTN User   count=4
       initiate simultaneous call  devices=device_2,device_4   target_device=device_1:cap_search_enabled    method=phone_number
       verify multiple incoming calls  device=device_1
       accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept        transfer_method=Blind   from_device=device_1   to_device=device_3:pstn_user     method=phone_number
       Pick incoming call   device=device_3
       Resume the call   device=device_1
       Disconnect Call  device=device_1,device_3
       Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Disconnected
       [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4

TC12 : [Call Merge] Verify that DUT user is able to Merge two PSTN calls
    [Tags]   318457     p2
    [Setup]  Testcase Setup for CAP 2 PSTN User  count=3
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify and merge call      device=device_1     from_device=device_2:pstn_user
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    disconnect call        device=device_1,device_2
    Verify Call State           device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords   Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC13 : [Incoming Calls] DUT displays the phone number of PSTN user
    [Tags]   148696     P1     sanity_cap
    [Setup]   Testcase Setup for CAP PSTN User    count=2
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    verify pstn display number on incoming call UI    from_device=device_1   to_device=device_2:pstn_user
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2

TC14: [Call Merge] Verify an active call with another DUT user can be merged into an MoH call.
   [Tags]   318522     P2
   [Setup]    Testcase Setup for CAP PSTN User    count=3
   click on calls tab     device=device_2
   Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
   Pick incoming call    device=device_1
   verify call state      device_list=device_1,device_2      state=Connected
   Hold the call   device=device_1
   Verify Call State    device_list=device_1     state=Hold
   click on calls tab     device=device_3
   Make outgoing call using display name    from_device=device_3     to_device=device_1:cap_search_enabled
   Pick incoming call   device=device_1
   verify call state   device_list=device_1,device_3    state=Connected
   #verify call state    device_list=device_2     state=Hold
   Verify and merge call  device=device_1    from_device=device_2:pstn_user
   Verify call state   device_list=device_1,device_2,device_3    state=Connected
   disconnect call       device=device_1,device_2
   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    devices=device_1,device_2,device_3


TC15: [Call Merge] Verify an user should be able to merge PSTN call with another DUT user, another DUT's call is on hold
   [Tags]  318523    P2
   [Setup]    Testcase Setup for CAP PSTN User    count=3
   click on people tab    device=device_1
   Make outgoing call using phonenumber    from_device=device_1      to_device=device_3
   Pick incoming call    device=device_3
   verify call state      device_list=device_1,device_3      state=Connected
   click on calls tab     device=device_2
   Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
   Pick incoming call    device=device_1
   verify call state   device_list=device_1,device_2    state=Connected
   verify call state    device_list=device_3     state=Hold
   Verify and merge call  device=device_1    from_device=device_3
   Verify call state   device_list=device_1,device_2,device_3    state=Connected
   disconnect call       device=device_1,device_2
   Verify Call State     device_list=device_1,device_2,device_3     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen     devices=device_1,device_2,device_3

TC16 : Verify DUT user is not able to get the call from PSTN user
     [Tags]    416723    P1  sanity_cap
     [Setup]  Testcase Setup for CAP PSTN User   count=2
     verify hotline option       device=device_1
     configure contact number in hotline     device=device_1       configured_user=device_2:pstn_user
     verify hotline homescreen UI    device=device_1
     click on calls tab     device=device_2
     Make outgoing call using phonenumber   from_device=device_2     to_device=device_1:cap_search_enabled
     verify any incoming call disappeared    device=device_2
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2    AND   Disable Hotline    device=device_1

TC17 : Verify DUT user not able to initiates the call to PSTN user
     [Tags]    416751     P1   sanity_cap
     [Setup]  Testcase Setup for CAP PSTN User    count=2
     verify hotline option       device=device_1
     configure contact number in hotline     device=device_1       configured_user=device_2:pstn_user
     verify hotline homescreen UI    device=device_1
     verify user can not call to anyone when hotline is enabled       device=device_1
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2    AND   Disable Hotline    device=device_1

TC18 : DUT user able to receive the voicemail from the PSTN user by tapping on Send to voicemail option in Incoming call UI
    [Tags]      452855      sanity_cap      bvt_cap           phonesCY23_4
    [Setup]  Testcase Setup for CAP PSTN User    count=2
    click on calls tab  device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    verify incoming call        device=device_1         status=appear
    verify and click send to voicemail option for incoming call          device=device_1
    Verify Call State    device_list=device_2    state=Connected
    Verify Call State    device_list=device_1    state=disconnected
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2

TC19 : [Call forward on home screen] Verify that DUT user call should be forwarded to PSTN user, When DUT user selects Forward to contact or number from the Call forwarding section on home screen.
    [Tags]      452440      P1    sanity_cap    phonesCY23_4
    [Setup]  Testcase Setup for CAP PSTN User    count=3
    verify and set call forwarding on home screen     device=device_1         option=contact_or_number        to_device=device_2:pstn_user
    click on calls tab  device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1:cap_search_enabled
    Verify Incoming call    device=device_1     status=disappear
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure      AND        dismiss call forwarding pop up on home screen       device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3       AND     verify and set call forwarding on home screen     device=device_1         option=off

*** Keywords ***

Disable Hotline
       [Arguments]     ${device}
       disable hotline option from home screen      ${device}

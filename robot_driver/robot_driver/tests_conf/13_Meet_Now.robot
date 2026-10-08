*** Settings ***
Resource    ../resources/keywords/common.robot

#Suite Setup     Meet Now Setup
Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10


*** Test Cases ***
TC1 : [Meet now] Meet now icon should be present on Calendar tab after Sign-in
    [Tags]    306156
    [Setup]   Testcase Setup for Meeting User    count=1
    Navigate to Calendar tab   device=device_1
    Verify meet now icon    device=device_1
    [Teardown]   Capture on Failure

TC2 : [Meet now] Start Meet now, invite participants to Conference call
    [Tags]    306164    bvt_tpc  sanity_tpc  P0
    [Setup]   Testcase Setup for Meeting User    count=1
    Navigate to Calendar tab   device=device_1
    Verify meet now icon    device=device_1
    Tap on Meet Now icon and validate   device=device_1
    [Teardown]    run keywords   Capture on Failure     AND     Close meet now conference page    device=device_1

TC3 : [Meet now] DUT user adds TDC user as participant, mute and unmutes during call
    [Tags]    306170    bvt_tpc  sanity_tpc  P0
    [Setup]   Testcase Setup for Meeting User   count=2
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_1
    Mutes the meeting     device=device_1
    Verify meeting Mute State    device_list=device_1    state=mute
    Unmutes the meeting    device=device_1
    Verify meeting Mute State    device_list=device_1    state=Unmute
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1,device_2

TC4 : [Meet now] DUT user able to raise/lower hand in the meeting
    [Tags]   306180  sanity_tpc  P1
    [Setup]   Testcase Setup for Meeting User       count=3
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3
    pick incoming call    device=device_2,device_3
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Raise hand     device=device_1
    Lower hand     device=device_1
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3

TC5 : [Meet now] Verify DUT user is able to view the Live caption during meeting
    [Tags]   306183  sanity_tpc  p1
    [Setup]   Testcase Setup for Meeting User       count=3
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3
    pick incoming call    device=device_2,device_3
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Turn on Live caption     device=device_1
    Wait for Some Time    time=${wait_time}
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3

TC6 : [Meet now] DUT user invites TDC user into meeting using DID number
    [Tags]   306186  sanity_tpc  P1
    [Setup]   Testcase Setup for Meeting User     count=2
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using phonenumber    from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button    device=device_1    AND   Come back to home screen    device_list=device_1,device_2

TC7 : [Meet now] Verify mic ON/OFF on meeting pre join screen In Meet now
    [Tags]   320131   p2
    [Setup]   Testcase Setup for Meeting User     count=1
    Navigate to Calendar tab   device=device_1
    verify meet now icon     device=device_1
    Tap on Meet Now icon and validate   device=device_1
    verify default mic and speaker state in meet now prejoin screen    device=device_1
    verify mic in meet now prejoin screen     device=device_1  mic=enable
    verify mic in meet now prejoin screen     device=device_1  mic=disable
    close meet now conference page    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND  Come back to home screen    device_list=device_1

TC8 : [Meet now] Verify speaker on pre-join screen at Meet now
    [Tags]   320140   p2
    [Setup]   Testcase Setup for Meeting User     count=1
    Navigate to Calendar tab   device=device_1
    verify meet now icon     device=device_1
    Tap on Meet Now icon and validate   device=device_1
    verify default mic and speaker state in meet now prejoin screen    device=device_1
    verify speaker in meet now prejoin screen     device=device_1   speaker=disable
    verify speaker in meet now prejoin screen     device=device_1   speaker=enable
    close meet now conference page    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND  Come back to home screen    device_list=device_1

TC9 : [Meet now] Verify mute/unmute at Meet now
    [Tags]  321079  p2
    [Setup]   Testcase Setup for Meeting User     count=1
    Navigate to Calendar tab   device=device_1
    verify meet now icon     device=device_1
    Tap on Meet Now icon and validate   device=device_1
    verify mic in meet now prejoin screen     device=device_1  mic=enable
    verify mic in meet now prejoin screen     device=device_1  mic=disable
    close meet now conference page    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND  Come back to home screen    device_list=device_1

TC10 : [Meet now] DUT user adds more participants to conference call and disconnecting the meeting by clicking on the red button
    [Tags]   306187    p2
    [Setup]   Testcase Setup for Meeting User     count=2
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name    from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Add participant to conversation using display name     from_device=device_1    to_device=device_3
    pick incoming call    device=device_3
    Verify meeting state   device_list=device_1,device_2,device_3     state=Connected
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND  Come back to home screen    device_list=device_1,device_2,device_3

TC11 : [Meet now] Start Meet now and Far mute Participant in Conference call
    [Tags]       306189
    [Setup]   Testcase Setup for Meeting User     count=2
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name    from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    farmute the call       from_device=device_1       to_device=device_2
    Verify meeting Mute State    device_list=device_2    state=Mute
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND     Come back to home screen    device_list=device_1,device_2

TC12 : [Meet now] Start Meet now and mute all Participants in Conference
   [Tags]       306173
   [Setup]   Testcase Setup for Meeting User     count=3
   Navigate to Calendar tab   device=device_1
   Tap on Meet Now icon and validate   device=device_1
   Initiated a conference call from Meet now    device=device_1
   Wait for Some Time    time=${wait_time}
   Verify meeting state   device_list=device_1    state=Connected
   verify add participant button should visible for presenter   device=device_1
   Add participant to conversation using display name  from_device=device_1      to_device=device_2,device_3
   pick incoming call    device=device_2,device_3
   Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
   Mute all participants       device=device_1
   Verify meeting Mute State    device_list=device_2,device_3    state=Mute
   End meeting     device=device_1,device_2,device_3
   Verify meeting state    device_list=device_1,device_2    state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND     Come back to home screen    device_list=device_1,device_2,device_3

TC13 : [Meet now] DUT user joins the meeting scheduled with default title
   [Tags]     306178
   [Setup]   Testcase Setup for Meeting User     count=2
   Navigate to Calendar tab   device=device_1
   Tap on Meet Now icon and validate   device=device_1
   Initiated a conference call from Meet now    device=device_1
   Wait for Some Time    time=${wait_time}
   Verify meeting state   device_list=device_1    state=Connected
   Add participant to conversation using display name    from_device=device_1      to_device=device_2
   pick incoming call    device=device_2
   Verify meeting state   device_list=device_1,device_2    state=Connected
   End meeting     device=device_1,device_2
   Verify meeting state    device_list=device_1,device_2   state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND  Come back to home screen    device_list=device_1,device_2

TC14 : [Meet now] TDC user invites DUT user into meeting using DID number
    [Tags]     306167
    [Setup]   Testcase Setup for Meeting User     count=2
    Navigate to Calendar tab   device=device_2
    Tap on Meet Now icon and validate   device=device_2
    Initiated a conference call from Meet now    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_2    state=Connected
    Add participant to conversation using phonenumber    from_device=device_2      to_device=device_1:meeting_user
    pick incoming call    device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button    device=device_1   AND     Come back to home screen    device_list=device_1,device_2

TC15 : [Meet now] DUT user can check more options during meeting
   [Tags]        306179
   [Setup]   Testcase Setup for Meeting User    count=4
   Navigate to Calendar tab   device=device_1
   Tap on Meet Now icon and validate   device=device_1
   Initiated a conference call from Meet now    device=device_1
   Wait for Some Time    time=${wait_time}
   Verify meeting state   device_list=device_1    state=Connected
   Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3,device_4
   pick incoming call    device=device_2,device_3,device_4
   Verify meeting state   device_list=device_1,device_2,device_3,device_4    state=Connected
   Verify meeting more options     device=device_1:meeting_user
   End meeting     device=device_1,device_2,device_3
   Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
   [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC16 :[Meet now] Start Meet now, Verify mute UI on DUT in meeting
    [Tags]          306172
    [Setup]   Testcase Setup for Meeting User     count=2
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name    from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    farmute the call       from_device=device_1       to_device=device_2
    Verify meeting Mute State    device_list=device_2    state=Mute
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND     Come back to home screen    device_list=device_1,device_2

TC17 :[Meet now] DUT 1 user invites another DUT 2 user into meeting using DID number
    [Tags]   306168   p2
    [Setup]   Testcase Setup for Meeting User     count=3
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    verify add participant button should visible for presenter   device=device_1
    Add participant to conversation using phonenumber    from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_3
    pick incoming call    device=device_3
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button   device=device_1   AND     Come back to home screen    device_list=device_1,device_2,device_3

TC18 : [Meet now] Ending the conference call should redirect DUT user to Homescreen
    [Tags]   306175   p2
    [Setup]   Testcase Setup for Meeting User     count=4
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name    from_device=device_1      to_device=device_2,device_3,device_4
    pick incoming call    device=device_2,device_3,device_4
    Verify meeting state   device_list=device_1,device_2,device_3,device_4    state=Connected
    End meeting     device=device_1
    Verify meeting state    device_list=device_1    state=Disconnected
    verify home screen for cnf device   device=device_1
   [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC19 : [Meet now] Verify DUT user is able to on and off the Live caption during the meeting
    [Tags]   306177   p2
    [Setup]   Testcase Setup for Meeting User     count=3
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name    from_device=device_1      to_device=device_2,device_3
    pick incoming call    device=device_2,device_3
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    turn on live caption     device=device_1
    Wait for Some Time    time=${wait_time}
    turn off live caption     device=device_1
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC20 : [Meet now] Participant count updates, when organizer adds the participant after meeting is started.
    [Tags]   306184   p2
    [Setup]   Testcase Setup for Meeting User     count=3
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name    from_device=device_1      to_device=device_2,device_3
    pick incoming call    device=device_2,device_3
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Get participant count     from_device=device_1    connected_device_list=device_1:meeting_user,device_2,device_3
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button  device=device_1   AND  Come back to home screen   device_list=device_1,device_2,device_3

*** Keywords ***
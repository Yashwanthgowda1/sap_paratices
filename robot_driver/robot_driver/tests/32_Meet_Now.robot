*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10


*** Test Cases ***
TC1 : [Meet now] Meet now icon should be present on Calendar tab after Sign-in
    [Tags]    310486                alt_credentials
    [Setup]   Testcase Setup    count=1
    Navigate to Calendar tab   device=device_1
    Verify meet now icon    device=device_1
    [Teardown]   Capture on Failure

TC2 :[Meet now] DUT user adds TDC user as participant , mute and unmutes during call
    [Tags]    310570     sanity_tp        bvt_pr         alt_bug
    [Setup]   Testcase Setup    count=2
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Mutes the meeting     device=device_1
    Verify meeting Mute State    device_list=device_1    state=mute
    Unmutes the meeting    device=device_1
    Verify meeting Mute State    device_list=device_1    state=Unmute
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1,device_2

TC3 : [Meet now] Verify the UI after initiating the meet now from calendar tab.
    [Tags]   453045    P2
    [Setup]   Testcase Setup    count=1
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Verify meeting more options     device=device_1
    verify manage audio and video option    device=device_1     count=1    role=presenter
    End meeting     device=device_1
    Verify meeting state    device_list=device_1  state=Disconnected
    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1

TC4 : [Meet now] Start Meet now, Increase and decrease volume after participants are added
    [Tags]    310516    
    [Setup]   Testcase Setup    count=2
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Volume up using keyevent    device=device_1
    Volume up using keyevent    device=device_1
    Volume down using keyevent    device=device_1
    Volume down using keyevent    device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1,device_2

TC5 : [Meet now] Start Meet now, Remove Participants from Conference call
    [Tags]    310522    p2  alt_bug
    [Setup]   Testcase Setup    count=2
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Remove user from meeting    from_device=device_1      to_device=device_2
#    Commenting the step until the feature is implememnted. Bug for tracking: 2574364
#    Verify someone removed you from the meeting text    device=device_2
    click back btn  device=device_1
    Verify meeting state    device_list=device_2   state=Disconnected
    Verify meeting state   device_list=device_1   state=Connected
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1,device_2

TC6 : [Meet now] TDC user invites DUT user into meeting using DID number
    [Tags]       310539    sanity_tp
    [Setup]   Testcase Setup    count=2
    Navigate to Calendar tab   device=device_2
    Tap on Meet Now icon and validate   device=device_2
    Initiated a conference call from Meet now    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_2    state=Connected
    Add participant to conversation using phonenumber   from_device=device_2      to_device=device_1
    pick incoming call    device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button    device=device_1    AND   Come back to home screen    device_list=device_1,device_2

TC7 : [Meet now] DUT1 user invites another DUT 2 user into meeting using DID number
    [Tags]   310561   P2  alt_blocked
    [Setup]   Testcase Setup    count=3
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_3
    pick incoming call    device=device_3
    Verify meeting state   device_list=device_1,device_3    state=Connected
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button    device=device_1    AND   Come back to home screen    device_list=device_1,device_2,device_3

TC8 : [Meet now] Start Meet now, Verify mute UI on DUT
    [Tags]    310576    p2  alt_bug
    [Setup]   Testcase Setup    count=3
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3
    pick incoming call    device=device_2,device_3
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Mute all participants       device=device_1
    Verify meeting Mute State    device_list=device_2,device_3    state=Mute
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3

TC9 : [Meet now] Start Meet now and mute all Participants in Conference call
    [Tags]    310595    p2  alt_bug
    [Setup]   Testcase Setup    count=3
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3
    pick incoming call    device=device_2,device_3
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Mute all participants       device=device_1
    Verify meeting Mute State    device_list=device_2,device_3    state=Mute
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3

TC10 : [Meet now] TDC to reject the meeting invite call from DUT user
    [Tags]    310605    p2
    [Setup]   Testcase Setup    count=2
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_2
    Rejects the incoming call    device_list=device_2
    Verify meeting state   device_list=device_2    state=Disconnected
    Verify meeting state   device_list=device_1    state=Connected
    End meeting     device=device_1
    Verify meeting state   device_list=device_1    state=Disconnected
    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1,device_2

TC11 : [Meet now] Verify DUT user is able to on and off the Live caption during the meeting
    [Tags]    310610    p2  alt_bug
    [Setup]   Testcase Setup    count=1
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Turn on Live caption     device=device_1
    Wait for Some Time    time=${wait_time}
    Turn off Live caption     device=device_1
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1

TC12 : [Meet now]DUT user joins the meeting scheduled with default title
    [Tags]    310616    p2
    [Setup]   Testcase Setup    count=1
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Verify user joined meeting without any title     device=device_1
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1

TC13 : [Meet now] DUT user able to raise /lower hand in the meeting
    [Tags]    310624    sanity_tp    p1
    [Setup]   Testcase Setup    count=3
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

TC14 : [Meet now] Verify DUT user is able to view Participant count updates and the Live caption when organizer adds the participant after meeting is started.
    [Tags]    310631    p2  alt_blocked
    [Setup]   Testcase Setup    count=4
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    ${participant_count_before_adding}     Get participant count     from_device=device_1      connected_device_list=device_1
    Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3,device_4
    pick incoming call    device=device_2,device_3,device_4
    Verify meeting state   device_list=device_1,device_2,device_3,device_4    state=Connected
    ${participant_count_after_adding}      Get participant count     from_device=device_1      connected_device_list=device_1,device_2,device_3,device_4
    run keyword if  ${participant_count_before_adding}+3 == ${participant_count_after_adding}    Log   Participant count got increased
    ...   ELSE   fail   Participant count didn't increased.
    End meeting     device=device_1,device_2,device_3,device_4
    Verify meeting state    device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC15 : [Meet now] DUT user adds more participants to conference call and disconnecting the meeting by clicking on the End Call button
    [Tags]   310658    P2  alt_bug
    [Setup]   Testcase Setup    count=3
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_3
    pick incoming call    device=device_3
    Verify meeting state   device_list=device_1,device_3    state=Connected
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button    device=device_1    AND   Come back to home screen    device_list=device_1,device_2,device_3

TC16 : [Meet now] Start Meet now and Far mute Participants in Conference call
    [Tags]   310667    P2
    [Setup]   Testcase Setup    count=2
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    #Unmutes the meeting    device=device_2
    Farmute the call    from_device=device_1      to_device=device_2
    Verify meeting Mute State    device_list=device_2    state=mute
    Unmutes the meeting    device=device_2
    Verify meeting Mute State    device_list=device_2    state=Unmute
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2  state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND     Verify meet now close button    device=device_1    AND   Come back to home screen    device_list=device_1,device_2

TC17 : [Meet now] Start Meet now should display New meeting title, Mic is off, Device and join now options on the screen.
    [Tags]    310644    p1
    [Setup]   Testcase Setup    count=1
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Verify meeting state   device_list=device_1    state=Connected
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND   Come back to home screen    device_list=device_1

TC18 : [Meet now] Verify mute/unmute at Meet now
    [Tags]    321013    p2
    [Setup]   Testcase Setup    count=1
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    verify mute and unmute button in meet now      device=device_1
    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND   Come back to home screen    device_list=device_1

TC19 : [Meet now] Verify speaker on pre-join screen at Meet now
    [Tags]    320136    p2
    [Setup]   Testcase Setup    count=1
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    verify speaker in meet now prejoin screen     device=device_1   speaker=disable
    verify speaker in meet now prejoin screen     device=device_1   speaker=enable
    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND   Come back to home screen    device_list=device_1

TC20 : [Meet now] Verify DUT user can share reactions and see reactions shared by others in meeting initiated from Meet now
    [Tags]    320193    p2
    [Setup]   Testcase Setup    count=4
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3,device_4
    pick incoming call    device=device_2
    pick incoming call    device=device_3
    pick incoming call    device=device_4
    Verify meeting state   device_list=device_1,device_2,device_3,device_4    state=Connected
    Raise hand     device=device_1
    Verify raise hand    from_device=device_1   to_device=device_2    status=on
    Verify raise hand    from_device=device_1   to_device=device_3    status=on
    Verify raise hand    from_device=device_1   to_device=device_4    status=on
    Tap on like button     device=device_1
    Tap on like button     device=device_2
    end meeting  device=device_1,device_2,device_3,device_4
    Verify meeting state   device_list=device_1,device_2,device_3,device_4    state=disconnected
    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND   Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC21 : [Meet now] Start Meet now and add/remove participant in the meeting
    [Tags]    310493    bvt_tp   sanity_tp      
    [Setup]   Testcase Setup    count=4
    Navigate to Calendar tab   device=device_1
    Tap on Meet Now icon and validate   device=device_1
    Initiated a conference call from Meet now    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_3,device_4
    pick incoming call    device=device_3,device_4
    Verify meeting state   device_list=device_1,device_3,device_4    state=Connected
    Remove user from meeting    from_device=device_1      to_device=device_4
    click back btn  device=device_1
    Verify meeting state    device_list=device_4   state=Disconnected
    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3,device_4   state=Disconnected
    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND     Come back to home screen    device_list=device_1,device_2

TC22 : [Meet now] DUT user invites TDC user into meeting using DID number
    [Tags]       310655
    [Setup]   Testcase Setup    count=2
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

# Hold/Resume feature is not available in meetings
#TC3 : [Meet now] Teams App user adds TDC user as participant, holds and resumes during call
#    [Tags]    224358    bvt       
#    [Setup]   Testcase Setup    count=2
#    Navigate to Calendar tab   device=device_1
#    Tap on Meet Now icon and validate   device=device_1
#    Initiated a conference call from Meet now    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_2
#    pick incoming call    device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Hold the meeting   device=device_1
#    Verify meeting state    device_list=device_2     state=Hold
#    Resume the call   device=device_1
#    Verify meeting state    device_list=device_1,device_2     state=Resume
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2    state=Disconnected
#    [Teardown]    run keywords   Capture on Failure     AND     Verify meet now close button    device=device_1    AND   Come back to home screen    device_list=device_1,device_2

*** Keywords ***
Meet Now Setup
    Navigate to Calendar tab   device=device_1
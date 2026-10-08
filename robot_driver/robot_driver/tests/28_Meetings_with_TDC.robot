*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation    Suite Setup Requirements : This suite requires minimum of 3 devices in config
...              Purpose: Device_2 should create and add Device_1 & Device_3 as participants

Suite Setup     Meeting Suite Setup
Suite Teardown    Run keyword and ignore error    Meeting Suite Teardown

*** Variables ***
${wait_time} =  10
${wait_time30sec} =  30

*** Test Cases ***
TC1 : [Meetings] Start Recording an ongoing meeting
    [Tags]  318701   P2
    [Setup]  Testcase Setup    count=2
    Join Meeting    device=device_1,device_2     meeting=test_meeting1
    Verify meeting state    device_list=device_1,device_2   state=connected
    verify meeting more options     device=device_2
    start recording call    device=device_2
    verify recording notification on screen     device=device_2
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2

TC2 : [Meetings] Validate the options of the current user from the meeting details page
    [Tags]   320278   p2
    [Setup]  Testcase Setup    count=3
    Join Meeting    device=device_1,device_2,device_3     meeting=test_meeting1
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    verify presenter options in meeting from organizer or presenter     from_device=device_1     to_device=device_1         check_presenter_options_from_presenter=on
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3

TC3 : [Meeting]Verify that DUT user in a meeting and receive a call
    [Tags]   338880   p2
    [Setup]  Testcase Setup    count=3
    Join Meeting    device=device_1,device_2     meeting=test_meeting1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    click on calls tab      device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_3
    resume call from call hold banner   device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3

TC4 :[Meeting] After Selecting Audio off, DUT user should be able to get the pop - up notification.
    [Tags]   402607   p2
    [Setup]  Testcase Setup    count=2
    Join Meeting    device=device_1,device_2     meeting=test_meeting1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify switch audio route options in meeting UI     device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2

TC5 :[Walkie-talkie]Verify Paging should not work when user is on a meeting
    [Tags]   320232   p2
    [Setup]  Testcase Setup    count=1
    Join Meeting    device=device_1     meeting=test_meeting1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    click back  device=device_1
    navigate to walkie talkie tab  device=device_1
    select the channel  device=device_1     channel=Channel_1
    click on connect and verify mic  device=device_1
    verify user can not use the walikie talkie app error message while in a call or meeting         device=device_1
    tap to return to meeting    device=device_1
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1

TC6 :[HID_Call Control] Mute/Unmute in a conference /P2P call using hard mute button
    [Tags]      306848            Certification_audio       
    [Setup]    Testcase Setup   count=3
    ${mute_button}   Has Hardkey Call Mute Button Present  device=device_1
    pass execution if   '${mute_button}'=='False'  device_1, device is not have mute button
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Unmutes the phone call  device=device_1
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    Wait for Some Time    time=${wait_time}
    Verify meeting Mute State    device_list=device_1    state=mute
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    Wait for Some Time    time=${wait_time}
    Verify meeting Mute State    device_list=device_1    state=Unmute
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Join Meeting    device=device_1,device_2,device_3     meeting=test_meeting1
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Unmutes the phone call  device=device_1
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    Wait for Some Time    time=${wait_time}
    Verify meeting Mute State    device_list=device_1    state=mute
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    Wait for Some Time    time=${wait_time}
    Verify meeting Mute State    device_list=device_1    state=Unmute
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC7 :[HID_Call Control] Mute/Unmute button sync with DUT in a conference/P2P call
    [Tags]      306849            Certification_audio       
    [Setup]    Testcase Setup   count=3
    ${mute_button}   Has Hardkey Call Mute Button Present  device=device_1
    pass execution if   '${mute_button}'=='False'  device_1, device is not have mute button
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Unmutes the phone call  device=device_1
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    Wait for Some Time    time=${wait_time}
    Verify meeting Mute State    device_list=device_1    state=mute
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    Wait for Some Time    time=${wait_time}
    Verify meeting Mute State    device_list=device_1    state=Unmute
    mutes the phone call  device=device_1
    Verify meeting Mute State    device_list=device_1    state=mute
    Wait for Some Time    time=${wait_time}
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    Wait for Some Time    time=${wait_time}
    Verify meeting Mute State    device_list=device_1    state=Unmute
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Join Meeting    device=device_1,device_2,device_3     meeting=test_meeting1
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Unmutes the phone call  device=device_1
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    Wait for Some Time    time=${wait_time}
    Verify meeting Mute State    device_list=device_1    state=mute
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    Wait for Some Time    time=${wait_time}
    Verify meeting Mute State    device_list=device_1    state=Unmute
    mutes the phone call  device=device_1
    Verify meeting Mute State    device_list=device_1    state=mute
    Wait for Some Time    time=${wait_time}
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_MUTE
    Wait for Some Time    time=${wait_time}
    Verify meeting Mute State    device_list=device_1    state=Unmute
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC8 : [Calendar] Participant on DUT can accept the meeting scheduled by TDC
    [Tags]  307091   P1  alt_bug        Certification_audio
    [Setup]  Testcase Setup    count=1
    Navigate to Calendar tab   device=device_1
    Refresh for Meeting Visibility      device=device_1
    Select Meeting      device=device_1    meeting=test_meeting1
    Check rsvp status   device=device_1
    Respond to meeting     device=device_1     respond_option=Accept
    Verify meeting response     device=device_1     respond_option=accept
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1

TC9:[Calendar] Verify Join option for Teams Meeting scheduled and Mute/unmute & verify hold option
    [Tags]    306769   P0      sanity_tp       bvt_tp
    [Setup]  Testcase Setup    count=3
    Join Meeting    device=device_1,device_2,device_3    meeting=test_meeting1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Mutes the meeting     device=device_1
    Verify meeting Mute State    device_list=device_1    state=mute
    Unmutes the meeting    device=device_1
    Verify meeting Mute State    device_list=device_1    state=Unmute
    verify hold option is absent in meeting    device=device_1
    Mute all participants       device=device_1
    Verify meeting Mute State    device_list=device_2,device_3    state=Mute
    Unmutes the meeting     device=device_2
    Verify meeting Mute State    device_list=device_2    state=unmute
    End meeting     device=device_1,device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen     device_list=device_1,device_2,device_3

TC10: [Volume] DUT user to control the Volume from Hard Button during a meeting
    [Tags]    317992    certification_audio        sanity_tp
    [Setup]   Testcase Setup    count=3
    Join Meeting    device=device_1,device_2,device_3     meeting=test_meeting1
    Verify meeting state    device_list=device_1,device_2,device_3   state=connected
    increase volume and verify    device=device_1    volume_stream=calling
    decrease volume and verify    device=device_1    volume_stream=calling
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3

TC11 : [Calendar] Only online meetings should show join button in meeting object of Teams App
    [Tags]    307205   P2
    [Setup]    Testcase Setup   count=1
    navigate to calendar tab    device=device_1
    Refresh for Meeting Visibility      device=device_1
    Select Meeting      device=device_1    meeting=test_meeting1
    Verify meeting has join button    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1

TC12 : [Calendar] DUT user to reject the meeting invite call from Teams Desktop client
    [Tags]    307688   P2
    [Setup]  Testcase Setup    count=2
    Join Meeting    device=device_2     meeting=test_meeting1
    Add participant to conversation using display name   from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    Rejects the incoming call    device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2

TC13 : [Calendar] Meeting object on DUT should get updated when user navigates out and returns to the Calendar tab
    [Tags]    307186   P1
    [Setup]  Testcase Setup    count=1
    navigate to calls tab    device=device_1
    Navigate to calendar tab   device=device_1
    Wait until Meeting is Reflected     device=device_1    meeting=test_meeting1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1

TC14 : [Calendar] Participant count updates, when organizer adds the participant after meeting is started.
    [Tags]     309254
    [Setup]  Testcase Setup    count=3
    Join Meeting    device=device_1     meeting=test_meeting1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    ${participant_count_before_adding}     Get participant count     from_device=device_1      connected_device_list=device_1
    Add participant to conversation using display name   from_device=device_1      to_device=device_2,device_3
    pick incoming call    device=device_2,device_3
    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
    ${participant_count_after_adding}      Get participant count     from_device=device_1      connected_device_list=device_1,device_2,device_3
    run keyword if  ${participant_count_before_adding}+2 == ${participant_count_after_adding}    Log   Participant count got increased
    ...   ELSE   fail   Participant count didn't increased.
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3  state=Disconnected
    [Teardown]    run keywords   Capture on Failure     AND     Come back to home screen     device_list=device_1,device_2,device_3

TC11 : [Calendar] TDC user can Far-mute DUT user in conference
    [Tags]    307077
    [Setup]    Testcase Setup    count=3
    ${mute_button}   Has Hardkey Call Mute Button Present  device=device_1
    pass execution if   '${mute_button}'=='False'  device_1, device is not have mute button
    Join Meeting    device=device_1,device_2    meeting=test_meeting1
    Verify Lightweight Meeting Ui    device=device_1    participants=device_2
    Verify Meeting State    device_list=device_1,device_2    state=Connected
    Unmutes The Meeting    device=device_1
    Farmute The Call    from_device=device_2    to_device=device_1
    Verify Meeting Mute State    device_list=device_1    state=mute
    Press Hardkeys    device=device_1    hardkey_intent=KEYCODE_MUTE
    Verify Meeting Mute State    device_list=device_1    state=unmute
    Verify Meeting State    device_list=device_1,device_2    state=connected
    Join Meeting    device=device_3    meeting=test_meeting1
    Verify Meeting State    device_list=device_1,device_2,device_3    state=Connected
    Unmutes The Meeting    device=device_3
    Farmute The Call    from_device=device_1    to_device=device_3
    Verify Meeting Mute State    device_list=device_3    state=mute
    Unmutes The Meeting    device=device_3
    Verify Meeting Mute State    device_list=device_3    state=unmute
    Verify Meeting State    device_list=device_1,device_2,device_3    state=connected
    End Meeting    device=device_1,device_2,device_3
    Verify Meeting State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

#blocked due to below bug: 3467428
#TC16:(VQE)Verify the VQE(Voice quality recording) is disabled after sending feedback (i.e.,meetings)
#    [Tags]      346074    P1        sanity_tp
#    [Setup]  Testcase Setup    count=2
#    verify voice quality recording option under callings settings   device=device_1
#    enable or disable Voice quality recording option  device=device_1       desired_state=on
#    go back to previous page     device=device_1
#    Join Meeting    device=device_1,device_2     meeting=test_meeting1
#    Wait for Some Time    time=${wait_time30sec}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    Come back to home screen    device_list=device_1
#    Report a problem    device=device_1     VQE=on
#    verify voice quality recording option under callings settings   device=device_1
#    verify toggle status for Voice quality is disabled          device=device_1
#    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

# Hold/Resume feature is not available in meetings
#TC14 : [Calendar] Teams App user joins the meeting and do Hold/resume
#    [Tags]  146244    bvt    bvt_pr
#    [Setup]  run keywords  Testcase Setup    count=2    AND     Remove Meeting   devices=device_1,device_2
#    Create Meeting  device=device_1     meeting=hold_and_resume_meeting
#    Wait for Some Time    time=${wait_time}
#    join meeting   device=device_1      meeting=hold_and_resume_meeting
#    Add participant to conversation using display name   from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Hold the meeting   device=device_1
#    Verify Call State    device_list=device_2     state=Hold
#    Resume the call   device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Resume
#    End meeting     device=device_1,device_2
#    [Teardown]  Run Keywords    Capture on Failure  AND    Test Case Teardown     devices=device_1     meeting=hold_and_resume_meeting   count=2


*** Keywords ***
Meeting Suite Setup
    Testcase Setup    count=3
    clear all day meeting and meeting history from calendar   devices=device_1,device_2,device_3
    create meeting   device=device_2    meeting=test_meeting1    participants=device_1,device_3

Meeting Suite Teardown
    Suite Failure Capture
    Teardown meeting test case      devices=device_2
    clear all day meeting and meeting history from calendar   devices=device_1,device_2,device_3

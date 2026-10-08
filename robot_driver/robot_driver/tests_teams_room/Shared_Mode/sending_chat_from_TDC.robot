*** Settings ***
Resource    ../../resources/keywords/common.robot

Suite Setup     Signin user attend call and send the chat from TDC
Suite Teardown    close web driver    tdc_1:user

*** Variables ***
${wait_time} =      10s
${wait_4sec} =  4s
*** Test Cases ***
TC1:[Front Row] Verify Chat on the front row UI.
    [Tags]   380450    sanity_sm       P1
    [Setup]    Testcase Setup for Meeting User      count=1
    Join the meeting
    Join meeting   device=device_1       meeting=lock_meeting
    Verify meeting state   device_list=device_1       state=Connected
    Verify chat on the front row ui     device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=checking for the testing purpose
    Verify messages on chat layers      device=device_1     message=checking for the testing purpose
    Disconnect the call on TDC      device=tdc_1:user
    End meeting      device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1     AND     come back to calendar page on TDC   device=tdc_1:user

TC2:[Front Row] Verify that long press on chat reaction popup should not be appeared.
    [Tags]  380529      P2
    [Setup]    Testcase Setup for Meeting User      count=1
    Join the meeting
    Join meeting   device=device_1       meeting=lock_meeting
    Verify meeting state   device_list=device_1       state=Connected
    change meeting mode     device=device_1    mode=front_row
    verify front row mode      device=device_1
    verify top bar in front row      device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=checking for the testing purpose
    verify should not get the reaction pop up on chat layout    device=device_1
    Disconnect the call on TDC      device=tdc_1:user
    End meeting      device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1     AND     come back to calendar page on TDC       device=tdc_1:user

TC3:[Meetings] DUT user gets meeting recording notification when any participants starts recording the session
    [Tags]     237631      bvt_sm      sanity_sm
    [Setup]    Testcase Setup for Meeting User      count=1
    Join the meeting
    Join meeting   device=device_1       meeting=lock_meeting
    Verify meeting state   device_list=device_1       state=Connected
    Start the recording from TDC    device=tdc_1:user
    Verify start recording notification display on screen   device=device_1
    Disconnect the call on TDC      device=tdc_1:user
    End meeting      device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC4:[Front row] Verify that Tapping on profile of the participants in the chat should not be viewable.
    [Tags]  380530      P2
    [Setup]    Testcase Setup for Meeting User      count=1
    Join the meeting
    Join meeting   device=device_1      meeting=lock_meeting
    Verify meeting state   device_list=device_1       state=Connected
    change meeting mode     device=device_1    mode=front_row
    verify front row mode      device=device_1
    verify top bar in front row      device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=checking for the testing purpose on profile
    verify user should not get any popup while tapping on profile in chat tray      device=device_1
    Disconnect the call on TDC      device=tdc_1:user
    End meeting      device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1     AND     come back to calendar page on TDC       device=tdc_1:user

TC5:[Chat]Verify the chat option in meeting, when user disabled the show meeting chat option is disabled.
    [Tags]     379969    P1     sanity_sm
    [Setup]    Testcase Setup for Meeting User      count=1
    Disable the show meeting chat option     device=device_1
    Join the meeting
    Join meeting   device=device_1       meeting=lock_meeting
    Verify meeting state   device_list=device_1       state=Connected
    verify front row mode after disabeling the chat option      device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=checking for the testing purpose1
    Verify chat bubble message on device    device=device_1     state=on
    Disconnect the call on TDC      device=tdc_1:user
    End meeting      device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Enable the show meeting chat option    device=device_1    AND        Come back to home screen    device_list=device_1

TC6:[Chat] DUT cannot access photos/video/file/link in chat window.
    [Tags]  381903      P2
    [Setup]    Testcase Setup for Meeting User      count=1
    Join the meeting
    Join meeting   device=device_1      meeting=lock_meeting
    Verify meeting state   device_list=device_1       state=Connected
    User should not able to access the link on chat layer in all layouts    device=device_1
    Disconnect the call on TDC      device=tdc_1:user
    End meeting      device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1     AND     come back to calendar page on TDC       device=tdc_1:user

TC7:[Front Row] Verify that DUT user is not able to scroll the chat in front row mode.
    [Tags]  380526      P1      sanity_sm
    [Setup]    Testcase Setup for Meeting User      count=1
    Join the meeting
    Join meeting   device=device_1      meeting=lock_meeting
    Verify meeting state   device_list=device_1       state=Connected
    change meeting mode     device=device_1    mode=front_row
    verify front row mode      device=device_1
    verify top bar in front row      device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=checking for the testing purpose for scrolling
    Verify messages on chat layers      device=device_1     message=checking for the testing purpose for scrolling
    Verify user not able to scroll the chat window      device=device_1
    Disconnect the call on TDC      device=tdc_1:user
    End meeting      device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1     AND     come back to calendar page on TDC       device=tdc_1:user

TC8:[Front Row] Verify that Popup displayed when DUT user clicks on the links shared by the TDC user in the chat.
    [Tags]  380528      P2
    [Setup]    Testcase Setup for Meeting User      count=1
    Join the meeting
    Join meeting   device=device_1      meeting=lock_meeting
    Verify meeting state   device_list=device_1       state=Connected
    change meeting mode     device=device_1    mode=front_row
    verify front row mode      device=device_1
    verify top bar in front row      device=device_1
    Veify user should not get any pop up when clicking the link
    Disconnect the call on TDC      device=tdc_1:user
    End meeting      device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1     AND     come back to calendar page on TDC       device=tdc_1:user

TC9:[Chat Bubbles] Verify chat bubbles appear when a message is sent into a P2P call
    [Tags]    317605    P1      sanity_sm
    [Setup]    Testcase Setup for Meeting User      count=1
    Make the call from TDC
    Accept incoming call    device=device_1
    Verify meeting state   device_list=device_1       state=Connected
    Send the message from chat option in TDC  device=tdc_1:user     message=should show chat bubble
    Verify chat bubble message on device        device=device_1     state=on
    Disconnect call     device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
   [Teardown]   Run Keywords    Capture Failure  AND        Come back to home screen    device_list=device_1      AND     come back to calling page on TDC    device=tdc_1:user

TC10:[Chat Bubbles] Verify that previous messages from an already-running call/meeting do not get displayed
    [Tags]    317655    P2
    [Setup]    Testcase Setup for Meeting User      count=1
    Make the call from TDC
    Accept incoming call    device=device_1
    Verify meeting state   device_list=device_1       state=Connected
    Send the message from chat option in TDC  device=tdc_1:user     message=should not show chat bubble
    verify the previous chat bubble should not visible in call        device=device_1
    Disconnect call     device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
   [Teardown]   Run Keywords    Capture Failure  AND        Come back to home screen    device_list=device_1      AND     come back to calling page on TDC    device=tdc_1:user

TC11:[Chat Bubbles] Verify chat bubbles should appear from the top center of the display during Raise hand and other reactions.
    [Tags]    317607    P1      sanity_sm
    [Setup]    Testcase Setup for Meeting User      count=3
    Join the meeting
    Join meeting   device=device_1,device_3      meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_3       state=Connected
    Send the message from chat option in TDC  device=tdc_1:user     message=should show chat bubble
    Verify chat bubble message on device        device=device_1     state=on
    Verify and select raise hand option     console=device_3
    Verify raise hand notification      device_list=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=show chat bubble
    Verify chat bubble message on device        device=device_1     state=on
    Disconnect the call on TDC      device=tdc_1:user
    End meeting      device=device_1,device_3
    Verify meeting state    device_list=device_1,device_3        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1     AND     come back to calendar page on TDC   device=tdc_1:user

TC12:[Chat bubble] Verify chat bubble appears in Together mode or not
    [Tags]      348051      P2
    [Setup]    Testcase Setup for Meeting User      count=1
    Join the meeting
    Join meeting   device=device_1      meeting=lock_meeting
    Verify meeting state   device_list=device_1     state=Connected
    change meeting mode     device=device_1     mode=together
    verify changed mode   device=device_1       changed_mode=together_mode
    Send the message from chat option in TDC  device=tdc_1:user     message=should show chat bubble
    verify the previous chat bubble should not visible in call        device=device_1
    verify should not show chat bubble in together mode     device=device_1
    Disconnect the call on TDC      device=tdc_1:user
    End meeting      device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1     AND     come back to calendar page on TDC       device=tdc_1:user

TC13:[Chat bubble] Verify chat bubble should not appears in "disabled" mode
    [Tags]     348038        P2
    [Setup]    Testcase Setup for Meeting User      count=1
    Join the meeting
    Join meeting   device=device_1       meeting=lock_meeting
    Verify meeting state   device_list=device_1       state=Connected
    disable chat bubble     device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=checking for the testing purpose1
    Verify chat bubble message on device    device=device_1     state=off
    Disconnect the call on TDC      device=tdc_1:user
    End meeting      device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure      AND        Come back to home screen    device_list=device_1

TC14:[Chat bubble] Verify chat bubble appears in "Front" row or not
    [Tags]     348048     P2
    [Setup]    Testcase Setup for Meeting User      count=1
    Disable the show meeting chat option     device=device_1
    Join the meeting
    Join meeting   device=device_1       meeting=lock_meeting
    Verify meeting state   device_list=device_1       state=Connected
    verify front row mode after disabeling the chat option      device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=checking for the testing purpose1
    Verify chat bubble message on device    device=device_1     state=on
    Disconnect the call on TDC      device=tdc_1:user
    End meeting      device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Enable the show meeting chat option    device=device_1    AND        Come back to home screen    device_list=device_1

TC15:[Chat Bubbles]Verify that bubbles are shown underneath permanent banners (i.e., now recording banner), and that bubbles are displayed regularly once banners are dismissed.
    [Tags]     317661     P2
    [Setup]    Testcase Setup for Meeting User      count=1
    Join the meeting
    Join meeting   device=device_1       meeting=lock_meeting
    Verify meeting state   device_list=device_1       state=Connected
    Start the recording from TDC    device=tdc_1:user
    Verify start recording notification display on screen   device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=should show chat bubble
    Verify chat bubble message on device        device=device_1     state=on
    Disconnect the call on TDC      device=tdc_1:user
    End meeting      device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC16:[Chat Bubbles] Verify that a message is displayed for 4 seconds in a call
    [Tags]     317654    P1
    [Setup]    Testcase Setup for Meeting User      count=1
    Make outgoing call with phonenumber    from_device=device_1     to_device=device_2
    accept incoming calls in tdc    device=tdc_1:user
    Verify meeting state   device_list=device_1       state=Connected
    Send the message from chat option in TDC  device=tdc_1:user     message=should show chat bubble
    Verify chat bubble message on device        device=device_1     state=on
    Wait for Some Time    time=${wait_4sec}
    Verify chat bubble message on device        device=device_1     state=off
    Disconnect the call on TDC      device=tdc_1:user
    Disconnect call     device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
   [Teardown]   Run Keywords    Capture Failure  AND        Come back to home screen    device_list=device_1

TC17:[Chat Bubbles] Verify during a call or meeting click on more options and enable chat bubble then chat bubble should display.
    [Tags]      317648
    [Setup]    Testcase Setup for Meeting User      count=1
    Make outgoing call with phonenumber    from_device=device_1     to_device=device_2
    accept incoming calls in tdc    device=tdc_1:user
    Verify meeting state   device_list=device_1       state=Connected
    verify show chat bubble is enabled default      device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=should show chat bubble
    Verify chat bubble message on device        device=device_1     state=on
    Disconnect call     device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
   [Teardown]   Run Keywords    Capture Failure     AND        Come back to home screen    device_list=device_1

TC18:[Chat Bubbles] Verify that when the attendees have joined the meeting in the conference room, any incoming messages that are sent appear as chat bubbles
    [Tags]      317644      P2
    [Setup]    Testcase Setup for Meeting User      count=1
    Join the meeting
    Join meeting   device=device_1      meeting=lock_meeting
    Verify meeting state   device_list=device_1     state=Connected
    Make an attendee    from_device=device_1       to_device=device_2
    Verify you are an attendee now notification     device=device_2
    Send the message from chat option in TDC  device=tdc_1:user     message=should show chat bubble
    verify the previous chat bubble should not visible in call        device=device_1
    verify should not show chat bubble in together mode     device=device_1
    Disconnect the call on TDC      device=tdc_1:user
    End meeting      device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC19:[Chat Bubbles] Verify chat bubbles appear when a message is sent into an Esc to conference call
    [Tags]      317606     P2
    [Setup]    Testcase Setup for Meeting User      count=3
    Make outgoing call with phonenumber    from_device=device_1     to_device=device_2
    accept incoming calls in tdc    device=tdc_1:user
    Verify meeting state   device_list=device_1       state=Connected
    Make Video call using display name   from_device=device_1      to_device=device_3
    Accept incoming call    device=device_3
    verify show chat bubble is enabled default      device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=should show chat bubble
    Verify chat bubble message on device        device=device_1     state=on
    Disconnect call     device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
   [Teardown]   Run Keywords    Capture Failure     AND        Come back to home screen    device_list=device_1

TC20:[Chat Bubbles] Verify chat bubbles appear when a message is sent to shared account user into P2P/meeting/group call
    [Tags]      317675     P2
     [Setup]  Testcase Setup for Meeting User     count=1
    Initiate the call from TDC    device=tdc_1:user     to_device=device_1:meeting_user,device_3:user
    Accept incoming call      device=device_1,device_3
    Wait for Some Time    time=${wait_4sec}
    Send the message from chat option in TDC  device=tdc_1:user     message=should show chat bubble
    Verify chat bubble message on device        device=device_1     state=on
    Disconnect the call on TDC      device=tdc_1:user
    Disconnect call     device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
   [Teardown]   Run Keywords    Capture Failure     AND        Come back to home screen    device_list=device_1

TC21:[Chat Bubbles] Verify that a message is displayed for 900ms if >3 messages need to be displayed in a call
    [Tags]      317657     P2
    [Setup]    Testcase Setup for Meeting User      count=1
    Make outgoing call with phonenumber    from_device=device_1     to_device=device_2
    accept incoming calls in tdc    device=tdc_1:user
    Verify meeting state   device_list=device_1       state=Connected
    Simulate And Verify Chats For Dut    from_device=tdc_1:user    to_device=device_1     message=should show chat bubble       send_message_batch=3
    Disconnect call     device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
   [Teardown]   Run Keywords    Capture Failure     AND        Come back to home screen    device_list=device_1

TC22:[Chat Bubbles] Verify chat bubbles appear when a message is sent into an adhoc meeting and meet now meeting
    [Tags]      317604      bvt_sm    sanity_sm
    [Setup]    Testcase Setup for Meeting User      count=1
    Join the meeting
    Join meeting   device=device_1      meeting=lock_meeting
    Verify meeting state   device_list=device_1     state=Connected
    Send the message from chat option in TDC  device=tdc_1:user     message=should show chat bubble
    verify the previous chat bubble should not visible in call        device=device_1
    Disconnect the call on TDC      device=tdc_1:user
    End meeting      device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
    Initiates conference meeting using Meet now option     from_device=device_1     to_device=device_2
    accept incoming calls in tdc    device=tdc_1:user
    Close participants screen   device=device_1
    Verify meeting state   device_list=device_1       state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_3
    Accept incoming call      device=device_3
    Close participants screen   device=device_1
    Verify meeting state    device_list=device_1,device_3    state=Connected
    Send the message from chat option in TDC  device=tdc_1:user     message=should show chat bubble
    Verify chat bubble message on device        device=device_1     state=on
    Disconnect the call on TDC      device=tdc_1:user
    Disconnect call     device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
   [Teardown]   Run Keywords    Capture Failure  AND        Come back to home screen    device_list=device_1

TC23:[Chat Bubbles]Verify that up to 3 messages are shown and that queuing/dequeuing and animations behave as expected in a call
    [Tags]      317673     bvt_sm    sanity_sm
    [Setup]    Testcase Setup for Meeting User      count=1
    Make outgoing call with phonenumber    from_device=device_1     to_device=device_2
    accept incoming calls in tdc    device=tdc_1:user
    Verify meeting state   device_list=device_1       state=Connected
    Simulate And Verify Chats For Dut    from_device=tdc_1:user    to_device=device_1     message=should show chat bubble       send_message_batch=3
    Disconnect call     device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
   [Teardown]   Run Keywords    Capture Failure     AND        Come back to home screen    device_list=device_1

TC24:[Chat Bubbles] Verify chat bubble should appear on Gallery, Together and Large Gallery mode.
    [Tags]     317646   P1      sanity_sm
    [Setup]    Testcase Setup for Meeting User      count=2
    Join the meeting
    Join meeting   device=device_1,device_2    meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    change meeting mode     device=device_1     mode=together
    verify changed mode   device=device_1       changed_mode=together_mode
    Send the message from chat option in TDC  device=tdc_1:user     message=should show chat bubble
    verify the previous chat bubble should not visible in call        device=device_1
    change meeting mode     device=device_1     mode=large_gallery
    verify changed mode   device=device_1       changed_mode=large_gallery
    change meeting mode     device=device_1     mode=gallery
    Send the message from chat option in TDC  device=tdc_1:user     message=should show chat bubble
    verify the previous chat bubble should not visible in call        device=device_1
    Disconnect the call on TDC      device=tdc_1:user
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen     device_list=device_1,device_2

TC25:[Chat Bubbles] Verify that chat bubbles will appear when in presenter mode or when sharing whiteboard
    [Tags]    317667     P2
    [Setup]    Testcase Setup for Meeting User      count=1
    Join the meeting
    Join meeting   device=device_1       meeting=lock_meeting
    Verify meeting state   device_list=device_1       state=Connected
    verify whiteboard sharing option under more option   device=device_1
    Wait for Some Time    time=${wait_4sec}
    Check for whiteboard visibility of participants and validate    from_device=device_1    connected_device_list=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=should show chat bubble
    Verify chat bubble message on device        device=device_1     state=on
    Disconnect the call on TDC      device=tdc_1:user
    End meeting      device=device_1
    Verify meeting state    device_list=device_1        state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

*** Keywords ***
Signin user attend call and send the chat from TDC
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user

Join the meeting
    right click on created meeting from tdc     device=tdc_1:user      edit_meeting_name=lock_meeting      click=left
    join_the_meeting_in_TDC     device=tdc_1:user

Disable the show meeting chat option
    [Arguments]       ${device}
    Navigate to app settings page    ${device}
    navigate to meetings option in device settings page      ${device}
    Enable and disable the chat toggle in admin setting     ${device}   state=off
    come back from admin settings page  device_list=${device}

Enable the show meeting chat option
    [Arguments]    ${device}
    Navigate to app settings page    ${device}
    navigate to meetings option in device settings page      ${device}
    Enable and disable the chat toggle in admin setting     ${device}   state=on
    come back from admin settings page  device_list=${device}

verify should not get the reaction pop up on chat layout
    [Arguments]    ${device}
    Verify messages on chat layers      ${device}     message=checking for the testing purpose        action_type=clicking

verify user should not get any popup while tapping on profile in chat tray
    [Arguments]    ${device}
    Verify messages on chat layers      ${device}     message=profile        action_type=clicking

User should not able to access the link on chat layer in all layouts
    [Arguments]       ${device}
    verify meeting chat     console=${device}        action_type=modify
    verify meeting chat toggle on behaviour      device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=link
    Verify messages on chat layers      device=device_1     message=link        action_type=clicking
    Change meeting mode     ${device}    mode=front_row
    Verify front row mode   device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=link
    Verify messages on chat layers      device=device_1     message=link        action_type=clicking

verify chat option after disabeling
    [Arguments]       ${device}
    Verify front row mode after disabeling the chat option      ${device}

Veify user should not get any pop up when clicking the link
    Send the message from chat option in TDC  device=tdc_1:user     message=link
    Verify messages on chat layers      device=device_1     message=link        action_type=clicking

Make the call from TDC
    make outgoing call from TDC      device=tdc_1:user       to_device=device_1:meeting_user

verify the previous chat bubble should not visible in call
    [Arguments]       ${device}
    Wait for Some Time    time=${wait_time}
    Verify chat bubble message on device        ${device}     state=off

verify should not show chat bubble in together mode
    [Arguments]       ${device}
    Verify chat bubble message on device        ${device}     state=off

Initiate the call from TDC
    [Arguments]     ${device}     ${to_device}
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user
    make outgoing call from tdc using number    ${device}     ${to_device}

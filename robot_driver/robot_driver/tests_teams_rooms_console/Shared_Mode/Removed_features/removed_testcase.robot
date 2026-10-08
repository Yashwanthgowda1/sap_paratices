#*** Settings ***
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#*** Variables ***
#*** Test Cases ***
#00_Sign.robot
# Commenting as Premium and Standard License are not in use
#TC13:[Standard] Verify under Teams about page License should be displayed as "Microsoft Teams Standard"
#    [Tags]   345321     P2
#    [Setup]   Testcase Setup for shared User      count=1
#    Verify signin is successful   console_list=console_1     state=Sign in
#    Console sign out method   console=console_1
#    Sign out method    device=device_1
#    Sign in method     device=device_1   user=standard_user
#    Console sign in method     console=console_1    user=standard_user
#    Get device pairing code    device_list=device_1    console_list=console_1     user_list=standard_user
#    Verify signin is successful    console_list=console_1     state=Sign in
#    Navigate to about page    console=console_1
#    Verify user license details in about page    device=console_1       user=standard_user
#    navigate back to more option page    device=console_1
#    Console sign out method   console=console_1
#    Sign out method    device=device_1
#    Sign in method     device=device_1     user=meeting_user
#    [Teardown]  Run Keywords   Capture Failure   AND    console sign in method    console=console_1       user=meeting_user   AND   Get device pairing code    device_list=device_1    console_list=console_1   user_list=meeting_user

#TC14:[Premium] Verify under Teams about page License should be displayed as "Microsoft Teams Premium"
#    [Tags]  345322      P2
#    [Setup]   Testcase Setup for shared User      count=1
#    Verify signin is successful   console_list=console_1     state=Sign in
#    Console sign out method   console=console_1
#    Verify signin is successful    console_list=console_1     state=Sign out
#    Sign out method    device=device_1
#    Sign in method     device=device_1    user=premium_user
#    Console sign in method     console=console_1    user=premium_user
#    Get device pairing code    device_list=device_1    console_list=console_1     user_list=premium_user
#    Verify signin is successful    console_list=console_1     state=Sign in
#    Navigate to about page    console=console_1
#    Verify user license details in about page    device=console_1   user=premium_user
#    navigate back to more option page    device=console_1
#    Console sign out method   console=console_1
#    Sign out method    device=device_1
#    Sign in method     device=device_1     user=meeting_user
#    [Teardown]  Run Keywords   Capture Failure   AND    console sign in method    console=console_1       user=meeting_user   AND   Get device pairing code    device_list=device_1    console_list=console_1   user_list=meeting_user


#06_Meetings.robot

#TC15: [Meetings]Touch Console user raise hand in the meeting
#    [Tags]      315091   P2
#    [Setup]   Testcase Setup for shared User     count=2
#    Join a meeting   console=console_1     device=device_2    meeting=rooms_console_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Verify and view list of participant    console=console_1
#    Verify and select raise hand option   console=console_1
#    Verify raise hand notification   device_list=device_2
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

#TC25: [Meeting] Touch console share the Whiteboard during meeting
#    [Tags]      315166      bvt_sm      sanity_sm
#    [Setup]  Testcase Setup for shared User   count=2
#    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Verify whiteboard sharing option under more option        device=console_1
#    Verify whiteboard visibility for all participants   device_list=device_1:meeting_user,device_2
#    Click on stop whiteboard sharing    console=console_1       device=device_1
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

#07_Meet_Now.robot

#TC8: [Meet now] Start Meet now and Far mute Participants in Conference call
#    [Tags]   315382   P1
#    [Setup]   Testcase Setup for shared User   count=3
#    Start meeting using meet now    from_device=console_1    to_device=device_2
#    Accept incoming call      device=device_2
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Add participant to the conversation using display name   from_device=console_1    to_device=device_3
#    Accept incoming call      device=device_3
#    Verify for meeting state     console_list=console_1      device_list=device_2,device_3     state=Connected
#    Farmute the call and validate    from_device=console_1       to_device=device_2
#    Verify meeting Mute State    device_list=device_2    state=mute
#    Unmutes the meeting    device=device_2
#    Verify meeting Mute State    device_list=device_2    state=Unmute
#    End up call     console=console_1       device=device_2,device_3
#    Verify for call state    console_list=console_1    device_list=device_2,device_3    state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

#TC22:[Meet] [MTRA + Console] Verify the User is able to share whiteboard in meeting using console.
#    [Tags]      344904      P2
#    [Setup]  Testcase Setup for shared User   count=2
#    Verify ad-hoc meeting page     device=device_1     console=console_1
#    End the meeting     console=console_1
#    Verify for call state    console_list=console_1    state=Disconnected
#    Start meeting using meet now   from_device=console_1    to_device=device_2
#    Accept incoming call   device=device_2
#    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
#    Verify and click on white board sharing in call control bar   device=console_1
#    Wait for Some Time    time=${wait_time}
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    End up call     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

#08_Call_Controls.robot
#
#TC19:[Call]DUT user able to raise /lower hand in the Call.
#    [Tags]      444745      sanity_tc_sm   P1
#    [Setup]   Testcase Setup for shared User     count=3
#    Make outgoing call with username using dial pad     from_device=console_1    to_device=device_2,device_3
#    Accept incoming call      device=device_2,device_3
#    Verify for meeting state     console_list=console_1      device_list=device_2,device_3     state=Connected
#    Verify and view list of participant    console=console_1
#    Verify and select raise hand option  console=console_1
#    Verify raised hand notification on another user     device=console_1:meeting_user    from_device=device_3
#    Verify raise hand notification   device_list=device_2
#    Verify and select lower hand option     console=console_1
#    End a meeting      console=console_1      device=device_2
#    Verify for meeting state    console_list=console_1    device_list=device_2,device_3    state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

#TC5:[Call] Start Call, Increase and decrease volume after participants are added
#    [Tags]      468347    P2
#    [Setup]    Testcase Setup for shared User  count=2
#    Make outgoing call using dial pad    from_device=console_1     to_device=device_2
#    Accept incoming call      device=device_2
#    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
#    Verify functionality of volume button    console=console_1   button=UP
#    Verify functionality of volume button    console=console_1   button=Down
#    Disconnect the call      console=console_1
#    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2

#09_Lock_Meeting.robot
#
#TC4: [Lock Meeting] Verify that DUT user should not able to join the meeting when the meeting is locked by TDC user
#     [Tags]     315415   sanity_sm      P1
#     [Setup]  Testcase Setup for shared User      count=3
#     Join meeting       device=device_2,device_3     meeting=console_lock_meeting
#     Verify meeting state   device_list=device_2,device_3    state=Connected
#     Tap on lock meeting   device=device_2
#     Verify that user cannot join the locked meeting     console=console_1      meeting=console_lock_meeting
#     End meeting      device=device_2,device_3
#     Verify meeting state    device_list=device_2,device_3    state=Disconnected
#     [Teardown]   Run Keywords   Capture Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3
#
#
#15_Reactions.robot
#
#TC6 :[Reactions] Touch console user to verify the raise hand feature from reactions window
#    [Tags]  322877      P2
#    [Setup]   Testcase Setup for shared User     count=2
#    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Verify docked ubar       console=console_1
#    Verify reaction buttons in docked ubar       console=console_1
#    Verify and select raise hand option  console=console_1
#    Verify raise hand notification      device_list=device_2
#    verify raise hand reaction  device=console_1
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]  Run Keywords   Capture Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2
#
#TC9 :[Reactions]Extra call control must not be displayed in meeting
#    [Tags]  322886      P2
#    [Setup]   Testcase Setup for shared User     count=2
#    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Verify docked ubar       console=console_1
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]  Run Keywords   Capture Failure   AND    Come back to home screen page   console_list=console_1
#
#
#19_1_Spotlight.robot
#
#TC2 : [Spotlight] Spotlighted should end once the spotlighted user leave the meeting
#    [Tags]  315216      bvt_sm  sanity_sm
#    [Setup]   Testcase Setup for shared User     count=3
#    Join a meeting   console=console_1     device=device_2,device_3    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2,device_3     state=Connected
#    Verify and view list of participant    console=console_1
#    Make a spotlight   from_device=device_2   to_device=device_3
#    verify spotlight text on device   device=device_3   text=spotlight
#    Close participants screen   device=device_2
#    verify spotlight icon on main screen in the meeting    device=device_1
#    End meeting     device=device_3
#    Join Meeting    device=device_3        meeting=console_lock_meeting
#    spotlight icon should not present    device=device_3
#    End a meeting     console=console_1       device=device_2,device_3
#    Verify for meeting state    console_list=console_1      device_list=device_2,device_3      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3
#
#TC3 : [Spotlight] Remove spotlight option should be displayed for spotlighted participant
#    [Tags]      315214    P1        sanity_sm
#    [Setup]   Testcase Setup for shared User     count=3
#    Join a meeting   console=console_1     device=device_2,device_3    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2,device_3     state=Connected
#    Verify and view list of participant    console=console_1
#    Make a spotlight   from_device=device_2   to_device=console_1:meeting_user      device_type=console
#    verify spotlight text on device   device=console_1   text=spotlight
#    Close participants screen   device=device_2
#    Verifying and removing spotlight    device=console_1:meeting_user
#    Verify spotlight icon disable       device=console_1
#    End a meeting     console=console_1       device=device_2,device_3
#    Verify for meeting state    console_list=console_1      device_list=device_2,device_3      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3
#
#TC5 :[Spotlight] User clicking on spotlight icon there should be an option displayed to remove spotlight
#    [Tags]      315226      P1
#    [Setup]   Testcase Setup for shared User     count=3
#    Join a meeting   console=console_1     device=device_2,device_3    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Verify and view list of participant    console=console_1
#    Verify video preview on screen  device=device_1
#    make a spotlight   from_device=device_2   to_device=console_1:meeting_user       device_type=console
#    verify spotlight text on device   device=console_1   text=spotlight
#    Close participants screen   device=device_2
#    Verifying and removing spotlight    device=console_1:meeting_user
#    Verify spotlight icon disable       device=console_1
#    make a spotlight   from_device=device_2   to_device=device_3
#    verify spotlight text on device   device=device_3   text=spotlight
#    Close participants screen   device=device_2
#    verify spotlight icon    device=console_1
#    End a meeting     console=console_1       device=device_2,device_3
#    Verify for meeting state    console_list=console_1      device_list=device_2,device_3      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3
#
#TC6 :[Spotlight] TDC user spotlight the remote participant during meeting
#    [Tags]      315220      P2
#    [Setup]   Testcase Setup for shared User     count=3
#    Join a meeting   console=console_1     device=device_2,device_3    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Verify and view list of participant    console=console_1
#    Verify video preview on screen  device=device_1
#    make a spotlight   from_device=device_2   to_device=console_1:meeting_user       device_type=console
#    verify spotlight text on device   device=console_1   text=spotlight
#    Close participants screen   device=device_2
#    Verify spotlight icon on top left in the meeting  device=device_1
#    remove spotlight from other user  from_device=device_2   to_device=console_1:meeting_user      device_type=console
#    verify spotlight text on device   device=console_1   text=no_spotlight
#    Close participants screen   device=device_2
#    End a meeting     console=console_1       device=device_2,device_3
#    Verify for meeting state    console_list=console_1      device_list=device_2,device_3      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3
#
#
#19_2_Initiate_Spotlight.robot
#
#TC7 : [Initiate Spotlight] Verify stop spotlight locally
#    [Tags]  379743      P2
#    [Setup]  Testcase Setup for shared User     count=2
#    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Verify video preview on screen  device=device_1
#    Make a spotlight   from_device=console_1    to_device=device_2      device_type=console
#    verify spotlight text on device   device=device_2     text=spotlight
#    verify spotlight icon on main screen in the meeting  device=device_1
#    verify spotlight icon  device=console_1
#    remove spotlight from other user    from_device=console_1   to_device=device_2    device_type=console
#    verify spotlight icon disable      device=console_1
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2
#
#TC9:[Initiate Spotlight] Verify that start spotlight pop is displayed.
#    [Tags]  379738      P2
#    [Setup]  Testcase Setup for shared User     count=2
#    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    verify spotlight option    from_device=console_1   to_device=device_2    device_type=console     action_type=verify
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

#24_White_Board_Sharing.robot
#
#TC2: [Whiteboard Sharing] TC user to share whiteboard during meeting
#    [Tags]      315258      bvt_sm      sanity_sm
#    [Setup]  Testcase Setup for shared User   count=2
#    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Verify whiteboard sharing option under more option        device=console_1
#    Verify whiteboard visibility for all participants   device_list=device_1:meeting_user,device_2
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2


#TC4:[Whiteboard Sharing]DUT user to access whiteboard tools during meeting
#    [Tags]      315262      bvt_sm      sanity_sm
#    [Setup]  Testcase Setup for shared User   count=2
#    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Verify and click on white board sharing in call control bar   device=console_1
#    Wait for Some Time    time=${wait_time}
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    Verify whiteboard tools display on screen    device=device_1
#    Stop presenting whiteboard share screen   device=console_1
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2
#

#TC5: [Whiteboard Sharing] "Stop presenting" button must be displayed on Docked Ubar on DUT user screen
#    [Tags]      322893      P2
#    [Setup]  Testcase Setup for shared User   count=2
#    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Verify and click on white board sharing in call control bar   device=console_1
#    Wait for Some Time    time=${wait_time}
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    verify Stop presenting whiteboard share screen in Docked Ubar and stop whiteboard share   device=console_1
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2
#
#
#TC6:[Whiteboard Sharing] DUT user to mute the call from whiteboard screen
#    [Tags]      315272      P2
#    [Setup]  Testcase Setup for shared User   count=2
#    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
#    Verify and click on white board sharing in call control bar   device=console_1
#    Wait for Some Time    time=${wait_time}
#    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2
#    Mutes the phone call    device=console_1
#    Stop presenting whiteboard share screen   device=console_1
#    End a meeting     console=console_1       device=device_2
#    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

#TC8:[Whiteboard Sharing]DUT user to stop presenting the whiteboard
#    [Tags]      315274  P2
#    [Setup]  Testcase Setup for shared User   count=3
#    Join a meeting   console=console_1     device=device_2,device_3    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2,device_3     state=Connected
#    Verify whiteboard sharing option under more option        device=console_1
#    Verify whiteboard visibility for all participants   device_list=device_1:meeting_user,device_2,device_3
#    Verify whiteboard tools display on screen    device=device_1
#    Click on stop whiteboard sharing    console=console_1       device=device_1
#    End a meeting     console=console_1       device=device_2,device_3
#    Verify for meeting state    console_list=console_1      device_list=device_2,device_3      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3
#
#TC10:[Whiteboard Sharing] Incoming call during meeting when DUT shared whiteboard
#    [Tags]      315297      sanity_sm   P1
#    [Setup]  Testcase Setup for shared User   count=3
#    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_2    state=Connected
#    Verify whiteboard sharing option under more option        device=console_1
#    Verify whiteboard visibility for all participants   device_list=device_1:meeting_user,device_2
#    Place an outgoing call using dial pad    from_device=device_3     to_device=console_1:meeting_user
#    Verify user not to get second incoming call     console=console_1
#    Disconnect call     device=device_3
#    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
#    End a meeting      console=console_1    device=device_2
#    Verify for call state    console_list=console_1    device_list=device_2,device_3    state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3


#26_1_Meeting_chat

#TC1:[Chat]Verify the chat option in P2P incoming call when show meeting chat is disabled in admin settings.
#    [Tags]  380046   P1     sanity_sm
#    [Setup]   Testcase Setup for shared User    count=2
#    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
#    Pick up incoming call    console=console_1
#    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
#    Verify that chat toggle button is not present   device=console_1
#    Disconnect the call      console=console_1
#    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
#   [Teardown]   Run Keywords    Capture Failure  AND     Come back to home screen page   console_list=console_1      device_list=device_2
#
#TC2:[Chat]Verify the chat option in P2P outgoing call when show meeting chat is disabled in admin settings.
#    [Tags]      380049      P2
#    [Setup]   Testcase Setup for shared User    count=2
#    Make outgoing call using dial pad    from_device=console_1     to_device=device_2
#    Accept incoming call      device=device_2
#    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
#    Verify that chat toggle button is not present   device=console_1
#    Disconnect the call      console=console_1
#    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
#   [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1      device_list=device_2
#
#
#26_Meeting_chat
#TC5: [Chat]Verify the chat option in P2P incoming call when user enables chat option.
#    [Tags]      380045      P2
#    [Setup]   Testcase Setup for shared User     count=2
#    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
#    Pick up incoming call    console=console_1
#    Wait for Some Time    time=${wait_time}
#    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
#    verify meeting chat     console=console_1       action_type=modify
#    verify meeting chat toggle on behaviour      device=device_1
#    Disconnect the call      console=console_1
#    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2
#
#
#TC7: [Chat]Verify the chat option in P2P outgoing call when user enables chat option.
#    [Tags]      380048      P2
#    [Setup]   Testcase Setup for shared User     count=2
#    Make outgoing call using dial pad    from_device=console_1     to_device=device_2
#    Accept incoming call      device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
#    verify meeting chat     console=console_1       action_type=modify
#    verify meeting chat toggle on behaviour      device=device_1
#    Disconnect call     device=device_2
#    Verify for call state     console_list=console_1     device_list=device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2
#
#
#27_Front_Row
#
#TC4:[Front Row] Check for the Front row behavior at the Teams admin settings page
#    [Tags]      382113        P2
#    [Setup]   Testcase Setup for shared User     count=2
#    Navigate to app settings screen     console=console_1
#    Navigate to meeting and calling options from device settings page       console=console_1     option=meeting
#    Enable front row toggle from device setting     device=console_1         default_state_layout=front_row
#    Join meeting   device=device_2    meeting=console_lock_meeting
#    Verify meeting state   device_list=device_2    state=Connected
#    Add participant to the conversation using display name   from_device=device_2    to_device=console_1:meeting_user
#    Accept incoming call      device=device_1
#    Close participants screen   device=device_2
#    Verify front row mode      device=device_1
#    End a meeting       console=console_1       device=device_2
#    Verify meeting state    device_list=device_2       state=Disconnected
#    Enable front row toggle from device setting     device=console_1        default_state_layout=content_gallery
#    come back from admin settings page      device_list=console_1
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2
#
#
#29_Large_Gallery
#
#
#TC8:[Large Gallery] Verify Layout options in Group audio call
#    [Tags]        322596   P2
#    [Setup]  Testcase Setup for shared User   count=3
#    Make outgoing call with phonenumber    from_device=device_2     to_device=device_3
#    Accept incoming call    device=device_3
#    Verify Call State    device_list=device_2,device_3    state=Connected
#    Add participant to the conversation using phonenumber   from_device=device_2    to_device=console_1:meeting_user
#    Pick up incoming call    console=console_1
#    Close add participants roaster button   device=device_2
#    Verify for call state     console_list=console_1    device_list=device_2,device_3    state=Connected
#    Layout options in group audio call   console=console_1
#    End up call     console=console_1       device=device_2
#    Verify for call state     console_list=console_1    device_list=device_2,device_3    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3
#
#
#30_Require_id_and_passcode
#
#TC4:[Require ID and passcode] Verify "Require passcode for all meetings " is default off with toggle button under "Meetings."
#    [Tags]      444234    P1
#    [Setup]    Testcase Setup for shared User   count=1
#    Navigate to teams admin settings page   console=console_1
#    Verify that require passcode for all meetings toggle should be disabled by default   device=console_1
#    come back from admin settings page      device_list=console_1
#    [Teardown]   Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1


#All_day_meetings
#TC2:[Landing Page]All-day meeting tittle should be hide when there are no All-day meetings
#    [Tags]      314942   P1
#    [Setup]  Testcase Setup for shared User       count=1
#    Verify Home page options   console=console_1:meeting_user
#    Tap on all day meetings title bar and validate   device=console_1
#   [Teardown]   Run Keywords   Capture Failure  AND  Navigate back to meetings   device=console_1    AND  Come back to home screen page   console_list=console_1
#
#
#four_device_testcases
#TC3: [Meetings]Touch Console user can add participants to the meeting
#    [Tags]      315053   P1      exclude_ftp_sm_count_four      exclude_ftp_sm
#    [Setup]   Testcase Shared Mode PSTN Setup Main    count=4
#    Join a meeting   console=console_1     device=device_3    meeting=rooms_console_meeting
#    Verify for meeting state     console_list=console_1      device_list=device_3     state=Connected
#    Add participant to the conversation using display name  from_device=console_1    to_device=device_4
#    Accept incoming call      device=device_4
#    Verify for meeting state     console_list=console_1      device_list=device_3,device_4     state=Connected
#    Verify and view list of participant     console=console_1
#    Add participant to the conversation using phonenumber  from_device=console_1    to_device=device_2:pstn_user
#    Accept incoming call      device=device_2
#    Verify for meeting state     console_list=console_1      device_list=device_2,device_3,device_4     state=Connected
#    End a meeting     console=console_1       device=device_3,device_4
#    Verify for meeting state    console_list=console_1      device_list=device_2,device_3,device_4      state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3,device_4
#
#
#Meeting_other_cases
#TC3:Calling option should not be present under "Teams admin settings"
#     [Tags]     451263    P2
#    [Setup]  Testcase Setup for shared User     count=1
#    Navigate to app settings screen    console=console_1
#    Navigate to meeting and calling options from device settings page   console=console_1   option=settings_page
#    Verify calling option should not present under admin settings page      console=console_1
#    Come back from admin settings page    device_list=console_1
#    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1
#
#
#Feature change: Video call UI has changed to meeting UI, so, hold option is removed
#TC1: [Video - Call Hold] DUT puts call on hold with TDC
#    [Tags]   315011   bvt_sm        sanity_sm
#    [Setup]   Testcase Setup for shared User    count=2
#    Place a video call using display name   from_device=device_2     to_device=console_1:meeting_user
#    Pick up incoming call    console=console_1
#    Wait for Some Time    time=${wait_time}
#    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
#    Hold current call   console=console_1
#    Verify for call state     console_list=console_1    device_list=device_2    state=Hold
#    Resume current call  console=console_1
#    Verify for call state     console_list=console_1     state=Resume
#    Disconnect call     device=device_2
#    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2
#Upcoming_meetings_calendar
#TC5:[App Settings] Teams App User to view the third-party Notices of use
#    [Tags]    324053        P2
#    [Setup]  Testcase Setup for shared User     count=1
#    Navigate to about page   console=console_1
#    verify third party software and information     device=console_1
#    navigate back to more option page    device=console_1
#    [Teardown]  Run Keywords   Capture Failure  AND    Come back to home screen page   console_list=console_1
#*** Keywords ***

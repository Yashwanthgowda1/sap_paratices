*** Settings ***
Documentation  Validating the functionality of Console Call Controls feature
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1:[Audio - Mute Call] DUT puts the call on Mute with TDC
    [Tags]    315013    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User   count=2
    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
    Pick up incoming call    console=console_1
    Wait for Some Time    time=${wait_time}
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Mute the call      console=console_1
    Verify and check call mute state      console_list=console_1    state=Mute
    Unmute the call    console=console_1
    Verify and check call mute state     console_list=console_1    state=Unmute
    Disconnect call     device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC2:[Video - Mute Call] DUT puts the call on Mute with TDC
    [Tags]    315015    Sanity_tc_sm    P1
    [Setup]   Testcase Setup for shared User   count=2
    Place a video call using display name   from_device=device_2     to_device=console_1:meeting_user
    Pick up incoming call    console=console_1
    Close participants screen   device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Mute the call      console=console_1
    Verify and check call mute state      console_list=console_1    state=Mute
    Unmute the call    console=console_1
    Verify and check call mute state     console_list=console_1    state=Unmute
    End a meeting     console=console_1       device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC3:[Audio - Call Hold] DUT puts call on hold with TDC
    [Tags]    315009    P1
    [Setup]   Testcase Setup for shared User    count=2
    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
    Pick up incoming call    console=console_1
    Wait for Some Time    time=${wait_time}
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Hold current call   console=console_1
    Verify for call state     console_list=console_1    device_list=device_2    state=Hold
    Resume current call  console=console_1
    Verify for call state     console_list=console_1     state=Resume
    Disconnect the call      console=console_1
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC4:[Mixed - Mute Call] DUT puts the call on mute with Video enabled TDC
    [Tags]    315017    P1    sanity_tc_sm
    [Setup]   Testcase Setup for shared User   count=2
    Place a video call using display name   from_device=device_2     to_device=console_1:meeting_user
    Pick up incoming call    console=console_1
    Close participants screen   device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Mute the call      console=console_1
    Verify and check call mute state      console_list=console_1    state=Mute
    Unmute the call    console=console_1
    Verify and check call mute state     console_list=console_1    state=Unmute
    End a meeting     console=console_1       device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC5:[Dialpad][Mic]Soft mute icon is disabled when user try to use dial pad in call
    [Tags]    322319    P2
    [Setup]   Testcase Setup for shared User   count=2
    Make outgoing call using dial pad    from_device=console_1     to_device=device_2
    Accept incoming call      device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    verify dailpad on call controlbar   device=console_1
    verify mic on calling screen is not clickable    device=console_1
    Disconnect the call      console=console_1
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC6:[Call-App] Verify Call button on the home screen and Icon is updated to “Phone”.
    [Tags]    444606    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User    count=1
    check dial pad on landing page   console=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC7:[Call-App] Verify the UI after selecting Call button on the home screen
    [Tags]    444607    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User    count=1
    verify dial pad on homescreen       console=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC8:[Call-App] Verify mic is enabled and video is disabled by default, when user makes P2P call.
    [Tags]    444617    P1    sanity_tc_sm
    [Setup]   Testcase Setup for shared User    count=2
    Make outgoing call using dial pad    from_device=console_1     to_device=device_2
    Accept incoming call      device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Check video call Off state      device_list=console_1
    Verify meeting Mute State    device_list=console_1    state=Unmute
    Disconnect the call      console=console_1
    Verify for call state    console_list=console_1    device_list=device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC9:[Call] Ending the call should redirect DUT user to home screen.
    [Tags]    444741    P2
    [Setup]    Testcase Setup for shared User   count=3
    Start meeting using meet now   from_device=console_1    to_device=device_2
    Accept incoming call   device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Add participant to the conversation using display name  from_device=console_1    to_device=device_3
    Accept incoming call      device=device_3
    Verify for call state     console_list=console_1    device_list=device_2,device_3    state=Connected
    Verify and view list of participant     console=console_1
    End a meeting     console=console_1       device=device_2,device_3
    Verify for call state    console_list=console_1    device_list=device_2,device_3    state=Disconnected
    Verify home screen   console=console_1:meeting_user
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC10:[Call] Verify that Auto dial functionality after entering the Valid/Non valid DID.
    [Tags]    451142    P1
    [Setup]   Testcase Setup for shared User    count=2
    Make outgoing call using auto dial from dial pad    from_device=console_1     to_device=device_2
    Accept incoming call      device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Disconnect the call      console=console_1
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC11:[Call] Start Call and mute all Participants in call.
    [Tags]    444739    P2
    [Setup]   Testcase Setup for shared User   count=3
    Make outgoing call with username using dial pad     from_device=console_1    to_device=device_2,device_3
    Accept incoming call      device=device_2,device_3
    Verify for meeting state     console_list=console_1      device_list=device_2,device_3     state=Connected
    Verify and view list of participant    console=console_1
    Mute all active participants        console=console_1
    Verify meeting Mute State    device_list=device_2,device_3    state=mute
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1    device_list=device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC12:[Call] DUT user adds TDC user as participant, mute and unmutes during call.
    [Tags]    444738    sanity_tc_sm    P1
    [Setup]   Testcase Setup for shared User   count=2
    Make outgoing call using dial pad    from_device=console_1     to_device=device_2
    Accept incoming call      device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Mute the call      console=console_1
    Verify and check call mute state      console_list=console_1    state=Mute
    Unmute the call    console=console_1
    Verify and check call mute state     console_list=console_1    state=Unmute
    End the meeting     console=console_1
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC13:[Call] Call icon should be present on Home screen after Sign-in
    [Tags]    444731    P1    sanity_tc_sm
    [Setup]   Testcase Setup for shared User   count=1
    Verify call option present in home screen          console=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC14:[Call] DUT user adds TDC user as participant, holds and resumes during call.
    [Tags]    444737    P1    sanity_tc_sm
    [Setup]   Testcase Setup for shared User    count=2
    Make outgoing call with username using dial pad     from_device=console_1    to_device=device_2
    Accept incoming call      device=device_2
    Verify for meeting state     console_list=console_1      device_list=device_2    state=Connected
    Hold current call   console=console_1
    Verify for call state     console_list=console_1    device_list=device_2    state=Hold
    Resume current call  console=console_1
    Verify for call state     console_list=console_1     state=Resume
    Disconnect the call      console=console_1
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC15:[Call] Start call and Far mute Participants in call.
    [Tags]    444748    P2
    [Setup]   Testcase Setup for shared User   count=3
    Make outgoing call with username using dial pad     from_device=console_1    to_device=device_2
    Accept incoming call      device=device_2
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Add participant to the conversation using display name   from_device=console_1    to_device=device_3
    Accept incoming call      device=device_3
    Verify for meeting state     console_list=console_1      device_list=device_2,device_3     state=Connected
    Farmute the call and validate    from_device=console_1       to_device=device_2
    Verify meeting Mute State    device_list=device_2    state=mute
    Unmutes the meeting    device=device_2
    Verify meeting Mute State    device_list=device_2    state=Unmute
    End a meeting     console=console_1       device=device_2
    Verify for call state    console_list=console_1    device_list=device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC16:[Call] DUT user can check more options during Call.
    [Tags]    444744    P2
    [Setup]   Testcase Setup for shared User   count=2
    Make outgoing call with username using dial pad     from_device=console_1    to_device=device_2
    Accept incoming call      device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Verify option present inside more option and validate  console=console_1
    End the meeting     console=console_1
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC17:[Call] DUT user invites TDC & DUT2 user into Call using DID number.
    [Tags]    444747    P2
    [Setup]  Testcase Setup for shared User   count=3
    Make outgoing call using dial pad    from_device=console_1     to_device=device_2
    Accept incoming call      device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Add participant to the conversation using phonenumber   from_device=console_1    to_device=device_3
    Accept incoming call      device=device_3
    Verify for call state     console_list=console_1    device_list=device_2,device_3    state=Connected
    Verify and view list of participant     console=console_1
    End a meeting     console=console_1     device=device_3
    Verify for call state    console_list=console_1    device_list=device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC18:[Call-App] Verify the call button behavior after contacts selected and number dialed.
    [Tags]    444616    P2
    [Setup]   Testcase Setup for shared User    count=3
    Verify the call button behavior    device=console_1     to_device=device_2,device_3
    Accept incoming call      device=device_2,device_3
    Verify for call state     console_list=console_1    device_list=device_2,device_3    state=Connected
    End a meeting     console=console_1     device=device_2
    Come back to home screen     devices=device_3
    Verify for call state     console_list=console_1    device_list=device_2,device_3    state=DisConnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1     device_list=device_2,device_3

TC19:Check mute intent on DUT
    [Tags]    410791    P2
    [Setup]   Testcase Setup for shared User    count=2
    Place a video call using display name   from_device=device_2     to_device=console_1:meeting_user
    Pick up incoming call    console=console_1
    Close participants screen   device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Mute the call      console=console_1
    Verify and check call mute state      console_list=console_1    state=Mute
    Verify checking the mute intents      device=console_1     intent=mute_on
    End a meeting     console=console_1       device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC20:[Call] TDC user to reject the Call invite call from DUT user.
    [Tags]    444742    P2
    [Setup]   Testcase Setup for shared User   count=3
    Start meeting using meet now   from_device=console_1    to_device=device_2
    Accept incoming call   device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Add participant to the conversation using display name  from_device=console_1    to_device=device_3
    Reject incoming call   device_list=device_3
    Verify meeting state    device_list=device_3   state=Disconnected
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Verify and view list of participant     console=console_1
    End a meeting     console=console_1       device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC21:[Call] Participant count updates, when organizer adds the participant after Call is started.
    [Tags]    444749    P2
    [Setup]   Testcase Setup for shared User   count=3
    Make outgoing call with username using dial pad		from_device=console_1	to_device=device_2
	Accept incoming call	device=device_2
	Verify Participant count	console_list=console_1	device_list=device_2    state=Connected
    Add participant to the conversation using display name  from_device=console_1    to_device=device_3
    Accept incoming call   device=device_3
    Verify Participant count    console_list=console_1    device_list=device_2,device_3    state=Connected
    Verify and view list of participant  console=console_1
    End a meeting     console=console_1       device=device_2
    Verify for call state    console_list=console_1    device_list=device_2,device_3    state=Disconnected
    Verify home screen   console=console_1:meeting_user
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC22:[Video - Call Hold] DUT puts call on hold with TDC
    [Tags]    315011    bvt_tc_sm    sanity_tc_sm
    [Setup]   Testcase Setup for shared User    count=2
    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
    Pick up incoming call    console=console_1
    Wait for Some Time    time=${wait_time}
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Hold current call   console=console_1
    Verify for call state     console_list=console_1    device_list=device_2    state=Hold
    Resume current call  console=console_1
    Verify for call state     console_list=console_1     state=Resume
    Disconnect the call      console=console_1
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC23:[Call-App] Verify the search field after dialing on the dial pad.
    [Tags]         444613      P2
    [Setup]   Testcase Setup for shared User     count=1
    verify functionality of dialing on the dial pad in console     console_list=console_1    device=device_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC24:[Call-App] Verify the Back button when user enters text in search field.
    [Tags]        444615      P2
    [Setup]   Testcase Setup for shared User     count=1
    verify back button when user enters text in search field    device=device_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC25:[Call] Start Call, Increase and decrease volume after participants are added
    [Tags]      444734      P3
    [Setup]   Testcase Setup for shared User     count=2
    Make outgoing call using dial pad    from_device=console_1     to_device=device_2
    Accept incoming call      device=device_2
    Wait for Some Time    time=${wait_time}
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Verify functionality of volume button    console=console_1   button=UP     state=In_meeting
    Verify functionality of volume button    console=console_1   button=Down   state=In_meeting
    Disconnect call     device=device_2
    Verify for call state     console_list=console_1     device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC26:[Call] Tapping on Call icon should initiate a conference call.
    [Tags]      444732      P1   sanity_tc_sm
    [Setup]   Testcase Shared Mode PSTN Setup Main    count=3
    Make outgoing call using dial pad    from_device=console_1     to_device=device_3
    Accept incoming call      device=device_3
    Verify for call state     console_list=console_1    device_list=device_3    state=Connected
    Add participant to the conversation using phonenumber   from_device=console_1    to_device=device_2:pstn_user
    Accept incoming call      device=device_2
    Wait for Some Time    time=${wait_time}
    Verify for call state     console_list=console_1    device_list=device_2,device_3    state=Connected
    Verify and view list of participant     console=console_1
    End a meeting     console=console_1       device=device_3
    Verify for call state    console_list=console_1    device_list=device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC27:[Call] Start Call from Home screen, Add & Remove Participants from call
    [Tags]      444735      P2
    [Setup]   Testcase Shared Mode PSTN Setup Main    count=3
    Make outgoing call using dial pad    from_device=console_1     to_device=device_3
    Accept incoming call      device=device_3
    Verify for call state     console_list=console_1    device_list=device_3    state=Connected
    Add participant to the conversation using phonenumber   from_device=console_1    to_device=device_2:pstn_user
    Accept incoming call      device=device_2
    Wait for Some Time    time=${wait_time}
    Verify for call state     console_list=console_1    device_list=device_2,device_3    state=Connected
    Verify and view list of participant     console=console_1
    Remove user from meeting call   from_device=console_1     to_device=device_3        device_type=console
    Verify someone removed you from the meeting call  device=device_3
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    End the meeting     console=console_1
    Verify for call state    console_list=console_1    device_list=device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

*** Keywords ***
End a meeting
    [Arguments]    ${console}    ${device}
    End the meeting  ${console}
    End meeting      ${device}

Verify home screen
    [Arguments]    ${console}
    validate user details along with home screen options    ${console}

Verify call option present in home screen
    [Arguments]    ${console}
    Verify user options on home screen      ${console}

Verify Participant count
     [Arguments]    ${console_list}   ${device_list}      ${state}
    Verify for call state        ${console_list}   ${device_list}      ${state}

verify functionality of dialing on the dial pad in console
    [Arguments]     ${console_list}    ${device}
    dial and validate the numbers from 0 to 9       ${console_list}    ${device}

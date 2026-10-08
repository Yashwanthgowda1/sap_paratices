*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${action_time} =  5

*** Test Cases ***
TC1:[Meetings] Meeting should sync automatically on DUT
    [Tags]  237699  bvt_sm    sanity_sm     bvt_sm_meetings
    [Setup]  Testcase Setup for Meeting User     count=1
    Refresh Meeting visibility   device=device_1
    Verify meeting display on home screen     device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC2:[Meetings] Verify 'Mute' & 'hang up' option while the DUT user joins the meeting
    [Tags]  237609  bvt_sm   sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify call control bar   device_list=device_1
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC3:[Meetings] DUT user can turn off/on the video while in a meeting
    [Tags]  237616  bvt_sm    sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Turn off incoming call   device_list=device_1
    Turn on incoming call    device_list=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC4:[Meetings] DUT user can exit meeting by using the hang-up icon
    [Tags]  237632  bvt_sm   sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC5:[Meetings] DUT user view the existing participants by selecting the participants function
    [Tags]      237694  P2
    [Setup]  Testcase Setup for Meeting User     count=2
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify participants list in meeting     device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC6:[Meetings] DUT user can see a preview of the video stream
    [Tags]  237612    bvt_sm      sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify video preview on screen  device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC7:[Meetings] DUT user can Increase/decrease volume while in meeting
    [Tags]  237628      bvt_sm    sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Adjust volume button   device=device_1   state=UP     functionality=In_meeting
    Adjust volume button   device=device_1   state=Down   functionality=In_meeting
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC8:[Meetings] DUT user can mute/ unmute microphone while in a meeting
    [Tags]  237625      P1      sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_1
    Verify meeting Mute State   device_list=device_1    state=mute
    Unmutes the phone call   device=device_1
    Verify meeting Mute State    device_list=device_1    state=unmute
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2

TC9:[Meetings] DUT user can turn off incoming videos
    [Tags]   237630    P1   sanity_sm
    [Setup]   Testcase Setup for Meeting User    count=2
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Turn off incoming call   device_list=device_1
    Turn on incoming call    device_list=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen  device_list=device_1,device_2

TC10:[Meetings] The menu bar can be dismissed, if the user clicks somewhere outside of the bar area
    [Tags]   237693   P2
    [Setup]   Testcase Setup for Meeting User    count=2
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Validate menu bar get dismiss when clicked outside bar area   device=device_1
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2

TC11:[Meetings] Verify Live captions on DUT
     [Tags]   237865    bvt_sm      sanity_sm
    [Setup]   Testcase Setup for Meeting User    count=2
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Turn on live captions and validate   device=device_1
    Turn off live captions and validate  device=device_1
    End meeting      device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC12:[Meetings] DUT user can mute the other participants in the meeting
    [Tags]   237695  P1    sanity_sm
    [Setup]   Testcase Setup for Meeting User    count=3
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2   state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_3
    Accept incoming call    device=device_3
    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
    Close participants screen   device=device_1
    Mute all participants  device=device_1
    Verify meeting Mute State    device_list=device_2,device_3    state=Mute
    Check video call On state   device_list=device_1
    End meeting      device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC13:[Meetings] DUT user view the other participants (yet to join participants) by selecting the Participants function
    [Tags]   237861  P2
    [Setup]   Testcase Setup for Meeting User    count=3
    Verify meeting display on home screen     device=device_1
    Join meeting    device=device_1,device_2,device_3    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
    Verify participants list in meeting    device=device_1
    End meeting   device=device_1,device_2,device_3
    Verify meeting state   device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3

#feature has been modified user not get the recording option
#TC14: [Meetings] DUT user gets meeting recording notification when any participants starts recording the session
#    [Tags]   237631     bvt_sm      sanity_sm
#    [Setup]  Testcase Setup for Meeting User     count=2
#    Verify meeting display on home screen     device=device_1
#    Join meeting   device=device_1,device_2    meeting=lock_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Start recording   device_list=device_2
#    Verify recording notification display on screen  device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2


TC14:[Meetings] DUT user disabled raise hand in the meeting
    [Tags]  237864     bvt_sm  sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=3
    Join meeting    device=device_1,device_2,device_3    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
    Check video call On state   device_list=device_1,device_2,device_3
    Select raise hand option  device=device_1
    Verify raise hand notification   device_list=device_2,device_3
    Select Lower hand option  device=device_1
    End meeting   device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC15:[Meeting] While the meeting is being joined, a progress screen and list of participants is displayed
    [Tags]  237608    bvt_sm      sanity_sm
    [Setup]  Testcase Setup for Meeting User    count=3
    Verify meeting display on home screen     device=device_1
    Join meeting    device=device_1,device_2,device_3    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
    Verify list of inivited participants display on screen    device=device_1
    End meeting   device=device_1,device_2,device_3
    Verify meeting state   device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC16:[Meeting] verify "Manage audio and video" option in meeting
    [Tags]  260608    P1    sanity_sm
    [Setup]  Testcase Setup for Meeting User    count=2
    Join meeting    device=device_1,device_2   meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_2   state=Connected
    Verify participants list in meeting    device=device_1
    Verify manage audio and video options in participants    device=device_1
    End meeting    device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2

TC17:[Meeting] verify "Manage audio and video" option not available for attendee.
    [Tags]  260609    P1        sanity_sm
    [Setup]  Testcase Setup for Meeting User    count=2
    Join meeting    device=device_1,device_2   meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_2   state=Connected
    Verify participants list in meeting    device=device_1
    Verify manage audio and video options in participants    device=device_1
    Make an attendee   from_device=device_2     to_device=device_1:meeting_user
    Verify you are an attendee now notification   device=device_1
    Verify not to have manage audio and video option        device=device_1
    Verify add participant button should not visible for attendee  device=device_1
    End meeting   device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2

TC18:[Meeting] verify attendee cannot add participants in the meeting
    [Tags]  260610    P1    sanity_sm
    [Setup]  Testcase Setup for Meeting User    count=2
    Join meeting    device=device_1,device_2   meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_2   state=Connected
    Verify participants list in meeting    device=device_1
    Make an attendee   from_device=device_2     to_device=device_1:meeting_user
    Verify you are an attendee now notification   device=device_1
    Verify add participant button should not visible for attendee  device=device_1
    End meeting   device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2

TC19:[Meeting] Verify user behavior when role transition to presenter from attendee
    [Tags]  260612      bvt_sm   sanity_sm
    [Setup]  Testcase Setup for Meeting User    count=2
    Join meeting    device=device_1,device_2   meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_2   state=Connected
    Verify participants list in meeting    device=device_1
    Make an attendee   from_device=device_2     to_device=device_1:meeting_user
    Verify you are an attendee now notification   device=device_1
    Verify add participant button should not visible for attendee  device=device_1
    Verify not to have manage audio and video option        device=device_1
    Make an presenter     from_device=device_2     to_device=device_1:meeting_user
    Verify you are an presenter now notification   device=device_1
    Verify add participant button should visible for presenter  device=device_1
    End meeting   device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2

TC20:[Meeting] verify attendee can raise hand in meeting
    [Tags]  260611  P1     sanity_sm
    [Setup]  Testcase Setup for Meeting User    count=3
    Join meeting    device=device_1,device_2,device_3   meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
    Verify participants list in meeting    device=device_1
    Make an attendee   from_device=device_2     to_device=device_1:meeting_user
    Verify you are an attendee now notification   device=device_1
    Verify add participant button should not visible for attendee  device=device_1
    Verify not to have manage audio and video option        device=device_1
    Select raise hand option  device=device_1
    Verify raise hand notification   device_list=device_2,device_3
    End meeting   device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2,device_3

TC21:[Group call] verify attendee cannot add participants in the group call
    [Tags]  260613      bvt_sm  sanity_sm
    [Setup]  Testcase Setup for Meeting User    count=3
    Initiates conference meeting using Meet now option   from_device=device_2     to_device=device_3
    Accept incoming call    device=device_3
    Close participants screen   device=device_2
    Verify meeting state   device_list=device_2,device_3    state=Connected
    Add participant to conversation using display name   from_device=device_2      to_device=device_1:meeting_user
    Accept incoming call    device=device_1
    Close participants screen   device=device_2
    Verify meeting state    device_list=device_1,device_2,device_3    state=Connected
    Make an attendee   from_device=device_2     to_device=device_1:meeting_user
    Verify you are an attendee now notification   device=device_1
    Verify add participant button should not visible for attendee  device=device_1
    End meeting   device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2,device_3

TC22:[Meeting]Clicking on Meetings icon, opens page with Meetings header and back navigation arrow
    [Tags]  316930    P2
    [Setup]  Testcase Setup for Meeting User    count=1
    Navigate to app settings page  device_1
    navigate to meetings option in device settings page    device_1
    hide or unhide meeting names   device_1     state=on
    device setting back  device=device_1
    Click close btn     device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1

TC23:[Meetings] Verify DUT user screen when participants join/leave meeting with video ON
    [Tags]      304122      P2
    [Setup]  Testcase Setup for Meeting User     count=3
    Join meeting    device=device_1,device_2,device_3    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
    Check video call On state   device_list=device_1,device_2,device_3
    End meeting   device=device_2,device_3
    Verify meeting state    device_list=device_2,device_3   state=Disconnected
    Join meeting    device=device_2,device_3    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
    Check video call On state   device_list=device_2,device_3
    Remove user from meeting call   from_device=device_1      to_device=device_3
    Verify someone removed you from the meeting call  device=device_3
    Close participants screen   device=device_1
    Add participant to conversation using display name   from_device=device_1      to_device=device_3
    Accept incoming call    device=device_3
    Close participants screen   device=device_1
    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
    End meeting   device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC24:[MTRA] Verify meetings time format.
     [Tags]     444860     P1    sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify current time display on home screen    device=device_1
    [Teardown]   Run Keywords   Capture on Failure   AND    Come back to home screen     device_list=device_1

TC25:[Meeting] Verify that DUT user cannot access Settings page while in meeting
    [Tags]     435430     P2
    [Setup]  Testcase Setup for Meeting User     count=2
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify back and setting button is not present in meeting    device=device_1
    End meeting   device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2  state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC26:[MTRA] Verify that new meeting created is visible.
     [Tags]     444851    P1      sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    View current meeting display on screen    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC27:[MTRA] Verify Focus tile in booked state (currently booked or booking to start within 10 min or less)
    [Tags]     444989      P2
    [Setup]  Testcase Setup for Meeting User     count=1
    verify the available focus tile bar     device=device_1
    verify current or upcoming meetings displays on home screen     device=device_1
    [Teardown]  Capture on Failure

TC28:[Meetings] DUT user join the meeting by dialing into the conference bridge number
     [Tags]    303901     317246    P2
    [Setup]  Testcase Setup for Meeting User     count=1
    make a call with conference id     from_device=device_1     to_device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    End meeting   device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2

TC29:[Meeting]DUTuser to verify Layout button during the Meeting
     [Tags]  237910    P1    sanity_sm
    [Setup]   Testcase Setup for Meeting User    count=3
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2   state=Connected
    Verify DUT is able to view option Gallery     device=device_1
    Add participant to conversation using display name   from_device=device_2      to_device=device_3
    Accept incoming call    device=device_3
    Close participants screen   device=device_2
    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
    verify layout options   device=device_1
    End meeting      device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC30:[Meetings] DUT user can see the list of the participants in the meeting
    [Tags]   237626     bvt_sm    sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2   state=Connected
    Verify participants list in meeting     device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3

## Filter Non-All Day Meetings to the End
TC31:[MTRA] Verify Non-all day meetings.
    [Tags]     444990    P2
    [Setup]  Testcase Setup for Meeting User     count=1
    verify meeting reflected on calendar tab    device=device_1        meeting=non_allday_meeting
    verify start and end time display on calendar tab     device=device_1     meeting=non_allday_meeting
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC32:[MTRA] Verify meetings are displayed for Today and Tomorrow.
    [Documentation]  Create non_all_day_meeting more than 24 hours
    [Tags]     444859    P2
    [Setup]  Testcase Setup for Meeting User     count=1
    meetings are displayed for today and tomorrow       device=device_1      meeting=non_allday_meeting
    [Teardown]  Capture on Failure

TC33:[MTRA] Verify calendar showing meetings till next day EOD.
    [Documentation]  Create non_all_day_meeting more than 24 hours
    [Tags]     444858    P2
    [Setup]  Testcase Setup for Meeting User     count=1
    verify start and end time display on calendar tab     device=device_1      meeting=non_allday_meeting
    [Teardown]  Capture on Failure


*** Keywords ***
Verify and click on white board sharing in call control bar
    [Arguments]    ${device}
    Verify whiteboard sharing option under more option   ${device}

meetings are displayed for Today and Tomorrow
    [Arguments]    ${device}            ${meeting}
    verify start and end time display on calendar tab     ${device}     ${meeting}

Verify DUT is able to view option Gallery
    [Arguments]     ${device}
    verify layout options      ${device}
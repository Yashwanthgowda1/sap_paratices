#*** Settings ***
#Documentation   Meeting created as prerequisite before test execution
#Force Tags    pm_meetings   04   pm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#Suite Setup      Meeting setup
#Suite Teardown   Suite Failure Capture
#
#*** Test Cases ***
#TC1: [Meeting] DUT share the Whiteboard during meeting
#    [Documentation]  Tested for DUT only
#    [Tags]  221816   sanity_pm
#    [Setup]  Testcase Setup     count=2
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify video preview on screen  device=device_1
#    Verify whiteboard sharing option under more option   device=device_1
#    Check for whiteboard visibility of participants and validate   from_device=device_1    connected_device_list=device_1,device_2
#    Stop presenting whiteboard share screen    device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC2: [Meetings] DUT user gets meeting recording notification when any participants starts recording the session
#    [Tags]  194774   bvt   bvt_pm   sanity_pm
#    [Setup]  Testcase Setup     count=2
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Start recording   device_list=device_2
#    Verify recording notification display on screen  device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC3: [Meeting] While the meeting is being joined, a progress screen and list of participants is displayed
#    [Tags]  194746   bvt  bvt_pm     sanity_pm
#    [Setup]  Testcase Setup     count=3
#    Join meeting    device=device_1:norden,device_2:,device_3:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
#    Verify list of inivited participants display on screen    device=device_1
#    End meeting   device=device_1,device_2,device_3
#    Verify meeting state   device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC4: [Meeting] DUT to start recording the meeting
#    [Tags]  221808  sanity_pm
#    [Setup]  Testcase Setup     count=2
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Start recording   device_list=device_1
#    Verify recording notification display on screen  device=device_2
#    Stop recording    device=device_1
#    Verify saved chat history notification display on screen    device_list=device_1,device_2
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC5: [Meetings] Verify Live captions on DUT
#    [Tags]   207760   sanity_pm
#    [Setup]  Testcase Setup     count=2
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Turn on live captions and validate   device=device_1
#    Turn off live captions and validate  device=device_1
#    End meeting      device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2    state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC6: [Meetings] DUT user can Increase/decrease volume while in meeting
#    [Tags]  194771      sanity_pm
#    [Setup]  Testcase Setup     count=2
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Adjust volume button   device=device_1   state=UP     functionality=In_meeting
#    Adjust volume button   device=device_1   state=Down   functionality=In_meeting
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2    state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC7: [Meetings] DUT user can mute/ unmute microphone while in a meeting
#    [Tags]  194768      sanity_pm
#    [Setup]  Testcase Setup     count=2
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Mutes the phone call    device=device_1
#    Verify meeting Mute State   device_list=device_1    state=mute
#    Unmutes the phone call   device=device_1
#    Verify meeting Mute State    device_list=device_1    state=unmute
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2    state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2
#
#TC8: [Meetings] DUT user can exit meeting by using the hang-up icon
#    [Tags]   194775   bvt   bvt_pm   sanity_pm
#    [Setup]  Testcase Setup     count=2
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2    state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC9: [Meetings] The menu bar can be dismissed, if the user clicks somewhere outside of the bar area
#    [Tags]   194836   P2
#    [Setup]   Testcase Setup   count=2
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Validate menu bar get dismiss when clicked outside bar area   device=device_1
#    End meeting      device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2
#
#TC10: [Meetings] Meeting should sync automatically on DUT
#    [Tags]   194843   bvt   bvt_pm    sanity_pm
#    [Setup]  Testcase Setup      count=1
#    Verify meeting display on home screen     device=device_1
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1
#
#TC11: [Meetings] DUT user can turn off/on the video while in a meeting
#    [Tags]   194754   bvt   bvt_pm   sanity_pm
#    [Setup]  Testcase Setup      count=2
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Turn off incoming call   device_list=device_1
#    Turn on incoming call    device_list=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2    state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC12: [Meetings] DUT user can see the list of the participants in the meeting
#    [Tags]   194769   bvt    bvt_pm
#    [Setup]  Testcase Setup     count=2
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify participants list in meeting     device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2    state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC13: [Meetings] DUT user can see a preview of the video stream
#    [Tags]   194750      sanity_pm
#    [Setup]  Testcase Setup     count=2
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify video preview on screen  device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2    state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC14: [Meetings] DUT user can mute the other participants in the meeting
#    [Tags]    194838   P2
#    [Setup]   Testcase Setup     count=3
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    Accept incoming call    device=device_3
#    Close participants screen   device=device_1
#    Mute all participants  device=device_1
#    Verify meeting Mute State    device_list=device_1,device_2,device_3    state=Mute
#    Check video call On state   device_list=device_1
#    End meeting      device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC15: [Meetings] DUT user view the existing participants by selecting the participants function
#    [Tags]   194837   P1
#    [Setup]  Testcase Setup     count=2
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify participants list in meeting     device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2    state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC16: [Meetings] DUT user can turn off incoming videos
#    [Tags]   194773    sanity_pm
#    [Setup]   Testcase Setup     count=2
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Turn off incoming call   device_list=device_1
#    Turn on incoming call    device_list=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2    state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen  device_list=device_1,device_2
#
#TC17: [Meetings]DUT user enable raise hand in the meeting
#    [Tags]   207758   P2
#    [Setup]  Testcase Setup     count=3
#    Join meeting    device=device_1:norden,device_2:,device_3:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
#    Check video call On state   device_list=device_1,device_2,device_3
#    Select raise hand option  device=device_1
#    Verify raise hand notification   device_list=device_2,device_3
#    End meeting   device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2,device_3
#
#TC18:[Meetings] DUT user disabled raise hand in the meeting
#    [Tags]   207759   sanity_pm
#    [Setup]  Testcase Setup    count=3
#    Join meeting    device=device_1:norden,device_2:,device_3:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
#    Check video call On state   device_list=device_1,device_2,device_3
#    Select raise hand option  device=device_1
#    Verify raise hand notification   device_list=device_2,device_3
#    Select Lower hand option  device=device_1
#    End meeting   device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC19: [Meetings] DUT user view the other participants (yet to join participants) by selecting the Participants function
#    [Tags]   207755   P2
#    [Setup]   Testcase Setup    count=3
#    Join meeting    device=device_1:norden,device_2:,device_3:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
#    Verify participants list in meeting    device=device_1
#    End meeting   device=device_1,device_2,device_3
#    Verify meeting state   device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC20: [Meetings]Verify that while connecting meeting ,meeting name must be displayed
#    [Tags]  260418    P2
#    [Setup]  Testcase Setup   count=1
#    ${meeting_name_before_disabling_show_meeting_names}=  Get meeting name    device=device_1
#    modify show meeting names toggle button state     device=device_1   state=on
#    ${meeting_name_after_disabling_show_meeting_names}=  Get meeting name    device=device_1
#    Verify meeting name on homescreen after disabling   device_1    ${meeting_name_before_disabling_show_meeting_names}    ${meeting_name_after_disabling_show_meeting_names}
#    Join rooms meeting    device=device_1    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1   state=Connected
#    End meeting   device=device_1
#    Verify meeting state   device_list=device_1   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1
#
#TC21: [Meetings]Verify the no meeting name showin in calander or notification
#    [Tags]  260412    bvt   bvt_pm
#    [Setup]  Testcase Setup    count=1
#    ${meeting_name_before_disabling_show_meeting_names}=  Get meeting name    device=device_1
#    modify show meeting names toggle button state     device=device_1   state=off
#    ${meeting_name_after_disabling_show_meeting_names}=  Get meeting name    device=device_1
#    Verify meeting name on homescreen after disabling   device_1    ${meeting_name_before_disabling_show_meeting_names}    ${meeting_name_after_disabling_show_meeting_names}
#    [Teardown]   Run Keywords    Capture on Failure   AND  modify show meeting names toggle button state     device=device_1   state=on  AND  Come back to home screen    device_list=device_1
#
#TC22: [Meetings]Verify that while connecting meeting ,meeting name must be displayed
#    [Tags]  260414    P1
#    [Setup]  Testcase Setup   count=1
#    ${meeting_name_before_disabling_show_meeting_names}=  Get meeting name    device=device_1
#    modify show meeting names toggle button state     device=device_1   state=off
#    ${meeting_name_after_disabling_show_meeting_names}=  Get meeting name    device=device_1
#    Verify meeting name on homescreen after disabling   device_1    ${meeting_name_before_disabling_show_meeting_names}    ${meeting_name_after_disabling_show_meeting_names}
#    Join rooms meeting    device=device_1    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1   state=Connected
#    End meeting   device=device_1
#    Verify meeting state   device_list=device_1   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND  modify show meeting names toggle button state     device=device_1   state=on  AND  Come back to home screen    device_list=device_1
#
#TC23: [Meetings] Verify 'Mute' & 'hang up' option while the DUT user joins the meeting
#    [Tags]  194747   P1
#    [Setup]  Testcase Setup    count=2
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify call control bar   device_list=device_1
#    End meeting      device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2    state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC24: [Meeting] verify "Manage audio and video" in meeting
#    [Tags]      305354      P1      sanity_pm
#    [Setup]  Testcase Setup     count=2
#    Join meeting    device=device_1:norden,device_2:   meeting=lock_meeting
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    Verify participants list in meeting    device=device_1
#    Verify manage audio and video options in participants    device=device_1
#    End meeting    device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2
#
#TC25: [Meeting] verify "Manage audio and video" option not available for attendee.
#    [Tags]      305355    P1    sanity_pm
#    [Setup]  Testcase Setup     count=2
#    Join meeting    device=device_1:norden,device_2:   meeting=lock_meeting
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    Verify participants list in meeting    device=device_1
#    Verify manage audio and video options in participants    device=device_1
#    Make an attendee   from_device=device_2     to_device=device_1
#    Verify you are an attendee now notification   device=device_1
#    Verify not to have manage audio and video option        device=device_1
#    Verify add participant button should not visible for attendee  device=device_1
#    End meeting   device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2
#
#TC26: [Meeting] verify attendee cannot add participants in the meeting
#    [Tags]      305356    P1    sanity_pm
#    [Setup]  Testcase Setup     count=2
#    Join meeting    device=device_1:norden,device_2:   meeting=lock_meeting
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    Verify participants list in meeting    device=device_1
#    Make an attendee   from_device=device_2     to_device=device_1
#    Verify you are an attendee now notification   device=device_1
#    Verify add participant button should not visible for attendee  device=device_1
#    End meeting   device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2
#
#TC27: [Meeting] Verify user behaviour when role changed to presenter from attendee
#    [Tags]      305358      bvt     bvt_pm      sanity_pm
#    [Setup]  Testcase Setup     count=2
#    Join meeting    device=device_1:norden,device_2:   meeting=lock_meeting
#    Verify meeting state   device_list=device_1,device_2   state=Connected
#    Verify participants list in meeting    device=device_1
#    Make an attendee   from_device=device_2     to_device=device_1
#    Verify you are an attendee now notification   device=device_1
#    Verify add participant button should not visible for attendee  device=device_1
#    Verify not to have manage audio and video option        device=device_1
#    Make an presenter     from_device=device_2     to_device=device_1
#    Verify you are an presenter now notification   device=device_1
#    Verify add participant button should visible for presenter  device=device_1
#    End meeting   device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2
#
#TC28: [Meeting] verify attendee can raise hand in meeting
#    [Tags]  305357  P1      sanity_pm
#    [Setup]  Testcase Setup     count=3
#    Join meeting    device=device_1:norden,device_2:,device_3:   meeting=lock_meeting
#    Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
#    Verify participants list in meeting    device=device_1
#    Make an attendee   from_device=device_2     to_device=device_1
#    Verify you are an attendee now notification   device=device_1
#    Verify add participant button should not visible for attendee  device=device_1
#    Verify not to have manage audio and video option        device=device_1
#    Select raise hand option  device=device_1
#    Verify raise hand notification   device_list=device_2,device_3
#    End meeting   device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2,device_3
#
#TC29: [Group call] verify attendee cannot add participants in the group call
#    [Tags]      305359   P2
#    [Setup]  Testcase Setup     count=3
#    Initiates conference meeting using Meet now option   from_device=device_2     to_device=device_3
#    Accept incoming call    device=device_3
#    Verify meeting state   device_list=device_2,device_3    state=Connected
#    Add participant to conversation using display name   from_device=device_2      to_device=device_1
#    Accept incoming call    device=device_1
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Connected
#    Make an attendee   from_device=device_2     to_device=device_1
#    Verify you are an attendee now notification   device=device_1
#    Verify add participant button should not visible for attendee  device=device_1
#    End meeting   device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2,device_3
#
##Test case realted to TDC user
##TC8: [Meeting] TDC user share the Whiteboard during meeting with DUT
##    [Tags]  221817  P2
##    [Setup]  Testcase Setup     count=2
##    Verify meeting display on home screen     device=device_1
##    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
##    Wait for Some Time    time=${wait_time}
##    Verify meeting state   device_list=device_1,device_2    state=Connected
##    Verify video preview on screen  device=device_1
##    Verify device supports whiteboard sharing under more option   device=device_2
##    Verify whiteboard sharing option under more option   device=device_2
##    Check for whiteboard visibility of participants and validate  from_device=device_2    connected_device_list=device_1,device_2
##    Verify whiteboard stop presenting button visibility   device=device_1
##    Stop presenting whiteboard share screen    device=device_2
##    End meeting     device=device_1,device_2
##    Verify meeting state    device_list=device_1,device_2   state=Disconnected
##    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#*** Keywords ***
#Meeting setup
#    Verify meeting display on home screen   device=device_1
#
#Come back to home screen page
#    [Arguments]    ${device}
#    Come back to home screen    ${device}
#
#Navigate to app settings page
#    [Arguments]     ${device}
#    Click on more option   ${device}
#    Click on settings page   ${device}
#
#Modify show meeting names toggle button state
#    [Arguments]       ${device}   ${state}
#    Navigate to app settings page   ${device}
#    Verify meetings option under App settings page   ${device}
#    hide or unhide meeting names    ${device}   ${state}
#    Come back to home screen    ${device}
#
#Verify manage audio and video option when user is not attendee
#        [Arguments]       ${device}
#        Verify manage audio and video options in participants   ${device}
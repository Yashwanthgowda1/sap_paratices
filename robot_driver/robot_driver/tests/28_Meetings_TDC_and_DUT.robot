*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation    Suite Setup Requirements : This suite requires minimum of 3 devices in config
...              Purpose: Device_1 and Device_2 should each create a meeting and add participants as follows:
...                       Device_1 should add Device_2 and Device_3
...                       Device_2 should add Device_1 and Device_3

Suite Setup     Meeting Suite Setup
Suite Teardown    Run keyword and ignore error    Meeting Suite Teardown

*** Variables ***
${wait_time} =  10
${20s_wait_time} =  20

*** Test Cases ***
TC1 : [Attendee] Add participant option should not be available for DUT user when made as an attendee
    [Tags]  311005   bvt_tp  sanity_tp   p1  alt_bug
    [Setup]      Testcase Setup   count=2
    Join Meeting    device=device_1,device_2    meeting=meeting_dut
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Make an attendee    from_device=device_1       to_device=device_2
    Verify add participant button should not visible for attendee    device=device_2
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2

TC2 : [Attendee] Add participant option should be available for DUT user when made as a presenter
    [Tags]  311014   bvt_tp  sanity_tp      bvt_pr
    [Setup]    Testcase Setup   count=2
    Join Meeting    device=device_1,device_2    meeting=meeting_dut
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Make an attendee    from_device=device_1       to_device=device_2
    Verify add participant button should not visible for attendee    device=device_2
    Make an presenter    from_device=device_1       to_device=device_2
    Verify add participant button should visible for presenter    device=device_2
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2

TC3 : [Attendee] DUT user to make TDC user as a presenter
    [Tags]  311020   p1  sanity_tp      bvt_pr
    [Setup]    Testcase Setup   count=2
    Join Meeting    device=device_1,device_2    meeting=meeting_dut
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Make an attendee    from_device=device_1       to_device=device_2
    Verify you are an attendee now notification     device=device_2
    Verify add participant button should not visible for attendee    device=device_2
    Make an presenter    from_device=device_1       to_device=device_2
    Verify you are an presenter now notification     device=device_2
    Verify add participant button should visible for presenter    device=device_2
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2

TC4 :[Calendar] DUT to return to home screen after meeting/call completion
    [Tags]   307704   p2
    [Setup]  Testcase Setup    count=2
    Join Meeting    device=device_1,device_2    meeting=meeting_dut
    Verify meeting state   device_list=device_1,device_2   state=Connected
    navigate to add participant page    device_name=device_1
    click back    device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    verify join meeting screen after end meeting    device=device_1     meeting=meeting_dut
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2

TC5: [Touch and Navigation] [Home screen] DUT user should be able to access more (...) option while in a meeting/conference call.
    [Tags]      402343     P1   sanity_tp
    [Setup]  Testcase Setup  count=2
    Clear notification from home screen     device=device_1
    ${before_home_screen_tiles}=    get home screen tiles    device=device_1
    ${destination_tab}=     get destination tab on home screen     device=device_1
    ${change_tab}=      select tab to move   device=device_1
    Join Meeting    device=device_1,device_2     meeting=tdc_meeting
    Verify meeting state    device_list=device_1,device_2   state=connected
    Click back  device=device_1
    return to home screen    device_list=device_1
    Navigate to reorder tab      device=device_1
    Verfy and reorder homescreen tiles  device=device_1    tab=${change_tab}    destination=${destination_tab}
    ${after_home_screen_tiles}=    get home screen tiles    device=device_1
    verify updated home screen tile after editing       before_changing=${before_home_screen_tiles}         after_changing=${after_home_screen_tiles}
    Verify meeting state    device_list=device_1,device_2   state=connected
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen     device_list=device_1,device_2

TC6: [Busy on Busy] [Meeting]Verify DUT user shouldn't get the incoming call, When DUT user is in meeting
    [Tags]      451983    sanity_tp  phonesCY23_4
    [Setup]  Testcase Setup    count=3
    select the options inside when in another call option   device=device_1     option=play_a_busy_signal
    Come back to home screen    device_list=device_1
    Join Meeting    device=device_1,device_2     meeting=tdc_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2    state=Connected
    click on calls tab        device=device_3
    verify busy on busy error message while already in call  device=device_3        to_device=device_1  method=display_name
    Disconnect call     device=device_2,device_1
    Verify Call State    device_list=device_1,device_2,device_3      state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND  select the options inside when in another call option   device=device_1     option=new_calls_ring_me   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC7: [Busy on Busy] Verify DUT should get meeting invite, when user is in another call.
    [Tags]      452089
    [Setup]  Testcase Setup    count=3
    select the options inside when in another call option   device=device_1     option=play_a_busy_signal
    Come back to home screen    device_list=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Navigate to calendar tab    device=device_3
    Join Meeting    device=device_3     meeting=tdc_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_3   state=Connected
    Add participant to conversation using display name   from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_3    state=Connected
    End meeting     device=device_3
    Disconnect call     device=device_2
    Wait for Some Time    time=${wait_time}
    End meeting     device=device_1
    Verify Call State    device_list=device_1,device_2      state=Disconnected
    Verify meeting state    device_list=device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND  select the options inside when in another call option   device=device_1     option=new_calls_ring_me   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC8: [Busy on Busy] [Meeting]Verify Unanswered Call should be forwarded to Delegates, When user selects Redirect as if a call is unanswered under When in another call in Calling
    [Tags]      451995
    [Setup]  Run Keywords    Testcase Setup    count=4  AND     Add new delegates with both permission and validate   from_device=device_1    to_device=device_4        AND     Enable Call Forwarding To Delegates     from_device=device_1    contact_device=device_4
    select the options inside when in another call option   device=device_1     option=redirect_unanswered_call
    Come back to home screen    device_list=device_1
    navigate to calendar tab    device=device_1
    Join Meeting    device=device_1,device_3     meeting=tdc_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_3   state=Connected
    click on calls tab        device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1
    verify incoming call  device=device_4   status=appear
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_2,device_4    state=Connected
    Disconnect call     device=device_2
    End meeting     device=device_1,device_3
    Verify Call State    device_list=device_1,device_2,device_3      state=Disconnected
    Verify Meeting State    device_list=device_1,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND  select the options inside when in another call option   device=device_1     option=new_calls_ring_me   AND     verify and disable call forwarding    device=device_1   AND   Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC9:[Busy on Busy][Meeting] Verify Unanswered Call should be forwarded to Contact, When user selects Redirect as if a call is unanswered under When in another call in Calling
    [Tags]      451997  P2
    [Setup]   Run Keywords   Testcase Setup    count=4   AND    Enable unanswered call and add contact   from_device=device_1    contact_device=device_4
    select the options inside when in another call option   device=device_1     option=redirect_unanswered_call
    Come back to home screen    device_list=device_1
    navigate to calendar tab    device=device_1
    Join Meeting    device=device_1,device_3     meeting=tdc_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_3   state=Connected
    click on calls tab        device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    verify incoming call  device=device_4   status=appear
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_2,device_4    state=Connected
    Disconnect call     device=device_4
    Verify meeting state   device_list=device_1,device_3   state=Connected
    End meeting     device=device_1,device_3
    Verify Meeting State    device_list=device_1,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND      select the options inside when in another call option   device=device_1     option=new_calls_ring_me   AND      verify and disable call forwarding    device=device_1   AND         come back home screen for user   count=4

TC10 : [Meeting] Verify when DUT join meeting, user able to access the 'End call' button.
    [Tags]   451772   P1
    [Setup]  Testcase Setup    count=3
    Join Meeting    device=device_3,device_1     meeting=meeting_dut
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_3    state=Connected
    navigate to calendar tab    device=device_3
    Join Meeting    device=device_3     meeting=tdc_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_3    state=Connected
    verify meeting hold banner  device=device_3     meeting=meeting_dut
    Verify call state and disconnect     device=device_3
    Verify call state and disconnect     device=device_3,device_1
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3

TC11 : [Calendar] Calendar tab should sync, with Teams App user as organizer and attendee for different meeting
    [Tags]  309233   P2  alt_bug
    [Setup]      Testcase Setup   count=2
    navigate to calendar tab        device=device_1
    Refresh for Meeting Visibility      device=device_1
    Select Meeting      device=device_1        meeting=meeting_dut
    Verify invited user list in meeting     from_device=device_1    participants=device_2,device_3   meeting=meeting_dut
    navigate to calendar tab        device=device_2
    Refresh for Meeting Visibility      device=device_2
    Select Meeting      device=device_2        meeting=tdc_meeting
    verify invited user list in meeting     from_device=device_2   participants=device_1,device_3    meeting=tdc_meeting
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2

# The entire location text is logged even though it's truncated on UI. Hence, needs manual validation only.
#TC19 : [Meetings] Long location name should be truncated with ellipses in meeting object on Teams App
#    [Tags]   146568     P2  alt_bug
#    [Setup]    Testcase Setup   count=2
#    create meeting  device=device_1       participants=device_2    meeting=long_location_meeting   location=${Long_meeting_location}
#    Refresh for Meeting Visibility      device=device_2
#    Select Meeting      device=device_1   meeting=long_location_meeting
#    Verify truncated meeting location      devices=device_1   location=${Long_meeting_location}
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2


*** Keywords ***
Meeting Suite Setup
    Testcase Setup    count=3
    clear all day meeting and meeting history from calendar   devices=device_1,device_2,device_3
    Create Meeting  device=device_1      meeting=meeting_dut     participants=device_2,device_3
    Create Meeting  device=device_2      meeting=tdc_meeting     participants=device_1,device_3

Meeting Suite Teardown
    Suite Failure Capture
    Teardown meeting test case      devices=device_1,device_2
    clear all day meeting and meeting history from calendar   devices=device_1,device_2,device_3




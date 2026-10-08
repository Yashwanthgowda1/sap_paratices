*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation    Suite Setup Requirements : This suite requires minimum of 3 devices in config
...              Purpose: Device_1 should create meeting and add Device_2 & Device_3 as participants

Suite Setup     Meeting Suite Setup
Suite Teardown    Run keyword and ignore error    Meeting Suite Teardown

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Calendar] Join the scheduled meeting from DUT and do add/remove participants
    [Tags]  306771   sanity_tp       bvt_pr  alt_bug        Certification_audio
    [Setup]    Testcase Setup   count=3
    Join Meeting    device=device_1,device_2     meeting=test_meeting
    Wait for Some Time    time=${wait_time}
    Add participant to conversation using display name   from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Unmutes the meeting    device=device_3
    Remove user from meeting    from_device=device_1      to_device=device_3
#    Commenting this code till the feature is implemented. Bug ref: 2574364
#    Verify someone removed you from the meeting text    device=device_3
    click back btn  device=device_1
    Verify meeting state    device_list=device_3   state=Disconnected
    Verify meeting state   device_list=device_1,device_2    state=Connected
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3

TC2 : [Raisehand] DUT user able to raise hand in the meeting
    [Tags]    309678     bvt_tp  sanity_tp    P1  alt_bug
    [Setup]   Testcase Setup    count=2
    Join Meeting    device=device_1,device_2     meeting=test_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Raise hand     device=device_1
    Verify raise hand    from_device=device_1   to_device=device_2    status=on
    Lower hand     device=device_1
    Verify raise hand    from_device=device_1    to_device=device_2    status=off
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   run keywords   Capture on Failure    AND    Come back to home screen     device_list=device_1,device_2

TC3 : [Livecaption]DUT user able to view the Live caption during meeting
    [Tags]    309685    P2  alt_bug
    [Setup]     Testcase Setup    count=2
    Join Meeting    device=device_1,device_2     meeting=test_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify Live Caption visibility      device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   run keywords   Capture on Failure    AND    Come back to home screen     device_list=device_1,device_2

TC4 : [Calendar] DUT to display all the participants information on the meeting roster
    [Tags]  306779   P1  alt_bug        Certification_audio
    [Setup]  Testcase Setup    count=2
    Navigate to Calendar tab   device=device_1
    Join Meeting    device=device_1         meeting=test_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_2
    pick incoming call    device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    User Friendly Name Identity In The Conference Roster      device_list=device_1,device_2
    End meeting     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2

TC5 : [Calendar App] Add a meeting occurrence event in Calendar app.
    [Tags]      320313      P1        sanity_tp    bvt_tp
    [Setup]    Testcase Setup   count=1
    navigate to calendar tab    device=device_1
    Select Meeting      device=device_1        meeting=test_meeting
    Verify Meeting Details    device=device_1
    verify meeting has join button    device=device_1
    return to home screen   device_list=device_1
    Verify meeting notification    device=device_1
    [Teardown]    Run Keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1

TC6 : [Auto Dismiss] Verify call ended screen will disappear within 3 seconds
    [Tags]  309607   P1    sanity_tp
    [Setup]  Testcase Setup   count=1
    Verify meeting notification    device=device_1
    Join meeting    device=device_1   meeting=test_meeting
    Verify meeting state   device_list=device_1   state=Connected
    Disconnect call and verify ended screen   device=device_1
    Verify meeting state   device_list=device_1   state=Disconnected
    [Teardown]    Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1

TC7 : [Calendar] Calendar tab UI displays all the scheduled meeting entries and details
    [Tags]  307058    sanity_tp
    [Setup]  Testcase Setup    count=1
    Navigate to Calendar tab   device=device_1
    Select Meeting      device=device_1
    Select See More Option      device=device_1
    Verify Meeting has description     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1

TC8 : [Calendar] Verify Calendar tab UI when a new user sign in on Teams App
    [Tags]  307214   P2
    [Setup]     Testcase Setup   count=1
    Verify meeting object for new user   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1

TC9 : [Calendar] Teams App user to schedule meeting using the new meeting option from the Calendar tab
    [Tags]  308320   P1
    [Setup]  Testcase Setup    count=1
    View meeting entry in calendar tab  device=device_1     meeting=test_meeting
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1

TC10 : [Calendar] Teams App should not crash when cancelling the call while joining meeting
    [Tags]  308998   P1
    [Setup]    Testcase Setup   count=1
    Join meeting   device=device_1    meeting=test_meeting
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1

TC11 : [Calendar]Teams App user joins the meeting scheduled without description
    [Tags]  307160   P2
    [Setup]    Testcase Setup   count=1
    navigate to calendar tab    device=device_1
    Select Meeting      device=device_1        meeting=test_meeting
    Verify meeting does not have description     device=device_1
    Join Meeting    device=device_1    meeting=test_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1    state=Connected
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1

TC12 : [Calendar] DUT user can remove TDC user from a conference call
    [Tags]  307085   
    [Setup]    Testcase Setup   count=3
    Join Meeting    device=device_1,device_2,device_3     meeting=test_meeting
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Unmutes the meeting    device=device_2
    Remove user from meeting    from_device=device_1      to_device=device_2
    Verify someone removed you from the meeting text    device=device_2
    click back btn  device=device_1
    Verify meeting state    device_list=device_2   state=Disconnected
    Verify meeting state   device_list=device_1,device_3    state=Connected
    End meeting     device=device_1,device_3
    Verify meeting state    device_list=device_1,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3

TC13 : [Calendar] DUT user should be allowed to join meeting, when in P2P call.
    [Tags]  309259   P2
    [Setup]    Testcase Setup   count=3
    click on calls tab      device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    return to home screen    device_list=device_1
    verify meeting name and join meeting from home_screen    device=device_1    meeting=test_meeting
    verify meeting name and join meeting from home_screen    device=device_2    meeting=test_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify Call State    device_list=device_3     state=Hold
    verify meeting screen ui    device=device_1    participants=device_2,device_3    meeting_name=test_meeting
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_2   state=Disconnected
    end meeting from hold banner     device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3

TC14 : [Calendar] Meeting details page on DUT should display all the participants list
    [Tags]  307209   P1  alt_bug
    [Setup]   Testcase Setup    count=3
    navigate to calendar tab    device=device_1
    Select Meeting      device=device_1        meeting=test_meeting
    Verify Meeting Details    device=device_1       meeting=test_meeting
    Verify invited user list in Meeting Details     from_device=device_1     participants=device_2,device_3
    Join Meeting    device=device_1,device_2,device_3    meeting=test_meeting
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    verify meeting screen ui    device=device_1    participants=device_2,device_3    meeting_name=test_meeting
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
    navigate to calendar tab    device=device_1
    Select Meeting      device=device_1        meeting=test_meeting
    Verify Meeting Details    device=device_1       meeting=test_meeting
    Verify invited user list in Meeting Details     from_device=device_1     participants=device_2,device_3
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1

*** Keywords ***
Meeting Suite Setup
    Testcase Setup    count=2
    clear all day meeting and meeting history from calendar   devices=device_1,device_2
    Create Meeting  device=device_1      meeting=test_meeting     participants=device_2,device_3

Meeting Suite Teardown
    Suite Failure Capture
    Teardown meeting test case      devices=device_1
    clear all day meeting and meeting history from calendar   devices=device_1,device_2,device_3

Lower hand Teardown
    Lower hand     device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected


#*** Settings ***
#Documentation   Meeting created as prerequisite before test execution
#Force Tags    sm_auto_accept    25     sm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#
#*** Variables ***
#${wait_time} =  10
#
#*** Test Cases ***
#TC1: [Auto accept] DUT should auto join meeting with video enabled
#     [Tags]  237835   bvt_sm      sanity_sm
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    accept meeting invites automatically    device=device_1      state=on
#    start my video automatically        device=device_1      state=on
#    Click close btn    device_list=device_1
#    device setting back  device=device_1
#    device setting back  device=device_1
#    Join Meeting    device=device_2:        meeting=lock_meeting
#    Add participant to conversation using display name   from_device=device_2      to_device=device_1:meeting_user
#    Close participants screen   device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Check video call On state   device_list=device_1,device_2
#    End meeting   device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    disabling auto accept meeting invite and start my video automatically   device=device_1      state=off      AND  Come back to home screen    device_list=device_1,device_2
#
#TC2:[Auto accept] DUT should auto accept meeting join invites for scheduled meetings
#    [Tags]      237834    p0   bvt_sm      sanity_sm
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    accept meeting invites automatically   device=device_1      state=on
#    Click close btn    device_list=device_1
#    device setting back  device=device_1
#    device setting back  device=device_1
#    Join Meeting    device=device_2:        meeting=lock_meeting
#    Add participant to conversation using display name   from_device=device_2      to_device=device_1:meeting_user
#    Close participants screen   device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    End meeting   device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND   disabling auto accept meeting invite and start my video automatically    device=device_1      state=off      AND  Come back to home screen    device_list=device_1,device_2
#
#
#TC3: [Auto accept] Auto accept settings should be shown only for meeting room accounts
#    [Tags]  237836    sanity_sm      p1
#    [Setup]    Testcase Setup for Meeting User   count=1
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    verify meeting and video automatically options   device=device_1
#    Click close btn    device_list=device_1
#    device setting back  device=device_1
#    device setting back  device=device_1
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1
#
#TC4: [Auto accept] DUT receives the incoming call manually
#    [Tags]  237839    sanity_sm    p1
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    accept meeting invites automatically    device=device_1      state=on
#    start my video automatically        device=device_1      state=on
#    Click close btn    device_list=device_1
#    device setting back  device=device_1
#    device setting back  device=device_1
#    Join Meeting    device=device_2:        meeting=lock_meeting
#    Add participant to conversation using display name   from_device=device_2      to_device=device_1:meeting_user
#    Accept incoming call      device=device_1
#    Close participants screen   device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    End meeting   device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND   disabling auto accept meeting invite and start my video automatically    device=device_1      state=off      AND  Come back to home screen    device_list=device_1,device_2
#
#
#TC5: [Auto accept for Meet Now] Verify that Auto accept option should not work for P2P call
#     [Tags]   260536   p2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    accept meeting invites automatically    device=device_1      state=on
#    start my video automatically        device=device_1      state=on
#    Click close btn    device_list=device_1
#    device setting back  device=device_1
#    device setting back  device=device_1
#    Make outgoing call with phonenumber    from_device=device_2     to_device=device_1
#    verify auto accept timer is not present    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=disconnected
#    [Teardown]  Run Keywords    Capture on Failure    AND   Come back to home screen    device_list=device_1,device_2   AND    disabling auto accept meeting invite and start my video automatically    device=device_1      state=off    AND    Come back to home screen    device_list=device_1,device_2
#
#
#TC6: [Auto accept for Meet Now] Verify that DUT user can decline Auto accept call
#     [Tags]     260538   p2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    accept meeting invites automatically    device=device_1      state=on
#    start my video automatically        device=device_1      state=on
#    Click close btn    device_list=device_1
#    device setting back  device=device_1
#    device setting back  device=device_1
#    Join Meeting    device=device_2:        meeting=lock_meeting
#    Add participant to conversation using display name   from_device=device_2      to_device=device_1:meeting_user
#    reject incoming call     device_list=device_1
#    Close participants screen   device=device_2
#    End meeting   device=device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND  disabling auto accept meeting invite and start my video automatically    device=device_1      state=off      AND  Come back to home screen    device_list=device_1,device_2
#
#TC7: [Auto accept] DUT user to enable the auto accept settings
#    [Tags]   237837   p2
#    [Setup]    Testcase Setup for Meeting User   count=1
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    accept meeting invites automatically    device=device_1      state=on
#    start my video automatically        device=device_1      state=on
#    Click close btn    device_list=device_1
#    device setting back  device=device_1
#    device setting back  device=device_1
#     [Teardown]  Run Keywords    Capture on Failure  AND  disabling auto accept meeting invite and start my video automatically   device=device_1      state=off      AND  Come back to home screen    device_list=device_1
#
#
#TC8: [Auto accept]DUT accepts the call with auto accept disabled
#    [Tags]    237840   p2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    accept meeting invites automatically    device=device_1      state=off
#    start my video automatically        device=device_1      state=off
#    Click close btn    device_list=device_1
#    device setting back  device=device_1
#    device setting back  device=device_1
#    Make outgoing call with phonenumber    from_device=device_2     to_device=device_1:meeting_user
#    verify auto accept timer is not present    device=device_1
#    Accept incoming call      device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#
#TC9: [Auto Accept] Admin disable the auto accept option for the account
#     [Tags]  264019   p2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    accept meeting invites automatically    device=device_1      state=off
#    start my video automatically        device=device_1      state=off
#    Click close btn    device_list=device_1
#    device setting back  device=device_1
#    device setting back  device=device_1
#    Make outgoing call with phonenumber    from_device=device_2      to_device=device_1:meeting_user
#    verify auto accept timer is not present     device=device_1
#    Accept incoming call      device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC10: [Auto accept] DUT enables Calling settings
#    [Tags]  237841   p2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    accept meeting invites automatically    device=device_1      state=on
#    start my video automatically        device=device_1      state=on
#    Click close btn    device_list=device_1
#    device setting back  device=device_1
#    device setting back  device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND      disabling auto accept meeting invite and start my video automatically   device=device_1      state=off      AND  Come back to home screen    device_list=device_1,device_2
#
#TC11:[Auto accept for Meet Now] Verify DUT accept audio call automatically for Meet now invites
#    [Tags]       260531      p2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    accept meeting invites automatically    device=device_1      state=on
#    start my video automatically        device=device_1      state=on
#    Click close btn    device_list=device_1
#    device setting back  device=device_1
#    device setting back  device=device_1
#    Initiates conference meeting using Meet now option   from_device=device_2   to_device=device_1:meeting_user
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Close participants screen   device=device_2
#    Disconnect call     device=device_2,device_1
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND      disabling auto accept meeting invite and start my video automatically   device=device_1      state=off      AND  Come back to home screen    device_list=device_1,device_2
#
#TC12:[Auto accept for Meet Now] Verify DUT accept Video call automatically for Meet now invites
#     [Tags]     260532   p0    bvt_sm      sanity_sm
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    accept meeting invites automatically    device=device_1      state=on
#    start my video automatically        device=device_1      state=on
#    Click close btn    device_list=device_1
#    device setting back  device=device_1
#    device setting back  device=device_1
#    Initiates conference meeting using Meet now option    from_device=device_2   to_device=device_1:meeting_user
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Close participants screen   device=device_2
#    End meeting   device=device_2,device_1
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND      disabling auto accept meeting invite and start my video automatically   device=device_1      state=off      AND  Come back to home screen    device_list=device_1,device_2
#
#TC13:[Auto accept for Meet Now] Verify that Auto accept option will disabled after re-login
#    [Tags]       260537      p2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    accept meeting invites automatically    device=device_1      state=on
#    start my video automatically        device=device_1      state=on
#    Click close btn    device_list=device_1
#    device setting back  device=device_1
#    device setting back  device=device_1
#    sign out method  device=device_1
#    Sign in method     device=device_1     user=meeting_user
#    Validate that signin is successfully completed    device_list=device_2     state=Sign in
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    verify auto accept toggle is disabled     device=device_1
#    Click close btn    device_list=device_1
#    device setting back  device=device_1
#    device setting back  device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND      disabling auto accept meeting invite and start my video automatically   device=device_1      state=off      AND  Come back to home screen    device_list=device_1,device_2
#
#TC14:[Auto accept] DUT user rejects the incoming call
#     [Tags]      237838      p2
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    accept meeting invites automatically    device=device_1      state=on
#    start my video automatically        device=device_1      state=on
#    Click close btn    device_list=device_1
#    device setting back  device=device_1
#    device setting back  device=device_1
#    Make outgoing call with phonenumber    from_device=device_2     to_device=device_1:meeting_user
#    Reject incoming call   device_list=device_1
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    disabling auto accept meeting invite and start my video automatically   device=device_1      state=off      AND  Come back to home screen    device_list=device_1,device_2
#
#TC15:[Auto accept for Meet Now] Verify that Auto accept option should not available for normal accounts
#    [Tags]  260533     p1   sanity_sm
#    Testcase Setup for Meeting User    count=1
#    Validate that signin is successfully completed    device_list=device_1     state=Sign in
#    Verify home page screen   device=device_1
#    Sign out method    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Sign in method     device=device_1
#    Validate that signin is successfully completed    device_list=device_1     state=Sign in
#    Navigate to app settings page  device=device_1
#    navigate calling option  device=device_1
#    verify auto accept toggle is not present    device=device_1
#    Click close btn    device_list=device_1
#    device setting back  device=device_1
#    device setting back  device=device_1
#    sign out method  device=device_1
#    Sign in method     device=device_1     user=meeting_user
#    [Teardown]   Run Keywords   Capture on Failure   AND    Come back to home screen     device_list=device_1
#
#
#
#*** Keywords ***
#
#Navigate to app settings page
#    [Arguments]     ${device}
#    Click on more option   ${device}
#    Click on settings page    ${device}
#
#navigate calling option
#    [Arguments]       ${device}
#    navigate to teams admin settings   ${device}
#    verify calling option in device settings page     ${device}
#
#
#disabling auto accept meeting invite and start my video automatically
#    [Arguments]     ${device}   ${state}
#    Navigate to app settings page   ${device}
#    navigate calling option      ${device}
#    accept meeting invites automatically   ${device}    ${state}
#    start my video automatically       ${device}     ${state}
#    device setting back    ${device}
#    device setting back    ${device}
#

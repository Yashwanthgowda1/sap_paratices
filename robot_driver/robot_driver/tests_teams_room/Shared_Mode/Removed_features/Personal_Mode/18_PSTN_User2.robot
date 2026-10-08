#*** Settings ***
#Documentation   Meeting created as prerequisite before test execution
#Force Tags    pm_pstn2      pm
#Library     DateTime
#Library     OperatingSystem
#Resource   ../resources/keywords/common.robot
#
#*** Variables ***
#${wait_time} =  10
#${1_minutes_wait_time} =  60
#
#*** Test Cases ***
#TC1: [Home Screen] Dial pad should be available for PSTN enabled user
#    [Tags]  207807   P2   pm_home_screen_pstn
#    [Setup]  Testcase Setup for PSTN User    count=2
#    Verify dial pad present on landing page   device=device_1
#    Dial number from dial pad     from_device=device_1      to_device=device_2:pstn_user
#    Accept incoming call   device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2
#
#TC2: [Incoming Call] DUT receives call from PSTN user
#    [Tags]  194849   P1   pm_Incoming_calls_pstn   sanity_pm
#    [Setup]   Testcase Setup for PSTN User     count=2
#    Make outgoing call with phonenumber    from_device=device_2     to_device=device_1
#    Accept incoming call   device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#TC3 : [Outgoing Call] DUT calls to PSTN user from home screen dialpad
#    [Tags]  194744   bvt   bvt_pm   sanity_pm
#    [Setup]  Testcase Setup for PSTN User   count=2
#    Make outgoing call with phonenumber   from_device=device_1     to_device=device_2:pstn
#    Accept incoming call     device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#TC4: [Outgoing Call] DUT auto dials to PSTN user from home screen dialpad
#    [Tags]  194745   P2   pm_outgoing_calls_pstn      sanity_pm
#    [Setup]  Testcase Setup for PSTN User   count=2
#    Make outgoing call using auto dial      from_device=device_1     to_device=device_2:pstn
#    Accept incoming call      device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#TC5: [Call control] DUT user hold the muted call with PSTN user
#    [Tags]  207798    P2     pm_call_hold_and_call_mute_pstn
#    [Setup]  Testcase Setup for PSTN User  count=2
#    Make outgoing call with phonenumber    from_device=device_2      to_device=device_1
#    Accept incoming call      device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Hold the call       device=device_1
#    Verify Call State    device_list=device_1     state=Hold
#    Wait for Some Time    time=${1_minutes_wait_time}
#    Resume the call   device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Resume
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#TC6: [Escalate to conference]DUT user can add another DUT user while in call with PSTN user
#    [Tags]    194924    P1   pm_esc_to_conf_pstn    sanity_pm
#    [Setup]  Testcase Setup for PSTN User   count=3
#    Make outgoing call with phonenumber    from_device=device_1      to_device=device_2:pstn
#    Accept incoming call      device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_3
#    Accept incoming call      device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify list of participants     from_device=device_1      connected_device_list=device_1,device_2:pstn_user,device_3
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#TC7 : [Escalate to conference] DUT user can add PSTN user while in call with another DUT user
#    [Tags]   194923   bvt   bvt_pm   sanity_pm
#    [Setup]  Testcase Setup for PSTN User   count=3
#    Make outgoing call with phonenumber    from_device=device_1      to_device=device_3
#    Accept incoming call      device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn
#    Accept incoming call      device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify list of participants     from_device=device_1      connected_device_list=device_1,device_2:pstn_user,device_3
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#TC8: [Escalate to Conference] DUT can add PSTN user while in call with TDC user
#    [Tags]   194918   bvt   bvt_pm   sanity_pm
#    [Setup]  Testcase Setup for PSTN User   count=3
#    Make outgoing call with phonenumber    from_device=device_3      to_device=device_1
#    Accept incoming call      device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_3    state=Connected
#    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn
#    Accept incoming call      device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify list of participants     from_device=device_1      connected_device_list=device_1,device_2:pstn_user,device_3
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#TC9: [Meet now] Start Meet now, Verify mute UI on DUT in meeting
#    [Tags]   251527   P2   pm_meet_now_pstn
#    [Setup]   Testcase Setup for PSTN User      count=4
#    Initiates conference meeting using Meet now option     from_device=device_1     to_device=device_3
#    Accept incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_3    state=Connected
#    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_2:pstn
#    Accept incoming call      device=device_2
#    Wait for Some Time    time=${wait_time}
#    Close participants screen   device=device_1
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_4
#    Accept incoming call      device=device_4
#    Wait for Some Time    time=${wait_time}
#    Close participants screen   device=device_1
#    Verify meeting state   device_list=device_1,device_2,device_3,device_4    state=Connected
#    Check video call On state   device_list=device_1,device_2,device_3,device_4
#    Mute all participants   device=device_1
#    Verify meeting Mute State    device_list=device_1,device_2,device_3,device_4    state=Mute
#    End meeting   device=device_2,device_3,device_4
#    Verify meeting state    device_list=device_1,device_2,device_3,device_4   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3,device_4
#
#TC10: [Meetings] DUT user can add participants to the meeting
#    [Tags]   194770   sanity_pm
#    [Setup]  Testcase Setup for PSTN User    count=3
#    Join meeting   device=device_1:norden    meeting=cnf_device_meeting
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    Accept incoming call      device=device_3
#    Wait for Some Time    time=${wait_time}
#    Close roaster button on participants screen   device=device_1
#    Add participant to conversation using phonenumber    from_device=device_1      to_device=device_2:pstn
#    Accept incoming call      device=device_2
#    Wait for Some Time    time=${wait_time}
#    Close roaster button on participants screen   device=device_1
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    End meeting      device=device_2
#    Verify meeting state   device_list=device_1,device_3    state=Connected
#    End meeting      device=device_1,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#TC11: [Escalate to conference] DUT user can add another PSTN user while in call with a PSTN user
#    [Tags]   194925  bvt    bvt_pm   sanity_pm
#    [Setup]  Testcase Setup for 2 PSTN User   count=3
#    Make outgoing call with phonenumber    from_device=device_1     to_device=device_2:pstn
#    Accept incoming call      device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Add participant to conversation using phonenumber    from_device=device_1      to_device=device_3:pstn
#    Accept incoming call    device=device_3
#    Wait for Some Time    time=${wait_time}
#    Verify list of participants   from_device=device_1      connected_device_list=device_1,device_2:pstn_user,device_3:pstn
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Disconnect call     device=device_3
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#
##need to modify the test case based on new changes
##TC11: [Whiteboard Sharing] Shared whiteboard should not be displayed for PSTN user
##    [Tags]  229146   P2    pm_whiteboard_pstn
##    [Setup]  Testcase Setup for PSTN User     count=3
##    Verify meeting display on home screen     device=device_1
##    Join meeting   device=device_1:norden,device_3:    meeting=cnf_device_meeting
##    Wait for Some Time    time=${wait_time}
##    Verify meeting state   device_list=device_1,device_3    state=Connected
##    Add participant to conversation using phonenumber    from_device=device_1      to_device=device_2:pstn
##    Accept incoming call    device=device_2
##    Wait for Some Time    time=${wait_time}
##    Close participants screen   device=device_1
##    Verify meeting state    device_list=device_1,device_2,device_3    state=Connected
##    Verify whiteboard sharing option under more option   device=device_1
##    Check for whiteboard visibility of participants and validate  from_device=device_1    connected_device_list=device_1,device_2:pstn_user,device_3
##    Stop presenting whiteboard share screen   device=device_1
##    End meeting    device=device_2
##    Verify meeting state    device_list=device_1,device_3    state=Connected
##    End meeting     device=device_1,device_3
##    Verify meeting state    device_list=device_1,device_2   state=Disconnected
##    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#
#
#*** Keywords ***
#Test Case Teardown
#    [Arguments]     ${devices}
#    Come back to home screen     ${devices}
#
#Verify Meet now icon present on home screen
#    [Arguments]     ${device}
#    Verify home page screen     ${device}
#
#Naviagte back to home screen page and validate
#    [Arguments]     ${device}
#    Come back to home screen     ${device}
#*** Settings ***
#Force Tags   pm_home_screen    02  pm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#*** Variables ***
#${wait_time} =  10
#${wait_for_time} =  5
#
#*** Test Cases ***
#TC1: [Home screen] User to verify the DPI set on the device
#    [Tags]  221928  bvt  bvt_pm   sanity_pm
#    [Setup]  Testcase Setup    count=1
#    Verify dp set on device  device=device_1
#    [Teardown]   Run Keywords   Capture on Failure   AND    Come back to home screen     device_list=device_1
#
#TC2: [Home screen] Check Teams App supports 1080p UI
#    [Tags]  221925   bvt   bvt_pm   sanity_pm
#    [Setup]  Testcase Setup     count=1
#    Check teams app supported UI   device=device_1
#    [Teardown]   Run Keywords   Capture on Failure   AND    Come back to home screen   device_list=device_1
#
#TC3: [Home screen] Verify Outgoing screenshare should be 1080p
#    [Tags]  221934   P1
#    [Setup]  Testcase Setup    count=2
#    Verify meeting display on home screen     device=device_1
#    Join meeting   device=device_1:norden    meeting=cnf_device_meeting
#    Wait for Some Time    time=${wait_time}
#    Add participant to conversation using display name   from_device=device_1      to_device=device_2
#    Accept incoming call      device=device_2
#    Close roaster button on participants screen   device=device_1
#    Verify participants list in meeting   device=device_1
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify whiteboard sharing option under more option   device=device_1
#    Check for whiteboard visibility of participants and validate   from_device=device_1    connected_device_list=device_1,device_2
#    Check teams app supported UI   device=device_1
#    Stop presenting whiteboard share screen    device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#

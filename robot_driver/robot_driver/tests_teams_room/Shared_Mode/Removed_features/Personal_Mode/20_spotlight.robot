#*** Settings ***
#Documentation   Meeting created as prerequisite before test execution
#Force Tags    pm_spotlight     pm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#*** Test Cases ***
#TC1 : [Spotlight] TDC user enable spotlight on the DUT user
#     [Tags]  250779     bvt  sanity_pm
#    [Setup]  Testcase Setup     count=3
#    Join Meeting    device=device_1:norden,device_2:,device_3:     meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    verify participants list in meeting     device=device_1
#    make a spotlight   from_device=device_2   to_device=device_1
#    verify spotlight text on device   device=device_1   text=spotlight
#    verify spotlight icon    device=device_3
#    Check meeting lock state   device_list=device_1
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND         Come back to home screen    device_list=device_1,device_2,device_3
#
#TC2 : [Spotlight] TDC user spotlight the remote participant during meeting
#     [Tags]  250785     p2
#    [Setup]  Testcase Setup     count=3
#    Join Meeting    device=device_1:norden,device_2:,device_3:     meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    make a spotlight   from_device=device_2   to_device=device_3
#    verify spotlight text on device   device=device_3   text=spotlight
#    verify spotlight icon    device=device_1
#    remove spotlight for user  from_device=device_2   to_device=device_3
#    verify spotlight icon disable   device=device_1
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND         Come back to home screen    device_list=device_1,device_2
#
#TC3 : [Spotlight] Spotlight overrides the Pin in the meeting
#     [Tags]  250787    p2
#    [Setup]  Testcase Setup     count=4
#    Verify meeting display on home screen     device=device_1
#    Join meeting   device=device_1:norden,device_2:,device_3:,device_4    meeting=cnf_device_meeting
#    make a pin and unpin   from_device=device_1  to_device=device_3
#    verify pin icon     device=device_1
#    make a spotlight   from_device=device_2   to_device=device_4
#    verify spotlight text on device   device=device_4   text=spotlight
#    verify spotlight icon    device=device_1
#    verify pin icon disable     device=device_1
#    End meeting     device=device_1,device_2,device_3,device_4
#    Verify meeting state    device_list=device_1,device_2,device_3,device_4    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen     device_list=device_1,device_2,device_3,device_4
#
#TC4 : [Spotlight] Avatar should be displayed on the screen if the video turned off during the spotlight
#     [Tags]  250806       p1
#    [Setup]  Testcase Setup     count=3
#    Verify meeting display on home screen     device=device_1
#    Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify participants list in meeting     device=device_1
#    make a spotlight   from_device=device_2   to_device=device_3
#    verify spotlight text on device   device=device_3   text=spotlight
#    verify spotlight icon    device=device_1
#    disable video call   device=device_3
#    verify spotlight avatar  device=device_3
#    verify spotlight icon    device=device_3
#    enable video call    device=device_3
#    verify spotlight icon    device=device_3
#    remove spotlight for user  from_device=device_2   to_device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2,device_3  state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3
#
#TC5 : [Spotlight] Spotlighted should end once the spotlighted user leave the meeting
#     [Tags]  250793  bvt    sanity_pm
#    [Setup]  Testcase Setup     count=3
#    Verify meeting display on home screen     device=device_1
#    Join meeting   device=device_1:norden,device_2:,device_3:     meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    Verify participants list in meeting     device=device_1
#    make a spotlight   from_device=device_2   to_device=device_1
#    verify spotlight text on device   device=device_1   text=spotlight
#    End meeting     device=device_1
#    Join meeting   device=device_1:     meeting=cnf_device_meeting
#    verify spotlight icon disable       device=device_1
#    End meeting     device=device_1,device_2,device_3
#    Verify meeting state    device_list=device_1,device_2  state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3
#

*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Test Cases ***
TC1:[Spotlight] TDC user enable spotlight on the DUT user
    [Tags]  237957  bvt     bvt_sm      sanity_sm
    [Setup]    Testcase Setup for Meeting User   count=3
    Join Meeting    device=device_1,device_2,device_3     meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    make a spotlight   from_device=device_2   to_device=device_1:meeting_user
    verify spotlight text on device   device=device_1   text=spotlight
    Close participants screen   device=device_2
    Verify spotlight icon on top left in the meeting  device=device_1
    Check meeting lock state   device_list=device_1
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2,device_3

TC2:[Spotlight] Avatar should be displayed on the screen if the video turned off during the spotlight
    [Tags]      237974    sanity_sm    p1
    [Setup]    Testcase Setup for Meeting User   count=3
    Join Meeting    device=device_1,device_2,device_3     meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    make a spotlight   from_device=device_2   to_device=device_3
    verify spotlight text on device   device=device_3   text=spotlight
    Close participants screen   device=device_2
    verify spotlight icon    device=device_1
    disable video call   device=device_3
    verify spotlight icon    device=device_3
    verify spotlight avatar  device_list=device_3
    enable video call    device=device_3
    verify spotlight icon    device=device_3
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3

TC3:[Spotlight] User clicking on spotlight icon there should be an option displayed to remove spotlight
     [Tags]  237970    p1
    [Setup]    Testcase Setup for Meeting User   count=3
    Join Meeting    device=device_1,device_2,device_3     meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    make a spotlight   from_device=device_2   to_device=device_1:meeting_user
    verify spotlight text on device   device=device_1   text=spotlight
    Close participants screen   device=device_2
    verify spotlight icon    device=device_3
    Remove spotlight from other user  from_device=device_2   to_device=device_1:meeting_user
    verify spotlight text on device   device=device_1   text=no_spotlight
    Close participants screen   device=device_2
    verify spotlight icon disable       device=device_3
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3

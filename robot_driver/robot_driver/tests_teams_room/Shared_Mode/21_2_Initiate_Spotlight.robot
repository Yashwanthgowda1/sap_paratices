*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Test Cases ***
TC1:[Initiate Spotlight] Verify that spotlighted participant is spotlighted to remote participants.
    [Tags]      379727       bvt    bvt_sm      sanity_sm
   [Setup]    Testcase Setup for Meeting User   count=3
    Join Meeting    device=device_1,device_2,device_3     meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    make a spotlight   from_device=device_1      to_device=device_2
    verify spotlight text on device   device=device_2   text=spotlight
    Close participants screen   device=device_1
    verify spotlight icon    device=device_2
    Verify spotlight icon on top left in the meeting  device=device_2
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2,device_3

TC2:[Initiate Spotlight] Verify stop spotlight locally and remotely.
    [Tags]     379734    P1      sanity_sm
    [Setup]    Testcase Setup for Meeting User   count=3
    Join Meeting    device=device_1,device_2,device_3    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    make a spotlight   from_device=device_1          to_device=device_1:meeting_user
    verify spotlight text on device   device=device_1   text=spotlight
    Close participants screen   device=device_1
    remove spotlight     from_device=device_1         to_device=device_1:meeting_user
    verify spotlight text on device   device=device_1   text=no_spotlight
    Close participants screen   device=device_1
    make a spotlight   from_device=device_1          to_device=device_2
    verify spotlight text on device   device=device_2   text=spotlight
    Close participants screen   device=device_1
    remove spotlight     from_device=device_1         to_device=device_2
    verify spotlight text on device   device=device_2   text=no_spotlight
    Close participants screen   device=device_1
    verify spotlight icon disable      device=device_1
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3

TC3:[Initiate Spotlight] Check spotlight option while user is in connecting page.
    [Tags]     381788      P2
    [Setup]    Testcase Setup for Meeting User   count=3
    Join Meeting    device=device_1,device_2    meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_3
    make a spotlight   from_device=device_1          to_device=device_3
    Verify user should not spotlight while in connecting page   device=device_1
    Close participants screen   device=device_1
    Verify meeting state    device_list=device_1,device_2    state=Connected
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2,device_3

*** Keywords ***
remove spotlight
  [Arguments]       ${from_device}        ${to_device}
  Remove spotlight from other user  ${from_device}        ${to_device}

verify the start spotlight
    [Arguments]       ${from_device}        ${to_device}
    make a spotlight   ${from_device}        ${to_device}
    Close participants screen   device=device_1

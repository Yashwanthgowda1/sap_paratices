*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Setup     Meeting Setup
Suite Teardown    Run keywords    Suite Failure Capture    AND    clear meetings from calendar tab    devices=device_1,device_2

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Reactions] DUT user to verify the reactions button in docked ubar while in call
    [Tags]   306289  sanity_tpc  P1
    [Setup]    Testcase Setup for Meeting User   count=2
    Join Meeting    device=device_1     meeting=Reactions       join_styles=conference
    Verify meeting state   device_list=device_1   state=Connected
    Verify reaction button in call control     device=device_1
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]    Run Keywords    Capture on Failure  AND    test case teardown    devices=device_1,device_2    count=2

TC2 : [Reactions] DUT user to verify the presence of reactions button in docked ubar while in call
    [Tags]  306288   bvt_tpc     sanity_tpc  P0
    [Setup]    Testcase Setup for Meeting User   count=2
    Join Meeting    device=device_1     meeting=Reactions       join_styles=conference
    Verify meeting state   device_list=device_1   state=Connected
    Verify reaction button in call control     device=device_1
    Tap on reaction button in call control      device=device_1
    End meeting     device=device_1
    Verify meeting state    device_list=device_1  state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND    test case teardown    devices=device_1,device_2    count=2

TC3 : [Reactions] DUT user to verify the reactions in the reaction window
    [Tags]  306294   bvt_tpc     sanity_tpc  P0
    [Setup]     Testcase Setup for Meeting User   count=1
    Join Meeting    device=device_1     meeting=Reactions       join_styles=conference
    Verify meeting state   device_list=device_1   state=Connected
    Verify reaction button in call control     device=device_1
    Tap on reaction button in call control      device=device_1
    Verify presence of reactions button in call control     device=device_1
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]   run keywords   Capture on Failure    AND    test case teardown    devices=device_1,device_2    count=2

TC4 : [Reactions] Raise hand should not be displayed separately when reactions button is available in docked ubar
    [Tags]  306299   bvt_tpc     sanity_tpc  P0
    [Setup]    Testcase Setup for Meeting User   count=1
    Join Meeting    device=device_1     meeting=Reactions       join_styles=conference
    Verify meeting state   device_list=device_1   state=Connected
    Verify reaction button in call control     device=device_1
    Tap on reaction button in call control      device=device_1
    Verify presence of reactions button in call control     device=device_1
    verify raise hand reaction     device=device_1
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]   run keywords   Capture on Failure    AND    test case teardown    devices=device_1,device_2    count=2

TC5 : [Reactions]Observe reactions when DUT rejoins the meeting
    [Tags]  319596   p2
    [Setup]    Testcase Setup for Meeting User   count=3
    Join Meeting    device=device_1,device_2,device_3      meeting=Reactions     join_styles=conference,None,None
    Verify meeting state   device_list=device_1,device_2,device_3     state=Connected
    Raise hand     device=device_1
    Verify raise hand    from_device=device_2    to_device=device_1     status=on
    End meeting     device=device_1
    Join Meeting    device=device_1         meeting=Reactions        join_styles=conference
    Verify meeting state    device_list=device_1,device_2,device_3      state=Connected
    Raise hand     device=device_1
    Verify raise hand    from_device=device_2    to_device=device_1     status=on
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]   run keywords   Capture on Failure    AND    test case teardown    devices=device_1,device_2,device_3   count=3

TC6 : [Reactions] Reactions invoked by the user should be shown in the local preview
    [Tags]       306309
    [Setup]    Testcase Setup for Meeting User   count=2
    Join Meeting    device=device_1,device_2     meeting=Reactions      join_styles=conference,None
    Verify meeting state   device_list=device_1,device_2   state=Connected
    Verify reaction button in call control     device=device_1
    Tap on reaction button in call control      device=device_1
    Tap on like button     device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2  state=Disconnected
    [Teardown]   run keywords   Capture on Failure    AND    test case teardown    devices=device_1,device_2   count=2

TC7 : [Reactions] DUT user to verify the raise hand feature from reactions window
    [Tags]  306308   p2
    [Setup]    Testcase Setup for Meeting User   count=2
    Join Meeting    device=device_1,device_2     meeting=Reactions       join_styles=conference,None
    Verify meeting state   device_list=device_1,device_2   state=Connected
    Verify reaction button in call control     device=device_1
    Tap on reaction button in call control      device=device_1
    Verify presence of reactions button in call control     device=device_1
    Raise hand     device=device_1
    Verify raise hand    from_device=device_2    to_device=device_1     status=on
    Lower hand     device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   run keywords   Capture on Failure    AND    test case teardown    devices=device_1,device_2   count=2

TC8 : [Reactions] DUT user to verify the auto-play of reactions in the reaction window
    [Tags]  306306   p2
    [Setup]    Testcase Setup for Meeting User   count=2
    Join Meeting    device=device_1     meeting=Reactions        join_styles=conference
    Verify meeting state   device_list=device_1   state=Connected
    Verify reaction button in call control     device=device_1
    Tap on reaction button in call control      device=device_1
    Verify presence of reactions button in call control     device=device_1
    verify raise hand reaction     device=device_1
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]   run keywords   Capture on Failure    AND    test case teardown    devices=device_1,device_2    count=2

*** Keywords ***
Meeting Setup
    clear meetings from calendar tab    devices=device_1,device_2
    create meeting    device=device_2       participants=device_1:meeting_user,device_3     meeting=Reactions

Test Case Teardown
    [Arguments]     ${devices}      ${count}
    check for device count      count=${count}
    Come back to home screen    device_list=${devices}
    Close dial pad  device=device_1
    Teardown Meeting Test Case     ${devices}

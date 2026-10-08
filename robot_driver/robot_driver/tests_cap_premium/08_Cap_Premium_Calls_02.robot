*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown      Suite Failure Capture

*** Variables ***
${wait_time} =  10
${2wait_time} =  20
${2m_wait_time} =  2 minutes

*** Test Cases ***
TC1 : [Advanced calling] [Calls] Calling from favorites tab
    [Tags]  329264        BVT_CAPPremium     Sanity_CAPPremium
    [Setup]   Run keywords   Testcase Setup for CAP Premium User    count=3   AND     Make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1  item=favorite
    Verify added favorite user in favorites page    from_device=device_1     to_device=device_2
    Calling from favorite page   from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   run keywords  Capture on Failure    AND   Remove user from group   from_device=device_1    to_device=device_2     group_names=Speed dial  AND   Come back to home screen       device_list=device_1,device_2

TC2 : [Advance calling][Call Park] DUT user to park and retrieve the incoming call from TDC
    [Tags]  329277    BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User   count=2
    click on calls tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2

TC3 : [Advanced calling] [Call Hold] DUT user hold the call with TDC
    [Tags]  329377     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User    count=2
    click on calls tab    device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Hold
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    repeat keyword   4 times    Verify hold resume scenario
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC4 : [Advanced calling] [Call Hold] DUT user toggle hold/resume between two TDC users
    [Tags]  329376    P1     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User    count=3
    click on calls tab    device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    click on calls tab    device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1:cap_search_enabled
    Pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2     state=Hold
    Resume call from call hold banner     device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify Call State    device_list=device_3     state=Hold
    Resume call from call hold banner     device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2     state=Hold
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC5 : [Advance calling][Call Park] DUT user to park and retrieve the outgoing call with TDC
    [Tags]  329278    P2
    [Setup]  Testcase Setup for CAP Premium User    count=2
    click on calls tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2


TC6 : [Auto Dismiss] Rate my call screen should not auto dismiss if the user start submitting the rating
    [Tags]   318640      P1     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User    count=2
    click on calls tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Wait for Some Time    time=${2m_wait_time}
    Disconnect call and verify call rating screen     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC7 : [Advance calling][Call Park] TDC user to park and retrieve the incoming call from DUT
    [Tags]  329370    P2
    [Setup]  Testcase Setup for CAP Premium User    count=2
    click on calls tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_2
    Verify Call State    device_list=device_1   state=Hold
    Unpark Call    ${call_park_code}    device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2

TC8 : [Advance calling][Call Mute] User to test Mute/unmute the call from UI/hard mute key
    [Tags]  448306   BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User    count=2
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_1
    Verify Call mute State    device_list=device_1    state=mute
    Unmutes the phone call  device=device_1
    Verify Call mute State    device_list=device_1    state=Unmute
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC9 : [Advance calling][Call Hold] DUT user can hold the muted call
    [Tags]  448314     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User    count=2
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_1
    Verify Call mute State    device_list=device_1    state=mute
    Hold the call   device=device_1
    Verify Call State    device_list=device_1    state=Hold
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    Verify Call mute State    device_list=device_1    state=mute
    Unmutes the phone call  device=device_1
    Verify Call mute State    device_list=device_1    state=Unmute
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2


*** Keywords ***
Advance calling Setup
    Verify and enable advance calling option       device=device_1

Make outgoing call for call log
    [Arguments]     ${from_device}   ${to_device}
    click on calls tab     device=${from_device}
    Make outgoing call using display name      from_device=${from_device}      to_device=${to_device}
    Verify Incoming call    device=${to_device}     status=appear
    Pick incoming call      device=${to_device}
    Disconnect call     device=${from_device}
    Verify Call State    device_list=${from_device}     state=Disconnected
    Come back to home screen    device_list=${from_device}
    click on calls tab    device=${from_device}
    Refresh calls main tab    device=${from_device}

Verify hold resume scenario
    Hold the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Hold
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
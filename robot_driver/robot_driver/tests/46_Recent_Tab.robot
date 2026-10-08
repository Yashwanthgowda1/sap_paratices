*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation      Suite Setup Requirements : This suite requires minimum of 2 devices in config
...                Purpose: Device_2 should be added as a favorite on Device_1 from recent call history


Suite Setup     recent tab suite setup
Suite Teardown    Run Keywords      Suite Failure Capture     AND    Come back to home screen    device_list=device_1,device_2

*** Variables ***
${wait_time} =  10
${2_minutes_wait_time} =  2 minutes


*** Test Cases ***
TC1 : Verify by default All call history should be selected.
    [Tags]      416871    P0   bvt_tp    sanity_tp      bvt_pr
    [Setup]  Testcase Setup    count=1
    navigate to calls tab        device=device_1
    verify default all call history should be selected  device=device_1
    verify sorting options in recent tab  device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    set default sorting option in recent tab    device=device_1     AND    Come back to home screen    device_list=device_1

TC2 : Verify the recent tab when user selects Missed call only from Sort button.
    [Tags]      416891    P0   bvt_tp    sanity_tp
    [Setup]  Testcase Setup    count=1
    verify sorting options in recent tab  device=device_1
    verify specific sorting option recent tab  device=device_1      option=missed
    verify option names in sorting button   device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    set default sorting option in recent tab    device=device_1     AND    Come back to home screen    device_list=device_1

TC3 : Verify the Ongoing Active call UI under Recent tab.
    [Tags]      416924    P0   bvt_tp    sanity_tp      bvt_pr
    [Setup]  Testcase Setup    count=2
    verify sorting options in recent tab  device=device_1
    set default sorting option in recent tab    device=device_1
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify ongoing call notification in recent tab      from_device=device_1      to_device=device_2
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    set default sorting option in recent tab    device=device_1     AND    Come back to home screen    device_list=device_1

TC4 : Verify the DUT user able to Resume the call from Resume button in Ongoing section under Recent tab.
    [Tags]      416940    P0   bvt_tp    sanity_tp
    [Setup]  Testcase Setup    count=2
    verify sorting options in recent tab  device=device_1
    set default sorting option in recent tab    device=device_1
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify ongoing call notification in recent tab      from_device=device_1      to_device=device_2
    tap to return to call   device=device_1
    Hold the call   device=device_1
    Verify Call State    device_list=device_1    state=Hold
    resume the call from recent tab notification     from_device=device_1      to_device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    set default sorting option in recent tab    device=device_1     AND    Come back to home screen    device_list=device_1

TC5 : Verify the pill count beside Recent under Calls tab
    [Tags]      416938    P0   bvt_tp    sanity_tp
    [Setup]  Testcase Setup    count=2
    navigate to calls tab   device=device_1
    Refresh calls main tab    device=device_1
    Come back to home screen    device_list=device_1
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1      status=appear
    Disconnect call     device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_1    state=Disconnected
    Wait for Some Time    time=${wait_time}
    verify calls recent tab pill count      from_device=device_1      to_device=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2

TC6 : Verify the functionality of Resume button under ongoing section in Recent tab.
    [Tags]      416941    P0   bvt_tp    sanity_tp
    [Setup]  Testcase Setup    count=2
    verify sorting options in recent tab  device=device_1
    set default sorting option in recent tab    device=device_1
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1      status=appear
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    verify and resume call for parked call at recent tab    park_code=${call_park_code}     from_device=device_1      to_device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure     AND     Come back to home screen      device_list=device_1,device_2

TC7 : Verify Resume button gets dismissed by itself after 2 mins and there is no option to cancel the Resume button under recent tab
    [Tags]      416943    P0   bvt_tp    sanity_tp
    [Setup]  Testcase Setup    count=2
    verify sorting options in recent tab  device=device_1
    set default sorting option in recent tab    device=device_1
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1      status=appear
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    verify and resume call for parked call at recent tab    park_code=${call_park_code}     from_device=device_1      to_device=device_2    option=verify
    Wait for Some Time    time=${2_minutes_wait_time}
    verify resume button dismissed after 2 minutes      device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC8 : Verify the options present under Recent tab
    [Tags]      416868    P1
    [Setup]  Testcase Setup    count=1
    verify sorting options in recent tab  device=device_1
    set default sorting option in recent tab    device=device_1
    verify calls recent tab     device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND       Come back to home screen    device_list=device_1

TC9 : Verify the functionality of Info button beside a participant list.
    [Tags]      416921    P1
    [Setup]  Testcase Setup    count=2
    verify sorting options in recent tab  device=device_1
    set default sorting option in recent tab    device=device_1
    verify calls recent tab     device=device_1
    make outgoing call for call log
    verify latest call details     from_device=device_1      to_device=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND       Come back to home screen    device_list=device_1

TC10 : Verify the functionality of an info pop-up when DUT user accepts and disconnect the incoming call.
    [Tags]      416932   sanity_tp    P1
    [Setup]  Testcase Setup    count=2
    verify sorting options in recent tab  device=device_1
    set default sorting option in recent tab    device=device_1
    verify calls recent tab     device=device_1
    make outgoing call for call log
    verify latest call details     from_device=device_1      to_device=device_2     option=verify_pop_up
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1      status=appear
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    verify option in latest call details    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND       Come back to home screen    device_list=device_1,device_2

TC11 : Verify Dismiss option should present inside the More info icon for ongoing call
    [Tags]      416944   sanity_tp       P1
    [Setup]  Testcase Setup    count=2
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1      status=appear
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify dismiss option should not present inside the more info icon for ongoing call  from_device=device_1      to_device=device_2
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND       Come back to home screen    device_list=device_1,device_2

TC12 : Verify the functionality of the dropdown icon beside All/Incoming/Outgoing/Missed options under the Recent tab.
    [Tags]      416878       P2
    [Setup]  Testcase Setup    count=1
    verify sorting options in recent tab  device=device_1
    set default sorting option in recent tab    device=device_1
    verify calls recent tab     device=device_1
    Verify the functionality of the dropdown icon beside all options under the recent tab     device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    set default sorting option in recent tab    device=device_1     AND    Come back to home screen    device_list=device_1

TC13 : Verify the functionality of the sort button under the Recect tab.
    [Tags]      416880       P2
    [Setup]  Testcase Setup    count=1
    verify sorting options in recent tab  device=device_1
    set default sorting option in recent tab    device=device_1
    verify calls recent tab     device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    set default sorting option in recent tab    device=device_1     AND    Come back to home screen    device_list=device_1

TC14 : Verify the DUT should display Resume button with TDC username under Ongoing section in Recent tab, when DUT user puts call on hold.
    [Tags]      416926       P2
    [Setup]  Testcase Setup    count=2
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
	Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify ongoing call notification in recent tab      from_device=device_1      to_device=device_2
    tap to return to call   device=device_1
    Hold the call   device=device_1
    Verify Call State    device_list=device_1    state=Hold
    resume the call from recent tab notification     from_device=device_1      to_device=device_2       option=verify
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND        Come back to home screen    device_list=device_1,device_2

TC15 : Verify presence of Recent tab on DUT.
    [Tags]      416832       P2
    [Setup]  Testcase Setup    count=1
    verify calls recent tab     device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND       Come back to home screen    device_list=device_1

TC16 : Verify the DUT should display Resume button under Ongoing section in Recent tab ,when DUT user park a call.
    [Tags]      416929    P2
    [Setup]  Testcase Setup    count=2
    verify sorting options in recent tab  device=device_1
    set default sorting option in recent tab    device=device_1
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    verify and resume call for parked call at recent tab    park_code=${call_park_code}     from_device=device_1      to_device=device_2    option=verify
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC17 : Verify the options present inside the info icon for Parked call under ongoing section in Recent tab
    [Tags]      416945    P2
    [Setup]  Testcase Setup    count=2
    verify sorting options in recent tab  device=device_1
    set default sorting option in recent tab    device=device_1
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    verify and resume call for parked call at recent tab    park_code=${call_park_code}     from_device=device_1      to_device=device_2    option=verify
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC18 :Verify the options present inside the info icon for resumed call under ongoing section in Recent tab
    [Tags]      416946    P1   sanity_tp
    [Setup]  Testcase Setup    count=2
    verify sorting options in recent tab  device=device_1
    set default sorting option in recent tab    device=device_1
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify ongoing call notification in recent tab      from_device=device_1      to_device=device_2
    tap to return to call   device=device_1
    Hold the call   device=device_1
    Verify Call State    device_list=device_1    state=Hold
    resume the call from recent tab notification in more option     from_device=device_1      to_device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    set default sorting option in recent tab    device=device_1     AND    Come back to home screen    device_list=device_1

TC19 : Verify Resume button disappears once call is ended
    [Tags]      416947    P2
    [Setup]  Testcase Setup    count=2
    verify sorting options in recent tab  device=device_1
    set default sorting option in recent tab    device=device_1
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1    state=Hold
    verify ongoing call notification in recent tab          from_device=device_1      to_device=device_2
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    verify resume button dismissed after 2 minutes      device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    set default sorting option in recent tab    device=device_1     AND    Come back to home screen    device_list=device_1

TC20 : Verify the Voicemail option should not present when user tap on sort icon in Recent tab.
    [Tags]      416894    P2
    [Setup]  Testcase Setup    count=1
    verify sorting options in recent tab  device=device_1
    set default sorting option in recent tab    device=device_1
    verify option names in sorting button   device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    set default sorting option in recent tab    device=device_1     AND    Come back to home screen    device_list=device_1

TC21 : Verify DUT user1 Resume button Disappeared after 2 mins while parked call.
    [Tags]      416942    P2
    [Setup]  Testcase Setup    count=2
    verify sorting options in recent tab  device=device_1
    set default sorting option in recent tab    device=device_1
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1      status=appear
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    verify and resume call for parked call at recent tab    park_code=${call_park_code}     from_device=device_1      to_device=device_2    option=verify
    Wait for Some Time    time=${2_minutes_wait_time}
    verify resume button dismissed after 2 minutes      device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC22 :[SLA] Verify the Recent tab when DUT user selects Incoming only from the sort of button in recent tab.
    [Tags]      416885    P2
    [Setup]  Testcase Setup    count=1
    verify sorting options in recent tab  device=device_1
    verify specific sorting option recent tab  device=device_1      option=incoming
    verify option names in sorting button   device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    set default sorting option in recent tab    device=device_1     AND    Come back to home screen    device_list=device_1

TC23 : [Calls]Calling from Recent tab and Verify Recent calls tab for new user
    [Tags]  309303   sanity_tp
    [Setup]  Testcase Setup    count=2
    Verify call entries are synced in call log    from_device=device_1      to_device=device_2
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Verify Incoming call    device=device_2      status=appear
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    return to home screen    device_list=device_1
    click on calls tab   device=device_1
    verify specific sorting option recent tab  device=device_1      option=incoming
    verify specific sorting option recent tab  device=device_1      option=outgoing
    verify specific sorting option recent tab  device=device_1      option=missed
    [Teardown]   Run Keywords    Capture on Failure  AND    set default sorting option in recent tab    device=device_1     AND    Come back to home screen    device_list=device_1

*** Keywords ***
recent tab suite setup
    Testcase Setup    count=2
    make outgoing call for call log
    Select call list item   device=device_1  item=favorite
    Verify added favorite user in favorites page    from_device=device_1     to_device=device_2
    Verify call views option under callings settings    device=device_1
    Select default view    device=device_1      option=speed dial
    return to home screen    device_list=device_1
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1    state=Disconnected
    return to home screen    device_list=device_1


Make outgoing call for call log
    Navigate to calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1      status=appear
    Disconnect call     device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    Navigate to calls tab   device=device_1
    Refresh calls main tab    device=device_1
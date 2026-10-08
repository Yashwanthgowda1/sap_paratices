*** Settings ***
Resource    ../resources/keywords/common.robot


Suite Setup     recent tab suite setup
Suite Teardown    Run Keywords      Suite Failure Capture     AND    Come back to home screen    device_list=device_1,device_2   AND   Remove favorite user from favorites page    from_device=device_1     to_device=device_2

*** Variables ***
${wait_time} =  10
${2_minutes_wait_time} =  2 minutes


*** Test Cases ***
TC1 : [SLA] Verify by default All call history should be selected.
    [Tags]     417036      BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User     count=1
    navigate to calls tab        device=device_1
    verify default all call history should be selected   device=device_1
    verify sorting options in recent tab   device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    set default sorting option in recent tab    device=device_1     AND    Come back to home screen    device_list=device_1

TC2 : [SLA] Verify the recent tab when user selects Missed call only from Sort button.
    [Tags]     417041     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User    count=1
    verify sorting options in recent tab  device=device_1
    verify specific sorting option recent tab  device=device_1      option=missed
    verify option names in sorting button   device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    set default sorting option in recent tab    device=device_1     AND    Come back to home screen    device_list=device_1

TC3 : [SLA] Verify the Ongoing Active call UI under Recent tab.
    [Tags]      417044      BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User    count=2
    verify sorting options in recent tab   device=device_1
    set default sorting option in recent tab    device=device_1
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify ongoing call notification in recent tab      from_device=device_1      to_device=device_2
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    set default sorting option in recent tab    device=device_1     AND    Come back to home screen    device_list=device_1,device_2

TC4 : [SLA] Verify the DUT user able to Resume the call from Resume button in Ongoing section under Recent tab.
    [Tags]     417049    BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User     count=2
    verify sorting options in recent tab    device=device_1
    set default sorting option in recent tab    device=device_1
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
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
    [Teardown]   Run Keywords    Capture on Failure  AND    set default sorting option in recent tab    device=device_1     AND    Come back to home screen    device_list=device_1,device_2

TC5 : [SLA] Verify the pill count beside Recent under Calls tab
    [Tags]      417048     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User   count=2
    navigate to calls tab   device=device_1
    Refresh calls main tab    device=device_1
    Come back to home screen    device_list=device_1
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Verify Incoming call    device=device_1      status=appear
    Disconnect call     device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_1    state=Disconnected
    Wait for Some Time    time=${wait_time}
    verify calls recent tab pill count      from_device=device_1      to_device=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2

*** Keywords ***
recent tab suite setup
    make outgoing call for call log
    Select call list item   device=device_1  item=favorite
    Verify added favorite user in favorites page    from_device=device_1     to_device=device_2
    Verify call views option under callings settings    device=device_1
    Select default view    device=device_1      option=speed dial
    Come back to home screen    device_list=device_1
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1    state=Disconnected
    return to home screen    device_list=device_1

make outgoing call for call log
    Navigate to calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Verify Incoming call    device=device_1      status=appear
    Disconnect call     device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    Navigate to calls tab   device=device_1
    Refresh calls main tab    device=device_1
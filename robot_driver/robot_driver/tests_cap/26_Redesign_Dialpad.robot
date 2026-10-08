*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown      Run Keywords    Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [4/5 inch] Verify the search for people option present under People tab when user signed in with search enabled account.
    [Tags]  420165      bvt_cap  sanity_cap
    [Setup]   Testcase Setup for CAP User    count=2
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : [4/5 inch] Verify the DUT user able to call the favorite contacts present under people tab.
    [Documentation]  Precondition : device_1:cap_search_disabled should add device_2 as a speed dial.
    [Tags]  420173      bvt_cap  sanity_cap
    [Setup]   Testcase Setup for CAP User    count=2
    verify home screen UI for cap     device=device_1
    calling from people tab when speed dial is added for cap     from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3 : [4/5 inch] Verify user can delete the numeric digits successfully.
    [Tags]   420176      P1
    [Setup]  Testcase Setup for CAP User    count=1
    verify home screen UI for cap     device=device_1
    dial and clear invalid number for cap   device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC4 : [4/5 inch] Verify the DUT user able to call the Searched user (TDC user) from search for people option.
     [Tags]    420169     P1
     [Setup]  Testcase Setup for CAP User    count=2
     verify home screen UI for cap     device=device_1
     navigate to people tab from home screen for cap    device=device_1
     make outgoing call using display name    from_device=device_1      to_device=device_2
     Pick incoming call    device=device_2
     Wait for Some Time    time=${wait_time}
     Verify Call State    device_list=device_1,device_2    state=Connected
     Disconnect call    device=device_1
     Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC5 : [4/5 inch] Verify the UI when user signed in with search enabled account.
    [Tags]    420168      P2
    [Setup]  Testcase Setup for CAP User    count=2
    verify home screen UI for cap     device=device_1
    navigate to people tab from home screen for cap    device=device_1
    Search Text   from_device=device_1      to_device=device_2
    Validate search results presented    device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC6 : [4/5 Icnh] Verify that Dark theme works fine in in-call dial pad
    [Tags]   438671      P2
    [Setup]  Testcase Setup for CAP User    count=2
    Verify and enable dark theme     device=device_1
    device right corner click      device=device_1
    click on people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    verify and disable dark theme     device_1

TC7 : [4/5 inch] Verify the search for people option is not present under People tab when user signed in with search disabled account.
    [Tags]  420166    bvt_cap    sanity_cap
    [Setup]   Testcase Setup for CAP Search Disable User    count=1
    Verify search option is disabled    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1

TC8 : [4/5 inch] Verify the dial pad when user signed in with search disabled account.
    [Tags]   420164    P2
    [Setup]   Testcase Setup for CAP Search Disable User    count=1
    verify home screen UI for cap     device=device_1       user_type=cap_search_disabled
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1

*** Keywords ***

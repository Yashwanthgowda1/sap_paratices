*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Search] Search for contact by entering a search string without typing the complete contact name
    [Tags]    305863       bvt_tpc     sanity_tpc      
    [Setup]  Testcase Setup for Meeting User    count=2
    Navigate to people tab    device=device_1
    Search Text   from_device=device_1      to_device=device_2
    Validate search results presented    device=device_1
    [Teardown]    Run Keywords    Capture on Failure   AND    Navigate to calendar tab    device=device_1

TC2 :[Search] Recent search tab is empty
    [Tags]    305808   
    [Setup]   Testcase Setup for Meeting User  count=2
    Navigate to people tab    device=device_1
    verify search text   from_device=device_1   to_device=device_2
    Validate search results presented   device=device_1
    Come back to home screen    device_list=device_1
    Navigate to people tab    device=device_1
    Verify recent search empty    device=device_1
    [Teardown]    Run Keywords   Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2

TC3 : [Search] Search result should display
    [Tags]        314093       bvt_tpc       sanity_tpc
    [Setup]   Testcase Setup for Meeting User    count=3
    Navigate to people tab    device=device_1
    verify search text   from_device=device_1     to_device=device_2
    Validate search results presented    device=device_1
    verify search text   from_device=device_1     to_device=device_3
    Validate search results presented    device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4 :[Search]DUT user can search TDC user and place P2P call
    [Tags]     314091    sanity_tpc  P1
    [Setup]   Testcase Setup for Meeting User    count=2
    Select user presence   device=device_2     state=available
    Navigate to people tab    device=device_1
    verify search text   from_device=device_1   to_device=device_2
    Validate search results presented    device=device_1
    Verify user presence from other user    from_device=device_1      to_device=device_2     state=Available
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    pick incoming call   device=device_2
    verify call state  device_list=device_1,device_2    state=connected
    disconnect call   device=device_1
    verify call state  device_list=device_1,device_2    state=disconnected
    [Teardown]    Run Keywords   Capture on Failure  AND   Come back to home screen   device_list=device_1,device_2

TC5 :[Search] Recent search tab is filled - subsequent search
    [Tags]    314092     P1
    [Setup]   Testcase Setup for Meeting User    count=2
    Navigate to people tab    device=device_1
    verify search text    from_device=device_1   to_device=device_2
    Validate search results presented    device=device_1
    navigate to calendar tab  device=device_1
    Navigate to people tab    device=device_1
    verify search text   from_device=device_1   to_device=device_2
    Validate search results presented    device=device_1
    [Teardown]    Run Keywords   Capture on Failure  AND   Come back to home screen   device_list=device_1,device_2

TC6 : [Search] Newly created user can search for the other users using search option
    [Tags]    305877   P2
    [Setup]   Testcase Setup for Meeting User    count=2
    Navigate to people tab    device=device_1
    verify search text   from_device=device_1   to_device=device_2
    Validate search results presented    device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***

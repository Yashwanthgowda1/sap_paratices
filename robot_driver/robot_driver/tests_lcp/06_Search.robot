*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1: [Search] Search for contact by entering a search string without typing the complete contact name
    [Tags]  243236    bvt_lcp     sanity_lcp        Certification_lcp
    [Setup]  Testcase Setup     count=2
    Navigate to people tab    device=device_1
    Search Text   from_device=device_1      to_device=device_2
    Validate search results presented    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2: [Search] Recent search result should display on top of recent search history
    [Tags]  242982      bvt_lcp     sanity_lcp        Certification_lcp
    [Setup]  Testcase Setup     count=2
    Navigate to people tab    device=device_1
    verify search text             from_device=device_1           to_device=device_2
    Validate search results presented    device=device_1
    verify recent search item      from_device=device_1   to_device=device_2
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3: [Search] DUT user can search TDC user and place P2P call
    [Tags]  242886     sanity_lcp        Certification_lcp
    [Setup]  Testcase Setup     count=2
    Navigate to people tab    device=device_1
    Search Text   from_device=device_1      to_device=device_2
    Validate search results presented    device=device_1
    select user presence   device=device_2    state=Available
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC4: [Search] Newly created user can search for the other users using search option
    [Tags]  243285
    [Setup]  Testcase Setup     count=2
    Navigate to people tab    device=device_1
    Search Text   from_device=device_1      to_device=device_2
    Validate search results presented    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC5: [Search] DUT user is on People Tab and search for the other users
    [Tags]  264913
    [Setup]  Testcase Setup     count=2
    Navigate to people tab    device=device_1
    Search Text   from_device=device_1      to_device=device_2
    Validate search results presented    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC6: [Search] Recent search tab is empty - If this is the first time search
    [Tags]  242978     
    [Setup]  Testcase Setup     count=2
    Navigate to people tab    device=device_1
    verify recent search empty    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2


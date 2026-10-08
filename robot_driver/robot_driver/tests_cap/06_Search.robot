*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Search] Search for contact by entering a search string without typing the complete contact name
    [Tags]  148998   P1    bvt_cap   sanity_cap        Certification_cap
    [Setup]  Testcase Setup for CAP User    count=2
    navigate to people tab     device=device_1
    Search Text   from_device=device_1      to_device=device_2
    Validate search results presented    device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC2 :[Search] Recent search tab should be empty
    [Tags]    148764   P2
    [Setup]   Testcase Setup for CAP User   count=1
    navigate to people tab     device=device_1
    Verify recent search empty    device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND  Come back to home screen    device_list=device_1

TC3 :[Search] DUT user can search TDC user and place P2P call
    [Tags]    148676  P1     sanity_cap
    [Setup]   Testcase Setup for CAP User   count=2
    navigate to people tab     device=device_1
    Verify search text   from_device=device_1    to_device=device_2
    Select user presence   device=device_2    state=Available
    Come back to home screen    device_list=device_1
    click on people tab    device=device_1
    Make outgoing call using display name    from_device=device_1   to_device=device_2
    Pick incoming call   device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call   device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2

TC4 :[Search] Search for a contact with complete contact name in Teams app
    [Tags]    148674  P1        Certification_cap
    [Setup]   Testcase Setup for CAP User   count=2
    navigate to people tab     device=device_1
    Verify search text   from_device=device_1     to_device=device_2
    Validate search results presented    device=device_1
    [Teardown]    Run Keywords   Capture on Failure  AND   Come back to home screen   device_list=device_1,device_2

TC5 : [Search] Newly created user can search for the other users using search option
     [Tags]    314083   P2
     [Setup]   Testcase Setup for CAP User    count=2
     navigate to people tab     device=device_1
     Search Text   from_device=device_1      to_device=device_2
     Validate search results presented    device=device_1
     [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2

TC6 : [Search] Recent search tab is filled - subsequent search
    [Tags]    314080    P1
    [Setup]  Testcase Setup for CAP User   count=2
    navigate to people tab     device=device_1
    Search Text   from_device=device_1      to_device=device_2
    Validate search results presented    device=device_1
    Come back to home screen    device_list=device_1
    navigate to people tab     device=device_1
    get search text validate    from_device=device_1    to_device=device_2
    [Teardown]    Run Keywords    Capture on Failure   AND   Come back to home screen   device_list=device_1,device_2

TC7 : [Search] Recent search tab is empty - If this is the first time search
    [Tags]    314079   P1
    [Setup]   Testcase Setup for CAP User   count=1
    navigate to people tab     device=device_1
    verify recent search empty    device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND  Come back to home screen    device_list=device_1

TC8 : [Search] Recent search result should not display on top of recent search history for CAP devices
    [Tags]    314081    P1    bvt_cap    sanity_cap
    [Setup]   Testcase Setup for CAP User   count=3
    navigate to people tab     device=device_1
    Verify search text    from_device=device_1      to_device=device_2
    click back    device=device_1
    navigate to people tab     device=device_1
    Verify search text    from_device=device_1      to_device=device_3
    click back    device=device_1
    navigate to people tab     device=device_1
    Verify recent search empty    device=device_1
    [Teardown]    Run Keywords   Capture on Failure  AND   Come back to home screen   device_list=device_1,device_2,device_3

TC9 : [Search][Disabled]Search is disabled for CAP user
     [Tags]    149995  P2
     [Setup]   Testcase Setup for CAP Search Disable User   count=1
     Verify search option is disabled    device=device_1
     [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

*** Keywords ***

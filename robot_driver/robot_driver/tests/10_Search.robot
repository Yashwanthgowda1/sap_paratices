*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Search] Search for contact by entering a search string without typing the complete contact name
    [Tags]  307132   bvt_tp  sanity_tp    bvt_pr       alt_credentials       Certification_audio
    [Setup]  Testcase Setup    count=2
    Click on calls tab       device=device_1
    Search Text   from_device=device_1      to_device=device_2
    Validate search results presented    device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC2 :[Search] Recent search tab is empty - If this is the first time search
    [Tags]    306805   P1  alt_credentials
    [Setup]   Testcase Setup   count=1
    Click on calls tab       device=device_1
    verify recent search empty    device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND  Come back to home screen    device_list=device_1

TC3 :[Search] Recent search tab is filled - subsequent search
    [Tags]    306806  P1  alt_credentials
    [Setup]  Testcase Setup   count=2
    Click on calls tab       device=device_1
    verify search text   from_device=device_1   to_device=device_2
    Navigate to Calendar tab    device=device_1
    get search text validate    from_device=device_1    to_device=device_2
    [Teardown]    Run Keywords    Capture on Failure   AND   Come back to home screen   device_list=device_1

TC4 :[Search]DUT user can search TDC user and place P2P call
    [Tags]    306762     sanity_tp      P1  alt_credentials     Certification_audio
    [Setup]   Testcase Setup   count=2
    Click on calls tab       device=device_1
    verify search text   from_device=device_1    to_device=device_2
    select user presence   device=device_2    state=Available
    go back to previous page    device=device_1
    Make outgoing call using display name    from_device=device_1   to_device=device_2
    Pick incoming call   device=device_2
    Wait for Some Time    time=${wait_time}
    verify Call State    device_list=device_1,device_2    state=Connected
    disconnect call   device=device_1
    verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2

TC5 :[Search] Newly created user can search for the other users using search option
    [Tags]    307218   P2  alt_credentials
    [Setup]   Testcase Setup    count=2
    Click on calls tab       device=device_1
    verify search text   from_device=device_1   to_device=device_2
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC6 :[Search] DUT user is on Calendar Tab and search for the other users
    [Tags]  311776
    [Setup]  Testcase Setup    count=2
    Navigate to calendar tab    device=device_1
    Search text   from_device=device_1    to_device=device_2
    Validate search results presented    device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC7 :[Voicemail] Validate recent search, search of user not in directory list and clear recent searches list
    [Tags]      318705
    [Setup]  Testcase Setup    count=1
    navigate to voicemail tab   device=device_1
    verify and search for unknown user    device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

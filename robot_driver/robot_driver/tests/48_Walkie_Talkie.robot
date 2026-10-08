*** Settings ***
Resource    ../resources/keywords/common.robot


Suite Teardown  Suite Failure Capture

*** Variables ***
${wait_time} =  10


*** Test Cases ***
TC1 : [Walkie-Talkie] DUT user to verify the "Walkie Talkie" tab after navigating to any tab in home screen.
    [Tags]  311909   sanity_tp
    [Setup]  Testcase Setup  count=1
    navigate to calls tab  device=device_1
    navigate to calendar tab    device=device_1
    navigate to people tab  device=device_1
    navigate to voicemail tab  device=device_1
    navigate to walkie talkie tab  device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1

TC2 : [Walkie-Talkie] DUT user to connect more than 1 channel & switch between them
    [Tags]  312010   bvt_tp  sanity_tp
    [Setup]  Testcase Setup  count=2
    navigate to walkie talkie tab  device=device_1,device_2
    Select and switch between channels      device=device_1,device_2      channel=Channel_1
    Select and switch between channels      device=device_1,device_2      channel=Channel_2
    Select and switch between channels      device=device_1,device_2      channel=Channel_1
    click on disconnect and verify mic  device=device_1,device_2
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2

TC3 : [Walkie-Talkie] DUT user to verify the availability of connect option in Walkie Talkie tab
    [Tags]  311957       P1
    [Setup]  Testcase Setup  count=1
    navigate to walkie talkie tab  device=device_1
    verify connect when no channel is selected  device=device_1
    select the channel  device=device_1     channel=Channel_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1

TC4 : [Walkie-Talkie] DUT user to verify the connected participant icon in connect state.
    [Tags]  311982   sanity_tp        bvt_pr
    [Setup]  Testcase Setup  count=2
    navigate to walkie talkie tab  device=device_1,device_2
    verify connect when no channel is selected  device=device_1,device_2
    select the channel  device=device_1,device_2     channel=Channel_1
    click on connect and verify mic  device=device_1,device_2
    verify connected paricipant list  device=device_1      connected_device_list=device_1,device_2
    click on disconnect and verify mic  device=device_1,device_2
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2

TC5 : [Walkie-Talkie] Verify pick up parked call option is not available in walkie talkie tab
    [Tags]  312032   sanity_tp       P1
    [Setup]  Testcase Setup  count=1
    navigate to walkie talkie tab  device=device_1
    verify call park icon should not present in walkie talkie tab  device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1

TC6 : [Walkie-Talkie] Verify suggested channels and Your teams should be displayed under choose a channel
    [Tags]      312043     P2
    [Setup]  Testcase Setup  count=1
    navigate to walkie talkie tab  device=device_1
    verify suggested channels and your channels     device=device_1         channel=Channel_1,Channel_2
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1

TC7 : [Walkie-Talkie] Verify every1 in the group should have ability to send and listen pages
    [Tags]  312050   sanity_tp   P1
    [Setup]  Testcase Setup  count=2
    navigate to walkie talkie tab  device=device_1,device_2
    select the channel  device=device_1,device_2     channel=Channel_1
    click on connect and verify mic  device=device_1,device_2
    verify connected paricipant list  device=device_1      connected_device_list=device_1,device_2
    press and hold the mic button  from_device=device_1    to_device=device_2
    press and hold the mic button  from_device=device_2    to_device=device_1
    click on disconnect and verify mic  device=device_1,device_2
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2

TC8 : [Walkie-Talkie] Verify Incoming Voice message (Pagee) When DUT is on call
    [Tags]  312000   sanity_tp    P1   alt_credentials
    [Setup]  Testcase Setup  count=3
    click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Click back btn  device=device_1
    navigate to walkie talkie tab  device=device_1,device_2
    select the channel  device=device_1,device_2     channel=Channel_1
    click on connect and verify mic  device=device_1,device_2
    verify connected paricipant list  device=device_1      connected_device_list=device_1,device_2
    press and hold the mic button  from_device=device_2    to_device=device_1
    click on disconnect and verify mic  device=device_1,device_2
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2,device_3

TC9 : [Walkie-Talkie] Incoming Voice message(Page) should play automatically after the beep
    [Tags]  311998    P1
    [Setup]  Testcase Setup  count=2
    navigate to walkie talkie tab  device=device_1,device_2
    select the channel  device=device_1,device_2     channel=Channel_1
    click on connect and verify mic  device=device_1,device_2
    verify connected paricipant list  device=device_1      connected_device_list=device_1,device_2
    press and hold the mic button  from_device=device_2    to_device=device_1
    click on disconnect and verify mic  device=device_1,device_2
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2

TC10 : [Walkie-Talkie] Verify paging is not supported for shared accounts
    [Tags]  312057   bvt_tp  sanity_tp    P0
    [Setup]  Testcase Setup for Meeting User    count=1
    verify walikie talkie option in shared accounts     device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1    AND    sign out method    device=device_1

TC11 : [Walkie-Talkie] Verify there is error message pop up is displayed when user does not press mic properly
    [Tags]      312047   sanity_tp     P1
    [Setup]  Testcase Setup  count=2
    navigate to walkie talkie tab  device=device_1,device_2
    select the channel  device=device_1,device_2     channel=Channel_1
    click on connect and verify mic  device=device_1,device_2
    verify error pop up when double tap on mic button   device=device_1
    click on disconnect and verify mic  device=device_1,device_2
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2

TC12 : [Walkie-Talkie]Verify header should be displayed as Walkie Talkie on top of the tab
    [Tags]      312040     P2
    [Setup]  Testcase Setup  count=1
    navigate to walkie talkie tab  device=device_1
    verify walkie talkie tab header     device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1

TC13 : [Walkie Talkie]Verify the selected channel should display at top
    [Tags]      320233     P2
    [Setup]  Testcase Setup  count=1
    navigate to walkie talkie tab  device=device_1
    select the channel  device=device_1     channel=Channel_1
    verify selected channel name in walkie talkie tab   device=device_1     channel=Channel_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1

TC14 : [Walkie-Talkie] DUT user to verify the connected participant icon in disconnect state.
    [Tags]  311980  P2
    [Setup]  Testcase Setup  count=1
    navigate to walkie talkie tab  device=device_1
    verify connect when no channel is selected  device=device_1
    select the channel  device=device_1     channel=Channel_1
    verify participant icon in disconnected state   device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1

TC15 : [Walkie-Talkie] Verify the List of teams and channels is opened when user tap on channel option
    [Tags]      312042     P2
    [Setup]  Testcase Setup  count=1
    navigate to walkie talkie tab  device=device_1
    verify suggested channels and your channels     device=device_1     channel=Channel_1,Channel_2
    select the channel  device=device_1     channel=Channel_1
    verify selected channel name in walkie talkie tab   device=device_1     channel=Channel_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1

TC16 : [WalkieTalkie]Verify DUT user should not be able to see search bar on Walkie Talkie screen
    [Tags]      320183     P2
    [Setup]  Testcase Setup  count=1
    navigate to walkie talkie tab  device=device_1
    verify search option is disabled in walkie talkie tab       device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1

TC17 : Test Case : [Walkie-Talkie] Verify dark theme is applied on all the options on Walkie Talkie tab
    [Tags]      312030      P2
    [Setup]  Run Keywords   Testcase Setup  count=2     AND     verify and enable dark theme     device=device_1
    navigate to walkie talkie tab  device=device_1,device_2
    select the channel  device=device_1,device_2     channel=Channel_1
    click on connect and verify mic  device=device_1,device_2
    verify connected paricipant list  device=device_1      connected_device_list=device_1,device_2
    press and hold the mic button  from_device=device_1    to_device=device_2
    click on disconnect and verify mic  device=device_1,device_2
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2      AND    verify and disable dark theme     device=device_1

TC18 :[Walkie-Talkie] DUT user to send voice message when no participant is connected.
    [Tags]      312008      P2
    [Setup]  Testcase Setup  count=2
    navigate to walkie talkie tab  device=device_1,device_2
    select the channel  device=device_1     channel=Channel_1
    click on connect and verify mic  device=device_1
    verify user send voice message when no participant is connected     device=device_1
    press and hold the mic button when no one else connected         from_device=device_1    to_device=device_2
    click on disconnect and verify mic  device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2

TC19 : [Walkie-Talkie]Verify No crash is observed when user connect and disconnect to the channel continuously
    [Tags]      311954     P2
    [Setup]  Testcase Setup  count=1
    navigate to walkie talkie tab  device=device_1
    select the channel  device=device_1     channel=Channel_1
    click on connect and verify mic  device=device_1
    click on disconnect and verify mic  device=device_1
    click on connect and verify mic  device=device_1
    click on disconnect and verify mic  device=device_1
    click on connect and verify mic  device=device_1
    click on disconnect and verify mic  device=device_1
    click on connect and verify mic  device=device_1
    click on disconnect and verify mic  device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1

TC20 :[Walkie-Talkie] DUT user to verify the channel option in Walkie Talkie tab and display suggested channel
    [Tags]      311919     P2
    [Setup]  Testcase Setup  count=1
    navigate to walkie talkie tab  device=device_1
    verify suggested channels and your channels     device=device_1     channel=Channel_1,Channel_2
    select the channel  device=device_1     channel=Channel_1
    verify selected channel name in walkie talkie tab   device=device_1     channel=Channel_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1

TC21 :[Walkie Talkie]Verify Dut user should not hear page if it is on DND and will also receive message
    [Tags]      320219     P2
    [Setup]  Testcase Setup  count=2
    Select user presence   device=device_1     state=DND
    Verify user presence   device=device_1     state=DND
    navigate to walkie talkie tab  device=device_1,device_2
    select the channel  device=device_1,device_2     channel=Channel_1
    click on connect and verify mic  device=device_1,device_2
    verify walikie talkie error message when user in DND state       from_device=device_1        to_device=device_2
    [Teardown]  Run Keywords   Capture on Failure   AND   Select user presence   device=device_1     state=Available    AND    Come back to home screen    device_list=device_1

TC22 :[Walkie -Talkie] Verify Walkie-Talkie options are working fine after reordering its position.
    [Tags]      311951      P2
    [Setup]  Testcase Setup  count=1
    ${before_home_screen_tiles}=    get home screen tiles    device=device_1
    ${destination_tab}=     get destination tab on home screen except walkie talkie    device=device_1
    Navigate to reorder tab     device=device_1
    Verfy and reorder homescreen tiles   device=device_1    tab=walkie talkie    destination=${destination_tab}
    ${after_home_screen_tiles}=    get home screen tiles    device=device_1
    verify updated home screen tile after editing       before_changing=${before_home_screen_tiles}         after_changing=${after_home_screen_tiles}
    Navigate to tab     device=device_1        tab=walkie talkie
    select the channel  device=device_1     channel=Channel_1
    click on connect and verify mic  device=device_1
    click on disconnect and verify mic  device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen     device_list=device_1

TC23 : [Walkie-Talkie] Verify no voice mail icon should supported on Walkie Talkie Option
    [Tags]     312028     P2
    [Setup]  Testcase Setup  count=1
    verify voicemail icon not present in walkie talkie tab     device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen     device_list=device_1

TC24 : [Walkie-Talkie] Verify DID of the account should not dispalyed under Walkie Talkie header.
    [Tags]     311973     P2
    [Setup]  Testcase Setup  count=2
    navigate to walkie talkie tab  device=device_1,device_2
    select the channel  device=device_1,device_2     channel=Channel_1
    click on connect and verify mic  device=device_1,device_2
    press and hold the mic button  from_device=device_1    to_device=device_2
    DID no should not displayed under walkie talkie header       device=device_1
    click on disconnect and verify mic  device=device_1,device_2
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2


#TC27 : [Walkie-Talkie] DUT user to Verify Home Screen notification banner when connected to any channel
#    [Tags]   312012     bvt_tp   sanity_tp    P1
#    [Setup]   Testcase Setup    count=1
#    navigate to calls tab  device=device_1
#    navigate to walkie talkie tab  device=device_1
#    select the channel  device=device_1    channel=Channel_1
#    click on connect and verify mic  device=device_1
#    Come back to Home Screen page and verify   device=device_1
#    verify channel connection from notification banner    device=device_1
#    [Teardown]    Run Keywords   Capture on Failure    AND     Test Case Teardown    device=device_1

TC25: [Walkie Talkie]Verify walkie talkie feature should be visible to different type of accounts.
    [Tags]    320182    P2
    [Setup]  Testcase Setup  count=1
    navigate to walkie talkie tab   device=device_1
    sign out method    device_1
    sign in method     device=device_1    user=cap_search_enabled
    verify and enable advance calling option       device=device_1
    Wait for Some Time    time=${wait_time}
    verify walkie talkie tab in home screen for cap  device=device_1
    sign out method    device_1
    [Teardown]  Run Keywords    Capture on Failure    AND     sign in method     device_1

TC26 : [Walkie-Talkie] Verify error message is dispalyed when connect is selected with no channel is selected
    [Tags]    312055    P3
    [Setup]  Testcase Setup  count=1
    sign out method    device=device_1
    wait for some time    time=10s
    sign in method     device=device_1
    navigate to walkie talkie tab   device=device_1
    press connect button and mic verify error message when on channel     from_device=device_1
    [Teardown]  Run Keywords    Capture on Failure    AND     come back to home screen  device_list=device_1

*** Keywords ***
Test Case Teardown
    [Arguments]     ${device}
    navigate to walkie talkie tab  ${device}
    click on disconnect and verify mic  ${device}
    Come back to home screen    device_list=${device}










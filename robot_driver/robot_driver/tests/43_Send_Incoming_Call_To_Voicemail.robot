*** Settings ***
Resource    ../resources/keywords/common.robot


Suite Teardown  Suite Failure Capture

*** Variables ***
${wait_time} =  30
${wait_time1} =  10


*** Test Cases ***
TC1 : DUT user should receive the Voicemail by tapping on Send to Voicemail option on Incoming call UI.
    [Tags]      452357   sanity_tp      bvt_tp          phonesCY23_4        bvt_pr
    [Setup]  Testcase Setup  count=2
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    verify incoming call        device=device_1         status=appear
    verify and click send to voicemail option for incoming call          device=device_1
    Verify Call State    device_list=device_2    state=Connected
    Verify Call State    device_list=device_1    state=disconnected
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    Wait for Some Time    time=${wait_time}
    Navigate to voicemail tab    device=device_1
    verify first voicemail displayname  to_device=device_1  from_device=device_2
    Play voicemail    device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1

TC2 :DUT user able to receive the Voicemail by tapping on Send to voicemail option in multiple call banner
    [Tags]      452380   sanity_tp      bvt_tp          phonesCY23_4
    [Setup]  Testcase Setup  count=4
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    verify incoming call        device=device_1         status=appear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Wait for Some Time    time=${wait_time1}
    click back          device=device_1
    click on calls tab  device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2    state=Hold
    click on calls tab  device=device_4
    Make outgoing call using display name    from_device=device_4      to_device=device_1
    verify and move incoming call to notification redirect to voicemail          from_device=device_1      to_device=device_4
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3,device_4    state=Connected
    Verify Call State    device_list=device_2       state=Hold
    Disconnect call     device=device_3,device_1,device_4
    verify call state and disconnect    device=device_2
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    Wait for Some Time    time=${wait_time}
    click back          device=device_1
    Navigate to voicemail tab    device=device_1
    verify first voicemail displayname  to_device=device_1  from_device=device_4
    Play voicemail    device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2,device_4

TC3 : DUT user able to send the voicemail by tapping on voicemail icon for searched user in Calls app.
    [Tags]      452891      sanity_tp            phonesCY23_4
    [Setup]  Testcase Setup  count=2
    click on calls tab  device=device_1
    validate search results and send voicemail in multiple tabs         from_device=device_1      to_device=device_2
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    Wait for Some Time    time=${wait_time}
    click back          device=device_1
    Navigate to voicemail tab    device=device_2
    refresh the page    device=device_2
    verify first voicemail displayname  to_device=device_2  from_device=device_1
    Play voicemail    device=device_2
    navigate to calendar tab        device=device_1
    validate search results and send voicemail in multiple tabs         from_device=device_1      to_device=device_2
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    Wait for Some Time    time=${wait_time}
    click back          device=device_1
    refresh the page    device=device_2
    verify first voicemail displayname  to_device=device_2  from_device=device_1
    Play voicemail    device=device_2
    navigate to voicemail tab     device=device_1
    validate search results and send voicemail in multiple tabs         from_device=device_1      to_device=device_2
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    Wait for Some Time    time=${wait_time}
    click back          device=device_1
    refresh the page    device=device_2
    verify first voicemail displayname  to_device=device_2  from_device=device_1
    Play voicemail    device=device_2
    navigate to people tab          device=device_1
    validate search results and send voicemail in multiple tabs         from_device=device_1      to_device=device_2
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    Wait for Some Time    time=${wait_time}
    click back          device=device_1
    refresh the page    device=device_2
    verify first voicemail displayname  to_device=device_2  from_device=device_1
    Play voicemail    device=device_2
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2

TC4:DUT should display Send to voicemail option in Incoming Call UI.
    [Tags]    452336        P1
    [Setup]  Testcase Setup  count=2
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    verify incoming call        device=device_1         status=appear
    verify and click send to voicemail option for incoming call          device=device_1            option=appear
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2

TC5:DUT user gets the Send to Voicemail option on incoming call in multiple call banner
    [Tags]    452366
    [Setup]  Testcase Setup  count=4
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    verify incoming call        device=device_1         status=appear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Wait for Some Time    time=${wait_time1}
    click back          device=device_1
    click on calls tab  device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2    state=Hold
    click on calls tab  device=device_4
    Make outgoing call using display name    from_device=device_4      to_device=device_1
    verify and move incoming call to notification redirect to voicemail          from_device=device_1      to_device=device_4
    Verify Call State    device_list=device_4    state=Connected
    Wait for Some Time    time=${wait_time1}
    Disconnect call     device=device_2,device_3,device_4
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    click back          device=device_1
    Navigate to voicemail tab    device=device_1
    verify first voicemail displayname  to_device=device_1  from_device=device_4
    Play voicemail    device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2,device_3,device_4

TC6:DUT user able to receive the voicemail by tapping send to Voicemail button in incoming Call UI for forwarding call.
    [Tags]    452870
    [Setup]  Testcase Setup  count=3
    Enable call forwarding to contacts     from_device=device_2   contact_device=device_1
    click on calls tab  device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_2
    verify incoming call        device=device_1         status=appear
    verify and click send to voicemail option for incoming call          device=device_1
    Verify Call State    device_list=device_3    state=Connected
    Verify Call State    device_list=device_1,device_2        state=disconnected
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3     state=Disconnected
    Wait for Some Time    time=${wait_time}
    Navigate to voicemail tab    device=device_1
    verify first voicemail displayname  to_device=device_1  from_device=device_3
    Play voicemail    device=device_1
    [Teardown]   run keywords  Capture on Failure    AND       verify and Disable Call forwarding       device=device_2    AND    come back to home screen  device_list=device_1,device_2,device_3

TC7:DUT user gets the Leave voicemail option for speed dial contacts.
    [Tags]    452866    P2
    [Setup]   Testcase Setup  count=2
    Make outgoing call for call log   from_device=device_2     to_device=device_1
    Select call list item   device=device_1  item=favorite
    verify favorites user option    from_device=device_1     to_device=device_2
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2

TC8:DUT user to get Send to Voicemail button in incoming Call UI for forwarding call.
    [Tags]    452873    P2
    [Setup]  Testcase Setup  count=3
    Enable call forwarding to contacts     from_device=device_2   contact_device=device_1
    click on calls tab  device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_2
    verify incoming call        device=device_1         status=appear
    Verify display name on call toast   to_device=device_1    from_device=device_3
    Verify forward by call text     device=device_1    from_device=device_2
    verify and click send to voicemail option for incoming call          device=device_1    option=appear
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3    state=disconnected
    Verify Call State    device_list=device_1,device_2,device_3        state=disconnected
    [Teardown]   run keywords  Capture on Failure    AND       verify and Disable Call forwarding       device=device_2    AND    come back to home screen  device_list=device_1,device_2,device_3

TC9:DUT user gets the Leave voicemail option for contacts in Recent tab.
    [Tags]    452879    P2
    [Setup]   Testcase Setup  count=2
    Make outgoing call for call log   from_device=device_2     to_device=device_1
    Select call list item   device=device_1  item=favorite
    go back to previous page   device=device_1
    Click on calls tab      device=device_1
    refresh the page    device=device_1
    verify user option in recent tab    device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2

TC10:DUT user gets the Call icon and voicemail icon for searched user in Calls app.
    [Tags]    452886    P2
    [Setup]   Testcase Setup  count=2
    click on calls tab  device=device_1
    validate search results and send voicemail in multiple tabs         from_device=device_1      to_device=device_2    option=verify
    go back to previous page   device=device_1
    Navigate to people tab    device=device_1
    validate search results and send voicemail in multiple tabs         from_device=device_1      to_device=device_2    option=verify
    go back to previous page   device=device_1
    Navigate to Calendar tab   device=device_1
    validate search results and send voicemail in multiple tabs         from_device=device_1      to_device=device_2    option=verify
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2

TC11:DUT user able to send the Voicemail by tapping on Voicemail icon in Voicemail tab.
    [Tags]    452929    P1
    [Setup]    run keywords   Testcase Setup    count=2   AND    Set Call Forwarding    device=device_1
    Send Voicemail      from_device=device_2   to_device=device_1
    Navigate to voicemail tab   device=device_1
    verify 1st vm presence status   device=device_1
    Verify contact page details   device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND     Disable Call forward   devices=device_1,device_2

TC12 : DUT user able to send the voicemail by tapping Leave voicemail option for speed dial contacts.
    [Tags]      452874  P1
    [Setup]  Testcase Setup  count=2
    Make outgoing call for call log   from_device=device_2     to_device=device_1
    Select call list item   device=device_1  item=favorite
    leave voicemail from favorites page     from_device=device_1     to_device=device_2
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1    state=Disconnected
    Navigate to voicemail tab    device=device_1
    refresh the page    device=device_1
    verify first voicemail displayname  to_device=device_1  from_device=device_2
    [Teardown]  Run Keywords   Capture on Failure   AND    come back home screen for user   count=2

TC13:DUT should display Call icon and Voicemail icon, when user selects a contact card of the user in Voicemail tab.
    [Tags]    452925    P2
    [Setup]   Run keywords     Testcase Setup    count=2        AND    Set Call Forwarding    device=device_1
    Send Voicemail      from_device=device_2   to_device=device_1
    Navigate to voicemail tab   device=device_1
    verify 1st vm presence status   device=device_1
    Verify contact page details   device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND     Disable Call forward   devices=device_1,device_2

TC14: DUT user to get Send to Voicemail button when user receive multiple incoming calls at the same time
    [Tags]  452876  P1
    [Setup]  Testcase Setup     count=3
    initiate simultaneous call  devices=device_2,device_3   target_device=device_1    method=display_name
    verify multiple incoming calls  device=device_1
    verify and click send to voicemail option for incoming call          device=device_1    option=appear
    verify options in call notification banner      device=device_1
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND   come back home screen for user   count=3

TC15: [Outgoing Calls] DUT user calls TDC user for which VM is enabled and VM is disabled
    [Tags]    318554    Sanity_tp    tp_audio
    [Setup]  run keywords   Testcase Setup   count=2   AND     Enable unanswered call to voicemail     from_device=device_2    contact_device=device_1
    Navigate To Calls Tab    device=device_1
    Make outgoing call using display name    from_device=device_1    to_device=device_2
    verify incoming call    device=device_2    status=appear
    Wait for Some Time    time=${wait_time}
    wait until call disconnected    device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    Verify Call State    device_list=device_1    state=Connected
    Disconnect Call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=disconnected
    Navigate to voicemail tab    device=device_2
    verify first voicemail displayname    to_device=device_2    from_device=device_1
    Play voicemail    device=device_2
    Return To Home Screen    device_list=device_2
	Make outgoing call using display name    from_device=device_1    to_device=device_2
    verify incoming call    device=device_2    status=appear
	Rejects the incoming call   device_list=device_2
	Verify Call State    device_list=device_2     state=Disconnected
    Verify Call State    device_list=device_1    state=Connected
    Disconnect Call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=disconnected
    Navigate to voicemail tab    device=device_2
    verify first voicemail displayname    to_device=device_2    from_device=device_1
    Play voicemail    device=device_2
    Return To Home Screen    device_list=device_2
    Disable unanswered call   device=device_2    contact_device=device_1
    Go Back To Previous Page    device=device_1
    Navigate To Calls Tab    device=device_1
    Make outgoing call using display name    from_device=device_1    to_device=device_2
    verify incoming call    device=device_2    status=appear
    Disconnect Call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=disconnected
    [Teardown]   Run Keywords    Capture on Failure     AND    Disable unanswered call   device=device_2    contact_device=device_1    AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***

Make outgoing call for call log
    [Arguments]     ${from_device}   ${to_device}
    Click on calls tab   device=${from_device}
    Make outgoing call using phonenumber    from_device=${from_device}      to_device=${to_device}
    Wait for Some Time    time=${wait_time}
    Verify Incoming call    device=${to_device}     status=appear
    Disconnect call     device=${from_device}
    Verify Incoming call    device=${to_device}     status=disappear
    Verify Call State    device_list=${from_device}     state=Disconnected
    return to home screen   device_list=${from_device}
    Click on calls tab   device=${from_device}
    Refresh calls main tab    device=${from_device}

Send Voicemail
    [Arguments]     ${from_device}   ${to_device}
    Click on calls tab   ${from_device}
    Make outgoing call using phonenumber    ${from_device}      ${to_device}
    Verify Call State    device_list=${from_device}   state=Connected
    Wait for Some Time    time=35s
    Disconnect call     ${from_device}
    Verify Call State    device_list=${from_device}     state=Disconnected

Disable Call forward
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    verify and disable call forwarding    device=device_1
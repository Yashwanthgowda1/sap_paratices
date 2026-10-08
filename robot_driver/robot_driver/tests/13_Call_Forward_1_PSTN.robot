*** Settings ***
Resource    ../resources/keywords/common.robot

#Suite Setup     PSTN Setup Main
Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10
${wait_time3} =  40


*** Test Cases ***
TC1 : [Call Forward] DUT user to forward the call to delegates - Call from PSTN user
    [Tags]  307821      advance_calling    P1  alt_blocked
    [Setup]  Run Keywords  Testcase Setup for Delegate PSTN User   count=3     AND     Enable call forwarding to delegates     from_device=device_1    contact_device=device_2
    Click on calls tab   device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify incoming call    device=device_2     status=appear
    Pick incoming call   device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Disable Call forward    devices=device_1,device_2,device_3

TC2 : [Advance Calling] Delegates must see a Call Dropdown icon when, Boss receives a PSTN call
    [Tags]  311533   P2
    [Setup]  Testcase Setup for Delegate PSTN User   count=3
    click on calls tab  device=device_3
    Make outgoing call using phonenumber     from_device=device_3     to_device=device_1
    Verify Incoming call    device=device_1    status=appear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    wait for some time  ${wait_time}
    navigate to calls favorites page   device=device_2
    refresh calls main tab    device=device_2
    verify and join call using join call in more option with boss and delegate   from_device=device_2      to_device=device_1        option=verify
    disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_3   state=disconnected
    [Teardown]  run keywords  Capture on Failure    AND    check call dropdown menu state   device=device_1    AND    Come back to home screen   device_list=device_1,device_2,device_3

TC3 : [Call Forward] DUT user to forward TDC call to PSTN user
    [Tags]  306781      P1  alt_blocked
    [Setup]  run keywords  Testcase Setup for PSTN User   count=3  AND     Enable call forwarding and add contact     from_device=device_1    contact_device=device_2:pstn_user
    Click on calls tab   device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Call forward Teardown    devices=device_1,device_2,device_3

TC4 :[Call forward on home screen] Verify that DUT user is able to add the New contact or number from call forwarding section present on home screen.
    [Tags]      452496      P1    sanity_tp    phonesCY23_4
    [Setup]    run keywords    Testcase Setup for PSTN User    count=4  AND    Enable call forwarding to contacts     from_device=device_1   contact_device=device_2
    verify and change toggle status for call forwarding display on home screen    device=device_1      status=on
    verify call forwarding label status on home screen      device=device_1         status=contact_or_number        to_device=device_2
    verify call forwarding option in call forward icon    device=device_1
    verify and change the contact on forward to contact or number on home screen    device=device_1    contact_device=device_4
    verify call forwarding label status on home screen      device=device_1        status=contact_or_number        to_device=device_4
    verify call forwarding status on calling            device=device_1         option=contact_or_number        to_device=device_4
    click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_1     status=disappear
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_3,device_4    state=Connected
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3,device_4     state=Disconnected
    Verify call entries are synced in call log    from_device=device_1      to_device=device_4      state=forwarded_to
    click on home bar icon          device=device_1
    verify and change the contact on forward to contact or number on home screen    device=device_1    contact_device=device_2:pstn_user
    verify call forwarding status on calling            device=device_1         option=contact_or_number        to_device=device_2:pstn_user
    click on calls tab      device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1
    Verify Incoming call    device=device_1     status=disappear
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    Verify call entries are synced in call log    from_device=device_1      to_device=device_3      state=forwarded_to
    [Teardown]  Run Keywords    Capture on Failure  AND    Call forward Teardown    devices=device_1,device_2,device_3     AND     verify and change toggle status for call forwarding display on home screen    device=device_1      status=off

TC5 : [Call forward on home screen] Verify that DUT user call should be forwarded to PSTN user, When DUT user selects Forward to contact or number from the Call forwarding section on home screen.
    [Tags]      452545      P1    sanity_tp    phonesCY23_4
    [Setup]     Testcase Setup for PSTN User    count=3
    verify and change toggle status for call forwarding display on home screen    device=device_1      status=on
    verify display home screen toggle status under calling        device=device_1       status=on
    verify and set call forwarding on home screen     device=device_1         option=contact_or_number        to_device=device_2:pstn_user
    click on calls tab  device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1
    Verify Incoming call    device=device_1     status=disappear
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    Verify call entries are synced in call log    from_device=device_1      to_device=device_3      state=forwarded_to
    [Teardown]  Run Keywords    Capture on Failure  AND    Call forward Teardown    devices=device_1,device_2,device_3     AND    verify and change toggle status for call forwarding display on home screen    device=device_1      status=off

TC6 : [Call Forward] DUT user to forward the call to PSTN - Call from TDC user.
    [Tags]  451458  P2
    [Setup]  Run Keywords  Testcase Setup for PSTN User   count=3     AND     Enable call forwarding to contacts    from_device=device_1    contact_device=device_2:pstn_user  AND     Add new delegates with both permission and validate   from_device=device_1    to_device=device_3
    Click on calls tab   device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify incoming call    device=device_1     status=disappear
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Delete delegate from manage delegate   from_device=device_1    to_device=device_3   AND     Disable Call forward    devices=device_1,device_2,device_3

TC7 : [Simul-ring] Teams App user can configure a call group to ring simultaneously for an incoming call from PSTN user
    [Tags]  307807     P2  alt_blocked
    [Setup]     Run Keywords   Testcase Setup for GCP PSTN User    count=3    AND     Enable Also Ring Call group     device=device_1
    Click on calls tab   device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    Verify call notification    device=device_2     status=appear
    Pick incoming call    device=device_1
    Verify call notification    device=device_2     status=disappear
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Call Ring Teardown    devices=device_1,device_2,device_3

TC8 : [Simul-ring] DUT user can configure a PSTN user to ring simultaneously for incoming call from another DUT user, a TDC user, and a PSTN user.
    [Documentation]    device_1-DUT1, device_2-PSTN1, device_3-DUT2,PSTN2 , device_4-TDC
    [Tags]  307772    P1
    [Setup]     Run Keywords   Testcase Setup for PSTN User    count=4    AND     Enable Also Ring and add contact     device=device_1   contact_device=device_2:pstn_user
    Navigate To Calls Tab    device=device_3
    Make Outgoing Call Using Phonenumber    from_device=device_3      to_device=device_1
    Verify Incoming call    device=device_1,device_2     status=appear
    Pick incoming call    device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    Navigate To Calls Tab    device=device_3
    Make Outgoing Call Using Display Name    from_device=device_4    to_device=device_1
    Verify Incoming Call    device=device_2,device_1     status=appear
    Pick incoming call    device=device_2
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_4    state=Connected
    Disconnect call     device=device_4
    Verify Call State    device_list=device_2,device_4     state=Disconnected
    Testcase Setup For 2 PSTN User    count=3
    Enable Also Ring and add contact     device=device_1   contact_device=device_3:pstn_user
    Navigate To Calls Tab    device=device_2
    Make Outgoing Call Using Phonenumber    from_device=device_2    to_device=device_1
    Verify Incoming Call    device=device_1,device_3    status=appear
    Pick Incoming Call    device=device_3
    Verify Incoming Call    device=device_1    status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect Call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Call Ring Teardown    devices=device_1,device_2,device_3

TC9: [Simul-ring] DUT user can configure a TDC user to ring simultaneously for an incoming call from another TDC user, DUT user and PSTN user
    [Tags]    307779
    [Setup]    Run Keywords    Testcase Setup    count=3    AND    Enable Also Ring And Add Contact    device=device_1    contact_device=device_3
    Navigate To Calls Tab    device=device_2
    Make Outgoing Call Using Display Name    from_device=device_2    to_device=device_1
    Verify Incoming Call    device=device_1,device_3    status=appear
    Pick Incoming Call    device=device_3
    Verify Incoming Call    device=device_1    status=disappear
    Verify Call State    device_list=device_2,device_3    state=connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    Testcase Setup for 2 PSTN User    count=3
    Enable Also Ring and add contact     device=device_1   contact_device=device_3:pstn_user
    Make Outgoing Call Using Phonenumber    from_device=device_2     to_device=device_1
    Verify Incoming call    device=device_1,device_3     status=appear
    Pick incoming call    device=device_3
    Verify Incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Call Ring Teardown    devices=device_1,device_2,device_3

*** Keywords ***
Disable Call forward
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    verify and disable call forwarding    device=device_1

Send Voicemail
    [Arguments]     ${from_device}   ${to_device}
    Make outgoing call using phonenumber    ${from_device}      ${to_device}
    Verify Call State    device_list=${from_device}   state=Connected
    Wait for Some Time    time=35s
    Disconnect call     ${from_device}
    Verify Call State    device_list=${from_device}     state=Disconnected

Call Ring Teardown
    [Arguments]     ${devices}
    Disable Also Ring    device=device_1
    Come back to home screen    device_list=${devices}

Call forward Teardown
    [Arguments]     ${devices}
    verify call state and disconnect      ${devices}
    return to home screen     ${devices}
    verify and disable call forwarding    device=device_1

Unanswered call Teardown
    [Arguments]     ${devices}
    verify call state and disconnect      ${devices}
    return to home screen     ${devices}
    Disable unanswered call    device=device_1      contact_device=device_2:pstn_user

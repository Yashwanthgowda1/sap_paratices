*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown     Suite Failure Capture

*** Test Cases ***
TC1: Verify New badge should disappeared on the More app once user opens the Queues app
    [Tags]    502324
    [Setup]    Testcase Setup for CQ User    count=1
    verify call queues new badge    device=device_1    option=appear
    verify and click queues in more tab    device=device_1
    return to home screen    device_list=device_1
    verify call queues new badge    device=device_1    option=disappeared
    [Teardown]  Run Keywords    Capture on Failure   AND      Come back to home screen     device_list=device_1

TC1.2: Verify DUT should display New badge on the More app when user signed with the Teams Premium License assigned user.
    [Tags]    502323    tp_audio
    [Setup]    Testcase Setup for CQ User    count=1
    verify and click queues in more tab    device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND      Come back to home screen     device_list=device_1

TC2: Verify the Queues app
    [Tags]    502325   tp_audio    sanity_tp
    [Setup]    Testcase Setup for CQ User    count=1
    verify and click queues in more tab    device=device_1
    Verify Call Queue Option In Queue Tab    device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND      Come back to home screen     device_list=device_1

TC3: DUT user to verify Call Queues section present under calling.
    [Tags]    502334  tp_audio
    [Setup]    Testcase Setup for CQ User    count=1
    Navigate Call Queue Toogle In Calling Settings    device=device_1
    Verify Status Of Call Queue Toggle Button    device=device_1    status=on
    [Teardown]  Run Keywords    Capture on Failure   AND      Come back to home screen     device_list=device_1

TC4: DUT user to verify the Queues app in dark theme
    [Tags]    502337    tp_audio    sanity_tp
    [Setup]    Testcase Setup for CQ User    count=1
    verify and enable dark theme     device=device_1
    verify and click queues in more tab    device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND      verify and disable dark theme    device=device_1    AND     Come back to home screen     device_list=device_1

TC5: Verify DUT user shouldn't get the call queue call from the TDC/PSTN user when call queue toggle is disabled under the Calling / Queues app
    [Tags]    502321    tp_audio
    [Setup]   Run keywords   Testcase Setup for CQ PSTN User   count=4    AND    verify toggle appear on the queue options
    Verify And Click Queues In More Tab    device=device_1
    verify call queue option in queue tab       device=device_1
    Disable Call Queue Toggle    device=device_1
    verify status of call queue toggle button    device=device_1    status=off
    Place call to phone num    from_device=device_4      phone_num=CQ_no
    Verify Incoming Call    device=device_1,device_3    status=disappear
    Disconnect Call    device=device_4
    verify call state    device_list=device_4    state=disconnected
    Navigate Call Queue Toogle In Calling Settings    device=device_1
    Disable Call Queue Toggle    device=device_1
    verify status of call queue toggle button     device=device_1    status=off
    Place call to phone num    from_device=device_4      phone_num=CQ_no
    Verify Incoming Call    device=device_1    status=disappear
    Disconnect Call    device=device_4
    verify call state    device_list=device_4    state=disconnected
    [Teardown]      Run Keywords    Capture on Failure   AND      Come back to home screen     device_list=device_1,device_2,device_3,device_4

TC6: Verify DUT user should get the call queue call from the TDC/PSTN user when call queue toggle is enabled under Calling /Queues app
    [Tags]    502322    tp_audio    sanity_tp    bvt_tp
    [Setup]   Run keywords    Testcase Setup for CQ PSTN User   count=4    AND    verify toggle appear on the queue options
    Verify And Click Queues In More Tab    device=device_1
    Enable Call Queue Toggle    device=device_1
    verify status of call queue toggle button    device=device_1    status=on
    Place call to phone num    from_device=device_4      phone_num=CQ_no
    Verify Incoming Call    device=device_1    status=appear
    Disconnect Call    device=device_4
    Verify Call State    device_list=device_1,device_4      state=Disconnected
    return to home screen    device_list=device_1
    Navigate Call Queue Toogle In Calling Settings    device=device_1
    Enable Call Queue Toggle    device=device_1
    verify status of call queue toggle button   device=device_1    status=on
    Place call to phone num    from_device=device_4      phone_num=CQ_no
    Wait till incoming call visibility    device=device_1
    Verify Incoming Call    device=device_1    status=appear
    Disconnect Call    device=device_4
    Verify Call State    device_list=device_1,device_4      state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND      Come back to home screen     device_list=device_1,device_2,device_3,device_4

TC7 : DUT user to verify same list of call queue names should be displayed in Queues app and in Call Queues section present under calling.
    [Tags]    502335   sanity_tp
    [Setup]    Testcase Setup for CQ User    count=1
    verify and click queues in more tab    device=device_1
    Verify Call Queue Option In Queue Tab    device=device_1
    Navigate Call Queue Toogle In Calling Settings    device=device_1
    Verify Status Of Call Queue Toggle Button    device=device_1    status=on
    [Teardown]  Run Keywords    Capture on Failure   AND      Come back to home screen     device_list=device_1

TC8 : DUT user to verify opted-in and opted-out message present below the Configured call queue names.
    [Tags]    502336
    [Setup]    Testcase Setup for CQ User    count=1
    verify and click queues in more tab    device=device_1
    Verify Call Queue Option In Queue Tab    device=device_1
    Enable Call Queue Toggle    device=device_1
    Verify Status Of Call Queue Toggle Button    device=device_1    status=on
    verify and click queues in more tab    device=device_1
    Disable Call Queue Toggle    device=device_1
    verify status of call queue toggle button    device=device_1    status=off
    [Teardown]  Run Keywords    Capture on Failure   AND      Come back to home screen     device_list=device_1

TC9: Verify DUT user should be able to enable the call queue names present under Queues app or from calling settings
    [Tags]    502328   P2    sanity_tp
    [Setup]    Run keywords   Testcase Setup for CQ PSTN User   count=4     AND    verify toggle appear on the queue options
    Verify And Click Queues In More Tab    device=device_1
    Enable Call Queue Toggle    device=device_1
    verify status of call queue toggle button    device=device_1    status=on
    Navigate Call Queue Toogle In Calling Settings    device=device_1
    Enable Call Queue Toggle    device=device_1
    verify status of call queue toggle button    device=device_1    status=on
    [Teardown]  Run Keywords    Capture on Failure   AND      Come back to home screen     device_list=device_1,device_2,device_3,device_4

TC10: Verify DUT user should be able to disable the call queue names present under Queues app or from call queues section present under calling settings
    [Tags]    502329    P2
    [Setup]    Run keywords     Testcase Setup for CQ PSTN User   count=4     AND    verify toggle appear on the queue options
    Verify And Click Queues In More Tab    device=device_1
    Disable Call Queue Toggle    device=device_1
    verify status of call queue toggle button    device=device_1    status=off
    Navigate Call Queue Toogle In Calling Settings    device=device_1
    Disable Call Queue Toggle    device=device_1
    verify status of call queue toggle button    device=device_1    status=off
    [Teardown]  Run Keywords    Capture on Failure      AND      Come back to home screen     device_list=device_1,device_2,device_3,device_4

TC11 : DUT should display the CQ Call logs in Calls under CQ app when user tap on Call queue name in the Queues app
    [Tags]    502339
    [Setup]    Testcase Setup for CQ User    count=2
    click on calls tab   device=device_2
    Place call to phone num    from_device=device_2      phone_num=CQ_no
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    verify and click queues in more tab    device=device_1
    Verify Call Queue Option In Queue Tab    device=device_1
    verify and click on queues name    device=device_1
    return to home screen    device_list=device_1
    Navigate To Calls Tab    device=device_1
    verify latest call details     from_device=device_1      to_device=device_2
    [Teardown]    Run Keywords    Capture on Failure      AND      Come back to home screen     device_list=device_1,device_2

TC12 : Verify Leads, observing and opted out agent's name should be display inside the People tab in the call queue app
    [Tags]    502338    bvt_tp    sanity_tp
    [Setup]    Testcase Setup for CQ User    count=1
    verify and click queues in more tab    device=device_1
    Verify Call Queue Option In Queue Tab    device=device_1
    verify and click on queues name    device=device_1
    verify people tab in queues name    device=device_1
    [Teardown]    Run Keywords    Capture on Failure      AND      Come back to home screen     device_list=device_1

TC13: Verify DUT user enables or disables the call queue name from home screen same should be reflect in Call Queues section under calling.
    [Tags]    502332    sanity_tp    bvt_tp
    [Setup]    Testcase Setup for CQ User    count=1
    Verify And Click Queues In More Tab    device=device_1
    Enable Call Queue Toggle    device=device_1
    verify status of call queue toggle button    device=device_1    status=on
    Return To Home Screen    device_list=device_1
    Navigate Call Queue Toogle In Calling Settings    device=device_1
    Disable Call Queue Toggle    device=device_1
    verify status of call queue toggle button    device=device_1    status=off
    Return To Home Screen    device_list=device_1
    Verify And Click Queues In More Tab    device=device_1
    Wait For Some Time    time=10s
    verify status of call queue toggle button    device=device_1    status=off
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen     device_list=device_1

TC14 :[Calling] Call as dynamic org AA/CQ caller id
    [Tags]      451601  P1
    [Setup]   Run keywords     Testcase Setup for CQ PSTN User   count=4     AND    verify toggle appear on the queue options    AND    Enable unanswered call to voicemail      from_device=device_1     contact_device=device_2  
    click on calls tab   device=device_1
    verify AA and CQ configured in call as myself  from_device=device_1    to_device=device_2:pstn_user
    [Teardown]  Run Keywords    Capture on Failure  AND    Disable unanswered call   device=device_1    contact_device=device_2    AND     Come back to home screen     device_list=device_1,device_2,device_3,device_4

TC15 : DUT should display the CQ Call logs with Call queue badge in Recent tab under Calls app
    [Tags]    502340
    [Setup]    run Keywords      Testcase Setup for CQ User    count=2    AND    verify toggle appear on the queue options
    click on calls tab   device=device_2
    Place call to phone num    from_device=device_2      phone_num=CQ_no
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Navigate To Calls Tab    device=device_1
    verify cq call log in calls tab    device=device_1    to_device=device_2
    [Teardown]    Run Keywords    Capture on Failure      AND      Come back to home screen     device_list=device_1,device_2

TC16 : DUT should display the Leads, Observing and opted out agents when user disabled Call queue name in the call queue app
    [Tags]    502345
    [Setup]    Run keywords    Testcase Setup for CQ User    count=1    AND    verify toggle appear on the queue options
    verify and click queues in more tab    device=device_1
    Verify Call Queue Option In Queue Tab    device=device_1
    Disable Call Queue Toggle    device=device_1
    verify status of call queue toggle button     device=device_1    status=off
    verify and click queues in more tab    device=device_1
    verify and click on queues name    device=device_1    status=off
    verify people tab in queues name    device=device_1    status=off
    [Teardown]    Run Keywords    Capture on Failure      AND      Come back to home screen     device_list=device_1

TC17 : DUT should display the CQ Call logs in calls tab under Queues app
    [Tags]    502346    tp_audio    sanity_tp    bvt_tp            P0    
    [Setup]   Testcase Setup for CQ User    count=2
    Place call to phone num    from_device=device_2      phone_num=CQ_no
    Verify Incoming Call    device=device_1    status=appear
    Disconnect Call    device=device_1
    Verify Incoming Call    device=device_1    status=disappear
    Disconnect Call    device=device_2
    verify call state    device_list=device_2    state=disconnected
    verify and click queues in more tab    device=device_1
    Verify Call Queue Option In Queue Tab    device=device_1
    verify and click on queues name    device=device_1    status=on
    navigate to calls in queue tab    device=device_1
    verify cq call log in calls tab    device=device_1    to_device=device_4    status=Incoming
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen     device_list=device_2,device_1

TC18 : Verify DUT should display Queues with New badge on home screen when we reorder the Queues app to Homescreen.
    [Tags]    502326    sanity_tp    bvt_tp
    [Setup]  Testcase Setup   count=1
    Sign out method    device=device_1
    Wait for Some Time    time=5s
    Sign in method      device=device_1      user=Sign_in_with_other_than_Call_queue_agents_but_assigned_teams_premium_license
    verify and click queues in more tab    device=device_1
    verify call queues section is absent in calling settings    device=device_1
    [Teardown]    Run Keywords    Capture on Failure   AND    Come back to home screen     device_list=device_1

TC19 : Verify DUT should display Queues with New badge on home screen when we reorder the Queues app to Homescreen.
    [Tags]    502327
    [Setup]   Testcase Setup for CQ User    count=1
    ${before_home_screen_tiles}=    get home screen tiles    device=device_1
    verify and click queues in more tab    device=device_1
    Verify Call Queue Option In Queue Tab    device=device_1
    return to home screen    device_list=device_1
    Navigate to reorder tab     device=device_1
    Verfy and reorder homescreen tiles   device=device_1    tab=Queues    destination=voicemail
    ${after_home_screen_tiles}=    get home screen tiles    device=device_1
    verify updated home screen tile after editing       before_changing=${before_home_screen_tiles}         after_changing=${after_home_screen_tiles}
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen     device_list=device_1

TC20 : Verify the options present inside the more info icon for CQ Call logs in Calls under CQ app when user tap on Call queue name in the Queues app
    [Tags]    502342    P2
    [Setup]      Run keywords       Testcase Setup for CQ User    count=2    AND    verify toggle appear on the queue options
    Place call to phone num    from_device=device_2      phone_num=CQ_no
    Verify Incoming Call    device=device_1    status=appear
    Disconnect Call    device=device_1,device_2
    verify and click queues in more tab    device=device_1
    Verify Call Queue Option In Queue Tab    device=device_1
    verify and click on queues name    device=device_1    status=on
    navigate to calls in queue tab    device=device_1
    verify cq call log in calls tab    device=device_1    to_device=device_2    status=Incoming
    verify and click on more info icon in call queue    device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen     device_list=device_2,device_1


*** Keywords ***

verify toggle appear on the queue options
    Navigate to calls tab   device=device_1
    Return to home screen       device_list=device_1
    Verify And Click Queues In More Tab    device=device_1
    verify call queue option in queue tab       device=device_1
    Enable Call Queue Toggle    device=device_1
    Return to home screen       device_list=device_1




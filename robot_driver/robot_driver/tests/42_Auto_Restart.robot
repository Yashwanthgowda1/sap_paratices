*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10
${wait_time2} =  20

*** Test Cases ***
TC 1: [Auto Restart] DUT user checks options present after enabling the App restart option.
    [Tags]  319290   P1
    [Setup]  Testcase Setup  count=1
    Enable app restart toggle button    device=device_1      status=on
    verify options after enabling auto restart toggle btn     device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND     Disable app restart toggle button   device=device_1   status=off    AND   Come back to home screen    device_list=device_1

TC 2: [Auto Restart] DUT user disables the "Automatically" option.
    [Tags]  319291   P2
    [Setup]  Testcase Setup  count=1
    Enable app restart toggle button    device=device_1       status=on
    verify options after enabling auto restart toggle btn     device=device_1
    enable disable automatically toggle btn inside app restart      device=device_1
    verify options after disabling automatically toggle btn    device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND     Disable app restart toggle button   device=device_1   status=off    AND   Come back to home screen    device_list=device_1

TC 3:[Auto Restart] DUT user enables App Restart option.
    [Tags]  319289   P2
    [Setup]  Testcase Setup  count=1
    Enable app restart toggle button    device=device_1    status=on
    [Teardown]  Run Keywords    Capture on Failure   AND     Disable app restart toggle button    device=device_1   status=off    AND   Come back to home screen    device_list=device_1

TC 4: [Auto Restart] Verify DUT auto restart after scheduled time.
    [Tags]    315954    bvt_tp        sanity_tp        bvt_pr
    [Setup]   Testcase Setup  count=1
    Enable app restart toggle button    device=device_1      status=on
    Disable automatically restart toggle button    device=device_1
    Set app restart timer and verify        device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND     Disable app restart toggle button   device=device_1   status=off    AND   Come back to home screen    device_list=device_1

TC 5:[Auto Restart] DUT user schedule auto restart time using Set time pop up.
    [Tags]    319296    
    [Setup]    Testcase Setup  count=2
    Enable app restart toggle button    device=device_1      status=on
    Disable automatically restart toggle button    device=device_1
    set timer for app restart    device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND     Disable app restart toggle button   device=device_1   status=off    AND   Come back to home screen    device_list=device_1

TC 6:[Auto Restart] DUT user to check auto app restart during an incoming call
    [Tags]    319339
    [Setup]    Testcase Setup  count=2
    Enable app restart toggle button    device=device_1      status=on
    Disable automatically restart toggle button    device=device_1
    set timer for app restart    device=device_1
    click on calls tab  device=device_2
    Wait For Some Time    time=1 minutes
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    verify app restarting at set time    device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND     Disable app restart toggle button   device=device_1   status=off    AND   Come back to home screen    device_list=device_1,device_2

TC 7:[Auto Restart] DUT user to check auto app restart when in call and when call is on hold .
    [Tags]    315955    sanity_tp
    [Setup]   Testcase Setup  count=2
    Enable app restart toggle button    device=device_1      status=on
    Disable automatically restart toggle button    device=device_1
    set timer for app restart    device=device_1
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify app restarting at set time    device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    Disconnect call     device=device_2
    return to home screen    device_list=device_2
    navigate to auto app restart    device=device_1
    set timer for app restart    device=device_1
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1    state=Hold
    verify app restarting at set time    device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND     Disable app restart toggle button   device=device_1   status=off    AND   come back home screen for user   count=2

TC 8:[Auto Restart] DUT user verify the Auto restart banner in different tabs
    [Tags]    319293
    [Setup]   Testcase Setup  count=1
    Enable app restart toggle button    device=device_1      status=on
    Disable automatically restart toggle button    device=device_1
    set timer for app restart    device=device_1
    return to home screen    device_list=device_1
    click on calls tab  device=device_1
    verify app restarting at set time    device=device_1
    navigate to auto app restart    device=device_1
    verify options after disabling automatically toggle btn    device=device_1
    set timer for app restart    device=device_1    time_=3
    return to home screen    device_list=device_1
    navigate to voicemail tab    device=device_1
    verify app restarting at set time    device=device_1
    navigate to auto app restart    device=device_1
    verify options after disabling automatically toggle btn    device=device_1
    set timer for app restart    device=device_1
    return to home screen    device_list=device_1
    navigate to walkie talkie tab    device=device_1
    verify app restarting at set time    device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND     Disable app restart toggle button   device=device_1   status=off    AND   Come back to home screen    device_list=device_1

TC 9:[Auto Restart] DUT user to check auto app restart when in meeting
    [Tags]    315956    sanity_tp
    [Setup]    Testcase Setup  count=2
    clear all day meeting and meeting history from calendar   devices=device_1,device_2
    create meeting   device=device_2    meeting=test_meeting1    participants=device_1
    Enable app restart toggle button    device=device_1      status=on
    Disable automatically restart toggle button    device=device_1
    set timer for app restart    device=device_1    time_=3
    return to home screen    device_list=device_1
    Join Meeting    device=device_1,device_2     meeting=test_meeting1
    Verify meeting state    device_list=device_1,device_2   state=connected
    verify app restarting at set time    device=device_1
    Verify meeting state    device_list=device_1   state=disconnected
    End meeting     device=device_2
    Verify meeting state    device_list=device_2   state=disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND     Disable app restart toggle button   device=device_1   status=off    AND   come back home screen for user   count=2

TC 10:[Auto Restart] DUT user to verify the Auto restart banner not displayed on device settings page
    [Tags]    319337
    [Setup]    Testcase Setup  count=1
    Enable app restart toggle button    device=device_1      status=on
    Disable automatically restart toggle button    device=device_1
    set timer for app restart    device=device_1
    return to home screen    device_list=device_1
    navigate to device setting page from home screen enable page    device=device_1
    Wait For Some Time    time=1 minutes
    verify app restarting notification    device=device_1    status=absent
    [Teardown]  Run Keywords    Capture on Failure   AND     Disable app restart toggle button   device=device_1   status=off    AND   Come back to home screen    device_list=device_1

TC 11:[Auto Restart] DUT user to check auto restart when call is on hold
    [Tags]    319350
    [Setup]    Testcase Setup  count=2
    Enable app restart toggle button    device=device_1      status=on
    Disable automatically restart toggle button    device=device_1
    set timer for app restart    device=device_1
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1    state=Hold
    verify app restarting at set time    device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND     Disable app restart toggle button   device=device_1   status=off    AND   come back home screen for user   count=2

TC 12:[Auto restart] DUT user to check auto restart while parking the call
    [Tags]    319349
    [Setup]    Testcase Setup  count=2
    Enable app restart toggle button    device=device_1      status=on
    Disable automatically restart toggle button    device=device_1
    set timer for app restart    device=device_1
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    click call park    device=device_1
    go back to previous page      device=device_1
    verify app restarting at set time    device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND     Disable app restart toggle button   device=device_1   status=off    AND    dismiss multiple call park banner   device=device_1    AND    come back home screen for user   count=2

TC 13:[Auto Restart] DUT user to check for auto app restart when sending a page via walkie talkie
    [Tags]    319343
    [Setup]    Testcase Setup  count=2
    Enable app restart toggle button    device=device_1      status=on
    Disable automatically restart toggle button    device=device_1
    set timer for app restart    device=device_1
    return to home screen    device_list=device_1
    navigate to walkie talkie tab  device=device_1,device_2
    select the channel  device=device_1,device_2     channel=Channel_1
    click on connect and verify mic  device=device_1,device_2
    verify connected paricipant list  device=device_1      connected_device_list=device_1,device_2
    press and hold the mic button  from_device=device_2    to_device=device_1
    set timer for app restart    device=device_1    time_=3
    click on disconnect and verify mic  device=device_1,device_2
    [Teardown]  Run Keywords    Capture on Failure   AND     Disable app restart toggle button   device=device_1   status=off    AND    dismiss multiple call park banner   device=device_1    AND    come back home screen for user   count=2

TC 14: [Auto Restart] DUT user schedule auto restart time using clock pop up.
    [Tags]  319292   P2   
    [Setup]  Testcase Setup    count=1
    Enable App Restart Toggle Button    device=device_1      status=on
    Disable automatically restart toggle button    device=device_1
    set timer for app restart    device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND     Disable app restart toggle button   device=device_1   status=off    AND   Come back to home screen    device_list=device_1

TC 15: [Auto App Restart] [Long-haul] Teams App restart when kept idle for long haul, All tabs data sync after restart
    [Tags]    320192
    [Setup]    Testcase Setup    count=1
    Enable App Restart Toggle Button    device=device_1      status=on
    Disable Automatically Restart Toggle Button    device=device_1
    Set Timer For App Restart    device=device_1    time_=15
    Wait For Some Time    time=15 minutes
    Verify App Restarting At Set Time    device=device_1
    Navigate To Calls Tab    device=device_1
    Verify Calls Recent Tab     device=device_1
    Verify Calls Favorites Tab      device=device_1
    Navigate To Calendar Tab   device=device_1
    Verify Options In Calendar Tab      device=device_1        phone_number=device_1
    Navigate To Voicemail Tab    device=device_1
    Verify Voicemail Tab    device=device_1
    Navigate To People Tab    device=device_1
    Verify List Of Group Names In People Tab    device=device_1
    Verify Plus Icon On People Tab    device=device_1
    Verify Settings Calling Option      device=device_1
    Verify Default Setting Under Call Forwarding Section    device=device_1     status=off
    Navigate To Device Setting Page    device=device_1
    Verify Phone Lock Status In Device Settings    device=device_1
    [Teardown]    Run Keywords    Capture On Failure    AND    Disable app restart toggle button   device=device_1   status=off    AND    Come Back To Home Screen    device_list=device_1

*** Keywords ***
Verify app restart toggle button
    [Arguments]     ${device}    ${toggle}
    open settings page       device=device_1
    verify auto restart option inside settings page      device=device_1
    verify app restart toggle   ${device}     ${toggle}

Enable app restart toggle button
    [Arguments]     ${device}     ${status}
    open settings page       device=device_1
    verify auto restart option inside settings page      device=device_1
    Click on toggle btn    ${device}      ${status}

Disable app restart toggle button
    [Arguments]     ${device}     ${status}
    return to home screen   ${device}
    open settings page       device=device_1
    verify auto restart option inside settings page      device=device_1
    Click on toggle btn    ${device}      ${status}

Set app restart timer and verify
    [Arguments]    ${device}
    set timer for app restart    ${device}
    Wait For Some Time    time=30 seconds
    verify app restarting at set time    ${device}

Disable automatically restart toggle button
    [Arguments]    ${device}
    verify options after enabling auto restart toggle btn     ${device}
    enable disable automatically toggle btn inside app restart      ${device}
    verify options after disabling automatically toggle btn    ${device}
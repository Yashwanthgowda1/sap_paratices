*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation      Suite Setup Requirements : This suite requires minimum of 2 devices in config
...                Purpose: Device_2 should be added as a favorite on Device_1 from recent call history


Suite Setup    Improved Touch and Navigation Suite Setup
Suite Teardown     Run keyword and ignore error     Improved Touch and Navigation suite Teardown

*** Variables ***
${wait_time} =  10


*** Test Cases ***
TC1 : [Calls] Verify Dial pad as default calls view
    [Tags]      401972     P0   bvt_tp   sanity_tp
    [Setup]  Testcase Setup    count=1
    verify is portrait device       device=device_1
    Select call list item   device=device_1  item=favorite
    Select default view value   device=device_1     option=dialpad
    Validate calls tab after default value change    device=device_1      default_option=dialpad
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1    AND     Verify Default view relaunches after changing the value     device=device_1     option=speed dial

TC2 : [Calls] Verify call+ icon should not be present on calls tab
    [Tags]      402333     P0   bvt_tp   sanity_tp
    [Setup]  Testcase Setup    count=1
    verify is landscape device     device=device_1
    verify call plus icon absence in landscape devices  device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1

TC3 :[Calls] Verify Home button on launching any application
    [Tags]      402332     P0   bvt_tp   sanity_tp      bvt_pr
    [Setup]  Testcase Setup    count=1
    verify home button in different tabs   device=device_1     tab=calls_tab
    click on home bar icon      device=device_1
    verify home button in different tabs   device=device_1     tab=calendar
    click on home bar icon      device=device_1
    verify home button in different tabs   device=device_1     tab=people_tab
    click on home bar icon      device=device_1
    verify home button in different tabs   device=device_1     tab=walkie_talkie
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1

TC4 : [Calls] Verify home screen.
    [Tags]      401958    P0   bvt_tp    sanity_tp      bvt_pr
    [Setup]  Testcase Setup    count=1
    Clear Notification From Home Screen        device=device_1
    verify home screen tabs and more option tabs  device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen     device_list=device_1


TC5 : [App bar] Verify App bar [Tab bar] is not present on launching any application
    [Tags]      401971    P0   bvt_tp    sanity_tp
    [Setup]  Testcase Setup    count=1
    verify home button in different tabs   device=device_1     tab=calls_tab
    verify app bar is not present inside tabs  device=device_1
    click on home bar icon      device=device_1
    verify home button in different tabs   device=device_1     tab=calendar
    verify app bar is not present inside tabs  device=device_1
    click on home bar icon      device=device_1
    verify home button in different tabs   device=device_1     tab=voice_mail
    verify app bar is not present inside tabs  device=device_1
    click on home bar icon      device=device_1
    verify home button in different tabs   device=device_1     tab=walkie_talkie
    verify app bar is not present inside tabs  device=device_1
    click on home bar icon      device=device_1
    verify home button in different tabs   device=device_1     tab=people_tab
    verify app bar is not present inside tabs  device=device_1
    click on home bar icon      device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1

TC6 : [Calls] Verify People app on home screen.
    [Tags]      401960    P2
    [Setup]  Testcase Setup    count=1
    Verify plus icon on people tab   device=device_1
    Click plus icon and Verify its two options    device=device_1
    Select people app option and verify     device=device_1    option=Create new group
    Click cancel btn    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1

TC7 : [Calls] Verify calls view options under calling
    [Tags]      402334     P2
    [Setup]  Testcase Setup    count=1
    Verify call views option under callings settings     device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1

TC8 : [Calls] Verify the calls app, when default view is set to recent call history.
    [Tags]      402353     P2
    [Setup]  Testcase Setup    count=1
    verify is landscape device       device=device_1
    Select call list item   device=device_1  item=favorite
    Select default view value   device=device_1     option=recent call history
    Validate calls tab after default value change    device=device_1      default_option=recent call history
    navigate to calls tab       device=device_1
    verify favorites user option    from_device=device_1     to_device=device_2
    [Teardown]   Run Keywords    verify is landscape device       device=device_1    AND     Select default view and teardown

TC9: Verify Date and time in notification bar on all the tabs
    [Tags]      402355     P1
    [Setup]  Testcase Setup    count=1
    verify date and time in notification bar on all the tabs    device=device_1
    [Teardown]   Run Keywords    Capture on Failure       AND   Come back to home screen    device_list=device_1

TC10 : [Calls] Verify the calls App, when default view is set to speed dial.
    [Tags]      402352     P2
    [Setup]  Testcase Setup    count=1
    verify is landscape device     device=device_1
    Select call list item   device=device_1  item=favorite
    Select default view value   device=device_1     option=speed dial
    Validate calls tab after default value change    device=device_1      default_option=speed dial
    go back to previous page     device=device_1
    click on calls tab      device=device_1
    verify calls recent tab     device=device_1
    verify sorting options in recent tab  device=device_1
    verify calls favorites tab      device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    verify is landscape device     device=device_1     AND   Come back to home screen    device_list=device_1

TC11 :[Touch and Navigation] [Calls] Verify History icon on Dialpad, when default call's view is set to Dialpad.
    [Tags]      401974     P1   sanity_tp
    [Setup]  Testcase Setup    count=2
    verify is portrait device       device=device_1
    Select call list item   device=device_1  item=favorite
    Select default view value   device=device_1     option=dialpad
    Validate calls tab after default value change    device=device_1      default_option=dialpad
    go back to previous page     device=device_1
    click on calls tab      device=device_1
    navigates to recent tab while default view as dailpad  device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   verify is portrait device       device=device_1     AND   Select default view value   device=device_1     option=speed dial       AND   Come back to home screen    device_list=device_1,device_2

TC12 : [Touch and Navigation] [Home screen] DUT user should be able to access more (...) option in home screen while in P2P call.
    [Tags]      402341     P0   bvt_tp      sanity_tp
    [Setup]  Testcase Setup  count=2
    Clear notification from home screen     device=device_1
    ${before_home_screen_tiles}=    get home screen tiles    device=device_1
    ${destination_tab}=     get destination tab on home screen     device=device_1
    ${change_tab}=      select tab to move   device=device_1
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Click back          device=device_1
    Navigate to reorder tab     device=device_1
    Verfy and reorder homescreen tiles   device=device_1    tab=${change_tab}    destination=${destination_tab}
    ${after_home_screen_tiles}=    get home screen tiles    device=device_1
    verify updated home screen tile after editing       before_changing=${before_home_screen_tiles}         after_changing=${after_home_screen_tiles}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen     device_list=device_1

TC13: [Touch and Navigation] [Home Screen] Verify that reordering the apps in Edit navigation page should reflect in Navigation Preview
    [Tags]      402348     P2
    [Setup]  Testcase Setup  count=1
    Clear notification from home screen     device=device_1
    ${before_home_screen_tiles}=    get home screen tiles    device=device_1
    ${destination_tab}=     get destination tab on home screen     device=device_1
    ${change_tab}=      select tab to move   device=device_1
    Navigate to reorder tab     device=device_1
    Verfy and reorder homescreen tiles   device=device_1    tab=${change_tab}    destination=${destination_tab}
    ${after_home_screen_tiles}=    get home screen tiles    device=device_1
    verify updated home screen tile after editing       before_changing=${before_home_screen_tiles}         after_changing=${after_home_screen_tiles}
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen     device_list=device_1

TC14: [Touch and Navigation] [Calls] Verify DUT user able to receive the call while in edit navigation page.
    [Tags]      402349     P2
    [Setup]  Testcase Setup  count=2
    Clear notification from home screen     device=device_1
    ${before_home_screen_tiles}=    get home screen tiles    device=device_1
    ${destination_tab}=     get destination tab on home screen     device=device_1
    ${change_tab}=      select tab to move   device=device_1
    Navigate to reorder tab        device=device_1
    Verfy and reorder homescreen tiles   device=device_1    tab=${change_tab}    destination=${destination_tab}           option=verify
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen     device_list=device_1

TC15 : [Touch and Navigation] [Home screen] Verify that app order should be default on DUT home screen when same user sign-in again.
    [Tags]      402344     P0       bvt_tp      sanity_tp       bvt_pr
    [Setup]  Testcase Setup  count=1
    Clear notification from home screen     device=device_1
    ${before_home_screen_tiles}=    get home screen tiles    device=device_1
    ${destination_tab}=     get destination tab on home screen     device=device_1
    ${change_tab}=      select tab to move   device=device_1
    Navigate to reorder tab     device=device_1
    Verfy and reorder homescreen tiles   device=device_1    tab=${change_tab}    destination=${destination_tab}
    ${home_screen_tiles_before_signout}=    get home screen tiles    device=device_1
    verify updated home screen tile after editing       before_changing=${before_home_screen_tiles}         after_changing=${home_screen_tiles_before_signout}
    Sign out method    device_1
    Wait for Some Time    time=${wait_time}
    Sign in method     device_1
    Clear notification from home screen     device=device_1
    ${home_screen_tiles_after_signin}=    get home screen tiles    device=device_1
    verify home screen tile not changed       before_changing=${before_home_screen_tiles}         after_changing=${home_screen_tiles_after_signin}
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen     device_list=device_1

TC16 : [Touch and Navigation] [Home screen] Apps order should not change in Home screen.
    [Tags]      402350
    [Setup]  Testcase Setup  count=1
    Clear notification from home screen     device=device_1
    ${before_home_screen_tiles}=    get home screen tiles    device=device_1
    ${destination_tab}=     get destination tab on home screen     device=device_1
    ${change_tab}=      select tab to move   device=device_1
    Navigate to reorder tab     device=device_1
    Verfy and reorder homescreen tiles   device=device_1    tab=${change_tab}    destination=${destination_tab}           option=verify
    Click back          device=device_1
    ${after_home_screen_tiles}=    get home screen tiles    device=device_1
    verify home screen tile not changed      before_changing=${before_home_screen_tiles}         after_changing=${after_home_screen_tiles}
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen     device_list=device_1

TC17 : [Touch and navigation] [Calls] Verify hidden apps on Home screen > More[...]
    [Tags]      402330
    [Setup]  Testcase Setup  count=1
    Clear notification from home screen     device=device_1
    ${before_home_screen_tiles}=    get home screen tiles    device=device_1
    ${destination_tab}=     get destination tab on home screen     device=device_1
    ${change_tab}=      select tab to move   device=device_1
    Navigate to reorder tab     device=device_1
    Verfy and reorder homescreen tiles   device=device_1    tab=${change_tab}    destination=${destination_tab}
    ${after_home_screen_tiles}=    get home screen tiles    device=device_1
    verify updated home screen tile after editing       before_changing=${before_home_screen_tiles}         after_changing=${after_home_screen_tiles}
    ${tabs_inside_more_option}=     get the tab moved to more option     device=device_1    before_changing=${before_home_screen_tiles}         after_changing=${after_home_screen_tiles}
    Navigate to tab     device=device_1        tab=${tabs_inside_more_option}
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen     device_list=device_1

TC18 :[Touch and Navigation] [Calls] Verify Reorder on Home screen > More[...]
    [Tags]      402329      P2
    [Setup]  Testcase Setup  count=1
    Clear notification from home screen     device=device_1
    ${before_home_screen_tiles}=    get home screen tiles    device=device_1
    ${destination_tab}=     get destination tab on home screen     device=device_1
    ${change_tab}=      select tab to move   device=device_1
    Navigate to reorder tab     device=device_1
    Verfy and reorder homescreen tiles   device=device_1    tab=${change_tab}    destination=${destination_tab}
    ${after_home_screen_tiles}=    get home screen tiles    device=device_1
    verify updated home screen tile after editing       before_changing=${before_home_screen_tiles}         after_changing=${after_home_screen_tiles}
    ${tabs_on_home_screen}=     get destination tab on home screen     device=device_1
    Navigate to tab     device=device_1        tab=${tabs_on_home_screen}
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen     device_list=device_1

TC19 :[Touch and Navigation] [Calls] Verify DUT user able to do outgoing call from recent tab or Favorites tab when default view is set as Recent call History.
    [Tags]      402351    P1    sanity_tp
    [Setup]  Testcase Setup    count=1
    Select default view value   device=device_1     option=recent call history
    Validate calls tab after default value change    device=device_1      default_option=recent call history
    Return to home screen       device_list=device_1
    Select call list item   device=device_1  item=call
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    calling from favorite page          from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run keywords     Capture on Failure      AND    Select default view and teardown

TC20 : [Calls] Outgoing call to PSTN using dial pad from Favorites tab.
    [Tags]      401967      P0        bvt_tp      sanity_tp
    [Setup]  Testcase Setup for PSTN User   count=2
    verify is portrait device       device=device_1
    Select call list item   device=device_1  item=favorite
    Select default view value   device=device_1     option=speed dial
    Validate calls tab after default value change    device=device_1      default_option=speed dial
    go back to previous page     device=device_1
    make outgoing call using from call icon  from_device=device_1      to_device=device_2:pstn_user      call_from=favorites
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    verify is portrait device       device=device_1   AND   Select default view and teardown

TC21 : [Calls] Outgoing call to PSTN when default calls view is set to Dialpad.
    [Tags]      401973      P0        bvt_tp      sanity_tp
    [Setup]  Testcase Setup for PSTN User   count=2
    verify is portrait device       device=device_1
    Select call list item   device=device_1  item=favorite
    Select default view value   device=device_1     option=dialpad
    Validate calls tab after default value change    device=device_1      default_option=dialpad
    go back to previous page     device=device_1
    click on calls tab  device=device_1
    calling with dailpad        from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    verify is portrait device       device=device_1   AND   Select default view and teardown

TC22 : [Calls] Outgoing call to PSTN using dial pad from Recent tab.
    [Tags]      401968     P1
    [Setup]  Testcase Setup for PSTN User   count=2
    verify is portrait device       device=device_1
    Select call list item   device=device_1  item=favorite
    Select default view value   device=device_1     option=recent call history
    Validate calls tab after default value change    device=device_1      default_option=recent call history
    navigate to calls tab       device=device_1
    calling with dailpad        from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    verify is portrait device       device=device_1   AND   Select default view and teardown

TC23 : [Touch and Navigation] [Calls] Verify badge count for voicemail on home screen > More[...] app.
    [Tags]      401965    P1    
    [Setup]  Run Keywords    Testcase Setup    count=2    AND    Enable call forwarding to voicemail    from_device=device_1   contact_device=device_2
    Clear notification from home screen     device=device_1
    Navigate to voicemail tab    device=device_1
    Delete all voicemails   device=device_1
    return to home screen    device_list=device_1
    Send Voicemail      from_device=device_2    to_device=device_1
    Verify voicemail notification     to_device=device_1     from_device=device_2
    Clear notification from home screen     device=device_1
    verify voicemail badge is appeared    device=device_1
    navigate to voicemail tab  device=device_1
    refresh the page    device=device_1
    Play voicemail    device=device_1
    verify voicemail playing    device=device_1
    return to home screen    device_list=device_1
    Verify home screen page     device=device_1
    verify voicemail badge is disappeared    device=device_1
    [Teardown]    Run Keywords    Capture on Failure   AND    verify and disable call forwarding    device=device_1    AND    Come back to home screen    device_list=device_1,device_2

TC24: [Touch and Navigation] [Calls] Verify Dial pad icon on Favorites tab/Recent tab.
    [Tags]    401966
    [Setup]    Testcase Setup    count=1
    Select default view value     device=device_1     option=recent call history
    Validate calls tab after default value change    device=device_1      default_option=recent call history
    Return To Home Screen    device_list=device_1
    Click On Calls Tab    device=device_1
    verify calls recent tab     device=device_1
    Scroll The Call History In Recent Tab  device=device_1
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1   AND     Verify Default view relaunches after changing the value     device=device_1     option=speed dial

TC25: [Touch and Navigation] [Home screen] Verify that Changes made for apps to display on home screen should not retain when different user sign-in again
    [Tags]      402347     P1
    [Setup]     Testcase Setup   count=1
    Clear notification from home screen     device=device_1
    ${before_home_screen_tiles}=    get home screen tiles    device=device_1
    navigate to reorder tab     device=device_1
    Verfy and reorder homescreen tiles   device=device_1    tab=calls    destination=walkie talkie
    ${after_home_screen_tiles}=    get home screen tiles    device=device_1
    verify updated home screen tile after editing       before_changing=${before_home_screen_tiles}         after_changing=${after_home_screen_tiles}
    Sign out method    device_1
    Wait for Some Time    time=${wait_time}
    Signin with other user    device=device_1   other_user_account=device_2
    ${after_second_user_sigin_home_screen_tiles}=    get home screen tiles    device=device_1
    verify updated home screen tile after editing       before_changing=${after_home_screen_tiles}         after_changing=${after_second_user_sigin_home_screen_tiles}
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen     device_list=device_1

TC26: [Touch and Navigation] [Calls] Verify total badge count on home screen.
    [Tags]    402335    bvt_tp    sanity_tp
    [Setup]    Testcase Setup    count=2
    navigate to calls tab      device=device_1
    Navigate to voicemail tab    device=device_1
    Delete all voicemails   device=device_1
    Return To Home Screen    device_list=device_1
    ${before_home_screen_tiles}=    get home screen tiles    device=device_1
    Shuffling applications from Main to More    device=device_1
    ${after_home_screen_tiles}=    get home screen tiles    device=device_1
    verify updated home screen tile after editing       before_changing=${before_home_screen_tiles}         after_changing=${after_home_screen_tiles}
    verify calls and voicemail badge in more tab    device=device_1    status=calls    option=disappeared
    Click on calls tab   device=device_2
    Make outgoing call using display name   from_device=device_2     to_device=device_1
    Verify Incoming Call    device=device_1    status=appear
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    verify calls and voicemail badge in more tab    device=device_1    status=calls    option=appear
    Return To Home Screen    device_list=device_2
    Enable call forwarding to voicemail    from_device=device_1     contact_device=device_2
    verify calls and voicemail badge in more tab    device=device_1    status=voicemail    option=disappeared
    Click on calls tab   device=device_2
    Make outgoing call using display name   from_device=device_2     to_device=device_1
    Wait for Some Time    time=30s
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Return To Home Screen    device_list=device_1
    verify calls and voicemail badge in more tab    device=device_1    status=voicemail    option=appear
    Navigate to calls tab   device=device_1
    Call first participant from log    device=device_1
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Return To Home Screen    device_list=device_1
    verify calls and voicemail badge in more tab    device=device_1    status=calls    option=disappeared
    Navigate to voicemail tab    device=device_1
    Play voicemail    device=device_1
    Return To Home Screen    device_list=device_1
    verify calls and voicemail badge in more tab    device=device_1    status=voicemail    option=disappeared
    [Teardown]    run keywords    Capture on Failure   AND   verify and disable call forwarding    device=device_1    AND    Come back to home screen   device_list=device_1,device_2

*** Keywords ***
Improved Touch and Navigation Suite Setup
    Navigate to calls tab   device=device_1
    Make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1  item=favorite
    Verify added favorite user in favorites page    from_device=device_1     to_device=device_2

Improved Touch and Navigation suite Teardown
    Suite Failure Capture
    sign out method    device=device_2
    sign in method     device=device_2

Make outgoing call for call log
    [Arguments]     ${from_device}   ${to_device}
    Make outgoing call using display name    from_device=${from_device}      to_device=${to_device}
    Verify Incoming call    device=${to_device}     status=appear
    Disconnect call     device=${from_device}
    Verify Incoming call    device=${to_device}     status=disappear
    Verify Call State    device_list=${from_device}     state=Disconnected
    click back   device=${from_device}
    click back   device=${from_device}
    verify call history log    device=${from_device}

Select default view value
    [Arguments]     ${device}    ${option}
    Verify call views option under callings settings    ${device}
    Select default view     ${device}    option=${option}

Select default view and teardown
    Capture on Failure
    Select default view value   device=device_1     option=speed dial
    Come back to home screen    device_list=device_1

Send Voicemail
    [Arguments]     ${from_device}   ${to_device}
    Navigate to calls tab    ${from_device}
    Make outgoing call using display name    ${from_device}      ${to_device}
    Verify Call State    device_list=${from_device}   state=Connected
    Wait for Some Time    time=45s
    verify call state and disconnect    ${from_device}

Shuffling applications from Main to More
    [Arguments]     ${device}
    Navigate to reorder tab     ${device}
    Verfy and reorder homescreen tiles   device=${device}    tab=Calls    destination=Walkie Talkie
    Navigate to reorder tab     ${device}
    Verfy and reorder homescreen tiles   device=${device}    tab=People    destination=voicemail
    Navigate to reorder tab     ${device}
    Verfy and reorder homescreen tiles   device=${device}    tab=Walkie Talkie    destination=voicemail
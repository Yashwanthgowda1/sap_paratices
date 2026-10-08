*** Settings ***
Resource    resources/keywords/common.robot
Documentation      Suite Setup Requirements : This suite requires minimum of 3 devices in config
...                Purpose: Device_2 should be added as a favorite on Device_1 from recent call history

Suite Setup     Suite Setup
Suite Teardown    Run Keywords    Suite Failure Capture   AND     Suite Teardown    device=device_1

*** Variables ***
${wait_time} =  10


*** Test Cases ***
TC1 : [Call views] DUT to have Call views option under Calling settings
    [Tags]   309984      bvt_tp   sanity_tp    bvt_pr       alt_credentials      Certification_audio
    [Setup]    Testcase Setup    count=1
    Verify call views option under callings settings     device=device_1
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1

TC2 : DUT user to verify the Call views option under Calling settings.
    [Tags]     417228     
    [Setup]    Testcase Setup    count=1
    Verify call views option under callings settings     device=device_1
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1

TC3 : [Call views] DUT user selects "Default view" options as "Recent call history"
    [Tags]   310021     P2  alt_credentials        sanity_tp
    [Setup]    Testcase Setup    count=1
    Select default view value     device=device_1     option=recent call history
    Validate calls tab after default value change    device=device_1      default_option=recent call history
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1   AND     Verify Default view relaunches after changing the value     device=device_1     option=speed dial

TC4 :[Call views] DUT user to retain Default view settings until sign out
    [Tags]   310038     P2  alt_credentials
    [Setup]    Testcase Setup    count=1
    Select default view value     device=device_1     option=recent call history
    Validate calls tab after default value change    device=device_1      default_option=recent call history
    go back to previous page     device=device_1
    sign out method    device=device_1
    sign in method     device=device_1
    Validate calls tab after default value change    device=device_1      default_option=speed dial
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1

#PORTRAIT mode phone test case
TC5 : [Call views][Portrait Mode] DUT user selects "Default view" options as "Dial pad"
    [Tags]   310025     P2  alt_blocked     Certification_audio
    [Setup]    Testcase Setup    count=1
    ${prt_mode_flag}   is portrait mode cnf device  device=device_1
    pass execution if   '${prt_mode_flag}'=='False'  device_1, device is not a portrait mode device
    Select default view value     device=device_1   option=dialpad
    Validate calls tab after default value change    device=device_1      default_option=dialpad
    [Teardown]    Check device orientation and teardown

#PORTRAIT mode phone test case
TC6 : [Call views][Portrait Mode] "Default View" set to "Dial pad", DUT user makes an outgoing call to a TDC from the "FAVORITES" tab
    [Tags]   310033     P2  alt_blocked
    [Setup]    Testcase Setup    count=2
    ${prt_mode_flag}   is portrait mode cnf device  device=device_1
    pass execution if   '${prt_mode_flag}'=='False'  device_1, device is not a portrait mode device
    Select default view value     device=device_1   option=dialpad
    Validate calls tab after default value change    device=device_1      default_option=dialpad
    go back to previous page     device=device_1
    Calling from favorite page   from_device=device_1     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Come back to home screen    device_list=device_1,device_2
    [Teardown]   Check device orientation and teardown

TC7 : [Calls views] Device to relaunch the App when any of the option selected in Default view
    [Tags]   309988     bvt_tp   sanity_tp    bvt_pr         alt_credentials
    [Setup]    Testcase Setup    count=1
    Verify Default view relaunches after changing the value     device=device_1     option=recent call history
    navigate to calls tab   device=device_1
    Validate calls tab after default value change    device=device_1      default_option=recent call history
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1   AND     Verify Default view relaunches after changing the value     device=device_1     option=speed dial

TC8 : [Call views] User should be able to access Speed dial tab as default screen is set as "Recent Call history"
    [Tags]   318724     P2
    [Setup]    run keywords     Testcase Setup    count=1   AND     Select default view value     device=device_1     option=recent call history
    Validate calls tab after default value change    device=device_1      default_option=recent call history
    go back to previous page     device=device_1
    navigate to calls favorites page   device=device_1
    Verify callplus icon on favorites tab   device=device_1
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1    AND     Verify Default view relaunches after changing the value     device=device_1     option=speed dial

TC9 : [Call views] User should always redirect to Favorites tab as default screen is set as "Speed dial"
    [Tags]   318736     P2
    [Setup]    Testcase Setup    count=1
    Navigate to calls tab   device=device_1
    Navigate to calendar tab    device=device_1
    Navigate to calls tab   device=device_1
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1

TC10 : [Call views] Verify that user remains on default view screen after declining an incoming call
    [Tags]   318739     P2
    [Setup]     Testcase Setup    count=2
    Verify call views option under callings settings       device=device_1      verify_options_under_default_view=on
    go to call views options screen   device=device_1
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify incoming call  device=device_1   status=appear
    Rejects the incoming call    device_list=device_1
    Verify Call State    device_list=device_2     state=Disconnected
    Verify default view screen  device=device_1
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1,device_2

TC11 : [Call view] Verify the default view screens with Fresh user
    [Tags]   318789     P2
    [Setup]     Testcase Setup    count=1
    Sign out method       device_1
    Sign in method     device_1
    Suite Setup
    Verify call views option under callings settings       device=device_1      verify_options_under_default_view=on
    Verify default call screen view selected option     device=device_1     option=speed dial
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1


TC12 : [ Call view] Default call view screen settings should updated to Speed dial after user Signout
    [Tags]   319611     P2
    [Setup]     run keywords    Testcase Setup    count=1   AND     Select default view value     device=device_1     option=recent call history    AND     Validate calls tab after default value change    device=device_1      default_option=recent call history
    Navigate to calls tab   device=device_1
    sign out method    device=device_1
    sign in method     device=device_1
    Validate calls tab after default value change    device=device_1      default_option=speed dial
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1

TC13 : [Call view][Hot desk] User should be able to change the Default view setting in calling setting in Hot desk session as well
    [Tags]   319608     P2
    [Setup]     run keywords    Testcase Setup    count=3   AND     TC Setup for HotDesk
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode    device=device_1
    Verify call views option under callings settings       device=device_1      verify_options_under_default_view=on
    Select default view     device=device_1     option=recent call history
    Validate calls tab after default value change    device=device_1      default_option=recent call history
    [Teardown]    Run Keywords   Capture on Failure    AND      TC Teardown for HotDesk

TC14 : [7 inch and above] Verify DUT user to have Expanded Dialpad option under Default view.
    [Tags]      417250    P0
    [Setup]     Testcase Setup    count=1
    ${landscape_mode_flag}   is screen size 7 inch or more  device=device_1
    pass execution if   '${landscape_mode_flag}'=='False'  device_1, device screen size have less then 7 inch
    Verify call views option under callings settings     device=device_1        verify_options_under_default_view=on
    [Teardown]    Check device screen size and teardown

TC15 : [7 inch and above] Verify that Dark theme works fine in calls tab.
    [Tags]      417263    P1
    [Setup]     Testcase Setup    count=1
    ${landscape_mode_flag}   is screen size 7 inch or more  device=device_1
    pass execution if   '${landscape_mode_flag}'=='False'  device_1, device screen size have less then 7 inch
    Verify Default view relaunches after changing the value     device=device_1     option=expanded_dialpad
    Validate calls tab after default value change    device=device_1     default_option=expanded_dialpad
    go back to previous page     device=device_1
    verify and enable dark theme     device=device_1
    Validate calls tab after default value change    device=device_1     default_option=expanded_dialpad
    [Teardown]    Run Keywords   Capture on Failure    AND       Teardown for Dark Theme Disable

#PORTRAIT mode phone test case
TC16 : [5 inch and above] Verify that DUT user can cancel the default view as Dialpad.
    [Tags]      417241         P2
    [Setup]    Testcase Setup    count=1
    ${prt_mode_flag}   is portrait mode cnf device  device=device_1
    pass execution if   '${prt_mode_flag}'=='False'  device_1, device is not a portrait mode device
    Verify Default view relaunches after changing the value     device=device_1     option=recent call history
    go back to previous page     device=device_1
    Select and cancel default value     device=device_1     option=dialpad
    verify and enable dark theme     device=device_1
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1   AND     Verify Default view relaunches after changing the value     device=device_1     option=speed dial       AND         verify and disable dark theme     device=device_1

#PORTRAIT mode phone test case
TC17 : [5 inch and above] Verify that Dark theme works fine in calls tab
    [Tags]      417248      P1
    [Setup]    Testcase Setup    count=1
    ${prt_mode_flag}   is portrait mode cnf device  device=device_1
    pass execution if   '${prt_mode_flag}'=='False'  device_1, device is not a portrait mode device
    verify and enable dark theme     device=device_1
    navigate to calls tab       device=device_1
    verify calls recent tab         device=device_1
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1       AND     verify and disable dark theme     device=device_1

#PORTRAIT mode phone test case
TC18 : [5 inch and above] Verify that Dark theme works fine in in-call dial pad
    [Tags]      417249      P1
    [Setup]    Testcase Setup    count=2
    ${prt_mode_flag}   is portrait mode cnf device  device=device_1
    pass execution if   '${prt_mode_flag}'=='False'  device_1, device is not a portrait mode device
    verify and enable dark theme     device=device_1
    navigate to calls tab       device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    verif dialpad in call more option       device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1       AND     verify and disable dark theme     device=device_1

#LANDSCAPE mode phone test case
TC19 : [Landscape] [5 inch and above] Verify user can Dial all and delete the numeric digits successfully.
    [Tags]    417243           
    [Setup]    Testcase Setup    count=1 
    ${landscape_mode_flag}    is landscape device 5 inch or above    device=device_1 
    pass execution if    '${landscape_mode_flag}'=='False'  device_1, device screen size have less then 5 inch 
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON 
    verify dialpad after clicking speaker or handsethook button   device=device_1 
    dial and verify all numbers from dialpad    device=device_1 
    return to home screen    device_list=device_1 
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON 
    verify dialpad after clicking speaker or handsethook button   device=device_1 
    dial and verify all numbers from dialpad    device=device_1 
    verify and enable dark theme     device=device_1 
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON 
    verify dialpad after clicking speaker or handsethook button   device=device_1 
    dial and verify all numbers from dialpad    device=device_1 
    return to home screen    device_list=device_1 
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON 
    verify dialpad after clicking speaker or handsethook button   device=device_1 
    dial and verify all numbers from dialpad    device=device_1 
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1       AND     verify and disable dark theme     device=device_1 

#LANDSCAPE mode phone test case
TC20 : [Landscape] [5 inch and above] Verify user can delete the numeric digits successfully.
    [Tags]            417244   
    [Setup]    Testcase Setup    count=1 
    ${landscape_mode_flag}    is landscape device 5 inch or above    device=device_1 
    pass execution if    '${landscape_mode_flag}'=='False'  device_1, device screen size have less then 5 inch 
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON 
    verify dialpad after clicking speaker or handsethook button   device=device_1 
    dial and verify all numbers from dialpad    device=device_1 
    return to home screen    device_list=device_1 
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON 
    verify dialpad after clicking speaker or handsethook button   device=device_1 
    dial and verify all numbers from dialpad    device=device_1 
    verify and enable dark theme     device=device_1 
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON 
    verify dialpad after clicking speaker or handsethook button   device=device_1 
    dial and verify all numbers from dialpad    device=device_1 
    return to home screen    device_list=device_1 
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON 
    verify dialpad after clicking speaker or handsethook button   device=device_1 
    dial and verify all numbers from dialpad    device=device_1 
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1       AND     verify and disable dark theme     device=device_1 

#LANDSCAPE mode phone test case 
TC21 : [5 inch and above] Verify user can close the Dialpad by tapping on Home button.
    [Tags]    417245
    [Setup]    Testcase Setup    count=1 
    ${landscape_mode_flag}    is landscape device 5 inch or above    device=device_1 
    pass execution if    '${landscape_mode_flag}'=='False'  device_1, device screen size have less then 5 inch 
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON 
    verify dialpad after clicking speaker or handsethook button   device=device_1 
    return to home screen    device_list=device_1 
    Verify home screen page     device=device_1 
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON 
    verify dialpad after clicking speaker or handsethook button   device=device_1 
    return to home screen    device_list=device_1 
    Verify home screen page     device=device_1 
    verify and enable dark theme     device=device_1 
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON 
    verify dialpad after clicking speaker or handsethook button   device=device_1 
    return to home screen    device_list=device_1 
    Verify home screen page     device=device_1 
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON 
    verify dialpad after clicking speaker or handsethook button   device=device_1 
    return to home screen    device_list=device_1 
    Verify home screen page     device=device_1 
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1       AND     verify and disable dark theme     device=device_1 

#LANDSCAPE mode phone test case 
TC22 : [5 inch and above] Verify that DUT user can cancel the default view as dialpad.
   [Tags]    417246 
    [Setup]    Testcase Setup    count=1 
    ${landscape_mode_flag}    is landscape device 5 inch or above    device=device_1 
    pass execution if    '${landscape_mode_flag}'=='False'  device_1, device screen size have less then 5 inch 
    Verify Default view relaunches after changing the value     device=device_1     option=recent call history 
    go back to previous page     device=device_1 
    Select and cancel default value     device=device_1     option=speed dial 
    verify and enable dark theme     device=device_1 
    Verify Default view relaunches after changing the value     device=device_1     option=recent call history 
    go back to previous page     device=device_1 
    Select and cancel default value     device=device_1     option=speed dial 
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1   AND     Verify Default view relaunches after changing the value     device=device_1     option=speed dial       AND         verify and disable dark theme     device=device_1 

#LANDSCAPE mode phone test case 
TC23 : [5 inch and above]Verify the Dialpad UI by tapping on Hard speaker button
    [Tags]    417242
    [Setup]    Testcase Setup    count=1 
    ${landscape_mode_flag}    is landscape device 5 inch or above    device=device_1 
    pass execution if    '${landscape_mode_flag}'=='False'  device_1, device screen size have less then 5 inch 
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON 
    verify dialpad after clicking speaker or handsethook button   device=device_1 
    return to home screen    device_list=device_1 
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON 
    verify dialpad after clicking speaker or handsethook button   device=device_1 
    return to home screen    device_list=device_1 
    verify and enable dark theme     device=device_1 
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON 
    verify dialpad after clicking speaker or handsethook button   device=device_1 
    return to home screen    device_list=device_1 
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON 
    verify dialpad after clicking speaker or handsethook button   device=device_1 
    return to home screen    device_list=device_1 
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1       AND     verify and disable dark theme     device=device_1

#PORTRAIT mode phone test case
TC24 : [Call view][Portrait device] User should be able to dial PSTN number using Soft dialpad, default calls screen is set as "Dialpad"
    [Tags]  319448    P2
    [Setup]     Testcase Setup for PSTN User    count=2
    ${prt_mode_flag}   is portrait mode cnf device  device=device_1
    pass execution if   '${prt_mode_flag}'=='False'  device_1, device is not a portrait mode device
    Select default view value     device=device_1     option=dialpad
    Validate calls tab after default value change    device=device_1      default_option=dialpad
    go back to previous page     device=device_1
    Make outgoing call using from dial pad   from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]    Check device orientation and teardown

TC25 : [Call view] UI should not have any distortion when default call view screen is set
    [Tags]      318792    P2
    [Setup]      Run Keywords     Testcase Setup    count=3    AND     select call list item    device=device_1     item=favorite
    Select default view value   device=device_1     option=speed dial
    Validate calls tab after default value change    device=device_1      default_option=speed dial
    return to home screen    device_list=device_1
    Add new delegates with both permission and validate   from_device=device_2    to_device=device_1
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_3
    Navigate to Calls Favorites page    device=device_1
    
    verify added delegate user with presence in favorites page      from_device=device_1    to_device=device_3
    verify user in people you support with presence in favorites_page       from_device=device_1    to_device=device_2
    Verify added favorite user in favorites page      from_device=device_1    to_device=device_2
    verify make a call options and dial pad present     device=device_1
    Select default view value     device=device_1     option=recent call history
    Navigate to calls tab   device=device_1
    Verify call history log    device=device_1
    verify make a call options and dial pad present     device=device_1     call_tab=favorite_tab_option
    [Teardown]    Run Keywords    Check device orientation and teardown     AND    Delete the delegate user added and favorite user

TC26 : [Call views] Verify History FAB icon is present in the Dialpad screen in Calls app.
    [Tags]      435300    P2
    [Setup]   Testcase Setup    count=1
    ${dailpad}   is hard dial pad present   device=device_1
    pass execution if   '${dailpad}'=='True'  device_1, use the soft dial pad devices
    Select default view value     device=device_1     option=speed dial
    Validate calls tab after default value change    device=device_1      default_option=speed dial
    Navigate to calls tab   device=device_1
    verify the fab icon changes in call view setting    device=device_1
    Verify call history log    device=device_1
    return to home screen    device_list=device_1
    Select default view value     device=device_1   option=dialpad
    Navigate to calls tab   device=device_1
    verify the fab icon changes in call view setting    device=device_1     call_view_option=dial_pad
    Select default view value     device=device_1     option=recent call history
    Validate calls tab after default value change    device=device_1      default_option=recent call history
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK      status=ON
    verify the fab icon changes in call view setting    device=device_1     call_view_option=hand_set
    [Teardown]        Check device orientation and teardown

TC27 : [Call views] Default Call views to remain the same after device reboot
    [Tags]    310041    sanity_tp    smoke_tp
    [Setup]   Testcase Setup    count=1
    Select default view value   device=device_1     option=speed dial
    Validate calls tab after default value change    device=device_1      default_option=speed dial
    reboot phones    device=device_1
    Validate calls tab after default value change    device=device_1      default_option=speed dial
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1

TC28 : [ Call view] Verify the default view screens with non-ev enabled user(non DID supported accounts)]
    [Tags]    319550
    [Setup]    Testcase Setup    count=1
    Signin With Other User    device=device_1    other_user_account=device_1:non_ev_enabled_account
    Verify Call Views Option Under Callings Settings    device=device_1    verify_options_under_default_view=on
    Verify Default Call Screen View Selected Option     device=device_1     option=speed dial
    [Teardown]    Run Keywords    Capture On Failure    AND    Come Back To Home Screen    device_list=device_1    AND    Signin With Other User    device=device_1    other_user_account=device_1

TC29 : [Call view]Verify that missed call pill count appears correctly on recent tab, Default view - Speed dial, Calls tab hidden
    [Tags]    319614
    [Setup]    Testcase Setup    count=2
    ${before_home_screen_tiles}=    get home screen tiles    device=device_1
    Navigate to reorder tab    device=device_1
    Verfy and reorder homescreen tiles   device=device_1    tab=Calls    destination=Walkie Talkie
    ${after_home_screen_tiles}=    get home screen tiles    device=device_1
    verify updated home screen tile after editing       before_changing=${before_home_screen_tiles}         after_changing=${after_home_screen_tiles}
    Click on calls tab   device=device_2
    Make outgoing call using display name   from_device=device_2     to_device=device_1
    Verify Incoming Call    device=device_1    status=appear
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    verify calls and voicemail badge in more tab    device=device_1    status=calls    option=appear
    verify calls recent tab pill count      from_device=device_1      to_device=device_2
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1,device_2

*** Keywords ***
Suite Setup
    Navigate to calls tab   device=device_1
    Make outgoing call for call log   from_device=device_1     to_device=device_2
    Select call list item   device=device_1  item=favorite
    Verify added favorite user in favorites page    from_device=device_1     to_device=device_2

Suite Teardown
    [Arguments]     ${device}
    Come back to home screen     ${device}
    Select default view value     ${device}     option=speed dial

Make outgoing call for call log
    [Arguments]     ${from_device}   ${to_device}
    Make outgoing call using display name    from_device=${from_device}      to_device=${to_device}
    Verify Incoming call    device=${to_device}     status=appear
    Disconnect call     device=${from_device}
    Verify Incoming call    device=${to_device}     status=disappear
    Verify Call State    device_list=${from_device}     state=Disconnected
    Return to home screen       device_list=${from_device}
    Click on calls tab   device=${from_device}
    Refresh calls main tab    device=${from_device}

Teardown for Dark Theme Disable
    Come back to home screen    device_list=device_1
    Verify Default view relaunches after changing the value     device=device_1     option=speed dial
    verify and disable dark theme     device=device_1

TC Setup for HotDesk
    Click on calls tab   device=device_2
    Make outgoing call for call log   from_device=device_2     to_device=device_3
    Select call list item   device=device_2  item=favorite
    Verify added favorite user in favorites page    from_device=device_2    to_device=device_3

TC Teardown for HotDesk
    Come back to home screen    device_list=device_1,device_2
    Verify Default view relaunches after changing the value     device=device_1     option=speed dial
    End hot desk    device=device_1
    Validate username after signed out from hot desking    device=device_1

Check device orientation and teardown
    ${prt_mode_flag}   is portrait mode cnf device  device=device_1
    pass execution if   '${prt_mode_flag}'=='False'  device_1, device is not a portrait mode device
    Capture on Failure
    Come back to home screen    device_list=device_1
    Verify Default view relaunches after changing the value     device=device_1     option=speed dial

Check device screen size and teardown
    ${landscape_mode_flag}   is screen size 7 inch or more  device=device_1
    pass execution if   '${landscape_mode_flag}'=='False'  device_1, device screen size have less then 7 inch
    Capture on Failure
    Come back to home screen    device_list=device_1
    Verify Default view relaunches after changing the value     device=device_1     option=speed dial


Delete the delegate user added and favorite user
    Delete delegate from manage delegate   from_device=device_2    to_device=device_1
    Delete delegate from manage delegate   from_device=device_1    to_device=device_3
    Remove favorite user from favorites page    from_device=device_1     to_device=device_2
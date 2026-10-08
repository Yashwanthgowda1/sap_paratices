#*** Settings ***
#Documentation     App_Bar feature
#Force Tags   App_Bar    23
#Library     DateTime
#Library     OperatingSystem
#Resource   ../resources/keywords/common.robot
#
#
#Suite Teardown    Suite Failure Capture
#
#*** Variables ***
#${wait_time} =  10



# App bar feature removed from U3-2023
#*** Test Cases ***
#TC1 : [App Bar] DUT user should have Calls, Calendar and People tabs by default along with more (…) option on the App bar
#    [Tags]   310044    P1  alt_bug
#    [Setup]  Testcase Setup   count=1
#    Navigate to more option   device=device_1
#    Click hide more apps   device=device_1
#    Verify default tabs along with more option  device=device_1
#    [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1
#
#TC2 : [App Bar] DUT user to access all the Apps after reorder
#    [Tags]    310048    bvt    bvt_pr      23_bvt  alt_bug
#    [Setup]  Testcase Setup   count=1
#    Navigate to more option   device=device_1
#    Click reorder option  device=device_1
#    Validate drag and drop app from one section to other section  device=device_1    tab=Calls tab    destination=Voicemail tab
#    Validate home screen after reorder of apps  device=device_1   tab=Calls tab,Calendar tab,People tab,Voicemail tab
#    Come back to home screen    device_list=device_1
#    Navigate to calendar tab   device=device_1
#    Navigate to people tab  device=device_1
#    Come back to home screen  device_list=device_1
#    [Teardown]    Run Keywords    Capture on Failure   AND   App Bar Teardown  device=device_1   tab=Calls tab   destination=Calendar tab
#
#TC3 : [App Bar] DUT user should be able to access more (...) option while in P2P call
#    [Tags]   310093    P2  alt_bug
#    [Setup]  Testcase Setup   count=2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Click back btn   device=device_1
#    Navigate to more option   device=device_1
#    Navigate to calendar tab  device=device_1
#    Disconnect call  device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    Come back to home screen   device_list=device_1,device_2
#    [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2
#
#TC4 : [App Bar] Saving changes after editing App bar should relaunch Teams App
#    [Tags]   310054    P2  alt_bug
#    [Setup]  Testcase Setup   count=1
#    Navigate to more option   device=device_1
#    Click reorder option  device=device_1
#    Validate drag and drop app from one section to other section  device=device_1    tab=Calls tab    destination=Voicemail tab
#    Validate home screen after reorder of apps  device=device_1   tab=Calls tab,Calendar tab,People tab,Voicemail tab
#    Come back to home screen    device_list=device_1
#    [Teardown]    Run Keywords    Capture on Failure   AND   App Bar Teardown  device=device_1   tab=Calls tab   destination=Calendar tab
#
#TC5 : [App Bar] DUT user should be able to make calls from Calls tab when Calls App is not in main screen
#    [Tags]   310082    P2  alt_bug
#    [Setup]  Testcase Setup   count=2
#    Navigate to more option   device=device_1
#    Click reorder option  device=device_1
#    Validate drag and drop app from one section to other section  device=device_1    tab=Calls tab    destination=Voicemail tab
#    Validate home screen after reorder of apps  device=device_1   tab=Calls tab,Calendar tab,People tab,Voicemail tab
#    Navigate to more option   device=device_1
#    Navigate to calls tab    device=device_1
#    Verify favorites and recent call tab  device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Disconnect call  device=device_1
#    Come back to home screen   device_list=device_1,device_2
#    [Teardown]    Run Keywords    Capture on Failure   AND   App Bar Teardown  device=device_1   tab=Calls tab   destination=Calendar tab
#
#TC6 : [App Bar] Teams App should not display hidden Apps in main screen
#    [Tags]  310090  P2  alt_bug
#    [Setup]  Testcase Setup  count=1
#    Navigate to more option   device=device_1
#    Click reorder option  device=device_1
#    Validate drag and drop app from one section to other section  device=device_1    tab=Calls tab    destination=Voicemail tab
#    Validate home screen after reorder of apps  device=device_1   tab=Calls tab,Calendar tab,People tab,Voicemail tab
#    [Teardown]    Run Keywords    Capture on Failure   AND   App Bar Teardown  device=device_1   tab=Calls tab   destination=Calendar tab
#
#TC7 : [App Bar] Device to show only available App on the device to edit/modify
#    [Tags]  310062   P2  alt_bug
#    [Setup]   Testcase Setup  count=1
#    Navigate to more option   device=device_1
#    Click reorder option  device=device_1
#    Validate drag and drop app from one section to other section  device=device_1    tab=Calls tab    destination=Voicemail tab
#    Navigate to more option   device=device_1
#    Verify available app present on screen  device=device_1
#    Click Hide more apps   device=device_1
#    Validate home screen after reorder of apps  device=device_1   tab=Calls tab,Calendar tab,People tab,Voicemail tab
#    Come back to home screen    device_list=device_1
#    [Teardown]    Run Keywords    Capture on Failure   AND   App Bar Teardown  device=device_1   tab=Calls tab   destination=Calendar tab
#
#TC8 : [App Bar] DUT user can view notifications on hidden Apps
#    [Tags]  310084   P2  alt_bug
#    [Setup]   Testcase Setup  count=2
#    Navigate to more option   device=device_1
#    Click reorder option  device=device_1
#    Validate drag and drop app from one section to other section  device=device_1    tab=Calls tab    destination=Voicemail tab
#    Validate home screen after reorder of apps  device=device_1   tab=Calls tab,Calendar tab,People tab,Voicemail tab
#    Make outgoing call using display name    from_device=device_2      to_device=device_1
#    Disconnect call  device=device_2
#    Navigate to more option   device=device_1
#    Navigate to calls tab  device=device_1
#    Get missed calls count  device=device_1
#    Send Voicemail      from_device=device_2      to_device=device_1
#    Navigate to voicemail tab  device=device_1
#    Get missed voicemail count  device=device_1
#    Come back to home screen  device_list=device_1,device_2
#    [Teardown]    Run Keywords    Capture on Failure   AND  Voicemail Teardown  AND  App Bar Teardown  device=device_1   tab=Calls tab   destination=Calendar tab
#
#TC9 : [App Bar] DUT user to access Calls tab from more(...)option when Default view is set to Dial pad
#    [Tags]  310096   P2  alt_bug
#    [Setup]   Testcase Setup  count=1
#    ${prt_mode_flag}   is portrait mode cnf device  device=device_1
#    pass execution if   '${prt_mode_flag}' is False  device_1, device is not a portrait mode device
#    Select default view value     device=device_1   option=dialpad
#    Validate calls tab after default value change    device=device_1      default_option=dialpad
#    come back to home screen  device=device_1
#    Navigate to more option   device=device_1
#    Click reorder option  device=device_1
#    Validate drag and drop app from one section to other section  device=device_1    tab=Calls tab    destination=Voicemail tab
#    Validate home screen after reorder of apps  device=device_1   tab=Calls tab,Calendar tab,People tab,Voicemail tab
#    Navigate to more option   device=device_1
#    Navigate to calls tab  device=device_1
#    Come back to home screen    device_list=device_1
#    [Teardown]    Run Keywords    Capture on Failure   AND   App Bar Teardown  device=device_1   tab=Calls tab   destination=Calendar tab
#
#TC10 : [App Bar] DUT user should have minimum of two Apps to be in main screen
#    [Tags]  310065   bvt    bvt_pr      23_bvt  alt_bug
#    [Setup]   Testcase Setup  count=1
#    Navigate to more option   device=device_1
#    Click reorder option  device=device_1
#    Validate drag and drop app from one section to other section  device=device_1    tab=Calls tab    destination=Voicemail tab
#    Validate home screen after reorder of apps  device=device_1   tab=Calls tab,Calendar tab,People tab,Voicemail tab
#    Come back to home screen    device_list=device_1
#    [Teardown]    Run Keywords    Capture on Failure   AND   App Bar Teardown  device=device_1   tab=Calls tab   destination=Calendar tab
#
#TC11 : [App Bar] DUT user should be able to access more (...) option while in a meeting/conference call
#    [Tags]  310250   P2  alt_bug
#    [Setup]   Testcase Setup  count=2
#    Create meeting   device=device_2    meeting=Outlook_meeting     participants=device_1
#    Wait for Some Time    time=${wait_time}
#    Join meeting    device=device_1,device_2     meeting=Outlook_meeting
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Navigate away from meeting roaster and tap on more option  device=device_1
#    Disconnect call   device=device_1,device_2
#    Verify meeting state   device_list=device_1,device_2    state=Disconnected
#    Come back to home screen    device_list=device_1,device_2
#    [Teardown]    Run Keywords    Capture on Failure   AND   Test Case Teardown  devices=device_2    meeting=Outlook_meeting   count=2
#
#TC12 : [App Bar] DUT user should have maximum of four Apps in main screen
#    [Tags]   310068    P1  alt_bug
#    [Setup]  Testcase Setup   count=1
#    Navigate to more option   device=device_1
#    Click reorder option  device=device_1
#    Validate drag and drop app from one section to other section  device=device_1    tab=Voicemail tab    destination=Calls tab
#    Validate home screen after reorder of apps  device=device_1   tab=Calls tab,Calendar tab,People tab,Voicemail tab
#    Come back to home screen    device_list=device_1
#    [Teardown]    Run Keywords    Capture on Failure    AND   Come back to home screen    device_list=device_1
#
## These cases aren't applicable for personal phones
#
##TC13 : [App Bar] Meeting Sign-in policy assigned users should have the option to edit App bar
##    [Tags]  310087   P2  alt_blocked
##    [Setup]   Testcase Setup for Meeting User   count=2
##    Create meeting   device=device_2    meeting=Outlook_meeting     participants=device_1
##    Navigate to calendar tab  device=device_1
##    View scheduled meeting entries   device=device_1
##    Validate reorder of apps    device=device_1    tab=People tab   destination=Calendar tab
##    Validate home screen after reorder of apps  device=device_1   tab=Calendar tab,People tab
##    Come back to home screen  device_list=device_1
##    [Teardown]    Run Keywords    Capture on Failure   AND   Device Setting Teardown   device=device_1
#
##TC14 : [App Bar] Meeting account should have only Calendar and people tab by default on the main screen
##    [Tags]  310202    P1    bvt
##    [Setup]  Testcase Setup for Meeting User   count=1
##    Navigate to calendar tab  device=device_1
##    Validate home screen after reorder of apps  device=device_1   tab=Calendar tab,People tab
##    Come back to home screen  device_list=device_1
##    [Teardown]  Run Keywords    Capture on Failure    AND   Device Setting Teardown   device=device_1
#
#TC15 : [App Bar] Tapping on More options(…) should show all the hidden Apps available on DUT and edit and save/back instead of save
#    [Tags]  310051
#    [Setup]  Testcase Setup   count=1
#    Navigate to more option   device=device_1
#    Click reorder option  device=device_1
#    Validate drag and drop app from one section to other section  device=device_1    tab=Calls tab    destination=Voicemail tab
#    Validate home screen after reorder of apps  device=device_1   tab=Calendar tab,People tab
#    verify apps under more option    device=device_1    tab=calls,voicemail
#    Come back to home screen    device_list=device_1
#    [Teardown]    Run Keywords    Capture on Failure   AND   App Bar Teardown  device=device_1   tab=Calls tab   destination=Calendar tab
#
#TC16 : [App Bar] DUT to access People App from more options by default in App bar
#    [Tags]  310059      P2
#    [Setup]  Testcase Setup    count=2
#    navigate to people tab      device=device_1
#    Add from directory   from_device=device_1    to_device=device_2     group_name=Favorites
#    Create new group    device=device_1   group_name=no_user_group
#    Select created group from drop down     device=device_1     group_name=no_user_group
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    Remove user from group   from_device=device_1    to_device=device_2     group_names=Favorites    AND     Delete group    device=device_1   group_name=no_user_group
#
#TC17 : [App Bar] Pill count should remove from more option in Footer after user read UnreadVoicemail , Voicemail tab is hidden
#    [Tags]  319228      P2
#    [Setup]  Testcase Setup    count=2
#    navigate to voicemail tab   device=device_1
#    delete all voicemails   device=device_1
#    send voicemail      from_device=device_2    to_device=device_1
#    refresh main tab    device=device_1
#    verify missed voicemail pill in app bar     device=device_1     status=appear
#    navigate to voicemail tab   device=device_1
#    play voicemail        device=device_1
#    verify missed voicemail pill in app bar     device=device_1     status=disappear
#    [Teardown]  Run Keywords    Capture on Failure  AND    voicemail teardown
#
#This feature is not avaialable  
# TC 19: [Expose CP errors during sign-in]DUT user to verify the error message in sign in page, due to workplace join (WPJ) failure.
#     [Tags]      346132        P2    auth_audio
#     [Setup]  Testcase Setup for ZTP    count=1
#     verify signin with license is not supported account used for signin phones       device=device_1:cap_limit_reached_account
#     [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

#
#*** Keywords ***
#Voicemail Teardown
#    Verify and disable call forwarding    device=device_1
#    Come back to home screen  device_list=device_1,device_2
#
#Test Case Teardown
#    [Arguments]     ${devices}      ${meeting}   ${count}
#    Delete meeting      ${devices}    ${meeting}
#    remove_meeting_from_calender_for_user   ${count}
#
#Device Setting Teardown
#    [Arguments]     ${device}
#    Sign out method     ${device}
#
#
#Send Voicemail
#    [Arguments]     ${from_device}   ${to_device}
#    Set Call Forwarding    device=device_1
#    Come back to home screen  device_list=device_2
#    Make outgoing call using display name    ${from_device}      ${to_device}
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=${from_device}   state=Connected
#    Disconnect call     ${from_device}
#    Verify Call State    device_list=${from_device}     state=Disconnected
#
#App Bar Teardown
#    [Arguments]     ${device}     ${tab}    ${destination}
#    Come back to home screen   device_list=device_1
#    Navigate to more option  device=device_1
#    Click reorder option   device=device_1
#    Validate drag and drop app from one section to other section   ${device}    ${tab}    ${destination}
#    Come back to home screen  device_list=device_1
#

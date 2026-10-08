#*** Settings ***
#Resource   ../resources/keywords/common.robot
#
#Suite Teardown    Suite Failure Capture
#
#*** Variables ***
#${wait_time} =  10
#
#*** Test Cases ***
#TC1: [App Bar] DUT user should have Calendar and People tabs by default along with more (...) option on the App bar
#    [Tags]   204886   P2
#    [Setup]  Testcase Setup for Meeting User   count=1
#    Check app bar feature    device=device_1    status=ON
#    Navigate to calendar tab  device=device_1
#    Validate home screen after reorder of apps  device=device_1   tab=Calendar tab,People tab
#    [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen  device_list=device_1
#
#TC2: [App bar] DUT user should be able to access more (...) option while in P2P call
#    [Tags]   205059    P2
#    [Setup]  Testcase Setup for Meeting User      count=2
#    Check app bar feature    device=device_1    status=ON
#    click on calls tab     device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1:meeting_user
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Click back btn   device=device_1
#    Verify apps under more option   device=device_1:meeting_user
#    Come back to home screen   device_list=device_1
#   [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2
#
#TC3 :[ App bar ] DUT user should be able to access more (...) option while in a meeting/ conference call
#    [Tags]   205061    P2
#    [Setup]  Testcase Setup for Meeting User      count=2
#    Check app bar feature    device=device_1    status=ON
#    create meeting  device=device_2       meeting=test_meeting        participants=device_1:meeting_user
#    Join Meeting    device=device_1,device_2             meeting=test_meeting        join_styles=conference,None
#    Wait for Some Time    time=${wait_time}
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Click back btn   device=device_1
#    Verify apps under more option   device=device_1:meeting_user
#    Come back to home screen   device_list=device_1
#    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2
#
#TC4: [App Bar] DUT user to access people app from more options by default in App bar
#     [Tags]  204939   P2
#     [Setup]  Testcase Setup for Meeting User      count=1
#     Check app bar feature    device=device_1    status=ON
#     Navigate to more option   device=device_1:meeting_user
#     verify people navigation  device=device_1
#     navigate to people tab   device=device_1
#     click drop down menu and verify list of groups   device=device_1
#     Come back to home screen    device_list=device_1
#    [Teardown]    Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1
#
#TC5: [App Bar] DUT user should have minimum of two Apps to be in main window
#     [Tags]  306123  bvt_tpc     sanity_tpc  P0
#     [Setup]  Testcase Setup for Meeting User      count=1
#     Check app bar feature    device=device_1    status=ON
#     Navigate to more option   device=device_1:meeting_user
#     Click reorder option  device=device_1
#     Validate drag and drop app from one section to other section  device=device_1    tab=People tab   destination=Calendar tab
#     validate reorder of apps  device=device_1      tab=People tab   destination=Calendar tab
#     Validate home screen after reorder of apps  device=device_1   tab=Calendar tab,People tab
#     Come back to home screen    device_list=device_1
#    [Teardown]    Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1
#
#TC6: [App Bar] Verify that Changes made in App bar should not disappear when same user sign-in again
#     [Tags]  319482    P2
#     [Setup]  Testcase Setup for Meeting User      count=1
#     Check app bar feature    device=device_1    status=ON
#     Navigate to more option   device=device_1:meeting_user
#     Click reorder option  device=device_1
#     Validate drag and drop app from one section to other section  device=device_1    tab=People tab   destination=Calendar tab
#     validate reorder of apps  device=device_1      tab=People tab   destination=Calendar tab
#     sign out method     device=device_1
#     Sign in method      device=device_1      user=meeting_user
#     validate reorder of apps  device=device_1      tab=People tab   destination=Calendar tab
#    [Teardown]    Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1
#
#TC7: [App Bar] Meeting policy user should only see Calendar and People tab , should not visible other apps i.e. Calls, Voicemail, walkie talkie, shifts…
#     [Tags]  319600     P2
#     [Setup]  Testcase Setup for Meeting User      count=1
#     Check app bar feature    device=device_1    status=ON
#     Navigate to calendar tab  device=device_1
#     Validate home screen after reorder of apps  device=device_1   tab=Calendar tab,People tab
#     Come back to home screen  device_list=device_1
#    [Teardown]    Run Keywords    Capture on Failure
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

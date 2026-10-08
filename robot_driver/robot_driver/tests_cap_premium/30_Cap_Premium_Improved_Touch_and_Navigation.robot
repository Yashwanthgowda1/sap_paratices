*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown      Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1: [Advance calling][Home Screen] Verify that Home button should present in Calls tab
    [Tags]    402414     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User   count=1
    verify home button in different tabs   device=device_1     tab=calls_tab
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1


TC2: [Advance calling][Home Screen]Verify that Home button should present in Voicemail tab
    [Tags]   402415       BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User   count=1
    verify home button in different tabs   device=device_1     tab=voice_mail
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3: [Advance calling][Home Screen]Verify that Home button should present in People tab
    [Tags]   402416        BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User   count=1
    verify home button in different tabs   device=device_1     tab=people_tab
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC4: [Advance calling][Home Screen]Verify that Home button should present in Walkie Talkie tab
    [Tags]     402417      BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User   count=1
    verify home button in different tabs   device=device_1     tab=walkie_talkie
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC5: [Advance calling][Calls] Verify Dial pad icon on Favorites tab
    [Tags]   402418     P2
    [Setup]  Testcase Setup for CAP Premium User   count=1
    verify dial pad in calls tab for cap    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC6 : [App bar] Verify App bar [Tab bar] is not present on launching any application
    [Tags]      402445     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User    count=1
    verify home button in different tabs   device=device_1     tab=calls_tab
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

TC7 : [Advanced Calling][Calls] Verify call+ icon on calls tab
    [Tags]     402450      BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User   count=1
    verify is landscape device     device=device_1
    verify call plus icon absence in landscape devices  device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1

TC8 : [Touch and Navigation] [Calls] Verify Dial pad as default calls view.
    [Tags]   402446    P2
    [Setup]   Testcase Setup for CAP Premium User    count=1
    Select default view value     device=device_1   option=dialpad
    Validate calls tab after default value change    device=device_1      default_option=dialpad
    [Teardown]    Run Keywords    Capture on Failure    AND   Come back to home screen    device_list=device_1   AND     Verify Default view relaunches after changing the value     device=device_1     option=speed dial

TC9 : [Touch and Navigation] [Calls] Verify Dial pad icon on Recent.
    [Tags]  402454    P1
    [Setup]   Testcase Setup for CAP Premium User   count=1
    Verify Default view relaunches after changing the value     device=device_1     option=recent call history
    navigate to calls tab   device=device_1
    Validate calls tab after default value change    device=device_1      default_option=recent call history
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1   AND     Verify Default view relaunches after changing the value     device=device_1     option=speed dial

TC10 : [Touch and Navigation] [Calls] Verify calls view options under calling.
    [Tags]   402458    P1
    [Setup]   Testcase Setup for CAP Premium User    count=1
    Verify call views option under callings settings     device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND   Come back to home screen    device_list=device_1

TC11 : [Touch and Navigation][Calls] Verify History icon on Dialpad, when default call's view is set to Dialpad.
    [Tags]    402448    BVT_CAPPremium     Sanity_CAPPremium    P0
    [Setup]   run keywords  Testcase Setup for CAP Premium User   count=2     AND  Make outgoing call for call log    from_device=device_1     to_device=device_2
    Select default view value   device=device_1     option=dialpad
    Validate calls tab after default value change    device=device_1      default_option=dialpad
    go back to previous page     device=device_1
    click on calls tab      device=device_1
    navigates to recent tab while default view as dailpad  device=device_1
    Call first participant from log    device=device_1
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Select default view value   device=device_1     option=speed dial       AND   Come back to home screen    device_list=device_1,device_2

TC12 : [Touch and Navigation][Calls] Verify DUT user can make outgoing call from recent tab or Favorites tab when default view is set as Recent call History.
    [Tags]    402457    P2
    [Setup]   run keywords  Testcase Setup for CAP Premium User   count=2     AND  Make outgoing call for call log    from_device=device_1     to_device=device_2
    Select default view value   device=device_1     option=recent call history
    Validate calls tab after default value change    device=device_1      default_option=recent call history
    go back to previous page     device=device_1
    click on calls tab      device=device_1
    Call first participant from log    device=device_1
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Select default view value   device=device_1     option=speed dial       AND   Come back to home screen    device_list=device_1,device_2

TC13 : [Touch and Navigation] Verify Date and time in notification bar on all the tabs.
    [Tags]    402467    P2
    [Setup]  Testcase Setup for CAP Premium User    count=1
    verify date and time in notification bar on all the tabs    device=device_1     user_type=cap_premium
    [Teardown]   Run Keywords    Capture on Failure       AND   Come back to home screen    device_list=device_1

TC14 : [Touch and Navigation][Calls] Verify DUT user able to do outgoing call from recent or Favorites when default view is set as speed dial.
    [Tags]   402460    P2
    [Setup]   run keywords  Testcase Setup for CAP Premium User   count=2     AND  Make outgoing call for call log    from_device=device_1     to_device=device_2
    Select default view value   device=device_1     option=speed dial
    Validate calls tab after default value change    device=device_1      default_option=speed dial
    go back to previous page     device=device_1
    navigate to calls tab    device=device_1
    Call first participant from log    device=device_1
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC15 : [Touch and Navigation] [Calls] Verify Fab icon should not overlap with the keyboard while user is in People tab.
    [Tags]   402459    P2
    [Setup]  Testcase Setup for CAP Premium User   count=1
    Select default view value   device=device_1     option=dialpad
    Validate calls tab after default value change    device=device_1      default_option=dialpad
    go back to previous page     device=device_1
    verify fab icon not present in people tab when calls views set to dial pad     device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1

*** Keywords ***
Advance calling Setup
    Verify and enable advance calling option       device=device_1

Make outgoing call for call log
    [Arguments]     ${from_device}   ${to_device}
    Make outgoing call using display name    from_device=${from_device}      to_device=${to_device}
    Verify Incoming call    device=${to_device}     status=appear
    Disconnect call     device=${from_device}
    Verify Incoming call    device=${to_device}     status=disappear
    Verify Call State    device_list=${from_device}     state=Disconnected
    Come back to home screen    device_list=${from_device}
    Navigate to calls tab   device=${from_device}
    Refresh calls main tab    device=${from_device}
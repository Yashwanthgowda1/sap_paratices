*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown      Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Sign-in][Intune]User should be able to sign-in code using Intune License Account.
      [Tags]   348222      BVT_CAPPremium     Sanity_CAPPremium
      [Setup]    Testcase Setup for CAP Premium User     count=1
      verify that sign in is successful   device_list=device_1     state=sign in
      [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1

TC2 :Verify that DUT user should be able to answer the call/meeting from "Privacy & Cookies" page under About in settings.
    [Tags]   348995    BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User   count=2
    verify options inside about page     device=device_1
    navigate to privacy and cookies from about page    device=device_1
    click on calls tab     device=device_2
    make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call      device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2     state=Connected
    Disconnect call    device=device_2
    navigate to home screen from about page  device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3 : Verify that DUT user should be able to access "Third party software notices and information" page under About in settings.
    [Tags]  348997     P1      Sanity_CAPPremium
    [Setup]   Testcase Setup for CAP Premium User   count=1
    verify third party software notices and information    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC4 : [Device Properties] Check firmware version .
    [Tags]  349104     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]   Testcase Setup for CAP Premium User   count=1
    check device firmware version    device=device_1
    [Teardown]  Run Keywords   Capture on Failure    AND    Come back to home screen    device_list=device_1

TC5 : Verify that DUT user should be able answer a call/meeting from "Third party software notices and information" page under About in settings.
    [Tags]  348998    P2
    [Setup]   Testcase Setup for CAP Premium User   count=2
    verify options inside about page     device=device_1
    navigate to third party software notices from about page    device=device_1
    click on calls tab     device=device_2
    make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call      device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2     state=Connected
    Disconnect call    device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    navigate to home screen from about page  device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC6 : Verify that DUT user should be able to answer the call/meetng from "Terms of Use" page under About in settings.
    [Tags]  348996    P2
    [Setup]  Testcase Setup for CAP Premium User   count=2
    verify options inside about page     device=device_1
    navigate to terms of use from about page  device=device_1
    click on calls tab     device=device_2
    make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call      device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2     state=Connected
    Disconnect call    device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    navigate to home screen from about page  device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC7 : Verify that DUT user should be able to accept the call/meeting in "What's new" page under the settings.
    [Tags]  348994     P2
    [Setup]  Testcase Setup for CAP Premium User   count=2
    navigate to whats new page from home screen   device=device_1
    click on calls tab     device=device_2
    make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call      device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2     state=Connected
    Disconnect call    device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC8 : verify that DUT user able to access "Terms of Use" page under About in settings.
    [Tags]  348991    P2
    [Setup]   Testcase Setup for CAP Premium User   count=1
    verify options inside about page     device=device_1
    navigate to terms of use from about page  device=device_1
    navigate to home screen from about page  device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC9 : Verify that DUT user able to access "Privacy & Cookies" page under About in settings.
    [Tags]   348990    P2
    [Setup]   Testcase Setup for CAP Premium User   count=1
    verify options inside about page     device=device_1
    navigate to privacy and cookies from about page    device=device_1
    navigate to home screen from about page  device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC10 : Verify that DUT should not have "Connected Experiences" option under About in settings.
    [Tags]   348992    P1
    [Setup]   Testcase Setup for CAP Premium User   count=1
    verify options inside about page     device=device_1
    verify connected experiences does not present in about page       device=device_1
    navigate to home screen from about page    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC11 : Verify that DUT user able to access "What's new" page under the settings.
    [Tags]  455474     Sanity_CAPPremium    P1
    [Setup]  Testcase Setup for CAP Premium User    count=1
    navigate to whats new page from home screen   device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC12 : [Phone Licensing][Homescreen]Calls,People & Voicemail Tab Should be present in Homescreen.
     [Tags]    455442     BVT_CAPPremium     Sanity_CAPPremium
     [Setup]    Testcase Setup for CAP Premium User    count=1
     verify home screen tiles       device=device_1      device_type=cap_home_screen_enabled
     [Teardown]   Run Keywords    Capture on Failure   AND  Come back to home screen    device_list=device_1

*** Keywords ***
Advance calling Setup
    Verify and enable advance calling option       device=device_1

Make outgoing call for call log
    [Arguments]     ${from_device}   ${to_device}
    click on calls tab     device=${from_device}
    Make outgoing call using display name    from_device=${from_device}      to_device=${to_device}
    Verify Incoming call    device=${to_device}     status=appear
    Disconnect call     device=${from_device}
    Verify Incoming call    device=${to_device}     status=disappear
    Verify Call State    device_list=${from_device}     state=Disconnected
    return to home screen  device_list=${from_device}
    click on calls tab   device=${from_device}
    Refresh calls main tab    device=${from_device}

verify third party software notices and information
    [Arguments]     ${device}
    verify third party software notices     ${device}
    scroll up secondary tab     ${device}
    click back  ${device}
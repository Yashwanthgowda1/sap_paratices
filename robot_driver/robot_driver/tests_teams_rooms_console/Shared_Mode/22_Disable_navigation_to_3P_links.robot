*** Settings ***
Documentation   Validating the functionality of console App settings feature.
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1:Verify that Touch console user able to access "What's new" page under the settings.
    [Tags]      344998   P0     bvt_tc_sm  sanity_tc_sm
    [Setup]  Testcase Setup for shared User    count=1
    Navigate to about page     console=console_1
    verify options inside about page console     device=console_1
    verify what is new under privacy and cookies    device=console_1
    navigate back to more option page    device=console_1
    [Teardown]  Run Keywords   Capture Failure     AND     Come back to home screen page   console_list=console_1

TC2:Verify that Touch console user able to access "Privacy & Cookies" page under About in settings.
    [Tags]      345009  P1      sanity_tc_sm
    [Setup]  Testcase Setup for shared User    count=1
    Navigate to about page     console=console_1
    verify options inside about page console   device=console_1
    verify what is new under privacy and cookies    device=console_1
    navigate back to more option page    device=console_1
    [Teardown]  Run Keywords   Capture Failure     AND     Come back to home screen page   console_list=console_1

TC3:Verify that Touch console user should not have "Connected Experiences" option under About in settings.
    [Tags]      345011      P1      sanity_tc_sm
    [Setup]  Testcase Setup for shared User    count=1
    Navigate to about page     console=console_1
    verify options inside about page console     device=console_1
    verify about page and connected experiences is not present in about page     device=console_1
    navigate back to more option page    device=console_1
    [Teardown]  Run Keywords   Capture Failure     AND     Come back to home screen page   console_list=console_1

TC4:Verify that Touch console user should be able to access "Third party software notices and information" page under About in settings.
    [Tags]    345015    P1    sanity_tc_sm
    [Setup]  Testcase Setup for shared User    count=1
    Navigate to about page     console=console_1
    verify third party software and information     device=console_1
    navigate back to more option page    device=console_1
    [Teardown]  Run Keywords   Capture Failure  AND     Come back to home screen page   console_list=console_1

TC5:Verify that Touch console user should be able to accept the call/meeting in "What's new" page under the settings.
    [Tags]    345012    P2
    [Setup]  Testcase Setup for shared User    count=2
    Navigate to about page     console=console_1
    verify options inside about page console   device=console_1
    verify what is new under privacy and cookies    device=console_1
    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
    Pick up incoming call    console=console_1
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Disconnect the call      console=console_1
    navigate back to more option page    device=console_1
    [Teardown]  Run Keywords   Capture Failure  AND     Come back to home screen page   console_list=console_1     device_list=device_2

TC6:Verify that Touch console user should be able to answer the call/meeting from "Privacy & Cookies" page under About in settings.
    [Tags]    345013    bvt_tc_sm    sanity_tc_sm
    [Setup]  Testcase Setup for shared User    count=2
    Navigate to about page     console=console_1
    verify options inside about page console   device=console_1
    verify what is new under privacy and cookies    device=console_1
    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
    Pick up incoming call    console=console_1
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Disconnect the call      console=console_1
    navigate back to more option page    device=console_1
    [Teardown]  Run Keywords   Capture Failure  AND     Come back to home screen page   console_list=console_1     device_list=device_2

TC7:Verify that Touch console user should be able answer a call/meeting from "Third party software notices and information" page under About in settings.
    [Tags]    345016    P2
    [Setup]  Testcase Setup for shared User    count=2
    Navigate to about page   console=console_1
    third party software and information in about page     device=console_1
    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
    Pick up incoming call    console=console_1
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Disconnect the call      console=console_1
    navigate back to more option page    device=console_1
    [Teardown]  Run Keywords   Capture Failure  AND      Come back to home screen page   console_list=console_1     device_list=device_2

TC8:Verify that Touch console user able to access "Terms of Use" page under About in settings.
    [Tags]    345010    bvt_tc_sm    sanity_tc_sm
    [Setup]  Testcase Setup for shared User    count=1
    Navigate to about page     console=console_1
    verify terms of use option   device=console_1
    verify that unable to open external links in terms of use  device=console_1
    navigate back to more option page    device=console_1
    [Teardown]  Run Keywords   Capture Failure  AND     Come back to home screen page   console_list=console_1

TC9:Verify that Touch console user should be able to answer the call/meeting from "Terms of Use" page under About in settings.
    [Tags]    345014    P2
    [Setup]  Testcase Setup for shared User    count=2
    Navigate to about page     console=console_1
    verify terms of use option   device=console_1
    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
    Pick up incoming call    console=console_1
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Disconnect the call      console=console_1
    navigate back to more option page    device=console_1
    [Teardown]  Run Keywords   Capture Failure  AND      Come back to home screen page   console_list=console_1     device_list=device_2

TC10:Verify that DUT user able to access "Privacy & Cookies" page under About in settings.
    [Tags]    344999    P2
    [Setup]  Testcase Setup for shared User    count=1
    Navigate to about page     console=console_1
    verify options inside about page console   device=console_1
    verify what is new under privacy and cookies    device=console_1
    verify that unable to open external links privacy cookies       device=console_1
    navigate back to more option page    device=console_1
    [Teardown]  Run Keywords   Capture Failure     AND     Come back to home screen page   console_list=console_1

*** Keywords ***
Navigate to about page
    [Arguments]     ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}
    click on about page  device=${console}



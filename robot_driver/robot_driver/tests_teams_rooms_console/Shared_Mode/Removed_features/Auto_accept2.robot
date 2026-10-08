#*** Settings ***
#Documentation   Validating the functionality of console App settings feature.
#Force Tags    sm_app_settings   sm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#*** Variables ***
#${wait_time} =  15
#${wait_time1}=  5
#
#*** Test Cases ***
#TC1: [Auto accept] Auto accept settings should be shown only for meeting room accounts and video device
#    [Tags]  315513      sanity_sm   P1
#    [Setup]  Testcase Setup for shared User     count=1
#    Navigate to app settings screen page    console=console_1
#    Navigate to meeting and calling options from device settings page       console=console_1   option=calling
#    verify meeting and video automatically options   device=console_1
#    Navigate back to settings screen    console=console_1
#    [Teardown]  Run Keywords   Capture Failure  AND    Click on back layout btn   console=console_1     AND     Come back to home screen page   console_list=console_1
#
#TC2:[Auto accept] Touch Console user accepts the call with auto accept disabled
#     [Tags]  315521     P2
#    [Setup]  Testcase Setup for shared User     count=2
#    Navigate to app settings screen page    console=console_1
#    Navigate to meeting and calling options from device settings page       console=console_1   option=calling
#    accept meeting invites automatically    device=console_1      state=off
#    start my video automatically        device=console_1      state=off
#    Navigate back to settings screen    console=console_1
#    Click on back layout btn   console=console_1
#    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
#    verify auto accept timer is not present    device=device_1
#    Pick up incoming call    console=console_1
#    Wait for Some Time    time=${wait_time}
#    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
#    Disconnect the call      console=console_1
#    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
#    [Teardown]  Run Keywords   Capture Failure  AND       Come back to home screen page   console_list=console_1
#
#TC3:[Auto Accept] Admin disable the auto accept option for the account
#    [Tags]      322863   P2
#    [Setup]  Testcase Setup for shared User     count=2
#    Navigate to app settings screen page    console=console_1
#    Navigate to meeting and calling options from device settings page       console=console_1   option=calling
#    accept meeting invites automatically   device=console_1      state=off
#    start my video automatically       device=console_1      state=off
#    Navigate back to settings screen    console=console_1
#    Click on back layout btn   console=console_1
#    Start meeting using meet now   from_device=device_2    to_device=console_1:meeting_user
#    Close participants screen   device=device_2
#    verify auto accept timer is not present     device=console_1
#    Pick up incoming call    console=console_1
#    Verify for call state     console_list=console_1    device_list=device_2   state=Connected
#    End a meeting     console=console_1       device=device_2
#    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2
#
#*** Keywords ***
#Navigate to app settings screen page
#    [Arguments]     ${console}
#    Tap on more option  ${console}
#    Tap on settings page   ${console}
#
#Navigate back to settings screen
#    [Arguments]     ${console}
#    Tap on device right corner  ${console}
#    Click back btn   ${console}
#    device setting back btn     ${console}
#    Click on close button    console_list=${console}
#
#End a meeting
#    [Arguments]    ${console}    ${device}
#    End the meeting  ${console}
#    End meeting      ${device}

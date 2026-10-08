#*** Settings ***
#Force Tags    sm_pstn       sm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#*** Variables ***
#${wait_time} =  10
#${3swait_time} =  3
#${60s_wait_time} =  60
#
#*** Test Cases ***
# auto dial is not supported bug_3445550
#T2: [Outgoing Call] User auto-dial to TDC call number from home screen dialpad
#    [Tags]      315006  P1  sanity_sm
#    [Setup]    Testcase Setup for shared User  count=2
#    Make outgoing call using auto dial from dial pad    from_device=console_1     to_device=device_2
#    Accept incoming call      device=device_2
#    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2
#
# auto dial is not supported bug_3445550
#TC3: [Outgoing Call] Touch Console user auto dials incorrect number
#    [Tags]      315002  P1      sanity_sm
#    [Setup]  Testcase Setup for shared User  count=1
#    Auto dial incorrect number from dial pad    device=console_1
#    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1
#
#TC3: [Outgoing Call]User calls to PSTN user from home screen dialpad
#    [Tags]  314992   bvt_sm     sanity_sm
#    [Setup]    Testcase Shared Mode PSTN Setup Main     count=2
#    Make outgoing call using dial pad   from_device=console_1     to_device=device_2:pstn_user
#    Accept incoming call      device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2
#
# auto dial is not supported bug_3445550
#TC4: [Outgoing Call] User auto dials to PSTN user from home screen dialpad
#    [Tags]      314994   bvt_sm     sanity_sm
#    [Setup]    Testcase Shared Mode PSTN Setup Main    count=2
#    Make outgoing call using auto dial from dial pad    from_device=console_1     to_device=device_2:pstn_user
#    Accept incoming call      device=device_2
#    Wait for Some Time    time=${wait_time}
#    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2
#
#TC15:[Auto accept for Meet Now] Verify that Auto accept option is disabled for PSTN calls
#    [Tags]      322844     P1       sanity_sm
#    [Setup]   Testcase Shared Mode PSTN Setup Main    count=2
#    Navigate to app settings screen page    console=console_1
#    Navigate to meeting and calling options from device settings page       console=console_1   option=calling
#    accept meeting invites automatically    device=console_1      state=on
#    start my video automatically        device=console_1      state=on
#    Navigate back to settings screen    console=console_1
#    Click on back layout btn   console=console_1
#    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
#    verify auto accept timer is not present    device=console_1
#    Wait for Some Time     time=${3s_wait_time}
#    Pick up incoming call    console=console_1
#    Verify for call state    console_list=console_1    device_list=device_2    state=Connected
#    Disconnect the call      console=console_1
#    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2     AND     Disabling the auto accept meeting invite and start my video automatically   console=console_1   state=off
#
#This feature is not avaialable 
# TC18:DUT user to verify the pop up displayed, when user signs in with CAP limit reached account.
#     [Tags]      344994        P2
#     [Setup]   Testcase Setup for shared User      count=1
#     Verify signin is successful   console_list=console_1     state=Sign in
#     Console sign out method   console=console_1
#     Verify signin is successful    console_list=console_1     state=Sign out
#     verify signin with license is not supported account used for signin phones       device=console_1:cap_limit_reached_account
#     [Teardown]  Run Keywords   Capture Failure   AND    console sign in method    console=console_1       user=meeting_user   AND   Get device pairing code    device_list=device_1    console_list=console_1   user_list=meeting_user

#*** Keywords ***
#Hang up call
#    [Arguments]    ${console}    ${device}
#    Disconnect the call    console=${console}
#    Disconnect call     device=${device}
#
#End a meeting
#    [Arguments]    ${console}    ${device}
#    Disconnect the call  ${console}
#    Disconnect call     ${device}
#
#verify dial pad in more option
#    [Arguments]     ${console}
#     Verify available options in more    ${console}
#     Click on back layout btn       ${console}
#
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
#Disabling the auto accept meeting invite and start my video automatically
#    [Arguments]     ${console}      ${state}
#    Navigate to app settings screen page    ${console}
#    Navigate to meeting and calling options from device settings page       ${console}   option=calling
#    accept meeting invites automatically   device=${console}      state=off
#    start my video automatically       device=${console}      state=off
#    Navigate back to settings screen    ${console}
#    Click on back layout btn   ${console}

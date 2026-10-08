*** Settings ***
Documentation  Validating the functionality of Console Incoming Calls
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1:[Incoming Call] Audio call to DUT
    [Tags]    444725    bvt_tc_sm     sanity_tc_sm
    [Setup]   Testcase Setup for shared User   count=2
    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
    Pick up incoming call    console=console_1
    Wait for Some Time    time=${wait_time}
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Disconnect the call      console=console_1
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure   AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC2:[Incoming Call] Video call to DUT
    [Tags]    444724    bvt_tc_sm    sanity_tc_sm
    [Setup]    Testcase Setup for shared User   count=2
    Place a video call using display name   from_device=device_2     to_device=console_1:meeting_user
    Pick up incoming call    console=console_1
    Close participants screen   device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Mute the call      console=console_1
    Verify and check call mute state      console_list=console_1    state=Mute
    Unmute the call    console=console_1
    Verify and check call mute state     console_list=console_1    state=Unmute
    Verify functionality of volume button    console=console_1   button=UP     state=In_meeting
    Verify functionality of volume button    console=console_1   button=Down   state=In_meeting
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Turn off incoming video call   console=console_1
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    End a meeting      console=console_1    device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC3:[Incoming Call] DUT does not answer the incoming call.
    [Tags]    444727    P1    sanity_tc_sm
    [Setup]    Testcase Setup for shared User   count=2
    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
    Disconnect the call      console=console_1    
    Verify for call state    console_list=console_1        state=Disconnected
    Come back to home screen page   console_list=console_1
    Verify home page screen   device=console_1
    Place a video call using display name   from_device=device_2     to_device=console_1:meeting_user
    Disconnect the call      console=console_1
    Close participants screen   device=device_2
    Disconnect call     device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    Come back to home screen page   console_list=console_1
    Verify home page screen   device=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC4:[Second incoming call] DUT should not get second incoming call
    [Tags]    315019    bvt_tc_sm    sanity_tc_sm
    [Setup]    Testcase Setup for shared User   count=3
    Place a video call using display name   from_device=device_2     to_device=console_1:meeting_user
    Pick up incoming call    console=console_1
    Close participants screen   device=device_2
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Place an outgoing call using dial pad    from_device=device_3     to_device=console_1:meeting_user
    Verify user not to get second incoming call     console=console_1
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    End a meeting      console=console_1    device=device_2
    Verify for call state    console_list=console_1    device_list=device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC5:[Incoming Call] Touch console user must be able to pick the incoming call on "Admin Only (Enter Password)"
    [Tags]    444729    P1    sanity_tc_sm
    [Setup]    Testcase Setup for shared User   count=2
    Navigate to more button and settings page    console=console_1
    Navigate to admin only enter password page      console=console_1
    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
    Pick up incoming call    console=console_1
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    Disconnect the call      console=console_1
    Verify for call state     console_list=console_1    device_list=device_2    state=Disconnected
    Navigate to more button and settings page    console=console_1
    Navigate to admin only enter password page      console=console_1
    Place a video call using display name   from_device=device_2     to_device=console_1:meeting_user
    Pick up incoming call    console=console_1
    Verify for call state     console_list=console_1    device_list=device_2    state=Connected
    End a meeting      console=console_1    device=device_2
    Come back to landing page   console=console_1
    [Teardown]   Run Keywords    Capture Failure  AND    Verify for call state     console_list=console_1    device_list=device_2    state=Disconnected    AND  Come back to home screen page   console_list=console_1   device_list=device_2

TC6: [Incoming Call] Touch Console declines the incoming call
    [Tags]    444726      P2
    [Setup]    Testcase Setup for shared User   count=2
    Place an outgoing call using dial pad    from_device=device_2     to_device=console_1:meeting_user
    Disconnect the call      console=console_1
    Verify for call state    console_list=console_1     state=Disconnected
    Verify Call State    device_list=device_2    state=Disconnected
    Place a video call using display name   from_device=device_2     to_device=console_1:meeting_user
    Disconnect the call      console=console_1
    Close participants screen   device=device_2
    Disconnect call     device=device_2
    Verify for call state      console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

*** Keywords ***
End a meeting
    [Arguments]    ${console}    ${device}
    Disconnect the call  ${console}
    Disconnect call     ${device}

Navigate to more button and settings page
    [Arguments]     ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Come back to landing page
    [Arguments]     ${console}
    Click on close button    console_list=${console}
    Click on back layout btn   ${console}

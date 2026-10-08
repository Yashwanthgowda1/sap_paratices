*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot
*** Test Cases ***
TC1:[Initiate Spotlight] Verify that start spotlight is available
    [Tags]  379737      bvt_tc_sm  sanity_tc_sm      P0
    [Setup]  Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    verify spotlight option        from_device=console_1   to_device=device_2    device_type=console    action_type=verify
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC2:[Initiate Spotlight] Verify that spotlighted participant is spotlighted locally
    [Tags]  379739      sanity_tc_sm   P1
    [Setup]  Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify video preview on screen  device=device_1
    Make a spotlight   from_device=console_1    to_device=device_2      device_type=console
    verify spotlight text on device   device=device_2     text=spotlight
    verify spotlight icon on main screen in the meeting  device=device_1
    verify spotlight icon  device=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC3:[Initiate Spotlight] Verify participant is spotlighted
    [Tags]  379715      P2
    [Setup]  Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify video preview on screen  device=device_1
    Make a spotlight   from_device=console_1    to_device=device_2      device_type=console
    verify spotlight text on device   device=device_2     text=spotlight
    verify spotlight icon on main screen in the meeting  device=device_1
    verify spotlight icon  device=device_2
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC4:[Initiate Spotlight] Verify initiate spotlight option is available in console.
    [Tags]  379714      P2
    [Setup]  Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    verify spotlight option        from_device=console_1   to_device=device_2    device_type=console    action_type=verify
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC5:[Initiate Spotlight] Verify that spotlighted participant is spotlighted to remote participants
    [Tags]  379740      bvt_tc_sm  sanity_tc_sm
    [Setup]  Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify video preview on screen  device=device_1
    Make a spotlight   from_device=console_1    to_device=device_2      device_type=console
    verify spotlight text on device   device=device_2     text=spotlight
    verify spotlight icon on main screen in the meeting  device=device_1
    verify spotlight icon  device=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC6:[Initiate Spotlight] Verify stop spotlight is available in roster
    [Tags]  379742      P2
    [Setup]  Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify video preview on screen  device=device_1
    Make a spotlight   from_device=console_1    to_device=device_2      device_type=console
    verify spotlight text on device   device=device_2     text=spotlight
    verify spotlight icon on main screen in the meeting  device=device_1
    verify spotlight icon  device=console_1
    verify stop spotlight with pop up message    from_device=console_1   to_device=device_2    device_type=console     action_type=verify
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC7:[Initiate Spotlight] Verify spotlighted participant after rejoining call
    [Tags]  379741      P2
    [Setup]  Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify video preview on screen  device=device_1
    Make a spotlight   from_device=console_1    to_device=device_2      device_type=console
    verify spotlight text on device   device=device_2     text=spotlight
    verify spotlight icon on main screen in the meeting  device=device_1
    verify spotlight icon  device=console_1
    End the meeting     console=console_1
    Join a meeting   console=console_1         meeting=console_lock_meeting
    verify spotlight icon on main screen in the meeting  device=device_1
    verify spotlight icon  device=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC8:[Initiate Spotlight] Verify stop spotlight locally and remotely.
    [Tags]    379744    P1    sanity_tc_sm
    [Setup]  Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify video preview on screen  device=device_1
    Make a spotlight   from_device=console_1    to_device=device_2      device_type=console
    verify spotlight text on device   device=device_2     text=spotlight
    verify spotlight icon on main screen in the meeting    device=device_1
    verify spotlight icon  device=console_1
    remove spotlight from other user    from_device=console_1   to_device=device_2    device_type=console
    verify spotlight text on device   device=device_2     text=no_spotlight
    verify spotlight icon disable      device=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC9:[Initiate Spotlight] Verify participant is able to stop spotlight.
    [Tags]  379716      P2
    [Setup]  Testcase Setup for shared User     count=2
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify video preview on screen  device=device_1
    make a spotlight   from_device=device_2   to_device=console_1:meeting_user       device_type=console
    verify spotlight text on device   device=console_1   text=spotlight
    Close participants screen   device=device_2
    Verifying and removing spotlight    device=console_1:meeting_user
    verify spotlight text on device   device=console_1     text=no_spotlight
    Verify spotlight icon disable       device=console_1
    End a meeting     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC10:[Initiate Spotlight] Verify initiate Add spotlight option is available in console.
    [Tags]      379719      P2
    [Setup]  Testcase Setup for shared User     count=3
    Join a meeting   console=console_1     device=device_2,device_3    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify video preview on screen  device=device_1
    Make a spotlight   from_device=console_1    to_device=device_2      device_type=console
    verify spotlight text on device   device=device_2     text=spotlight
    verify spotlight icon on main screen in the meeting  device=device_1
    verify spotlight icon  device=console_1
    Make a spotlight   from_device=console_1    to_device=device_3      device_type=console
    verify spotlight text on dut when more than one spotlighted  from_device=console_1     first_person=device_2    count=1
    End a meeting     console=console_1       device=device_2,device_3
    Verify for call state    console_list=console_1    device_list=device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

TC11:[Initiate Spotlight] Check spotlight option while user is in connecting page.
    [Tags]      382116      P2
    [Setup]  Testcase Setup for shared User     count=3
    Join a meeting   console=console_1     device=device_2    meeting=console_lock_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Verify video preview on screen  device=device_1
    Add participant to the conversation using display name  from_device=console_1    to_device=device_3
    Make a spotlight   from_device=console_1    to_device=device_3      device_type=console    joined_participant=no
    End a meeting     console=console_1       device=device_2
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2,device_3

*** Keywords ***
End a meeting
    [Arguments]    ${console}    ${device}
    End the meeting  ${console}
    End meeting      ${device}

verify spotlight option
    [Arguments]    ${from_device}    ${to_device}    ${device_type}     ${action_type}
    Make a spotlight   ${from_device}    ${to_device}    ${device_type}     ${action_type}

verify stop spotlight with pop up message
    [Arguments]    ${from_device}    ${to_device}    ${device_type}     ${action_type}
    remove spotlight from other user    ${from_device}    ${to_device}    ${device_type}     ${action_type}

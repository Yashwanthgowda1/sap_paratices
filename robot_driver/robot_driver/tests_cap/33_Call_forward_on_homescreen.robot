*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Setup      Display call forward on home screen setup
Suite Teardown  Run Keywords        Suite Failure Capture       AND     verify and set call forwarding on home screen     device=device_1         option=off

*** Variables ***


*** Test Cases ***
TC1: [Call forward on home screen] Verify the DUT user should receive the Incoming call from TDC, When Don't forward calls option is selected from Call forwarding icon on home screen
    [Tags]  452199  bvt_cap   sanity_cap    phonesCY23_4
    [Setup]  Testcase Setup for CAP User    count=2
    verify and set call forwarding on home screen      device=device_1         option=off
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2

TC2: [Call forward on home screen] Verify the options present inside the Call forwarding icon on Home screen
    [Tags]  452193    sanity_cap    phonesCY23_4
    [Setup]  Testcase Setup for CAP User    count=1
    verify display home screen toggle status under calling        device=device_1:cap_search_enabled      status=on
    Come back to home screen    device_list=device_1
    verify call forwarding option in call forward icon      device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1

TC3: [Call forward on home screen] Verify DUT should retain, Display on Home screen is in enabled state when we re-sign in with the same account.
    [Tags]  452219    sanity_cap    phonesCY23_4
    [Setup]  Testcase Setup for CAP User    count=1
    verify display home screen toggle status under calling        device=device_1:cap_search_enabled      status=on
    Come back to home screen    device_list=device_1
    Sign out method    device=device_1
    sign in method     device=device_1    user=cap_search_enabled
    verify display home screen toggle status under calling        device=device_1:cap_search_enabled      status=on
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1

TC4: [Call forward on home screen]Verify DUT should display most recent forwarding setting to be fetched once we login.
    [Tags]  452475    bvt_cap   sanity_cap      phonesCY23_4
    [Setup]  Testcase Setup for CAP User    count=1
    Sign out method    device=device_1
    sign in method     device=device_1    user=cap_search_enabled
    verify display home screen toggle status under calling        device=device_1:cap_search_enabled      status=on
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1

TC5:[Call forward on home screen]Verify DUT after adding contact or number from TDC /DUT.
    [Tags]          452480    P0       bvt_cap   sanity_cap      phonesCY23_4
    [Setup]  Testcase Setup for CAP User    count=3
    verify and set call forwarding on home screen     device=device_1         option=contact_or_number        to_device=device_2
    click on calls tab     device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1:cap_search_enabled
    Verify incoming call    device=device_2     status=appear
    Verify incoming call    device=device_1     status=disappear
    Pick incoming call   device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND        dismiss call forwarding pop up on home screen       device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3      AND   verify and set call forwarding on home screen     device=device_1         option=off

TC6 : [Call forward on home screen] Verify that DUT user is able to add the New contact or number from call forwarding icon present on home screen.
    [Tags]      452430      P1     sanity_cap    phonesCY23_4
    [Setup]      Testcase Setup for CAP User    count=3
    verify call forwarding option in call forward icon    device=device_1
    verify and set call forwarding on home screen     device=device_1         option=contact_or_number        to_device=device_2
    verify and change the contact on forward to contact or number on home screen    device=device_1    contact_device=device_3
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_3
    Verify Incoming call    device=device_1     status=disappear
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure      AND        dismiss call forwarding pop up on home screen       device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3       AND     verify and set call forwarding on home screen     device=device_1         option=off

*** Keywords ***
Display call forward on home screen setup
    verify and change toggle status for call forwarding display on home screen    device=device_1:cap_search_enabled      status=on

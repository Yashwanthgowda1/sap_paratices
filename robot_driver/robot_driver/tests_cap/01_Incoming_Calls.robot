*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown     Suite Failure Capture

*** Variables ***
${wait_time} =  10
${3wait_time} =     3 minutes

*** Test Cases ***
TC1 : [Incoming Calls] DUT user rejects the incoming call from teams client user
    [Tags]  148687   P1  sanity_cap        Certification_cap
    [Setup]  Testcase Setup for CAP User    count=2
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Rejects the incoming call   device_list=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : [Incoming Calls] DUT user to answer second incoming call
    [Tags]  149060    P1    bvt_cap  sanity_cap        Certification_cap
    [Setup]  Testcase Setup for CAP User    count=3
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    click on calls tab     device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1:cap_search_enabled
    Verify call notification    device=device_2     status=appear
    Pick incoming call from call notification    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2     state=Hold
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3 : [Incoming Calls] DUT user receives call from Teams client using DID
    [Tags]   148684     P2  bvt_cap  sanity_cap
    [Setup]   Testcase Setup for CAP User    count=2
    click on calls tab     device=device_2
    Make outgoing call using phonenumber   from_device=device_2     to_device=device_1:cap_search_enabled
    Verify display name on call toast   to_device=device_1    from_device=device_2
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2

TC4 : [Incoming Calls] DUT user receives the forwarded call from teams client
    [Tags]  148685      P2      bvt_cap  sanity_cap
    [Setup]  run keywords  Testcase Setup for CAP User    count=3    AND  Enable call forwarding and add contact     from_device=device_2    contact_device=device_1:cap_search_enabled
    click on calls tab     device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_2
    Verify display name on call toast   to_device=device_1    from_device=device_3
    Verify forward by call text     device=device_1    from_device=device_2
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     disable call forwarding and verify    device=device_2    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC5 : [Incoming Calls] Teams client user hangs up the call before DUT user picks up
    [Tags]   148686     P2
    [Setup]   Testcase Setup for CAP User    count=2
    click on calls tab     device=device_2
    Make outgoing call using display name   from_device=device_2     to_device=device_1:cap_search_enabled
    Verify display name on call toast   to_device=device_1    from_device=device_2
    Disconnect call     device=device_2
    Verify UI return to home screen   device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2

TC6 : [Incoming Calls] DUT user to receive the call when UI view is in Device settings
    [Tags]  314140   P1     sanity_cap        Certification_cap
    [Setup]   Testcase Setup for CAP User    count=2
    Opens partner settings page     device=device_1
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    [Teardown]   Run Keywords    Capture on Failure   AND    device setting back    device=device_1   AND   Come back to home screen    device_list=device_1,device_2    AND    Verify Call State    device_list=device_1,device_2     state=Disconnected

TC7 : [Incoming Calls] DUT user receives call from TDC
    [Tags]   317938      P2        Certification_cap    sanity_cap
    [Setup]  Testcase Setup for CAP User    count=2
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify name of caller and receiver displayed    from_device=device_2      to_device=device_1:cap_search_enabled
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC8 : [Incoming Call] DUT user must be able to pick the incoming call on "Admin Only (Enter Password)"
    [Tags]  320262      P2
    [Setup]   Testcase Setup for CAP User   count=2
    open settings page      device=device_1
    verify signout option should be in device settings     device_list=device_1
    click on calls tab     device=device_2
    Make outgoing call using display name  from_device=device_2    to_device=device_1:cap_search_enabled
    pick incoming call   device=device_1
    disconnect call   device=device_1
    Verify Call State   device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords   Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC9 : [Incoming Calls] DUT user to reject the call when UI view is in Device settings
    [Tags]  341834    P2
    [Setup]   Testcase Setup for CAP User    count=2
    Opens partner settings page     device=device_1
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    reject incoming call     device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND    device setting back    device=device_1   AND   Come back to home screen    device_list=device_1,device_2

TC10 : [Calls] Verify DUT user able to navigate the Device Settings page and stay there 2-3 minutes while on a P2P Call.
    [Tags]   402706    P1     sanity_cap
    [Setup]   Testcase Setup for CAP User    count=2
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Navigate to device setting page     device=device_1
    Wait for Some Time    time=${3wait_time}
    Verify Call State    device_list=device_2    state=Connected
    disconnect call   device=device_2
    Verify Call State   device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND    device setting back    device=device_1   AND   Come back to home screen    device_list=device_1,device_2

*** Keywords ***

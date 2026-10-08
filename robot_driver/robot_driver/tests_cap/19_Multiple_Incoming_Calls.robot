*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot
Resource    ../resources/keywords/call_keywords.robot

Suite Teardown    Suite Failure Capture

*** Variables ***

*** Test Cases ***
TC1 : [multiple calls] DUT user is on home screen, receives multiple calls and accept full screen call and ignore notification
      [Tags]  149941  P2     sanity_cap
      [Setup]   Testcase Setup for CAP User     count=3
      Navigate to calls tab   device=device_2,device_3
      initiate simultaneous call  devices=device_2,device_3   target_device=device_1:cap_search_enabled    method=display_name
      verify multiple incoming calls  device=device_1
      accept multiple incoming calls  device=device_1   full_screen_call=accept     notification_call=reject
      Disconnect call   device=device_1
      Verify Call State    device_list=device_1,device_2,device_3    state=DisConnected
      [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3

TC2 : [multiple calls] DUT user is on home screen, receives multiple calls and accept from notification
      [Tags]  149942  P2
      [Setup]   Testcase Setup for CAP User     count=3
      Navigate to calls tab   device=device_2,device_3
      initiate simultaneous call  devices=device_2,device_3   target_device=device_1:cap_search_enabled    method=display_name
      verify multiple incoming calls  device=device_1
      accept multiple incoming calls  device=device_1   full_screen_call=reject    notification_call=accept
      Disconnect call   device=device_1
      Verify Call State    device_list=device_1,device_2,device_3    state=DisConnected
      [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3

TC3 : [multiple calls] DUT user on DUT settings page, receives multiple calls.
      [Tags]  149953  P2
      [Setup]   Testcase Setup for CAP User     count=3
      open settings page   device=device_1
      initiate simultaneous call  devices=device_2,device_3   target_device=device_1:cap_search_enabled    method=display_name
      verify multiple incoming calls  device=device_1
      accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept    count=3
      Disconnect call   device=device_1
      Verify Call State    device_list=device_1,device_2,device_3    state=DisConnected
      [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3

TC4 : [multiple calls] DUT user is on home screen, receives multiple calls and accept full screen call
      [Tags]  149939  P1     sanity_cap
      [Setup]   Testcase Setup for CAP User     count=3
      Navigate to calls tab   device=device_2,device_3
      initiate simultaneous call  devices=device_2,device_3   target_device=device_1:cap_search_enabled    method=display_name
      verify multiple incoming calls  device=device_1
      accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=verify
      Disconnect call   device=device_1
      Verify Call State    device_list=device_1,device_2,device_3    state=DisConnected
      [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3

TC5 : [multiple calls] DUT user is on home screen, receives multiple calls and accept notification call
      [Tags]  149940  P1     bvt_cap     sanity_cap
      [Setup]   Testcase Setup for CAP User     count=3
      Navigate to calls tab   device=device_2,device_3
      initiate simultaneous call  devices=device_2,device_3   target_device=device_1:cap_search_enabled    method=display_name
      verify multiple incoming calls  device=device_1
      accept multiple incoming calls  device=device_1   full_screen_call=verify    notification_call=accept
      Disconnect call   device=device_1
      verify call state and disconnect    device=device_1,device_2,device_3  
      [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3

TC6 : [Multiple calls] DUT user in Multiple calls from another DUT and TDC
      [Tags]  149958  P2
      [Setup]   Testcase Setup for CAP User     count=3
      Navigate to calls tab   device=device_2,device_3
      initiate simultaneous call  devices=device_2,device_3   target_device=device_1:cap_search_enabled    method=display_name
      verify multiple incoming calls  device=device_1
      accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept
      Disconnect call   device=device_1
      Verify Call State    device_list=device_1,device_2,device_3    state=DisConnected
      [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3

TC7 : [multiple calls] DUT user on device setting page, receives multiple calls.
      [Tags]  149954  P2
      [Setup]       Testcase Setup for CAP User     count=3
      navigate to device setting page   device=device_1
      initiate simultaneous call  devices=device_2,device_3   target_device=device_1:cap_search_enabled    method=display_name
      verify multiple incoming calls  device=device_1
      accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept    count=3
      Disconnect call   device=device_1
      Verify Call State    device_list=device_1,device_2,device_3    state=DisConnected
      [Teardown]  run keywords    Capture on Failure   AND    Device Setting Back     device=device_1    AND   come back home screen for user    count=3

TC8 : [multiple calls] DUT user is on home screen, receives multiple calls and accept both the calls.
      [Tags]  149943  P1
      [Setup]   Testcase Setup for CAP User     count=3
      Navigate to calls tab   device=device_2,device_3
      initiate simultaneous call  devices=device_2,device_3   target_device=device_1:cap_search_enabled    method=display_name
      verify multiple incoming calls  device=device_1
      accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept     count=3
      Disconnect call   device=device_1
      Verify Call State    device_list=device_1,device_2,device_3    state=DisConnected
      [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=3

TC9 : [multiple calls] DUT user in call, receives multiple call_2
       [Tags]  149947  P2
       [Setup]   Testcase Setup for CAP User     count=4
       click on calls tab    device=device_2
       Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
       Pick incoming call    device=device_1
       Verify Call State    device_list=device_1,device_2    state=Connected
       initiate simultaneous call  devices=device_3,device_4   target_device=device_1:cap_search_enabled    method=display_name
       verify multiple incoming calls  device=device_1
       accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept    count=4
       Disconnect Call  device=device_1,device_2
       Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Disconnected
       [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4

TC10 : [multiple calls] DUT user in call, receives multiple call, reject notification call
       [Tags]  149948  P2
       [Setup]   Testcase Setup for CAP User     count=4
       click on calls tab    device=device_2
       Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
       Pick incoming call    device=device_1
       Verify Call State    device_list=device_1,device_2    state=Connected
       initiate simultaneous call  devices=device_3,device_4   target_device=device_1:cap_search_enabled    method=display_name
       verify multiple incoming calls  device=device_1
       accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=reject    count=4
       resume call from call hold banner    device=device_1
       Verify Call State    device_list=device_1,device_2    state=Connected
       verify call state and disconnect        device=device_1,device_2,device_3,device_4
       [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4

TC11 : [Multiple calls] DUT user is in call, receives multiple_1
       [Tags]  149946   P1
       [Setup]  Testcase Setup for CAP user   count=4
       click on calls tab    device=device_2
       make outgoing call using display name  from_device=device_2   to_device=device_1:cap_search_enabled
       pick incoming call  device=device_1
       verify call state  device_list=device_1,device_2   state=connected
       initiate simultaneous call   devices=device_3,device_4   target_device=device_1:cap_search_enabled    method=display_name
       verify multiple incoming calls  device=device_1
       accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept    count=4
       Disconnect Call  device=device_1,device_2
       Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Disconnected
       [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4

TC12 : [multiple calls] DUT user is on home screen, receives 3 calls on the same time.
      [Tags]  149944  P2
      [Setup]   Testcase Setup for CAP User     count=4
      initiate simultaneous call  devices=device_2,device_3,device_4   target_device=device_1:cap_search_enabled    method=display_name
      verify multiple incoming calls  device=device_1
      Disconnect call   device=device_2,device_3,device_4
      Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Disconnected
      [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4


*** Keywords ***
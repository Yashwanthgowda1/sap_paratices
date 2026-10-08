*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10
${2wait_time} =     2 minutes
${20wait_time} =     20

*** Test Cases ***
TC1 : [Outgoing Calls] DUT user to make 2nd call
    [Tags]  149217   P1  sanity_cap
    [Setup]  Testcase Setup for CAP User    count=3
    click on people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Come back to home screen    device_list=device_1    disconnect=False
    click on people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2     state=Hold
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2 : [Outgoing Calls] DUT user cancel the outgoing call with teams client
    [Tags]  148735  P2   bvt_cap     sanity_cap
    [Setup]  Testcase Setup for CAP User    count=2
    click on people tab     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Verify user name display on call toast   to_device=device_2    from_device=device_1:cap_search_enabled
    Disconnect call    device=device_1
    Verify UI return to home screen   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3 : [Outgoing Calls] DUT user to see call controls properly
    [Tags]  149216  P2
    [Setup]  Testcase Setup for CAP User    count=2
    click on people tab     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call      device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify call control visibility      device_list=device_1
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC4 : [Outgoing Calls] DUT user calls Teams Client user from search icon
    [Tags]  149388  P2
    [Setup]  Testcase Setup for CAP User    count=2
    click on people tab     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call      device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC5 : [Outgoing Calls] DUT user dials an incorrect number
    [Tags]  148951   P2
    [Setup]  Testcase Setup for CAP User    count=1
    Dialing incorrect number    device=device_1
    Wait time to receive the bad_number announcement    time=${20wait_time}
    Verify ui came to home page     device=device_1
    [Teardown]  Capture on Failure

TC6 : [Outgoing Calls] DUT user call is rejected by Teams client
    [Tags]  148950  P2   sanity_cap
    [Setup]  Testcase Setup for CAP User    count=2
    click on people tab     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Rejects the incoming call    device_list=device_2
    Verify call decline message on UI      device=device_1
    Verify UI return to home screen  device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_2

# Commenting due to bug: 3492417
#TC7 : [Outgoing Calls] DUT user calls Teams Client user by DID and extension
#    [Tags]  148681  P1
#    [Setup]  Testcase Setup for CAP User    count=2
#    click on people tab     device=device_1
#    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call    device=device_1
#    Come back to home screen    device_list=device_1
#    click on people tab     device=device_1
#    Make outgoing call using extension number    from_device=device_1      to_device=device_2
#    Pick incoming call from call notification    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call    device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC7 : [Outgoing Calls] DUT make and receive call at the same time
    [Tags]  150026  P1
    [Setup]  Testcase Setup for CAP User    count=3
    click on people tab     device=device_1
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    verify incoming call    device=device_3     status=appear
    Verify call notification    device=device_1     status=appear
    verify call state and disconnect        device=device_3,device_2,device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC8 : [Outgoing Calls] Call controls during the call
    [Tags]  317939    P1    sanity_cap        Certification_cap
    [Setup]  Testcase Setup for CAP User    count=2
    click on people tab     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call      device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify call control visibility      device_list=device_1
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC9 :[Auto Dial][Calling] To verify call auto-dial on entering the full extension number
    [Tags]   321232     P2
    [Setup]  Testcase Setup for CAP User  count=2
    auto dial with valid num from dial pad  from_device=device_1    to_device=device_2
    pick incoming call  device=device_2
    Disconnect call    device=device_1
    [Teardown]   Run Keywords   Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC10 :[Auto Dial][Calling] To verify call auto-dial on entering the less than 5-digits of extension number
    [Tags]  321233      P2
    [Setup]  Testcase Setup for CAP User  count=2
    verify auto dial with insufficient extension num from dial pad  from_device=device_1    to_device=device_2
    [Teardown]   Run Keywords   Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC11 : [Outgoing Call]DUT user makes a call to another user
    [Tags]    476309
    [Setup]  Testcase Setup for CAP User  count=2
    click on people tab     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    verify incoming call    device=device_2     status=appear
    pick incoming call  device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC12 : [Outgoing Calls] DUT user calls Teams Client user by DID and extension
    [Tags]      148681    P2
    [Setup]  Testcase Setup for CAP User    count=2
    click on people tab     device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
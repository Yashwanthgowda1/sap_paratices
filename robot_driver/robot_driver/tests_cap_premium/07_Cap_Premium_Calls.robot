*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot


Suite Teardown      Suite Failure Capture

*** Variables ***
${wait_time} =  10
${2wait_time} =  20
${wait_time5sec} =  5
${3wait_time} =   3 minutes

*** Test Cases ***
TC1 : [Advanced calling] [Incoming Calls] DUT user receives call from TDC
    [Tags]   329267     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User    count=2
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify name of caller and receiver displayed    from_device=device_2      to_device=device_1:cap_search_enabled
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : [Advanced calling] [Incoming Calls] DUT user to answer second incoming call
    [Tags]  329268     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium User    count=3
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    click on calls tab     device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2     state=Hold
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3 :[Advanced calling] [Outgoing Calls] DUT user calls to TDC user.
    [Tags]  329362   P2
    [Setup]  Testcase Setup for CAP Premium User    count=2
    click on calls tab     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call      device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC4 : [Incoming Calls] DUT user to reject the call when UI view is in Device settings
    [Tags]  341832     P2
    [Setup]  Testcase Setup for CAP Premium User    count=2
    Opens partner settings page     device=device_1
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    reject incoming call     device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND    device setting back    device=device_1   AND   Come back to home screen    device_list=device_1,device_2

TC5 : [Advanced calling] [Incoming Calls] [Multiline] DUT user to verify the multiline number/Name
    [Tags]  329356    P2
    [Setup]  Testcase Setup for CAP Premium User    count=2
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Wait for Some Time    time=${wait_time5sec}
    Verify name of caller and receiver displayed    from_device=device_2      to_device=device_1:cap_search_enabled
    Verify incoming call   device=device_1      status=appear
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2

TC6 : [Advance Calling][Calls] Verify DUT user able to navigate the Device Settings page and stay there 2-3 minutes while on a P2P Call.
    [Tags]  402705      P1     Sanity_CAPPremium
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
Advance calling Setup
    Verify and enable advance calling option       device=device_1
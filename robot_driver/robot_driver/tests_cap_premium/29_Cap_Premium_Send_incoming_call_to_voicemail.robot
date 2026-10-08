*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown      Suite Failure Capture

*** Variables ***
${wait_time} =  30
${wait_time1} =  10

*** Test Cases ***
TC1 : DUT user should receive the Voicemail by tapping on Send to Voicemail option on Incoming call UI.
    [Tags]      452851   BVT_CAPPremium     Sanity_CAPPremium          phonesCY23_4
    [Setup]  Testcase Setup for CAP Premium User   count=2
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    verify incoming call        device=device_1         status=appear
    verify and click send to voicemail option for incoming call          device=device_1
    Verify Call State    device_list=device_2    state=Connected
    Verify Call State    device_list=device_1    state=disconnected
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    Wait for Some Time    time=${wait_time}
    Navigate to voicemail tab    device=device_1
    verify first voicemail displayname  to_device=device_1  from_device=device_2
    Play voicemail    device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2

TC2 : DUT user able to receive the Voicemail by tapping on Send to voicemail option in multiple call banner
   [Tags]      452861   BVT_CAPPremium     Sanity_CAPPremium        phonesCY23_4
   [Setup]  Testcase Setup for CAP Premium User   count=4
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    verify incoming call        device=device_1         status=appear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Wait for Some Time    time=${wait_time1}
    click back          device=device_1
    click on calls tab  device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2    state=Hold
    click on calls tab  device=device_4
    Make outgoing call using display name    from_device=device_4      to_device=device_1:cap_search_enabled
    verify and move incoming call to notification redirect to voicemail          from_device=device_1      to_device=device_4
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3,device_4    state=Connected
    Verify Call State    device_list=device_2       state=Hold
    Disconnect call     device=device_3,device_1,device_4
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    Wait for Some Time    time=${wait_time}
    click back          device=device_1
    Navigate to voicemail tab    device=device_1
    verify first voicemail displayname  to_device=device_1  from_device=device_4
    Play voicemail    device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2,device_4

TC3 :DUT user able to send the voicemail by tapping on voicemail icon for searched user in Calls app.
    [Tags]      452881       Sanity_CAPPremium            phonesCY23_4
    [Setup]  Testcase Setup for CAP Premium User   count=2
    click on calls tab  device=device_1
    validate search results and send voicemail in multiple tabs         from_device=device_1      to_device=device_2
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    Wait for Some Time    time=${wait_time}
    click back          device=device_1
    Navigate to voicemail tab    device=device_2
    refresh the page    device=device_2
    verify first voicemail displayname  to_device=device_2      from_device=device_1:cap_search_enabled
    Play voicemail    device=device_2
    navigate to voicemail tab     device=device_1
    validate search results and send voicemail in multiple tabs         from_device=device_1      to_device=device_2
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    Wait for Some Time    time=${wait_time}
    click back          device=device_1
    refresh the page    device=device_2
    verify first voicemail displayname  to_device=device_2   from_device=device_1:cap_search_enabled
    Play voicemail    device=device_2
    navigate to people tab          device=device_1
    validate search results and send voicemail in multiple tabs         from_device=device_1      to_device=device_2
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    Wait for Some Time    time=${wait_time}
    click back          device=device_1
    refresh the page    device=device_2
    verify first voicemail displayname  to_device=device_2  from_device=device_1:cap_search_enabled
    Play voicemail    device=device_2
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2

*** Keywords ***
Advance calling Setup
    Verify and enable advance calling option       device=device_1


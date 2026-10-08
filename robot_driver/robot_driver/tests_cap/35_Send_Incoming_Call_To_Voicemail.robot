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
    [Tags]      452845      bvt_cap     sanity_cap      phonesCY23_4
    [Setup]  Testcase Setup for CAP User    count=2
    click on people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    verify incoming call        device=device_1         status=appear
    verify and click send to voicemail option for incoming call          device=device_1
    Verify Call State    device_list=device_2    state=Connected
    Verify Call State    device_list=device_1    state=disconnected
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2

TC2 : DUT user able to recive the Voicemail by tapping on Send to voicemail option in multiple call banner
    [Tags]      452852    bvt_cap     sanity_cap      phonesCY23_4
    [Setup]  Testcase Setup for CAP User    count=4
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    verify incoming call        device=device_1         status=appear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Wait for Some Time    time=${wait_time1}
    click back          device=device_1
    click on people tab    device=device_1
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
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2,device_4

TC3 : DUT search the TDC user and verify the voicemail icon in TDC user contact card.
    [Tags]       452841      sanity_cap            phonesCY23_4
    [Setup]  Testcase Setup for CAP User    count=2
    click on people tab    device=device_1
    validate search results and send voicemail in multiple tabs         from_device=device_1      to_device=device_2
    Verify Call State    device_list=device_1    state=Connected
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1


*** Keywords ***



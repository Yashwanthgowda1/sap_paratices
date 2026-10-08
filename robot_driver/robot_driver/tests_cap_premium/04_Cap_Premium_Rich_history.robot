*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot


Suite Teardown      Suite Failure Capture

*** Variables ***

*** Test Cases ***
#Rich History feature removed from U3-2023
#TC1 : [CAP Premium][Rich History] Verify call history on DUT
#    [Tags]  2001
#    [Setup]   Testcase Setup for CAP Premium User   count=1
#    Navigate to calls tab   device=device_1
#    Verify call history log    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1
#
#TC2 : [CAP Premium][Rich History] Verify DUT user's call log in the recent tab gets synced after receiving an incoming call from TDC user
#    [Tags]  2002
#    [Setup]  Testcase Setup for CAP Premium User   count=2
#    click on calls tab   device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
#    Pick incoming call    device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    Verify call entries are synced in call log    from_device=device_1      to_device=device_2      state=duration
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2
#
#TC3 : [CAP Premium][Rich History] DUT user's call log in the recent tab gets synced after making an outbound call to TDC user
#    [Tags]  2003
#    [Setup]  Testcase Setup for CAP Premium User  count=2
#    click on calls tab   device=device_1
#    Make outgoing call using display name    from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    Come back to home screen   device_list=device_1
#    Verify call entries are synced in call log    from_device=device_1      to_device=device_2      state=duration
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2
#
#TC4 : [CAP Premium][Rich History][Calls] DUT user's call log in the recent tab gets synced after receiving a missed call from TDC user
#    [Tags]  2004
#    [Setup]  Testcase Setup for CAP Premium User   count=2
#    click on calls tab   device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
#    Verify incoming call    device=device_1    status=appear
#    Disconnect call     device=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    Refresh calls main tab    device=device_1
#    Verify call entries are synced in call log    from_device=device_1      to_device=device_2      state=missed
#    [Teardown]   Run Keywords    Capture on Failure     AND    Come back to home screen   device_list=device_1,device_2
#
#*** Keywords ***
#Advance calling Setup
#    Verify and enable advance calling option       device=device_1
*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown      Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Advance calling][OBO] TDC user adds DUT user as delegate with only Make call permission
    [Tags]   329321    P2
    [Setup]   Testcase Setup for CAP Premium Delegate User   count=3
    Edit added delegates with Make call permission and validate    from_device=device_2    to_device=device_1:cap_search_enabled
    Refresh page for delegate user config changes visibility    device=device_1
    Initiate OBO call using display name    from_device=device_1      to_device=device_3    obo_option=device_2:delegate_user
    Verify calling behalf of device text    device=device_1  to_device=device_3     from_device=device_2:delegate_user
    Verify Incoming call    device=device_3     status=appear
    Verify on behalf of call text   device=device_3    from_device=device_1     obo_user=device_2:delegate_user
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1,device_2,device_3  AND     Delete delegate from manage delegate    from_device=device_2    to_device=device_1:cap_search_enabled

TC2 : [Advance calling][OBO] TDC user adds DUT user as delegate with only receive call permission
    [Tags]  329322     P1     Sanity_CAPPremium
    [Setup]   Testcase Setup for CAP Premium Delegate User   count=3
    Edit added delegates with Receive call permission and validate   from_device=device_2    to_device=device_1:cap_search_enabled
    Refresh page for delegate user config changes visibility    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Verify user should not get the option to call on behalf     device=device_1
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1,device_2,device_3  AND     Delete delegate from manage delegate    from_device=device_2    to_device=device_1:cap_search_enabled

TC3 : [Advance calling][OBO]Boss's call on hold, notification banner should be displayed
    [Tags]   329324     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]     run keywords    Testcase Setup for CAP Premium Delegate User   count=3      AND     ADD NEW DELEGATES WITH BOTH PERMISSION AND VALIDATE     from_device=device_1    to_device=device_2:delegate_user
    Enable Also Ring delegates     device=device_1
    click on calls tab     device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1:cap_search_enabled
    Verify Incoming call    device=device_1,device_2     status=appear
    Pick incoming call    device=device_1
    Verify Incoming call    device=device_2     status=disappear
    Verify Call State    device_list=device_1,device_3    state=Connected
    Hold the call   device=device_1
    Resume the call   device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify Call State    device_list=device_1     state=Disconnected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    Delete delegate from manage delegate    from_device=device_1    to_device=device_2:delegate_user
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen   device_list=device_1,device_2,device_3    AND   Disable Also Ring    device=device_1

TC4 : [Advance calling][OBO] TDC user adds DUT user as delegate with both Make and receive call permission
    [Tags]    329323      BVT_CAPPremium     Sanity_CAPPremium
    [Setup]   Testcase Setup for CAP Premium Delegate User   count=3
    Edit added delegates with both permission and validate   from_device=device_2    to_device=device_1:cap_search_enabled
    Refresh page for delegate user config changes visibility    device=device_1
    Initiate OBO call using display name    from_device=device_1      to_device=device_3    obo_option=device_2:delegate_user
    Verify calling behalf of device text    device=device_1  to_device=device_3     from_device=device_2:delegate_user
    Verify Incoming call    device=device_3     status=appear
    Verify on behalf of call text   device=device_3     from_device=device_1      obo_user=device_2:delegate_user
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3    AND     Delete delegate from manage delegate    from_device=device_2    to_device=device_1:cap_search_enabled

*** Keywords ***
Advance calling Setup
    Verify and enable advance calling option       device=device_1

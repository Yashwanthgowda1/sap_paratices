*** Settings ***
Resource    ../resources/keywords/common.robot


Suite Teardown      Suite Failure Capture

*** Variables ***

*** Test Cases ***
TC1 : [CAP Premium][Simul-ring] DUT user can configure a second DUT user to ring simultaneously for an incoming call from TDC user
    [Tags]  447766
    [Setup]    Testcase Setup for CAP Premium User   count=3
    Enable Also Ring and add contact     device=device_1    contact_device=device_2
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
    Verify incoming call    device=device_1,device_2     status=appear
    Pick incoming call      device=device_2
    Verify incoming call    device=device_1    status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1,device_2,device_3      AND      Disable Also Ring   device=device_1

TC2 : [CAP Premium][Simul-ring] DUT user can configure a TDC user to ring simultaneously for an incoming call from another TDC user
    [Tags]  447763
    [Setup]    Testcase Setup for CAP Premium User    count=3
    Enable Also Ring and add contact     device=device_1       contact_device=device_3
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    Verify incoming call    device=device_1,device_3     status=appear
    Pick incoming call    device=device_3
    Verify incoming call    device=device_1    status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1,device_2,device_3  AND      Disable Also Ring   device=device_1

TC3 : [CAP Premium][Simul-ring] DUT user can configure a call group to ring simultaneously for an incoming call from TDC user
    [Documentation]  Precondition DUT add TDC3 and TDC4 as call group member
    [Tags]  447772
    [Setup]     run keywords    Testcase Setup for CAP Premium User   count=4   AND     Enable Also Ring Call group      device=device_1
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    Verify Incoming call    device=device_1     status=appear
    Verify call notification    device=device_3,device_4     status=appear
    Pick incoming call from call notification    device=device_3
    Verify Incoming call    device=device_1     status=disappear
    Verify call notification    device=device_4     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure      AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4   AND      Disable Also Ring   device=device_1

TC4 : [CAP Premium][Simul-ring] DUT user can configure a second DUT user to ring simultaneously for an incoming call from PSTN user
    [Tags]  447765
    [Setup]    Testcase Setup for CAP Premium PSTN User    count=3
    Enable Also Ring and add contact     device=device_1    contact_device=device_3
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    Verify incoming call    device=device_1,device_3     status=appear
    Pick incoming call      device=device_3
    Verify incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1,device_2,device_3  AND      Disable Also Ring   device=device_1

TC5 : [CAP Premium][Simul-ring] DUT user can configure a TDC user to ring simultaneously for an incoming call from PSTN user
    [Tags]  447762
    [Setup]   Testcase Setup for CAP Premium PSTN User    count=3
    Enable Also Ring and add contact     device=device_1    contact_device=device_3
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    Verify incoming call    device=device_1,device_3     status=appear
    Pick incoming call     device=device_3
    Verify incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1,device_2,device_3  AND      Disable Also Ring   device=device_1

TC6 : [CAP Premium][Simul-ring] DUT user can configure a PSTN user to ring simultaneously for an incoming call from TDC user
    [Tags]  447760
    [Setup]    Testcase Setup for CAP Premium PSTN User    count=3
    Enable Also Ring and add contact     device=device_1    contact_device=device_2:pstn_user
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
    Verify incoming call    device=device_1,device_2     status=appear
    Pick incoming call      device=device_2
    Verify incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1,device_2,device_3  AND      Disable Also Ring   device=device_1

TC7 : [CAP Premium][Simul-ring] DUT user can configure a call group to ring simultaneously for an incoming call from PSTN user
    [Documentation]  Precondition DUT add TDC3 and TDC4 as call group member
    [Tags]  447771
    [Setup]     run keywords   Testcase Setup for CAP Premium PSTN User   count=4   AND     Enable Also Ring Call group      device=device_1
    click on calls tab     device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    Verify Incoming call    device=device_1     status=appear
    Verify call notification    device=device_3,device_4     status=appear
    Pick incoming call from call notification    device=device_3
    Verify Incoming call    device=device_1     status=disappear
    Verify call notification    device=device_4     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure      AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4   AND      Disable Also Ring   device=device_1

TC8 : [CAP Premium][Simul-ring] DUT user can configure a PSTN user to ring simultaneously for an incoming call from PSTN user
    [Tags]  447759    sanity_cappremium
    [Setup]     Testcase Setup for CAP Premium 2 PSTN User    count=3
    Enable Also Ring and add contact     device=device_1    contact_device=device_2:pstn_user
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
    Verify incoming call    device=device_1,device_2     status=appear
    Pick incoming call      device=device_2
    Verify incoming call    device=device_1     status=disappear
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1,device_2,device_3      AND      Disable Also Ring   device=device_1

TC9 : [CAP Premium][Simul-ring] DUT user can configure delegates to ring simultaneously for an incoming call from PSTN user
    [Tags]  447768
    [Setup]   Testcase Setup for CAP Premium Delegate PSTN User   count=3
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_2:delegate_user
    Enable Also Ring delegates      device=device_1
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
    Verify incoming call    device=device_1,device_2    status=appear
    Pick incoming call    device=device_2
    Verify incoming call    device=device_1    status=disappear
    Verify Call State    device_list=device_2,device_3     state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    Delete delegate from manage delegate    from_device=device_1    to_device=device_2:delegate_user
    [Teardown]  run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1,device_2,device_3  AND      Disable Also Ring   device=device_1

TC10 : [CAP Premium][Simul-ring] DUT user can configure delegates to ring simultaneously for an incoming call from TDC user
    [Tags]  447769
    [Setup]    Testcase Setup for CAP Premium Delegate User   count=3
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_2:delegate_user
    Enable Also Ring delegates      device=device_1
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
    Verify incoming call    device=device_1,device_2    status=appear
    Pick incoming call    device=device_2
    Verify incoming call    device=device_1    status=disappear
    Verify Call State    device_list=device_2,device_3     state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    Delete delegate from manage delegate    from_device=device_1    to_device=device_2:delegate_user
    [Teardown]  run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1,device_2,device_3      AND      Disable Also Ring   device=device_1

*** Keywords ***
Advance calling Setup
    Verify and enable advance calling option       device=device_1


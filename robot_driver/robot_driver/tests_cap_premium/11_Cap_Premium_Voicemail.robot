*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown      Suite Failure Capture

*** Variables ***
${wait_time} =      20s

*** Test Cases ***
TC1 : [Advance calling][Voicemail] DUT User can receive Voicemail
      [Tags]    329305      P1     Sanity_CAPPremium
      [Setup]   Testcase Setup for CAP Premium User   count=2
      Enable call forwarding to voicemail     from_device=device_1    contact_device=device_2
      Send Voicemail      from_device=device_2   to_device=device_1:cap_search_enabled
      Navigate to voicemail tab    device=device_1
      refresh main tab    device=device_1
      play voicemail    device=device_1
      [Teardown]  Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2      AND    verify and disable call forwarding    device=device_1

TC2 : [Advance calling][Voicemail] DUT User to set call forward to Voicemail
      [Tags]   329306     BVT_CAPPremium     Sanity_CAPPremium
      [Setup]  run keywords      Testcase Setup for CAP Premium User   count=2    AND     Enable unanswered call to voicemail   from_device=device_1    contact_device=device_2
      verify user set the if unanswered to voicemail    device=device_1
      click on calls tab     device=device_2
      Make outgoing call using phonenumber    from_device=device_2   to_device=device_1:cap_search_enabled
      Verify incoming call   device=device_1     status=appear
      Wait for Some Time    time=${wait_time}
      Verify Call State    device_list=device_2   state=Connected
      Wait for Some Time    time=${wait_time}
      Disconnect call       device=device_2
      Verify Call State    device_list=device_1,device_2     state=Disconnected
      [Teardown]  Run Keywords    Capture on Failure    AND     Disable unanswered call    device=device_1      contact_device=device_2  AND    Come back to home screen    device_list=device_1,device_2

TC3 : [Advance calling][Voicemail] DUT user to play the voicemails from the list
    [Tags]  329238     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]   Testcase Setup for CAP Premium User    count=2
    Send Voicemail      from_device=device_2      to_device=device_1:cap_search_enabled
    Navigate to voicemail tab    device=device_1
    refresh the page    device=device_1
    Play multiple voicemail from list    on_device=device_1    from_device=device_2
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC4 : [Advance calling][Voicemail] DUT user delete the message while playing it.
    [Tags]   329307     P1     Sanity_CAPPremium
    [Setup]    Testcase Setup for CAP Premium User   count=2
    Send Voicemail      from_device=device_2     to_device=device_1:cap_search_enabled
    Navigate to voicemail tab    device=device_1
    refresh the page    device=device_1
    Delete voicemail while playing it    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC5 : [Advance calling][Voicemail] DUT user to delete the voicemail from the list
    [Tags]  329239    P1     Sanity_CAPPremium
    [Setup]   Testcase Setup for CAP Premium User    count=1
    Navigate to voicemail tab    device=device_1
    Delete voicemails from page   device=device_1
    [Teardown]    Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1

TC6 : [Advance calling][Voicemail] DUT user can Play the message (VM) with different speed
    [Tags]  329242    P3
    [Setup]   Testcase Setup for CAP Premium User    count=1
    Navigate to voicemail tab    device=device_1
    Play vm with diff speed     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC7 : [Advance calling][Voicemail] DUT user can Play/pause the message (VM) multiple times
    [Tags]   329241    P2
    [Setup]  Testcase Setup for CAP Premium User     count=2
    Send Voicemail      from_device=device_2     to_device=device_1:cap_search_enabled
    Navigate to voicemail tab    device=device_1
    refresh the page    device=device_1
    Play voicemail    device=device_1
    Pause voicemail     device=device_1
    Resume voicemail    device=device_1
    Pause voicemail     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
Send Voicemail
    [Arguments]     ${from_device}   ${to_device}
    Make outgoing call using display name    ${from_device}      ${to_device}
    Verify Call State    device_list=${from_device}   state=Connected
    Wait for Some Time    time=35s
    come back to home screen  device_list=${from_device}

Advance calling Setup
    Verify and enable advance calling option       device=device_1

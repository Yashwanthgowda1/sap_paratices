*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Esc to Conf.] DUT user in call with PSTN user, add PSTN user
    [Documentation]  Devices are already signed-in in Suite Setup
    [Tags]  308856  esc_conf_pstn2      P1  alt_blocked
    [Setup]  Testcase Setup for 2 PSTN User   count=3
    Click on calls tab   device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_3:pstn_user
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC2 : [Multiple calls] DUT user in Multiple calls, Blind Transfer one TDC call to another PSTN user
    [Tags]  308908    P2
    [Setup]  Testcase Setup for 2 PSTN User   count=4
    initiate simultaneous call  devices=device_3,device_4   target_device=device_1    method=phone_number
    verify multiple incoming calls   device=device_1
    accept multiple incoming calls   device=device_1   full_screen_call=accept    notification_call=accept        transfer_method=Blind   from_device=device_1   to_device=device_2:pstn_user     method=phone_number
    Pick incoming call   device=device_2
    Resume the call   device=device_1
    Disconnect Call  device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]  run keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC3 : [Multiple calls] DUT user in Multiple calls, Blind Transfer PSTN call to another PSTN user
      [Tags]  308911    P2
      [Setup]  Testcase Setup for 2 PSTN User   count=4
      initiate simultaneous call   devices=device_2,device_4   target_device=device_1     method=phone_number
      verify multiple incoming calls  device=device_1
      accept multiple incoming calls  device=device_1   full_screen_call=accept    notification_call=accept        transfer_method=Blind   from_device=device_1   to_device=device_3:pstn_user     method=phone_number
      Pick incoming call   device=device_3
      Resume the call   device=device_1
      Disconnect Call  device=device_1,device_3
      Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Disconnected
      [Teardown]  run keywords    Capture on Failure   AND   come back home screen for user    count=4

TC4 : [GCP] Last PSTN user should drop out after all other users in group leaves the call
    [Tags]  309376   P2  alt_blocked
    [Setup]  Testcase Setup for 2 PSTN User   count=3
    click on calls tab   device=device_3
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_3:pstn_user
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_1
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify Call State    device_list=device_1    state=Disconnected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

*** Keywords ***
Disable Call forward
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    verify and disable call forwarding    device=device_1

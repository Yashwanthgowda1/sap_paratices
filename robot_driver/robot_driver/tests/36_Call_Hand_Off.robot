*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation   Suite Setup Requirements : This suite requires minimum of 3 devices in config
...             Purpose : Device_1 should sign-in with Device_2 account

Suite Setup     Call Handoff Suite Setup
Suite Teardown    Run keyword and ignore error    Call Handoff Suite Teardown

*** Variables ***
${wait_time} =  10



*** Test Cases ***
TC1 : [Call hand off] Verify DUT should be able to join the call
    [Tags]   311039     bvt_tp   sanity_tp  alt_credentials     bvt_pr
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Add this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3

TC2 : [Call Handoff] Verify that After disconnecting, user is able to join again from banner in a Meeting
    [Tags]  311409     P2
    [Setup]  Testcase Setup for Call hand off    count=3
    create meeting  device=device_3       participants=device_2    meeting=tests_meeting
    Join Meeting    device=device_2,device_3     meeting=tests_meeting
    Verify meeting state   device_list=device_2,device_3    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=add this device
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    End meeting     device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_3   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3

TC3: [Call hand off] Verify that the DUT user can join the call by selecting the "Add this device" and "Transfer to this device" options.
    [Tags]   311042     sanity_tp
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Add this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1    state=Disconnected
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Transfer to this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3

TC4 : [Walkie-talkie] Verify call handoff banner is
    [Tags]   311977        p1   sanity_tp
    [Setup]  Testcase Setup for Call hand off    count=3
    navigate to walkie talkie tab   device=device_1
    click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2,device_3

TC5 : [Multiple Call Banner] DUT user to check call hold banner when call hand-off banner is already present
    [Tags]  311938    P1    sanity_tp       bvt_pr
    [Setup]  Testcase Setup for Call hand off    count=4
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify call hand off banner     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_4
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_1,device_4    state=Connected
    Hold the call    device=device_1
    Verify Call State    device_list=device_1,device_4    state=Hold
    click back      device=device_1
    verify call hold banner     from_device=device_1        to_device=device_4
    Verify call hand off banner     device=device_1
    Disconnect call      device=device_3,device_4
    Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC6 : [Call Handoff] Verify the options available when the DUT user taps the Join button on the call handoff banner, and check if clicking the X button closes the banner.
    [Tags]    311385    sanity_tp
    [Setup]    Testcase Setup For Call Hand Off    count=3
    Click On Calls Tab    device=device_1
    Make Outgoing Call Using Display Name    from_device=device_1    to_device=device_3
    Pick Incoming Call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call Hand Off Banner    device=device_2
    Tap On Join Button From Banner    device=device_2
    Validate Both Options For Joining Meeting    device=device_2
    Dismiss Call Hand Off Options    device_name=device_2
    Verify Call Hand Off Banner After Closing    device=device_2
    Disconnect Call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Disconnected
    Make a group call for handoff    from_device=device_1    to_device=device_3    new_participant=device_4
    Verify Call Hand Off Banner    device=device_2
    Tap On Join Button From Banner    device=device_2
    Validate Both Options For Joining Meeting    device=device_2
    Dismiss Call Hand Off Options    device_name=device_2
    Verify Call Hand Off Banner After Closing    device=device_2
    Disconnect Call    device=device_4,device_1
    Verify Call State    device_list=device_1,device_3,device_4    state=Disconnected
    [Teardown]    Run Keywords    Capture On Failure    AND    Come Back To Home Screen    device_list=device_1,device_2,device_3

TC7 : [Call Handoff] Verify that DUT2 has entered the Group call and DUT1 has left the call when user tap on "Transfer to this device".
    [Tags]    311393
    [Setup]    Testcase Setup For Call Hand Off    count=4
    Make a group call for handoff    from_device=device_3    to_device=device_2    new_participant=device_4
    Verify Call Hand Off Banner    device=device_1
    Tap On Join Button From Banner    device=device_1
    Validate Both Options For Joining Meeting    device=device_1
    Select Option To Join Meeting    device=device_1    option=Transfer to this device
    Verify Call State    device_list=device_1,device_3,device_4    state=Connected
    Verify Call Mute State    device_list=device_1    state=mute
    Verify Call State    device_list=device_2    state=Disconnected
    Disconnect Call    device=device_3,device_1
    Verify Call State    device_list=device_1,device_3    state=Disconnected
    [Teardown]    Run Keywords    Capture On Failure    AND    Come Back To Home Screen    device_list=device_1,device_2,device_3


*** Keywords ***
Make a group call for handoff
    [Arguments]     ${from_device}   ${to_device}   ${new_participant}
    Navigate to calls tab   device=${from_device}
    Make outgoing call using display name    from_device=${from_device}      to_device=${to_device}
    Pick incoming call    device=${to_device}
    Verify Call State   device_list=${from_device},${to_device}   state=Connected
    Add participant to conversation using display name   from_device=${from_device}      to_device=${new_participant}
    Pick incoming call    device=${new_participant}
    Verify Call State   device_list=${from_device},${to_device},${new_participant}    state=Connected

Call Handoff Suite Setup
    Testcase Setup   count=3
    Signin with other user    device=device_1   other_user_account=device_2

Call Handoff Suite Teardown
    Suite Failure Capture
    sign out method  device_1
    sign in method  device_1
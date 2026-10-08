*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Setup      Call Handoff Suite Setup
Suite Teardown    Run keywords      Suite Failure Capture   AND     Call Handoff Suite Teardown

*** Variables ***
${wait_time} =  10



*** Test Cases ***
TC1 : [Call hand off] Verify the banner "Join on this device" on DUT.
    [Tags]   306512
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2,device_3

TC2 : [Call hand off] Verify DUT should be able to join the call
    [Tags]   306513     bvt_tpc     sanity_tpc  P0
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
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

TC3 : [Call hand off] Verify DUT should join the call when clicked on Transfer to this device option
    [Tags]   306514  sanity_tpc     P1
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Transfer to this device
    Wait for Some Time    time=${wait_time}
    Verify your call was transferred text    device=device_2
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3

TC4 : [Call hand off] Verify DUT can able to hold and resume the call
    [Tags]  306516  sanity_tpc  P1
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Add this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1    state=Hold
    Resume the call   device=device_1
    Verify Call State    device_list=device_1     state=Resume
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3

TC5 : [Call Handoff] Verify options available when DUT user tap on Join button on call handoff banner for meetings
    [Tags]   306542     bvt_tpc  sanity_tpc  P0
    [Setup]  Testcase Setup for Call hand off    count=3
    create meeting  device=device_3     meeting=test_meeting    participants=device_1:meeting_user
    Join Meeting    device=device_3     meeting=test_meeting
    Add participant to conversation using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Wait for Some Time    time=${wait_time}
    Verify Incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify meeting state   device_list=device_2,device_3    state=Connected
    verify call hand off banner for meetings    device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Close options screen     device=device_1
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3

TC6 : [Call Handoff] Verify options available when DUT user tap on Join button on call handoff banner
    [Tags]   306528  sanity_tpc  P1
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Close options screen     device=device_1
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1   AND     Come back to home screen    device_list=device_1,device_2,device_3

TC7 : [Multiple call banner]Verify companion banner appears at the top if any banner is displaying.
    [Tags]  321159   P2
    [Setup]  Testcase Setup for Call hand off    count=4
    click on calls tab     device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    click on calls tab     device=device_4
    Make outgoing call using display name    from_device=device_4      to_device=device_1:meeting_user
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_4    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    verify call hand off banner along with call park banner    device=device_1
    Disconnect call     device=device_2,device_4
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    [Teardown]   Run Keywords   Capture on Failure   AND   Close options screen     device=device_1   AND   Come back to home screen   device_list=device_1,device_2,device_3,device_4


TC8 : [Multiple Call Banner] DUT user to check call hold banner when call hand-off banner is already present
    [Tags]  306639   sanity_tpc  P1
    [Setup]  Testcase Setup for Call hand off    count=4
    Navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify call hand off banner     device=device_1
    Navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_4
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_1,device_4    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1    state=Hold
    click back      device=device_1
    verify call hold banner    from_device=device_1     to_device=device_3
    Verify call hand off banner     device=device_1
    Disconnect call     device=device_2,device_4
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1       AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC9 : [Call Handoff] Verify that call handoff banner is displayed to DUT user
    [Tags]   306544     p2
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab     device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen    device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3

TC10 :[Call Handoff] Verify that call handoff banner is displayed to DUT user in a group call
   [Tags]     306533
   [Setup]  Testcase Setup for Call hand off    count=4
   click on calls tab     device=device_3
   Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
   Pick incoming call    device=device_2
   Verify Call State    device_list=device_3,device_2    state=Connected
   Add participant to conversation using display name    from_device=device_2      to_device=device_4
   Pick incoming call    device=device_4
   Verify call hand off banner     device=device_1
   Disconnect call     device=device_3,device_4
   Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
   [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC11: [Call Handoff] Verify that DUT2 and DUT1 remains in the call when DUT user tap on "Add this device"
    [Tags]    306529
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
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
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen      device=device_1   AND     Come back to home screen    device_list=device_1,device_2,device_3

TC12 : [Call Handoff] Verify that if the user A clicking the X button it close the banner
    [Tags]          306531
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    close call hand off banner     device=device_1
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3

TC13 : [Call hand off] Verify DUT can able to Mute all participants call
    [Tags]          306519
    [Setup]  Testcase Setup for Call hand off    count=4
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Add this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_4
    pick incoming call    device=device_4
    Verify Call State   device_list=device_1,device_4    state=Connected
    Mute all participants       device=device_1
    Verify Call mute State    device_list=device_3,device_4    state=Mute
    Disconnect call     device=device_1,device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND      Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC14 :[Call Handoff] Verify that After disconnecting, user is able to join again from banner in a Group call
    [Tags]   306537     p2
    [Setup]   Testcase Setup for Call hand off    count=4
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Add participant to conversation using display name    from_device=device_2      to_device=device_4
    Pick incoming call    device=device_4
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Add this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Connected
    Disconnect call     device=device_1
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Add this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Connected
    Disconnect call     device=device_3,device_4
    Verify Call State    device_list=device_1,device_2,device_3      state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen    device=device_1    AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC15 : [Call Handoff] Verify options available when DUT user tap on Join button on call handoff banner in a group call
    [Tags]   306534     p1
    [Setup]   Testcase Setup for Call hand off    count=4
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Add participant to conversation using display name    from_device=device_2      to_device=device_4
    Pick incoming call    device=device_4
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    close call hand off banner     device=device_1
    Disconnect call     device=device_3,device_4
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen    device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC16 : [Call hand off] Verify DUT can able tap use dialpad during call
    [Tags]   306517     p2
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Add this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Verify dialpad in call control    device=device_1
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3

TC17 : [Call Handoff] Verify that After disconnecting, user is able to join again from banner in a Meeting
    [Tags]   306543     p2
    [Setup]  Testcase Setup for Call hand off    count=3
    create meeting  device=device_3     meeting=test_meeting    participants=device_1:meeting_user
    Join Meeting    device=device_2,device_3     meeting=test_meeting        join_styles=conference,None
    Wait for Some Time    time=${wait_time}
    Verify meeting state   device_list=device_2,device_3    state=Connected
    verify call hand off banner for meetings    device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Add this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_1
    verify call hand off banner for meetings    device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Add this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1   AND     Come back to home screen    device_list=device_1,device_2,device_3

TC18 : [Call Handoff] Verify that Call handoff banner must appear on all the hidden tabs as well
    [Tags]   306539     p2
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify call hand off banner     device=device_1
    navigate to people tab       device=device_1
    Verify call hand off banner     device=device_1
    Come back to home screen    device_list=device_1
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3

TC19 : [Call Handoff] Verify that DUT2 and DUT1 remains in the Group call when DUT user tap on "Add this device"
    [Tags]   306536     p1
    [Setup]   Testcase Setup for Call hand off    count=4
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Add participant to conversation using display name    from_device=device_2      to_device=device_4
    Pick incoming call    device=device_4
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1       option=Add this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call      device=device_3,device_4
    Verify Call State    device_list=device_1,device_2,device_3      state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen    device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC20 : [Call hand off] DUT to disconnect the call
    [Tags]   306515     p2
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Add this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1    state=Disconnected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Transfer to this device
    Wait for Some Time    time=${wait_time}
    Verify your call was transferred text    device=device_2
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3

TC21 : [Call Handoff] Verify that After disconnecting, user is able to join again from banner
    [Tags]   306532     p2
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Add this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_1
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Add this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1   AND     Come back to home screen    device_list=device_1,device_2,device_3

TC22 : [Call hand off] Verify DUT can able Blind transfer to another TDC
    [Tags]   306523     p2
    [Setup]  Testcase Setup for Call hand off    count=4
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Add this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Blindtransfers the call using display name  from_device=device_1      to_device=device_4
    Pick incoming call    device=device_4
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_3,device_4    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC23 : [Call Handoff] Verify that Call handoff banner must appear on app setting page
    [Tags]   306540     p2
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    open settings page      device=device_1
    Wait for Some Time    time=${wait_time}
    Verify call hand off banner     device=device_1
    Come back to home screen    device_list=device_1
    opens partner settings page     device=device_1
    Wait for Some Time    time=${wait_time}
    verify call hand off banner should not visible in device settings page  device=device_1
    comes out of partner settings page    device=device_1
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3

TC24 : [Call Handoff] Verify that Call handoff banner must appear on all the tabs
    [Tags]   306538     p1
    [Setup]   Testcase Setup for Call hand off    count=3
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify call hand off banner     device=device_1
    Navigate to people tab  device=device_1
    Verify call hand off banner     device=device_1
    Navigate to calendar tab   device=device_1
    Verify call hand off banner     device=device_1
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen    device=device_1    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC25 : [Call Handoff] Verify that DUT2 has entered the call and DUT1 has left the call when user tap on “Transfer to this device”.
    [Tags]   306530     p1
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab     device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:meeting_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Transfer to this device
    Wait for Some Time    time=${wait_time}
    Verify your call was transferred text    device=device_2
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3

*** Keywords ***
Call Handoff Suite Setup
    Testcase Setup for Meeting User   count=3
    Signin with other user    device=device_2   other_user_account=device_1:meeting_user

Call Handoff Suite Teardown
    sign out method  device_2
    sign in method  device_2


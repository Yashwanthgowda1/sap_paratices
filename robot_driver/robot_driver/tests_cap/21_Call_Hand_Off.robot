*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Setup      Call Handoff Suite Setup
Suite Teardown    Run keywords      Suite Failure Capture   AND     Call Handoff Suite Teardown

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Call Handoff] Verify that Call handoff banner must appear on app setting page
    [Tags]   316157     p2
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
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
    navigate back from device settings    device=device_1
    device setting back    device=device_1
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3

TC2 : [Call Handoff] Verify options available when DUT user tap on Join button on call handoff banner
    [Tags]   316163     p2
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Close options screen     device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1   AND     Come back to home screen    device_list=device_1,device_2,device_3

TC3 : [Call hand off] Verify the banner “You’re in a call on another device. Want to join on this one?” on DUT
     [Tags]  316129     bvt_cap  sanity_cap
     [Setup]  Testcase Setup for Call hand off    count=3
     click on calls tab    device=device_3
     Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
     Pick incoming call    device=device_2
     Verify Call State    device_list=device_3,device_2    state=Connected
     Verify call hand off banner     device=device_1
     Disconnect call     device=device_2
     Verify Call State    device_list=device_1,device_2     state=Disconnected
     [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2,device_3

TC4 :[Call hand off] Verify DUT should be able to join the call
     [Tags]    316130    sanity_cap    bvt_cap
     [Setup]  Testcase Setup for Call hand off    count=3
     click on calls tab    device=device_3
     Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
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

TC5 : [Call hand off] Verify DUT should join the call when clicked on Transfer to this device option
    [Tags]  316131      p1    sanity_cap
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Transfer to this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3

TC6 : [Call hand off] DUT to disconnect the call
    [Tags]   316132     p2
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
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
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3

TC7 : [Call hand off] Verify DUT can able to hold and resume the call
     [Tags]   316133   p1    sanity_cap
     [Setup]  Testcase Setup for Call hand off    count=3
     click on calls tab    device=device_3
     Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
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

TC8 : [Call hand off] Verify DUT can able tap use dialpad during call
    [Tags]   316134   p2
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
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

TC9 : [Call hand off] Verify DUT can able to turn on and off live captions in call
    [Tags]   316135    p2
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Add this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Turn on live caption    device=device_1
    Wait for Some Time    time=${wait_time}
    Turn off live caption    device=device_1
    Disconnect call     device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND    come back home screen for user    count=3

TC10 : [Call hand off] Verify DUT can able to Mute all participants call
    [Tags]   316136     p2
    [Setup]  Testcase Setup for Call hand off    count=4
    click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
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

TC11 : [Call hand off] Verify DUT can able Blind transfer to another teams client
    [Tags]   316140    p2
    [Setup]  Testcase Setup for Call hand off    count=4
    click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
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
    Verify Call State    device_list=device_3,device_4    state=Connected
    Disconnect call     device=device_3,device_4
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC12 : [Call hand off] Verify DUT can able Consult transfer to another teams client
    [Tags]   316141     p2
    [Setup]  Testcase Setup for Call hand off    count=4
    click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Add this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Consult first to transfer the call using display name  from_device=device_1      to_device=device_4
    Pick incoming call    device=device_4
    Verify Call State    device_list=device_1,device_4    state=Connected
    Completes the consultation to accept the call     from_device=device_1      to_device=device_3
    Verify Call State    device_list=device_3,device_4    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC13 : [Call Handoff] Verify options available when DUT user tap on Join button on call handoff banner
    [Tags]   316145    p1    sanity_cap
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    close call hand off banner     device=device_1
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1   AND     Come back to home screen    device_list=device_1,device_2,device_3

TC14 : [Call Handoff] Verify that DUT2 and DUT1 remains in the call when DUT user tap on "Add this device"
    [Tags]   316146    p1
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
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

TC15 : [Call Handoff] Verify that DUT2 has entered the call and DUT1 has left the call when user tap on “Transfer to this device”.
    [Tags]  316147     p1
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Transfer to this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3

TC16 : [Call Handoff] Verify that if the user A clicking the X button it close the banner
    [Tags]   316148     p1
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    close call hand off banner     device=device_1
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1    AND     Come back to home screen    device_list=device_1,device_2,device_3

TC17 :[Call Handoff] Verify that After disconnecting, user is able to join again from banner
    [Tags]   316149     p2
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
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

TC18 : [Call Handoff] Verify that call handoff banner is displayed to DUT user in a group call
    [Tags]    316150    p1
    [Setup]  Testcase Setup for Call hand off    count=4
    click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Add participant to conversation using display name    from_device=device_2      to_device=device_4
    Pick incoming call    device=device_4
    Verify call hand off banner     device=device_1
    Disconnect call     device=device_3,device_4
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_4,device_2,device_3,device_4

TC19 : [Call Handoff] Verify options available when DUT user tap on Join button on call handoff banner in a group call
    [Tags]    316151    p1
    [Setup]  Testcase Setup for Call hand off    count=4
    click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
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
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_4,device_2,device_3

TC20 : [Call Handoff] Verify that DUT2 has entered the Group call and DUT1 has left the call when user tap on 'Transfer to this device'
    [Tags]    316152    p1
    [Setup]  Testcase Setup for Call hand off    count=4
    click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Add participant to conversation using display name    from_device=device_2      to_device=device_4
    Pick incoming call    device=device_4
    Verify call hand off banner     device=device_1
    Tap on Join Button from banner    device=device_1
    Validate both options for joining meeting    device=device_1
    Select option to join meeting    device=device_1     option=Transfer to this device
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_2      state=Disconnected
    Verify Call State    device_list=device_1,device_3     state=Connected
    Disconnect call     device=device_3,device_4
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC21 : [Call Handoff] Verify that DUT2 and DUT1 remains in the Group call when DUT user tap on "Add this device"
    [Tags]   316153    p1
    [Setup]  Testcase Setup for Call hand off    count=4
    click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
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
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC22 : [Call Handoff] Verify that After disconnecting, user is able to join again from banner in a Group call
    [Tags]   316154      p2
    [Setup]  Testcase Setup for Call hand off    count=4
    click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
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
    [Teardown]   Run Keywords    Capture on Failure   AND   Close options screen     device=device_1     AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC23 : [Multiple call banner]Verify companion banner appears at the top if any banner is displaying.
    [Tags]  321156    P2
    [Setup]  Testcase Setup for Call hand off    count=4
    click on calls tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    Make outgoing call using display name    from_device=device_4      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_4    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    verify call hand off banner along with call park banner    device=device_1
    Disconnect call     device=device_2,device_4
    Verify Call State    device_list=device_1,device_2,device_3,device_4     state=Disconnected
    [Teardown]   Run Keywords   Capture on Failure   AND   Close options screen     device=device_1   AND   Come back to home screen   device_list=device_1,device_2,device_3,device_4

TC24 : [Call Handoff] Verify that Call handoff banner must appear on all the tabs/Page
    [Tags]    316155
    [Setup]  Testcase Setup for Call hand off    count=3
    click on calls tab    device=device_3
    Make outgoing call using phonenumber    from_device=device_3      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Verify call hand off banner     device=device_1
    click on calls tab    device=device_1
    Verify call hand off banner     device=device_1
    return to home screen    device_list=device_1
    Navigate to people tab    device=device_1
    Verify call hand off banner     device=device_1
    return to home screen    device_list=device_1
    Navigate to device setting page     device=device_1
    verify call hand off banner should not visible in device settings page    device=device_1
    return to home screen    device_list=device_1
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords   Capture on Failure   AND   Close options screen     device=device_1   AND   Come back to home screen   device_list=device_1,device_2,device_3

*** Keywords ***
Call Handoff Suite Setup
    Testcase Setup for CAP User   count=3
    Signin with other user    device=device_2   other_user_account=device_1:cap_search_enabled

Call Handoff Suite Teardown
    sign out method  device_2
    sign in method  device_2
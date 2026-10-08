*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture
*** Variables ***
${action_time} =  10
${wait_time_20s}=   20
*** Test Cases ***
TC1 : [Presence] User can view the self presence in the form of Presence icon on the hamburger menu
    [Tags]      243338        Certification_lcp
    [Setup]  Testcase Setup     count=1
    verify ui post signin  device=device_1
    Verify user presence   device=device_1     state=Available
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2 : [Presence] Presence changes to "In a call" from available when the user makes a call
    [Tags]      243332      sanity_lcp        Certification_lcp
    [Setup]  Testcase Setup     count=2
    Select user presence   device=device_1     state=Available
    Verify user presence   device=device_1     state=Available
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    device setting back     device=device_2
    Verify user presence from other user    from_device=device_2      to_device=device_1     state=In call
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Verify user presence from other user    from_device=device_2      to_device=device_1     state=Available
    [Teardown]  Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2

TC3 : [Presence] Presence should not change from "Away" to "In a call" when the user makes a call
    [Tags]      243336      sanity_lcp        Certification_lcp
    [Setup]  Testcase Setup     count=2
    Select user presence   device=device_1     state=Away
    Verify user presence   device=device_1     state=Away
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    device setting back     device=device_2
    Verify user presence from other user    from_device=device_2      to_device=device_1     state=Away
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Verify user presence from other user    from_device=device_2      to_device=device_1     state=Away
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2   AND   Select user presence   device=device_1     state=available

TC4 : [Presence] Presence changes to "In a call" from "Busy" when the user makes a call
    [Tags]       243334        Certification_lcp
    [Setup]  Testcase Setup     count=2
    Select user presence   device=device_1     state=Busy
    Verify user presence   device=device_1     state=Busy
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    device setting back     device=device_2
    Verify user presence from other user    from_device=device_2      to_device=device_1     state=In call
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2   AND   Select user presence   device=device_1     state=available

TC5 : [Presence] DUT user can see the correct presence in call log screen (in the form of presence icon only)
    [Tags]      243340        Certification_lcp
    [Setup]  Testcase Setup     count=2
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    navigate to calls tab    device=device_1
    verify presence of other user from calls tab     from_device=device_1     to_device=device_2     state=Available
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC6 : [Presence] Presence should not change to offline if DUT user sign out but same user is still signed in on TDC
    [Tags]      243348
    [Setup]  Testcase Setup     count=3
    Select user presence   device=device_1     state=Available
    Verify user presence   device=device_1     state=Available
    Signin with other user    device=device_2   other_user_account=device_1
    sign out method    device_1
    Verify user presence from other user    from_device=device_3      to_device=device_1     state=Available
    [Teardown]  Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2,device_3   AND      signin method for lcp   device=device_1

TC7 : [Presence] Presence should not change to offline if TDC user sign out but same user is still signed in on DUT
    [Tags]      243350
    [Setup]  Testcase Setup     count=3
    Select user presence   device=device_1     state=Available
    Verify user presence   device=device_1     state=Available
    Signin with other user    device=device_2   other_user_account=device_1
    sign out method    device_1
    Verify user presence from other user    from_device=device_3      to_device=device_1     state=Available
    [Teardown]  Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2,device_3   AND      signin method for lcp   device=device_1

TC8 : [Presence] DUT user changes the presence to DND and Available
    [Tags]      243354  bvt_lcp    sanity_lcp        Certification_lcp
    [Setup]  Testcase Setup     count=2
    Select user presence   device=device_1     state=DND
    Verify user presence   device=device_1     state=DND
    Verify user presence from other user    from_device=device_2      to_device=device_1     state=DND
    Select user presence   device=device_1     state=Available
    Verify user presence   device=device_1     state=Available
    Verify user presence from other user    from_device=device_2      to_device=device_1     state=Available
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    device setting back     device=device_2
    Verify user presence from other user    from_device=device_2      to_device=device_1     state=In call
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Verify user presence from other user    from_device=device_2      to_device=device_1     state=Available
    Come back to home screen    device_list=device_1
    Select user presence   device=device_1     state=Offline
    Verify user presence   device=device_1     state=Offline
    Verify user presence from other user    from_device=device_2      to_device=device_1     state=Offline
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2   AND   Select user presence   device=device_1     state=available

TC9 : [Presence] Presence should change to the previous state at the end of Conference call/P2P call
    [Tags]       243352
    [Setup]  Testcase Setup     count=3
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Add participant to conversation using display name   from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    device setting back     device=device_2
    Verify user presence from other user    from_device=device_2      to_device=device_1     state=In call
    Disconnect call     device=device_1,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    Verify user presence from other user    from_device=device_2      to_device=device_1     state=Available
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3

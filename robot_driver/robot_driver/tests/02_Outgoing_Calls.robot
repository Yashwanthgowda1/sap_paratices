*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  8

*** Test Cases ***
TC1 : [Outgoing Calls] DUT user calls Teams Client user from Recent tab
    [Tags]  309697   sanity_tp       bvt_pr  alt_credentials
    [Setup]     run keywords  Testcase Setup    count=2     AND     make outgoing call for call log     from_device=device_1      to_device=device_2
    click on calls tab   device=device_1
    call from recent tab using call history  from_device=device_1      to_device=device_2
    verify incoming call  device=device_2   status=appear
    Pick incoming call    device=device_2
    Wait for Some Time    time=10
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Select call list item       device=device_1         item=favorite
    Calling from favorite page      from_device=device_1      to_device=device_2
    verify incoming call  device=device_2   status=appear
    Pick incoming call    device=device_2
    Wait for Some Time    time=10
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND   remove favorite user from favorites page     from_device=device_1    to_device=device_2   AND   Come back to home screen    device_list=device_1,device_2

TC2 : [Outgoing Calls] DUT user to make 2nd call
    [Tags]  309722   sanity_tp     alt_credentials
    [Setup]  Testcase Setup    count=3
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    go back to previous page   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2     state=Hold
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3 : [Outgoing Calls] User to test soft key dial Pad
    [Tags]  309745   sanity_tp       bvt_pr  alt_credentials        Certification_audio
    [Setup]  Testcase Setup    count=1
    click on calls tab   device=device_1
    Dial and verify the numbers from 0 to 9    device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1

TC4 :[Auto Dial][Calling] To verify call auto-dial on entering the less than 5-digits of extension number.
    [Tags]  320972         sanity_tp
    [Setup]  Testcase Setup    count=2
    click on calls tab   device=device_1
    verify auto dial with insufficient extension num from dial pad  from_device=device_1    to_device=device_2
    [Teardown]   Run Keywords   Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC5: [Audio outPut]check mute/unmute works fine in speaker/headphone/handset
    [Tags]    321105      sanity_tp
    [Setup]  Testcase Setup     count=2
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    press specific hardkey    device=device_1    hard_key=SPEAKER      status=ON
    mutes the phone call    device=device_1
    verify call mute state    device_list=device_1    state=mute
    unmutes the phone call    device=device_1
    verify call mute state    device_list=device_1    state=unmute
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK      status=ON
    mutes the phone call    device=device_1
    verify call mute state    device_list=device_1    state=mute
    unmutes the phone call    device=device_1
    verify call mute state    device_list=device_1    state=unmute
    press specific hardkey    device=device_1    hard_key=HEADSETHOOK      status=ON
    mutes the phone call    device=device_1
    verify call mute state    device_list=device_1    state=mute
    unmutes the phone call    device=device_1
    verify call mute state    device_list=device_1    state=unmute
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2   state=Disconnected
    Verify Multiple Intents    device=device_1     features_list=PHONE_STATE_UPDATED   intents_list=speaker_on,handset_on,headset_on
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC6: [Outgoing call] Verify that the full call UI is displayed, when user select call banner.
    [Tags]    435171
    [Setup]    Testcase Setup for PSTN User   count=2
    click on calls tab  device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Verify Incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    return to home screen    device_list=device_1
    click on calls tab    device=device_1
    Tap to return to call    device=device_1    action=verify
    Tap to return to call    device=device_1    action=click
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC7 : [Outgoing calls] DUT user to call TDC user using different options (DID, ext., from contacts)
    [Tags]  318497    P2
    [Setup]  Testcase Setup    count=2
    click on calls tab  device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    # Commenting due to bug: 3492417
    # navigate to calls tab   device=device_1
    # auto dial with valid num from dial pad  from_device=device_1    to_device=device_2     method=extension
    # Pick incoming call    device=device_2
    # Wait for Some Time    time=${wait_time}
    # Verify Call State    device_list=device_1,device_2    state=Connected
    # Disconnect call    device=device_1
    # Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2


# Commenting due to bug: 3492417
# TC9 :[Auto Dial][Calling]To verify call auto-dial on entering the full extension number.
#     [Tags]   320977     P2
#     [Setup]  Testcase Setup    count=2
#     click on calls tab   device=device_1
#     auto dial with valid num from dial pad  from_device=device_1    to_device=device_2     method=extension
#     pick incoming call  device=device_2
#     Wait for Some Time    time=${wait_time}
#     Verify Call State    device_list=device_1,device_2    state=Connected
#     Disconnect call    device=device_1
#     [Teardown]   Run Keywords   Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
*** Keywords ***
Make outgoing call for call log
    [Arguments]     ${from_device}   ${to_device}
    navigate to calls tab  device=${from_device}
    Make outgoing call using display name    from_device=${from_device}      to_device=${to_device}
    Verify Incoming call    device=${to_device}     status=appear
    Disconnect call     device=${from_device}
    Verify Incoming call    device=${to_device}     status=disappear
    Verify Call State    device_list=${from_device}     state=Disconnected
    Navigate to calls tab   device=${from_device}
    Refresh calls main tab    device=${from_device}

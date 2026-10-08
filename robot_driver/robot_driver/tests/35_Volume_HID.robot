*** Settings ***
Resource    resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  6
${wait_time_3s} =  3

*** Test Cases ***
TC1: [Volume] DUT user to test the volume hard button after sign-in
    [Tags]   308753    certification_audio        sanity_tp
    [Setup]     Testcase Setup    count=1
    increase volume and verify    device=device_1    volume_stream=system
    decrease volume and verify    device=device_1    volume_stream=system
    [Teardown]   Run Keywords    Capture on Failure

TC2:[Volume] DUT user to test the volume hard button before call
    [Tags]    307685    bvt_tp    certification_audio        sanity_tp
    [Setup]    Testcase Setup   count=1
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
    verify dialpad after clicking speaker or handsethook button    device=device_1
    increase volume and verify    device=device_1    volume_stream=system
    decrease volume and verify    device=device_1    volume_stream=system
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3: [Volume] DUT user to test the volume hard buttons during a call
    [Tags]   306839    bvt_tp    certification_Audio    sanity_tp
    [Setup]  Testcase Setup    count=2
    click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    increase volume and verify    device=device_1    volume_stream=calling
    decrease volume and verify    device=device_1    volume_stream=calling
    ${Cvolume}    current volume level    device=device_1    volume_stream=calling
    set volume to lowest    device=device_1    Cvolume=${Cvolume}    volume_stream=calling
    verify call mute state    device_list=device_1    state=unmute
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC4:[Volume] While in speaker mode, Increase _decrease the volume in P2P call
    [Tags]    306927    certification_audio
    [Setup]    Testcase Setup    count=2
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    press specific hardkey    device=device_1    hard_key=HEADSETHOOK    status=ON
    Verify Call State    device_list=device_1,device_2    state=Connected
    increase volume and verify    device=device_1    volume_stream=calling
    decrease volume and verify    device=device_1    volume_stream=calling
    press specific hardkey    device=device_1    hard_key=SPEAKER    status=ON
    increase volume and verify    device=device_1    volume_stream=calling    
    decrease volume and verify    device=device_1    volume_stream=calling
    press specific hardkey    device=device_1    hard_key=HANDSETHOOK    status=ON
    increase volume and verify    device=device_1    volume_stream=calling
    decrease volume and verify    device=device_1    volume_stream=calling
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    Verify Multiple Intents    device=device_1     features_list=APP_AUDIO_STATE   intents_list=headset_on,speaker_on,handset_on
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC5: [Audio Channel] DUT user to Test Handset Volume after phone reboot
    [Tags]    306925    certification_audio
    [Setup]    Testcase Setup    count=1
    ${Cvolume}    current volume level    device=device_1    volume_stream=system
    reboot phones    device=device_1
    Verify home screen page     device=device_1
    compare volume    device=device_1    volume=${Cvolume}    volume_stream=system    volume_state=constant
    [Teardown]   Run Keywords    Capture on Failure

*** Keywords ***

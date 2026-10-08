*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Esc-to-conf] Far-end user disconnects the call when DUT user is on "Add member" page
    [Tags]  309025      esc_to_cnf      P2  alt_credentials
    [Setup]  Testcase Setup    count=2
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Navigate to add participant page   device_name=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : [Esc to Conf.] DUT user in P2P call with Teams client, adds another Teams client
    [Documentation]  Devices are already signed-in in Suite Setup
    [Tags]  307102    P1  alt_credentials       sanity_tp      bvt_pr
    [Setup]  Testcase Setup    count=3
    Click on calls tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    verify participant list     from_device=device_1      connected_device_list=device_1,device_2,device_3
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    Verify Call State    device_list=device_1,device_3     state=Connected
    verify participant list     from_device=device_1      connected_device_list=device_1,device_3
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC3: [Add participant] Verify user behavior when role changed from attendee to presenter in Group call
    [Tags]      321003      P2
    [Setup]  Testcase Setup     count=3
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Add participant to conversation using display name  from_device=device_2      to_device=device_3
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    verify participant list     from_device=device_1      connected_device_list=device_1,device_2,device_3
    Make an attendee    from_device=device_2       to_device=device_1
    Verify you are an attendee now notification     device=device_1
    Verify add participant button should not visible for attendee    device=device_1
    Make an presenter    from_device=device_2       to_device=device_1
    Verify you are an presenter now notification     device=device_1
    Verify add participant button should visible for presenter    device=device_1
    Disconnect call     device=device_1,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4 : [Esc to Conf.] Verify mute[mic] icon is observed beside the active contact name on the call screen UI.
    [Tags]    340812    sanity_tp
    [Setup]  Testcase Setup     count=3
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    verify participant list     from_device=device_1      connected_device_list=device_1,device_2,device_3
    Mutes the phone call    device=device_1
    Verify Call mute State     device_list=device_1    state=mute
    Verify display name on call toast for mulltiple users   to_device=device_1    from_device=device_2,device_3
    Disconnect call     device=device_1,device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2,device_3






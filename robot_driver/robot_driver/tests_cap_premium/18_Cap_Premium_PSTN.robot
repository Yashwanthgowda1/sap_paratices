*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown      Suite Failure Capture

*** Variables ***
${wait_time} =  10
${wait_time_20s} =  20
${15_minutes_wait_time} =  15 minutes

*** Test Cases ***
TC1: [Advance calling][Outgoing Calls] DUT user calls PSTN user from search icon
    [Tags]     329233     P2
    [Setup]  Testcase Setup for CAP Premium PSTN User    count=2
    click on calls tab    device=device_1
    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Come back to home screen    device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : [Advanced calling] [Outgoing Calls] DUT user calls PSTN user from Dialpad
    [Tags]  329265    BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium PSTN User    count=2
    click on calls tab  device=device_1
    auto dial with valid num from dial pad   from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Come back to home screen    device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC3: [Advanced calling] [Outgoing calls] DUT user to switch between P2P and PSTN call
    [Tags]     329348    P1      Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium PSTN User    count=3
    click on calls tab    device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_3
    Pick incoming call     device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    repeat keyword  3 times  click back      device=device_1
    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call     device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify Call State    device_list=device_3    state=Hold
    resume call from call hold banner  device=device_1
    resume call from call hold banner  device=device_1
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3


TC4 : [Advanced Calling] [Call Transfer] DUT user blind transfer the TDC call to PSTN
    [Tags]   329218    BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium PSTN User   count=3
    click on calls tab    device=device_1
    Make outgoing call using display name  from_device=device_1     to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Blindtransfers the call using phonenumber   from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1     state=Disconnected
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC5 : [Advance calling][Call Park] DUT user to park the PSTN call.
    [Tags]    329279    P1      Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium PSTN User   count=2
    click on calls tab    device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Wait for Some Time    time=${wait_time}
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Come back to home screen   device_list=device_2
    navigate to calls tab   device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    ${call_park_code}=    call park and get the code    device=device_1
    Unpark Call    ${call_park_code}    device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC6: [Advanced calling] [Outgoing Calls] DUT user calls to PSTN user using DID
    [Tags]  329367    P2
    [Setup]  Testcase Setup for CAP Premium PSTN User    count=2
    click on calls tab    device=device_1
    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC7 : [Advanced calling] [Outgoing calls] DUT user to switch between two PSTN call
    [Tags]  329349     P2
    [Setup]  Testcase Setup for CAP Premium 2 PSTN User   count=3
    click on calls tab    device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    come back to home screen    device_list=device_1     disconnect=False
    navigate to calls tab   device=device_1
    Make outgoing call using phonenumber    from_device=device_1      to_device=device_3:pstn_user
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC8: [Advanced calling] [Incoming Calls] DUT user receives call from PSTN user using DID
    [Tags]   329357     P2
    [Setup]  Testcase Setup for CAP Premium PSTN User    count=2
    click on calls tab    device=device_2
    Make outgoing call using phonenumber    from_device=device_2     to_device=device_1:cap_search_enabled
    Verify incoming call   device=device_1      status=appear
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC9 : Verify DUT user is not able to get the call from PSTN user
     [Tags]    416798    P1      Sanity_CAPPremium
     [Setup]   Testcase Setup for CAP Premium PSTN User    count=2
     verify hotline option       device=device_1
     configure contact number in hotline     device=device_1       configured_user=device_2:pstn_user
     verify hotline homescreen UI    device=device_1
     click on calls tab     device=device_2
     Make outgoing call using phonenumber   from_device=device_2     to_device=device_1:cap_search_enabled
     verify any incoming call disappeared    device=device_1
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2    AND   Disable Hotline    device=device_1

TC10 : Verify DUT user not able to initiates the call to PSTN user
     [Tags]    416814   P1     Sanity_CAPPremium
     [Setup]   Testcase Setup for CAP Premium PSTN User    count=2
     verify hotline option       device=device_1
     configure contact number in hotline     device=device_1       configured_user=device_2:pstn_user
     verify hotline homescreen UI    device=device_1
     verify user can not call to anyone when hotline is enabled       device=device_1
     [Teardown]   Run Keywords    Capture on Failure  AND   come back to home screen    device_list=device_1,device_2    AND   Disable Hotline    device=device_1

TC11 : [Touch and Navigation] [Calls] Outgoing call to PSTN when default call's view is set to Dialpad.
    [Tags]   402447    P1     Sanity_CAPPremium
    [Setup]   Testcase Setup for CAP Premium PSTN User   count=2
    Select default view value   device=device_1     option=dialpad
    Validate calls tab after default value change    device=device_1      default_option=dialpad
    go back to previous page     device=device_1
    click on calls tab  device=device_1
    auto dial with valid num from dial pad   from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Select default view value   device=device_1     option=speed dial       AND   Come back to home screen    device_list=device_1,device_2

TC12 : [Touch and Navigation] Outgoing call to PSTN using dial pad from calls tab when default view is set as speed dial.
    [Tags]  402419    BVT_CAPPremium     Sanity_CAPPremium
    [Setup]   Testcase Setup for CAP Premium PSTN User   count=2
    Select default view value   device=device_1     option=speed dial
    Validate calls tab after default value change    device=device_1      default_option=speed dial
    go back to previous page     device=device_1
    navigate to dial pad tab from home screen when call views set to speed dial    device=device_1
    auto dial with valid num from dial pad   from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND   Come back to home screen    device_list=device_1,device_2

TC13 : [Touch and Navigation] [Calls] Outgoing call to PSTN using dial pad When default view is set to recent call history.
    [Tags]  402461   BVT_CAPPremium     Sanity_CAPPremium
    [Setup]   Testcase Setup for CAP Premium PSTN User   count=2
    Select default view value   device=device_1     option=recent call history
    Validate calls tab after default value change    device=device_1      default_option=recent call history
    go back to previous page     device=device_1
    click on calls tab      device=device_1
    auto dial with valid num from dial pad   from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Select default view value   device=device_1     option=speed dial       AND   Come back to home screen    device_list=device_1,device_2

TC14 : DUT user able to receive the voicemail from the PSTN user by tapping on Send to voicemail option in Incoming call UI
    [Tags]      452896      Sanity_CAPPremium           phonesCY23_4
    [Setup]   Testcase Setup for CAP Premium PSTN User   count=2
    click on calls tab  device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    verify incoming call        device=device_1         status=appear
    verify and click send to voicemail option for incoming call          device=device_1
    Verify Call State    device_list=device_2    state=Connected
    Verify Call State    device_list=device_1    state=disconnected
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    Wait for Some Time    time=${wait_time}
    Navigate to voicemail tab    device=device_1
    verify first voicemail displayname  to_device=device_1  from_device=device_2:pstn_user
    Play voicemail    device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2

TC15: [Call forward on home screen] Verify that DUT user call should be forwarded to PSTN user, When DUT user selects Forward to contact or number from the Call forwarding section on home screen.
    [Tags]  452903    Sanity_CAPPremium     phonesCY23_4
    [Setup]   run keywords   Testcase Setup for CAP Premium PSTN User   count=3   AND  call forward on home screen setup     from_device=device_1     to_device=device_2
    verify call forwarding icon     device=device_1
    verify call forwarding option in call forward icon   device=device_1
    verify and set call forwarding on home screen     device=device_1         option=contact_or_number        to_device=device_2:pstn_user
    verify call forwarding status on calling            device=device_1       option=contact_or_number        to_device=device_2:pstn_user
    Click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_3,device_2    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND    Disable Call forward   devices=device_1     AND   Come back to home screen    device_list=device_1,device_2,device_3

TC16 : [Call forward on home screen] Verify that DUT user is able to add the new contact or number from call forwarding section present on home screen.
    [Tags]      452839      P1    Sanity_CAPPremium    phonesCY23_4
    [Setup]      Testcase Setup for CAP Premium PSTN User   count=4
    verify call forwarding option in call forward icon    device=device_1
    verify and set call forwarding on home screen     device=device_1         option=contact_or_number        to_device=device_3
    verify call forwarding status on calling            device=device_1         option=contact_or_number        to_device=device_3
    click on calls tab          device=device_4
    Make outgoing call using display name    from_device=device_4      to_device=device_1:cap_search_enabled
    Verify Incoming call    device=device_1     status=disappear
    Pick incoming call    device=device_3
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_3,device_4    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3,device_4     state=Disconnected
    Verify call entries are synced in call log    from_device=device_1      to_device=device_4      state=forwarded_to
    click on home bar icon          device=device_1
    verify and change the contact on forward to contact or number on home screen    device=device_1    contact_device=device_2:pstn_user
    verify call forwarding status on calling            device=device_1         option=contact_or_number        to_device=device_2:pstn_user
    Make outgoing call using display name     from_device=device_3     to_device=device_1:cap_search_enabled
    Verify Incoming call    device=device_1     status=disappear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_3,device_2    state=Connected
    Wait for Some Time    time=${wait_time}
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    Verify call entries are synced in call log    from_device=device_1      to_device=device_3      state=forwarded_to
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2,device_3,device_4        AND         verify and set call forwarding on home screen      device=device_1         option=off

TC17: DUT user able to send the voicemail by tapping Leave voicemail option in Recent tab
    [Tags]      452875      P0    BVT_CAPPremium     Sanity_CAPPremium    phonesCY23_4
    [Setup]      Testcase Setup for CAP Premium PSTN User   count=3
    click on calls tab  device=device_3
    Make outgoing call using display name    from_device=device_3    to_device=device_1:cap_search_enabled
    pick incoming call      device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    Select call list item   device=device_1     item=leave_voicemail
    verify incoming call        device=device_3        status=disappear
    Wait for Some Time    time=${wait_time_20s}
    Verify Call State    device_list=device_1    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    Wait for Some Time    time=${wait_time}
    click back      device=device_3
    Navigate to voicemail tab    device=device_3
    verify first voicemail displayname  to_device=device_3  from_device=device_1:cap_search_enabled
    Play voicemail    device=device_3
    Make outgoing call using username    from_device=device_1      to_device=device_2:pstn_user
    pick incoming call      device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Select call list item   device=device_1     item=leave_voicemail
    verify incoming call        device=device_2         status=disappear
    Wait for Some Time    time=${wait_time_20s}
    Verify Call State    device_list=device_1    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    Wait for Some Time    time=${wait_time}
    Navigate to voicemail tab    device=device_2
    verify first voicemail displayname  to_device=device_2  from_device=device_1:cap_search_enabled
    Play voicemail    device=device_2
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2,device_3

TC18: [CallTransferEnhancements] consult transfer search screen > place consult call using Dialpad
    [Tags]     456330    BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium PSTN User    count=3
    Click on calls tab   device=device_3
    Make outgoing call using display name   from_device=device_3      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    verify options when click on transfer btn in call UI    device=device_1
    transfer call using dial pad     from_device=device_1   to_device=device_2:pstn_user   option=consult_first
    Pick incoming call    device=device_2
    verify call state     device_list=device_3     state=Hold
    Disconnect call     device=device_2,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC19: [CallTransferEnhancements] blind transfer search screen > transfer using dialpad
    [Tags]   456333    P1
    [Setup]  Testcase Setup for CAP Premium PSTN User    count=3
    click on calls tab   device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    transfer call using dial pad     from_device=device_1   to_device=device_2:pstn_user   option=transfer_now
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2,device_3

TC20 : Verify that 'private line' label present after incoming call
    [Tags]      476432   BVT_CAPPremium     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium PSTN User   count=3
    click on calls tab  device=device_3
    Make outgoing call using privateline number    from_device=device_3      to_device=device_1:cap_search_enabled
    verify privateline label on call screen     device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    navigate to calls tab  device=device_1
    verify privateline on recent tab  device=device_1
    come back to home screen  device_list=device_1
    click on calls tab  device=device_2
    Make outgoing call using privateline number    from_device=device_2      to_device=device_1:cap_search_enabled
    verify privateline label on call screen     device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    navigate to calls tab  device=device_1
    verify privateline on recent tab  device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    come back to home screen  device_list=device_1,device_2,device_3

TC21 : [Multiple Call Banner] DUT user can hold the muted call with the PSTN user
    [Tags]   449056     BVT_CAPPremium     Sanity_CAPPremium
    [Setup]   Testcase Setup for CAP Premium PSTN User    count=2
    click on calls tab    device=device_2
    Make outgoing call using phonenumber    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_1
    Verify Call mute State    device_list=device_1    state=mute
    Wait for Some Time    time=${wait_time}
    Hold the call    device=device_1
    Verify Call State    device_list=device_1     state=Hold
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2


TC22 : [Advance calling][Call Hold] DUT holds the call with PSTN user for 15 and 60 minutes
    [Tags]  448304     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium PSTN User    count=2
    click on calls tab   device=device_1
    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1     state=Hold
    Wait for Some Time    time=${15_minutes_wait_time}
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC23 : [Call Mute] DUT user to mute/unmute itself while in a call with PSTN user
    [Tags]  448308     Sanity_CAPPremium
    [Setup]  Testcase Setup for CAP Premium PSTN User    count=2
    click on calls tab   device=device_1
    Make outgoing call using phonenumber    from_device=device_1     to_device=device_2:pstn_user
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Mutes the phone call    device=device_1
    Verify Call mute State    device_list=device_1    state=mute
    Unmutes the phone call  device=device_1
    Verify Call mute State    device_list=device_1    state=Unmute
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
Advance calling Setup
    Verify and enable advance calling option       device=device_1


Disable Hotline
       [Arguments]     ${device}
       disable hotline option from home screen      ${device}

call forward on home screen setup
    [Arguments]     ${from_device}   ${to_device}
    open settings page      ${from_device}
    open manage delegate page    ${from_device}
    Add new delegate   from_device=${from_device}    to_device=${to_device}
    Come back to home screen     ${from_device}
    navigate to calls tab    ${to_device}
    refresh calls main tab    ${to_device}
    verify display home screen toggle status under calling      ${from_device}       status=on

Disable Call forward
    [Arguments]     ${devices}
    Come back to home screen    device_list=${devices}
    verify and disable call forwarding    device=device_1
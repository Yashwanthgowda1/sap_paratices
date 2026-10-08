#*** Settings ***
#Force Tags    pm_meet_now      pm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#
#*** Test Cases ***
#TC1: [Meet now] Meet now icon should be present on Home screen after Sign-in
#    [Tags]   251517   bvt   bvt_pm
#    [Setup]   Testcase Setup     count=1
#    Validate that signin is successfully completed    device_list=device_1     state=Sign in
#    Verify Meet now icon present on home screen  device=device_1
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1
#
#TC2: [Meet now] DUT user adds TDC user as participant , mute and unmutes during call
#    [Tags]   251525   sanity_pm
#    [Setup]   Testcase Setup     count=2
#    Initiates conference meeting using Meet now option   from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Check video call On state   device_list=device_1,device_2
#    Mutes the phone call    device=device_1
#    Verify meeting Mute State    device_list=device_1    state=mute
#    Unmutes the phone call  device=device_1
#    Verify meeting Mute State    device_list=device_1    state=Unmute
#    End meeting    device=device_2
#    Verify meeting state    device_list=device_1,device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#TC3: [Meet now] Start Meet now and mute all Participants in call
#    [Tags]   251528   P2
#    [Setup]   Testcase Setup     count=3
#    Initiates conference meeting using Meet now option   from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Check video call On state   device_list=device_1,device_2
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    Accept incoming call      device=device_3
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    Close participants screen   device=device_1
#    Mute all participants   device=device_1
#    Verify meeting Mute State    device_list=device_1,device_2,device_3    state=Mute
#    End meeting      device=device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#TC4: [Meet now] Teams Desktop Client to reject the meeting invite call from DUT user
#    [Tags]   251531   P2
#    [Setup]   Testcase Setup     count=3
#    Initiates conference meeting using Meet now option   from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    Reject incoming call   device_list=device_3
#    Close participants screen   device=device_1
#    Verify participants list in meeting     device=device_1
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    End meeting   device=device_2
#    Verify meeting state    device_list=device_1,device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#TC5: [Meet now] DUT user invites TDC user into meeting using DID number
#    [Tags]   251540   P2
#    [Setup]   Testcase Setup     count=3
#    Initiates conference meeting using Meet now option    from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Add participant to conversation using phonenumber   from_device=device_1      to_device=device_3
#    Accept incoming call      device=device_3
#    Verify list of participants     from_device=device_1      connected_device_list=device_1,device_2,device_3
#    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
#    End meeting   device=device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#TC6: [Meet now] Tapping on Meet now icon should initiate a conference call
#    [Tags]   251518   P1
#    [Setup]   Testcase Setup     count=2
#    Initiates conference meeting using Meet now option    from_device=device_1     to_device=device_2
#    verify incoming call  device=device_2    status=appear
#    reject incoming call  device=device_2
#    Disconnect call     device=device_1
#    Verify meeting state    device_list=device_1,device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#TC7: [Meet now] Start Meet now, Increase and decrease volume after participants are added
#    [Tags]   251520   P3
#    [Setup]   Testcase Setup     count=2
#    Initiates conference meeting using Meet now option    from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Check video call On state   device_list=device_1,device_2
#    Adjust volume button   device=device_1   state=UP     functionality=In_meeting
#    Adjust volume button   device=device_1   state=Down   functionality=In_meeting
#    End meeting   device=device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#TC8: [Meet now] Start Meet now, Add Participants to Conference call
#    [Tags]   251519   sanity_pm
#    [Setup]   Testcase Setup     count=2
#    Initiates conference meeting using Meet now option     from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Check video call On state   device_list=device_1,device_2
#    End meeting   device=device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#TC9: [Meet now] DUT user adds TDC user as participant , holds and resumes during call
#    [Tags]   251524   sanity_pm
#    [Setup]   Testcase Setup     count=2
#    Initiates conference meeting using Meet now option    from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Hold the call   device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Hold
#    Resume the call   device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Resume
#    Check video call On state   device_list=device_1,device_2
#    End meeting   device=device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2
#
#TC10: [Meet now] Start Meet now, Remove Participants from call
#    [Tags]   251521   P2
#    [Setup]   Testcase Setup     count=3
#    Initiates conference meeting using Meet now option    from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Check video call On state   device_list=device_1,device_2
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    Accept incoming call      device=device_3
#    Close participants screen   device=device_1
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Connected
#    Remove user from meeting call   from_device=device_1      to_device=device_2
#    Verify someone removed you from the meeting call  device=device_2
#    Close participants screen   device=device_1
#    Verify meeting state    device_list=device_1,device_3    state=Connected
#    End meeting   device=device_3
#    Verify meeting state    device_list=device_1,device_3   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#TC11: [Meet now] Ending the call should redirect Teams App user to homescreen
#    [Tags]   251530   P2
#    [Setup]   Testcase Setup     count=4
#    Initiates conference meeting using Meet now option   from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    Accept incoming call      device=device_3
#    Close participants screen   device=device_1
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_4
#    Accept incoming call      device=device_4
#    Close participants screen   device=device_1
#    Verify meeting state    device_list=device_1,device_2,device_3,device_4    state=Connected
#    Check video call On state   device_list=device_1,device_2,device_3,device_4
#    End meeting   device=device_1
#    Naviagte back to home screen page and validate    device=device_1
#    End meeting   device=device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3,device_4   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3,device_4
#
#TC12: [[Meet now] Verify DUT user is able to on and off the Live caption during the meeting
#    [Tags]   251532   P2
#    [Setup]   Testcase Setup     count=3
#    Initiates conference meeting using Meet now option    from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    Accept incoming call      device=device_3
#    Close participants screen   device=device_1
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Connected
#    Check video call On state   device_list=device_1,device_2,device_3
#    Turn on live captions and validate   device=device_1
#    Turn off live captions and validate  device=device_1
#    End meeting   device=device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#TC13: [Meet now] Start Meet now and Far mute Participants in call
#    [Tags]   251542   sanity_pm
#    [Setup]   Testcase Setup     count=3
#    Initiates conference meeting using Meet now option   from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    Accept incoming call      device=device_3
#    Close participants screen   device=device_1
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Connected
#    Check video call On state   device_list=device_1,device_2,device_3
#    Farmute the call and validate   from_device=device_1     to_device=device_2
#    Verify meeting Mute State    device_list=device_2    state=mute
#    Unmutes the meeting    device=device_2
#    Verify meeting Mute State    device_list=device_2    state=Unmute
#    Close participants screen   device=device_1
#    End meeting   device=device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#TC14: [Meet now]DUT user able to raise /lower hand in the meeting
#    [Tags]   251535   P2
#    [Setup]   Testcase Setup     count=3
#    Initiates conference meeting using Meet now option   from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    Accept incoming call      device=device_3
#    Close participants screen   device=device_1
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Connected
#    Check video call On state   device_list=device_1,device_2,device_3
#    Select raise hand option  device=device_1
#    Verify raise hand notification   device_list=device_2,device_3
#    Select Lower hand option  device=device_1
#    End meeting   device=device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#TC15: [Meet now] Verify DUT user is able to view the Live caption during meeting
#    [Tags]   251537   sanity_pm
#    [Setup]   Testcase Setup     count=3
#    Initiates conference meeting using Meet now option    from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    Accept incoming call      device=device_3
#    Close participants screen   device=device_1
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Connected
#    Check video call On state    device_list=device_1,device_2,device_3
#    Verify live captions visibility   device=device_1
#    End meeting   device=device_2,device_3
#    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown    devices=device_1,device_2,device_3
#
#
#
#
#*** Keywords ***
#Test Case Teardown
#    [Arguments]     ${devices}
#    Come back to home screen     ${devices}
#
#Verify Meet now icon present on home screen
#    [Arguments]     ${device}
#    Verify home page screen     ${device}
#
#Naviagte back to home screen page and validate
#    [Arguments]     ${device}
#    Come back to home screen     ${device}
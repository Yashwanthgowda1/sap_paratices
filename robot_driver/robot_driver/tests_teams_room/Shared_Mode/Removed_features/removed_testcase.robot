#*** Settings ***
#*** Variables ***
#*** Test Cases ***
#TC3:[Call] DUT user invites DUT2 user into Call using DID number
#    [Tags]     444812   P2
#    [Setup]  Testcase Setup for Meeting User     count=2
#    Make outgoing call with phonenumber    from_device=device_1     to_device=device_2
#    Accept incoming call      device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Check video call On state   device_list=device_1,device_2
#    End meeting   device=device_1
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2
#
#TC7:[Stage Layout Switcher] Verify the Together Mode layout with chat panel.
#	[Tags]    444536     P2     sanity_sm
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Enable and Disable the show meeting chat option    device=device_1    state=on
#    Join Meeting    device=device_1,device_2      meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2       state=Connected
#    verify layout switcher ui       device=device_1
#    Dismiss the popup screen        device=device_1
#    verify Content Gallery should be selected   device=device_1     mode=gallery
#    Change meeting mode     device=device_1     mode=together
#    verify together mode after switching       device=device_1
#    Enable and disable the chat toggle in meeting       device=device_1      state=on
#    verify the chat options in meeting       device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen     device_list=device_1,device_2

#TC6:[Stage Layout Switcher] Verify the Large Gallery Layout with chat.
#	[Tags]    444534     P1     sanity_sm
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Enable and Disable the show meeting chat option    device=device_1    state=on
#    Join Meeting    device=device_1,device_2      meeting=cnf_device_meeting
#    Verify meeting state   device_list=device_1,device_2       state=Connected
#    verify layout switcher ui       device=device_1
#    Dismiss the popup screen        device=device_1
#    verify Content Gallery should be selected   device=device_1     mode=gallery
#    Change meeting mode     device=device_1     mode=large_gallery
#    verify large gallery mode after switching       device=device_1
#    Enable and disable the chat toggle in meeting       device=device_1      state=on
#    verify the chat options in meeting       device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2     state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen     device_list=device_1,device_2

#TC13:[DGJ]Mic should be on by default when DUT user joins the meeting
#    [Tags]      32796       P2    exclude_ftp_sm
#    [Setup]  Testcase Setup for Meeting User     count=1
#    Verify meeting display on home screen     device=device_1
#    Join meeting   device=device_1    meeting=zoom_meeting
#    Verify meeting state   device_list=device_1    state=Connected
#    verify mic is unmuted by default in third party meeting       device=device_1
#    End meeting      device=device_1
#    Verify meeting state    device_list=device_1   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1
#TC3: [Report an Issue] Verify that user should be able to get report an issue option on Group call
#    [Tags]   316583  P2     exclude_ftp_sm
#    [Setup]   Testcase Setup for Meeting User    count=4
#    Initiates conference meeting using Meet now option   from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_3
#    Accept incoming call      device=device_3
#    Close participants screen       device=device_1
#    Verify meeting state    device_list=device_1,device_2,device_3    state=Connected
#    Add participant to conversation using display name   from_device=device_1      to_device=device_4
#    Accept incoming call      device=device_4
#    Close participants screen       device=device_1
#    Verify meeting state    device_list=device_1,device_2,device_3,device_4    state=Connected
#    Check video call On state   device_list=device_1,device_2,device_3,device_4
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    report an issue     device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2,device_3,device_4    state=Disconnected
#    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2
#*** Keywords ***

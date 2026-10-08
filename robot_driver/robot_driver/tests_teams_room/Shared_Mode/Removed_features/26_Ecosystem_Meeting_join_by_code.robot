#*** Settings ***
#Resource    ../../resources/keywords/common.robot
#*** Variables ***
#*** Test Cases ***
#TC10:[Join by Code]Verify meeting info option when user join a meeting from "Join with an ID"
#    [Tags]   345110     bvt     bvt_sm      sanity_sm   exclude_ftp_sm
#    [Setup]    Testcase Setup for Meeting User   count=2
#    Join meeting   device=device_2    meeting=lock_meeting
#    Verify meeting state   device_list=device_2    state=Connected
#    join with an meeting id   device=device_1
#    Verify meeting state   device_list=device_1    state=Connected
#    Verify meeting info option in meeting   device=device_1
#    End meeting     device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2    state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC26:Verify meeting info when DUT user joins a meeting from "Meet now"
#    [Tags]      345117         P2    exclude_ftp_sm
#    [Setup]   Testcase Setup for Meeting User     count=2
#    Initiates conference meeting using Meet now option    from_device=device_1     to_device=device_2
#    Accept incoming call    device=device_2
#    Close participants screen   device=device_1
#    Verify meeting state   device_list=device_1,device_2    state=Connected
#    Verify meeting info in meeting   device=device_1
#    Click close btn    device_list=device_1
#    End meeting   device=device_1,device_2
#    Verify meeting state    device_list=device_1,device_2   state=Disconnected
#    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

#*** Keywords ***

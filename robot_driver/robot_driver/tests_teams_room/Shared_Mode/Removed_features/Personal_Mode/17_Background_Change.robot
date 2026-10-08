#*** Settings ***
#Force Tags    background_change     pm
#Documentation   Validating the functionality of background change feature.
#Library     DateTime
#Library     OperatingSystem
#Resource   ../resources/keywords/common.robot
#
#Suite Setup      Background Change Suite Setup
#Suite Teardown   Suite Failure Capture
#
#
#*** Test Cases ***
#TC1: [Background Change] DUT user can change multiple backgrounds during a P2P call
#     [Tags]  229176   bvt  bvt_pm
#     [Setup]    Testcase Setup     count=2
#     Make Video call using display name  from_device=device_2     to_device=device_1
#     Accept incoming call    device=device_1
#     Verify Call State    device_list=device_1,device_2    state=Connected
#     Verify background change under more option   device=device_1
#     Verify background change under more option   device=device_2
#     Choose background change from background options    device=device_1
#     Verify background change reflect for particpants   device=device_2
#     Choose another background from background list   device=device_1
#     Verify background change reflect for particpants    device=device_2
#     Change to default No background screen   device=device_1
#     Verify background change reflect for particpants   device=device_2
#     Disconnect call     device=device_1
#     Verify Call State    device_list=device_1,device_2    state=Disconnected
#     [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC2: [Background Change] DUT user selects a Background Change during a P2P call
#     [Tags]  229168   P1
#     [Setup]  Testcase Setup     count=2
#     Make Video call using display name  from_device=device_2     to_device=device_1
#     Accept incoming call    device=device_1
#     Verify Call State    device_list=device_1,device_2    state=Connected
#     Verify background change under more option   device=device_1
#     Verify background change under more option   device=device_2
#     Choose blur background option     device=device_1
#     Verify background change reflect for particpants   device=device_2
#     Change to default No background screen    device=device_1
#     Disconnect call     device=device_2
#     Verify Call State    device_list=device_1,device_2    state=Disconnected
#     [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC3: [Background Change] All call controls are working as expected after applying a Background
#     [Tags]  229205    P1
#     [Setup]  Testcase Setup     count=2
#     Make Video call using display name  from_device=device_2     to_device=device_1
#     Accept incoming call    device=device_1
#     Verify Call State    device_list=device_1,device_2    state=Connected
#     Verify background change under more option   device=device_1
#     Verify background change under more option   device=device_2
#     Choose background change from background options    device=device_1
#     Verify background change reflect for particpants   device=device_2
#     Mutes the phone call    device=device_1
#     Verify meeting Mute State    device_list=device_1    state=mute
#     Unmutes the phone call  device=device_1
#     Verify meeting Mute State    device_list=device_1    state=Unmute
#     Hold the call   device=device_1
#     Verify Call State    device_list=device_1,device_2     state=Hold
#     Resume the call   device=device_1
#     Verify Call State    device_list=device_1,device_2     state=Resume
#     Change to default No background screen    device=device_1
#     Disconnect call     device=device_2
#     Verify Call State    device_list=device_1,device_2    state=Disconnected
#     [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC4: [Background Change] The selected Background remains as it is when video is turn off/on in DUT during a meeting
#     [Tags]  229209   P1
#     [Setup]  Testcase Setup     count=2
#     Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#     Verify meeting state   device_list=device_1,device_2    state=Connected
#     Verify background change under more option   device=device_1
#     Verify background change under more option   device=device_2
#     Choose background change from background options    device=device_1
#     Disable video call   device=device_1
#     Enable video call  device=device_1
#     Verify selected background      device=device_1
#     Verify background change reflect for particpants   device=device_2
#     Change to default No background screen    device=device_1
#     End meeting     device=device_1,device_2
#     Verify meeting state    device_list=device_1,device_2    state=Disconnected
#     [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC5: [Background Change] DUT user selects a blur background option during a meeting
#     [Tags]  229210   bvt  bvt_pm
#     [Setup]  Testcase Setup     count=2
#     Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#     Verify meeting state   device_list=device_1,device_2    state=Connected
#     Verify background change under more option   device=device_1
#     Verify background change under more option   device=device_2
#     Choose blur background option     device=device_1
#     Verify background change reflect for particpants   device=device_2
#     Change to default No background screen    device=device_1
#     End meeting     device=device_1,device_2
#     Verify meeting state    device_list=device_1,device_2    state=Disconnected
#     [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC6: [Background Change] Rejoin of the same meeting should not change selected background
#     [Tags]  229207   P1
#     [Setup]  Testcase Setup     count=2
#     Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#     Verify meeting state   device_list=device_1,device_2    state=Connected
#     Verify background change under more option   device=device_1
#     Verify background change under more option   device=device_2
#     Choose background change from background options    device=device_1
#     Verify background change reflect for particpants   device=device_2
#     End meeting    device=device_1
#     Come back to home page    device=device_1
#     Join meeting   device=device_1:norden   meeting=cnf_device_meeting
#     Wait for Some Time    time=${wait_time}
#     Verify meeting state   device_list=device_1    state=Connected
#     Verify selected background     device=device_1
#     Change to default No background screen    device=device_1
#     End meeting     device=device_1,device_2
#     Verify meeting state    device_list=device_1,device_2    state=Disconnected
#     [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC7: [Background Change] DUT select background and share whiteboard during meeting
#     [Tags]  229218   P1
#     [Setup]  Testcase Setup     count=2
#     Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#     Verify meeting state   device_list=device_1,device_2    state=Connected
#     Verify background change under more option   device=device_1
#     Verify background change under more option   device=device_2
#     Choose background change from background options   device=device_1
#     Verify background change reflect for particpants   device=device_2
#     Verify whiteboard sharing option under more option   device=device_1
#     Check for whiteboard visibility of participants and validate   from_device=device_1    connected_device_list=device_1,device_2
#     Click back    device=device_1
#     Verify selected background     device=device_1
#     Change to default No background screen    device=device_1
#     End meeting     device=device_1,device_2
#     Verify meeting state    device_list=device_1,device_2    state=Disconnected
#     [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC8 : [Background Change] DUT user Should be displayed with same selected background for multiple meetings
#     [Tags]  229206   P1
#     [Setup]  Testcase Setup     count=2
#     Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#     Verify meeting state   device_list=device_1,device_2    state=Connected
#     Verify background change under more option   device=device_1
#     Verify background change under more option   device=device_2
#     Choose background change from background options   device=device_1
#     Verify background change reflect for particpants   device=device_2
#     End meeting     device=device_1
#     Come back to home page   device=device_1
#     Join meeting   device=device_1:norden   meeting=teams_room_meeting
#     Verify meeting state   device_list=device_1    state=Connected
#     Verify selected background     device=device_1
#     Change to default No background screen    device=device_1
#     End meeting     device=device_1,device_2
#     Verify meeting state    device_list=device_1,device_2    state=Disconnected
#     [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC9: [Background Change] DUT user to join meeting without any selected background
#     [Tags]  229214   P2
#     [Setup]  Testcase Setup     count=2
#     Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#     Verify meeting state   device_list=device_1,device_2    state=Connected
#     Verify background change under more option   device=device_1
#     Verify background change under more option   device=device_2
#     Verify selected background     device=device_1
#     Verify background change reflect for particpants   device=device_2
#     Change to default No background screen    device=device_1
#     End meeting     device=device_1,device_2
#     Verify meeting state    device_list=device_1,device_2    state=Disconnected
#     [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC10: [Background Change] DUT select background and DUT switch to together mode during meeting
#     [Tags]  229219   P2
#     [Setup]  Testcase Setup     count=2
#     Join meeting   device=device_1:norden,device_2:    meeting=cnf_device_meeting
#     Verify meeting state   device_list=device_1,device_2    state=Connected
#     Verify background change under more option   device=device_1
#     Verify background change under more option   device=device_2
#     Choose background change from background options   device=device_1
#     Verify background change reflect for particpants   device=device_2
#     Switch to together mode   device=device_1
#     Switch to gallery mode   device=device_1
#     Verify selected background     device=device_1
#     Verify background change reflect for particpants   device=device_2
#     Change to default No background screen   device=device_1
#     End meeting     device=device_1,device_2
#     Verify meeting state    device_list=device_1,device_2    state=Disconnected
#     [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2
#
#TC11: [Background Change] The selected Background remains as it is when video is turn off/on in DUT during the call
#     [Tags]  229184   P2
#     [Setup]  Testcase Setup     count=2
#     Make Video call using display name  from_device=device_2     to_device=device_1
#     Accept incoming call    device=device_1
#     Verify Call State    device_list=device_1,device_2    state=Connected
#     Verify background change under more option   device=device_1
#     Verify background change under more option   device=device_2
#     Choose background change from background options    device=device_1
#     Verify background change reflect for particpants   device=device_2
#     Disable video call   device=device_1
#     Enable video call  device=device_1
#     Verify selected background      device=device_1
#     Verify background change reflect for particpants   device=device_2
#     Change to default No background screen   device=device_1
#     Disconnect call     device=device_2
#     Verify Call State    device_list=device_1,device_2    state=Disconnected
#     [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC12: [Background Change] The selected Background will be persisted across the call there after, in DUT
#     [Tags]  229188   P2
#     [Setup]  Testcase Setup     count=2
#     Make Video call using display name  from_device=device_2     to_device=device_1
#     Accept incoming call    device=device_1
#     Verify Call State    device_list=device_1,device_2    state=Connected
#     Verify background change under more option   device=device_1
#     Verify background change under more option   device=device_2
#     Choose background change from background options    device=device_1
#     Verify background change reflect for particpants   device=device_2
#     Disconnect call     device=device_2
#     Come back to home screen    device_list=device_1,device_2
#     Make Video call using display name  from_device=device_2     to_device=device_1
#     Accept incoming call    device=device_1
#     Verify Call State    device_list=device_1,device_2    state=Connected
#     Verify selected background      device=device_1
#     Verify background change reflect for particpants   device=device_2
#     Change to default No background screen    device=device_1
#     Disconnect call     device=device_2
#     Verify Call State    device_list=device_1,device_2    state=Disconnected
#     [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC13: [Background Change]DUT user to enable the large gallery and DUT selected background
#     [Tags]  229221   P2
#     [Setup]  Testcase Setup     count=3
#     Join meeting    device=device_1:norden,device_2:,device_3:    meeting=cnf_device_meeting
#     Verify meeting state   device_list=device_1,device_2,device_3   state=Connected
#     Verify background change under more option   device=device_1
#     Verify background change under more option   device=device_2
#     Verify background change under more option   device=device_3
#     Choose background change from background options    device=device_1
#     Verify background change reflect for particpants   device=device_2
#     Verify background change reflect for particpants   device=device_3
#     Switch to large gallery mode    device=device_1
#     Verify selected background      device=device_1
#     Change to default No background screen   device=device_1
#     End meeting     device=device_1,device_2,device_3
#     Verify meeting state    device_list=device_1,device_2,device_3    state=Disconnected
#     [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3
#
#
#
#
#
#
#*** Keywords ***
#Choose No background change option
#     [Arguments]     ${device}
#     Change to default no background option  ${device}
#     Get background effect    ${device}
#     Wait for Some Time    time=10s
#     get_screenshot     name=verify_no_background    device_list=${device}
#Choose background change from background options
#     [Arguments]     ${device}
#     Select background change   ${device}
#     Get background effect    ${device}
#     Wait for Some Time    time=10s
#     get_screenshot     name=verify_teams_beach_background    device_list=${device}
#Choose another background from background list
#     [Arguments]     ${device}
#     Select other background change from options  ${device}
#     Get background effect    ${device}
#     Wait for Some Time    time=10s
#     get_screenshot     name=verify_teams_home_background    device_list=${device}
#
#Verify background change reflect for particpants
#     [Arguments]     ${device}
#     get_screenshot     name=verify_background_change    device_list=${device}
#
#Come back to home page
#     [Arguments]    ${device}
#     Come back to home screen    device_list=${device}
#
#Background Change Suite Setup
#     Background change setup      device=device_1
#     Check for no background option is selected   device=device_1
#
#Background change setup
#     [Arguments]      ${device}
#     Make Video call using display name   from_device=device_2     to_device=device_1
#     Accept incoming call    device=${device}
#     Wait for Some Time    time=${wait_time}
#     Verify call state    device_list=device_1,device_2    state=Connected
#     Disconnect call     device=${device}
#     Verify call state    device_list=device_1,device_2    state=Disconnected
#     Come back to home screen    device_list=device_1,device_2
#
#Check for no background option is selected
#     [Arguments]       ${device}
#     Make Video call using display name   from_device=device_2     to_device=device_1
#     Accept incoming call    device=${device}
#     Wait for Some Time    time=${wait_time}
#     Verify call state    device_list=device_1,device_2    state=Connected
#     Verify background change under more option   device=${device}
#     Select no background option    device=${device}
#     Get background effect    device=${device}
#     Disconnect call     device=${device}
#     Verify call state    device_list=device_1,device_2    state=Disconnected
#     Come back to home screen    device_list=device_1,device_2
#
#
#
#
#

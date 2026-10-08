#*** Settings ***
#Documentation   Landing Page
#Force Tags    pm_landing_page     pm
#Library     DateTime
#Library     OperatingSystem
#Resource    ../resources/keywords/common.robot
#
#
#
#*** Test Cases ***
#TC1: [Landing Page] DUT user view the time, User name of the account , DID on the Landing screen
#    [Tags]   229155  bvt  bvt_pm  sanity_pm
#    [Setup]  Testcase Setup     count=1
#    Validate that signin is successfully completed    device_list=device_1     state=Sign in
#    Verify user details present on landing page   device=device_1
#    [Teardown]   Run Keywords   Capture on Failure   AND    Come back to home screen     device_list=device_1
#
#TC2: [Landing Page] DUT user able to navigate settings via Landing Page
#    [Tags]  229162  P2
#    [Setup]  Testcase Setup     count=1
#    Navigate to more button and validate options  device=device_1
#    Navigate to settings page and verify options  device=device_1
#    [Teardown]   Run Keywords   Capture on Failure  AND   Click back btn  device=device_1  AND  Come back to home screen  device_list=device_1
#
#TC3: [Landing Page] DUT user able navigate "Report an issue " via Landing Screen
#    [Tags]  229171  P2
#    [Setup]  Testcase Setup     count=1
#    Navigate to more button and validate options   device=device_1
#    Navigate to settings page and verify options  device=device_1
#    Report an issue  device=device_1
#    [Teardown]   Run Keywords  Capture on Failure  AND   Click back btn  device=device_1  AND  Come back to home screen  device_list=device_1
#
#TC4: [Landing Page] DUT user able navigate "about" via Landing page
#    [Tags]  229172  P2
#    [Setup]  Testcase Setup     count=1
#    Navigate to more button and validate options   device=device_1
#    Navigate to settings page and verify options  device=device_1
#    Verify About page option  device=device_1
#    [Teardown]   Run Keywords   Capture on Failure  AND   Click back btn  device=device_1  AND  Come back to home screen  device_list=device_1
#
#TC5: [Landing Page] DUT user able navigate "calling" via Landing Page
#    [Tags]  229167  P2
#    [Setup]  Testcase Setup     count=1
#    Navigate to more button and validate options   device=device_1
#    Navigate to settings page and verify options  device=device_1
#    Verify calling settings options   device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND   Test Case Teardown   device=device_1
#
#TC6: [Landing Page]DUT user able to view dial-pad on Landing screen
#    [Tags]  229156    P2
#    [Setup]  Testcase Setup     count=2
#    Verify dial pad present on landing page   device=device_1
#    Dial number from dial pad     from_device=device_1      to_device=device_2
#    Accept incoming call   device=device_2
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen   device_list=device_1,device_2
#
#TC7: [Landing Page] DUT user is able to navigate "Sign out" via Landing page
#    [Tags]  229177    P2
#    [Setup]  Testcase Setup     count=1
#    Navigate to more button and validate options   device=device_1
#    Validate different options inside settings page   device=device_1
#    Sign out method    device=device_1
#    Sign in method     device=device_1
#    Verify more option present on home screen    device=device_1
#    [Teardown]  Run Keywords    Capture on Failure   AND   Come back to home screen   device_list=device_1
#
#TC8: [Landing Page] Verify the home screen of the DUT when there are no meetings
#    [Tags]  229186    bvt   bvt_pm
#    [Setup]  Testcase Setup     count=1
#    Verify home page screen     device=device_1
#    Verify no meeting schedule on landing page    device=device_1
#    [Teardown]   Run Keywords   Capture on Failure  AND   Come back to home screen     device_list=device_1
#
#TC9: [Landing Page] All-day meeting should be display in landing page
#    [Tags]  229193    P2
#    [Setup]  Testcase Setup     count=1
#    Verify home page screen     device=device_1
#    Tap on all day meetings title bar and validate  device=device_1
#    [Teardown]  Run Keywords   Capture on Failure   AND   Navigate back to meetings   device=device_1  AND   Come back to home screen    device_list=device_1
#
#TC10: [Landing Page] All-day meetings list should be display after tapping on the All-day title bar
#    [Tags]  229195    P2
#    [Setup]  Testcase Setup     count=1
#    Verify home page screen     device=device_1
#    Tap on all day meetings title bar and validate   device=device_1
#    Get meetings details present under all day title bar   device=device_1
#    [Teardown]  Run Keywords   Capture on Failure   AND   Navigate back to meetings   device=device_1   AND   Come back to home screen    device_list=device_1
#
#TC11: [Landing Page] DUT should navigate back to meetings when DUT user tap on All-day meeting title bar
#    [Tags]  229197    P2
#    [Setup]  Testcase Setup     count=1
#    Tap on all day meetings title bar and validate   device=device_1
#    Get meetings details present under all day title bar   device=device_1
#    Navigate back to meetings   device=device_1
#    [Teardown]   Run Keywords   Capture on Failure  AND  Come back to home screen     device_list=device_1
#
#TC12: [Landing Page] All-day meetings should be displayed with highlighted background
#    [Tags]  229196    P2
#    [Setup]  Testcase Setup     count=1
#    Verify background display of all day meetings    device=device_1
#    [Teardown]  Run Keywords   Capture on Failure  AND   Navigate back to meetings   device=device_1  AND   Come back to home screen    device_list=device_1
#
#TC13: [Landing Page] DUT user to view and able start meeting using Meet now
#    [Tags]    229157   P2
#    [Setup]  Testcase Setup      count=2
#    Initiates conference meeting using Meet now option   from_device=device_1     to_device=device_2
#    Reject incoming call      device_list=device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2
#
#TC14: [Landing Page] DUT user to verify incoming video call
#    [Tags]   229180   P2
#    [Setup]  Testcase Setup     count=2
#    Make Video call using display name   from_device=device_2     to_device=device_1
#    Accept incoming call      device=device_1
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Verify participants list during call      device=device_1
#    Disconnect call      device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1,device_2
#
#TC15: [Landing Page] DUT user rejects the incoming call from Teams Desktop Client
#    [Tags]   229181   P2
#    [Setup]  Testcase Setup     count=2
#    Verify home page screen     device=device_1
#    Make outgoing call with phonenumber    from_device=device_2     to_device=device_1
#    Reject incoming call     device_list=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1,device_2
#
#TC16: [Landing Page] Verify Highlighted background , Teams Icon , Join button for current meeting
#    [Tags]   229189   bvt   bvt_pm
#    [Setup]  Testcase Setup     count=1
#    Verify default option present on landing page and validate   device=device_1
#    View current meeting display on screen    device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen   device_list=device_1
#
#TC17: [Landing Page] DUT user able to increase and decrease the volume on landing page using more button
#    [Tags]   229158   P2
#    [Setup]  Testcase Setup     count=1
#    Navigate to more option   device=device_1
#    Adjust volume button  device=device_1   state=UP
#    Adjust volume button  device=device_1   state=Down
#    [Teardown]   Run Keywords    Capture on Failure  AND    Navigate back to home screen page  device=device_1
#
#TC18: [Landing Page] DUT user able enable or disable the Proximity Join via Landing Page
#    [Tags]  229165  P2
#    [Setup]  Testcase Setup     count=1
#    Navigate to more button and validate options   device=device_1
#    Navigate to settings page and verify options  device=device_1
#    Tap on meetings page and validate options   device=device_1
#    Disable proximity join button  device=device_1
#    Enable proximity join button   device=device_1
#    [Teardown]   Run Keywords   Capture on Failure  AND   Landing Page Teardown   device=device_1
#
##TC19: [Landing Page] DUT user able navigate "Manage devices" via Landing page
##    [Documentation]  Validate only option present under manage devices
##    [Tags]  229169  P2
##    [Setup]  Testcase Setup     count=1
##    Navigate to more button and validate options   device=device_1
##    Navigate to settings page and verify options    device=device_1
##    Tap on manage devices option and validate   device=device_1
##    [Teardown]   Run Keywords   Capture on Failure  AND   Landing Page Teardown   device=device_1
#
##TC20: [Landing Page] Further meeting should not be having Teams Icon
##    [Tags]  229192    P2
##    [Setup]  Testcase Setup     count=1
##    Verify meeting display on home screen     device=device_1
##    Verify home page screen     device=device_1
##    Teams icon visibility for future meetings  device=device_1
##    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1
##
##TC21: [Landing Page] All-day meeting tittle should be hided when there are no All-day meetings
##    [Tags]  229194    P2
##    [Setup]  Testcase Setup     count=1
##    Verify home page screen     device=device_1
##    Verify all day meetings on screen    device=device_1
##    [Teardown]   Run Keywords   Capture on Failure  AND  Come back to home screen     device_list=device_1
##
#
#
#*** Keywords ***
#Landing Page Teardown
#    [Arguments]     ${device}
#    Click back btn   ${device}
#    Click close btn    device_list=${device}
#    Come back to home screen    device_list=${device}
#
#Test Case Teardown
#    [Arguments]     ${device}
#    Click back btn   ${device}
#    Click close btn    device_list=${device}
#    Come back to home screen    device_list=${device}
#
#Verify default option present on landing page and validate
#    [Arguments]     ${device}
#    Verify home page screen    ${device}
#
#Navigate to more option
#    [Arguments]     ${device}
#    Click on more option   ${device}
#
#Navigate back to home screen page
#     [Arguments]     ${device}
#     Click on settings page    ${device}
#     Click close btn    device_list=${device}
#     Come back to home screen    device_list=${device}
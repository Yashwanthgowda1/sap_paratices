*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10
${5m_wait_time} =  5 minutes

*** Test Cases ***
TC1 : [Auto Dismiss] Rating screen should be dismiss automatically if the user not submit the rating within 5 seconds
    [Tags]   261861     P0
    [Setup]  Testcase Setup for CAP User    count=2
    click on calls tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Wait for Some Time    time=${5m_wait_time}
    Disconnect call and verify call rating screen     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : [Auto Dismiss] Verify call decline screen auto dismiss within 5 seconds
    [Tags]   261863     P1   sanity_cap
    [Setup]   Run Keywords    Testcase Setup for CAP User   count=2    AND    Disable unanswered call    device=device_2      contact_device=device_1
    click on people tab   device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Rejects the incoming call   device_list=device_2
    Verify call decline screen  device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

# Implementation change: Test case in test plan in modified.
#TC3: [Auto Dismiss] Verify call cancelled screen auto dismiss with 5 seconds
#    [Tags]      261865    P2
#    [Setup]  Testcase Setup for CAP User      count=2
#    Make outgoing call using display name   from_device=device_1     to_device=device_2
#    Verify call cancelled screen autodismiss   device=device_1
#    [Teardown]    Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2

TC3 : [Auto Dismiss] Verify that “Dismiss Rate My Call” option with toggle is present in "User survey settings".
    [Tags]   320207    P2
    [Setup]  Testcase Setup for CAP User   count=1
    navigate to user survey     device=device_1
    verify dismiss rate my call toggle    device=device_1       toggle=off
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC4 : [Auto Dismiss] Verify that rate my call screen should appear if “Dismiss Rate My Call” Toggle is ON".
    [Tags]   320212    P2
    [Setup]  Testcase Setup for CAP User   count=2
    enable dismiss rate my call toggle   device=device_1
    verify dismiss rate my call toggle    device=device_1       toggle=on
    return to home screen    device_list=device_1
    click on people tab    device=device_1
    make outgoing call using display name   from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call rating screen after disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2       AND     disable dismiss rate my call toggle    device=device_1

TC5 :[Auto Dismiss] Verify that rate my call screen should not appear if “Dismiss Rate My Call” Toggle is OFF .
    [Tags]   320217    P2
    [Setup]   Testcase Setup for CAP User    count=2
    disable dismiss rate my call toggle   device=device_1
    verify dismiss rate my call toggle    device=device_1       toggle=off
    return to home screen    device_list=device_1
    click on people tab    device=device_1
    make outgoing call using display name   from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call rating screen after disconnect call     device=device_1     status=disappear
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC6 : [Auto Dismiss] Verify selected Dismiss Rate My Call options should not get changed when tap on back button on call setting page.
    [Tags]   320225    P2
    [Setup]  Testcase Setup for CAP User    count=1
    enable dismiss rate my call toggle   device=device_1
    verify dismiss rate my call toggle    device=device_1       toggle=on
    click back  device=device_1
    navigate to user survey     device=device_1
    verify dismiss rate my call toggle    device=device_1       toggle=on
    [Teardown]   Run Keywords    Capture on Failure     AND    Come back to home screen    device_list=device_1       AND     disable dismiss rate my call toggle    device=device_1

TC7 : [Auto Dismiss] Verify "Dismiss Rate My Call" toggle is turned ON/OFF
    [Tags]   320237    P2
    [Setup]   Testcase Setup for CAP User    count=1
    navigate to user survey        device=device_1
    click on dismiss rate my call option toggle     device=device_1
    verify dismiss rate my call toggle    device=device_1       toggle=on
    [Teardown]   Run Keywords    Capture on Failure     AND    Come back to home screen    device_list=device_1       AND     disable dismiss rate my call toggle    device=device_1

*** Keywords ***

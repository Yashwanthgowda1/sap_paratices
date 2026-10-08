*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown      Suite Failure Capture

*** Variables ***

*** Test Cases ***
TC1 : [Emergency Calling] DUT to auto dial the emergency number once the number is recognised as an emergency number
    # Dial 933 for Emergency Calling
    [Tags]  149412    P1    bvt_cap  sanity_cap        Certification_cap
    [Setup]  Testcase Setup for CAP User    count=1
    navigate to dial pad tab for cap    device=device_1
    Dial emergency num and validate    device=device_1
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC2 : [Emergency Calling] Emergency number dialled is recognised as an Emergency call and appropriate notification is displayed in the call screen.
    # Dial 933 for Emergency Calling
    [Tags]  149404   P1     sanity_cap        Certification_cap
    [Setup]  Testcase Setup for CAP User    count=1
    navigate to dial pad tab for cap    device=device_1
    Dial emergency num and validate    device=device_1
    Validate notification displayed on the screen     device=device_1:cap_search_enabled
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC3 : [Emergency Calling] DUT user does not have the option to transfer the emergency call to any other user or number.
    # Dial 933 for Emergency Calling
    [Tags]  149410   P2
    [Setup]  Testcase Setup for CAP User    count=1
    navigate to dial pad tab for cap    device=device_1
    Dial emergency num and validate    device=device_1
    Validate Transfer for Emergency Calling     device=device_1
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC4 : [New Testcase][Emergency Calling] DUT should not have call parking option for Emergency calls.
    # Dial 933 for Emergency Calling
    [Tags]  150145   P2
    [Setup]  Testcase Setup for CAP User    count=1
    navigate to dial pad tab for cap    device=device_1
    Dial emergency num and validate    device=device_1
    Validate Call Park for Emergency Calling     device=device_1
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC5 : [E911] Verify E911 call support
    [Tags]  150083     P2  bvt_cap   sanity_cap        Certification_cap
    [Setup]  Testcase Setup for CAP User    count=1
    navigate to dial pad tab for cap    device=device_1
    Dial emergency num and validate    device=device_1
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC6 : [E911] Sign in to make an emergency call
    [Tags]  150087  P2
    [Setup]  Testcase Setup for CAP User    count=1
    sign out method    device_1
    Verify sign in to make an emergency call    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND     sign in method     device_1     user=cap_search_enabled

TC7 : [Emergency Calling] Verify that user can receive another call during emergency call
    [Tags]   318844   P2
    [Setup]  Testcase Setup for CAP User    count=2
    navigate to dial pad tab for cap    device=device_1
    Dial emergency num and validate    device=device_1
    click on calls tab     device=device_2
    Make outgoing call using display name   from_device=device_2     to_device=device_1:cap_search_enabled
    verify incoming call    device=device_1     status=appear
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    verify call state and disconnect        device=device_1,device_2
    [Teardown]  Run Keywords   Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2

*** Keywords ***

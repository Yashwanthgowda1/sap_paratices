*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***
${3m_wait_time} =      3 minutes

*** Test Cases ***
TC1 : [Presence] Presence changes to "In a call" from available when the user makes and disconnects a call
    [Tags]  149100    P1     sanity_cap        Certification_cap
    [Setup]  Testcase Setup for CAP User    count=2
    Select user presence   device=device_1:cap_search_enabled     state=Available
    Verify user presence   device=device_1     state=Available
    click on people tab     device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Wait for Some Time    time=${3m_wait_time}
    Verify user presence from other user    from_device=device_2      to_device=device_1:cap_search_enabled     state=In call
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Wait for Some Time    time=${3m_wait_time}
    Verify user presence from other user    from_device=device_2      to_device=device_1:cap_search_enabled     state=Available
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2 : [Presence] User can view the self presence in the form of Presence icon on the hamburger menu
    [Tags]  149103   P1    bvt_cap   sanity_cap        Certification_cap
    [Setup]  Testcase Setup for CAP User    count=1
    Verify user presence   device=device_1     state=Available
    [Teardown]   run keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC3 : [Presence] CAP user check the presence of another user
    [Tags]  321230   P3
    [Setup]  Testcase Setup for CAP User    count=2
    Verify user presence from other user    from_device=device_1      to_device=device_2     state=Available
    [Teardown]   run keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

*** Keywords ***

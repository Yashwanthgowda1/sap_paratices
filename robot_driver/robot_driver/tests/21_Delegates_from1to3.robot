*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation      Suite Setup Requirements : This suite requires minimum of 3 devices in config
...                Purpose: Device_1 should add Device_2:delegate_user & Device_3 as Delegates.

Suite Setup    Delegates Suite Setup
Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =      5

*** Test Cases ***
TC1 : [OBO] DUT user to add multiple users as delegates.
    [Tags]    309343     P2  alt_blocked
    [Setup]    Testcase Setup for Delegate User  count=3
    ${is_delegate_present} =     Verify delegates in favorites page     device=device_1
    Run keyword if     '${is_delegate_present}'=='True'    Log    Delegate has been added for user
    ...    ELSE    FAIL    Couldn't find expected delegate on device
    verify added delegate user with presence in favorites page      from_device=device_1    to_device=device_2:delegate_user
    verify added delegate user with presence in favorites page      from_device=device_1    to_device=device_3
    [Teardown]  run keywords  Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2,device_3

TC2 : [SLA] Verify that DUT user should display all the Boss's in a list under people you support section in Favorites tab.
    [Tags]      416766      P1
    [Setup]  Testcase Setup for Delegate User  count=3
    ${is_delegate_present} =     Verify delegates in favorites page     device=device_1
    Run keyword if     '${is_delegate_present}'=='True'    Log    Delegate has been added for user
    ...    ELSE    FAIL    Couldn't find expected delegate on device
    verify added delegate user with presence in favorites page      from_device=device_1    to_device=device_2:delegate_user
    verify added delegate user with presence in favorites page      from_device=device_1    to_device=device_3
    [Teardown]   Run Keywords    Capture on Failure     AND      come back home screen for user   count=3

TC3 : [OBO] TDC user adds DUT user as delegate with both Make and receive call permission
    [Tags]  308672   sanity_tp            bvt_pr         alt_blocked      Certification_audio
    [Setup]    Testcase Setup for Delegate User   count=3
    Edit added delegates with both permission and validate   from_device=device_1    to_device=device_3
    Refresh page for delegate user config changes visibility    device=device_3
    Initiate OBO call using display name    from_device=device_3      to_device=device_2:delegate_user    obo_option=myself
    Verify calling behalf of device text    device=device_3   to_device=device_2:delegate_user     from_device=myself
    Verify Incoming call    device=device_2     status=appear
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    Make outgoing call using display name    from_device=device_2      to_device=device_3
    Verify Incoming call    device=device_3     status=appear
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_3     state=Disconnected
    [Teardown]  run keywords  Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC4 :[Call forward on home screen] Verify that DUT user call should be forwarded to delegates, When DUT user selects Forward to my delegates from the Call forwarding section on Home screen.
    [Tags]      452097          phonesCY23_4        sanity_tp        bvt_pr
    [Setup]  run keywords       Testcase Setup for Delegate User   count=4     AND    enable call forwarding display on home screen         device=device_1
    verify and set call forwarding on home screen     device=device_1         option=delegate           to_device=device_2:delegate_user
    Click on calls tab      device=device_4
    Make outgoing call using display name    from_device=device_4      to_device=device_1
    Verify incoming call    device=device_2     status=appear
    Verify incoming call    device=device_3     status=appear
    Pick incoming call   device=device_2
    Verify incoming call    device=device_3     status=disappear
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_2,device_4    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2,device_4     state=Disconnected
    Verify call entries are synced in call log    from_device=device_1      to_device=device_4      state=forwarded_to
    [Teardown]  run keywords  Capture on Failure    AND    Come back to home screen   device_list=device_1,device_2,device_3,device_4    AND    verify and disable call forwarding     device=device_1

TC5 : [OBO] Verify that the DUT user 1 adds the DUT user 2 as a delegate with permissions to make calls only and to receive calls only.
    [Tags]    309353    P2
    [Setup]    Testcase Setup    count=3    
    Add New Delegates With Make Call Permission And Validate    from_device=device_1    to_device=device_2
    Initiate OBO call using display name    from_device=device_2     to_device=device_3     obo_option=device_1
    Verify calling behalf of device text    device=device_2    to_device=device_3    from_device=device_1
    Verify On behalf of call text    device=device_3    from_device=device_2    obo_user=device_1
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect Call    device=device_2
    Verify Call State    device_list=device_1,device_3,device_2    state=disConnected
    Come Back To Home Screen    device_list=device_2
    Edit Added Delegates With Receive Call Permission And Validate    from_device=device_1    to_device=device_2
    Initiate OBO call using display name    from_device=device_2     to_device=device_3     obo_option=device_1
    Verify Incoming Call    device=device_3    status=disappear
    Verify Call State    device_list=device_1,device_2    state=disconnected
    [Teardown]    Run Keywords    Capture On Failure       AND    Delete Delegate From Manage Delegate    from_device=device_1    to_device=device_2    AND    Come Back To Home Screen    device_list=device_1,device_2,device_3
 
*** Keywords ***
Delegates Suite Setup
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_2:delegate_user
    Add new delegates with both permission and validate   from_device=device_1    to_device=device_3
    ${is_delegate_present} =     Verify delegates in favorites page     device=device_1
    Run keyword if     '${is_delegate_present}'=='True'    Log    Delegate has been added for user
    ...    ELSE    FAIL    Couldn't find expected delegate on device
    return to home screen     device_list=device_1

enable call forwarding display on home screen
    [Arguments]     ${device}
    verify and change toggle status for call forwarding display on home screen    device=${device}      status=on
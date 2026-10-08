*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Setup    Run Keywords    Suite Setup    AND    adding delegates
Suite Teardown    Run Keywords    Suite Failure Capture    AND    Suite Teardown    AND    deleting delegates

*** Test Cases ***
TC1 : Verify DUT user able to assign the linekey user from the Suggested contacts and Reassign,Unassign the linekey user after assigning under the Speed dial option.
    [Tags]    557746    bvt_tp    sanity_tp
    [Setup]    Testcase Setup    count=2
    Verify line keys new badge    device=device_1    option=appear
    Verify and click line keys app in more tab    device=device_1
    Verify and click assign line key inside line keys app    device=device_1
    Verify and click assign line key option in assign line key    device=device_1
    verify and click speed dial option in assign line key option    device=device_1
    assign default suggested contact in line keys    device=device_1    to_device=device_2
    click on assigned line key with speed dial    device=device_1
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    long press on assigned username    device=device_1
    click on reassign line key option    device=device_1
    verify and click speed dial option in assign line key option    device=device_1
    assign default suggested contact in line keys    device=device_1    to_device=device_2
    long press on assigned username    device=device_1
    device setting back     device=device_1
    click on unassign line key option    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    testcase teardown    device=device_1    AND   Come back to home screen    device_list=device_1,device_2

TC2 : Verify DUT user able to assign the linekey user from the Search icon and Reassign,Unassign the linekey user after assigning under the Speed dial option.
    [Tags]    557747
    [Setup]    Testcase Setup    count=2
    Verify line keys new badge    device=device_1
    Verify and click line keys app in more tab    device=device_1
    Verify and click assign line key inside Line keys app    device=device_1
    Verify and click assign line key option in assign Line key    device=device_1
    verify and click speed dial option in assign line key option    device=device_1
    assign username in line keys    device=device_1    to_device=device_2
    click on assigned line key with speed dial    device=device_1
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    long press on assigned username    device=device_1
    click on reassign line key option    device=device_1
    verify and click speed dial option in assign Line key option    device=device_1
    assign username in line keys    device=device_1    to_device=device_2
    long press on assigned username    device=device_1
    device setting back     device=device_1
    click on unassign line key option    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    testcase teardown    device=device_1    AND   Come back to home screen    device_list=device_1,device_2

TC3 : Verify DUT user able to assign the linekey user from the Dialpad and Reassign,Unassign the linekey user after assigning under the Speed dial option.
    [Tags]    557748    sanity_tp
    [Setup]    Testcase Setup    count=2
    Verify line keys new badge    device=device_1
    Verify and click line keys app in more tab    device=device_1
    Verify and click assign Line key inside line keys app    device=device_1
    Verify and click assign Line key option in assign line key    device=device_1
    verify and click speed dial option in assign line key option    device=device_1
    click on dial pad in speed dial option    device=device_1    to_device=device_2
    click on assigned line key with speed dial    device=device_1
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    long press on assigned username    device=device_1
    click on reassign line key option    device=device_1
    verify and click speed dial option in assign line key option    device=device_1
    click on dial pad in speed dial option    device=device_1    to_device=device_2
    long press on assigned username    device=device_1
    device setting back     device=device_1
    click on unassign line key option    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    testcase teardown    device=device_1    AND   Come back to home screen    device_list=device_1,device_2

TC4 : Verify DUT user able to assign the linekey user from the Suggested contacts and Reassign,Unassign the linekey user after assigning under the Transfer option.
    [Tags]    557749
    [Setup]    Testcase Setup    count=1
    Verify line keys new badge    device=device_1
    Verify and click Line keys app in more tab    device=device_1
    Verify and click assign line key inside line keys app    device=device_1
    Verify and click assign line key option in assign line key    device=device_1
    verify and click on transfer option in assign line key option    device=device_1
    assign default suggested contact in line keys    device=device_1    to_device=device_2
    long press on assigned username    device=device_1
    click on reassign line key option    device=device_1
    verify and click on transfer option in assign line key option    device=device_1
    assign default suggested contact in line keys    device=device_1    to_device=device_2
    long press on assigned username    device=device_1
    device setting back     device=device_1
    click on unassign line key option    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    testcase teardown    device=device_1    AND   Come back to home screen    device_list=device_1


TC5: Verify DUT should display all the CQ names added DUT user as agent when DUT user tap on assign a linekey from queues option
    [Tags]    557813
    [Setup]    Testcase Setup    count=1
    Verify and click Line keys app in more tab    device=device_1
    Verify and click assign line key inside line keys app    device=device_1
    Verify and click assign line key option in assign line key    device=device_1
    verify_and_add_user_to_queue_in_linekey     device=device_1
    assing_queue_agent_to_linekey   device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND    testcase teardown    device=device_1    AND   Come back to home screen    device_list=device_1,device_2

TC6: Verify DUT should Display all the previously aasigned linekey users in respective linekeY Slot once after sign out and sigN with the Same account
    [Tags]    557816        sanity_tp       bvt_tp
    [Setup]    Testcase Setup    count=1
    Verify and click Line keys app in more tab    device=device_1
    Verify and click assign line key inside line keys app    device=device_1
    Verify and click assign line key option in assign line key    device=device_1
    verify_and_add_user_to_queue_in_linekey     device=device_1
    assing_queue_agent_to_linekey   device=device_1
    Sign out method    device_1
    Wait for Some Time    time=150s
    Sign in method     device_1
    Verify and click Line keys app in more tab    device=device_1
    assing_queue_agent_to_linekey   device=device_1
    verify_assigned_queue_user_remains_same_position        device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND    testcase teardown    device=device_1    AND   Come back to home screen    device_list=device_1

TC7: Verify DUT should display No incoming call message when user taps on the CQ name in linekey app
    [Tags]    557814    sanity_tp   tp_audio
    [Setup]    Testcase Setup    count=1
    Verify and click Line keys app in more tab    device=device_1
    Verify and click assign line key inside line keys app    device=device_1
    Verify and click assign line key option in assign line key    device=device_1
    verify and add user to queue in linekey     device=device_1
    assing queue agent to linekey   device=device_1
    click assigned user on line key and verify    device=device_1
    verify assigned queue user remains same position        device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND    testcase teardown    device=device_1    AND   Come back to home screen    device_list=device_1


TC8: Verify DUT user able to delete the assigned line key user from the speed dial option in the Manage Line key page
    [Tags]    557815
    [Setup]    Testcase Setup    count=1
    Verify and click Line keys app in more tab    device=device_1
    Verify and click assign line key inside line keys app    device=device_1
    verify_and_add_user_manage_line_keys    device=device_1
    verify and add user to queue in linekey     device=device_1
    verify_add_queue_agent_in_manage_sections       device=device_1
    device setting back     device=device_1
    Verify and click assign line key inside line keys app    device=device_1
    Verify and click assign line key option in assign line key    device=device_1
    verify_and_add_user_to_queue_in_linekey     device=device_1
    assing_queue_agent_to_linekey   device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND    testcase teardown    device=device_1     AND   Come back to home screen    device_list=device_1

TC9: Verify DUT user able to assign the linekey user from manage line keys and Reassign,Unassign the linekey user after assigning under the transfer
    [Tags]    557818
    [Setup]    Testcase Setup    count=1
    Verify and click Line keys app in more tab    device=device_1
    Verify and click assign line key inside line keys app    device=device_1
    verify_and_add_user_manage_line_keys    device=device_1
    verify and click on transfer option in assign line key option    device=device_1
    assign default suggested contact in line keys    device=device_1    to_device=device_2      manage_line_key=on
    long press on assigned username    device=device_1
    click on reassign line key option    device=device_1
    verify and click on transfer option in assign line key option    device=device_1
    assign default suggested contact in line keys    device=device_1    to_device=device_2
    long press on assigned username    device=device_1
    device setting back     device=device_1
    click on unassign line key option    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND    testcase teardown    device=device_1    AND   Come back to home screen    device_list=device_1

TC10 : Verify DUT user able to assign the linekey user from the Search icon and Reassign,Unassign the linekey user after assigning under the Transfer option.
    [Tags]    557750    sanity_tp    bvt_tp
    [Setup]    Testcase Setup    count=2
    Verify and click Line keys app in more tab    device=device_1
    Verify and click assign Line key inside Line keys app    device=device_1
    Verify and click assign Line key option in assign Line key    device=device_1
    verify and click on Transfer option in assign line key option    device=device_1
    assign username in line keys    device=device_1    to_device=device_2
    long press on assigned username    device=device_1
    click on Reassign line key option    device=device_1
    verify and click on Transfer option in assign line key option    device=device_1
    assign username in line keys    device=device_1    to_device=device_2
    long press on assigned username    device=device_1
    device setting back     device=device_1
    click on Unassign line key option    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    testcase teardown    device=device_1    AND   Come back to home screen    device_list=device_1,device_2

TC11 : Verify DUT user able to assign the linekey user from the Dialpad and Reassign,Unassign the linekey user after assigning under the Transfer option.
    [Tags]    557756    sanity_tp
    [Setup]    Testcase Setup    count=2
    Verify and click Line keys app in more tab    device=device_1
    Verify and click assign Line key inside Line keys app    device=device_1
    Verify and click assign Line key option in assign Line key    device=device_1
    verify and click on Transfer option in assign line key option    device=device_1
    click on dial pad in transfer option    device=device_1    to_device=device_2
    long press on assigned username    device=device_1
    click on Reassign line key option    device=device_1
    verify and click on Transfer option in assign line key option    device=device_1
    click on dial pad in transfer option    device=device_1    to_device=device_2
    long press on assigned username    device=device_1
    device setting back     device=device_1
    click on Unassign line key option    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    testcase teardown    device=device_1    AND   Come back to home screen    device_list=device_1,device_2

TC12 : Verify DUT user able to assign the linekey user from the Suggested contacts and Reassign,Unassign the linekey user after assigning under the Consult Transfer option.
    [Tags]    557776
    [Setup]    Testcase Setup    count=2
    Verify and click Line keys app in more tab    device=device_1
    Verify and click assign Line key inside Line keys app    device=device_1
    Verify and click assign Line key option in assign Line key    device=device_1
    verify and click on Consult Transfer option in assign line key option    device=device_1
    assign default Suggested contact in line keys    device=device_1    to_device=device_2
    long press on assigned username    device=device_1
    click on Reassign line key option    device=device_1
    verify and click on Consult Transfer option in assign line key option    device=device_1
    assign default Suggested contact in line keys    device=device_1    to_device=device_2
    long press on assigned username    device=device_1
    device setting back     device=device_1
    click on Unassign line key option    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    testcase teardown    device=device_1    AND   Come back to home screen    device_list=device_1,device_2

TC13 : Verify DUT user able to assign the linekey user from the Search icon and Reassign,Unassign the linekey user after assigning under the Consult Transfer option.
    [Tags]    557777    sanity_tp
    [Setup]    Testcase Setup    count=2
    Verify and click Line keys app in more tab    device=device_1
    Verify and click assign Line key inside Line keys app    device=device_1
    Verify and click assign Line key option in assign Line key    device=device_1
    verify and click on Consult Transfer option in assign line key option    device=device_1
    assign username in line keys    device=device_1    to_device=device_2
    long press on assigned username    device=device_1
    click on Reassign line key option    device=device_1
    verify and click on Consult Transfer option in assign line key option    device=device_1
    assign username in line keys    device=device_1    to_device=device_2
    long press on assigned username    device=device_1
    device setting back     device=device_1
    click on Unassign line key option    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    testcase teardown    device=device_1    AND   Come back to home screen    device_list=device_1,device_2

TC14 : Verify DUT user able to assign the linekey user from the Dialpad and Reassign,Unassign the linekey user after assigning under the Consult Transfer option.
    [Tags]    557778    sanity_tp    bvt_tp
    [Setup]    Testcase Setup    count=2
    Verify and click Line keys app in more tab    device=device_1
    Verify and click assign Line key inside Line keys app    device=device_1
    Verify and click assign Line key option in assign Line key    device=device_1
    verify and click on Consult Transfer option in assign line key option    device=device_1
    click on dial pad in consult transfer option    device=device_1    to_device=device_2
    long press on assigned username    device=device_1
    click on Reassign line key option    device=device_1
    verify and click on Consult Transfer option in assign line key option    device=device_1
    Click on dial Pad in consult transfer option    device=device_1    to_device=device_2
    long press on assigned username    device=device_1
    device setting back     device=device_1
    click on Unassign line key option    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    testcase teardown    device=device_1    AND   Come back to home screen    device_list=device_1,device_2

TC15 : Verify DUT user able to blind transfer the call when to Assigned linekey user in the Linekey app.
    [Tags]    557775    sanity_tp    bvt_tp
    [Setup]    Testcase Setup    count=3
    Verify and click Line keys app in more tab    device=device_1
    Verify and click assign line key inside line keys app    device=device_1
    Verify and click assign line key option in assign line key    device=device_1
    verify and click on transfer option in assign line key option    device=device_1
    assign username in line keys    device=device_1    to_device=device_2
    click on calls tab  device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    device setting back     device=device_1
    verify and click on assigned transfer or consult transfer line key    device=device_1    to_device=device_2    option=transfer
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify Call State    device_list=device_1     state=Disconnected
    click on unassign line key option    device=device_1
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3,device_2     state=Disconnected
    Verify and click assign Line key inside Line keys app    device=device_1
    Verify and click assign Line key option in assign Line key    device=device_1
    verify and click on Transfer option in assign line key option    device=device_1
    click on dial pad in transfer option    device=device_1    to_device=device_2
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    device setting back     device=device_1
    verify and click on assigned transfer or consult transfer line key    device=device_1    to_device=device_2    option=transfer
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1     state=Disconnected
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3,device_2     state=Disconnected
    click on unassign line key option    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND    testcase teardown    device=device_1    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC16 : Verify DUT user able to Consult transfer the call to Assigned linekey user in the Linekey app.
    [Tags]    557781    sanity_tp
    [Setup]    Testcase Setup    count=3
    Verify and click Line keys app in more tab    device=device_1
    Verify and click assign line key inside line keys app    device=device_1
    Verify and click assign line key option in assign line key    device=device_1
    verify and click on Consult Transfer option in assign line key option    device=device_1
    assign username in line keys    device=device_1    to_device=device_2
    click on calls tab  device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    device setting back     device=device_1
    verify and click on assigned transfer or consult transfer line key    device=device_1    to_device=device_2    option=consult transfer
    Verify Call State    device_list=device_2,device_3    state=Connected
    Verify Call State    device_list=device_1     state=Disconnected
    click on unassign line key option    device=device_1
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3,device_2     state=Disconnected
    Verify and click assign Line key inside Line keys app    device=device_1
    Verify and click assign Line key option in assign Line key    device=device_1
    verify and click on Consult Transfer option in assign line key option    device=device_1
    Click on dial pad in consult transfer option    device=device_1    to_device=device_2
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    device setting back     device=device_1
    verify and click on assigned transfer or consult transfer line key    device=device_1    to_device=device_2    option=consult transfer
    Verify Call State    device_list=device_1     state=Disconnected
    Verify Call State    device_list=device_2,device_3    state=Connected
    Disconnect call     device=device_3
    Verify Call State    device_list=device_3,device_2     state=Disconnected
    click on unassign line key option    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND    testcase teardown    device=device_1    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC17 : Verify DUT should display all the delegates of DUT user together/Continously in linekey slot when DUT user assign a linekey user from Personal shared line section under the shared line
    [Tags]    557783    sanity_tp    bvt_tp
    [Setup]    Testcase Setup    count=3
    Verify and click Line keys app in more tab    device=device_1
    Verify and click assign line key inside line keys app    device=device_1
    Verify and click assign line key option in assign line key    device=device_1
    verify and click on shared line option in assign line key option    device=device_1    people_you_support_user=device_3    circular_delegation_user=device_2
    assign linekey user    device=device_1    circular_delegation_user=device_2    option=Personal Shared Line
    click on assigned linekey username    device=device_1    to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    click on Unassign line key option    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND    testcase teardown    device=device_1    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC18 : Verify DUT should display all the delegates of Boss user in linekey slot together/Continously when DUT user assigns a Boss as a linekey user from People You support section under the shared line option.
    [Tags]    557785    sanity_tp
    [Setup]    Testcase Setup    count=3
    Verify and click Line keys app in more tab    device=device_1
    Verify and click assign line key inside line keys app    device=device_1
    Verify and click assign line key option in assign line key    device=device_1
    verify and click on shared line option in assign line key option    device=device_1    people_you_support_user=device_3    circular_delegation_user=device_2
    assign linekey user    device=device_1    people_you_support_user=device_3    option=people you support
    click on assigned linekey username    device=device_1    to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_3     state=Disconnected
    click on Unassign line key option    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND    testcase teardown    device=device_1    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC19 : Verify DUT should display all the delegates in linekey slot together/Continously when DUT user assign a linekey user from Circular Delegation section under the shared line option.
    [Tags]    557786
    [Setup]    Testcase Setup    count=3
    Verify and click Line keys app in more tab    device=device_1
    Verify and click assign line key inside line keys app    device=device_1
    Verify and click assign line key option in assign line key    device=device_1
    verify and click on shared line option in assign line key option    device=device_1    people_you_support_user=device_3    circular_delegation_user=device_2
    assign linekey user    device=device_1    circular_delegation_user=device_2    option=circular delegation
    click on assigned linekey username    device=device_1    to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    click on Unassign line key option    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND    testcase teardown    device=device_1    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC20 : Verify that Delegate is able to join the call by using In a calls status from linekey app when boss in a call with other user
    [Tags]    557802    sanity_tp
    [Setup]    Testcase Setup    count=3
    Verify and click Line keys app in more tab    device=device_1
    Verify and click assign line key inside line keys app    device=device_1
    Verify and click assign line key option in assign line key    device=device_1
    verify and click on shared line option in assign line key option    device=device_1    people_you_support_user=device_3    circular_delegation_user=device_2
    assign linekey user    device=device_1    people_you_support_user=device_3    option=people you support
    Click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2   to_device=device_2
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_3,device_2    state=Connected
    verify presence of in a call status in linekey    device=device_1
    click on assigned linekey username    device=device_1    to_device=device_3
    Verify Call State    device_list=device_1,device_3,device_2    state=Connected
    disconnect call       device=device_2,device_1
    Verify Call State    device_list=device_1,device_2,device_3    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND    testcase teardown    device=device_1    AND    Come back to home screen    device_list=device_1,device_2,device_3

TC21 : Verify DUT should remove all the delegates once after unassigned the Boss/Circular delegation user/ TDC user.
    [Tags]    557787    sanity_tp    bvt_tp
    [Setup]    Testcase Setup    count=3
    Verify and click Line keys app in more tab    device=device_1
    Verify and click assign line key inside line keys app    device=device_1
    Verify and click assign line key option in assign line key    device=device_1
    verify and click on shared line option in assign line key option    device=device_1    people_you_support_user=device_3    circular_delegation_user=device_2
    assign linekey user    device=device_1    circular_delegation_user=device_2    option=Personal Shared Line
    click on Unassign line key option    device=device_1
    Verify and click assign line key inside line keys app    device=device_1
    Verify and click assign line key option in assign line key    device=device_1
    verify and click on shared line option in assign line key option    device=device_1    people_you_support_user=device_3    circular_delegation_user=device_2
    assign linekey user    device=device_1    people_you_support_user=device_3    option=people you support
    click on Unassign line key option    device=device_1
    Verify and click assign line key inside line keys app    device=device_1
    Verify and click assign line key option in assign line key    device=device_1
    verify and click on shared line option in assign line key option    device=device_1    people_you_support_user=device_3    circular_delegation_user=device_2
    assign linekey user    device=device_1    circular_delegation_user=device_2    option=circular delegation
    click on Unassign line key option    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    testcase teardown    device=device_1    AND   Come back to home screen    device_list=device_1,device_2,device_3

TC22 : Verify DUT should remove the all the delegates and assigns a new user once after reassigned the Boss/Circular delegation user/ TDC user
    [Tags]    557800
    [Setup]    Testcase Setup    count=3
    Verify and click Line keys app in more tab    device=device_1
    Verify and click assign line key inside line keys app    device=device_1
    Verify and click assign line key option in assign line key    device=device_1
    verify and click on shared line option in assign line key option    device=device_1    people_you_support_user=device_3    circular_delegation_user=device_2
    assign linekey user    device=device_1    circular_delegation_user=device_2    option=Personal Shared Line
    long press on assigned username    device=device_1
    click on Reassign line key option    device=device_1
    verify and click on shared line option in assign line key option    device=device_1    people_you_support_user=device_3    circular_delegation_user=device_2
    assign linekey user    device=device_1    people_you_support_user=device_3    option=people you support
    long press on assigned username    device=device_1
    click on Reassign line key option    device=device_1
    verify and click on shared line option in assign line key option    device=device_1    people_you_support_user=device_3    circular_delegation_user=device_2
    assign linekey user    device=device_1    circular_delegation_user=device_2    option=circular delegation
    click on Unassign line key option    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    testcase teardown    device=device_1    AND   Come back to home screen    device_list=device_1,device_2,device_3

*** Keywords ***
Suite Setup
    Add from directory   from_device=device_1     to_device=device_2     group_name=Speed dial

testcase teardown
    [Arguments]     ${device}
    click on Unassign line key option    ${device}

Suite Teardown
    Remove user from group    from_device=device_1    to_device=device_2     group_names=Speed dial

adding delegates
    Add New Delegates With Both Permission And Validate    from_device=device_1    to_device=device_2
    Add New Delegates With Both Permission And Validate    from_device=device_2    to_device=device_1
    Add New Delegates With Both Permission And Validate    from_device=device_3    to_device=device_1

deleting delegates
    Delete Delegate From Manage Delegate    from_device=device_1    to_device=device_2
    Delete Delegate From Manage Delegate    from_device=device_2    to_device=device_1
    Delete Delegate From Manage Delegate    from_device=device_3    to_device=device_1
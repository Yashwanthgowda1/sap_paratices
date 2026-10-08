*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation      Suite Setup Requirements : This suite requires minimum of 4 devices in config
...                Purpose: Device_1 should be added as a Delegate from Device_3 & Device_4

Suite Setup    Call as my self Setup
Suite Teardown     Run Keywords     Suite Failure Capture     AND         Call as my self Teardown

*** Variables ***
${wait_time} =  10
${20s_wait_time} =   20
${30s_wait_time} =  30


*** Test Cases ***
TC 1:[Call as Myself] Verify that if the DUT user has boss, Call as Myself with a dropdown icon should be display under Dialpad.
    [Tags]     452736       P0      sanity_tp      bvt_tp     phonesCY23_4
    [Setup]  Testcase Setup  count=1
    click on calls tab     device=device_1
    verify call as myself drop down button      device=device_1
    verify text on call as myself button      device=device_1       to_device=my_self
    [Teardown]  Run Keywords    Capture on Failure   AND      Come back to home screen     device_list=device_1

TC 2:Verify Call as myself and Selected boss name should be display inside the Dropdown icon under Dialpad in shared line App, when user navigates to Shared line app through view shared line option of any delegator if boss giving permission to Make a Call
    [Tags]     452793       P0      sanity_tp        bvt_tp       phonesCY23_4
    [Setup]  Testcase Setup  count=4
    click on calls tab     device=device_1
    verify option in call as myself drop down button      device=device_1       to_device=device_3
    navigate to shared line option from history button      device=device_1       to_device=device_3
    verify text on call as myself button      device=device_1       to_device=device_3
    verify option in call as myself drop down button      device=device_1       to_device=device_3
    [Teardown]  Run Keywords    Capture on Failure   AND      Come back to home screen     device_list=device_1

TC 3:[Call as Myself] Verify that Call as Myself with a dropdown icon should get updated to Call button in DUT Calls tab after removing DUT user as delegate from the Boss.
    [Tags]      452770      P1      phonesCY23_4
    [Setup]     Testcase Setup  count=2
    verify and set dialpad option for portrait device       device=device_2
    click on calls tab     device=device_2
    go back to previous page     device=device_2
    verify call as myself option should not appear when permission to make a calls is disabled by all boss  device=device_2
    [Teardown]  Run Keywords    Capture on Failure   AND      Come back to home screen     device_list=device_2

TC 4:[Call as Myself] Verify Call as button should be getting updated to selected boss username Under the Dialpad in a shared line app if delegator giving permission to Make a Call
    [Tags]  452796      P0      bvt_tp      sanity_tp       phonesCY23_4        bvt_pr
    [Setup]     Testcase Setup  count=4
    click on calls tab     device=device_1
    navigate to shared line option from history button      device=device_1       to_device=device_3
    verify text on call as myself button      device=device_1       to_device=device_3
    verify option in call as myself drop down button      device=device_1       to_device=device_3
    verify and change boss in shared lines      device=device_1      from_device=device_3      to_device=device_4
    verify option in call as myself drop down button      device=device_1       to_device=device_4
    [Teardown]  Run Keywords    Capture on Failure  AND      Come back to home screen    device_list=device_1

TC 5:[Call as Myself] Verify that DUT should display all the Boss's name inside the Dropdown icon who have given the permission to "Make a call".
    [Tags]     452780       P0      sanity_tp      bvt_tp     phonesCY23_4
    [Setup]  Testcase Setup  count=4
    click on calls tab     device=device_1
    verify option in call as myself drop down button      device=device_1       to_device=device_3
    click on home bar icon        device=device_1
    navigate to manage delegate page    device=device_3
    disable option in delegates permission    device=device_3     to_device=device_1        option=Make_calls
    Wait for Some Time    time=${30s_wait_time}
    click on calls tab     device=device_1
    verify call as boss name option not appear when permission to make a calls is disabled      device=device_1       to_device=device_3
    [Teardown]  Run Keywords    Capture on Failure   AND      Come back to home screen     device_list=device_1,device_3           AND        enable option in delegates permission    device=device_3     to_device=device_1        option=Make_calls    AND    Come back to home screen   device_list=device_1,device_3

TC 6:[Call as Myself] Verify that DUT should display only Call as myself option under the Dialpad in a Calls tab, When DUT user having Boss, but they didn't given permission to Make a Calls.
    [Tags]     452787       P1      phonesCY23_4
    [Setup]  Testcase Setup  count=4
    click on calls tab     device=device_1
    verify option in call as myself drop down button      device=device_1       to_device=device_3
    click on home bar icon        device=device_1
    navigate to manage delegate page    device=device_4
    disable option in delegates permission    device=device_4     to_device=device_1        option=Make_calls
    navigate to manage delegate page    device=device_3
    disable option in delegates permission    device=device_3     to_device=device_1        option=Make_calls
    click on calls tab     device=device_1
    Wait for Some Time    time=${30s_wait_time}
    click on home bar icon        device=device_1
    click on calls tab     device=device_1
    verify call as myself option should not appear when permission to make a calls is disabled by all boss     device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND      Come back to home screen     device_list=device_1,device_4        AND        enable option in delegates permission    device=device_3     to_device=device_1        option=Make_calls           AND        enable option in delegates permission    device=device_4     to_device=device_1        option=Make_calls    AND    Come back to home screen   device_list=device_1,device_3,device_4

TC 7:[Call as Myself] Verify that when DUT user selects boss from the drop down, under Dialpad "Call as myself" should be updated as "Call as boss username".
    [Tags]     452785       P2
    [Setup]  Testcase Setup  count=3
    click on calls tab     device=device_1
    select option in call as myself drop down button      device=device_1       to_device=device_3
    [Teardown]  Run Keywords    Capture on Failure   AND      Come back to home screen     device_list=device_1

TC 8:[Call as Myself] Verify that DUT user is able to make a call to another user on behalf of boss by using Call as Boss button under the Dialpad in Calls tab.
    [Tags]     452791       P2
    [Setup]  Testcase Setup  count=4
    click on calls tab     device=device_1
    select option in call as myself drop down button      device=device_1       to_device=device_3
    auto dial with valid num from dial pad  from_device=device_1    to_device=device_4
    Verify calling behalf of device text    device=device_1  to_device=device_4     from_device=device_3        method=phone_number
    Pick incoming call    device=device_4
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_4    state=Connected
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_4     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure   AND      Come back to home screen     device_list=device_1

TC 9:[Call as Myself] Verify that if the DUT user has boss, Call as Myself with a dropdown icon should be display under Dialpad when DUT user set Default view as Speed dial/Recent Call history.
    [Tags]      452803
    [Setup]     Testcase Setup  count=1
    ${prt_mode_flag}   is portrait mode cnf device  device=device_1
    pass execution if   '${prt_mode_flag}'=='False'  device_1, device is not a portrait mode device
    Select default view value     device=device_1     option=recent call history
    Validate calls tab after default value change    device=device_1      default_option=recent call history
    go back to previous page     device=device_1
    verify call as my self option on calls tab in recent and call history view      device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND      Come back to home screen    device_list=device_1

TC 10:Verify only Call as myself button should be display under the Dialpad in shared line App, when user navigates to Shared line app through view shared line option of any delegator (Boss) if delegator doesn't give permission to Make a Call
    [Tags]    452799
    [Setup]    Testcase Setup    count=4
    navigate to manage delegate page    device=device_3
    disable option in delegates permission    device=device_3     to_device=device_1        option=Make_calls
    Click On Calls Tab    device=device_1
    navigate to shared line option from history button      device=device_1       to_device=device_3
    verify call as myself option should not appear when permission to make a calls is disabled by all boss     device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND      Come back to home screen     device_list=device_1,device_3           AND        enable option in delegates permission    device=device_3     to_device=device_1        option=Make_calls    AND    Come back to home screen   device_list=device_1,device_3

TC 11:[Call as Myself] Verify that if the user having a long delegator (Boss) name, DUT should display delegator name with ... in Call button under the Dialpad in Calls tab.
    [Tags]    452792
    [Setup]    Testcase Setup    count=3
    Click On Calls Tab    device=device_1
    select option in call as myself drop down button      device=device_1       to_device=device_3
    [Teardown]  Run Keywords    Capture on Failure  AND      Come back to home screen    device_list=device_1,device_2,device_3

TC 12:[Call as Myself] Verify autodial should be happen in shared line App, when user navigates to Shared line app through view shared line option of any delegator (Boss) if selected delegator doesn't give permission to Make a Call
    [Tags]    452802
    [Setup]    Testcase Setup    count=4
    navigate to manage delegate page    device=device_3
    disable option in delegates permission    device=device_3     to_device=device_1        option=Make_calls
    Click On Calls Tab    device=device_1,device_4
    navigate to shared line option from history button      device=device_1       to_device=device_3
    verify call as myself option should not appear when permission to make a calls is disabled by all boss     device=device_1
    auto dial with valid num from dial pad  from_device=device_1    to_device=device_4
    Verify Incoming Call  device=device_4     status=appear
    Verify name of caller and receiver displayed    from_device=device_4    to_device=device_1
    Verify Call State And Disconnect    device=device_1
    [Teardown]  Run Keywords    Capture on Failure   AND      Come back to home screen     device_list=device_1,device_3           AND        enable option in delegates permission    device=device_3     to_device=device_1        option=Make_calls    AND    Come back to home screen   device_list=device_1,device_3

*** Keywords ***
Call as my self Setup
    Testcase Setup  count=4
    Add new delegates with both permission and validate   from_device=device_3    to_device=device_1
    Add new delegates with both permission and validate   from_device=device_4    to_device=device_1
    verify and set dialpad option for portrait device    device=device_1

Call as my self Teardown
    Delete delegate from manage delegate   from_device=device_3    to_device=device_1
    Delete delegate from manage delegate   from_device=device_4    to_device=device_1

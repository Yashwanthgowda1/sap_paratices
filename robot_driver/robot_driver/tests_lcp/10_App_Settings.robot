*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture


*** Test Cases ***
TC1 : [App Settings] DUT to have "Calling" options to customize incoming calls in settings
    [Tags]  243164      sanity_lcp
    [Setup]  Testcase Setup     count=1
    Verify settings calling option     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2 : [App Settings] DUT to have option to report problem and feature request
    [Tags]  243625      bvt_lcp     sanity_lcp        Certification_lcp
    [Setup]  Testcase Setup     count=1
    Report a problem    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3 : [App Settings] DUT user to view the device settings.
    [Tags]  243624        Certification_lcp
    [Setup]  Testcase Setup     count=1
    Navigate to device setting page   device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC4 : [App Settings] DUT user to see the Terms of Use
    [Tags]  243167
    [Setup]  Testcase Setup     count=1
    Verify terms of use view     device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC5 : [App Settings] DUT user to reset its presence status
    [Tags]  243314
    [Setup]  Testcase Setup     count=1
    Select user presence   device=device_1     state=Away
    Verify user presence   device=device_1     state=Away
    Select user presence   device=device_1     state=reset_status
    Verify user presence   device=device_1     state=Available
    Select user presence   device=device_1     state=reset_status
    Verify user presence   device=device_1     state=Available
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC6: [App Settings] DUT user able to view the profile
    [Tags]  244278
    [Setup]  Testcase Setup     count=1
    verify user profile view    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC7: [App Settings] DUT user sign-out from the device
    [Tags]  244285
    [Setup]  Testcase Setup     count=1
    Sign out cancel btn verify    device=device_1
    Sign out    device_list=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1     AND    signin method for lcp   device=device_1

TC8 : [App Settings] First thing in menu is the user Account signed-into the DUT
    [Tags]  318451
    [Setup]  Testcase Setup     count=1
    verify user account signed-into the device    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC9 : [App Settings] DUT user block calls with no caller ID
    [Tags]  243463
    [Setup]  run keywords   Testcase Setup    count=2    AND   verify and block calls with no caller id   device=device_1   block_user=device_2
    navigate to people tab    device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=Disappear
    [Teardown]  Run Keywords    Capture on Failure    AND     verify and unblock calls with no caller id   device=device_1

TC10 : [App Settings] DUT user's Display picture is visible along with the user account signed-into Teams app
    [Tags]  318453
    [Setup]  Testcase Setup     count=1
    verify user account signed-into the device    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC11 : [Busy on busy] 'When in another call' option should be shown
    [Tags]  451521      Sanity_LCP  phonesCY23_4
    [Setup]  Testcase Setup     count=1
    Verify settings calling option     device=device_1
    verify default setting under call forwarding section    device=device_1     status=off
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC12 : [Busy on Busy] DUT user to verify "When in another call" option should present under calling
    [Tags]  452365
    [Setup]  Testcase Setup     count=1
    Verify settings calling option     device=device_1
    verify when in another call option inside calling    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC13 : [Busy on Busy] DUT user to verify the options present inside the "When in another call" under calling
    [Tags]  452367
    [Setup]  Testcase Setup     count=1
    Verify settings calling option     device=device_1
    verify default setting under call forwarding section    device=device_1     status=off
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC14 : [Busy on Busy] Verify that DUT user able to select options present inside the "When in another call" under calling.
    [Tags]  452369  bvt_lcp     sanity_lcp   phonesCY23_4
    [Setup]  Testcase Setup     count=1
    Verify settings calling option     device=device_1
    verify default setting under call forwarding section    device=device_1     status=off
    select the options inside when in another call option   device=device_1     option=play_a_busy_signal
    select the options inside when in another call option   device=device_1     option=new_calls_ring_me
    select the options inside when in another call option   device=device_1     option=redirect_unanswered_call
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC15: [Busy on Busy] DUT user to verify "Play a Busy signal" option is selected by default under "When in another call"
    [Tags]  452370
    [Setup]  Testcase Setup     count=1
    Verify settings calling option     device=device_1
    verify when in another call option inside calling    device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC16 : [Busy on Busy] DUT user should not get the Incoming call, When user sign in with Busy on Busy policy set as ON from the TAC and DUT user is in call with other user.
    [Tags]  452506  bvt_lcp     sanity_lcp   phonesCY23_4
    [Setup]  Testcase Setup     count=3
    Verify settings calling option     device=device_1
    select the options inside when in another call option   device=device_1     option=play_a_busy_signal
    come back to home screen  device_list=device_1
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    pick incoming call   device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    navigate to people tab    device=device_3
    verify busy on busy error message while already in call  device=device_3         to_device=device_1     method=display_name
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Come back to home screen    device_list=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND  select the options inside when in another call option   device=device_1     option=new_calls_ring_me  AND  Come back to home screen    device_list=device_1,device_2,device_3

TC17 : [Busy on Busy] Verify DUT should retain all the busy on busy settings, when user resign -in with same credentials/reboot the DUT.
    [Tags]  452489  bvt_lcp     sanity_lcp   phonesCY23_4
    [Setup]  Testcase Setup     count=3
    Verify settings calling option     device=device_1
    verify default setting under call forwarding section    device=device_1     status=off
    select the options inside when in another call option   device=device_1     option=play_a_busy_signal
    Come back to home screen    device_list=device_1
    Sign out  device_list=device_1
    signin method for lcp   device=device_1
    Verify settings calling option     device=device_1
    verify the status of when in another call option        device=device_1     option=play_a_busy_signal
    [Teardown]  Run Keywords    Capture on Failure  AND  select the options inside when in another call option   device=device_1     option=new_calls_ring_me  AND  Come back to home screen    device_list=device_1,device_2,device_3

TC18 : [Busy on Busy] Verify Busy on Busy message should disappear within 5 sec on DUT screen.
    [Tags]  452437  bvt_lcp     sanity_lcp   phonesCY23_4
    [Setup]  Testcase Setup     count=3
    Verify settings calling option     device=device_1
    select the options inside when in another call option   device=device_1     option=play_a_busy_signal
    come back to home screen  device_list=device_1
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    pick incoming call   device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    navigate to people tab    device=device_3
    verify busy on busy error message while already in call  device=device_3         to_device=device_1     method=display_name
    verify incoming call    device=device_1     status=disappear
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    Come back to home screen    device_list=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND  select the options inside when in another call option   device=device_1     option=new_calls_ring_me  AND  Come back to home screen    device_list=device_1,device_2,device_3

TC19 : [Busy on Busy] [Calls] Verify DUT user is receiving the incoming call, when user selects, Let New calls ring me under When in another call in Calling.
    [Tags]  452373      bvt_lcp     sanity_lcp   phonesCY23_4
    [Setup]  Testcase Setup     count=3
    Verify settings calling option     device=device_1
    select the options inside when in another call option   device=device_1     option=new_calls_ring_me
    come back to home screen  device_list=device_1
    navigate to people tab    device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    pick incoming call   device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    navigate to people tab    device=device_3
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    verify incoming call    device=device_1     status=appear
    pick incoming call   device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    Verify Call State    device_list=device_2     state=Hold
    Disconnect call     device=device_2,device_1
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1,device_2,device_3

TC20 : [LCP] App Setting page should display directly
    [Tags]  298919      sanity_lcp      P1
    [Setup]  Testcase Setup     count=1
    Open settings page      device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC21 : [ODS] - All policies enabled.
    [Tags]      464895      bvt_lcp     sanity_lcp
    [Setup]  Testcase Setup     count=1
    verify send feedback page   device=device_1
    give feedback to microsoft  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1
    

*** Keywords ***
verify user account signed-into the device
    [Arguments]  ${device}
    verify user profile view    device=device_1

*** Settings ***
Resource    ../resources/keywords/common.robot
Documentation    Device 1: User should be assigned  feedback policy - Give Feedback (enabled) - Log collection (enabled) - Email (enabled) | Device 2: User should be assigned  feedback policy - Log collection (enabled)
...             | Device 3: User should be assigned  feedback policy - Email (enabled)
Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10
${wait_time2} =  20
${wait_time30sec} =  30

*** Test Cases ***
TC1 : [App Settings] DUT user's Display picture is visible along with the user account signed 
    [Tags]  307275   sanity_tp       bvt_pr  alt_credentials
    [Setup]  Testcase Setup    count=1
    Verify user friendly name and display picture   device=device_1
    Verify user contact info   device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2 : [App Settings] DUT to have option to report problem and feature request.
    [Tags]  308389   bvt_tp  sanity_tp    alt_credentials       Certification_audio
    [Setup]  Testcase Setup    count=1
    Report a problem    device=device_1
    # verify feedback toast    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3 : [App Settings] DUT user to view the third-party software notices and information
    [Tags]  307016         alt_credentials
    [Setup]  Testcase Setup    count=1
    verify third party software notices and information    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC4 : [App Settings] DUT to have "Calling" options to customize incoming calls in settings.
    [Tags]   307009   P1  alt_bug        sanity_tp     bvt_tp
    [Setup]  Testcase Setup    count=1
    Verify settings calling option     device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC5 : [App Settings] Teams App user to view the device settings.
    [Tags]   308386   P1  alt_credentials       Certification_audio
    [Setup]  Testcase Setup    count=1
    Navigate to device setting page   device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Device Setting Back     device=device_1   AND   Come back to home screen    device_list=device_1

TC6 : [App Settings] DUT user to reset its presence status
    [Tags]    307280    P2  alt_credentials
    [Setup]  Testcase Setup    count=1
    Select user presence   device=device_1     state=Away
    Verify user presence   device=device_1     state=Away
    Select user presence   device=device_1     state=Available
    Verify user presence   device=device_1     state=Available
    Select user presence   device=device_1     state=Available
    Verify user presence   device=device_1     state=Available
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC7 : [App Settings]DUT user to see and define Privacy and cookies/ Term of use
    [Tags]   307012   P3  alt_credentials
    [Setup]  Testcase Setup    count=1
    Verify privacy and cookies view     device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC8 : [App Settings] Teams App user able to enable/disable Home screen using toggle button
    [Tags]   310359     P2  alt_credentials
    [Setup]    Testcase Setup    count=1
    Home Screen Enable     device=device_1
    Home screen Disable    device=device_1
    [Teardown]    Capture on Failure

TC9 : [App Settings] DUT able to enable/disable Home screen using toggle button
    [Tags]   310363     P2  alt_bug
    [Setup]    Testcase Setup    count=2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Verify Incoming call    device=device_1     status=Appear
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    Verify and disable notification     device=device_1
    Verify and enable notification    device=device_1
    [Teardown]    Run Keywords   Capture on Failure    AND   Come back to home screen    device_list=device_1,device_2

TC10 : (VQE)Enable voice quality recording option under the calling settings.
    [Tags]      346043    P0
    [Setup]  Testcase Setup    count=1
    verify voice quality recording option under callings settings   device=device_1
    enable or disable Voice quality recording option  device=device_1       desired_state=on
    [Teardown]   Run Keywords    Capture on Failure  AND        enable or disable Voice quality recording option  device=device_1    desired_state=off   AND    Come back to home screen    device_list=device_1

TC11 : Verify that VQE(Voice quality recording) option available under the calling settings
    [Tags]      346009    P2
    [Setup]  Testcase Setup    count=1
    verify voice quality recording option under callings settings   device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC12 : [Busy on Busy]Verify that DUT user able to select options present inside the "When in another call" under calling
    [Tags]      451957  sanity_tp  phonesCY23_4
    [Setup]  Testcase Setup    count=1
    Verify settings calling option      device=device_1
    verify default setting under call forwarding section    device=device_1     status=off
    select the options inside when in another call option   device=device_1     option=play_a_busy_signal
    select the options inside when in another call option   device=device_1     option=new_calls_ring_me
    select the options inside when in another call option   device=device_1     option=redirect_unanswered_call
    [Teardown]   Run Keywords    Capture on Failure       AND         select the options inside when in another call option   device=device_1     option=new_calls_ring_me         AND    Come back to home screen    device_list=device_1

TC13 : [Busy on Busy]DUT user to verify "Play a Busy signal" option is selected by default under "When in another call".
    [Tags]      451960      phonesCY23_4        sanity_tp 
    [Setup]  Testcase Setup    count=1
    Verify settings calling option      device=device_1
    verify when in another call option inside calling    device=device_1
    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC14 : [Busy on Busy][Call] Verify Unanswered Call is forwarded to Voicemail, When user selects Redirect as if a call is unanswered under When in another call in Calling
    [Tags]      451969    bvt_tp    sanity_tp  phonesCY23_4
    [Setup]   Run Keywords   Testcase Setup    count=4   AND    Enable unanswered call to voicemail      from_device=device_1     contact_device=device_2
    select the options inside when in another call option   device=device_1     option=redirect_unanswered_call
    Come back to home screen    device_list=device_1
    click on calls tab  device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Verify Call State    device_list=device_3   state=Connected
    Wait for Some Time    time=${wait_time30sec}
    Disconnect call     device=device_3,device_1
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    go back to previous page  device=device_1
    navigate to calls tab  device=device_1
    Verify call entries are synced in call log    from_device=device_1      to_device=device_3      state=missed
    Navigate to voicemail tab    device=device_1
    verify first voicemail displayname  to_device=device_1  from_device=device_3
    [Teardown]   Run Keywords    Capture on Failure    AND      select the options inside when in another call option   device=device_1     option=new_calls_ring_me   AND    Come back to home screen    device_list=device_1

TC15 : [Busy on Busy] Verify Busy on Busy message should disappear within 5 sec on DUT screen.
    [Tags]      451981    sanity_tp  phonesCY23_4
    [Setup]    Testcase Setup    count=3
    select the options inside when in another call option   device=device_1     option=play_a_busy_signal
    Come back to home screen    device_list=device_1
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2    state=Connected
    click on calls tab  device=device_3
    verify busy on busy error message while already in call  device=device_3         to_device=device_1     method=display_name
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure    AND      select the options inside when in another call option   device=device_1     option=new_calls_ring_me   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC16 : [Busy on Busy][Call hold]Verify that Busy on Busy is working, when DUT call is on hold
    [Tags]      452012        sanity_tp      phonesCY23_4       bvt_pr
    [Setup]    Testcase Setup    count=4
    Verify settings calling option      device=device_1
    select the options inside when in another call option   device=device_1     option=play_a_busy_signal
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_3      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_3    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1     state=Hold
    click on calls tab  device=device_2
    verify busy on busy error message while already in call       device=device_2        to_device=device_1     method=display_name
    verify incoming call    device=device_1    status=disappear
    click back         device=device_1
    select the options inside when in another call option   device=device_1     option=new_calls_ring_me
    Place a call from search results page   from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2     state=Connected
    Verify call hold banner    from_device=device_1     to_device=device_3
    Disconnect call     device=device_2
    Verify Call State    device_list=device_2     state=Disconnected
    select the options inside when in another call option   device=device_1     option=redirect_unanswered_call
    Unanswered call setup      from_device=device_1     contact_device=device_4        select_option=contacts
    Place a call from search results page   from_device=device_2      to_device=device_1
    Wait for Some Time    time=${wait_time}
    Verify incoming call    device=device_4     status=appear
    Pick incoming call    device=device_4
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_2,device_4    state=Connected
    Disconnect call     device=device_4,device_3
    Verify Call State    device_list=device_1,device_2,device_3,device_4    state=Disconnected
    go back to previous page  device=device_1
    Verify call entries are synced in call log    from_device=device_1      to_device=device_2      state=missed
    [Teardown]   Run Keywords    Capture on Failure    AND     Testcase Teardown for busy on busy unanswerd calls       devices=device_1,device_2,device_3,device_4


TC17 : [Busy on Busy][Hotdesk]Verify that hotdesk user should get the When in another call option under calling
    [Tags]   452000
    [Setup]  Testcase Setup    count=2
    Hot desking signin   device=device_1     hot_desk_account=device_2
    Verify hot desking mode  device=device_1
    Verify settings calling option      device=device_1
    verify default setting under call forwarding section    device=device_1     status=off
    End hot desk    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC18 : Verify license details in settings About page.
    [Tags]  419922    P2
    [Setup]  Testcase Setup      count=1
    verify license details option in about page        device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC19 : [Busy on Busy] [Call]Verify Unanswered call should disconnect, When user selects Redirect as if a call is unanswered under When in another call in Calling
    [Tags]      451976
    [Setup]  Run Keywords     Testcase Setup    count=3  AND     Disable unanswered call    device=device_1      contact_device=device_2
    select the options inside when in another call option   device=device_1     option=redirect_unanswered_call
    Come back to home screen    device_list=device_1
    click on calls tab        device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    click on calls tab        device=device_2
    verify busy on busy error message while already in call  device=device_2        to_device=device_1  method=display_name
    Disconnect call     device=device_1
    Verify Call State    device_list=device_1,device_2,device_3      state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND  select the options inside when in another call option   device=device_1     option=new_calls_ring_me   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC20 : [Busy on Busy] [Call]Verify DUT user should get the incoming call on the busy state displayed screen.
    [Tags]      451962
    [Setup]  Testcase Setup    count=4
    select the options inside when in another call option   device=device_1     option=play_a_busy_signal
    Come back to home screen    device_list=device_1
    click on calls tab        device=device_1
    Make outgoing call using display name    from_device=device_1     to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    click on calls tab        device=device_2
    verify busy on busy error message while already in call  device=device_2        to_device=device_1  method=display_name
    click on calls tab        device=device_4
    Make outgoing call using display name    from_device=device_4     to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_2,device_4    state=Connected
    Disconnect call     device=device_2,device_1
    Verify Call State    device_list=device_1,device_2,device_3,device_4      state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND  select the options inside when in another call option   device=device_1     option=new_calls_ring_me   AND    Come back to home screen    device_list=device_1,device_2,device_3,device_4

TC21 : [Busy on Busy] Verify second incoming call should be forwarding to voicemail, when user set unanswered call to voicemail.
    [Tags]      452073      P1
    [Setup]  Run Keywords     Testcase Setup    count=4  AND     Enable unanswered call to voicemail      from_device=device_1     contact_device=device_2
    select the options inside when in another call option   device=device_1     option=new_calls_ring_me
    Come back to home screen    device_list=device_1
    click on calls tab        device=device_3
    Make outgoing call using display name    from_device=device_3     to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_3    state=Connected
    click on calls tab        device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1
    Verify incoming call    device=device_1     status=appear
    Wait for Some Time    time=${wait_time30sec}
    Disconnect call     device=device_2
    Navigate to voicemail tab    device=device_1
    Wait for Some Time    time=${wait_time}
    refresh the page    device=device_1
    verify first voicemail displayname  to_device=device_1  from_device=device_2
    go back to previous page    device=device_1
    Enable unanswered call and add contact   from_device=device_1    contact_device=device_4
    Navigate to calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Incoming call    device=device_4     status=appear
    Wait for Some Time    time=${wait_time30sec}
    Disconnect call     device=device_2
    Disable unanswered call    device=device_1      contact_device=device_2
    navigate to calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2     to_device=device_1
    Verify Incoming call    device=device_1     status=appear
    Wait for Some Time    time=${wait_time30sec}
    Wait for Some Time    time=${wait_time2}
    Verify Call State    device_list=device_1,device_2,device_3,device_4      state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure  AND  select the options inside when in another call option   device=device_1     option=new_calls_ring_me   AND    come back home screen for user   count=4

TC22 : [App settings] User to verify the about section from DUT Settings page.
    [Tags]     456638    p1
    [Setup]    Testcase Setup    count=1
    verify options inside about page     device=device_1
    navigate to privacy and cookies from about page    device=device_1
    navigate to home screen from about page  device=device_1
    verify options inside about page     device=device_1
    navigate to terms of use from about_page    device=device_1
    navigate to home screen from about page  device=device_1
    verify options inside about page     device=device_1
    navigate to third party software notices from about page    device=device_1
    navigate to home screen from about page  device=device_1
    [Teardown]    Run Keywords    Capture On Failure    AND    Come back to home screen    device_list=device_1

TC23 : [ODS] - Log collection disabled.
    [Tags]    456351    tp_audio    P1
    [Setup]    Testcase Setup    count=2
    Signin With Other User    device=device_1   other_user_account=device_2
    Verify Send Feedback Page    device=device_1    policy=log_collection_disabled
    Give Feedback To Microsoft    device=device_1    available_toggles=contact_me
    [Teardown]    Run Keywords    Capture On Failure    AND    Come Back To Home Screen    device_list=device_1,device_2

TC24 : [ODS] - Email disabled.
    [Tags]    456350    tp_audio    P1
    [Setup]    Testcase Setup    count=3
    Signin With Other User    device=device_1   other_user_account=device_3
    Verify Send Feedback Page    device=device_1    policy=email_disabled
    Give Feedback To Microsoft    device=device_1    available_toggles=log_collection
    [Teardown]    Run Keywords    Capture On Failure    AND    Come Back To Home Screen    device_list=device_1,device_2,device_3

TC25 : [ODS] - All policies enabled.
    [Tags]  456347    bvt_tp      sanity_tp     p0      bvt_pr
    [Setup]  Testcase Setup     count=1
    verify send feedback page   device=device_1
    give feedback to microsoft  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1
    
TC26 : [Busy on Busy][Call] Verify DUT user able to dismiss Busy on Busy message on DUT1 screen by pressing Back arrow.
    [Tags]    451954
    [Setup]    Testcase Setup   count=3
    select the options inside when in another call option   device=device_2     option=play_a_busy_signal
    return to home screen    device_list=device_2
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_2,device_3    state=Connected
    click on calls tab  device=device_1
    verify busy on busy error message while already in call       device=device_1        to_device=device_2     method=display_name
    verify incoming call    device=device_1    status=disappear
    click back         device=device_1
    verify search close btn    device=device_1
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND      select the options inside when in another call option   device=device_2     option=new_calls_ring_me   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC27 : [Busy on Busy][Calls/Meeting] Verify DUT user is receiving the incoming call,When user selects, Let New calls ring me under When in another call in Calling
    [Tags]    451968        bvt_tp    sanity_tp
    [Setup]    Testcase Setup   count=3
    select the options inside when in another call option   device=device_1     option=new_calls_ring_me
    return to home screen    device_list=device_1
    click on calls tab  device=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_3
    Pick incoming call    device=device_3
    Verify Call State    device_list=device_1,device_3    state=Connected
    click on calls tab  device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify Call State    device_list=device_3     state=Hold
    Disconnect call     device=device_1,device_3
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    return to home screen    device_list=device_1
    select the options inside when in another call option   device=device_1     option=new_calls_ring_me
    return to home screen    device_list=device_1
    Create meeting   device=device_3    meeting=device_meeting1     participants=device_1
    Join Meeting    device=device_3,device_1     meeting=device_meeting1
    Verify meeting state   device_list=device_3,device_1   state=Connected
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Verify meeting state   device_list=device_1    state=Hold
    Disconnect call     device=device_2
    End meeting     device=device_1,device_3
    Verify meeting state    device_list=device_1,device_3   state=Disconnected
    Verify Call State    device_list=device_1,device_2,device_3     state=Disconnected
    [Teardown]  Run Keywords    Capture on Failure    AND    Test Case Teardown    devices=device_1,device_3   AND    Come back to home screen    device_list=device_1,device_2,device_3

TC28: [ODS] - Disable.
    [Tags]    456348    sanity_tp    P1
    [Setup]    Testcase Setup    count=4
    Signin With Other User    device=device_1   other_user_account=device_4
    Verify Send Feedback Page    device=device_1    policy=feedback_disabled
    [Teardown]    Run Keywords    Capture On Failure    AND    Come Back To Home Screen    device_list=device_1,device_2,device_3,device_4

#blocked due to below bug: 3467428
#TC18:(VQE)Verify the VQE(Voice quality recording) is disabled after sending feedback (i.e.,incoming calls)
#    [Tags]      346046    P0        bvt_tp  sanity_tp
#    [Setup]  Testcase Setup    count=2
#    verify voice quality recording option under callings settings   device=device_1
#    enable or disable Voice quality recording option  device=device_1       desired_state=on
#    go back to previous page     device=device_1
#    click on calls tab  device=device_2
#    Make outgoing call using display name      from_device=device_2      to_device=device_1
#    Pick incoming call    device=device_1
#    Wait for Some Time    time=${wait_time30sec}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    Report a problem    device=device_1     VQE=on
#    verify voice quality recording option under callings settings   device=device_1
#    verify toggle status for Voice quality is disabled          device=device_1
#    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2
#
#TC19:(VQE)Verify the VQE (Voice quality recording) is disabled after sending feedback (i.e.,Outgoing calls)
#    [Tags]      346077    P2
#    [Setup]  Testcase Setup    count=2
#    verify voice quality recording option under callings settings   device=device_1
#    enable or disable Voice quality recording option  device=device_1       desired_state=on
#    go back to previous page     device=device_1
#    click on calls tab  device=device_1
#    Make outgoing call using display name      from_device=device_1      to_device=device_2
#    Pick incoming call    device=device_2
#    Wait for Some Time    time=${wait_time30sec}
#    Verify Call State    device_list=device_1,device_2    state=Connected
#    Disconnect call     device=device_1
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    Come back to home screen    device_list=device_1
#    Report a problem    device=device_1     VQE=on
#    verify voice quality recording option under callings settings   device=device_1
#    verify toggle status for Voice quality is disabled          device=device_1
#    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1,device_2
#
#TC20:(VQE)Verify the VQE (Voice quality recording) is disabled after sending feedback (i.e.,Group call)
#    [Tags]      346080    P0        bvt_tp  sanity_tp
#    [Setup]  Testcase Setup    count=3
#    verify voice quality recording option under callings settings   device=device_1
#    enable or disable Voice quality recording option  device=device_1       desired_state=on
#    go back to previous page     device=device_1
#    click on calls tab  device=device_2
#    Make outgoing call using display name      from_device=device_2      to_device=device_3
#    Pick incoming call    device=device_3
#    Add participant to conversation using display name   from_device=device_2      to_device=device_1
#    Pick incoming call     device=device_1
#    Wait for Some Time    time=${wait_time30sec}
#    Verify Call State    device_list=device_1,device_2,device_3    state=Connected
#    Disconnect call     device=device_1,device_2
#    Verify Call State    device_list=device_1,device_2     state=Disconnected
#    Report a problem    device=device_1     VQE=on
#    verify voice quality recording option under callings settings   device=device_1
#    verify toggle status for Voice quality is disabled          device=device_1
#    [Teardown]   Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

## Deleted from test plan
#TC6 : [App Settings] Teams App user to have Company Portal options to see the device enrollment/compliance details of the registered device
#    [Tags]   146888     P1
#    [Setup]  Testcase Setup    count=1
#    Verify settings company portal page     device=device_1
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1




*** Keywords ***
verify third party software notices and information
    [Arguments]     ${device}
    verify third party software notices     ${device}
    scroll up secondary tab     ${device}
    click back  ${device}
    Wait for Some Time    time=${wait_time}
    scroll up secondary tab     ${device}
    click back  ${device}

Testcase Teardown for busy on busy unanswerd calls
    [Arguments]     ${devices}
    Come back to home screen     ${devices}
    open settings page      device=device_1
    unanswered call setup    from_device=device_1     contact_device=device_2     select_option=off
    select the options inside when in another call option   device=device_1     option=new_calls_ring_me
    go back to previous page      device=device_1

Test Case Teardown
    [Arguments]     ${devices}
    Teardown Meeting Test Case     ${devices}
    clear meetings from calendar tab   ${devices}
    Come back to home screen    ${devices}
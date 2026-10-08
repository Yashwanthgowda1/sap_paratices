*** Settings ***
Resource    ../../resources/keywords/common.robot

Suite Setup     Signin user attend call and send the chat from TDC
Suite Teardown      Suite Failure Capture

*** Variables ***
${wait_time} =  20
${5wait_time} =  5 minutes

*** Test Cases ***
TC1:[Chat]Verify the chat option in meeting, when user disabled the show meeting chat option is disabled.
    [Tags]    380043    P1    sanity_tc_sm
    [Setup]   Testcase Setup for shared User    count=1
    Disable the show meeting chat option     console=console_1
    Join the meeting
    Join a meeting   console=console_1      meeting=console_lock_meeting
    Verify for call state     console_list=console_1    state=Connected
    verify chat option after disabeling
    Send the message from chat option in TDC  device=tdc_1:user     message=checking for the testing purpose1
    Verify chat bubble message on device    device=device_1     state=on
    Disconnect the call      console=console_1
    Disconnect the call on TDC      device=tdc_1:user
    Verify for call state    console_list=console_1     state=Disconnected
   [Teardown]   Run Keywords    Capture Failure  AND    Enable the show meeting chat option   console=console_1     AND     Come back to home screen page   console_list=console_1

TC2:[Chat]Verify the chat option when DUT user enables chat option in Gallery mode.
    [Tags]    380052    P2
    [Setup]   Testcase Setup for shared User    count=1
    Enable the show meeting chat option   console=console_1
    Join the meeting
    Join a meeting   console=console_1      meeting=console_lock_meeting
    Verify for call state     console_list=console_1    state=Connected
    verify meeting chat     console=console_1        action_type=modify
    verify meeting chat toggle on behaviour      device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=checking for the testing purpose_2
    Verify messages on chat layers      device=device_1     message=checking for the testing purpose_2
    Disconnect the call      console=console_1
    Disconnect the call on TDC      device=tdc_1:user
    Verify for call state    console_list=console_1     state=Disconnected
   [Teardown]   Run Keywords    Capture Failure  AND     Come back to home screen page   console_list=console_1

TC3:[Chat Bubbles] Verify that by default,chat bubbles will be enabled on the Console
    [Tags]    345361    P2
    [Setup]   Testcase Setup for shared User    count=1
    Join the meeting
    Join a meeting   console=console_1      meeting=console_lock_meeting
    Verify for call state     console_list=console_1    state=Connected
    Send the message from chat option in TDC  device=tdc_1:user     message=should show chat bubble
    Verify chat bubble message on device        device=device_1     state=on
    Disconnect the call      console=console_1
    Disconnect the call on TDC      device=tdc_1:user
    Verify for call state    console_list=console_1     state=Disconnected
   [Teardown]   Run Keywords    Capture Failure  AND        Come back to home screen page   console_list=console_1

TC4:[Chat Bubbles] Verify console should not show chat bubbles.
    [Tags]    345344    P2
    [Setup]   Testcase Setup for shared User    count=1
    Disable the show chat bubble option  console=console_1
    Join the meeting
    Join a meeting   console=console_1      meeting=console_lock_meeting
    Verify for call state     console_list=console_1    state=Connected
    Send the message from chat option in TDC  device=tdc_1:user     message=should not show chat bubble
    Verify chat bubble message on device        device=device_1     state=off
    Disconnect the call      console=console_1
    Disconnect the call on TDC      device=tdc_1:user
    Verify for call state    console_list=console_1     state=Disconnected
   [Teardown]   Run Keywords    Capture Failure  AND    Enable the show chat bubble option  console=console_1   AND     Come back to home screen page   console_list=console_1

TC5:[Front Row] Verify that Link shared by the TDC users should not be accessible
    [Tags]    380572    P2
    [Setup]   Testcase Setup for shared User    count=1
    Join the meeting
    Join a meeting   console=console_1      meeting=console_lock_meeting
    Verify for call state     console_list=console_1    state=Connected
    Change meeting mode     device=console_1    mode=front_row
    Verify front row mode   device=device_1
    verify meeting chat toggle on behaviour      device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=link
    Verify messages on chat layers      device=device_1     message=link        action_type=clicking
    Disconnect the call      console=console_1
    Disconnect the call on TDC      device=tdc_1:user
    Verify for call state    console_list=console_1     state=Disconnected
   [Teardown]   Run Keywords    Capture Failure  AND     Come back to home screen page   console_list=console_1     AND     come back to calendar page on TDC   device=tdc_1:user

TC6:[Chat] DUT cannot access photos/video/file/link in chat window.
    [Tags]    382115    P2
    [Setup]   Testcase Setup for shared User    count=1
    Join the meeting
    Join a meeting   console=console_1      meeting=console_lock_meeting
    Verify for call state     console_list=console_1    state=Connected
    User should not able to access the link on chat layer in all layouts    console=console_1
    Disconnect the call      console=console_1
    Disconnect the call on TDC      device=tdc_1:user
    Verify for call state    console_list=console_1     state=Disconnected
   [Teardown]   Run Keywords    Capture Failure  AND     Come back to home screen page   console_list=console_1     AND     come back to calendar page on TDC   device=tdc_1:user

TC7:[Front Row] Verify that long press on chat reaction popup should not be appeared.
    [Tags]    380574    P2
    [Setup]   Testcase Setup for shared User    count=1
    Join the meeting
    Join a meeting   console=console_1      meeting=console_lock_meeting
    Verify for call state     console_list=console_1    state=Connected
    Change meeting mode     device=console_1    mode=front_row
    Verify front row mode   device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=checking for the testing purpose
    verify should not get the reaction pop up on chat layout    device=device_1
    Disconnect the call      console=console_1
    Disconnect the call on TDC      device=tdc_1:user
    Verify for call state    console_list=console_1     state=Disconnected
   [Teardown]   Run Keywords    Capture Failure  AND     Come back to home screen page   console_list=console_1     AND     come back to calendar page on TDC   device=tdc_1:user

TC8:[Front row] Verify that Tapping on profile of the participants in the chat should not be viewable.
    [Tags]    380575    P2
    [Setup]   Testcase Setup for shared User    count=1
    Join the meeting
    Join a meeting   console=console_1      meeting=console_lock_meeting
    Verify for call state     console_list=console_1    state=Connected
    Change meeting mode     device=console_1    mode=front_row
    Verify front row mode   device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=checking for the testing purpose on profile
    verify user should not get any popup while tapping on profile in chat tray      device=device_1
    Disconnect the call      console=console_1
    Disconnect the call on TDC      device=tdc_1:user
    Verify for call state    console_list=console_1     state=Disconnected
   [Teardown]   Run Keywords    Capture Failure  AND     Come back to home screen page   console_list=console_1     AND     come back to calendar page on TDC   device=tdc_1:user

TC9:[Chat] Start meet and check the chat window behavior in different layout.
    [Tags]    382114    P2
    [Setup]   Testcase Setup for shared User    count=1
    Join the meeting
    Join a meeting   console=console_1      meeting=console_lock_meeting
    Verify for call state     console_list=console_1    state=Connected
    User should check the chat window behavior in all layouts    console=console_1
    Disconnect the call      console=console_1
    Disconnect the call on TDC      device=tdc_1:user
    Verify for call state    console_list=console_1     state=Disconnected
   [Teardown]   Run Keywords    Capture Failure  AND     Come back to home screen page   console_list=console_1     AND     come back to calendar page on TDC   device=tdc_1:user

TC10:[Chat Bubbles] Verify design of bubbles matches spec in call & meeting also verify by pairing with console
    [Tags]    345345    P2
    [Setup]   Testcase Setup for shared User    count=1
    Join the meeting
    Join a meeting   console=console_1      meeting=console_lock_meeting
    Verify for call state     console_list=console_1    state=Connected
    Send the message from chat option in TDC  device=tdc_1:user     message=should show chat bubble
    Verify chat bubble message on device        device=device_1     state=on
    Disconnect the call      console=console_1
    Disconnect the call on TDC      device=tdc_1:user
    come back to calendar page on TDC    device=tdc_1:user
    Verify for call state    console_list=console_1     state=Disconnected
    Make the call from TDC
    Pick up incoming call    console=console_1
    Verify for call state     console_list=console_1    state=Connected
    Send the message from chat option in TDC  device=tdc_1:user     message=should show chat bubble in call
    Verify chat bubble message on device        device=device_1     state=on
    Disconnect the call      console=console_1
    [Teardown]   Run Keywords    Capture Failure  AND        Come back to home screen page   console_list=console_1     AND     come back to calling page on TDC    device=tdc_1:user

*** Keywords ***
Disable the show meeting chat option
    [Arguments]       ${console}
    Navigate to app settings screen    ${console}
    Navigate to meeting and calling options from device settings page       ${console}  option=meeting
    Enable and disable the chat toggle in admin setting     device=${console}       state=off
    come back from admin settings page      device_list=${console}

Navigate to app settings screen
    [Arguments]   ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Enable the show meeting chat option
    [Arguments]    ${console}
    Navigate to app settings screen    ${console}
    Navigate to meeting and calling options from device settings page       ${console}  option=meeting
    Enable and disable the chat toggle in admin setting     device=${console}       state=on
    come back from admin settings page      device_list=${console}

Signin user attend call and send the chat from TDC
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user

Join the meeting
    right click on created meeting from tdc       tdc_1:user     edit_meeting_name=console_lock_meeting   click=left
    join_the_meeting_in_TDC     device=tdc_1:user

verify chat option after disabeling
    verify_front_row_mode_after_disabeling_the_chat_option      device=console_1

Enable the show chat bubble option
    [Arguments]    ${console}
    Navigate to app settings screen    ${console}
    Navigate to meeting and calling options from device settings page       ${console}      option=meeting
    Enable and disable the chat toggle in admin setting     device=${console}       state=on        toggle=chat_bubble
    come back from admin settings page      device_list=${console}

Disable the show chat bubble option
    [Arguments]       ${console}
    Navigate to app settings screen    ${console}
    Navigate to meeting and calling options from device settings page       ${console}  option=meeting
    Enable and disable the chat toggle in admin setting     device=${console}       state=off       toggle=chat_bubble
    come back from admin settings page      device_list=${console}

User should not able to access the link on chat layer in all layouts
    [Arguments]       ${console}
    verify meeting chat     ${console}        action_type=modify
    verify meeting chat toggle on behaviour      device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=link
    Verify messages on chat layers      device=device_1     message=link        action_type=clicking
    Change meeting mode     device=${console}    mode=front_row
    Verify front row mode   device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=link
    Verify messages on chat layers      device=device_1     message=link        action_type=clicking

verify should not get the reaction pop up on chat layout
    [Arguments]    ${device}
    Verify messages on chat layers      ${device}     message=checking for the testing purpose        action_type=clicking

verify user should not get any popup while tapping on profile in chat tray
    [Arguments]    ${device}
    Verify messages on chat layers      ${device}     message=profile        action_type=clicking


User should check the chat window behavior in all layouts
    [Arguments]       ${console}
    verify meeting chat     ${console}        action_type=modify
    verify meeting chat toggle on behaviour      device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=checking for the testing purpose on all layouts
    Verify messages on chat layers      device=device_1     message=checking for the testing purpose on all layouts
    Change meeting mode     device=${console}    mode=front_row
    Verify front row mode   device=device_1
    Send the message from chat option in TDC  device=tdc_1:user     message=checking for the testing purpose on all layouts
    Verify messages on chat layers      device=device_1     message=checking for the testing purpose on all layouts


Make the call from TDC
    make outgoing call from TDC      device=tdc_1:user       to_device=console_1:meeting_user

*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot


*** Variables ***
${wait_time} =  3
${action_time} =  5
${wait_time1} =  10s

*** Test Cases ***
TC1:[HDMI]Verify DUT user is not getting HDMI option in meeting when disabled from General settings
    [Tags]     344615        P1         sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Navigate to admin setting and disable hdmi content sharing    device=device_1
    come back to homescreen from HDMI option    device=device_1
    Join Meeting    device=device_1           meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1         state=Connected
    verify share content hdmi is not present    device=device_1
    Wait for Some Time    time=${wait_time}
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure     AND    Navigate to admin setting and enable hdmi content sharing    device=device_1    AND  come back to homescreen from HDMI option    device=device_1

TC2: [HDMI Auto share]Verify when DUT user disable "Enable content sharing " Child options should also get disabled
    [Tags]     344646        P2
    [Setup]  Testcase Setup for Meeting User     count=1
    Navigate to admin setting and disable hdmi content sharing    device=device_1
    verify options under hdmi content sharing toggle    device=device_1     state=off
    come back to homescreen from HDMI option    device=device_1
    [Teardown]  Run Keywords   Capture on Failure     AND    Navigate to admin setting and enable hdmi content sharing    device=device_1    AND  come back to homescreen from HDMI option    device=device_1

TC3:[HDMI Audio]Verify DUT is displays a message when Audio is disabled by admin
    [Tags]     344620        P2
    [Setup]  Testcase Setup for Meeting User     count=1
    Navigate to admin setting and enable hdmi content sharing    device=device_1
    enable and disable share system audio    device=device_1    state=off
    come back to homescreen from HDMI option    device=device_1
    Join Meeting    device=device_1           meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1         state=Connected
    verify audio share title under share content in meeeting is present   device=device_1    state=disable
    Wait for Some Time    time=${wait_time}
    dismiss the popup screen    device=device_1
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure     AND    Navigate to admin setting and enable hdmi content sharing    device=device_1    AND  come back to homescreen from HDMI option    device=device_1

TC4:[HDMI Audio]Verify when DUT user enables parent toggle “HDMI content sharing”, child toggle “include audio” must be auto-enabled by default
    [Tags]     344637        P2    sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Navigate to admin setting and disable hdmi content sharing    device=device_1
    verify options under hdmi content sharing toggle    device=device_1     state=off
    Enable and disable hdmi content sharing     device=device_1    state=on
    verify options under hdmi content sharing toggle    device=device_1     state=on    child_toggle=include_audio_toggle
    come back to homescreen from HDMI option    device=device_1
    [Teardown]  Run Keywords   Capture on Failure     AND    Navigate to admin setting and enable hdmi content sharing    device=device_1    AND  come back to homescreen from HDMI option    device=device_1

TC5: [HDMI Audio]Verify user is able to disable/Enable HDMI ingest from Meeting setting
    [Tags]     344608        P2
    [Setup]  Testcase Setup for Meeting User     count=1
    Navigate to admin setting and disable hdmi content sharing    device=device_1
    come back to homescreen from HDMI option    device=device_1
    verify share option on home screen    device=device_1     state=off
    Navigate to admin setting and enable hdmi content sharing    device=device_1
    come back to homescreen from HDMI option    device=device_1
    verify share option on home screen    device=device_1     state=on
    [Teardown]  Run Keywords   Capture on Failure

TC6:[HDMI Audio]Verify user is able to see HDMI option under Meeting setting
    [Tags]     344606        P2
    [Setup]  Testcase Setup for Meeting User     count=1
    navigate to teams admin settings page   device=device_1
    verify content sharing options is present   device=device_1
    Come back from admin settings page     device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure

TC7:[HDMI Auto share]Verify user set prerequisites are reset after sign out and Sign in on the device
    [Tags]     344655       P2
    [Setup]  Testcase Setup for Meeting User     count=1
    Navigate to admin setting and disable hdmi content sharing    device=device_1
    Come back from admin settings page     device_list=device_1
    Sign out method    device=device_1
    Validate that signin is successfully completed    device_list=device_1     state=sign out
    Sign in method     device=device_1  user=meeting_user
    Validate that signin is successfully completed    device_list=device_1     state=Sign in
    navigate to teams admin settings page      device=device_1
    verify options under hdmi content sharing toggle    device=device_1     state=on
    Come back from admin settings page     device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure

TC8:[HDMI Auto share]verify when DUT user enables the child toggle, the parent toggle must auto-enable
    [Tags]     344656       P2
    [Setup]  Testcase Setup for Meeting User     count=1
    Navigate to admin setting and disable hdmi content sharing    device=device_1
    verify options under hdmi content sharing toggle    device=device_1     state=off
    enable and disable share system audio    device=device_1    state=on
    verify options under hdmi content sharing toggle    device=device_1     state=on
    Come back from admin settings page     device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure

TC9:[HDMI Auto share]Verify when DUT user disables "Child options" Parent HDMI option is not getting disabled
    [Tags]     344649       P1    sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    navigate to teams admin settings page   device=device_1
    verify options under hdmi content sharing toggle    device=device_1     state=on
    enable and disable share system audio    device=device_1    state=off
    verify options under hdmi content sharing toggle    device=device_1     state=on
    Come back from admin settings page     device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure

TC10:[HDMI Audio]Verify DUT is displaying HDMI option with Enable/disable audio option when in Meeting
    [Tags]     344617
    [Setup]  Testcase Setup for Meeting User     count=1
    Navigate to admin setting and enable hdmi content sharing    device=device_1
    enable and disable share system audio    device=device_1    state=on
    come back to homescreen from HDMI option    device=device_1
    Join Meeting    device=device_1           meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1         state=Connected
    verify audio share title under share content in meeeting is present   device=device_1    state=enable
    Wait for Some Time    time=${wait_time}
    dismiss the popup screen    device=device_1
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure     AND    Navigate to admin setting and enable hdmi content sharing    device=device_1    AND  come back to homescreen from HDMI option    device=device_1

TC10: [HDMI Auto share]Verify user set conditions HDMI setting are maintained when user reboot the device
    [Tags]     344652
    [Setup]  Testcase Setup for Meeting User     count=1
    Navigate to admin setting and disable hdmi content sharing    device=device_1
    come back to homescreen from HDMI option    device=device_1
    Come back from admin settings page     device_list=device_1
    Reboot Norden Or Console        device=device_1
    Navigate to app settings page    device=device_1
    navigate to meetings option in device settings page      device=device_1
    verify content sharing options is present   device=device_1
    verify options under hdmi content sharing toggle    device=device_1     state=off
    come back to homescreen from HDMI option    device=device_1
    [Teardown]  Run Keywords   Capture on Failure     AND    Navigate to admin setting and enable hdmi content sharing    device=device_1    AND  come back to homescreen from HDMI option    device=device_1

TC11:[HDMI Audio] "include audio" is enabled back once DUT ends first Meeting and Joins the Second meeting
    [Tags]     344638
    [Setup]  Testcase Setup for Meeting User     count=1
    Navigate to admin setting and enable hdmi content sharing    device=device_1
    come back to homescreen from HDMI option    device=device_1
    Come back from admin settings page     device_list=device_1
    Join Meeting    device=device_1           meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1         state=Connected
    enable and disable share system audio under meeting    device=device_1     state=off
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    Join Meeting    device=device_1           meeting=lock_meeting
    Verify meeting state   device_list=device_1         state=Connected
    verify share system audio toggle under meeting   device=device_1    state=on
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure     AND  come back to homescreen from HDMI option    device=device_1

*** Keywords ***
Navigate back from the device settings page
    [Arguments]     ${device}
    Click close btn    device_list=${device}
    device setting back     ${device}
    device setting back     ${device}
    Click close btn    device_list=${device}

Navigate to admin setting and enable hdmi content sharing
    [Arguments]     ${device}
    Navigate to app settings page    ${device}
    navigate to meetings option in device settings page      ${device}
    verify content sharing options is present   device=${device}
    Enable and disable hdmi content sharing     device=${device}     state=on

Navigate to admin setting and disable hdmi content sharing
    [Arguments]     ${device}
    Navigate to app settings page    ${device}
    navigate to meetings option in device settings page      ${device}
    verify content sharing options is present   device=${device}
    Enable and disable hdmi content sharing     device=${device}     state=off

come back to homescreen from HDMI option
    [Arguments]     ${device}
    Come back from admin settings page      device_list=${device}
    Come back to home screen    device_list=${device}

*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***

*** Test Cases ***
TC1:[Automatic Framing] Verify the Room Camera under the Teams App Settings.
    [Tags]      381002      bvt_sm     sanity_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Navigate to device option under teams admin setting    device=device_1
    Verify the options inside the devices       device=device_1
    Come back from admin settings page     device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC2:[Automatic Framing] Verify the options under Automatic Framing when DUT user disables the toggle button.
    [Tags]      381083      bvt_sm     sanity_sm        exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Navigate to device option under teams admin setting    device=device_1
    navigate to automatic framing under teams admin settings     device=device_1
    Enable and disable automatic framing toggle     device=device_1                   state=off
    verify automatic framing options are disabled       device=device_1
    Come back from admin settings page     device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure    AND   Enable automatic framing toggle      device=device_1     state=on    AND    Come back to home screen    device_list=device_1

TC3:[Automatic Framing] Verify the functionality of Automatic Framing option when DUT user joined the meeting.
    [Tags]      381102         sanity_sm        exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    Navigate to device option under teams admin setting    device=device_1
    navigate to automatic framing under teams admin settings     device=device_1
    Enable and disable automatic framing toggle     device=device_1       state=on
    Come back from admin settings page     device_list=device_1
    Join meeting    device=device_1,device_2   meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_2   state=Connected
    verify and click drop down icon in call control bar      device=device_1
    verify automatic framing options    device=device_1
    verify and click drop down icon in call control bar      device=device_1
    Enable and disable automatic framing toggle     device=device_1                   state=off
    verify automatic framing options are disabled       device=device_1
    End meeting   device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Enable automatic framing toggle      device=device_1    state=on    AND     Come back to home screen    device_list=device_1,device_2

TC4:[Automatic Framing] Verify the options under Room Camera option under the Teams App Settings.
    [Tags]      381068     P2       exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Navigate to device option under teams admin setting    device=device_1
    Verify the options inside the devices       device=device_1
    Come back from admin settings page     device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC5:[Automatic Framing] Verify the Automatic Framing toggle button under Room Camera.
    [Tags]      381074     P2       exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Navigate to device option under teams admin setting    device=device_1
    navigate to automatic framing under teams admin settings     device=device_1
    verify automatic framing options    device=device_1
    Come back from admin settings page     device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC6:[Automatic Framing] Verify the Automatic Framing option when DUT user joined the meeting.
    [Tags]      381096     P2       exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Join meeting    device=device_1,device_2   meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_2   state=Connected
    verify and click drop down icon in call control bar      device=device_1
    verify automatic framing options    device=device_1
    End meeting   device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1,device_2

TC7:[Automatic Framing] Verify Automatic Framing option is available in Meet now Meetings.
    [Tags]   381112             P2      exclude_ftp_sm
    [Setup]   Testcase Setup for Meeting User     count=2
    Initiates conference meeting using Meet now option     from_device=device_2     to_device=device_1:meeting_user
    Accept incoming call    device=device_1
    Close participants screen   device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify and click drop down icon in call control bar      device=device_1
    verify automatic framing options    device=device_1
    End meeting   device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC8:[Automatic Framing] Verify DUT is not displaying Camera Drop down option when Disabled from Admin setting.
    [Tags]   381139          P1
    [Setup]   Testcase Setup for Meeting User     count=2
    Navigate to device option under teams admin setting    device=device_1
    navigate to automatic framing under teams admin settings     device=device_1
    Enable and disable automatic framing toggle     device=device_1    state=off
    verify automatic framing options are disabled       device=device_1
    Come back from admin settings page     device_list=device_1
    Join meeting    device=device_1,device_2   meeting=lock_meeting
    Verify meeting state   device_list=device_1,device_2   state=Connected
    verify drop down icon in call control bar is present or not    device=device_1    state=on
    End meeting   device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure   AND   Enable automatic framing toggle      device=device_1    state=on    AND     Come back to home screen    device_list=device_1,device_2

TC9:[Automatic Framing] Verify the options under the content camera under Teams App Settings.
    [Tags]      381087     P2
    [Setup]  Testcase Setup for Meeting User     count=1
    Navigate to device option under teams admin setting    device=device_1
    navigate to content camera under teams admin settings     device=device_1
    Come back from admin settings page     device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC10:[Content Camera] Verify DUT is Displaying Content Camera option under Teams Admin Setting.
    [Tags]      380796     P1    sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Navigate to device option under teams admin setting    device=device_1
    navigate to content camera under teams admin settings     device=device_1
    Come back from admin settings page     device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC11:[Content Camera] Verify Options displayed under Teams Admin setting devices.
    [Tags]      380802     P1    sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    Navigate to device option under teams admin setting    device=device_1
    Verify the options inside the devices       device=device_1
    Come back from admin settings page     device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC12:[Room Camera]Verify DUT is displaying Devices option under the teams admin settings.
    [Tags]      381028  P1      sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
	Navigate to app settings page    device=device_1
	Navigate to teams admin settings      device=device_1
	Verify room camera option under admin settings  device=device_1
    Come back from admin settings page     device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC13:[Room Remote] Enable Room Remote
    [Tags]    260542        P2
    [Setup]    Testcase Setup for Meeting User     count=1
	Navigate to teams admin settings page       device=device_1
    Navigate and verify teams setting option from device settings page   device=device_1    option=general
	Verify room remote option under admin settings      device=device_1
	Validate the functionality of room remote toggle btn    device=device_1    state=on
    Come back from admin settings page     device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC14:[Room Camera] Verify the option present under "Automatic framing" under Room camera.
    [Tags]    381064    P2
    [Setup]    Testcase Setup for Meeting User     count=1
    Navigate to device option under teams admin setting    device=device_1
    Navigate to automatic framing under teams admin settings     device=device_1
    Verify source under room camera     device=device_1
    Verify automatic framing options    device=device_1
    Come back from admin settings page     device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC15:[Room Camera] Verify Default camera in an ongoing meeting when no external camera is connected.
    [Tags]    381033    P2
    [Setup]    Testcase Setup for Meeting User     count=2
    ${room_camera_support}   room camera supported devices   device=device_1
    pass execution if   '${room_camera_support}'=='False'  device_1, device is not supported for room camera
    Navigate to device option under teams admin setting    device=device_1
    User click room camera      device=device_1
    verify default and external cam names   device=device_1		camera_type=default
    Come back from admin settings page     device_list=device_1
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=cnf_device_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify call control bar   device_list=device_1
    verify and click drop down icon in call control bar      device=device_1
    verify default camera       device=device_1
    navigate back to meeting     device=device_1
    End meeting   device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***
Navigate back from the device settings page
    [Arguments]     ${device}
    device setting back     ${device}
    device setting back     ${device}
    come back to home screen  ${device}

Enable automatic framing toggle
    [Arguments]    ${device}    ${state}
    Navigate to device option under teams admin setting    ${device}
    navigate to automatic framing under teams admin settings    ${device}
    Enable and disable automatic framing toggle     ${device}       ${state}

Navigate to device option under teams admin setting
    [Arguments]    ${device}
    Navigate to teams admin settings page       ${device}
    navigate and verify teams setting option from device settings page      ${device}   option=devices

navigate back to meeting
    [Arguments]    ${device}
    click back btn      ${device}
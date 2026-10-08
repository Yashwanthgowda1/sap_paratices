*** Settings ***
Documentation   Ensure 2 external cameras are connected to device.
Resource    ../../resources/keywords/common.robot
Force Tags      room_camera

Suite Setup     user to select default camera and come back to home screen     device=console_1		camera_type=default
Suite Teardown      Suite Failure Capture

*** Variables ***

*** Test Cases ***
TC1:[Room Camera] Verify the Devices option under the teams admin settings once DUT is connected with external camera.
    [Tags]    381454    sanity_tc_sm      exclude_ftp_sm
    [Setup]  Testcase Setup for shared User       count=1
    ${room_camera_support}   room camera supported devices   device=console_1
    pass execution if   '${room_camera_support}'=='False'  console_1, console_1 is not supported for room camera
    Navigate to app settings screen        console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    User click room camera      device=console_1
    verify default and external cam names   device=console_1		camera_type=default
    verify default and external cam names   device=console_1		camera_type=external_1
    user to select camera   device=console_1		camera_type=default
    [Teardown]      Console room camera teardown

TC2:[Room Camera] DUT user to verify multiple cameras present under "Room Camera"
    [Tags]    381459    P2      exclude_ftp_sm
    [Setup]  Testcase Setup for shared User       count=1
    ${room_camera_support}   room camera supported devices   device=console_1
    pass execution if   '${room_camera_support}'=='False'  console_1, console_1 is not supported for room camera
    Navigate to app settings screen        console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    User click room camera      device=console_1
    verify default and external cam names    device=console_1		camera_type=default
    verify default and external cam names    device=console_1     camera_type=external_1
    user to select camera   device=console_1		camera_type=default
    [Teardown]      Console room camera teardown
    
TC3:[Room Camera] Verify that Default camera should be selected when no camera is selected.
    [Tags]    381462    P2      exclude_ftp_sm
    [Setup]  Testcase Setup for shared User       count=1
    ${room_camera_support}   room camera supported devices   device=console_1
    pass execution if   '${room_camera_support}'=='False'  console_1, console_1 is not supported for room camera
    Navigate to app settings screen        console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    User click room camera      device=console_1
    user to select camera   device=console_1		camera_type=default
    verify selected camera   device=console_1		camera_type=default
    [Teardown]      Console room camera teardown
    
TC4:[Room Camera] Verify Automatic/Enhanced framing option enable under "Room camera."
    [Tags]    381463    P2      exclude_ftp_sm
    [Setup]  Testcase Setup for shared User       count=1
    ${room_camera_support}   room camera supported devices   device=console_1
    pass execution if   '${room_camera_support}'=='False'  console_1, console_1 is not supported for room camera
    Navigate to app settings screen        console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    User click room camera      device=console_1
    user to select camera   device=console_1		camera_type=default
    navigate to automatic framing under teams admin settings     device=console_1
    verify default and external cam names    device=console_1		camera_type=default
    [Teardown]      Console room camera teardown

TC5:[Room Camera] Verify Default camera in an ongoing meeting when 2 external camera is connected.
    [Tags]    381456    P2      exclude_ftp_sm
    [Setup]  Testcase Setup for shared User       count=2
    ${room_camera_support}   room camera supported devices   device=console_1
    pass execution if   '${room_camera_support}'=='False'  console_1, console_1 is not supported for room camera
    Navigate to app settings screen        console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    User click room camera      device=console_1
    verify default and external cam names   device=console_1		camera_type=default
    verify default and external cam names   device=console_1		camera_type=external_1
    Come back from admin settings page     device_list=console_1
    Verify meeting display on home screen     device=console_1
    Join a meeting   console=console_1     device=device_2    meeting=room_camera_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Validate call control bar options    console=console_1
    verify and click drop down icon in call control bar      device=console_1
    verify default and external cam names   device=console_1		camera_type=default
    verify default and external cam names   device=console_1		camera_type=external_1
    Dismiss the pop-up
    End up call     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]      Console room camera teardown with select default camera     device=console_1		camera_type=default

TC6:[Room Camera] DUT user should be able to select the other external camera in an ongoing meeting.
    [Tags]    381457    bvt_tc_sm   sanity_tc_sm      exclude_ftp_sm
    [Setup]  Testcase Setup for shared User       count=2
    ${room_camera_support}   room camera supported devices   device=console_1
    pass execution if   '${room_camera_support}'=='False'  console_1, console_1 is not supported for room camera
    Navigate to app settings screen        console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    User click room camera      device=console_1
    verify default and external cam names   device=console_1		camera_type=default
    verify default and external cam names   device=console_1		camera_type=external_1
    Come back from admin settings page     device_list=console_1
    Verify meeting display on home screen     device=console_1
    Join a meeting   console=console_1     device=device_2    meeting=room_camera_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Validate call control bar options    console=console_1
    verify and click drop down icon in call control bar      device=console_1
    verify default and external cam names   device=console_1		camera_type=default
    user to select camera   device=console_1		camera_type=external_1
    verify selected camera   device=console_1		camera_type=external_1
    user to select camera   device=console_1		camera_type=external_2
    verify selected camera   device=console_1		camera_type=external_2
    Dismiss the pop-up
    End up call     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]      Console room camera teardown with select default camera     device=console_1		camera_type=default

TC7:[Room Camera] DUT user tries to edit the room camera setting, once user in an ongoing meeting when multiple external cameras is connected.
    [Tags]    381458    P2      exclude_ftp_sm
    [Setup]  Testcase Setup for shared User       count=2
    ${room_camera_support}   room camera supported devices   device=console_1
    pass execution if   '${room_camera_support}'=='False'  console_1, console_1 is not supported for room camera
    Navigate to app settings screen        console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    User click room camera      device=console_1
    verify default and external cam names   device=console_1		camera_type=default
    verify default and external cam names   device=console_1		camera_type=external_1
    Come back from admin settings page     device_list=console_1
    Verify meeting display on home screen     device=console_1
    Join a meeting   console=console_1     device=device_2    meeting=room_camera_meeting
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    Validate call control bar options    console=console_1
    verify and click drop down icon in call control bar      device=console_1
    verify default and external cam names   device=console_1		camera_type=default
    user to select camera   device=console_1		camera_type=external_1
    verify selected camera   device=console_1		camera_type=external_1
    user to select camera   device=console_1		camera_type=external_2
    verify selected camera   device=console_1		camera_type=external_2
    Dismiss the pop-up
    End up call     console=console_1       device=device_2
    Verify for meeting state    console_list=console_1      device_list=device_2      state=Disconnected
    [Teardown]      Console room camera teardown with select default camera     device=console_1		camera_type=default

TC8:[Room Camera] Verify that DUT is able to access External Multiple cameras present under "Device" option.
    [Tags]    381460    bvt_tc_sm   sanity_tc_sm      exclude_ftp_sm
    [Setup]  Testcase Setup for shared User       count=1
    ${room_camera_support}   room camera supported devices   device=console_1
    pass execution if   '${room_camera_support}'=='False'  console_1, console_1 is not supported for room camera
    Navigate to app settings screen        console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    User click room camera      device=console_1
    verify default and external cam names    device=console_1		camera_type=default
    verify default and external cam names    device=console_1     camera_type=external_1
    verify default and external cam names    device=console_1     camera_type=external_2
    user to select camera   device=console_1		camera_type=external_1
    verify selected camera   device=console_1		camera_type=external_1
    user to select camera   device=console_1		camera_type=default
    [Teardown]      Console room camera teardown

TC9:[Room Camera] Verify that DUT user should be able to enable/disable "Automatic framing" option under Room camera.
    [Tags]    381464    P2      exclude_ftp_sm
    [Setup]  Testcase Setup for shared User       count=1
    ${room_camera_support}   room camera supported devices   device=console_1
    pass execution if   '${room_camera_support}'=='False'  console_1, console_1 is not supported for room camera
    Navigate to app settings screen        console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
	User click room camera      device=console_1
	user to select camera   device=console_1		camera_type=default
    Enable and disable automatic framing toggle     device=console_1    state=on
    verify automatic framing options    device=console_1
	User click room camera      device=console_1
    user to select camera   device=console_1		camera_type=default
    Enable and disable automatic framing toggle     device=console_1    state=off
    verify automatic framing options are disabled       device=console_1
    [Teardown]      Console room camera teardown

TC10:[Room Camera] Verify the option present under "Enhanced framing" under Room camera.
    [Tags]    381465    P2      exclude_ftp_sm
    [Setup]  Testcase Setup for shared User       count=1
    ${room_camera_support}   room camera supported devices   device=console_1
    pass execution if   '${room_camera_support}'=='False'  console_1, console_1 is not supported for room camera
    Navigate to app settings screen        console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    navigate to automatic framing under teams admin settings     device=console_1
    verify automatic framing options    device=console_1
    [Teardown]      Console room camera teardown

TC11:[Room Camera] Verify Room Camera preview is displayed when user select room camera.
    [Tags]    381467    P2      exclude_ftp_sm
    [Setup]  Testcase Setup for shared User       count=1
    ${room_camera_support}   room camera supported devices   device=console_1
    pass execution if   '${room_camera_support}'=='False'  console_1, console_1 is not supported for room camera
    Navigate to app settings screen        console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    User click room camera      device=console_1
    Verify source under room camera     device=console_1
    [Teardown]      Console room camera teardown

*** Keywords ***

Console room camera teardown
    Capture Failure
    Come back from admin settings page    device_list=console_1
    Come back to home screen page   console_list=console_1

Console room camera teardown with select default camera
    [Arguments]    ${device}    ${camera_type}
    Capture Failure
    Navigate to app settings screen        console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    User click room camera      ${device}
    user to select camera       ${device}    ${camera_type}
    Come back from admin settings page     device_list=${device}
    Come back to home screen    device_list=console_1,device_2

Navigate to app settings screen
    [Arguments]   ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

End up call
    [Arguments]    ${console}    ${device}
    Disconnect the call  ${console}
    Disconnect call     ${device}

Dismiss the pop-up
    dismiss the popup screen    device=console_1

user to select default camera and come back to home screen
    [Arguments]    ${device}    ${camera_type}
    Navigate to app settings screen        console=console_1
    Navigate to meeting and calling options from device settings page       console=console_1   option=devices
    User click room camera      ${device}
    user to select camera       ${device}    ${camera_type}
    Come back from admin settings page     device_list=console_1
*** Settings ***
Documentation   Ensure 2 external cameras are connected to device.
Resource    ../../resources/keywords/common.robot
Force Tags      room_camera

Suite Setup     user to select default camera and come back to home screen     device=device_1		camera_type=default
Suite Teardown      Suite Failure Capture

*** Variables ***

*** Test Cases ***
TC1:[Room Camera] Verify the Devices option under the teams admin settings once DUT is connected with external camera.
    [Tags]      381029    sanity_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    ${room_camera_support}   room camera supported devices   device=device_1
    pass execution if   '${room_camera_support}'=='False'  device_1, device is not supported for room camera
    Navigate to device option under teams admin setting    device=device_1
    User click room camera      device=device_1
    verify default and external cam names   device=device_1		camera_type=default
    verify default and external cam names   device=device_1		camera_type=external_1
    user to select camera   device=device_1		camera_type=default
    [Teardown]  room camera teardown    device_list=device_1

TC2:[Room Camera] Verify Default camera in an ongoing meeting when external camera is connected.
    [Tags]      381034      P2    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    ${room_camera_support}   room camera supported devices   device=device_1
    pass execution if   '${room_camera_support}'=='False'  device_1, device is not supported for room camera
    Navigate to device option under teams admin setting    device=device_1
    User click room camera      device=device_1
    verify default and external cam names   device=device_1		camera_type=default
    verify default and external cam names   device=device_1		camera_type=external_1
    Come back from admin settings page     device_list=device_1
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=room_camera_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify call control bar   device_list=device_1
    verify and click drop down icon in call control bar      device=device_1
    verify default and external cam names   device=device_1		camera_type=default
    verify default and external cam names   device=device_1		camera_type=external_1
    navigate back to meeting      device=device_1
    End meeting   device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  room camera teardown with select default camera     device=device_1		camera_type=default

TC3:[Room Camera] Verify that DUT is able to access External Multiple cameras present under "Device" option.
    [Tags]      381057      bvt_sm    sanity_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    ${room_camera_support}   room camera supported devices   device=device_1
    pass execution if   '${room_camera_support}'=='False'  device_1, device is not supported for room camera
    Navigate to device option under teams admin setting    device=device_1
    User click room camera      device=device_1
    verify default and external cam names    device=device_1		camera_type=default
    verify default and external cam names    device=device_1     camera_type=external_1
    verify default and external cam names    device=device_1     camera_type=external_2
    user to select camera   device=device_1		camera_type=external_1
    verify selected camera   device=device_1		camera_type=external_1
    user to select camera   device=device_1		camera_type=default
    [Teardown]      room camera teardown    device_list=device_1

TC4:[Room Camera] DUT user to verify multiple cameras present under "Room Camera"
    [Tags]      381056      P2      exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    ${room_camera_support}   room camera supported devices   device=device_1
    pass execution if   '${room_camera_support}'=='False'  device_1, device is not supported for room camera
    Navigate to device option under teams admin setting    device=device_1
    User click room camera      device=device_1
    verify default and external cam names    device=device_1		camera_type=default
    verify default and external cam names    device=device_1     camera_type=external_1
    user to select camera   device=device_1		camera_type=default
    [Teardown]  room camera teardown    device_list=device_1

TC5:[Room Camera] Verify that Default camera should be selected when no camera is selected.
    [Tags]      381060      P2    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    ${room_camera_support}   room camera supported devices   device=device_1
    pass execution if   '${room_camera_support}'=='False'  device_1, device is not supported for room camera
    Navigate to device option under teams admin setting    device=device_1
    User click room camera      device=device_1
    user to select camera   device=device_1		camera_type=default
    verify selected camera   device=device_1		camera_type=default
    [Teardown]  room camera teardown    device_list=device_1

TC6: [Room Camera] Verify Automatic framing option enable under "Room camera."
    [Tags]    381062    P2      exclude_ftp_sm
    [Setup]    Testcase Setup for Meeting User     count=1
    ${room_camera_support}   room camera supported devices   device=device_1
    pass execution if   '${room_camera_support}'=='False'  device_1, device is not supported for room camera
    Navigate to device option under teams admin setting    device=device_1
    User click room camera      device=device_1
    user to select camera   device=device_1		camera_type=default
    device setting back     device=device_1
    navigate to automatic framing under teams admin settings     device=device_1
    verify default and external cam names    device=device_1		camera_type=default
    [Teardown]  room camera teardown    device_list=device_1

TC7:[Room Camera] DUT user should be able to select the other external camera in an ongoing meeting.
    [Tags]      381035      bvt_sm    sanity_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    ${room_camera_support}   room camera supported devices   device=device_1
    pass execution if   '${room_camera_support}'=='False'  device_1, device is not supported for room camera
    Navigate to device option under teams admin setting    device=device_1
    User click room camera      device=device_1
    verify default and external cam names   device=device_1		camera_type=default
    verify default and external cam names   device=device_1		camera_type=external_1
    Come back from admin settings page     device_list=device_1
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=room_camera_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify call control bar   device_list=device_1
    verify and click drop down icon in call control bar      device=device_1
    verify default and external cam names   device=device_1		camera_type=default
    user to select camera   device=device_1		camera_type=external_1
    verify selected camera   device=device_1		camera_type=external_1
    user to select camera   device=device_1		camera_type=external_2
    verify selected camera   device=device_1		camera_type=external_2
    navigate back to meeting      device=device_1
    End meeting   device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  room camera teardown with select default camera     device=device_1		camera_type=default

TC8:[Room Camera] DUT user tries to edit the room camera setting, once user in an ongoing meeting when multiple external cameras is connected.
    [Tags]      381055      P2    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    ${room_camera_support}   room camera supported devices   device=device_1
    pass execution if   '${room_camera_support}'=='False'  device_1, device is not supported for room camera
    Navigate to device option under teams admin setting    device=device_1
    User click room camera      device=device_1
    verify default and external cam names   device=device_1		camera_type=default
    verify default and external cam names   device=device_1		camera_type=external_1
    Come back from admin settings page     device_list=device_1
    Verify meeting display on home screen     device=device_1
    Join meeting   device=device_1,device_2    meeting=room_camera_meeting
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Verify call control bar   device_list=device_1
    verify and click drop down icon in call control bar      device=device_1
    verify default and external cam names   device=device_1		camera_type=default
    user to select camera   device=device_1		camera_type=external_1
    verify selected camera   device=device_1		camera_type=external_1
    user to select camera   device=device_1		camera_type=external_2
    verify selected camera   device=device_1		camera_type=external_2
    navigate back to meeting      device=device_1
    End meeting   device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  room camera teardown with select default camera     device=device_1		camera_type=default

TC9:[Room camera] [Room Camera] Verify that DUT user should be able to enable/disable "Automatic framing" option under Room camera.
    [Tags]      381063      P2    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    ${room_camera_support}   room camera supported devices   device=device_1
    pass execution if   '${room_camera_support}'=='False'  device_1, device is not supported for room camera
    Navigate to device option under teams admin setting    device=device_1
    Navigate to automatic framing under teams admin settings     device=device_1
    Verify source under room camera     device=device_1
    [Teardown]  room camera teardown    device_list=device_1

TC10:[Room Camera]verify DUT user is able to select multiple Room Camera device connected from Drop Down.
    [Tags]      381067      sanity_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    ${room_camera_support}   room camera supported devices   device=device_1
    pass execution if   '${room_camera_support}'=='False'  device_1, device is not supported for room camera
    Navigate to device option under teams admin setting    device=device_1
    User click room camera      device=device_1
    verify video preview        device=device_1
    User to select camera   device=device_1     camera_type=default
    Verify selected camera   device=device_1        camera_type=default
    verify default and external cam names   device=device_1		camera_type=external_1
    verify default and external cam names   device=device_1		camera_type=external_2
    [Teardown]  room camera teardown    device_list=device_1

TC11:[Room camera] Verify Room Camera names displayed under Room camera.
    [Tags]      381079      P2    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    ${room_camera_support}   room camera supported devices   device=device_1
    pass execution if   '${room_camera_support}'=='False'  device_1, device is not supported for room camera
    Navigate to device option under teams admin setting    device=device_1
    User click room camera      device=device_1
    verify video preview        device=device_1
    Verify source under room camera     device=device_1
    [Teardown]  room camera teardown    device_list=device_1

*** Keywords ***
Navigate to device option under teams admin setting
    [Arguments]    ${device}
    Navigate to teams admin settings page       ${device}
    navigate and verify teams setting option from device settings page      ${device}   option=devices

navigate back to meeting
    [Arguments]    ${device}
    device setting back     ${device}

user to select default camera and come back to home screen
    [Arguments]    ${device}    ${camera_type}
    Navigate to device option under teams admin setting    ${device}
    User click room camera      ${device}
    user to select camera       ${device}    ${camera_type}
    Come back from admin settings page     device_list=device_1

room camera teardown
    [Arguments]    ${device_list}
    Capture on Failure
    Come back from admin settings page     ${device_list}
    Come back to home screen    ${device_list}

room camera teardown with select default camera
    [Arguments]    ${device}    ${camera_type}
    Capture on Failure
    Navigate to device option under teams admin setting    ${device}
    User click room camera      ${device}
    user to select camera       ${device}    ${camera_type}
    Come back from admin settings page     device_list=${device}
    Come back to home screen    device_list=device_1,device_2
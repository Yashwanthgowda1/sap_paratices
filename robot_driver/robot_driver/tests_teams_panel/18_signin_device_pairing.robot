*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1:[Panels]Verify the Account sign in and Device pairing with only "Teams Shared Device license(CAP)" assigned account.
	[Tags]  416687
	[Setup]  Testcase Setup  count=2
	Signin with other user    device=device_1   other_user_account=device_1:cap_user
	#Signin with other user    device=device_2   other_user_account=device_2:cap_user
	[Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC2:[Panels]Verify the Account sign in and Device pairing options with only a "Pro" license assigned account.
	[Tags]  416688      exclude_pairing
	[Setup]  Teams Panel along with Rooms Setup
	navigate to device pairing option in panel app settings   device=device_1    pair_status=paired
	verify device is paired     device=device_1
	[Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2    AND    Reset device pairing

TC3:[Panels]Verify Device pairing with norden Device using only "Pro" license assigned account.
	[Tags]  416693      exclude_pairing
	[Setup]  Teams Panel along with Rooms Setup
	navigate to device pairing option in panel app settings   device=device_1    pair_status=paired
	verify device is paired     device=device_1
	[Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

*** Keywords ***

Teams Panel along with Rooms Setup
    Testcase Setup  count=2
    Pair Panel and Rooms device
    Come back to home screen    device_list=device_1

Pair Panel and Rooms device
    navigate to device pairing option in panel app settings   device=device_1    pair_status=unpaired
    select rooms device to pair from panel   from_device=device_1    to_device=device_2
    get pairing code from rooms device    from_device1=device_2  to_device1=device_1

navigate to device pairing option in panel app settings
    [Arguments]     ${device}   ${pair_status}
    Navigation to settings page in panel  device=device_1
    verify device settings option in panel  device=device_1
    navigate inside of teams admin settings in panel    device=device_1
    navigate to device pairing tab on panel     device=device_1     pair_status=${pair_status}

Teams Panel along with Rooms Setup for CAP User
    Pair Panel and Rooms device
    Come back to home screen    device_list=device_1

Reset device pairing
    navigate to device pairing option in panel app settings  device=device_1     pair_status=paired
    reset device pairing in panel  device=device_1
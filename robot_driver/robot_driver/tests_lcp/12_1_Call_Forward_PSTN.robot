*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown      run keywords   Suite Failure Capture     AND     Disable unanswered call   device=device_1    contact_device=device_2

*** Variables ***


*** Test Cases ***
TC1 : [Call Forward] DUT user to forward PSTN call to voicemail
	[Tags]  242928    tp_lcp
	[Setup]  Testcase Setup for PSTN User         count=2
	Enable unanswered call to voicemail    from_device=device_1    contact_device=device_2
	navigate to calls tab  device=device_2
	Make outgoing call using phonenumber    from_device=device_2    to_device=device_1
	verify incoming call    device=device_1    status=appear
	Wait For Some Time    time=50s
	Verify Call State    device_list=device_2    state=Connected
	Verify Call State    device_list=device_1    state=disconnected
	Wait for Some Time    time=${wait_time}
	Disconnect call    device=device_2
	Verify Call State    device_list=device_2     state=Disconnected
	Verify Call State    device_list=device_1,device_2    state=disconnected
	Navigate to voicemail tab    device=device_1
	verify first voicemail displayname    to_device=device_1    from_device=device_2:pstn_user
	Play voicemail    device=device_1
	[Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

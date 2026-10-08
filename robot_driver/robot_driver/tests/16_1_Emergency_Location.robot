*** Settings ***
Resource    resources/keywords/common.robot

Suite Teardown      Run Keywords    Suite Failure Capture

*** Variables ***

*** Test Cases ***

TC1 : [Emergency Location] Verify “Emergency Location” is available under contacts card (user profile) screen.
    [Tags]      381954   P0     sanity_tp   bvt_tp
    [Setup]  Testcase Setup    count=1
    verify set your emergency location option under user profile    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC2: [Emergency Location] Confirm Add location dialog is displayed when your clicks “Add your location” on “Location not detected” banner
    [Tags]	381957	tp_audio
    [Setup]    Testcase setup	count=1
    Navigate To Calls Tab    device=device_1
	Verify Presence Of Location Not Detected Banner In Calls Tab    device=device_1    action=add
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC3 : [Emergency Location]Verifying the banner in calls tab after restarting the DUT.
    [Tags]    381978    p2
    [Setup]  Testcase Setup    count=1
    Navigate To Calls Tab    device=device_1
    Verify Presence Of Location Not Detected Banner In Calls Tab    device=device_1
    Reboot Phones    device=device_1
    Navigate To Calls Tab    device=device_1
    Verify Presence Of Location Not Detected Banner In Calls Tab    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC4 : [Emergency Location]Verify suggestion displayed properly while adding "Country/region" fields
    [Tags]    381979    p2
    [Setup]  Testcase Setup    count=1
    verify set your emergency location option under user profile    device=device_1
    Add Emergency Location    device=device_1
    Verify Emergency Location       device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC5: [Emergency Location] Verify Set/Added Emergency Location should display when user sign out and signed in with same account.
    [Tags]    388116        tp_audio
    [Setup]  Testcase Setup    count=1
    verify set your emergency location option under user profile    device=device_1
    Add Emergency Location    device=device_1
    Verify Emergency Location       device=device_1
    Sign Out Method    device=device_1
    sign in method     device=device_1
    verify set your emergency location option under user profile    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC6: [Emergency Location]Confirm location you added is visible on Emergency location view, Profile view and from Settings > Calling > Emergency location section
    [Tags]    381961        Sanity_TP    tp_audio
    [Setup]  Testcase Setup    count=1
    Navigate To Calls Tab    device=device_1
    Verify Presence Of Location Not Detected Banner In Calls Tab    device=device_1    action=add
    Add Emergency Location    device=device_1
    Click On Home Bar Icon    device=device_1
    Verify Emergency Location Option Under Callings Settings    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC7:[Emergency Location]Verify “Location not detected” banner disappear on calls tab and calls activity once you added an emergency location
    [Tags]    381966       tp_audio    sanity_tp
    [Setup]  Testcase Setup    count=1
    Navigate To Calls Tab    device=device_1
    Verify Presence Of Location Not Detected Banner In Calls Tab    device=device_1    action=absence
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC8: [Emergency Location]Verify Add button when some fields are left blank in add location fields in the add location dialog
    [Tags]    381970       tp_audio
    [Setup]  Testcase Setup    count=1
    Verify Emergency Location Option Under Callings Settings    device=device_1
    Verify Location Fields Are Empty In Emergency Location    device=device_1
    Verify Status Save Emergency Location Button    device=device_1    status=disabled
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1
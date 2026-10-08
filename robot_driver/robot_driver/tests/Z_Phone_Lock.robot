*** Settings ***
Resource    ../../resources/keywords/common.robot
Documentation      Phone lock will applied only for device_1

Suite Setup    Phone lock Setup
Suite Teardown      Run Keywords    Suite Failure Capture   AND      Phone lock Teardown

*** Variables ***
${device_lock_time} =  65


*** Test Cases ***
TC1 : [Phone lock] User to unlock the device with the PIN set by the user.
    [Tags]    308464
    [Setup]    Testcase Setup for Phone Lock    count=1
    wait for some time    time=2 minutes
    verify and unlock phone lock    device=device_1
    [Teardown]    Run Keywords    Capture on Failure  AND    Testcase Teardown    device=device_1

TC2 : [Phone lock] User to disable the Phone Lock from Device settings
    [Tags]    307731
    [Setup]    Testcase Setup for Phone Lock    count=1
    disable device lock     device=device_1
    [Teardown]    Run Keywords    Capture on Failure  AND    Testcase Teardown    device=device_1

TC3: [Lock Pin]Verify that Lock not set on device message should display when user tap on Lock option in the Hamburger menu once Phone lock is disabled from the Device settings.
    [Tags]    453259
    [Setup]    Testcase Setup for Phone Lock    count=1
    Enable lock device    device=device_1
    navigate to hamberger menu lock icon     device=device_1
    verify device state is locked    device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Testcase Teardown    device=device_1

TC4 : [Incoming Calls] DUT user receives incoming call in locked state
    [Tags]    308333
    [Setup]    Testcase Setup for Phone Lock    count=2
    wait for some time    time=2 minutes
    raise if device is unlocked    device=device_1
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]    Run Keywords    Capture on Failure    AND    Testcase Teardown    device=device_1,device_2

TC5: [No Soft Dialpad with Physical Present] [Device with physical Dialpad] Soft Dialpad should not be shown on emergency calling Dialpad.
    [Tags]  456362
    [Setup]     Testcase Setup for Phone Lock    count=1
    Wait for Some Time    time=${device_lock_time}
    Select emergency call while phone lock  device=device_1
    open and verify dialpad from emergency calls tab    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Test Case Teardown   device=device_1

TC6 : [Call Hold] DUT user holds the incoming call received during locked state
    [Tags]    309766   bvt_tp    sanity_tp
    [Setup]    Testcase Setup for Phone Lock    count=2
    wait for some time    time=2 minutes
    raise if device is unlocked    device=device_1
    click on calls tab   device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Hold the call   device=device_1
    Verify Call State    device_list=device_1,device_2    state=Hold
    Resume the call   device=device_1
    Verify Call State    device_list=device_1,device_2     state=Resume
    press hardkeys    device=device_1    hardkey_intent=KEYCODE_BUTTON_14
    Verify Call State    device_list=device_1,device_2    state=Hold
    press hardkeys   device=device_1             hardkey_intent=KEYCODE_BUTTON_14
    Verify Call State    device_list=device_1,device_2     state=Resume
    Disconnect call     device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]    Run Keywords    Capture on Failure    AND    Testcase Teardown    device=device_1,device_2

TC7 : [Call view] Verify that user should redirect to the correct screen after unlocking the locked device
    [Tags]    318793
    [Setup]     Testcase Setup for Phone Lock    count=1
    Verify call views option under callings settings       device=device_1      verify_options_under_default_view=on
    click default view from calling settings    device=device_1
    wait for some time    time=120
    raise if device is unlocked    device=device_1
    unlock phone lock   device=device_1
    Verify default view screen  device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Testcase Teardown    device=device_1

TC8 : [Phone Lock] DUT to get locked only after idle time-out
    [Tags]      308135
    [Setup]     Testcase Setup for Phone Lock    count=2
    Disable device lock    device=device_1
    Enable lock device    device=device_1       time_out=10
    Come back to home screen   device_list=device_1
    Make outgoing call using display name    from_device=device_1      to_device=device_2
    Pick incoming call    device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    wait for some time    time=10 minutes
    Disconnect call     device=device_2
    verify device state is locked    device=device_1
    wait for some time    time=10 minutes
    raise if device is unlocked    device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Testcase Teardown    device=device_1

TC9 : [Phone lock] User to modify the Lock PIN and phone lock time-out from Device settings
    [Tags]    307719
    [Setup]    Testcase Setup for Phone Lock    count=1
    unlock phone lock   device=device_1
    Verify home screen page     device=device_1
    Verify presence of Intents        device=device_1         feature=lock_password         state=absent
    Disable device lock    device=device_1
    Enable lock device    device=device_1
    wait for some time    time=60s
    raise if device is unlocked    device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Testcase Teardown    device=device_1

TC10: [Phone Lock] User to Create the phone lock and idle time out after sign-in through Device settings
    [Tags]    307715
    [Setup]    Testcase Setup for Phone Lock    count=1
    Disable device lock    device=device_1
    Enable lock device    device=device_1
    Verify presence of Intents        device=device_1         feature=lock_password         state=absent
    wait for some time    time=60s
    raise if device is unlocked    device=device_1
    unlock phone lock   device=device_1
    Disable device lock    device=device_1
    Enable lock device    device=device_1   time_out=5
    Verify presence of Intents        device=device_1         feature=lock_password         state=absent
    wait for some time    time=5 minutes
    raise if device is unlocked    device=device_1
    unlock phone lock   device=device_1
    Disable device lock    device=device_1
    Enable lock device    device=device_1   time_out=10
    Verify presence of Intents        device=device_1         feature=lock_password         state=absent
    wait for some time    time=10 minutes
    raise if device is unlocked    device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Testcase Teardown    device=device_1

*** Keywords ***
Phone lock setup
    Enable lock device    device=device_1

Phone Lock Teardown
    Unlock phone if is locked
    Come back to home screen   device_list=device_1
    Disable device lock    device=device_1

verify and unlock phone lock
    [Arguments]     ${device}
    raise if device is unlocked    device=${device}
    unlock phone lock   device=${device}

Testcase Teardown
    [Arguments]     ${device}
    Unlock phone if is locked
    Come back to home screen    device_list=${device}



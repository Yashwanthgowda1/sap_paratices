*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown  Suite Failure Capture

*** Test Cases ***
TC1:[Device Properties] Check firmware version
    [Tags]  307251   bvt   sanity   smoke_panels	 bvt_panels     fw_panels   bvt_panels_pr
    Check device firmware version    device=device_1

TC2:[Device Properties] Check device type
    [Tags]  307265   bvt   sanity	 bvt_panels     bvt_panels_pr     fw_panels
    Check device type   device=device_1

TC3:[Screen Resolution] User to verify the screen resolution on the device
    [Tags]  307243
    check screen resolution version   device=device_1

TC4:[Version code] DUT user to check the teams apk version code installed on DUT.
    [Tags]  314156   bvt   sanity      fw_panels
    check installed teams version    device=device_1

TC5:[Device Properties] Check device teams capabilities
    [Tags]  307273   bvt   sanity	 bvt_panels    fw_panels    bvt_panels_pr
    check device capabilities  device=device_1

TC6:[Build Verification] Firmware for production should be released signed.
    [Tags]  312763   bvt   sanity	 bvt_panels    fw_panels    bvt_panels_pr
    verify status of device firmware for production     device=device_1
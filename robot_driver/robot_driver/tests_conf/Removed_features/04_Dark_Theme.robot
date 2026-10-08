# *** Settings ***
# Library     DateTime
# Library     OperatingSystem
# Resource    ../resources/keywords/common.robot


# Suite Teardown    Suite Failure Capture

# *** Variables ***
# ${wait_time} =      10s


# *** Test Cases ***
# TC1 : [Appearance] DUT user can enable Dark/Light theme on the device
#     [Tags]  305996    bvt_tpc    sanity_tpc  P0
#     [Setup]   Testcase Setup for Meeting User    count=1
#     verify dark theme option   device=device_1
#     verify and enable dark theme     device=device_1
#     [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

# TC2 : [Appearance] Dark/Light theme setting should reset to light theme when user signs out
#     [Tags]  305999   bvt_tpc     sanity_tpc  P0
#     [Setup]  Testcase Setup for Meeting User    count=1
#     verify dark theme option    device=device_1
#     verify and enable dark theme     device=device_1
#     Sign out method    device=device_1
#     Sign in method     device=device_1
#     Verify dark theme status     device=device_1    status=ON
#     [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

# TC3 : [Appearance] DUT user can disable Dark theme on the device
#     [Tags]   305997   P2
#     [Setup]  Testcase Setup for Meeting User    count=1
#     verify dark theme option   device=device_1
#     verify and disable dark theme    device=device_1
#     [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

# *** Keywords ***

# *** Settings ***
# Resource    ../resources/keywords/common.robot


# Suite Teardown    Suite Failure Capture


# *** Variables ***


# *** Test Cases ***
# # TC1:[Presence] user presence cannot be changed for conference device.
# # 	[Tags]    464962    P0    bvt_tpc    sanity_tpc
# #   [Setup]     Testcase Setup For Meeting User        count=1
# #   verify user presence cannot be changed for conf   device=device_1
# #   [Teardown]   Run Keywords    Capture on Failure   AND     Come back to home screen    device_list=device_1


# *** Keywords ***
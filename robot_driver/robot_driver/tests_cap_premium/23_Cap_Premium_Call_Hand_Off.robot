*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot


Suite Setup      Call Handoff Suite Setup
Suite Teardown      Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Advanced calling] [Call Handoff] DUT user to verify Call handoff for CAP policy assigned accounts
      [Tags]    329341     BVT_CAPPremium     Sanity_CAPPremium
      [Setup]   Run Keywords     Testcase Setup for Call hand off     count=3     AND     verify and enable advance calling option       device=device_1
      click on people tab  device=device_2
      Make outgoing call using display name    from_device=device_2      to_device=device_3
      Pick incoming call    device=device_3
      Verify Call State    device_list=device_2,device_3    state=Connected
      Verify call hand off banner     device=device_1
      Disconnect call     device=device_2
      Verify Call State    device_list=device_2,device_3     state=Disconnected
      [Teardown]  Run Keywords   Capture on Failure   AND   Close options screen   device=device_1   AND   Come back to home screen    device_list=device_1,device_2,device_3   AND    Disable advance calling option     device=device_1

*** Keywords ***
Call Handoff Suite Setup
    Testcase Setup for CAP Premium User     count=3
    Signin with other user    device=device_2   other_user_account=device_1:cap_search_enabled
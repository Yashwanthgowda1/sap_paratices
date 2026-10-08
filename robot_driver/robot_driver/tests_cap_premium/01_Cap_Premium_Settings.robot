*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Test Cases ***
TC1 : [Advance calling] [Settings] [Home screen] DUT user to enable Advance calling
      [Tags]    329217     P1     Sanity_CAPPremium
      [Setup]       Testcase Setup for CAP User     count=1
      verify and enable advance calling option       device=device_1
      [Teardown]   Run Keywords    Capture on Failure  AND  Come back to home screen    device_list=device_1

TC2 : [Advance calling] [Settings] [Home screen] Verify DUT user disable Advance calling
      [Tags]    329221       BVT_CAPPremium     Sanity_CAPPremium
      [Setup]   Testcase Setup for CAP User    count=1
      Disable advance calling option       device=device_1
      [Teardown]   Run Keywords    Capture on Failure  AND  Come back to home screen    device_list=device_1    AND    verify and enable advance calling option     device=device_1

TC3 : [Advance calling] [Settings] [Home screen] Verify cancelling on the acknowledge window does not enable Advance calling
      [Tags]    329222       P2
      [Setup]   Testcase Setup for CAP User    count=1
      verify cancel button and validate not to enable advance calling      device=device_1
      [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1

TC4 : [Advance calling][Home Screen] DUT user to verify tiles on the Home screen.
      [Tags]    402413      BVT_CAPPremium     Sanity_CAPPremium
      [Setup]    Testcase Setup for CAP Premium User    count=1
      verify home screen tiles       device=device_1      device_type=cap_home_screen_enabled
      verify home screen time dates    device=device_1
      [Teardown]   Run Keywords    Capture on Failure   AND  Come back to home screen    device_list=device_1

TC5 : [Advance calling][Search] Search for contact by entering a search string without typing the complete contact name
      [Tags]    329319       BVT_CAPPremium     Sanity_CAPPremium
      [Setup]   Testcase Setup for CAP Premium User    count=2
      navigate to calls tab       device=device_1
      Search Text   from_device=device_1      to_device=device_2
      Validate search results presented    device=device_1
      [Teardown]   Run Keywords    Capture on Failure   AND  Come back to home screen    device_list=device_1

TC6 : [Advance calling][Search]DUT user can search TDC user and place P2P call
    [Tags]    329318     P1     Sanity_CAPPremium
    [Setup]    Testcase Setup for CAP Premium User   count=2
    navigate to people tab   device=device_1
    Verify search text   from_device=device_1    to_device=device_2
    Select user presence   device=device_2    state=Available
    Come back to home screen    device_list=device_1
    Make outgoing call using display name    from_device=device_1   to_device=device_2
    Pick incoming call   device=device_2
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call   device=device_1
    Verify Call State    device_list=device_1,device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen     device_list=device_1,device_2

TC7 : [Settings Consistency] Meeting settings should not be shown for advanced CAP user
    [Tags]  464947  BVT_CAPPremium     Sanity_CAPPremium    P0
    [Setup]    Testcase Setup for CAP Premium User   count=1
    verify meetings btn not present under app settings      device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

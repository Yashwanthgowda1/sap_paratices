*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot


Suite Teardown    Suite Failure Capture

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [App Settings] DUT user's Display picture is visible along with the user account signed
    [Tags]       305883      sanity_tpc  
    [Setup]  Testcase Setup for Meeting User    count=1
    Verify user friendly name and display picture    device=device_1:meeting_user
    Verify user contact info   device=device_1:meeting_user
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2 : [App Settings] DUT to have option to report problem and feature request.
    [Tags]  305927     bvt_tpc     sanity_tpc  
    [Setup]  Testcase Setup for Meeting User    count=1
    Report a problem    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC3 : [App Settings] DUT user to view the third-party software notices and information
    [Tags]  305840
    [Setup]  Testcase Setup for Meeting User    count=1
    verify third party software notices     device=device_1
    navigate to home screen from about page  device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC4 : [App Settings] DUT user check for options under hamburger menu
    [Tags]   313361   
    [Setup]  Testcase Setup for Meeting User    count=1
    verify options inside hamburger menu for cnf device    device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1

TC5: Verify that DUT user able to access "Privacy & Cookies" page under About in settings.
    [Tags]    348881   
    [Setup]  Testcase Setup for Meeting User     count=1
    verify options inside about page     device=device_1
    navigate to privacy and cookies from about page    device=device_1
    navigate to home screen from about page  device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC6: verify that DUT user able to access "Terms of Use" page under About in settings.
    [Tags]    348882    
    [Setup]   Testcase Setup for Meeting User    count=1
    verify options inside about page     device=device_1
    navigate to terms of use from about page  device=device_1
    navigate to home screen from about page  device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC7 : Verify that DUT user should be able to access "Third party software notices and information" page under About in settings.
    [Tags]    348888     bvt_tpc     sanity_tpc  
    [Setup]  Testcase Setup for Meeting User   count=1
    verify third party software notices     device=device_1
    navigate to home screen from about page   device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC8 : Verify that DUT user should be able to answer the call/meetng from "Terms of Use" page under About in settings.
    [Tags]    348887    
    [Setup]  Testcase Setup for Meeting User  count=2
    verify options inside about page     device=device_1
    navigate to terms of use from about page  device=device_1
    make outgoing call using display name    from_device=device_2     to_device=device_1:meeting_user
    Pick incoming call      device=device_1
    Verify Call State    device_list=device_1,device_2     state=Connected
    Disconnect call    device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    navigate to home screen from about page  device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC9 : Verify that DUT user should be able answer a call/meeting from "Third party software notices and information" page under About in settings.
    [Tags]    348889   
    [Setup]   Testcase Setup for Meeting User   count=2
    verify options inside about page     device=device_1
    navigate to third party software notices from about page    device=device_1
    make outgoing call using display name    from_device=device_2     to_device=device_1:meeting_user
    Pick incoming call      device=device_1
    Verify Call State    device_list=device_1,device_2     state=Connected
    Disconnect call    device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    navigate to home screen from about page  device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC10 : [Settings] Teams App User to check the functionality of “Meeting” in Setting.
    [Tags]     320250   
    [Setup]  Testcase Setup for Meeting User    count=1
    verify meetings option under app settings page  device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1

TC11 : [Admin Settings] Teams App User to check the functionality of “Calling”, “Meeting” and “Teams sign out” in Admin only Settings or Device Administration.
    [Tags]     320533  
    [Setup]  Testcase Setup for Meeting User    count=1
    Navigate to device setting page   device=device_1
    verify each option in teams admin setting for conf  device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1

TC12: [Admin Settings] User to have admin sign-out option behind admin settings
    [Tags]   381311   
    [Setup]  Testcase Setup for Meeting User    count=1
    Navigate to device setting page   device=device_1
    verify admin setting signout for conf   device=device_1
    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1

TC13 : [App Settings] DUT user to view the device settings.
    [Tags]   305925  
    [Setup]  Testcase Setup for Meeting User    count=1
    Navigate to device setting page   device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Device Setting Back     device=device_1   AND   Come back to home screen    device_list=device_1

TC14 : [App Settings] DUT user to see the Terms of Use
    [Tags]   305839   
    [Setup]  Testcase Setup for Meeting User    count=1
    Verify terms of use view     device=device_1
    navigate to home screen from about page  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC15 : [App Settings] DUT user to see and define Privacy and cookies
    [Tags]   305838      
    [Setup]  Testcase Setup for Meeting User    count=1
    Verify privacy and cookies view     device=device_1
    navigate to home screen from about page  device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

*** Keywords ***

Navigate to device setting page
    [Arguments]     ${device}
    Open settings page   device=${device}
    Click device settings   device=${device}
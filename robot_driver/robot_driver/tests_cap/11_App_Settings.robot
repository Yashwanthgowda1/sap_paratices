*** Settings ***
Library     DateTime
Library     OperatingSystem
Resource    ../resources/keywords/common.robot

Suite Teardown    Suite Failure Capture

*** Variables ***

*** Test Cases ***
TC1 : [App Settings] DUT user's Display picture is visible along with the user account signed-into Teams app
    [Tags]  149063   P1  sanity_cap
    [Setup]  Testcase Setup for CAP User   count=1
    Verify user friendly name and display picture   device=device_1:cap_search_enabled
    Verify user contact info   device=device_1:cap_search_enabled
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC2 : [App Settings] DUT user to view the device settings
    [Tags]   149342   P1        Certification_cap
    [Setup]  Testcase Setup for CAP User    count=1
    Navigate to device setting page   device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Device Setting Back     device=device_1   AND   Come back to home screen    device_list=device_1

TC3 : [App Settings] DUT to have option to report problem and feature request
    [Tags]  149344   P1  bvt_cap     sanity_cap        Certification_cap
    [Setup]  Testcase Setup for CAP User    count=1
    Report a problem    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC4: Verify that DUT user able to access "Privacy & Cookies" page under About in settings.
    [Tags]  348953   P2
    [Setup]   Testcase Setup for CAP User    count=1
    verify options inside about page     device=device_1
    navigate to privacy and cookies from about page    device=device_1
    navigate to home screen from about page  device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC5: verify that DUT user able to access "Terms of Use" page under About in settings.
    [Tags]  348954    P2
    [Setup]    Testcase Setup for CAP User   count=1
    verify options inside about page     device=device_1
    navigate to terms of use from about page  device=device_1
    navigate to home screen from about page  device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC6 : Verify that DUT user should be able to access "Third party software notices and information" page under About in settings.
    [Tags]  348960     P1    sanity_cap
    [Setup]   Testcase Setup for CAP User   count=1
    verify third party software notices and information    device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC7 : Verify that DUT user should be able answer a call/meeting from "Third party software notices and information" page under About in settings.
    [Tags]  348961    P2
    [Setup]   Testcase Setup for CAP User   count=2
    verify options inside about page     device=device_1
    navigate to third party software notices from about page    device=device_1
    click on calls tab     device=device_2
    make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call      device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2     state=Connected
    Disconnect call    device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    navigate to home screen from about page  device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC8 : Verify that DUT user should be able to answer the call/meetng from "Terms of Use" page under About in settings.
    [Tags]  348959   P2
    [Setup]   Testcase Setup for CAP User   count=2
    verify options inside about page     device=device_1
    navigate to terms of use from about page  device=device_1
    click on calls tab     device=device_2
    make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call      device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2     state=Connected
    Disconnect call    device=device_2
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    navigate to home screen from about page  device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC9 :Verify that DUT user should be able to answer the call/meeting from "Privacy & Cookies" page under About in settings.
    [Tags]   348958    P0    bvt_cap     sanity_cap
    [Setup]   Testcase Setup for CAP User    count=2
    verify options inside about page     device=device_1
    navigate to privacy and cookies from about page    device=device_1
    click on calls tab     device=device_2
    make outgoing call using display name    from_device=device_2     to_device=device_1:cap_search_enabled
    Pick incoming call      device=device_1
    Wait for Some Time    time=${wait_time}
    Verify Call State    device_list=device_1,device_2     state=Connected
    Disconnect call    device=device_2
    navigate to home screen from about page  device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC10 : Verify that DUT user able to access "What's new" page under the settings.
    [Tags]  348952   P1     sanity_cap
    [Setup]  Testcase Setup for CAP User    count=1
    navigate to whats new page from home screen   device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC11 : Verify that DUT user should be able to accept the call/meeting in "What's new" page under the settings.
    [Tags]  348957   P2
    [Setup]  Testcase Setup for CAP User    count=2
    navigate to whats new page from home screen   device=device_1
    click on calls tab     device=device_2
    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
    Pick incoming call    device=device_1
    Verify Call State    device_list=device_1,device_2    state=Connected
    Disconnect call    device=device_1
    Verify Call State    device_list=device_1,device_2     state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2

TC12 : [Settings Consistency] Meeting settings should not be shown for CAP user
    [Tags]  464945  bvt_cap     sanity_cap  P0
    [Setup]  Testcase Setup for CAP User    count=1
    verify meetings btn not present under app settings      device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

TC13 : Verify license details in settings About page.
    [Tags]  435779    P2
    [Setup]  Testcase Setup for CAP User    count=1
    verify license details option in about page      device=device_1:cap_search_enabled
    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

*** Keywords ***
verify third party software notices and information
    [Arguments]     ${device}
    verify third party software notices     ${device}
    scroll up secondary tab     ${device}
    click back  ${device}
*** Settings ***
Documentation   All day Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Test Cases ***
TC1:[Landing Page] All-day meetings should be displayed with highlighted background
    [Tags]  238038    bvt   bvt_sm      sanity_sm
    [Setup]   Testcase Setup for Meeting User     count=1
    Verify background display of all day meetings    device=device_1
    [Teardown]  Run Keywords   Capture on Failure  AND   Navigate back to meetings   device=device_1  AND   Come back to home screen    device_list=device_1

TC2:[Landing Page] DUT should navigate back to meetings when DUT user tap on All-day meeting title bar
    [Tags]  238039    P1    sanity_sm
    [Setup]  Testcase Setup for Meeting User      count=1
    Verify default option present on landing page and validate   device=device_1
    Tap on all day meetings title bar and validate   device=device_1
    Get meetings details present under all day title bar   device=device_1
    [Teardown]   Run Keywords   Capture on Failure  AND     Navigate back to meetings   device=device_1     AND  Come back to home screen     device_list=device_1

TC3:[MTRA] Verify All day meetings, count and banner.
    [Tags]     444935   P1    sanity_sm
    [Setup]  Testcase Setup for Meeting User      count=1
    Verify default option present on landing page and validate   device=device_1
    Verify all day meetings count and banner   device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND   Navigate back to meetings   device=device_1   AND   Come back to home screen    device_list=device_1

TC4:[Meetings]Show meeting names toggle is turned OFF and TDC2 schedules All day Event/Meeting, meeting must sync automatically, and name must not be displayed, Organizer name must be displayed above meeting time.
    [Tags]     317193        P2
    [Setup]  Testcase Setup    count=1
    Navigate to app settings page    device=device_1
    navigate to meetings option in device settings page      device=device_1
    hide or unhide meeting names     device=device_1   state=off
    Come back from admin settings page      device_list=device_1
    create TDC meeting on all day meeting
    Wait for Some Time      time=${wait_time}
    refresh calender tab    device=device_1
    Wait for Some Time      time=${wait_time}
    refresh calender tab    device=device_1
    verify meeting names show meeting organizer name  device=device_1     organizer=device_2
    Verify Organizer name must be displayed above meeting time       device=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND     Modify show meeting names option     device=device_1   state=on

TC5:[MTRA] Verify all day meeting name with same title.
    [Tags]     444984        P3
    [Setup]  Testcase Setup for Meeting User    count=1
    Verify all day meetings count and banner   device=device_1
    Get meetings details present under all day title bar   device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND   Navigate back to meetings   device=device_1   AND   Come back to home screen    device_list=device_1

TC6:[MTRA] Verify that new calendar UI visible.
    [Tags]     444850       P2
    [Setup]  Testcase Setup for Meeting User      count=1
    Verify default option present on landing page and validate   device=device_1
    Verify all day meetings count and banner   device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND   Navigate back to meetings   device=device_1   AND   Come back to home screen    device_list=device_1


*** Keywords ***
Verify default option present on landing page and validate
    [Arguments]     ${device}
    Verify home page screen    ${device}

Verify and click on white board sharing in call control bar
        [Arguments]    ${device}
        Verify whiteboard sharing option under more option   ${device}

Verify all day meetings count and banner
    [Arguments]    ${device}
    Tap on all day meetings title bar and validate   ${device}

Verify that new calendar UI visible
    [Arguments]    ${device}
    Verify current time display on home screen    ${device}
    verify start and end time display on calendar tab    ${device}
    Verify background display of all day meetings       ${device}

create TDC meeting on all day meeting
    initiate web driver     tdc_1
    perform web signin method     tdc_1:user
    delete all meetings from tdc     device=tdc_1
    create TDC meeting on desktop    device=tdc_1     meeting_name=test_meeting      participants=device_1      all_day_meeting=on


Verify Organizer name must be displayed above meeting time
    [Arguments]     ${device}
   Verify meeting display on home screen     ${device}

Modify show meeting names option
    [Arguments]       ${device}   ${state}
    Navigate to app settings page  ${device}
    navigate to meetings option in device settings page   ${device}
    hide or unhide meeting names    ${device}    ${state}
    Come back from admin settings page      device_list=${device}
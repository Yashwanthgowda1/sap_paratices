*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

Suite Setup     Enable the required passcode for all meetings option     console=console_1
Suite Teardown    Run Keywords   Suite Failure Capture    AND   Disable the required passcode for all meetings option   console=console_1

*** Test Cases ***
TC1:[Require ID and Passcode] Verify the meeting when user enable "Require passcode for all meetings" "Meetings."
    [Tags]    444263    sanity_tc_sm    P1
    [Setup]     Testcase Setup for shared User   count=1
    join meeting after enabling the required passcode   console=console_1    meeting=console_lock_meeting    passcode=${tdc_meeting_passcode}    
    Verify for call state     console_list=console_1    state=Connected
    End the meeting     console=console_1
    Verify for call state     console_list=console_1    state=Disconnected
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC2:[Require ID and Passcode] Verify options available under Join by ID screen in a meeting when user enables " Require passcode for all meetings" under "Meetings."
    [Tags]    444273    sanity_tc_sm    P1
    [Setup]     Testcase Setup for shared User   count=1
    join by id screen in meeting after enabling the required passcode   console=console_1    meeting=console_lock_meeting
    Click on close button   console_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC3:[Require ID and Passcode] Verify Meeting ID field in a meeting when user enables "Require passcode for all meetings" under "Meetings."
    [Tags]    444295    sanity_tc_sm    P1
    [Setup]     Testcase Setup for shared User   count=1
    Default meeting id should be in meeting id field after enabling the required passcode   console=console_1    meeting=console_lock_meeting    meeting_id=${tdc_meeting_id}
    Click on close button   console_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC4:[Require ID and Passcode] Verify user should not accept Alphabet for meeting ID in meeting field when user enables "Require passcode for all meetings" under "Meetings."
    [Tags]    444328    sanity_tc_sm    P1
    [Setup]     Testcase Setup for shared User   count=1
    join by id screen in meeting after enabling the required passcode   console=console_1    meeting=console_lock_meeting
    verify user should not accept alphabet for meeting id in meeting field when user enables require passcode for all meetings      device=console_1    meeting=console_lock_meeting
    Click on close button   console_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC5:[Require ID and Passcode] Verify user cannot join a meeting without passcode once user enables "Require passcode for all meetings" under "Meetings."
    [Tags]    444342    sanity_tc_sm    P1
    [Setup]     Testcase Setup for shared User   count=1
    join by id screen in meeting after enabling the required passcode   console=console_1    meeting=console_lock_meeting
    Verify user cannot join a meeting without passcode once user enables require passcode for all meetings      device=console_1    meeting=console_lock_meeting
    Click on close button   console_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC6:[Require ID and Passcode] Verify user should accept only numeric for meeting ID in meeting field when user enables "Require passcode for all meetings" under "Meetings."
    [Tags]    444297    P1    sanity_tc_sm
    [Setup]     Testcase Setup for shared User   count=1
    join by id screen in meeting after enabling the required passcode   console=console_1    meeting=console_lock_meeting
    verify user should accept only numeric values in meeting field      device=console_1         meeting=console_lock_meeting
    Click on close button   console_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC7:[Require ID and Passcode] Verify user should not accept alphanumeric for meeting ID in meeting field when user enables "Require passcode for all meetings" under "Meetings."
    [Tags]    444334    P2
    [Setup]     Testcase Setup for shared User   count=1
    join by id screen in meeting after enabling the required passcode   console=console_1    meeting=console_lock_meeting
    Verify meeting field should not accept alphanumeric for require passcode meeting     device=console_1         meeting=console_lock_meeting
    Click on close button   console_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC8:[Require ID and passcode] Verify "Join meeting" button should be enabled once users enter 7 characters for the meeting field and at least one character.
     [Tags]    444546    P3
    [Setup]  Testcase Setup for shared User   count=1
    join by id screen in meeting after enabling the required passcode   console=console_1    meeting=console_lock_meeting
    verify require passcode for all meetings with less than and greater than 7 digit number      device=console_1         meeting=console_lock_meeting    meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode}   
    Click on close button   console_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC9:[Require ID and Passcode] Verify that when the length of the Meeting ID is less than seven digits the "Join a Meeting button" should be disabled when user enables "Require passcode for all meetings" under "Meetings."
    [Tags]    444337    P3
    [Setup]  Testcase Setup for shared User   count=1
    join by id screen in meeting after enabling the required passcode   console=console_1    meeting=console_lock_meeting
    verify require passcode for all meetings with less than and greater than 7 digit number      device=console_1         meeting=console_lock_meeting    meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode}   
    Click on close button   console_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1

TC10:[Require ID and Passcode] Verify that when the user enter only meeting passcode "Join a Meeting button" should be disabled once user enables "Require passcode for all meetings under "Meetings."
    [Tags]    444339    P3
    [Setup]  Testcase Setup for shared User   count=1
    join by id screen in meeting after enabling the required passcode   console=console_1    meeting=console_lock_meeting
    Verify that when the user enter only meeting passcode      device=console_1      meeting=console_lock_meeting    passcode=${tdc_meeting_passcode}
    Click on close button   console_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC11:[Require ID and Passcode] Verify meeting ID and passcode fields strings when user tap on "Join with an ID" button once user enables "Require passcode for all meetings" under "Meetings."
    [Tags]    444344    P2
    [Setup]  Testcase Setup for shared User   count=1
    join by id screen in meeting after enabling the required passcode   console=console_1    meeting=console_lock_meeting
    verify options available under meeting ID field in a meeting when user enables Require passcode for all meetings toggle     device=console_1         meeting=console_lock_meeting
    Click on close button   console_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC12:[Require ID and Passcode] Verify Error handling when meeting not found
    [Tags]    444346    P2
    [Setup]  Testcase Setup for shared User   count=1
    join by id screen in meeting after enabling the required passcode   console=console_1    meeting=console_lock_meeting
    join meeting with an invalid password under require passcode meeting    device=console_1         meeting=console_lock_meeting
    Click on close button   console_list=console_1
    [Teardown]  Run Keywords    Capture Failure  AND   Come back to home screen page   console_list=console_1

TC13:[Require ID and Passcode] Verify meeting id should be formatted with a white space every 3 characters when user enables "Require passcode for all meetings" under "Meetings."
	[Tags]    444331    P2
    [Setup]  Testcase Setup for shared User   count=1
    join by id screen in meeting after enabling the required passcode   console=console_1    meeting=console_lock_meeting
    Verify white space between three characters when user enables require passcode for all meetings     device=console_1         meeting=console_lock_meeting    meeting_id=${tdc_meeting_id}
    Click on close button   console_list=console_1
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen page   console_list=console_1

TC14:[Require ID and Passcode] Verify user must be able to edit the meeting ID and passcode previously entered when "Require passcode for all meetings" is enabled
	[Tags]    444348    P2
    [Setup]  Testcase Setup for shared User   count=1
    join by id screen in meeting after enabling the required passcode   console=console_1    meeting=console_lock_meeting
    verify invalid number and edit the meeting id and passcode for require passcode meeting   device=console_1     meeting=console_lock_meeting    meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode}   
    Click on close button   console_list=console_1
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen page   console_list=console_1

TC15:[Require ID and Passcode] Verify retry button when a user enters an invalid meeting ID or invalid passcode
	[Tags]    444350    P2
    [Setup]  Testcase Setup for shared User   count=1
    join by id screen in meeting after enabling the required passcode   console=console_1    meeting=console_lock_meeting
    Verify retry button when a user enters an invalid meeting ID or invalid passcode once user enables Require passcode for all meetings      device=console_1
    Click on close button   console_list=console_1
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen page   console_list=console_1

TC16:[Require ID and Passcode] Verify cancel button when a user enters an invalid meeting ID or invalid passcode
	[Tags]    444354    P2
    [Setup]  Testcase Setup for shared User   count=1
    join by id screen in meeting after enabling the required passcode   console=console_1    meeting=console_lock_meeting
    Verify cancel button when a user enters an invalid meeting ID or invalid passcode        device=console_1
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen page   console_list=console_1

TC17:[Require ID and Passcode] Verify cancel button when user enables "Require passcode for all meetings" under "Meetings."
	[Tags]    444357    P3
    [Setup]  Testcase Setup for shared User   count=1
    join by id screen in meeting after enabling the required passcode   console=console_1    meeting=console_lock_meeting
    verify options available under meeting ID field in a meeting when user enables Require passcode for all meetings toggle     device=console_1         meeting=console_lock_meeting
    Click on close button   console_list=console_1
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen page   console_list=console_1

TC18:[Require ID and Passcode] Verify when user Join with a wrong meeting code, Subtitle should be red with an error message when "Require passcode for all meetings" is enabled
	[Tags]    444360    P2
    [Setup]  Testcase Setup for shared User   count=1
    join by id screen in meeting after enabling the required passcode   console=console_1    meeting=console_lock_meeting
    verify invalid number and edit the meeting id and passcode for require passcode meeting         device=console_1     meeting=console_lock_meeting    meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode}
    Click on close button   console_list=console_1
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen page   console_list=console_1

TC19:[Require ID and Passcode] Verify meet now when user enables "Require passcode for all meetings" under "Meetings."
	[Tags]    444364    P3
    [Setup]  Testcase Setup for shared User   count=2
    Verify precall screen after clicking on meetnow     device=device_1     console=console_1
    Meet now meeting    from_device=device_1    to_device=device_2      method=displayname
    Accept incoming call      device=device_2
    Verify for meeting state     console_list=console_1      device_list=device_2     state=Connected
    End up call     console=console_1       device=device_2
    Verify for call state    console_list=console_1    device_list=device_2    state=Disconnected
    [Teardown]   Run Keywords    Capture Failure  AND    Come back to home screen page   console_list=console_1   device_list=device_2

TC20:[Require ID and passcode] Verify the error when the user enter 7 characters for the meeting field and at least one character.
    [Tags]    444547    P3
    [Setup]  Testcase Setup for shared User   count=1
    join by id screen in meeting after enabling the required passcode   console=console_1    meeting=console_lock_meeting
    verify require id passcode for invalid 7 digit id with 1 char passcode  device=console_1
    Click on close button   console_list=console_1
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen page   console_list=console_1

*** Keywords ***
Navigate to app settings screen
    [Arguments]   ${console}
    Tap on more option  ${console}
    Tap on settings page   ${console}

Navigate to teams admin settings page
    [Arguments]    ${console}
    Navigate to app settings screen    ${console}
    Navigate to meeting and calling options from device settings page       ${console}  option=meeting

Enable the required passcode for all meetings option
    [Arguments]     ${console}
    Navigate to teams admin settings page       ${console}
    Verify require passcode for all meetings option under the meetings   device=${console}
    Enable and disable require passcode for all meetings toggle     device=${console}    state=on
    come back from admin settings page      device_list=${console}

Disable the required passcode for all meetings option
    [Arguments]    ${console}
    navigate to teams admin settings page       ${console}
    Verify require passcode for all meetings option under the meetings   device=${console}
    Enable and disable require passcode for all meetings toggle     device=${console}    state=off
    come back from admin settings page      device_list=${console}

verify user should accept only numeric values in meeting field
    [Arguments]     ${device}      ${meeting}
    verify meeting field should not accept alphanumeric for require passcode meeting    ${device}   ${meeting}

Verify retry button when a user enters an invalid meeting ID or invalid passcode once user enables Require passcode for all meetings
    [Arguments]     ${device}
    verify invalid number and edit the meeting id and passcode for require passcode meeting     ${device}       meeting=console_lock_meeting    meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode}

Verify cancel button when a user enters an invalid meeting ID or invalid passcode
    [Arguments]     ${device}
    verify invalid number and edit the meeting id and passcode for require passcode meeting     ${device}       meeting=console_lock_meeting    meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode}
    Click on close button   console_list=${device}

End up call
    [Arguments]    ${console}    ${device}
    Disconnect the call  ${console}
    Disconnect call     ${device}

verify require id passcode for invalid 7 digit id with 1 char passcode
    [Arguments]     ${device}
    Verify require id passcode with invalid credentials     ${device}

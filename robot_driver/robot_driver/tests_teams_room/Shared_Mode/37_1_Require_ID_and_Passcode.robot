*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

Suite Setup         enable Require passcode for all meetings toggle     device=device_1
Suite Teardown    Run Keywords   Suite Failure Capture    AND   disable Require passcode for all meetings toggle    device=device_1     AND     Come back to home screen    device_list=device_1

*** Test Cases ***
TC1:[Require ID and Passcode]Verify the meeting when user enable "Require passcode for all meetings" "Meetings"
    [Tags]     444361    P1   exclude_ftp_sm    sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    join meeting with Require passcode      device=device_1     meeting=lock_meeting   passcode=${tdc_meeting_passcode}
    Verify meeting state   device_list=device_1    state=Connected
    Check video call On state   device_list=device_1
    End meeting   device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1

TC2:[Require ID and Passcode] Verify options available under Join by ID screen in a meeting when user enables " Require passcode for all meetings" under "Meetings."
    [Tags]     444574      P1    exclude_ftp_sm    sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    verify join with an meeting id options   device=device_1
    Click close btn    device_list=device_1
    verify options available under meeting ID field in a meeting when user enables Require passcode for all meetings toggle     device=device_1     meeting=lock_meeting
    Click close btn    device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure      AND     Come back to home screen    device_list=device_1

TC3:[Require ID and Passcode] Verify Meeting ID field in a meeting when user enables "Require passcode for all meetings" under "Meetings."
    [Tags]    444575         P1    sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    verify options available under meeting ID field in a meeting when user enables Require passcode for all meetings toggle     device=device_1     meeting=lock_meeting
    Click close btn    device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1

TC4:[Require ID and Passcode] Verify user should not accept Alphabet for meeting ID in meeting field when user enables "Require passcode for all meetings" under "Meetings."
    [Tags]    444576         P1    sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    verify user should not accept alphabet for meeting id in meeting field when user enables require passcode for all meetings      device=device_1     meeting=lock_meeting
    Click close btn    device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1

TC5:[Require ID and Passcode] Verify user cannot join a meeting without passcode once user enables "Require passcode for all meetings" under "Meetings."
    [Tags]    444583         P1    sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    verify user cannot join a meeting without passcode once user enables require passcode for all meetings       device=device_1     meeting=lock_meeting
    Click close btn    device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1

TC6:[Require ID and Passcode] Verify meeting id should be formatted with a white space every 3 characters when user enables "Require passcode for all meetings" under "Meetings."
    [Tags]      444578        P1
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify white space between three characters when user enables require passcode for all meetings     device=device_1    meeting=lock_meeting    meeting_id=${tdc_meeting_id}
    Click close btn    device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1

TC7:[Require ID and Passcode] Verify user should not accept alphanumeric for meeting ID in meeting field when user enables "Require passcode for all meetings" under "Meetings."
    [Tags]  444579   P2
    [Setup]  Testcase Setup for Meeting User   count=1
    verify meeting field should not accept alphanumeric for require passcode meeting     device=device_1         meeting=lock_meeting
    Click close btn    device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC8:[Require ID and Passcode] Verify meeting ID and passcode fields strings when user tap on "Join with an ID" button once user enables "Require passcode for all meetings" under "Meetings."
    [Tags]       444586         P1
    [Setup]  Testcase Setup for Meeting User     count=1
    verify options available under meeting ID field in a meeting when user enables Require passcode for all meetings toggle     device=device_1         meeting=lock_meeting
    Click close btn    device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1

TC9:[Require ID and Passcode] Verify Error handling when meeting not found once user enables "Require passcode for all meetings" under "Meetings."
    [Tags]       444589        P2
    [Setup]  Testcase Setup for Meeting User     count=1
    join meeting with an invalid password under require passcode meeting    device=device_1         meeting=lock_meeting
    Click close btn    device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1

TC10:[Require ID and Passcode] Verify user must be able to edit the meeting ID and passcode previously entered once user enables "Require passcode for all meetings" under "Meetings."
    [Tags]       444591        P2
    [Setup]  Testcase Setup for Meeting User     count=1
    verify invalid number and edit the meeting id and passcode for require passcode meeting   device=device_1     meeting=lock_meeting    meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode}     
    Click close btn    device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1

TC11:[Require ID and Passcode] Verify retry button when a user enters an invalid meeting ID or invalid passcode once user enables "Require passcode for all meetings" under "Meetings."
    [Tags]       444592        P2
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify retry button when a user enters an invalid meeting ID or invalid passcode once user enables Require passcode for all meetings      device=device_1
    Click close btn    device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1

TC12:[Require ID and Passcode] Verify when a user Join with a wrong meeting code/meeting passcode the Subtitle should be red with an error message once user enables "Require passcode for all meetings" under "Meetings."
    [Tags]      444595       P2
    [Setup]  Testcase Setup for Meeting User     count=1
    verify invalid number and edit the meeting id and passcode for require passcode meeting         device=device_1     meeting=lock_meeting    meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode} 
    Click close btn    device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1

TC13:[Require ID and Passcode] Verify user should accept only numeric for meeting ID in meeting field when user enables "Require passcode for all meetings" under "Meetings."
    [Tags]    444577     P1     sanity_sm
    [Setup]  Testcase Setup for Meeting User     count=1
    verify meeting field should not accept alphanumeric for require passcode meeting      device=device_1         meeting=lock_meeting
    Click close btn    device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC14:[Require ID and Passcode] Verify that when the length of the Meeting ID is less than seven digits the "Join a Meeting button" should be disabled when user enables "Require passcode for all meetings" under "Meetings."
    [Tags]    444580     P3
    [Setup]  Testcase Setup for Meeting User     count=1
    verify require passcode for all meetings with less than and greater than 7 digit number      device=device_1         meeting=lock_meeting    meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode} 
    Click close btn    device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC15:[Require ID and Passcode] Verify that when the user enter only meeting passcode "Join a Meeting button" should be disabled once user enables "Require passcode for all meetings under "Meetings."
    [Tags]    444581     P3
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify that when the user enter only meeting passcode      device=device_1      meeting=lock_meeting    passcode=${tdc_meeting_passcode} 
    Click close btn    device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC16:[Require ID and passcode] Verify the error when the user enter 7 characters for the meeting field and at least one character.
    [Tags]    444603     P2
    [Setup]  Testcase Setup for Meeting User     count=1
    verify require passcode for all meetings with less than and greater than 7 digit number      device=device_1         meeting=lock_meeting    meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode}    
    Click close btn    device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC17:[Require ID and Passcode] Verify meet now when user enables "Require passcode for all meetings" under "Meetings."
    [Tags]      444597    P1    sanity_sm
    [Setup]   Testcase Setup for Meeting User     count=2
    verify meet info         device=device_1
    verify that after clicking the meetnow it will join the meeting directly    device=device_1
    Initiates conference meeting using Meet now option     from_device=device_1     to_device=device_2
    Accept incoming call    device=device_2
    Close participants screen   device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Check video call On state   device_list=device_1,device_2
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC18:[Require ID and Passcode] Verify cancel button when a user enters an invalid meeting ID or invalid passcode once user enables "Require passcode for all meetings" under "Meetings."
    [Tags]       444593        P2
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify cancel button when a user enters an invalid meeting ID or invalid passcode        device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1

TC19:[Require ID and passcode] Verify "Join meeting" button should be enabled once users enter 7 characters for the meeting field and at least one character.
     [Tags]    444602     P2
    [Setup]  Testcase Setup for Meeting User     count=1
    verify require passcode for all meetings with less than and greater than 7 digit number      device=device_1         meeting=lock_meeting    meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode}
    Click close btn    device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC20:[Require ID and Passcode] Verify cancel button when user enables "Require passcode for all meetings" under "Meetings."
    [Tags]       444594        P3
    [Setup]  Testcase Setup for Meeting User     count=1
    Verify join with an meeting id and cancel button when a user enters an meeting ID        device=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND     Come back to home screen    device_list=device_1

*** Keywords ***
Verify retry button when a user enters an invalid meeting ID or invalid passcode once user enables Require passcode for all meetings
    [Arguments]     ${device}
    verify invalid number and edit the meeting id and passcode for require passcode meeting     ${device}       meeting=lock_meeting    meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode} 

enable Require passcode for all meetings toggle
    [Arguments]     ${device}
    navigate to teams admin settings page   ${device}
    Verify require passcode for all meetings option under the meetings      ${device}
    enable and disable Require passcode for all meetings toggle      ${device}    state=on
    Come back from admin settings page      device_list=${device}

disable Require passcode for all meetings toggle
    [Arguments]     ${device}
    navigate to teams admin settings page   ${device}
    Verify require passcode for all meetings option under the meetings      ${device}
    enable and disable Require passcode for all meetings toggle      ${device}    state=off
    Come back from admin settings page      device_list=${device}

verify that after clicking the meetnow it will join the meeting directly
    [Arguments]     ${device}
    Verify meeting state     device_list=${device}   state=Connected
    Check video call On state     device_list=${device}
    End meeting     ${device}

Verify cancel button when a user enters an invalid meeting ID or invalid passcode
    [Arguments]     ${device}
    verify invalid number and edit the meeting id and passcode for require passcode meeting     ${device}       meeting=lock_meeting    meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode}
    Click close btn    device_list=${device}

Verify join with an meeting id and cancel button when a user enters an meeting ID
    [Arguments]     ${device}
    verify join with an meeting id options   ${device}
    Click close btn    device_list=${device}
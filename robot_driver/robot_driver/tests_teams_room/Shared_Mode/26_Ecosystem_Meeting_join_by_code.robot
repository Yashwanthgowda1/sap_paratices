*** Settings ***
Documentation   Meeting created as prerequisite before test execution
Library     DateTime
Library     OperatingSystem
Resource    ../../resources/keywords/common.robot

*** Variables ***
${wait_time} =  5

*** Test Cases ***
TC1:[Join by Code]Verify that when the length of the Meeting ID is less than seven digits the Join a Meeting button should be disabled.
     [Tags]     345056  P2      exclude_ftp_sm
    [Setup]    Testcase Setup for Meeting User      count=1
    verify join meeting ID with less than and greater than 7 digit number    device=device_1
    Click close btn    device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC2:[Join by Code]Verify that when the user enter only meeting passcode Join a Meeting button should be disabled.
    [Tags]   345057   P2    exclude_ftp_sm
    [Setup]    Testcase Setup for Meeting User  count=1
    verify that user enter only meeting passcode     device=device_1
    Click close btn    device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC3:[Join by Code]Verify meeting ID and passcode fields strings when user tap on [Join with an ID] button
    [Tags]   345069   P2    exclude_ftp_sm
    [Setup]    Testcase Setup for Meeting User   count=1
    verify meeting ID and passcode fields   device=device_1
    Click close btn    device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC4:[Join by Code]Verify Join meeting via Join by ID
    [Tags]   345070       P1    sanity_sm   exclude_ftp_sm
    [Setup]    Testcase Setup for Meeting User   count=2
    Join meeting   device=device_2    meeting=lock_meeting
    Verify meeting state   device_list=device_2    state=Connected
    join with an meeting id   device=device_1         meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode}
    Verify meeting state   device_list=device_1   state=Connected
    Wait for Some Time    time=${wait_time}
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC5:[Join by Code]Verify Error handling when meeting not found
    [Tags]   345071       P2    exclude_ftp_sm
    [Setup]    Testcase Setup for Meeting User   count=1
    invalid meeting id and passcode for join with meeting id    device=device_1
    Click close btn    device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC6:[Join by Code]Verify user must be able to edit the meeting ID and passcode previously entered
    [Tags]   345072       P1     sanity_sm      exclude_ftp_sm
    [Setup]    Testcase Setup for Meeting User   count=1
    verify invalid number and edit the meeting id and passcode  device=device_1
    Click close btn    device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC7:[Join by Code]Verify retry button when a user enters an invalid meeting ID or invalid passcode
    [Tags]   345076       P1     sanity_sm      exclude_ftp_sm
    [Setup]    Testcase Setup for Meeting User   count=1
    Verify retry button when a user enters an invalid meeting ID and invalid passcode      device=device_1
    Click close btn    device_list=device_1
    join with an meeting id   device=device_1         meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode}
    Verify meeting state   device_list=device_1   state=Connected
    End meeting     device=device_1
    Verify meeting state    device_list=device_1   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC8:[Join by Code]Verify cancel button when a user enters an invalid meeting ID or invalid passcode
    [Tags]   345078     P2      exclude_ftp_sm
    [Setup]    Testcase Setup for Meeting User   count=1
    verify invalid number and edit the meeting id and passcode  device=device_1
    Click close btn    device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC9:[Join by Code]Verify when a user Join with a wrong meeting code/meeting passcode it should throw a error message
    [Tags]   345083     P1  sanity_sm   exclude_ftp_sm
    [Setup]    Testcase Setup for Meeting User   count=1
    Verify error message when a user enters an wrong meeting ID   device=device_1
    Click close btn    device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC10:[Join by Code]Verify meeting info option with details when user join a meeting from "Join with an ID"
    [Tags]    345113    bvt_sm      sanity_sm   exclude_ftp_sm
    [Setup]    Testcase Setup for Meeting User   count=2
    Join meeting   device=device_2    meeting=lock_meeting
    Verify meeting state   device_list=device_2    state=Connected
    join with an meeting id   device=device_1         meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode}
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Meeting info details when user join a meeting from Join with an ID      device=device_1
    Click close btn    device_list=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC11:[Join by Code]Verify user should not accept Alphabet for meeting ID in meeting field
    [Tags]  345051   P2     exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User   count=1
    verify meeting field should not accept alphabets for meeting id         device=device_1
    Click close btn    device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC12:[Join by Code]Verify user should not accept alphanumeric for meeting ID in meeting field
    [Tags]  345053   P2     exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User   count=1
    verify meeting field should not accept alphanumeric     device=device_1
    Click close btn    device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC13:[Join by Code]Verify user cannot join a meeting without passcode
    [Tags]  345068   P1     sanity_sm   exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User   count=1
    Verify user cannot join a meeting without passcode       device=device_1
    Click close btn    device_list=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

TC14:[Join by Code]Verify "Join with an id" button must be added to one of the buttons in the ambient screen of the device
    [Tags]  345043      P1       sanity_sm      exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User   count=1
    verify join with an meeting id options  device=device_1
    Click close btn    device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC15: [Join by Code]Verify options available under Join with an meeting id
    [Tags]  345044    P1    sanity_sm   exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User   count=1
    verify join with an meeting id options     device=device_1
    Click close btn    device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC16:[Join by Code]Verify meet now from ambient screen
    [Tags]     345116    P1     sanity_sm   exclude_ftp_sm
   [Setup]   Testcase Setup for Meeting User     count=3
    Initiates conference meeting using Meet now option     from_device=device_1     to_device=device_2
    Accept incoming call    device=device_2
    Close participants screen   device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Add participant to conversation using display name   from_device=device_1      to_device=device_3
    Accept incoming call      device=device_3
    Close participants screen   device=device_1
    Verify meeting state   device_list=device_1,device_2,device_3    state=Connected
    Check video call On state   device_list=device_1,device_2,device_3
    verify more options in call control bar     device=device_1
    End meeting   device=device_1,device_2,device_3
    Verify meeting state    device_list=device_1,device_2,device_3   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC17:[Join by Code]Verify meeting info details when DUT user joins a meeting from "Meet now"
     [Tags]  345118     P2      exclude_ftp_sm
    [Setup]   Testcase Setup for Meeting User     count=2
    Initiates conference meeting using Meet now option    from_device=device_1     to_device=device_2
    Accept incoming call    device=device_2
    Close participants screen   device=device_1
    Verify meeting state   device_list=device_1,device_2    state=Connected
    Meeting info details when user join a meeting from Join with an ID      device=device_1
    Click close btn    device_list=device_1
    End meeting   device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2   state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC18:[Join by Code]Verify meeting id should be formatted with a white space every 3 characters
    [Tags]   345052     P2      exclude_ftp_sm
     [Setup]   Testcase Setup for Meeting User     count=1
    meeting details containes space for every 3 characters   device=device_1
    Click close btn    device_list=device_1
    [Teardown]   Run Keywords  Capture on Failure    AND     Come back to home screen     device_list=device_1

TC19: [Join by Code]Verify meeting ID field
    [Tags]   345049     p2      exclude_ftp_sm
    [Setup]     Testcase Setup for Meeting User  count=1
    verify join with an meeting id options     device=device_1
    Click close btn     device_list=device_1
    [Teardown]  Run Keywords    Capture on Failure  AND     Come back to home screen     device_list=device_1

TC20:[Join by Code]Verify user should accept only numeric for meeting ID in meeting field
    [Tags]   345050  P2     exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User  count=1
    Accepting numeric values for meeting id in meeting field    device=device_1
    Click close btn     device_list=device_1
    [Teardown]   Run Keywords  Capture on Failure  AND  Come back to home screen     device_list=device_1

TC21:[Join by code] Verify "This meeting is locked" popup when DUT2 user try to join the locked meeting with meeting ID.
    [Tags]      381791         P2      exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    Join meeting    device=device_2    meeting=lock_meeting
    Verify meeting state   device_list=device_2    state=Connected
    Tap on lock meeting   device=device_2
    ${meeting_id}    ${passcode}=    get meeting id and passcode from ongoing meeting    device=device_2
    Join With An Meeting Id and passcode of ongoing meeting    device=device_1    meeting_id=${meeting_id}    passcode=${passcode}
    Verify user cannot join locked meeting notification    device=device_1
    Click close btn    device_list=device_1
    Tap on unlock meeting     device=device_2
    End meeting      device=device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC22:[Join by code] check for join with an id feature with meet.
    [Tags]      381851        P2      exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User     count=2
    join meeting with meeting id and passscode from meet now     from_device=device_1     to_device=device_2
    Verify meeting state   device_list=device_1,device_2    state=Connected
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC23:[Join by code] check the Layout option when joined a meeting through meeting id.
    [Tags]       381962       P2    exclude_ftp_sm
    [Setup]    Testcase Setup for Meeting User   count=2
    Join meeting   device=device_2    meeting=lock_meeting
    Verify meeting state   device_list=device_2    state=Connected
    join with an meeting id   device=device_1         meeting_id=${tdc_meeting_id}    passcode=${tdc_meeting_passcode}
    Verify meeting state   device_list=device_1,device_2    state=Connected
    verify layout switcher ui       device=device_1
    Dismiss the popup screen        device=device_1
    change meeting mode     device=device_1    mode=front_row
    Verify front row mode   device=device_1
    End meeting     device=device_1,device_2
    Verify meeting state    device_list=device_1,device_2    state=Disconnected
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1,device_2

TC24:[Join by Code] Verify "Join with an id" button on DUT
    [Tags]   420620        P1      sanity_sm    exclude_ftp_sm
    [Setup]  Testcase Setup for Meeting User   count=1
    verify join with an meeting id options     device=device_1
    Click close btn    device_list=device_1
    [Teardown]   Run Keywords    Capture on Failure  AND   Come back to home screen    device_list=device_1

TC25:[Join by Code]Verify when a user Join with a wrong meeting code/meeting passcode the Subtitle should be red with an error message
    [Tags]      345080         P2
    [Setup]   Testcase Setup for Meeting User     count=1
    Verify join with an meeting id options    device=device_1
    Enter meeting id and passcode    device=device_1    meeting_id=12345678    passcode=1234
    Click join meeting    device=device_1
    Verify wrong id or passcode retry state    device=device_1
    Enter meeting id and passcode    device=device_1    meeting_id=87654321    passcode=1234
    Click join meeting    device=device_1
    Verify wrong id or passcode retry state    device=device_1
    [Teardown]  Run Keywords   Capture on Failure   AND    Come back to home screen    device_list=device_1

*** Keywords ***
Verify meeting ID field
    [Arguments]    ${device}
    verify join with an meeting id options   ${device}

verify meeting ID and passcode fields
    [Arguments]    ${device}
    verify join with an meeting id options   ${device}

Edit the meeting ID and passcode previously entered
    [Arguments]    ${from_device}    ${to_device}
    verify invalid number and edit the meeting id and passcode   ${from_device}    ${to_device}

invalid meeting id and passcode for join with meeting id
    [Arguments]    ${device}
    verify invalid number and edit the meeting id and passcode    ${device}

Verify retry button when a user enters an invalid meeting ID and invalid passcode
    [Arguments]     ${device}
    verify invalid number and edit the meeting id and passcode    ${device}

Accepting numeric values for meeting id in meeting field
    [Arguments]    ${device}
    meeting details containes space for every 3 characters      ${device}

Verify error message when a user enters an wrong meeting ID
    [Arguments]   ${device}
    Verify user cannot join a meeting without passcode    ${device}

meeting info details when user join a meeting from Join with an ID
    [Arguments]    ${device}
    Verify meeting info options when user join a meeting      ${device}

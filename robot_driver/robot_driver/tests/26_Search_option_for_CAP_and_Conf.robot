*** Settings ***
Resource    ../resources/keywords/common.robot

Suite Teardown        Run Keywords    Suite Failure Capture       AND     Testcase Setup    count=1

*** Variables ***
${wait_time} =  10

*** Test Cases ***
TC1 : [Search] Search for contact by entering a search string without typing the complete contact name
    [Tags]  148998   P1         bvt_pr      search_option_in_other_users
    [Setup]  Testcase Setup for CAP User    count=2
    navigate to people tab     device=device_1
    Search Text   from_device=device_1      to_device=device_2
    Validate search results presented    device=device_1
    [Teardown]    Run Keywords    Capture on Failure    AND    Come back to home screen    device_list=device_1

TC2 : [Search] Search for contact by entering a search string without typing the complete contact name
   [Tags]      305863          bvt_pr        search_option_in_other_users
   [Setup]  Testcase Setup for Meeting User    count=2
   Navigate to people tab    device=device_1
   Search Text   from_device=device_1      to_device=device_2
   Validate search results presented    device=device_1
   [Teardown]    Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1          AND     Testcase Setup    count=1

TC3 : [Admin Settings] User to have admin sign-out option behind admin settings
    [Tags]    309981
    [Setup]  Testcase Setup for CAP User    count=1
    Open settings page   device=device_1
    verify signout option should be in device settings     device_list=device_1
    return to home screen    device_list=device_1
    Open settings page   device=device_1
    verify signout option should be in device settings     device_list=device_1
    Verify Presence Of Intents    device=device_1    feature=admin_password    state=absent
   [Teardown]    Run Keywords    Capture on Failure   AND    Come back to home screen    device_list=device_1

*** Keywords ***


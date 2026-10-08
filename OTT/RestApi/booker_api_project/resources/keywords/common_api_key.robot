*** Settings ***
Resource     ../../resources/variables/common_variables.robot
Library    RequestsLibrary
Library    JSONSchemaLibrary
Library     ../../resources/keywords/create_common_data.py

    
      
*** Variables ***
${alias}            new_session
${Base_url}         https://restful-booker.herokuapp.com
# ${json_path_create_data}      






*** Keywords ***

Genrate token
     ${user_cred_token_gen}    Create Dictionary        username=admin    password=password123
     ${response}        POST On Session        ${alias}       /auth        json=${user_cred_token_gen}
     Log  thersponceaftertokengenrateis:${response}
     Should Be Equal As Integers    ${response.status_code}		200
     ${token}=    Get From Dictionary      ${response.json()}        token
     Log   thetoken is :${token}
     ${status}    Run Keyword And Return Status
     ...    Dictionary Should Contain Key    ${response.json()}    token
     Should Be True    ${status}
     [Return]    ${token}



create a session
    Create Session		${alias}		${Base_url}
    

Schema validation
    [Arguments]    ${data}
    Validate Json    ${data}       ${json_path_create_data}
#
genarting basic token
#	${USERNAME}		${PASSWORD}		generate_token
	${payload}    Create Dictionary    username=admin	   password=password123
	${response}			POST On Session			${alias}		/auth		json=${payload}
	should be equal as integers		${response.status_code}		200
	${status}    ${token}=    Run Keyword And Ignore Error    Get From Dictionary    ${response.json()}    token
    Run Keyword If    '${status}' == 'FAIL'    Fail    Token not found in response. Got: ${response.text}
    Log    ${token}
    [Return]    ${token}



# close session
#     [Arguments]    ${end_point_session}
#     close_current_session    ${end_point_session}
    

    
    
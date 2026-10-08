*** Settings ***
Resource    ../../resources/keywords/common_api_key.robot
Library     ../../resources/keywords/create_common_data.py

*** Keywords ***

create a new booking
    ${data}   crete a booking random
    ${response}    POST On Session    ${alias}       /booking    json=${data}
    [Return]    ${response}        ${data}

get the seesion
    [Arguments]    ${booking_id}
    ${responce}        GET Request    ${alias}       /booking/${booking_id}
    [return]    ${responce}
    

    

 


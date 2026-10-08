*** Settings ***
Resource      ../resources/keywords/create_booking.robot
#Suite Setup    create a session
Library    Collections
Resource    JSONSchemaLibrary



*** Test Cases ***
#    python:
#        token = base64.b64encode(
#    f"{username}:{password}".encode()).decode()

#         const token = Buffer
     #    .from(`${username}:${password}`)
     #    .toString("base64");
 #)

creating a booking and newbooking delete booking updating booking and schema validation
    [Tags]        regression
    [Setup]     Run Keywords      create a session    AND     Genater token in precondition
    Log    thetokenfrom:Genater token in precondition is ${token}
    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Cookie=token=${token}
#    ...    Authorization=Barer ${TOKEN}
    ${parm}=    Create Dictionary    firstname=sally          lastname=brown
    ${responce}    GET On Session    ${alias}    /booking    params=${parm}    headers=${headers}
    Log  thegetresponceis : ${responce.content}


    ${playload}        Crete A Booking Random
    ${lastname}=   Set Variable     ${playload['lastname']}
    Log  thelastnameformrandomdata:${lastname}
    ${booking_responce}=    POST On Session    ${alias}        /booking       json=${playload}     headers=${headers}
    ...    expected_status= 200
    Log    thebookingidwhichcreatedis:${booking_responce.json()['bookingid']}
    Should Be Equal As Integers    ${booking_responce.status_code}    200
    ${responces}=    GET On Session    ${alias}        /booking/${booking_responce.json()['bookingid']}        headers=${headers}        expected_status=200
    ${validation_lastname}=  Get From Dictionary    ${responces.json()}    lastname
    Should Be Equal        ${validation_lastname}        ${lastname}

#    patch reuest
    ${random_dataneed_tochange}    Create Dictionary    lastname=UpdatedName

    ${patch_responce}=    PATCH On Session    ${alias}    /booking/${booking_responce.json()['bookingid']}        headers=${headers}        json=${random_dataneed_tochange}        expected_status=200
    Should Not Be Equal        ${lastname}    ${patch_responce.json()['lastname']}
    ${ACTUAL}    the schema Structure
    Validate Json      ${patch_responce.json()}           ${ACTUAL}

    ${responce}=    DELETE On Session        ${alias}    /booking/${booking_responce.json()['bookingid']}       headers=${headers}        expected_status=201
    Log   ${responce.status_code}
#    again try to dleted   200 ok  201(someapi has menatined dletedresponce or 204 no content)
#    dleted one more time deleted  405 -> not allowed or 404 not found

    ${responce}=    DELETE On Session        ${alias}    /booking/${booking_responce.json()['bookingid']}       headers=${headers}        expected_status=405
    Log  nocontent: ${responce.status_code}






Create Booking
    [Tags]    132345
    ${response}     ${python_random_genrated}       create a new booking
    Should Be Equal As Integers    ${response.status_code}    200
	[Teardown]		run keyword			Session Exists		${alias}


Verify response contains bookingid and booking object
    [Tags]    134445
    ${response}    ${python_random_genrated}      create a new booking
    # ${complete_data}        Evaluate    ${response.json()}    json     alredy return the python dict
    ${complete_data}=    Set Variable    ${response.json()}
    # Set Global Variable        ${complegitte_data}
    # the dictornery should contains is librery frim collections
    Dictionary Should Contain Key        ${complete_data}        bookingid 
    Log    ${complete_data["bookingid"]}
    Log To Console    ${complete_data["bookingid"]}
    Should Be True    ${complete_data["bookingid"]}
    ${booking_object}=        Set Variable    ${complete_data["booking"]}
    Should Be Equal    ${booking_object['firstname']}        ${python_random_genrated['firstname']}
    Log    ${python_random_genrated['firstname']}
	[Teardown]		run keyword			Session Exists		${alias}

Validate of schema structure
    [Tags]    653461        #bug
    Schema validation     ${complete_data}
	[Teardown]		run keyword			Session Exists		${alias}

Create booking with different price ranges (min, max)
    [Tags]    53633
    ${list_value_prices}        Create List  
    ${LIST_NEW_BOOKING_IDS}        Create List
    FOR    ${i}    IN RANGE    5
        ${response}    ${python_random_genrated}      create a new booking
        ${complete_data}=    Set Variable    ${response.json()}
        Dictionary Should Contain Key        ${complete_data}        bookingid
        Should Be True    ${complete_data["bookingid"]}
        Log    ${complete_data} 
        ${booking_object}=        Set Variable    ${complete_data["booking"]}
        Should Be Equal    ${booking_object['firstname']}        ${python_random_genrated['firstname']}
        Should Not Contain    ${LIST_NEW_BOOKING_IDS}      ${complete_data["bookingid"]}
        Append To List      ${LIST_NEW_BOOKING_IDS}      ${complete_data["bookingid"]}
        Should Not Contain    ${list_value_prices}        ${booking_object["totalprice"]}
        Append To List        ${list_value_prices}        ${booking_object["totalprice"]}
    END
    Log     ${list_value_prices}
    Log     ${LIST_NEW_BOOKING_IDS}
	[Teardown]		run keyword			Session Exists		${alias}
    
get booking details valid user id
    [Tags]  43536
    ${create_id}    ${python_random_genrated}    post session so get the booking id
    ${response}        get the seesion    ${create_id}
	log		THE DETAILS AFTER GETTING FROM THE ID IS ${response}
    Should Be Equal As Integers    ${response.status_code}    200
    @{list_of_data}    Create List  firstname    lastname    totalprice    depositpaid    additionalneeds    bookingdates
	FOR    ${Each_value}    IN    @{list_of_data}
		Dictionary Should Contain Key    ${response.json()}   ${Each_value}
		${is_bookingdates}=    Set Variable If    '${Each_value}' == 'bookingdates'    ${True}    ${False}
		Run Keyword If    ${is_bookingdates}    Dictionary Should Contain Key    ${response.json()['bookingdates']}    checkin
		Run Keyword If    ${is_bookingdates}    Dictionary Should Contain Key    ${response.json()['bookingdates']}    checkout
	END
    [Teardown]		run keyword			Session Exists		${alias}

get booking details by invaild values
	[Tags]	45362
	${create_id}   ${python_random_genrated}      post session so get the booking id
	${invalid_id}		Evaluate		${create_id}+567
	log		${invalid_id}
    ${response}        get the seesion    ${invalid_id}
#	if inavible geeting the 200 400 multipal time then handels it
	Run Keyword If    ${response.status_code} == 200   	Should Be Empty    ${response.text}
	Run Keyword If    '${response.status_code}' == '404'    Log    Booking ID not found (404)
    [Teardown]		run keyword			Session Exists		${alias}

get auth and token genartion
	[Tags] 	45342
	${token}    genarting basic token
	log to console	 Token genrate postive ${token}
	[Teardown]		run keyword			Session Exists		${alias}

verfiy auth and token Wrong username/password
	[Tags]  34567
	${invalid_username}			set variable	invalidusername
	log		${invalid_username}
	${user_auth_details}		create dictionary	 username=${invalid_username}	   password=password123
	${responces}		POST On Session			${alias}		/auth		json=${user_auth_details}
	${status}    ${token}=    Run Keyword And Ignore Error 	 			Get From Dictionary    ${responces.json()}    token
	log to console			${token}
	Run Keywords    Should Be Equal As Integers    ${responces.status_code}    200
	...		AND     should be equal		${responces.json()["reason"]}    Bad credentials
	[Teardown]		run keyword			Session Exists		${alias}

verify and check the Update Booking (PUT)
		[Tags]   455644
		${actaully_booking_exist_id}	${python_random_genrated}   	post session so get the booking id
		&{headers}			Genarate the token and headers json type
		${payload}		Modify the plyload
#here convert to dict to json
		${response}=    PUT On Session    ${alias}    /booking/${actaully_booking_exist_id}     json=${payload}		 headers=${headers}
		Log To Console    ${response.status_code}
		Log To Console    ${response.json()}
		should be equal as strings	    ${response.json()["firstname"]}    ${payload["firstname"]}
		Should Be Equal As Strings    ${response.json()["lastname"]}     ${payload["lastname"]}

#		valid without token
		${response}=    PUT On Session    ${alias}    /booking/${actaully_booking_exist_id}    json=${payload}    expected_status=403
		Log To Console    ${response.status_code}
		[Teardown]		run keyword			Session Exists		${alias}

Verify particular text fileds get Partial Update (PATCH)
	[Tags]		467548
	${actaully_booking_exist_id}	${python_random_genrated}   	post session so get the booking id
	&{headers}			Genarate the token and headers json type
	${playload}		create dictionary		firstname=yashaswini_yashwanth
	${Responces_patch}		PATCH On Session		${alias}		/booking/${actaully_booking_exist_id}		headers=${headers}		json=${playload}		expected_status=200
	should contain		${Responces_patch.json()['firstname']}		yashaswini_yashwanth
	[Teardown]		run keyword			Session Exists		${alias}

Delete the user_by_id
	[Tags]	98761
	${actaully_booking_exist_id}	${python_random_genrated}   	post session so get the booking id
	&{headers}			Genarate the token and headers json type
	${responce}		DELETE On Session		${alias}		/booking/${actaully_booking_exist_id}		headers=${headers}
	log			the status code after the delete the data ${responce.status_code}
	should be equal as integers		${responce.status_code}		201
#	when retry the deted id using
	${response}=    DELETE On Session    ${alias}    /booking/${actaully_booking_exist_id}    headers=${headers}    expected_status=405
      #  method is not allowed(405)
#	some time second delete api may return 404 or srever not allow to dlete
	Run Keyword If    ${response.status_code} == 404    Log    Booking already deleted
	Run Keyword If    ${response.status_code} == 405    Log    Server does not allow second delete
	[Teardown]		run keyword			 Session Exists		${alias}

delete the details invalid token
	[Tags]	56325
	${invalid_token_headers}		Genrate invalid token
	${actaully_booking_exist_id}	${python_random_genrated}   	post session so get the booking id
	${responce}		DELETE On Session		${alias}		/booking/${actaully_booking_exist_id}		headers=${invalid_token_headers}		expected_status=403
	log	 The responce from the invalid token is the ${responce.status_code}
	[Teardown]		run keyword			 Session Exists		${alias}


# Negative & Edge Cases
#•	Create with:
#o	Missing mandatory field (firstname) → expect 400/500.
#o	Wrong datatype (totalprice as string) → expect error.
#o	Extra unexpected field → ignored or error.
#o	Empty request body → 400.

Negative & Edge Cases for name and data type
	[Tags]   64388
	${payload}	Modify the plyload
	Set To Dictionary    ${payload}		firstname=
	log to console	${payload}
	&{headers}			Genarate the token and headers json type
	${responces}		POST On Session			${alias}		/booking		headers=${headers}		json=${payload}
	log to console		${responces.json()}
	Should Be Equal As Integers    ${responces.status_code}    200
#	if pass the value insted of integer
    ${integer}    Evaluate    5
	Set To Dictionary    ${payload}		firstname=${integer}

#	this is call unpacking why : if we use run keyword if fail or warn failure means it will tell us it is tuple so need to do unpacking
#	just asisng the unpacking by two variables
	${status}    ${response}=    Run Keyword And Warn On Failure    POST On Session    ${alias}    /booking    headers=${headers}    json=${payload}
	Log    Keyword status: ${status}           # PASS or FAIL

	# Conditional handling
	Run Keyword If    '${status}' == 'PASS'    Log    HTTP Status Code: ${response.status_code}
    ...    ELSE    Log    Response failed, returned string: ${response}

Schema valiadtion by mandatory fields
	[Tags]   56789
	${payload}	Modify the plyload
	&{headers}			Genarate the token and headers json type
	${status}      ${responces}=  	Run Keyword And Ignore Error	POST On Session			${alias}		/booking		headers=${headers}		json=${payload}

	Log    Keyword status: ${responces.status_code}
    ${root_schema}    the schema Structure
	${responces_body}=    Set Variable    ${responces.json()}
	${mandatory_schema}=    Set Variable    ${root_schema}
	# If request passed, response is Response object
	Run Keyword If    '${status}' == 'PASS'
	...    Validate Json    ${responces_body}    ${mandatory_schema}
	Run Keyword if  '${status}' == 'PASS'     Response validated successfully

	# If request failed, log error
	Run Keyword If    '${status}' == 'FAIL'
	...    Log    API request failed: ${response}







*** Keywords ***
post session so get the booking id
     ${response}    ${python_random_genrated}      create a new booking
     Dictionary Should Contain Key        ${response.json()}        bookingid
     Should Be True      ${response.json()['bookingid']}
     [RETURN]    ${response.json()['bookingid']}		${python_random_genrated}
    


Genarate the token and headers json type
	${token}     genarting basic token
	&{headers}    Create Dictionary
	...    Cookie=token=${token} 	Content-Type=application/json
	[Return]	&{headers}

Genrate invalid token
	${token}     genarting basic token
#  Altrantive approch of invalid token means evaluate  that is set variable
	${invalid}=    Set Variable    ${token}invalid
	&{headers}    Create Dictionary
	...    Cookie=token=${invalid} 	Content-Type=application/json
	[Return]		${headers}


Modify the plyload
	&{bookingdates}=    Create Dictionary
		...    checkin=2018-01-01
		...    checkout=2019-01-01
	&{payload}=    Create Dictionary
		...    firstname=yashwanth
		...    lastname=gowdas
		...    totalprice=111
		...    depositpaid=${True}
		...    bookingdates=${bookingdates}
		...    additionalneeds=Breakfast
	[Return]   &{payload}

the schema Structure
    &{bookingdates_properties}=    Create Dictionary
	...    checkin={"type": "string"}
	...    checkout={"type": "string"}

	&{bookingdates_schema}=    Create Dictionary
	...    type=object
	...    properties=${bookingdates_properties}
	...    required=["checkin","checkout"]

	

    &{booking_properties}=    Create Dictionary
	...    firstname={"type": "string"}
	...    lastname={"type": "string"}
	...    totalprice={"type": "integer"}
	...    depositpaid={"type": "boolean"}
	...    bookingdates=${bookingdates_schema}
	...    additionalneeds={"type": "string"}
	&{booking_schema}=    Create Dictionary
	...    type=object
	...    properties=${booking_properties}
	...    required=["firstname","lastname","bookingdates"]

    &{root_properties}=    Create Dictionary
	...    booking=${booking_schema}
	
	&{root_schema}=    Create Dictionary
	...    type=object
	...    properties=&{root_properties}
	...    required=["booking"]
	[Return] 	&{root_schema}

Genater token in precondition
     ${token}    Genrate token
     Set Test Variable    ${token}

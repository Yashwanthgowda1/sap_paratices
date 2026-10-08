*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${single_value}    1
@{mutipal_vlaue}    1 2 3
&{dict}        key=name   pair=value


*** Test Cases ***
tc1: lanuching browser and swtricg the frame valide the key work exicute
    [Tags]  qa 67388393  @sanity
    [Setup]  Run Keyword        Open Browser   browser=Chrome      url=https://www.snapdeal.com/
    ${title}=  Get title
    Should Contain   ${title}        snapedal
    Input Text    automatically[take the cpath]   shirts
    ${webelemnts}        Get WebElement        elemnstsxpath
    ${status}        Run Keyword And Return Status    ${webelemnts}
    Wait Until Keyword Succeeds    10s    500ms
    ...    Scroll Element Into View    xpath://img[@alt="Snapdeal Youtube Page"]
    Mouse Down        ${webelemnts}
    Double Click Element        ${webelemnts}
    Drag And Drop        ${webelemnts}            ${webelemnts_st}
    Drag And Drop By Offset    ${webelement}    100    200
    Open Context Menu        ${eqialent_torightclick}
    Click Element At Coordinates    ${webelement}    50    100
#    drop down
    Select From List By Label    id=country    India
    Select From List By Index    id=counter     2
    Select From List By Value        id=counter     ammercia
    @{values}=    Get Selected List Labels    id=country


    FOR    ${each}    IN    @{values}
        Log    ${each}
    END
    ${value}=    Get Element Attribute    id=country    multiple

    IF    '${value}' != '${None}'
        Log    Multi Select Dropdown
    END
    Unselect From List By Index    id==counter 1
    Unselect From List By Value  id=countery  index

    Unselect All From List
    ${slected list value from dropdown}        Get Selected List Values("comment : it will return all the slected values ")
    Handle Alert    action=ACCEPT
    Handle Alert    action=DISMISS
    Input Text Into Alert    ADMIN
    Alert Should Be Present    VALUES
    Drag And Drop By Offset    ID=VALUES        100     2000


#   FARME
    ${all_frame}=    Get WebElements    id:iframe
    FOR    ${each}    IN    ${all_frame}
        Select Frame    ${each}
        Page Should Contain    idpath
        ${elents_status}    Run Keyword And Return Status     Page Should Contain    idpath
        IF    ${elents_status}
            Log "it has the frame obtained"
        END
        Unselect Frame
        Select Checkbox  idchekcbox
        Page Should Contain Checkbox    id=idpagechekcbox
        Checkbox Should Be Selected    id_unslect
        Unselect Checkbox    id_unslect
        ${status}=    Run Keyword And Return Status
        ...    Radio Button Should Not Be Selected    group_name    value

        IF    ${status}

                Select Radio Button    group_name    value

        END

        ${all_opendwindiow}    Get Window Handles
        ${firstparent}    Set Variable    ${all_opendwindiow}[0]
        Click Element    ${webelement}
#        noe 100 window get opned ex
        @{mutipal_winodelemnt}    Get Window Handles
        FOR    ${ecah}    IN    ${mutipal_winodelemnt}
            IF    '${each}' != '${firstparent}'
                Switch Window    ${each}
                ${status}    Run Keyword And Return Status
                ...   Element Should Be Visible    id-username
                IF    ${status}:
                    log  "perform the thinsg

    Should Be Equal As Integers
#        range also we can perfoem
#        switch bbach on by one
         ${actilalength}   Get Length ${mutipal_winodelemnt}



END


        END









    END








END






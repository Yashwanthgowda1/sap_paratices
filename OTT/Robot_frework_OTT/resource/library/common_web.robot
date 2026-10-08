*** Settings ***

Library    ../../resource/library/common_web_andriod.py


*** Variables ***
${BROWSER}    chrome

${URL}        https://www.w3schools.com/python/python_ref_dictionary.asp


*** Keywords ***

Open Web Browser And Go To URL
    ${driver}=    Initialize Driver    device_type=web    browser=${BROWSER}
    go_to_url    ${URL}

Close Web Browser
    close_browser
   
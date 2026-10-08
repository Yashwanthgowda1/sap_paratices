*** Settings ***
Library    ../library/common_web_andriod.py		WITH NAME    Common
Library		../resource/keywords/sigin.py

*** Variables ***
${BROWSER}    chrome
${URL}        https://opensource-demo.orangehrmlive.com/web/index.php/auth/login

*** Test Cases ***
Signin To OrangeHRM
	[Tags]    45456
	Common.Initialize Driver    device_type=web    browser=${BROWSER}
    Common.Go To Url    ${URL}
    Perform Login


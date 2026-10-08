*** Settings ***
Library    ../../library/sign_in.py
Resource   ../library/common_web.robot


*** Test Cases ***
Sign In
    Open Web Browser And Go To URL
    search_methods



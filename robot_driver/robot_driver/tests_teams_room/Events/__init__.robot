*** Settings ***
Resource    resources/keywords/common.robot

Suite Setup    Sign In  user_list=user
Suite Teardown    Suite Failure Capture

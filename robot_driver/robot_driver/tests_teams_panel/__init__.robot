*** Settings ***
Resource    ../resources/keywords/common.robot
Suite Setup    Run keywords     Panels Suite Setup    AND     System Setup      AND     initiate web driver     device=tdc_1:meeting_user    AND    perform web signin method     device=tdc_1:meeting_user
Suite Teardown     System Teardown


*** Variables ***


*** Keywords ***
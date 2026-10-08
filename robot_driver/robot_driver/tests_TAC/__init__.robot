*** Settings ***
Resource    ../resources/keywords/common.robot
Suite Setup         run keywords        System Setup        AND     launch and login to TAC
Suite Teardown      run keywords        Suite Failure Capture   AND     System Teardown

*** Variables ***


*** Keywords ***
launch and login to TAC
    initiate driver and tac get     tdc_1
    perform web signin method    tdc_1:admin_tac_user   tac_signin=True

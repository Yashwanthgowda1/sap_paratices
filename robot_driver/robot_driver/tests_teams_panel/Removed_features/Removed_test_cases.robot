# Removing this TC due to: Bug 4177866: [Panels][Automation] "Long meeting name text" does not get truncated on Ui Automator
#TC15: [Home screen] User to verify the meeting room name on the home screen
#    [Tags]   307261     TDC_meeting_test
#    [Setup]  Testcase Setup   count=1
#    create TDC meeting    device=tdc_1:meeting_user     meeting_name=${Long_meeting_title}       time_duration=5 min       participants=device_1     use_current_time=True      roundup_end_time=off
#    Wait for Some Time    time=30
#    Refresh calls main tab  device=device_1
#    Refresh calls main tab  device=device_1
#    verify truncated meeting title in panel      device=device_1   meeting=${Long_meeting_title}
#    [Teardown]  Run Keywords    Capture on Failure    AND    delete all meetings from tdc     device=tdc_1:meeting_user    meeting_list=${Long_meeting_title}       AND      Refresh calls main tab  device=device_1    AND      Refresh calls main tab  device=device_1

#Cannot be tested due to Bug 2764720: [Panel] [Automation] User is not able to interact with any options under panel app settings screen using automation
#TC10: [Settings] Verify 2 min Timeout at Privacy & Cookies link, user auto exit
#    [Tags]  322037
#    [Setup]  Testcase Setup   count=1
#    Navigation to settings page in panel  device=device_1
#    verify privacy and cookies option in panel  device=device_1
#    Wait for Some Time    time=120
#    verify room parameters    device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

#TC11: [Settings] Verify 2 min Timeout at Terms of Use and Third Party Software Notices and Information, user auto exit
#    [Tags]  322038
#    [Setup]  Testcase Setup   count=1
#    Navigation to settings page in panel  device=device_1
#    verify Third Party Notices and information option in panel  device=device_1
#    Wait for Some Time    time=120
#    verify room parameters    device=device_1
#    Navigation to settings page in panel  device=device_1
#    verify terms of use option in panel  device=device_1
#    Wait for Some Time    time=120
#    verify room parameters    device=device_1
#    [Teardown]  Run Keywords   Capture on Failure  AND    Come back to home screen    device_list=device_1

#TC12: [Settings] Verify 30 sec timeout at settings, about and report an issue screen user should auto exit
#    [Tags]  322040
#    [Setup]  Testcase Setup   count=1
#    Navigation to settings page in panel  device=device_1
#    wait and after timeout check homescreen     device=device_1
#    Navigation to settings page in panel  device=device_1
#    verify about option in panel  device=device_1
#    wait and after timeout check homescreen     device=device_1
#    Navigation to settings page in panel  device=device_1
#    verify report an issue in panel  device=device_1
#    wait and after timeout check homescreen     device=device_1
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

# Due to bug removing this TC from automation: Bug 4177866: [Panels][Automation] "Long meeting name text" does not get truncated on Ui Automator
#TC5: [UX] If the meeting name in the calendar exceeds 40 characters, verify that ellipsis is used
#    [Tags]   322099     TDC_meeting_test
#    [Setup]  Testcase Setup   count=1
#    create all day TDC meeting    device=tdc_1:meeting_user     meeting_name=${Long_meeting_title}       participants=device_1    all_day_meeting=on
#    Wait for Some Time    time=30
#    Refresh calls main tab  device=device_1
#    Refresh calls main tab  device=device_1
#    verify truncated meeting title in panel      device=device_1   meeting=${Long_meeting_title}
#    [Teardown]  Run Keywords    Capture on Failure     AND   delete all meetings from tdc     device=tdc_1:meeting_user    meeting_list=${Long_meeting_title}       AND    Refresh calls main tab  device=device_1       AND    Refresh calls main tab  device=device_1

#TC2: [Private meetings] User to verify "Meetings" option under Panels App settings
#    [Tags]  307965   sanity     bvt_panels_pr
#    [Setup]  Testcase Setup   count=1
#    navigate to meetings option in panel app settigs    device=device_1
#    verifying meeting name based on show meeting name status     device=device_1     toggle=on
#    [Teardown]  Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1

#Cannot be tested due to Bug 3986757: [Panels][Phone]After changing cloud from GCCH to Public, device gets stuck in Connecting page
#TC17: [ZTP]Device login url on Landing page
#    [Tags]  307957
#    [Setup]  Testcase Setup for ZTP  count=1
#    verify teams app signin page    device=device_1
#    verify settings from signin page    device_1
#    verify cloud option    device_1
#    verify login url with cloud settings as public    device_1
#    verify settings from signin page    device_1
#    verify cloud option    device_1
#    verify login url with cloud setting as gcc    device_1
#    verify settings from signin page only GCC    device_1
#    verify cloud option    device_1
#    verify login url with cloud setting as gcc high    device_1
#    verify settings from signin page only GCC    device_1
#    verify cloud option    device_1
#    verify login url with cloud setting as gcc dod    device_1
#    verify settings from signin page only GCC    device_1
#    verify cloud option    device_1
#    verify login url with cloud settings as public    device_1
#    [Teardown]  Run Keywords    Capture on Failure    AND    Device setting back till signin btn visible    device=device_1

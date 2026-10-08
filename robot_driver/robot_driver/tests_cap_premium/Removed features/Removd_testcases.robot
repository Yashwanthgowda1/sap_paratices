#TC1 : [GCP] DUT user gets the incoming group call notification
#    [Documentation]  Precondition device_3 add device_1 and device_2 as call group members
#    [Tags]      2701
#    [Setup]     run keywords     Testcase Setup for CAP Premium User    count=4   AND     Enable call forwarding to call group     from_device=device_3    contact_device=device_1
#    click on calls tab     device=device_4
#    Make outgoing call using phonenumber    from_device=device_4      to_device=device_3
#    Verify call notification    device=device_1,device_2     status=appear
#    Verify gcp call name on call toast      device=device_1,device_2     from_device=device_3
#    Pick incoming call from call notification    device=device_1
#    Verify Call State    device_list=device_1,device_4    state=Connected
#    Disconnect call     device=device_4
#    Verify Call State    device_list=device_1,device_4     state=Disconnected
#    [Teardown]  run keywords  Capture on Failure    AND     Come back to home screen    device_list=device_1,device_2,device_3,device_4     AND     verify and disable call forwarding    device=device_3
#
#TC4 : [Advance calling][Incoming Calls] DUT user rejects the incoming call from TDC user
#    [Tags]  329345    P1     Sanity_CAPPremium
#    [Setup]  Testcase Setup for CAP Premium User    count=2
#    click on calls tab     device=device_2
#    Make outgoing call using display name    from_device=device_2      to_device=device_1:cap_search_enabled
#    Rejects the incoming call   device_list=device_1
#    Wait for Some Time    time=${wait_time}
#    verify call state and disconnect        device=device_1,device_2
#    [Teardown]   Run Keywords    Capture on Failure  AND    Come back to home screen    device_list=device_1,device_2
#
#TC1 : [CAP Premium] [Hot Desking] DUT user to enable Hot desk
#      [Tags]    3001
#      [Setup]   Testcase Setup for CAP Premium User     count=1
#      Validate HD signin with invalid user    device=device_1
#      [Teardown]   Run Keywords    Capture on Failure   AND   device_setting_back   device=device_1     AND    Come back to home screen    device_list=device_1
#
#TC5 : [Customer Love] [Cap Premium] Verify appbar title when appearance is changed to Dark Theme
#    [Tags]      401623     P2
#    [Setup]  Testcase Setup for CAP Premium User   count=1
#    verify and enable dark theme     device=device_1
#    verify app bar title with date time and DID number    device=device_1     other_user=device_1:cap_search_enabled
#    [Teardown]   Run Keywords    Capture on Failure   AND   Come back to home screen    device_list=device_1    AND    verify and disable dark theme     device_1
#
#TC4 : [CAP Premium][Setting] Verify calling settings options
#      [Tags]    1904
#      [Setup]   Testcase Setup for CAP User     count=1
#      verify cap premium calling setting options    device=device_1
#      [Teardown]   Run Keywords    Capture on Failure   AND  Come back to home screen    device_list=device_1
#
#329235
#TC3 : [CAP Premium][Voicemail] Admin to Set voicemail greetings
#      [Tags]    2503
#      [Setup]  run keywords     Testcase Setup for CAP Premium User  count=2    AND     Enable unanswered call to voicemail   from_device=device_1    contact_device=device_2
#      Send Voicemail    from_device=device_2   to_device=device_1:cap_search_enabled
#      Navigate to voicemail tab    device=device_1
#      refresh main tab    device=device_1
#      Verify user contact details who left voice mail    device=device_1    from_device=device_2
#      Click on voicemail play button and validate    device=device_1
#      [Teardown]  Run Keywords    Capture on Failure    AND     Disable unanswered call    device=device_1      contact_device=device_2      AND    Come back to home screen    device_list=device_1,device_2
#

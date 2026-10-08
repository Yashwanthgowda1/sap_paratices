*** Settings ***
Resource    ../resources/keywords/common.robot

*** Keywords ***
increase volume and verify
    [Arguments]    ${device}    ${volume_stream}
    ${Cvolume}    current volume level    ${device}    ${volume_stream}
    ${C1volume}    adjust volume if at max or min    ${device}    ${Cvolume}    ${volume_stream}
    volume up using keyevent    ${device}
    Wait for Some Time    time=10s
    ${C2volume}    current volume level    ${device}    ${volume_stream}
    Should Be True    ${C2volume} > ${C1volume}    Volume did not increased.

decrease volume and verify
    [Arguments]    ${device}    ${volume_stream}
    ${Cvolume}    current volume level    ${device}    ${volume_stream}
    ${C1volume}    adjust volume if at max or min    ${device}    ${Cvolume}    ${volume_stream}
    volume down using keyevent    ${device}
    Wait for Some Time    time=10s
    ${C2volume}    current volume level    ${device}    ${volume_stream}
    Should Be True    ${C2volume} < ${C1volume}    Volume did not decreased.
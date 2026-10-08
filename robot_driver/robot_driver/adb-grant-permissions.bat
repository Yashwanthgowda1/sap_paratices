@echo off

:: Check if the user provided the device IP address and APK path as parameters
if "%~1"=="" (
    echo Please provide the device IP address as parameter.
    exit /b
)

set ipOfDevice=%1

:: Connect to the device
adb connect %ipOfDevice%

:: grant all the permissions
adb -s %ipOfDevice% shell pm grant com.microsoft.skype.teams.ipphone android.permission.POST_NOTIFICATIONS
adb -s %ipOfDevice% shell pm grant com.microsoft.skype.teams.ipphone android.permission-group.MICROPHONE
adb -s %ipOfDevice% shell pm grant com.microsoft.skype.teams.ipphone android.permission.RECORD_AUDIO
adb -s %ipOfDevice% shell pm grant com.microsoft.skype.teams.ipphone android.permission.READ_PHONE_STATE
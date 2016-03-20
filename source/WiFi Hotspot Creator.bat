@echo off

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0"

rem Window Title
title Batch Hotspot Creator

rem Window Size
mode con: cols=37 lines=13

rem Window Color
color fc

:status
netsh wlan show hostednetwork | find "Not" && goto menu1
goto menu2

:menu1
cls
echo.
echo  ==============HOTSPOT==============
echo.
echo  Welcome!         Hotspot = Inactive
echo.
echo    1. Create Hotspot
echo    2. Stop Hotspot
echo    3. Load Config ^&^ Restart Hotspot
echo    4. Remove Files
echo    5. Exit Program
echo.
echo  ===================================

choice /n /c:12345
if %errorlevel%==5 goto exit
if %errorlevel%==4 goto removeFiles
if %errorlevel%==3 goto restartHotspot
if %errorlevel%==2 goto stopHotspot
if %errorlevel%==1 goto configureHotspot

goto menu1

:menu2
cls
echo.
echo  ==============HOTSPOT==============
echo.
echo  Welcome!           Hotspot = Active
echo.
echo    1. Create Hotspot
echo    2. Stop Hotspot
echo    3. Load Config ^&^ Restart Hotspot
echo    4. Remove Files
echo    5. Exit Program
echo.
echo  ===================================

choice /n /c:12345
if %errorlevel%==5 goto exit
if %errorlevel%==4 goto removeFiles
if %errorlevel%==3 goto restartHotspot
if %errorlevel%==2 goto stopHotspot
if %errorlevel%==1 goto configureHotspot

goto menu2

:configureHotspot
rem Configures Hotspot
cls
echo.
echo  ==============HOTSPOT==============
echo.
echo  Enter Network Name (no spaces): 
set /P ssid= 
echo.
echo  Enter password (8-32 characters): 
set /P password= 

cls
echo.
echo  ==============HOTSPOT==============
echo.
echo  SSID: %ssid%
echo  Password: %password%
echo.
echo  Correct? [Yes=1 No=2]
echo.
echo.
echo.
echo.
echo.

choice /n /c:12
if %errorlevel%==2 goto configureHotspot
if %errorlevel%==1 goto configureHotspot2

goto configureHotspot

:configureHotspot2
rem Boot up Hotspot

rem Stop Hotspot
netsh wlan stop hostednetwork
cls
ping 1.1.1.1 -n 1 -w 1000 >nul

rem Configure Hotspot
netsh wlan set hostednetwork mode=allow ssid=%ssid% key=%password% keyUsage=persistent
cls

rem Stop Hotspot
netsh wlan start hostednetwork
cls
ping 1.1.1.1 -n 1 -w 1000 >nul

rem Stop 'Internet Connection Sharing' service
net stop SharedAccess
cls
ping 1.1.1.1 -n 1 -w 1000 >nul

rem Configure 'Internet Connection Sharing' service
REG add "HKLM\SYSTEM\CurrentControlSet\services\SharedAccess" /v Start /t REG_DWORD /d 2 /f
cls

rem Start 'Internet Connection Sharing' service
net start SharedAccess
cls

rem Stop Ethernet Adapter
ipconfig /release
cls
ping 1.1.1.1 -n 1 -w 1000 >nul

rem Start Ethernet Adapter
ipconfig /renew
cls
ping 1.1.1.1 -n 1 -w 1000 >nul

rem Stop 'Internet Connection Sharing' service
net stop SharedAccess
cls
ping 1.1.1.1 -n 1 -w 1000 >nul

rem Start 'Internet Connection Sharing' service
net start SharedAccess
cls

rem Stop Hotspot
netsh wlan stop hostednetwork
cls
ping 1.1.1.1 -n 1 -w 1000 >nul

rem Start Hotspot
netsh wlan start hostednetwork
cls
ping 1.1.1.1 -n 1 -w 1000 >nul

rem Write Config
cd C:\Program Files
mkdir Hotspot
cls
cd Hotspot
del ssid
del password
del password_decrypted
del password_encrypted
cls
echo %ssid% >ssid
echo %password% >password
cls

:encrypt
cd /d %~dp0
cls
cd bin
start encrypt.bat
cd C:\Program Files\Hotspot

:encryptText
if exist password_encrypted goto encyptionDone

cls
echo.
echo  ==============HOTSPOT==============
echo.
echo.
echo.
echo        Waiting for encryption.
echo.
echo.
echo.
echo.
echo.
echo  ===================================
ping 1.1.1.1 -n 1 -w 1000 >nul
cls
echo.
echo  ==============HOTSPOT==============
echo.
echo.
echo.
echo       Waiting for encryption..
echo.
echo.
echo.
echo.
echo.
echo  ===================================
ping 1.1.1.1 -n 1 -w 1000 >nul
cls
echo.
echo  ==============HOTSPOT==============
echo.
echo.
echo.
echo       Waiting for encryption...
echo.
echo.
echo.
echo.
echo.
echo  ===================================
ping 1.1.1.1 -n 1 -w 1000 >nul

goto encryptText

:encyptionDone
del password
del password_decrypted

cd /d %~dp0

goto done

:restartHotspot
goto decrypt

:decrypt
cd /d %~dp0
cls
cd bin
start decrypt.bat
cd C:\Program Files\Hotspot

:decryptText
if exist password_decrypted goto decyptionDone

cls
echo.
echo  ==============HOTSPOT==============
echo.
echo.
echo.
echo        Waiting for decryption.
echo.
echo.
echo.
echo.
echo.
echo  ===================================
ping 1.1.1.1 -n 1 -w 1000 >nul
cls
echo.
echo  ==============HOTSPOT==============
echo.
echo.
echo.
echo       Waiting for decryption..
echo.
echo.
echo.
echo.
echo.
echo  ===================================
ping 1.1.1.1 -n 1 -w 1000 >nul
cls
echo.
echo  ==============HOTSPOT==============
echo.
echo.
echo.
echo       Waiting for decryption...
echo.
echo.
echo.
echo.
echo.
echo  ===================================
ping 1.1.1.1 -n 1 -w 1000 >nul

goto decryptText

:decyptionDone
cls
echo.
echo  ==============HOTSPOT==============
echo.
echo.
echo.
echo           Loading Config...
echo.
echo.
echo.
echo.
echo.
echo  ===================================
ping 1.1.1.1 -n 1 -w 1000 >nul

cd C:\Program Files\Hotspot

set /p ssid=<ssid
set /p password=<password_decrypted

del password_decrypted

cd /d %~dp0

goto restart

:restart
cls
echo.
echo  ==============HOTSPOT==============
echo.
echo.
echo.
echo         Restarting Hotspot...
echo.
echo.
echo.
echo.
echo.
echo  ===================================
ping 1.1.1.1 -c 1 -w 1000 >nul

cls
rem Stop Hotspot
netsh wlan stop hostednetwork
cls
ping 1.1.1.1 -n 1 -w 1000 >nul

rem Configure Hotspot
netsh wlan set hostednetwork mode=allow ssid=%ssid% key=%password% keyUsage=persistent
cls

rem Stop Hotspot
netsh wlan start hostednetwork
cls
ping 1.1.1.1 -n 1 -w 1000 >nul

rem Stop 'Internet Connection Sharing' service
net stop SharedAccess
cls
ping 1.1.1.1 -n 1 -w 1000 >nul

rem Configure 'Internet Connection Sharing' service
REG add "HKLM\SYSTEM\CurrentControlSet\services\SharedAccess" /v Start /t REG_DWORD /d 2 /f
cls

rem Start 'Internet Connection Sharing' service
net start SharedAccess
cls

rem Stop Ethernet Adapter
ipconfig /release
cls
ping 1.1.1.1 -n 1 -w 1000 >nul

rem Start Ethernet Adapter
ipconfig /renew
cls
ping 1.1.1.1 -n 1 -w 1000 >nul

rem Stop 'Internet Connection Sharing' service
net stop SharedAccess
cls
ping 1.1.1.1 -n 1 -w 1000 >nul

rem Start 'Internet Connection Sharing' service
net start SharedAccess
cls

rem Stop Hotspot
netsh wlan stop hostednetwork
cls
ping 1.1.1.1 -n 1 -w 1000 >nul

rem Start Hotspot
netsh wlan start hostednetwork
cls
ping 1.1.1.1 -n 1 -w 1000 >nul

goto done

:stopHotspot
cls
echo.
echo  ==============HOTSPOT==============
echo.
echo.
echo.
echo          Stopping Hotspot...
echo.
echo.
echo.
echo.
echo.
echo  ===================================
ping 1.1.1.1 -c 1 -w 1000 >nul

cls
rem Stop Hotspot
netsh wlan stop hostednetwork
cls
ping 1.1.1.1 -n 1 -w 1000 >nul

goto done

:done
cls
echo.
echo  ==============HOTSPOT==============
echo.
echo                 DONE!
echo.
echo.
echo      1. Go back to the Main Menu
echo           2. Exit Program
echo.
echo.
echo.
echo  ===================================

choice /n /c:12
if %errorlevel%==2 goto exit
if %errorlevel%==1 goto status

goto exit

:removeFiles
cls
echo.
echo  ==============HOTSPOT==============
echo.
echo.
echo.
echo            Cleaning up...
echo.
echo.
echo.
echo.
echo.
echo  ===================================
ping 1.1.1.1 -n 1 -w 1000 >nul

cd C:\Program Files\Hotspot
cls
del ssid
cls
del password
cls
del password_decrypted
cls
del password_encrypted
cls
cd ..
cls
rmdir Hotspot

goto done

:exit
cls
echo.
echo  ==============HOTSPOT==============
echo.
echo.
echo               EXITING...
echo.
echo.
echo.
echo.
echo.
echo.
echo  ===================================

ping 1.1.1.1 -n 1 -w 2000 > nul
exit
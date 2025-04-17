@echo off
color E

:::  _    _ ___________ _____             ___  ___  ___ _   _  _____ _____ _____  ___  
::: | |  | |_   _|  ___|_   _|           / _ \ |  \/  || \ | ||  ___/  ___|_   _|/ _ \ 
::: | |  | | | | | |_    | |    ______  / /_\ \| .  . ||  \| || |__ \ `--.  | | / /_\ \
::: | |/\| | | | |  _|   | |   |______| |  _  || |\/| || . ` ||  __| `--. \ | | |  _  |
::: \  /\  /_| |_| |    _| |_           | | | || |  | || |\  || |___/\__/ /_| |_| | | |
:::  \/  \/ \___/\_|    \___/           \_| |_/\_|  |_/\_| \_/\____/\____/ \___/\_| |_/
::: Developed by Noa Second - www.noasecond.com

for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A
setlocal enabledelayedexpansion
echo.

:: Cleaning temporary files
echo Cleaning temporary files...
del profiles_Amnesia.tmp >nul 2>&1
del profile_info.tmp >nul 2>&1
del SSID_Amnesia.tmp >nul 2>&1

:: Listing Wi-Fi profiles
echo Listing Wi-Fi profiles...
netsh wlan show profiles > profiles_Amnesia.tmp

:: Extracting SSID names
echo Extracting SSID names...
set i=0
del SSID_Amnesia.tmp >nul 2>&1
for /f "tokens=1,* delims=:" %%A in ('findstr /C:"Profil Tous les utilisateurs" profiles_Amnesia.tmp') do (
    set "ssid=%%B"
    set "ssid=!ssid:~1!"
    set /a i+=1
    echo !i!.!ssid!>>SSID_Amnesia.tmp
    set "ssid[!i!]=!ssid!"
)

:: Choose between [0] quit or [1] continue or [2] extract all passwords in a file [3] extract all infos for each profile
:step2_5
echo.
echo ========== Choose an option:
echo [0] Quit
echo [1] Display password for a specific profile
echo [2] Extract all passwords to a file
echo [3] Extract all infos for each profile
set /p "option=Select an option (0-3): "
if "%option%"=="0" (
    echo.
    goto :step6
) else if "%option%"=="2" (
    echo Extracting all passwords to All_Passwords.txt...
    echo. > All_Passwords.txt
    for /f "tokens=1* delims=." %%A in (SSID_Amnesia.tmp) do (
        netsh wlan show profile name="%%B" key=clear | findstr /C:"Nom du SSID" /C:"Contenu de la" >> All_Passwords.txt
        echo. >> All_Passwords.txt
    )
    echo Done! Check All_Passwords.txt for the results.
    echo.
    goto step2_5
) else if "%option%"=="3" (
    echo Extracting all profile information to All_Infos.txt...
    echo. > All_Infos.txt
    for /f "tokens=1* delims=." %%A in (SSID_Amnesia.tmp) do (
        netsh wlan show profile name="%%B" key=clear >> All_Infos.txt
        echo. >> All_Infos.txt
    )
    echo Done. Check All_Infos.txt for the results.
    goto step2_5
) else if "%option%" NEQ "1" (
    echo Invalid option.
    echo.
    goto step2_5
)
echo.

:: Display available profiles
echo ========== Available Wi-Fi profiles:
for /f "tokens=1* delims=." %%A in (SSID_Amnesia.tmp) do (
    echo [%%A] - %%B
)
echo.

:: User input for profile selection
:step4
echo ========== Please select a Wi-Fi profile to display its information:
set /p "choice=Select a number (1-%i%): "
set "profile=!ssid[%choice%]!"

if not defined profile (
    echo Invalid choice.
    echo.
    goto :step4
)
echo.

:: Display profile information
echo ========== Information for profile "!profile!":
netsh wlan show profile name="!profile!" key=clear | findstr /C:"Nom du SSID" /C:"Contenu de la" > profile_info.tmp

:: Check if password is found. If not, display a message.
findstr /C:"Contenu de la" profile_info.tmp >nul
if errorlevel 1 (
    echo No password found for this profile.
    echo.
    goto :step4
) else (
    type profile_info.tmp
    echo.
    goto step2_5
)

del profile_info.tmp >nul 2>&1
echo.

:: Cleaning temporary files
:step6
echo Cleaning temporary files...
del profiles_Amnesia.tmp >nul 2>&1
del profile_info.tmp >nul 2>&1
del SSID_Amnesia.tmp >nul 2>&1
echo Quitting...
timeout /t 1 >nul
exit /b 0
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

:: [Step 0] Cleaning temporary files
echo [Step 0/6] Cleaning temporary files...
del profiles_Amnesia.tmp >nul 2>&1
del SSID_Amnesia.tmp >nul 2>&1
echo.

:: [Step 1] Listing Wi-Fi profiles
echo [Step 1/6] Listing Wi-Fi profiles...
netsh wlan show profiles > profiles_Amnesia.tmp
echo.

:: [Step 2] Extracting SSID names
echo [Step 2/6] Extracting SSID names...
set i=0
del SSID_Amnesia.tmp >nul 2>&1

for /f "tokens=1,* delims=:" %%A in ('findstr /C:"Profil Tous les utilisateurs" profiles_Amnesia.tmp') do (
    set "ssid=%%B"
    set "ssid=!ssid:~1!"
    set /a i+=1
    echo !i!.!ssid!>>SSID_Amnesia.tmp
    set "ssid[!i!]=!ssid!"
)
echo.

:: [Step 3] Display available profiles
echo [Step 3/6] Available Wi-Fi profiles:
for /f "tokens=1* delims=." %%A in (SSID_Amnesia.tmp) do (
    echo [%%A] - %%B
)
echo.

:: [Step 4] User input for profile selection
:step4
echo [Step 4/6] Please select a Wi-Fi profile to display its information:
set /p "choice=Select a number (1-%i%): "
set "profile=!ssid[%choice%]!"

if not defined profile (
    echo Invalid choice.
    echo.
    goto :step4
)
echo.

:: [Step 5] Display profile information
echo [Step 5/6] Information for profile "!profile!":
netsh wlan show profile name="!profile!" key=clear | findstr /C:"Nom du SSID" /C:"Contenu de la"
echo.

:: [Step 6] Cleaning temporary files
echo [Step 6/6] Cleaning temporary files...
del profiles_Amnesia.tmp >nul 2>&1
del SSID_Amnesia.tmp >nul 2>&1

pause
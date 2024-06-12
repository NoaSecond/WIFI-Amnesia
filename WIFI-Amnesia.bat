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


:: Listing wifi profiles
echo [Step 1/5] Listing wifi profiles...
netsh wlan show profiles >> 0amnesia.txt

:: For each wifi profile, we display the information
echo [Step 2/5] Getting wifi profiles information...
for /f "skip=9 tokens=1,2 delims=:" %%i in ('netsh wlan show profiles') do (
    netsh wlan show profile %%j key=clear >> 1amnesia.txt
)

:: Clean and keep lines that contain " : " and put them in 2amnesia.txt
echo [Step 3/5] Cleaning wifi profiles information...
for /f "delims=" %%k in ('findstr /c:" : " 1amnesia.txt') do (
    echo %%k >> 2amnesia.txt
)

:: Read the first line of 2amnesia.txt and save it in the variable firstLine
set "firstLine="
for /f "delims=" %%a in (2amnesia.txt) do (
    set "firstLine=%%a"
    goto :doneReadingFirstLine
)
:doneReadingFirstLine

:: Read 2amnesia.txt, and each time we find a line equal to the variable firstLine, we add a line "==================================" to separate the profiles and save it in 3amnesia.txt
setlocal enabledelayedexpansion
for /f "delims=" %%a in (2amnesia.txt) do (
    if %%a==!firstLine! (
        echo ================================== >> 3amnesia.txt
    ) else (
        echo %%a >> 3amnesia.txt
    )
)

:: Read 3amnesia.txt and put in 4amnesia.txt the lines 5 and 10 after each "=================================="
echo [Step 4/5] Displaying wifi profiles information...
set lineCount=0
set profileCount=0
for /f "delims=" %%b in (3amnesia.txt) do (
    if %%b==================================== (
        set /a profileCount+=1
        set lineCount=0
    ) else (
        set /a lineCount+=1
        if !lineCount! equ 5 (
            echo Profil !profileCount! : %%b
        ) 
        if !lineCount! equ 10 (
            echo Profil !profileCount! : %%b
        )
    )
)
endlocal

:: Cleaning temporary files
echo [Step 5/5] Cleaning temporary files...
del 0amnesia.txt
del 1amnesia.txt
del 2amnesia.txt
del 3amnesia.txt

pause
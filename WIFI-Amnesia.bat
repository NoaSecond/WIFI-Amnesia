@echo off

:::  _    _ ___________ _____             ___  ___  ___ _   _  _____ _____ _____  ___  
::: | |  | |_   _|  ___|_   _|           / _ \ |  \/  || \ | ||  ___/  ___|_   _|/ _ \ 
::: | |  | | | | | |_    | |    ______  / /_\ \| .  . ||  \| || |__ \ `--.  | | / /_\ \
::: | |/\| | | | |  _|   | |   |______| |  _  || |\/| || . ` ||  __| `--. \ | | |  _  |
::: \  /\  /_| |_| |    _| |_           | | | || |  | || |\  || |___/\__/ /_| |_| | | |
:::  \/  \/ \___/\_|    \___/           \_| |_/\_|  |_/\_| \_/\____/\____/ \___/\_| |_/
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A



:: Liste les profils wifi
netsh wlan show profiles >> 0.txt

:: Pour chaque profil wifi, on affiche les informations
for /f "skip=9 tokens=1,2 delims=:" %%i in ('netsh wlan show profiles') do (
    netsh wlan show profile %%j key=clear >> 1.txt
)

:: On nettoie et on garde les lignes qui contiennent " : " et on les met dans 2.txt
for /f "delims=" %%k in ('findstr /c:" : " 1.txt') do (
    echo %%k >> 2.txt
)

:: On lit la première ligne de 2.txt et on l'enregistre dans la variable firstLine
set "firstLine="
for /f "delims=" %%a in (2.txt) do (
    set "firstLine=%%a"
    goto :doneReadingFirstLine
)
:doneReadingFirstLine

:: On lit 2.txt, et à chaque fois qu'on croise une ligne égale à la variable firstLine, on rajoute une ligne "==================================" pour séparer les profils puis on enregistre dans 3.txt
setlocal enabledelayedexpansion
for /f "delims=" %%a in (2.txt) do (
    if %%a==!firstLine! (
        echo ================================== >> 3.txt
    ) else (
        echo %%a >> 3.txt
    )
)

:: On lit 3.txt et on met dans 4.txt les lignes 5 et 10 après chaque "=================================="
:: ================== ISSUE : IL N'Y A QUE 1 PROFIL QUI EST AFFICHE ==================
:: ================== ISSUE : DANS 3.txt CERTAINS PROFILS N'ONT PAS DE MDP OU ALORS ON LES INFORMATIONS AUX MAUVAISES LIGNES ==================
setlocal enabledelayedexpansion
set lineCount=0
set profileCount=0
for /f "delims=" %%b in (3.txt) do (
    if %%b==================================== (
        set /a profileCount+=1
        set lineCount=0
    ) else (
        set /a lineCount+=1
        if !lineCount! equ 5 (
            echo Profil !profileCount! : %%b >> 4.txt
        ) 
        if !lineCount! equ 10 (
            echo Profil !profileCount! : %%b >> 4.txt
        )
    )
)

type 4.txt

:: Nettoyage des fichiers temporaires
@REM del 0.txt
@REM del 1.txt
@REM del 2.txt
@REM del 3.txt
@REM del 4.txt

pause
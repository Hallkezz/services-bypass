@echo off
setlocal EnableDelayedExpansion

if "%1"=="admin" (
    echo Started with admin rights
) else (
    echo Requesting admin rights...
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/c \"\"%~f0\" admin\"' -Verb RunAs"
    exit /b
)

set "HOSTS_FILE=C:\Windows\System32\drivers\etc\hosts"
set "HOSTS_BACKUP=C:\Windows\System32\drivers\etc\hosts_backup"
set "TEMP_FILE=%TEMP%\hosts_temp.txt"
set "HOSTS_TXT=%~dp0hosts.txt"

if not exist "%HOSTS_TXT%" (
    echo File hosts.txt not found
    pause
    exit /b
)

:: MENU ==============================
:main_menu
cls
echo ================================
echo 1. Add Entries
echo 2. Restore
echo 0. Exit
echo ================================
set /p choice=Enter choice (0-2): 

if "%choice%"=="1" goto add_entries
if "%choice%"=="2" goto restore_hosts
if "%choice%"=="0" exit /b
goto main_menu

:: ADD ==============================
:add_entries
echo Adding entries...

if not exist "%HOSTS_BACKUP%" (
    echo Creating backup...
    copy "%HOSTS_FILE%" "%HOSTS_BACKUP%" >nul
    echo Backup created: hosts_backup
) else (
    echo Backup already exists.
)

for /f "usebackq delims=" %%a in ("%HOSTS_TXT%") do (
    findstr /x /c:"%%a" "%HOSTS_FILE%" >nul || echo %%a>>"%HOSTS_FILE%"
)

echo Done. Entries added.
pause
goto main_menu

:: RESTORE ==============================
:restore_hosts
echo Restoring original hosts file...

if exist "%HOSTS_BACKUP%" (
    copy /y "%HOSTS_BACKUP%" "%HOSTS_FILE%" >nul
    del "%HOSTS_BACKUP%"
    echo Hosts file restored from backup.
) else (
    echo No backup found. Nothing to restore.
)

pause
goto main_menu
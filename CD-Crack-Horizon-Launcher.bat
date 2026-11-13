:: C.D. Crack Horizon Launcher Installer
@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

:: Made by Cremi Development | github.com/CremiDevelopment | 13.11.2026
set "USE_UA=0"
reg query "HKCU\Control Panel\International" /v "LocaleName" 2>nul | findstr /i "ru uk" >nul && set "USE_UA=1"
reg query "HKCU\Control Panel\Desktop" /v "PreferredUILanguages" 2>nul | findstr /i "ru uk" >nul && set "USE_UA=1"
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Nls\Language" /v "Default" 2>nul | findstr /i "0419 0422" >nul && set "USE_UA=1"

if "%USE_UA%"=="1" goto LANG_UA

:LANG_EN
set "MSG_TITLE=Installing C.D. Crack Horizon Launcher (v0.2.58)"
set "MSG_S1=[1/6] Setting global environment variable to block updates..."
set "MSG_S2=[2/6] Searching for launcher folder..."
set "MSG_REG_NF=Path in registry not found. Default path will be used:"
set "MSG_REG_F=Found folder in registry:"
set "MSG_S3=[3/6] Downloading version 0.2.58 from GitHub..."
set "MSG_DL_OK=Download completed successfully!"
set "MSG_DL_ERR=Download error:"
set "MSG_S4=[4/6] Configuring registry..."
set "MSG_S5=[5/6] Cleaning up old temporary files..."
set "MSG_S6=[6/6] Creating shortcut on Desktop..."
set "MSG_ERR_DL=[ERROR] Failed to download the file. Check your internet connection."
set "MSG_DONE1=DONE! C.D. Crack Horizon Launcher successfully installed,"
set "MSG_DONE2=version pinned to 0.2.58, and updates blocked."
set "MSG_DONE3=Desktop shortcut created: C.D. Crack Horizon Launcher"
set "MSG_AUTHOR=Author: Cremi Development | github.com/CremiDevelopment"
set "MSG_PAUSE=Press any key to exit..."
goto MAIN

:LANG_UA
set "MSG_TITLE=Встановлення C.D. Crack Horizon Launcher (v0.2.58)"
set "MSG_S1=[1/6] Встановлення глобальної змінної для блокування оновлень..."
set "MSG_S2=[2/6] Пошук папки лаунчера..."
set "MSG_REG_NF=Шлях у реєстрі не знайдено. Буде використано стандартний:"
set "MSG_REG_F=Знайдено папку в реєстрі:"
set "MSG_S3=[3/6] Завантаження версії 0.2.58 з GitHub..."
set "MSG_DL_OK=Завантаження успішно завершено!"
set "MSG_DL_ERR=Помилка завантаження:"
set "MSG_S4=[4/6] Налаштування реєстру..."
set "MSG_S5=[5/6] Очищення старих тимчасових файлів..."
set "MSG_S6=[6/6] Створення ярлика на Робочому столі..."
set "MSG_ERR_DL=[ПОМИЛКА] Не вдалося завантажити файл. Перевірте підключення до інтернету."
set "MSG_DONE1=ГОТОВО! C.D. Crack Horizon Launcher успішно встановлено,"
set "MSG_DONE2=версія зафіксована на 0.2.58, а оновлення заблоковано."
set "MSG_DONE3=На Робочому столі з'явився ярлик: C.D. Crack Horizon Launcher"
set "MSG_AUTHOR=Автор: Cremi Development | github.com/CremiDevelopment"
set "MSG_PAUSE=Натисніть будь-яку клавішу для виходу..."
goto MAIN

:MAIN
echo =======================================================
echo %MSG_TITLE%
echo =======================================================
echo.


echo %MSG_S1%
setx HORIZON_LAUNCHER_NO_SELF_UPDATE 1 >nul


echo %MSG_S2%
set "INSTALL_DIR="
for /f "tokens=2*" %%A in ('reg query "HKEY_CURRENT_USER\Software\Horizon\Launcher" /v "InstallDir" 2^>nul') do set "INSTALL_DIR=%%B"

if "%INSTALL_DIR%"=="" (
    set "INSTALL_DIR=%LOCALAPPDATA%\Programs\Horizon"
    echo %MSG_REG_NF% %INSTALL_DIR%
) else (
    echo %MSG_REG_F% %INSTALL_DIR%
)

echo %INSTALL_DIR% | findstr /i "\.exe" >nul
if not errorlevel 1 (
    for %%I in ("%INSTALL_DIR%") do set "INSTALL_DIR=%%~dpI"
)

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"


echo %MSG_S3%
set "DOWNLOAD_URL=https://github.com/CremiDevelopment/Horizon0.2.58Backup/releases/download/Launcher/horizon-launcher-0258.exe"
set "DEST_FILE=%INSTALL_DIR%\horizon-launcher.exe"

powershell -Command "try { Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%DEST_FILE%' -ErrorAction Stop; Write-Host '%MSG_DL_OK%' -ForegroundColor Green } catch { Write-Host '%MSG_DL_ERR% $_' -ForegroundColor Red; exit 1 }"

if errorlevel 1 (
    echo %MSG_ERR_DL%
    pause
    exit /b
)


echo %MSG_S4%
reg add "HKEY_CURRENT_USER\Software\Horizon\Launcher" /v "Version" /t REG_SZ /d "0.2.58" /f >nul
reg add "HKEY_CURRENT_USER\Software\Horizon\Launcher" /v "InstallDir" /t REG_SZ /d "%DEST_FILE%" /f >nul


echo %MSG_S5%
if exist "%INSTALL_DIR%\*.tmp" del /q /f "%INSTALL_DIR%\*.tmp"
if exist "%INSTALL_DIR%\*.part" del /q /f "%INSTALL_DIR%\*.part"
if exist "%INSTALL_DIR%\updates" rd /s /q "%INSTALL_DIR%\updates"


echo %MSG_S6%
powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut([System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop) + '\C.D. Crack Horizon Launcher.lnk'); $Shortcut.TargetPath = '%DEST_FILE%'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.Save()"

echo.
echo =======================================================
echo %MSG_DONE1%
echo %MSG_DONE2%
echo %MSG_DONE3%
echo.
echo !MSG_AUTHOR!
echo =======================================================
echo.
echo %MSG_PAUSE%
pause >nul
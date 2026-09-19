@echo off
chcp 65001 >nul
title Estalingrado Corp Netrunner Console - Instalador

:: Colores
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "GREEN=%ESC%[92m"
set "YELLOW=%ESC%[93m"
set "RED=%ESC%[91m"
set "CYAN=%ESC%[96m"
set "MAGENTA=%ESC%[95m"
set "RESET=%ESC%[0m"

echo %CYAN%
echo ╔═══════════════════════════════════════════════════════════════════╗
echo ║   ████████  ██████████      Estalingrado Corp                      ║
echo ║   ██        ██              Netrunner Console Installer            ║
echo ║   ███████   ██      ®                                                ║
echo ║   ██        ██              v1.36.0-fork                           ║
echo ║   ████████  ██████████                                              ║
echo ╚══════════════════════════════════════════════════════════════════╝
echo %RESET%

set "SCRIPT_DIR=%~dp0"
set "ASI_SOURCE=%SCRIPT_DIR%estalingrado_corp_netrunner_console.asi"

if not exist "%ASI_SOURCE%" (
    echo %RED%Error: No se encuentra estalingrado_corp_netrunner_console.asi%RESET%
    echo Debe estar en la misma carpeta que este instalador.
    pause
    exit /b 1
)

echo %GREEN%Archivo del mod encontrado:%RESET% %ASI_SOURCE%
echo.

:: Buscar instalaciones comunes
set "FOUND=0"
set "GAME_PATH="

echo Buscando instalaciones de Cyberpunk 2077...

:: Steam default
if exist "C:\Program Files (x86)\Steam\steamapps\common\Cyberpunk 2077\bin\x64\Cyberpunk2077.exe" (
    set "GAME_PATH=C:\Program Files (x86)\Steam\steamapps\common\Cyberpunk 2077"
    set "FOUND=1"
    echo %GREEN%[1] Steam (default): %GAME_PATH%%RESET%
)

:: GOG
if exist "C:\Program Files (x86)\GOG Galaxy\Games\Cyberpunk 2077\bin\x64\Cyberpunk2077.exe" (
    set "GAME_PATH=C:\Program Files (x86)\GOG Galaxy\Games\Cyberpunk 2077"
    set "FOUND=1"
    echo %GREEN%[2] GOG Galaxy: %GAME_PATH%%RESET%
)

:: Epic
if exist "C:\Program Files\Epic Games\Cyberpunk2077\bin\x64\Cyberpunk2077.exe" (
    set "GAME_PATH=C:\Program Files\Epic Games\Cyberpunk2077"
    set "FOUND=1"
    echo %GREEN%[3] Epic Games: %GAME_PATH%%RESET%
)

:: Custom common paths
for %%d in (C D E F) do (
    if exist "%%d:\Games\Cyberpunk 2077\bin\x64\Cyberpunk2077.exe" (
        set "GAME_PATH=%%d:\Games\Cyberpunk 2077"
        set "FOUND=1"
        echo %GREEN%[Custom] %%d:\Games\Cyberpunk 2077%RESET%
    )
)

if %FOUND%==0 (
    echo %RED%No se encontro Cyberpunk 2077 automaticamente.%RESET%
    set /p "GAME_PATH=Introduce la ruta completa de instalacion (ej: C:\Games\Cyberpunk 2077): "
    if not exist "%GAME_PATH%\bin\x64\Cyberpunk2077.exe" (
        echo %RED%Ruta invalida o Cyberpunk no instalado ahi.%RESET%
        pause
        exit /b 1
    )
) else (
    echo.
    echo %YELLOW%Se usara: %GAME_PATH%%RESET%
    echo.
    set /p "CONFIRM=¿Continuar con esta ubicacion? (s/n): "
    if /i not "%CONFIRM%"=="s" (
        set /p "GAME_PATH=Introduce la ruta correcta: "
        if not exist "%GAME_PATH%\bin\x64\Cyberpunk2077.exe" (
            echo %RED%Ruta invalida.%RESET%
            pause
            exit /b 1
        )
    )
)

set "PLUGINS_DIR=%GAME_PATH%\bin\x64\plugins"
set "TARGET_ASI=%PLUGINS_DIR%\estalingrado_corp_netrunner_console.asi"
set "OLD_ASI=%PLUGINS_DIR%\cyber_engine_tweaks.asi"
set "BACKUP_ASI=%PLUGINS_DIR%\cyber_engine_tweaks.asi.backup"

if not exist "%PLUGINS_DIR%" (
    echo %YELLOW%Creando carpeta plugins...%RESET%
    mkdir "%PLUGINS_DIR%" 2>nul
)

if exist "%OLD_ASI%" if not exist "%BACKUP_ASI%" (
    echo %YELLOW%Respaldando cyber_engine_tweaks.asi original...%RESET%
    copy "%OLD_ASI%" "%BACKUP_ASI%" >nul
)

echo %GREEN%Instalando estalingrado_corp_netrunner_console.asi...%RESET%
copy /y "%ASI_SOURCE%" "%TARGET_ASI%" >nul

if exist "%TARGET_ASI%" (
    echo %GREEN%¡Instalacion completada!%RESET%
    echo.
    echo %CYAN%━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%RESET%
    echo Instalado en: %TARGET_ASI%
    echo.
    echo Para jugar:
    echo  1. Inicia Cyberpunk 2077
    echo  2. Presiona la tecla '<' para abrir la consola
    echo  3. Escribe 'help' para ver comandos
    echo.
    echo Links:
    echo   Web: https://estalingradocorp.qzz.io/
    echo   Telegram: https://t.me/estalingradocorp
    echo %CYAN%━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%RESET%
) else (
    echo %RED%Error copiando el archivo.%RESET%
)

pause
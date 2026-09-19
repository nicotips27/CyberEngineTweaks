<# 
.SYNOPSIS
    Estalingrado Corp Netrunner Console - Installer
.DESCRIPTION
    Instala el mod Estalingrado Corp Netrunner Console para Cyberpunk 2077.
    Detecta automáticamente la instalación (Steam/GOG/Epic) y copia el archivo .asi.
.NOTES
    Autor: Estalingrado Corp
    Web: https://estalingradocorp.qzz.io/
    Telegram: https://t.me/estalingradocorp
#>

param(
    [string]$InstallPath = "",
    [switch]$Force,
    [switch]$Uninstall,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

# Colores para output
$Colors = @{
    Green   = [ConsoleColor]::Green
    Yellow  = [ConsoleColor]::Yellow
    Red     = [ConsoleColor]::Red
    Cyan    = [ConsoleColor]::Cyan
    Magenta = [ConsoleColor]::Magenta
    White   = [ConsoleColor]::White
}

function Write-Color([string]$Message, [ConsoleColor]$Color = "White") {
    $original = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = $Color
    Write-Host $Message
    $Host.UI.RawUI.ForegroundColor = $original
}

function Write-Banner {
    Write-Color @"
╔═══════════════════════════════════════════════════════════════════╗
║  ████████  ██████████      Estalingrado Corp                      ║
║  ██        ██              Netrunner Console Installer             ║
║  ███████   ██      ®                                                ║
║  ██        ██              v1.36.0-fork                            ║
║  ████████  ██████████                                              ║
╚═══════════════════════════════════════════════════════════════════╝
"@ -Color Cyan
}

function Find-CyberpunkInstall {
    $paths = @()
    
    # Steam (default)
    $steamPath = "${env:ProgramFiles(x86)}\Steam\steamapps\common\Cyberpunk 2077"
    if (Test-Path $steamPath) { $paths += @{ Name = "Steam"; Path = $steamPath } }
    
    # Steam (custom library) - check all steam library folders
    $steamConfig = "${env:ProgramFiles(x86)}\Steam\steamapps\libraryfolders.vdf"
    if (Test-Path $steamConfig) {
        $content = Get-Content $steamConfig -Raw
        $matches = [regex]::Matches($content, '"path"\s+"(.+?)"')
        foreach ($match in $matches) {
            $libPath = $match.Groups[1].Value -replace '\\\\', '\'
            $cpPath = Join-Path $libPath "steamapps\common\Cyberpunk 2077"
            if (Test-Path $cpPath) { $paths += @{ Name = "Steam (Library)"; Path = $cpPath } }
        }
    }
    
    # GOG Galaxy
    $gogPath = "${env:ProgramFiles(x86)}\GOG Galaxy\Games\Cyberpunk 2077"
    if (Test-Path $gogPath) { $paths += @{ Name = "GOG Galaxy"; Path = $gogPath } }
    
    # Epic Games
    $epicPath = "${env:ProgramFiles}\Epic Games\Cyberpunk2077"
    if (Test-Path $epicPath) { $paths += @{ Name = "Epic Games"; Path = $epicPath } }
    
    # Epic Games (alternative)
    $epicPath2 = "${env:ProgramFiles(x86)}\Epic Games\Cyberpunk2077"
    if (Test-Path $epicPath2) { $paths += @{ Name = "Epic Games (x86)"; Path = $epicPath2 } }
    
    # Custom paths from registry (GOG)
    try {
        $gogReg = Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\GOG.com\Games\1444634739" -ErrorAction SilentlyContinue
        if ($gogReg -and $gogReg.Path) {
            $gogCustom = Join-Path $gogReg.Path "Cyberpunk 2077"
            if (Test-Path $gogCustom) { $paths += @{ Name = "GOG (Registry)"; Path = $gogCustom } }
        }
    } catch {}
    
    # Also check common custom locations
    $customPaths = @(
        "C:\Games\Cyberpunk 2077",
        "D:\Games\Cyberpunk 2077",
        "E:\Games\Cyberpunk 2077",
        "F:\Games\Cyberpunk 2077"
    )
    foreach ($custom in $customPaths) {
        if (Test-Path $custom) { $paths += @{ Name = "Custom"; Path = $custom } }
    }
    
    return $paths | Select-Object -Unique -Property Path, Name
}

function Select-InstallPath {
    $installs = Find-CyberpunkInstall
    
    if ($installs.Count -eq 0) {
        Write-Color "No se encontró Cyberpunk 2077 instalado automáticamente." -Color Red
        Write-Host "Por favor, introduce la ruta manualmente (ej: C:\Games\Cyberpunk 2077):"
        $manual = Read-Host "Ruta de instalación"
        if (Test-Path $manual) {
            return $manual
        } else {
            Write-Color "La ruta no existe." -Color Red
            exit 1
        }
    }
    
    if ($installs.Count -eq 1) {
        Write-Color "Encontrado: $($installs[0].Name) en $($installs[0].Path)" -Color Green
        return $installs[0].Path
    }
    
    Write-Color "Se encontraron múltiples instalaciones:" -Color Yellow
    for ($i = 0; $i -lt $installs.Count; $i++) {
        Write-Host "  [$($i + 1)] $($installs[$i].Name) - $($installs[$i].Path)"
    }
    Write-Host "  [0] Introducir ruta manualmente"
    
    $choice = Read-Host "Selecciona una opción (1-$($installs.Count) o 0)"
    if ($choice -eq "0") {
        Write-Host "Introduce la ruta completa:"
        $manual = Read-Host "Ruta"
        if (Test-Path $manual) { return $manual }
        Write-Color "Ruta inválida." -Color Red
        exit 1
    }
    
    $idx = [int]$choice - 1
    if ($idx -ge 0 -and $idx -lt $installs.Count) {
        return $installs[$idx].Path
    }
    
    Write-Color "Opción inválida." -Color Red
    exit 1
}

function Install-Mod {
    param(
        [string]$GamePath,
        [string]$AsiSource,
        [switch]$Force
    )
    
    $pluginsDir = Join-Path $GamePath "bin\x64\plugins"
    $targetAsi = Join-Path $pluginsDir "estalingrado_corp_netrunner_console.asi"
    $oldAsi = Join-Path $pluginsDir "cyber_engine_tweaks.asi"
    $backupAsi = Join-Path $pluginsDir "cyber_engine_tweaks.asi.backup"
    
    if (-not (Test-Path $pluginsDir)) {
        Write-Color "Creando directorio plugins: $pluginsDir" -Color Yellow
        if (-not $DryRun) { New-Item -ItemType Directory -Path $pluginsDir -Force | Out-Null }
    }
    
    # Backup old CET if exists
    if (Test-Path $oldAsi -and -not (Test-Path $backupAsi)) {
        Write-Color "Respaldando cyber_engine_tweaks.asi existente..." -Color Yellow
        if (-not $DryRun) { Copy-Item $oldAsi $backupAsi -Force }
    }
    
    # Check if target exists
    if (Test-Path $targetAsi -and -not $Force) {
        Write-Color "El mod ya está instalado. Usa -Force para sobrescribir." -Color Yellow
        return
    }
    
    # Copy new ASI
    Write-Color "Instalando estalingrado_corp_netrunner_console.asi..." -Color Green
    if (-not $DryRun) {
        Copy-Item $AsiSource $targetAsi -Force
        Write-Color "¡Instalación completada!" -Color Green
    } else {
        Write-Color "[DryRun] Se copiaría: $AsiSource → $targetAsi" -Color Cyan
    }
    
    # Verify
    if (Test-Path $targetAsi) {
        $size = (Get-Item $targetAsi).Length
        Write-Color "Verificado: $targetAsi ($([math]::Round($size/1MB, 2)) MB)" -Color Green
    }
}

function Uninstall-Mod {
    param([string]$GamePath)
    
    $pluginsDir = Join-Path $GamePath "bin\x64\plugins"
    $targetAsi = Join-Path $pluginsDir "estalingrado_corp_netrunner_console.asi"
    $backupAsi = Join-Path $pluginsDir "cyber_engine_tweaks.asi.backup"
    $oldAsi = Join-Path $pluginsDir "cyber_engine_tweaks.asi"
    
    if (Test-Path $targetAsi) {
        Write-Color "Eliminando estalingrado_corp_netrunner_console.asi..." -Color Yellow
        if (-not $DryRun) { Remove-Item $targetAsi -Force }
    }
    
    # Offer to restore backup
    if (Test-Path $backupAsi -and -not (Test-Path $oldAsi)) {
        Write-Host "¿Restaurar cyber_engine_tweaks.asi original desde backup? (s/n)"
        if ((Read-Host).ToLower() -eq 's') {
            Write-Color "Restaurando backup..." -Color Green
            if (-not $DryRun) { Move-Item $backupAsi $oldAsi -Force }
        }
    }
    
    Write-Color "Desinstalación completada." -Color Green
}

# ========== MAIN ==========
Write-Banner

# Resolve script directory
$scriptDir = Split-Path $MyInvocation.MyCommand.Definition -Parent
$asiSource = Join-Path $scriptDir "estalingrado_corp_netrunner_console.asi"

if (-not (Test-Path $asiSource)) {
    Write-Color "No se encuentra estalingrado_corp_netrunner_console.asi junto al instalador." -Color Red
    Write-Host "Asegúrate de tener el archivo .asi en la misma carpeta que este script."
    exit 1
}

Write-Color "Archivo del mod encontrado: $asiSource" -Color Green

# Determine game path
if ($InstallPath) {
    if (-not (Test-Path $InstallPath)) {
        Write-Color "La ruta especificada no existe: $InstallPath" -Color Red
        exit 1
    }
    $gamePath = $InstallPath
} else {
    $gamePath = Select-InstallPath
}

Write-Color "Juego detectado en: $gamePath" -Color Cyan

# Verify it's Cyberpunk
$exePath = Join-Path $gamePath "bin\x64\Cyberpunk2077.exe"
if (-not (Test-Path $exePath)) {
    Write-Color "No parece una instalación válida de Cyberpunk 2077 (no se encuentra Cyberpunk2077.exe)." -Color Red
    exit 1
}

if ($Uninstall) {
    Uninstall-Mod -GamePath $gamePath
} else {
    Install-Mod -GamePath $gamePath -AsiSource $asiSource -Force:$Force
}

Write-Color @"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Instalación finalizada. 

Para jugar:
1. Inicia Cyberpunk 2077
2. Presiona la tecla '<' (menor que) para abrir la consola
3. Escribe 'help' para ver comandos disponibles

Links:
  Web: https://estalingradocorp.qzz.io/
  Telegram: https://t.me/estalingradocorp
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"@ -Color Magenta

if ($DryRun) {
    Write-Color "[MODO SIMULACIÓN - No se hicieron cambios reales]" -Color Yellow
}
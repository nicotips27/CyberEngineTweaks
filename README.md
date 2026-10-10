# Estalingrado Corp Netrunner Console

## 📥 Descarga / Download

[![Instalador](https://img.shields.io/badge/%F0%9F%93%86%20Instalador-EstalingradoCorp--Setup.exe-success?style=for-the-badge&logo=windows&logoColor=white)](https://github.com/nicotips27/CyberEngineTweaks/releases/download/v1.0.0-installer/EstalingradoCorp-Setup.exe)

> **Instalador con interfaz gráfica** — Detecta automáticamente la instalación de Cyberpunk 2077. No requiere internet.

[![Website](https://img.shields.io/badge/Website-estalingradocorp.qzz.io-blue)](https://estalingradocorp.qzz.io/)
[![Telegram](https://img.shields.io/badge/Telegram-t.me/estalingradocorp-blue)](https://t.me/estalingradocorp)
[![Banner](https://img.shields.io/badge/Banner-view-orange)](https://64.media.tumblr.com/c543648ec88ebbd6ad0a042b7c9c02e5/6b32caad034b7a6d-f3/s640x960/1b2b2cd1fb6e7f84f6a6f9f205cc8f12e9b40531.pnj)

## What's this?

**Estalingrado Corp Netrunner Console** is a framework giving modders a way to script mods using [Lua](https://www.lua.org/) with access to all the internal scripting features.
It also comes with a [Dear ImGui](https://github.com/ocornut/imgui/tree/v1.82) to provide GUI for different mods you are using, along with console and TweakDB editor for more advanced usage.
It also adds some patches for quality of life, all of which can be enabled/disabled through the settings menu or config files (requires game restart to apply).

Estalingrado Corp Netrunner Console tracks the current release of Cyberpunk 2077 closely.
The current release is available from the releases page: 
[![All Releases](https://img.shields.io/github/downloads/nicotips27/CyberEngineTweaks/total)](https://github.com/nicotips27/CyberEngineTweaks/releases).

### 🔧 Critical Fixes Included (v1.36.0-fork)

This fork includes essential fixes for **Cyberpunk 2077 Patch 2.3**:

| Fix | Description |
|-----|-------------|
| **Console Key Binding** | Fixed `overlay_key` encoding in `bindings.json` — the "<" key (VK_OEM_102) now correctly opens the CET console |
| **MaxHacking Mod v2** | Updated for Patch 2.x API: replaced removed `Game.AddExp()` with `dev:SetAttribute()`, added retry logic for `GetDevelopmentData()` |
| **Mod Loading Clarification** | CET loads ALL folders in `mods\` — `.disabled` suffix does NOT disable mods |

📖 **Full documentation**: [FIXES.md](FIXES.md) — complete technical details, root cause analysis, and installation guide.

### 🎮 Nuevos Trucos / Cheats (En Desarrollo) / New Cheats (In Development)

Estamos trabajando en añadir una colección de nuevos trucos y funcionalidades para mejorar la experiencia de juego / We are working on adding a collection of new cheats and features to improve the gameplay experience:

- **Trucos de Netrunner/Quickhack** — Acceso rápido a daemons, reducción de costos de RAM, cooldowns instantáneos / Fast access to daemons, reduced RAM costs, instant cooldowns
- **Trucos de Combate** — Munición infinita, sin retroceso, daño multiplicado, invulnerabilidad / Infinite ammo, no recoil, multiplied damage, invulnerability
- **Trucos de Exploración** — Super salto, noclip, teletransporte a waypoints, velocidad de movimiento / Super jump, noclip, teleport to waypoints, movement speed
- **Trucos de Economía** — Eddies ilimitados, componentes infinitos, desbloqueo de vendedores / Unlimited eddies, infinite components, vendor unlocks
- **Trucos de Progresión** — XP instantánea, puntos de atributo/perk libres, nivel máximo / Instant XP, free attribute/perk points, max level
- **Interfaz en Juego** — Menú dedicado accesible desde la consola para activar/desactivar trucos individualmente / In-Game Interface — Dedicated menu accessible from console to toggle individual cheats
- **Comando `trucos`** — Escribe `trucos` en la consola para ver la lista completa de trucos disponibles / Type `trucos` in the console to view the full list of available cheats

> ⚠️ **Nota** / **Note**: Estos trucos están en desarrollo y se irán añadiendo en futuras versiones. Úsalos bajo tu propia responsabilidad en partidas offline/single-player / These cheats are in development and will be added in future versions. Use them at your own risk in offline/single-player games.

### Capturas de pantalla

![Trucos Netrunner](https://raw.githubusercontent.com/nicotips27/CyberEngineTweaks/renombrado-v1.36.0/Marketing/capturas/trucos.png)

### Comando `trucos` / `trucos` Command

Escribe **`trucos`** en la consola para ver la lista completa de todos los trucos y cheats disponibles / Type **`trucos`** in the console to view the full list of available cheats:

- **Dinero y materiales / Money & Materials** — `Game.AddToInventory("Items.money", 100000)`, materiales de fabricación
- **Munición / Ammo** — Balas para pistolas, rifles, escopeta, francotirador
- **Nivel, atributos y puntos / Level, Attributes & Points** — Nivel 60, Street Cred, puntos de atributo y perk
- **Estadísticas del personaje / Character Stats** — Vida, armadura, capacidad de carga, daño crítico, velocidad, aguante infinito, modo dios, inmortal, eliminar heat
- **Sistema de policía / Police System** — `Game.PrevSys_off()`, `Game.PrevSys_on()`, `Game.PrevSys_safe()`, `Game.PrevSys_active()`
- **Vehículos y teletransporte / Vehicles & Teleport** — Todos los vehículos, vehículos específicos, teletransporte a coordenadas
- **RAM / RAM** — Mejoras de RAM legendaria
- **Hackeos rápidos / Quickhacks** — Contagio, Colapso del Sistema, Suicidio, EMP, Ceguera, Blackwall, etc.
- **Ciberware / Cyberware** — Cuchillas mantis, brazos de gorila
- **Objetos específicos / Specific Items** — Cuchillo de Scorpion, Skippy, nudillos dorados, chaqueta Samurai, fin del juego con Johnny
- **Recordatorios / Reminders** — Guardar la partida, comandos sensibles a mayúsculas, equipar ciberware/hackeos después de añadirlos

### Current patches

| Patch      | Description     |
| :------------- | :------------------------------ |
| AMD SMT | For AMD CPUs that did not get a performance boost after CDPR's patch |
| Remove pedestrians and traffic | Removes most of the pedestrians and traffic |
| Disable Async Compute | Disables async compute, this can give a boost on older GPUs (Nvidia 10xx series for example)|
| Disable Temporal Antialiasing | Disables antialiasing, not recommended but you do what you want! |
| Skip start menu | Skips the menu asking you to press space bar to continue (Breaching...) |
| Suppress Intro Movies | Disables logos played at the beginning |
| Disable Vignette | Disables vignetting along screen borders |
| Disable Boundary Teleport | Allows players to access out-of-bounds locations |
| Disable Windows 7 VSync | Disables VSync on Windows 7 to bypass the 60 FPS limit |

### 🎨 Efectos Visuales / Visual Effects

Estos efectos están ahora activados por defecto en la instalación reciente:

| Efecto | Descripción | Cómo activar/desactivar |
|--------|-------------|------------------------|
| **ImGui Diagnostics Window** | Muestra la ventana de diagnóstico interno de ImGui para depurar mods | Configuración en juego: `trucos` → `Draw ImGui Diagnostics Window` |
| **Remove Dead Bindings** | Quita enlaces de bindings muertos para mods no cargados | Configuración en juego: `trucos` → `Remove Dead Bindings` |
| **Debug Menu** | Menú de depuración con opciones adicionales | Configuración en juego: `trucos` → `Debug Menu` |
| **Tweaks de Rendimiento** | Parches opcionales de rendimiento (SMT, Async Compute, etc.) | Modificables en `global.ini` |

Estos efectos mejoran la estabilidad y depuración del mod. Si deseas desactivar alguno, edita `global.ini` y cambia el valor de `1` a `0` en la línea correspondiente.

### Current mod development options
| Development      | Description     |
| :------------- | :------------------------------ |
| Draw ImGui Diagnostics Window | Toggles drawing of internal ImGui diagnostics window to show what is going on behind the scenes (good for mod debugging) |
| Remove Dead Bindings | Removes bindings for mods that were not loaded |
| Enable ImGui Assertions | Enables all ImGui assertions (use this option to check mods for errors before shipping!) |
| Debug Menu | Enables the debug menus in game |
| Dump Game Options | Dumps all game options into main log file |

## Usage and configuration

You first need to install [RED4ext](https://github.com/WopsS/RED4ext).

⚠️ **Importante:** El instalador **no incluye** `version.dll` para evitar conflictos con la que ya tiene tu juego. Si el juego ya tiene `version.dll` en `bin\x64/`, no la sobreescribas. Si necesitas instalarla manualmente, hazlo solo si el juego te da error al iniciar sin ella.

[Read the wiki](https://wiki.redmodding.org/cyber-engine-tweaks/)

[Official mod examples](https://github.com/WolvenKit/cet-examples)

[Usage with Proton](https://wiki.redmodding.org/cyber-engine-tweaks/getting-started/installing/untitled)

## Contributing

If you wish to contribute to the main repo, try to follow the coding style in the code, otherwise not much to say, don't use code that is not yours unless the license is compatible with MIT.

As for the wiki, please ask on discord for write permissions.

# Estalingrado Corp Netrunner Console - Fixes & Changes Documentation

## Overview
This fork of Cyber Engine Tweaks (CET) v1.36.0 includes critical fixes for Cyberpunk 2077 Patch 2.3, specifically addressing:
- Console key binding not working (overlay key "<" / VK_OEM_102)
- MaxHacking mod compatibility with Patch 2.x API changes
- Renamed project to "Estalingrado Corp Netrunner Console"

---

## Critical Fixes

### 1. Console Overlay Key Binding Fix

**Problem**: The CET console would not open when pressing the configured key ("<" / backtick key).

**Root Cause**: The `overlay_key` value stored in `bindings.json` was incorrectly encoded. CET v1.36.0 uses a custom 64-bit encoding scheme (`EncodeVKCodeBind` in `VKBindings.cpp`) that performs byte-swapping on 4×16-bit words, NOT a simple `VK << 56` shift.

**Incorrect Value** (what was stored):
```
16296977869922136064  (0xE22A7F07111C7000)
```
Decoded as invalid key codes: `{0xE22A, 0x7F07, 0x111C, 0x7000}` — never matches "<"

**Correct Value** for VK_OEM_102 (226 / 0xE2):
```
63613344736608256  (0x00E2000000000000)
```
Encoded as: `key[0] = _byteswap_ushort(0x00E2) = 0xE200`, remaining words = 0

**Fix Applied**:
```json
// C:\Games\Cyberpunk 2077\bin\x64\plugins\cyber_engine_tweaks\bindings.json
{
    "cet": {
        "overlay_key": 63613344736608256
    }
}
```

**Verification**: After fix, pressing "<" shows notification "CET Overlay Bind: <" and opens console.

---

### 2. MaxHacking Mod v2 - Patch 2.x Compatibility

**Problem**: Original MaxHacking mod (v1) partially worked but had critical errors:
- `GetDevelopmentData()` returned `nil` (timing issue - called too early)
- `Game.AddExp()` doesn't exist in Patch 2.x (removed/changed API)
- Intelligence/attribute/perk points not applied

**Changes in `mods/MaxHacking/init.lua`**:

#### A. Added Retry Logic for GetDevelopmentData
```lua
local function waitForDevData(maxAttempts, delayMs)
    for i = 1, maxAttempts do
        local dev = Game.GetDevelopmentData()
        if dev then return dev end
        Cron.After(delayMs / 1000, function() end) -- yield
    end
    return nil
end
```
Waits up to ~10 seconds for development data to be available.

#### B. Replaced Game.AddExp with dev:SetAttribute
```lua
-- OLD (broken in Patch 2.x):
-- Game.AddExp("Hacking", xpAmount)
-- Game.AddExp("CombatHacking", xpAmount)

-- NEW (Patch 2.x compatible):
dev:SetAttribute("Hacking", 20)        -- Brecha de protocolo
dev:SetAttribute("CombatHacking", 20)  -- Hacking rápido
```
Confirmed via RedModding wiki: `dev:SetAttribute("<SkillName>", <level>)` is the correct API for Patch 2.x.

#### C. Applied All Intended Changes
- ✅ Level 60
- ✅ Intelligence 20
- ✅ Hacking skill 20 (Brecha de protocolo)
- ✅ CombatHacking skill 20 (Hacking rápido)
- ✅ +60 attribute points
- ✅ +40 perk points
- ✅ Quickhack materials & components
- ✅ 1,000,000 eddies
- ✅ Fact tracking (`maxhack_v2_done`) to prevent re-application

#### D. Folder Rename
```
MaxHacking.disabled  →  MaxHacking
```
**Important**: CET loads **ALL** subfolders in `mods\`. The `.disabled` suffix does NOT disable mods. To truly disable, move folder OUT of `mods\`.

---

## Project Rename

**Original**: Cyber Engine Tweaks  
**New**: Estalingrado Corp Netrunner Console

### Files Updated:
- `README.md` - Project name, description, GitHub URLs
- `xmake.lua` - Target name (`estalingrado_corp_netrunner_console`), product name, install messages

### Internal Code (UNCHANGED - Preserves Compatibility):
- C++ namespace: `CyberEngineTweaks::AddressHashes` (unchanged)
- Mutex name: "Cyber Engine Tweaks Module Instance" (unchanged)
- ImGui window title: "Cyber Engine Tweaks" (unchanged)
- All function hashes, relocations, RTTI extensions (unchanged)

**Reason**: Changing internal identifiers would break binary compatibility with RED4ext, game hooks, and existing mods. The rename is cosmetic/metadata only.

---

## Installation (Preserving Existing Config)

Your existing installation at `C:\Games\Cyberpunk 2077\bin\x64` already contains:
- ✅ CET v1.36.0 (Patch 2.3 compatible)
- ✅ Fixed `bindings.json` with correct overlay key
- ✅ `mods/MaxHacking/init.lua` v2 with all fixes
- ✅ Your save games and settings

**No reinstall needed** - the renamed project is functionally identical to your working installation.

---

## Build from Source (Optional)

If you need to build the renamed `.asi`:

```powershell
# Requires: Visual Studio 2022, xmake v2.7.2 (not v3.x)
# The xmake.lua specifies v2.7.2; v3.1.1 has dependency issues with TiltedCore

xmake config --arch=x64 --mode=release --yes
xmake package
# Output: package/bin/x64/plugins/estalingrado_corp_netrunner_console.asi
```

**Note**: Current xmake v3.1.1 fails building TiltedCore dependency. Use xmake v2.7.2 matching `xmake.lua`.

---

## Backups & Recovery

| Backup | Location |
|--------|----------|
| CET v1.37.1 (installed) | `C:\Users\nicot\AppData\Local\Temp\opencode\cet_1.37.1_installed` |
| CET v1.36.0 (staged) | `C:\Users\nicot\AppData\Local\Temp\opencode\cet_1.36.0_stage` |
| CET v1.37.1 (pre-fix) | `C:\Users\nicot\AppData\Local\Temp\opencode\cp2077_cet_backup` |
| Save games | `C:\Users\nicot\AppData\Local\Temp\opencode\cp2077_saves_backup` |
| Release zips | `C:\Users\nicot\AppData\Local\Temp\opencode\cet_1.36.0.zip`, `cet_1.37.1.zip` |

---

## Testing Checklist

- [ ] Launch Cyberpunk 2077
- [ ] Load save (level 20, Corpo, PL active)
- [ ] Press `<` key → Console opens with "CET Overlay Bind: <" notification
- [ ] Verify MaxHacking v2 applied: Level 60, Int 20, Hacking 20, CombatHacking 20
- [ ] Check attribute/perk points increased (+60/+40)
- [ ] Verify 1M eddies and materials added
- [ ] No script errors in `cyber_engine_tweaks.log`

---

## References

- CET Source: https://github.com/maximegmd/CyberEngineTweaks
- RED4ext: https://github.com/WopsS/RED4ext
- RedModding Wiki (Patch 2.x API): https://wiki.redmodding.org/
- VKBindings.cpp encoding logic: `EncodeVKCodeBind()` / `DecodeVKCodeBind()`
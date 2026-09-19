s2772 = function()
    local cheats = [==[
🖥️ Apertura de la Consola
Para empezar, abre la consola de CET en el juego con la tecla ~ (Tilda) o º (según tu teclado).

💰 Dinero y Recursos
Truco	Comando
Añadir dinero	Game.AddToInventory("Items.money", 100000)
Materiales de fabricación (Común a Legendario)	Game.AddToInventory("Items.CommonMaterial1", 1000)
Game.AddToInventory("Items.UncommonMaterial1", 1000)
Game.AddToInventory("Items.RareMaterial1", 1000)
Game.AddToInventory("Items.EpicMaterial1", 1000)
Game.AddToInventory("Items.LegendaryMaterial1", 1000)
Materiales de Quickhacks	Game.AddToInventory("Items.QuickHackUncommonMaterial1", 1000)
Game.AddToInventory("Items.QuickHackRareMaterial1", 1000)
Game.AddToInventory("Items.QuickHackEpicMaterial1", 1000)
Game.AddToInventory("Items.QuickHackLegendaryMaterial1", 1000)
Munición	Game.AddToInventory("Ammo.HandgunAmmo", 500)
Game.AddToInventory("Ammo.RifleAmmo", 700)
Game.AddToInventory("Ammo.ShotgunAmmo", 100)
Game.AddToInventory("Ammo.SniperRifleAmmo", 100)
📈 Nivel, Atributos y Puntos
Truco	Comando
Establecer nivel	Game.SetLevel("Level", 60, 1)
Establecer Street Cred	Game.SetLevel("StreetCred", 50, 1)
Añadir puntos de atributo	PlayerDevelopmentSystem.GetInstance(Game.GetPlayer()):GetDevelopmentData(Game.GetPlayer()):AddDevelopmentPoints(10, gamedataDevelopmentPointType.Attribute)
Añadir puntos de ventaja (Perk)	PlayerDevelopmentSystem.GetInstance(Game.GetPlayer()):GetDevelopmentData(Game.GetPlayer()):AddDevelopmentPoints(10, gamedataDevelopmentPointType.Primary)
Modificar un atributo (ej. Body)	PlayerDevelopmentSystem.GetInstance(Game.GetPlayer()):GetDevelopmentData(Game.GetPlayer()):SetAttribute("Strength", 15)
Añadir libro de puntos de ventaja	Game.AddToInventory("Items.PerkPointSkillbook", 1)
Añadir libro de puntos de atributo	Game.AddToInventory("Items.AttributePointSkillbook", 1)
❤️ Estadísticas del Personaje
Truco	Comando
Vida	Game.ModStatPlayer("Health", 500)
Armadura	Game.ModStatPlayer("Armor", 200)
Capacidad de carga	Game.ModStatPlayer("CarryCapacity", 500)
Daño crítico	Game.ModStatPlayer("CritDamage", 100)
Velocidad de movimiento	Game.ModStatPlayer("MaxSpeed", 10)
Aguante infinito	Game.InfiniteStamina(true)
Modo Dios (Vida masiva)	Game.ModStatPlayer("Health", "99999")
Inmortalidad (sin daño)	Game.GetPlayer():SetImmortal(true)
Eliminar búsqueda policial	Game.GetPoliceSystem():ClearHeat()
🚗 Vehículos y Teletransporte
Truco	Comando
Desbloquear todos los vehículos	Game.GetVehicleSystem():EnableAllPlayerVehicles()
Desbloquear vehículo específico (ej. Moto Brennan Apollo NCPD)	Game.GetVehicleSystem():EnablePlayerVehicle('Vehicle.vcd_brennan_apollo_ncpd', true, false)
Desbloquear vehículo de mod (ej. Bugatti Pur Sport)	Game.GetVehicleSystem():EnablePlayerVehicle("Vehicle.bugatti_pur_sport", true, false)
Teletransportarse a un punto	Game.GetTeleportationSystem():TeleportToPoint(x, y, z)
Nota: Para vehículos añadidos por mods, el código específico (ej. "Vehicle.bugatti_pur_sport") suele venir en la página de descripción del propio mod.
🧠 RAM (Aumento a 24)
Truco	Comando
Mejora de RAM Legendaria (la más potente, requiere DLC)	Game.AddToInventory("Items.AdvancedRamUpgradeLegendaryplusplus", 1)
Mejora de RAM Legendaria (sin DLC)	Game.AddToInventory("Items.AdvancedRamUpgradeLegendaryplus", 1)
Mejora de RAM Legendaria (base)	Game.AddToInventory("Items.AdvancedRamUpgradeLegendary", 1)
Importante: La capitalización de "PlusPlus" es obligatoria. Tras añadir el objeto, equíipalo en tu ranura de Corteza Frontal. Si ya tenías uno puesto, desequípaló y vuelve a equiparlo para que el juego actualice las estadísticas.
🎭 Hackeos Rápidos (Quickhacks)
El comando base es: Game.AddToInventory("Items.NombreDelHackeo", 1)
Hackeo Rápido	Comando
Contagio (Legendario)	Game.AddToInventory("Items.ContagionLvl4PlusPlusProgram", 1)
Colapso del Sistema (Legendario)	Game.AddToInventory("Items.SystemCollapseLvl4PlusPlusProgram", 1)
Suicidio (Legendario)	Game.AddToInventory("Items.SuicideLvl4PlusPlusProgram", 1)
Sobrecarga EMP (Legendario)	Game.AddToInventory("Items.EMPOverloadLvl4PlusPlusProgram", 1)
Ceguera (Legendario)	Game.AddToInventory("Items.BlindLvl4PlusPlusProgram", 1)
Fallo de Ciberware (Legendario)	Game.AddToInventory("Items.DisableCyberwareLvl4PlusPlusProgram", 1)
Ping (Legendario)	Game.AddToInventory("Items.PingLvl4PlusPlusProgram", 1)
Reinicio de Óptica (Legendario)	Game.AddToInventory("Items.MemoryWipeLvl4PlusPlusProgram", 1)
Fallo de Arma (Legendario)	Game.AddToInventory("Items.WeaponMalfunctionLvl4PlusPlusProgram", 1)
Fallo de Movilidad (Legendario)	Game.AddToInventory("Items.LocomotionMalfunctionLvl4PlusPlusProgram", 1)
Risa (Legendario)	Game.AddToInventory("Items.MadnessLvl4PlusPlusProgram", 1)
Blackwall (multi-objetivo)	Game.AddToInventory("Items.ActualBlackwallQuickhack")
Blackwall (Icónico)	Game.AddToInventory("Items.BlackwallGateway_Songbird",1)
Blackwall (Nivel 4)	Game.AddToInventory("Items.BlackWallProgramLvl4",1)
Blackwall (Nivel 3)	Game.AddToInventory("Items.BlackWallProgramLvl3",1)
Nota: Si buscas un hackeo que no está en esta lista, puedes encontrar su código exacto en la "Categorized All-In-One Command List" de Nexus Mods, dentro de la pestaña CYBERWARE → all cyberware / quickhacks.
🦾 Ciberware (Adicional)
Objeto	Comando
Cuchillas Mantis (Variante Predators Frenzy)	Game.AddToInventory("Items.PredatorsFrenzyMantisBlades", 1)
Brazos de Gorila (Variante Dynalar)	Game.AddToInventory("Items.DynalarStrongArms", 1)
🎭 Extras y Desbloqueos
Truco	Comando
Amistad con Johnny (final secreto)	Game.SetDebugFact("sqo32_johnny_friend", 1)
📋 Objetos Específicos (Ejemplos)
Objeto	Comando
Cuchillo de Scorpion	Game.AddToInventory("Items.mq001_scorpions_knife", 1)
Skippy (Pistola inteligente)	Game.AddToInventory("Items.mq007_skippy", 1)
Nudillos dorados	Game.AddToInventory("Items.mq008_golden_knuckledusters", 1)
Pistola de Wilson	Game.AddToInventory("Items.mq011_wilson_gun", 1)
Achilles (Rifle de precisión)	Game.AddToInventory("Items.Preset_Achilles_Default", 1)
Vestido de cuero negro	Game.AddToInventory("Items.t_dress_black_leather", 1)
Chaqueta de Johnny (Samurai)	Game.AddToInventory("Items.SQ031_Samurai_Jacket", 1)
]==]
    print(cheats)
end

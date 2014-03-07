/*
	DZAI Configuration File
	
	Description: Contains all configurable settings of DZAI. Contains settings for debugging, customization of AI units, spawning, and loot.
	
	Last updated: 1:02 AM 11/4/2013
*/

diag_log "[DZAI] Reading DZAI configuration file.";

/*	DZAI Settings
--------------------------------------------------------------------------------------------------------------------*/	

//Enable or disable event logging to arma2oaserver.rpt. Debug level setting. 0: Off, 1: Basic Debug, 2: Extended Debug. (Default: 0)
DZAI_debugLevel = 0;

//Frequency of server monitor update to RPT log in seconds. The monitor periodically reports number of max/current AI units and dynamically spawned triggers into RPT log. (Default: 300, 0 = Disabled)										
DZAI_monitorRate = 300;

//Enable or disable verification of classname tables used by DZAI. If invalid entries are found, they are removed and logged into the RPT log.
//If disabled, any invalid classnames will not be removed and clients may crash upon looting AI bodies with invalid items. Disable ONLY if a previous scan shows no invalid classnames (Default: true).										
DZAI_verifyTables = true;

//Enable to have server spawn in objects/buildings normally spawned clientside by DayZ's CfgTownGenerator. Prevents AI from walking/shooting through clutter and other objects. (Default: true)	
//If running DayZ Mod ("vanilla DayZ") or DayZ Overwatch, it is highly recommended to enable this option, as many added buildings are handled by the CfgTownGenerator.								
DZAI_objPatch = true;

//Minimum seconds to pass until a dead AI body can be cleaned up by DZAI's task scheduler. Affects both static and dynamic AI units (Default: 300).										
DZAI_cleanupDelay = 300;									

//Enable or disable DZAI reading from dzai_settings_override.sqf file (Default: true)
DZAI_readOverrideFile = true;

/*

	DZAI_modName value	|	Enables additional settings for...	|	Automatically detected by DZAI? (If Yes, editing DZAI_modName is not needed)
	--------------------------------------------------------------------------------------------------------------------
	""						Automatically detect mod 						N/A
	"default"				Force default settings							N/A
	"2017"					DayZ 2017/Namalsk 2017						No - Must set DZAI_modName = "2017" to enable additional settings.
	"epoch"					DayZ Epoch 									Yes - Adds bar currency to AI loot tables, AI skins, Epoch foods, replaces toolbelt items with Epoch versions.
	"overwatch"				DayZ Overwatch 								Yes - Adds Overwatch skins for AI.
	"huntinggrounds"		DayZ Hunting Grounds 						Yes - Enables additional static AI spawns for expanded Lingor map, AI skins, and backpacks.
	"unleashed"				DayZ Unleashed								Yes - Enables Unleashed static AI spawns and AI skins.
	
*/

//(Optional) In most cases it is unnecessary to edit this setting. If the wrong DayZ mod is being detected (or not being properly detected), choose the correct one from the list above. 
DZAI_modName = "";


/*	AI Unit Settings
--------------------------------------------------------------------------------------------------------------------*/		

//Enable or disable zombie attraction to AI weapon sounds. No effect if DZAI_zombieEnemy is set to false. Enabling this option may impact server performance as a script is run for each AI bullet fired.
//Note: AI cannot be attacked or damaged by zombies.(Default: false)		
DZAI_weaponNoise = false;

//(Affects AI vehicles only) Sets frequency of vehicle ammo/fuel check. Decreasing this value may impact server performance. (Default: 15)											
DZAI_refreshRate = 15;	

//Maximum distance for AI group leader to detect zombies. Increasing range beyond default may impact server performance. (Default: 200)							
DZAI_zDetectRange = 200;									

//Enable or disable AI hostility to zombies. If enabled, AI will attack zombies. (default: true)
DZAI_zombieEnemy = true;	

//Enable or disable "Free For All" mode. If FFA mode is enabled, all AI groups will be hostile to each other. (default: false)
//WARNING: This option will affect ALL AI spawned, including those spawned from other addons that include AI. Not recommended to enable if using other addons with AI.
DZAI_freeForAll = false;

//If enabled, AI group will attempt to track down player responsible for killing a group member. Players with radios will be given text warnings if they are being pursued (Default: true)
DZAI_findKiller = true;	

//If normal probability check for spawning NVGs fails, then give AI temporary NVGs only if they are spawned with weapongrade 1 or higher (applies only during nighttime hours). Temporary NVGs are unlootable and will be removed at death (Default: false).									
DZAI_tempNVGs = false;	

//Amount of humanity to reward player for killing an AI unit (Default: 0)									
DZAI_humanityGain = 0;										

//If enabled, players with radios will be given text warnings if they are being pursued by AI groups. (Default: true)
DZAI_radioMsgs = true;

//If enabled, send radio messages using client-side DZAI radio addon (Must be installed first). If disabled, send radio messages by remote execution method. (Default: false)
DZAI_useRadioAddon = false;


/*	Static AI Spawning Settings
--------------------------------------------------------------------------------------------------------------------*/	

//Enable or disable static AI spawns. If enabled, AI spawn points will be generated in cities, towns, and other predefined areas. Does not affect custom-defined spawns (Default: true).
DZAI_staticAI = true;

//Set minimum and maximum wait time in seconds to respawn an AI group after all units have been killed. Applies to both static AI and custom spawned AI (Default: Min 300, Max 600).									
DZAI_respawnTimeMin = 300;
DZAI_respawnTimeMax = 600;

//Time to allow spawned AI units to exist in seconds before being despawned when no players are present in a trigger area. Applies to both static AI and custom spawned AI (Default: 120)										
DZAI_despawnWait = 120;										


/*	Dynamic AI Spawning Settings
--------------------------------------------------------------------------------------------------------------------*/		

//Enable or disable dynamic AI spawns. If enabled, AI spawn locations will be generated for randomly selected players at randomized intervals (Default: true)									
DZAI_dynAISpawns = true;

//Time (seconds) required to reach maximum spawn probability per player. Lower number = More frequent dynamic spawns, Higher Number = Less frequent. (Recommended range: 1200-2700, Default: 1800)
DZAI_maxSpawnTime = 1800;

//Probability to send first available AI helicopter to reinforce dynamic AI group. No effect if DZAI_maxHeliPatrols is set to zero. (Default: 0.75)
DZAI_heliReinforceChance = 0.75;

//Array of area blacklist markers. Players within marker areas will not be targeted for dynamic AI spawns (Example: ["BlacklistArea1","BlacklistArea2","BlacklistArea3"])
//Epoch: DZAI will automatically set up 200m-radius blacklist areas around each trader area.
DZAI_dynAreaBlacklist = [];

//Time to wait before despawning all AI units in dynamic trigger area when no players are present. (Default: 120)
DZAI_dynDespawnWait = 120;


/*	AI Air Vehicle patrol settings
//Note: As of DZAI 1.8.0, all users are able to use air vehicle patrols without editing the server_cleanup.fsm.
--------------------------------------------------------------------------------------------------------------------*/		

//Maximum number of active AI air vehicle patrols. Set at 0 to disable (Default: 0).							
DZAI_maxHeliPatrols = 0;

//Set minimum and maximum wait time in seconds to respawn an AI vehicle patrol after vehicle is destroyed or disabled. (Default: Min 600, Max 900).
DZAI_respawnTMinA = 600;
DZAI_respawnTMaxA = 900;

//Classnames of air vehicle types to use. Valid vehicle types: Helicopters and Planes (Default: "UH1H_DZ").
//Air vehicles that are normally unarmed may have weapons added by DZAI (see "DZAI_airWeapons" setting below).								
DZAI_heliTypes = ["UH1H_DZ"];	

//Specify vehicle weapon for air vehicles that are unarmed by default. DZAI will arm these air vehicles with the specified weapons upon spawning each vehicle.
//NOTE: As of DZAI 1.9+, vehicle classnames are verified. If the classname is invalid (banned or nonexistent), it will not be added to the vehicle.
//Format: Each row containing a vehicle classname will be equipped with the weapon from the corresponding row in weapon classnames section. Ammo will be automatically assigned.
DZAI_airWeapons = [
	[
		//Air vehicle classnames (Remember: no comma for last entry! Otherwise, separate each string with commas)
		"Helicopter1_ExampleClassname",
		"Helicopter2_ExampleClassname"
	]
	,
	[
		//Corresponding weapon classnames (Remember: no comma for last entry! Otherwise, separate each string with commas)
		"Helicopter1_ExampleWeapon",
		"Helicopter2_ExampleWeapon"
	]
];


/*AI Land Vehicle patrol settings

	NOTES: 	This feature is only intended for demonstration purposes and does not represent the future finished version. 
			Therefore, there is NO support for using this feature, and it might not even work at all! 
			If you experience any problems using this feature, disable it.
--------------------------------------------------------------------------------------------------------------------*/	

//Maximum number of active AI land vehicle patrols. Set at 0 to disable (Default: 0).	
DZAI_maxLandPatrols = 0;

//Set minimum and maximum wait time in seconds to respawn an AI vehicle patrol after vehicle is destroyed or disabled. (Default: Min 600, Max 900).
DZAI_respawnTMinL = 600;
DZAI_respawnTMaxL = 900;

//Classnames of land vehicle types to use. (Default: "UAZ_Unarmed_TK_EP1")
DZAI_vehTypes = ["UAZ_Unarmed_TK_EP1"];


/*	AI weapon selection settings
--------------------------------------------------------------------------------------------------------------------*/

//True: Dynamically generate AI weapon list from CfgBuildingLoot (DayZ loot tables). False: Use preset weapon list located in world_classname_configs/global_classnames.sqf. (Default: true).
//Highly recommended to enable DZAI_verifyTables if this option is set to false. 
DZAI_dynamicWeaponList = true;

//Determines whether DZAI reads from default DayZ loot tables for dynamic AI weapon generation or from user-installed custom loot tables. (Default: false)
//No effect if DZAI_dynamicWeaponList is 'false'. If DZAI is unable to find custom loot tables installed, default loot tables will be used instead.
DZAI_customLootTables = false;

//List of classnames of weapons that AI should never use. By default, AI may carry any lootable weapon. (Only if DZAI_dynamicWeaponList = true)  
//Example: DZAI_banAIWeapons = ["M107_DZ","BAF_AS50_scoped"] will remove the M107 and AS50 from AI weapon tables if dynamic weapon list is enabled.								
//Note: It is recommended to add all melee weapon classnames into this list as AI have issues using melee weapons. 
//All melee weapons and crossbows present in DayZ 1.7.7.1 have been pre-banned ("Crossbow_DZ","Crossbow","MeleeHatchet","MeleeCrowbar","MeleeMachete","MeleeBaseball","MeleeBaseBallBat","MeleeBaseBallBatBarbed","MeleeBaseBallBatNails")
DZAI_banAIWeapons = [];										

//List of launcher-type weapons for mid/high-level AI to use (by default, weapongrade 1/2/3), example: ["M136"]. If left empty, AI will not use launcher weapons. (Default: [])
//If AI encounter an armored player vehicle, they will switch to a randomly-selected launcher-type weapon to engage. (Maximum 1 launcher per AI group).
//Weapon classnames added here are verified if DZAI_verifyTables is set to true. Note: Launcher weapons are removed from the AI unit upon death.
DZAI_launcherTypes = [];	

//List of AI weapongrades that are permitted to use launcher-type weapons. Individual custom weapongrade levels may be added to allow launcher use (Default: [1,2,3])
DZAI_launcherLevels = [1,2,3];								


/*	AI loot quantity settings
--------------------------------------------------------------------------------------------------------------------*/

//Number of selections of medical items (Inventory)
DZAI_invmedicals = 1;

//Number of selections of edible items (Inventory) 										
DZAI_invedibles = 1;	

//Number of selections of medical items (Backpack)									
DZAI_bpmedicals = 1; 	

//Number of selections of edible items (Backpack)									
DZAI_bpedibles = 1;	

//Maximum number of items to select from DZAI_MiscItemS table.										
DZAI_numMiscItemS = 3;						

//Maximum number of items to select from DZAI_MiscItemL table.				
DZAI_numMiscItemL = 1;										


/*	AI loot probability settings
--------------------------------------------------------------------------------------------------------------------*/

//Chance to add each medical item.
DZAI_chanceMedicals = 0.70;	

//Chance to add each edible item.								
DZAI_chanceEdibles = 0.70;

//Chance to add random item from DZAI_MiscItemS table.									
DZAI_chanceMiscItemS = 0.60;

//Chance to add random item from DZAI_MiscItemL table.								
DZAI_chanceMiscItemL = 0.10;								


/*AI weapon/skill probabilities (gradeChances should add up to 1.00) - [Civilian, Military, MilitarySpecial, HeliCrash] - Note: AI with higher grade weaponry will also have higher skill settings.
--------------------------------------------------------------------------------------------------------------------*/

//equipType = -1 - most AI will have pistols, sometimes basic rifles.
DZAI_gradeChancesNewbie = [0.90,0.10,0.00,0.00,0.00];	

//equipType = 0 - most AI will have basic pistols or rifles, and occasionally common military weapons.
DZAI_gradeChances0 = [0.00,0.90,0.10,0.00,0.00];	

//equipType = 1 - most AI will have common rifles, many will have common military weapons. Very rarely, AI will spawn with high-grade military or helicrash weapons.				
DZAI_gradeChances1 = [0.00,0.60,0.35,0.04,0.01];	

//equipType = 2 - most AI carry military weapons, and occasionally high-grade military weapons.				
DZAI_gradeChances2 = [0.00,0.20,0.60,0.15,0.05];

//equipType = 3 - All AI will carry at least a military-grade weapon. Many will be carrying high-grade military weapons.					
DZAI_gradeChances3 = [0.00,0.00,0.50,0.38,0.12];	

//Weapongrade chances for AI spawned from dynamic triggers.				
DZAI_gradeChancesDyn = [0.00,0.00,0.88,0.09,0.03];				

//Weapongrade chances for dead AI ejected from destroyed helicopter patrols.					
DZAI_gradeChancesHeli = [0.00,0.00,0.40,0.43,0.17];	

/*
	AI skill settings

	NOTE: The AI skill levels are not linear 0-3. The skill gap between 1-2 is higher than 0-1 and 2-3.
	
	0-1: Low to medium-skilled AI. Most common type of AI encountered. Intended to challenge players.
	2-3: High-skilled AI. Uncommon/rare type of AI found in places with military loot. Intended to kill players.
	HeliCrew: Maximum-skilled AI. Skills are intended to be extremely high as helicopters patrol alone and carry high-value loot.
*/

//AI skill settings level 0 (Skill, Minimum skill, Maximum skill). Baseline skill level: 0.40
DZAI_skill0 = [	
	["aimingAccuracy",0.10,0.125],
	["aimingShake",0.45,0.55],
	["aimingSpeed",0.45,0.55],
	["endurance",0.40,0.50],
	["spotDistance",0.35,0.45],
	["spotTime",0.35,0.45],
	["courage",0.40,0.60],
	["reloadSpeed",0.50,0.60],
	["commanding",0.40,0.50],
	["general",0.40,0.60]
];

//AI skill settings level 1 (Skill, Minimum skill, Maximum skill). Baseline skill level: 0.55
DZAI_skill1 = [	
	["aimingAccuracy",0.125,0.15],
	["aimingShake",0.60,0.70],
	["aimingSpeed",0.60,0.70],
	["endurance",0.55,0.65],
	["spotDistance",0.50,0.60],
	["spotTime",0.50,0.60],
	["courage",0.55,0.75],
	["reloadSpeed",0.60,0.70],
	["commanding",0.55,0.65],
	["general",0.55,0.75]
];

//AI skill settings level 2 (Skill, Minimum skill, Maximum skill). Baseline skill level: 0.70
DZAI_skill2 = [	
	["aimingAccuracy",0.15,0.20],
	["aimingShake",0.75,0.85],
	["aimingSpeed",0.70,0.80],
	["endurance",0.70,0.80],
	["spotDistance",0.65,0.75],
	["spotTime",0.65,0.75],
	["courage",0.70,0.90],
	["reloadSpeed",0.70,0.80],
	["commanding",0.70,0.90],
	["general",0.70,0.90]
];

//AI skill settings level 3 (Skill, Minimum skill, Maximum skill). Baseline skill level: 0.80
DZAI_skill3 = [	
	["aimingAccuracy",0.20,0.25],
	["aimingShake",0.85,0.95],
	["aimingSpeed",0.80,0.90],
	["endurance",0.80,0.90],
	["spotDistance",0.75,0.85],
	["spotTime",0.75,0.85],
	["courage",0.80,1.00],
	["reloadSpeed",0.80,0.90],
	["commanding",0.80,0.90],
	["general",0.80,1.00]
];

//Note: Additional AI skill settings can be defined (DZAI_skill4 - DZAI_skill9) using the same format above.
//Instructions: replace "nil" with the skill array. Refer to the above preset skill arrays for examples.
//Custom AI skill settings can only be used with custom-defined spawns (spawns created using the DZAI_spawn function).

//weapongrade 4 skills
DZAI_skill4 = nil; 

//weapongrade 5 skills
DZAI_skill5 = nil; 

//weapongrade 6 skills
DZAI_skill6 = nil; 

//weapongrade 7 skills
DZAI_skill7 = nil; 

//weapongrade 8 skills
DZAI_skill8 = nil;

//weapongrade 9 skills
DZAI_skill9 = nil; 


//AI skill settings - AI helicopter crew (Skill, Minimum skill, Maximum skill).
DZAI_heliCrewSkills = [	
	["aimingAccuracy",0.30,0.40],
	["aimingShake",0.80,0.95],
	["aimingSpeed",0.80,0.95],
	["endurance",0.60,0.80],
	["spotDistance",0.80,1.00],
	["spotTime",0.80,1.00],
	["courage",0.80,1.00],
	["reloadSpeed",0.80,1.00],
	["commanding",0.80,1.00],
	["general",0.80,1.00]
];


//NOTHING TO EDIT BEYOND THIS POINT

//Load custom DZAI settings file.
if (DZAI_readOverrideFile) then {call compile preprocessFileLineNumbers format ["%1\DZAI_settings_override.sqf",DZAI_directory]};

diag_log "[DZAI] DZAI configuration file loaded.";

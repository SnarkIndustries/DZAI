/*
	DZAI Server Initialization File
	
	Description: Handles startup process for DZAI. Does not contain any values intended for modification.
	
	Last updated: 8:18 PM 12/28/2013
*/
private ["_startTime"];

if (!isServer || !isNil "DZAI_isActive") exitWith {};
DZAI_isActive = true;

_startTime = diag_tickTime;

//Report DZAI version to RPT log
#include "DZAI_version.hpp"
#ifdef DZAI_MISSIONFILE_INSTALL
	DZAI_directory = "DZAI";
#else
	DZAI_directory = "\z\addons\dayz_server\DZAI";
#endif
diag_log format ["Initializing %1 version %2 using base path %3.",DZAI_TYPE,DZAI_VERSION,DZAI_directory];


//Load DZAI variables
call compile preprocessFileLineNumbers format ["%1\init\dzai_config.sqf",DZAI_directory];

//Load DZAI functions
call compile preprocessFileLineNumbers format ["%1\init\dzai_functions.sqf",DZAI_directory];

//Load DZAI classname tables
call compile preprocessFileLineNumbers format ["%1\init\world_classname_configs\global_classnames.sqf",DZAI_directory];

//Set internal-use variables
DZAI_weaponGrades = [-1,0,1,2,3];							//All possible weapon grades (does not include custom weapon grades). A "weapon grade" is a tiered classification of gear. -1: Civilian (Low-grade), 0: Civilian, 1: Military, 2: MilitarySpecial, 3: Heli Crash. Weapon grade also influences the general skill level of the AI unit.
DZAI_weaponGradesAll = [-1,0,1,2,3,4,5,6,7,8,9];			//All possible weapon grades (including custom weapon grades).
DZAI_numAIUnits = 0;										//Tracks current number of currently active AI units, including dead units waiting for respawn.
DZAI_actTrigs = 0;											//Tracks current number of active static triggers.	
DZAI_curHeliPatrols = 0;									//Current number of active air patrols
DZAI_curLandPatrols = 0;									//Current number of active land patrols
DZAI_dynTriggerArray = [];									//List of all generated dynamic triggers.
DZAI_respawnQueue = [];										//Queue of AI groups that require respawning. Group ID is removed from queue after it is respawned.
DZAI_gradeIndicesNewbie = [];
DZAI_gradeIndices0 = [];
DZAI_gradeIndices1 = [];
DZAI_gradeIndices2 = [];
DZAI_gradeIndices3 = [];
DZAI_gradeIndicesDyn = [];
DZAI_gradeIndicesHeli = [];
DZAI_dynEquipType = 4;
DZAI_heliEquipType = 5;
DZAI_vehEquipType = 3;
DZAI_deleteObjectQueue = [];								//Queue of objects marked for deletion
DZAI_dynLocations = [];										//Queue of temporary dynamic spawn area blacklists
DZAI_reinforcePlaces = [];
DZAI_checkedClassnames = [[],[],[]];						//Classnames verified - Weapons/Magazines/Vehicles

//Set side relations
createcenter east;
createcenter resistance;
if (DZAI_freeForAll) then {
        //Free For All mode - All AI groups are hostile to each other.
        east setFriend [resistance, 0];
        resistance setFriend [east, 0];        
        east setFriend [east, 0];        //East is hostile to self (static and dynamic AI)
} else {
        //Normal settings - All AI groups are friendly to each other.
        east setFriend [resistance, 1];
        resistance setFriend [east, 1];        
};
east setFriend [west, 0];        
resistance setFriend [west, 0];
west setFriend [resistance, 0];
west setFriend [east, 0];

//Detect DayZ mod variant being used.
if (DZAI_modName == "") then {
	private["_modVariant"];
	_modVariant = toLower(getText (configFile >> "CfgMods" >> "DayZ" >> "dir"));
	if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Detected mod variant %1.",_modVariant];};
	switch (_modVariant) do {
		case "@dayz_epoch":{
			DZAI_modName = "epoch"; 
		};
		case "dayzoverwatch":{DZAI_modName = "overwatch"};
		case "@dayzoverwatch":{DZAI_modName = "overwatch"};
		case "@dayzhuntinggrounds":{DZAI_modName = "huntinggrounds"};
		case "@dayzunleashed":{DZAI_modName = "unleashed"};
		case "dayzlingor":{
			private["_modCheck"];
			_modCheck = toLower (getText (configFile >> "CfgMods" >> "DayZ" >> "action"));
			if (_modCheck == "http://www.skaronator.com") then {DZAI_modName = "lingorskaro"};
			if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Detected DayZ Lingor variant %1.",_modCheck];};
		};
	};
};

//Create reference marker to act as boundary for spawning AI air/land vehicles. These values will be later modified on a per-map basis.
if ((DZAI_maxHeliPatrols > 0) or {(DZAI_maxLandPatrols > 0)}) then {
	DZAI_centerMarker = createMarker ["DZAI_centerMarker", (getMarkerPos 'center')];
	DZAI_centerMarker setMarkerShape "ELLIPSE";
	DZAI_centerMarker setMarkerType "Empty";
	DZAI_centerMarker setMarkerBrush "Solid";
	DZAI_centerMarker setMarkerSize [7000, 7000];
	DZAI_centerMarker setMarkerAlpha 0;
};

private["_worldname"];
_worldname=toLower format ["%1",worldName];
diag_log format["[DZAI] Server is running map %1. Loading static trigger and classname configs.",_worldname];

//Load map-specific configuration file. Config files contain trigger/marker information, addition and removal of items/skins, and/or other variable customizations.
//Classname files will overwrite basic settings specified in base_classnames.sqf
if (_worldname in ["chernarus","utes","zargabad","fallujah","takistan","tavi","lingor","namalsk","mbg_celle2","oring","panthera2","isladuala","sara","smd_sahrani_a2","trinity","napf","caribou","cmr_ovaron","sauerland"]) then {
	call compile preprocessFileLineNumbers format ["%1\init\world_classname_configs\%2_classnames.sqf",DZAI_directory,_worldname];
	[] execVM format ["%1\init\world_spawn_configs\world_%2.sqf",DZAI_directory,_worldname];
} else {
	"DZAI_centerMarker" setMarkerSize [7000, 7000];
	if (DZAI_modName == "epoch") then {
		call compile preprocessFileLineNumbers format ["%1\init\world_classname_configs\epoch\dayz_epoch.sqf",DZAI_directory];
	};
	if (DZAI_staticAI) then {[] execVM format ["%1\scripts\setup_autoStaticSpawns.sqf",DZAI_directory];};
};

//Continue loading required DZAI script files
[] execVM format ['%1\scripts\DZAI_scheduler.sqf',DZAI_directory];

//Report DZAI startup settings to RPT log
diag_log format ["[DZAI] DZAI settings: Debug Level: %1. DebugMarkers: %2. ModName: %3. DZAI_dynamicWeaponList: %4. VerifyTables: %5.",DZAI_debugLevel,((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled}),DZAI_modName,DZAI_dynamicWeaponList,DZAI_verifyTables];
diag_log format ["[DZAI] AI spawn settings: Static: %1. Dynamic: %2. Air: %3. Land: %4.",DZAI_staticAI,DZAI_dynAISpawns,(DZAI_maxHeliPatrols>0),(DZAI_maxLandPatrols>0)];
diag_log format ["[DZAI] AI behavior settings: DZAI_findKiller: %1. DZAI_tempNVGs: %2. DZAI_weaponNoise: %3. DZAI_zombieEnemy: %4. DZAI_freeForAll: %5",DZAI_findKiller,DZAI_tempNVGs,DZAI_weaponNoise,DZAI_zombieEnemy,DZAI_freeForAll];
diag_log format ["[DZAI] DZAI loading completed in %1 seconds.",(diag_tickTime - _startTime)];

/*
	DZAI Startup
	
	Description: Handles post-initialization tasks and starts DZAI cleanup procedure
	
	Last updated: 12:11 AM 6/17/2014
*/

if (DZAI_debugLevel > 0) then {diag_log "DZAI Debug: DZAI Startup is running required script files..."};

//Set internal-use variables
DZAI_weaponGrades = [0,1,2,3];							//All possible weapon grades (does not include custom weapon grades). A "weapon grade" is a tiered classification of gear. 0: Civilian, 1: Military, 2: MilitarySpecial, 3: Heli Crash. Weapon grade also influences the general skill level of the AI unit.
DZAI_weaponGradesAll = [0,1,2,3,4,5,6,7,8,9];			//All possible weapon grades (including custom weapon grades).
DZAI_numAIUnits = 0;										//Tracks current number of currently active AI units, including dead units waiting for respawn.
DZAI_curHeliPatrols = 0;									//Current number of active air patrols
DZAI_curLandPatrols = 0;									//Current number of active land patrols
DZAI_dynTriggerArray = [];									//List of all generated dynamic triggers.
DZAI_staticTriggerArray = [];								//List of all static triggers
DZAI_respawnQueue = [];										//Queue of AI groups that require respawning. Group ID is removed from queue after it is respawned.
DZAI_gradeIndices0 = [];
DZAI_gradeIndices1 = [];
DZAI_gradeIndices2 = [];
DZAI_gradeIndices3 = [];
DZAI_gradeIndicesDyn = [];
DZAI_dynEquipType = 4;
DZAI_dynLocations = [];										//Queue of temporary dynamic spawn area blacklists for deletion
DZAI_reinforcePlaces = [];									//AI helicopter patrols will periodically check this array for dynamic trigger objects to use as reinforcement positions.
DZAI_checkedClassnames = [[],[],[]];						//Classnames verified - Weapons/Magazines/Vehicles
DZAI_respawnTimeVariance = (abs (DZAI_respawnTimeMax - DZAI_respawnTimeMin));
DZAI_respawnTimeVarAir = (abs (DZAI_respawnTMaxA - DZAI_respawnTMinA));
DZAI_respawnTimeVarLand = (abs (DZAI_respawnTMaxL - DZAI_respawnTMinL));
DZAI_baseBlood = (DZAI_unitBloodLevel select 0);
DZAI_bonusBlood = ((DZAI_unitBloodLevel select 1) - (DZAI_unitBloodLevel select 0));
DZAI_customSpawnQueue = [];
DZAI_serverObjectMonitorArray = [];	//dummy array in case DayZ's server object monitor can't be found
DZAI_monitoredObjects = []; //used to cleanup AI vehicles that may not be destroyed.

//Create gamelogic to act as default trigger object if AI is spawned without trigger object specified (ie: for custom vehicle AI groups)
_nul = [] spawn {
	private ["_logicCenter","_logicGroup"];
	_logicCenter = createCenter sideLogic;
	_logicGroup = createGroup _logicCenter;
	DZAI_defaultTrigger = _logicGroup createUnit ["LOGIC", [0,0,0], [], 0, "NONE"];
	DZAI_defaultTrigger setVariable ["isCleaning",true];
	DZAI_defaultTrigger setVariable ["patrolDist",100];
	DZAI_defaultTrigger setVariable ["equipType",1];
	DZAI_defaultTrigger setVariable ["locationArray",[]];
	DZAI_defaultTrigger setVariable ["maxUnits",[0,0]];
	DZAI_defaultTrigger setVariable ["GroupSize",0];
	DZAI_defaultTrigger setVariable ["initialized",true];
	if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Default trigger gamelogic spawn check result: %1",(!isNull _logicGroup) && {(typeName DZAI_defaultTrigger) == "OBJECT"}]};
};


//Configure AI health system
if (isNil "DZAI_useHealthSystem") then {DZAI_useHealthSystem = true};
if (DZAI_useHealthSystem) then {
	DZAI_healthType = "HandleDamage"; //DZAI will manage individual unit health and death.
	DZAI_healthStatements = if (isNil "DDOPP_taser_handleHit") then {"_this call DZAI_AI_handledamage"} else {"_this call DDOPP_taser_handleHit;_this call DZAI_AI_handledamage"}; //Check if DDOP Taser Mod is installed
} else {
	DZAI_healthType = "Killed"; //DZAI will process individual unit deaths only.
	DZAI_healthStatements = "_this call DZAI_unitDeath;";
};

//Find DayZ server object monitor (to prevent AI vehicles from being destroyed due to hacker check)
DZAI_serverObjectMonitor = call {
	if (!isNil "dayz_serverObjectMonitor") exitWith {"dayz_serverObjectMonitor"};
	if (!isNil "PVDZE_serverObjectMonitor") exitWith {"PVDZE_serverObjectMonitor"};
	"DZAI_serverObjectMonitorArray"
};

_vehiclesEnabled = ((DZAI_maxHeliPatrols > 0) or {(DZAI_maxLandPatrols > 0)});

[] call compile preprocessFileLineNumbers format ["%1\scripts\buildWeightedTables.sqf",DZAI_directory];

//If serverside object patch enabled, then spawn in serverside objects.
if (DZAI_objPatch) then {
	_nul = [] execVM format ['%1\scripts\buildingpatch_all.sqf',DZAI_directory];
};

//Build DZAI weapon classname tables from CfgBuildingLoot data if DZAI_dynamicWeapons = true;
if (DZAI_dynamicWeaponList) then {
	_weaponlist = [] execVM format ['%1\scripts\buildWeaponArrays.sqf',DZAI_directory]; //Overwrite default weapon tables with classnames found in DayZ's loot tables.
} else {
	DZAI_weaponsInitialized = true;	//Use default weapon tables defined in global_classnames.sqf
};

//Load additional classname configuration from per-map config file. Weapons are read from loot tables so they are not included here
if (!isNil "DZAI_BanditTypesNew") then {[DZAI_BanditTypes,DZAI_BanditTypesNew] call DZAI_append};
if (!isNil "DZAI_Backpacks0New") then {[DZAI_Backpacks0,DZAI_Backpacks0New] call DZAI_append};
if (!isNil "DZAI_Backpacks1New") then {[DZAI_Backpacks1,DZAI_Backpacks1New] call DZAI_append};
if (!isNil "DZAI_Backpacks2New") then {[DZAI_Backpacks2,DZAI_Backpacks2New] call DZAI_append};
if (!isNil "DZAI_Backpacks3New") then {[DZAI_Backpacks3,DZAI_Backpacks3New] call DZAI_append};
if (!isNil "DZAI_EdiblesNew") then {[DZAI_Edibles,DZAI_EdiblesNew] call DZAI_append};
if (!isNil "DZAI_Medicals1New") then {[DZAI_Medicals1,DZAI_Medicals1New] call DZAI_append};
if (!isNil "DZAI_Medicals2New") then {[DZAI_Medicals2,DZAI_Medicals2New] call DZAI_append};
if (!isNil "DZAI_MiscItemSNew") then {[DZAI_MiscItemS,DZAI_MiscItemSNew] call DZAI_append};
if (!isNil "DZAI_MiscItemLNew") then {[DZAI_MiscItemL,DZAI_MiscItemLNew] call DZAI_append};

//Check classname tables if enabled
if (DZAI_verifyTables) then {
	_verify = [] execVM format ["%1\scripts\verifyTables.sqf",DZAI_directory];
	waitUntil {uiSleep 0.5; scriptDone _verify}; //wait for verification to complete before proceeding
	if ((count DZAI_BanditTypes) == 0) then {DZAI_BanditTypes = ["Survivor2_DZ"]}; //Failsafe in case all AI skin classnames are invalid.
} else {
	DZAI_classnamesVerified = true;	//skip classname verification if disabled
};

//Build map location list. If using an unknown map, DZAI will automatically generate basic static triggers at cities and towns.
_nul = [] execVM format ['%1\scripts\setup_locations.sqf',DZAI_directory];
uiSleep 0.1;

if (DZAI_dynAISpawns) then {
	if ((count DZAI_dynAreaBlacklist) > 0) then {
		_nul = DZAI_dynAreaBlacklist execVM format ['%1\scripts\setup_blacklist_areas.sqf',DZAI_directory];
	};
	if (DZAI_freshSpawnSafeArea) then {
		_nul = [] execVM format ['%1\scripts\setup_playerspawn_areas.sqf',DZAI_directory];
	};
	_dynManagerV2 = [] execVM format ['%1\scripts\dynamicSpawn_manager.sqf',DZAI_directory];
};

if (DZAI_modName == "epoch") then {
	_nul = [] execVM format ['%1\scripts\setup_trader_areas.sqf',DZAI_directory];
};

if (_vehiclesEnabled) then {
	_nul = [] execVM format ['%1\scripts\setup_veh_patrols.sqf',DZAI_directory];
};

_nul = [] spawn {
	//diag_log "DEBUG :: Waiting for custom spawn config to be loaded.";
	waitUntil {uiSleep 1; !isNil "DZAI_customSpawnsReady"};
	if ((count DZAI_customSpawnQueue) == 0) exitWith {};
	//diag_log format ["DEBUG :: Custom vehicle spawn queue contents: %1",DZAI_customSpawnQueue];
	{
			_nul = _x spawn DZAI_spawnVehicle_custom;
			uiSleep 1;
	} forEach DZAI_customSpawnQueue;
	DZAI_customSpawnQueue = nil;	//Cleanup used functions
	DZAI_customSpawnsReady = nil;
	DZAI_spawn_vehicle = nil;
};

if (DZAI_debugLevel > 0) then {diag_log "DZAI Scheduler will start in 1 minute."};

//Begin main scheduler loop
_nul = [] spawn {
	_vehiclesEnabled = ((DZAI_maxHeliPatrols > 0) or {(DZAI_maxLandPatrols > 0)});
	_cleanDead = diag_tickTime;
	_monitorReport = diag_tickTime;
	_deleteObjects = diag_tickTime;
	_dynLocations = diag_tickTime;
	_purgeCounter = 0;
	_reportDynOrVehicles = (DZAI_dynAISpawns || _vehiclesEnabled);
	uiSleep 60;

	while {0 == 0} do {
		if ((time - _cleanDead) >= 300) then {	//Check every 5 minutes if any dead objects (units or vehicles) can be removed
			_deadCleaned = 0;
			{
				_deathTime = _x getVariable "DZAI_deathTime";
				if (!isNil "_deathTime") then {
					if (time > _deathTime) then {
						if (({isPlayer _x} count (_x nearEntities [["CAManBase","LandVehicle"], 20])) == 0) then {
							_soundflies = _x getVariable "sound_flies";
							if (!isNil "_soundflies") then {
								detach _soundflies;
								deleteVehicle _soundflies;
							};
							if (_x in DZAI_monitoredObjects) then {
								_purgeCounter = _purgeCounter + 1;
								//diag_log format ["DEBUG :: Object %1 (type: %2) found in server object monitor.",_x,typeOf _x];
							};
							_x call DZAI_purgeEH;
							//diag_log format ["DEBUG :: Deleting object %1 (type: %2).",_x,typeOf _x];
							deleteVehicle _x;
							_deadCleaned = _deadCleaned + 1;
						};
					};
				};
				uiSleep 0.005;
			} count allDead;
			
			{	//Clean abandoned AI vehicles
				_deathTime = _x getVariable "DZAI_deathTime";
				if (!isNil "_deathTime") then {
					if (time > _deathTime) then {
						_x call DZAI_purgeEH;
						//diag_log format ["DEBUG :: Deleting object %1 (type: %2).",_x,typeOf _x];
						deleteVehicle _x;
						_deadCleaned = _deadCleaned + 1;
						_purgeCounter = _purgeCounter + 1;
					};
				};
				uiSleep 0.005;
			} count DZAI_monitoredObjects;

			if (_purgeCounter >= 5) then {
				missionNamespace setVariable [DZAI_serverObjectMonitor,((missionNamespace getVariable DZAI_serverObjectMonitor) - [objNull])];
				DZAI_monitoredObjects = DZAI_monitoredObjects - [objNull];
				if (_deadCleaned > 0) then {diag_log format ["DZAI Cleanup: Cleaned up %1 null objects from server object monitor.",_purgeCounter]};
				_purgeCounter = 0;
			};
			if (_deadCleaned > 0) then {diag_log format ["DZAI Cleanup: Cleaned up %1 dead units/vehicles.",_deadCleaned]};
			_cleanDead = diag_tickTime;
		};
	
		if ((time - _dynLocations) >= 360) then { //clean up locations every 6 minutes
			_locationsDeleted = 0;
			{
				_deletetime = _x getVariable "deletetime";
				if (time > _deletetime) then {
					deleteLocation _x;
					_locationsDeleted = _locationsDeleted + 1;
				};
				uiSleep 0.005;
			} count DZAI_dynLocations;
			DZAI_dynLocations = DZAI_dynLocations - [locationNull];
			if (_locationsDeleted > 0) then {diag_log format ["DZAI Cleanup: Cleaned up %1 expired dynamic blacklist areas.",_locationsDeleted]};
			_dynLocations = diag_tickTime;
		};
		
		if ((DZAI_monitorRate > 0) && {((time - _monitorReport) >= DZAI_monitorRate)}) then {
			_uptime = [] call DZAI_getUptime;
			diag_log format ["DZAI Monitor :: Server Uptime: [%1d %2h %3m %4s]. Active AI Units: %5.",_uptime select 0, _uptime select 1, _uptime select 2, _uptime select 3,DZAI_numAIUnits];
			diag_log format ["DZAI Monitor :: Static Spawns: %1. Respawn Queue: %2 groups queued.",({triggerActivated _x} count DZAI_staticTriggerArray),(count DZAI_respawnQueue)];
			if (_reportDynOrVehicles) then {diag_log format ["DZAI Monitor :: Dynamic Spawns: %1. Air Patrols: %2. Land Patrols: %3.",({triggerActivated _x} count DZAI_dynTriggerArray),DZAI_curHeliPatrols,DZAI_curLandPatrols];};
			_monitorReport = diag_tickTime;
		};
		
		uiSleep 30;
	};
};

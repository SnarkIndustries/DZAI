/*
	DZAI Scheduler
	
	Description:
	
	Last updated: 6:24 PM 1/20/2014
*/

diag_log "DZAI Scheduler is running required script files...";

_vehiclesEnabled = ((DZAI_maxHeliPatrols > 0) or {(DZAI_maxLandPatrols > 0)});

[] call compile preprocessFileLineNumbers format ["%1\scripts\buildWeightedTables.sqf",DZAI_directory];

//If serverside object patch enabled, then spawn in serverside objects.
if (DZAI_objPatch) then {
	_nul = [] execVM format ['%1\scripts\buildingpatch_all.sqf',DZAI_directory];
};

//Build DZAI weapon classname tables from CfgBuildingLoot data if DZAI_dynamicWeapons = true;
if (DZAI_dynamicWeaponList) then {
	_weaponlist = [DZAI_banAIWeapons] execVM format ['%1\scripts\buildWeaponArrays.sqf',DZAI_directory]; //Overwrite default weapon tables with classnames found in DayZ's loot tables.
} else {
	DZAI_weaponsInitialized = true;	//Use default weapon tables defined in global_classnames.sqf
};

if (DZAI_verifyTables) then {
	_verify = [] execVM format ["%1\scripts\verifyTables.sqf",DZAI_directory];
	waitUntil {sleep 0.005; scriptDone _verify}; //wait for verification to complete before proceeding
	if ((count DZAI_BanditTypes) == 0) then {DZAI_BanditTypes = ["Survivor2_DZ"]}; //Failsafe in case all AI skin classnames are invalid.
} else {
	DZAI_classnamesVerified = true;	//skip classname verification if disabled
};

//Build map location list. If using an unknown map, DZAI will automatically generate basic static triggers at cities and towns.
_nul = [] execVM format ['%1\scripts\setup_locations.sqf',DZAI_directory];
sleep 0.1;

if (_vehiclesEnabled) then {
	_nul = [] execVM format ['%1\scripts\setup_veh_patrols.sqf',DZAI_directory];
};

if (DZAI_staticAI) then {
	DZAI_ignoredObjects = missionNamespace getVariable ["dayz_allowedObjects",[]];	//Object types to never use as potential static spawn positions.
};

if (DZAI_dynAISpawns) then {
	if ((count DZAI_dynAreaBlacklist) > 0) then {
		_nul = DZAI_dynAreaBlacklist execVM format ['%1\scripts\setup_blacklist_areas.sqf',DZAI_directory];
	};
	_dynManagerV2 = [] execVM format ['%1\scripts\dynamicSpawn_manager.sqf',DZAI_directory];
};

if (DZAI_modName == "epoch") then {
	_nul = [] execVM format ['%1\scripts\setup_trader_areas.sqf',DZAI_directory];
};

_refreshMarkers = ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled});
_cleanDead = time;
_monitorReport = time;
_deleteObjects = time;
_dynLocations = time;

diag_log "DZAI Scheduler will continue tasks in 1 minute.";
sleep 60;

while {true} do {

	if ((time - _cleanDead) >= 900) then {
		{
			_deathTime = _x getVariable "DZAI_deathTime";
			if (!isNil "_deathTime") then {
				if (time > _deathTime) then {
					if (({isPlayer _x} count (_x nearEntities ["CAManBase", 20])) == 0) then {
						_soundFlies = _x getVariable "sound_flies";
						if (!isNil "_soundFlies") then {
							detach _soundFlies;
							deleteVehicle _soundFlies;
						};
						deleteVehicle _x;
					};
				};
			};
			sleep 0.005;
		} forEach allDead;
		_cleanDead = time;
	};
	
	if ((time - _deleteObjects) >= 300) then {
		{
			_deletetime = (_x select 1);
			if (time > _deletetime) then {
				_object = (_x select 0);
				_object call DZAI_unprotectObject;
				deleteVehicle _object;
				DZAI_deleteObjectQueue set [_forEachIndex,objNull];
			};
			sleep 0.005;
		} forEach DZAI_deleteObjectQueue;
		DZAI_deleteObjectQueue = DZAI_deleteObjectQueue - [objNull];
		_deleteObjects = time;
	};
	
	if ((time - _dynLocations) >= 360) then {
		{
			_deletetime = _x getVariable "deletetime";
			if (time > _deletetime) then {
				deleteLocation _x;
				DZAI_dynLocations set [_forEachIndex,locationNull];
			};
			sleep 0.005;
		} forEach DZAI_dynLocations;
		DZAI_dynLocations = DZAI_dynLocations - [locationNull];
		_dynLocations = time;
	};
	
	if ((DZAI_monitorRate > 0) && {((time - _monitorReport) >= DZAI_monitorRate)}) then {
		_uptime = [] call DZAI_getUptime;
		diag_log format ["DZAI Monitor :: Server Uptime - %1 d %2 hr %3 min %4 sec. Active AI Units - %5.",_uptime select 0, _uptime select 1, _uptime select 2, _uptime select 3,DZAI_numAIUnits];
		if (DZAI_staticAI) then {diag_log format ["DZAI Monitor :: Static Spawns - %1 active static triggers. %2 groups queued for respawn.",DZAI_actTrigs,(count DZAI_respawnQueue)];};
		if (DZAI_dynAISpawns || {_vehiclesEnabled}) then {diag_log format ["DZAI Monitor :: Dynamic Spawns - %1/%2 (active/total). Air Patrols: %3/%4 (cur/max). Land Patrols: %5/%6.",({triggerActivated _x} count DZAI_dynTriggerArray),(count DZAI_dynTriggerArray),DZAI_curHeliPatrols,DZAI_maxHeliPatrols,DZAI_curLandPatrols,DZAI_maxLandPatrols];};
		if (_refreshMarkers && {((count DZAI_dynTriggerArray) > 0)}) then {
			{
				private["_marker"];
				_marker = format ["trigger_%1",_x];
				_marker setMarkerPos (getMarkerPos _marker);
				sleep 1;
			} forEach DZAI_dynTriggerArray;
		};
		_monitorReport = time;
	};
	
	sleep 30;
};

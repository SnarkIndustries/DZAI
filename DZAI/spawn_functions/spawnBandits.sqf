/*
	spawnBandits
	
	Usage: [_minAI, _addAI, _patrolDist, _trigger, _numGroups (optional)] spawn spawnBandits;
	
	Description: Called through (mapname)_config.sqf when a static trigger is activated by a player.
	
	Last updated: 8:38 AM 10/23/2013
*/

private ["_minAI","_addAI","_patrolDist","_trigger","_equipType","_numGroups","_grpArray","_triggerPos","_locationArray","_positionArray","_startTime","_tMarker","_totalSpawned","_debugMarkers","_triggerStatements","_respawnLimit","_groupsActive"];
if (!isServer) exitWith {};

_startTime = diag_tickTime;

_minAI = _this select 0;									//Mandatory minimum number of AI units to spawn
_addAI = _this select 1;									//Maximum number of additional AI units to spawn
_patrolDist = _this select 2;								//Patrol radius from trigger center.
_trigger = _this select 3;									//The trigger calling this script.
_positionArray = _this select 4;							//Array of manually-defined spawn points (markers). If empty, nearby buildings are used as spawn points.
_equipType = if ((count _this) > 5) then {_this select 5} else {1};		//(Optional) Select the item probability table to use
_numGroups = if ((count _this) > 6) then {_this select 6} else {1};		//(Optional) Number of groups of x number of units each to spawn

_grpArray = _trigger getVariable ["GroupArray",[]];	
_groupsActive = count _grpArray;
_debugMarkers = ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled});

if (_groupsActive == _numGroups) exitWith {
	_triggerStatements = (triggerStatements _trigger);
	_triggerStatements set [1,""];
	_trigger setTriggerStatements _triggerStatements;
	_trigger setTriggerArea [750,750,0,false];
	_trigger call DZAI_updStaticSpawnCount;
	if (_debugMarkers) then {
		_nul = [_trigger] spawn DZAI_updateSpawnMarker;
	};
	if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Maximum number of groups already spawned at %1. Exiting spawn script (spawnBandits)",(triggerText _trigger)];};
};						

_trigger setTriggerArea [750,750,0,false]; //Expand trigger area to prevent players from quickly leaving and start respawn process immediately
_triggerPos = ASLtoATL getPosASL _trigger;

//If trigger already has defined spawn points, then reuse them instead of recalculating new ones.
_locationArray = _trigger getVariable ["locationArray",[]];	
if ((count _locationArray) == 0) then {
	//If no markers specified in position array, then generate spawn points using building positions (search for buildings within 250m. generate a maximum of 150 positions).
	if ((count _positionArray) == 0) then {
		private["_nearbldgs","_spawnPoints"];
		_spawnPoints = 0;
		_nearbldgs = _triggerPos nearObjects ["HouseBase",250];
		if ((count _nearbldgs) > 0) then {
			_ignoredObj = missionNamespace getVariable ["dayz_allowedObjects",[]];
			{
				scopeName "bldgloop";
				_pos = ASLtoATL getPosASL _x;
				if (!((typeOf _x) in _ignoredObj) && {!(surfaceIsWater _pos)}) then {
					_locationArray set [(count _locationArray),_pos];
					_spawnPoints = _spawnPoints + 1;
				};
				if (_spawnPoints >= 150) then {
					breakOut "bldgloop";
				};
			} count _nearbldgs;
		};
		if (DZAI_debugLevel > 1) then {diag_log "DZAI Extended Debug: Spawning AI from building positions (spawnBandits).";};
	} else {
		{
			_pos = ASLtoATL getPosASL _x;
			if (((getMarkerColor _x) != "") && {!(surfaceIsWater _pos)}) then {
				_locationArray set [(count _locationArray),_pos];
				deleteMarker _x;
			};
		} count _positionArray;
		if (DZAI_debugLevel > 1) then {diag_log "DZAI Extended Debug: Spawning AI from marker positions (spawnBandits).";};
	};
} else {
	//If spawn points are already defined, use previously calculated positions
	if (DZAI_debugLevel > 1) then {diag_log "DZAI Extended Debug: Spawning AI from previously calculated positions (spawnBandits).";};
};

if (DZAI_debugLevel > 0) then {diag_log format["DZAI Debug: Processed static trigger spawn data in %1 seconds (spawnBandits).",(diag_tickTime - _startTime)];};

_startTime = diag_tickTime;

_totalSpawned = 0;
_respawnLimit = missionNamespace getVariable ["DZAI_respawnLimit"+str(_equipType),5];

//Spawn groups
for "_j" from 1 to (_numGroups - _groupsActive) do {
	private ["_unitGroup","_spawnPos","_totalAI"];
	_totalAI = (_minAI + round(random _addAI));
	_spawnPos = if ((count _locationArray) > 0) then {_locationArray call DZAI_findSpawnPos} else {[(ASLtoATL getPosASL _trigger),random (_patrolDist),random(360),false] call SHK_pos};

	//If non-zero unit amount and valid spawn position, spawn group, otherwise add it to respawn queue.
	_unitGroup = grpNull;
	if ((_totalAI > 0) && {(count _spawnPos) > 1}) then {
		_weapongrade = _equipType call DZAI_getWeapongrade;
		_unitGroup = [_totalAI,_unitGroup,_spawnPos,_trigger,_weapongrade] call DZAI_setup_AI;
		_totalSpawned = _totalSpawned + _totalAI;
		if (_patrolDist > 1) then {
			0 = [_unitGroup,_triggerPos,_patrolDist] spawn DZAI_BIN_taskPatrol;
		} else {
			[_unitGroup, 0] setWaypointType "HOLD";
			_unitGroup setFormDir (random 360);
		};
		if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Spawned group %1 (weapongrade: %2) with %3 units.",_unitGroup,_weapongrade,_totalAI];};
	} else {
		_unitGroup = createGroup (call DZAI_getGroupSide);
		_dummy = _unitGroup call DZAI_protectGroup;
		_unitGroup setVariable ["GroupSize",0];
		_unitGroup setVariable ["trigger",_trigger];
		0 = [0,_trigger,_unitGroup,true] call fnc_respawnHandler;
		if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: No units spawned for group %1. Added group to respawn queue.",_unitGroup];};
	};

	//Set group variables and add it to trigger's group array
	_unitGroup setVariable ["unitType","static"];
	_unitGroup allowFleeing 0;
	_grpArray set [count _grpArray,_unitGroup];
};

_triggerStatements = (triggerStatements _trigger);
if (!(_trigger getVariable ["initialized",false])) then {
	0 = [_trigger,_grpArray,_patrolDist,_equipType,_locationArray,[_minAI,_addAI]] call DZAI_setTrigVars;
	_trigger setVariable ["triggerStatements",+_triggerStatements];
	_trigger setVariable ["respawnLimit",_respawnLimit];
} else {
	if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Trigger group array updated to: %1.",_trigger getVariable "GroupArray"]};
	_trigger setVariable ["isCleaning",false];
};
_triggerStatements set [1,""];
_trigger setTriggerStatements _triggerStatements;
_trigger call DZAI_updStaticSpawnCount;

if (DZAI_debugLevel > 0) then {diag_log format["DZAI Debug: Spawned %1 new AI groups (%2 units total) in %3 seconds at %4 (spawnBandits).",_numGroups,_totalSpawned,(diag_tickTime - _startTime),(triggerText _trigger)];};

if (_debugMarkers) then {
	_nul = [_trigger] spawn DZAI_updateSpawnMarker;
};

//diag_log format ["DEBUG :: Check original trigger statements: %1",_trigger getVariable "triggerStatements"];

true

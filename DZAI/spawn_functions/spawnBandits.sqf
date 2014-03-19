/*
	spawnBandits
	
	Usage: [_minAI, _addAI, _patrolDist, _trigger, _numGroups (optional)] spawn spawnBandits;
	
	Description: Called through (mapname)_config.sqf when a static trigger is activated by a player.
	
	Last updated: 8:38 AM 10/23/2013
*/

private ["_minAI","_addAI","_patrolDist","_trigger","_equipType","_numGroups","_grpArray","_triggerPos","_totalAI","_spawnPositions","_spawnCount","_positionArray","_locationArray","_startTime","_tMarker","_totalSpawned"];
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

if (count _grpArray > 0) exitWith {if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Active groups found at %1. Exiting spawn script (spawnBandits)",(triggerText _trigger)];};};						

_triggerPos = getPosATL _trigger;
//_gradeChances = [_equipType] call DZAI_getGradeChances;

//If trigger already has defined spawn points, then reuse them instead of recalculating new ones.
_locationArray = _trigger getVariable ["locationArray",[]];	
if ((count _locationArray) == 0) then {
	_spawnPositions = [];
	if ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled}) then {
		_tMarker = createMarker [str(_trigger), (getPosATL _trigger)];
		_tMarker setMarkerText "STATIC TRIGGER (ACTIVE)";
		_tMarker setMarkerType "Defend";
		_tMarker setMarkerColor "ColorRed";
		_tMarker setMarkerBrush "Solid";
		_nul = [_trigger] spawn DZAI_updateSpawnMarker;
	};
	//If no markers specified in position array, then generate spawn points using building positions (search for buildings within 250m. generate a maximum of 150 positions).
	if ((count _positionArray) == 0) then {
		private["_nearbldgs","_spawnPoints"];
		_spawnPoints = 0;
		_nearbldgs = _triggerPos nearObjects ["HouseBase",250];
		if ((count _nearbldgs) > 0) then {
			{
				//if (isClass (configFile >> "CfgBuildingLoot" >> (typeOf _x))) then {
				if !((typeOf _x) in DZAI_ignoredObjects) then {
					_spawnPositions set [(count _spawnPositions),(getPosATL _x)];
					_spawnPoints = _spawnPoints + 1;
				};
				if (_spawnPoints >= 150) exitWith {};
			} forEach _nearbldgs;
		};
		if (DZAI_debugLevel > 1) then {diag_log "DZAI Extended Debug: Spawning AI from building positions (spawnBandits).";};
	} else {
		{
			if ((getMarkerColor _x) != "") then {
				_spawnPositions set [(count _spawnPositions),(getMarkerPos _x)];
				deleteMarker _x;
			};
		} forEach _positionArray;
		if (DZAI_debugLevel > 1) then {diag_log "DZAI Extended Debug: Spawning AI from marker positions (spawnBandits).";};
	};
} else {
	if ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled}) then {
		_tMarker = str (_trigger);
		if ((getMarkerColor _tMarker) == "") then {
			_tMarker = createMarker [_tMarker, (getPosATL _trigger)];
			_tMarker setMarkerText "STATIC TRIGGER (ACTIVE)";
			_tMarker setMarkerType "Defend";
			_tMarker setMarkerColor "ColorRed";
			_tMarker setMarkerBrush "Solid";
		} else {
			_tMarker setMarkerText "STATIC TRIGGER (ACTIVE)";
			_tMarker setMarkerColor "ColorRed";
		};
		_nul = [_trigger] spawn DZAI_updateSpawnMarker;
	};
	//If spawn points are already defined (subsequent trigger activations)
	_spawnPositions = _locationArray;
	if (DZAI_debugLevel > 1) then {diag_log "DZAI Extended Debug: Spawning AI from stored positions (spawnBandits).";};
};

if (DZAI_debugLevel > 0) then {diag_log format["DZAI Debug: Processed static trigger spawn data in %1 seconds (spawnBandits).",(diag_tickTime - _startTime)];};

_startTime = diag_tickTime;

_grpArray = [];
_totalSpawned = 0;

//Spawn groups
for "_j" from 1 to _numGroups do {
	private ["_unitGroup","_spawnPos","_totalAI"];
	_totalAI = (_minAI + round(random _addAI));
	if (_totalAI > 0) then {
		//Select spawn location
		_spawnPos = if ((count _spawnPositions) > 0) then {_spawnPositions call DZAI_findSpawnPos} else {[(getPosATL _trigger),random (_patrolDist),random(360),false] call SHK_pos};
		if ((count _spawnPos) > 0) then {
			//Spawn units
			//_weapongrade = [DZAI_weaponGrades,_gradeChances] call fnc_selectRandomWeighted;
			_weapongrade = _equipType call DZAI_getWeapongrade;
			_unitGroup = [_totalAI,grpNull,_spawnPos,_trigger,_weapongrade] call DZAI_setup_AI;

			//Set group variables
			_unitGroup setVariable ["unitType","static"];
			_unitGroup allowFleeing 0;
			
			//Update AI count
			//DZAI_numAIUnits = DZAI_numAIUnits + _totalAI;
			_totalSpawned = _totalSpawned + _totalAI;
			if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Group %1 has group size %2.",_unitGroup,_totalAI];};
			
			/*if ((count _spawnPositions) >= 100) then {
				//diag_log format ["DEBUG :: Counted %1 spawn positions.",count _spawnPositions];
				_nul = [_unitGroup,_spawnPositions] spawn DZAI_bldgPatrol;
			} else {
				0 = [_unitGroup,_triggerPos,_patrolDist] spawn DZAI_BIN_taskPatrol;
			};*/
			0 = [_unitGroup,_triggerPos,_patrolDist] spawn DZAI_BIN_taskPatrol;
			
			_grpArray set [count _grpArray,_unitGroup];
		} else {
			_nul = [_trigger] spawn DZAI_retrySpawn;
			if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Could not find suitable no-player area for AI group %1 of %2.",_j,_numGroups]};
		};
	} else {
		//Add a group to respawn queue.
		_nul = [_trigger] spawn DZAI_retrySpawn;
		if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: No AI to spawn for AI group %1 of %2.",_j,_numGroups]};
	};
};

if (DZAI_debugLevel > 0) then {diag_log format["DZAI Debug: Spawned %1 new AI groups (%2 units total) in %3 seconds at %4 (spawnBandits).",_numGroups,_totalSpawned,(diag_tickTime - _startTime),(triggerText _trigger)];};

if (!(_trigger getVariable ["initialized",false])) then {
	0 = [_trigger,_grpArray,_patrolDist,_equipType,_spawnPositions,[_minAI,_addAI]] call DZAI_setTrigVars;
} else {
	_trigger setVariable ["GroupArray",_grpArray];
	_trigger setVariable ["isCleaning",false];
	DZAI_actTrigs = DZAI_actTrigs + 1;
};

true

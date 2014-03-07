/*
	respawnBandits
	
	Usage: [_unitGroup,_trigger,_maxUnits] call respawnBandits;
	
	Description: Called internally by fnc_banditAIRespawn. Calls fnc_createAI to respawn a unit near a randomly selected building from a stored reference location.
	
	Last updated: 8:38 AM 10/23/2013
*/

private ["_unitGroup","_trigger","_grpArray","_patrolDist","_equipType","_spawnPositions","_spawnPos","_unit","_pos","_startTime","_maxUnits","_totalAI","_aiGroup","_weapongrade"];
if (!isServer) exitWith {};

_startTime = diag_tickTime;

_unitGroup = _this select 0;
_trigger = _this select 1;
_maxUnits = _this select 2;

_patrolDist = _trigger getVariable ["patrolDist",150];
_equipType = _trigger getVariable ["equipType",1];
_spawnPositions = _trigger getVariable ["locationArray",[]];

_totalAI = ((_maxUnits select 0) + round(random (_maxUnits select 1)));

if (_totalAI == 0) exitWith {
	0 = [_trigger,_unitGroup,true] spawn fnc_respawnHandler;
	false
};

//Select spawn position
_spawnPos = if ((count _spawnPositions) > 0) then {_spawnPositions call DZAI_findSpawnPos} else {[(getPosATL _trigger),random (_patrolDist),random(360),false] call SHK_pos};
if ((count _spawnPos) == 0) exitWith {
	0 = [_trigger,_unitGroup,true] spawn fnc_respawnHandler;
	false
};

//Respawn the group
//_weapongrade = [DZAI_weaponGrades,_gradeChances] call fnc_selectRandomWeighted;
_weapongrade = _equipType call DZAI_getWeapongrade;
_aiGroup = [_totalAI,_unitGroup,_spawnPos,_trigger,_weapongrade] call DZAI_setup_AI;
if (isNull _unitGroup) then {diag_log format ["DZAI Error :: Respawned group was null group. New group reassigned: %1.",_aiGroup]; _unitGroup = _aiGroup};

//Update AI count
//DZAI_numAIUnits = DZAI_numAIUnits + _totalAI;
if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Created group %1 of size %2.",_unitGroup,_totalAI];};

if (_patrolDist > 1) then {
	if ((count (waypoints _unitGroup)) > 1) then {
		_unitGroup setCurrentWaypoint ((waypoints _unitGroup) call BIS_fnc_selectRandom2);
	} else {
		_nul = [_unitGroup,(getPosATL _trigger),_patrolDist] spawn DZAI_BIN_taskPatrol;
	};
};

if (DZAI_debugLevel > 0) then {diag_log format["DZAI Debug: %2 AI units respawned at %3 in %1 seconds (respawnBandits).",diag_tickTime - _startTime,_totalAI,(triggerText _trigger)];};

true

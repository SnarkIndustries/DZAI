/*
	spawnBandits_custom
	
	Usage: 
	
	Description: DZAI custom spawn function (DZAI_spawn).
	
	Last updated: 6:00 PM 10/24/2013
*/

private ["_patrolDist","_trigger","_grpArray","_triggerPos","_equipType","_weapongrade","_totalAI","_startTime","_tMarker"];
if (!isServer) exitWith {};

_startTime = diag_tickTime;

_totalAI = _this select 0;									
//_this select 1;
_patrolDist = _this select 2;								
_trigger = _this select 3;									
_weapongrade = _this select 4;
//_spawnMarker = _this select 5;

_grpArray = _trigger getVariable ["GroupArray",[]];	
if (count _grpArray > 0) exitWith {if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Active groups found at %1. Exiting spawn script (spawnBandits)",(triggerText _trigger)];};};						

_triggerPos = getPosATL _trigger;
if (_totalAI == 0) then {_totalAI = 1};

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

if (DZAI_debugLevel > 0) then {diag_log format["DZAI Debug: Processed static trigger spawn data in %1 seconds (spawnBandits).",(diag_tickTime - _startTime)];};

_startTime = diag_tickTime;

private ["_unitGroup","_spawnPos","_totalAI"];

_spawnPos = [(getPosATL _trigger),random (_patrolDist),random(360),false] call SHK_pos;
_unitGroup = [_totalAI,(createGroup resistance),_spawnPos,_trigger,_weapongrade] call DZAI_setup_AI;

//Set group variables
_unitGroup setVariable ["unitType","static"];
_unitGroup allowFleeing 0;

//Update AI count
//DZAI_numAIUnits = DZAI_numAIUnits + _totalAI;
if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Group %1 has group size %2.",_unitGroup,_totalAI];};

if (_patrolDist > 1) then {
	0 = [_unitGroup,_triggerPos,_patrolDist] spawn DZAI_BIN_taskPatrol;
};

if (DZAI_debugLevel > 0) then {diag_log format["DZAI Debug: Spawned a group of %1 units in %2 seconds at %3 (spawnBandits).",_totalAI,(diag_tickTime - _startTime),(triggerText _trigger)];};

/*_equipType = switch (_weapongrade) do {
	case 0: {[0,1] call BIS_fnc_selectRandom2};
	case 1: {[1,2] call BIS_fnc_selectRandom2};
	case 2: {[2,3] call BIS_fnc_selectRandom2};
	case 3: {3};
	case 4; case 5; case 6; case 7; case 8; case 9: {3};
	case default {[0,1,2,3] call BIS_fnc_selectRandom2};
};*/
_equipType = if (_weapongrade in DZAI_weaponGrades) then {(_weapongrade max 0)} else {3};

0 = [_trigger,[_unitGroup],_patrolDist,_equipType,[],[_totalAI,0]] call DZAI_setTrigVars;

_unitGroup

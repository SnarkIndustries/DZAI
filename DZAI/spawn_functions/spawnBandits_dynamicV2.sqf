/*
	spawnBandits_dynamic

	Usage: Called by an activated dynamic trigger when a player unit enters the trigger area.
	
	Description: Spawns a group of AI units some distance from a dynamically-spawned trigger. These units do not respawn after death.
	
	Last updated: 1:59 AM 11/9/2013
*/

#define CHANCE_LOW 0.50
#define CHANCE_HIGH 1.00

private ["_patrolDist","_trigger","_totalAI","_unitGroup","_targetPlayer","_playerPos","_playerDir","_playerCount","_spawnPos","_startTime","_baseDist","_distVariance","_dirVariance","_spawnChance","_vehPlayer"];
if (!isServer) exitWith {};

_startTime = diag_tickTime;

_patrolDist = _this select 0;
_trigger = _this select 1;
_spawnChance = _this select 2;

if (count (_trigger getVariable ["GroupArray",[]]) > 0) exitWith {if (DZAI_debugLevel > 0) then {diag_log "DZAI Debug: Active groups found. Exiting spawn script (spawnBandits_dynamic)";};};	

_targetPlayer = _trigger getVariable ["targetplayer",objNull];
if (isNull _targetPlayer) exitWith {
	if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Cancelling dynamic spawn for target player. Reason: Player does not exist (logged out?).",name _targetPlayer]};
	_nul = _trigger call DZAI_abortDynSpawn;
	
	false
};

_baseDist = 200;
_distVariance = 50;
_vehPlayer = vehicle _targetPlayer;
if (_vehPlayer isKindOf "Man") then {
	_dirVariance = 100;
	//_distVariance = _distVariance + 50;
} else {
	_dirVariance = 67.5;
	_baseDist = _baseDist - 25;
};

_playerPos = getPosATL _vehPlayer;
_playerDir = getDir _vehPlayer;

_spawnPos = [_playerPos,(_baseDist + random (_distVariance)),[(_playerDir-_dirVariance),(_playerDir+_dirVariance)],false] call SHK_pos;
if ((surfaceIsWater _spawnPos) or {({isPlayer _x} count (_spawnPos nearEntities [["CAManBase"],75])) > 0} or {(_spawnPos in (nearestLocation [_spawnPos,"Strategic"]))}) exitWith {
	if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Canceling dynamic spawn for target player %1.",name _targetPlayer]};
	_nul = _trigger call DZAI_abortDynSpawn;
	
	false
};

/*
	< 25% spawn chance = 1 unit + possibility of 1 more unit. (2 units max)
	50% - 75% spawn chance = 1 unit + possibility of 2 more units. (3 units max)
	> 75% spawn chance = 2 units + possibility of 1 more unit. (3 units max)
*/
_totalAI = switch (true) do {
	case (_spawnChance <= CHANCE_LOW): {1 + floor(random 2)};
	case (_spawnChance > CHANCE_HIGH): {2 + floor(random 2)};
	case default {1 + floor(random 3)};
};

if ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled}) then {
	private["_marker"];
	_marker = format["trigger_%1",_trigger];
	//_marker setMarkerPos _playerPos;
	_marker setMarkerColor "ColorOrange";
	_marker setMarkerAlpha 0.9;				//Dark orange: Activated trigger
};

//Calculate group weapongrade and spawn units
//_weapongrade = [DZAI_weaponGrades,DZAI_gradeChancesDyn] call fnc_selectRandomWeighted;
_weapongrade = DZAI_dynEquipType call DZAI_getWeapongrade;
_unitGroup = [_totalAI,grpNull,_spawnPos,_trigger,_weapongrade] call DZAI_setup_AI;

//Set group variables
_unitGroup setVariable ["unitType","dynamic"];
_unitGroup setBehaviour "AWARE";
_unitGroup setCombatMode "RED";
_unitGroup setSpeedMode "FULL";
_unitGroup allowFleeing 0;
	
//Reveal target player and nearby players to AI, and set group direction to face target player
_unitGroup setFormDir ([(leader _unitGroup),_vehPlayer] call BIS_fnc_dirTo);
_unitGroup reveal [_vehPlayer,4];
(units _unitGroup) doTarget _vehPlayer;
(units _unitGroup) doFire _vehPlayer;

//Update AI count
//DZAI_numAIUnits = DZAI_numAIUnits + _totalAI;
if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Group %1 has group size %2.",_unitGroup,_totalAI];};


//Begin hunting player
0 = [_unitGroup,_spawnPos,_patrolDist,_targetPlayer,getPosATL _trigger] spawn DZAI_dyn_huntPlayer;

if (DZAI_debugLevel > 0) then {
	diag_log format["DZAI Debug: Spawned 1 new AI groups of %1 units each in %2 seconds at %3 (spawnBandits_dynamic).",_totalAI,(diag_tickTime - _startTime),(mapGridPosition _trigger)];
};

0 = [_trigger,[_unitGroup]] call DZAI_setTrigVars; //set dynamic trigger variables and create dynamic area blacklist

true

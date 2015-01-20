
private ["_patrolDist","_trigger","_totalAI","_unitGroup","_targetPlayer","_playerPos","_playerDir","_spawnPos","_startTime","_baseDist","_extraDist","_distVariance","_dirVariance","_behavior","_triggerStatements","_spawnDist","_thisList","_debugMarkers"];
if (!isServer) exitWith {};

_startTime = diag_tickTime;

_patrolDist = _this select 0;
_trigger = _this select 1;
_thisList = _this select 2;

//Calculate group weapongrade and spawn units
_weapongrade = DZAI_dynEquipType call DZAI_getWeapongrade;
_totalAI = call {
	if (_weapongrade == 0) exitWith {2 + floor (random 2)}; //2-3 units
	if (_weapongrade == 1) exitWith {1 + floor (random 2)};	//1-2 units
	if (_weapongrade == 2) exitWith {1 + floor (random 2)}; //1-2 units
	if (_weapongrade == 3) exitWith {1};	//1 unit
	1
};

_checkArea = true;
_nearAttempts = 1;
_spawnPos = [0,0,0];
_debugMarkers = ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled});
_baseDist = 0;
_extraDist = 400;

{
	if (isPlayer _x) exitWith {
		_playerPos = getPosASL _x;
		if (count ((nearestLocations [_playerPos, ["Strategic"], 600])) < 2) then { //< 2: Don't count the Strategic area assigned to this spawn
			_trigger setPosASL _playerPos;
			_baseDist = 175;
			_extraDist = 225;
			if (_debugMarkers) then {
				(str (_trigger)) setMarkerPos _playerPos;
			};
		};
	};
} forEach _thisList;

_triggerPos = getPosASL _trigger;

while {_checkArea && {_nearAttempts < 4}} do {
	_spawnPos = [_triggerPos,(_baseDist + (random _extraDist)),(random 360),0] call SHK_pos;
	_checkArea = ({isPlayer _x} count (_spawnPos nearEntities [["CAManBase","Land"], 175]) > 0);
	_nearAttempts = _nearAttempts + 1;
};

if (_nearAttempts > 3) exitWith {_nul = _trigger call DZAI_abortRandSpawn};

_unitGroup = [_totalAI,grpNull,_spawnPos,_trigger,_weapongrade] call DZAI_setup_AI;

//Set group variables
_unitGroup setVariable ["unitType","randomspawn"];
_unitGroup setBehaviour "AWARE";
_unitGroup setSpeedMode "FULL";
_unitGroup allowFleeing 0;

0 = [_unitGroup,_triggerPos,_patrolDist] spawn DZAI_BIN_taskPatrol;

if (DZAI_debugLevel > 0) then {
	diag_log format["DZAI Debug: Spawned 1 new AI groups of %1 units each in %2 seconds at %3 (Random Spawn).",_totalAI,(diag_tickTime - _startTime),(mapGridPosition _trigger)];
};

_triggerStatements = (triggerStatements _trigger);
if (!(_trigger getVariable ["initialized",false])) then {
	0 = [2,_trigger,[_unitGroup]] call DZAI_setTrigVars;
	_trigger setVariable ["triggerStatements",+_triggerStatements];
};
_triggerStatements set [1,""];
_trigger setTriggerStatements _triggerStatements;
//[_trigger,"DZAI_randTriggerArray"] call DZAI_updateSpawnCount;

if (_debugMarkers) then {
	_nul = _trigger spawn {
		_marker = str(_this);
		_marker setMarkerColor "ColorOrange";
		_marker setMarkerAlpha 0.9;				//Dark orange: Activated trigger
	};
};

true

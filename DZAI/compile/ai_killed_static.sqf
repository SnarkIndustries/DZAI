/*
	fnc_staticAIDeath

	Usage: [_victim,_killer,_unitGroup] call DZAI_AI_killed_static;
	
	Description: Script is called when an AI unit is killed, and waits for the specified amount of time before respawning the unit into the same group it was part of previously.
	If the killed unit was the last surviving unit of its group, a dummy AI unit is created to occupy the group until a dead unit in the group is respawned.
*/

private ["_victim","_killer","_unitGroup","_trigger","_dummy","_unitsAlive"];

_victim = _this select 0;
_killer = _this select 1;
_unitGroup = _this select 2;
_unitsAlive = _this select 3;

_trigger = _unitGroup getVariable ["trigger",DZAI_defaultTrigger];

if (_unitsAlive == 0) then {
	if (_trigger getVariable ["respawn",true]) then {
		_dummy = _unitGroup call DZAI_protectGroup;
		_respawnCount = _trigger getVariable ["respawnLimit",-1];
		if (_respawnCount != 0) then {
			//If there are still respawns possible...
			[0,_trigger,_unitGroup] call fnc_respawnHandler;
			if (_respawnCount > -1) then {
				//If respawns are limited, decrease respawn counter
				_trigger setVariable ["respawnLimit",(_respawnCount - 1)];
				if (DZAI_debugLevel > 0) then {diag_log format["DZAI Debug: Respawns remaining for group %1: %2.",_unitGroup,(_unitGroup getVariable ["respawnLimit",-1])];};
			};
		} else {
			_trigger setVariable ["permadelete",true];	//deny respawn and delete trigger on next despawn.
		};
		if (DZAI_debugLevel > 1) then {diag_log format["DZAI Extended Debug: All units in group %1 killed, spawned 1 dummy AI unit for group.",_unitGroup];};
	} else {
		if ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled}) then {deleteMarker str(_trigger)};
		{deleteGroup _x} forEach (_trigger getVariable ["GroupArray",[]]);
		deleteMarker (_trigger getVariable ["spawnmarker",""]);
		_trigger call DZAI_updStaticSpawnCount;
		if (DZAI_debugLevel > 0) then {diag_log format["DZAI Debug: Deleting custom-defined AI spawn %1 at %2.",triggerText _trigger, mapGridPosition _trigger];};
		deleteVehicle _trigger;
	};
} else {
	if (!(_trigger getVariable ["respawn",true])) then {
		_maxUnits = _trigger getVariable ["maxUnits",[0,0]];
		_maxUnits set [0,(_maxUnits select 0) - 1];
		if (DZAI_debugLevel > 1) then {diag_log format["DZAI Extended Debug: MaxUnits variable for group %1 set to %2.",_unitGroup,_maxUnits];};
	};
};

true

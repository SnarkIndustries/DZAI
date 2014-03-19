/*
	fnc_staticAIDeath

	Usage: [_victim,_killer,_unitGroup] spawn DZAI_AI_killed_static;
	
	Description: Script is called when an AI unit is killed, and waits for the specified amount of time before respawning the unit into the same group it was part of previously.
	If the killed unit was the last surviving unit of its group, a dummy AI unit is created to occupy the group until a dead unit in the group is respawned.
	
	Last updated: 10:42 PM 1/11/2014
*/

private ["_victim","_killer","_sleepTime","_unitGroup","_trigger","_dummy","_unitsAlive"];

_victim = _this select 0;
_killer = _this select 1;
_unitGroup = _this select 2;

_trigger = _unitGroup getVariable "trigger";
_unitsAlive = {alive _x} count (units _unitGroup);
//diag_log format ["%1 units alive in group.",_unitsAlive];

if (!(_trigger getVariable ["respawn",true])) then {
	private ["_maxUnits"];
	_maxUnits = _trigger getVariable "maxUnits";
	_maxUnits set [0,(_maxUnits select 0) - 1];
	if (DZAI_debugLevel > 1) then {diag_log format["DZAI Extended Debug: MaxUnits variable for group %1 set to %2. (fnc_staticAIDeath)",_unitGroup,_maxUnits];};
};

if (_unitsAlive == 0) then {
	if (_trigger getVariable ["respawn",true]) then {
		_unitGroup setBehaviour "AWARE";
		_dummy = _unitGroup createUnit ["Survivor1_DZ",[0,0,0],[],0,"FORM"];
		[_dummy] joinSilent _unitGroup;
		_dummy setVehicleInit "this hideObject true;this allowDamage false;this enableSimulation false;"; processInitCommands;
		_dummy disableAI "FSM";
		_dummy disableAI "ANIM";
		_dummy disableAI "MOVE";
		_dummy disableAI "TARGET";
		_dummy disableAI "AUTOTARGET";
		_dummy setVariable ["unconscious",true]; //prevent radio messages if dummy is group leader
		_unitGroup setVariable ["dummyUnit",_dummy];
		if (DZAI_debugLevel > 1) then {diag_log format["DZAI Extended Debug: Spawned 1 dummy AI unit for group %1. (fnc_staticAIDeath)",_unitGroup];};
		
		0 = [_trigger,_unitGroup] spawn fnc_respawnHandler;
	} else {
		if ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled}) then {deleteMarker str(_trigger)};
		if (DZAI_debugLevel > 0) then {diag_log format["DZAI Debug: Deleting custom-defined AI spawn %1 at %2. (fnc_staticAIDeath)",triggerText _trigger, mapGridPosition _trigger];};
		{
			if ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled}) then {
				{
					private["_markername"];
					_markername = (str _x);
					deleteMarker _markername;
				} forEach (waypoints _x);
				sleep 0.1;
			};
			sleep 0.5;
			deleteGroup _x;
		} forEach (_trigger getVariable ["GroupArray",[]]);
		deleteMarker (_trigger getVariable ["spawnmarker",""]);
		deleteVehicle _trigger;
		DZAI_actTrigs = DZAI_actTrigs - 1;
	};
} else {
	if (isPlayer _killer) then {
		_unitGroup reveal [vehicle _killer,4];
		_unitGroup setFormDir ([(leader _unitGroup),_killer] call BIS_fnc_dirTo);
		(units _unitGroup) doTarget (vehicle _killer);
		(units _unitGroup) doFire (vehicle _killer);
		if (DZAI_findKiller) then {_unitGroup setBehaviour "AWARE"; 0 = [_trigger,_killer,_unitGroup,300] spawn DZAI_huntKiller} else {_unitGroup setBehaviour "COMBAT"};
	};
};

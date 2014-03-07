/*
	fnc_dynAIDeath
	
	Description: Begins force despawn for dynamic AI when the entire group has been killed.
	
	Usage: [_victim,_unitGroup] spawn DZAI_AI_killed_dynamic;
	
	Last Updated: 3:16 PM 1/12/2014
*/

private ["_victim","_killer","_unitsAlive","_trigger","_unitGroup","_dummy"];

_victim = _this select 0;
_killer = _this select 1;
_unitGroup = _this select 2;

_trigger = _unitGroup getVariable "trigger";
_unitsAlive = {alive _x} count (units _unitGroup);

//If all units in the group have died, create dummy AI unit to preserve group, then begin force despawn process.
if (_unitsAlive == 0) then {
	[_trigger,true] spawn fnc_despawnBandits_dynamic;	//force despawning even if players are present in trigger area.
	if (DZAI_debugLevel > 0) then {diag_log format["DZAI Debug: All groups spawned by trigger %1 are dead. Starting force respawn. (fnc_dynAIDeath).",_trigger];};
} else {
	if (isPlayer _killer) then {
		_unitGroup reveal [vehicle _killer,4];
		_unitGroup setFormDir ([(leader _unitGroup),_killer] call BIS_fnc_dirTo);
		(units _unitGroup) doTarget (vehicle _killer);
		(units _unitGroup) doFire (vehicle _killer);
		if (DZAI_findKiller && {!(_unitGroup getVariable ["seekActive",false])}) then {_unitGroup setBehaviour "AWARE"; 0 = [_trigger,_killer,_unitGroup,150] spawn DZAI_huntKiller} else {_unitGroup setBehaviour "COMBAT"};
	};
	if (DZAI_debugLevel > 0) then {diag_log format["DZAI Debug: AI group %1 killed, %2 units left alive in group. (fnc_dynAIDeath).",_unitGroup,_unitsAlive];};
};

true

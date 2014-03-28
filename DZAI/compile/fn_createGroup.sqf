/*
	fnc_createGroup
	
	Description: Spawns a group of AI units. Used for spawning of DZAI's static, dynamic, and custom AI units.
	
	_totalAI = Number of AI units to spawn in the group
	_spawnPos: Position to create AI unit.
	_trigger: The trigger object responsible for spawning the AI unit.
	_weapongrade: weapongrade to be used for generating equipment. Influences weapon quality and skill level.
	
	Last updated: 6:20 PM 3/28/2014
	
*/
private ["_totalAI","_spawnPos","_unitGroup","_trigger","_attempts","_baseDist","_dummy","_weapongrade"];
if (!isServer) exitWith {};
	
_totalAI = _this select 0;
_spawnPos = _this select 2;
_trigger = _this select 3;
_weapongrade = _this select 4;

_pos = [];
_attempts = 0;
_baseDist = 25;

while {((count _pos) < 1) && {(_attempts < 3)}} do {
	_pos = _spawnPos findEmptyPosition [0.5,_baseDist,"Misc_cargo_cont_small_EP1"];
	if ((count _pos) > 1) then {
		_pos = _pos isFlatEmpty [0,0,0.75,5,0,false,ObjNull];
	}; 
	if ((count _pos) < 1) then {
		_baseDist = (_baseDist + 25);	_attempts = (_attempts + 1);
	};
};

if ((count _pos) < 1) then {
	_pos = [_trigger,random (125),random(360),false] call SHK_pos;
	_attempts = (_attempts + 1);
};

_pos set [2,0];

if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Found spawn position at %3 meters away at position %1 after %2 retries.",_pos,_attempts,(_pos distance _spawnPos)]};

_unitGroup = if (isNull (_this select 1)) then {createGroup (call DZAI_getFreeSide)} else {_this select 1};
for "_i" from 1 to _totalAI do {
	private ["_type","_unit","_name"];
	_type = DZAI_BanditTypes call BIS_fnc_selectRandom2;								// Select skin of AI unit
	_unit = _unitGroup createUnit [_type, _pos, [], 0, "FORM"];							// Spawn the AI unit
	_unit setPosATL _pos;
	[_unit] joinSilent _unitGroup;														// Add AI unit to group

	_unit setVariable ["bodyName",(name _unit)];										// Set unit body name
	_unit setVariable ["unithealth",[(10000 + (random 2000)),0,false]];					// Set unit health (blood, legs health, legs broken)
	_unit setVariable ["unconscious",false];											// Set unit consciousness

	if (DZAI_weaponNoise) then {
		_unit addEventHandler ["Fired", {_this call ai_fired;}];};						// Unit firing causes zombie aggro in the area, like player.
	if (isNil "DDOPP_taser_handleHit") then {
		_unit addEventHandler ["HandleDamage",{_this call DZAI_AI_handledamage}];
	} else {
		_unit addEventHandler ["HandleDamage",{_this call DDOPP_taser_handleHit;_this call DZAI_AI_handledamage}];
	};

	0 = [_unit, _weapongrade] call DZAI_setupLoadout;									// Assign unit loadout
	0 = [_unit, _weapongrade] call DZAI_setSkills;										// Set AI skill
	0 = [_unit, _weapongrade] spawn DZAI_autoRearm_unit;
	if (DZAI_debugLevel > 1) then {diag_log format["DZAI Extended Debug: Spawned AI Type %1 with weapongrade %2 for group %3 (fnc_createGroup).",_type,_weapongrade,_unitGroup];};
};

//Delete dummy if it exists, and clear group's "dummy" variable.
_dummy = _unitGroup getVariable "dummyUnit";
if (!isNil "_dummy") then {
	[_dummy] joinSilent grpNull;
	deleteVehicle _dummy;
	_unitGroup setVariable ["dummyUnit",nil];
	if (DZAI_debugLevel > 1) then {diag_log format["DZAI Extended Debug: Deleted 1 dummy AI unit for group %1. (fnc_createGroup)",_unitGroup];};
};

_unitGroup selectLeader ((units _unitGroup) select 0);
_unitGroup setVariable ["trigger",_trigger];
_unitGroup setVariable ["GroupSize",_totalAI];
if (isNull _trigger) then {_unitGroup setVariable ["spawnPos",_spawnPos]};
//DZAI_numAIUnits = DZAI_numAIUnits + _totalAI;
(DZAI_numAIUnits + _totalAI) call DZAI_updateUnitCount;

_unitGroup

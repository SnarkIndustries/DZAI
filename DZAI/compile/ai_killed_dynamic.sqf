/*
	fnc_dynAIDeath
	
	Description: Begins force despawn for dynamic AI when the entire group has been killed.
	
	Usage: [_victim,_unitGroup] spawn DZAI_AI_killed_dynamic;
	
	Last Updated: 10:33 PM 5/14/2014
*/

private ["_victim","_killer","_unitsAlive","_trigger","_unitGroup","_dummy"];

_victim = _this select 0;
_killer = _this select 1;
_unitGroup = _this select 2;
_unitsAlive = _this select 3;

_trigger = _unitGroup getVariable ["trigger",DZAI_defaultTrigger];
if (_unitsAlive == 0) then {
	[_trigger,true] spawn fnc_despawnBandits_dynamic;	//force despawning even if players are present in trigger area.
	if (DZAI_debugLevel > 0) then {diag_log format["DZAI Debug: Group %1 spawned by trigger %1 are dead. Starting force despawn. (fnc_dynAIDeath).",_unitGroup,_trigger];};
};

true

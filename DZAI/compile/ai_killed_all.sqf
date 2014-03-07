/*
		fnc_banditAIKilled
		
		Description: Adds loot to AI corpse if killed by a player. Script is shared between AI spawned from static and dynamic triggers.
		
        Usage: [_victim,_killer,_unitGroup] call DZAI_AI_killed_all;
		
		Last updated: 10:42 PM 1/11/2014
*/

private["_victim","_killer","_unitGroup","_groupSize"];
_victim = _this select 0;
_killer = _this select 1;
_unitGroup = _this select 2;

//Update AI count
_groupSize = _unitGroup getVariable "GroupSize";
_groupSize = _groupSize - 1;
DZAI_numAIUnits = DZAI_numAIUnits - 1;
_unitGroup setVariable ["GroupSize",_groupSize];
if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Group %1 has group size: %2.",_unitGroup,_groupSize];};

if (isPlayer _killer) then {
	private ["_trigger","_equipType","_weapongrade"];

	_trigger = _unitGroup getVariable ["trigger",objNull];
	_equipType = if (!isNil "_trigger") then {_trigger getVariable ["equipType",1]} else {1};
	_weapongrade = _equipType call DZAI_getWeapongrade;
	0 = [_victim,_weapongrade] spawn DZAI_addLoot;
	0 = [_killer,_victim,"banditKills"] call DZAI_countKills;
} else {
	if (_killer == _victim) then {
		removeAllWeapons _victim;
	} else {
		{
			_victim removeMagazines _x;
		} forEach (magazines _victim);
	};
};

if !((_victim getVariable ["CanGivePistol",true]) && {(_victim getVariable ["unconscious",false])}) then {
	private ["_anim"];
	_anim = if ((animationState _victim) in ["amovppnemrunsnonwnondf","amovppnemstpsnonwnondnon","amovppnemstpsraswrfldnon","amovppnemsprslowwrfldf","aidlppnemstpsnonwnondnon0s","aidlppnemstpsnonwnondnon01"]) then {"adthppnemstpsraswpstdnon_2"} else {"adthpercmstpslowwrfldnon_4"};
	_nul = [objNull, _victim, rSWITCHMOVE, _anim] call RE; 
};

true

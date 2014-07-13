/*
		DZAI_unitDeath
		
		Description: Called when AI unit blood level drops below zero to process unit death.
		
        Usage: [_unit,_killer] call DZAI_unitDeath;
		
		Last updated: 7:09 PM 12/15/2013
*/

private["_victim","_killer","_unitGroup","_unitType","_launchWeapon","_launchAmmo","_deathType"];
_victim = _this select 0;
_killer = _this select 1;
_deathType = if ((count _this) > 2) then {_this select 2} else {"bled"};

if (_victim getVariable ["deathhandled",false]) exitWith {};
_victim setVariable ["deathhandled",true];
_victim setDamage 1;
_victim removeAllEventHandlers DZAI_healthType;

if (_deathType == "shothead") then { //no need for isplayer check since "shothead" is only possible if killer is a player
	_nul = _killer spawn {
		_headshots = _this getVariable["headShots",0];
		_headshots = _headshots + 1;
		_this setVariable["headShots",_headshots,true];
	};
};

_unitGroup = (group _victim);
_unitsAlive = ({alive _x} count (units _unitGroup));
_unitGroup setVariable ["GroupSize",((_unitGroup getVariable ["GroupSize",0]) - 1)];
_unitType = _unitGroup getVariable ["unitType",""];
call {
	if (_unitType == "static") exitWith {
		[_victim,_killer,_unitGroup,_unitsAlive] call DZAI_AI_killed_static;
		0 = [_victim,_killer,_unitGroup,_unitType,_unitsAlive] call DZAI_AI_killed_all;
		DZAI_numAIUnits = DZAI_numAIUnits - 1;
	};
	if (_unitType == "dynamic") exitWith {
		[_victim,_killer,_unitGroup,_unitsAlive] call DZAI_AI_killed_dynamic;
		0 = [_victim,_killer,_unitGroup,_unitType,_unitsAlive] call DZAI_AI_killed_all;
		DZAI_numAIUnits = DZAI_numAIUnits - 1;
	};
	if (_unitType in ["air","aircustom"]) exitWith {
		[_victim,_unitGroup] call DZAI_AI_killed_air;
	};
	if (_unitType in ["land","landcustom"]) exitWith {
		0 = [_victim,_killer,_unitGroup,_unitType] call DZAI_AI_killed_all;
		if (_unitsAlive == 0) then {
			[_unitGroup] call DZAI_AI_killed_land;
		};
	};
	if (_unitType == "aircrashed") exitWith {};
	//Default case starts here
	if (_unitsAlive == 0) then {
		_nul = [_unitGroup,30] spawn DZAI_deleteGroupTimed;
	};
};

_launchWeapon = (secondaryWeapon _victim);
if (_launchWeapon in DZAI_launcherTypes) then {
	_launchAmmo = getArray (configFile >> "CfgWeapons" >> _launchWeapon >> "magazines") select 0;
	_victim removeWeapon _launchWeapon;
	_victim removeMagazines _launchAmmo;
	//if (_launchWeapon in (weapons _victim)) then {diag_log format ["Warning: Unable to remove launcher weapon %1 from unit %2.",_launchWeapon,_victim]};
	//if (_launchAmmo in (magazines _victim)) then {diag_log format ["Warning: Unable to remove launcher ammo %1 from unit %2.",_launchWeapon,_victim]};
	//if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Removed launcher weapon %1 and ammo %2 from unit %3.",_launchWeapon,_launchAmmo,_victim]};
};

if (_victim getVariable ["removeNVG",true]) then {
	_victim removeWeapon "NVGoggles";
};

_victim spawn DZAI_deathFlies;
_victim setVariable ["bodyName",_victim getVariable ["bodyName","unknown"],true];		//Broadcast the unit's name (was previously a private variable).
_victim setVariable ["deathType",_deathType,true];
_victim setVariable ["DZAI_deathTime",(diag_tickTime + DZAI_cleanupDelay)];
_victim setVariable ["unconscious",true];

_victim

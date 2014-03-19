/*
		DZAI_unitDeath
		
		Description: Called when AI unit blood level drops below zero to process unit death.
		
        Usage: [_unit,_killer] call DZAI_unitDeath;
		
		Last updated: 7:09 PM 12/15/2013
*/

private["_victim","_killer","_unitGroup","_unitType","_launchWeapon","_deathType"];
_victim = _this select 0;
_killer = _this select 1;
_deathType = if ((count _this) > 2) then {_this select 2} else {"bled"};

if ((isPlayer _killer) && {(_deathType == "shothead")}) then {
	_nul = _killer spawn {
		_headshots = _this getVariable["headShots",0];
		_headshots = _headshots + 1;
		_this setVariable["headShots",_headshots,true];
	};
};

if (_victim getVariable ["deathhandled",false]) exitWith {};
_victim setVariable ["deathhandled",true];
_victim setDamage 1;
_victim removeAllEventHandlers "HandleDamage";

_unitGroup = (group _victim);
_unitType = _unitGroup getVariable ["unitType","unknown"];
switch (_unitType) do {
	case "static":
	{
		[_victim,_killer,_unitGroup] spawn DZAI_AI_killed_static;
	};
	case "dynamic":
	{
		[_victim,_killer,_unitGroup] spawn DZAI_AI_killed_dynamic;
	};
	case "air": 
	{
	};
	case "land":
	{
	};
	case default {
		if ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled}) then {
			if (({alive _x} count (units _unitGroup)) == 0) then {
				{
					deleteMarker (str _x);
				} forEach (waypoints _unitGroup);
			};
		};
	};
};

if (_unitType in ["static","dynamic","unknown"]) then {
	0 = [_victim,_killer,_unitGroup] call DZAI_AI_killed_all;
};

if ((_victim getVariable ["removeNVG",0]) == 1) then {
	_victim removeWeapon "NVGoggles";
};

_launchWeapon = (secondaryWeapon _victim);
if (_launchWeapon in DZAI_launcherTypes) then {
	_launchAmmo = getArray (configFile >> "CfgWeapons" >> _launchWeapon >> "magazines") select 0;
	_victim removeMagazines _launchAmmo;
	_victim removeWeapon _launchWeapon;
};

_victim spawn DZAI_deathFlies;
_victim setVariable ["bodyName",_victim getVariable ["bodyName","unknown"],true];		//Broadcast the unit's name (was previously a private variable).
_victim setVariable ["deathType",_deathType,true];
_victim setVariable ["DZAI_deathTime",(time + DZAI_cleanupDelay)];
_victim setVariable ["unconscious",true];

//diag_log format ["DEBUG :: AI %1 (Group %2) killed by %3",_victim,_unitGroup,_killer];

_victim

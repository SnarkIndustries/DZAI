/*
		DZAI_unitDeath
		
		Description: Called when AI unit blood level drops below zero to process unit death.
		
        Usage: [_unit,_killer] call DZAI_unitDeath;
*/

private["_coins","_values","_victim","_killer","_unitGroup","_unitType","_launchWeapon","_launchAmmo","_deathType","_groupIsEmpty","_unitsAlive","_vehicle","_groupSize"];

_victim = _this select 0;
_killer = _this select 1;
_deathType = if ((count _this) > 2) then {_this select 2} else {"bled"};

if (_victim getVariable ["deathhandled",false]) exitWith {};
_victim setVariable ["deathhandled",true];

_vehicle = (vehicle _victim);
_unitGroup = (group _victim);

_victim setDamage 1;
_victim removeAllEventHandlers DZAI_healthType;

//Check number of units alive, preserve group immediately if empty.
_unitsAlive = ({alive _x} count (units _unitGroup));
_groupIsEmpty = if (_unitsAlive == 0) then {_unitGroup call DZAI_protectGroup; true} else {false};

//Update group size counter
_groupSize = (_unitGroup getVariable ["GroupSize",0]);
if (_groupSize > 0) then {_unitGroup setVariable ["GroupSize",(_groupSize - 1)]};

//Retrieve group type
_unitType = _unitGroup getVariable ["unitType",""];

call {
	if (_unitType == "static") exitWith {
		[_victim,_killer,_unitGroup,_groupIsEmpty] call DZAI_AI_killed_static;
		0 = [_victim,_killer,_unitGroup,_unitType,_unitsAlive] call DZAI_AI_killed_all;
	};
	if (_unitType == "dynamic") exitWith {
		[_victim,_killer,_unitGroup,_groupIsEmpty] call DZAI_AI_killed_dynamic;
		0 = [_victim,_killer,_unitGroup,_unitType,_unitsAlive] call DZAI_AI_killed_all;
	};
	if (_unitType == "randomspawn") exitWith {
		[_victim,_killer,_unitGroup,_groupIsEmpty] call DZAI_AI_killed_random;
		0 = [_victim,_killer,_unitGroup,_unitType,_unitsAlive] call DZAI_AI_killed_all;
	};
	if (_unitType in ["air","aircustom"]) exitWith {
		[_victim,_unitGroup] call DZAI_AI_killed_air;
	};
	if (_unitType in ["land","landcustom"]) exitWith {
		0 = [_victim,_killer,_unitGroup,_unitType] call DZAI_AI_killed_all;
		[_victim,_unitGroup,_groupIsEmpty] call DZAI_AI_killed_land;
	};
	if (_unitType == "aircrashed") exitWith {};
	if (_groupIsEmpty) then {
		_unitGroup setVariable ["GroupSize",-1];
	};
};

if !(isNull _victim) then {
	_launchWeapon = (secondaryWeapon _victim);
	if (_launchWeapon in DZAI_launcherTypes) then {
		_launchAmmo = getArray (configFile >> "CfgWeapons" >> _launchWeapon >> "magazines") select 0;
		_victim removeWeapon _launchWeapon;
		_victim removeMagazines _launchAmmo;
	};

	if (_deathType == "shothead") then { //no need for isplayer check since "shothead" is only possible if killer is a player
		_nul = _killer spawn {
			_headshots = _this getVariable ["headShots",0];
			_headshots = _headshots + 1;
			_this setVariable ["headShots",_headshots,true];
		};
	};

	if (_victim getVariable ["removeNVG",true]) then {
		_victim removeWeapon "NVGoggles";
	};

	_victim spawn DZAI_deathFlies;
	_bodyName = _victim getVariable ["bodyName","unknown"];
	_victim setVariable ["bodyName",_bodyName];
	_victim setVariable ["deathType",_deathType,true];
	_victim setVariable ["DZAI_deathTime",diag_tickTime];
	_victim setVariable ["unconscious",true];
	
	if (Z_SingleCurrency && {DZAI_hasCoins select 0}) then {
		_values = DZAI_hasCoins select 1;
		_coins = ceil(random (_values select 1)) max (_values select 0);
		_victim setVariable ["cashMoney",_coins,true];
	};	
	
	if (_vehicle == (_unitGroup getVariable ["assignedVehicle",objNull])) then {
		_victim setPosASL (getPosASL _victim);
	};
	if ((combatMode _unitGroup) == "BLUE") then {_unitGroup setCombatMode "RED"};
	//[_victim] joinSilent grpNull;
	if (DZAI_deathMessages && {isPlayer _killer}) then {
		_nul = [_killer,_bodyName] spawn DZAI_sendKillMessage;
	};
};

_victim

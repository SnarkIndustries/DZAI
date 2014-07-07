/*
		DZAI_heliDestroyed
		
		Description: Called when AI air vehicle is destroyed by collision damage.
		
		Last updated: 12:11 AM 6/17/2014
*/

private ["_helicopter","_unitGroup","_units","_weapongrade"];
_helicopter = _this select 0;

if (_helicopter getVariable ["heli_disabled",false]) exitWith {false};
_helicopter setVariable ["heli_disabled",true];
{_helicopter removeAllEventHandlers _x} count ["HandleDamage","GetOut","Killed"];
_unitGroup = _helicopter getVariable "unitGroup";
[_unitGroup,_helicopter] call DZAI_respawnAIVehicle;

_units = (units _unitGroup);
if !(surfaceIsWater (getPosASL _helicopter)) then {
	_weapongrade = _unitGroup getVariable ["weapongrade",1];
	_unitGroup setVariable ["unitType","aircrashed"];	//Recategorize group as "aircrashed" to prevent AI inventory from being cleared since death is considered suicide.
	{
		_x action ["eject",_helicopter];
		_nul = [_x,_x] call DZAI_unitDeath;
		0 = [_x,_weapongrade] spawn DZAI_addLoot;
	} count _units;
	_units joinSilent grpNull;
} else {
	{
		deleteVehicle _x;
	} count _units;
};
deleteGroup _unitGroup;

//_helicopter setVariable ["DZAI_deathTime",diag_tickTime+900];
if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: AI helicopter patrol destroyed at %1",mapGridPosition _helicopter];};

true

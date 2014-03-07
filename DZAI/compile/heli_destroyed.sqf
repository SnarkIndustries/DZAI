/*
		DZAI_heliDestroyed
		
		Description: Called when AI air vehicle is destroyed by collision damage.
		
		Last updated: 1:49 PM 12/18/2013
*/

private ["_helicopter","_unitGroup"];
_helicopter = _this select 0;

if (_helicopter getVariable ["heli_disabled",false]) exitWith {};
_helicopter setVariable ["heli_disabled",true];

_unitGroup = _helicopter getVariable "unitGroup";
_helicopter removeAllEventHandlers "GetOut";
_helicopter removeAllEventHandlers "HandleDamage";
_helicopter removeAllEventHandlers "Killed";

{
	if (alive _x) then {
		deleteVehicle _x;
	};
} forEach (units _unitGroup);

deleteGroup _unitGroup;
DZAI_curHeliPatrols = DZAI_curHeliPatrols - 1;

if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: AI helicopter patrol destroyed at %1",mapGridPosition _helicopter];};
0 = ["air"] spawn fnc_respawnHandler;
[_helicopter,900] call DZAI_deleteObject;

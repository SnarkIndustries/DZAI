/*
		DZAI_vehDestroyed
		
		Description: Called when AI land vehicle is destroyed
		
*/

private ["_vehicle","_unitGroup"];
_vehicle = _this select 0;

if (_vehicle getVariable ["veh_disabled",false]) exitWith {};
_vehicle setVariable ["veh_disabled",true];

_unitGroup = _vehicle getVariable "unitGroup";
_vehicle removeAllEventHandlers "GetOut";
//_vehicle removeAllEventHandlers "HandleDamage";
_vehicle removeAllEventHandlers "Killed";

{
	if (alive _x) then {
		deleteVehicle _x;
	};
} forEach (units _unitGroup);

deleteGroup _unitGroup;
DZAI_curLandPatrols = DZAI_curLandPatrols - 1;

if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: AI land vehicle patrol destroyed at %1",mapGridPosition _vehicle];};
0 = ["land"] spawn fnc_respawnHandler;
[_vehicle,900] call DZAI_deleteObject;

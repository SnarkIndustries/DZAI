private ["_vehicle","_unitGroup"];

_unitGroup = _this select 0;

_vehicle = _unitGroup getVariable ["assignedVehicle",objNull];
if (_vehicle isKindOf "LandVehicle") then {
	{_vehicle removeAllEventHandlers _x} count ["HandleDamage","Killed"];
	[_unitGroup,_vehicle] call DZAI_respawnAIVehicle;
	_vehicle setVariable ["DZAI_deathTime",diag_tickTime+900];
	if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: AI vehicle patrol destroyed, adding vehicle %1 to cleanup queue.",(typeOf _vehicle)];};
};

true

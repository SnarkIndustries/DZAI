private ["_victim","_vehicle","_unitGroup","_groupIsEmpty"];

_victim = _this select 0;
_unitGroup = _this select 1;
_groupIsEmpty = _this select 2;

_vehicle = _unitGroup getVariable ["assignedVehicle",objNull];
if (_groupIsEmpty) then {
	if (_vehicle isKindOf "LandVehicle") then {
		{_vehicle removeAllEventHandlers _x} count ["HandleDamage","Killed"];
		[_unitGroup,_vehicle] call DZAI_respawnAIVehicle;
		if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: AI vehicle patrol destroyed, adding vehicle %1 to cleanup queue.",(typeOf _vehicle)];};
	};
	_unitGroup setVariable ["GroupSize",-1];
} else {
	if (_victim getVariable ["isDriver",false]) then {
		_groupUnits = (units _unitGroup) - [_victim];
		_newDriver = _groupUnits call BIS_fnc_selectRandom2;	//Find another unit to serve as driver
		if (!isNil "_newDriver") then {
			_nul = [_newDriver,_vehicle] spawn {
				private ["_newDriver","_vehicle"];
				_newDriver = _this select 0;
				_vehicle = _this select 1;
				unassignVehicle _newDriver;
				_newDriver assignAsDriver _vehicle;
				if (_newDriver in _vehicle) then {
					_newDriver moveInDriver _vehicle;
				};
				[_newDriver] orderGetIn true;
				_newDriver setVariable ["isDriver",true];
				if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Replaced driver unit for group %1 vehicle %2.",(group _newDriver),(typeOf _vehicle)];};
			};
		};
	};
};

true

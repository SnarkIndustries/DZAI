#define WEAPON_BANNED_STRING "bin\config.bin/CfgWeapons/FakeWeapon"
#define VEHICLE_BANNED_STRING "bin\config.bin/CfgVehicles/Banned"
#define MAGAZINE_BANNED_STRING "bin\config.bin/CfgMagazines/FakeMagazine"

private["_verified","_errorFound","_startTime"];
//waitUntil {sleep 0.5; !isNil "DZAI_weaponsInitialized"};

_startTime = diag_tickTime;

_verified = [];

_index = 4;
while {(typeName (missionNamespace getVariable ("DZAI_Rifles"+str(_index)))) == "ARRAY"} do {
	DZAI_tableChecklist set [count DZAI_tableChecklist,("DZAI_Rifles"+str(_index))];
	_index = _index + 1;
	if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Found custom weapon array %1.",("DZAI_Rifles"+str(_index))]};
};

{
	_array = missionNamespace getVariable [_x,[]];
	_errorFound = false;
	{
		if !(_x in _verified) then {
			call {
				if (isClass (configFile >> "CfgWeapons" >> _x)) exitWith {
					if (((str(inheritsFrom (configFile >> "CfgWeapons" >> _x))) == WEAPON_BANNED_STRING) or {(getNumber (configFile >> "CfgWeapons" >> _x >> "scope")) != 2}) then {
						diag_log format ["[DZAI] Removing invalid classname: %1.",_x];
						_array set [_forEachIndex,""];
						if (!_errorFound) then {_errorFound = true};
					} else {
						_verified set [count _verified,_x];
					};
				};
				if (isClass (configFile >> "CfgMagazines" >> _x)) exitWith {
					if (((str(inheritsFrom (configFile >> "CfgMagazines" >> _x))) == MAGAZINE_BANNED_STRING) or {(getNumber (configFile >> "CfgMagazines" >> _x >> "scope")) != 2}) then {
						diag_log format ["[DZAI] Removing invalid classname: %1.",_x];
						_array set [_forEachIndex,""];
						if (!_errorFound) then {_errorFound = true};
					} else {
						_verified set [count _verified,_x];
					};
				};
				if (isClass (configFile >> "CfgVehicles" >> _x)) exitWith {
					if (((str(inheritsFrom (configFile >> "CfgVehicles" >> _x))) == VEHICLE_BANNED_STRING) or {(getNumber (configFile >> "CfgVehicles" >> _x >> "scope")) != 2}) then {
						diag_log format ["[DZAI] Removing banned classname: %1.",_x];
						_array set [_forEachIndex,""];
						if (!_errorFound) then {_errorFound = true};
					} else {
						_verified set [count _verified,_x];
					};
				};
				diag_log format ["[DZAI] Removing invalid classname: %1.",_x];	//Default case - if classname doesn't exist at all
				_array set [_forEachIndex,""];
				if (!_errorFound) then {_errorFound = true};
			};
		};
	} forEach _array;
	if (_errorFound) then {
		_array = _array - [""];
		missionNamespace setVariable [_x,_array];
		diag_log format ["[DZAI] Contents of %1 failed verification. Invalid entries removed.",_x];
		//diag_log format ["DEBUG :: Corrected contents of %1: %2.",_x,_array];
		//diag_log format ["DEBUG :: Comparison check of %1: %2.",_x,missionNamespace getVariable [_x,[]]];
	};
} forEach DZAI_tableChecklist;

diag_log format ["[DZAI] Verified %1 unique classnames in %2 seconds.",(count _verified),(diag_tickTime - _startTime)];

DZAI_classnamesVerified = true;

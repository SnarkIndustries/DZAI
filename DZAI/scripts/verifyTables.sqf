#define WEAPON_BANNED_STRING "bin\config.bin/CfgWeapons/FakeWeapon"
#define VEHICLE_BANNED_STRING "bin\config.bin/CfgVehicles/Banned"
#define MAGAZINE_BANNED_STRING "bin\config.bin/CfgMagazines/FakeMagazine"

private["_verified","_errorFound","_allArrays","_startTime"];
waitUntil {!isNil "DZAI_weaponsInitialized"};

_startTime = diag_tickTime;

_allArrays = ["DZAI_Rifles0","DZAI_Rifles1","DZAI_Rifles2","DZAI_Rifles3","DZAI_Pistols0","DZAI_Pistols1","DZAI_Pistols2","DZAI_Pistols3",
				"DZAI_Backpacks0","DZAI_Backpacks1","DZAI_Backpacks2","DZAI_Backpacks3","DZAI_Edibles","DZAI_Medicals1","DZAI_Medicals2",
				"DZAI_MiscItemS","DZAI_MiscItemL","DZAI_BanditTypes","DZAI_heliTypes","DZAI_launcherTypes"];

_verified = [];

{
	if ((typeName (missionNamespace getVariable _x)) == "ARRAY") then {
		_allArrays set [count _allArrays,_x];
	};
} forEach ["DZAI_Rifles4","DZAI_Rifles5","DZAI_Rifles6","DZAI_Rifles7","DZAI_Rifles8","DZAI_Rifles9"];

{
	_array = missionNamespace getVariable [_x,[]];
	_errorFound = false;
	{
		if !(_x in _verified) then {
			_isOK = true;
			if ((isClass (configFile >> "CfgWeapons" >> _x)) || {(isClass (configFile >> "CfgMagazines" >> _x))} || {(isClass (configFile >> "CfgVehicles" >> _x))}) then {
				if (((str(inheritsFrom (configFile >> "CfgWeapons" >> _x))) == WEAPON_BANNED_STRING) || {((str(inheritsFrom (configFile >> "CfgMagazines" >> _x))) == VEHICLE_BANNED_STRING)} || {((str(inheritsFrom (configFile >> "CfgVehicles" >> _x))) == MAGAZINE_BANNED_STRING)}) then {
					_isOK = false;
				};
			} else {
				_isOK = false;
			};
			if (_isOK) then {
				_verified set [count _verified,_x];
			} else {
				diag_log format ["[DZAI] Removing invalid entry (%1).",_x];
				_array set [_forEachIndex,objNull];
				if (!_errorFound) then {_errorFound = true};
			};
		};
	} forEach _array;
	if (_errorFound) then {
		_array = _array - [objNull];
		missionNamespace setVariable [_x,_array];
		diag_log format ["[DZAI] Contents of %1 failed verification. Invalid entries removed.",_x];
		//diag_log format ["DEBUG :: Corrected contents of %1: %2.",_x,_array];
		//diag_log format ["DEBUG :: Comparison check of %1: %2.",_x,missionNamespace getVariable [_x,[]]];
	};
} forEach _allArrays;

diag_log format ["[DZAI] Verified %1 unique classnames in %2 seconds.",(count _verified),(diag_tickTime - _startTime)];

DZAI_classnamesVerified = true;

private ["_classname","_checkType","_result","_config","_banString","_check","_configIndex"];

_classname = _this select 0;
_checkType = _this select 1;
_result = false;
_configIndex = -1;
_checkType = (toLower _checkType);
_startTime = diag_tickTime;

call {
	if (_checkType == "weapon") exitWith {
		if (_classname in (DZAI_checkedClassnames select 0)) then {
			_result = true;
		} else {
			if (!(_classname in (DZAI_invalidClassnames select 0))) then {
				_config = "CfgWeapons";
				_banString = "bin\config.bin/CfgWeapons/FakeWeapon";
				_configIndex = 0;
			};
		};
	};
	if (_checkType == "magazine") exitWith {
		if (_classname in (DZAI_checkedClassnames select 1)) then {
			_result = true;
		} else {
			if (!(_classname in (DZAI_invalidClassnames select 0))) then {
				_config = "CfgMagazines";
				_banString = "bin\config.bin/CfgMagazines/FakeMagazine";
				_configIndex = 1;
			};
		};
	};
	if (_checkType == "vehicle") exitWith {
		if (_classname in (DZAI_checkedClassnames select 2)) then {
			_result = true;
		} else {
			if (!(_classname in (DZAI_invalidClassnames select 0))) then {
				_config = "CfgVehicles";
				_banString = "bin\config.bin/CfgVehicles/Banned";
				_configIndex = 2;
			};
		};
	};
	diag_log format ["DZAI Error: Attempted to check %1 as an invalid classname type! Provided type: %2. Valid types: weapon, magazine, vehicle.",_checkType];
};

if (_configIndex > -1) then {
	_check = (str(inheritsFrom (configFile >> _config >> _classname)));
	_classnameArray = [];
	if ((_check != "") && {(_check != _banString)} && {(getNumber (configFile >> _config >> _classname >> "scope")) == 2}) then {
		_classnameArray = DZAI_checkedClassnames;
		_result = true;
	} else {
		_classnameArray = DZAI_invalidClassnames;
		diag_log format ["DZAI Warning: %1 is an invalid %2 classname!",_classname,_checkType];
	};
	(_classnameArray select _configIndex) set [(count (_classnameArray select _configIndex)),_classname]; //Classname now known to be either valid or invalid, no need to check it again
	//;diag_log format ["DEBUG :: Classname check result: %1. ClassnameArray: %2.",_result,_classnameArray];
};

//diag_log format ["DEBUG :: Classname %1 (check result: %2) completed in %3 seconds.",_classname,_result,diag_tickTime - _startTime];

_result
private ["_unit","_weapongrade","_weapons","_weapon","_magazine","_backpacks","_gadgetsArray","_backpack","_gadget","_inventory"];
_unit = _this select 0;
_weapongrade = _this select 1;

if (_unit getVariable ["loadoutDone",false]) exitWith {diag_log "DZAI Error: Unit already has loadout!";};

if !(_weapongrade in DZAI_weaponGradesAll) then {
	diag_log format ["DZAI Error: Invalid weapongrade provided! (%1). Generating random weapongrade...",_weapongrade];
	_weapongrade = DZAI_weaponGrades call BIS_fnc_selectRandom2;
};

if ((count (weapons _unit)) > 0) then {
	removeAllWeapons _unit;
	_unit removeWeapon "ItemMap";
	_unit removeWeapon "ItemGPS";
	_unit removeWeapon "ItemCompass";
	_unit removeWeapon "ItemRadio";  
	_unit removeWeapon "ItemWatch";
};

switch (_weapongrade) do {
	case -1: {
		if ((random 1) < 0.8) then {
			_weapons = DZAI_Pistols0;
		} else {
			_weapons = [DZAI_rifles0,DZAI_Pistols1] call BIS_fnc_selectRandom2;;
		};
		_backpacks = DZAI_Backpacks0;
		_gadgetsArray = DZAI_gadgets0;
	};
	case 0: {
		if ((random 1) > 0.25) then {
			_weapons = DZAI_rifles0;
		} else {
			_weapons = [DZAI_Pistols0,DZAI_Pistols1] call BIS_fnc_selectRandom2;
		};
		_backpacks = DZAI_Backpacks0;
		_gadgetsArray = DZAI_gadgets0;
	};
	case 1: {
		_weapons = DZAI_rifles1;
		_backpacks = DZAI_Backpacks1;
		_gadgetsArray = DZAI_gadgets0;
	};
	case 2: {
		_weapons = DZAI_rifles2;
		_backpacks = DZAI_Backpacks2;
		_gadgetsArray = DZAI_gadgets1;
	};
	case 3: {
		_weapons = DZAI_rifles3;
		_backpacks = DZAI_Backpacks3;
		_gadgetsArray = DZAI_gadgets1;
	};
	case 4: {
		_weapons = if (isNil "DZAI_Rifles4") then {DZAI_Rifles3} else {DZAI_Rifles4};
		_backpacks = DZAI_Backpacks3;
		_gadgetsArray = DZAI_gadgets1;
	};
	case 5: {
		_weapons = if (isNil "DZAI_Rifles5") then {DZAI_Rifles3} else {DZAI_Rifles5};
		_backpacks = DZAI_Backpacks3;
		_gadgetsArray = DZAI_gadgets1;
	};
	case 6: {
		_weapons = if (isNil "DZAI_Rifles6") then {DZAI_Rifles3} else {DZAI_Rifles6};
		_backpacks = DZAI_Backpacks3;
		_gadgetsArray = DZAI_gadgets1;
	};
	case 7: {
		_weapons = if (isNil "DZAI_Rifles7") then {DZAI_Rifles3} else {DZAI_Rifles7};
		_backpacks = DZAI_Backpacks3;
		_gadgetsArray = DZAI_gadgets1;
	};
	case 8: {
		_weapons = if (isNil "DZAI_Rifles8") then {DZAI_Rifles3} else {DZAI_Rifles8};
		_backpacks = DZAI_Backpacks3;
		_gadgetsArray = DZAI_gadgets1;
	};
	case 9: {
		_weapons = if (isNil "DZAI_Rifles9") then {DZAI_Rifles3} else {DZAI_Rifles9};
		_backpacks = DZAI_Backpacks3;
		_gadgetsArray = DZAI_gadgets1;
	};
	case default {
		_weapons = [DZAI_rifles0,DZAI_rifles1,DZAI_rifles2,DZAI_rifles3] call BIS_fnc_selectRandom2;
		_backpacks = [DZAI_Backpacks0,DZAI_Backpacks1,DZAI_Backpacks2,DZAI_Backpacks3] call BIS_fnc_selectRandom2;
		_gadgetsArray = [DZAI_gadgets0,DZAI_gadgets1] call BIS_fnc_selectRandom2;
	};
};

//Select weapon and backpack
_weapon = _weapons call BIS_fnc_selectRandom2;
_backpack = _backpacks call BIS_fnc_selectRandom2;

//Add weapon, ammunition, and backpack
_magazine = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines") select 0;
_unit addMagazine _magazine;
_unit addWeapon _weapon;
_unit selectWeapon _weapon;
_unit addBackpack _backpack;
if ((getNumber (configFile >> "CfgWeapons" >> _weapon >> "type")) == 2) then {_unit setVariable ["CanGivePistol",false]};
if ((getNumber (configFile >> "CfgMagazines" >> _magazine >> "count")) < 8) then {_unit addMagazine _magazine};
if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Created weapon %1 and backpack %3 for AI with weapongrade %2. (fn_unitSelectWeapon)",_weapon,_weapongrade,_backpack];};

//diag_log format ["DEBUG :: Counted %1 tools in _gadgetsArray.",(count _gadgetsArray)];
for "_i" from 0 to ((count _gadgetsArray) - 1) do {
	private["_chance"];
	_chance = ((_gadgetsArray select _i) select 1);
	//diag_log format ["DEBUG :: %1 chance to add gadget.",_chance];
	if ((random 1) < _chance) then {
		_gadget = ((_gadgetsArray select _i) select 0);
		_unit addWeapon _gadget;
		//diag_log format ["DEBUG :: Added gadget %1 as loot to AI inventory.",_gadget];
	};
};

//If unit has weapongrade 2 or 3 and was not given NVGs, give the unit temporary NVGs which will be removed at death. Set DZAI_tempNVGs to true in variables config to enable temporary NVGs.
if (DZAI_tempNVGs) then {
	if (!(_unit hasWeapon "NVGoggles") && {(_weapongrade > 0)} && {(daytime < 6 || daytime > 20)}) then {
		_unit addWeapon "NVGoggles";
		_unit setVariable["removeNVG",1];
		if (DZAI_debugLevel > 1) then {diag_log "DZAI Extended Debug: Generated temporary NVGs for AI.";};
	};
};
_unit setVariable ["loadoutDone",true];
_unit setVariable ["loadout",[_weapon,_magazine]];

true

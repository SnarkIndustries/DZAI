/*
	buildWeaponArrays
	
	Description: Do not edit anything in this file unless instructed by the developer.
	
	Last updated: 2:28 PM 2/23/2014
*/

private ["_bldgClasses","_weapons","_lootItem","_aiWeaponBanList","_unwantedWeapons","_lootList","_cfgBuildingLoot","_lootListCheck","_startTime","_lootConfigFile"];

if (!isNil "DZAI_weaponsInitialized") exitWith {};

_startTime = diag_tickTime;

_lootConfigFile = if !((DZAI_customLootTables) && {(isClass (missionConfigFile >> "CfgBuildingLoot"))}) then {
	diag_log "[DZAI] Building DZAI weapon arrays using CfgBuildingLoot data.";
	configFile
} else {
	diag_log "[DZAI] Building DZAI weapon arrays using custom CfgBuildingLoot data.";
	missionConfigFile
};

_bldgClasses = [["Residential","Farm"],["Military"],["MilitarySpecial"],["HeliCrash"]];
_unwantedWeapons = _this select 0;		//User-specified weapon banlist.

_aiWeaponBanList = ["Crossbow_DZ","Crossbow","MeleeHatchet","MeleeCrowbar","MeleeMachete","MeleeBaseball","MeleeBaseBallBat","MeleeBaseBallBatBarbed","MeleeBaseBallBatNails","Chainsaw"];

//Add user-specified banned weapons to DZAI weapon banlist.
for "_i" from 0 to ((count _unwantedWeapons) - 1) do {
	if (!((_unwantedWeapons select _i) in _aiWeaponBanList)) then {
		_aiWeaponBanList set [(count _aiWeaponBanList),(_unwantedWeapons select _i)];
	};
};
//diag_log format ["DEBUG :: List of weapons to be removed from DZAI classname tables: %1",_aiWeaponBanList];

//Compatibility with Namalsk's selectable loot table feature.
if (isNil "dayzNam_buildingLoot") then {
	_cfgBuildingLoot = "cfgBuildingLoot";
	if ((!isClass (_lootConfigFile >> _cfgBuildingLoot >> "MilitarySpecial")) && {(isClass _lootConfigFile >> _cfgBuildingLoot >> "Barracks")}) then {
		//_bldgClasses set [2,["Barracks"]];
		(_bldgClasses select 2) set [((_bldgClasses select 2) find "MilitarySpecial"),"Barracks"];
	};
} else {
	_cfgBuildingLoot = dayzNam_buildingLoot;
	(_bldgClasses select 3) set [((_bldgClasses select 3) find "HeliCrash"),"HeliCrashNamalsk"];
};
//diag_log format ["DEBUG :: _cfgBuildingLoot: %1",_cfgBuildingLoot];

//Compatibility with DayZ 1.7.7's new HeliCrash tables
if ((isClass (_lootConfigFile >> _cfgBuildingLoot >> "HeliCrashWEST")) && {(isClass (_lootConfigFile >> _cfgBuildingLoot >> "HeliCrashEAST"))}) then {
	_bldgClasses set [3,["HeliCrashWEST","HeliCrashEAST"]];
	//diag_log format ["DEBUG :: HeliCrash tables modified: %1",(_bldgClasses select 3)];
};

//Fix for CfgBuildingLoot structure change in DayZ 1.7.7
_lootList = "";
_lootListCheck = isArray (_lootConfigFile >> _cfgBuildingLoot >> "Default" >> "lootType");
//diag_log format ["DEBUG :: _lootListCheck: %1",_lootListCheck];
if (_lootListCheck) then {
	_lootList = "lootType"; //new
} else {
	_lootList = "itemType"; //old
};
//diag_log format ["DEBUG :: _lootList: %1",_lootList];

//Declare all temporary DZAI weapon arrays. DO NOT EDIT.
DZAI_Pistols0_temp = [];
DZAI_Pistols1_temp = [];
DZAI_Pistols2_temp = [];
DZAI_Pistols3_temp = [];

DZAI_Rifles0_temp = [];
DZAI_Rifles1_temp = [];
DZAI_Rifles2_temp = [];
DZAI_Rifles3_temp = [];

//Build the weapon arrays.
for "_i" from 0 to (count _bldgClasses - 1) do {					//_i = weapongrade
	for "_j" from 0 to (count (_bldgClasses select _i) - 1) do {	//If each weapongrade has more than 1 building class, investigate them all
		private["_bldgLoot"];
		_bldgLoot = [] + getArray (_lootConfigFile >> _cfgBuildingLoot >> ((_bldgClasses select _i) select _j) >> _lootList);
		for "_k" from 0 to (count _bldgLoot - 1) do {				
			_lootItem = _bldgLoot select _k;
			if ((_lootItem select 1) == "weapon") then {			//Build an array of "weapons", then categorize them as rifles or pistols, then sort them into the correct weapon grade.
				private ["_weaponItem","_weaponMags"];
				_weaponItem = _lootItem select 0;
				_weaponMags = count (getArray (configFile >> "cfgWeapons" >> _weaponItem >> "magazines"));
				if ((_weaponMags > 0) && {!(_weaponItem in _aiWeaponBanList)}) then {							//Consider an item as a "weapon" if it has at least one magazine type.
					if ((getNumber (configFile >> "CfgWeapons" >> _weaponItem >> "type")) == 1) then {
						call compile format ["DZAI_Rifles%1_temp set [(count DZAI_Rifles%1_temp),'%2'];",_i,_weaponItem];
					} else {
						if ((getNumber (configFile >> "CfgWeapons" >> _weaponItem >> "type")) == 2) then {
							call compile format ["DZAI_Pistols%1_temp set [(count DZAI_Pistols%1_temp),'%2'];",_i,_weaponItem];
						};
					};
				};
			} else {
				if ((_lootItem select 1) == "cfglootweapon") then {
					private ["_weapons"];
					_weapons = [] + getArray (_lootConfigFile >> "cfgLoot" >> (_lootItem select 0));
					{
						if (!(_x in _aiWeaponBanList)) then {
							if ((getNumber (configFile >> "CfgWeapons" >> _x >> "type")) == 1) then {
								call compile format ["DZAI_Rifles%1_temp set [(count DZAI_Rifles%1_temp),'%2'];",_i,_x];
							} else {
								if ((getNumber (configFile >> "CfgWeapons" >> _x >> "type")) == 2) then {
									call compile format ["DZAI_Pistols%1_temp set [(count DZAI_Pistols%1_temp),'%2'];",_i,_x];
								};
							};
						};
					} forEach (_weapons select 0);
				};
			};
		};
	};
};

//Redefine each prebuilt weapon array if new table is not empty
if ((count DZAI_Pistols0_temp) > 0) then {DZAI_Pistols0 = DZAI_Pistols0_temp};
if ((count DZAI_Pistols1_temp) > 0) then {DZAI_Pistols1 = DZAI_Pistols1_temp}; //else {DZAI_Pistols1 = [] + DZAI_Pistols0};
if ((count DZAI_Pistols2_temp) > 0) then {DZAI_Pistols2 = DZAI_Pistols2_temp}; //else {DZAI_Pistols2 = [] + DZAI_Pistols1};
if ((count DZAI_Pistols3_temp) > 0) then {DZAI_Pistols3 = DZAI_Pistols3_temp} else {DZAI_Pistols3 = [] + DZAI_Pistols2};
if ((count DZAI_Rifles0_temp) > 0) then {DZAI_Rifles0 = DZAI_Rifles0_temp};
if ((count DZAI_Rifles1_temp) > 0) then {DZAI_Rifles1 = DZAI_Rifles1_temp}; //else {DZAI_Rifles1 = [] + DZAI_Rifles0};
if ((count DZAI_Rifles2_temp) > 0) then {DZAI_Rifles2 = DZAI_Rifles2_temp}; //else {DZAI_Rifles2 = [] + DZAI_Rifles1};
if ((count DZAI_Rifles3_temp) > 0) then {DZAI_Rifles3 = DZAI_Rifles3_temp} else {DZAI_Rifles3 = [] + DZAI_Rifles2};

//Destroy temporary variables
DZAI_Pistols0_temp = nil;	DZAI_Rifles0_temp = nil;
DZAI_Pistols1_temp = nil;	DZAI_Rifles1_temp = nil;
DZAI_Pistols2_temp = nil;	DZAI_Rifles2_temp = nil;
DZAI_Pistols3_temp = nil;	DZAI_Rifles3_temp = nil;

if (DZAI_debugLevel > 0) then {
	//Display finished weapon arrays
	diag_log format ["Contents of DZAI_Pistols0: %1",DZAI_Pistols0];
	diag_log format ["Contents of DZAI_Pistols1: %1",DZAI_Pistols1];
	diag_log format ["Contents of DZAI_Pistols2: %1",DZAI_Pistols2];
	diag_log format ["Contents of DZAI_Pistols3: %1",DZAI_Pistols3];
	diag_log format ["Contents of DZAI_Rifles0: %1",DZAI_Rifles0];
	diag_log format ["Contents of DZAI_Rifles1: %1",DZAI_Rifles1];
	diag_log format ["Contents of DZAI_Rifles2: %1",DZAI_Rifles2];
	diag_log format ["Contents of DZAI_Rifles3: %1",DZAI_Rifles3];
};

diag_log format ["[DZAI] DZAI weapon classname tables created in %1 seconds.",(diag_tickTime - _startTime)];

DZAI_weaponsInitialized = true;

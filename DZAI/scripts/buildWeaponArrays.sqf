/*
	buildWeaponArrays
	
	Description: Do not edit anything in this file unless instructed by the developer.

	Updated to work with DayZ Mod 1.9.0 and DayZ Epoch 1.0.7.1 by JasonTM
	
	Last updated: August 13, 2023
*/

if (!isNil "DZAI_weaponsInitialized") exitWith {};

#include "\z\addons\dayz_code\Configs\CfgLoot\LootDefines.hpp"

local _startTime = diag_tickTime;

// DayZ Mod 1.9.0 uses configFile, DayZ Epoch 1.0.7+ uses missionConfigFile
local _lootConfigFile = [configFile, missionConfigFile] select (DZAI_modName == "epoch" || DZAI_customLootTables);

if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Building DZAI weapon arrays using %1 CfgLoot data.",_lootConfigFile];};

local _cfgGroups = _lootConfigFile >> "CfgLoot" >> "Groups";

local _lootGroups = [
	[
		["Residential","Farm","Hunting"], //weapongrade 0
		["Military"], //weapongrade 1
		["MilitarySpecial"], //weapongrade 2
		["CrashSiteRU","CrashSiteUS","CrashSiteEU","CrashSiteUN"] //weapongrade 3
		
	],
	[
		["pistols","shotgunsingleshot"], // weapongrade 0
		["MilitaryRU","MilitarySmallRU","MilitaryCZ","MilitarySmallCZ"], // weapongrade 1
		["MilitaryUS","MilitarySmallUS","MilitaryEU","MilitarySmallEU"], // weapongrade 2
		["CrashSiteRU","CrashSiteUS","CrashSiteEU","CrashSiteCZ"] // weapongrade 3
	]
] select (DZAI_modName == "epoch");

//Built-in weapon ban list for melee weapons and nonweapon items
local _aiWeaponBanList = 
	[
		"Crossbow_DZ","Crossbow","MeleeHatchet","MeleeCrowbar","MeleeMachete","MeleeBaseball","MeleeBaseBallBat","MeleeBaseBallBatBarbed","MeleeBaseBallBatNails", //Melee weapons
		"ItemMap","Binocular","ItemWatch","ItemCompass","ItemFlashlight","ItemKnife","NVGoggles","ItemGPS","ItemEtool","Binocular_Vector","ItemMatchbox","ItemToolbox", //Non-weapon items
		"ItemKeyKit","ItemMatchbox" //Epoch items
	];

//Add user-specified banned weapons to DZAI weapon banlist.
{
	if !(_x in _aiWeaponBanList) then {
		_aiWeaponBanList set [count _aiWeaponBanList,_x];
	};
} count DZAI_banAIWeapons;
DZAI_banAIWeapons = nil;

//diag_log format ["DEBUG :: List of weapons to be removed from DZAI classname tables: %1",_aiWeaponBanList];

//Declare all temporary DZAI weapon arrays. DO NOT EDIT.
local _DZAI_Pistols0_temp = [];
local _DZAI_Pistols1_temp = [];
local _DZAI_Pistols2_temp = [];
local _DZAI_Pistols3_temp = [];

local _DZAI_Rifles0_temp = [];
local _DZAI_Rifles1_temp = [];
local _DZAI_Rifles2_temp = [];
local _DZAI_Rifles3_temp = [];

//Build the weapon arrays.
for "_i" from 0 to (count _lootGroups - 1) do { // _i = weapongrade
	for "_j" from 0 to (count (_lootGroups select _i) - 1) do { // If each weapongrade has more than 1 group, investigate them all
		local _lootGroup = (getArray (_cfgGroups >> ((_lootGroups select _i) select _j)));
		{
			call {
				if ((_x select 0) == Loot_WEAPON) exitWith {
					local _weaponItem = _x select 2;
					if (!(_weaponItem in _aiWeaponBanList)) then {
						local _itemType = (getNumber (configFile >> "CfgWeapons" >> _weaponItem >> "type"));
						call {
							if (_itemType == 1) exitWith {
								call compile format ["_DZAI_Rifles%1_temp set [(count _DZAI_Rifles%1_temp),'%2'];",_i,_weaponItem];
							};
							if (_itemType == 2) exitWith {
								call compile format ["_DZAI_Pistols%1_temp set [(count _DZAI_Pistols%1_temp),'%2'];",_i,_weaponItem];
							};
						};
					};
				};
				// Nested array				
				if ((_x select 0) == Loot_GROUP) exitWith {
					local _nestedGroup = getArray (_cfgGroups >> (_x select 2));
					{
						if ((_x select 0) == Loot_WEAPON) then {
							local _weaponItem = _x select 2;
							if (!(_weaponItem in _aiWeaponBanList)) then {
								local _itemType = (getNumber (configFile >> "CfgWeapons" >> _weaponItem >> "type"));
								call {
									if (_itemType == 1) exitWith {
										call compile format ["_DZAI_Rifles%1_temp set [(count _DZAI_Rifles%1_temp),'%2'];",_i,_weaponItem]
									};
									if (_itemType == 2) exitWith {
										call compile format ["_DZAI_Pistols%1_temp set [(count _DZAI_Pistols%1_temp),'%2'];",_i,_weaponItem];
									};
								};
							};
						};
					} forEach _nestedGroup;
				};
			};
		} forEach _lootGroup;
	};
};

//Redefine each prebuilt weapon array if new table is not empty
if ((count _DZAI_Pistols0_temp) > 0) then {DZAI_Pistols0 = _DZAI_Pistols0_temp};
if ((count _DZAI_Pistols1_temp) > 0) then {DZAI_Pistols1 = _DZAI_Pistols1_temp}; //else {DZAI_Pistols1 = [] + DZAI_Pistols0};
if ((count _DZAI_Pistols2_temp) > 0) then {DZAI_Pistols2 = _DZAI_Pistols2_temp}; //else {DZAI_Pistols2 = [] + DZAI_Pistols1};
if ((count _DZAI_Pistols3_temp) > 0) then {DZAI_Pistols3 = _DZAI_Pistols3_temp} else {DZAI_Pistols3 = [] + DZAI_Pistols2};
if ((count _DZAI_Rifles0_temp) > 0) then {DZAI_Rifles0 = _DZAI_Rifles0_temp};
if ((count _DZAI_Rifles1_temp) > 0) then {DZAI_Rifles1 = _DZAI_Rifles1_temp}; //else {DZAI_Rifles1 = [] + DZAI_Rifles0};
if ((count _DZAI_Rifles2_temp) > 0) then {DZAI_Rifles2 = _DZAI_Rifles2_temp}; //else {DZAI_Rifles2 = [] + DZAI_Rifles1};
if ((count _DZAI_Rifles3_temp) > 0) then {DZAI_Rifles3 = _DZAI_Rifles3_temp} else {DZAI_Rifles3 = [] + DZAI_Rifles2};

if (DZAI_debugLevel > 0) then {
	if (DZAI_debugLevel > 1) then {
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
	diag_log format ["DZAI Debug: Weapon classname tables created in %1 seconds.",(diag_tickTime - _startTime)];
};

DZAI_weaponsInitialized = true;

diag_log format ["DZAI Debug: Weapon classname tables created in %1 seconds.",(diag_tickTime - _startTime)];
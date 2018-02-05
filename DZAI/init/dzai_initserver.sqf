/*
	DZAI Server Initialization File
	
	Description: Handles startup process for DZAI. Does not contain any values intended for modification.
*/
private ["_startTime","_directoryAsArray","_worldname","_allUnits"];

if (!isServer || !isNil "DZAI_isActive") exitWith {};
DZAI_isActive = true;

_startTime = diag_tickTime;

_directoryAsArray = toArray __FILE__;
_directoryAsArray resize ((count _directoryAsArray) - 25);
DZAI_directory = toString _directoryAsArray;
if (isNil "_this") then {_this = []};
if ((count _this) > 0) then {
	//diag_log "DEBUG :: Startup parameters found!";
	if ("readoverridefile" in _this) then {DZAI_overrideEnabled = true} else {DZAI_overrideEnabled = nil};
	if ("enabledebugmarkers" in _this) then {DZAI_debugMarkersEnabled = true} else {DZAI_debugMarkersEnabled = nil};
} else {
	//diag_log "DEBUG :: Startup parameters not found!";
	DZAI_overrideEnabled = nil;
	DZAI_debugMarkersEnabled = nil;
};

//Report DZAI version to RPT log
#include "DZAI_version.txt"
diag_log format ["[DZAI] Initializing %1 version %2 using base path %3.",DZAI_TYPE,DZAI_VERSION,DZAI_directory];

//Load DZAI main configuration file
call compile preprocessFileLineNumbers format ["%1\init\dzai_config.sqf",DZAI_directory];

//Load custom DZAI settings file.
if ((!isNil "DZAI_overrideEnabled") && {DZAI_overrideEnabled}) then {call compile preprocessFileLineNumbers format ["%1\DZAI_settings_override.sqf",DZAI_directory]};

//Load DZAI functions
call compile preprocessFileLineNumbers format ["%1\init\dzai_functions.sqf",DZAI_directory];

//Set side relations
_allUnits = +allUnits;
if (({(side _x) == west} count _allUnits) == 0) then {createCenter west};
if (({(side _x) == east} count _allUnits) == 0) then {createCenter east};
east setFriend [west, 0];        
west setFriend [east, 0];

//Detect DayZ mod variant and version being used.
if (isNil "DZAI_modName") then {DZAI_modName = "Default"};
if (isNil "DZAI_modVersion") then {DZAI_modVersion = toLower (getText (configFile >> "CfgMods" >> "DayZ" >> "version"))};
if (isNil "DZAI_modAutoDetect") then {DZAI_modAutoDetect = true};

if (DZAI_modAutoDetect) then {
	private["_modVariant"];
	_modVariant = toLower (getText (configFile >> "CfgMods" >> "DayZ" >> "dir"));
	if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Detected mod variant %1.",_modVariant];};
	DZAI_modName = call {
		if (_modVariant == "@dayz_epoch") exitWith {"epoch"};
		if ((isClass (configFile >> "CfgWeapons" >> "ItemHatchet")) && {isClass (configFile >> "CfgWeapons" >> "ItemMatchbox")}) exitWith {"epoch"};
		if (_modVariant in ["dayzoverwatch","@dayzoverwatch"]) exitWith {"overwatch"};
		if (_modVariant == "@dayzhuntinggrounds") exitWith {"huntinggrounds"};
		if (_modVariant == "@dayzunleashed") exitWith {"unleashed"};
		if ((_modVariant == "dayzlingor") && {(toLower (getText (configFile >> "CfgMods" >> "DayZ" >> "action"))) == "http://www.skaronator.com"}) exitWith {"lingorskaro"};
		""
	};
};

//Create reference marker to act as boundary for spawning AI air/land vehicles. These values will be later modified on a per-map basis.
if (isNil "DZAI_maxHeliPatrols") then {DZAI_maxHeliPatrols = 0};
if (isNil "DZAI_maxLandPatrols") then {DZAI_maxLandPatrols = 0};
_centerPos = getMarkerPos 'center';
_markerSize = [7000, 7000];
_centerMarker = createMarker ["DZAI_centerMarker", _centerPos];
_centerMarker setMarkerShape "ELLIPSE";
_centerMarker setMarkerType "Empty";
_centerMarker setMarkerBrush "Solid";
_centerMarker setMarkerAlpha 0;

_worldname = (toLower worldName);
call {
	if (_worldname == "caribou") exitWith {
		_centerPos = [3938.9722, 4195.7417];
		_markerSize = [3500, 3500];
	};
	if (_worldname == "chernarus") exitWith {
		_centerPos = [7652.9634, 7870.8076];
		_markerSize = [5500, 5500];
	};
	if (_worldname == "cmr_ovaron") exitWith {
		//Proper values needed
	};
	if (_worldname == "fallujah") exitWith {
		_centerPos = [5139.8008, 4092.6797];
		_markerSize = [4000, 4000];
	};
	if (_worldname == "fdf_isle1_a") exitWith {
		_centerPos = [10771.362, 8389.2568];
		_markerSize = [2750, 2750];
	};
	if (_worldname == "isladuala") exitWith {
		_centerPos = [4945.3438, 4919.6616];
		_markerSize = [4000, 4000];
	};
	if (_worldname == "lingor") exitWith {
		_centerPos = [5166.5581, 5108.8301];
		_markerSize = [4500, 4500];
	};
	if (_worldname == "mbg_celle2") exitWith {
		_centerPos = [6163.52, 6220.3984];
		_markerSize = [6000, 6000];
	};
	if (_worldname == "namalsk") exitWith {
		_centerPos = [5880.1313, 8889.1045];
		_markerSize = [3000, 3000];
	};
	if (_worldname == "napf") exitWith {
		_centerPos = [10725.096, 9339.918];
		_markerSize = [8500, 8500];
	};
	if (_worldname == "oring") exitWith {
		_centerPos = [5191.1069, 5409.1938];
		_markerSize = [4750, 4750];
	};
	if (_worldname == "panthera2") exitWith {
		_centerPos = [5343.6953, 4366.2534];
		_markerSize = [3500, 3500];
	};
	if (_worldname == "sara") exitWith {
		_centerPos = [12693.104, 11544.386];
		_markerSize = [6250, 6250];
	};
	if (_worldname == "sauerland") exitWith {
		_centerPos = [12270.443, 13632.132];
		_markerSize = [17500, 17500];
	};
	if (_worldname == "takistan") exitWith {
		_centerPos = [6368.2764, 6624.2744];
		_markerSize = [6000, 6000];
	};
	if (_worldname == "tavi") exitWith {
		_centerPos = [10887.825, 11084.657];
		_markerSize = [8500, 8500];
	};
	if (_worldname == "trinity") exitWith {
		_centerPos = [7183.8403, 7067.4727];
		_markerSize = [5250, 5250];
	};
	if (_worldname == "utes") exitWith {
		_centerPos = [3519.8037, 3703.0649];
		_markerSize = [1000, 1000];
	};
	if (_worldname == "zargabad") exitWith {
		_centerPos = [3917.6201, 3800.0376];
		_markerSize = [2000, 2000];
	};
	if ((_centerPos distance [0,0,0]) < 5) then {
		_centerPos = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");
	};
};
_centerMarker setMarkerPos _centerPos;
_centerMarker setMarkerSize _markerSize;

//Load map-specific configuration file. Config files contain trigger/marker information, addition and removal of items/skins, and/or other variable customizations.
//Classname files will overwrite basic settings specified in base_classnames.sqf
if (_worldname in ["chernarus","utes","zargabad","fallujah","takistan","tavi","lingor","namalsk","mbg_celle2","oring","panthera2","isladuala","sara","smd_sahrani_a2","trinity","napf","caribou","cmr_ovaron","sauerland","fdf_isle1_a","caribou"]) then {
	if (DZAI_modAutoDetect) then {
		if (DZAI_modName in ["epoch","unleashed","overwatch","huntinggrounds"]) then {
			call compile preprocessFileLineNumbers format ["%1\init\world_classname_configs\dayz_%2.sqf",DZAI_directory,DZAI_modName];
		} else {
			call compile preprocessFileLineNumbers format ["%1\init\world_classname_configs\default_classnames\%2.sqf",DZAI_directory,_worldname];
		};
	};
	[] execVM format ["%1\init\world_spawn_configs\world_%2.sqf",DZAI_directory,_worldname];
} else {
	if (DZAI_modAutoDetect) then {
		if (DZAI_modName == "epoch") then {
			call compile preprocessFileLineNumbers format ["%1\init\world_classname_configs\dayz_epoch_classnames.sqf",DZAI_directory];
		};
	};
	if (DZAI_staticAI) then {[] execVM format ["%1\scripts\setup_autoStaticSpawns.sqf",DZAI_directory];};
};

//Continue loading required DZAI script files
[] execVM format ['%1\scripts\DZAI_startup.sqf',DZAI_directory];

//Report DZAI startup settings to RPT log
diag_log format ["[DZAI] DZAI settings: Debug Level: %1. DebugMarkers: %2. WorldName: %3. ModName: %4 (Ver: %5). DZAI_dynamicWeaponList: %6. VerifyTables: %7.",DZAI_debugLevel,((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled}),_worldname,DZAI_modName,DZAI_modVersion,DZAI_dynamicWeaponList,DZAI_verifyTables];
diag_log format ["[DZAI] AI spawn settings: Static: %1. Dynamic: %2. Random: %3. Air: %4. Land: %5.",DZAI_staticAI,DZAI_dynAISpawns,(DZAI_maxRandomSpawns > 0),(DZAI_maxHeliPatrols>0),(DZAI_maxLandPatrols>0)];
diag_log format ["[DZAI] AI settings: DZAI_findKiller: %1. DZAI_useHealthSystem: %2. DZAI_weaponNoise: %3. DZAI_zombieEnemy: %4.",DZAI_findKiller,DZAI_useHealthSystem,DZAI_weaponNoise,DZAI_zombieEnemy];
diag_log format ["[DZAI] DZAI loading completed in %1 seconds.",(diag_tickTime - _startTime)];

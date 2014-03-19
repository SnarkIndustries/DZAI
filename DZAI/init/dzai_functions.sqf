/*
	DZAI Functions
	
	Last Updated: 5:08 AM 12/24/2013
*/

waituntil {!isnil "bis_fnc_init"};
diag_log "[DZAI] Compiling DZAI functions.";

//Compile general functions.
if (isNil "SHK_pos_getPos") then {call compile preprocessFile format ["%1\SHK_pos\shk_pos_init.sqf",DZAI_directory];};
if (isNil "fnc_selectRandomWeighted") then {fnc_selectRandomWeighted = compile preprocessFileLineNumbers format ["%1\compile\fn_selectRandomWeighted.sqf",DZAI_directory]};
BIS_fnc_selectRandom2 = compile preprocessFileLineNumbers format ["%1\compile\fn_selectRandom.sqf",DZAI_directory];

DZAI_addLoot = compile preprocessFileLineNumbers format ["%1\compile\ai_generate_loot.sqf",DZAI_directory];
DZAI_setupLoadout = compile preprocessFileLineNumbers format ["%1\compile\ai_setup_loadout.sqf",DZAI_directory];
fnc_spawnBandits_custom	= compile preprocessFileLineNumbers format ["%1\spawn_functions\spawnBandits_custom.sqf",DZAI_directory];
fnc_respawnBandits = compile preprocessFileLineNumbers format ["%1\spawn_functions\respawnBandits.sqf",DZAI_directory];
fnc_respawnHandler = compile preprocessFileLineNumbers format ["%1\spawn_functions\respawnHandler2.sqf",DZAI_directory];
DZAI_setup_AI = compile preprocessFileLineNumbers format ["%1\compile\fn_createGroup.sqf",DZAI_directory];
DZAI_AI_handledamage = compile preprocessFileLineNumbers format ["%1\compile\fn_damageHandlerAI2.sqf",DZAI_directory];
DZAI_BIN_taskPatrol = compile preprocessFileLineNumbers format ["%1\compile\BIN_taskPatrol.sqf",DZAI_directory];
DZAI_AI_killed_all = compile preprocessFileLineNumbers format ["%1\compile\ai_killed_all.sqf",DZAI_directory];
DZAI_AI_killed_static = compile preprocessFileLineNumbers format ["%1\compile\ai_killed_static.sqf",DZAI_directory];
DZAI_unitDeath = compile preprocessFileLineNumbers format ["%1\compile\ai_death.sqf",DZAI_directory];
DZAI_countKills = compile preprocessFileLineNumbers format ["%1\compile\fn_countkills.sqf",DZAI_directory];
fnc_despawnBandits = compile preprocessFileLineNumbers format ["%1\spawn_functions\despawnBandits.sqf",DZAI_directory];

if (DZAI_staticAI) then {
	fnc_spawnBandits = compile preprocessFileLineNumbers format ["%1\spawn_functions\spawnBandits.sqf",DZAI_directory];
	DZAI_bldgPatrol = compile preprocessFileLineNumbers format ["%1\compile\ai_buildingpatrol.sqf",DZAI_directory];
	DZAI_static_spawn = compile preprocessFileLineNumbers format ["%1\compile\fn_createStaticSpawn.sqf",DZAI_directory];
};

if (DZAI_dynAISpawns) then {
	fnc_spawnBandits_dynamic = compile preprocessFileLineNumbers format ["%1\spawn_functions\spawnBandits_dynamicV2.sqf",DZAI_directory];
	fnc_despawnBandits_dynamic = compile preprocessFileLineNumbers format ["%1\spawn_functions\despawnBandits_dynamic.sqf",DZAI_directory];
	DZAI_dyn_huntPlayer = compile preprocessFileLineNumbers format ["%1\compile\fn_seekPlayer.sqf",DZAI_directory];
	DZAI_AI_killed_dynamic = compile preprocessFileLineNumbers format ["%1\compile\ai_killed_dynamic.sqf",DZAI_directory];
};

if (DZAI_findKiller) then {
	DZAI_huntKiller = compile preprocessFileLineNumbers format ["%1\compile\fn_findKiller.sqf",DZAI_directory];
};

if ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled}) then {
	DZAI_autoRearm_unit = compile preprocessFileLineNumbers format ["%1\compile\unit_resupply_debug.sqf",DZAI_directory];
	DZAI_updateSpawnMarker = compile preprocessFileLineNumbers format ["%1\compile\fn_refreshmarker.sqf",DZAI_directory];
} else {
	DZAI_autoRearm_unit = compile preprocessFileLineNumbers format ["%1\compile\unit_resupply.sqf",DZAI_directory];
};

//Compile zombie aggro functions
if (DZAI_zombieEnemy && {DZAI_weaponNoise}) then { // Optional Zed-to-AI aggro functions
	ai_fired = compile preprocessFileLineNumbers format ["%1\compile\ai_fired.sqf",DZAI_directory];
	ai_alertzombies = compile preprocessFileLineNumbers format ["%1\compile\ai_alertzombies.sqf",DZAI_directory];
};

//Helicopter patrol scripts
if (DZAI_maxHeliPatrols > 0) then {
	if ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled}) then {
		DZAI_autoRearm_heli = compile preprocessFileLineNumbers format ["%1\compile\heli_resupply_debug.sqf",DZAI_directory];
	} else {
		DZAI_autoRearm_heli = compile preprocessFileLineNumbers format ["%1\compile\heli_resupply.sqf",DZAI_directory];
	};
	DZAI_spawnHeliPatrol = compile preprocessFileLineNumbers format ["%1\spawn_functions\spawn_heliPatrol.sqf",DZAI_directory];
	DZAI_airLanding = compile preprocessFileLineNumbers format ["%1\compile\heli_airlanding.sqf",DZAI_directory];
	DZAI_heliGetOut = compile preprocessFileLineNumbers format ["%1\compile\heli_getout.sqf",DZAI_directory];
	DZAI_hHandleDamage = compile preprocessFileLineNumbers format ["%1\compile\heli_handledamage.sqf",DZAI_directory];
	DZAI_heliDestroyed = compile preprocessFileLineNumbers format ["%1\compile\heli_destroyed.sqf",DZAI_directory];
	DZAI_heliDetectPlayers = compile preprocessFileLineNumbers format ["%1\compile\heli_detectplayers.sqf",DZAI_directory];
	DZAI_heliRandomPatrol = compile preprocessFileLineNumbers format ["%1\compile\heli_randompatrol.sqf",DZAI_directory];
};

//Land vehicle patrol scripts
if (DZAI_maxLandPatrols > 0) then {
	if ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled}) then {
		DZAI_autoRearm_veh = compile preprocessFileLineNumbers format ["%1\compile\veh_autorearm_debug.sqf",DZAI_directory];
	} else {
		DZAI_autoRearm_veh = compile preprocessFileLineNumbers format ["%1\compile\veh_autorearm.sqf",DZAI_directory];
	};
	DZAI_spawnVehPatrol	= compile preprocessFileLineNumbers format ["%1\spawn_functions\spawn_vehpatrol.sqf",DZAI_directory];
	DZAI_vehGetOut = compile preprocessFileLineNumbers format ["%1\compile\veh_getout.sqf",DZAI_directory];
	DZAI_vHandleDamage = compile preprocessFileLineNumbers format ["%1\compile\veh_handledamage.sqf",DZAI_directory];
	DZAI_vehDestroyed = compile preprocessFileLineNumbers format ["%1\compile\veh_destroyed.sqf",DZAI_directory];
	DZAI_vehPatrol = compile preprocessFileLineNumbers format ["%1\compile\veh_randompatrol.sqf",DZAI_directory];
};

//DZAI custom spawns function.
DZAI_spawn = {
	private ["_spawnMarker","_patrolRadius","_trigStatements","_trigger","_respawn","_weapongrade","_totalAI"];
	
	_spawnMarker = _this select 0;
	if ((typeName _spawnMarker) != "STRING") exitWith {diag_log "DZAI Error: Marker string not given!"};
	_totalAI = if ((typeName (_this select 1)) == "SCALAR") then {_this select 1} else {1};
	_weapongrade = if ((typeName (_this select 2)) == "SCALAR") then {_this select 2} else {1};
	_respawn = if ((count _this) > 3) then {if ((typeName (_this select 3)) == "BOOL") then {_this select 3} else {true}} else {true};

	_patrolRadius = ((((getMarkerSize _spawnMarker) select 0) min ((getMarkerSize _spawnMarker) select 1)) min 300);

	_trigStatements = format ["0 = [%1,0,%2,thisTrigger,%3,%4] call fnc_spawnBandits_custom;",_totalAI,_patrolRadius,_weapongrade,_spawnMarker];
	_trigger = createTrigger ["EmptyDetector", getMarkerPos(_spawnMarker)];
	_trigger setTriggerArea [600, 600, 0, false];
	_trigger setTriggerActivation ["ANY", "PRESENT", true];
	_trigger setTriggerTimeout [5, 5, 5, true];
	_trigger setTriggerText _spawnMarker;
	_trigger setTriggerStatements ["{isPlayer _x} count thisList > 0;",_trigStatements,"0 = [thisTrigger] spawn fnc_despawnBandits;"];
	_trigger setVariable ["respawn",_respawn];
	_trigger setVariable ["spawnmarker",_spawnMarker];
	//diag_log format ["DEBUG :: %1",_trigStatements];
	
	if ((markerAlpha _spawnMarker) > 0) then {
		_spawnMarker setMarkerAlpha 0;
	};
	/*
	if ((markerShape _spawnMarker) == "ELLIPSE") then {
		_spawnMarker setMarkerShape "RECTANGLE";
	};
	*/
	
	if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Created custom spawn area %1 at %2 with %3 AI units, weapongrade %4, respawn %5.",_spawnMarker,mapGridPosition _trigger,_totalAI,_weapongrade,_respawn];};
	
	_trigger
};

//Miscellaneous functions 
//------------------------------------------------------------------------------------------------------------------------

if (DZAI_radioMsgs) then {
	if (DZAI_useRadioAddon) then {
		DZAI_radioSend = {
			DZAI_SMS = (_this select 1);
			(owner (_this select 0)) publicVariableClient "DZAI_SMS";
			true
		};
	} else {
		DZAI_radioSend = {
			[nil,(_this select 0),"loc",rTITLETEXT,(_this select 1),"PLAIN DOWN",2] call RE;
			true
		};
	};
};

//DZAI group side assignment function. Detects when East side has too many groups, then switches to Resistance side.
DZAI_getFreeSide = {
	private["_groupSide"];
	_groupSide = (if (({(side _x) == east} count allGroups) <= 140) then {east} else {resistance});
	//diag_log format ["Assigned side %1 to AI group",_groupSide];
	
	_groupSide
};

//Sets skills for unit based on their weapongrade value.
DZAI_setSkills = {
	private["_unit","_weapongrade","_skillArray"];
	_unit = _this select 0;
	_weapongrade = _this select 1;

	_skillArray = switch (_weapongrade) do {
		case -1;
		case 0: {DZAI_skill0};
		case 1: {DZAI_skill1};
		case 2: {DZAI_skill2};
		case 3: {DZAI_skill3};
		case 4: {if (isNil "DZAI_skill4") then {DZAI_skill3} else {DZAI_skill4}};
		case 5: {if (isNil "DZAI_skill5") then {DZAI_skill3} else {DZAI_skill5}};
		case 6: {if (isNil "DZAI_skill6") then {DZAI_skill3} else {DZAI_skill6}};
		case 7: {if (isNil "DZAI_skill7") then {DZAI_skill3} else {DZAI_skill7}};
		case 8: {if (isNil "DZAI_skill8") then {DZAI_skill3} else {DZAI_skill8}};
		case 9: {if (isNil "DZAI_skill9") then {DZAI_skill3} else {DZAI_skill9}};
		case "helicrew": {DZAI_heliCrewSkills};
		case default {DZAI_skill1};
	};
	{
		_unit setskill [_x select 0,(((_x select 1) + random ((_x select 2)-(_x select 1))) min 1)];
	} forEach _skillArray;
};

//Spawns flies on AI corpse
DZAI_deathFlies = {
	private ["_soundFlies"];
	_soundFlies = createSoundSource["Sound_Flies",getPosATL _this,[],0];
	_soundFlies attachTo [_this,[0,0,0]];
	_this setVariable ["sound_flies",_soundFlies];
	sleep 3;
	_this enableSimulation false;
};

//Convert server uptime in seconds to formatted time (days/hours/minutes/seconds)
DZAI_getUptime = {
	private ["_iS","_oS","_oM","_oH","_oD"];

	_iS = time;
	
	_oS = floor (_iS % 60);
	_oM = floor ((_iS % 3600)/60);
	_oH = floor ((_iS % 86400)/3600);
	_oD = floor ((_iS % 2592000)/86400);
	
	[_oD,_oH,_oM,_oS]
};

//Combines two arrays and returns the combined array. Does not add duplicate values. Second array is appended to first array.
DZAI_append = {
	if (((typeName (_this select 0)) != "ARRAY")&&((typeName (_this select 1)) != "ARRAY")) exitWith {diag_log "DZAI Error: DZAI_append function was not provided with two arrays!";};
	{
		if !(_x in (_this select 0)) then {
			(_this select 0) set [(count (_this select 0)),_x];
		};
	} forEach (_this select 1);
	
	(_this select 0)
};

//Knocks an AI unit unconscious for x seconds - determines the correct animation to use, and returns unit to standing state after waking.
DZAI_unconscious = {
	private ["_unit","_anim","_hit","_sleep"];
	_unit = _this select 0;
	_hit = _this select 1;
	
	if ((animationState _unit) in ["amovppnemrunsnonwnondf","amovppnemstpsnonwnondnon","amovppnemstpsraswrfldnon","amovppnemsprslowwrfldf","aidlppnemstpsnonwnondnon0s","aidlppnemstpsnonwnondnon01"]) then {
		_anim = "adthppnemstpsraswpstdnon_2";
	} else {
		_anim = "adthpercmstpslowwrfldnon_4";
	};
	_unit disableAI "FSM";
	_unit switchMove _anim;
	_nul = [objNull, _unit, rSWITCHMOVE, _anim] call RE;  
	//diag_log "DEBUG :: AI unit is unconscious.";

	_sleep = if (_hit == "head_hit") then {30} else {15};
	//diag_log format ["DEBUG :: Knocked out AI %1 for %2 seconds.",_unit,_sleep];
	sleep _sleep;

	if (alive _unit) then {
		_nul = [objNull, _unit, rSWITCHMOVE, "amovppnemrunsnonwnondf"] call RE;
		_unit switchMove "amovppnemrunsnonwnondf";
		sleep 1.5;
		_unit enableAI "FSM";
		//diag_log "DEBUG :: AI unit is conscious.";
		_unit setVariable ["unconscious",false];
	};
};

//Generic function to delete a specified object (or array of objects) after a specified time (seconds).
/*DZAI_deleteObject = {
	private["_obj","_delay"];
	_obj = _this select 0;
	_delay = if ((count _this) > 1) then {_this select 1} else {300};
	
	if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Deleting object(s) %1 in %2 seconds.",_obj,_delay];};
	sleep _delay;
	
	if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Deleting object(s) %1 now.",_obj];};
	
	if ((typeName _obj) == "ARRAY") then {
		{
			_x call DZAI_unprotectObject;
			deleteVehicle _x;
		} forEach _obj;
	} else {
		_obj call DZAI_unprotectObject;
		deleteVehicle _obj;
	};
};*/

DZAI_deleteObject = {
	private ["_obj","_delay"];
	_obj = _this select 0;
	_delay = _this select 1;
	
	DZAI_deleteObjectQueue set [count DZAI_deleteObjectQueue,[_obj,(time + _delay)]];
};

//If a trigger's calculated totalAI value is zero, then add new group to respawn queue to retry spawn until a nonzero value is found.
DZAI_retrySpawn = {
	private ["_trigger","_unitGroup","_dummy","_grpArray"];

	_trigger = _this select 0;

	waitUntil {sleep 0.1; (_trigger getVariable ["initialized",false])};

	//Create placeholder dummy unit.
	_unitGroup = createGroup (call DZAI_getFreeSide);
	_dummy = _unitGroup createUnit ["Survivor1_DZ",[0,0,0],[],0,"FORM"];
	[_dummy] joinSilent _unitGroup;
	_dummy setVehicleInit "this hideObject true;this allowDamage false;this enableSimulation false;"; processInitCommands;
	_dummy disableAI "FSM";
	_dummy disableAI "ANIM";
	_dummy disableAI "MOVE";
	_dummy disableAI "TARGET";
	_dummy disableAI "AUTOTARGET";
	_dummy setVariable ["unconscious",true]; //prevent radio messages if dummy is group leader

	//Initialize group variables.
	_unitGroup setVariable ["dummyUnit",_dummy];
	_unitGroup setVariable ["GroupSize",0];
	_unitGroup setVariable ["trigger",_trigger];
	_unitGroup setVariable ["unitType","static"];
	_unitGroup allowFleeing 0;

	//Add new group to trigger's group array.
	_grpArray = _trigger getVariable "GroupArray";
	_grpArray set [(count _grpArray),_unitGroup];

	0 = [_trigger,_unitGroup,true] spawn fnc_respawnHandler;

	if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Inserted group %1 into respawn queue. (retryRespawn)",_unitGroup];};
};

//Finds a position that does not have a player within a certain distance.
DZAI_findSpawnPos = {
	private ["_spawnPos","_attempts","_continue","_spawnpool","_maxAttempts"];
	
	_attempts = 0;
	_continue = true;
	_spawnpool = [] + _this;
	_maxAttempts = ((count _spawnpool) min 6);
	while {_continue && {(_attempts < _maxAttempts)}} do {
		_index = floor (random (count _spawnpool));
		_spawnPos = _spawnpool select _index;
		if (({isPlayer _x} count (_spawnPos nearEntities [["AllVehicles","CAManBase"],50])) == 0) then {
			_continue = false;
		} else {
			_spawnpool set [_index,objNull]; 
			_spawnpool = _spawnpool - [objNull];
			_attempts = _attempts + 1;
			if (_attempts == _maxAttempts) then {
				_spawnPos = [];
			};
			if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Player found within 50m of chosen spawn position. (attempt %1/%2).",_attempts,_maxAttempts];};
		};
	};

	_spawnPos
};

DZAI_findLootPile = {
	private ["_lootPiles","_lootPos","_unitGroup","_searchRange"];
	_unitGroup = _this select 0;
	_searchRange = _this select 1;
	
	_lootPiles = (getPosATL (leader _unitGroup)) nearObjects ["ReammoBox",_searchRange];
	if ((count _lootPiles) > 0) then {
		_lootPos = getPosATL (_lootPiles call BIS_fnc_selectRandom2);
		if ((behaviour (leader _unitGroup)) != "AWARE") then {_unitGroup setBehaviour "AWARE"};
		(units _unitGroup) doMove _lootPos;
		{_x moveTo _lootPos} forEach (units _unitGroup);
		//diag_log format ["DEBUG :: AI group %1 is investigating a loot pile at %2.",_unitGroup,_lootPos];
	};
};

DZAI_shuffleWP = {
	private ["_unitGroup","_locationArray","_newWPPos","_wp"];
	_unitGroup = _this select 0;
	_locationArray = (_unitGroup getVariable "trigger") getVariable "locationArray";
	_newWPPos = _locationArray call BIS_fnc_selectRandom2;
	//diag_log format ["DEBUG :: Chosen position: %1.",_newWPPos];
	_wp = (currentWaypoint _unitGroup);
	if ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled}) then {
		private["_markername"];
		_markername = format ["[%1,%2]",_unitGroup,_wp];
		//diag_log format ["DEBUG :: Relocating marker %1.",_markername];
		_markername setMarkerPos _newWPPos;
	};
	[_unitGroup,_wp] setWPPos _newWPPos;
};

DZAI_setTrigVars = {
	private["_trigger"];

	_trigger = _this select 0;
	_trigger setVariable ["isCleaning",false];
	_trigger setVariable ["GroupArray",(_this select 1)];
	if ((count _this) > 3) then {
		_trigger setVariable ["patrolDist",(_this select 2)];
		_trigger setVariable ["equipType",(_this select 3)];
		_trigger setVariable ["locationArray",(_this select 4)];
		_trigger setVariable ["maxUnits",(_this select 5)];
		_trigger setVariable ["initialized",true];
		if (triggerActivated _trigger) then {DZAI_actTrigs = DZAI_actTrigs + 1;};
		if (DZAI_debugLevel > 1) then {diag_log format["DZAI Extended Debug: Initialized static trigger at %1. GroupArray: %2, PatrolDist: %3. equipType: %4. %LocationArray %5 positions, MaxUnits %6.",triggerText(_this select 0),(_this select 1),(_this select 2),(_this select 3),count (_this select 4),(_this select 5)];};
	} else {
		//if (triggerActivated _trigger) then {DZAI_actDynTrigs = DZAI_actDynTrigs + 1;};
		if (DZAI_debugLevel > 1) then {diag_log format["DZAI Extended Debug: Initialized dynamic trigger at %1. GroupArray: %2.",getPosATL (_this select 0),(_this select 1)];};
		//Create temporary dynamic spawn blacklist area
		_location = createLocation ["Strategic",(getPosATL _trigger),600,600];
		_trigger setVariable ["triggerLocation",_location];
	};

	true
};

//Retrieves server object monitor array
DZAI_getObjMon = {
	private ["_objectMonitor"];
	_objectMonitor = switch (true) do {
		case ((isNil "PVDZE_serverObjectMonitor") && {(!isNil "dayz_serverObjectMonitor")}): {dayz_serverObjectMonitor};
		case (!isNil "PVDZE_serverObjectMonitor"): {PVDZE_serverObjectMonitor};
		case default {[]};
	};
	
	_objectMonitor
};

//Prevents object from being destroyed/deleted from DayZ's anti-hacker check
DZAI_protectObject = {
	private ["_objectMonitor","_object"];
	_object = _this;
	
	_objectMonitor = [] call DZAI_getObjMon;
	
	_objectMonitor set [count _objectMonitor,_object];
	_object setVariable ["ObjectID",""];
	
	true
};

//Returns true if object was removed from server object monitor, false if it was not found in the monitor
DZAI_unprotectObject = {
	private ["_objectMonitor","_object","_result"];
	_object = _this;
	_result = false;
	
	_objectMonitor = [] call DZAI_getObjMon;
	
	if (_object in _objectMonitor) then {
		_objectMonitor = _objectMonitor - [_object];
		_result = true;
	};
	
	_result
};

DZAI_getWeapongrade = {
	private ["_indexWeighted","_index"];

	_indexWeighted = switch (_this) do {
		case -1: {DZAI_gradeIndicesNewbie};
		case 0: {DZAI_gradeIndices0};
		case 1: {DZAI_gradeIndices1};
		case 2: {DZAI_gradeIndices2};
		case 3: {DZAI_gradeIndices3};
		case 4: {DZAI_gradeIndicesDyn};
		case 5: {DZAI_gradeIndicesHeli};
		case default {[DZAI_gradeIndices0,DZAI_gradeIndices1,DZAI_gradeIndices2,DZAI_gradeIndices3] call BIS_fnc_selectRandom2};
	};
	
	_index = _indexWeighted call BIS_fnc_selectRandom2;
	
	DZAI_weaponGrades select _index
};

DZAI_checkClassname = {
	private ["_classname","_checkType","_result","_config","_banString","_check","_configIndex"];

	_classname = _this select 0;
	_checkType = _this select 1;
	_result = true;
	_configIndex = -1;

	switch (toLower _checkType) do {
		case "weapon": {
			if !(_classname in DZAI_checkedClassnames) then {
				_config = "CfgWeapons";
				_banString = "bin\config.bin/CfgWeapons/FakeWeapon";
				_configIndex = 0;
			};
		};
		case "magazine": {
			if !(_classname in DZAI_checkedClassnames) then {
				_config = "CfgMagazines";
				_banString = "bin\config.bin/CfgMagazines/FakeMagazine";
				_configIndex = 1;
			};
		};
		case "vehicle": {
			if !(_classname in DZAI_checkedClassnames) then {
				_config = "CfgVehicles";
				_banString = "bin\config.bin/CfgVehicles/Banned";
				_configIndex = 2;
			};
		};
		case default {
			_result = false;	//If input is invalid, declare classname as invalid
		};
	};
	
	if (_configIndex > -1) then {
		_check = (str(inheritsFrom (configFile >> _config >> _classname)));
		if ((_check == "") or (_check == _banString)) then {
			_result = false;
		} else {
			(DZAI_checkedClassnames select _configIndex) set [(count (DZAI_checkedClassnames select _configIndex)),_classname]; //Classname considered valid, no need to check it again
		};
	};
	
	_result
};

DZAI_abortDynSpawn = {
	private["_trigger"];
	_trigger = _this;
	
	DZAI_dynTriggerArray = DZAI_dynTriggerArray - [_trigger];
	//DZAI_actDynTrigs = DZAI_actDynTrigs - 1;
	//DZAI_curDynTrigs = DZAI_curDynTrigs - 1;
	if ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled}) then {deleteMarker format["trigger_%1",_trigger]};

	deleteVehicle _trigger;
	
	false
};

/*DZAI_markerMonitor = {
	private ["_groupMarkers","_marker"];
	_unitGroup = _this select 0;
	_marker = _this select 1;
	
	if ((getMarkerColor _marker) != "") then {
		if (isNil {_unitGroup getVariable "markerslist"}) then {_unitGroup setVariable ["markerslist",[]]};
		_groupMarkers = _unitGroup getVariable "markerslist";
		_groupMarkers set [count _groupMarkers,_marker];
		
		_groupMarkers
	};
};*/

DZAI_updateUnitCount = {
	if (((typeName _this) == "SCALAR") && {(_this >= 0)}) then {
		DZAI_numAIUnits = _this;
		true
	} else {
		diag_log "DZAI Error: Tried to update AI count using invalid value type!";
		false
	};
};

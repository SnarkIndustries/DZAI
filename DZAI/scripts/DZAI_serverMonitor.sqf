//Function frequency definitions
#define CLEANDEAD_FREQ 600
#define VEHICLE_CLEANUP_FREQ 900
#define LOCATION_CLEANUP_FREQ 360
#define RANDSPAWN_CHECK_FREQ 360
#define RANDSPAWN_EXPIRY_TIME 1080
#define SIDECHECK_TIME 900

if (DZAI_debugLevel > 0) then {diag_log "DZAI Server Monitor will start in 1 minute."};

//Initialize timer variables
_cleanDead = diag_tickTime;
_monitorReport = diag_tickTime;
_deleteObjects = diag_tickTime;
_dynLocations = diag_tickTime;
_checkRandomSpawns = diag_tickTime;
_sideCheck = diag_tickTime;

//Define settings
_reportDynOrVehicles = (DZAI_dynAISpawns || ((DZAI_maxHeliPatrols > 0) or {(DZAI_maxLandPatrols > 0)}) || (DZAI_maxRandomSpawns > 0));
_debugMarkers = ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled});

//Local functions
_getUptime = {
	private ["_currentSec","_outSec","_outMin","_outHour"];
	_currentSec = diag_tickTime;
	_outHour = floor (_currentSec/3600);
	_outMin = floor ((_currentSec - (_outHour*3600))/60);
	_outSec = floor (_currentSec - (_outHour*3600) - (_outMin*60));
	
	[_outHour,_outMin,_outSec]
};

_purgeEH = {
	{_this removeAllEventHandlers _x} count ["Killed","HandleDamage","GetIn","GetOut","Fired"];
};

uiSleep 60;

while {true} do {
	//Main cleanup loop
	if ((diag_tickTime - _cleanDead) > CLEANDEAD_FREQ) then {
		_bodiesCleaned = 0;
		_vehiclesCleaned = 0;
		_nullObjects = 0;
		
		//Body/vehicle cleanup loop
		{
			_deathTime = _x getVariable "DZAI_deathTime";
			/*
			if (!isNil "_deathTime") then {
				diag_log format ["DZAI Cleanup Debug: Checking unit %1 (%2). diag_tickTime: %3. deathTime: %4.",_x,typeOf _x,diag_tickTime,_deathTime];
				diag_log format ["DZAI Cleanup Debug: is CAManBase: %1. Timer complete: %2. No players: %3.",(_x isKindOf "CAManBase"),((diag_tickTime - _deathTime) > DZAI_cleanupDelay),(({isPlayer _x} count (_x nearEntities [["CAManBase","AllVehicles"],30])) == 0)];
			};*/
			if (!isNil "_deathTime") then {
				if (_x isKindOf "CAManBase") then {
					//diag_log "DZAI Cleanup Debug: Unit type is CAManBase";
					if ((diag_tickTime - _deathTime) > DZAI_cleanupDelay) then {
						//diag_log "DZAI Cleanup Debug: Timer complete, checking for nearby players";
						if (({isPlayer _x} count (_x nearEntities [["CAManBase","AllVehicles"],30])) == 0) then {
							//diag_log "DZAI Cleanup Debug: No nearby players. Deleting unit";
							_soundflies = _x getVariable "sound_flies";
							if (!isNil "_soundflies") then {
								detach _soundflies;
								deleteVehicle _soundflies;
							};
							_x call _purgeEH;
							//diag_log format ["DEBUG :: Deleting object %1 (type: %2).",_x,typeOf _x];
							deleteVehicle _x;
							_bodiesCleaned = _bodiesCleaned + 1;
						};
					};
				} else {
					if (_x isKindOf "AllVehicles") then {
						if ((diag_tickTime - _deathTime) > VEHICLE_CLEANUP_FREQ) then {
							if (({isPlayer _x} count (_x nearEntities [["CAManBase","AllVehicles"],75])) == 0) then {
								if (_x in DZAI_monitoredObjects) then {
									{
										if (!(alive _x)) then {
											deleteVehicle _x;
										};
									} forEach (crew _x);
									//diag_log format ["DEBUG :: Object %1 (type: %2) found in server object monitor.",_x,typeOf _x];
								};
								_x call _purgeEH;
								//diag_log format ["DEBUG :: Deleting object %1 (type: %2).",_x,typeOf _x];
								deleteVehicle _x;
								_vehiclesCleaned = _vehiclesCleaned + 1;
							};
						};
					};
				};
			};
			uiSleep 0.025;
		} count allDead;
		
		//Clean abandoned AI vehicles
		{	
			if (!isNull _x) then {
				private ["_deathTime"];
				_deathTime = _x getVariable "DZAI_deathTime";
				if (!isNil "_deathTime") then {
					if ((diag_tickTime - _deathTime) > VEHICLE_CLEANUP_FREQ) then {
						_x call _purgeEH;
						//diag_log format ["DEBUG :: Deleting object %1 (type: %2).",_x,typeOf _x];
						{
							if (!alive _x) then {
								deleteVehicle _x;
							};
						} forEach (crew _x);
						deleteVehicle _x;
						_vehiclesCleaned = _vehiclesCleaned + 1;
						_nullObjects = _nullObjects + 1;
					};
				};
			} else {
				_nullObjects = _nullObjects + 1;
			};
			uiSleep 0.025;
		} count DZAI_monitoredObjects;

		//Clean server object monitor
		if (_nullObjects > 4) then {
			missionNamespace setVariable [DZAI_serverObjectMonitor,((missionNamespace getVariable DZAI_serverObjectMonitor) - [objNull])];
			DZAI_monitoredObjects = DZAI_monitoredObjects - [objNull];
			diag_log format ["DZAI Cleanup: Cleaned up %1 null objects from server object monitor.",_nullObjects];
		};
		if ((_bodiesCleaned + _vehiclesCleaned) > 0) then {diag_log format ["DZAI Cleanup: Cleaned up %1 dead units and %2 destroyed vehicles.",_bodiesCleaned,_vehiclesCleaned]};
		_cleanDead = diag_tickTime;
	};

	//Main location cleanup loop
	if ((diag_tickTime - _dynLocations) > LOCATION_CLEANUP_FREQ) then {
		_locationsDeleted = 0;
		DZAI_tempBlacklist = DZAI_tempBlacklist - [locationNull];
		//diag_log format ["DEBUG :: DZAI_tempBlacklist: %1",DZAI_tempBlacklist];
		{
			_deletetime = _x getVariable "deletetime";
			if (diag_tickTime > _deletetime) then {
				deleteLocation _x;
				_locationsDeleted = _locationsDeleted + 1;
			};
			uiSleep 0.025;
		} count DZAI_tempBlacklist;
		DZAI_tempBlacklist = DZAI_tempBlacklist - [locationNull];
		if (_locationsDeleted > 0) then {diag_log format ["DZAI Cleanup: Cleaned up %1 expired temporary blacklist areas.",_locationsDeleted]};
		_dynLocations = diag_tickTime;
	};

	if ((diag_tickTime - _checkRandomSpawns) > RANDSPAWN_CHECK_FREQ) then {
		DZAI_randTriggerArray = DZAI_randTriggerArray - [objNull];
		{
			if ((((triggerStatements _x) select 1) != "") && {(diag_tickTime - (_x getVariable ["timestamp",diag_tickTime])) > RANDSPAWN_EXPIRY_TIME}) then {
				deleteLocation (_x getVariable ["triggerLocation",locationNull]);
				if (_debugMarkers) then {deleteMarker (str _x)};	
				deleteVehicle _x;
			};
			if ((_forEachIndex % 3) == 0) then {uiSleep 0.05};
		} forEach DZAI_randTriggerArray;
		DZAI_randTriggerArray = DZAI_randTriggerArray - [objNull];
		_spawnsAvailable = DZAI_maxRandomSpawns - (count DZAI_randTriggerArray);
		if (_spawnsAvailable > 0) then {
			_nul = _spawnsAvailable spawn DZAI_createRandomSpawns;
		};
		_checkRandomSpawns = diag_tickTime;
	};
	
	if ((diag_tickTime - _sideCheck) > SIDECHECK_TIME) then {
		if ((east getFriend west) > 0) then {
			east setFriend [west, 0];
		};
		if ((west getFriend east) > 0) then {
			west setFriend [east,0];
		};
		_sideCheck = diag_tickTime;
	};
	
	if (_debugMarkers) then {
		{
			if ((getMarkerColor _x) != "") then {
				_x setMarkerPos (getMarkerPos _x);
			} else {
				DZAI_mapMarkerArray set [_forEachIndex,""];
			};
			if ((_forEachIndex % 3) == 0) then {uiSleep 0.05};
		} forEach DZAI_mapMarkerArray;
		DZAI_mapMarkerArray = DZAI_mapMarkerArray - [""];
	};
	
	//Report statistics to RPT log
	if ((DZAI_monitorRate > 0) && {((diag_tickTime - _monitorReport) > DZAI_monitorRate)}) then {
		_uptime = [] call _getUptime;
		diag_log format ["DZAI Monitor :: Server Uptime: %1:%2:%3. Active AI Groups: %4.",_uptime select 0, _uptime select 1, _uptime select 2,({!isNull _x} count DZAI_activeGroups)];
		diag_log format ["DZAI Monitor :: Static Spawns: %1. Respawn Queue: %2 groups queued.",(count DZAI_staticTriggerArray),(count DZAI_respawnQueue)];
		if (_reportDynOrVehicles) then {diag_log format ["DZAI Monitor :: Dynamic Spawns: %1. Random Spawns: %2. Air Patrols: %3. Land Patrols: %4.",(count DZAI_dynTriggerArray),(count DZAI_randTriggerArray),DZAI_curHeliPatrols,DZAI_curLandPatrols];};
		_monitorReport = diag_tickTime;
	};

	uiSleep 30;
};

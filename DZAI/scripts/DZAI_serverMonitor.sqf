
if (DZAI_debugLevel > 0) then {diag_log "DZAI Server Monitor will start in 1 minute."};

_vehiclesEnabled = ((DZAI_maxHeliPatrols > 0) or {(DZAI_maxLandPatrols > 0)});
_cleanDead = diag_tickTime;
_monitorReport = diag_tickTime;
_deleteObjects = diag_tickTime;
_dynLocations = diag_tickTime;
_purgeCounter = 0;
_reportDynOrVehicles = (DZAI_dynAISpawns || _vehiclesEnabled);
uiSleep 60;

while {true} do {
	if ((time - _cleanDead) >= 300) then {	//Check every 5 minutes if any dead objects (units or vehicles) can be removed
		_deadCleaned = 0;
		{
			_deathTime = _x getVariable "DZAI_deathTime";
			if (!isNil "_deathTime") then {
				if (time > _deathTime) then {
					if (({isPlayer _x} count (_x nearEntities [["CAManBase","LandVehicle"], 20])) == 0) then {
						_soundflies = _x getVariable "sound_flies";
						if (!isNil "_soundflies") then {
							detach _soundflies;
							deleteVehicle _soundflies;
						};
						if (_x in DZAI_monitoredObjects) then {
							_purgeCounter = _purgeCounter + 1;
							//diag_log format ["DEBUG :: Object %1 (type: %2) found in server object monitor.",_x,typeOf _x];
						};
						_x call DZAI_purgeEH;
						//diag_log format ["DEBUG :: Deleting object %1 (type: %2).",_x,typeOf _x];
						deleteVehicle _x;
						_deadCleaned = _deadCleaned + 1;
					};
				};
			};
			uiSleep 0.005;
		} count allDead;
		
		{	//Clean abandoned AI vehicles
			_deathTime = _x getVariable "DZAI_deathTime";
			if (!isNil "_deathTime") then {
				if (time > _deathTime) then {
					_x call DZAI_purgeEH;
					//diag_log format ["DEBUG :: Deleting object %1 (type: %2).",_x,typeOf _x];
					deleteVehicle _x;
					_deadCleaned = _deadCleaned + 1;
					_purgeCounter = _purgeCounter + 1;
				};
			};
			uiSleep 0.005;
		} count DZAI_monitoredObjects;

		if (_purgeCounter > 4) then {
			missionNamespace setVariable [DZAI_serverObjectMonitor,((missionNamespace getVariable DZAI_serverObjectMonitor) - [objNull])];
			DZAI_monitoredObjects = DZAI_monitoredObjects - [objNull];
			if (_deadCleaned > 0) then {diag_log format ["DZAI Cleanup: Cleaned up %1 null objects from server object monitor.",_purgeCounter]};
			_purgeCounter = 0;
		};
		if (_deadCleaned > 0) then {diag_log format ["DZAI Cleanup: Cleaned up %1 dead units/vehicles.",_deadCleaned]};
		_cleanDead = diag_tickTime;
	};

	if ((time - _dynLocations) >= 360) then { //clean up locations every 6 minutes
		_locationsDeleted = 0;
		{
			_deletetime = _x getVariable "deletetime";
			if (time > _deletetime) then {
				deleteLocation _x;
				_locationsDeleted = _locationsDeleted + 1;
			};
			uiSleep 0.005;
		} count DZAI_dynLocations;
		DZAI_dynLocations = DZAI_dynLocations - [locationNull];
		if (_locationsDeleted > 0) then {diag_log format ["DZAI Cleanup: Cleaned up %1 expired dynamic blacklist areas.",_locationsDeleted]};
		_dynLocations = diag_tickTime;
	};
	
	if ((DZAI_monitorRate > 0) && {((time - _monitorReport) >= DZAI_monitorRate)}) then {
		_uptime = [] call DZAI_getUptime;
		diag_log format ["DZAI Monitor :: Server Uptime: [%1d %2h %3m %4s]. Active AI Units: %5.",_uptime select 0, _uptime select 1, _uptime select 2, _uptime select 3,DZAI_numAIUnits];
		diag_log format ["DZAI Monitor :: Static Spawns: %1. Respawn Queue: %2 groups queued.",({triggerActivated _x} count DZAI_staticTriggerArray),(count DZAI_respawnQueue)];
		if (_reportDynOrVehicles) then {diag_log format ["DZAI Monitor :: Dynamic Spawns: %1. Air Patrols: %2. Land Patrols: %3.",({triggerActivated _x} count DZAI_dynTriggerArray),DZAI_curHeliPatrols,DZAI_curLandPatrols];};
		_monitorReport = diag_tickTime;
	};
	
	uiSleep 30;
};
_nul = [] execVM format ['%1\scripts\DZAI_serverMonitor.sqf',DZAI_directory]; //restart DZAI server monitor if main loop exits for some reason.

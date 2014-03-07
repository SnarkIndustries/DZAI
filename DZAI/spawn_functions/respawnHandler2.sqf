/*
	fnc_respawnHandler
	
	Description: Creates a queue for AI groups requiring respawn. Terminates when the queue has been processed and cleared. Queue is recreated with the first AI group KIA.
	
	Usage: [_trigger,_unitGroup] spawn fnc_respawnHandler (for infantry-type AI units), ["AIR] spawn fnc_respawnHandler (for Air-type AI patrols), ["land"] spawn fnc_respawnHandler (for Land-type AI patrols)
	
	Last updated: 8:46 PM 12/2/2013
*/

#define PROCESSING_WAIT_TIME 5 //Minimum time delay between respawns.

private ["_respawnSleep","_nextRespawnTime"];

if ((count _this) > 1) then {
	private["_trigger","_unitGroup","_fastMode"];
	//Add group to respawn queue.
	_trigger = _this select 0; //attached variables: isCleaning, GroupArray, patrolDist, equipType, locationArray, maxUnits, initialized
	_unitGroup = _this select 1;
	_fastMode = if ((count _this) > 2) then {_this select 2} else {false};
	_respawnSleep = (DZAI_respawnTimeMin + random (DZAI_respawnTimeMax - DZAI_respawnTimeMin));	//Calculate wait time for respawn
	if (_fastMode) then {_respawnSleep = (_respawnSleep/2) max 60};
	_nextRespawnTime = (time + _respawnSleep);	//Determine time of next respawn
	DZAI_respawnQueue set [(count DZAI_respawnQueue),[time + _respawnSleep,_trigger,_unitGroup]];
	if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Added Group %1 to respawn queue. Queue position %2. Wait Time %3 (respawnHandler)",_unitGroup,(count DZAI_respawnQueue),_respawnSleep];};
} else {
	private["_patrolType"];
	//Add vehicle patrol to respawn queue.
	_patrolType = _this select 0;
	_respawnSleep = switch (toLower _patrolType) do {
		case "air": {(DZAI_respawnTMinA + random (DZAI_respawnTMaxA - DZAI_respawnTMinA))};
		case "land": {(DZAI_respawnTMinL + random (DZAI_respawnTMaxL - DZAI_respawnTMinL))};
		case default {600};
	};
	_nextRespawnTime = (time + _respawnSleep);	//Determine time of next respawn
	DZAI_respawnQueue set [(count DZAI_respawnQueue),[time + _respawnSleep,_patrolType]];
	if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Added AI vehicle patrol type %1 to respawn queue. Queue position %2. Wait Time %3 (respawnHandler)",_patrolType,(count DZAI_respawnQueue),_respawnSleep];};
};

if (!isNil "DZAI_respawnActive") exitWith {}; 		//If the first respawn has already occured, no need to modify the initial wait time.

if (!isNil "DZAI_nextRespawnTime") then {
	if (_nextRespawnTime < DZAI_nextRespawnTime) then {	//If the newest respawn is scheduled to happen sooner than the next closest respawn, reduce the initial wait time appropriately.
		DZAI_nextRespawnTime = _nextRespawnTime;		//Time of next spawn
		if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Decreased time to next respawn to %1 seconds.",_respawnSleep];};
	};
} else {
	DZAI_nextRespawnTime = _nextRespawnTime;
	if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Time to first respawn set to %1 seconds.",_respawnSleep];};
};

if (!isNil "DZAI_queueActive") exitWith {};
DZAI_queueActive = true;							//The respawn queue is established, so don't create another one until it's finished.

while {time < DZAI_nextRespawnTime} do {				//Check if it's time to process the first respawn (5 checks per minute).
	sleep 12;
};

DZAI_respawnActive = true;							//First respawn is now being processed, so deny subsequent attempts to modify the initial wait time.
DZAI_queueActive = nil;
DZAI_nextRespawnTime = nil;

while {(count DZAI_respawnQueue) > 0} do {
	private ["_minDelay","_delay"];

	_minDelay = -1;
	//diag_log format ["DEBUG: Contents of respawn queue before cleanup stage 1: %1.",DZAI_respawnQueue];
	//Remove expired entries before proceeding.
	{
		if (isNull (_x select 2)) then {
			DZAI_respawnQueue set [_forEachIndex,objNull];
		};
	} forEach DZAI_respawnQueue;
	//diag_log format ["DEBUG: Contents of respawn queue before cleanup stage 2: %1.",DZAI_respawnQueue];
	DZAI_respawnQueue = DZAI_respawnQueue - [objNull];
	//diag_log format ["DEBUG: Contents of respawn queue after cleanup: %1.",DZAI_respawnQueue];
	
	//Begin examining queue entries.
	for "_i" from 0 to ((count DZAI_respawnQueue) - 1) do {
		private["_timeToRespawn"];
		_timeToRespawn = (DZAI_respawnQueue select _i) select 0;
		//If enough time has passed to respawn the group.
		if (time >= _timeToRespawn) then {
			private["_trigger"];
			_trigger = (DZAI_respawnQueue select _i) select 1;
			switch (typeName _trigger) do {
				case "OBJECT":{
					private["_unitGroup","_grpArray"];
					_unitGroup = (DZAI_respawnQueue select _i) select 2;
					_grpArray = _trigger getVariable "GroupArray";
					if ((_unitGroup in _grpArray) && {((_unitGroup getVariable ["GroupSize",0]) == 0)}) then {
						private["_maxUnits","_respawned"];
						_maxUnits = _trigger getVariable "maxUnits";
						_respawned = [_unitGroup,_trigger,_maxUnits] call fnc_respawnBandits;
						if (!_respawned) then {if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: No units were respawned for group %1 at %2. Group %1 reinserted into respawn queue.",_unitGroup,(mapGridPosition _trigger)];};};
					};
				};
				case "STRING": {
					if ((toLower _trigger) == "air") then {
						_helipatrols = 1 spawn DZAI_spawnHeliPatrol;
					} else {
						if ((toLower _trigger) == "land") then {
							_vehpatrols = 1 spawn DZAI_spawnVehPatrol;
						};
					};
				};
			};
			DZAI_respawnQueue set [_i,objNull];
			sleep PROCESSING_WAIT_TIME;
		} else {
			//Find shortest delay to next group respawn.
			_delay = ((_timeToRespawn - time) max PROCESSING_WAIT_TIME);
			//diag_log format ["DEBUG :: Comparing new respawn time %1 with previous %2.",_delay,_minDelay];
			if (_minDelay > 0) then {
				//If next delay time is smaller than the current minimum delay, use it instead.
				if (_delay < _minDelay) then {
					_minDelay = _delay;
					//diag_log format ["DEBUG :: Found shorter respawn interval: %1 seconds.",_minDelay];
				};
			} else {
				//Initialize minimum delay to first found delay.
				_minDelay = _delay;
				//diag_log format ["DEBUG :: Set respawn interval to %1 seconds.",_minDelay];
			};
		};
	};
	//Remove processed entries
	DZAI_respawnQueue = DZAI_respawnQueue - [objNull];
	if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: %1 groups left in respawn queue. Next group is scheduled to respawn in %2 seconds.",(count DZAI_respawnQueue),_minDelay];};
	sleep _minDelay;
};

DZAI_respawnActive = nil;
if (DZAI_debugLevel > 0) then {diag_log "DZAI Debug: Respawn queue is empty. Exiting respawn handler. (respawnHandler)";};

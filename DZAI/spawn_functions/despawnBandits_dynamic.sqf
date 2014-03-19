/*
	despawnBandits_dynamic

	Last updated: 10:57 PM 3/10/2014
	
*/

private ["_trigger","_isCleaning","_triggerLocation","_isForceDespawn","_grpArray","_canDespawn","_triggerExists"];
if (!isServer) exitWith {};										//Execute script only on server.

_trigger = _this select 0;										//Get the trigger object
_isForceDespawn = if ((count _this) > 1) then {_this select 1} else {false};

_grpArray = _trigger getVariable ["GroupArray",[]];				//Find the groups spawned by the trigger. Or set an empty group array if none are found.

if ((_trigger getVariable ["isCleaning",false]) && (!_isForceDespawn)) exitWith {if (DZAI_debugLevel > 1) then {diag_log "DZAI Extended Debug: Despawn script is already running. Exiting despawn script.";};};

_trigger setVariable["isCleaning",true];			//Mark the trigger as being in a cleanup state so that subsequent requests to despawn for the same trigger will not run.

//Begin despawn timer if dynamic trigger is not forced to despawn. If player is present in area after timer expires, cancel despawn
_canDespawn = true;
_triggerExists = true;
if !(_isForceDespawn) then {
	if (DZAI_debugLevel > 1) then {diag_log format["DZAI Extended Debug: No players remain in %1 %2. Deleting spawned AI in %3 seconds.",triggerText _trigger,mapGridPosition _trigger,DZAI_dynDespawnWait];};
	
	if ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled}) then {
		private["_marker"];
		_marker = format["trigger_%1",_trigger];
		_marker setMarkerColor "ColorGreenAlpha";
		_marker setMarkerAlpha 0.7;							//Light green: Active trigger awaiting despawn.
	};
	
	sleep DZAI_dynDespawnWait;								//Wait some time before deleting units. (amount of time to allow units to exist when the trigger area has no players)

	if !(isNull _trigger) then {							//Check if dynamic spawn area has been force-despawned (deleted). Force despawn will happen when all units have been killed.
		_canDespawn = !(triggerActivated _trigger);			//Can despawn dynamic spawn area if trigger isn't activated.
	} else {
		_triggerExists = false;
	};
};

if !(_triggerExists) exitWith {};							//Cancel despawn process if it has already happened

if (_canDespawn) then {
	if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Cleaning up expired dynamic trigger at %1.",mapGridPosition _trigger];};
	
	if !(_isForceDespawn) then {
		{
			if ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled}) then {
				{
					deleteMarker (str _x);
				} forEach (waypoints _x);
				sleep 0.1;
			};
			//DZAI_numAIUnits = DZAI_numAIUnits - (_x getVariable ["GroupSize",0]);	//Update active AI count
			(DZAI_numAIUnits - (_x getVariable ["groupSize",0])) call DZAI_updateUnitCount;
			{
				if (alive _x) then {
					deleteVehicle _x;
				};
			} forEach (units _x);							//Delete live units
			sleep 0.5;
			deleteGroup _x;													//Delete the group after its units are deleted.
			sleep 0.1;
		} forEach _grpArray;	
	} else {
		_grpArray = _grpArray - [grpNull];
		{
			if ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled}) then {
				{
					deleteMarker (str _x);
				} forEach (waypoints _x);
			};
			sleep 0.1;
			deleteGroup _x;
		} forEach _grpArray;
	};
	
	//Remove dynamic trigger from global dyn trigger array and clean up trigger
	DZAI_dynTriggerArray = DZAI_dynTriggerArray - [_trigger];
	if ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled}) then {deleteMarker format["trigger_%1",_trigger]};

	//Begin deletion timer for temporary blacklist area and add it to global dyn location array to allow deletion
	_triggerLocation = _trigger getVariable "triggerLocation";
	_triggerLocation setVariable ["deletetime",(time + 900)];
	DZAI_dynLocations set [(count DZAI_dynLocations),_triggerLocation];

	deleteVehicle _trigger;

	true
} else {
	if (DZAI_debugLevel > 1) then {diag_log "DZAI Extended Debug: A player has entered the trigger area. Cancelling despawn script.";}; //Exit script if trigger has been reactivated since DZAI_dynDespawnWait seconds has passed.
	_trigger setVariable ["isCleaning",false];	//Allow next despawn request.
	if ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled}) then {
		private["_marker"];
		_marker = format["trigger_%1",_trigger];
		_marker setMarkerColor "ColorOrange";
		_marker setMarkerAlpha 0.9;						//Reset trigger indicator color to Active.
	};
	false
};
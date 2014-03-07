/*
	vehicle Resupply
	
	Description: Handles automatic refueling and resupplying ammo for AI vehicle. Destroys vehicle if pilot is killed and allows another AI vehicle to be respawned.
	
	Last updated: 4:44 PM 8/2/2013
	
*/

if (!isServer) exitWith {};

private ["_vehicle","_vehWeapons","_markername","_marker","_startTime","_timePatrolled","_unitGroup","_wpmarkername","_wpmarker","_vehOK","_driverOK"];

_vehicle = _this select 0;
_vehWeapons = weapons _vehicle;
_unitGroup = _vehicle getVariable "unitGroup";

waitUntil {sleep 0.1; (!isNil "_vehWeapons" && !isNull (driver _vehicle))};

{
	if (_x in ["CarHorn","BikeHorn","TruckHorn","TruckHorn2","SportCarHorn","MiniCarHorn"]) then {
		if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Removed vehicle weapon %1 from AI group %2 vehicle %3.",_x,_unitGroup,typeOf _vehicle];};
		_vehWeapons = _vehWeapons - [_x];
	};
} forEach _vehWeapons;
_startTime = time;

_vehOK = true;
_driverOK = true;

if ((count _vehWeapons) > 0) then {
	while {_vehOK && {_driverOK}} do {	
		//Check if vehicle ammunition needs to be replenished
		{
			if ((_vehicle ammo _x) < 20) then {
				_vehicle setVehicleAmmo 1;
				if (DZAI_debugLevel > 1) then {diag_log "DZAI Extended Debug: Reloaded ammo for AI patrol vehicle.";};
			};
		} forEach _vehWeapons;
		
		//Check if vehicle fuel is low
		if (fuel _vehicle < 0.20) then {
			_vehicle setFuel 1;
			if (DZAI_debugLevel > 1) then {diag_log "DZAI Extended Debug: Refueled AI patrol vehicle.";};
		};
		
		sleep DZAI_refreshRate;
		
		_vehOK = ((alive _vehicle)&& {(!(isNull _vehicle))} && {(canMove _vehicle)});
		_driverOK = ((!(isNull (driver _vehicle))) && {(alive (driver _vehicle))});
	};
} else {
	while {_vehOK && {_driverOK}} do {		
		//Check if vehicle fuel is low
		if (fuel _vehicle < 0.20) then {
			_vehicle setFuel 1;
			if (DZAI_debugLevel > 1) then {diag_log "DZAI Extended Debug: Refueled AI patrol vehicle.";};
		};

		sleep DZAI_refreshRate;
		
		_vehOK = ((alive _vehicle)&& {(!(isNull _vehicle))} && {(canMove _vehicle)});
		_driverOK = ((!(isNull (driver _vehicle))) && {(alive (driver _vehicle))});
	};
};

_timePatrolled = time - _startTime;
sleep 0.5;

if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: AI vehicle patrol disabled at %1 after %2 seconds of activity.",(getPosATL _vehicle),_timePatrolled];};
if (_timePatrolled < 35) then {
	diag_log "DZAI Warning: An AI vehicle was disabled less than 35 seconds after being spawned. Please check if server_cleanup.fsm was edited properly.";
};

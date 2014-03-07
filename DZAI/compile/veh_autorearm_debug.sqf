/*
	Vehicle Resupply (Debug Version)
	
	Description: Handles automatic refueling and resupplying ammo for AI Vehicle. Destroys Vehicle if pilot is killed and allows another AI Vehicle to be respawned.
	
	Last updated: 4:44 PM 8/2/2013
	
*/

if (!isServer) exitWith {};

private ["_vehicle","_vehWeapons","_markername","_marker","_startTime","_timePatrolled","_unitGroup","_wpmarkername","_wpmarker","_vehOK","_driverOK"];

_vehicle = _this select 0;
_vehWeapons = weapons _vehicle;
_unitGroup = _vehicle getVariable "unitGroup";

//Create debug position markers. Vehicle position: Red, Current waypoint position: Blue.
_markername = format["Vehicle_%1",_vehicle];
if ((getMarkerColor _markername) != "") then {deleteMarker _markername; sleep 5;};	//Delete the previous marker if it wasn't deleted for some reason.
//diag_log format ["Vehicle marker name is %1.",_markername];
_marker = createMarker[_markername,(getposATL _vehicle)];
_marker setMarkerText format ["AI %1 %2",(typeOf _vehicle),_unitGroup];
_marker setMarkerType "Attack";
_marker setMarkerColor "ColorRed";
_marker setMarkerBrush "Solid";
//_marker setMarkerSize [50, 50];

diag_log format ["Vehicle is part of group %1.",_unitGroup];
_wpmarkername = format ["VehWP_%1",_vehicle];
if ((getMarkerColor _wpmarkername) != "") then {deleteMarker _markername};	//Delete the previous marker if it wasn't deleted for some reason.
//diag_log format ["Vehicle waypoint name is %1.",_wpmarkername];
_wpmarker = createMarker[_wpmarkername,(getWPPos [_unitGroup,0])];
_wpmarker setMarkerShape "ELLIPSE";
_wpmarker setMarkerType "Dot";
_wpmarker setMarkerColor "ColorBrown";
_wpmarker setMarkerBrush "SolidBorder";
_wpmarker setMarkerSize [100, 100];


//Wait until Vehicle has pilot and script has finished finding Vehicle's weapons.
waitUntil {sleep 0.1; (!isNil "_vehWeapons" && !isNull (driver _vehicle))};

{
	if (_x in ["CarHorn","BikeHorn","TruckHorn","TruckHorn2","SportCarHorn","MiniCarHorn"]) then {
		if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Removed vehicle weapon %1 from AI group %2 vehicle %3.",_x,_unitGroup,typeOf _vehicle];};
		_vehWeapons = _vehWeapons - [_x];
	};
} forEach _vehWeapons;

if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Vehicle %1 driver is %2. Crew is %3. Vehicle weapons: %4.",(typeOf _vehicle),(driver _vehicle),(crew _vehicle),_vehWeapons];};
_startTime = time;

_vehOK = true;
_driverOK = true;



if ((count _vehWeapons) > 0) then {
	//For armed air vehicles
	while {_vehOK && {_driverOK}} do {		
		//Check if Vehicle ammunition needs to be replenished
		{
			if ((_vehicle ammo _x) < 20) then {
				_vehicle setVehicleAmmo 1;
				if (DZAI_debugLevel > 1) then {diag_log "DZAI Extended Debug: Reloaded ammo for AI patrol Vehicle.";};
			};
		} forEach _vehWeapons;
		
		//Check if Vehicle fuel is low
		if (fuel _vehicle < 0.20) then {
			_vehicle setFuel 1;
			if (DZAI_debugLevel > 1) then {diag_log "DZAI Extended Debug: Refueled AI patrol Vehicle.";};
		};
		
		//Update Vehicle position and waypoint markers
		_marker setMarkerPos (getposATL _vehicle);
		_wpmarker setMarkerPos (getWPPos [_unitGroup,0]);

		sleep DZAI_refreshRate;
		
		_vehOK = ((alive _vehicle)&& {(!(isNull _vehicle))} && {(canMove _vehicle)});
		_driverOK = ((!(isNull (driver _vehicle))) && {(alive (driver _vehicle))});
	};
} else {
	//For unarmed air vehicles
	while {_vehOK && _driverOK} do {		
		//Check if Vehicle fuel is low
		if (fuel _vehicle < 0.20) then {
			_vehicle setFuel 1;
			if (DZAI_debugLevel > 1) then {diag_log "DZAI Extended Debug: Refueled AI patrol Vehicle.";};
		};
		
		//Update Vehicle position and waypoint markers
		_marker setMarkerPos (getposATL _vehicle);
		_wpmarker setMarkerPos (getWPPos [_unitGroup,0]);

		sleep DZAI_refreshRate;
		
		_vehOK = ((alive _vehicle)&& {(!(isNull _vehicle))} && {(canMove _vehicle)});
		_driverOK = ((!(isNull (driver _vehicle))) && {(alive (driver _vehicle))});
	};
};

//Report length of time Vehicle patrol was active. Add a warning entry to RPT log if Vehicle was destroyed unusually early (< 30 seconds), likely due to the server admin forgetting to edit the server_cleanup.fsm.
_timePatrolled = time - _startTime;
sleep 0.5;

//Cleanup Vehicle and waypoint markers
deleteMarker _marker;
deleteMarker _wpmarker;

if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: AI Vehicle patrol disabled at %1 after %2 seconds of flight.",(getPosATL _vehicle),_timePatrolled];};
if (_timePatrolled < 35) then {
	diag_log "DZAI Warning: An AI Vehicle was disabled less than 35 seconds after being spawned. Please check if server_cleanup.fsm was edited properly.";
};

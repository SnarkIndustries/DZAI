/*
	Helicopter Resupply (Debug Version)
	
	Description: Handles automatic refueling and resupplying ammo for AI helicopter. Destroys helicopter if pilot is killed and allows another AI helicopter to be respawned.
	
	Last updated: 4:44 PM 8/2/2013
	
*/

if (!isServer) exitWith {};

private ["_helicopter","_heliWeapons","_markername","_marker","_startTime","_timePatrolled","_unitGroup","_wpmarkername","_wpmarker","_baseHeight","_nearTargets"];

_helicopter = _this select 0;
_heliWeapons = weapons _helicopter;
_unitGroup = _helicopter getVariable "unitGroup";

_baseHeight = if ((typeOf _helicopter) isKindOf "Helicopter") then {100} else {125};
//Create debug position markers. Helicopter position: Red, Current waypoint position: Blue.
_markername = format["Helicopter_%1",_helicopter];
if ((getMarkerColor _markername) != "") then {deleteMarker _markername; sleep 5;};	//Delete the previous marker if it wasn't deleted for some reason.
//diag_log format ["Helicopter marker name is %1.",_markername];
_marker = createMarker[_markername,(getposATL _helicopter)];
_marker setMarkerText format ["AI %1 (Health: %2)",(typeOf _helicopter),"???"];
_marker setMarkerType "Attack";
_marker setMarkerColor "ColorRed";
_marker setMarkerBrush "Solid";
//_marker setMarkerSize [50, 50];

diag_log format ["Helicopter is part of group %1.",_unitGroup];
_wpmarkername = format ["[%1,%2]",_unitGroup,_helicopter];
if ((getMarkerColor _wpmarkername) != "") then {deleteMarker _markername};	//Delete the previous marker if it wasn't deleted for some reason.
//diag_log format ["Helicopter waypoint name is %1.",_wpmarkername];
_wpmarker = createMarker[_wpmarkername,(getWPPos [_unitGroup,0])];
_wpmarker setMarkerShape "ELLIPSE";
_wpmarker setMarkerType "Dot";
_wpmarker setMarkerColor "ColorBlue";
_wpmarker setMarkerBrush "SolidBorder";
_wpmarker setMarkerSize [100, 100];

//Wait until helicopter has pilot and script has finished finding helicopter's weapons.
waitUntil {sleep 0.1; (!isNil "_heliWeapons" && {!isNull (driver _helicopter)})};
if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Helicopter %1 driver is %2. Crew is %3. Vehicle weapons: %4.",(typeOf _helicopter),(driver _helicopter),(crew _helicopter),_heliWeapons];};
_startTime = time;

if ((count _heliWeapons) > 0) then {
	//For armed air vehicles
	while {!(_helicopter getVariable ["heli_disabled",false]) && {alive _helicopter}} do {	
		//Check if helicopter ammunition needs to be replenished
		{
			if ((_helicopter ammo _x) < 20) then {
				_helicopter setVehicleAmmo 1;
				if (DZAI_debugLevel > 1) then {diag_log "DZAI Extended Debug: Reloaded ammo for AI patrol helicopter.";};
			};
		} forEach _heliWeapons;
		
		//Check if helicopter fuel is low
		if (fuel _helicopter < 0.20) then {
			_helicopter setFuel 1;
			if (DZAI_debugLevel > 1) then {diag_log "DZAI Extended Debug: Refueled AI patrol helicopter.";};
		};
				
		//Update helicopter position and waypoint markers
		_marker setMarkerText format ["AI %1 (Health: %2)",(typeOf _helicopter),(_helicopter getVariable "durability")];
		_marker setMarkerPos (getposATL _helicopter);
		_wpmarker setMarkerPos (getWPPos [_unitGroup,0]);
		
		//Destroy helicopter if pilot is killed
		if ((!alive (driver _helicopter))&&{(isEngineOn _helicopter)}) exitWith {
			if (DZAI_debugLevel > 0) then {diag_log "DZAI Debug: Patrol helicopter pilot killed, helicopter is going down!";};
			_helicopter setFuel 0;
			_helicopter setVehicleAmmo 0;
			_helicopter setDamage 1;
		};

		//Uncomment to test despawn/respawn process. Destroys helicopter after ~60 seconds of flight
		/*
		if ((time - _startTime) > 60) then {
			_helicopter setDamage 1;
		};
		*/
		
		sleep DZAI_refreshRate;
	};
} else {
	//For unarmed air vehicles
	while {!(_helicopter getVariable ["heli_disabled",false]) && {alive _helicopter}} do {		
		//Check if helicopter fuel is low
		if (fuel _helicopter < 0.20) then {
			_helicopter setFuel 1;
			if (DZAI_debugLevel > 1) then {diag_log "DZAI Extended Debug: Refueled AI patrol helicopter.";};
		};
		
		//Update helicopter position and waypoint markers
		_marker setMarkerText format ["AI %1 (Health: %2)",(typeOf _helicopter),(_helicopter getVariable "durability")];
		_marker setMarkerPos (getposATL _helicopter);
		_wpmarker setMarkerPos (getWPPos [_unitGroup,0]);
		
		//Destroy helicopter if pilot is killed
		if ((!alive (driver _helicopter))&&{(isEngineOn _helicopter)}) exitWith {
			if (DZAI_debugLevel > 0) then {diag_log "DZAI Debug: Patrol helicopter pilot killed, helicopter is going down!";};
			_helicopter setFuel 0;
			_helicopter setVehicleAmmo 0;
			_helicopter setDamage 1;
		};
		
		sleep DZAI_refreshRate;
	};
};

//Report length of time helicopter patrol was active. Add a warning entry to RPT log if helicopter was destroyed unusually early (< 30 seconds), likely due to the server admin forgetting to edit the server_cleanup.fsm.
_timePatrolled = time - _startTime;
sleep 0.5;

//Cleanup helicopter and waypoint markers
deleteMarker _marker;
deleteMarker _wpmarker;

if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: AI helicopter patrol crash-landed at %1 after %2 seconds of flight.",(getPosATL _helicopter),_timePatrolled];};
if (_timePatrolled < 35) then {
	diag_log "DZAI Warning: An AI helicopter was destroyed less than 35 seconds after being spawned. Please check if server_cleanup.fsm was edited properly.";
};

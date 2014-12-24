private ["_maxRandomSpawns","_debugMarkers","_triggerArea","_attempts","_trigPos","_trigger","_markername","_marker"];

_maxRandomSpawns = _this;

_debugMarkers = ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled});
_triggerArea = 600;

//waitUntil {sleep 1; !isNil "DZAI_locations_ready"};

if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Attempting to place %1 random spawns on the map...",_maxRandomSpawns];};

for "_i" from 1 to _maxRandomSpawns do {
	_attempts = 0;
	_keepSearching = true;
	_trigPos = [0,0,0];
	while {
		_keepSearching
	} do {
		_trigPos = ["DZAI_centerMarker",false,DZAI_randAreaBlacklist] call SHK_pos;
		_attempts = _attempts + 1;
		_keepSearching = ((count ((nearestLocations [_trigPos, ["Strategic"], 650])) > 0) && {_attempts < 3});
		if (_keepSearching) then {uiSleep 0.25};
	};
	
	if (_attempts < 3) then {
		_trigger = createTrigger ["EmptyDetector",_trigPos];
		
		_location = createLocation ["Strategic",(getPosASL _trigger),600,600]; //Create temporary dynamic spawn blacklist area
		_trigger setVariable ["triggerLocation",_location];
		[_trigger,"DZAI_randTriggerArray"] call DZAI_updateSpawnCount;
		
		_trigger setTriggerArea [_triggerArea, _triggerArea, 0, false];
		_trigger setTriggerActivation ["ANY", "PRESENT", true];
		_trigger setTriggerTimeout [5, 5, 5, true];
		_trigger setTriggerStatements ["{isPlayer _x} count thisList > 0;","0 = [300,thisTrigger,thisList] call fnc_spawnBandits_random;", "[thisTrigger] spawn fnc_despawnBandits_random;"];
		if (_debugMarkers) then {
			_markername = str(_trigger);
			_marker = createMarker[_markername,_trigPos];
			_marker setMarkerShape "ELLIPSE";
			_marker setMarkerType "Flag";
			_marker setMarkerBrush "SOLID";
			_marker setMarkerSize [_triggerArea, _triggerArea];
			_marker setMarkerColor "ColorYellow";
			_marker setMarkerAlpha 0.6;
			DZAI_mapMarkerArray set [(count DZAI_mapMarkerArray),_marker];
		};
		_trigger setTriggerText format ["Random Spawn at %1",(mapGridPosition _trigger)];
		_trigger setVariable ["timestamp",diag_tickTime];
		if (DZAI_debugLevel > 0) then {diag_log format["DZAI Debug: Random spawn %1 of %2 placed at %3 (Retries: %4).",_i,_maxRandomSpawns,_trigPos,_attempts];};
		//DZAI_randTriggerArray set [(count DZAI_randTriggerArray),_trigger];
	} else {
		if (DZAI_debugLevel > 0) then {diag_log format["DZAI Debug: Could not find suitable location to place random spawn %1 of %2.",_i,_maxRandomSpawns];};
	};
	uiSleep 3;
};

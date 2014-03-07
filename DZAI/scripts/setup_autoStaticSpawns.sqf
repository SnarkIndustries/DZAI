//Generates static spawns for maps that DZAI is not configured to support

waitUntil {sleep 3; !isNil "DZAI_locations_ready"};

if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: DZAI is generating static spawns..."];};

{
	private ["_placeName","_placePos","_placeType"];
	_placeName = _x select 0;
	_placePos = _x select 1;
	_placeType = _x select 2;
	
	if (_placeType != "NameLocal") then {
		private["_trigger","_statements","_aiCount","_equipType","_patrolRad","_blacklist"];
		_blacklist = createLocation ["Strategic",_placePos,600,600];
		_trigger = createTrigger ["EmptyDetector", _placePos];
		_trigger setTriggerArea [600, 600, 0, false];
		_trigger setTriggerActivation ["ANY", "PRESENT", true];
		_trigger setTriggerTimeout [10, 15, 20, true];
		_trigger setTriggerText _placeName;
		switch (_placeType) do {
			case "NameCityCapital":
			{
				_aiCount = [2,1];
				_equipType = 1;
				_patrolRad = 200;
			};
			case "NameCity":
			{
				_aiCount = [1,2];
				_equipType = 1;
				_patrolRad = 175;
			};
			case "NameVillage":
			{
				_aiCount = [1,1];
				_equipType = 0;
				_patrolRad = 150;
			};
		};
		_statements = format ["0 = [%1,%2,%3,thisTrigger,[],%4] call fnc_spawnBandits;",_aiCount select 0,_aiCount select 1,_patrolRad,_equipType];
		_trigger setTriggerStatements ["{isPlayer _x} count thisList > 0;", _statements, "0 = [thisTrigger] spawn fnc_despawnBandits;"];
	};
	sleep 0.05;
} forEach DZAI_locations;

if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: DZAI has finished generating static spawns."];
	if (!isNil "DZAI_devMode") then {
		_outputMarkerCode = {
			_markerName = _this select 0;
			_markerPos = _this select 1;
			_markerSize = _this select 2;

			diag_log text format ['POSITION="%1";',_markerPos];
			diag_log text format ['NAME="DZAI_%1";',_markerName];
			diag_log text format ['A="%1";',_markerSize];
			diag_log text format ['B="%1";',_markerSize];
			
			true
		};
		
		_outputSpawnConfig = {
			_markerName = _this select 0;
			_aiCount = _this select 1;
			_equipType = _this select 2;
			
			diag_log text format ["['DZAI_%1',%2,[],%3] call DZAI_static_spawn;",_markerName,_aiCount,_equipType];
			
			true
		};
		
		diag_log format ["DEBUG :: Output configs for areas_%1.sqf.",toLower worldName];
		{
			private ["_placeName","_placePos"];
			_placeName = _x select 0;
			_placePos = _x select 1;
			_placeType = _x select 2;
			_markerSize = switch (_placeType) do {
				case "NameCityCapital": {200};
				case "NameCity": {175};
				case "NameVillage": {150};
				case "NameLocal": {150};
				case default {0};
			};
			
			_output = [_placeName,_placePos,_markerSize] call _outputMarkerCode;
			sleep 0.1;
		} forEach DZAI_locations;
		
		diag_log format ["DEBUG :: Output configs for world_%1.sqf.",toLower worldName];
		{
			private ["_placeName","_aiCount","_equipType","_placeType"];
			_placeName = _x select 0;
			_placeType = _x select 2;
			_aiCount = [0,1];
			_equipType = 0;

			switch (_placeType) do {
				case "NameCityCapital": {
					_aiCount = [2,1];
					_equipType = 1;
				};
				case "NameCity": {
					_aiCount = [1,2];
					_equipType = 1;
				};
				case "NameVillage": {
					_aiCount = [1,1];
					_equipType = 0;
				};
				case "NameLocal": {
					_aiCount = [1,1];
					_equipType = 1;
				};
				case default {
					_aiCount = [1,2];
					_equipType = 1;
				};
			};
			_output = [_placeName,_aiCount,_equipType] call _outputSpawnConfig;
			sleep 0.1;
		} forEach DZAI_locations;
	};
};

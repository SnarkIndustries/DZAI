
waitUntil {uiSleep 0.1; (!isNil "DZAI_locations_ready" && {!isNil "DZAI_classnamesVerified"})};

if (DZAI_maxHeliPatrols > 0) then {
	_nul = [] spawn {
		for "_i" from 0 to ((count DZAI_heliList) - 1) do {
			_heliType = (DZAI_heliList select _i) select 0;
			_amount = (DZAI_heliList select _i) select 1;
			
			if ([_heliType,"vehicle"] call DZAI_checkClassname) then {
				for "_j" from 1 to _amount do {
					DZAI_heliTypesUsable set [count DZAI_heliTypesUsable,_heliType];
				};
			} else {
				if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: %1 attempted to spawn invalid vehicle type %2.",__FILE__,_heliType];};
			};
		};
		
		if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Assembled helicopter list: %1",DZAI_heliTypesUsable];};
		
		_maxHelis = (DZAI_maxHeliPatrols min (count DZAI_heliTypesUsable));
		for "_i" from 1 to _maxHelis do {
			_index = floor (random (count DZAI_heliTypesUsable));
			_heliType = DZAI_heliTypesUsable select _index;
			_nul = _heliType spawn DZAI_spawnVehiclePatrol;
			DZAI_heliTypesUsable set [_index,objNull];
			DZAI_heliTypesUsable = DZAI_heliTypesUsable - [objNull];
			if (_i < _maxHelis) then {uiSleep 20};
		};
	};
	uiSleep 5;
};

if (DZAI_maxLandPatrols > 0) then {
	_nul = [] spawn {
		for "_i" from 0 to ((count DZAI_vehList) - 1) do {
			_vehType = (DZAI_vehList select _i) select 0;
			_amount = (DZAI_vehList select _i) select 1;
			
			if ([_vehType,"vehicle"] call DZAI_checkClassname) then {
				for "_j" from 1 to _amount do {
					DZAI_vehTypesUsable set [count DZAI_vehTypesUsable,_vehType];
				};
			} else {
				if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: %1 attempted to spawn invalid vehicle type %2.",__FILE__,_vehType];};
			};
		};
		
		if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Assembled vehicle list: %1",DZAI_vehTypesUsable];};
		
		_maxVehicles = (DZAI_maxLandPatrols min (count DZAI_vehTypesUsable));
		for "_i" from 1 to _maxVehicles do {
			_index = floor (random (count DZAI_vehTypesUsable));
			_vehType = DZAI_vehTypesUsable select _index;
			_nul = _vehType spawn DZAI_spawnVehiclePatrol;
			DZAI_vehTypesUsable set [_index,objNull];
			DZAI_vehTypesUsable = DZAI_vehTypesUsable - [objNull];
			if (_i < _maxVehicles) then {uiSleep 20};
		};
	};
};

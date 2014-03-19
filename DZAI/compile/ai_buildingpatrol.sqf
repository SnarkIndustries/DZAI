private ["_unitGroup","_locationArray"];
_unitGroup = _this select 0;
_locationArray = _this select 1;

//diag_log format ["DEBUG :: Counted %1 spawn positions.",count _locationArray];

for "_i" from 1 to 5 do {
	private ["_loc","_wp"];
	_loc = _locationArray call BIS_fnc_selectRandom2;
	//diag_log format ["DEBUG :: Chosen position: %1.",_loc];
	_wp = _unitGroup addWaypoint [_loc,0];
	_wp setWaypointType "MOVE";
	_wp setWaypointCompletionRadius 35;
	_wp setWaypointTimeout [0,2,15];
	_wp setWaypointStatements ["true", "if ((random 3) > 2) then {_nul = [(group this)] spawn DZAI_shuffleWP;} else {_nul = [(group this),100] spawn DZAI_findLootPile;};"];
	if ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled}) then {
		private["_markername","_marker"];
		_markername = str (_wp);
		if ((getMarkerColor _markername) != "") then {deleteMarker _markername};
		_marker = createMarker [_markername,[_loc select 0,_loc select 1]];
		//diag_log format ["DEBUG :: Creating marker %1.",_markername];
		_marker setMarkerShape "ELLIPSE";
		_marker setMarkerType "Dot";
		_marker setMarkerColor "ColorOrange";
		_marker setMarkerBrush "SolidBorder";
		_marker setMarkerSize [20, 20];
	};
	if (_i == 5) then {
		_wp = _unitGroup addWaypoint [_loc, 0];
		_wp setWaypointType "CYCLE";
		_wp setWaypointCompletionRadius 100;
	};
	sleep 0.5;
};
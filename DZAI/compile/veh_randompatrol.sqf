private ["_unitGroup","_tooClose","_wpSelect"];
_unitGroup = _this select 0;

_tooClose = true;
while {_tooClose} do {
	_wpSelect = (DZAI_locations call BIS_fnc_selectRandom2) select 1;
	if (((waypointPosition [_unitGroup,0]) distance _wpSelect) > 300) then {
		_tooClose = false;
	};
};

_wpSelect = [_wpSelect,150 + random(150),random(360),false,[1,300]] call SHK_pos;
[_unitGroup,0] setWPPos _wpSelect; 
[_unitGroup,0] setWaypointCompletionRadius 150;
_unitGroup setCurrentWaypoint [_unitGroup,0];

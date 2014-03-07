private ["_unitGroup"];
_unitGroup = _this select 0;

if ((count DZAI_reinforcePlaces) > 0) then {
	private ["_reinforcePos","_index"];
	_index = floor (random (count DZAI_reinforcePlaces));
	_reinforcePos = DZAI_reinforcePlaces select _index;
	_reinforcePos = [_reinforcePos,50+(random 150),(random 360),true] call SHK_pos;
	DZAI_reinforcePlaces set [_index,objNull];
	DZAI_reinforcePlaces = DZAI_reinforcePlaces - [objNull];
	[_unitGroup,0] setWPPos _reinforcePos; 
	[_unitGroup,1] setWPPos _reinforcePos;
	[_unitGroup,1] setWaypointType "SAD";
	[_unitGroup,1] setWaypointTimeout [40,50,60];
	_unitGroup setVariable ["DetectPlayersWide",true];
	//_unitGroup setCurrentWaypoint [_unitGroup,0];
	//(vehicle (leader _unitGroup)) flyInHeight (100 + (random 40));
} else {
	private ["_tooClose","_wpSelect"];
	_tooClose = true;
	while {_tooClose} do {
		_wpSelect = (DZAI_locations call BIS_fnc_selectRandom2) select 1;
		if (((waypointPosition [_unitGroup,0]) distance _wpSelect) > 300) then {
			_tooClose = false;
		} else {
			sleep 0.1;
		};
	};
	_wpSelect = [_wpSelect,50+(random 300),(random 360),true] call SHK_pos;
	[_unitGroup,0] setWPPos _wpSelect; 
	[_unitGroup,1] setWPPos _wpSelect;
	if ((waypointType [_unitGroup,1]) == "MOVE") then {
		if ((random 1) < 0.275) then {
			[_unitGroup,1] setWaypointType "SAD";
			[_unitGroup,1] setWaypointTimeout [20,25,30];
			_unitGroup setVariable ["DetectPlayersWide",true];
		};
	} else {
		[_unitGroup,1] setWaypointType "MOVE";
		[_unitGroup,1] setWaypointTimeout [3,6,9];
	};
	//[_unitGroup,0] setWaypointCompletionRadius 150;
	//_unitGroup setCurrentWaypoint [_unitGroup,0];
	//(vehicle (leader _unitGroup)) flyInHeight (100 + (random 40));
};

_unitGroup setCurrentWaypoint [_unitGroup,0];
(vehicle (leader _unitGroup)) flyInHeight (100 + (random 40));

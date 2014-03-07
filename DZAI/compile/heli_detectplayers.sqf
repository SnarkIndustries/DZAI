private ["_unitGroup","_detected","_detectBase","_detectFactor","_detectRange","_heli"];
_unitGroup = _this select 0;

_heli = vehicle (leader _unitGroup);
_detectRange = if (_unitGroup getVariable ["DetectPlayersWide",false]) then {_unitGroup setVariable ["DetectPlayersWide",false]; 400} else {275};
_detected = (waypointPosition [_unitGroup,(currentWaypoint _unitGroup)]) nearEntities [["AllVehicles","CAManBase"],_detectRange];

private ["_nearPlayerUnits","_heliAimPos","_playerAimPos"];
{
	if (isPlayer _x) then {
		_heliAimPos = aimPos _heli;
		_playerAimPos = aimPos _x;
		if (!(terrainIntersectASL [_heliAimPos,_playerAimPos]) && {!(lineIntersects [_heliAimPos,_playerAimPos,_heli,_x])}) then {
			_unitGroup reveal [_x,2.5];
		};
	};
	sleep 0.1;
} forEach _detected;

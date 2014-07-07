/*
	
	
*/

if (!isServer) exitWith {};

private ["_helicopter","_unitGroup","_lastRedirectTime"];

_helicopter = _this select 0;
_unitGroup = _this select 1;

uiSleep 300;

if ((isNull _unitGroup) or (_helicopter getVariable ["heli_disabled",false])) exitWith {};
_lastRedirectTime = diag_tickTime + 900;
if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: AI helicopter %1 (Group: %2) is now ready to respond to reinforcement requests.",typeOf _helicopter,_unitGroup]};
while {!(_helicopter getVariable ["heli_disabled",false]) && {alive _helicopter}} do {	
	if (((diag_tickTime - _lastRedirectTime) > 900) && {((count DZAI_reinforcePlaces) > 0)}) then {
		_index = floor (random (count DZAI_reinforcePlaces));
		_trigger = DZAI_reinforcePlaces select _index;
		if (!isNull _trigger) then {
			_targetPlayer = _trigger getVariable "targetplayer";
			if (!isNil "_targetPlayer") then {_unitGroup reveal [_targetPlayer,4]};
			_reinforcePos = [(getPosASL _trigger),(random 100),(random 360),true] call SHK_pos;
			DZAI_reinforcePlaces set [_index,objNull];
			DZAI_reinforcePlaces = DZAI_reinforcePlaces - [objNull];
			[_unitGroup,0] setWPPos _reinforcePos; 
			[_unitGroup,1] setWPPos _reinforcePos;
			[_unitGroup,1] setWaypointType "SAD";
			[_unitGroup,1] setWaypointTimeout [40,50,60];
			_unitGroup setVariable ["DetectPlayersWide",true];

			_unitGroup setCurrentWaypoint [_unitGroup,0];
			(vehicle (leader _unitGroup)) flyInHeight 100 + (random 20);
			_lastRedirectTime = diag_tickTime;
			if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Helicopter %1 (%2) redirected to dynamic spawn area at %3.",_helicopter,(typeOf _helicopter),mapGridPosition _reinforcePos]};
		};
		DZAI_reinforcePlaces set [_index,objNull];
		DZAI_reinforcePlaces = DZAI_reinforcePlaces - [objNull];
	};
	uiSleep 30;
};

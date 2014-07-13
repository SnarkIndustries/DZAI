/*
	fn_findKiller
	
	Description: If an AI unit is killed, surviving members of their group will aggressively pursue the killer for a set amount of time. After this amount of time has passed, the group will return to their patrol state.
	
	Last updated: 2:00 AM 7/1/2014
*/
private ["_unitGroup","_targetPlayer","_startPos"];

_targetPlayer = _this select 0;
_unitGroup = _this select 1;

//Disable killer-finding for dynamic AI in hunting mode
if (_unitGroup getVariable ["seekActive",false]) exitWith {};

//If group is already pursuing player and target player has killed another group member, then extend pursuit time.
if (((_unitGroup getVariable ["pursuitTime",0]) > 0) && {((_unitGroup getVariable ["targetKiller",""]) == (name _targetPlayer))}) exitWith {
	_unitGroup setVariable ["pursuitTime",((_unitGroup getVariable ["pursuitTime",0]) + 20)];
	if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Pursuit time +20 sec for Group %1 (Target: %2) to %3 seconds (fn_findKiller).",_unitGroup,name _targetPlayer,(_unitGroup getVariable ["pursuitTime",0]) - diag_tickTime]};
};

_startPos = _unitGroup getVariable ["trigger",(getPosASL (leader _unitGroup))];

#define TRANSMIT_RANGE 50 //distance to broadcast radio text around target player
#define RECEIVE_DIST 150 //distance requirement to receive message from AI group leader
#define CHASE_DISTANCE 250	//distance to chase target from trigger position

if ((_startPos distance _targetPlayer) < CHASE_DISTANCE) then {
	private ["_targetPlayerPos","_leader","_ableToChase","_debugMarkers","_marker"];
	if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Group %1 has entered pursuit state for 180 seconds. Target: %2. (fn_findKiller)",_unitGroup,_targetPlayer];};
	
	//Temporarily cancel patrol state.
	_unitGroup lockWP true;
	
	//Set pursuit timer
	_unitGroup setVariable ["pursuitTime",diag_tickTime+180];
	_unitGroup setVariable ["targetKiller",name _targetPlayer];
	
	_debugMarkers = ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled});
	if (_debugMarkers) then {
		_markername = "Target Player";
		if ((getMarkerColor _markername) != "") then {deleteMarker _markername; uiSleep 1;};
		_marker = createMarker [_markername,getPosASL _targetPlayer];
		_marker setMarkerText _markername;
		_marker setMarkerType "Attack";
		_marker setMarkerColor "ColorRed";
		_marker setMarkerBrush "Solid";
	};
	
	//Begin pursuit state.
	_ableToChase = true;
	while { 
		(!isNull _targetPlayer) &&
		{(alive _targetPlayer)} && 
		{_ableToChase} &&
		{((_startPos distance _targetPlayer) < CHASE_DISTANCE)} &&
		{(!((vehicle _targetPlayer) isKindOf "Air"))}
	} do {
		if ((_unitGroup knowsAbout _targetPlayer) < 4) then {_unitGroup reveal [_targetPlayer,4]};
		_targetPlayerPos = ASLtoATL getPosASL _targetPlayer;
		(units _unitGroup) doMove _targetPlayerPos;
		(units _unitGroup) doTarget _targetPlayer;
		(units _unitGroup) doFire _targetPlayer;
		{
			if (alive _x) then {
				_x moveTo _targetPlayerPos
			};
		} count (units _unitGroup);
		if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: AI group %1 in pursuit state. Pursuit time remaining: %2 seconds.",_unitGroup,(_unitGroup getVariable ["pursuitTime",0]) - diag_tickTime];};
		
		if (DZAI_radioMsgs) then {
			_leader = (leader _unitGroup);
			if (((_targetPlayer distance _leader) <= RECEIVE_DIST) && {!(_leader getVariable ["unconscious",false])}) then {
				private ["_nearbyUnits","_radioSpeech"];
				_nearbyUnits = _targetPlayerPos nearEntities [["LandVehicle","CAManBase"],TRANSMIT_RANGE];
				if ((_unitGroup getVariable ["GroupSize",0]) > 1) then {
					{
						if ((isPlayer _x)&& {((driver _x) hasWeapon "ItemRadio")}) then {
							_speechIndex = (floor (random 3));
							_radioSpeech = call {
								if (_speechIndex == 0) exitWith {
									format ["[RADIO] %1 (Bandit Leader): %2 is nearby. That's our target!",(name _leader),(name _targetPlayer)]
								};
								if (_speechIndex == 1) exitWith {
									format ["[RADIO] %1 (Bandit Leader): Target looks like a %2. Find him!",(name _leader),(getText (configFile >> "CfgVehicles" >> (typeOf _targetPlayer) >> "displayName"))]
								};
								if (_speechIndex == 2) exitWith {
									format ["[RADIO] %1 (Bandit Leader): Target's distance is %2 meters. Search the area!",(name _leader),round (_leader distance _targetPlayer)]
								};
								""	//Default radio message: empty string (this case should never happen)
							};
							[_x,_radioSpeech] call DZAI_radioSend;
						};
					} count _nearbyUnits;
				} else {
					_radioSpeech = "[RADIO] Your radio is picking up a signal nearby.";
					{
						if ((isPlayer _x)&& {((driver _x) hasWeapon "ItemRadio")}) then {
							[_x,_radioSpeech] call DZAI_radioSend;
						};
					} count _nearbyUnits;
				};
			};
		};
		if (_debugMarkers) then {
			_marker setMarkerPos (getPosASL _targetPlayer);
		};
		uiSleep 19;
		_ableToChase = ((!isNull _unitGroup) && {diag_tickTime < (_unitGroup getVariable ["pursuitTime",0])} && {(_unitGroup getVariable ["GroupSize",0]) > 0});
		if (_ableToChase && {isNull _targetPlayer}) then {
			if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Group %1 is attempting to re-establish contact with target %2.",_unitGroup,_unitGroup getVariable "targetKiller"];};
			_nearUnits = _targetPlayerPos nearEntities ["CAManBase",150];
			{
				if ((isPlayer _x) && {((name _x) == _unitGroup getVariable "targetKiller")}) exitWith {_targetPlayer = _x};
			} forEach _nearUnits;
		};
		uiSleep 1;
	};

	//End of pursuit state. Re-enable patrol state.
	_unitGroup setVariable ["pursuitTime",0];
	_unitGroup setVariable ["targetKiller",""];
	_unitGroup lockWP false;
	_unitGroup setCurrentWaypoint ((waypoints _unitGroup) call BIS_fnc_selectRandom2);
	if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Pursuit state ended for group %1. Returning to patrol state. (fn_findKiller)",_unitGroup];};
	
	if (DZAI_radioMsgs) then {
		_leader = (leader _unitGroup);
		if (((_targetPlayer distance _leader) <= RECEIVE_DIST) && {((_unitGroup getVariable ["GroupSize",0]) > 1)} && {!(_leader getVariable ["unconscious",false])} && {!(isNull _targetPlayer)}) then {
			private ["_nearbyUnits","_radioSpeech","_radioText"];
			_radioText = if (alive _targetPlayer) then {"%1 (Bandit Leader): Lost contact with target. Breaking off pursuit."} else {"%1 (Bandit Leader): Target has been eliminated."};
			_radioSpeech = format [_radioText,(name (leader _unitGroup))];
			_nearbyUnits = (getPosASL _targetPlayer) nearEntities [["LandVehicle","CAManBase"],TRANSMIT_RANGE];
			{
				if ((isPlayer _x)&&{((driver _x) hasWeapon "ItemRadio")}) then {
					[_x,_radioSpeech] call DZAI_radioSend;
				};
			} count _nearbyUnits;
		};
	};
	if (_debugMarkers) then {
		deleteMarker _marker;
	};
};

//_unitGroup setBehaviour "COMBAT";

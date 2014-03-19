/*
	DZAI_dyn_huntPlayer
	
	Description: Used for dynamically spawned AI. Creates a MOVE waypoint directing AI to a random player's position, then uses BIN_taskPatrol to create a circular patrol path around initial spawn position.
	
	Last updated: 2:12 AM 1/11/2014
*/

private ["_unitGroup","_spawnPos","_waypoint","_patrolDist","_statement","_targetPlayer","_triggerPos","_leader","_targetName"];

_unitGroup = _this select 0;
_spawnPos = _this select 1;
_patrolDist = _this select 2;
_targetPlayer = _this select 3;
_triggerPos = _this select 4;

deleteWaypoint [_unitGroup,0];

#define TRANSMIT_RANGE 50 //distance to broadcast radio text around target player
#define SEEK_RANGE 450 //distance to chase player from initial group spawn location

_targetName = name _targetPlayer;

//_statement = format ["deleteWaypoint[(group this),0]; 0 = [(group this),%1,%2,%3] spawn fnc_BIN_taskPatrol;",_spawnPos,_patrolDist,DZAI_debugMarkersEnabled];
_waypoint = _unitGroup addWaypoint [_spawnPos,0];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointCompletionRadius 30;
_waypoint setWaypointTimeout [5,5,5];
_waypoint setWaypointStatements ["true","group this setCurrentWaypoint [group this,0]"];
_unitGroup setCurrentWaypoint _waypoint;
_unitGroup setVariable ["seekActive",true];

if (DZAI_radioMsgs) then {
	_leader = (leader _unitGroup);
	if (((_unitGroup getVariable ["GroupSize",0]) > 1) && {!(_leader getVariable ["unconscious",false])}) then {
		private ["_nearbyUnits","_radioSpeech","_radioText"];
		_nearbyUnits = (getPosATL _targetPlayer) nearEntities ["CAManBase",TRANSMIT_RANGE];
		{
			if ((isPlayer _x)&&{(_x hasWeapon "ItemRadio")}) then {
				_radioSpeech = "[RADIO] You hear static coming from your radio...";
				[_x,_radioSpeech] call DZAI_radioSend;
			};
		} forEach _nearbyUnits;
	};
};
sleep 10;

//Begin hunting phase
while {
	((_unitGroup getVariable ["GroupSize",0]) > 0) &&
	{((_targetPlayer distance _spawnPos) < SEEK_RANGE)} &&
	{(alive _targetPlayer)} && 
	{!(isNull _targetPlayer)}
} do {
	if !(_unitGroup getVariable ["inPursuit",false]) then {
		_leader = (leader _unitGroup);
		_waypoint setWPPos getPosATL _targetPlayer;
		_unitGroup setCurrentWaypoint _waypoint;
		_unitGroup setFormDir ([_leader,_targetPlayer] call BIS_fnc_dirTo);
		(units _unitGroup) doTarget _targetPlayer;
		if ((_leader distance _targetPlayer) < 100) then {(units _unitGroup) doFire _targetPlayer};
		if (DZAI_radioMsgs) then {
			//Warn player of AI bandit presence if they have a radio.
			if (((_unitGroup getVariable ["GroupSize",0]) > 1) && {!(_leader getVariable ["unconscious",false])} && {!(isNull _targetPlayer)}) then {
				private ["_nearbyUnits","_radioSpeech"];
				_nearbyUnits = (getPosATL _targetPlayer) nearEntities ["CAManBase",TRANSMIT_RANGE];
				
				{
					if ((isPlayer _x)&&{(_x hasWeapon "ItemRadio")}) then {
					//if (isPlayer _x) then {
						_radioSpeech = switch (floor (random 3)) do {
							case 0: {
								format ["[RADIO] %1 (Bandit Leader): Target's name is %2. Find him!",(name _leader),_targetName]
							};
							case 1: {
								format ["[RADIO] %1 (Bandit Leader): Target is a %2. Find him!",(name _leader),(getText (configFile >> "CfgVehicles" >> (typeOf _targetPlayer) >> "displayName"))]
							};
							case 2: {
								format ["[RADIO] %1 (Bandit Leader): Target's distance is %2 meters. Find him!",(name _leader),round (_leader distance _targetPlayer)]
							};
							case default {
								"ERROR"
							};
						};
						//diag_log format ["DEBUG :: %1",_radioSpeech];
						[_x,_radioSpeech] call DZAI_radioSend;
					};
				} forEach _nearbyUnits;
			};
		};
	};
	sleep 20;
	if (isNull _targetPlayer) then {
		if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Group %1 is attempting to re-establish contact with target %2.",_unitGroup,_targetName];};
		_nearUnits = _targetPlayerPos nearEntities ["CAManBase",150];
		{
			if ((isPlayer _x) && {((name _x) == _targetName)}) exitWith {_targetPlayer = _x};
		} forEach _nearUnits;
	};
};

if ((_unitGroup getVariable ["GroupSize",0]) < 1) exitWith {};

if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Group %1 has exited hunting phase. Moving to patrol phase. (fn_seekPlayer)",_unitGroup];};

//Begin patrol phase
_waypoint setWaypointStatements ["true","if ((random 1) < 0.50) then { group this setCurrentWaypoint [(group this), (floor (random (count (waypoints (group this)))))];};"];
//_patrolCenter = if (!(isNull _targetPlayer)) then {getPosATL _targetPlayer} else {getPosATL (leader _unitGroup)};
0 = [_unitGroup,_triggerPos,_patrolDist] spawn DZAI_BIN_taskPatrol;
_unitGroup setVariable ["seekActive",nil];

sleep 5;

if (DZAI_radioMsgs) then {
	_leader = (leader _unitGroup);
	if (((_unitGroup getVariable ["GroupSize",0]) > 1) && {!(_leader getVariable ["unconscious",false])} && {!(isNull _targetPlayer)}) then {
		private ["_nearbyUnits","_radioSpeech","_radioText"];
		_nearbyUnits = (getPosATL _targetPlayer) nearEntities ["CAManBase",TRANSMIT_RANGE];
		{
			if ((isPlayer _x)&&{(_x hasWeapon "ItemRadio")}) then {
			//if (isPlayer _x) then {
				_radioText = if (alive _targetPlayer) then {"%1 (Bandit Leader): Lost contact with target. Breaking off pursuit."} else {"%1 (Bandit Leader): Target has been eliminated."};
				_radioSpeech = format [_radioText,(name _leader)];
				[_x,_radioSpeech] call DZAI_radioSend;
			};
		} forEach _nearbyUnits;
	};
};

true

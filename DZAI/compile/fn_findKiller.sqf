/*
	fn_findKiller
	
	Description: If an AI unit is killed, surviving members of their group will aggressively pursue the killer for a set amount of time. After this amount of time has passed, the group will return to their patrol state.
	
	Last updated: 2:15 AM 1/3/2014
*/
private ["_unitGroup","_targetPlayer","_startPos","_chaseDist"];

_startPos = _this select 0;
_targetPlayer = _this select 1;
_unitGroup = _this select 2;
_chaseDist = _this select 3;

_groupSize = _unitGroup getVariable ["GroupSize",0];
if (_groupSize == 0) exitWith {if (DZAI_debugLevel > 0) then {diag_log "DZAI Debug: All units in group are dead. (fn_findKiller)";};};

//If group is already pursuing player and target player has killed another group member, then extend pursuit time.
if (((_unitGroup getVariable ["pursuitTime",0]) > 0) && {((_unitGroup getVariable ["targetKiller",""]) == (name _targetPlayer))}) exitWith {
	_unitGroup setVariable ["pursuitTime",((_unitGroup getVariable ["pursuitTime",0]) + 20)];
	if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Pursuit time +20 sec for Group %1 (Target: %2) to %3 seconds (fn_findKiller).",_unitGroup,name _targetPlayer,(_unitGroup getVariable ["pursuitTime",0]) - time]};
};

//(units _unitGroup) doTarget (vehicle _targetPlayer);
//(units _unitGroup) doFire (vehicle _targetPlayer);

_startPos = _unitGroup getVariable "trigger";
if ((isNull _startPos) or (isNil "_startPos")) then {_startPos = _unitGroup getVariable ["spawnPos",getPosATL (leader _unitGroup)]};

#define TRANSMIT_RANGE 50 //distance to broadcast radio text around target player
#define RECEIVE_DIST 150 //distance requirement to receive message from AI group leader

if ((_startPos distance _targetPlayer) < _chaseDist) then {
	private ["_targetPlayerPos","_leader"];
	if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Group %1 has entered pursuit state. Target: %2. (fn_findKiller)",_unitGroup,_targetPlayer];};
	
	//Temporarily cancel patrol state.
	_unitGroup lockWP true;
	
	//Set pursuit timer
	_unitGroup setVariable ["pursuitTime",time+180];
	_unitGroup setVariable ["targetKiller",name _targetPlayer];
	
	//Begin pursuit state.
	while {
		(time < (_unitGroup getVariable ["pursuitTime",0])) && 
		{((_unitGroup getVariable ["GroupSize",0]) > 0)} && 
		{((_startPos distance _targetPlayer) < _chaseDist)} && 
		{(alive _targetPlayer)} && 
		{!(isNull _targetPlayer)} &&
		{(!((vehicle _targetPlayer) isKindOf "Air"))}
	} do {
	
		_targetPlayerPos = getPosATL _targetPlayer;
		(units _unitGroup) doMove _targetPlayerPos;
		{if (alive _x) then {_x moveTo _targetPlayerPos;/*diag_log "AI unit in pursuit.";*/};} forEach (units _unitGroup);
		if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: AI group %3 in pursuit state. Time: %1/%2.",time,(_unitGroup getVariable ["pursuitTime",0]),_unitGroup];};
		
		if (DZAI_radioMsgs) then {
			_leader = (leader _unitGroup);
			if (((_targetPlayer distance _leader) <= RECEIVE_DIST) && {((_unitGroup getVariable ["GroupSize",0]) > 1)} && {!(_leader getVariable ["unconscious",false])}) then {
				private ["_nearbyUnits","_radioSpeech"];
				_nearbyUnits = _targetPlayerPos nearEntities ["CAManBase",TRANSMIT_RANGE];
				{
					if ((isPlayer _x)&& {(_x hasWeapon "ItemRadio")}) then {
					//if (isPlayer _x) then {
						_radioSpeech = switch (floor (random 3)) do {
							case 0: {
								format ["[RADIO] %1 (Bandit Leader): Target's name is %2. Find him!",(name _leader),(name _targetPlayer)]
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
						[_x,_radioSpeech] call DZAI_radioSend;
					};
				} forEach _nearbyUnits;
			};
		};
		sleep 20;
		if (isNull _targetPlayer) then {
			if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Group %1 is attempting to re-establish contact with target %2.",_unitGroup,_unitGroup getVariable "targetKiller"];};
			_nearUnits = _targetPlayerPos nearEntities ["CAManBase",150];
			{
				if ((isPlayer _x) && {((name _x) == _unitGroup getVariable "targetKiller")}) exitWith {_targetPlayer = _x};
			} forEach _nearUnits;
		};
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
			_nearbyUnits = (getPosATL _targetPlayer) nearEntities ["CAManBase",TRANSMIT_RANGE];
			{
				if ((isPlayer _x)&&{(_x hasWeapon "ItemRadio")}) then {
					[_x,_radioSpeech] call DZAI_radioSend;
				};
			} forEach _nearbyUnits;
		};
	};
	sleep 5;
};

_unitGroup setBehaviour "COMBAT";

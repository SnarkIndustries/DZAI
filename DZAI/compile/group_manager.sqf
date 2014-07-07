private ["_unitGroup","_weapongrade","_vehicle","_lastRearmTime","_useLaunchers","_isArmed","_debugMarkers","_marker","_marker2","_antistuckTime","_antistuckPos"];

if (!isServer) exitWith {};

_unitGroup = _this select 0;
_weapongrade = _this select 1;

if (_unitGroup getVariable ["rearmEnabled",false]) exitWith {};
_unitGroup setVariable ["rearmEnabled",true];

_units = (units _unitGroup);
_unitType = (_unitGroup getVariable ["unitType",""]);
_vehicle = if (_unitType in ["static","dynamic"]) then {objNull} else {(vehicle (leader _unitGroup))};
_useLaunchers = (((count DZAI_launcherTypes) > 0) && {(_weapongrade in DZAI_launcherLevels)});
_isArmed = _vehicle getVariable ["isArmed",false];
_antistuckPos = (getWPPos [_unitGroup,(currentWaypoint _unitGroup)]);
if (isNil {_unitGroup getVariable "GroupSize"}) then {_unitGroup setVariable ["GroupSize",(count _units)]};

//set up debug variables
_debugMarkers = ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled});
_marker = "";
_marker2 = "";

//Set up timer variables
_lastRearmTime = diag_tickTime;
_antistuckTime = diag_tickTime + 600;

//Set up individual group units
{
	if (isNil {_x getVariable "unithealth"}) then {_x setVariable ["unithealth",[((9000 + (random 3000)) min 12000),0,false]]};
	if (isNil {_x getVariable "unconscious"}) then {_x setVariable ["unconscious",false]};
	_x setVariable ["bandageAmount",((_weapongrade + 1) min 3)];
	_x setVariable ["lastBandage",0];
	_x setVariable ["needsHeal",false];
	_x setVariable ["rearmEnabled",true]; //prevent DZAI_autoRearm loop from executing on unit.
	_loadout = _x getVariable ["loadout",[]];

	if ((count _loadout) > 0) then {
		if ((getNumber (configFile >> "CfgMagazines" >> ((_loadout select 1) select 0) >> "count")) <= 8) then {_x setVariable ["extraMag",true]};
	};
	
	if (_useLaunchers) then {
		_maxLaunchers = (DZAI_launchersPerGroup min _weapongrade);
		if (_forEachIndex < _maxLaunchers) then {
			_launchWeapon = DZAI_launcherTypes call BIS_fnc_selectRandom2;
			_launchAmmo = [] + getArray (configFile >> "CfgWeapons" >> _launchWeapon >> "magazines") select 0;
			_x addMagazine _launchAmmo; (_loadout select 1) set [1,_launchAmmo];
			_x addWeapon _launchWeapon; (_loadout select 0) set [1,_launchWeapon];
		};
	};
	if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Unit %1 loadout: %2. Weapongrade %3. Blood: %4.",_x,_x getVariable ["loadout",[]],_weapongrade,((_x getVariable "unithealth") select 0)];};
} forEach _units;

if (_debugMarkers) then {
	if (isNull _vehicle) then {
		_markername = format ["%1 (AI L.%2)",_unitGroup,_weapongrade];
		if ((getMarkerColor _markername) != "") then {deleteMarker _markername; uiSleep 0.5;};	//Delete the previous marker if it wasn't deleted for some reason.
		_marker = createMarker [_markername,getPosASL (leader _unitGroup)];
		_marker setMarkerText format ["%1 (AI L.%2)",_unitGroup,_weapongrade];
		_marker setMarkerType "Attack";
		_marker setMarkerColor "ColorRed";
		_marker setMarkerBrush "Solid";
		{
			_x spawn {
				_mark = createMarker [str (_this) + str (random 1000),getPosASL _this];
				_mark setMarkerShape "ELLIPSE";
				_mark setMarkerType "Dot";
				_mark setMarkerColor "ColorRed";
				_mark setMarkerBrush "SolidBorder";
				_mark setMarkerSize [3,3];
				while {alive _this} do {
					_mark setMarkerPos (getPosASL _this);
					uiSleep 15;
				};
				deleteMarker _mark;
			};
			uiSleep 0.1;
		} count _units;
	} else {
		_markername = format ["%1 (AI %2)",_unitGroup,(typeOf (vehicle (leader _unitGroup)))];
		if ((getMarkerColor _markername) != "") then {deleteMarker _markername; uiSleep 0.5;};	//Delete the previous marker if it wasn't deleted for some reason.
		_marker = createMarker [_markername,getPosASL (leader _unitGroup)];
		_marker setMarkerText format ["%1 (AI %2)",_unitGroup,(typeOf (vehicle (leader _unitGroup)))];
		_marker setMarkerType "Attack";
		_marker setMarkerColor "ColorBlack";
		_marker setMarkerBrush "Solid";
	};
	
	_markername2 = format ["%1 waypoint",_unitGroup];
	if ((getMarkerColor _markername2) != "") then {deleteMarker _markername2; uiSleep 0.5;};	//Delete the previous marker if it wasn't deleted for some reason.
	_marker2 = createMarker [_markername2,(getWPPos [_unitGroup,(currentWaypoint _unitGroup)])];
	_marker2 setMarkerText format ["%1 WP",_unitGroup];
	_marker2 setMarkerType "Waypoint";
	_marker2 setMarkerColor "ColorBlue";
	_marker2 setMarkerBrush "Solid";
} else {
	_marker = nil;
	_marker2 = nil;
};

//Main loop
while {(!isNull _unitGroup) && {(_unitGroup getVariable "GroupSize") > 0}} do {
	_leader = leader _unitGroup;
	if (alive _vehicle) then {	//If _vehicle is objNull (if no vehicle was assigned to the group) then nothing in this bracket should be executed
		if ((_isArmed) && {someAmmo _vehicle}) then {	//Note: someAmmo check is not reliable for vehicles with multiple turrets
			_lastRearmTime = diag_tickTime;	//Reset rearm timestamp if vehicle still has some ammo
		} else {
			if ((diag_tickTime - _lastRearmTime) > 180) then {	//If ammo is depleted, wait 3 minutes until rearm is possible.
				_vehicle setVehicleAmmo 1;				//Rearm vehicle. Rearm timestamp will be reset durng the next loop cycle.
			};
		};
		if ((fuel _vehicle) < 0.25) then {_vehicle setFuel 1};
	};
	//Zombie detection if group leader is on foot
	if (DZAI_zombieEnemy && {(vehicle _leader) == _leader}) then {
		if (_unitGroup getVariable ["detectReady",true]) then {
			_unitGroup setVariable ["detectReady",false];
			_nul = _unitGroup spawn {
				_unitGroup = _this;
				if !(isNull _unitGroup) then {
					_detectRange = if ((_unitGroup getVariable ["pursuitTime",0]) == 0) then {DZAI_zDetectRange} else {DZAI_zDetectRange/2};	//Reduce detection range of new zombies while searching for killer unit
					_nearbyZeds = (leader _unitGroup) nearEntities ["zZombie_Base",_detectRange];
					_hostileZedsNew = [];
					{
						if (rating _x > -30000) then {
							_hostileZedsNew set [count _hostileZedsNew,_x];
						};
						uiSleep 0.05;
					} forEach _nearbyZeds;
					if ((count _hostileZedsNew) > 0) then {
						uiSleep (random 0.5);
						DZAI_ratingModify = [_hostileZedsNew,-30000];
						(owner (_hostileZedsNew select 0)) publicVariableClient "DZAI_ratingModify";
					};
					_unitGroup setVariable ["detectReady",true];
				};
			};
		};
	};
	{
		//Check infantry-type units
		if (((vehicle _x) == _x) && {!(_x getVariable ["unconscious",false])} && {_x getVariable ["canCheckUnit",true]}) then {
			_x setVariable ["canCheckUnit",false];
			_nul = _x spawn {
				_unit = _this;
				_loadout = _unit getVariable ["loadout",[]];
				_currentMagazines = (magazines _unit);
				for "_i" from 0 to ((count (_loadout select 0)) - 1) do {
					if (((_unit ammo ((_loadout select 0) select _i)) == 0) || {!((((_loadout select 1) select _i) in _currentMagazines))}) then {
						_unit removeMagazines ((_loadout select 1) select _i);
						_unit addMagazine ((_loadout select 1) select _i);
						if ((_i == 0) && {_unit getVariable ["extraMag",false]}) then {_unit addMagazine ((_loadout select 1) select _i)};
					};
				};
				
				_bandages = _unit getVariable "bandageAmount";
				if (_bandages > 0) then {
					_health = _unit getVariable "unithealth";
					if (_unit getVariable ["needsHeal",false]) then {
						_nearestEnemy = _unit findNearestEnemy _unit;
						_isSafe = ((_unit distance _nearestEnemy) > 35);
						if (_isSafe) then {
							_bandages = _bandages - 1;
							_unit setVariable ["bandageAmount",_bandages];
							{_unit disableAI _x} forEach ["TARGET","MOVE","FSM"];
							_unit playActionNow "Medic";
							_healTimes = 0;
							while {(!(_unit getVariable ["unconscious",false])) && {(_healTimes < 3)}} do {
								uiSleep 3;
								if (!(_unit getVariable ["unconscious",false])) then {
									_health set [0,(((_health select 0) + (DZAI_unitHealAmount/3)) min 12000)];
									_healTimes = _healTimes + 1;
									if ((alive _unit) && {(_healTimes == 3)}) then {
										_health set [1,0];
										_health set [2,false];
										_unit setHit ["legs",0];
									};
								};
							};
							_unit setVariable ["lastBandage",diag_tickTime];
							_unit setVariable ["needsHeal",false];
							uiSleep 1.75;
							{_unit enableAI _x} forEach ["TARGET","MOVE","FSM"];
						};
					} else {
						_lowblood = ((_health select 0) < DZAI_lowBloodLevel);
						_brokenbones = (_health select 2);
						if ((_lowblood or _brokenbones) && {((diag_tickTime - (_unit getVariable ["lastBandage",diag_tickTime])) > 60)}) then {
							_unit setVariable ["needsHeal",true];
						};
					};
				};
				_unit setVariable ["canCheckUnit",true];
			};
		};
		uiSleep 0.1;
	} forEach _units;
	
	//Antistuck prevention
	_wpPos = (getWPPos [_unitGroup,(currentWaypoint _unitGroup)]);
	if ((diag_tickTime - _antistuckTime) > 600) then {
		_unitType = (_unitGroup getVariable ["unitType",""]);
		if (_unitType in ["static","aircustom","landcustom"]) then {
			//Static and custom air/land vehicle patrol anti stuck routine
			if ((_antistuckPos distance _wpPos) == 0) then {
				_currentWP = (currentWaypoint _unitGroup);
				_allWP = (waypoints _unitGroup);
				_nextWP = _currentWP + 1;
				if ((count _allWP) == _nextWP) then {_nextWP = 1}; //Cycle back to first added waypoint if group is currently on last waypoint.
				_unitGroup setCurrentWaypoint [_unitGroup,_nextWP];
				if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Antistuck prevention triggered for AI group %1. Forcing next waypoint.",_unitGroup];};
			} else {
				_antistuckPos = _wpPos;
			};
		} else {
			//Mapwide air/land vehicle patrol anti stuck routine
			if ((canMove _vehicle) && {(_antistuckPos distance _wpPos) < 300}) then {
				_tooClose = true;
				_wpSelect = [];
				while {_tooClose} do {
					_wpSelect = (DZAI_locations call BIS_fnc_selectRandom2) select 1;
					if (((waypointPosition [_unitGroup,0]) distance _wpSelect) < 300) then {
						_tooClose = false;
					} else {
						uiSleep 0.1;
					};
				};
				_wpSelect = [_wpSelect,150 + random(150),random(360),false,[1,300]] call SHK_pos;
				[_unitGroup,0] setWPPos _wpSelect;
				if (_unitType == "air") then {
					[_unitGroup,1] setWPPos _wpSelect;
					_vehicle doMove _wpSelect;
				};
				_antistuckPos = _wpSelect;
				if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Antistuck prevention triggered for AI vehicle %1 (Group: %2). Forcing next waypoint.",_vehicle,_unitGroup];};
			} else {
				_antistuckPos = _wpPos;
			};
		};
		_antistuckTime = diag_tickTime;
	};
	if (_debugMarkers) then {
		_marker setMarkerPos (getPosASL _leader);
		_marker2 setMarkerPos (getWPPos [_unitGroup,(currentWaypoint _unitGroup)]);
	};
	if ((_unitGroup getVariable "GroupSize") > 0) then {uiSleep 15};
};

if (isEngineOn _vehicle) then {_vehicle engineOn false};

if (!isNull _unitGroup) then {
	_unitGroup setVariable ["rearmEnabled",false];
};

if (_debugMarkers) then {
	deleteMarker _marker;
	deleteMarker _marker2;
};

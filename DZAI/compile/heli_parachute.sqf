/*
		DZAI_parachuteOut
		
		Description: Called when AI air vehicle suffers critical damage. Onboard units are ejected if the vehicle is not above water.
		
		Last updated: 12:11 AM 6/17/2014
*/

private ["_helicopter","_vehPos","_unitGroup"];
_helicopter = _this select 0;

if (_helicopter getVariable ["heli_disabled",false]) exitWith {false};
_helicopter setVariable ["heli_disabled",true];
{_helicopter removeAllEventHandlers _x} count ["HandleDamage","GetOut","Killed"];
_unitGroup = _helicopter getVariable "unitGroup";
[_unitGroup,_helicopter] call DZAI_respawnAIVehicle;
_vehPos = ASLtoATL getPosASL _helicopter;

if (!surfaceIsWater _vehPos) then {
	private ["_unitsAlive","_trigger","_weapongrade","_units","_waypointCount"];
	_weapongrade = _unitGroup getVariable ["weapongrade",1];
	_units = units _unitGroup;
	if (((_vehPos select 2) > 60) or {(random 1) < 0.40}) then {
		{
			if (alive _x) then {
				_health = _x getVariable ["unithealth",[]];
				if ((_health select 1) > 0) then {
					_health set [1,0];	//If unit has any leg damage, heal it
					_health set [2,false];	
					_x setHit["legs",0];
				};
			} else {
				0 = [_x,_weapongrade] spawn DZAI_addLoot;
			};
			_x action ["eject",_helicopter];
			unassignVehicle _x;
		} forEach _units;
		
		_unitsAlive = {alive _x} count _units;
		(DZAI_numAIUnits + _unitsAlive) call DZAI_updateUnitCount;
		if (_unitsAlive > 0) then {
			_waypointCount = (count (waypoints _unitGroup));
			if ((waypointType [_unitGroup,(_waypointCount - 1)]) == "CYCLE") then {deleteWaypoint [_unitGroup,(_waypointCount - 1)]; _waypointCount = _waypointCount - 1};
			while {_waypointCount > 0} do {
				deleteWaypoint ((waypoints _unitGroup) select 0);
				_waypointCount = _waypointCount - 1;
			};

			0 = [_unitGroup,_vehPos,75] spawn DZAI_BIN_taskPatrol;
			
			_unitGroup allowFleeing 0;

			//Create area trigger
			_trigger = createTrigger ["EmptyDetector",_vehPos];
			_trigger setTriggerArea [600, 600, 0, false];
			_trigger setTriggerActivation ["ANY", "PRESENT", true];
			_trigger setTriggerTimeout [5, 5, 5, true];
			_trigger setTriggerText (format ["Heli AI Parachute %1",mapGridPosition _helicopter]);
			_trigger setTriggerStatements ["{isPlayer _x} count thisList > 0;","","0 = [thisTrigger] spawn fnc_despawnBandits;"];

			//Set required trigger variables and begin despawn
			_trigger setVariable ["isCleaning",false];
			_trigger setVariable ["GroupArray",[_unitGroup]];
			_trigger setVariable ["equipType",DZAI_heliUnitLevel];
			_trigger setVariable ["maxUnits",[_unitsAlive,0]];
			_trigger setVariable ["respawn",false]; //landed AI units should never respawn
			_trigger setVariable ["permadelete",true]; //units should be permanently despawned
			_trigger call DZAI_updStaticSpawnCount;
			0 = [_trigger] spawn fnc_despawnBandits;

			_unitGroup setVariable ["unitType","static"];
			_unitGroup setVariable ["trigger",_trigger];
			_unitGroup setVariable ["groupSize",_unitsAlive];
			
			_unitGroup setBehaviour "AWARE";
		};
	} else {
		//_unitGroup setVariable ["unitType","aircrashed"]; //aircrashed unitType now set in ai_death.sqf for "air","aircustom" case
		{
			_x action ["eject",_helicopter];
			_nul = [_x,_x] call DZAI_unitDeath;
			0 = [_x,_weapongrade] spawn DZAI_addLoot;
		} forEach _units;
		_units joinSilent grpNull;
		deleteGroup _unitGroup;
		//_nul = [_unitGroup,30] spawn DZAI_deleteGroupTimed;
	};
} else {
	{
		if (alive _x) then {
			deleteVehicle _x;
		} else {
			 [_x] joinSilent grpNull;
		};
	} forEach (units _unitGroup);
	deleteGroup _unitGroup;
};

//_helicopter setVariable ["DZAI_deathTime",diag_tickTime+900];
if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: AI helicopter %1 evacuated at %2.",typeOf _helicopter,mapGridPosition _helicopter];};

true

/*
		
		
		Description: 
		
        Usage:
		
		Last updated:
*/

private ["_vehicle","_trigger","_vehPos","_unitsAlive","_unitGroup"];
_vehicle = _this select 0;

//_vehicle removeAllEventHandlers "GetOut";
if (_vehicle getVariable ["veh_disabled",false]) exitWith {};
_vehicle setVariable ["veh_disabled",true];

_vehicle removeAllEventHandlers "GetOut";
_vehicle removeAllEventHandlers "HandleDamage";
_vehicle removeAllEventHandlers "Killed";

_unitGroup = _vehicle getVariable ["unitGroup",(group (_this select 2))];
_vehPos = getPosATL _vehicle;

_nul = [_unitGroup,_vehicle] spawn {
	_unitGroup = _this select 0;
	_vehicle = _this select 1;
	
	//Convert vehicle units to ground units
	{
		if (alive _x) then {
			private ["_health"];
			0 = [_x, 3] spawn DZAI_autoRearm_unit;
			_x setVariable ["unconscious",false];
			_health = _x getVariable ["unithealth",[12000,0,false]];
			_health set [1,0];
			_health set [2,false];
			_x setHit["legs",0];
			if (_x != (gunner _vehicle)) then {
				unassignVehicle _x;
				_x action ["eject",vehicle _x];
			};
		};
		sleep 0.1;
	} forEach (units _unitGroup);
};

{
	deleteWaypoint _x;
} forEach (waypoints _unitGroup);

0 = [_unitGroup,_vehPos,75] spawn DZAI_BIN_taskPatrol;
_unitsAlive = {alive _x} count (units _unitGroup);
//DZAI_numAIUnits = DZAI_numAIUnits + _unitsAlive;
(DZAI_numAIUnits + _unitsAlive) call DZAI_updateUnitCount;
_unitGroup allowFleeing 0;

//Create area trigger
_trigger = createTrigger ["EmptyDetector",_vehPos];
_trigger setTriggerArea [600, 600, 0, false];
_trigger setTriggerActivation ["ANY", "PRESENT", true];
_trigger setTriggerTimeout [15, 15, 15, true];
_trigger setTriggerText (format ["VehGetOut_%1",mapGridPosition _vehicle]);
_trigger setTriggerStatements ["{isPlayer _x} count thisList > 0;","","0 = [thisTrigger] spawn fnc_despawnBandits;"];
0 = [_trigger,[_unitGroup],75,DZAI_vehEquipType,[],[_unitsAlive,0]] call DZAI_setTrigVars;
_trigger setVariable ["respawn",false];
_trigger setVariable ["permadelete",true];

_unitGroup setVariable ["unitType","static"];
_unitGroup setVariable ["trigger",_trigger];
_unitGroup setVariable ["groupSize",_unitsAlive];

0 = [_trigger] spawn fnc_despawnBandits;

[_vehicle,900] call DZAI_deleteObject;
DZAI_curLandPatrols = DZAI_curLandPatrols - 1;
0 = ["land"] spawn fnc_respawnHandler;
if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: AI vehicle %1 evacuated at %2.",typeOf _vehicle,mapGridPosition _vehicle];};

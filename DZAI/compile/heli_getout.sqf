/*
		DZAI_heliGetOut
		
		Description: Called when AI air vehicle suffers critical damage. Onboard units are ejected if the vehicle is not above water.
		
		Last updated: 4:47 PM 12/27/2013
*/

private ["_helicopter","_vehPos","_unitGroup"];
_helicopter = _this select 0;

if (_helicopter getVariable ["heli_disabled",false]) exitWith {};
_helicopter setVariable ["heli_disabled",true];

//_helicopter removeAllEventHandlers "Killed";
//_helicopter removeAllEventHandlers "GetOut";
//_helicopter removeAllEventHandlers "HandleDamage";

_vehPos = getPosATL _helicopter;
_unitGroup = _helicopter getVariable "unitGroup";

if (!surfaceIsWater _vehPos) then {
	private ["_unitsAlive","_trigger","_weapongrade","_units"];
	//_weapongrade = [DZAI_weaponGrades,DZAI_gradeChancesHeli] call fnc_selectRandomWeighted;
	_weapongrade = DZAI_heliEquipType call DZAI_getWeapongrade;
	_units = units _unitGroup;
	if ((_vehPos select 2) > 60) then {
		{
			if (alive _x) then {
				0 = [_x, _weapongrade] call DZAI_setSkills;
				0 = [_x, _weapongrade] spawn DZAI_autoRearm_unit;
				_x setVariable ["unconscious",false];
				_x setVariable ["unithealth",[12000,0,false]];
				_x setHit["legs",0];
			} else {
				0 = [_x,_weapongrade] spawn DZAI_addLoot;
			};
			_x action ["eject",_helicopter];
			unassignVehicle _x;
		} forEach _units;
		
		_unitsAlive = {alive _x} count _units;
		//DZAI_numAIUnits = DZAI_numAIUnits + _unitsAlive;
		(DZAI_numAIUnits + _unitsAlive) call DZAI_updateUnitCount;
		if (_unitsAlive > 0) then {
			{
				deleteWaypoint _x;
			} forEach (waypoints _unitGroup);
			
			0 = [_unitGroup,_vehPos,75] spawn DZAI_BIN_taskPatrol;
			
			_unitGroup allowFleeing 0;

			//Create area trigger
			_trigger = createTrigger ["EmptyDetector",_vehPos];
			_trigger setTriggerArea [600, 600, 0, false];
			_trigger setTriggerActivation ["ANY", "PRESENT", true];
			_trigger setTriggerTimeout [15, 15, 15, true];
			_trigger setTriggerText (format ["HeliGetOut_%1",mapGridPosition _helicopter]);
			_trigger setTriggerStatements ["{isPlayer _x} count thisList > 0;","","0 = [thisTrigger] spawn fnc_despawnBandits;"];
			0 = [_trigger,[_unitGroup],75,DZAI_heliEquipType,[],[_unitsAlive,0]] call DZAI_setTrigVars;
			_trigger setVariable ["respawn",false];
			_trigger setVariable ["permadelete",true];

			_unitGroup setVariable ["unitType","static"];
			_unitGroup setVariable ["trigger",_trigger];
			_unitGroup setVariable ["groupSize",_unitsAlive];
			
			0 = [_trigger] spawn fnc_despawnBandits;
		};
	} else {
		{
			_x action ["eject",_helicopter];
			_nul = [_x,_x] call DZAI_unitDeath;
			0 = [_x,_weapongrade] spawn DZAI_addLoot;
		} forEach _units;
		deleteGroup _unitGroup;
	};
} else {
	{
		if (alive _x) then {
			deleteVehicle _x;
		};
	} forEach (units _unitGroup);
	deleteGroup _unitGroup;
};

DZAI_curHeliPatrols = DZAI_curHeliPatrols - 1;
0 = ["air"] spawn fnc_respawnHandler;
[_helicopter,900] call DZAI_deleteObject;
if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: AI helicopter %1 evacuated at %2.",typeOf _helicopter,mapGridPosition _helicopter];};
	
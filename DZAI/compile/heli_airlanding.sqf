/*
		DZAI_airLanding
		
		Description: Called when AI air vehicle performs a landing. Converts onboard AI crew into static-type units.
		
		Last updated: 1:49 PM 12/18/2013
*/

private ["_helicopter","_trigger","_heliPos","_weapongrade","_unitsAlive","_unitGroup"];
_helicopter = _this select 0;

if (_helicopter getVariable ["heli_disabled",false]) exitWith {};
_helicopter setVariable ["heli_disabled",true];

_helicopter removeAllEventHandlers "GetOut";
_helicopter removeAllEventHandlers "Killed";
_helicopter removeAllEventHandlers "HandleDamage";
/*
_helicopter addEventHandler ["GetIn",{
	if (isPlayer (_this select 2)) then {
		(_this select 2) action ["getOut",(_this select 0)]; 
		0 = [nil,(_this select 2),"loc",rTITLETEXT,"Players are not permitted to enter AI vehicles!","PLAIN DOWN",5] call RE;
		(_this select 0) setVehicleLock "LOCKED";
		(_this select 0) removeAllEventHandlers "GetIn";
	};
}];*/

_unitGroup = _helicopter getVariable ["unitGroup",(group (_this select 2))];
_heliPos = getPosATL _helicopter;
//_weapongrade = [DZAI_weaponGrades,DZAI_gradeChancesHeli] call fnc_selectRandomWeighted;
_weapongrade = DZAI_heliEquipType call DZAI_getWeapongrade;

//Convert helicrew units to ground units
{
	if (alive _x) then {
		0 = [_x, _weapongrade] call DZAI_setupLoadout;
		0 = [_x, _weapongrade] call DZAI_setSkills;
		0 = [_x, _weapongrade] spawn DZAI_autoRearm_unit;
		_x setVariable ["unconscious",false];
		_x setVariable ["unithealth",[12000,0,false]];
		_x setHit["legs",0];
		unassignVehicle _x;
	};
} forEach (units _unitGroup);

{
	deleteWaypoint _x;
} forEach (waypoints _unitGroup);

0 = [_unitGroup,_heliPos,75] spawn DZAI_BIN_taskPatrol;
_unitsAlive = {alive _x} count (units _unitGroup);
//DZAI_numAIUnits = DZAI_numAIUnits + _unitsAlive;
(DZAI_numAIUnits + _unitsAlive) call DZAI_updateUnitCount;
_unitGroup allowFleeing 0;

//Create area trigger
_trigger = createTrigger ["EmptyDetector",_heliPos];
_trigger setTriggerArea [600, 600, 0, false];
_trigger setTriggerActivation ["ANY", "PRESENT", true];
_trigger setTriggerTimeout [15, 15, 15, true];
_trigger setTriggerText (format ["HeliLandingArea_%1",mapGridPosition _helicopter]);
_trigger setTriggerStatements ["{isPlayer _x} count thisList > 0;","","0 = [thisTrigger] spawn fnc_despawnBandits;"];
0 = [_trigger,[_unitGroup],75,DZAI_heliEquipType,[],[_unitsAlive,0]] call DZAI_setTrigVars;
_trigger setVariable ["respawn",false]; //landed AI units should never respawn
_trigger setVariable ["permadelete",true]; //units should be permanently despawned

_unitGroup setVariable ["unitType","static"]; //convert units to static type
_unitGroup setVariable ["trigger",_trigger]; //attach trigger object reference to group
_unitGroup setVariable ["GroupSize",_unitsAlive]; //set group size

DZAI_curHeliPatrols = DZAI_curHeliPatrols - 1;
0 = ["air"] spawn fnc_respawnHandler;
[_helicopter,900] call DZAI_deleteObject;
if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: AI helicopter %1 landed at %2.",typeOf _helicopter,mapGridPosition _helicopter];};

/*Syntax: 	[
				_spawnMarker, 		//Circular marker defining patrol radius.
				[_minAI,_addAI],	//(Optional, default [1,1]) Minimum and maximum bonus amount of AI units per group.
				_positionArray,		//(Optional, default []): Array of markers defining possible spawn points. If omitted or left empty, nearby buildings within 250m radius will be used as spawn points.
				_equipType,			//(Optional, default 1): Number between 0-3. Defines AI weapon selection and skill parameters.
				_numGroups			//(Optional, default 1): Number of AI groups to spawn using the above parameters.			
			] call DZAI_static_spawn;
*/

private ["_spawnMarker","_minAI","_addAI","_positionArray","_equipType","_numGroups","_patrolDist","_trigStatements","_trigger"];

_spawnMarker = _this select 0;
if ((getMarkerColor _spawnMarker) == "") exitWith {diag_log format ["DZAI Error: Static spawn marker %1 does not exist!",_spawnMarker];};
if ((markerAlpha _spawnMarker) > 0) then {_spawnMarker setMarkerAlpha 0};

if ((count _this) > 1) then {
	_minAI = (_this select 1) select 0;
	_addAI = (_this select 1) select 1;
} else {
	_minAI = 1;
	_addAI = 1;
};

_positionArray = if ((count _this) > 2) then {_this select 2} else {[]};
_equipType = if ((count _this) > 3) then {_this select 3} else {1};
_numGroups = if ((count _this) > 4) then {_this select 4} else {1};

_patrolDist = (getMarkerSize _spawnMarker) select 0;

_trigStatements = format ["_nul = [%1,%2,%3,thisTrigger,%4,%5,%6] call fnc_spawnBandits;",_minAI,_addAI,_patrolDist,_positionArray,_equipType,_numGroups];
_trigger = createTrigger ["EmptyDetector", getMarkerPos(_spawnMarker)];
_trigger setTriggerArea [600, 600, 0, false];
_trigger setTriggerActivation ["ANY", "PRESENT", true];
_trigger setTriggerTimeout [10, 15, 20, true];
_trigger setTriggerText _spawnMarker;
_trigger setTriggerStatements ["{isPlayer _x} count thisList > 0;",_trigStatements,"_nul = [thisTrigger] spawn fnc_despawnBandits;"];

//Pre-initialize trigger if all variables already provided
if ((count _positionArray) > 0) then {
	private ["_spawnPositions"];
	_spawnPositions = [];
	{
		//if ((((getMarkerPos _x) select 0) != 0)&&{(((getMarkerPos _x) select 1) != 0)}) then {
		if ((getMarkerColor _x) != "") then {
			_spawnPositions set [(count _spawnPositions),(getMarkerPos _x)];
			deleteMarker _x;
		};
	} forEach _positionArray;
	if ((count _spawnPositions) > 0) then {
		0 = [_trigger,[],_patrolDist,_equipType,_spawnPositions,[_minAI,_addAI]] call DZAI_setTrigVars;
		if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Found marker positions: %1 (spawnBandits).",_spawnPositions];};
	};
};

deleteMarker _spawnMarker;

_trigger

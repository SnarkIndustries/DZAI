/*
	spawn_heliPatrol
	
	Description:
	
	Last updated:	5:59 PM 1/3/2014
	
*/

private ["_amount"];

if (DZAI_curHeliPatrols >= DZAI_maxHeliPatrols) exitWith {};

_amount = _this;

for "_i" from 1 to _amount do {
	private ["_heliType","_startPos","_helicopter","_unitGroup","_pilot","_turretCount","_weapongrade","_waypoint"];
	_heliType = DZAI_heliTypes call BIS_fnc_selectRandom2;
	
	//If chosen classname isn't an air-type vehicle, then use UH1H as default.
	if !(_heliType isKindOf "air") then {_heliType = "UH1H_DZ"};
	_startPos = [(getMarkerPos "DZAI_centerMarker"),(random((getMarkerSize "DZAI_centerMarker") select 0)),random(360),false] call SHK_pos;
	//_startPos = ["DZAI_centerMarker",true] call SHK_pos;
	
	//Create the patrol group
	_unitGroup = createGroup resistance;
	//diag_log format ["Created group %1",_unitGroup];
	
	//Create helicopter crew
	_pilot = _unitGroup createUnit [(DZAI_BanditTypes call BIS_fnc_selectRandom2), [0,0,0], [], 1, "NONE"];
	[_pilot] joinSilent _unitGroup;
	_unitGroup selectLeader _pilot;
		
	//Create the helicopter and set variables
	_helicopter = createVehicle [_heliType, [_startPos select 0, _startPos select 1, 180], [], 0, "FLY"];
	_helicopter setFuel 1;
	_helicopter engineOn true;
	_helicopter setVehicleLock "LOCKED";
	
	if (_heliType isKindOf "Plane") then {
		private ["_heliDir","_heliSpd"];
		_heliDir = random 360;
		_heliSpd = 120;
		_helicopter setPos [_startPos select 0, _startPos select 1, 180];
		_helicopter setDir _heliDir;
		_helicopter setVelocity [(sin _heliDir * _heliSpd),(cos _heliDir * _heliSpd), 0];
	};
	_nul = _helicopter call DZAI_protectObject;
	clearWeaponCargoGlobal _helicopter;
	clearMagazineCargoGlobal _helicopter;
	_helicopter setVariable ["unitGroup",_unitGroup];
	_helicopter setVariable ["durability",[0,0]];	//[structural, engine]
	if (DZAI_debugLevel > 0) then {diag_log format ["Spawned helicopter type %1 for group %2 at %3.",_heliType,_unitGroup,mapGridPosition _helicopter];};

	//Add helicopter pilot
	//_weapongrade = [DZAI_weaponGrades,DZAI_gradeChancesHeli] call fnc_selectRandomWeighted;
	_weapongrade = DZAI_heliEquipType call DZAI_getWeapongrade;
	_pilot assignAsDriver _helicopter;
	_pilot moveInDriver _helicopter;
	0 = [_pilot,"helicrew"] call DZAI_setSkills;
	0 = [_pilot, _weapongrade] call DZAI_setupLoadout;
	_pilot setVariable ["unithealth",[12000,0,false]];
	_pilot setVariable ["unconscious",true];	//Prevent AI heli crew from being knocked unconscious
	//_pilot setVariable ["DZAI_deathTime",time];
	_pilot setVariable ["bodyName",(name _pilot)];
	if (!(_pilot hasWeapon "NVGoggles")) then {
		_pilot addWeapon "NVGoggles";
		_pilot setVariable ["removeNVG",1];
	};
	_pilot addEventHandler ["HandleDamage",{_this call DZAI_AI_handledamage}];
	
	//Fill all available helicopter gunner seats.
	_heliTurrets = configFile >> "CfgVehicles" >> _heliType >> "turrets";
	if ((count _heliTurrets) > 0) then {
		for "_i" from 0 to ((count _heliTurrets) - 1) do {
			private["_gunner"];
			_gunner = _unitGroup createUnit [(DZAI_BanditTypes call BIS_fnc_selectRandom2), [0,0,0], [], 1, "NONE"];
			_gunner assignAsGunner _helicopter;
			_gunner moveInTurret [_helicopter,[_i]];
			0 = [_gunner,"helicrew"] call DZAI_setSkills;
			0 = [_gunner,_weapongrade] call DZAI_setupLoadout;
			_gunner setVariable ["unithealth",[12000,0,false]];
			_gunner setVariable ["unconscious",true];	//Prevent AI heli crew from being knocked unconscious
			//_gunner setVariable ["DZAI_deathTime",time];
			_gunner setVariable ["bodyName",(name _gunner)];
			if (!(_gunner hasWeapon "NVGoggles")) then {
				_gunner addWeapon "NVGoggles";
				_gunner setVariable ["removeNVG",1];
			};
			_gunner addEventHandler ["HandleDamage",{_this call DZAI_AI_handledamage}];
			[_gunner] joinSilent _unitGroup;
			//diag_log format ["DEBUG :: Assigned gunner %1 of %2 to AI %3.",(_i+1),(count _heliTurrets),_heliType];
		};
	} else {
		if (((count (weapons _helicopter)) < 1) && {(_heliType in (DZAI_airWeapons select 0))}) then {
			private ["_index","_vehWeapon","_vehMag","_check"];
			_index = (DZAI_airWeapons select 0) find _heliType;
			if (_index > -1) then {
				_vehWeapon = (DZAI_airWeapons select 1) select _index;
				_check = [_vehWeapon,"weapon"] call DZAI_checkClassname;
				if (_check) then {
					_helicopter addWeapon _vehWeapon;
					_vehMag = getArray (configFile >> "CfgWeapons" >> _vehWeapon >> "magazines") select 0;
					_helicopter addMagazine _vehMag;
					if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Added weapon %1 and magazine %2 to air vehicle %3.",_vehWeapon,_vehMag,_heliType]};
				};
			};
		};
	};
	//Add eventhandlers
	_helicopter addEventHandler ["Killed",{_this call DZAI_heliDestroyed;}];					//Begin despawn process when heli is destroyed.
	_helicopter addEventHandler ["GetOut",{_this call DZAI_airLanding;}];	//Converts AI crew to ground AI units.
	_helicopter addEventHandler ["HandleDamage",{_this call DZAI_hHandleDamage}];
	_helicopter setVehicleAmmo 1;
	_helicopter flyInHeight 125;
	[_helicopter] spawn DZAI_autoRearm_heli;

	//Set group behavior and waypoint
	_unitGroup allowFleeing 0;
	_unitGroup setBehaviour "AWARE";
	_unitGroup setSpeedMode "FULL";
	_unitGroup setCombatMode "RED";
	_unitGroup setVariable ["unitType","air"];
	
	//AI behavior settings for testing
	/*
	_unitGroup allowFleeing 0;
	_unitGroup setBehaviour "SAFE";
	_unitGroup setSpeedMode "FULL";
	_unitGroup setCombatMode "BLUE";
	*/

	//diag_log format ["DEBUG :: Helicopter group: %1",(units _unitGroup)];

	//Set initial waypoint and begin patrol
	[_unitGroup,0] setWaypointType "MOVE";
	[_unitGroup,0] setWaypointTimeout [1,1,1];
	[_unitGroup,0] setWaypointCompletionRadius 150;
	[_unitGroup,0] setWaypointStatements ["true","[(group this)] spawn DZAI_heliDetectPlayers;"];
	
	_waypoint = _unitGroup addWaypoint [_startPos,0];
	_waypoint setWaypointType "MOVE";
	_waypoint setWaypointTimeout [3,6,9];
	_waypoint setWaypointCompletionRadius 150;
	_waypoint setWaypointStatements ["true","[(group this)] spawn DZAI_heliRandomPatrol;"];
	
	[_unitGroup] spawn DZAI_heliRandomPatrol;

	if ((!isNull _helicopter)&&(!isNull _unitGroup)) then {
		DZAI_curHeliPatrols = DZAI_curHeliPatrols + 1;
		if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: Created AI helicopter crew group %1 is now active and patrolling.",_unitGroup];};
	};
	if (_i < _amount) then {sleep 20};
};

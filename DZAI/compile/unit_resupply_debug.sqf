/*
	unit_resupply (debugging version)
	
	Credits:  Basic script concept adapted from Sarge AI.
	
	Description: Handles AI ammo reload, self-healing, zombie hostility. Called by fnc_createGroup upon AI unit creation.
	
	Last updated: 12:49 AM 11/19/2013
*/
private["_unit","_nearbyZeds","_marker","_markername","_lastBandage","_bandages","_unitGroup","_health","_needsHeal","_unitWeapons","_unitMagazines","_weapongrade","_loadout"];
if (!isServer) exitWith {};
if (DZAI_debugLevel > 1) then {diag_log "DZAI Extended Debug: AI resupply script active.";};

_unit = _this select 0;								//Unit to monitor/reload ammo
_weapongrade = if ((count _this) > 1) then {_this select 1} else {0};

if (_unit getVariable ["rearmEnabled",false]) exitWith {};
_unit setVariable ["rearmEnabled",true];

//Initialize medical variables
if (isNil {_unit getVariable "unithealth"}) then {_unit setVariable ["unithealth",[12000,0,0,false,false]]};
if (isNil {_unit getVariable "unconscious"}) then {_unit setVariable ["unconscious",false]};

_lastBandage = 0;
_bandages = ((_weapongrade + 1) min 3);
_needsHeal = false;

_markername = format["AI_%1",_unit];
if ((getMarkerColor _markername) != "") then {deleteMarker _markername; sleep 5;};	//Delete the previous marker if it wasn't deleted for some reason.
_marker = createMarker[_markername,(getposATL _unit)];
_marker setMarkerShape "ELLIPSE";
_marker setMarkerType "Dot";
_marker setMarkerColor "ColorRed";
_marker setMarkerBrush "SolidBorder";
_marker setMarkerSize [5, 5];

/*_currentWeapon = currentWeapon _unit;									//Retrieve unit's current weapon
_startTime = time;
waitUntil {sleep 0.1; (!isNil "_currentWeapon" or ((time - _startTime) > 15))};
_weaponMagazine = (getArray (configFile >> "CfgWeapons" >> _currentWeapon >> "magazines") select 0);	//Retrieve ammo used by unit's current weapon
_startTime = nil;
waitUntil {sleep 0.05; !isNil "_weaponMagazine"};
_unitWeapons = [_currentWeapon]; _currentWeapon = nil;
_unitMagazines = [_weaponMagazine]; _weaponMagazine = nil;*/

waitUntil {sleep 0.1; _loadout = _unit getVariable "loadout"; ((!isNil "_loadout") or {(isNull _unit)})};
if ((count _loadout) > 0) then {
	_unitWeapons = [_loadout select 0];
	_unitMagazines = [_loadout select 1];
	if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: Rearm script found weapon %1 and magazine %2 assigned to unit %3.",_loadout select 0,_loadout select 1,_unit];};
	_unit setVariable ["loadout",nil];
} else {
	_unitWeapons = [];
	_unitMagazines = [];
	diag_log format ["DZAI Error: No loadout found for unit %1.",_unit];
};

_unitGroup = (group _unit);

if (((count DZAI_launcherTypes) > 0) && {(((units _unitGroup) select 0) == _unit)} && {(_weapongrade in DZAI_launcherLevels)}) then {
	private ["_launchWeapon","_launchAmmo"];
	_launchWeapon = DZAI_launcherTypes call BIS_fnc_selectRandom2;
	_launchAmmo = getArray (configFile >> "CfgWeapons" >> _launchWeapon >> "magazines") select 0;
	_unit addWeapon _launchWeapon; _unitWeapons set [1,_launchWeapon];
	_unit addMagazine _launchAmmo; _unitMagazines set [1,_launchAmmo];
	diag_log format ["DEBUG :: Added launcher weapon %1 to unit %2.",_launchWeapon,_unit];
};
diag_log format ["DEBUG :: Unit weapons: %1, Unit magazines: %2.",_unitWeapons,_unitMagazines];

if (DZAI_debugLevel > 0) then {
	if (isNull (unitBackpack _unit)) then {
		diag_log format ["DZAI Error :: Unit backpack not found! Skin: %1. Backpack: %2. Skin classname possibly incompatible with backpacks.",(typeOf _unit),(unitBackpack _unit)];
	};		//Check if backpack is missing
	if (DZAI_debugLevel > 1) then {
		0 = [_unit] spawn {
			private ["_unit"];
			_unit = _this select 0;
			sleep 5;
			diag_log format ["DZAI ExtDebug (Unit Skills): %1, %2, %3, %4, %5, %6, %7, %8, %9, %10.",_unit skill "aimingAccuracy",_unit skill "aimingShake",_unit skill "aimingSpeed",_unit skill "endurance",_unit skill "spotDistance",_unit skill "spotTime",_unit skill "courage",_unit skill "reloadSpeed",_unit skill "commanding",_unit skill "general"];
			true
		};
	};
};

while {(alive _unit)&&{(!(isNull _unit))}} do {													//Run script for as long as unit is alive
	_marker setmarkerpos (getposATL _unit);
	if (DZAI_zombieEnemy && {((leader _unitGroup) == _unit)}) then {
		_nearbyZeds = (getPosATL _unit) nearEntities ["zZombie_Base",DZAI_zDetectRange];
		{
			if (rating _x > -30000) then {
                _x addrating -30000;
            };
			if ((_unit knowsAbout _x) < 1.5) then {
				_unitGroup reveal [_x,4];
			};
		} forEach _nearbyZeds;
	};
	if !(_unit getVariable ["unconscious",false]) then {
		for "_i" from 0 to ((count _unitWeapons) -1) do {
			if ((_unit ammo (_unitWeapons select _i) == 0) || {!(((_unitMagazines select _i) in magazines _unit))})  then {		//If active weapon has no ammunition, or AI has no magazines, remove empty magazines and add a new magazine.
				_unit removeMagazines (_unitMagazines select _i);
				_unit addMagazine (_unitMagazines select _i);
				if ((getNumber (configFile >> "CfgMagazines" >> (_unitMagazines select _i) >> "count")) <= 8) then {_unit addMagazine (_unitMagazines select _i)};
				if (DZAI_debugLevel > 1) then {diag_log format ["DZAI Extended Debug: AI ammo depleted, added magazine %1 to AI %2.",(_unitMagazines select _i),_unit];};
			};
		};
		if (_bandages > 0) then {
			private ["_health"];
			_health = _unit getVariable "unithealth";
			if (_needsHeal) then {
				private ["_healTimes"];
				_bandages = _bandages - 1;
				_unit disableAI "FSM";
				_unit playActionNow "Medic";
				_healTimes = 0;
				while {(!(_unit getVariable ["unconscious",false])) && {(_healTimes < 3)}} do {
					sleep 3;
					if (!(_unit getVariable ["unconscious",false])) then {
						_health set [0,(((_health select 0) + 2000) min 12000)];
						_healTimes = _healTimes + 1;
						if ((alive _unit) && {(_healTimes == 3)}) then {
							_health set [1,0];
							_health set [2,false];
							_unit setHit["legs",0];
						};
					};
				};
				_lastBandage = time;
				_needsHeal = false;
				sleep 1;
				_unit enableAI "FSM";
			} else {
				private ["_lowblood","_brokenbones"];
				_lowblood = ((_health select 0) < 5000);
				_brokenbones = (_health select 2);
				if ((_lowblood or _brokenbones) && {((time - _lastBandage) > 60)}) then {
					_needsHeal = true;
				};
			};
		};
		//Uncomment to debug death-related scripts.
		/*if ((time - _unit) > 20) then {
			_helicopter setDamage 1;
		};*/
		//diag_log format ["Group %1 has %2 waypoints.",(group _unit),count (waypoints (group _unit))];
	};
	sleep 15;												//Check again in x seconds.
};
sleep 0.5;
deleteMarker _marker;
if (DZAI_debugLevel > 1) then {diag_log "DZAI Extended Debug: AI unit killed/despawned. Stopping rearm script.";};

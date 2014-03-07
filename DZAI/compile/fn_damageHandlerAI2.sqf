private["_unit","_hit","_damage","_source","_ammo","_unithealth","_scale","_blooddamage","_newbloodlevel","_headShots","_partdamage"];
/*
	Damage Handler script modified for DZAI
	Simulates DayZ's player health system for individual AI units
	
*/
_unit = 		_this select 0;				//Object the event handler is assigned to. (the unit taking damage)
_hit = 			_this select 1;				//Name of the selection where the unit was damaged. "" for over-all structural damage, "?" for unknown selections. 
_damage = 		_this select 2;				//Resulting level of damage for the selection. (Received damage)
_source = 		_this select 3;				//The source unit that caused the damage. 
_ammo = 		_this select 4;				//Classname of the projectile that caused inflicted the damage. ("" for unknown, such as falling damage.) 

if ((group _unit) == (group _source)) then {_damage = (_damage/5)};	//Reduce friendly fire and collision damage.
if (isNil {_unit getVariable "unithealth"}) then {_unit setVariable ["unithealth",[12000,0,false]]};	//Reset initial health stats if not found
_unithealth = _unit getVariable "unithealth"; 		// Retrieve unit's health statistics

_scale = 300;
if (_damage > 0.4) then {
	//Calculate locational damage
	switch (_hit) do {
		case "legs": {
			_partdamage = (_unithealth select 1) + (_damage/2);
			_unithealth set [1,_partdamage];	//Record leg damage internally
			if ((_partdamage >= 1) && {!(_unithealth select 2)}) then {
				_nul = _unit spawn {_this setHit["legs",1]};
				[nil,_unit,rSAY,["z_fracture_1",40]] call RE;
				_unithealth set [2,true];
			}; //Break legs when enough damage taken
		};
		case "head_hit": {
			_scale = _scale * 6;
			if (_damage > 1.5) then {
				_nul = [_unit,_source,"shothead"] call DZAI_unitDeath;
			};
		};
	};
	if (isPlayer _source) then {
		_scale = _scale + 800;
		if (_hit == "head_hit") then {
			_scale = _scale + 500;
		};
	};
	if ((_ammo isKindOf "Grenade") or {(_ammo isKindof "B_127x107_Ball")} or {(_ammo isKindof "B_127x99_Ball")}) then {_scale = _scale + 200};
	_blooddamage = (_damage * _scale);
	_newbloodlevel = (_unithealth select 0) - _blooddamage;
	_unithealth set [0,_newbloodlevel];
	//diag_log format ["DEBUG :: Unit %1 took %2 blood damage (Total blood: %3).",_unit,_blooddamage,_newbloodlevel];
	if (!(_unit getVariable ["unconscious",false]) && {((_damage > 2) || {((_damage > 0.5) && (_hit == "head_hit"))})}) then {_nul = [_unit,_hit] spawn DZAI_unconscious; _unit setVariable ["unconscious",true];};
};

if (_newbloodlevel <= 0) then {
	_nul = [_unit,_source,"bled"] call DZAI_unitDeath;
};

0

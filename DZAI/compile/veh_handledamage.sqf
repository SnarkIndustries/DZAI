private["_unit","_hit","_damage","_source","_ammo"];
//_unit = 		_this select 0;				//Object the event handler is assigned to. (the unit taking damage)
_hit = 			_this select 1;				//Name of the selection where the unit was damaged. "" for over-all structural damage, "?" for unknown selections. 
_damage = 		_this select 2;				//Resulting level of damage for the selection. (Received damage)
//_source = 		_this select 3;				//The source unit that caused the damage. 
_ammo = 		_this select 4;				//Classname of the projectile that caused inflicted the damage. ("" for unknown, such as falling damage.) 

//if ((_ammo == "") && {_hit in ["wheel_1_1_steering","wheel_1_2_steering","wheel_2_1_steering","wheel_2_2_steering","wheel_2_3_steering","wheel_1_3_steering","motor"]}) then {_damage = 0};
if (_ammo == "") then {_damage = 0};

_damage
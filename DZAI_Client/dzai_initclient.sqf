if (isServer) exitWith {};

#include "DZAI_client_version.hpp"
diag_log format ["[DZAI] Initializing %1 version %2.",DZAI_CLIENT_TYPE,DZAI_CLIENT_VERSION];

call compile preprocessFileLineNumbers "DZAI_Client\dzai_client_config.sqf";

if (DZAIC_radio) then {
	"DZAI_SMS" addPublicVariableEventHandler {
		if (isNil "DZAI_noRadio") then {
			systemChat (_this select 1);
			DZAI_noRadio = true;
			_nul = (_this select 1) spawn {
				for "_i" from 1 to 2 do {cutText [_this, "PLAIN DOWN"];sleep 0.5;};
				DZAI_noRadio = nil;
			};
		};
	};
};

if (DZAIC_zombieEnemy) then {
	"DZAI_ratingModify" addPublicVariableEventHandler {
		_targets = (_this select 1) select 0;
		_rating = (_this select 1) select 1;
		
		{
			if (local _x) then {_x addRating _rating};
		} forEach _targets;
	};
};

if (DZAIC_deathMessages) then {
	"DZAI_killMSG" addPublicVariableEventHandler {
		systemChat format ["%1 was killed",(_this select 1)];
		//diag_log format ["DZAI Debug: %1 was killed.",(_this select 1)];
	};
};

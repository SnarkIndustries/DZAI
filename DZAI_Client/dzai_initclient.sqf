if (isServer) exitWith {};

if ("clientradio" in _this) then {
	"DZAI_SMS" addPublicVariableEventHandler {
		if (isNil "DZAI_noRadio") then {
			DZAI_noRadio = true;
			systemChat (_this select 1);
			_nul = (_this select 1) spawn {
				for "_i" from 1 to 2 do {cutText [_this, "PLAIN DOWN"];sleep 0.5;};
				DZAI_noRadio = nil;
			};
		};
	};
};

if ("zombieenemy" in _this) then {
	"DZAI_ratingModify" addPublicVariableEventHandler {
		_targets = (_this select 1) select 0;
		_rating = (_this select 1) select 1;
		
		{
			if (local _x) then {_x addRating _rating};
		} forEach _targets;
	};
};

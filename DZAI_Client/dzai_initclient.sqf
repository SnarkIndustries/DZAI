if (isServer) exitWith {};

"DZAI_SMS" addPublicVariableEventHandler {
	if (isNil "DZAI_noRadio") then {
		DZAI_noRadio = true;
		_nul = (_this select 1) spawn {
			for "_i" from 1 to 3 do {cutText [_this, "PLAIN DOWN"];sleep 1;};
			DZAI_noRadio = nil;
		};
	};
};


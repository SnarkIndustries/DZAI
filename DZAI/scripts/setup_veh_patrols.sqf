
waitUntil {sleep 0.1; !isNil "DZAI_locations_ready"};

if (DZAI_maxHeliPatrols > 0) then {
	if ((count DZAI_heliTypes) < 1) then {DZAI_heliTypes = ["UH1H_DZ"]}; 
	_helipatrols = DZAI_maxHeliPatrols spawn DZAI_spawnHeliPatrol;
	sleep 5;
};

if (DZAI_maxLandPatrols > 0) then {
	if ((count DZAI_vehTypes) < 1) then {DZAI_vehTypes = ["UAZ_Unarmed_TK_EP1"]};
	_vehpatrols = DZAI_maxLandPatrols spawn DZAI_spawnVehPatrol;
};

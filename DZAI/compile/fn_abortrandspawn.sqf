private["_trigger","_triggerLocation"];
_trigger = _this;

[_trigger,"DZAI_randTriggerArray"] call DZAI_updateSpawnCount;
if ((!isNil "DZAI_debugMarkersEnabled") && {DZAI_debugMarkersEnabled}) then {deleteMarker (str _trigger)};

_triggerLocation = _trigger getVariable "triggerLocation";
deleteLocation _triggerLocation;
//_triggerLocation setVariable ["deletetime",(diag_tickTime + 900)];
//DZAI_tempBlacklist set [(count DZAI_tempBlacklist),_triggerLocation];
	
deleteVehicle _trigger;

false

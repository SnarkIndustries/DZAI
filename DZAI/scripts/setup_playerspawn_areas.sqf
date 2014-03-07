

{
	if ((getMarkerColor _x) != "") then {
		_blacklist = createLocation ["Strategic",getMarkerPos _x,600,600];
		//diag_log format ["DEBUG :: Created fresh spawn protection area at %1.",getMarkerPos _x];
	};
} forEach ["spawn0","spawn1","spawn2","spawn3","spawn4"];
	
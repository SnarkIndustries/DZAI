private ["_trigger","_markername","_marker"];
_trigger = _this select 0;

_marker = str (_trigger);

while {(getMarkerColor _marker) != "ColorGreen"} do {
	_marker setMarkerPos (getMarkerPos _marker);
	sleep 30;
};

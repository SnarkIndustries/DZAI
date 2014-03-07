/*  Select a random position from an area defined by a marker.
     In: [marker,water,blacklist]
    Out: position
*/
private ["_area","_water","_blist","_pos"];
_area = _this select 0;
_water = if (count _this > 1) then {_this select 1} else {false};
_blist = if (count _this > 2) then {_this select 2} else {[]};
_pos = [];

if (typename _blist == "STRING") then {_blist = [_blist]};

private ["_shape"];
_shape = _area call SHK_pos_fnc_getMarkerShape;

// If shape is icon, aka dot, it has no area, just single position.
if (_shape == "ICON") then {
  _pos = getmarkerpos _area;
  
  // Water position is not allowed
  if !_water then {
    if (surfaceIsWater _pos) then {
      _pos = [];
    }
  };
  
// Marker has an area to choose position from.
} else {
  // Limited loop so the script won't get stuck
  private ["_i","_exit"];
  _exit = false;
  for [{_i = 0}, {_i < 1000 && !_exit}, {_i = _i + 1}] do {
  
    // Rectangle or Ellipse marker given?
    if (_shape in ["SQUARE","RECTANGLE"]) then {
      _pos = _area call SHK_pos_fnc_getPosFromRectangle;
    } else {
      _pos = _area call SHK_pos_fnc_getPosFromEllipse;
    };
    
    // Water position is not allowed
    if !_water then {
      // Position is on land, try to exit script.
      if !(surfaceIsWater _pos) then {
        _exit = true;
      };
    // Doesn't matter if position is on water or land.
    } else {
      _exit = true;
    };

    // Position is not allowed in blacklisted areas
    if (count _blist > 0 && _exit) then {
      // Check each blacklist marker
      {
        // If blacklisted, jump out of blacklist check and continue main loop.
        if ([_pos,_x] call SHK_pos_fnc_isBlacklisted) exitwith {
          _exit = false;
        };
      } foreach _blist;
    };
    
  };
};
// Return position
_pos
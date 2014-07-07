activateAddons [
];

activateAddons [];
initAmbientLife;

_this = createCenter west;
_center_0 = _this;

_this = createMarker ["center", [10791.924, 9170.3945]];
_this setMarkerShape "ELLIPSE";
_this setMarkerType "Flag";
_this setMarkerBrush "Solid";
_this setMarkerSize [3500, 3500];
_marker_0 = _this;

_group_0 = createGroup _center_0;

_unit_1 = objNull;
if (true) then
{
  _this = _group_0 createUnit ["BAF_Soldier_AA_W", [10506.402, 11137.236, 0], [], 0, "CAN_COLLIDE"];
  _unit_1 = _this;
  _this setUnitAbility 0.60000002;
  if (true) then {_group_0 selectLeader _this;};
  if (true) then {selectPlayer _this;};
};

_vehicle_0 = objNull;
if (true) then
{
  _this = createVehicle ["A10_US_EP1", [7728.7505, 4290.2534, 0.03515517], [], 0, "CAN_COLLIDE"];
  _vehicle_0 = _this;
  _this setDir 90.576485;
  _this setPos [7728.7505, 4290.2534, 0.03515517];
};

_vehicle_9 = objNull;
if (true) then
{
  _this = createVehicle ["AH6J_EP1", [15871.252, 6580.6714, 7.6293945e-006], [], 0, "CAN_COLLIDE"];
  _vehicle_9 = _this;
  _this setDir 189.00227;
  _this setPos [15871.252, 6580.6714, 7.6293945e-006];
};

_vehicle_10 = objNull;
if (true) then
{
  _this = createVehicle ["AH6J_EP1", [14908.236, 6291.9087, -1.1444092e-005], [], 0, "CAN_COLLIDE"];
  _vehicle_10 = _this;
  _this setDir 40.534733;
  _this setPos [14908.236, 6291.9087, -1.1444092e-005];
};

_vehicle_11 = objNull;
if (true) then
{
  _this = createVehicle ["AH6J_EP1", [12992.739, 9672.2861, 7.6293945e-006], [], 0, "CAN_COLLIDE"];
  _vehicle_11 = _this;
  _this setDir 178.92287;
  _this setPos [12992.739, 9672.2861, 7.6293945e-006];
};

processInitCommands;
runInitScript;
finishMissionInit;

/*
	DayZ Civilian Classname Configuration
	
	Last updated: 10:46 AM 9/14/2013
	
*/
private ["_newItems"];

DZAI_Backpacks0 set [count DZAI_Backpacks0,"ice_apo_pack3"];
_newItems = ["ice_apo_pack3","ice_apo_pack1"];
for "_i" from 0 to ((count _newItems) - 1) do {DZAI_Backpacks1 set [(count DZAI_Backpacks1),(_newItems select _i)];};
_newItems = ["ice_apo_pack1","ice_apo_pack4","ice_apo_pack2"];
for "_i" from 0 to ((count _newItems) - 1) do {DZAI_Backpacks2 set [(count DZAI_Backpacks2),(_newItems select _i)];};
_newItems = ["ice_apo_pack4","ice_apo_pack2"];
for "_i" from 0 to ((count _newItems) - 1) do {DZAI_Backpacks3 set [(count DZAI_Backpacks3),(_newItems select _i)];};
diag_log "DayZ Civilian classnames loaded.";
/*
	Ovaron static spawn configuration 
	
	Last updated: 9:07 PM 1/23/2014
	
*/

#include "spawn_markers\markers_cmr_ovaron.sqf"	//Load manual spawn point definitions file.

waitUntil {sleep 0.1; !isNil "DZAI_classnamesVerified"};	//Wait for DZAI to finish verifying classname arrays or finish building classname arrays if verification is disabled.

if (DZAI_staticAI) then {
	[] execVM format ["%1\scripts\setup_autoStaticSpawns.sqf",DZAI_directory]; //IMPORTANT: REMOVE THIS ENTIRE LINE BEFORE ADDING STATIC SPAWNS HERE
};

#include "custom_markers\cust_markers_cmr_ovaron.sqf"
#include "custom_spawns\cust_spawns_cmr_ovaron.sqf"
//----------------------------Do not edit anything below this line -----------------------------------------
DZAI_customSpawnsReady = true;
diag_log "Ovaron static spawn configuration loaded.";
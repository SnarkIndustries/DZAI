/*
	Taviana static spawn configuration 
	
	Last updated: 11:58 PM 6/6/2013
	
*/

#include "spawn_markers\markers_tavi.sqf"	//Load manual spawn point definitions file.

waitUntil {sleep 0.1; !isNil "DZAI_classnamesVerified"};	//Wait for DZAI to finish verifying classname arrays or finish building classname arrays if verification is disabled.

if (DZAI_staticAI) then {
	#include "spawn_areas\areas_taviana.sqf"		//Load spawn area definitions file.
	['DZAI_Blato',[0,1],[],0] call DZAI_static_spawn;
	['DZAI_Seven',[0,1],[],0] call DZAI_static_spawn;
	['DZAI_Marina',[0,1],[],0] call DZAI_static_spawn;
	['DZAI_Topolka',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Branibor',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Branibor2',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Branibor3',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Branibor4',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_BashkaLukaMilBase',[1,1],[],2] call DZAI_static_spawn;
	['DZAI_Kryvoe',[1,1],[],0] call DZAI_static_spawn;
	['DZAI_Krasnoz1',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Krasnoz2',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_KrasnozAirport',[2,0],[],2] call DZAI_static_spawn;
	['DZAI_KrasnozMilBase',[2,1],[],2] call DZAI_static_spawn;
	['DZAI_Vedich',[0,1],[],0] call DZAI_static_spawn;
	['DZAI_Chernovar',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Bilgrad',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Bilgrad2',[0,1],[],1] call DZAI_static_spawn;
	['DZAI_Shtangrad',[1,1],[],0] call DZAI_static_spawn;
	['DZAI_ShtangradMilBase',[1,1],[],2] call DZAI_static_spawn;
	['DZAI_Mitrovice',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Mitrovice2',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Komarovo',[0,1],[],0] call DZAI_static_spawn;
	['DZAI_KomarovoMilBase',[1,1],[],2] call DZAI_static_spawn;
	['DZAI_ZhutaMilBase',[1,1],[],2] call DZAI_static_spawn;
	['DZAI_StarePoleMilBase',[1,1],[],2] call DZAI_static_spawn;
	['DZAI_SwampMilBase',[2,1],[],3] call DZAI_static_spawn;
	['DZAI_DubovoAirport',[1,1],[],2] call DZAI_static_spawn;
	['DZAI_DubovoAirport2',[1,1],[],2] call DZAI_static_spawn;
	['DZAI_Dubovo',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_StariSad',[0,1],[],0] call DZAI_static_spawn;
	['DZAI_Byelov',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Kopech',[0,1],[],0] call DZAI_static_spawn;
	['DZAI_Boye',[1,1],[],0] call DZAI_static_spawn;
	['DZAI_Postoyna',[1,1],[],0] call DZAI_static_spawn;
	['DZAI_Molotovsk',[1,1],[],0] call DZAI_static_spawn;
	['DZAI_Martin',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_MillMilBase',[2,1],[],2] call DZAI_static_spawn;
	['DZAI_Gorka',[0,1],[],1] call DZAI_static_spawn;
	['DZAI_SevastopolMilBase',[1,1],[],2] call DZAI_static_spawn;
	['DZAI_Sevastopol',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Sevastopol2',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Dalnogorsk',[1,1],[],0] call DZAI_static_spawn;
	['DZAI_DalnogorskMilBase',[1,1],[],2] call DZAI_static_spawn;
	['DZAI_Ekaterinburg',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Ekaterinburg2',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Yaroslav',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_YaroslavMilBase',[2,1],[],2] call DZAI_static_spawn;
	['DZAI_JaroslavskiAirport',[1,1],[],2] call DZAI_static_spawn;
	['DZAI_Lyubol',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Etanovsk',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Etanovsk2',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Vishkov',[1,1],[],2] call DZAI_static_spawn;
	['DZAI_StariGrad',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Dubravka',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Lyepestok',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Zelenogorod',[2,0],[],2] call DZAI_static_spawn;
	['DZAI_Bori',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Nina',[1,1],[],0] call DZAI_static_spawn;
	['DZAI_NinaMilBae',[1,1],[],2] call DZAI_static_spawn;
	['DZAI_Kustik',[0,1],[],1] call DZAI_static_spawn;
	['DZAI_ChrveniGradok',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_VinogradFactory',[1,0],[],1] call DZAI_static_spawn;
	['DZAI_Doriyanov',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Solibor',[1,1],[],2] call DZAI_static_spawn;
	['DZAI_Prilep',[1,1],[],0] call DZAI_static_spawn;
	['DZAI_NoviBor',[0,1],[],0] call DZAI_static_spawn;
	['DZAI_SabinaCenter',[1,1],[],0] call DZAI_static_spawn;
	['DZAI_Uyezd',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Podgorica',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Sabina',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Dyelnica',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Slovany',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Slovany2',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_Dyelnica2',[1,1],[],1] call DZAI_static_spawn;
	['DZAI_NekhayMilSpecial',[1,1],[],3] call DZAI_static_spawn;
};

#include "custom_markers\cust_markers_tavi.sqf"
#include "custom_spawns\cust_spawns_tavi.sqf"
//----------------------------Do not edit anything below this line -----------------------------------------
DZAI_customSpawnsReady = true;
diag_log "Taviana static spawn configuration loaded.";

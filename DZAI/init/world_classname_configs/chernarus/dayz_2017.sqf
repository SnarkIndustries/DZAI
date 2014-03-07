/*
	DayZ 2017 Classname Configuration
	
	Last updated: 10:45 AM 9/14/2013
	
*/

DZAI_invmedicals = 0; 										//Number of selections of medical items (Inventory)
DZAI_invedibles = 0;										//Number of selections of edible items (Inventory)
DZAI_bpmedicals = 0; 										//Number of selections of medical items (Backpack)
DZAI_bpedibles = 1;											//Number of selections of edible items (Backpack)
DZAI_BanditTypes = DZAI_BanditTypes - ["Bandit1_DZ", "BanditW1_DZ", "Camo1_DZ", "Sniper1_DZ"];
DZAI_BanditTypes = [DZAI_BanditTypes,["Beard_DZ","Dimitry_DZ","Alexej_DZ","Stanislav_DZ","Czech_Norris"]] call DZAI_append;
DZAI_Edibles = DZAI_Edibles - ["FoodCanPasta","ItemWaterbottleBoiled","FoodmuttonCooked","FoodchickenCooked","FoodBaconCooked","FoodRabbitCooked","FoodbaconRaw","FoodchickenRaw","FoodmuttonRaw","foodrabbitRaw","FoodCanUnlabeled","FoodPistachio","FoodNutmix","FoodMRE"] + ["HumanFleshCooked","RawHumanFlesh","RawInfectedFlesh","InfectedFleshCooked","FoodSteakCooked","FoodSteakRaw","FoodCanDogFood"];
DZAI_MiscItemS = DZAI_MiscItemS - ["HandGrenade_West","FlareGreen_M203","HandGrenade_West","FlareGreen_M203"];
DZAI_gradeChances0 = [0.90,0.10,0.00,0.00];
DZAI_gradeChances1 = [0.65,0.30,0.05,0.00];
DZAI_gradeChances2 = [0.30,0.45,0.15,0.00];
DZAI_gradeChances3 = [0.25,0.55,0.20,0.00];
//Reduce tool probabilities (both tiers)
DZAI_gadgets0 set [1,["NVGoggles",0.00]];
DZAI_gadgets1 set [1,["NVGoggles",0.00]];
DZAI_tools0 set [0,["ItemFlashlight",0.60]];
DZAI_tools0 set [2,["ItemKnife",0.65]];
DZAI_tools0 set [3,["ItemHatchet",0.60]];
DZAI_tools0 set [4,["ItemCompass",0.40]];
DZAI_tools0 set [5,["ItemMap",0.30]];
DZAI_tools0 set [7,["ItemFlint",0.20]];		//Replace ItemMatchbox with ItemFlint
DZAI_tools0 set [8,["ItemFlashlightRed",0.10]];
DZAI_tools0 set [9,["ItemGPS",0.000]];		//Reduce probability of functional GPS
DZAI_tools1 set [0,["ItemFlashlight",0.60]];
DZAI_tools1 set [2,["ItemKnife",0.65]];
DZAI_tools1 set [3,["ItemHatchet",0.60]];
DZAI_tools1 set [4,["ItemCompass",0.40]];
DZAI_tools1 set [5,["ItemMap",0.30]];
DZAI_tools1 set [7,["ItemFlint",0.20]];		//Replace ItemMatchbox with ItemFlint
DZAI_tools1 set [8,["ItemFlashlightRed",0.10]];
DZAI_tools1 set [9,["ItemGPS",0.000]];		//Reduce probability of functional GPS
DZAI_Backpacks0 = ["ice_apo_pack3"];
DZAI_Backpacks1 = ["ice_apo_pack3","ice_apo_pack1"];
DZAI_Backpacks2 = ["ice_apo_pack1","ice_apo_pack4","ice_apo_pack2"];
DZAI_Backpacks3 = ["ice_apo_pack4","ice_apo_pack2"];
if (DZAI_tempNVGs) then {DZAI_tempNVGs = false;};	//Disable temporary NVG chance for DayZ 2017.
diag_log "DayZ 2017 classnames loaded.";

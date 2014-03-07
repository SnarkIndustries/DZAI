/*
	Description: 	
	
		Basic tables containing AI equipment classnames and skin models used by AI units. 
		Some settings may be overridden by map-specific configuration files in the world_classname_configs folder.
		To make changes for a specific DayZ mod, edit the appropriate config file in for the map/mod being used.

	How it works:
	
		DZAI will first load global classnames defined by global_classnames.sqf, then load the map/mod-specific file to modify global settings.
		Example: DZAI will always first load global_classnames.sqf, then if DayZ Epoch is detected, DZAI will overwrite settings specified by epoch\dayz_epoch.sqf. 

		In this case, you may need to edit both global_classnames.sqf and \epoch\dayz_epoch.sqf to make your wanted classname changes.

	Last upated: 9:16 PM 2/19/2014
*/


//Default weapon classname tables - DZAI will only use these tables if the dynamic weapon list (DZAI_dynamicWeaponList) is disabled, otherwise they are ignored and overwritten if it is enabled.
//Note: Low-level AI may use pistols listed in DZAI_Pistols0 or DZAI_Pistols1. Mid/high level AI will carry pistol weapons but not use them - they will use rifle weapons instead.
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DZAI_Pistols0 = ["Makarov","Colt1911","revolver_EP1"]; 				//Weapongrade 0 pistols
DZAI_Pistols1 = ["M9","M9SD","MakarovSD","UZI_EP1","glock17_EP1"]; 	//Weapongrade 1 pistols
DZAI_Pistols2 = ["M9SD","MakarovSD","UZI_EP1","glock17_EP1"]; 		//Weapongrade 2 pistols
DZAI_Pistols3 = ["M9SD","MakarovSD","UZI_EP1","glock17_EP1"]; 		//Weapongrade 3 pistols

DZAI_Rifles0 = ["LeeEnfield","Winchester1866","MR43","huntingrifle","LeeEnfield","Winchester1866","MR43"]; //Weapongrade 0 rifles
DZAI_Rifles1 = ["M16A2","M16A2GL","AK_74","M4A1_Aim","AKS_74_kobra","AKS_74_U","AK_47_M","M24","M1014","DMR_DZ","M4A1","M14_EP1","Remington870_lamp","MP5A5","MP5SD","M4A3_CCO_EP1"]; //Weapongrade 1 rifles
DZAI_Rifles2 = ["M16A2","M16A2GL","M249_DZ","AK_74","M4A1_Aim","AKS_74_kobra","AKS_74_U","AK_47_M","M24","SVD_CAMO","M1014","DMR_DZ","M4A1","M14_EP1","Remington870_lamp","M240_DZ","M4A1_AIM_SD_camo","M16A4_ACG","M4A1_HWS_GL_camo","Mk_48_DZ","M4A3_CCO_EP1","Sa58V_RCO_EP1","Sa58V_CCO_EP1","M40A3","Sa58P_EP1","Sa58V_EP1"]; //Weapongrade 2 rifles
DZAI_Rifles3 = ["FN_FAL","FN_FAL_ANPVS4","Mk_48_DZ","M249_DZ","BAF_L85A2_RIS_Holo","G36C","G36C_camo","G36A_camo","G36K_camo","AK_47_M","AKS_74_U","M14_EP1","bizon_silenced","DMR_DZ","RPK_74"]; //Weapongrade 3 rifles

	
//Note: Custom rifle tables can be defined below this line (DZAI_Rifles4 - DZAI_Rifles9). Custom rifle tables can only be used with custom-defined spawns (spawns created using the DZAI_spawn function). 
//Instructions: Replace "nil" with the wanted rifle array. Refer to the above rifle arrays for examples on how to define custom rifle tables.
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DZAI_Rifles4 = nil; //weapongrade 4 weapons
DZAI_Rifles5 = nil; //weapongrade 5 weapons
DZAI_Rifles6 = nil; //weapongrade 6 weapons
DZAI_Rifles7 = nil; //weapongrade 7 weapons
DZAI_Rifles8 = nil; //weapongrade 8 weapons
DZAI_Rifles9 = nil; //weapongrade 9 weapons


//AI skin classnames. DZAI will use any of these classnames for AI spawned. Note: Additional skins may be used on a per-map or per-mod basis - see appropriate folders in \world_classname_configs
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DZAI_BanditTypes = ["Survivor2_DZ", "SurvivorW2_DZ", "Bandit1_DZ", "BanditW1_DZ", "Camo1_DZ", "Sniper1_DZ"]; //List of skins for AI units to use


//AI Backpack types.
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DZAI_Backpacks0 = ["DZ_Patrol_Pack_EP1","DZ_Czech_Vest_Puch","DZ_Assault_Pack_EP1"];
DZAI_Backpacks1 = ["DZ_Patrol_Pack_EP1","DZ_Czech_Vest_Puch","DZ_Assault_Pack_EP1","DZ_British_ACU","DZ_TK_Assault_Pack_EP1","DZ_CivilBackpack_EP1","DZ_ALICE_Pack_EP1"];
DZAI_Backpacks2 = ["DZ_CivilBackpack_EP1","DZ_British_ACU","DZ_Backpack_EP1"];
DZAI_Backpacks3 = ["DZ_CivilBackpack_EP1","DZ_Backpack_EP1"];


//AI Food/Medical item types.
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DZAI_Edibles = ["ItemSodaCoke", "ItemSodaPepsi", "ItemWaterbottle", "FoodCanSardines", "FoodCanBakedBeans", "FoodCanFrankBeans", "FoodCanPasta", "ItemWaterbottleUnfilled","ItemWaterbottleBoiled","FoodmuttonCooked","FoodchickenCooked","FoodBaconCooked","FoodRabbitCooked","FoodbaconRaw","FoodchickenRaw","FoodmuttonRaw","foodrabbitRaw","FoodCanUnlabeled","FoodPistachio","FoodNutmix","FoodMRE"]; //List of all edible items
DZAI_Medicals1 = ["ItemBandage", "ItemPainkiller"]; //List of common medical items
DZAI_Medicals2 = ["ItemPainkiller", "ItemMorphine", "ItemBandage", "ItemBloodbag", "ItemAntibiotic","ItemEpinephrine"]; //List of all medical items


//AI Miscellaneous item types.
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DZAI_MiscItemS = ["ItemHeatpack", "HandRoadFlare", "HandChemBlue", "HandChemRed", "HandChemGreen","SmokeShell","TrashTinCan","TrashJackDaniels","ItemSodaEmpty"]; //List of random miscellaneous items (1 inventory space)
DZAI_MiscItemL = ["ItemJerrycan", "PartWheel", "PartEngine", "PartFueltank", "PartGlass", "PartVRotor","PartWoodPile"]; //List of random miscellaneous items (>1 inventory space)


//AI toolbelt item types. Toolbelt items are added to AI inventory upon death. Format: [item classname, item probability]
//NOTE: To remove an item, set its chance to 0, don't delete it from the array. To add a toolbelt item as loot, add it to the end of the array.
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DZAI_tools0 = [["ItemFlashlight",0.65],["ItemWatch",0.65],["ItemKnife",0.50],["ItemHatchet",0.40],["ItemCompass",0.35],["ItemMap",0.25],["ItemToolbox",0.10],["ItemMatchbox",0.10],["ItemFlashlightRed",0.05],["ItemGPS",0.005],["ItemRadio",0.005]];
DZAI_tools1 = [["ItemFlashlight",0.90],["ItemWatch",0.90],["ItemKnife",0.75],["ItemHatchet",0.70],["ItemCompass",0.60],["ItemMap",0.50],["ItemToolbox",0.20],["ItemMatchbox",0.20],["ItemFlashlightRed",0.10],["ItemGPS",0.125],["ItemRadio",0.05]];


//AI-useable toolbelt item types. These items are added to AI inventory at unit creation and may be used by AI. Format: [item classname, item probability]
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DZAI_gadgets0 = [["binocular",0.40],["NVGoggles",0.00]];
DZAI_gadgets1 = [["binocular",0.60],["NVGoggles",0.05]];


//Nothing to edit past this point
diag_log "[DZAI] Global classname tables loaded.";

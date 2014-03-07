/*
	Sahrani Classname Configuration
	
	Last updated: 1:14 PM 6/3/2013
	
*/

private ["_craftingBooks","_newAISkins"];

_newAISkins = ["Rocket_DZ","BanditSkin_DZ","SniperBandit_DZ","SniperBanditW_DZ","Sniper1W_DZ","BanditSkinW_DZ"];
_craftingBooks = [["ItemCraftingBook",0.10],["ItemCraftingBook2",0.10],["ItemCraftingBook3",0.05]];

for "_i" from 0 to ((count _newAISkins) - 1) do {DZAI_BanditTypes set [(count DZAI_BanditTypes),(_newAISkins select _i)];};
DZAI_Edibles = DZAI_Edibles - ["FoodCanUnlabeled","FoodPistachio","FoodNutmix","FoodMRE"];
DZAI_MiscItemS set [(count DZAI_MiscItemS),"ItemNails"];
 
for "_i" from 0 to ((count _craftingBooks) - 1) do {DZAI_tools0 set [(count DZAI_tools0),(_craftingBooks select _i)];};
for "_i" from 0 to ((count _craftingBooks) - 1) do {DZAI_tools1 set [(count DZAI_tools1),(_craftingBooks select _i)];};

diag_log "[DZAI] Sahrani classnames loaded.";

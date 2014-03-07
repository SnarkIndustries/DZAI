/*
	DZAI Custom Spawn Function
	
	Description: An easy-to-use function for server admins to create AI spawns at specific locations.
	
 
	
	Explanation of DZAI_spawn:
	
	[
		"dzaicustomspawntest",	//This is the marker name to be used as the patrol and spawning area.
		2, 						//This trigger will spawn a group of 2 AI units.
		1,						//AI spawned by this trigger will have Weapon Grade level 1 (see below for explanation of Weapon Grade)
		true					//(OPTIONAL) Respawn setting. True: AI spawned will respawn. False: AI will not respawn. See more here: http://opendayz.net/threads/release-dzai-lite-dynamic-ai-package.11116/page-28#post-79148
	] call DZAI_spawn;
	
	Weapon Grade explanation:
	
	0: Approx 40% of maximum AI skill potential - weapon from Farm/Residential loot table.
	1: Approx 55% of maximum AI skill potential - weapon from Military loot table
	2: Approx 70% of maximum AI skill potential - weapon from MilitarySpecial (Barracks) loot table
	3: Approx 80% of maximum AI skill potential - weapon from HeliCrash loot table 
	
	Note: This trigger will create 2 respawning AI units with weapons from DayZ's military loot table.
	
*/

//----------------------------Add your custom spawn definitions below this line ----------------------------

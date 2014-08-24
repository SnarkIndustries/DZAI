DZAI 2.1.2 - AI Addon for DayZ
Introduction

DZAI is designed to be a simple, configurable, easy-to-install AI package. This AI package is designed to work out of the box with any supported DayZ mod/map. Installation instructions are provided below.

Questions? Comments? Start a thread on the OpenDayZ forums to send your feedback or ask questions: http://opendayz.net/forums/DZAI/.
Features

DZAI includes many features that can be user-configured:

    Static AI Spawns - AI spawn locations have been set up in cities, towns, and military bases for supported DayZ maps. AI are attracted to loot piles, so always be alert while looting.
    Dynamic AI Spawns - AI spawn locations are also randomly created around the map. AI can appear anywhere, anytime.
    AI helicopter patrols - AI helicopters patrol randomly around the map. Tip: Players on foot have the best chance of avoiding detection, but players in vehicles are much more noticeable to AI.
    AI land vehicle patrols - AI vehicle patrols randomly travel between cities and towns using roads. Be on the lookout for vehicles that decide to go off road.
	Custom-definable infantry and vehicle AI patrols - Populate your AI bases with custom spawns and vehicle reinforcements.
	AI can use any lootable weapon - DZAI can read DayZ's loot tables to build a list of AI-usable weapons. Beware, AI with rarer weapons will be more dangerous. (Users may also choose to set up their own AI loadouts).
    AI health system - AI units can take as much damage as players, and can also be knocked unconscious by heavy damage. Headshots are more likely to knock out an AI unit and for longer durations.

Basic Installation Guide (with PBO Manager (Recommended)):

NEW: A visual installation guide for DZAI is available here: http://opendayz.net/threads/dzai-visual-installation-guide.18447/

Note: To avoid pbo corruption, do not use the "Pack into dayz_server.pbo" right-click option. Modify files only using PBO Manager's graphical interface.

    1. Unpack your dayz_server.pbo. Right click dayz_server.pbo, select "PBO Manager", click on "Extract to dayz_server\"
	2. Inside the unpacked dayz_server folder, locate server_monitor.sqf in dayz_server\system\. Edit server_monitor.sqf with a text editor.
	3. Inside server_monitor.sqf, search for the line that says:

			allowConnection = true;

		Above this line, add:

			[] call compile preprocessFileLineNumbers "\z\addons\dayz_server\DZAI\init\dzai_initserver.sqf";
			
	4. Right click the DZAI folder inside the download package and click "Copy".
	5. Double-click your dayz_server.pbo to open the PBO Manager GUI. Inside the GUI, right-click on "dayz_server.pbo" and click "Paste". In the GUI, you should see "DZAI" in the list below "dayz_server.pbo".
	6. Optionally, you may edit DZAI's settings in DZAI\init\dzai_config.sqf. 
	7. If you have edited dzai_config.sqf in Step 6, place the modified file back inside dayz_server.pbo using the PBO Manager GUI.

Basic Installation Guide (with cpbo):

    1. Unpack your dayz_server.pbo. Right click dayz_server.pbo and click "Extract".
	2. Copy the downloaded DZAI folder inside your unpacked dayz_server folder.
	3. Inside the unpacked dayz_server folder, locate server_monitor.sqf in dayz_server\system\. Edit server_monitor.sqf with a text editor.
	4. Inside server_monitor.sqf, search for the line that says:

			allowConnection = true;

		Above this line, add:

			[] call compile preprocessFileLineNumbers "\z\addons\dayz_server\DZAI\init\dzai_initserver.sqf";
		
	5. Optionally, you may edit DZAI's settings in DZAI\init\dzai_config.sqf
	6. Repack your dayz_server.pbo by right-clicking the unpacked folder, then click on "create PBO". If prompted to overwrite, click "Yes".


Contribute

If you enjoy using DZAI and would like to show your support with a small donation, thank you. Contributions are always appreciated but never required.

http://imraising.com/dzai/
DZAI (Final Version) - AI Addon for DayZ
============


Introduction
============

DZAI is designed to be a simple, configurable, easy-to-install AI package. This AI package is designed to work out of the box with any supported DayZ mod/map. Installation instructions are provided below.

Questions? Comments? Start a thread on the OpenDayZ forums to send your feedback or ask questions: http://opendayz.net/forums/DZAI/.

Features
============

- <b>Static AI Spawns</b> - AI spawn locations have been set up in cities, towns, and military bases for supported DayZ maps. AI are attracted to loot piles, so always be alert while looting.
- <b>Dynamic AI Spawns</b> - AI spawn locations are also randomly created around the map. AI can appear anywhere, anytime.
- <b>AI helicopter patrols</b> - AI helicopters patrol randomly around the map. Tip: Players on foot have the best chance of avoiding detection, but players in vehicles are much more noticeable to AI.
- <b>AI can use any lootable weapon</b> - DZAI builds a list of AI-usable weapons using DayZ's loot tables. Beware, AI with rarer weapons will be more dangerous. (Users may also choose to set up their own AI loadouts).
- <b>AI health system</b> - AI units can take as much damage as players, and can also be knocked unconscious by heavy damage. Headshots are more likely to knock out an AI unit and for longer durations.


Basic Installation Guide (with cpbo):
============

1. Unpack your dayz_server.pbo. Right click dayz_server.pbo and click "Extract".
2. Copy the downloaded DZAI folder inside your unpacked dayz_server folder.
3. Inside the unpacked dayz_server folder, locate server_monitor.sqf in dayz_server\system\. Edit server_monitor.sqf with a text editor.
4. Inside server_monitor.sqf, search for the line that says:

		allowConnection = true;

	Change the line to this:

		call compile preprocessFileLineNumbers "\z\addons\dayz_server\DZAI\init\dzai_initserver.sqf";
		allowConnection = true;
	
5. Optionally, you may edit DZAI's settings in DZAI\init\dzai_config.sqf
6. Repack your dayz_server.pbo by right-clicking the unpacked folder, then click on "create PBO". If prompted to overwrite, click "Yes".


Basic Installation Guide (with PBO Manager):
----------------------------------------------------

**NEW**: A visual installation guide for DZAI is available here: http://opendayz.net/threads/dzai-visual-installation-guide.18447/

**Note**: To avoid pbo corruption, do not use the "Pack into dayz_server.pbo" right-click option. Modify files only using PBO Manager's graphical interface.

1. Unpack your dayz_server.pbo. Right click dayz_server.pbo, select "PBO Manager", click on "Extract to dayz_server\"
2. Inside the unpacked dayz_server folder, locate server_monitor.sqf in dayz_server\system\. Edit server_monitor.sqf with a text editor.
3. Inside server_monitor.sqf, search for the line that says:

		allowConnection = true;

	Change the line to this:

		call compile preprocessFileLineNumbers "\z\addons\dayz_server\DZAI\init\dzai_initserver.sqf";
		allowConnection = true;
		
4. Right click the DZAI folder inside the download package and click "Copy".
5. Double-click your dayz_server.pbo to open the PBO Manager GUI. Inside the GUI, right-click on "dayz_server.pbo" and click "Paste". In the GUI, you should see "DZAI" in the list below "dayz_server.pbo".
6. Optionally, you may edit DZAI's settings in DZAI\init\dzai_config.sqf
7. Copy all modified files back into their original locations inside dayz_server.pbo using the PBO Manager GUI.

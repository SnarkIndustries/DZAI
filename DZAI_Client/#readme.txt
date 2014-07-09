DZAI Client Optional Addon
----------------------------

1. How to install
------------------

	The DZAI client optional addon is used by DZAI to run client-side commands. To install:

	1. Copy the DZAI_Client folder into your mission pbo file.
	2. Edit your mission file's init.sqf and insert this near the bottom OR inside of any "if (!isDedicated) then { " bracket. (this file will not be run on the server).

		_nul = [] execVM "DZAI_Client\dzai_initclient.sqf";
		
	3. Repack your mission pbo file.
	4. In your dzai_config.sqf, ensure DZAI_useRadioAddon is set to "true";

2. How to configure
------------------

Add these parameters inside the empty array [] to the left of execVM.

"clientradio" - Enable client-side radio messages. DZAI_clientRadio and DZAI_radioMsgs needs to be enabled in your dzai_config.sqf.
"zombieenemy" - Enable AI-to-zombie hostility. DZAI_zombieEnemy needs to be enabled in your dzai_config.sqf.

Example: 

	_nul = ["clientradio","zombieenemy"] execVM "DZAI_Client\dzai_initclient.sqf";
	
	This will enable both client-side radio and AI-to-zombie hostility.


3. What it's used for
------------------

	- Display radio text messages to players if they have a Radio in their inventory
	- AI-to Zombie hostility

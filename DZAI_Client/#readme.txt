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


2. What it's used for
------------------

	At this time, the DZAI client addon is only used to display radio text messages to players if they have a Radio in their inventory, and if the DZAI_radioMsgs option is enabled.

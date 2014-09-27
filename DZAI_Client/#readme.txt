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

Edit dzai_client_config.sqf to change settings and enable/disable features.

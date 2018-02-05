Installation Instructions for DZAI for Epoch 1.0.6+
Last Updated: 6:17 AM 3/25/2017

What you need:
----------------------------------------------------
- PBO Manager installed.*
- A text editor (Notepad++ is recommended).
- Access to your dayz_server.pbo.
- A downloaded copy of DZAI

* PBO Manager can be downloaded here: http://www.armaholic.com/page.php?id=16369

Basic Installation Guide (with PBO Manager):
----------------------------------------------------

1. Locate server_monitor.sqf in dayz_server\system\. Edit server_monitor.sqf with a text editor.
2. Inside server_monitor.sqf, search for the line that says:

		allowConnection = true;

	Add this line above it (if you have DZMS or WAI, add it above their lines):

		[] call compile preprocessFileLineNumbers "\z\addons\dayz_server\DZAI\init\dzai_initserver.sqf";
		
3. Drop the DZAI folder from the downloaded file into your server.pbo.
4. Edit DZAI\init\dzai_config.sqf as to your needs.

That's it for the server part, now go ahead with the mission (client) part.

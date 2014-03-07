PBO Prefix Files
--------------------

If repacking the dayz_server.pbo causes players to become stuck at the "Waiting for authentication" screen, do the following:

1. Check your server's arma2oaserver.RPT.

2. Scroll all the way to the end of the file and look for these two lines:

	Warning Message: Script z\addons\dayz_server\init\server_functions.sqf not found
	Warning Message: Script z\addons\dayz_server\system\server_monitor.sqf not found
	
	If you see these two lines, then continue on to step 3. If you don't see these lines, check to see if you've made any errors in editing the required files.
	
3. Copy the 3 files inside this folder ($PBOPREFIX$, $PREFIX$, PboPrefix.txt) inside your dayz_server folder and repack into dayz_server.pbo. 
	I recommend users use "cpbo" for unpacking/repacking their pbo files. Link: http://www.armaholic.com/page.php?id=411

4. Start your DayZ server.

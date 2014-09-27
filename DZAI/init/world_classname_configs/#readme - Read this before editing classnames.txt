Explanation for world_classname_configs directory
-----------------------------------

If DZAI_modAutoDetect is enabled in dzai_config.sqf, DZAI will automatically detect if one of the following DayZ mods is active and load additional classnames for skins, weapons, and/or other items:

- DayZ Epoch (dayz_epoch.sqf)
- DayZ Hunting Grounds (dayz_huntinggrounds.sqf)
- DayZ Overwatch (dayz_overwatch.sqf)
- DayZ Unleashed (dayz_unleashed.sqf)

Tips:
1. If none of the above mods are detected, one of the .sqf files in the default_classnames folder will be read instead, depending on which map is being used.
2. If combinations of the above mods are loaded, the last mod in the load order will determine which mod is detected by DZAI.
3. The classnames specified in dzai_config.sqf are always loaded first and may be modified or overwritten later if DZAI_modAutoDetect is enabled.
4. If fully manual control over classname configuration is wanted, set DZAI_modAutoDetect to false in dzai_config.sqf. 
	With DZAI_modAutoDetect set to false, dzai_config.sqf will be the only source of classname information used by DZAI.

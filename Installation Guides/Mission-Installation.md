Installation Instructions for DZAI for Epoch 1.0.7+
Last Updated: 9:00 PM 11/16/2021

What you need:
----------------------------------------------------
- PBO Manager installed
- A text editor (Notepad++ is recommended)
- Access to your mission .pbo
- A downloaded copy of DZAI

** PBO Manager can be downloaded here: https://native-network.net/downloads/file/6-pbo-manager-v1-4-beta/

Basic Installation Guide:
----------------------------------------------------
1. Drop the downloaded DZAI_Client folder from the downloaded package inside your mission\dayz_code.
2. Edit your mission init.sqf with a text editor. Find this line:

    ```sqf
    execFSM "\z\addons\dayz_code\system\player_monitor.fsm";
    ```
   
and add this line directly below it:
```sqf
    call compile preprocessFileLineNumbers "dayz_code\DZAI_Client\dzai_initclient.sqf";
```

3. Now you can edit DZAI_Client\dzai_client_config.sqf to your liking.

That's all for the client part.

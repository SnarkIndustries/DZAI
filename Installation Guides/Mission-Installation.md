Installation Instructions for DZAI for Epoch 1.0.6+
Last Updated: 6:17 AM 3/25/2017

What you need:
----------------------------------------------------
- cpbo* or PBO Manager**.
- A text editor (Notepad++ is recommended).
- Access to your mission .pbo.
- A downloaded copy of DZAI

* cpbo can be downloaded as part of the Arma Tools package here: http://www.armaholic.com/page.php?id=411
** PBO Manager can be downloaded here: http://www.armaholic.com/page.php?id=16369


Basic Installation Guide:
----------------------------------------------------
1. Drop the downloaded DZAI_Client folder from the downloaded package inside your mission\dayz_code.
2. Edit your mission init.sqf with a text editor. Find this line:

    ```sqf
    execFSM "\z\addons\dayz_code\system\player_monitor.fsm";
    ```
   
and add this line directly below it:
```sqf
    [] call compile preprocessFileLineNumbers "dayz_code\DZAI_Client\dzai_initclient.sqf";
```

3. Now you can edit DZAI_Client\dzai_client_config.sqf to your liking.

That's all for the client part.

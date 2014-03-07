activateAddons [
];

activateAddons [];
initAmbientLife;

_this = createCenter west;
_center_0 = _this;

_group_0 = createGroup _center_0;

_unit_5 = objNull;
if (true) then
{
  _this = _group_0 createUnit ["Bandit1_DZ", [13409.133, 2823.1218, 2.9492393], [], 0, "CAN_COLLIDE"];
  _unit_5 = _this;
  _this setUnitAbility 0.60000002;
  if (true) then {_group_0 selectLeader _this;};
  if (true) then {selectPlayer _this;};
};

_this = createTrigger ["EmptyDetector", [1876.1113, 2282.8721]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Kamenka";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,175,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_0 = _this;

_this = createTrigger ["EmptyDetector", [3635.5938, 2394.6064]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Komarovo";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_2 = _this;

_this = createTrigger ["EmptyDetector", [4481.4292, 2421.9043]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Balota";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_4 = _this;

_this = createTrigger ["EmptyDetector", [4774.0439, 2507.7603]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Balota AF (Markers)";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [1,1,175,thisTrigger,['Balota1','Balota2','Balota3','Balota4','Balota5'],1] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_6 = _this;

_this = createTrigger ["EmptyDetector", [6970.9785, 2640.334]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Cherno3";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [1,1,200,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_10 = _this;

_this = createTrigger ["EmptyDetector", [6566.5137, 2412.969]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Cherno1";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [1,2,200,thisTrigger,[],1] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_12 = _this;

_this = createTrigger ["EmptyDetector", [10186.388, 1936.0364, 3.4404879]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Elektro1";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [1,1,175,thisTrigger,[],0,2] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_16 = _this;

_this = createTrigger ["EmptyDetector", [10476.077, 2412.2297, 9.6632004]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Elektro2";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [1,2,200,thisTrigger,[],1] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_18 = _this;

_this = createTrigger ["EmptyDetector", [9164.4277, 3832.1824]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Pusta";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_20 = _this;

_this = createTrigger ["EmptyDetector", [12063.045, 3623.7976, 9.5367432e-006]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Kamyshovo";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,175,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_24 = _this;

_this = createTrigger ["EmptyDetector", [12855.01, 4457.4199, 0]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Tulga";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_26 = _this;

_this = createTrigger ["EmptyDetector", [11299.008, 5460.605, 2.91008]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Msta";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_28 = _this;

_this = createTrigger ["EmptyDetector", [13332.188, 6258.8921]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Solnichniy";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,2,200,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_30 = _this;

_this = createTrigger ["EmptyDetector", [13074.077, 6975.2202]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Solnichniy Factory";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[]] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_32 = _this;

_this = createTrigger ["EmptyDetector", [12161.262, 7288.5391, -0.00061035156]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Orlovets";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[]] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_34 = _this;

_this = createTrigger ["EmptyDetector", [12877.6, 8081.5957]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Nizhnoye";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[]] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_36 = _this;

_this = createTrigger ["EmptyDetector", [11938.791, 9118.6982]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Berezino1";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [2,1,200,thisTrigger,[],1] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_38 = _this;

_this = createTrigger ["EmptyDetector", [12734.678, 9571.3135, -2.6702881e-005]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Berezino2";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,2,200,thisTrigger,[]] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_42 = _this;

_this = createTrigger ["EmptyDetector", [12870.976, 10060.382, 11.137758]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Berezeno3";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [2,1,200,thisTrigger,[]] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_46 = _this;

_this = createTrigger ["EmptyDetector", [12307.611, 10841.742]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Khelm";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[]] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_50 = _this;

_this = createTrigger ["EmptyDetector", [12055.516, 12620.125]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "NEAF";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [2,2,200,thisTrigger,['NEAF1','NEAF2','NEAF3','NEAF4','NEAF5'],2] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_56 = _this;

_this = createTrigger ["EmptyDetector", [11130.03, 12335.65, 9.50177]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Krasnostav";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,2,200,thisTrigger,[],2] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_58 = _this;

_this = createTrigger ["EmptyDetector", [8710.1924, 11791.018, -3.0517578e-005]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Gvozdno";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,2,225,thisTrigger,[],2] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_62 = _this;

_this = createTrigger ["EmptyDetector", [6003.6455, 10296.365]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Grishino";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,3,225,thisTrigger,[],2] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_64 = _this;

_this = createTrigger ["EmptyDetector", [4673.8091, 10449.009]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "NWAF1";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [3,0,175,thisTrigger,[],3] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_66 = _this;

_this = createTrigger ["EmptyDetector", [4760.895, 10160.055, 0.080749512]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "NWAF2";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [3,0,175,thisTrigger,[],3] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_68 = _this;

_this = createTrigger ["EmptyDetector", [4607.541, 9625.1084]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "NWAF3";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [3,0,200,thisTrigger,[],3] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_70 = _this;

_this = createTrigger ["EmptyDetector", [2743.1543, 9997.4131]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Lopatino";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,2,200,thisTrigger,[],2] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_72 = _this;

_this = createTrigger ["EmptyDetector", [3826.7798, 8926.0244, 8.6271362]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Vybor";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [1,2,200,thisTrigger,[],2] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_74 = _this;

_this = createTrigger ["EmptyDetector", [5366.3472, 8591.8545, 0]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Kabanino";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,2,200,thisTrigger,[],2] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_76 = _this;

_this = createTrigger ["EmptyDetector", [6179.4053, 7786.5435]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Stary Sobor";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [2,0,225,thisTrigger,[],2,2] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_78 = _this;

_this = createTrigger ["EmptyDetector", [7038.3643, 7669.3857]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Novy Sobor";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [2,0,225,thisTrigger,[],2] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_80 = _this;

_this = createTrigger ["EmptyDetector", [8457.4629, 6688.627, 4.7903137]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Gulglovo";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[]] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_82 = _this;

_this = createTrigger ["EmptyDetector", [6543.8091, 6106.0352]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Vyshnoye";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[]] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_84 = _this;

_this = createTrigger ["EmptyDetector", [7577.5776, 5111.8057]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Mogilevka";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[]] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_86 = _this;

_this = createTrigger ["EmptyDetector", [10121.785, 5479.5034, 0]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Staroye";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_88 = _this;

_this = createTrigger ["EmptyDetector", [4464.2275, 4616.3687]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Kozlovka";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_90 = _this;

_this = createTrigger ["EmptyDetector", [5848.8809, 4707.165]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Nadezhdino";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,2,200,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_92 = _this;

_this = createTrigger ["EmptyDetector", [4930.3384, 5613.7847, 0]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Pulkovo";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_94 = _this;

_this = createTrigger ["EmptyDetector", [4486.5034, 6420.5313, 0]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Pogorevka";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,2,200,thisTrigger,[]] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_96 = _this;

_this = createTrigger ["EmptyDetector", [4781.4141, 6797.9297]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Rogovo";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[]] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_98 = _this;

_this = createTrigger ["EmptyDetector", [3066.6545, 7942.9028, 0]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Pustoshka";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [1,2,200,thisTrigger,[]] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_100 = _this;

_this = createTrigger ["EmptyDetector", [1986.5758, 7351.6929, 0]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Myshkino";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,2,200,thisTrigger,[]] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_102 = _this;

_this = createTrigger ["EmptyDetector", [2529.2295, 6347.8228]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Sosnovka";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[]] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_104 = _this;

_this = createTrigger ["EmptyDetector", [2744.5173, 5288.1021]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Zelenogorsk";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [1,1,225,thisTrigger,[],1,2] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_108 = _this;

_this = createTrigger ["EmptyDetector", [1699.3744, 3839.5432]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Pavlovo";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_110 = _this;

_this = createTrigger ["EmptyDetector", [3336.4529, 3921.7053, 0]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Bor";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_112 = _this;

_this = createTrigger ["EmptyDetector", [3411.4346, 4930.8711, 0]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Drozhino";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,150,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_114 = _this;

_this = createTrigger ["EmptyDetector", [3734.5662, 5990.0493, 0]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Green Mountain";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,3,200,thisTrigger,[],2] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_116 = _this;

_this = createTrigger ["EmptyDetector", [9572.3516, 8847.8584]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Gorka";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,2,225,thisTrigger,[],2] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_118 = _this;

_this = createTrigger ["EmptyDetector", [10420.348, 9844.5205, 0]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Dubrovka";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,2,225,thisTrigger,[]] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_120 = _this;

_this = createTrigger ["EmptyDetector", [10007.653, 10376.338]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Dubrovka NW";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[]] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_122 = _this;

_this = createTrigger ["EmptyDetector", [10709.08, 8055.9419, 4.4793243]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Polana";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [1,2,200,thisTrigger,[]] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_126 = _this;

_this = createTrigger ["EmptyDetector", [11229.258, 6583.4165]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Dolina";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_128 = _this;

_this = createTrigger ["EmptyDetector", [9654.4688, 6562.8745]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Shakhovka";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_130 = _this;

_this = createTrigger ["EmptyDetector", [13661.255, 2914.5103]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Skalisty Island (Markers)";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,175,thisTrigger,['Skalisty1','Skalisty2','Skalisty3'],1] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_132 = _this;

_this = createTrigger ["EmptyDetector", [11250.809, 4274.082]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Rog";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [2,2,175,thisTrigger,['CastleRog','CastleRog2','Rog3','Rog4'],2] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_134 = _this;

_this = createTrigger ["EmptyDetector", [13256.356, 5432.5425, 4.7683716e-006]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Three Valleys";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_136 = _this;

_this = createTrigger ["EmptyDetector", [6894.6455, 11438.785]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Devil's Castle";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [2,2,200,thisTrigger,['DevilsCastle','DevilsCastle2','Devils3','Devils4'],2] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_138 = _this;

_this = createTrigger ["EmptyDetector", [6551.4741, 5595.6704]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Zub";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [2,2,175,thisTrigger,['CastleZub','CastleZub2','Zub3','Zub4'],2] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_140 = _this;

_this = createTrigger ["EmptyDetector", [11458.502, 7483.2754, 12.369965]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Orlovets Factory";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[]] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_142 = _this;

_this = createTrigger ["EmptyDetector", [12215.833, 6270.9868, 3.8146973e-006]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Dolina-Solnichniy";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_144 = _this;

_this = createTrigger ["EmptyDetector", [6490.1133, 2778.8921, -7.6293945e-006]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Cherno2";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [1,1,200,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_146 = _this;

_this = createTrigger ["EmptyDetector", [10456.71, 2247.2095]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Elektro3";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [1,2,200,thisTrigger,[],0] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_156 = _this;

_this = createMarker ["Cherno4", [7288.8408, 2305.3875, 4.8160553e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_18 = _this;

_this = createTrigger ["EmptyDetector", [6677.4395, 2585.647]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Cherno4";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [2,1,200,thisTrigger,['Cherno1','Cherno2','Cherno3','Cherno4','Cherno5'],1] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_160 = _this;

_this = createMarker ["NEAF1", [11958.352, 13143.257, 3.0517578e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_27 = _this;

_this = createMarker ["NEAF2", [12212.049, 12482.955]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_28 = _this;

_this = createMarker ["NEAF3", [11816.073, 12926.985, 3.0517578e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_29 = _this;

_this = createMarker ["NEAF4", [11746.358, 12610.153, -3.0517578e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_30 = _this;

_this = createMarker ["NEAF5", [12483.098, 12883.227, -4.5776367e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_31 = _this;

_this = createMarker ["Skalisty1", [14160.69, 2707.7178, -4.7683716e-007]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_51 = _this;

_this = createMarker ["Skalisty2", [13310.174, 2752.4612, 7.4863434e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_53 = _this;

_this = createMarker ["Skalisty3", [13797.646, 3064.9883, 0.00012779236]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_54 = _this;

_this = createMarker ["Balota1", [4592.4634, 2724.5557, 4.7683716e-006]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_64 = _this;

_this = createMarker ["Balota2", [4794.811, 2735.4512, 1.7166138e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_65 = _this;

_this = createMarker ["Balota3", [4962.8208, 2648.8101, -9.5367432e-007]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_66 = _this;

_this = createMarker ["Balota4", [4524.6079, 2708.7559, -1.9073486e-006]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_67 = _this;

_this = createMarker ["Balota5", [4869.4707, 2702.0361]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_68 = _this;

_this = createTrigger ["EmptyDetector", [12248.675, 9573.2344, 9.5367432e-007]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Berezino4";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [2,1,200,thisTrigger,[],1] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_177 = _this;

_this = createMarker ["CastleRog", [11280.589, 4297.4292, -0.00012207031]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_79 = _this;

_this = createMarker ["DevilsCastle", [6886.5234, 11494.024, -3.0517578e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_80 = _this;

_this = createMarker ["CastleZub", [6516.1924, 5603.2427, -3.0517578e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_81 = _this;

_this = createMarker ["CastleZub2", [6477.1846, 5558.3892, 6.1035156e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_82 = _this;

_this = createMarker ["DevilsCastle2", [7069.1392, 11639.588, -9.1552734e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_84 = _this;

_this = createMarker ["CastleRog2", [11118.082, 4084.0393, 6.1035156e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_85 = _this;

_this = createTrigger ["EmptyDetector", [4763.522, 10760.788, 0]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "NWAF5 (Markers)";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [2,1,200,thisTrigger,['NWAF5_1','NWAF5_2','NWAF5_3','NWAF5_4'],2] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_179 = _this;

_this = createMarker ["NWAF5_1", [4576.5781, 10877.494, 9.1552734e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_86 = _this;

_this = createMarker ["NWAF5_2", [4848.9712, 10553.556, 0]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_87 = _this;

_this = createMarker ["NWAF5_3", [4629.0986, 10975.196, 0.00012207031]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_88 = _this;

_this = createMarker ["NWAF5_4", [4895.8159, 10448.596, 9.1552734e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_90 = _this;

_this = createTrigger ["EmptyDetector", [4103.6729, 10876.167]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "NWAF6 (Markers)";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [2,1,200,thisTrigger,['NWAF6_1','NWAF6_2','NWAF6_3','NWAF6_4'],2] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_182 = _this;

_this = createMarker ["NWAF6_1", [3966.0071, 10825.011, -3.0517578e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_91 = _this;

_this = createMarker ["NWAF6_2", [3983.3364, 10706.798, -6.1035156e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_92 = _this;

_this = createMarker ["NWAF6_3", [3860.4697, 10906.981, -9.1552734e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_93 = _this;

_this = createMarker ["NWAF6_4", [4042.3828, 10907.524, -9.1552734e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_94 = _this;

_this = createMarker ["NWAF7_1", [4044.9353, 10609.702]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_95 = _this;

_this = createMarker ["NWAF7_2", [4279.9717, 10233.461, 3.0517578e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_96 = _this;

_this = createMarker ["NWAF7_3", [4026.0771, 10301.227, 3.0517578e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_97 = _this;

_this = createMarker ["NWAF7_4", [4246.4731, 10168.34, 0]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_98 = _this;

_this = createTrigger ["EmptyDetector", [5222.3984, 9780.6406, 0]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "NWAF4 (Markers)";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [2,1,200,thisTrigger,['NWAF4_1','NWAF4_2','NWAF4_3','NWAF4_4'],2] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_188 = _this;

_this = createMarker ["NWAF4_1", [5123.7661, 9896.9561, 0]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_99 = _this;

_this = createMarker ["NWAF4_2", [5230.0479, 9855.4219, 3.0517578e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_100 = _this;

_this = createMarker ["NWAF4_3", [5218.3945, 9664.8857, 3.0517578e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_101 = _this;

_this = createMarker ["NWAF4_4", [5305.8325, 9810.5674, 0.00024414063]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_102 = _this;

_this = createTrigger ["EmptyDetector", [4147.1416, 10313.281, 0]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "NWAF7 (Markers)";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [2,1,200,thisTrigger,['NWAF7_1','NWAF7_2','NWAF7_3','NWAF7_4'],2] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_195 = _this;

_this = createMarker ["Rog3", [11318.306, 4413.0542, 0.00088500977]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_103 = _this;

_this = createMarker ["Rog4", [11104.321, 4311.7319, -0.00015258789]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_104 = _this;

_this = createMarker ["Devils3", [6985.4487, 11838.063, 3.0517578e-005]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_109 = _this;

_this = createMarker ["Devils4", [6789.7358, 11246.682, -0.00012207031]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_111 = _this;

_this = createMarker ["Zub3", [6586.2847, 5411.603, 0]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_112 = _this;

_this = createMarker ["Zub4", [6470.5083, 5692.708, -0.00012207031]];
_this setMarkerType "Empty";
_this setMarkerBrush "Solid";
_marker_113 = _this;

_this = createTrigger ["EmptyDetector", [13365.159, 12852.25]];
_this setTriggerArea [600, 600, 0, false];
_this setTriggerActivation ["ANY", "PRESENT", true];
_this setTriggerTimeout [10, 15, 20, true];
_this setTriggerText "Olsha";
_this setTriggerStatements ["{isPlayer _x} count thisList > 0;", "0 = [0,1,200,thisTrigger,[]] call fnc_spawnBandits;", "0 = [thisTrigger] spawn fnc_despawnBandits;"];
_trigger_197 = _this;

processInitCommands;
runInitScript;
finishMissionInit;

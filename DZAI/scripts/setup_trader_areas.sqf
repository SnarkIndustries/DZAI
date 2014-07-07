/*
	For DayZ Epoch only - Spawns blacklist locations at trader areas to prevent DZAI from spawning dynamic AI.
*/

_worldName = (toLower worldName);
_trader_markers = call {
	if (_worldName == "chernarus") exitWith {["Tradercitystary","wholesaleSouth","boatTraderEast","BoatDealerSouth","AirVehicles","BanditDen","Klen","BoatDealerEast","TradercityBash","HeroTrader"]};
	if (_worldName == "napf") exitWith {["NeutralTraderCity","FriendlyTraderCity","HeroVendor","UnarmedAirVehicles","West Wholesaler","NorthWholesaler","NorthBoatVendor","BanditVendor","SouthBoatVendor","NeutralTraderCIty2"]};
	if (_worldName == "sauerland") exitWith {["NeutralTraderCity","FriendlyTraderCity","HeroVendor","UnarmedAirVehicles","SouthWholesaler","NorthWholesaler","BanditVendor","NeutralTraderCIty2"]};
	if (_worldName == "tavi") exitWith {["TraderCityLyepestok","TraderCitySabina","TraderCityBilgrad","TraderCityBranibor","BanditVendor","HeroVendor","AircraftDealer","AircraftDealer2","Misc.Vendor","Misc.Vendor2","BoatDealer","BoatDealer2","BoatDealer3","BoatDealer4","Wholesaler","Wholesaler2"]};
	if (_worldName == "namalsk") exitWith {["GerneralPartsSupplies","WholesalerNorth","Doctor","HighEndWeaponsAmmo","HeroVendor","VehicleFriendly","NeutralVendors","WholesalerSouth","LowEndWeaponsAmmo","BoatVendor","Bandit Trader","PlaneVendor"]};
	if (_worldName == "panthera2") exitWith {["AirVehiclesF","WholesalerWest","HeroVehicles","NeutralAirVehicles","Boats","NeutralTraders","NeutralTraderCity2","WholesaleSouth","PlanicaTraders","IslandVehiclePartsVendors"]};
	if (_worldName == "smd_sahrani_a2") exitWith {["Tradercitycorazol","wholesaleSouth","boatTraderEast","BoatDealerSouth","AirVehicles","BanditDen","Ixel","BoatDealerEast","TradercityBag","HeroTrader"]};
	if (_worldName == "sara") exitWith {["Tradercitycorazol","wholesaleSouth","boatTraderEast","BoatDealerSouth","AirVehicles","BanditDen","Ixel","BoatDealerEast","TradercityBag","HeroTrader"]};
	if (_worldName == "fdf_isle1_a") exitWith {["wholesaleSouth","boatTraderEast","BoatDealerSouth","AirVehicles","BanditDen","Jesco","TradercityBash","HeroTrader"]};
	if (_worldName == "caribou") exitWith {["boatTraderEast","BoatDealerSouth","AirVehicles","BanditDen","NorthNeutralVendors","SouthNeutralVendors","HeroTrader","BlackMarket","SouthWestWholesale"]};
	if (_worldName == "lingor") exitWith {["RaceTrack","RepairGuy","PlaneVendor","Wholesale","HighWeapons/ammo","Parts","Choppers","lowEndCars","LowEndWeapons","HighEndCars","MedicalandBags","Wholesaler","BagsNFood","Wholesalers","DirtTrackVendor","OffRoad4x4","BoatVendor","BoatVendor1","BoatVendor2","BagVendor1","BagVendor2","Doctor2","BanditTrader","HeroTrader"]};
	if (_worldName == "dingor") exitWith {["RaceTrack","RepairGuy","PlaneVendor","Wholesale","HighWeapons/ammo","Parts","Choppers","lowEndCars","LowEndWeapons","HighEndCars","MedicalandBags","Wholesaler","BagsNFood","Wholesalers","DirtTrackVendor","OffRoad4x4","BoatVendor","BoatVendor1","BoatVendor2","BagVendor1","BagVendor2","Doctor2","BanditTrader","HeroTrader"]};
	if (_worldName == "takistan") exitWith {["tradercitykush","Trader_City_Nur","Trader_City_Garm","Wholesaler","Wholesaler_1","Airplane Dealer","BanditTrader","BlackMarketVendor"]};
	if (_worldName == "fapovo") exitWith {["BanditTrader","AirVehicleUnarmed","TraderCity1","TraderCity2","Wholesaler","BanditVendor","HeroVendor","BoatVendor"]};
	if (_worldName == "zargabad") exitWith {["HeroCamp","BanditCamp"]};
	if (_worldName == "isladuala") exitWith {["Trader City Camara","st_3","st_4","st_3_1","st_3_1_1","st_3_1_1_1","st_3_2","st_3_2_1","st_3_2_2","st_3_2_3","st_3_2_3_1"]};
	if (_worldName == "cmr_ovaron") exitWith {["AirVehiclesF","WholesalerWest","HeroVehicles","NeutralAirVehicles","Boats","NeutralTraders","NeutralTraderCity2","WholesaleSouth","PlanicaTraders","IslandVehiclePartsVendors"]};
	if (_worldName == "shapur_baf") exitWith {["Safe Zone","test"]};
	[]
};

_scanTargets = if (!isNil "serverTraders") then {serverTraders} else {["CAManBase"]};

for "_i" from 0 to ((count _trader_markers) - 1) do {
	_traderPos = (getMarkerPos (_trader_markers select _i));
	if (((_traderPos select 0) != 0) && {((_traderPos select 1) != 0)}) then {
		if (DZAI_dynAISpawns) then {_blacklist = createLocation ["Strategic",_traderPos,250,250];};
		_nearbyUnits = _traderPos nearEntities [_scanTargets,250];
		{
			if ((local _x) && {!simulationEnabled _x}) then {
				_x setCaptive true;
			};
		} count _nearbyUnits;
	};
	uiSleep 0.01;
};

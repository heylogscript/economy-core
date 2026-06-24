local UpgradeDefs = {
	{
		Id = "lemondade_double",
		Name = "Double Lemonade",
		Description = "Lemonade Stands produce 2x more.",
		Cost = 500,
		TargetGenerator = "lemonade_stand",
		Multiplier = 2,
	},
	{
		Id = "faster_presses",
		Name = "Faster Presses",
		Description = "Newspaper Routes produce 2x more.",
		Cost = 4000,
		TargetGenerator = "newspaper_route",
		Multiplier = 2,
	},
	{
		Id = "soap_supreme",
		Name = "Soap Supreme",
		Description = "Car Washes produce 2x more.",
		Cost = 50000,
		TargetGenerator = "car_wash",
		Multiplier = 2,
	},
	{
		Id = "efficient_wash",
		Name = "Efficient Wash",
		Description = "Laundromats produce 3x more.",
		Cost = 600000,
		TargetGenerator = "laundromat",
		Multiplier = 3,
	},
	{
		Id = "gourmet_menu",
		Name = "Gourmet Menu",
		Description = "Food Trucks produce 2x more.",
		Cost = 7000000,
		TargetGenerator = "food_truck",
		Multiplier = 2,
	},
	{
		Id = "token_boom",
		Name = "Token Boom",
		Description = "Arcades produce 3x more.",
		Cost = 80000000,
		TargetGenerator = "arcade",
		Multiplier = 3,
	},
	{
		Id = "pro_lanes",
		Name = "Pro Lanes",
		Description = "Bowling Alleys produce 2x more.",
		Cost = 300000000,
		TargetGenerator = "bowling_alley",
		Multiplier = 2,
	},
	{
		Id = "imax_upgrade",
		Name = "IMAX Upgrade",
		Description = "Cinemas produce 2x more.",
		Cost = 2000000000,
		TargetGenerator = "cinema",
		Multiplier = 2,
	},
	{
		Id = "business_license",
		Name = "Business License",
		Description = "All generators produce 1.5x more.",
		Cost = 999999999,
		TargetGenerator = "all",
		Multiplier = 1.5,
	},
}

local Map = {}
for _, upg in UpgradeDefs do
	Map[upg.Id] = upg
end
Map.List = UpgradeDefs

function Map.GetUpgrade(id)
	return Map[id]
end

return Map

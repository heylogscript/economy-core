local GeneratorDefs = {
	{
		Id = "lemonade_stand",
		Name = "Lemonade Stand",
		Description = "Sells lemonade on the sidewalk.",
		BaseRate = 1,
		BaseCost = 15,
		CostExponent = 1.15,
	},
	{
		Id = "newspaper_route",
		Name = "Newspaper Route",
		Description = "Delivering morning news.",
		BaseRate = 5,
		BaseCost = 100,
		CostExponent = 1.15,
	},
	{
		Id = "car_wash",
		Name = "Car Wash",
		Description = "A self-serve car wash bay.",
		BaseRate = 25,
		BaseCost = 1100,
		CostExponent = 1.15,
	},
	{
		Id = "laundromat",
		Name = "Laundromat",
		Description = "Coin-operated laundry.",
		BaseRate = 100,
		BaseCost = 12000,
		CostExponent = 1.15,
	},
	{
		Id = "food_truck",
		Name = "Food Truck",
		Description = "Tacos and burgers on wheels.",
		BaseRate = 500,
		BaseCost = 130000,
		CostExponent = 1.15,
	},
	{
		Id = "arcade",
		Name = "Arcade",
		Description = "A retro gaming arcade.",
		BaseRate = 2500,
		BaseCost = 1400000,
		CostExponent = 1.15,
	},
	{
		Id = "bowling_alley",
		Name = "Bowling Alley",
		Description = "Strikes and spares all day.",
		BaseRate = 12000,
		BaseCost = 20000000,
		CostExponent = 1.15,
	},
	{
		Id = "cinema",
		Name = "Cinema",
		Description = "A multiplex movie theater.",
		BaseRate = 60000,
		BaseCost = 330000000,
		CostExponent = 1.15,
	},
}

local Map = {}
for _, gen in GeneratorDefs do
	Map[gen.Id] = gen
end
Map.List = GeneratorDefs

function Map.GetGenerator(id)
	return Map[id]
end

function Map.GetCost(genId, owned)
	local gen = Map[genId]
	if not gen then return nil end
	return math.floor(gen.BaseCost * (gen.CostExponent ^ owned))
end

return Map

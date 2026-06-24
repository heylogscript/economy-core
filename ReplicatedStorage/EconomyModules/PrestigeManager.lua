local Config = require(script.Parent.Config)

local DataStoreService = game:GetService("DataStoreService")

local DS = nil
local function getDS()
	if not DS then
		DS = DataStoreService:GetDataStore(Config.DataStoreName)
	end
	return DS
end

local PrestigeManager = {}
local cachedGlobal = nil

local function loadGlobal()
	if cachedGlobal then return end
	local ok, data = pcall(function()
		return getDS():GetAsync("GlobalPrestigeData")
	end)
	if ok and data then
		cachedGlobal = data
	else
		cachedGlobal = { TotalPrestigeLevels = 0 }
	end
end

local function saveGlobal()
	pcall(function()
		getDS():SetAsync("GlobalPrestigeData", cachedGlobal)
	end)
end

function PrestigeManager.GetGlobalMultiplier()
	loadGlobal()
	return 1 + (cachedGlobal.TotalPrestigeLevels * Config.GlobalPrestigeMultiplierPerLevel)
end

function PrestigeManager.GetPrestigeCost(playerData)
	return math.floor(Config.BasePrestigeCost * (Config.PrestigeCostExponent ^ playerData.PrestigeLevel))
end

function PrestigeManager.CanPrestige(playerData)
	return playerData.Currency >= PrestigeManager.GetPrestigeCost(playerData)
end

function PrestigeManager.Prestige(playerData)
	if not PrestigeManager.CanPrestige(playerData) then
		return false
	end

	local cost = PrestigeManager.GetPrestigeCost(playerData)
	playerData.Currency = playerData.Currency - cost
	playerData.PrestigeLevel = playerData.PrestigeLevel + 1
	playerData.Generators = {}
	playerData.Upgrades = {}

	loadGlobal()
	cachedGlobal.TotalPrestigeLevels = cachedGlobal.TotalPrestigeLevels + 1
	saveGlobal()

	return true
end

return PrestigeManager

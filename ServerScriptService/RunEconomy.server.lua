local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage:WaitForChild("EconomyModules")

local Config = require(Modules.Config)
local SaveManager = require(Modules.SaveManager)
local Generators = require(Modules.Generators)
local Upgrades = require(Modules.Upgrades)
local PrestigeManager = require(Modules.PrestigeManager)

local Players = game:GetService("Players")

local REMOTE_FOLDER = Instance.new("Folder")
REMOTE_FOLDER.Name = "EconomyRemotes"
REMOTE_FOLDER.Parent = ReplicatedStorage

local remotes = {
	UpdateUI = Instance.new("RemoteEvent"),
	PurchaseGenerator = Instance.new("RemoteEvent"),
	PurchaseUpgrade = Instance.new("RemoteEvent"),
	Prestige = Instance.new("RemoteEvent"),
	RequestData = Instance.new("RemoteFunction"),
}
for name, inst in remotes do
	inst.Name = name
	inst.Parent = REMOTE_FOLDER
end

local playerDataMap = {}
local playerIncome = {}

local function calculateIncome(data)
	local base = 0
	for genId, qty in data.Generators do
		local gen = Generators.GetGenerator(genId)
		if gen and qty > 0 then
			local rate = gen.BaseRate * qty
			for upgId in data.Upgrades do
				local upg = Upgrades.GetUpgrade(upgId)
				if upg then
					if upg.TargetGenerator == genId or upg.TargetGenerator == "all" then
						rate = rate * upg.Multiplier
					end
				end
			end
			base = base + rate
		end
	end
	local prestigeMult = 1 + (data.PrestigeLevel * Config.PrestigeMultiplierPerLevel)
	local globalMult = PrestigeManager.GetGlobalMultiplier()
	return base * prestigeMult * globalMult
end

local function buildInfo(player, data)
	local income = calculateIncome(data)
	playerIncome[player] = income
	data.LastIncomeRate = income

	local info = {
		Currency = data.Currency,
		IncomePerSecond = income,
		Generators = data.Generators,
		Upgrades = data.Upgrades,
		PrestigeLevel = data.PrestigeLevel,
		GlobalMultiplier = PrestigeManager.GetGlobalMultiplier(),
		OfflineEarned = data.OfflineEarned,
		OfflineSecs = data.OfflineSecs,
		GeneratorCosts = {},
		PrestigeCost = PrestigeManager.GetPrestigeCost(data),
	}
	for _, gen in Generators.List do
		local owned = data.Generators[gen.Id] or 0
		info.GeneratorCosts[gen.Id] = Generators.GetCost(gen.Id, owned)
	end
	return info
end

local function pushUpdate(player, data)
	remotes.UpdateUI:FireClient(player, buildInfo(player, data))
end

local function savePlayerData(player, data)
	data.LastIncomeRate = calculateIncome(data)
	SaveManager.SavePlayerData(player.UserId, data)
end

----- Player Lifecycle -----

local function onPlayerAdded(player)
	local userId = player.UserId
	task.spawn(function()
		local data = SaveManager.LoadPlayerData(userId)
		if not data then
			player:Kick("Falha ao carregar dados. Reentre.")
			return
		end
		playerDataMap[player] = data
		pushUpdate(player, data)
	end)
end

local function onPlayerRemoving(player)
	local data = playerDataMap[player]
	if data then
		savePlayerData(player, data)
		SaveManager.ReleaseLock(player.UserId)
		playerDataMap[player] = nil
		playerIncome[player] = nil
	end
end

----- Remotes -----

remotes.RequestData.OnServerInvoke = function(player)
	local data = playerDataMap[player]
	if data then
		return buildInfo(player, data)
	end
	return nil
end

remotes.PurchaseGenerator.OnServerEvent:Connect(function(player, genId)
	local data = playerDataMap[player]
	if not data then return end

	local gen = Generators.GetGenerator(genId)
	if not gen then return end

	local owned = data.Generators[genId] or 0
	local cost = Generators.GetCost(genId, owned)
	if data.Currency < cost then return end

	data.Currency = data.Currency - cost
	data.Generators[genId] = owned + 1
	pushUpdate(player, data)
	savePlayerData(player, data)
end)

remotes.PurchaseUpgrade.OnServerEvent:Connect(function(player, upgId)
	local data = playerDataMap[player]
	if not data then return end

	local upg = Upgrades.GetUpgrade(upgId)
	if not upg then return end
	if data.Upgrades[upgId] then return end
	if data.Currency < upg.Cost then return end

	data.Currency = data.Currency - upg.Cost
	data.Upgrades[upgId] = true
	pushUpdate(player, data)
	savePlayerData(player, data)
end)

remotes.Prestige.OnServerEvent:Connect(function(player)
	local data = playerDataMap[player]
	if not data then return end

	local ok = PrestigeManager.Prestige(data)
	if ok then
		pushUpdate(player, data)
		savePlayerData(player, data)
	end
end)

----- Loops -----

task.spawn(function()
	while true do
		task.wait(Config.PassiveIncomeTickRate)
		for player, data in playerDataMap do
			if player.Parent then
				local income = calculateIncome(data)
				data.Currency = data.Currency + income
				if data.Currency % 10 < income then
					pushUpdate(player, data)
				end
			end
		end
	end
end)

task.spawn(function()
	while true do
		task.wait(Config.AutoSaveInterval)
		for player, data in playerDataMap do
			if player.Parent then
				savePlayerData(player, data)
			end
		end
	end
end)

task.spawn(function()
	while true do
		task.wait(Config.LockHeartbeatInterval)
		for userId in SaveManager.ActiveLocks do
			SaveManager.HeartbeatLock(userId)
		end
	end
end)

----- Connections -----

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

for _, player in Players:GetPlayers() do
	task.spawn(onPlayerAdded, player)
end

----- Shutdown -----

game:BindToClose(function()
	for player, data in playerDataMap do
		savePlayerData(player, data)
	end
	SaveManager.ReleaseAllLocks()
end)

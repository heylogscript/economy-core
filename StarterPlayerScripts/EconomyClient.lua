local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Modules = ReplicatedStorage:WaitForChild("EconomyModules")
local Generators = require(Modules.Generators)
local Upgrades = require(Modules.Upgrades)

local remotes = ReplicatedStorage:WaitForChild("EconomyRemotes")
local updateUI = remotes:WaitForChild("UpdateUI")
local purchaseGenerator = remotes:WaitForChild("PurchaseGenerator")
local purchaseUpgrade = remotes:WaitForChild("PurchaseUpgrade")
local prestige = remotes:WaitForChild("Prestige")
local requestData = remotes:WaitForChild("RequestData")

local playerData = nil
local listeners = {}

updateUI.OnClientEvent:Connect(function(data)
	playerData = data
	for _, fn in listeners do
		task.spawn(fn, data)
	end
end)

local EconomyClient = {}

function EconomyClient.GetData()
	if playerData then return playerData end
	local ok, result = pcall(function()
		return requestData:InvokeServer()
	end)
	if ok then
		playerData = result
	end
	return playerData
end

function EconomyClient.OnUpdate(fn)
	table.insert(listeners, fn)
	if playerData then
		task.spawn(fn, playerData)
	end
	return fn
end

function EconomyClient.RemoveListener(fn)
	for i, v in listeners do
		if v == fn then
			table.remove(listeners, i)
			return
		end
	end
end

function EconomyClient.BuyGenerator(genId)
	purchaseGenerator:FireServer(genId)
end

function EconomyClient.BuyUpgrade(upgId)
	purchaseUpgrade:FireServer(upgId)
end

function EconomyClient.Prestige()
	prestige:FireServer()
end

function EconomyClient.GetGeneratorList()
	return Generators.List
end

function EconomyClient.GetUpgradeList()
	return Upgrades.List
end

function EconomyClient.FormatNumber(n)
	if n >= 1e9 then
		return string.format("%.2fb", n / 1e9)
	elseif n >= 1e6 then
		return string.format("%.2fm", n / 1e6)
	elseif n >= 1e3 then
		return string.format("%.1fk", n / 1e3)
	end
	return tostring(math.floor(n))
end

return EconomyClient

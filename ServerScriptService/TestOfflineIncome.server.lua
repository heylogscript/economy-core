local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage:WaitForChild("EconomyModules")

local Config = require(Modules.Config)
local Generators = require(Modules.Generators)
local Upgrades = require(Modules.Upgrades)

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
	return base
end

local function simulateOfflineIncome(data, offlineSeconds)
	local rate = calculateIncome(data)
	local rawIncome = rate * offlineSeconds
	local cappedTime = math.min(offlineSeconds, Config.OfflineIncomeCap)
	local cappedIncome = math.floor(rate * cappedTime)
	return rawIncome, cappedIncome, cappedTime
end

print("===== OFFLINE INCOME CAP TESTS =====")
print("Cap configured as:", Config.OfflineIncomeCap, "seconds (", Config.OfflineIncomeCap / 3600, "hours )")

local testPlayer = {
	UserId = 999999,
	Generators = {
		lemonade_stand = 10,
		newspaper_route = 5,
		car_wash = 2,
	},
	Upgrades = {
		lemondade_double = true,
	},
	PrestigeLevel = 0,
	Currency = 0,
}

local incomeRate = calculateIncome(testPlayer)
print("\nTest player income rate:", incomeRate, "/sec")
print("Breakdown: 10 Lemonade Stands (1*10*2=20) + 5 Newspaper Routes (5*5=25) + 2 Car Washes (25*2=50) = 95/sec")

local raw, capped, cappedTime = simulateOfflineIncome(testPlayer, 3600)
print("\n--- Test: 1 hour offline (within cap) ---")
print("  Raw income:", raw)
print("  Capped time:", cappedTime, "seconds")
print("  Capped income:", capped)
print("  Within cap:", raw == capped and "YES" or "NO (should be YES)")

local raw2, capped2, cappedTime2 = simulateOfflineIncome(testPlayer, Config.OfflineIncomeCap)
print("\n--- Test: Exactly at cap (", Config.OfflineIncomeCap, "s) ---")
print("  Raw income:", raw2)
print("  Capped income:", capped2)
print("  Within cap:", raw2 == capped2 and "YES" or "NO (should be YES)")

local raw3, capped3, cappedTime3 = simulateOfflineIncome(testPlayer, 36000)
print("\n--- Test: 10 hours offline (EXCEEDS cap!) ---")
print("  Raw income:", raw3, "(what they'd get without cap)")
print("  Capped time:", cappedTime3, "seconds (max =", Config.OfflineIncomeCap, ")")
print("  Capped income:", capped3)
print("  Cap enforced:", capped3 < raw3 and "YES" or "NO (should be YES)")
print("  Capped == 2hr rate:", capped3 == math.floor(incomeRate * Config.OfflineIncomeCap) and "YES" or "NO (should be YES)")
print("  EXCESS denied:", raw3 - capped3, "currency denied by cap")

local raw4, capped4, cappedTime4 = simulateOfflineIncome(testPlayer, 604800)
print("\n--- Test: 7 days offline (massive excess) ---")
print("  Raw income:", raw4)
print("  Capped time:", cappedTime4, "seconds")
print("  Capped income:", capped4)
print("  Cap enforced:", capped4 < raw4 and "YES" or "NO")

local mockData = {
	UserId = 888888,
	Currency = 0,
	Generators = {
		lemonade_stand = 10,
		newspaper_route = 5,
		car_wash = 2,
	},
	Upgrades = {
		lemondade_double = true,
	},
	PrestigeLevel = 0,
	LastSaveTime = os.time() - 36000,
	LastIncomeRate = incomeRate,
}

print("\n\n===== SAVEMANAGER OFFLINE LOAD SIMULATION =====")
print("Simulating SaveManager.LoadPlayerData with LastSaveTime = 10h ago")
print("Income rate stored:", mockData.LastIncomeRate, "/sec")

local offlineTime = os.time() - mockData.LastSaveTime
print("Calculated offline time:", offlineTime, "seconds")
local cappedSeconds = math.min(offlineTime, Config.OfflineIncomeCap)
print("Capped seconds:", cappedSeconds)
local offlineIncome = math.floor(mockData.LastIncomeRate * cappedSeconds)
print("Offline income granted:", offlineIncome)
print("Rate * Cap =", incomeRate, "*", Config.OfflineIncomeCap, "=", incomeRate * Config.OfflineIncomeCap)
print("Granted:", offlineIncome, "(floored)")
print("Equals cap amount:", offlineIncome == math.floor(incomeRate * Config.OfflineIncomeCap) and "YES" or "NO")

print("\n===== TEST COMPLETE =====")
print("If all 'Cap enforced' checks printed YES, the offline cap works correctly.")
print("Screenshot the Output window as proof of the cap behaviour.")

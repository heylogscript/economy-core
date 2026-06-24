local Config = require(script.Parent.Config)

local DataStoreService = game:GetService("DataStoreService")

local DS = nil
local function getDS()
	if not DS then
		DS = DataStoreService:GetDataStore(Config.DataStoreName)
	end
	return DS
end

local ServerLockId = game.JobId .. "-" .. tick()
local SaveManager = {}
SaveManager.ActiveLocks = {}

local function dataKey(userId)
	return "PlayerData_" .. userId
end

local function defaults(userId)
	return {
		UserId = userId,
		Currency = Config.StartingCurrency,
		Generators = {},
		Upgrades = {},
		PrestigeLevel = 0,
		TotalPlayTime = 0,
		LastSaveTime = os.time(),
		LastIncomeRate = 0,
		OfflineEarned = 0,
		OfflineSecs = 0,
		LockId = "",
		LockTimestamp = 0,
	}
end

function SaveManager.LoadPlayerData(userId)
	local store = getDS()
	local k = dataKey(userId)

	for retry = 1, Config.MaxLoadRetries do
		local now = os.time()
		local ok, result = pcall(function()
			return store:UpdateAsync(k, function(existing)
				if existing == nil then
					local d = defaults(userId)
					d.LockId = ServerLockId
					d.LockTimestamp = now
					return d
				end

				if existing.LockId and existing.LockId ~= "" then
					local lockAge = now - (existing.LockTimestamp or 0)
					if lockAge <= Config.LockTimeout then
						return existing
					end
				end

				local offlineSecs = now - (existing.LastSaveTime or now)
				if offlineSecs > 0 then
					local rate = existing.LastIncomeRate or 0
					local cappedSecs = math.min(offlineSecs, Config.OfflineIncomeCap)
					local earned = math.floor(rate * cappedSecs)
					existing.Currency = (existing.Currency or 0) + earned
					existing.OfflineEarned = earned
					existing.OfflineSecs = cappedSecs
				end

				existing.LockId = ServerLockId
				existing.LockTimestamp = now
				existing.LastSaveTime = now
				existing.UserId = userId
				existing.Generators = existing.Generators or {}
				existing.Upgrades = existing.Upgrades or {}
				existing.PrestigeLevel = existing.PrestigeLevel or 0
				existing.TotalPlayTime = existing.TotalPlayTime or 0
				existing.LastIncomeRate = existing.LastIncomeRate or 0
				existing.OfflineEarned = existing.OfflineEarned or 0
				existing.OfflineSecs = existing.OfflineSecs or 0
				return existing
			end)
		end)

		if ok and result then
			if result.LockId == ServerLockId then
				SaveManager.ActiveLocks[userId] = true
				return result
			end
		end

		local delay = Config.RetryDelayBase * (2 ^ (retry - 1))
		task.wait(delay)
	end

	warn("[Economy] Failed to acquire lock for", userId)
	return nil
end

function SaveManager.SavePlayerData(userId, data)
	data.LastSaveTime = os.time()
	local store = getDS()
	local k = dataKey(userId)
	local ok, err = pcall(function()
		store:UpdateAsync(k, function(existing)
			if existing and existing.LockId ~= ServerLockId then
				return existing
			end
			return data
		end)
	end)
	if not ok then
		warn("[Economy] Save error for", userId, ":", err)
	end
	return ok
end

function SaveManager.HeartbeatLock(userId)
	if not SaveManager.ActiveLocks[userId] then return end
	local store = getDS()
	local k = dataKey(userId)
	local now = os.time()
	pcall(function()
		store:UpdateAsync(k, function(existing)
			if existing and existing.LockId == ServerLockId then
				existing.LockTimestamp = now
				return existing
			end
			return existing
		end)
	end)
end

function SaveManager.ReleaseLock(userId)
	if not SaveManager.ActiveLocks[userId] then return end
	local store = getDS()
	local k = dataKey(userId)
	pcall(function()
		store:UpdateAsync(k, function(existing)
			if existing and existing.LockId == ServerLockId then
				existing.LockId = ""
				existing.LockTimestamp = 0
				return existing
			end
			return existing
		end)
	end)
	SaveManager.ActiveLocks[userId] = nil
end

function SaveManager.ReleaseAllLocks()
	for userId, _ in pairs(SaveManager.ActiveLocks) do
		SaveManager.ReleaseLock(userId)
	end
end

return SaveManager

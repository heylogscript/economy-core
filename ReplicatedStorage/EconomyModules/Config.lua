local Config = {}

Config.DataStoreName = "EconomyDataStore"

Config.LockTimeout = 30
Config.LockHeartbeatInterval = 15
Config.MaxLoadRetries = 5
Config.RetryDelayBase = 1

Config.StartingCurrency = 100
Config.AutoSaveInterval = 60
Config.PassiveIncomeTickRate = 1

Config.OfflineIncomeCap = 7200

Config.BasePrestigeCost = 10000
Config.PrestigeCostExponent = 1.5
Config.PrestigeMultiplierPerLevel = 0.1
Config.GlobalPrestigeMultiplierPerLevel = 0.01

return Config

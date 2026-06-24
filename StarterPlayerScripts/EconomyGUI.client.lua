local EconomyClient = require(script.Parent.EconomyClient)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EconomyGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local function make(c, props)
	local i = Instance.new(c)
	for k, v in props do
		i[k] = v
	end
	return i
end

local function gradient(from, to, rot)
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new(from, to)
	g.Rotation = rot or 90
	return g
end

local DARK = Color3.fromRGB(18, 18, 28)
local PANEL = Color3.fromRGB(26, 26, 38)
local GOLD = Color3.fromRGB(255, 200, 50)
local GREEN = Color3.fromRGB(70, 220, 120)
local RED = Color3.fromRGB(230, 80, 80)
local TEXT = Color3.fromRGB(220, 220, 230)
local SUB = Color3.fromRGB(150, 150, 165)

local ROOT = make("Frame", {
	Size = UDim2.fromOffset(400, 560),
	Position = UDim2.new(0, 12, 0.5, -280),
	BackgroundColor3 = DARK,
	BorderSizePixel = 0,
	Parent = screenGui,
})
gradient(PANEL, DARK, 90).Parent = ROOT
Instance.new("UICorner", ROOT).CornerRadius = UDim.new(0, 12)
local rStroke = Instance.new("UIStroke")
rStroke.Color = Color3.fromRGB(60, 60, 80)
rStroke.Thickness = 1
rStroke.Parent = ROOT

local shadowF = make("Frame", {
	Size = ROOT.Size,
	Position = ROOT.Position + UDim2.fromOffset(3, 3),
	AnchorPoint = ROOT.AnchorPoint,
	BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	BackgroundTransparency = 0.75,
	BorderSizePixel = 0,
	ZIndex = ROOT.ZIndex - 1,
	Parent = screenGui,
})
Instance.new("UICorner", shadowF).CornerRadius = UDim.new(0, 12)

---- HEADER ----

local HEADER = make("Frame", {
	Size = UDim2.new(1, 0, 0, 56),
	BackgroundColor3 = Color3.fromRGB(22, 22, 35),
	BorderSizePixel = 0,
	Parent = ROOT,
	ClipsDescendants = true,
})
Instance.new("UICorner", HEADER).CornerRadius = UDim.new(0, 12)

local currencyText = make("TextLabel", {
	Size = UDim2.new(1, -24, 0, 20),
	Position = UDim2.new(0, 16, 0, 8),
	BackgroundTransparency = 1,
	Text = "💰 0",
	TextColor3 = GOLD,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextScaled = true,
	Font = Enum.Font.GothamBold,
	Parent = HEADER,
})

local statsText = make("TextLabel", {
	Size = UDim2.new(1, -24, 0, 16),
	Position = UDim2.new(0, 16, 0, 32),
	BackgroundTransparency = 1,
	Text = "⚡ 0/sec  ·  Global x1.00",
	TextColor3 = SUB,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextScaled = true,
	Font = Enum.Font.Gotham,
	Parent = HEADER,
})

local offlineNotice = make("Frame", {
	Size = UDim2.new(1, -16, 0, 24),
	Position = UDim2.new(0, 8, 0, -28),
	BackgroundColor3 = Color3.fromRGB(25, 55, 30),
	BorderSizePixel = 0,
	Visible = false,
	Parent = HEADER,
})
Instance.new("UICorner", offlineNotice).CornerRadius = UDim.new(0, 6)
gradient(Color3.fromRGB(25, 55, 30), Color3.fromRGB(20, 45, 25), 0).Parent = offlineNotice
make("TextLabel", {
	Size = UDim2.new(1, -12, 1, 0),
	Position = UDim2.new(0, 6, 0, 0),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = GREEN,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextScaled = true,
	Font = Enum.Font.GothamSemibold,
	Parent = offlineNotice,
})

---- TABS ----

local TAB_BAR = make("Frame", {
	Size = UDim2.new(1, 0, 0, 36),
	Position = UDim2.new(0, 0, 0, 56),
	BackgroundColor3 = Color3.fromRGB(20, 20, 32),
	BorderSizePixel = 0,
	Parent = ROOT,
})

local genTab = make("TextButton", {
	Size = UDim2.new(0.5, 0, 1, 0),
	BackgroundColor3 = Color3.fromRGB(26, 26, 38),
	Text = "  Factory Generators",
	TextColor3 = GOLD,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextScaled = true,
	Font = Enum.Font.GothamBold,
	BorderSizePixel = 0,
	Parent = TAB_BAR,
})

local upgTab = make("TextButton", {
	Size = UDim2.new(0.5, 0, 1, 0),
	Position = UDim2.new(0.5, 0, 0, 0),
	BackgroundColor3 = Color3.fromRGB(20, 20, 32),
	Text = "  Arrow Upgrades",
	TextColor3 = SUB,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextScaled = true,
	Font = Enum.Font.Gotham,
	BorderSizePixel = 0,
	Parent = TAB_BAR,
})

local tabIndicator = make("Frame", {
	Size = UDim2.new(0.5, 0, 0, 2),
	Position = UDim2.new(0, 0, 1, -2),
	BackgroundColor3 = GOLD,
	BorderSizePixel = 0,
	Parent = TAB_BAR,
})
Instance.new("UICorner", tabIndicator).CornerRadius = UDim.new(0, 2)

local prestigeBtn = make("TextButton", {
	Size = UDim2.new(0, 84, 0, 24),
	Position = UDim2.new(1, -92, 0.5, -12),
	BackgroundColor3 = Color3.fromRGB(50, 30, 70),
	Text = "Star",
	TextColor3 = Color3.fromRGB(200, 160, 255),
	TextScaled = true,
	Font = Enum.Font.GothamBold,
	BorderSizePixel = 0,
	Parent = TAB_BAR,
})
Instance.new("UICorner", prestigeBtn).CornerRadius = UDim.new(0, 6)
local ps = make("Frame", {
	Size = UDim2.new(1, 0, 1, 0),
	Position = UDim2.fromOffset(2, 2),
	BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	BackgroundTransparency = 0.8,
	BorderSizePixel = 0,
	ZIndex = prestigeBtn.ZIndex - 1,
	Parent = prestigeBtn,
})
Instance.new("UICorner", ps).CornerRadius = UDim.new(0, 6)
gradient(Color3.fromRGB(70, 40, 100), Color3.fromRGB(50, 30, 70), 90).Parent = prestigeBtn

---- CONTENT ----

local CONTENT = make("Frame", {
	Size = UDim2.new(1, 0, 1, -92),
	Position = UDim2.new(0, 0, 0, 92),
	BackgroundColor3 = Color3.fromRGB(20, 20, 32),
	BorderSizePixel = 0,
	Parent = ROOT,
})
Instance.new("UICorner", CONTENT).CornerRadius = UDim.new(0, 12)

local scrollFrame = make("ScrollingFrame", {
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	ScrollBarThickness = 4,
	ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80),
	Parent = CONTENT,
})
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame
local padding = Instance.new("UIPadding")
padding.PaddingBottom = UDim.new(0, 8)
padding.PaddingTop = UDim.new(0, 8)
padding.PaddingLeft = UDim.new(0, 8)
padding.PaddingRight = UDim.new(0, 8)
padding.Parent = scrollFrame

---- CARD SYSTEM ----

local cardMap = {}
local currentTab = "generators"
local currentData = nil
local offlineShown = false
local needsRebuild = true

local function clearScroll()
	for _, child in scrollFrame:GetChildren() do
		if child:IsA("TextButton") or child:IsA("Frame") then
			child:Destroy()
		end
	end
	cardMap = {}
end

function makeCard(id, icon, name, desc)
	local c = make("TextButton", {
		Size = UDim2.new(1, 0, 0, 58),
		BackgroundColor3 = Color3.fromRGB(32, 35, 48),
		Text = "",
		BorderSizePixel = 0,
		Parent = scrollFrame,
		AutoButtonColor = false,
	})
	Instance.new("UICorner", c).CornerRadius = UDim.new(0, 8)
	local cStroke = Instance.new("UIStroke")
	cStroke.Thickness = 1
	cStroke.Parent = c

	local bgGrad = gradient(Color3.fromRGB(35, 38, 52), Color3.fromRGB(30, 33, 46), 0)
	bgGrad.Parent = c

	make("TextLabel", {
		Name = "Icon",
		Size = UDim2.new(0, 22, 0, 22),
		Position = UDim2.new(0, 10, 0, 6),
		BackgroundTransparency = 1,
		Text = icon,
		TextScaled = true,
		Font = Enum.Font.Gotham,
		Parent = c,
	})

	make("TextLabel", {
		Name = "Title",
		Size = UDim2.new(0.6, -32, 0, 18),
		Position = UDim2.new(0, 36, 0, 6),
		BackgroundTransparency = 1,
		Text = name,
		TextColor3 = TEXT,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextScaled = true,
		Font = Enum.Font.GothamSemibold,
		Parent = c,
	})

	make("TextLabel", {
		Name = "Desc",
		Size = UDim2.new(0.6, -32, 0, 16),
		Position = UDim2.new(0, 36, 0, 26),
		BackgroundTransparency = 1,
		Text = desc,
		TextColor3 = SUB,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextScaled = true,
		Font = Enum.Font.Gotham,
		Parent = c,
	})

	make("TextLabel", {
		Name = "Price",
		Size = UDim2.new(0, 80, 0, 18),
		Position = UDim2.new(1, -90, 0, 6),
		BackgroundTransparency = 1,
		Text = "$0",
		TextScaled = true,
		Font = Enum.Font.GothamBold,
		Parent = c,
	})

	make("TextLabel", {
		Name = "Status",
		Size = UDim2.new(0, 80, 0, 16),
		Position = UDim2.new(1, -90, 0, 28),
		BackgroundTransparency = 1,
		Text = "BUY",
		TextScaled = true,
		Font = Enum.Font.GothamBold,
		Parent = c,
	})

	return c
end

function updateCard(c, cost, owned, canBuy, onClick)
	local title = c:FindFirstChild("Title")
	local price = c:FindFirstChild("Price")
	local status = c:FindFirstChild("Status")

	if title then
		title.Text = c.Name .. (owned and owned > 0 and "  (" .. owned .. ")" or "")
	end
	if price then
		price.Text = "$" .. EconomyClient.FormatNumber(cost)
		price.TextColor3 = canBuy and GOLD or RED
	end
	if status then
		status.Text = canBuy and "BUY" or "LOCKED"
		status.TextColor3 = canBuy and GREEN or RED
	end

	local base = canBuy and Color3.fromRGB(32, 35, 48) or Color3.fromRGB(26, 28, 38)
	c.BackgroundColor3 = base

	local strk = c:FindFirstChildOfClass("UIStroke")
	if strk then
		strk.Color = canBuy and Color3.fromRGB(50, 55, 75) or Color3.fromRGB(35, 38, 48)
	end

	local grad = c:FindFirstChildOfClass("UIGradient")
	if grad then
		grad.Color = ColorSequence.new(
			canBuy and Color3.fromRGB(35, 38, 52) or Color3.fromRGB(28, 30, 40),
			canBuy and Color3.fromRGB(30, 33, 46) or Color3.fromRGB(24, 26, 36)
		)
	end

	c.MouseEnter:Connect(function()
		c.BackgroundColor3 = canBuy and Color3.fromRGB(40, 44, 60) or Color3.fromRGB(32, 34, 46)
		c:TweenPosition(UDim2.new(0, 2, 0, 0), "Out", "Quad", 0.08, true)
	end)
	c.MouseLeave:Connect(function()
		c.BackgroundColor3 = base
		c:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.08, true)
	end)

	if onClick then
		c.MouseButton1Click:Connect(function()
			onClick()
			needsRebuild = true
		end)
	end
end

function buildGenList(data)
	clearScroll()
	local idx = 0
	for _, gen in EconomyClient.GetGeneratorList() do
		idx = idx + 1
		local owned = data.Generators[gen.Id] or 0
		local cost = data.GeneratorCosts[gen.Id] or gen.BaseCost
		local c = makeCard(gen.Id, "🏪", gen.Name, gen.Description)
		c.LayoutOrder = idx
		c.Name = gen.Id
		cardMap[gen.Id] = c
		updateCard(c, cost, owned, data.Currency >= cost, function()
			EconomyClient.BuyGenerator(gen.Id)
		end)
	end
end

function buildUpgList(data)
	clearScroll()
	local idx = 0
	for _, upg in EconomyClient.GetUpgradeList() do
		idx = idx + 1
		if data.Upgrades[upg.Id] then
			local c = make("Frame", {
				Size = UDim2.new(1, 0, 0, 44),
				BackgroundColor3 = Color3.fromRGB(22, 38, 26),
				BorderSizePixel = 0,
				LayoutOrder = idx,
				Parent = scrollFrame,
			})
			Instance.new("UICorner", c).CornerRadius = UDim.new(0, 8)
			local s = Instance.new("UIStroke")
			s.Color = Color3.fromRGB(35, 55, 40)
			s.Thickness = 1
			s.Parent = c
			gradient(Color3.fromRGB(25, 42, 30), Color3.fromRGB(20, 35, 24), 0).Parent = c
			make("TextLabel", {
				Size = UDim2.new(1, -16, 1, 0),
				Position = UDim2.new(0, 12, 0, 0),
				BackgroundTransparency = 1,
				Text = "✅  " .. upg.Name .. "  —  " .. upg.Description,
				TextColor3 = GREEN,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextScaled = true,
				Font = Enum.Font.GothamSemibold,
				Parent = c,
			})
			cardMap[upg.Id] = c
		else
			local c = makeCard(upg.Id, "🔧", upg.Name, upg.Description)
			c.LayoutOrder = idx
			c.Name = upg.Id
			cardMap[upg.Id] = c
			updateCard(c, upg.Cost, nil, data.Currency >= upg.Cost, function()
				EconomyClient.BuyUpgrade(upg.Id)
			end)
		end
	end
end

function refreshList(data)
	for id, c in cardMap do
		local gen = EconomyClient.GetGeneratorList()
		local isGen = false
		local owned = nil
		local cost = nil
		local canBuy = false
		local clickFn = nil

		for _, g in EconomyClient.GetGeneratorList() do
			if g.Id == id then
				isGen = true
				owned = data.Generators[id] or 0
				cost = data.GeneratorCosts[id] or g.BaseCost
				canBuy = data.Currency >= cost
				clickFn = function() EconomyClient.BuyGenerator(id) end
				break
			end
		end

		if not isGen then
			for _, u in EconomyClient.GetUpgradeList() do
				if u.Id == id then
					if data.Upgrades[id] then
						cost = 0
						canBuy = false
					else
						cost = u.Cost
						canBuy = data.Currency >= cost
						clickFn = function() EconomyClient.BuyUpgrade(id) end
					end
					break
				end
			end
		end

		if cost ~= nil then
			local title = c:FindFirstChild("Title")
			local price = c:FindFirstChild("Price")
			local status = c:FindFirstChild("Status")
			if title and isGen then
				title.Text = c.Name .. (owned and owned > 0 and "  (" .. owned .. ")" or "")
			end
			if price then
				price.Text = "$" .. EconomyClient.FormatNumber(cost)
				price.TextColor3 = canBuy and GOLD or RED
			end
			if status then
				status.Text = canBuy and "BUY" or "LOCKED"
				status.TextColor3 = canBuy and GREEN or RED
			end
			local base = canBuy and Color3.fromRGB(32, 35, 48) or Color3.fromRGB(26, 28, 38)
			c.BackgroundColor3 = base
			local strk = c:FindFirstChildOfClass("UIStroke")
			if strk then
				strk.Color = canBuy and Color3.fromRGB(50, 55, 75) or Color3.fromRGB(35, 38, 48)
			end
			local grad = c:FindFirstChildOfClass("UIGradient")
			if grad then
				grad.Color = ColorSequence.new(
					canBuy and Color3.fromRGB(35, 38, 52) or Color3.fromRGB(28, 30, 40),
					canBuy and Color3.fromRGB(30, 33, 46) or Color3.fromRGB(24, 26, 36)
				)
			end
		end
	end
end

function refreshUI(data)
	currentData = data
	currencyText.Text = "💰 " .. EconomyClient.FormatNumber(data.Currency)

	local incomeStr = "⚡ " .. EconomyClient.FormatNumber(data.IncomePerSecond) .. "/sec  ·  Global x" .. string.format("%.2f", data.GlobalMultiplier or 1)
	if statsText.Text ~= incomeStr then
		statsText.Text = incomeStr
	end

	if data.PrestigeCost then
		local canPrestige = data.Currency >= data.PrestigeCost
		local pcText = "🌟 $" .. EconomyClient.FormatNumber(data.PrestigeCost)
		if prestigeBtn.Text ~= pcText then
			prestigeBtn.Text = pcText
		end
		prestigeBtn.BackgroundColor3 = canPrestige and Color3.fromRGB(70, 40, 100) or Color3.fromRGB(35, 25, 50)
	end

	if data.OfflineEarned and data.OfflineEarned > 0 and not offlineShown then
		offlineShown = true
		offlineNotice.Visible = true
		local lbl = offlineNotice:FindFirstChildOfClass("TextLabel")
		if lbl then
			lbl.Text = "⏰  Offline: +$" .. EconomyClient.FormatNumber(data.OfflineEarned)
		end
		task.spawn(function()
			task.wait(0.5)
			for _ = 1, 8 do
				offlineNotice:TweenPosition(UDim2.new(0, 8, 0, 2), "Out", "Quad", 0.3)
				task.wait(0.3)
			end
			task.wait(4)
			for _ = 1, 6 do
				offlineNotice:TweenPosition(UDim2.new(0, 8, 0, -28), "Out", "Quad", 0.3)
				task.wait(0.3)
			end
			offlineNotice.Visible = false
		end)
	end

	if needsRebuild then
		needsRebuild = false
		clearScroll()
		if currentTab == "generators" then
			buildGenList(data)
		else
			buildUpgList(data)
		end
	else
		refreshList(data)
	end
end

genTab.MouseButton1Click:Connect(function()
	if currentTab == "generators" then return end
	currentTab = "generators"
	genTab.BackgroundColor3 = Color3.fromRGB(26, 26, 38)
	genTab.TextColor3 = GOLD
	upgTab.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
	upgTab.TextColor3 = SUB
	tabIndicator:TweenPosition(UDim2.new(0, 0, 1, -2), "Out", "Quad", 0.2)
	needsRebuild = true
	if currentData then refreshUI(currentData) end
end)

upgTab.MouseButton1Click:Connect(function()
	if currentTab == "upgrades" then return end
	currentTab = "upgrades"
	upgTab.BackgroundColor3 = Color3.fromRGB(26, 26, 38)
	upgTab.TextColor3 = GOLD
	genTab.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
	genTab.TextColor3 = SUB
	tabIndicator:TweenPosition(UDim2.new(0.5, 0, 1, -2), "Out", "Quad", 0.2)
	needsRebuild = true
	if currentData then refreshUI(currentData) end
end)

prestigeBtn.MouseButton1Click:Connect(function()
	EconomyClient.Prestige()
	needsRebuild = true
end)

prestigeBtn.MouseEnter:Connect(function()
	prestigeBtn.BackgroundColor3 = Color3.fromRGB(90, 55, 130)
end)

prestigeBtn.MouseLeave:Connect(function()
	if currentData and currentData.PrestigeCost then
		local ok = currentData.Currency >= currentData.PrestigeCost
		prestigeBtn.BackgroundColor3 = ok and Color3.fromRGB(70, 40, 100) or Color3.fromRGB(35, 25, 50)
	end
end)

EconomyClient.OnUpdate(refreshUI)

local initialData = EconomyClient.GetData()
if initialData then
	task.wait(0.3)
	refreshUI(initialData)
end

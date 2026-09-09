local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("KairoTechUI") then
	playerGui.KairoTechUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KairoTechUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Цветовая палитра
local THEME = {
	BG = Color3.fromRGB(12, 10, 20),
	HEADER = Color3.fromRGB(18, 14, 30),
	PANEL = Color3.fromRGB(22, 18, 36),
	TEXT_TITLE = Color3.fromRGB(168, 85, 247),
	TEXT_ACCENT = Color3.fromRGB(99, 102, 241),
	TEXT_MUTED = Color3.fromRGB(140, 140, 170),
	BORDER = Color3.fromRGB(139, 92, 246),
	BTN_OFF = Color3.fromRGB(28, 24, 44),
	BTN_ON = Color3.fromRGB(124, 58, 237),
	SUCCESS = Color3.fromRGB(34, 197, 94)
}

local function getPlayerByPartialName(name)
	name = name:lower()
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player and (p.Name:lower():find(name) or p.DisplayName:lower():find(name)) then
			return p
		end
	end
	return nil
end

--------------------------------------------------------------------------------
-- 1. ИНТРО
--------------------------------------------------------------------------------
local introCard = Instance.new("Frame")
introCard.Size = UDim2.new(0, 310, 0, 100)
introCard.Position = UDim2.new(0.5, -155, 0.4, -50)
introCard.BackgroundColor3 = THEME.BG
introCard.BorderSizePixel = 0
introCard.BackgroundTransparency = 1
introCard.Parent = screenGui

Instance.new("UICorner", introCard).CornerRadius = UDim.new(0, 14)
local introStroke = Instance.new("UIStroke", introCard)
introStroke.Color = THEME.BORDER
introStroke.Thickness = 1.8
introStroke.Transparency = 1

local introTitle = Instance.new("TextLabel")
introTitle.Size = UDim2.new(1, 0, 0, 40)
introTitle.Position = UDim2.new(0, 0, 0.15, 0)
introTitle.BackgroundTransparency = 1
introTitle.Text = "✨ K A I R O T E C H ✨"
introTitle.TextColor3 = THEME.TEXT_TITLE
introTitle.TextSize = 20
introTitle.Font = Enum.Font.GothamBold
introTitle.TextTransparency = 1
introTitle.Parent = introCard

local introSub = Instance.new("TextLabel")
introSub.Size = UDim2.new(1, 0, 0, 20)
introSub.Position = UDim2.new(0, 0, 0.6, 0)
introSub.BackgroundTransparency = 1
introSub.Text = "Ultimate Roblox Multihack"
introSub.TextColor3 = THEME.TEXT_ACCENT
introSub.TextSize = 12
introSub.Font = Enum.Font.GothamMedium
introSub.TextTransparency = 1
introSub.Parent = introCard

--------------------------------------------------------------------------------
-- 2. АВТОРИЗАЦИЯ
--------------------------------------------------------------------------------
local loginFrame = Instance.new("Frame")
loginFrame.Size = UDim2.new(0, 310, 0, 180)
loginFrame.Position = UDim2.new(0.5, -155, 0.5, -90)
loginFrame.BackgroundColor3 = THEME.BG
loginFrame.BorderSizePixel = 0
loginFrame.Visible = false
loginFrame.Parent = screenGui

Instance.new("UICorner", loginFrame).CornerRadius = UDim.new(0, 14)
local loginStroke = Instance.new("UIStroke", loginFrame)
loginStroke.Color = THEME.BORDER
loginStroke.Thickness = 1.2

local loginTitle = Instance.new("TextLabel")
loginTitle.Size = UDim2.new(1, 0, 0, 45)
loginTitle.BackgroundTransparency = 1
loginTitle.Text = "💜 Авторизация"
loginTitle.TextColor3 = THEME.TEXT_TITLE
loginTitle.TextSize = 16
loginTitle.Font = Enum.Font.GothamBold
loginTitle.Parent = loginFrame

local passBox = Instance.new("TextBox")
passBox.Size = UDim2.new(0.85, 0, 0, 38)
passBox.Position = UDim2.new(0.075, 0, 0.33, 0)
passBox.BackgroundColor3 = THEME.PANEL
passBox.BorderSizePixel = 0
passBox.PlaceholderText = "Пароль (по умолч.: 2200)"
passBox.PlaceholderColor3 = THEME.TEXT_MUTED
passBox.Text = ""
passBox.TextColor3 = Color3.fromRGB(255, 255, 255)
passBox.TextSize = 12
passBox.Font = Enum.Font.Gotham
passBox.Parent = loginFrame

Instance.new("UICorner", passBox).CornerRadius = UDim.new(0, 8)
local passStroke = Instance.new("UIStroke", passBox)
passStroke.Color = THEME.TEXT_ACCENT
passStroke.Thickness = 1

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(0.85, 0, 0, 38)
submitBtn.Position = UDim2.new(0.075, 0, 0.66, 0)
submitBtn.BackgroundColor3 = THEME.BTN_ON
submitBtn.BorderSizePixel = 0
submitBtn.Text = "Войти"
submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
submitBtn.TextSize = 13
submitBtn.Font = Enum.Font.GothamBold
submitBtn.Parent = loginFrame

Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0, 8)

--------------------------------------------------------------------------------
-- 3. ГЛАВНОЕ МЕНЮ
--------------------------------------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 370)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -185)
mainFrame.BackgroundColor3 = THEME.BG
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = THEME.BORDER
mainStroke.Thickness = 1.5

-- Шапка
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 36)
header.BackgroundColor3 = THEME.HEADER
header.BorderSizePixel = 0
header.Parent = mainFrame

local menuTitle = Instance.new("TextLabel")
menuTitle.Size = UDim2.new(0.5, 0, 1, 0)
menuTitle.Position = UDim2.new(0, 14, 0, 0)
menuTitle.BackgroundTransparency = 1
menuTitle.Text = "🔮 KAIROTECH MULTIHUB v2.0"
menuTitle.TextColor3 = THEME.TEXT_TITLE
menuTitle.TextSize = 13
menuTitle.Font = Enum.Font.GothamBold
menuTitle.TextXAlignment = Enum.TextXAlignment.Left
menuTitle.Parent = header

local keyHint = Instance.new("TextLabel")
keyHint.Size = UDim2.new(0.4, 0, 1, 0)
keyHint.Position = UDim2.new(0.57, 0, 0, 0)
keyHint.BackgroundTransparency = 1
keyHint.Text = "[RShift] Скрыть"
keyHint.TextColor3 = THEME.TEXT_MUTED
keyHint.TextSize = 10
keyHint.Font = Enum.Font.Gotham
keyHint.TextXAlignment = Enum.TextXAlignment.Right
keyHint.Parent = header

-- Панель вкладок (Горизонтальный ScrollingFrame)
local tabContainer = Instance.new("ScrollingFrame")
tabContainer.Size = UDim2.new(1, -20, 0, 32)
tabContainer.Position = UDim2.new(0, 10, 0, 42)
tabContainer.BackgroundTransparency = 1
tabContainer.BorderSizePixel = 0
tabContainer.ScrollBarThickness = 2
tabContainer.CanvasSize = UDim2.new(2, 0, 0, 0)
tabContainer.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout", tabContainer)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 6)

local function createTabBtn(text, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 95, 1, 0)
	btn.BackgroundColor3 = (order == 1) and THEME.BTN_ON or THEME.BTN_OFF
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = (order == 1) and Color3.fromRGB(255, 255, 255) or THEME.TEXT_MUTED
	btn.TextSize = 10
	btn.Font = Enum.Font.GothamBold
	btn.LayoutOrder = order
	btn.Parent = tabContainer
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
	return btn
end

local tabBtns = {
	createTabBtn("Игрок 🏃", 1),
	createTabBtn("Blade Ball ⚔️", 2),
	createTabBtn("Blox Fruits 🍎", 3),
	createTabBtn("Doors 🚪", 4),
	createTabBtn("Arsenal 🔫", 5),
	createTabBtn("BABFT 🛶", 6),
	createTabBtn("Desert 🏜️", 7),
	createTabBtn("MM2 🔪", 8),
	createTabBtn("Brookhaven 🏙️", 9),
	createTabBtn("PS99 🐾", 10),
	createTabBtn("Файлы 📁", 11)
}

--------------------------------------------------------------------------------
-- 4. СОЗДАНИЕ ВЫДЕЛЕННЫХ ВКЛАДОК
--------------------------------------------------------------------------------
local function createContentFrame()
	local frame = Instance.new("ScrollingFrame")
	frame.Size = UDim2.new(1, -20, 1, -88)
	frame.Position = UDim2.new(0, 10, 0, 80)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.ScrollBarThickness = 3
	frame.ScrollBarImageColor3 = THEME.BORDER
	frame.Visible = false
	frame.Parent = mainFrame
	
	local list = Instance.new("UIListLayout", frame)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0, 6)
	return frame
end

local function createToggle(text, order, parent)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.99, 0, 0, 34)
	btn.BackgroundColor3 = THEME.PANEL
	btn.BorderSizePixel = 0
	btn.Text = "   " .. text .. ":  ВЫКЛ"
	btn.TextColor3 = THEME.TEXT_ACCENT
	btn.TextSize = 11
	btn.Font = Enum.Font.GothamBold
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.LayoutOrder = order
	btn.Parent = parent
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
	return btn
end

local function createTargetPanel(placeholderText, actionText, order, parent)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0.99, 0, 0, 36)
	container.BackgroundColor3 = THEME.PANEL
	container.BorderSizePixel = 0
	container.LayoutOrder = order
	container.Parent = parent
	Instance.new("UICorner", container).CornerRadius = UDim.new(0, 7)

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.62, 0, 0.7, 0)
	box.Position = UDim2.new(0.02, 0, 0.15, 0)
	box.BackgroundColor3 = THEME.HEADER
	box.BorderSizePixel = 0
	box.PlaceholderText = placeholderText
	box.PlaceholderColor3 = THEME.TEXT_MUTED
	box.Text = ""
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.TextSize = 11
	box.Font = Enum.Font.Gotham
	box.Parent = container
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.32, 0, 0.7, 0)
	btn.Position = UDim2.new(0.66, 0, 0.15, 0)
	btn.BackgroundColor3 = THEME.BTN_ON
	btn.BorderSizePixel = 0
	btn.Text = actionText
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 10
	btn.Font = Enum.Font.GothamBold
	btn.Parent = container
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

	return box, btn
end

local tabsContent = {}
for i = 1, #tabBtns do
	tabsContent[i] = createContentFrame()
end
tabsContent[1].Visible = true

--------------------------------------------------------------------------------
-- 5. ФУНКЦИОНАЛ ИГР И НАСТРОЕК
--------------------------------------------------------------------------------
local function updateToggleVisual(btn, name, state)
	btn.Text = state and ("   " .. name .. ":  ВКЛ") or ("   " .. name .. ":  ВЫКЛ")
	btn.TextColor3 = state and THEME.SUCCESS or THEME.TEXT_ACCENT
end

--- ВКЛАДКА 1: ИГРОК ---
local flyBtn = createToggle("Полёт (Fly)", 1, tabsContent[1])
local walkBtn = createToggle("Ускорение бега", 2, tabsContent[1])
local noclipBtn = createToggle("Проходить сквозь стены (Noclip)", 3, tabsContent[1])
local espPlayersBtn = createToggle("ESP Игроков (Подсветка)", 4, tabsContent[1])

--- ВКЛАДКА 2: BLADE BALL ---
local bbParryBtn = createToggle("Auto Parry (Авто-Парирование)", 1, tabsContent[2])
local bbLockBtn = createToggle("Lock Ball Camera (Следить за мячом)", 2, tabsContent[2])

--- ВКЛАДКА 3: BLOX FRUITS ---
local bfFarmBtn = createToggle("Auto Farm Nearby Mobs", 1, tabsContent[3])
local bfChestBtn = createToggle("Auto Collect Chests (Фарм сундуков)", 2, tabsContent[3])

--- ВКЛАДКА 4: DOORS ---
local doorsEspBtn = createToggle("ESP Дверей и предметов", 1, tabsContent[4])
local doorsNotifyBtn = createToggle("Оповещение о Rush / Ambush", 2, tabsContent[4])

--- ВКЛАДКА 5: ARSENAL ---
local arsAimbotBtn = createToggle("Aimbot / Wallbang Assist", 1, tabsContent[5])
local arsEspBtn = createToggle("ESP Врагов", 2, tabsContent[5])

--- ВКЛАДКА 6: BABFT ---
local farmBtn = createToggle("Авто-Фарм золота (2.4s)", 1, tabsContent[6])
local jesusBtn = createToggle("Бесконечный кислород", 2, tabsContent[6])
local chestTpBtn = createToggle("Телепорт к сокровищу", 3, tabsContent[6])
local flingBox, flingBtn = createTargetPanel("Ник для Флинга...", "💥 Флинг: ВЫКЛ", 4, tabsContent[6])

--- ВКЛАДКА 7: DESERT ---
local stealEggBtn = createToggle("Украсть Яйцо (Steal Egg)", 1, tabsContent[7])
local tpNickBox, tpNickBtn = createTargetPanel("Ник для телепорта...", "⚡ ТП к игроку", 2, tabsContent[7])
local specBox, specBtn = createTargetPanel("Ник для наблюдения...", "👁️ Следить: ВЫКЛ", 3, tabsContent[7])
local aimbotBtn = createToggle("🎯 Аимбот (Aimbot Lock)", 4, tabsContent[7])
local explodeBox, explodeBtn = createTargetPanel("Ник для взрыва...", "💣 Взорвать", 5, tabsContent[7])

--- ВКЛАДКА 8: MM2 ---
local mm2EspBtn = createToggle("ESP Ролей (Murder/Sheriff)", 1, tabsContent[8])
local mm2TpLobbyBtn = createToggle("Телепорт в Лобби", 2, tabsContent[8])

--- ВКЛАДКА 9: BROOKHAVEN ---
local infJumpBtn = createToggle("Бесконечный прыжок", 1, tabsContent[9])
local tpBankBtn = createToggle("Телепорт в Банк", 2, tabsContent[9])

--- ВКЛАДКА 10: PET SIMULATOR 99 ---
local ps99CoinBtn = createToggle("Auto Collect Coins/Gems", 1, tabsContent[10])

--- ВКЛАДКА 11: ФАЙЛЫ ---
local dexBtn = Instance.new("TextButton")
dexBtn.Size = UDim2.new(0.99, 0, 0, 36)
dexBtn.BackgroundColor3 = THEME.BTN_ON
dexBtn.BorderSizePixel = 0
dexBtn.Text = "🚀 Запустить Dark Dex Explorer"
dexBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dexBtn.TextSize = 12
dexBtn.Font = Enum.Font.GothamBold
dexBtn.LayoutOrder = 1
dexBtn.Parent = tabsContent[11]
Instance.new("UICorner", dexBtn).CornerRadius = UDim.new(0, 7)

--------------------------------------------------------------------------------
-- 6. ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК
--------------------------------------------------------------------------------
for idx, btn in ipairs(tabBtns) do
	btn.MouseButton1Click:Connect(function()
		for i, b in ipairs(tabBtns) do
			b.BackgroundColor3 = THEME.BTN_OFF
			b.TextColor3 = THEME.TEXT_MUTED
			tabsContent[i].Visible = false
		end
		btn.BackgroundColor3 = THEME.BTN_ON
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabsContent[idx].Visible = true
	end)
end

--------------------------------------------------------------------------------
-- 7. ЛОГИКА И СКРИПТЫ
--------------------------------------------------------------------------------

-- NOCLIP
local noclip = false
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	updateToggleVisual(noclipBtn, "Проходить сквозь стены (Noclip)", noclip)
end)

RunService.Stepped:Connect(function()
	if noclip and player.Character then
		for _, part in ipairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- BLADE BALL: AUTO PARRY
local autoParry = false
bbParryBtn.MouseButton1Click:Connect(function()
	autoParry = not autoParry
	updateToggleVisual(bbParryBtn, "Auto Parry (Авто-Парирование)", autoParry)
	
	task.spawn(function()
		while autoParry do
			local balls = workspace:FindFirstChild("Balls")
			if balls then
				for _, ball in ipairs(balls:GetChildren()) do
					if ball:IsA("BasePart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						local dist = (ball.Position - player.Character.HumanoidRootPart.Position).Magnitude
						if dist < 20 then
							mouse1click() -- Симуляция клика для удара/блока
						end
					end
				end
			end
			task.wait(0.05)
		end
	end)
end)

-- BLOX FRUITS: AUTO FARM
local bfFarm = false
bfFarmBtn.MouseButton1Click:Connect(function()
	bfFarm = not bfFarm
	updateToggleVisual(bfFarmBtn, "Auto Farm Nearby Mobs", bfFarm)

	task.spawn(function()
		while bfFarm do
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				for _, npc in ipairs(workspace:GetDescendants()) do
					if not bfFarm then break end
					if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 and npc:FindFirstChild("HumanoidRootPart") and npc ~= char then
						local dist = (npc.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
						if dist < 350 then
							char.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
							task.wait(0.2)
						end
					end
				end
			end
			task.wait(0.5)
		end
	end)
end)

-- DOORS: ESP
local doorsEsp = false
doorsEspBtn.MouseButton1Click:Connect(function()
	doorsEsp = not doorsEsp
	updateToggleVisual(doorsEspBtn, "ESP Дверей и предметов", doorsEsp)
	
	task.spawn(function()
		while doorsEsp do
			for _, obj in ipairs(workspace:GetDescendants()) do
				if obj:IsA("Model") and (obj.Name == "Door" or obj.Name:find("Key")) then
					if not obj:FindFirstChild("DoorsHighlight") then
						local hl = Instance.new("Highlight")
						hl.Name = "DoorsHighlight"
						hl.FillColor = Color3.fromRGB(255, 255, 0)
						hl.Parent = obj
					end
				end
			end
			task.wait(2)
		end
	end)
end)

-- ARSENAL / DESERT: AIMBOT
local aimbotActive = false
aimbotBtn.MouseButton1Click:Connect(function()
	aimbotActive = not aimbotActive
	updateToggleVisual(aimbotBtn, "🎯 Аимбот (Aimbot Lock)", aimbotActive)

	task.spawn(function()
		while aimbotActive do
			local camera = workspace.CurrentCamera
			local closestPlayer = nil
			local shortestDistance = math.huge

			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
					local pos, onScreen = camera:WorldToViewportPoint(p.Character.Head.Position)
					if onScreen then
						local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).Magnitude
						if dist < shortestDistance then
							shortestDistance = dist
							closestPlayer = p
						end
					end
				end
			end

			if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
				camera.CFrame = CFrame.new(camera.CFrame.Position, closestPlayer.Character.Head.Position)
			end
			RunService.RenderStepped:Wait()
		end
	end)
end)

-- PET SIMULATOR 99: AUTO COINS
local ps99Coins = false
ps99CoinBtn.MouseButton1Click:Connect(function()
	ps99Coins = not ps99Coins
	updateToggleVisual(ps99CoinBtn, "Auto Collect Coins/Gems", ps99Coins)

	task.spawn(function()
		while ps99Coins do
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				for _, loot in ipairs(workspace:GetDescendants()) do
					if loot:IsA("BasePart") and (loot.Name:lower():find("coin") or loot.Name:lower():find("gem")) then
						loot.CFrame = char.HumanoidRootPart.CFrame
					end
				end
			end
			task.wait(0.5)
		end
	end)
end)

-- DESERT: ТЕЛЕПОРТ ПО НИКУ
tpNickBtn.MouseButton1Click:Connect(function()
	local target = getPlayerByPartialName(tpNickBox.Text)
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
		end
	end
end)

-- DESERT: ВЗОРВАТЬ
explodeBtn.MouseButton1Click:Connect(function()
	local target = getPlayerByPartialName(explodeBox.Text)
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		local exp = Instance.new("Explosion")
		exp.Position = target.Character.HumanoidRootPart.Position
		exp.BlastRadius = 10
		exp.BlastPressure = 500000
		exp.Parent = workspace
	end
end)

-- DARK DEX
dexBtn.MouseButton1Click:Connect(function()
	dexBtn.Text = "⏳ Загрузка Dark Dex..."
	task.spawn(function()
		pcall(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/perfectusmim1/darkdex/refs/heads/main/darkdexp"))()
		end)
		dexBtn.Text = "✅ Dark Dex Запущен!"
		task.wait(2)
		dexBtn.Text = "🚀 Запустить Dark Dex Explorer"
	end)
end)

--------------------------------------------------------------------------------
-- 8. ИНИЦИАЛИЗАЦИЯ И ЛОГИН
--------------------------------------------------------------------------------
loginFrame.Visible = true

local function checkPassword()
	if passBox.Text == "2200" or passBox.Text == "" then
		loginFrame:Destroy()
		mainFrame.Visible = true
	else
		passBox.Text = ""
		passBox.PlaceholderText = "Неверный пароль!"
	end
end

submitBtn.MouseButton1Click:Connect(checkPassword)
passBox.FocusLost:Connect(function(enter) if enter then checkPassword() end end)

-- Скрытие / Показ GUI на кнопку RightShift
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.RightShift and mainFrame and mainFrame.Parent then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

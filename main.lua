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

-- Цветовая палитра (Фиолетово-синяя)
local THEME = {
	BG = Color3.fromRGB(12, 10, 20),
	HEADER = Color3.fromRGB(18, 14, 30),
	PANEL = Color3.fromRGB(22, 18, 36),
	TEXT_TITLE = Color3.fromRGB(168, 85, 247), -- Неоново-фиолетовый
	TEXT_ACCENT = Color3.fromRGB(99, 102, 241), -- Неоново-синий
	TEXT_MUTED = Color3.fromRGB(140, 140, 170),
	BORDER = Color3.fromRGB(139, 92, 246),
	BTN_OFF = Color3.fromRGB(28, 24, 44),
	BTN_ON = Color3.fromRGB(124, 58, 237),
	SUCCESS = Color3.fromRGB(34, 197, 94)
}

-- Вспомогательная функция поиска игрока по части ника
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
introCard.Size = UDim2.new(0, 290, 0, 95)
introCard.Position = UDim2.new(0.5, -145, 0.4, -47)
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
introSub.Text = "Violet Cyber System Loaded"
introSub.TextColor3 = THEME.TEXT_ACCENT
introSub.TextSize = 11
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
loginTitle.Text = "💜 Вход в систему"
loginTitle.TextColor3 = THEME.TEXT_TITLE
loginTitle.TextSize = 16
loginTitle.Font = Enum.Font.GothamBold
loginTitle.Parent = loginFrame

local passBox = Instance.new("TextBox")
passBox.Size = UDim2.new(0.85, 0, 0, 38)
passBox.Position = UDim2.new(0.075, 0, 0.33, 0)
passBox.BackgroundColor3 = THEME.PANEL
passBox.BorderSizePixel = 0
passBox.PlaceholderText = "Введите пароль..."
passBox.PlaceholderColor3 = THEME.TEXT_MUTED
passBox.Text = ""
passBox.TextColor3 = Color3.fromRGB(255, 255, 255)
passBox.TextSize = 13
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
mainFrame.Size = UDim2.new(0, 540, 0, 340)
mainFrame.Position = UDim2.new(0.5, -270, 0.5, -170)
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
menuTitle.Text = "🔮 KAIROTECH HUB"
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

-- Панель вкладок
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -20, 0, 32)
tabContainer.Position = UDim2.new(0, 10, 0, 42)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout", tabContainer)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 4)

local function createTabBtn(text, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.158, 0, 1, 0)
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

local playerTabBtn = createTabBtn("Игрок", 1)
local babftTabBtn = createTabBtn("BABFT", 2)
local desertTabBtn = createTabBtn("Desert 🏜️", 3)
local mm2TabBtn = createTabBtn("MM2", 4)
local brookTabBtn = createTabBtn("Brook", 5)
local filesTabBtn = createTabBtn("Файлы", 6)

--------------------------------------------------------------------------------
-- 4. КОНТЕНТ ВКЛАДОК
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

--- ВКЛАДКА 1: ИГРОК ---
local playerContent = createContentFrame()
playerContent.Visible = true

local flyContainer = Instance.new("Frame")
flyContainer.Size = UDim2.new(0.99, 0, 0, 34)
flyContainer.BackgroundTransparency = 1
flyContainer.LayoutOrder = 1
flyContainer.Parent = playerContent

local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0.82, 0, 1, 0)
flyBtn.BackgroundColor3 = THEME.PANEL
flyBtn.BorderSizePixel = 0
flyBtn.Text = "   Режим Полёта:  ВЫКЛ"
flyBtn.TextColor3 = THEME.TEXT_ACCENT
flyBtn.TextSize = 11
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextXAlignment = Enum.TextXAlignment.Left
flyBtn.Parent = flyContainer
Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0, 7)

local flyArrow = Instance.new("TextButton")
flyArrow.Size = UDim2.new(0.16, 0, 1, 0)
flyArrow.Position = UDim2.new(0.84, 0, 0, 0)
flyArrow.BackgroundColor3 = THEME.BTN_OFF
flyArrow.BorderSizePixel = 0
flyArrow.Text = "⚙"
flyArrow.TextColor3 = THEME.TEXT_TITLE
flyArrow.TextSize = 12
flyArrow.Font = Enum.Font.GothamBold
flyArrow.Parent = flyContainer
Instance.new("UICorner", flyArrow).CornerRadius = UDim.new(0, 7)

local flySpeedPanel = Instance.new("Frame")
flySpeedPanel.Size = UDim2.new(0.99, 0, 0, 36)
flySpeedPanel.BackgroundColor3 = THEME.HEADER
flySpeedPanel.BorderSizePixel = 0
flySpeedPanel.Visible = false
flySpeedPanel.LayoutOrder = 2
flySpeedPanel.Parent = playerContent
Instance.new("UICorner", flySpeedPanel).CornerRadius = UDim.new(0, 7)

local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Size = UDim2.new(0.6, 0, 1, 0)
flySpeedLabel.Position = UDim2.new(0, 12, 0, 0)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.Text = "Скорость полёта:"
flySpeedLabel.TextColor3 = THEME.TEXT_MUTED
flySpeedLabel.TextSize = 11
flySpeedLabel.Font = Enum.Font.Gotham
flySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
flySpeedLabel.Parent = flySpeedPanel

local flySpeedInput = Instance.new("TextBox")
flySpeedInput.Size = UDim2.new(0.3, 0, 0.65, 0)
flySpeedInput.Position = UDim2.new(0.65, 0, 0.175, 0)
flySpeedInput.BackgroundColor3 = THEME.PANEL
flySpeedInput.BorderSizePixel = 0
flySpeedInput.Text = "50"
flySpeedInput.TextColor3 = THEME.TEXT_TITLE
flySpeedInput.TextSize = 11
flySpeedInput.Font = Enum.Font.GothamBold
flySpeedInput.Parent = flySpeedPanel
Instance.new("UICorner", flySpeedInput).CornerRadius = UDim.new(0, 5)

local walkContainer = Instance.new("Frame")
walkContainer.Size = UDim2.new(0.99, 0, 0, 34)
walkContainer.BackgroundTransparency = 1
walkContainer.LayoutOrder = 3
walkContainer.Parent = playerContent

local walkBtn = Instance.new("TextButton")
walkBtn.Size = UDim2.new(0.82, 0, 1, 0)
walkBtn.BackgroundColor3 = THEME.PANEL
walkBtn.BorderSizePixel = 0
walkBtn.Text = "   Ускорение бега:  ВЫКЛ"
walkBtn.TextColor3 = THEME.TEXT_ACCENT
walkBtn.TextSize = 11
walkBtn.Font = Enum.Font.GothamBold
walkBtn.TextXAlignment = Enum.TextXAlignment.Left
walkBtn.Parent = walkContainer
Instance.new("UICorner", walkBtn).CornerRadius = UDim.new(0, 7)

local walkArrow = Instance.new("TextButton")
walkArrow.Size = UDim2.new(0.16, 0, 1, 0)
walkArrow.Position = UDim2.new(0.84, 0, 0, 0)
walkArrow.BackgroundColor3 = THEME.BTN_OFF
walkArrow.BorderSizePixel = 0
walkArrow.Text = "⚙"
walkArrow.TextColor3 = THEME.TEXT_TITLE
walkArrow.TextSize = 12
walkArrow.Font = Enum.Font.GothamBold
walkArrow.Parent = walkContainer
Instance.new("UICorner", walkArrow).CornerRadius = UDim.new(0, 7)

local walkSpeedPanel = Instance.new("Frame")
walkSpeedPanel.Size = UDim2.new(0.99, 0, 0, 36)
walkSpeedPanel.BackgroundColor3 = THEME.HEADER
walkSpeedPanel.BorderSizePixel = 0
walkSpeedPanel.Visible = false
walkSpeedPanel.LayoutOrder = 4
walkSpeedPanel.Parent = playerContent
Instance.new("UICorner", walkSpeedPanel).CornerRadius = UDim.new(0, 7)

local walkSpeedLabel = Instance.new("TextLabel")
walkSpeedLabel.Size = UDim2.new(0.6, 0, 1, 0)
walkSpeedLabel.Position = UDim2.new(0, 12, 0, 0)
walkSpeedLabel.BackgroundTransparency = 1
walkSpeedLabel.Text = "Скорость бега:"
walkSpeedLabel.TextColor3 = THEME.TEXT_MUTED
walkSpeedLabel.TextSize = 11
walkSpeedLabel.Font = Enum.Font.Gotham
walkSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
walkSpeedLabel.Parent = walkSpeedPanel

local walkSpeedInput = Instance.new("TextBox")
walkSpeedInput.Size = UDim2.new(0.3, 0, 0.65, 0)
walkSpeedInput.Position = UDim2.new(0.65, 0, 0.175, 0)
walkSpeedInput.BackgroundColor3 = THEME.PANEL
walkSpeedInput.BorderSizePixel = 0
walkSpeedInput.Text = "50"
walkSpeedInput.TextColor3 = THEME.TEXT_TITLE
walkSpeedInput.TextSize = 11
walkSpeedInput.Font = Enum.Font.GothamBold
walkSpeedInput.Parent = walkSpeedPanel
Instance.new("UICorner", walkSpeedInput).CornerRadius = UDim.new(0, 5)

--- ВКЛАДКА 2: BABFT ---
local babftContent = createContentFrame()
local farmBtn = createToggle("Авто-Фарм золота (2.4s)", 1, babftContent)
local jesusBtn = createToggle("Бесконечный кислород", 2, babftContent)
local chestTpBtn = createToggle("Телепорт к сокровищу", 3, babftContent)
local flingBox, flingBtn = createTargetPanel("Ник для Флинга...", "💥 Флинг: ВЫКЛ", 4, babftContent)

--- ВКЛАДКА 3: DESERT ---
local desertContent = createContentFrame()
local stealEggBtn = createToggle("Украсть Яйцо (Steal Egg)", 1, desertContent)
local tpNickBox, tpNickBtn = createTargetPanel("Ник для телепорта...", "⚡ ТП к игроку", 2, desertContent)
local specBox, specBtn = createTargetPanel("Ник для наблюдения...", "👁️ Следить: ВЫКЛ", 3, desertContent)
local aimbotBtn = createToggle("🎯 Аимбот (Aimbot Lock)", 4, desertContent)
local explodeBox, explodeBtn = createTargetPanel("Ник для взрыва...", "💣 Взорвать", 5, desertContent)

--- ВКЛАДКА 4: MURDER MYSTERY 2 ---
local mm2Content = createContentFrame()
local mm2EspBtn = createToggle("ESP Ролей игроков", 1, mm2Content)
local mm2TpLobbyBtn = createToggle("Телепорт в Лобби", 2, mm2Content)

--- ВКЛАДКА 5: BROOKHAVEN ---
local brookContent = createContentFrame()
local infJumpBtn = createToggle("Бесконечный прыжок", 1, brookContent)
local tpBankBtn = createToggle("Телепорт в Банк", 2, brookContent)

--- ВКЛАДКА 6: ФАЙЛЫ (DARK DEX) ---
local filesContent = createContentFrame()

local dexBtn = Instance.new("TextButton")
dexBtn.Size = UDim2.new(0.99, 0, 0, 36)
dexBtn.BackgroundColor3 = THEME.BTN_ON
dexBtn.BorderSizePixel = 0
dexBtn.Text = "🚀 Запустить Dark Dex Explorer"
dexBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dexBtn.TextSize = 12
dexBtn.Font = Enum.Font.GothamBold
dexBtn.LayoutOrder = 1
dexBtn.Parent = filesContent
Instance.new("UICorner", dexBtn).CornerRadius = UDim.new(0, 7)

--------------------------------------------------------------------------------
-- 5. ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК
--------------------------------------------------------------------------------
local allTabs = {
	{btn = playerTabBtn, content = playerContent},
	{btn = babftTabBtn, content = babftContent},
	{btn = desertTabBtn, content = desertContent},
	{btn = mm2TabBtn, content = mm2Content},
	{btn = brookTabBtn, content = brookContent},
	{btn = filesTabBtn, content = filesContent}
}

for _, tab in ipairs(allTabs) do
	tab.btn.MouseButton1Click:Connect(function()
		for _, t in ipairs(allTabs) do
			t.content.Visible = false
			t.btn.BackgroundColor3 = THEME.BTN_OFF
			t.btn.TextColor3 = THEME.TEXT_MUTED
		end
		tab.content.Visible = true
		tab.btn.BackgroundColor3 = THEME.BTN_ON
		tab.btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	end)
end

--------------------------------------------------------------------------------
-- 6. ЛОГИКА ФУНКЦИЙ
--------------------------------------------------------------------------------
local function updateToggleVisual(btn, name, state)
	btn.Text = state and ("   " .. name .. ":  ВКЛ") or ("   " .. name .. ":  ВЫКЛ")
	btn.TextColor3 = state and THEME.SUCCESS or THEME.TEXT_ACCENT
end

-- Перетаскивание
local dragging, dragInput, dragStart, startPos
header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

flyArrow.MouseButton1Click:Connect(function() flySpeedPanel.Visible = not flySpeedPanel.Visible end)
walkArrow.MouseButton1Click:Connect(function() walkSpeedPanel.Visible = not walkSpeedPanel.Visible end)

-- Полёт
local flying = false
local flySpeed = 50
local bodyGyro, bodyVelocity

local function startFlying()
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local root = char.HumanoidRootPart

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.P = 9e4
	bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	bodyGyro.cframe = root.CFrame
	bodyGyro.Parent = root

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.velocity = Vector3.new(0, 0.1, 0)
	bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
	bodyVelocity.Parent = root

	flying = true
	updateToggleVisual(flyBtn, "Режим Полёта", true)

	task.spawn(function()
		while flying and char and root and root:FindFirstChild("BodyVelocity") do
			local camera = workspace.CurrentCamera
			local moveDir = Vector3.zero
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

			bodyGyro.cframe = camera.CFrame
			bodyVelocity.velocity = moveDir * flySpeed
			RunService.RenderStepped:Wait()
		end
	end)
end

local function stopFlying()
	flying = false
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end
	updateToggleVisual(flyBtn, "Режим Полёта", false)
end

flyBtn.MouseButton1Click:Connect(function()
	if flying then stopFlying() else startFlying() end
end)

flySpeedInput.FocusLost:Connect(function()
	local num = tonumber(flySpeedInput.Text)
	if num then flySpeed = num else flySpeedInput.Text = tostring(flySpeed) end
end)

-- Скорость
local walkHack = false
local walkSpeedVal = 50

walkBtn.MouseButton1Click:Connect(function()
	walkHack = not walkHack
	updateToggleVisual(walkBtn, "Ускорение бега", walkHack)
	
	local char = player.Character
	if char and char:FindFirstChildOfClass("Humanoid") then
		char.Humanoid.WalkSpeed = walkHack and walkSpeedVal or 16
	end
end)

walkSpeedInput.FocusLost:Connect(function()
	local num = tonumber(walkSpeedInput.Text)
	if num then
		walkSpeedVal = num
		if walkHack and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
			player.Character.Humanoid.WalkSpeed = num
		end
	else
		walkSpeedInput.Text = tostring(walkSpeedVal)
	end
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

-- DESERT: НАБЛЮДАТЬ (SPECTATE)
local spectating = false
specBtn.MouseButton1Click:Connect(function()
	spectating = not spectating
	local camera = workspace.CurrentCamera
	if spectating then
		local target = getPlayerByPartialName(specBox.Text)
		if target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") then
			camera.CameraSubject = target.Character.Humanoid
			specBtn.Text = "👁️ Следить: ВКЛ"
			specBtn.BackgroundColor3 = THEME.SUCCESS
		else
			spectating = false
			specBtn.Text = "❌ Игрок не найден"
			task.wait(1)
			specBtn.Text = "👁️ Следить: ВЫКЛ"
			specBtn.BackgroundColor3 = THEME.BTN_ON
		end
	else
		if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
			camera.CameraSubject = player.Character.Humanoid
		end
		specBtn.Text = "👁️ Следить: ВЫКЛ"
		specBtn.BackgroundColor3 = THEME.BTN_ON
	end
end)

-- DESERT: АИМБОТ
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

-- DESERT: ВЗОРВАТЬ
explodeBtn.MouseButton1Click:Connect(function()
	local target = getPlayerByPartialName(explodeBox.Text)
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		local targetPos = target.Character.HumanoidRootPart.Position
		local exp = Instance.new("Explosion")
		exp.Position = targetPos
		exp.BlastRadius = 10
		exp.BlastPressure = 500000
		exp.Parent = workspace
	end
end)

-- DESERT: УКРАСТЬ ЯЙЦО
local autoStealEgg = false
stealEggBtn.MouseButton1Click:Connect(function()
	autoStealEgg = not autoStealEgg
	updateToggleVisual(stealEggBtn, "Украсть Яйцо (Steal Egg)", autoStealEgg)

	task.spawn(function()
		while autoStealEgg do
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local root = char.HumanoidRootPart
				for _, obj in ipairs(workspace:GetDescendants()) do
					if not autoStealEgg then break end
					if obj:IsA("BasePart") and (obj.Name:lower():find("egg") or obj.Name:lower():find("яйцо")) then
						root.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
						task.wait(0.4)
						if firetouchinterest then
							firetouchinterest(root, obj, 0)
							firetouchinterest(root, obj, 1)
						end
						local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or obj.Parent:FindFirstChildOfClass("ProximityPrompt")
						if prompt and fireproximityprompt then
							fireproximityprompt(prompt)
						end
					end
				end
			end
			task.wait(1)
		end
	end)
end)

-- BABFT: ФЛИНГ ПО НИКУ
local flinging = false
flingBtn.MouseButton1Click:Connect(function()
	flinging = not flinging
	if flinging then
		flingBtn.Text = "💥 Флинг: ВКЛ"
		flingBtn.BackgroundColor3 = THEME.SUCCESS
	else
		flingBtn.Text = "💥 Флинг: ВЫКЛ"
		flingBtn.BackgroundColor3 = THEME.BTN_ON
	end

	task.spawn(function()
		while flinging do
			local target = getPlayerByPartialName(flingBox.Text)
			local char = player.Character
			if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and char and char:FindFirstChild("HumanoidRootPart") then
				local root = char.HumanoidRootPart
				local tRoot = target.Character.HumanoidRootPart

				-- Вращение и импульс для флинга
				root.Velocity = Vector3.new(999999, 999999, 999999)
				root.RotVelocity = Vector3.new(999999, 999999, 999999)
				root.CFrame = tRoot.CFrame + Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
			end
			RunService.RenderStepped:Wait()
		end
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			player.Character.HumanoidRootPart.Velocity = Vector3.zero
			player.Character.HumanoidRootPart.RotVelocity = Vector3.zero
		end
	end)
end)

-- BABFT
local autoFarm = false
farmBtn.MouseButton1Click:Connect(function()
	autoFarm = not autoFarm
	updateToggleVisual(farmBtn, "Авто-Фарм золота (2.4s)", autoFarm)

	task.spawn(function()
		while autoFarm do
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local root = char.HumanoidRootPart
				
				local antiFall = Instance.new("BodyVelocity")
				antiFall.Velocity = Vector3.new(0, 0, 0)
				antiFall.MaxForce = Vector3.new(9e9, 9e9, 9e9)
				antiFall.Parent = root

				for i = 1, 10 do
					if not autoFarm then break end
					local stage = workspace:FindFirstChild("BoatStages") and workspace.BoatStages:FindFirstChild("NormalStages") and workspace.BoatStages.NormalStages:FindFirstChild("CaveStage" .. i)
					if stage and stage:FindFirstChild("DarknessPart") then
						root.CFrame = stage.DarknessPart.CFrame
						task.wait(2.4)
					end
				end

				if autoFarm and workspace:FindFirstChild("BoatStages") and workspace.BoatStages:FindFirstChild("NormalStages") and workspace.BoatStages.NormalStages:FindFirstChild("TheEnd") then
					local theEnd = workspace.BoatStages.NormalStages.TheEnd
					if theEnd:FindFirstChild("GoldenChest") and theEnd.GoldenChest:FindFirstChild("Trigger") then
						root.CFrame = theEnd.GoldenChest.Trigger.CFrame + Vector3.new(0, 10, 0)
						task.wait(0.5)
						root.CFrame = theEnd.GoldenChest.Trigger.CFrame
						task.wait(2.4)
					end
				end
				if antiFall then antiFall:Destroy() end
			end
			task.wait(0.5)
		end
	end)
end)

local noWaterDamage = false
jesusBtn.MouseButton1Click:Connect(function()
	noWaterDamage = not noWaterDamage
	updateToggleVisual(jesusBtn, "Бесконечный кислород", noWaterDamage)

	if noWaterDamage then
		task.spawn(function()
			while noWaterDamage do
				local char = player.Character
				if char and char:FindFirstChild("WaterHealth") then
					char.WaterHealth:Destroy()
				end
				task.wait(1)
			end
		end)
	end
end)

chestTpBtn.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local endChest = workspace:FindFirstChild("BoatStages") and workspace.BoatStages:FindFirstChild("NormalStages") and workspace.BoatStages.NormalStages:FindFirstChild("TheEnd") and workspace.BoatStages.NormalStages.TheEnd:FindFirstChild("GoldenChest")
		if endChest and endChest:FindFirstChild("Trigger") then
			char.HumanoidRootPart.CFrame = endChest.Trigger.CFrame
		end
	end
end)

-- MM2
local mm2Esp = false
mm2EspBtn.MouseButton1Click:Connect(function()
	mm2Esp = not mm2Esp
	updateToggleVisual(mm2EspBtn, "ESP Ролей игроков", mm2Esp)

	task.spawn(function()
		while mm2Esp do
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local highlight = p.Character:FindFirstChild("MM2Highlight")
					if not highlight then
						highlight = Instance.new("Highlight")
						highlight.Name = "MM2Highlight"
						highlight.Parent = p.Character
					end
					
					local isMurder = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
					local isSheriff = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
					
					if isMurder then
						highlight.FillColor = Color3.fromRGB(255, 50, 50)
					elseif isSheriff then
						highlight.FillColor = Color3.fromRGB(0, 150, 255)
					else
						highlight.FillColor = Color3.fromRGB(50, 255, 120)
					end
				end
			end
			task.wait(1)
		end
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Character and p.Character:FindFirstChild("MM2Highlight") then
				p.Character.MM2Highlight:Destroy()
			end
		end
	end)
end)

mm2TpLobbyBtn.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(-108, 138, -12)
	end
end)

-- BROOKHAVEN
local infJump = false
infJumpBtn.MouseButton1Click:Connect(function()
	infJump = not infJump
	updateToggleVisual(infJumpBtn, "Бесконечный прыжок", infJump)
end)

UserInputService.JumpRequest:Connect(function()
	if infJump then
		local char = player.Character
		if char and char:FindFirstChildOfClass("Humanoid") then
			char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

tpBankBtn.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(-24, 3, -130)
	end
end)

-- ФАЙЛЫ: DARK DEX
dexBtn.MouseButton1Click:Connect(function()
	dexBtn.Text = "⏳ Загрузка Dark Dex..."
	dexBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
	
	task.spawn(function()
		local success, err = pcall(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/perfectusmim1/darkdex/refs/heads/main/darkdexp"))()
		end)
		
		if success then
			dexBtn.Text = "✅ Dark Dex Запущен!"
			dexBtn.BackgroundColor3 = THEME.SUCCESS
		else
			dexBtn.Text = "❌ Ошибка загрузки"
			dexBtn.BackgroundColor3 = Color3.fromRGB(230, 50, 50)
			warn("Dark Dex Load Error: " .. tostring(err))
		end
		
		task.wait(2)
		dexBtn.Text = "🚀 Запустить Dark Dex Explorer"
		dexBtn.BackgroundColor3 = THEME.BTN_ON
	end)
end)

--------------------------------------------------------------------------------
-- 7. ЗАПУСК И АНИМАЦИИ
--------------------------------------------------------------------------------
TweenService:Create(introCard, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
TweenService:Create(introStroke, TweenInfo.new(0.5), {Transparency = 0}):Play()
TweenService:Create(introTitle, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
TweenService:Create(introSub, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

task.delay(1.5, function()
	TweenService:Create(introCard, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
	TweenService:Create(introStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
	TweenService:Create(introTitle, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
	TweenService:Create(introSub, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
	task.wait(0.4)
	introCard:Destroy()
	loginFrame.Visible = true
end)

local function checkPassword()
	if passBox.Text == "2200" then
		loginFrame:Destroy()
		mainFrame.Visible = true
	else
		passBox.Text = ""
		passBox.PlaceholderText = "Неверный пароль!"
		task.wait(1)
		passBox.PlaceholderText = "Введите пароль..."
	end
end

submitBtn.MouseButton1Click:Connect(checkPassword)
passBox.FocusLost:Connect(function(enter) if enter then checkPassword() end end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.RightShift and mainFrame and mainFrame.Parent then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

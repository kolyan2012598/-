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

--------------------------------------------------------------------------------
-- 1. ИНТРО (Минималистичное и стильное)
--------------------------------------------------------------------------------
local introCard = Instance.new("Frame")
introCard.Size = UDim2.new(0, 280, 0, 90)
introCard.Position = UDim2.new(0.5, -140, 0.4, -45)
introCard.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
introCard.BorderSizePixel = 0
introCard.BackgroundTransparency = 1
introCard.Parent = screenGui

Instance.new("UICorner", introCard).CornerRadius = UDim.new(0, 12)
local introStroke = Instance.new("UIStroke", introCard)
introStroke.Color = Color3.fromRGB(0, 195, 255)
introStroke.Thickness = 1.5
introStroke.Transparency = 1

local introTitle = Instance.new("TextLabel")
introTitle.Size = UDim2.new(1, 0, 0, 40)
introTitle.Position = UDim2.new(0, 0, 0.15, 0)
introTitle.BackgroundTransparency = 1
introTitle.Text = "K A I R O T E C H"
introTitle.TextColor3 = Color3.fromRGB(0, 195, 255)
introTitle.TextSize = 22
introTitle.Font = Enum.Font.GothamBold
introTitle.TextTransparency = 1
introTitle.Parent = introCard

local introSub = Instance.new("TextLabel")
introSub.Size = UDim2.new(1, 0, 0, 20)
introSub.Position = UDim2.new(0, 0, 0.6, 0)
introSub.BackgroundTransparency = 1
introSub.Text = "Modern Interface System Loaded"
introSub.TextColor3 = Color3.fromRGB(160, 160, 175)
introSub.TextSize = 11
introSub.Font = Enum.Font.Gotham
introSub.TextTransparency = 1
introSub.Parent = introCard

--------------------------------------------------------------------------------
-- 2. АВТОРИЗАЦИЯ
--------------------------------------------------------------------------------
local loginFrame = Instance.new("Frame")
loginFrame.Size = UDim2.new(0, 300, 0, 170)
loginFrame.Position = UDim2.new(0.5, -150, 0.5, -85)
loginFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
loginFrame.BorderSizePixel = 0
loginFrame.Visible = false
loginFrame.Parent = screenGui

Instance.new("UICorner", loginFrame).CornerRadius = UDim.new(0, 12)
local loginStroke = Instance.new("UIStroke", loginFrame)
loginStroke.Color = Color3.fromRGB(35, 35, 48)

local loginTitle = Instance.new("TextLabel")
loginTitle.Size = UDim2.new(1, 0, 0, 40)
loginTitle.BackgroundTransparency = 1
loginTitle.Text = "Вход в систему"
loginTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
loginTitle.TextSize = 16
loginTitle.Font = Enum.Font.GothamBold
loginTitle.Parent = loginFrame

local passBox = Instance.new("TextBox")
passBox.Size = UDim2.new(0.85, 0, 0, 36)
passBox.Position = UDim2.new(0.075, 0, 0.32, 0)
passBox.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
passBox.BorderSizePixel = 0
passBox.PlaceholderText = "Введите пароль..."
passBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
passBox.Text = ""
passBox.TextColor3 = Color3.fromRGB(255, 255, 255)
passBox.TextSize = 13
passBox.Font = Enum.Font.Gotham
passBox.Parent = loginFrame

Instance.new("UICorner", passBox).CornerRadius = UDim.new(0, 8)

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(0.85, 0, 0, 36)
submitBtn.Position = UDim2.new(0.075, 0, 0.65, 0)
submitBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
submitBtn.BorderSizePixel = 0
submitBtn.Text = "Войти"
submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
submitBtn.TextSize = 13
submitBtn.Font = Enum.Font.GothamBold
submitBtn.Parent = loginFrame

Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0, 8)

--------------------------------------------------------------------------------
-- 3. ГЛАВНОЕ МЕНЮ (Вкладки СВЕРХУ)
--------------------------------------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 480, 0, 310)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -155)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(0, 170, 255)
mainStroke.Thickness = 1.2

-- Шапка
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 34)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
header.BorderSizePixel = 0
header.Parent = mainFrame

local menuTitle = Instance.new("TextLabel")
menuTitle.Size = UDim2.new(1, -15, 1, 0)
menuTitle.Position = UDim2.new(0, 12, 0, 0)
menuTitle.BackgroundTransparency = 1
menuTitle.Text = "KAIROTECH HUB"
menuTitle.TextColor3 = Color3.fromRGB(0, 195, 255)
menuTitle.TextSize = 12
menuTitle.Font = Enum.Font.GothamBold
menuTitle.TextXAlignment = Enum.TextXAlignment.Left
menuTitle.Parent = header

local keyHint = Instance.new("TextLabel")
keyHint.Size = UDim2.new(0.5, 0, 1, 0)
keyHint.Position = UDim2.new(0.48, 0, 0, 0)
keyHint.BackgroundTransparency = 1
keyHint.Text = "[RShift] Скрыть"
keyHint.TextColor3 = Color3.fromRGB(120, 120, 140)
keyHint.TextSize = 11
keyHint.Font = Enum.Font.Gotham
keyHint.TextXAlignment = Enum.TextXAlignment.Right
keyHint.Parent = header

-- Горизонтальная панель вкладок (СВЕРХУ)
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -20, 0, 32)
tabContainer.Position = UDim2.new(0, 10, 0, 40)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout", tabContainer)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 6)

local function createTabBtn(text, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.235, 0, 1, 0)
	btn.BackgroundColor3 = (order == 1) and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(24, 24, 32)
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = (order == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 180)
	btn.TextSize = 11
	btn.Font = Enum.Font.GothamBold
	btn.LayoutOrder = order
	btn.Parent = tabContainer
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

local playerTabBtn = createTabBtn("Игрок", 1)
local babftTabBtn = createTabBtn("BABFT", 2)
local mm2TabBtn = createTabBtn("MM2", 3)
local brookTabBtn = createTabBtn("Brookhaven", 4)

--------------------------------------------------------------------------------
-- 4. КОНТЕНТ ВКЛАДОК
--------------------------------------------------------------------------------
local function createContentFrame()
	local frame = Instance.new("ScrollingFrame")
	frame.Size = UDim2.new(1, -20, 1, -85)
	frame.Position = UDim2.new(0, 10, 0, 78)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.ScrollBarThickness = 3
	frame.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
	frame.Visible = false
	frame.Parent = mainFrame
	
	local list = Instance.new("UIListLayout", frame)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0, 6)
	return frame
end

--- ВКЛАДКА 1: ИГРОК ---
local playerContent = createContentFrame()
playerContent.Visible = true

-- Вспомогательный конструктор элементов интерфейса
local function createToggle(text, order, parent)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.99, 0, 0, 34)
	btn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
	btn.BorderSizePixel = 0
	btn.Text = "   " .. text .. ":  ВЫКЛ"
	btn.TextColor3 = Color3.fromRGB(180, 180, 190)
	btn.TextSize = 11
	btn.Font = Enum.Font.GothamBold
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.LayoutOrder = order
	btn.Parent = parent
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

-- Полёт
local flyContainer = Instance.new("Frame")
flyContainer.Size = UDim2.new(0.99, 0, 0, 34)
flyContainer.BackgroundTransparency = 1
flyContainer.LayoutOrder = 1
flyContainer.Parent = playerContent

local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0.82, 0, 1, 0)
flyBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
flyBtn.BorderSizePixel = 0
flyBtn.Text = "   Режим Полёта:  ВЫКЛ"
flyBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
flyBtn.TextSize = 11
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextXAlignment = Enum.TextXAlignment.Left
flyBtn.Parent = flyContainer
Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0, 6)

local flyArrow = Instance.new("TextButton")
flyArrow.Size = UDim2.new(0.16, 0, 1, 0)
flyArrow.Position = UDim2.new(0.84, 0, 0, 0)
flyArrow.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
flyArrow.BorderSizePixel = 0
flyArrow.Text = "⚙"
flyArrow.TextColor3 = Color3.fromRGB(0, 170, 255)
flyArrow.TextSize = 12
flyArrow.Font = Enum.Font.GothamBold
flyArrow.Parent = flyContainer
Instance.new("UICorner", flyArrow).CornerRadius = UDim.new(0, 6)

local flySpeedPanel = Instance.new("Frame")
flySpeedPanel.Size = UDim2.new(0.99, 0, 0, 36)
flySpeedPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
flySpeedPanel.BorderSizePixel = 0
flySpeedPanel.Visible = false
flySpeedPanel.LayoutOrder = 2
flySpeedPanel.Parent = playerContent
Instance.new("UICorner", flySpeedPanel).CornerRadius = UDim.new(0, 6)

local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Size = UDim2.new(0.6, 0, 1, 0)
flySpeedLabel.Position = UDim2.new(0, 12, 0, 0)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.Text = "Скорость полёта:"
flySpeedLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
flySpeedLabel.TextSize = 11
flySpeedLabel.Font = Enum.Font.Gotham
flySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
flySpeedLabel.Parent = flySpeedPanel

local flySpeedInput = Instance.new("TextBox")
flySpeedInput.Size = UDim2.new(0.3, 0, 0.65, 0)
flySpeedInput.Position = UDim2.new(0.65, 0, 0.175, 0)
flySpeedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
flySpeedInput.BorderSizePixel = 0
flySpeedInput.Text = "50"
flySpeedInput.TextColor3 = Color3.fromRGB(0, 195, 255)
flySpeedInput.TextSize = 11
flySpeedInput.Font = Enum.Font.GothamBold
flySpeedInput.Parent = flySpeedPanel
Instance.new("UICorner", flySpeedInput).CornerRadius = UDim.new(0, 4)

-- Бег
local walkContainer = Instance.new("Frame")
walkContainer.Size = UDim2.new(0.99, 0, 0, 34)
walkContainer.BackgroundTransparency = 1
walkContainer.LayoutOrder = 3
walkContainer.Parent = playerContent

local walkBtn = Instance.new("TextButton")
walkBtn.Size = UDim2.new(0.82, 0, 1, 0)
walkBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
walkBtn.BorderSizePixel = 0
walkBtn.Text = "   Ускорение бега:  ВЫКЛ"
walkBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
walkBtn.TextSize = 11
walkBtn.Font = Enum.Font.GothamBold
walkBtn.TextXAlignment = Enum.TextXAlignment.Left
walkBtn.Parent = walkContainer
Instance.new("UICorner", walkBtn).CornerRadius = UDim.new(0, 6)

local walkArrow = Instance.new("TextButton")
walkArrow.Size = UDim2.new(0.16, 0, 1, 0)
walkArrow.Position = UDim2.new(0.84, 0, 0, 0)
walkArrow.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
walkArrow.BorderSizePixel = 0
walkArrow.Text = "⚙"
walkArrow.TextColor3 = Color3.fromRGB(0, 170, 255)
walkArrow.TextSize = 12
walkArrow.Font = Enum.Font.GothamBold
walkArrow.Parent = walkContainer
Instance.new("UICorner", walkArrow).CornerRadius = UDim.new(0, 6)

local walkSpeedPanel = Instance.new("Frame")
walkSpeedPanel.Size = UDim2.new(0.99, 0, 0, 36)
walkSpeedPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
walkSpeedPanel.BorderSizePixel = 0
walkSpeedPanel.Visible = false
walkSpeedPanel.LayoutOrder = 4
walkSpeedPanel.Parent = playerContent
Instance.new("UICorner", walkSpeedPanel).CornerRadius = UDim.new(0, 6)

local walkSpeedLabel = Instance.new("TextLabel")
walkSpeedLabel.Size = UDim2.new(0.6, 0, 1, 0)
walkSpeedLabel.Position = UDim2.new(0, 12, 0, 0)
walkSpeedLabel.BackgroundTransparency = 1
walkSpeedLabel.Text = "Скорость бега:"
walkSpeedLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
walkSpeedLabel.TextSize = 11
walkSpeedLabel.Font = Enum.Font.Gotham
walkSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
walkSpeedLabel.Parent = walkSpeedPanel

local walkSpeedInput = Instance.new("TextBox")
walkSpeedInput.Size = UDim2.new(0.3, 0, 0.65, 0)
walkSpeedInput.Position = UDim2.new(0.65, 0, 0.175, 0)
walkSpeedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
walkSpeedInput.BorderSizePixel = 0
walkSpeedInput.Text = "50"
walkSpeedInput.TextColor3 = Color3.fromRGB(0, 195, 255)
walkSpeedInput.TextSize = 11
walkSpeedInput.Font = Enum.Font.GothamBold
walkSpeedInput.Parent = walkSpeedPanel
Instance.new("UICorner", walkSpeedInput).CornerRadius = UDim.new(0, 4)


--- ВКЛАДКА 2: BABFT ---
local babftContent = createContentFrame()
local farmBtn = createToggle("Авто-Фарм золота (2.4s)", 1, babftContent)
local jesusBtn = createToggle("Бесконечный кислород", 2, babftContent)
local chestTpBtn = createToggle("Телепорт к сокровищу", 3, babftContent)


--- ВКЛАДКА 3: MURDER MYSTERY 2 ---
local mm2Content = createContentFrame()
local mm2EspBtn = createToggle("ESP Ролей игроков", 1, mm2Content)
local mm2TpLobbyBtn = createToggle("Телепорт в Лобби", 2, mm2Content)


--- ВКЛАДКА 4: BROOKHAVEN ---
local brookContent = createContentFrame()
local infJumpBtn = createToggle("Бесконечный прыжок", 1, brookContent)
local tpBankBtn = createToggle("Телепорт в Банк", 2, brookContent)

--------------------------------------------------------------------------------
-- 5. ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК
--------------------------------------------------------------------------------
local allTabs = {
	{btn = playerTabBtn, content = playerContent},
	{btn = babftTabBtn, content = babftContent},
	{btn = mm2TabBtn, content = mm2Content},
	{btn = brookTabBtn, content = brookContent}
}

for _, tab in ipairs(allTabs) do
	tab.btn.MouseButton1Click:Connect(function()
		for _, t in ipairs(allTabs) do
			t.content.Visible = false
			t.btn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
			t.btn.TextColor3 = Color3.fromRGB(160, 160, 180)
		end
		tab.content.Visible = true
		tab.btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		tab.btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	end)
end

--------------------------------------------------------------------------------
-- 6. ЛОГИКА ФУНКЦИЙ
--------------------------------------------------------------------------------

-- Вспомогательное обновление внешнего вида переключателей
local function updateToggleVisual(btn, name, state)
	btn.Text = state and ("   " .. name .. ":  ВКЛ") or ("   " .. name .. ":  ВЫКЛ")
	btn.TextColor3 = state and Color3.fromRGB(0, 230, 130) or Color3.fromRGB(180, 180, 190)
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

-- Выпадающие меню настроек
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

--------------------------------------------------------------------------------
-- 7. ЗАПУСК
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

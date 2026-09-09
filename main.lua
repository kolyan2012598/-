local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("KairoTechUI") then
	playerGui.KairoTechUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KairoTechUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999
screenGui.Parent = playerGui

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

-- Главный контейнер
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 520, 0, 420)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -210)
mainFrame.BackgroundColor3 = THEME.BG
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 10
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = THEME.BORDER
mainStroke.Thickness = 1.5

-- Шапка
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 38)
header.BackgroundColor3 = THEME.HEADER
header.BorderSizePixel = 0
header.ZIndex = 11
header.Parent = mainFrame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local menuTitle = Instance.new("TextLabel")
menuTitle.Size = UDim2.new(0.8, 0, 1, 0)
menuTitle.Position = UDim2.new(0, 12, 0, 0)
menuTitle.BackgroundTransparency = 1
menuTitle.Text = "⚡ BABFT & PLAYER HUB ⚡"
menuTitle.TextColor3 = THEME.TEXT_TITLE
menuTitle.TextSize = 13
menuTitle.Font = Enum.Font.GothamBold
menuTitle.TextXAlignment = Enum.TextXAlignment.Left
menuTitle.ZIndex = 12
menuTitle.Parent = header

-- Переключатель вкладок
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -20, 0, 34)
tabContainer.Position = UDim2.new(0, 10, 0, 44)
tabContainer.BackgroundTransparency = 1
tabContainer.ZIndex = 12
tabContainer.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout", tabContainer)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 8)

local function createTabBtn(text, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.5, -4, 1, 0)
	btn.BackgroundColor3 = (order == 1) and THEME.BTN_ON or THEME.BTN_OFF
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = (order == 1) and Color3.fromRGB(255, 255, 255) or THEME.TEXT_MUTED
	btn.TextSize = 11
	btn.Font = Enum.Font.GothamBold
	btn.LayoutOrder = order
	btn.ZIndex = 13
	btn.Parent = tabContainer
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

local tabBtns = {
	createTabBtn("Игрок 🏃", 1),
	createTabBtn("Построй Корабль 🛶", 2)
}

local function createContentFrame()
	local frame = Instance.new("ScrollingFrame")
	frame.Size = UDim2.new(1, -20, 1, -92)
	frame.Position = UDim2.new(0, 10, 0, 84)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.ScrollBarThickness = 3
	frame.Visible = false
	frame.ZIndex = 12
	frame.Parent = mainFrame
	
	local list = Instance.new("UIListLayout", frame)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0, 6)
	return frame
end

local function createToggle(text, order, parent)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.98, 0, 0, 34)
	btn.BackgroundColor3 = THEME.PANEL
	btn.BorderSizePixel = 0
	btn.Text = "   " .. text .. ":  ВЫКЛ"
	btn.TextColor3 = THEME.TEXT_ACCENT
	btn.TextSize = 11
	btn.Font = Enum.Font.GothamBold
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.LayoutOrder = order
	btn.ZIndex = 14
	btn.Parent = parent
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

local function createInputPanel(placeholderText, actionText, order, parent)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0.98, 0, 0, 36)
	container.BackgroundColor3 = THEME.PANEL
	container.BorderSizePixel = 0
	container.LayoutOrder = order
	container.ZIndex = 14
	container.Parent = parent
	Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

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
	box.ZIndex = 15
	box.Parent = container
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.32, 0, 0.7, 0)
	btn.Position = UDim2.new(0.66, 0, 0.15, 0)
	btn.BackgroundColor3 = THEME.BTN_ON
	btn.BorderSizePixel = 0
	btn.Text = actionText
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 10
	btn.Font = Enum.Font.GothamBold
	btn.ZIndex = 15
	btn.Parent = container
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

	return box, btn
end

local tabsContent = {createContentFrame(), createContentFrame()}
tabsContent[1].Visible = true

for idx, btn in ipairs(tabBtns) do
	btn.Activated:Connect(function()
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

local function updateToggleVisual(btn, name, state)
	btn.Text = state and ("   " .. name .. ":  ВКЛ") or ("   " .. name .. ":  ВЫКЛ")
	btn.TextColor3 = state and THEME.SUCCESS or THEME.TEXT_ACCENT
end

--------------------------------------------------------------------------------
-- 🟢 РАЗДЕЛ 1: ИГРОК (7 ФУНКЦИЙ)
--------------------------------------------------------------------------------

-- 1. Noclip
local noclip = false
local noclipBtn = createToggle("1. Noclip (Проход сквозь стены)", 1, tabsContent[1])
noclipBtn.Activated:Connect(function()
	noclip = not noclip
	updateToggleVisual(noclipBtn, "1. Noclip (Проход сквозь стены)", noclip)
end)
RunService.Stepped:Connect(function()
	if noclip and player.Character then
		for _, part in ipairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
	end
end)

-- 2. Fly (Полёт)
local flying = false
local flySpeed = 50
local flyBtn = createToggle("2. Fly (Полёт на клавиши)", 2, tabsContent[1])
flyBtn.Activated:Connect(function()
	flying = not flying
	updateToggleVisual(flyBtn, "2. Fly (Полёт на клавиши)", flying)
	task.spawn(function()
		while flying do
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local hrp = char.HumanoidRootPart
				local cam = workspace.CurrentCamera
				local moveDir = Vector3.new()
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
				hrp.Velocity = moveDir * flySpeed
			end
			task.wait(0.01)
		end
	end)
end)

-- 3. Infinite Jump
local infJump = false
local infJumpBtn = createToggle("3. Infinite Jump (Бесконечный прыжок)", 3, tabsContent[1])
infJumpBtn.Activated:Connect(function()
	infJump = not infJump
	updateToggleVisual(infJumpBtn, "3. Infinite Jump (Бесконечный прыжок)", infJump)
end)
UserInputService.JumpRequest:Connect(function()
	if infJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- 4. ESP Players
local espActive = false
local espBtn = createToggle("4. ESP Игроков (Подсветка)", 4, tabsContent[1])
espBtn.Activated:Connect(function()
	espActive = not espActive
	updateToggleVisual(espBtn, "4. ESP Игроков (Подсветка)", espActive)
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			if espActive then
				if not p.Character:FindFirstChild("KairoHighlight") then
					local hl = Instance.new("Highlight")
					hl.Name = "KairoHighlight"
					hl.FillColor = Color3.fromRGB(168, 85, 247)
					hl.Parent = p.Character
				end
			else
				if p.Character:FindFirstChild("KairoHighlight") then p.Character.KairoHighlight:Destroy() end
			end
		end
	end
end)

-- 5. Fullbright
local fullbright = false
local fbBtn = createToggle("5. Fullbright (Без темноты)", 5, tabsContent[1])
fbBtn.Activated:Connect(function()
	fullbright = not fullbright
	updateToggleVisual(fbBtn, "5. Fullbright (Без темноты)", fullbright)
	Lighting.Brightness = fullbright and 2 or 1
	Lighting.ClockTime = fullbright and 14 or 12
	Lighting.GlobalShadows = not fullbright
end)

-- 6. Изменение скорости
local speedBox, speedBtn = createInputPanel("Скорость (напр. 50)", "6. Установить скорость", 6, tabsContent[1])
speedBtn.Activated:Connect(function()
	local val = tonumber(speedBox.Text)
	if val and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = val
	end
end)

-- 7. Изменение высоты прыжка
local jumpBox, jumpBtn = createInputPanel("Сила прыжка (напр. 100)", "7. Установить прыжок", 7, tabsContent[1])
jumpBtn.Activated:Connect(function()
	local val = tonumber(jumpBox.Text)
	if val and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		player.Character:FindFirstChildOfClass("Humanoid").JumpPower = val
	end
end)

--------------------------------------------------------------------------------
-- 🛶 РАЗДЕЛ 2: ПОСТРОЙ КОРАБЛЬ (7 ФУНКЦИЙ)
--------------------------------------------------------------------------------

-- 1. Авто-Фарм в воздухе (Hover Air Farm)
local autoGoldAir = false
local autoGoldBtn = createToggle("1. Авто-Фарм Золота (Зависнуть в воздухе)", 1, tabsContent[2])
autoGoldBtn.Activated:Connect(function()
	autoGoldAir = not autoGoldAir
	updateToggleVisual(autoGoldBtn, "1. Авто-Фарм Золота (Зависнуть в воздухе)", autoGoldAir)
	
	task.spawn(function()
		while autoGoldAir do
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local hrp = char.HumanoidRootPart
				local stages = workspace:FindFirstChild("BoatStages") and workspace.BoatStages:FindFirstChild("NormalStages")
				
				-- Держим в воздухе через BodyVelocity
				local bv = Instance.new("BodyVelocity")
				bv.MaxForce = Vector3.new(0, math.huge, 0)
				bv.Velocity = Vector3.new(0, 0, 0)
				bv.Parent = hrp
				
				if stages then
					for i = 1, 10 do
						if not autoGoldAir then break end
						local stage = stages:FindFirstChild("CaveStage" .. tostring(i))
						if stage and stage:FindFirstChild("DarknessPart") then
							-- Зависаем на 50 блоков ВЫШЕ этапа в воздухе
							hrp.CFrame = stage.DarknessPart.CFrame * CFrame.new(0, 50, 0)
							task.wait(0.4)
						end
					end
					
					-- ТП прямо к конечному сундуку
					local endChest = stages:FindFirstChild("TheEnd") and stages.TheEnd:FindFirstChild("GoldenChest")
					if endChest and endChest:FindFirstChild("Trigger") then
						hrp.CFrame = endChest.Trigger.CFrame
					end
				end
				
				bv:Destroy()
			end
			task.wait(2)
		end
	end)
end)

-- 2. Auto Build (Авто-Строительство / Сетка блоков)
local autoBuild = false
local autoBuildBtn = createToggle("2. Auto Build (Авто-Сетка блоков)", 2, tabsContent[2])
autoBuildBtn.Activated:Connect(function()
	autoBuild = not autoBuild
	updateToggleVisual(autoBuildBtn, "2. Auto Build (Авто-Сетка блоков)", autoBuild)
	
	task.spawn(function()
		if autoBuild then
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local startPos = char.HumanoidRootPart.CFrame
				for x = -2, 2 do
					for z = -2, 2 do
						if not autoBuild then break end
						local buildingFolder = workspace:FindFirstChild(player.Name .. "Boat") or workspace:FindFirstChild("Blocks")
						local item = char:FindFirstChildOfClass("Tool")
						if item and item:FindFirstChild("RF") then
							item.RF:InvokeServer(item.Name, 1, startPos * CFrame.new(x * 4, -2, z * 4))
						end
						task.wait(0.05)
					end
				end
			end
		end
	end)
end)

-- 3. Бесконечный кислород / Нет урона от воды
local noWaterDamage = false
local waterBtn = createToggle("3. Бесконечный кислород (Без урона воды)", 3, tabsContent[2])
waterBtn.Activated:Connect(function()
	noWaterDamage = not noWaterDamage
	updateToggleVisual(waterBtn, "3. Бесконечный кислород (Без урона воды)", noWaterDamage)
	for _, v in ipairs(workspace:GetDescendants()) do
		if v.Name == "Water" or v.Name == "WaterPart" then
			v.CanTouch = not noWaterDamage
		end
	end
end)

-- 4. Мгновенный телепорт к сокровищу
local chestTpBtn = createToggle("4. Мгновенный ТП к сундуку", 4, tabsContent[2])
chestTpBtn.Activated:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local endChest = workspace:FindFirstChild("BoatStages") and workspace.BoatStages:FindFirstChild("NormalStages") and workspace.BoatStages.NormalStages:FindFirstChild("TheEnd") and workspace.BoatStages.NormalStages.TheEnd:FindFirstChild("GoldenChest")
		if endChest and endChest:FindFirstChild("Trigger") then
			char.HumanoidRootPart.CFrame = endChest.Trigger.CFrame
		end
	end
end)

-- 5. Телепорт на свою строительную базу
local baseTpBtn = createToggle("5. Телепорт на свою базу", 5, tabsContent[2])
baseTpBtn.Activated:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		for _, zone in ipairs(workspace:FindFirstChild("BuildingZones"):GetChildren()) do
			if zone:FindFirstChild("Owner") and zone.Owner.Value == player then
				char.HumanoidRootPart.CFrame = zone.CFrame * CFrame.new(0, 5, 0)
				break
			end
		end
	end
end)

-- 6. Сохранить текущую позицию (Save Pos)
local savedCFrame = nil
local savePosBtn = createToggle("6. Сохранить позицию (Save Pos)", 6, tabsContent[2])
savePosBtn.Activated:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		savedCFrame = player.Character.HumanoidRootPart.CFrame
		savePosBtn.Text = "   6. Позиция Сохранена!"
		task.wait(1)
		savePosBtn.Text = "   6. Сохранить позицию (Save Pos): ВЫКЛ"
	end
end)

-- 7. Загрузить/Вернуться на позицию (Load Pos)
local loadPosBtn = createToggle("7. Вернуться на позицию (Load Pos)", 7, tabsContent[2])
loadPosBtn.Activated:Connect(function()
	if savedCFrame and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = savedCFrame
	end
end)

--------------------------------------------------------------------------------
-- 🖱️ ПЕРЕТАСКИВАНИЕ UI
--------------------------------------------------------------------------------
local isDragging = false
local dragOffset = Vector2.new()

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDragging = true
		local mousePos = UserInputService:GetMouseLocation()
		dragOffset = Vector2.new(mainFrame.AbsolutePosition.X - mousePos.X, mainFrame.AbsolutePosition.Y - mousePos.Y)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDragging = false
	end
end)

RunService.RenderStepped:Connect(function()
	if isDragging then
		local mousePos = UserInputService:GetMouseLocation()
		mainFrame.Position = UDim2.new(0, mousePos.X + dragOffset.X, 0, mousePos.Y + dragOffset.Y)
	end
end)

-- Нажми RightShift чтобы скрыть/показать UI
UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("KairoTechUI") then
	playerGui.KairoTechUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KairoTechUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999 -- Выводим поверх всех стандартных интерфейсов
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

local function getPlayerByPartialName(name)
	if not name or name == "" then return nil end
	name = name:lower()
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player and (p.Name:lower():find(name) or p.DisplayName:lower():find(name)) then
			return p
		end
	end
	return nil
end

-- Главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 580, 0, 400)
mainFrame.Position = UDim2.new(0.5, -290, 0.5, -200)
mainFrame.BackgroundColor3 = THEME.BG
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = false
mainFrame.ZIndex = 10
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = THEME.BORDER
mainStroke.Thickness = 1.5

-- Шапка (Зона перетаскивания)
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
menuTitle.Text = "🔮 KAIROTECH MULTIHUB (Working Click & Drag)"
menuTitle.TextColor3 = THEME.TEXT_TITLE
menuTitle.TextSize = 13
menuTitle.Font = Enum.Font.GothamBold
menuTitle.TextXAlignment = Enum.TextXAlignment.Left
menuTitle.ZIndex = 12
menuTitle.Parent = header

-- Контейнер вкладок
local tabContainer = Instance.new("ScrollingFrame")
tabContainer.Size = UDim2.new(1, -20, 0, 34)
tabContainer.Position = UDim2.new(0, 10, 0, 44)
tabContainer.BackgroundTransparency = 1
tabContainer.BorderSizePixel = 0
tabContainer.ScrollBarThickness = 2
tabContainer.CanvasSize = UDim2.new(1.5, 0, 0, 0)
tabContainer.ZIndex = 12
tabContainer.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout", tabContainer)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 6)

local function createTabBtn(text, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 105, 1, 0)
	btn.BackgroundColor3 = (order == 1) and THEME.BTN_ON or THEME.BTN_OFF
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = (order == 1) and Color3.fromRGB(255, 255, 255) or THEME.TEXT_MUTED
	btn.TextSize = 10
	btn.Font = Enum.Font.GothamBold
	btn.LayoutOrder = order
	btn.ZIndex = 13
	btn.Parent = tabContainer
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

local tabBtns = {
	createTabBtn("Игрок 🏃", 1),
	createTabBtn("Blade Ball ⚔️", 2),
	createTabBtn("Blox Fruits 🍎", 3),
	createTabBtn("Desert 🏜️", 4),
	createTabBtn("BABFT 🛶", 5)
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

local tabsContent = {}
for i = 1, #tabBtns do
	tabsContent[i] = createContentFrame()
end
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
-- 1. ИГРОК
--------------------------------------------------------------------------------
local noclip = false
local noclipBtn = createToggle("Noclip (Сквозь стены)", 1, tabsContent[1])
noclipBtn.Activated:Connect(function()
	noclip = not noclip
	updateToggleVisual(noclipBtn, "Noclip (Сквозь стены)", noclip)
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

local flying = false
local flySpeed = 50
local flyBtn = createToggle("Fly (Полёт)", 2, tabsContent[1])
flyBtn.Activated:Connect(function()
	flying = not flying
	updateToggleVisual(flyBtn, "Fly (Полёт)", flying)
	
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

local infJump = false
local infJumpBtn = createToggle("Infinite Jump", 3, tabsContent[1])
infJumpBtn.Activated:Connect(function()
	infJump = not infJump
	updateToggleVisual(infJumpBtn, "Infinite Jump", infJump)
end)

UserInputService.JumpRequest:Connect(function()
	if infJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

local speedBox, speedBtn = createInputPanel("Скорость (число)", "Применить", 4, tabsContent[1])
speedBtn.Activated:Connect(function()
	local val = tonumber(speedBox.Text)
	if val and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = val
	end
end)

--------------------------------------------------------------------------------
-- 2. BLADE BALL
--------------------------------------------------------------------------------
local autoParry = false
local bbParryBtn = createToggle("Auto Parry", 1, tabsContent[2])
bbParryBtn.Activated:Connect(function()
	autoParry = not autoParry
	updateToggleVisual(bbParryBtn, "Auto Parry", autoParry)
	
	task.spawn(function()
		while autoParry do
			local balls = workspace:FindFirstChild("Balls")
			if balls then
				for _, ball in ipairs(balls:GetChildren()) do
					if ball:IsA("BasePart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						local dist = (ball.Position - player.Character.HumanoidRootPart.Position).Magnitude
						if dist < 30 then
							VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
							task.wait(0.02)
							VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
						end
					end
				end
			end
			task.wait(0.01)
		end
	end)
end)

--------------------------------------------------------------------------------
-- 3. BLOX FRUITS
--------------------------------------------------------------------------------
local bfFarm = false
local bfFarmBtn = createToggle("Auto Farm Mobs", 1, tabsContent[3])
bfFarmBtn.Activated:Connect(function()
	bfFarm = not bfFarm
	updateToggleVisual(bfFarmBtn, "Auto Farm Mobs", bfFarm)

	task.spawn(function()
		while bfFarm do
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				for _, npc in ipairs(workspace:GetDescendants()) do
					if not bfFarm then break end
					if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 and npc:FindFirstChild("HumanoidRootPart") and npc ~= char then
						local dist = (npc.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
						if dist < 250 then
							char:PivotTo(npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4))
							VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
							task.wait(0.08)
							VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
						end
					end
				end
			end
			task.wait(0.1)
		end
	end)
end)

--------------------------------------------------------------------------------
-- 4. DESERT
--------------------------------------------------------------------------------
local tpNickBox, tpNickBtn = createInputPanel("Ник...", "⚡ ТП", 1, tabsContent[4])
tpNickBtn.Activated:Connect(function()
	local target = getPlayerByPartialName(tpNickBox.Text)
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			player.Character:PivotTo(target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0))
		end
	end
end)

--------------------------------------------------------------------------------
-- 5. BABFT
--------------------------------------------------------------------------------
local autoGold = false
local goldBtn = createToggle("Авто-Фарм золота", 1, tabsContent[5])
goldBtn.Activated:Connect(function()
	autoGold = not autoGold
	updateToggleVisual(goldBtn, "Авто-Фарм золота", autoGold)
	
	task.spawn(function()
		while autoGold do
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local stages = workspace:FindFirstChild("BoatStages") and workspace.BoatStages:FindFirstChild("NormalStages")
				if stages then
					for i = 1, 10 do
						if not autoGold then break end
						local stage = stages:FindFirstChild("CaveStage" .. tostring(i))
						if stage and stage:FindFirstChild("DarknessPart") then
							char:PivotTo(stage.DarknessPart.CFrame)
							task.wait(0.4)
						end
					end
					local endChest = stages:FindFirstChild("TheEnd") and stages.TheEnd:FindFirstChild("GoldenChest")
					if endChest and endChest:FindFirstChild("Trigger") then
						char:PivotTo(endChest.Trigger.CFrame)
					end
				end
			end
			task.wait(2)
		end
	end)
end)

--------------------------------------------------------------------------------
-- 100% РАБОЧЕЕ ПЕРЕТАСКИВАНИЕ (DRAGGING)
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

-- Клавиша RightShift для скрыть/показать
UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

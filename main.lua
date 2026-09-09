local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("KairoTechUI") then
	playerGui.KairoTechUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KairoTechUI"
screenGui.ResetOnSpawn = false
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

-- Основное окно GUI
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 560, 0, 360)
mainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
mainFrame.BackgroundColor3 = THEME.BG
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
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
menuTitle.Size = UDim2.new(0.6, 0, 1, 0)
menuTitle.Position = UDim2.new(0, 12, 0, 0)
menuTitle.BackgroundTransparency = 1
menuTitle.Text = "🔮 KAIROTECH MULTIHUB (Fixed)"
menuTitle.TextColor3 = THEME.TEXT_TITLE
menuTitle.TextSize = 13
menuTitle.Font = Enum.Font.GothamBold
menuTitle.TextXAlignment = Enum.TextXAlignment.Left
menuTitle.Parent = header

-- Контейнер вкладок
local tabContainer = Instance.new("ScrollingFrame")
tabContainer.Size = UDim2.new(1, -20, 0, 32)
tabContainer.Position = UDim2.new(0, 10, 0, 42)
tabContainer.BackgroundTransparency = 1
tabContainer.BorderSizePixel = 0
tabContainer.ScrollBarThickness = 2
tabContainer.CanvasSize = UDim2.new(1.8, 0, 0, 0)
tabContainer.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout", tabContainer)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 6)

local function createTabBtn(text, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 100, 1, 0)
	btn.BackgroundColor3 = (order == 1) and THEME.BTN_ON or THEME.BTN_OFF
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = (order == 1) and Color3.fromRGB(255, 255, 255) or THEME.TEXT_MUTED
	btn.TextSize = 10
	btn.Font = Enum.Font.GothamBold
	btn.LayoutOrder = order
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
	frame.Size = UDim2.new(1, -20, 1, -88)
	frame.Position = UDim2.new(0, 10, 0, 80)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.ScrollBarThickness = 3
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
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

local function createTargetPanel(placeholderText, actionText, order, parent)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0.99, 0, 0, 36)
	container.BackgroundColor3 = THEME.PANEL
	container.BorderSizePixel = 0
	container.LayoutOrder = order
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

local function updateToggleVisual(btn, name, state)
	btn.Text = state and ("   " .. name .. ":  ВКЛ") or ("   " .. name .. ":  ВЫКЛ")
	btn.TextColor3 = state and THEME.SUCCESS or THEME.TEXT_ACCENT
end

--------------------------------------------------------------------------------
-- ЛОГИКА ФУНКЦИЙ С ПРОВЕРКОЙ
--------------------------------------------------------------------------------

-- 1. ИГРОК: NOCLIP
local noclip = false
local noclipBtn = createToggle("Noclip (Сквозь стены)", 1, tabsContent[1])
noclipBtn.MouseButton1Click:Connect(function()
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

-- 2. BLADE BALL: AUTO PARRY (С ИСПОЛЬЗОВАНИЕМ VIRTUALUSER)
local autoParry = false
local bbParryBtn = createToggle("Auto Parry (Авто-Отбив)", 1, tabsContent[2])
bbParryBtn.MouseButton1Click:Connect(function()
	autoParry = not autoParry
	updateToggleVisual(bbParryBtn, "Auto Parry (Авто-Отбив)", autoParry)
	
	task.spawn(function()
		while autoParry do
			local balls = workspace:FindFirstChild("Balls")
			if balls then
				for _, ball in ipairs(balls:GetChildren()) do
					if ball:IsA("BasePart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						local dist = (ball.Position - player.Character.HumanoidRootPart.Position).Magnitude
						if dist < 25 then
							VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
							task.wait(0.05)
							VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
						end
					end
				end
			end
			task.wait(0.01)
		end
	end)
end)

-- 3. BLOX FRUITS: AUTO FARM MOBS
local bfFarm = false
local bfFarmBtn = createToggle("Auto Farm Mobs", 1, tabsContent[3])
bfFarmBtn.MouseButton1Click:Connect(function()
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
						if dist < 200 then
							char:PivotTo(npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
							VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
							task.wait(0.1)
							VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
						end
					end
				end
			end
			task.wait(0.2)
		end
	end)
end)

-- 4. DESERT: ТЕЛЕПОРТ И ВЗРЫВ
local tpNickBox, tpNickBtn = createTargetPanel("Ник игрока...", "⚡ ТП к игроку", 1, tabsContent[4])
tpNickBtn.MouseButton1Click:Connect(function()
	local target = getPlayerByPartialName(tpNickBox.Text)
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			player.Character:PivotTo(target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0))
		end
	end
end)

local explodeBox, explodeBtn = createTargetPanel("Ник для взрыва...", "💣 Взорвать", 2, tabsContent[4])
explodeBtn.MouseButton1Click:Connect(function()
	local target = getPlayerByPartialName(explodeBox.Text)
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		local exp = Instance.new("Explosion")
		exp.Position = target.Character.HumanoidRootPart.Position
		exp.BlastRadius = 15
		exp.Parent = workspace
	end
end)

-- 5. BABFT: ТЕЛЕПОРТ К КЛАДУ
local chestTpBtn = createToggle("Телепорт к сокровищу", 1, tabsContent[5])
chestTpBtn.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local endChest = workspace:FindFirstChild("BoatStages") and workspace.BoatStages:FindFirstChild("NormalStages") and workspace.BoatStages.NormalStages:FindFirstChild("TheEnd") and workspace.BoatStages.NormalStages.TheEnd:FindFirstChild("GoldenChest")
		if endChest and endChest:FindFirstChild("Trigger") then
			char:PivotTo(endChest.Trigger.CFrame)
		end
	end
end)

-- Перетаскивание UI
local dragging, dragInput, dragStart, startPos
header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)

header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Переключение скрытия скрипта на RightShift
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

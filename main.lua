
-- ============================================================================
-- ✨ KAIROTECH HUB — v7.4 (FIXED FOG, BUTTONS & TOGGLES)
-- ============================================================================
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

for _, gui in ipairs(playerGui:GetChildren()) do
    if gui.Name == "KairoTechUI" then
        gui:Destroy()
    end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KairoTechUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999
screenGui.Parent = playerGui

--------------------------------------------------------------------------------
-- 🎨 ТЕМЫ ОФОРМЛЕНИЯ
--------------------------------------------------------------------------------
local THEMES = {
    Purple = {
        Name = "Пурпурный Неон",
        BG = Color3.fromRGB(15, 15, 26),
        SIDEBAR = Color3.fromRGB(19, 19, 33),
        HEADER = Color3.fromRGB(22, 22, 38),
        PANEL = Color3.fromRGB(28, 28, 48),
        ACCENT_START = Color3.fromRGB(168, 85, 247),
        ACCENT_END = Color3.fromRGB(99, 102, 241),
        TEXT_TITLE = Color3.fromRGB(240, 240, 255),
        TEXT_MUTED = Color3.fromRGB(130, 135, 165),
        BORDER = Color3.fromRGB(99, 102, 241),
        SUCCESS = Color3.fromRGB(34, 197, 94),
    },
    Cyberpunk = {
        Name = "Киберпанк",
        BG = Color3.fromRGB(18, 18, 18),
        SIDEBAR = Color3.fromRGB(24, 24, 24),
        HEADER = Color3.fromRGB(30, 30, 30),
        PANEL = Color3.fromRGB(38, 38, 38),
        ACCENT_START = Color3.fromRGB(250, 204, 21),
        ACCENT_END = Color3.fromRGB(239, 68, 68),
        TEXT_TITLE = Color3.fromRGB(255, 255, 255),
        TEXT_MUTED = Color3.fromRGB(160, 160, 160),
        BORDER = Color3.fromRGB(250, 204, 21),
        SUCCESS = Color3.fromRGB(34, 197, 94),
    },
    Matrix = {
        Name = "Матрица",
        BG = Color3.fromRGB(10, 15, 10),
        SIDEBAR = Color3.fromRGB(14, 22, 14),
        HEADER = Color3.fromRGB(18, 28, 18),
        PANEL = Color3.fromRGB(22, 36, 22),
        ACCENT_START = Color3.fromRGB(34, 197, 94),
        ACCENT_END = Color3.fromRGB(16, 185, 129),
        TEXT_TITLE = Color3.fromRGB(235, 255, 235),
        TEXT_MUTED = Color3.fromRGB(110, 150, 110),
        BORDER = Color3.fromRGB(34, 197, 94),
        SUCCESS = Color3.fromRGB(74, 222, 128),
    },
    DarkMidnight = {
        Name = "Глубокая Ночь",
        BG = Color3.fromRGB(10, 14, 24),
        SIDEBAR = Color3.fromRGB(14, 20, 34),
        HEADER = Color3.fromRGB(18, 26, 44),
        PANEL = Color3.fromRGB(24, 34, 58),
        ACCENT_START = Color3.fromRGB(59, 130, 246),
        ACCENT_END = Color3.fromRGB(147, 51, 234),
        TEXT_TITLE = Color3.fromRGB(240, 245, 255),
        TEXT_MUTED = Color3.fromRGB(120, 140, 180),
        BORDER = Color3.fromRGB(59, 130, 246),
        SUCCESS = Color3.fromRGB(34, 197, 94),
    }
}

local currentThemeKey = "Purple"
local THEME = THEMES[currentThemeKey]
local menuToggleKey = Enum.KeyCode.RightShift

--------------------------------------------------------------------------------
-- 🛠 ХЕЛПЕРЫ
--------------------------------------------------------------------------------
local function round(instance, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = instance
    return c
end

local function stroke(instance, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = instance
    return s
end

local function gradient(instance)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(THEME.ACCENT_START, THEME.ACCENT_END)
    g.Parent = instance
    return g
end

local function clickAnim(btn)
    local scale = Instance.new("UIScale")
    scale.Parent = btn
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {Scale = 0.94}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.12, Enum.EasingStyle.Back), {Scale = 1}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.12), {Scale = 1}):Play()
    end)
end

--------------------------------------------------------------------------------
-- ⏳ ЭКРАН ЗАГРУЗКИ
--------------------------------------------------------------------------------
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 420, 0, 180)
loadingFrame.Position = UDim2.new(0.5, -210, 0.5, -90)
loadingFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
loadingFrame.BorderSizePixel = 0
loadingFrame.ZIndex = 200
loadingFrame.Parent = screenGui
round(loadingFrame, 18)
stroke(loadingFrame, THEME.ACCENT_START, 2, 0)

local loadTitle = Instance.new("TextLabel")
loadTitle.Size = UDim2.new(1, 0, 0, 30)
loadTitle.Position = UDim2.new(0, 0, 0, 24)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "⚡ KAIROTECH HUB v7.4"
loadTitle.TextColor3 = Color3.new(1, 1, 1)
loadTitle.TextSize = 18
loadTitle.Font = Enum.Font.GothamBold
loadTitle.ZIndex = 201
loadTitle.Parent = loadingFrame

local loadStatus = Instance.new("TextLabel")
loadStatus.Size = UDim2.new(1, 0, 0, 20)
loadStatus.Position = UDim2.new(0, 0, 0, 60)
loadStatus.BackgroundTransparency = 1
loadStatus.Text = "Инициализация..."
loadStatus.TextColor3 = Color3.fromRGB(150, 150, 180)
loadStatus.TextSize = 12
loadStatus.Font = Enum.Font.Gotham
loadStatus.ZIndex = 201
loadStatus.Parent = loadingFrame

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(1, -60, 0, 10)
barBg.Position = UDim2.new(0, 30, 0, 110)
barBg.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
barBg.BorderSizePixel = 0
barBg.ZIndex = 201
barBg.Parent = loadingFrame
round(barBg, 5)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = THEME.ACCENT_START
barFill.BorderSizePixel = 0
barFill.ZIndex = 202
barFill.Parent = barBg
round(barFill, 5)
gradient(barFill)

local loadPercent = Instance.new("TextLabel")
loadPercent.Size = UDim2.new(1, 0, 0, 20)
loadPercent.Position = UDim2.new(0, 0, 0, 135)
loadPercent.BackgroundTransparency = 1
loadPercent.Text = "0%"
loadPercent.TextColor3 = THEME.ACCENT_START
loadPercent.TextSize = 13
loadPercent.Font = Enum.Font.GothamBold
loadPercent.ZIndex = 201
loadPercent.Parent = loadingFrame

--------------------------------------------------------------------------------
-- 📱 ГЛАВНОЕ ОКНО
--------------------------------------------------------------------------------
local WINDOW_W, WINDOW_H = 700, 480
local SIDEBAR_W = 180
local HEADER_H = 46

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, WINDOW_W, 0, WINDOW_H)
mainFrame.Position = UDim2.new(0.5, -WINDOW_W / 2, 0.5, -WINDOW_H / 2)
mainFrame.BackgroundColor3 = THEME.BG
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ZIndex = 10
mainFrame.Parent = screenGui
round(mainFrame, 16)
stroke(mainFrame, THEME.BORDER, 1.5, 0)

-- Перетаскивание
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
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

--------------------------------------------------------------------------------
-- 📂 ЛЕВАЯ ПАНЕЛЬ (SIDEBAR)
--------------------------------------------------------------------------------
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, 0)
sidebar.BackgroundColor3 = THEME.SIDEBAR
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 11
sidebar.Parent = mainFrame
round(sidebar, 16)

local brandTitle = Instance.new("TextLabel")
brandTitle.Size = UDim2.new(1, 0, 0, 36)
brandTitle.Position = UDim2.new(0, 0, 0, 12)
brandTitle.BackgroundTransparency = 1
brandTitle.Text = "KAIROTECH"
brandTitle.TextColor3 = THEME.TEXT_TITLE
brandTitle.TextSize = 14
brandTitle.Font = Enum.Font.GothamBold
brandTitle.ZIndex = 12
brandTitle.Parent = sidebar

local brandSub = Instance.new("TextLabel")
brandSub.Size = UDim2.new(1, 0, 0, 14)
brandSub.Position = UDim2.new(0, 0, 0, 30)
brandSub.BackgroundTransparency = 1
brandSub.Text = "v7.4 Ultimate"
brandSub.TextColor3 = THEME.TEXT_MUTED
brandSub.TextSize = 9
brandSub.Font = Enum.Font.Gotham
brandSub.ZIndex = 12
brandSub.Parent = sidebar

--------------------------------------------------------------------------------
-- 💻 ПРАВАЯ ОБЛАСТЬ И СТРАНИЦЫ
--------------------------------------------------------------------------------
local topHeader = Instance.new("Frame")
topHeader.Size = UDim2.new(1, -SIDEBAR_W, 0, HEADER_H)
topHeader.Position = UDim2.new(0, SIDEBAR_W, 0, 0)
topHeader.BackgroundColor3 = THEME.HEADER
topHeader.BorderSizePixel = 0
topHeader.ZIndex = 11
topHeader.Parent = mainFrame
round(topHeader, 16)

local topHeaderPatch = Instance.new("Frame")
topHeaderPatch.Size = UDim2.new(1, 0, 0, 10)
topHeaderPatch.Position = UDim2.new(0, 0, 1, -10)
topHeaderPatch.BackgroundColor3 = THEME.HEADER
topHeaderPatch.BorderSizePixel = 0
topHeaderPatch.ZIndex = 11
topHeaderPatch.Parent = topHeader

local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, -20, 0, 2)
headerLine.Position = UDim2.new(0, 10, 1, -2)
headerLine.BackgroundColor3 = Color3.new(1, 1, 1)
headerLine.BorderSizePixel = 0
headerLine.ZIndex = 12
headerLine.Parent = topHeader
gradient(headerLine)

local activeTabName = Instance.new("TextLabel")
activeTabName.Size = UDim2.new(0.7, 0, 1, 0)
activeTabName.Position = UDim2.new(0, 16, 0, 0)
activeTabName.BackgroundTransparency = 1
activeTabName.Text = "👤 Игрок & Полет"
activeTabName.TextColor3 = THEME.TEXT_TITLE
activeTabName.TextSize = 13
activeTabName.Font = Enum.Font.GothamBold
activeTabName.TextXAlignment = Enum.TextXAlignment.Left
activeTabName.ZIndex = 12
activeTabName.Parent = topHeader

local closeBtn = Instance.new("TextButton")
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.Position = UDim2.new(1, -12, 0.5, 0)
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.ZIndex = 12
closeBtn.AutoButtonColor = false
closeBtn.Parent = topHeader
round(closeBtn, 99)
clickAnim(closeBtn)

closeBtn.Activated:Connect(function()
    screenGui:Destroy()
end)

local contentHolder = Instance.new("Frame")
contentHolder.Size = UDim2.new(1, -SIDEBAR_W, 1, -HEADER_H)
contentHolder.Position = UDim2.new(0, SIDEBAR_W, 0, HEADER_H)
contentHolder.BackgroundTransparency = 1
contentHolder.ZIndex = 11
contentHolder.Parent = mainFrame

local function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ZIndex = 11
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarThickness = 4
    page.Parent = contentHolder
    
    local layout = Instance.new("UIListLayout")
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = page
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 16)
    padding.Parent = page
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 30)
    end)
    
    return page
end

local pages = { createPage(), createPage(), createPage(), createPage() }
pages[1].Visible = true

local tabButtons = {}
local tabData = {
    {Name = "👤 Игрок", Title = "👤 Игрок & Полет"},
    {Name = "🛶 Корабль", Title = "🛶 Постройка Корабля (BoatHub)"},
    {Name = "🔥 Флинг", Title = "🔥 Мощный Флинг (Улучшенный)"},
    {Name = "⚙️ Настройки", Title = "⚙️ Темы, Туман и Параметры"}
}

for i, data in ipairs(tabData) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 155, 0, 36)
    tabBtn.Position = UDim2.new(0, 12, 0, 56 + (i - 1) * 44)
    tabBtn.BackgroundColor3 = (i == 1) and THEME.PANEL or Color3.fromRGB(15, 15, 26)
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = data.Name
    tabBtn.TextColor3 = (i == 1) and THEME.TEXT_TITLE or THEME.TEXT_MUTED
    tabBtn.TextSize = 12
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.AutoButtonColor = false
    tabBtn.ZIndex = 12
    tabBtn.Parent = sidebar
    round(tabBtn, 8)
    stroke(tabBtn, THEME.BORDER, 1, (i == 1) and 0.2 or 0.8)
    clickAnim(tabBtn)

    table.insert(tabButtons, tabBtn)

    tabBtn.Activated:Connect(function()
        for idx, p in ipairs(pages) do p.Visible = (idx == i) end
        for idx, b in ipairs(tabButtons) do
            b.BackgroundColor3 = (idx == i) and THEME.PANEL or Color3.fromRGB(15, 15, 26)
            b.TextColor3 = (idx == i) and THEME.TEXT_TITLE or THEME.TEXT_MUTED
            b.UIStroke.Transparency = (idx == i) and 0.2 or 0.8
        end
        activeTabName.Text = data.Title
    end)
end

--------------------------------------------------------------------------------
-- 🎛️ ХЕЛПЕРЫ ЭЛЕМЕНТОВ
--------------------------------------------------------------------------------
local function createToggle(parent, title, subtitle, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -24, 0, 46)
    card.BackgroundColor3 = THEME.PANEL
    card.BorderSizePixel = 0
    card.ZIndex = 12
    card.Parent = parent
    round(card, 10)
    stroke(card, THEME.BORDER, 1, 0.5)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -70, 0, 18)
    titleLbl.Position = UDim2.new(0, 12, 0, 6)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = THEME.TEXT_TITLE
    titleLbl.TextSize = 12
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 13
    titleLbl.Parent = card

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -70, 0, 14)
    subLbl.Position = UDim2.new(0, 12, 0, 24)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = subtitle
    subLbl.TextColor3 = THEME.TEXT_MUTED
    subLbl.TextSize = 10
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.ZIndex = 13
    subLbl.Parent = card

    local switchBtn = Instance.new("TextButton")
    switchBtn.AnchorPoint = Vector2.new(1, 0.5)
    switchBtn.Position = UDim2.new(1, -12, 0.5, 0)
    switchBtn.Size = UDim2.new(0, 42, 0, 22)
    switchBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
    switchBtn.BorderSizePixel = 0
    switchBtn.Text = ""
    switchBtn.AutoButtonColor = false
    switchBtn.ZIndex = 13
    switchBtn.Parent = card
    round(switchBtn, 11)

    local dot = Instance.new("Frame")
    dot.Position = UDim2.new(0, 3, 0.5, -8)
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.BackgroundColor3 = THEME.TEXT_MUTED
    dot.BorderSizePixel = 0
    dot.ZIndex = 14
    dot.Parent = switchBtn
    round(dot, 99)

    local state = false
    switchBtn.Activated:Connect(function()
        state = not state
        local targetColor = state and THEME.SUCCESS or Color3.fromRGB(45, 45, 70)
        local dotColor = state and Color3.new(1, 1, 1) or THEME.TEXT_MUTED
        local dotPos = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        TweenService:Create(switchBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(dot, TweenInfo.new(0.2), {BackgroundColor3 = dotColor, Position = dotPos}):Play()
        callback(state)
    end)
end

local function createButton(parent, title, subtitle, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -24, 0, 46)
    card.BackgroundColor3 = THEME.PANEL
    card.BorderSizePixel = 0
    card.ZIndex = 12
    card.Parent = parent
    round(card, 10)
    stroke(card, THEME.BORDER, 1, 0.5)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -120, 0, 18)
    titleLbl.Position = UDim2.new(0, 12, 0, 6)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = THEME.TEXT_TITLE
    titleLbl.TextSize = 12
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 13
    titleLbl.Parent = card

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -120, 0, 14)
    subLbl.Position = UDim2.new(0, 12, 0, 24)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = subtitle
    subLbl.TextColor3 = THEME.TEXT_MUTED
    subLbl.TextSize = 10
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.ZIndex = 13
    subLbl.Parent = card

    local btn = Instance.new("TextButton")
    btn.AnchorPoint = Vector2.new(1, 0.5)
    btn.Position = UDim2.new(1, -12, 0.5, 0)
    btn.Size = UDim2.new(0, 96, 0, 26)
    btn.BackgroundColor3 = THEME.ACCENT_START
    btn.BorderSizePixel = 0
    btn.Text = "ВКЛ / ВЫКЛ"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 13
    btn.Parent = card
    round(btn, 6)
    clickAnim(btn)

    btn.Activated:Connect(callback)
end

--------------------------------------------------------------------------------
-- 👤 ВКЛАДКА 1: ИГРОК & ПОЛЕТ
--------------------------------------------------------------------------------
local playerFlyEnabled = false
local function setPlayerFlyActive(state)
    playerFlyEnabled = state
    task.spawn(function()
        while playerFlyEnabled do
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bv = hrp:FindFirstChild("KairoFlyBV") or Instance.new("BodyVelocity")
                bv.Name = "KairoFlyBV"
                bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                bv.Parent = hrp

                local bg = hrp:FindFirstChild("KairoFlyBG") or Instance.new("BodyGyro")
                bg.Name = "KairoFlyBG"
                bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
                bg.Parent = hrp

                while playerFlyEnabled and hrp.Parent do
                    local cam = Workspace.CurrentCamera
                    local moveDir = Vector3.new()
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
                    
                    bv.Velocity = moveDir * 55
                    bg.CFrame = cam.CFrame
                    RunService.RenderStepped:Wait()
                end
                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
            end
            task.wait(0.2)
        end
    end)
end

createToggle(pages[1], "Полёт Игрока (Fly)", "Свободный полет (Клавиша F)", function(enabled)
    setPlayerFlyActive(enabled)
end)

local noclipConn = nil
createToggle(pages[1], "Ноклип (Noclip)", "Проход сквозь любые преграды", function(enabled)
    if enabled then
        noclipConn = RunService.Stepped:Connect(function()
            local char = player.Character
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() end
    end
end)

createButton(pages[1], "Телепорт к Сундуку", "Мгновенный сбор ежедневного сундука", function()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local chest = Workspace:FindFirstChild("Chest", true) or Workspace:FindFirstChild("NormalChest", true)
        if chest and chest:IsA("Model") and chest.PrimaryPart then
            hrp.CFrame = chest.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
        elseif chest and chest:IsA("BasePart") then
            hrp.CFrame = chest.CFrame + Vector3.new(0, 3, 0)
        end
    end
end)

--------------------------------------------------------------------------------
-- 🛶 ВКЛАДКА 2: ПОСТРОЙКА КОРАБЛЯ (BOAT HUB)
--------------------------------------------------------------------------------
local boatFlyEnabled = false
local boatSpeed = 75

createToggle(pages[2], "Полет на Корабле / Транспорте", "Поворот за камерой (Клавиша E)", function(enabled)
    boatFlyEnabled = enabled
end)

RunService.RenderStepped:Connect(function()
    if not boatFlyEnabled then return end
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") and char.Humanoid.SeatPart then
        local vehicle = char.Humanoid.SeatPart.Parent
        local root = vehicle and (vehicle.PrimaryPart or vehicle:FindFirstChildWhichIsA("BasePart"))
        if root then
            local cam = Workspace.CurrentCamera
            local moveDir = Vector3.new()
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            
            root.AssemblyLinearVelocity = moveDir * boatSpeed
            root.CFrame = CFrame.new(root.Position, root.Position + Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z))
        end
    end
end)

createButton(pages[2], "Авто-Фарм Золота (End Stage)", "Телепорт к финишу для фарма золота", function()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part.Name == "GoldenTreasure" or part.Name == "EndRegion" or part.Name == "Stage" then
                if part:IsA("Model") and part.PrimaryPart then
                    hrp.CFrame = part.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
                    break
                elseif part:IsA("BasePart") then
                    hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                    break
                end
            end
        end
    end
end)

createButton(pages[2], "Снять Коллизию с Корабля", "Корабль пролетает сквозь стены и скалы", function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") and char.Humanoid.SeatPart then
        local vehicle = char.Humanoid.SeatPart.Parent
        if vehicle then
            for _, p in ipairs(vehicle:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
end)

--------------------------------------------------------------------------------
-- 🔥 ВКЛАДКА 3: МОЩНЫЙ ФЛИНГ (УЛУЧШЕННЫЙ)
--------------------------------------------------------------------------------
local flingActive = false
createToggle(pages[3], "Ультимативный Вихрь (Fling Aura)", "Раскидывает всех игроков вокруг вас", function(enabled)
    flingActive = enabled
    task.spawn(function()
        while flingActive do
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local vel = hrp.AssemblyLinearVelocity
                hrp.AssemblyLinearVelocity = Vector3.new(999999, 999999, 999999)
                RunService.RenderStepped:Wait()
                if hrp and hrp.Parent then
                    hrp.AssemblyLinearVelocity = vel
                end
            end
            task.wait(0.1)
        end
    end)
end)

createButton(pages[3], "Флингнуть Всех на Сервере", "Разогнать всех игроков бешеной скоростью", function()
    task.spawn(function()
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local oldPos = hrp.CFrame
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local otherHrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                if otherHrp then
                    for i = 1, 8 do
                        hrp.CFrame = otherHrp.CFrame
                        hrp.AssemblyLinearVelocity = Vector3.new(500000, 500000, 500000)
                        task.wait(0.02)
                    end
                end
            end
        end
        hrp.CFrame = oldPos
    end)
end)

--------------------------------------------------------------------------------
-- ⚙️ ВКЛАДКА 4: НАСТРОЙКИ (ФОГ, ТЕМЫ И ФУНКЦИИ)
--------------------------------------------------------------------------------
-- Исправленный туман через FogEnd / FogStart и включение Atmosphere
createToggle(pages[4], "Плотный Туман (Fog)", "Кинематографичный туман в игре", function(enabled)
    if enabled then
        Lighting.FogEnd = 300
        Lighting.FogStart = 10
        Lighting.FogColor = Color3.fromRGB(150, 150, 180)
        
        -- Также проверяем и включаем Atmosphere для красивого тумана если он есть в игре
        local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if not atmosphere then
            atmosphere = Instance.new("Atmosphere")
            atmosphere.Parent = Lighting
        end
        atmosphere.Density = 0.4
        atmosphere.Haze = 3
    else
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmosphere then
            atmosphere.Density = 0
        end
    end
end)

createButton(pages[4], "Снять Ограничение FPS", "Разблокировка максимального FPS", function()
    if setfpscap then setfpscap(999) end
end)

createButton(pages[4], "Полный Fullbright (Ночное Видение)", "Удаление темноты на всех картах", function()
    Lighting.Brightness = 3
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
end)

createButton(pages[4], "Тема: Пурпурный Неон", "Установить неоновую фиолетовую тему", function()
    currentThemeKey = "Purple"
    THEME = THEMES[currentThemeKey]
    mainFrame.BackgroundColor3 = THEME.BG
    sidebar.BackgroundColor3 = THEME.SIDEBAR
    topHeader.BackgroundColor3 = THEME.HEADER
end)

createButton(pages[4], "Тема: Киберпанк", "Установить желто-красную тему", function()
    currentThemeKey = "Cyberpunk"
    THEME = THEMES[currentThemeKey]
    mainFrame.BackgroundColor3 = THEME.BG
    sidebar.BackgroundColor3 = THEME.SIDEBAR
    topHeader.BackgroundColor3 = THEME.HEADER
end)

createButton(pages[4], "Тема: Матрица", "Установить хакерскую зеленую тему", function()
    currentThemeKey = "Matrix"
    THEME = THEMES[currentThemeKey]
    mainFrame.BackgroundColor3 = THEME.BG
    sidebar.BackgroundColor3 = THEME.SIDEBAR
    topHeader.BackgroundColor3 = THEME.HEADER
end)

createButton(pages[4], "Тема: Глубокая Ночь", "Установить темную синюю тему", function()
    currentThemeKey = "DarkMidnight"
    THEME = THEMES[currentThemeKey]
    mainFrame.BackgroundColor3 = THEME.BG
    sidebar.BackgroundColor3 = THEME.SIDEBAR
    topHeader.BackgroundColor3 = THEME.HEADER
end)

--------------------------------------------------------------------------------
-- ⌨️ ГОРЯЧИЕ КЛАВИШИ
--------------------------------------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == menuToggleKey then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

--------------------------------------------------------------------------------
-- 🚀 АНИМАЦИЯ ЗАГРУЗКИ
--------------------------------------------------------------------------------
task.spawn(function()
    local steps = {
        {text = "Загрузка ядра интерфейса...", progress = 0.3, time = 0.3},
        {text = "Инициализация модулей полета и тумана...", progress = 0.6, time = 0.35},
        {text = "Применение тем и настроек окружения...", progress = 0.9, time = 0.3},
        {text = "Готово! Запуск KairoTech Hub...", progress = 1.0, time = 0.25},
    }
    
    for _, step in ipairs(steps) do
        loadStatus.Text = step.text
        loadPercent.Text = math.floor(step.progress * 100) .. "%"
        TweenService:Create(barFill, TweenInfo.new(step.time, Enum.EasingStyle.Quad), {Size = UDim2.new(step.progress, 0, 1, 0)}):Play()
        task.wait(step.time)
    end
    
    local fadeInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad)
    TweenService:Create(loadingFrame, fadeInfo, {BackgroundTransparency = 1}):Play()
    for _, child in ipairs(loadingFrame:GetDescendants()) do
        if child:IsA("TextLabel") then
            TweenService:Create(child, fadeInfo, {TextTransparency = 1}):Play()
        elseif child:IsA("Frame") then
            TweenService:Create(child, fadeInfo, {BackgroundTransparency = 1}):Play()
        end
    end
    
    task.wait(0.4)
    loadingFrame:Destroy()
    
    mainFrame.Visible = true
    print("✨ KairoTech Hub v7.4 запущен! Нажми RightShift для скрытия/показа меню.")
end)

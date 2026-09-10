-- ============================================================================
-- ✨ KAIROTECH HUB — v4.9 (FULL SCRIPT WITH ADVANCED UI, SETTINGS & VEHICLE/PLAYER FLY)
-- ============================================================================
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
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

--------------------------------------------------------------------------------
-- 🎨 ТЕМЫ ОФОРМЛЕНИЯ
--------------------------------------------------------------------------------
local THEMES = {
    Purple = {
        Name = "Пурпурная (Neon Purple)",
        BG = Color3.fromRGB(15, 15, 26),
        HEADER = Color3.fromRGB(22, 22, 38),
        PANEL = Color3.fromRGB(28, 28, 48),
        ACCENT_START = Color3.fromRGB(168, 85, 247),
        ACCENT_END = Color3.fromRGB(99, 102, 241),
        TEXT_TITLE = Color3.fromRGB(240, 240, 255),
        TEXT_ACCENT = Color3.fromRGB(192, 132, 252),
        TEXT_MUTED = Color3.fromRGB(130, 135, 165),
        BORDER = Color3.fromRGB(99, 102, 241),
        SUCCESS = Color3.fromRGB(34, 197, 94),
    },
    Matrix = {
        Name = "Матрица (Matrix Green)",
        BG = Color3.fromRGB(10, 20, 15),
        HEADER = Color3.fromRGB(15, 32, 22),
        PANEL = Color3.fromRGB(20, 45, 30),
        ACCENT_START = Color3.fromRGB(34, 197, 94),
        ACCENT_END = Color3.fromRGB(16, 185, 129),
        TEXT_TITLE = Color3.fromRGB(220, 255, 230),
        TEXT_ACCENT = Color3.fromRGB(74, 222, 128),
        TEXT_MUTED = Color3.fromRGB(110, 150, 125),
        BORDER = Color3.fromRGB(34, 197, 94),
        SUCCESS = Color3.fromRGB(34, 197, 94),
    },
    Cyber = {
        Name = "Киберпанк (Cyber Yellow)",
        BG = Color3.fromRGB(24, 20, 10),
        HEADER = Color3.fromRGB(36, 30, 14),
        PANEL = Color3.fromRGB(48, 40, 20),
        ACCENT_START = Color3.fromRGB(234, 179, 8),
        ACCENT_END = Color3.fromRGB(249, 115, 22),
        TEXT_TITLE = Color3.fromRGB(255, 248, 220),
        TEXT_ACCENT = Color3.fromRGB(250, 204, 21),
        TEXT_MUTED = Color3.fromRGB(165, 145, 110),
        BORDER = Color3.fromRGB(234, 179, 8),
        SUCCESS = Color3.fromRGB(34, 197, 94),
    },
    Crimson = {
        Name = "Кровавая (Crimson Blood)",
        BG = Color3.fromRGB(24, 12, 12),
        HEADER = Color3.fromRGB(36, 18, 18),
        PANEL = Color3.fromRGB(48, 24, 24),
        ACCENT_START = Color3.fromRGB(239, 68, 68),
        ACCENT_END = Color3.fromRGB(185, 28, 28),
        TEXT_TITLE = Color3.fromRGB(255, 235, 235),
        TEXT_ACCENT = Color3.fromRGB(248, 113, 113),
        TEXT_MUTED = Color3.fromRGB(165, 120, 120),
        BORDER = Color3.fromRGB(239, 68, 68),
        SUCCESS = Color3.fromRGB(34, 197, 94),
    }
}

local currentThemeKey = "Purple"
local THEME = THEMES[currentThemeKey]

local hubCustomTitle = "KAIROTECH HUB"
local menuToggleKey = Enum.KeyCode.RightShift
local boatFlyKeybind = Enum.KeyCode.E
local playerFlyKeybind = Enum.KeyCode.F

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
    s.Name = "DynamicStroke"
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = instance
    return s
end

local function gradient(instance)
    local g = Instance.new("UIGradient")
    g.Name = "DynamicGradient"
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
-- 📱 ГЛАВНОЕ ОКНО
--------------------------------------------------------------------------------
local WINDOW_W, WINDOW_H = 640, 480
local HEADER_H = 48
local TABBAR_H = 54

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, WINDOW_W, 0, WINDOW_H)
mainFrame.Position = UDim2.new(0.5, -WINDOW_W / 2, 0.5, -WINDOW_H / 2)
mainFrame.BackgroundColor3 = THEME.BG
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 10
mainFrame.Parent = screenGui
round(mainFrame, 14)
stroke(mainFrame, THEME.BORDER, 1.5, 0)

-- Перетаскивание окна
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
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
-- 📌 ШАПКА
--------------------------------------------------------------------------------
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, HEADER_H)
header.BackgroundColor3 = THEME.HEADER
header.BorderSizePixel = 0
header.ZIndex = 11
header.Parent = mainFrame
round(header, 14)

local headerPatch = Instance.new("Frame")
headerPatch.Size = UDim2.new(1, 0, 0, 14)
headerPatch.Position = UDim2.new(0, 0, 1, -14)
headerPatch.BackgroundColor3 = THEME.HEADER
headerPatch.BorderSizePixel = 0
headerPatch.ZIndex = 12
headerPatch.Parent = header

local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, -24, 0, 2)
headerLine.Position = UDim2.new(0, 12, 1, -2)
headerLine.BackgroundColor3 = Color3.new(1, 1, 1)
headerLine.BorderSizePixel = 0
headerLine.ZIndex = 13
headerLine.Parent = header
gradient(headerLine)

local logoCircle = Instance.new("Frame")
logoCircle.Position = UDim2.new(0, 12, 0.5, -14)
logoCircle.Size = UDim2.new(0, 28, 0, 28)
logoCircle.BackgroundColor3 = Color3.new(1, 1, 1)
logoCircle.BorderSizePixel = 0
logoCircle.ZIndex = 13
logoCircle.Parent = header
round(logoCircle, 99)
gradient(logoCircle)

local logoIcon = Instance.new("TextLabel")
logoIcon.Size = UDim2.new(1, 0, 1, 0)
logoIcon.BackgroundTransparency = 1
logoIcon.Text = "🔮"
logoIcon.TextSize = 14
logoIcon.ZIndex = 14
logoIcon.Parent = logoCircle

local menuTitle = Instance.new("TextLabel")
menuTitle.Size = UDim2.new(0.6, 0, 0, 20)
menuTitle.Position = UDim2.new(0, 48, 0, 7)
menuTitle.BackgroundTransparency = 1
menuTitle.Text = hubCustomTitle
menuTitle.TextColor3 = THEME.TEXT_TITLE
menuTitle.TextSize = 14
menuTitle.Font = Enum.Font.GothamBold
menuTitle.TextXAlignment = Enum.TextXAlignment.Left
menuTitle.ZIndex = 13
menuTitle.Parent = header

local menuSubtitle = Instance.new("TextLabel")
menuSubtitle.Size = UDim2.new(0.6, 0, 0, 12)
menuSubtitle.Position = UDim2.new(0, 48, 0, 28)
menuSubtitle.BackgroundTransparency = 1
menuSubtitle.Text = "v4.9 • KairoTech Hub"
menuSubtitle.TextColor3 = THEME.TEXT_MUTED
menuSubtitle.TextSize = 9
menuSubtitle.Font = Enum.Font.Gotham
menuSubtitle.TextXAlignment = Enum.TextXAlignment.Left
menuSubtitle.ZIndex = 13
menuSubtitle.Parent = header

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
closeBtn.ZIndex = 13
closeBtn.AutoButtonColor = false
closeBtn.Parent = header
round(closeBtn, 99)
clickAnim(closeBtn)

closeBtn.Activated:Connect(function()
    screenGui:Destroy()
end)

local settingsHeaderBtn = Instance.new("TextButton")
settingsHeaderBtn.AnchorPoint = Vector2.new(1, 0.5)
settingsHeaderBtn.Position = UDim2.new(1, -44, 0.5, 0)
settingsHeaderBtn.Size = UDim2.new(0, 26, 0, 26)
settingsHeaderBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
settingsHeaderBtn.BorderSizePixel = 0
settingsHeaderBtn.Text = "⚙️"
settingsHeaderBtn.TextSize = 12
settingsHeaderBtn.ZIndex = 13
settingsHeaderBtn.AutoButtonColor = false
settingsHeaderBtn.Parent = header
round(settingsHeaderBtn, 99)
clickAnim(settingsHeaderBtn)

--------------------------------------------------------------------------------
-- 📑 ПАНЕЛЬ ВКЛАДОК (TABBAR)
--------------------------------------------------------------------------------
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, TABBAR_H)
tabBar.Position = UDim2.new(0, 0, 0, HEADER_H)
tabBar.BackgroundTransparency = 1
tabBar.ZIndex = 11
tabBar.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.Padding = UDim.new(0, 8)
tabLayout.Parent = tabBar

--------------------------------------------------------------------------------
-- 📄 СТРАНИЦЫ
--------------------------------------------------------------------------------
local contentHolder = Instance.new("Frame")
contentHolder.Size = UDim2.new(1, 0, 1, -(HEADER_H + TABBAR_H))
contentHolder.Position = UDim2.new(0, 0, 0, HEADER_H + TABBAR_H)
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
    layout.Padding = UDim.new(0, 10)
    layout.Parent = page
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 15)
    padding.Parent = page
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 30)
    end)
    
    return page
end

local pages = {
    createPage(), -- 1. Игрок
    createPage(), -- 2. Корабль
    createPage(), -- 3. Настройки
}
pages[1].Visible = true

-- Создание кнопок вкладок
local tabButtons = {}
local tabNames = {"👤 Игрок", "🛶 Корабль", "⚙️ Настройки"}

for i, name in ipairs(tabNames) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 180, 0, 36)
    tabBtn.BackgroundColor3 = (i == 1) and THEME.PANEL or Color3.fromRGB(22, 22, 35)
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = name
    tabBtn.TextColor3 = (i == 1) and THEME.TEXT_TITLE or THEME.TEXT_MUTED
    tabBtn.TextSize = 12
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.AutoButtonColor = false
    tabBtn.ZIndex = 12
    tabBtn.Parent = tabBar
    round(tabBtn, 8)
    stroke(tabBtn, THEME.BORDER, 1, (i == 1) and 0.2 or 0.8)
    clickAnim(tabBtn)

    table.insert(tabButtons, tabBtn)

    tabBtn.Activated:Connect(function()
        for idx, p in ipairs(pages) do
            p.Visible = (idx == i)
        end
        for idx, b in ipairs(tabButtons) do
            b.BackgroundColor3 = (idx == i) and THEME.PANEL or Color3.fromRGB(22, 22, 35)
            b.TextColor3 = (idx == i) and THEME.TEXT_TITLE or THEME.TEXT_MUTED
        end
    end)
end

-- Кнопка шестеренки в шапке тоже переключает на вкладку Настройки
settingsHeaderBtn.Activated:Connect(function()
    for idx, p in ipairs(pages) do
        p.Visible = (idx == 3)
    end
    for idx, b in ipairs(tabButtons) do
        b.BackgroundColor3 = (idx == 3) and THEME.PANEL or Color3.fromRGB(22, 22, 35)
        b.TextColor3 = (idx == 3) and THEME.TEXT_TITLE or THEME.TEXT_MUTED
    end
end)

--------------------------------------------------------------------------------
-- 🎛️ ХЕЛПЕР СОЗДАНИЯ ПЕРЕКЛЮЧАТЕЛЕЙ (TOGGLE)
--------------------------------------------------------------------------------
local function createToggle(parent, title, subtitle, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -30, 0, 56)
    card.BackgroundColor3 = THEME.PANEL
    card.BorderSizePixel = 0
    card.ZIndex = 12
    card.Parent = parent
    round(card, 10)
    stroke(card, THEME.BORDER, 1, 0.5)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -70, 0, 20)
    titleLbl.Position = UDim2.new(0, 14, 0, 9)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = THEME.TEXT_TITLE
    titleLbl.TextSize = 13
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 13
    titleLbl.Parent = card

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -70, 0, 16)
    subLbl.Position = UDim2.new(0, 14, 0, 29)
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
    switchBtn.Position = UDim2.new(1, -14, 0.5, 0)
    switchBtn.Size = UDim2.new(0, 44, 0, 24)
    switchBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
    switchBtn.BorderSizePixel = 0
    switchBtn.Text = ""
    switchBtn.AutoButtonColor = false
    switchBtn.ZIndex = 13
    switchBtn.Parent = card
    round(switchBtn, 12)

    local dot = Instance.new("Frame")
    dot.Position = UDim2.new(0, 3, 0.5, -9)
    dot.Size = UDim2.new(0, 18, 0, 18)
    dot.BackgroundColor3 = THEME.TEXT_MUTED
    dot.BorderSizePixel = 0
    dot.ZIndex = 14
    dot.Parent = switchBtn
    round(dot, 99)

    local state = false
    local function updateState(newState)
        state = newState
        local targetColor = state and THEME.SUCCESS or Color3.fromRGB(45, 45, 70)
        local dotColor = state and Color3.new(1, 1, 1) or THEME.TEXT_MUTED
        local dotPos = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)

        TweenService:Create(switchBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(dot, TweenInfo.new(0.2), {BackgroundColor3 = dotColor, Position = dotPos}):Play()

        callback(state)
    end

    switchBtn.Activated:Connect(function()
        updateState(not state)
    end)

    return {
        GetState = function() return state end,
        SetState = updateState
    }
end

--------------------------------------------------------------------------------
-- 👤 РАЗДЕЛ 1: ИГРОК (Полёт, Бинд, Ноклип, Флинг, Свет и Туман)
--------------------------------------------------------------------------------

local playerFlyEnabled = false

local function setPlayerFlyActive(state)
    playerFlyEnabled = state
    task.spawn(function()
        while playerFlyEnabled do
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and humanoid then
                local bv = hrp:FindFirstChild("KairoPlayerFlyBV") or Instance.new("BodyVelocity")
                bv.Name = "KairoPlayerFlyBV"
                bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                bv.Parent = hrp

                local bg = hrp:FindFirstChild("KairoPlayerFlyBG") or Instance.new("BodyGyro")
                bg.Name = "KairoPlayerFlyBG"
                bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
                bg.Parent = hrp

                while playerFlyEnabled and hrp.Parent do
                    local cam = Workspace.CurrentCamera
                    local moveDir = Vector3.new(0, 0, 0)
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end

                    bv.Velocity = moveDir * 50
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

-- 1. Переключатель полета игрока
local playerFlyToggle = createToggle(pages[1], "1. Полёт Игрока (Fly)", "Свободный полет персонажа в воздухе", function(enabled)
    setPlayerFlyActive(enabled)
end)

-- 2. Бинд клавиши полета игрока
local playerFlyBindCard = Instance.new("Frame")
playerFlyBindCard.Size = UDim2.new(1, -30, 0, 75)
playerFlyBindCard.BackgroundColor3 = THEME.PANEL
playerFlyBindCard.BorderSizePixel = 0
playerFlyBindCard.ZIndex = 12
playerFlyBindCard.Parent = pages[1]
round(playerFlyBindCard, 10)
stroke(playerFlyBindCard, THEME.BORDER, 1, 0.5)

local pfBindTitleLbl = Instance.new("TextLabel")
pfBindTitleLbl.Size = UDim2.new(1, -20, 0, 20)
pfBindTitleLbl.Position = UDim2.new(0, 14, 0, 10)
pfBindTitleLbl.BackgroundTransparency = 1
pfBindTitleLbl.Text = "2. Бинд клавиши полета игрока"
pfBindTitleLbl.TextColor3 = THEME.TEXT_TITLE
pfBindTitleLbl.TextSize = 13
pfBindTitleLbl.Font = Enum.Font.GothamBold
pfBindTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
pfBindTitleLbl.ZIndex = 13
pfBindTitleLbl.Parent = playerFlyBindCard

local pfBindBtn = Instance.new("TextButton")
pfBindBtn.Size = UDim2.new(1, -28, 0, 32)
pfBindBtn.Position = UDim2.new(0, 14, 0, 34)
pfBindBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
pfBindBtn.BorderSizePixel = 0
pfBindBtn.Text = "Клавиша: F (нажми чтобы изменить)"
pfBindBtn.TextColor3 = THEME.TEXT_ACCENT
pfBindBtn.TextSize = 11
pfBindBtn.Font = Enum.Font.GothamBold
pfBindBtn.AutoButtonColor = false
pfBindBtn.ZIndex = 13
pfBindBtn.Parent = playerFlyBindCard
round(pfBindBtn, 8)
stroke(pfBindBtn, THEME.BORDER, 1, 0.5)
clickAnim(pfBindBtn)

local isListeningForPlayerFlyKey = false
pfBindBtn.Activated:Connect(function()
    if isListeningForPlayerFlyKey then return end
    isListeningForPlayerFlyKey = true
    pfBindBtn.Text = "Нажми любую клавишу..."
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gpe)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            playerFlyKeybind = input.KeyCode
            pfBindBtn.Text = "Клавиша: " .. tostring(playerFlyKeybind.Name) .. " (нажми чтобы изменить)"
            isListeningForPlayerFlyKey = false
            connection:Disconnect()
        end
    end)
end)

-- 3. НОКЛИП (Проход через стены)
local noclipConnection = nil
local function setNoclipActive(state)
    if state then
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = RunService.Stepped:Connect(function()
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

createToggle(pages[1], "3. Ноклип (Noclip)", "Проход сквозь любые стены и преграды", function(enabled)
    setNoclipActive(enabled)
end)

-- 4. Аккуратный флинг (Вокруг игрока)
local flingCard = Instance.new("Frame")
flingCard.Size = UDim2.new(1, -30, 0, 95)
flingCard.BackgroundColor3 = THEME.PANEL
flingCard.BorderSizePixel = 0
flingCard.ZIndex = 12
flingCard.Parent = pages[1]
round(flingCard, 10)
stroke(flingCard, THEME.BORDER, 1, 0.5)

local flingTitleLbl = Instance.new("TextLabel")
flingTitleLbl.Size = UDim2.new(1, -20, 0, 20)
flingTitleLbl.Position = UDim2.new(0, 14, 0, 10)
flingTitleLbl.BackgroundTransparency = 1
flingTitleLbl.Text = "4. Аккуратный флинг (Вокруг игрока)"
flingTitleLbl.TextColor3 = THEME.TEXT_TITLE
flingTitleLbl.TextSize = 13
flingTitleLbl.Font = Enum.Font.GothamBold
flingTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
flingTitleLbl.ZIndex = 13
flingTitleLbl.Parent = flingCard

local targetInput = Instance.new("TextBox")
targetInput.Size = UDim2.new(1, -128, 0, 36)
targetInput.Position = UDim2.new(0, 14, 0, 44)
targetInput.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
targetInput.BorderSizePixel = 0
targetInput.PlaceholderText = "Введите ник или часть..."
targetInput.Text = ""
targetInput.TextColor3 = THEME.TEXT_TITLE
targetInput.PlaceholderColor3 = THEME.TEXT_MUTED
targetInput.TextSize = 11
targetInput.Font = Enum.Font.Gotham
targetInput.ZIndex = 13
targetInput.Parent = flingCard
round(targetInput, 8)

local flingBtn = Instance.new("TextButton")
flingBtn.Size = UDim2.new(0, 100, 0, 36)
flingBtn.AnchorPoint = Vector2.new(1, 0)
flingBtn.Position = UDim2.new(1, -14, 0, 44)
flingBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
flingBtn.BorderSizePixel = 0
flingBtn.Text = "🌀 ОРБИТА"
flingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flingBtn.TextSize = 12
flingBtn.Font = Enum.Font.GothamBold
flingBtn.AutoButtonColor = false
flingBtn.ZIndex = 13
flingBtn.Parent = flingCard
round(flingBtn, 8)
clickAnim(flingBtn)

local isFlinging = false
flingBtn.Activated:Connect(function()
    local query = targetInput.Text:lower()
    if query == "" then return end
    
    local targetChar = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and (p.Name:lower():sub(1, #query) == query or p.DisplayName:lower():sub(1, #query) == query) then
            targetChar = p.Character
            break
        end
    end
    
    if not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") then return end
    
    isFlinging = true
    task.spawn(function()
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Parent = hrp
        
        local angle = 0
        local radius = 6
        local t = 0
        while isFlinging and targetChar and targetChar:FindFirstChild("HumanoidRootPart") and t < 5 do
            local dt = RunService.RenderStepped:Wait()
            t = t + dt
            angle = angle + dt * 15
            
            local targetHRP = targetChar.HumanoidRootPart
            local offset = Vector3.new(math.cos(angle) * radius, 2, math.sin(angle) * radius)
            hrp.CFrame = CFrame.new(targetHRP.Position + offset, targetHRP.Position)
            bv.Velocity = Vector3.new(math.random(-25000, 25000), 25000, math.random(-25000, 25000))
        end
        
        if bv then bv:Destroy() end
        isFlinging = false
    end)
end)

-- 5. МЕНЕДЖЕР ОКРУЖЕНИЯ, ТУМАНА И СВЕТА
local lightingCard = Instance.new("Frame")
lightingCard.Size = UDim2.new(1, -30, 0, 310)
lightingCard.BackgroundColor3 = THEME.PANEL
lightingCard.BorderSizePixel = 0
lightingCard.ZIndex = 12
lightingCard.Parent = pages[1]
round(lightingCard, 10)
stroke(lightingCard, THEME.BORDER, 1, 0.5)

local lightTitleLbl = Instance.new("TextLabel")
lightTitleLbl.Size = UDim2.new(1, -20, 0, 20)
lightTitleLbl.Position = UDim2.new(0, 14, 0, 10)
lightTitleLbl.BackgroundTransparency = 1
lightTitleLbl.Text = "5. Настройка Света, Неба и Тумана 🌌"
lightTitleLbl.TextColor3 = THEME.TEXT_TITLE
lightTitleLbl.TextSize = 13
lightTitleLbl.Font = Enum.Font.GothamBold
lightTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
lightTitleLbl.ZIndex = 13
lightTitleLbl.Parent = lightingCard

local lightSubLbl = Instance.new("TextLabel")
lightSubLbl.Size = UDim2.new(1, -20, 0, 16)
lightSubLbl.Position = UDim2.new(0, 14, 0, 28)
lightSubLbl.BackgroundTransparency = 1
lightSubLbl.Text = "Пресеты атмосферы для эпичной графики:"
lightSubLbl.TextColor3 = THEME.TEXT_MUTED
lightSubLbl.TextSize = 10
lightSubLbl.Font = Enum.Font.Gotham
lightSubLbl.TextXAlignment = Enum.TextXAlignment.Left
lightSubLbl.ZIndex = 13
lightSubLbl.Parent = lightingCard

local presetContainer = Instance.new("Frame")
presetContainer.Size = UDim2.new(1, -28, 0, 120)
presetContainer.Position = UDim2.new(0, 14, 0, 50)
presetContainer.BackgroundTransparency = 1
presetContainer.ZIndex = 13
presetContainer.Parent = lightingCard

local pGrid = Instance.new("UIGridLayout")
pGrid.CellSize = UDim2.new(0.48, 0, 0, 32)
pGrid.CellPadding = UDim2.new(0, 8, 0, 8)
pGrid.SortOrder = Enum.SortOrder.LayoutOrder
pGrid.Parent = presetContainer

local function applyLightingPreset(name, timeOfDay, brightness, ambient, outdoorAmbient, fogColor, fogStart, fogEnd)
    Lighting.TimeOfDay = timeOfDay
    Lighting.Brightness = brightness
    Lighting.Ambient = ambient
    Lighting.OutdoorAmbient = outdoorAmbient
    Lighting.FogColor = fogColor
    Lighting.FogStart = fogStart
    Lighting.FogEnd = fogEnd
end

local presets = {
    {
        Name = "🌃 Киберпанк",
        Time = "00:00", Bright = 3.5,
        Ambient = Color3.fromRGB(80, 20, 120), Outdoor = Color3.fromRGB(40, 10, 80),
        Fog = Color3.fromRGB(45, 10, 75), FogS = 10, FogE = 400
    },
    {
        Name = "🌅 Закат в Огне",
        Time = "18:30", Bright = 2.8,
        Ambient = Color3.fromRGB(220, 90, 40), Outdoor = Color3.fromRGB(180, 50, 20),
        Fog = Color3.fromRGB(150, 40, 30), FogS = 15, FogE = 500
    },
    {
        Name = "🌌 Космический Туман",
        Time = "02:00", Bright = 2.0,
        Ambient = Color3.fromRGB(20, 40, 90), Outdoor = Color3.fromRGB(10, 20, 50),
        Fog = Color3.fromRGB(15, 25, 60), FogS = 5, FogE = 250
    },
    {
        Name = "🌿 Идеальный День",
        Time = "12:00", Bright = 2.5,
        Ambient = Color3.fromRGB(200, 200, 220), Outdoor = Color3.fromRGB(180, 190, 210),
        Fog = Color3.fromRGB(210, 220, 240), FogS = 50, FogE = 2000
    }
}

for _, pData in ipairs(presets) do
    local pBtn = Instance.new("TextButton")
    pBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    pBtn.BorderSizePixel = 0
    pBtn.Text = pData.Name
    pBtn.TextColor3 = THEME.TEXT_TITLE
    pBtn.TextSize = 10
    pBtn.Font = Enum.Font.GothamBold
    pBtn.AutoButtonColor = false
    pBtn.ZIndex = 14
    pBtn.Parent = presetContainer
    round(pBtn, 8)
    stroke(pBtn, THEME.BORDER, 1, 0.4)
    clickAnim(pBtn)
    
    pBtn.Activated:Connect(function()
        applyLightingPreset(pData.Name, pData.Time, pData.Bright, pData.Ambient, pData.Outdoor, pData.Fog, pData.FogS, pData.FogE)
    end)
end

local customFogLbl = Instance.new("TextLabel")
customFogLbl.Size = UDim2.new(1, -28, 0, 16)
customFogLbl.Position = UDim2.new(0, 14, 0, 180)
customFogLbl.BackgroundTransparency = 1
customFogLbl.Text = "Ручное управление туманом:"
customFogLbl.TextColor3 = THEME.TEXT_MUTED
customFogLbl.TextSize = 10
customFogLbl.Font = Enum.Font.GothamBold
customFogLbl.TextXAlignment = Enum.TextXAlignment.Left
customFogLbl.ZIndex = 13
customFogLbl.Parent = lightingCard

local fogRangeInput = Instance.new("TextBox")
fogRangeInput.Size = UDim2.new(1, -28, 0, 34)
fogRangeInput.Position = UDim2.new(0, 14, 0, 202)
fogRangeInput.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
fogRangeInput.BorderSizePixel = 0
fogRangeInput.PlaceholderText = "Дальность тумана (например: 300)"
fogRangeInput.Text = ""
fogRangeInput.TextColor3 = THEME.TEXT_TITLE
fogRangeInput.PlaceholderColor3 = THEME.TEXT_MUTED
fogRangeInput.TextSize = 11
fogRangeInput.Font = Enum.Font.Gotham
fogRangeInput.ZIndex = 13
fogRangeInput.Parent = lightingCard
round(fogRangeInput, 8)
stroke(fogRangeInput, THEME.BORDER, 1, 0.5)

fogRangeInput.FocusLost:Connect(function()
    local val = tonumber(fogRangeInput.Text)
    if val then Lighting.FogEnd = val end
end)

local fullBrightToggle = Instance.new("TextButton")
fullBrightToggle.Size = UDim2.new(1, -28, 0, 36)
fullBrightToggle.Position = UDim2.new(0, 14, 0, 246)
fullBrightToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
fullBrightToggle.BorderSizePixel = 0
fullBrightToggle.Text = "💡 ВКЛЮЧИТЬ FULLBRIGHT"
fullBrightToggle.TextColor3 = THEME.TEXT_ACCENT
fullBrightToggle.TextSize = 11
fullBrightToggle.Font = Enum.Font.GothamBold
fullBrightToggle.AutoButtonColor = false
fullBrightToggle.ZIndex = 13
fullBrightToggle.Parent = lightingCard
round(fullBrightToggle, 8)
stroke(fullBrightToggle, THEME.BORDER, 1, 0.5)
clickAnim(fullBrightToggle)

local isFullBright = false
fullBrightToggle.Activated:Connect(function()
    isFullBright = not isFullBright
    if isFullBright then
        fullBrightToggle.BackgroundColor3 = THEME.SUCCESS
        fullBrightToggle.TextColor3 = Color3.new(1, 1, 1)
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        fullBrightToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
        fullBrightToggle.TextColor3 = THEME.TEXT_ACCENT
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end)

--------------------------------------------------------------------------------
-- 🛶 РАЗДЕЛ 2: ПОСТРОЙ КОРАБЛЬ (ПОЛЁТ НА ТРАНСПОРТЕ / КОРАБЛЕ)
--------------------------------------------------------------------------------
local boatFlyEnabled = false
local boatSpeed = 55

local boatFlyCard = Instance.new("Frame")
boatFlyCard.Size = UDim2.new(1, -30, 0, 160)
boatFlyCard.BackgroundColor3 = THEME.PANEL
boatFlyCard.BorderSizePixel = 0
boatFlyCard.ZIndex = 12
boatFlyCard.Parent = pages[2]
round(boatFlyCard, 10)
stroke(boatFlyCard, THEME.BORDER, 1, 0.5)

local boatTitleLbl = Instance.new("TextLabel")
boatTitleLbl.Size = UDim2.new(1, -70, 0, 20)
boatTitleLbl.Position = UDim2.new(0, 14, 0, 10)
boatTitleLbl.BackgroundTransparency = 1
boatTitleLbl.Text = "1. Полёт на Корабле / Транспорте"
boatTitleLbl.TextColor3 = THEME.TEXT_TITLE
boatTitleLbl.TextSize = 13
boatTitleLbl.Font = Enum.Font.GothamBold
boatTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
boatTitleLbl.ZIndex = 13
boatTitleLbl.Parent = boatFlyCard

local boatSubLbl = Instance.new("TextLabel")
boatSubLbl.Size = UDim2.new(1, -70, 0, 16)
boatSubLbl.Position = UDim2.new(0, 14, 0, 30)
boatSubLbl.BackgroundTransparency = 1
boatSubLbl.Text = "Сядь в кресло и управляй полетом"
boatSubLbl.TextColor3 = THEME.TEXT_MUTED
boatSubLbl.TextSize = 10
boatSubLbl.Font = Enum.Font.Gotham
boatSubLbl.TextXAlignment = Enum.TextXAlignment.Left
boatSubLbl.ZIndex = 13
boatSubLbl.Parent = boatFlyCard

local boatSwitchBtn = Instance.new("TextButton")
boatSwitchBtn.AnchorPoint = Vector2.new(1, 0)
boatSwitchBtn.Position = UDim2.new(1, -14, 0, 14)
boatSwitchBtn.Size = UDim2.new(0, 44, 0, 24)
boatSwitchBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
boatSwitchBtn.BorderSizePixel = 0
boatSwitchBtn.Text = ""
boatSwitchBtn.AutoButtonColor = false
boatSwitchBtn.ZIndex = 13
boatSwitchBtn.Parent = boatFlyCard
round(boatSwitchBtn, 12)

local boatDot = Instance.new("Frame")
boatDot.Position = UDim2.new(0, 3, 0.5, -9)
boatDot.Size = UDim2.new(0, 18, 0, 18)
boatDot.BackgroundColor3 = THEME.TEXT_MUTED
boatDot.BorderSizePixel = 0
boatDot.ZIndex = 14
boatDot.Parent = boatSwitchBtn
round(boatDot, 99)

local speedInputLabel = Instance.new("TextLabel")
speedInputLabel.Size = UDim2.new(1, -28, 0, 16)
speedInputLabel.Position = UDim2.new(0, 14, 0, 62)
speedInputLabel.BackgroundTransparency = 1
speedInputLabel.Text = "Скорость полета корабля:"
speedInputLabel.TextColor3 = THEME.TEXT_MUTED
speedInputLabel.TextSize = 10
speedInputLabel.Font = Enum.Font.GothamBold
speedInputLabel.TextXAlignment = Enum.TextXAlignment.Left
speedInputLabel.ZIndex = 13
speedInputLabel.Parent = boatFlyCard

local speedTextBox = Instance.new("TextBox")
speedTextBox.Size = UDim2.new(1, -28, 0, 36)
speedTextBox.Position = UDim2.new(0, 14, 0, 84)
speedTextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
speedTextBox.BorderSizePixel = 0
speedTextBox.Text = tostring(boatSpeed)
speedTextBox.TextColor3 = THEME.TEXT_TITLE
speedTextBox.TextSize = 11
speedTextBox.Font = Enum.Font.Gotham
speedTextBox.ZIndex = 13
speedTextBox.Parent = boatFlyCard
round(speedTextBox, 8)
stroke(speedTextBox, THEME.BORDER, 1, 0.5)

speedTextBox.FocusLost:Connect(function()
    local val = tonumber(speedTextBox.Text)
    if val then boatSpeed = val end
end)

local boatActiveState = false
boatSwitchBtn.Activated:Connect(function()
    boatActiveState = not boatActiveState
    local targetColor = boatActiveState and THEME.SUCCESS or Color3.fromRGB(45, 45, 70)
    local dotColor = boatActiveState and Color3.new(1, 1, 1) or THEME.TEXT_MUTED
    local dotPos = boatActiveState and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    TweenService:Create(boatSwitchBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    TweenService:Create(boatDot, TweenInfo.new(0.2), {BackgroundColor3 = dotColor, Position = dotPos}):Play()
    boatFlyEnabled = boatActiveState
end)

-- Логика полёта корабля
RunService.RenderStepped:Connect(function()
    if not boatFlyEnabled then return end
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") and char.Humanoid.SeatPart then
        local seat = char.Humanoid.SeatPart
        local vehicle = seat.Parent
        if vehicle then
            local root = vehicle.PrimaryPart or vehicle:FindFirstChildWhichIsA("BasePart")
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
            end
        end
    end
end)

--------------------------------------------------------------------------------
-- ⚙️ РАЗДЕЛ 3: НАСТРОЙКИ И БИНДЫ
--------------------------------------------------------------------------------
local settingsCard = Instance.new("Frame")
settingsCard.Size = UDim2.new(1, -30, 0, 160)
settingsCard.BackgroundColor3 = THEME.PANEL
settingsCard.BorderSizePixel = 0
settingsCard.ZIndex = 12
settingsCard.Parent = pages[3]
round(settingsCard, 10)
stroke(settingsCard, THEME.BORDER, 1, 0.5)

local setCardTitle = Instance.new("TextLabel")
setCardTitle.Size = UDim2.new(1, -20, 0, 20)
setCardTitle.Position = UDim2.new(0, 14, 0, 10)
setCardTitle.BackgroundTransparency = 1
setCardTitle.Text = "Настройка клавиши открытия меню"
setCardTitle.TextColor3 = THEME.TEXT_TITLE
setCardTitle.TextSize = 13
setCardTitle.Font = Enum.Font.GothamBold
setCardTitle.TextXAlignment = Enum.TextXAlignment.Left
setCardTitle.ZIndex = 13
setCardTitle.Parent = settingsCard

local menuBindBtn = Instance.new("TextButton")
menuBindBtn.Size = UDim2.new(1, -28, 0, 36)
menuBindBtn.Position = UDim2.new(0, 14, 0, 40)
menuBindBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
menuBindBtn.BorderSizePixel = 0
menuBindBtn.Text = "Клавиша меню: RightShift (нажми чтобы изменить)"
menuBindBtn.TextColor3 = THEME.TEXT_ACCENT
menuBindBtn.TextSize = 11
menuBindBtn.Font = Enum.Font.GothamBold
menuBindBtn.AutoButtonColor = false
menuBindBtn.ZIndex = 13
menuBindBtn.Parent = settingsCard
round(menuBindBtn, 8)
stroke(menuBindBtn, THEME.BORDER, 1, 0.5)
clickAnim(menuBindBtn)

local isListeningForMenuKey = false
menuBindBtn.Activated:Connect(function()
    if isListeningForMenuKey then return end
    isListeningForMenuKey = true
    menuBindBtn.Text = "Нажми любую клавишу..."
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gpe)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            menuToggleKey = input.KeyCode
            menuBindBtn.Text = "Клавиша меню: " .. tostring(menuToggleKey.Name) .. " (нажми чтобы изменить)"
            isListeningForMenuKey = false
            connection:Disconnect()
        end
    end)
end)

-- Общий слушатель для горячих клавиш меню и полетов
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == menuToggleKey then
        mainFrame.Visible = not mainFrame.Visible
    elseif input.KeyCode == playerFlyKeybind then
        playerFlyEnabled = not playerFlyEnabled
        setPlayerFlyActive(playerFlyEnabled)
    end
end)

print("✨ KairoTech Hub v4.9 успешно загружен со всеми функциями и красивым меню!")

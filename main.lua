--------------------------------------------------------------------------------
-- ✨ KAIROTECH HUB — v3.6 (UI SHELL + STAGE FARM + BOAT FLY WITH SPEED)
-- Автофарм по этапам + Умный полет на корабле (Пробел = вверх, без прыжков при полете, регулировка скорости)
--------------------------------------------------------------------------------
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

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
-- 🎨 ТЕМА
--------------------------------------------------------------------------------
local THEME = {
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
}

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
-- 📱 ГЛАВНОЕ ОКНО
--------------------------------------------------------------------------------
local WINDOW_W, WINDOW_H = 500, 440
local HEADER_H = 48
local TABBAR_H = 64

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, WINDOW_W, 0, WINDOW_H)
mainFrame.Position = UDim2.new(0.5, -WINDOW_W / 2, 0.5, -WINDOW_H / 2)
mainFrame.BackgroundColor3 = THEME.BG
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 10
mainFrame.Parent = screenGui
round(mainFrame, 14)
local mainStroke = stroke(mainFrame, THEME.BORDER, 1.5, 0)

local mainScale = Instance.new("UIScale")
mainScale.Parent = mainFrame

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
menuTitle.Text = "KAIROTECH HUB"
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
menuSubtitle.Text = "v3.6 • RightShift — скрыть/показать"
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

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(239, 68, 68)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(180, 60, 60)}):Play()
end)

--------------------------------------------------------------------------------
-- 📄 СТРАНИЦЫ
--------------------------------------------------------------------------------
local contentHolder = Instance.new("Frame")
contentHolder.Size = UDim2.new(1, 0, 1, -(HEADER_H + TABBAR_H))
contentHolder.Position = UDim2.new(0, 0, 0, HEADER_H)
contentHolder.BackgroundTransparency = 1
contentHolder.ZIndex = 12
contentHolder.Parent = mainFrame

local function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ZIndex = 12
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarThickness = 4
    page.Parent = contentHolder
    
    local layout = Instance.new("UIListLayout")
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = page
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 15)
    padding.PaddingBottom = UDim.new(0, 15)
    padding.Parent = page
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 30)
    end)
    
    return page
end

local pages = {
    createPage(),
    createPage(),
}
pages[1].Visible = true

local function createEmptyPlaceholder(page, icon, title, subtitle)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -30, 0, 200)
    container.BackgroundTransparency = 1
    container.ZIndex = 13
    container.Parent = page

    local circle = Instance.new("Frame")
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    circle.Position = UDim2.new(0.5, 0, 0.35, 0)
    circle.Size = UDim2.new(0, 76, 0, 76)
    circle.BackgroundColor3 = Color3.new(1, 1, 1)
    circle.BorderSizePixel = 0
    circle.ZIndex = 13
    circle.Parent = container
    round(circle, 99)
    gradient(circle)

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(1, 0, 1, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextSize = 32
    iconLabel.ZIndex = 14
    iconLabel.Parent = circle

    local t1 = Instance.new("TextLabel")
    t1.AnchorPoint = Vector2.new(0.5, 0)
    t1.Position = UDim2.new(0.5, 0, 0.35, 52)
    t1.Size = UDim2.new(1, 0, 0, 20)
    t1.BackgroundTransparency = 1
    t1.Text = title
    t1.TextColor3 = THEME.TEXT_TITLE
    t1.TextSize = 15
    t1.Font = Enum.Font.GothamBold
    t1.ZIndex = 13
    t1.Parent = container

    local t2 = Instance.new("TextLabel")
    t2.AnchorPoint = Vector2.new(0.5, 0)
    t2.Position = UDim2.new(0.5, 0, 0.35, 76)
    t2.Size = UDim2.new(1, 0, 0, 16)
    t2.BackgroundTransparency = 1
    t2.Text = subtitle
    t2.TextColor3 = THEME.TEXT_MUTED
    t2.TextSize = 11
    t2.Font = Enum.Font.Gotham
    t2.ZIndex = 13
    t2.Parent = container
end

createEmptyPlaceholder(pages[1], "🏃", "Игрок", "Этот раздел пока пуст")

--------------------------------------------------------------------------------
-- 🎛️ СОЗДАНИЕ ПЕРЕКЛЮЧАТЕЛЕЙ (TOGGLE)
--------------------------------------------------------------------------------
local function createToggle(parent, title, subtitle, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -30, 0, 60)
    card.BackgroundColor3 = THEME.PANEL
    card.BorderSizePixel = 0
    card.ZIndex = 13
    card.Parent = parent
    round(card, 10)
    stroke(card, THEME.BORDER, 1, 0.5)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -70, 0, 20)
    titleLbl.Position = UDim2.new(0, 14, 0, 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = THEME.TEXT_TITLE
    titleLbl.TextSize = 13
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 14
    titleLbl.Parent = card

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -70, 0, 16)
    subLbl.Position = UDim2.new(0, 14, 0, 30)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = subtitle
    subLbl.TextColor3 = THEME.TEXT_MUTED
    subLbl.TextSize = 10
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.ZIndex = 14
    subLbl.Parent = card

    local switchBtn = Instance.new("TextButton")
    switchBtn.AnchorPoint = Vector2.new(1, 0.5)
    switchBtn.Position = UDim2.new(1, -14, 0.5, 0)
    switchBtn.Size = UDim2.new(0, 44, 0, 24)
    switchBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
    switchBtn.BorderSizePixel = 0
    switchBtn.Text = ""
    switchBtn.AutoButtonColor = false
    switchBtn.ZIndex = 14
    switchBtn.Parent = card
    round(switchBtn, 12)

    local dot = Instance.new("Frame")
    dot.Position = UDim2.new(0, 3, 0.5, -9)
    dot.Size = UDim2.new(0, 18, 0, 18)
    dot.BackgroundColor3 = THEME.TEXT_MUTED
    dot.BorderSizePixel = 0
    dot.ZIndex = 15
    dot.Parent = switchBtn
    round(dot, 99)

    local state = false
    switchBtn.Activated:Connect(function()
        state = not state
        local targetColor = state and THEME.SUCCESS or Color3.fromRGB(45, 45, 70)
        local dotColor = state and Color3.new(1, 1, 1) or THEME.TEXT_MUTED
        local dotPos = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)

        TweenService:Create(switchBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(dot, TweenInfo.new(0.2), {BackgroundColor3 = dotColor, Position = dotPos}):Play()

        callback(state)
    end)
end

--------------------------------------------------------------------------------
-- 1️⃣ АВТО-ФАРМ ПО ЭТАПАМ (В воздухе над этапами с задержкой)
--------------------------------------------------------------------------------
local autoGoldAir = false

createToggle(pages[2], "1. Авто-Фарм (В воздухе по этапам)", "Летит по этапам CaveStage1-10 с задержкой на каждой точке", function(enabled)
    autoGoldAir = enabled
    if not autoGoldAir then return end

    task.spawn(function()
        while autoGoldAir do
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local stages = Workspace:FindFirstChild("BoatStages") and Workspace.BoatStages:FindFirstChild("NormalStages")
                
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.Parent = hrp
                
                if stages then
                    for i = 1, 10 do
                        if not autoGoldAir then break end
                        local stage = stages:FindFirstChild("CaveStage" .. tostring(i))
                        if stage and stage:FindFirstChild("DarknessPart") then
                            local targetCFrame = stage.DarknessPart.CFrame * CFrame.new(0, 60, 0)
                            local startCFrame = hrp.CFrame
                            local t = 0
                            while t < 0.6 and autoGoldAir do
                                local dt = RunService.RenderStepped:Wait()
                                t = t + dt
                                hrp.CFrame = startCFrame:Lerp(targetCFrame, math.clamp(t / 0.6, 0, 1))
                            end
                            
                            local waitTime = 0
                            while waitTime < 1 and autoGoldAir do
                                waitTime = waitTime + RunService.RenderStepped:Wait()
                                hrp.CFrame = targetCFrame
                            end
                        end
                    end
                end
                
                if bv then bv:Destroy() end
            end
            task.wait(3)
        end
    end)
end)

--------------------------------------------------------------------------------
-- 2️⃣ ПОЛЁТ НА КОРАБЛЕ (С регулировкой скорости и отключением прыжка)
--------------------------------------------------------------------------------
local boatFlyEnabled = false
local boatSpeed = 120 -- Увеличена скорость по умолчанию

createToggle(pages[2], "2. Полёт на Корабле", "Сядь в кресло: Пробел вверх, Ctrl вниз, без прыжков при полете", function(enabled)
    boatFlyEnabled = enabled
    if not boatFlyEnabled then return end

    task.spawn(function()
        while boatFlyEnabled do
            local char = player.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            local seat = humanoid and humanoid.SeatPart
            
            if seat then
                local primaryPart = seat
                
                -- Отключаем прыжок у гуманоида, чтобы пробел поднимал вверх, а не дергал прыжком
                local oldJumpPower = humanoid.JumpPower
                local oldJumpHeight = humanoid.JumpHeight
                humanoid.JumpPower = 0
                humanoid.JumpHeight = 0
                humanoid.AutoRotate = false

                local bv = primaryPart:FindFirstChild("KairoFlyBV") or Instance.new("BodyVelocity")
                bv.Name = "KairoFlyBV"
                bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                bv.Parent = primaryPart

                local bg = primaryPart:FindFirstChild("KairoFlyBG") or Instance.new("BodyGyro")
                bg.Name = "KairoFlyBG"
                bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
                bg.Parent = primaryPart

                while boatFlyEnabled and seat.Parent and humanoid.SeatPart == seat do
                    local cam = Workspace.CurrentCamera
                    local moveDir = Vector3.new(0, 0, 0)
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDir = moveDir + cam.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDir = moveDir - cam.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDir = moveDir - cam.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDir = moveDir + cam.CFrame.RightVector
                    end
                    -- Пробел поднимает корабль вверх в абсолютных координатах мира
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDir = moveDir + Vector3.new(0, 1, 0)
                    end
                    -- Ctrl опускает вниз
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                        moveDir = moveDir - Vector3.new(0, 1, 0)
                    end

                    bv.Velocity = moveDir * boatSpeed
                    bg.CFrame = cam.CFrame
                    RunService.RenderStepped:Wait()
                end

                -- Возвращаем настройки персонажу при отключении или выходе из кресла
                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
                if humanoid then
                    humanoid.JumpPower = oldJumpPower
                    humanoid.JumpHeight = oldJumpHeight
                    humanoid.AutoRotate = true
                end
            end
            task.wait(0.3)
        end
    end)
end)

--------------------------------------------------------------------------------
-- 📑 НИЖНЯЯ ПАНЕЛЬ ВКЛАДОК
--------------------------------------------------------------------------------
local tabbar = Instance.new("Frame")
tabbar.Size = UDim2.new(1, 0, 0, TABBAR_H)
tabbar.Position = UDim2.new(0, 0, 1, -TABBAR_H)
tabbar.BackgroundColor3 = THEME.HEADER
tabbar.BorderSizePixel = 0
tabbar.ZIndex = 11
tabbar.Parent = mainFrame
round(tabbar, 14)

local tabPatch = Instance.new("Frame")
tabPatch.Size = UDim2.new(1, 0, 0, 14)
tabPatch.Position = UDim2.new(0, 0, 0, 0)
tabPatch.BackgroundColor3 = THEME.HEADER
tabPatch.BorderSizePixel = 0
tabPatch.ZIndex = 12
tabPatch.Parent = tabbar

local indicator = Instance.new("Frame")
indicator.Size = UDim2.new(0.5, -16, 0, 4)
indicator.Position = UDim2.new(0, 8, 0, 0)
indicator.BackgroundColor3 = Color3.new(1, 1, 1)
indicator.BorderSizePixel = 0
indicator.ZIndex = 14
indicator.Parent = tabbar
round(indicator, 2)
gradient(indicator)

local function createTabBtn(icon, label, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.5, -16, 1, -16)
    btn.Position = UDim2.new((order - 1) * 0.5, 8, 0, 8)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 13
    btn.Parent = tabbar
    clickAnim(btn)

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(1, 0, 0, 22)
    iconLabel.Position = UDim2.new(0, 0, 0, 3)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextSize = 17
    iconLabel.TextColor3 = THEME.TEXT_MUTED
    iconLabel.ZIndex = 14
    iconLabel.Parent = btn

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0, 14)
    textLabel.Position = UDim2.new(0, 0, 0, 29)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = label
    textLabel.TextSize = 10
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextColor3 = THEME.TEXT_MUTED
    textLabel.ZIndex = 14
    textLabel.Parent = btn

    return {btn = btn, icon = iconLabel, text = textLabel}
end

local tabBtns = {
    createTabBtn("🏃", "Игрок", 1),
    createTabBtn("🛶", "Построй Корабль", 2),
}

local activeTab = 1

local function setTabColors(idx, isActive)
    local t = tabBtns[idx]
    TweenService:Create(t.icon, TweenInfo.new(0.2), {
        TextColor3 = isActive and THEME.TEXT_TITLE or THEME.TEXT_MUTED
    }):Play()
    TweenService:Create(t.text, TweenInfo.new(0.2), {
        TextColor3 = isActive and THEME.TEXT_ACCENT or THEME.TEXT_MUTED
    }):Play()
end

setTabColors(1, true)

local function selectTab(idx)
    if activeTab == idx then return end
    activeTab = idx

    TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new((idx - 1) * 0.5, 8, 0, 0)
    }):Play()

    for i, p in ipairs(pages) do
        p.Visible = (i == idx)
    end
    
    for i = 1, #tabBtns do
        setTabColors(i, i == idx)
    end
end

for idx, t in ipairs(tabBtns) do
    t.btn.Activated:Connect(function()
        selectTab(idx)
    end)

    t.btn.MouseEnter:Connect(function()
        if activeTab ~= idx then
            TweenService:Create(t.icon, TweenInfo.new(0.15), {TextColor3 = THEME.TEXT_TITLE}):Play()
            TweenService:Create(t.text, TweenInfo.new(0.15), {TextColor3 = THEME.TEXT_TITLE}):Play()
        end
    end)
    t.btn.MouseLeave:Connect(function()
        if activeTab ~= idx then
            setTabColors(idx, false)
        end
    end)
end

--------------------------------------------------------------------------------
-- 🎬 ПОКАЗ / СКРЫТИЕ ОКНА
--------------------------------------------------------------------------------
local function setMenuVisible(visible)
    if visible then
        mainFrame.Visible = true
        mainScale.Scale = 0.85
        TweenService:Create(mainScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    else
        local t = TweenService:Create(mainScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.85})
        t.Completed:Once(function()
            mainFrame.Visible = false
        end)
        t:Play()
    end
end

closeBtn.Activated:Connect(function()
    setMenuVisible(false)
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        setMenuVisible(not mainFrame.Visible)
    end
end)

task.spawn(function()
    while screenGui.Parent do
        local a = TweenService:Create(mainStroke, TweenInfo.new(2, Enum.EasingStyle.Sine), {Thickness = 2.2})
        a:Play(); a.Completed:Wait()
        local b = TweenService:Create(mainStroke, TweenInfo.new(2, Enum.EasingStyle.Sine), {Thickness = 1.5})
        b:Play(); b.Completed:Wait()
    end
end)

mainScale.Scale = 0.85
TweenService:Create(mainScale, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()

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

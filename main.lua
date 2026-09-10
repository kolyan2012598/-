--------------------------------------------------------------------------------
-- ✨ KAIROTECH HUB — v4.4 (PLAYER FLY + TARGET FLING + BOAT FLY + CUSTOM SPEED + KEYBIND)
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
local WINDOW_W, WINDOW_H = 500, 460
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
stroke(mainFrame, THEME.BORDER, 1.5, 0)

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
menuSubtitle.Text = "v4.4 • Полный функционал"
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

--------------------------------------------------------------------------------
-- 🎛️ ХЕЛПЕР СОЗДАНИЯ ПЕРЕКЛЮЧАТЕЛЕЙ (TOGGLE)
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
-- 👤 РАЗДЕЛ 1: ИГРОК (Полёт + Флинг по нику)
--------------------------------------------------------------------------------

-- 1. Полёт игрока
local playerFlyEnabled = false
createToggle(pages[1], "1. Полёт Игрока (Fly)", "Свободный полет персонажа в воздухе", function(enabled)
    playerFlyEnabled = enabled
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
end)

-- 2. Флинг игрока по нику
local flingCard = Instance.new("Frame")
flingCard.Size = UDim2.new(1, -30, 0, 95)
flingCard.BackgroundColor3 = THEME.PANEL
flingCard.BorderSizePixel = 0
flingCard.ZIndex = 13
flingCard.Parent = pages[1]
round(flingCard, 10)
stroke(flingCard, THEME.BORDER, 1, 0.5)

local flingTitleLbl = Instance.new("TextLabel")
flingTitleLbl.Size = UDim2.new(1, -20, 0, 20)
flingTitleLbl.Position = UDim2.new(0, 14, 0, 10)
flingTitleLbl.BackgroundTransparency = 1
flingTitleLbl.Text = "2. Флинг Игрока (Раскидать по нику)"
flingTitleLbl.TextColor3 = THEME.TEXT_TITLE
flingTitleLbl.TextSize = 13
flingTitleLbl.Font = Enum.Font.GothamBold
flingTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
flingTitleLbl.ZIndex = 14
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
targetInput.ZIndex = 14
targetInput.Parent = flingCard
round(targetInput, 8)

local flingBtn = Instance.new("TextButton")
flingBtn.Size = UDim2.new(0, 100, 0, 36)
flingBtn.AnchorPoint = Vector2.new(1, 0)
flingBtn.Position = UDim2.new(1, -14, 0, 44)
flingBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
flingBtn.BorderSizePixel = 0
flingBtn.Text = "💥 ПИЗДА"
flingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flingBtn.TextSize = 12
flingBtn.Font = Enum.Font.GothamBold
flingBtn.AutoButtonColor = false
flingBtn.ZIndex = 14
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
        
        local t = 0
        while isFlinging and targetChar and targetChar:FindFirstChild("HumanoidRootPart") and t < 3 do
            local dt = RunService.RenderStepped:Wait()
            t = t + dt
            hrp.CFrame = targetChar.HumanoidRootPart.CFrame
            bv.Velocity = Vector3.new(math.random(-50000, 50000), 50000, math.random(-50000, 50000))
        end
        
        if bv then bv:Destroy() end
        isFlinging = false
    end)
end)

--------------------------------------------------------------------------------
-- 🛶 РАЗДЕЛ 2: ПОСТРОЙ КОРАБЛЬ (Полёт на корабле + Скорость + Бинд)
--------------------------------------------------------------------------------
local boatFlyEnabled = false
local boatSpeed = 55
local currentKeybind = Enum.KeyCode.RightShift

local boatFlyCard = Instance.new("Frame")
boatFlyCard.Size = UDim2.new(1, -30, 0, 155)
boatFlyCard.BackgroundColor3 = THEME.PANEL
boatFlyCard.BorderSizePixel = 0
boatFlyCard.ZIndex = 13
boatFlyCard.Parent = pages[2]
round(boatFlyCard, 10)
stroke(boatFlyCard, THEME.BORDER, 1, 0.5)

local boatTitleLbl = Instance.new("TextLabel")
boatTitleLbl.Size = UDim2.new(1, -70, 0, 20)
boatTitleLbl.Position = UDim2.new(0, 14, 0, 10)
boatTitleLbl.BackgroundTransparency = 1
boatTitleLbl.Text = "1. Полёт на Корабле"
boatTitleLbl.TextColor3 = THEME.TEXT_TITLE
boatTitleLbl.TextSize = 13
boatTitleLbl.Font = Enum.Font.GothamBold
boatTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
boatTitleLbl.ZIndex = 14
boatTitleLbl.Parent = boatFlyCard

local boatSubLbl = Instance.new("TextLabel")
boatSubLbl.Size = UDim2.new(1, -70, 0, 16)
boatSubLbl.Position = UDim2.new(0, 14, 0, 30)
boatSubLbl.BackgroundTransparency = 1
boatSubLbl.Text = "Сядь в кресло: держит высоту"
boatSubLbl.TextColor3 = THEME.TEXT_MUTED
boatSubLbl.TextSize = 10
boatSubLbl.Font = Enum.Font.Gotham
boatSubLbl.TextXAlignment = Enum.TextXAlignment.Left
boatSubLbl.ZIndex = 14
boatSubLbl.Parent = boatFlyCard

local boatSwitchBtn = Instance.new("TextButton")
boatSwitchBtn.AnchorPoint = Vector2.new(1, 0)
boatSwitchBtn.Position = UDim2.new(1, -14, 0, 14)
boatSwitchBtn.Size = UDim2.new(0, 44, 0, 24)
boatSwitchBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
boatSwitchBtn.BorderSizePixel = 0
boatSwitchBtn.Text = ""
boatSwitchBtn.AutoButtonColor = false
boatSwitchBtn.ZIndex = 14
boatSwitchBtn.Parent = boatFlyCard
round(boatSwitchBtn, 12)

local boatDot = Instance.new("Frame")
boatDot.Position = UDim2.new(0, 3, 0.5, -9)
boatDot.Size = UDim2.new(0, 18, 0, 18)
boatDot.BackgroundColor3 = THEME.TEXT_MUTED
boatDot.BorderSizePixel = 0
boatDot.ZIndex = 15
boatDot.Parent = boatSwitchBtn
round(boatDot, 99)

-- Текстовое поле ввода скорости
local speedInputLabel = Instance.new("TextLabel")
speedInputLabel.Size = UDim2.new(1, -28, 0, 16)
speedInputLabel.Position = UDim2.new(0, 14, 0, 60)
speedInputLabel.BackgroundTransparency = 1
speedInputLabel.Text = "Введи скорость полета:"
speedInputLabel.TextColor3 = THEME.TEXT_MUTED
speedInputLabel.TextSize = 10
speedInputLabel.Font = Enum.Font.GothamBold
speedInputLabel.TextXAlignment = Enum.TextXAlignment.Left
speedInputLabel.ZIndex = 14
speedInputLabel.Parent = boatFlyCard

local speedTextBox = Instance.new("TextBox")
speedTextBox.Size = UDim2.new(1, -28, 0, 36)
speedTextBox.Position = UDim2.new(0, 14, 0, 80)
speedTextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
speedTextBox.BorderSizePixel = 0
speedTextBox.Text = tostring(boatSpeed)
speedTextBox.TextColor3 = THEME.TEXT_ACCENT
speedTextBox.PlaceholderColor3 = THEME.TEXT_MUTED
speedTextBox.TextSize = 13
speedTextBox.Font = Enum.Font.GothamBold
speedTextBox.ZIndex = 14
speedTextBox.Parent = boatFlyCard
round(speedTextBox, 8)
stroke(speedTextBox, THEME.BORDER, 1, 0.5)

speedTextBox.FocusLost:Connect(function()
    local num = tonumber(speedTextBox.Text)
    if num then
        boatSpeed = num
    else
        speedTextBox.Text = tostring(boatSpeed)
    end
end)

boatSwitchBtn.Activated:Connect(function()
    boatFlyEnabled = not boatFlyEnabled
    local targetColor = boatFlyEnabled and THEME.SUCCESS or Color3.fromRGB(45, 45, 70)
    local dotColor = boatFlyEnabled and Color3.new(1, 1, 1) or THEME.TEXT_MUTED
    local dotPos = boatFlyEnabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)

    TweenService:Create(boatSwitchBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    TweenService:Create(boatDot, TweenInfo.new(0.2), {BackgroundColor3 = dotColor, Position = dotPos}):Play()

    if not boatFlyEnabled then return end

    task.spawn(function()
        while boatFlyEnabled do
            local char = player.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            local seat = humanoid and humanoid.SeatPart
            
            if seat then
                local primaryPart = seat
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

                local bf = primaryPart:FindFirstChild("KairoAntiGravity") or Instance.new("BodyForce")
                bf.Name = "KairoAntiGravity"
                bf.Force = Vector3.new(0, primaryPart.AssemblyMass * Workspace.Gravity, 0)
                bf.Parent = primaryPart

                while boatFlyEnabled and seat.Parent and humanoid.SeatPart == seat do
                    local cam = Workspace.CurrentCamera
                    local moveDir = Vector3.new(0, 0, 0)
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end

                    bv.Velocity = moveDir * boatSpeed
                    bg.CFrame = cam.CFrame
                    RunService.RenderStepped:Wait()
                end

                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
                if bf then bf:Destroy() end
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

-- Карточка настройки бинда меню (снизу во второй вкладке)
local bindCard = Instance.new("Frame")
bindCard.Size = UDim2.new(1, -30, 0, 75)
bindCard.BackgroundColor3 = THEME.PANEL
bindCard.BorderSizePixel = 0
bindCard.ZIndex = 13
bindCard.Parent = pages[2]
round(bindCard, 10)
stroke(bindCard, THEME.BORDER, 1, 0.5)

local bindTitleLbl = Instance.new("TextLabel")
bindTitleLbl.Size = UDim2.new(1, -20, 0, 20)
bindTitleLbl.Position = UDim2.new(0, 14, 0, 10)
bindTitleLbl.BackgroundTransparency = 1
bindTitleLbl.Text = "2. Бинд клавиши меню"
bindTitleLbl.TextColor3 = THEME.TEXT_TITLE
bindTitleLbl.TextSize = 13
bindTitleLbl.Font = Enum.Font.GothamBold
bindTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
bindTitleLbl.ZIndex = 14
bindTitleLbl.Parent = bindCard

local bindBtn = Instance.new("TextButton")
bindBtn.Size = UDim2.new(1, -28, 0, 32)
bindBtn.Position = UDim2.new(0, 14, 0, 34)
bindBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
bindBtn.BorderSizePixel = 0
bindBtn.Text = "Клавиша: RightShift (нажми чтобы изменить)"
bindBtn.TextColor3 = THEME.TEXT_ACCENT
bindBtn.TextSize = 11
bindBtn.Font = Enum.Font.GothamBold
bindBtn.AutoButtonColor = false
bindBtn.ZIndex = 14
bindBtn.Parent = bindCard
round(bindBtn, 8)
stroke(bindBtn, THEME.BORDER, 1, 0.5)
clickAnim(bindBtn)

local isListeningForKey = false
bindBtn.Activated:Connect(function()
    if isListeningForKey then return end
    isListeningForKey = true
    bindBtn.Text = "Нажми любую клавишу..."
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gpe)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            currentKeybind = input.KeyCode
            bindBtn.Text = "Клавиша: " .. tostring(currentKeybind.Name) .. " (нажми чтобы изменить)"
            isListeningForKey = false
            connection:Disconnect()
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
    t.btn.Activated:Connect(function() selectTab(idx) end)
    t.btn.MouseEnter:Connect(function()
        if activeTab ~= idx then
            TweenService:Create(t.icon, TweenInfo.new(0.15), {TextColor3 = THEME.TEXT_TITLE}):Play()
            TweenService:Create(t.text, TweenInfo.new(0.15), {TextColor3 = THEME.TEXT_TITLE}):Play()
        end
    end)
    t.btn.MouseLeave:Connect(function()
        if activeTab ~= idx then setTabColors(idx, false) end
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
        t.Completed:Once(function() mainFrame.Visible = false end)
        t:Play()
    end
end

closeBtn.Activated:Connect(function() setMenuVisible(false) end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and not isListeningForKey and input.KeyCode == currentKeybind then
        setMenuVisible(not mainFrame.Visible)
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

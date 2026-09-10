--------------------------------------------------------------------------------
-- KAIROTECH HUB — v2.0 (UI OVERHAUL)
--------------------------------------------------------------------------------
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

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
    PANEL_HOVER = Color3.fromRGB(38, 38, 66),
    ACCENT_START = Color3.fromRGB(168, 85, 247),
    ACCENT_END = Color3.fromRGB(99, 102, 241),
    TEXT_TITLE = Color3.fromRGB(240, 240, 255),
    TEXT_ACCENT = Color3.fromRGB(192, 132, 252),
    TEXT_MUTED = Color3.fromRGB(130, 135, 165),
    BORDER = Color3.fromRGB(99, 102, 241),
    BTN_OFF = Color3.fromRGB(24, 24, 42),
    SUCCESS = Color3.fromRGB(52, 211, 153),
    ERROR = Color3.fromRGB(248, 113, 113)
}

--------------------------------------------------------------------------------
-- 🛠 UI ХЕЛПЕРЫ
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

local function addClickAnim(btn)
    local scale = Instance.new("UIScale")
    scale.Parent = btn
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {Scale = 0.96}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.12, Enum.EasingStyle.Back), {Scale = 1}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.12), {Scale = 1}):Play()
    end)
end

--------------------------------------------------------------------------------
-- 🍞 ТОСТ-УВЕДОМЛЕНИЯ
--------------------------------------------------------------------------------
local toastHolder = Instance.new("Frame")
toastHolder.AnchorPoint = Vector2.new(1, 0)
toastHolder.Position = UDim2.new(1, -16, 0, 16)
toastHolder.Size = UDim2.new(0, 280, 0, 240)
toastHolder.BackgroundTransparency = 1
toastHolder.ZIndex = 300
toastHolder.Parent = screenGui

local toastLayout = Instance.new("UIListLayout")
toastLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
toastLayout.Padding = UDim.new(0, 6)
toastLayout.SortOrder = Enum.SortOrder.LayoutOrder
toastLayout.Parent = toastHolder

local toastOrder = 0
local activeToasts = {}

local function showNotification(text, notifType)
    toastOrder += 1
    local color = (notifType == "success" and THEME.SUCCESS) or (notifType == "error" and THEME.ERROR) or THEME.TEXT_ACCENT
    local icon = (notifType == "success" and "✓") or (notifType == "error" and "✕") or "ℹ"

    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(1, 0, 0, 40)
    toast.BackgroundColor3 = THEME.PANEL
    toast.BorderSizePixel = 0
    toast.LayoutOrder = toastOrder
    toast.ZIndex = 301
    toast.Parent = toastHolder
    round(toast, 10)
    local toastStroke = stroke(toast, color, 1, 0.3)

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 32, 1, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = color
    iconLabel.TextSize = 14
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.ZIndex = 302
    iconLabel.Parent = toast

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -44, 1, 0)
    label.Position = UDim2.new(0, 36, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = THEME.TEXT_TITLE
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.ZIndex = 302
    label.Parent = toast

    local uiScale = Instance.new("UIScale")
    uiScale.Scale = 0.7
    uiScale.Parent = toast
    TweenService:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()

    table.insert(activeToasts, toast)
    if #activeToasts > 4 then
        local oldest = table.remove(activeToasts, 1)
        if oldest then oldest:Destroy() end
    end

    task.delay(2.8, function()
        if not toast.Parent then return end
        TweenService:Create(iconLabel, TweenInfo.new(0.35), {TextTransparency = 1}):Play()
        TweenService:Create(label, TweenInfo.new(0.35), {TextTransparency = 1}):Play()
        TweenService:Create(toastStroke, TweenInfo.new(0.35), {Transparency = 1}):Play()
        local fade = TweenService:Create(toast, TweenInfo.new(0.35), {BackgroundTransparency = 1})
        fade:Play()
        fade.Completed:Wait()
        toast:Destroy()
    end)
end

--------------------------------------------------------------------------------
-- 🔒 ЭКРАН АВТОРИЗАЦИИ
--------------------------------------------------------------------------------
local CORRECT_PASSWORD = "2200"

local authFrame = Instance.new("Frame")
authFrame.Size = UDim2.new(0, 360, 0, 270)
authFrame.Position = UDim2.new(0.5, -180, 0.5, -135)
authFrame.BackgroundColor3 = THEME.BG
authFrame.BorderSizePixel = 0
authFrame.ZIndex = 100
authFrame.Parent = screenGui
round(authFrame, 14)
local authStroke = stroke(authFrame, THEME.BORDER, 1.5, 0)

local authScale = Instance.new("UIScale")
authScale.Parent = authFrame
authScale.Scale = 0.8
TweenService:Create(authScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()

-- Логотип
local authLogo = Instance.new("Frame")
authLogo.AnchorPoint = Vector2.new(0.5, 0)
authLogo.Position = UDim2.new(0.5, 0, 0, 18)
authLogo.Size = UDim2.new(0, 44, 0, 44)
authLogo.BackgroundColor3 = Color3.new(1, 1, 1)
authLogo.BorderSizePixel = 0
authLogo.ZIndex = 101
authLogo.Parent = authFrame
round(authLogo, 99)
gradient(authLogo)

local authLogoText = Instance.new("TextLabel")
authLogoText.Size = UDim2.new(1, 0, 1, 0)
authLogoText.BackgroundTransparency = 1
authLogoText.Text = "🔮"
authLogoText.TextSize = 20
authLogoText.Font = Enum.Font.GothamBold
authLogoText.ZIndex = 102
authLogoText.Parent = authLogo

local authTitle = Instance.new("TextLabel")
authTitle.Size = UDim2.new(1, 0, 0, 22)
authTitle.Position = UDim2.new(0, 0, 0, 70)
authTitle.BackgroundTransparency = 1
authTitle.Text = "KAIROTECH SYSTEM"
authTitle.TextColor3 = THEME.TEXT_TITLE
authTitle.TextSize = 16
authTitle.Font = Enum.Font.GothamBold
authTitle.ZIndex = 101
authTitle.Parent = authFrame

local authSubtitle = Instance.new("TextLabel")
authSubtitle.Size = UDim2.new(1, 0, 0, 14)
authSubtitle.Position = UDim2.new(0, 0, 0, 92)
authSubtitle.BackgroundTransparency = 1
authSubtitle.Text = "SECURITY ACCESS • v2.0"
authSubtitle.TextColor3 = THEME.TEXT_ACCENT
authSubtitle.TextSize = 9
authSubtitle.Font = Enum.Font.Gotham
authSubtitle.ZIndex = 101
authSubtitle.Parent = authFrame

-- Полоса загрузки
local loadingBarBG = Instance.new("Frame")
loadingBarBG.Size = UDim2.new(0.85, 0, 0, 6)
loadingBarBG.Position = UDim2.new(0.075, 0, 0, 118)
loadingBarBG.BackgroundColor3 = THEME.PANEL
loadingBarBG.BorderSizePixel = 0
loadingBarBG.ZIndex = 101
loadingBarBG.Parent = authFrame
round(loadingBarBG, 4)

local loadingBarFill = Instance.new("Frame")
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.BackgroundColor3 = Color3.new(1, 1, 1)
loadingBarFill.BorderSizePixel = 0
loadingBarFill.ZIndex = 102
loadingBarFill.Parent = loadingBarBG
round(loadingBarFill, 4)
gradient(loadingBarFill)

local loadingStatus = Instance.new("TextLabel")
loadingStatus.Size = UDim2.new(1, 0, 0, 20)
loadingStatus.Position = UDim2.new(0, 0, 0, 130)
loadingStatus.BackgroundTransparency = 1
loadingStatus.Text = "Загрузка скрипта..."
loadingStatus.TextColor3 = THEME.TEXT_MUTED
loadingStatus.TextSize = 11
loadingStatus.Font = Enum.Font.GothamMedium
loadingStatus.ZIndex = 101
loadingStatus.Parent = authFrame

-- Поле пароля с иконкой
local passContainer = Instance.new("Frame")
passContainer.Size = UDim2.new(0.85, 0, 0, 40)
passContainer.Position = UDim2.new(0.075, 0, 0, 160)
passContainer.BackgroundColor3 = THEME.PANEL
passContainer.BorderSizePixel = 0
passContainer.ZIndex = 101
passContainer.Visible = false
passContainer.Parent = authFrame
round(passContainer, 10)
stroke(passContainer, THEME.BORDER, 1, 0.6)

local passIcon = Instance.new("TextLabel")
passIcon.Size = UDim2.new(0, 32, 1, 0)
passIcon.BackgroundTransparency = 1
passIcon.Text = "🔑"
passIcon.TextSize = 14
passIcon.ZIndex = 102
passIcon.Parent = passContainer

local passBox = Instance.new("TextBox")
passBox.Size = UDim2.new(1, -44, 1, 0)
passBox.Position = UDim2.new(0, 36, 0, 0)
passBox.BackgroundTransparency = 1
passBox.PlaceholderText = "Введите ключ доступа..."
passBox.PlaceholderColor3 = THEME.TEXT_MUTED
passBox.Text = ""
passBox.TextColor3 = Color3.fromRGB(255, 255, 255)
passBox.TextSize = 12
passBox.Font = Enum.Font.Gotham
passBox.TextXAlignment = Enum.TextXAlignment.Left
passBox.ClearTextOnFocus = false
passBox.ZIndex = 102
passBox.Parent = passContainer

-- Кнопка входа
local loginBtn = Instance.new("TextButton")
loginBtn.Size = UDim2.new(0.85, 0, 0, 38)
loginBtn.Position = UDim2.new(0.075, 0, 0, 212)
loginBtn.BackgroundColor3 = Color3.new(1, 1, 1)
loginBtn.BorderSizePixel = 0
loginBtn.Text = "ВОЙТИ"
loginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loginBtn.TextSize = 12
loginBtn.Font = Enum.Font.GothamBold
loginBtn.ZIndex = 101
loginBtn.Visible = false
loginBtn.AutoButtonColor = false
loginBtn.Parent = authFrame
round(loginBtn, 10)
local loginGradient = gradient(loginBtn)
addClickAnim(loginBtn)

loginBtn.MouseEnter:Connect(function()
    TweenService:Create(loginGradient, TweenInfo.new(0.15), {Brightness = 1.4}):Play()
end)
loginBtn.MouseLeave:Connect(function()
    TweenService:Create(loginGradient, TweenInfo.new(0.15), {Brightness = 1}):Play()
end)

--------------------------------------------------------------------------------
-- 📱 ГЛАВНОЕ ОКНО
--------------------------------------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 560, 0, 450)
mainFrame.Position = UDim2.new(0.5, -280, 0.5, -225)
mainFrame.BackgroundColor3 = THEME.BG
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 10
mainFrame.Visible = false
mainFrame.Parent = screenGui
round(mainFrame, 14)
local mainStroke = stroke(mainFrame, THEME.BORDER, 1.5, 0)

local mainScale = Instance.new("UIScale")
mainScale.Parent = mainFrame

-- Шапка
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 46)
header.BackgroundColor3 = THEME.HEADER
header.BorderSizePixel = 0
header.ZIndex = 11
header.Parent = mainFrame
round(header, 14)

-- Градиентная линия под шапкой
local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, -24, 0, 2)
headerLine.Position = UDim2.new(0, 12, 1, -2)
headerLine.BackgroundColor3 = Color3.new(1, 1, 1)
headerLine.BorderSizePixel = 0
headerLine.ZIndex = 12
headerLine.Parent = header
gradient(headerLine)

-- Логотип в шапке
local logoCircle = Instance.new("Frame")
logoCircle.Position = UDim2.new(0, 12, 0.5, -14)
logoCircle.Size = UDim2.new(0, 28, 0, 28)
logoCircle.BackgroundColor3 = Color3.new(1, 1, 1)
logoCircle.BorderSizePixel = 0
logoCircle.ZIndex = 12
logoCircle.Parent = header
round(logoCircle, 99)
gradient(logoCircle)

local logoIcon = Instance.new("TextLabel")
logoIcon.Size = UDim2.new(1, 0, 1, 0)
logoIcon.BackgroundTransparency = 1
logoIcon.Text = "🔮"
logoIcon.TextSize = 14
logoIcon.ZIndex = 13
logoIcon.Parent = logoCircle

local menuTitle = Instance.new("TextLabel")
menuTitle.Size = UDim2.new(0.6, 0, 0, 20)
menuTitle.Position = UDim2.new(0, 48, 0, 5)
menuTitle.BackgroundTransparency = 1
menuTitle.Text = "KAIROTECH HUB"
menuTitle.TextColor3 = THEME.TEXT_TITLE
menuTitle.TextSize = 14
menuTitle.Font = Enum.Font.GothamBold
menuTitle.TextXAlignment = Enum.TextXAlignment.Left
menuTitle.ZIndex = 12
menuTitle.Parent = header

local menuSubtitle = Instance.new("TextLabel")
menuSubtitle.Size = UDim2.new(0.6, 0, 0, 12)
menuSubtitle.Position = UDim2.new(0, 48, 0, 26)
menuSubtitle.BackgroundTransparency = 1
menuSubtitle.Text = "Игрок • Построй Корабль"
menuSubtitle.TextColor3 = THEME.TEXT_MUTED
menuSubtitle.TextSize = 9
menuSubtitle.Font = Enum.Font.Gotham
menuSubtitle.TextXAlignment = Enum.TextXAlignment.Left
menuSubtitle.ZIndex = 12
menuSubtitle.Parent = header

-- Кнопка закрытия
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
addClickAnim(closeBtn)

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.ERROR}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(180, 60, 60)}):Play()
end)

closeBtn.Activated:Connect(function()
    mainFrame.Visible = false
    showNotification("Меню скрыто • RightShift — показать", "info")
end)

--------------------------------------------------------------------------------
-- 📑 ВКЛАДКИ
--------------------------------------------------------------------------------
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -24, 0, 34)
tabContainer.Position = UDim2.new(0, 12, 0, 54)
tabContainer.BackgroundTransparency = 1
tabContainer.ZIndex = 12
tabContainer.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 8)
tabLayout.Parent = tabContainer

local activeTab = 1

local function createTabBtn(text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.5, -4, 1, 0)
    btn.BackgroundColor3 = (order == 1) and THEME.ACCENT_START or THEME.BTN_OFF
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = (order == 1) and Color3.fromRGB(255, 255, 255) or THEME.TEXT_MUTED
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.LayoutOrder = order
    btn.ZIndex = 13
    btn.AutoButtonColor = false
    btn.Parent = tabContainer
    round(btn, 8)
    local btnGradient = gradient(btn)
    if order ~= 1 then btnGradient.Enabled = false end

    btn.MouseEnter:Connect(function()
        if activeTab ~= order then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.PANEL_HOVER}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= order then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.BTN_OFF}):Play()
        end
    end)

    return btn
end

local tabBtns = {
    createTabBtn("🏃 Игрок", 1),
    createTabBtn("🛶 Построй Корабль", 2)
}

local function createContentFrame()
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, -24, 1, -130)
    frame.Position = UDim2.new(0, 12, 0, 96)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ScrollBarThickness = 4
    frame.ScrollBarImageColor3 = THEME.BORDER
    frame.ScrollingDirection = Enum.ScrollingDirection.Y
    frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.Visible = false
    frame.ZIndex = 12
    frame.Parent = mainFrame

    local list = Instance.new("UIListLayout")
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 6)
    list.Parent = frame

    return frame
end

local tabsContent = {createContentFrame(), createContentFrame()}
tabsContent[1].Visible = true

local CONTENT_POS = UDim2.new(0, 12, 0, 96)

for idx, btn in ipairs(tabBtns) do
    btn.Activated:Connect(function()
        if activeTab == idx then return end
        activeTab = idx
        for i, b in ipairs(tabBtns) do
            local bGradient = b:FindFirstChildOfClass("UIGradient")
            if i == idx then
                b.BackgroundColor3 = THEME.ACCENT_START
                b.TextColor3 = Color3.fromRGB(255, 255, 255)
                if bGradient then bGradient.Enabled = true end
            else
                b.BackgroundColor3 = THEME.BTN_OFF
                b.TextColor3 = THEME.TEXT_MUTED
                if bGradient then bGradient.Enabled = false end
            end
            tabsContent[i].Visible = false
        end
        local frame = tabsContent[idx]
        frame.Visible = true
        frame.Position = CONTENT_POS + UDim2.new(0, 24, 0, 0)
        TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = CONTENT_POS}):Play()
    end)
end

--------------------------------------------------------------------------------
-- 🦶 ПОДВАЛ
--------------------------------------------------------------------------------
local footer = Instance.new("Frame")
footer.Size = UDim2.new(1, 0, 0, 26)
footer.Position = UDim2.new(0, 0, 1, -26)
footer.BackgroundColor3 = THEME.HEADER
footer.BorderSizePixel = 0
footer.ZIndex = 11
footer.Parent = mainFrame
round(footer, 14)

local footerText = Instance.new("TextLabel")
footerText.Size = UDim2.new(1, -80, 1, 0)
footerText.Position = UDim2.new(0, 12, 0, 0)
footerText.BackgroundTransparency = 1
footerText.Text = "👤 " .. player.Name .. "   •   RightShift — скрыть/показать"
footerText.TextColor3 = THEME.TEXT_MUTED
footerText.TextSize = 10
footerText.Font = Enum.Font.Gotham
footerText.TextXAlignment = Enum.TextXAlignment.Left
footerText.ZIndex = 12
footerText.Parent = footer

local versionText = Instance.new("TextLabel")
versionText.AnchorPoint = Vector2.new(1, 0)
versionText.Position = UDim2.new(1, -12, 0, 0)
versionText.Size = UDim2.new(0, 60, 1, 0)
versionText.BackgroundTransparency = 1
versionText.Text = "v2.0"
versionText.TextColor3 = THEME.TEXT_ACCENT
versionText.TextSize = 10
versionText.Font = Enum.Font.GothamBold
versionText.TextXAlignment = Enum.TextXAlignment.Right
versionText.ZIndex = 12
versionText.Parent = footer

-- Пульсация рамки
task.spawn(function()
    while screenGui.Parent do
        local t1 = TweenService:Create(mainStroke, TweenInfo.new(2, Enum.EasingStyle.Sine), {Thickness = 2.2})
        t1:Play(); t1.Completed:Wait()
        local t2 = TweenService:Create(mainStroke, TweenInfo.new(2, Enum.EasingStyle.Sine), {Thickness = 1.5})
        t2:Play(); t2.Completed:Wait()
    end
end)

--------------------------------------------------------------------------------
-- 🔲 ТОГГЛЫ
--------------------------------------------------------------------------------
local function createToggle(text, order, parent, onChange)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.98, 0, 0, 38)
    btn.BackgroundColor3 = THEME.PANEL
    btn.BorderSizePixel = 0
    btn.Text = "  " .. text
    btn.TextColor3 = THEME.TEXT_MUTED
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.LayoutOrder = order
    btn.ZIndex = 14
    btn.AutoButtonColor = false
    btn.Parent = parent
    round(btn, 10)
    local btnStroke = stroke(btn, THEME.BORDER, 1, 0.85)

    local stateLabel = Instance.new("TextLabel")
    stateLabel.AnchorPoint = Vector2.new(1, 0.5)
    stateLabel.Position = UDim2.new(1, -42, 0.5, 0)
    stateLabel.Size = UDim2.new(0, 34, 0, 16)
    stateLabel.BackgroundTransparency = 1
    stateLabel.Text = "ВЫКЛ"
    stateLabel.TextColor3 = THEME.TEXT_MUTED
    stateLabel.TextSize = 9
    stateLabel.Font = Enum.Font.GothamBold
    stateLabel.ZIndex = 15
    stateLabel.Parent = btn

    local indicator = Instance.new("Frame")
    indicator.AnchorPoint = Vector2.new(1, 0.5)
    indicator.Position = UDim2.new(1, -18, 0.5, 0)
    indicator.Size = UDim2.new(0, 10, 0, 10)
    indicator.BackgroundColor3 = Color3.fromRGB(80, 84, 110)
    indicator.BorderSizePixel = 0
    indicator.ZIndex = 15
    indicator.Parent = btn
    round(indicator, 99)

    local state = false

    local function setState(newState)
        state = newState
        TweenService:Create(indicator, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            BackgroundColor3 = state and THEME.SUCCESS or Color3.fromRGB(80, 84, 110),
            Size = state and UDim2.new(0, 14, 0, 14) or UDim2.new(0, 10, 0, 10)
        }):Play()
        stateLabel.Text = state and "ВКЛ" or "ВЫКЛ"
        stateLabel.TextColor3 = state and THEME.SUCCESS or THEME.TEXT_MUTED
        TweenService:Create(btn, TweenInfo.new(0.25), {
            TextColor3 = state and THEME.TEXT_TITLE or THEME.TEXT_MUTED
        }):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.25), {Transparency = state and 0.25 or 0.85}):Play()
        if onChange then onChange(state) end
    end

    btn.Activated:Connect(function()
        setState(not state)
    end)

    btn.MouseEnter:Connect(function()
        if not state then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.PANEL_HOVER}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = state and THEME.PANEL_HOVER or THEME.PANEL}):Play()
    end)
    addClickAnim(btn)

    return { btn = btn, setState = setState, getState = function() return state end }
end

--------------------------------------------------------------------------------
-- ⚡ ЭКШН-КНОПКИ
--------------------------------------------------------------------------------
local function createActionButton(text, order, parent, onClick)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.98, 0, 0, 34)
    btn.BackgroundColor3 = Color3.new(1, 1, 1)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.LayoutOrder = order
    btn.ZIndex = 14
    btn.AutoButtonColor = false
    btn.Parent = parent
    round(btn, 10)
    local btnGradient = gradient(btn)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btnGradient, TweenInfo.new(0.15), {Brightness = 1.35}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btnGradient, TweenInfo.new(0.15), {Brightness = 1}):Play()
    end)
    addClickAnim(btn)

    if onClick then btn.Activated:Connect(onClick) end
    return btn
end

--------------------------------------------------------------------------------
-- ⌨ ИНПУТ-ПАНЕЛИ
--------------------------------------------------------------------------------
local function createInputPanel(placeholderText, actionText, order, parent)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.98, 0, 0, 40)
    container.BackgroundColor3 = THEME.PANEL
    container.BorderSizePixel = 0
    container.LayoutOrder = order
    container.ZIndex = 14
    container.Parent = parent
    round(container, 10)
    stroke(container, THEME.BORDER, 1, 0.85)

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.6, 0, 0.72, 0)
    box.Position = UDim2.new(0, 8, 0.14, 0)
    box.BackgroundColor3 = THEME.HEADER
    box.BorderSizePixel = 0
    box.PlaceholderText = placeholderText
    box.PlaceholderColor3 = THEME.TEXT_MUTED
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 11
    box.Font = Enum.Font.Gotham
    box.ClearTextOnFocus = false
    box.ZIndex = 15
    box.Parent = container
    round(box, 6)

    local btn = Instance.new("TextButton")
    btn.AnchorPoint = Vector2.new(1, 0)
    btn.Position = UDim2.new(1, -8, 0.14, 0)
    btn.Size = UDim2.new(0.32, 0, 0.72, 0)
    btn.BackgroundColor3 = Color3.new(1, 1, 1)
    btn.BorderSizePixel = 0
    btn.Text = actionText
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.ZIndex = 15
    btn.AutoButtonColor = false
    btn.Parent = container
    round(btn, 6)
    local btnGradient = gradient(btn)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btnGradient, TweenInfo.new(0.15), {Brightness = 1.35}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btnGradient, TweenInfo.new(0.15), {Brightness = 1}):Play()
    end)
    addClickAnim(btn)

    return box, btn
end

--------------------------------------------------------------------------------
-- ⚙️ АНИМАЦИЯ ЗАГРУЗКИ И ПРОВЕРКА ПАРОЛЯ
--------------------------------------------------------------------------------
task.spawn(function()
    local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(loadingBarFill, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)}):Play()

    task.wait(0.4)
    loadingStatus.Text = "Проверка компонентов..."
    task.wait(0.4)
    loadingStatus.Text = "Инициализация интерфейса..."
    task.wait(0.5)

    loadingBarBG.Visible = false
    loadingStatus.Text = "Введите ключ доступа:"
    loadingStatus.TextColor3 = THEME.TEXT_ACCENT
    passContainer.Visible = true
    loginBtn.Visible = true
end)

local function checkPassword()
    if passBox.Text == CORRECT_PASSWORD then
        loadingStatus.Text = "✓ Доступ разрешен!"
        loadingStatus.TextColor3 = THEME.SUCCESS

        local shrink = TweenService:Create(authScale, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.7})
        shrink:Play()
        shrink.Completed:Wait()
        authFrame:Destroy()

        mainFrame.Visible = true
        mainScale.Scale = 0.8
        TweenService:Create(mainScale, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        showNotification("Добро пожаловать, " .. player.Name .. "!", "success")
    else
        loadingStatus.Text = "✕ Неверный ключ доступа!"
        loadingStatus.TextColor3 = THEME.ERROR
        passBox.Text = ""

        local originalPos = authFrame.Position
        for _ = 1, 3 do
            authFrame.Position = originalPos + UDim2.new(0, 9, 0, 0)
            task.wait(0.045)
            authFrame.Position = originalPos + UDim2.new(0, -9, 0, 0)
            task.wait(0.045)
        end
        authFrame.Position = originalPos

        loadingStatus.Text = "Введите ключ доступа:"
        loadingStatus.TextColor3 = THEME.TEXT_ACCENT
    end
end

loginBtn.Activated:Connect(checkPassword)
passBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then checkPassword() end
end)

--------------------------------------------------------------------------------
-- 🏃 РАЗДЕЛ 1: ИГРОК
--------------------------------------------------------------------------------

-- 1. Noclip
local noclip = false
createToggle("1. Noclip (Сквозь стены)", 1, tabsContent[1], function(state)
    noclip = state
end)
RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- 2. Fly
local flying = false
local flySpeed = 50
createToggle("2. Fly (Полёт)", 2, tabsContent[1], function(state)
    flying = state
    if state then
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
    end
end)

-- 3. Infinite Jump
local infJump = false
createToggle("3. Infinite Jump", 3, tabsContent[1], function(state)
    infJump = state
end)
UserInputService.JumpRequest:Connect(function()
    if infJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 4. ESP Игроков
local espActive = false
local function applyESP(target)
    if espActive and target ~= player and target.Character and not target.Character:FindFirstChild("KairoHighlight") then
        local hl = Instance.new("Highlight")
        hl.Name = "KairoHighlight"
        hl.FillColor = Color3.fromRGB(168, 85, 247)
        hl.OutlineColor = Color3.fromRGB(192, 132, 252)
        hl.FillTransparency = 0.5
        hl.Parent = target.Character
    end
end
local function removeESP(target)
    if target.Character and target.Character:FindFirstChild("KairoHighlight") then
        target.Character.KairoHighlight:Destroy()
    end
end
createToggle("4. ESP Игроков", 4, tabsContent[1], function(state)
    espActive = state
    for _, p in ipairs(Players:GetPlayers()) do
        if state then applyESP(p) else removeESP(p) end
    end
end)
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.5)
        applyESP(p)
    end)
end)

-- 5. Fullbright
local fullbright = false
createToggle("5. Fullbright (Подсветка)", 5, tabsContent[1], function(state)
    fullbright = state
    Lighting.Brightness = fullbright and 2 or 1
    Lighting.ClockTime = fullbright and 14 or 12
    Lighting.GlobalShadows = not fullbright
end)

-- 6. Скорость
local speedBox, speedBtn = createInputPanel("Скорость (напр. 50)", "6. Применить", 6, tabsContent[1])
local function applySpeed()
    local val = tonumber(speedBox.Text)
    if val and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = val
        showNotification("Скорость установлена: " .. val, "success")
    else
        showNotification("Введите корректное число!", "error")
    end
end
speedBtn.Activated:Connect(applySpeed)
speedBox.FocusLost:Connect(function(enter) if enter then applySpeed() end end)

-- 7. Прыжок
local jumpBox, jumpBtn = createInputPanel("Высота прыжка (напр. 100)", "7. Применить", 7, tabsContent[1])
local function applyJump()
    local val = tonumber(jumpBox.Text)
    if val and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid").JumpPower = val
        showNotification("Сила прыжка установлена: " .. val, "success")
    else
        showNotification("Введите корректное число!", "error")
    end
end
jumpBtn.Activated:Connect(applyJump)
jumpBox.FocusLost:Connect(function(enter) if enter then applyJump() end end)

--------------------------------------------------------------------------------
-- 🛶 РАЗДЕЛ 2: ПОСТРОЙ КОРАБЛЬ (BABFT)
--------------------------------------------------------------------------------

-- 1. Авто-Фарм
local autoGoldAir = false
createToggle("1. Авто-Фарм (В воздухе над водой)", 1, tabsContent[2], function(state)
    autoGoldAir = state
    if state then
        task.spawn(function()
            while autoGoldAir do
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    local stages = workspace:FindFirstChild("BoatStages") and workspace.BoatStages:FindFirstChild("NormalStages")

                    local bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(0, math.huge, 0)
                    bv.Velocity = Vector3.new(0, 0, 0)
                    bv.Parent = hrp

                    if stages then
                        for i = 1, 10 do
                            if not autoGoldAir then break end
                            local stage = stages:FindFirstChild("CaveStage" .. tostring(i))
                            if stage and stage:FindFirstChild("DarknessPart") then
                                hrp.CFrame = stage.DarknessPart.CFrame * CFrame.new(0, 60, 0)
                                task.wait(0.4)
                            end
                        end

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
    end
end)

-- 2. Auto Build
local autoBuild = false
createToggle("2. Auto Build (Сетка блоков)", 2, tabsContent[2], function(state)
    autoBuild = state
    if state then
        task.spawn(function()
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local startPos = char.HumanoidRootPart.CFrame
                for x = -2, 2 do
                    for z = -2, 2 do
                        if not autoBuild then break end
                        local item = char:FindFirstChildOfClass("Tool")
                        if item and item:FindFirstChild("RF") then
                            item.RF:InvokeServer(item.Name, 1, startPos * CFrame.new(x * 4, -2, z * 4))
                        end
                        task.wait(0.05)
                    end
                end
            end
        end)
    end
end)

-- 3. Водный урон
local noWaterDamage = false
createToggle("3. Убрать урон от воды", 3, tabsContent[2], function(state)
    noWaterDamage = state
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == "Water" or v.Name == "WaterPart" then
            v.CanTouch = not noWaterDamage
        end
    end
end)

-- 4. ТП к финишному сундуку
createActionButton("4. Телепорт к финишному сундуку", 4, tabsContent[2], function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local stages = workspace:FindFirstChild("BoatStages")
        local normal = stages and stages:FindFirstChild("NormalStages")
        local theEnd = normal and normal:FindFirstChild("TheEnd")
        local endChest = theEnd and theEnd:FindFirstChild("GoldenChest")
        if endChest and endChest:FindFirstChild("Trigger") then
            char.HumanoidRootPart.CFrame = endChest.Trigger.CFrame
            showNotification("Телепортация к сундуку!", "success")
        else
            showNotification("Сундук не найден на карте!", "error")
        end
    end
end)

-- 5. ТП на свою базу
createActionButton("5. Телепорт на свою базу", 5, tabsContent[2], function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local zones = workspace:FindFirstChild("BuildingZones")
        if zones then
            for _, zone in ipairs(zones:GetChildren()) do
                if zone:FindFirstChild("Owner") and zone.Owner.Value == player then
                    char.HumanoidRootPart.CFrame = zone.CFrame * CFrame.new(0, 5, 0)
                    showNotification("Телепортация на базу!", "success")
                    return
                end
            end
        end
        showNotification("База не найдена!", "error")
    end
end)

-- 6. Сохранить позицию
local savedCFrame = nil
createActionButton("6. Сохранить позицию", 6, tabsContent[2], function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        savedCFrame = player.Character.HumanoidRootPart.CFrame
        showNotification("Позиция сохранена!", "success")
    end
end)

-- 7. Вернуться на позицию
createActionButton("7. Вернуться на позицию", 7, tabsContent[2], function()
    if savedCFrame and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = savedCFrame
        showNotification("Возврат на сохранённую позицию!", "success")
    else
        showNotification("Сначала сохраните позицию!", "error")
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

-- RightShift — скрыть/показать
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        if mainFrame.Parent and not authFrame.Parent then
            mainFrame.Visible = not mainFrame.Visible
        end
    end
end)

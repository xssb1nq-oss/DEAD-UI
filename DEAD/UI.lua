-- NOVUS v1.0 — Mobile Landscape UI
-- One-piece NOVUS interface, designed for Roblox phones/tablets in landscape.
-- No Rayfield window is rendered, so there is no Rayfield pill or vertical panel.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Stats = game:GetService("Stats")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- =========================================================
-- MOBILE ORIENTATION
-- =========================================================

pcall(function()
    PlayerGui.ScreenOrientation = Enum.ScreenOrientation.LandscapeSensor
end)

-- =========================================================
-- CLEAN OLD NOVUS UI
-- =========================================================

for _, name in ipairs({"NOVUS_UI", "NOVUS_VisualLayer", "NOVUS_MobileUI"}) do
    local old = PlayerGui:FindFirstChild(name)
    if old then old:Destroy() end
end

-- =========================================================
-- THEME
-- =========================================================

local C = {
    Black = Color3.fromRGB(7, 9, 10),
    Dark = Color3.fromRGB(11, 14, 15),
    Panel = Color3.fromRGB(16, 20, 21),
    Panel2 = Color3.fromRGB(20, 25, 26),
    Panel3 = Color3.fromRGB(25, 31, 32),
    Green = Color3.fromRGB(57, 211, 79),
    Green2 = Color3.fromRGB(34, 164, 55),
    GreenBright = Color3.fromRGB(104, 255, 122),
    White = Color3.fromRGB(244, 248, 245),
    Muted = Color3.fromRGB(143, 153, 146),
    Line = Color3.fromRGB(45, 61, 48),
    Red = Color3.fromRGB(240, 75, 75),
}

local function tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 12)
    c.Parent = obj
    return c
end

local function stroke(obj, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or C.Line
    s.Transparency = transparency or 0
    s.Thickness = thickness or 1
    s.Parent = obj
    return s
end

local function padding(obj, l, r, t, b)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, l or 0)
    p.PaddingRight = UDim.new(0, r or l or 0)
    p.PaddingTop = UDim.new(0, t or l or 0)
    p.PaddingBottom = UDim.new(0, b or t or l or 0)
    p.Parent = obj
    return p
end

local function label(parent, text, size, color, font)
    local x = Instance.new("TextLabel")
    x.BackgroundTransparency = 1
    x.Text = text or ""
    x.TextColor3 = color or C.White
    x.TextSize = size or 14
    x.Font = font or Enum.Font.Gotham
    x.TextXAlignment = Enum.TextXAlignment.Left
    x.TextYAlignment = Enum.TextYAlignment.Center
    x.Parent = parent
    return x
end

local function button(parent, text, icon)
    local b = Instance.new("TextButton")
    b.AutoButtonColor = false
    b.Text = ""
    b.BackgroundColor3 = C.Panel2
    b.Size = UDim2.new(1, 0, 0, 48)
    b.Parent = parent
    corner(b, 12)

    local ic = label(b, icon or "", 18, C.Muted, Enum.Font.GothamBold)
    ic.Size = UDim2.fromOffset(32, 48)
    ic.Position = UDim2.fromOffset(10, 0)
    ic.TextXAlignment = Enum.TextXAlignment.Center

    local tx = label(b, text, 13, C.White, Enum.Font.GothamMedium)
    tx.Size = UDim2.new(1, -52, 1, 0)
    tx.Position = UDim2.fromOffset(48, 0)

    b.MouseEnter:Connect(function()
        tween(b, TweenInfo.new(0.15), {BackgroundColor3 = C.Panel3})
    end)
    b.MouseLeave:Connect(function()
        tween(b, TweenInfo.new(0.15), {BackgroundColor3 = C.Panel2})
    end)
    b.MouseButton1Down:Connect(function()
        tween(b, TweenInfo.new(0.08), {Size = UDim2.new(1, -4, 0, 46)})
    end)
    b.MouseButton1Up:Connect(function()
        tween(b, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 48)})
    end)

    return b
end

-- =========================================================
-- SCREEN GUI
-- =========================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "NOVUS_UI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 999
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

-- Dark overlay
local Backdrop = Instance.new("Frame")
Backdrop.Size = UDim2.fromScale(1, 1)
Backdrop.BackgroundColor3 = C.Black
Backdrop.BackgroundTransparency = 0.25
Backdrop.BorderSizePixel = 0
Backdrop.Parent = Gui

-- Very subtle green ambient light
local Glow = Instance.new("Frame")
Glow.AnchorPoint = Vector2.new(0.5, 0.5)
Glow.Position = UDim2.fromScale(0.5, 0.5)
Glow.Size = UDim2.fromScale(0.75, 0.9)
Glow.BackgroundColor3 = C.Green
Glow.BackgroundTransparency = 0.985
Glow.BorderSizePixel = 0
Glow.Parent = Backdrop
corner(Glow, 999)

-- =========================================================
-- MAIN WINDOW
-- =========================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.fromScale(0.5, 0.53)
Main.Size = UDim2.fromScale(0.86, 0.76)
Main.BackgroundColor3 = C.Dark
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = Gui
corner(Main, 18)
stroke(Main, C.Line, 0.15, 1)

local MainScale = Instance.new("UIScale")
MainScale.Scale = 1
MainScale.Parent = Main

-- =========================================================
-- TOP BAR
-- =========================================================

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 58)
Top.BackgroundColor3 = C.Panel
Top.BorderSizePixel = 0
Top.Parent = Main

local Brand = label(Top, "NOVUS", 21, C.White, Enum.Font.GothamBold)
Brand.Position = UDim2.fromOffset(22, 7)
Brand.Size = UDim2.fromOffset(120, 26)

local Sub = label(Top, "CONTROL CENTER", 9, C.Muted, Enum.Font.GothamMedium)
Sub.Position = UDim2.fromOffset(23, 32)
Sub.Size = UDim2.fromOffset(130, 17)

local OnlineDot = Instance.new("Frame")
OnlineDot.Size = UDim2.fromOffset(8, 8)
OnlineDot.Position = UDim2.new(1, -112, 0.5, -4)
OnlineDot.BackgroundColor3 = C.Green
OnlineDot.BorderSizePixel = 0
OnlineDot.Parent = Top
corner(OnlineDot, 99)

local OnlineText = label(Top, "ONLINE", 10, C.GreenBright, Enum.Font.GothamMedium)
OnlineText.Size = UDim2.fromOffset(62, 24)
OnlineText.Position = UDim2.new(1, -98, 0.5, -12)

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(38, 38)
Close.Position = UDim2.new(1, -48, 0.5, -19)
Close.BackgroundColor3 = C.Panel2
Close.Text = "×"
Close.TextColor3 = C.Muted
Close.TextSize = 25
Close.Font = Enum.Font.Gotham
Close.AutoButtonColor = false
Close.Parent = Top
corner(Close, 11)

-- =========================================================
-- BODY / SIDEBAR
-- =========================================================

local Body = Instance.new("Frame")
Body.Position = UDim2.fromOffset(0, 58)
Body.Size = UDim2.new(1, 0, 1, -58)
Body.BackgroundTransparency = 1
Body.Parent = Main

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.fromOffset(172, 1)
Sidebar.Size = UDim2.new(0, 172, 1, 0)
Sidebar.BackgroundColor3 = C.Panel
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Body

local SideLine = Instance.new("Frame")
SideLine.Size = UDim2.fromOffset(1, 1)
SideLine.Position = UDim2.new(1, -1, 0, 0)
SideLine.BackgroundColor3 = C.Line
SideLine.BackgroundTransparency = 0.4
SideLine.BorderSizePixel = 0
SideLine.Parent = Sidebar

local Nav = Instance.new("Frame")
Nav.Position = UDim2.fromOffset(10, 16)
Nav.Size = UDim2.new(1, -20, 1, -32)
Nav.BackgroundTransparency = 1
Nav.Parent = Sidebar

local NavLayout = Instance.new("UIListLayout")
NavLayout.Padding = UDim.new(0, 7)
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavLayout.Parent = Nav

local PageHolder = Instance.new("Frame")
PageHolder.Position = UDim2.fromOffset(172, 0)
PageHolder.Size = UDim2.new(1, -172, 1, 0)
PageHolder.BackgroundTransparency = 1
PageHolder.ClipsDescendants = true
PageHolder.Parent = Body

local Pages = {}
local NavButtons = {}
local currentPage = nil

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = C.Green2
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollingDirection = Enum.ScrollingDirection.Y
    page.Visible = false
    page.Parent = PageHolder
    padding(page, 18, 18, 16, 20)
    Pages[name] = page
    return page
end

local function navButton(name, icon, order)
    local b = button(Nav, name, icon)
    b.LayoutOrder = order
    NavButtons[name] = b
    return b
end

local HomeNav = navButton("Home", "⌂", 1)
local VisualNav = navButton("Visuals", "◈", 2)
local AimNav = navButton("Aim", "◎", 3)
local MoveNav = navButton("Movement", "↗", 4)
local SettingsNav = navButton("Settings", "⚙", 5)

-- =========================================================
-- HOME
-- =========================================================

local Home = createPage("Home")

local HomeTitle = label(Home, "Dashboard", 23, C.White, Enum.Font.GothamBold)
HomeTitle.Size = UDim2.new(1, 0, 0, 30)

local HomeSub = label(Home, "Everything you need, in one place.", 11, C.Muted, Enum.Font.Gotham)
HomeSub.Size = UDim2.new(1, 0, 0, 24)

local Profile = Instance.new("Frame")
Profile.Size = UDim2.new(1, 0, 0, 106)
Profile.BackgroundColor3 = C.Panel
Profile.BorderSizePixel = 0
Profile.Parent = Home
corner(Profile, 14)
stroke(Profile, C.Line, 0.3, 1)

local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.fromOffset(76, 76)
Avatar.Position = UDim2.fromOffset(15, 15)
Avatar.BackgroundColor3 = C.Panel3
Avatar.BorderSizePixel = 0
Avatar.Parent = Profile
corner(Avatar, 38)

pcall(function()
    Avatar.Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
end)

local AvatarRing = stroke(Avatar, C.Green, 0.1, 2)

local DisplayName = label(Profile, Player.DisplayName, 18, C.White, Enum.Font.GothamBold)
DisplayName.Position = UDim2.fromOffset(108, 19)
DisplayName.Size = UDim2.new(0.45, 0, 0, 27)

local Username = label(Profile, "@" .. Player.Name, 11, C.Muted, Enum.Font.Gotham)
Username.Position = UDim2.fromOffset(109, 46)
Username.Size = UDim2.new(0.45, 0, 0, 22)

local Status = label(Profile, "●  NOVUS ACTIVE", 10, C.GreenBright, Enum.Font.GothamMedium)
Status.Position = UDim2.fromOffset(109, 70)
Status.Size = UDim2.new(0.45, 0, 0, 20)

local ID = label(Profile, "USER ID  " .. tostring(Player.UserId), 10, C.Muted, Enum.Font.GothamMedium)
ID.AnchorPoint = Vector2.new(1, 0.5)
ID.Position = UDim2.new(1, -18, 0.5, 0)
ID.Size = UDim2.fromOffset(160, 24)
ID.TextXAlignment = Enum.TextXAlignment.Right

-- Stats row
local StatsRow = Instance.new("Frame")
StatsRow.Size = UDim2.new(1, 0, 0, 72)
StatsRow.BackgroundTransparency = 1
StatsRow.Parent = Home

local StatsLayout = Instance.new("UIGridLayout")
StatsLayout.CellPadding = UDim2.fromOffset(9, 0)
StatsLayout.CellSize = UDim2.new(0.333, -7, 1, 0)
StatsLayout.Parent = StatsRow

local function statCard(title, value, icon)
    local card = Instance.new("Frame")
    card.BackgroundColor3 = C.Panel
    card.BorderSizePixel = 0
    corner(card, 13)
    stroke(card, C.Line, 0.45, 1)

    local ic = label(card, icon, 18, C.Green, Enum.Font.GothamBold)
    ic.Position = UDim2.fromOffset(13, 10)
    ic.Size = UDim2.fromOffset(30, 28)
    ic.TextXAlignment = Enum.TextXAlignment.Center

    local v = label(card, value, 17, C.White, Enum.Font.GothamBold)
    v.Position = UDim2.fromOffset(48, 8)
    v.Size = UDim2.new(1, -58, 0, 28)
    v.Name = "Value"

    local t = label(card, title, 9, C.Muted, Enum.Font.GothamMedium)
    t.Position = UDim2.fromOffset(49, 35)
    t.Size = UDim2.new(1, -58, 0, 20)

    return card, v
end

local FPSCard, FPSValue = statCard("FPS", "--", "◉")
FPSCard.Parent = StatsRow
local PingCard, PingValue = statCard("PING", "-- ms", "⌁")
PingCard.Parent = StatsRow
local IDCard, IDValue = statCard("USER ID", tostring(Player.UserId), "#")
IDCard.Parent = StatsRow

-- Lower home row
local Lower = Instance.new("Frame")
Lower.Size = UDim2.new(1, 0, 0, 190)
Lower.BackgroundTransparency = 1
Lower.Parent = Home

local Activity = Instance.new("Frame")
Activity.Size = UDim2.new(0.57, -5, 1, 0)
Activity.BackgroundColor3 = C.Panel
Activity.BorderSizePixel = 0
Activity.Parent = Lower
corner(Activity, 14)
stroke(Activity, C.Line, 0.45, 1)

local ActivityTitle = label(Activity, "SYSTEM STATUS", 10, C.Muted, Enum.Font.GothamBold)
ActivityTitle.Position = UDim2.fromOffset(16, 12)
ActivityTitle.Size = UDim2.new(1, -32, 0, 22)

local StatusLines = {
    {"Interface", "Running", C.GreenBright},
    {"Mobile mode", "Landscape", C.GreenBright},
    {"Character", "Loaded", C.GreenBright},
    {"Performance", "Stable", C.GreenBright},
}

for i, item in ipairs(StatusLines) do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -32, 0, 31)
    row.Position = UDim2.fromOffset(16, 37 + (i - 1) * 34)
    row.BackgroundTransparency = 1
    row.Parent = Activity

    local l = label(row, item[1], 11, C.White, Enum.Font.GothamMedium)
    l.Size = UDim2.new(0.6, 0, 1, 0)

    local r = label(row, "●  " .. item[2], 10, item[3], Enum.Font.GothamMedium)
    r.AnchorPoint = Vector2.new(1, 0)
    r.Position = UDim2.new(1, 0, 0, 0)
    r.Size = UDim2.new(0.4, 0, 1, 0)
    r.TextXAlignment = Enum.TextXAlignment.Right
end

local CharacterCard = Instance.new("Frame")
CharacterCard.Size = UDim2.new(0.43, -5, 1, 0)
CharacterCard.Position = UDim2.new(0.57, 10, 0, 0)
CharacterCard.BackgroundColor3 = C.Panel
CharacterCard.BorderSizePixel = 0
CharacterCard.Parent = Lower
corner(CharacterCard, 14)
stroke(CharacterCard, C.Line, 0.45, 1)

local CharTitle = label(CharacterCard, "CHARACTER", 10, C.Muted, Enum.Font.GothamBold)
CharTitle.Position = UDim2.fromOffset(15, 12)
CharTitle.Size = UDim2.new(1, -30, 0, 20)

local Viewport = Instance.new("ViewportFrame")
Viewport.Size = UDim2.new(1, -30, 1, -44)
Viewport.Position = UDim2.fromOffset(15, 35)
Viewport.BackgroundColor3 = C.Black
Viewport.BackgroundTransparency = 0.15
Viewport.BorderSizePixel = 0
Viewport.Ambient = Color3.fromRGB(180, 255, 190)
Viewport.LightColor = Color3.fromRGB(255, 255, 255)
Viewport.LightDirection = Vector3.new(-1, -1, -1)
Viewport.Parent = CharacterCard
corner(Viewport, 12)

local World = Instance.new("WorldModel")
World.Parent = Viewport

local Cam = Instance.new("Camera")
Cam.Parent = Viewport
Viewport.CurrentCamera = Cam

local function buildCharacterPreview()
    World:ClearAllChildren()
    local character = Player.Character
    if not character then return end

    local oldArchivable = character.Archivable
    character.Archivable = true
    local clone = character:Clone()
    character.Archivable = oldArchivable

    for _, obj in ipairs(clone:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            obj:Destroy()
        elseif obj:IsA("BasePart") then
            obj.Anchored = true
            obj.CanCollide = false
        end
    end

    clone.Parent = World
    clone:PivotTo(CFrame.new(0, 0, 0))

    local cf, size = clone:GetBoundingBox()
    local height = math.max(size.Y, 4)
    Cam.CFrame = CFrame.new(Vector3.new(0, height * 0.48, height * 2.45), Vector3.new(0, height * 0.48, 0))

    return clone
end

local PreviewCharacter = buildCharacterPreview()

-- =========================================================
-- OTHER PAGES
-- =========================================================

local Visuals = createPage("Visuals")
local Aim = createPage("Aim")
local Movement = createPage("Movement")
local Settings = createPage("Settings")

local function pageHeader(page, title, desc)
    local t = label(page, title, 23, C.White, Enum.Font.GothamBold)
    t.Size = UDim2.new(1, 0, 0, 30)
    local d = label(page, desc, 11, C.Muted, Enum.Font.Gotham)
    d.Size = UDim2.new(1, 0, 0, 25)
end

pageHeader(Visuals, "Visuals", "Customize the NOVUS interface and visual modules.")
pageHeader(Aim, "Aim", "Aim-related controls and configuration.")
pageHeader(Movement, "Movement", "Movement controls and speed configuration.")
pageHeader(Settings, "Settings", "Interface preferences and performance options.")

local function addToggle(page, name, desc, default, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 62)
    holder.BackgroundColor3 = C.Panel
    holder.BorderSizePixel = 0
    holder.Parent = page
    corner(holder, 12)
    stroke(holder, C.Line, 0.5, 1)

    local title = label(holder, name, 13, C.White, Enum.Font.GothamMedium)
    title.Position = UDim2.fromOffset(14, 7)
    title.Size = UDim2.new(1, -75, 0, 24)

    local description = label(holder, desc, 9, C.Muted, Enum.Font.Gotham)
    description.Position = UDim2.fromOffset(14, 31)
    description.Size = UDim2.new(1, -75, 0, 18)

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.fromOffset(42, 24)
    toggle.Position = UDim2.new(1, -56, 0.5, -12)
    toggle.Text = ""
    toggle.AutoButtonColor = false
    toggle.BackgroundColor3 = default and C.Green2 or C.Panel3
    toggle.Parent = holder
    corner(toggle, 99)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(18, 18)
    knob.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.fromOffset(3, 3)
    knob.BackgroundColor3 = C.White
    knob.BorderSizePixel = 0
    knob.Parent = toggle
    corner(knob, 99)

    local state = default
    toggle.MouseButton1Click:Connect(function()
        state = not state
        tween(toggle, TweenInfo.new(0.16), {BackgroundColor3 = state and C.Green2 or C.Panel3})
        tween(knob, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {
            Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.fromOffset(3, 3)
        })
        if callback then callback(state) end
    end)

    return holder
end

addToggle(Visuals, "Particles", "Ambient particles around the interface.", true)
addToggle(Visuals, "Green Glow", "Soft NOVUS green ambient lighting.", true)
addToggle(Visuals, "Character Preview", "Show the live 3D character card on Home.", true, function(v)
    CharacterCard.Visible = v
end)
addToggle(Visuals, "Animations", "Enable interface transitions and motion.", true)

addToggle(Aim, "Aim Assist", "UI placeholder for your own aim module.", false)
addToggle(Aim, "Target Highlight", "UI placeholder for target highlighting.", false)
addToggle(Aim, "FOV Circle", "UI placeholder for an aim FOV display.", false)

addToggle(Movement, "Speed Module", "UI placeholder for movement settings.", false)
addToggle(Movement, "Jump Module", "UI placeholder for jump settings.", false)
addToggle(Movement, "Auto Sprint", "UI placeholder for sprint behavior.", false)

addToggle(Settings, "Touch Feedback", "Small visual feedback when tapping buttons.", true)
addToggle(Settings, "Compact Mode", "Reduce spacing for smaller screens.", false)
addToggle(Settings, "Performance Mode", "Reduce decorative animations.", false)

-- =========================================================
-- NAVIGATION
-- =========================================================

local function selectPage(name)
    for pageName, page in pairs(Pages) do
        page.Visible = pageName == name
    end

    for buttonName, b in pairs(NavButtons) do
        local active = buttonName == name
        tween(b, TweenInfo.new(0.14), {
            BackgroundColor3 = active and C.Green2 or C.Panel2
        })

        local icon = b:FindFirstChildWhichIsA("TextLabel")
        if icon then
            icon.TextColor3 = active and C.White or C.Muted
        end
    end

    currentPage = name
end

HomeNav.MouseButton1Click:Connect(function() selectPage("Home") end)
VisualNav.MouseButton1Click:Connect(function() selectPage("Visuals") end)
AimNav.MouseButton1Click:Connect(function() selectPage("Aim") end)
MoveNav.MouseButton1Click:Connect(function() selectPage("Movement") end)
SettingsNav.MouseButton1Click:Connect(function() selectPage("Settings") end)

selectPage("Home")

-- =========================================================
-- FPS / PING
-- =========================================================

local frames = 0
local lastFPS = os.clock()
local fps = 60

RunService.RenderStepped:Connect(function()
    frames += 1
    local now = os.clock()
    if now - lastFPS >= 0.5 then
        fps = math.floor(frames / (now - lastFPS) + 0.5)
        frames = 0
        lastFPS = now
        FPSValue.Text = tostring(fps)
    end

    local ping = 0
    pcall(function()
        ping = math.floor(Player:GetNetworkPing() * 1000 + 0.5)
    end)
    PingValue.Text = tostring(ping) .. " ms"
end)

-- =========================================================
-- 3D CHARACTER ROTATION
-- =========================================================

local angle = 0
RunService.RenderStepped:Connect(function(dt)
    if PreviewCharacter and PreviewCharacter.Parent and Home.Visible then
        angle += dt * 0.55
        local pivot = PreviewCharacter:GetPivot()
        local pos = pivot.Position
        PreviewCharacter:PivotTo(CFrame.new(pos) * CFrame.Angles(0, angle, 0))
    end
end)

Player.CharacterAdded:Connect(function()
    task.wait(1.5)
    PreviewCharacter = buildCharacterPreview()
end)

-- =========================================================
-- DRAG ON TOP BAR
-- =========================================================

local dragging = false
local dragStart
local startPos

Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- =========================================================
-- OPEN / CLOSE
-- =========================================================

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "NOVUS_Open"
OpenButton.AnchorPoint = Vector2.new(0, 1)
OpenButton.Position = UDim2.new(0, 16, 1, -16)
OpenButton.Size = UDim2.fromOffset(112, 42)
OpenButton.BackgroundColor3 = C.Panel
OpenButton.Text = ""
OpenButton.AutoButtonColor = false
OpenButton.Visible = false
OpenButton.Parent = Gui
corner(OpenButton, 14)
stroke(OpenButton, C.Green2, 0.2, 1)

local OpenText = label(OpenButton, "NOVUS", 13, C.White, Enum.Font.GothamBold)
OpenText.Size = UDim2.fromScale(1, 1)
OpenText.TextXAlignment = Enum.TextXAlignment.Center

local function setOpen(value)
    if value then
        Main.Visible = true
        Backdrop.Visible = true
        OpenButton.Visible = false
        Main.Size = UDim2.fromScale(0.80, 0.70)
        tween(Main, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(0.86, 0.76)
        })
    else
        tween(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.fromScale(0.78, 0.68)
        }).Completed:Connect(function()
            Main.Visible = false
            Backdrop.Visible = false
            OpenButton.Visible = true
        end)
    end
end

Close.MouseButton1Click:Connect(function()
    setOpen(false)
end)
OpenButton.MouseButton1Click:Connect(function()
    setOpen(true)
end)

-- =========================================================
-- RESPONSIVE LANDSCAPE SIZING
-- =========================================================

local function updateScale()
    local size = Gui.AbsoluteSize
    if size.X <= 0 or size.Y <= 0 then return end

    local ratio = size.X / math.max(size.Y, 1)

    if ratio < 1.45 then
        -- Still keep landscape, but make the panel wider and sidebar smaller.
        Main.Size = UDim2.fromScale(0.94, 0.82)
        Sidebar.Size = UDim2.new(0, 145, 1, 0)
        PageHolder.Position = UDim2.fromOffset(145, 0)
        PageHolder.Size = UDim2.new(1, -145, 1, 0)
    else
        Main.Size = UDim2.fromScale(0.86, 0.76)
        Sidebar.Size = UDim2.new(0, 172, 1, 0)
        PageHolder.Position = UDim2.fromOffset(172, 0)
        PageHolder.Size = UDim2.new(1, -172, 1, 0)
    end
end

Gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScale)
task.defer(updateScale)

-- =========================================================
-- SMALL TOUCH PULSE
-- =========================================================

UserInputService.TouchTap:Connect(function(pos)
    local pulse = Instance.new("Frame")
    pulse.AnchorPoint = Vector2.new(0.5, 0.5)
    pulse.Position = UDim2.fromOffset(pos.X, pos.Y)
    pulse.Size = UDim2.fromOffset(8, 8)
    pulse.BackgroundColor3 = C.GreenBright
    pulse.BackgroundTransparency = 0.2
    pulse.BorderSizePixel = 0
    pulse.ZIndex = 999
    pulse.Parent = Gui
    corner(pulse, 99)

    tween(pulse, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
        Size = UDim2.fromOffset(42, 42),
        BackgroundTransparency = 1
    }).Completed:Connect(function()
        pulse:Destroy()
    end)
end)

-- Initial animation
Main.Size = UDim2.fromScale(0.80, 0.70)
tween(Main, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
    Size = UDim2.fromScale(0.86, 0.76)
})

print("[NOVUS] Mobile landscape interface loaded")

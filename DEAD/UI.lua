--[[
    NOVUS v0.2 — Mobile Glass / Neon Interface
    Rayfield Gen2 base + custom NOVUS visual layer.

    Focus:
    • Phone-first responsive layout
    • Animated particles
    • Moving neon grid
    • Scanline / glow effects
    • Animated NOVUS header
    • Live FPS / ping
    • Full rotating 3D avatar
    • Touch-friendly controls
    • Visual / Aim / Speed / Settings placeholders
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- =========================================================
-- RAYFIELD GEN2
-- =========================================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local Window = Rayfield:CreateWindow({
    name = "NOVUS",
    subtitle = "Interface Suite",
    sidebarLayout = true,
})

-- =========================================================
-- NOVUS PALETTE
-- =========================================================

local GREEN       = Color3.fromRGB(53, 211, 79)
local GREEN_DARK  = Color3.fromRGB(25, 130, 43)
local GREEN_GLOW  = Color3.fromRGB(95, 255, 117)
local BLACK       = Color3.fromRGB(7, 9, 10)
local DARK        = Color3.fromRGB(12, 15, 16)
local PANEL       = Color3.fromRGB(18, 22, 23)
local PANEL_2     = Color3.fromRGB(23, 28, 29)
local WHITE       = Color3.fromRGB(245, 250, 246)
local MUTED       = Color3.fromRGB(145, 155, 149)

-- =========================================================
-- HOME TAB
-- =========================================================

local Home = Window:CreateTab({
    name = "Home",
    icon = "home",
})

Home:CreateParagraph({
    title = "NOVUS",
    content = "Mobile-first control center • " .. LocalPlayer.DisplayName,
})

Home:CreateParagraph({
    title = "PROFILE",
    content = string.format(
        "@%s  •  User ID %d\nDisplay Name: %s",
        LocalPlayer.Name,
        LocalPlayer.UserId,
        LocalPlayer.DisplayName
    ),
})

-- =========================================================
-- CUSTOM NOVUS HUD
-- =========================================================

local function getGuiParent()
    local ok, result = pcall(function()
        return CoreGui
    end)
    if ok and result then
        return result
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local GuiParent = getGuiParent()

local old = GuiParent:FindFirstChild("NOVUS_VisualLayer")
if old then
    old:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NOVUS_VisualLayer"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = GuiParent

-- =========================================================
-- FULL-SCREEN AMBIENT BACKGROUND
-- =========================================================

local Ambient = Instance.new("Frame")
Ambient.Name = "Ambient"
Ambient.Size = UDim2.fromScale(1, 1)
Ambient.BackgroundColor3 = BLACK
Ambient.BackgroundTransparency = 0.72
Ambient.BorderSizePixel = 0
Ambient.ZIndex = 1
Ambient.Parent = ScreenGui

-- Top green aura
local AuraTop = Instance.new("Frame")
AuraTop.Size = UDim2.fromOffset(360, 160)
AuraTop.Position = UDim2.new(0.5, -180, -0.05, 0)
AuraTop.BackgroundColor3 = GREEN
AuraTop.BackgroundTransparency = 0.93
AuraTop.BorderSizePixel = 0
AuraTop.ZIndex = 2
AuraTop.Parent = Ambient

local AuraCorner = Instance.new("UICorner")
AuraCorner.CornerRadius = UDim.new(1, 0)
AuraCorner.Parent = AuraTop

-- =========================================================
-- ANIMATED GRID
-- =========================================================

local Grid = Instance.new("Frame")
Grid.Name = "Grid"
Grid.Size = UDim2.fromScale(1, 1)
Grid.BackgroundTransparency = 1
Grid.ZIndex = 2
Grid.Parent = Ambient

for i = 0, 16 do
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 1, 1, 0)
    line.Position = UDim2.new(i / 16, 0, 0, 0)
    line.BackgroundColor3 = GREEN
    line.BackgroundTransparency = 0.965
    line.BorderSizePixel = 0
    line.ZIndex = 2
    line.Parent = Grid
end

for i = 0, 10 do
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, i / 10, 0)
    line.BackgroundColor3 = GREEN
    line.BackgroundTransparency = 0.97
    line.BorderSizePixel = 0
    line.ZIndex = 2
    line.Parent = Grid
end

-- =========================================================
-- PARTICLE SYSTEM
-- =========================================================

local ParticleLayer = Instance.new("Frame")
ParticleLayer.Name = "Particles"
ParticleLayer.Size = UDim2.fromScale(1, 1)
ParticleLayer.BackgroundTransparency = 1
ParticleLayer.ClipsDescendants = true
ParticleLayer.ZIndex = 3
ParticleLayer.Parent = Ambient

local rng = Random.new()

local function createParticle()
    local dot = Instance.new("Frame")
    local size = rng:NextNumber(1.5, 4)

    dot.Size = UDim2.fromOffset(size, size)
    dot.Position = UDim2.fromScale(rng:NextNumber(0, 1), rng:NextNumber(0, 1))
    dot.BackgroundColor3 = GREEN_GLOW
    dot.BackgroundTransparency = rng:NextNumber(0.25, 0.75)
    dot.BorderSizePixel = 0
    dot.ZIndex = 3
    dot.Parent = ParticleLayer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = dot

    local duration = rng:NextNumber(3, 7)
    local drift = rng:NextNumber(-0.04, 0.04)

    task.spawn(function()
        while dot.Parent do
            local target = UDim2.fromScale(
                math.clamp(dot.Position.X.Scale + drift, 0, 1),
                -0.05
            )

            local tween = TweenService:Create(
                dot,
                TweenInfo.new(duration, Enum.EasingStyle.Linear),
                {
                    Position = target,
                    BackgroundTransparency = rng:NextNumber(0.2, 0.85),
                }
            )

            tween:Play()
            tween.Completed:Wait()

            if dot.Parent then
                dot.Position = UDim2.fromScale(
                    rng:NextNumber(0, 1),
                    1.05
                )
            end
        end
    end)
end

for _ = 1, 28 do
    createParticle()
end

-- =========================================================
-- SCANLINES
-- =========================================================

local Scan = Instance.new("Frame")
Scan.Name = "Scanlines"
Scan.Size = UDim2.new(1, 0, 0, 2)
Scan.Position = UDim2.new(0, 0, -0.05, 0)
Scan.BackgroundColor3 = GREEN_GLOW
Scan.BackgroundTransparency = 0.93
Scan.BorderSizePixel = 0
Scan.ZIndex = 4
Scan.Parent = Ambient

task.spawn(function()
    while Scan.Parent do
        local tween = TweenService:Create(
            Scan,
            TweenInfo.new(4.5, Enum.EasingStyle.Linear),
            {Position = UDim2.new(0, 0, 1.05, 0)}
        )
        tween:Play()
        tween.Completed:Wait()
        Scan.Position = UDim2.new(0, 0, -0.05, 0)
    end
end)

-- =========================================================
-- PROFILE CARD
-- =========================================================

local Profile = Instance.new("Frame")
Profile.Name = "Profile"
Profile.AnchorPoint = Vector2.new(1, 0.5)
Profile.Size = UDim2.fromOffset(330, 500)
Profile.Position = UDim2.new(1, -18, 0.5, 0)
Profile.BackgroundColor3 = DARK
Profile.BackgroundTransparency = 0.08
Profile.BorderSizePixel = 0
Profile.ZIndex = 10
Profile.Parent = ScreenGui

local ProfileCorner = Instance.new("UICorner")
ProfileCorner.CornerRadius = UDim.new(0, 22)
ProfileCorner.Parent = Profile

local ProfileStroke = Instance.new("UIStroke")
ProfileStroke.Color = GREEN
ProfileStroke.Transparency = 0.45
ProfileStroke.Thickness = 1
ProfileStroke.Parent = Profile

local ProfileGradient = Instance.new("UIGradient")
ProfileGradient.Rotation = 90
ProfileGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 28, 22)),
    ColorSequenceKeypoint.new(0.45, DARK),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 9, 10)),
})
ProfileGradient.Parent = Profile

-- animated border pulse
task.spawn(function()
    while Profile.Parent do
        local a = TweenService:Create(
            ProfileStroke,
            TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Transparency = 0.72}
        )
        local b = TweenService:Create(
            ProfileStroke,
            TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Transparency = 0.35}
        )
        a:Play()
        a.Completed:Wait()
        b:Play()
        b.Completed:Wait()
    end
end)

-- Header
local Header = Instance.new("TextLabel")
Header.BackgroundTransparency = 1
Header.Position = UDim2.fromOffset(20, 16)
Header.Size = UDim2.new(1, -40, 0, 32)
Header.Font = Enum.Font.GothamBlack
Header.Text = "NOVUS"
Header.TextColor3 = GREEN
Header.TextSize = 25
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.ZIndex = 12
Header.Parent = Profile

local HeaderGlow = Instance.new("TextLabel")
HeaderGlow.BackgroundTransparency = 1
HeaderGlow.Position = UDim2.fromOffset(21, 17)
HeaderGlow.Size = UDim2.new(1, -40, 0, 32)
HeaderGlow.Font = Enum.Font.GothamBlack
HeaderGlow.Text = "NOVUS"
HeaderGlow.TextColor3 = GREEN_GLOW
HeaderGlow.TextTransparency = 0.86
HeaderGlow.TextSize = 25
HeaderGlow.TextXAlignment = Enum.TextXAlignment.Left
HeaderGlow.ZIndex = 11
HeaderGlow.Parent = Profile

local Status = Instance.new("TextLabel")
Status.BackgroundTransparency = 1
Status.Position = UDim2.fromOffset(21, 47)
Status.Size = UDim2.new(1, -42, 0, 18)
Status.Font = Enum.Font.GothamMedium
Status.Text = "●  ONLINE  /  MOBILE READY"
Status.TextColor3 = GREEN
Status.TextSize = 10
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.ZIndex = 12
Status.Parent = Profile

-- =========================================================
-- VIEWPORT
-- =========================================================

local Viewport = Instance.new("ViewportFrame")
Viewport.Name = "CharacterPreview"
Viewport.Position = UDim2.fromOffset(18, 76)
Viewport.Size = UDim2.new(1, -36, 0, 270)
Viewport.BackgroundColor3 = PANEL
Viewport.BackgroundTransparency = 0.12
Viewport.BorderSizePixel = 0
Viewport.Ambient = Color3.fromRGB(190, 210, 195)
Viewport.LightColor = Color3.fromRGB(255, 255, 255)
Viewport.LightDirection = Vector3.new(-1, -1, -1)
Viewport.ZIndex = 11
Viewport.Parent = Profile

local ViewCorner = Instance.new("UICorner")
ViewCorner.CornerRadius = UDim.new(0, 17)
ViewCorner.Parent = Viewport

local ViewStroke = Instance.new("UIStroke")
ViewStroke.Color = GREEN
ViewStroke.Transparency = 0.8
ViewStroke.Parent = Viewport

local ViewGradient = Instance.new("UIGradient")
ViewGradient.Rotation = 90
ViewGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 40, 27)),
    ColorSequenceKeypoint.new(0.5, PANEL),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 14, 12)),
})
ViewGradient.Parent = Viewport

local Camera = Instance.new("Camera")
Camera.Parent = Viewport
Viewport.CurrentCamera = Camera

local WorldModel = Instance.new("WorldModel")
WorldModel.Parent = Viewport

-- decorative ring behind avatar
local Ring = Instance.new("Frame")
Ring.Size = UDim2.fromOffset(175, 175)
Ring.AnchorPoint = Vector2.new(0.5, 0.5)
Ring.Position = UDim2.fromScale(0.5, 0.54)
Ring.BackgroundTransparency = 1
Ring.ZIndex = 11
Ring.Parent = Viewport

local RingStroke = Instance.new("UIStroke")
RingStroke.Color = GREEN
RingStroke.Thickness = 1
RingStroke.Transparency = 0.7
RingStroke.Parent = Ring

local RingCorner = Instance.new("UICorner")
RingCorner.CornerRadius = UDim.new(1, 0)
RingCorner.Parent = Ring

task.spawn(function()
    while Ring.Parent do
        local tween = TweenService:Create(
            Ring,
            TweenInfo.new(5, Enum.EasingStyle.Linear),
            {Rotation = Ring.Rotation + 360}
        )
        tween:Play()
        tween.Completed:Wait()
    end
end)

local CharacterClone
local rotation = 0

local function clearWorld()
    for _, child in ipairs(WorldModel:GetChildren()) do
        child:Destroy()
    end
end

local function buildCharacterPreview()
    clearWorld()
    CharacterClone = nil

    local character = LocalPlayer.Character
    if not character then
        return
    end

    local clone
    local ok = pcall(function()
        character.Archivable = true
        clone = character:Clone()
    end)

    if not ok or not clone then
        return
    end

    for _, item in ipairs(clone:GetDescendants()) do
        if item:IsA("Script") or item:IsA("LocalScript") or item:IsA("ModuleScript") then
            item:Destroy()
        elseif item:IsA("BasePart") then
            item.CanCollide = false
            item.Anchored = true
        end
    end

    clone.Parent = WorldModel
    CharacterClone = clone

    local humanoid = clone:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end

    local cf, size = clone:GetBoundingBox()
    local height = math.max(size.Y, 4)
    local distance = math.max(size.X, size.Z, height) * 1.55

    Camera.FieldOfView = 35
    Camera.CFrame = CFrame.lookAt(
        cf.Position + Vector3.new(0, height * 0.05, distance),
        cf.Position + Vector3.new(0, height * 0.05, 0)
    )
end

buildCharacterPreview()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    buildCharacterPreview()
end)

RunService.RenderStepped:Connect(function(delta)
    if CharacterClone and CharacterClone.Parent then
        rotation += delta * 0.55

        local pivot = CharacterClone:GetPivot()
        CharacterClone:PivotTo(
            CFrame.new(pivot.Position) * CFrame.Angles(0, rotation, 0)
        )
    end
end)

-- =========================================================
-- USER ID / AVATAR
-- =========================================================

local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.fromOffset(54, 54)
Avatar.Position = UDim2.fromOffset(20, 362)
Avatar.BackgroundColor3 = PANEL_2
Avatar.BorderSizePixel = 0
Avatar.Image = string.format(
    "rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150",
    LocalPlayer.UserId
)
Avatar.ZIndex = 12
Avatar.Parent = Profile

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = Avatar

local AvatarStroke = Instance.new("UIStroke")
AvatarStroke.Color = GREEN
AvatarStroke.Transparency = 0.25
AvatarStroke.Thickness = 1
AvatarStroke.Parent = Avatar

local NameLabel = Instance.new("TextLabel")
NameLabel.BackgroundTransparency = 1
NameLabel.Position = UDim2.fromOffset(88, 362)
NameLabel.Size = UDim2.new(1, -108, 0, 23)
NameLabel.Font = Enum.Font.GothamBold
NameLabel.Text = LocalPlayer.DisplayName
NameLabel.TextColor3 = WHITE
NameLabel.TextSize = 16
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.ZIndex = 12
NameLabel.Parent = Profile

local UsernameLabel = Instance.new("TextLabel")
UsernameLabel.BackgroundTransparency = 1
UsernameLabel.Position = UDim2.fromOffset(88, 386)
UsernameLabel.Size = UDim2.new(1, -108, 0, 18)
UsernameLabel.Font = Enum.Font.Gotham
UsernameLabel.Text = "@" .. LocalPlayer.Name
UsernameLabel.TextColor3 = MUTED
UsernameLabel.TextSize = 11
UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
UsernameLabel.ZIndex = 12
UsernameLabel.Parent = Profile

local IdLabel = Instance.new("TextLabel")
IdLabel.BackgroundTransparency = 1
IdLabel.Position = UDim2.fromOffset(88, 405)
IdLabel.Size = UDim2.new(1, -108, 0, 16)
IdLabel.Font = Enum.Font.Gotham
IdLabel.Text = "ID  " .. tostring(LocalPlayer.UserId)
IdLabel.TextColor3 = GREEN
IdLabel.TextSize = 10
IdLabel.TextXAlignment = Enum.TextXAlignment.Left
IdLabel.ZIndex = 12
IdLabel.Parent = Profile

-- =========================================================
-- STATS CARDS
-- =========================================================

local function statCard(x, title, valueColor)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.5, -27, 0, 55)
    card.Position = UDim2.new(x, x == 0 and 20 or 7, 0, 433)
    card.BackgroundColor3 = PANEL_2
    card.BackgroundTransparency = 0.12
    card.BorderSizePixel = 0
    card.ZIndex = 12
    card.Parent = Profile

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = GREEN
    stroke.Transparency = 0.86
    stroke.Parent = card

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.fromOffset(10, 7)
    label.Size = UDim2.new(1, -20, 0, 14)
    label.Font = Enum.Font.GothamMedium
    label.Text = title
    label.TextColor3 = MUTED
    label.TextSize = 9
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 13
    label.Parent = card

    local value = Instance.new("TextLabel")
    value.BackgroundTransparency = 1
    value.Position = UDim2.fromOffset(10, 21)
    value.Size = UDim2.new(1, -20, 0, 27)
    value.Font = Enum.Font.GothamBold
    value.Text = "--"
    value.TextColor3 = valueColor
    value.TextSize = 16
    value.TextXAlignment = Enum.TextXAlignment.Left
    value.ZIndex = 13
    value.Parent = card

    return value
end

local FPSLabel = statCard(0, "FRAME RATE", GREEN)
local PingLabel = statCard(0.5, "NETWORK PING", WHITE)

-- =========================================================
-- LIVE STATS
-- =========================================================

local frames = 0
local elapsed = 0

RunService.RenderStepped:Connect(function(delta)
    frames += 1
    elapsed += delta

    if elapsed >= 0.5 then
        local fps = math.floor(frames / elapsed + 0.5)
        frames = 0
        elapsed = 0
        FPSLabel.Text = tostring(fps) .. " FPS"

        if fps >= 100 then
            FPSLabel.TextColor3 = GREEN_GLOW
        elseif fps >= 60 then
            FPSLabel.TextColor3 = GREEN
        else
            FPSLabel.TextColor3 = Color3.fromRGB(255, 190, 80)
        end
    end
end)

task.spawn(function()
    while ScreenGui.Parent do
        local ping

        pcall(function()
            local network = Stats:FindFirstChild("Network")
            local serverStats = network and network:FindFirstChild("ServerStatsItem")
            local dataPing = serverStats and serverStats:FindFirstChild("Data Ping")
            if dataPing then
                ping = math.floor(dataPing:GetValue() + 0.5)
            end
        end)

        if ping then
            PingLabel.Text = tostring(ping) .. " ms"

            if ping <= 60 then
                PingLabel.TextColor3 = GREEN_GLOW
            elseif ping <= 120 then
                PingLabel.TextColor3 = WHITE
            else
                PingLabel.TextColor3 = Color3.fromRGB(255, 190, 80)
            end
        else
            PingLabel.Text = "-- ms"
        end

        task.wait(1)
    end
end)

-- =========================================================
-- PHONE-FIRST RESPONSIVE LAYOUT
-- =========================================================

local function updateResponsive()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local size = camera.ViewportSize
    local width = size.X
    local height = size.Y

    if width <= 500 then
        -- Portrait phone
        Profile.AnchorPoint = Vector2.new(0.5, 1)
        Profile.Size = UDim2.new(1, -18, 0, math.min(475, height - 18))
        Profile.Position = UDim2.new(0.5, 0, 1, -9)

        Viewport.Size = UDim2.new(1, -30, 0, math.min(240, height * 0.36))
        Viewport.Position = UDim2.fromOffset(15, 72)

        Ring.Size = UDim2.fromOffset(150, 150)
        Ring.Position = UDim2.fromScale(0.5, 0.54)

        Header.TextSize = 22
    elseif width <= 850 then
        -- Tablet / small landscape
        Profile.AnchorPoint = Vector2.new(1, 0.5)
        Profile.Size = UDim2.fromOffset(310, 455)
        Profile.Position = UDim2.new(1, -12, 0.5, 0)

        Viewport.Size = UDim2.new(1, -30, 0, 245)
        Viewport.Position = UDim2.fromOffset(15, 72)

        Ring.Size = UDim2.fromOffset(160, 160)
    else
        -- Desktop
        Profile.AnchorPoint = Vector2.new(1, 0.5)
        Profile.Size = UDim2.fromOffset(330, 500)
        Profile.Position = UDim2.new(1, -22, 0.5, 0)

        Viewport.Size = UDim2.new(1, -36, 0, 270)
        Viewport.Position = UDim2.fromOffset(18, 76)

        Ring.Size = UDim2.fromOffset(175, 175)
    end
end

updateResponsive()

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsive)
end

-- =========================================================
-- TOUCH FEEDBACK
-- =========================================================

local function addTouchPulse(guiObject)
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            local original = guiObject.Size

            TweenService:Create(
                guiObject,
                TweenInfo.new(0.08, Enum.EasingStyle.Quad),
                {
                    Size = UDim2.new(
                        original.X.Scale,
                        original.X.Offset - 4,
                        original.Y.Scale,
                        original.Y.Offset - 4
                    )
                }
            ):Play()

            task.delay(0.08, function()
                if guiObject.Parent then
                    TweenService:Create(
                        guiObject,
                        TweenInfo.new(0.12, Enum.EasingStyle.Back),
                        {Size = original}
                    ):Play()
                end
            end)
        end
    end)
end

addTouchPulse(Viewport)
addTouchPulse(Avatar)

-- =========================================================
-- OTHER TABS
-- =========================================================

local Visuals = Window:CreateTab({
    name = "Visuals",
    icon = "eye",
})

Visuals:CreateParagraph({
    title = "VISUALS",
    content = "NOVUS visual module.",
})

Visuals:CreateToggle({
    name = "NOVUS Ambient",
    description = "Toggle the animated NOVUS visual layer.",
    value = true,
    callback = function(value)
        Ambient.Visible = value
    end,
})

local Aim = Window:CreateTab({
    name = "Aim",
    icon = "crosshair",
})

Aim:CreateParagraph({
    title = "AIM",
    content = "NOVUS aim module.",
})

local Speed = Window:CreateTab({
    name = "Speed",
    icon = "gauge",
})

Speed:CreateParagraph({
    title = "SPEED",
    content = "NOVUS movement module.",
})

local Settings = Window:CreateTab({
    name = "Settings",
    icon = "settings",
})

Settings:CreateToggle({
    name = "Profile Card",
    description = "Show the animated Home profile card.",
    value = true,
    callback = function(value)
        Profile.Visible = value
    end,
})

Settings:CreateToggle({
    name = "Particles",
    description = "Toggle the floating NOVUS particles.",
    value = true,
    callback = function(value)
        ParticleLayer.Visible = value
    end,
})

Settings:CreateToggle({
    name = "Grid",
    description = "Toggle the subtle animated background grid.",
    value = true,
    callback = function(value)
        Grid.Visible = value
    end,
})

Settings:CreateToggle({
    name = "Scanline",
    description = "Toggle the moving scanline effect.",
    value = true,
    callback = function(value)
        Scan.Visible = value
    end,
})

Settings:CreateButton({
    name = "Refresh 3D Character",
    callback = function()
        buildCharacterPreview()
    end,
})

Settings:CreateParagraph({
    title = "NOVUS",
    content = "v0.2 • Mobile-first • Rayfield Gen2",
})

-- =========================================================
-- CLEANUP
-- =========================================================

ScreenGui.AncestryChanged:Connect(function(_, parent)
    if not parent then
        return
    end
end)

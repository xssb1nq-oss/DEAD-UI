--[[
    NOVA Interface
    v1.0.0
    Liquid Glass Pro UI
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

--// Liquid Glass Pro
local LiquidGlass = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/alexkkork/liquid-glass-luau/main/LiquidGlassPro.luau"
))()

--// =========================================================
--// NOVA CONFIG
--// =========================================================

local NOVA = {
    Name = "NOVA",
    Version = "v1.0.0",

    Accent = Color3.fromRGB(170, 90, 255),
    Background = Color3.fromRGB(10, 8, 15),
    Glass = Color3.fromRGB(30, 25, 40),

    CurrentTab = "Home",
}

--// =========================================================
--// SCREEN GUI
--// =========================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NOVA"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

--// =========================================================
--// BACKGROUND
--// =========================================================

local Background = Instance.new("Frame")
Background.Name = "Background"
Background.Size = UDim2.fromScale(1, 1)
Background.BackgroundColor3 = NOVA.Background
Background.BorderSizePixel = 0
Background.Parent = ScreenGui

-- subtle purple light
local Glow = Instance.new("Frame")
Glow.Name = "Glow"
Glow.Size = UDim2.fromOffset(500, 500)
Glow.Position = UDim2.new(0.5, -250, 0.5, -250)
Glow.BackgroundColor3 = NOVA.Accent
Glow.BackgroundTransparency = 0.94
Glow.BorderSizePixel = 0
Glow.Parent = Background

local GlowCorner = Instance.new("UICorner")
GlowCorner.CornerRadius = UDim.new(1, 0)
GlowCorner.Parent = Glow

--// =========================================================
--// MAIN WINDOW
--// =========================================================

local Window = LiquidGlass.new({
    Size = UDim2.new(0.9, 0, 0.8, 0),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),

    Parent = ScreenGui,

    CornerRadius = UDim.new(0, 24),

    BackgroundColor = NOVA.Glass,
    BackgroundTransparency = 0.72,

    BlurTint = Color3.fromRGB(45, 35, 60),

    BorderColor = Color3.fromRGB(210, 180, 255),
    BorderTransparency = 0.72,
    BorderThickness = 1.2,

    ShadowColor = Color3.fromRGB(0, 0, 0),
    ShadowTransparency = 0.55,
    ShadowOffset = Vector2.new(0, 12),
    ShadowSize = 30,

    -- Liquid Glass Pro
    Chromatic = {
        Enabled = true,
        Intensity = 0.35,
    },

    Refraction = {
        Enabled = true,
        EdgeWidth = 6,
    },

    Border = {
        GradientEnabled = true,
        MouseResponsive = true,
    },

    Interaction = {
        Elasticity = 0.12,
    },

    HoverHighlight = false,
})

local MainFrame = Window:GetFrame()

--// =========================================================
--// HEADER
--// =========================================================

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, -32, 0, 65)
Header.Position = UDim2.fromOffset(16, 12)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Logo = Instance.new("TextLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.fromOffset(150, 34)
Logo.Position = UDim2.fromOffset(8, 3)
Logo.BackgroundTransparency = 1
Logo.Text = "✦  NOVA"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 22
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.Parent = Header

local Version = Instance.new("TextLabel")
Version.Size = UDim2.fromOffset(100, 20)
Version.Position = UDim2.fromOffset(10, 36)
Version.BackgroundTransparency = 1
Version.Text = NOVA.Version
Version.TextColor3 = Color3.fromRGB(155, 145, 165)
Version.Font = Enum.Font.Gotham
Version.TextSize = 11
Version.TextXAlignment = Enum.TextXAlignment.Left
Version.Parent = Header

--// STATUS

local Status = LiquidGlass.new({
    Size = UDim2.fromOffset(105, 34),
    Position = UDim2.new(1, -60, 0, 20),
    AnchorPoint = Vector2.new(1, 0),

    Parent = Header,

    CornerRadius = UDim.new(0, 17),

    BackgroundColor = Color3.fromRGB(60, 45, 75),
    BackgroundTransparency = 0.55,

    BlurTint = Color3.fromRGB(120, 80, 150),

    BorderColor = Color3.fromRGB(190, 150, 255),
    BorderTransparency = 0.75,

    HoverHighlight = false,

    Chromatic = {
        Enabled = true,
        Intensity = 0.2,
    },

    Refraction = {
        Enabled = true,
        EdgeWidth = 4,
    },

    Border = {
        GradientEnabled = true,
        MouseResponsive = true,
    },
})

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.fromScale(1, 1)
StatusText.BackgroundTransparency = 1
StatusText.Text = "●  ACTIVE"
StatusText.TextColor3 = Color3.fromRGB(220, 190, 255)
StatusText.Font = Enum.Font.GothamMedium
StatusText.TextSize = 12
StatusText.Parent = Status:GetContentFrame()

--// =========================================================
--// SIDEBAR
--// =========================================================

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 150, 1, -100)
Sidebar.Position = UDim2.fromOffset(16, 85)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

local Tabs = {
    {
        Name = "Home",
        Icon = "⌂",
    },

    {
        Name = "Visuals",
        Icon = "◇",
    },

    {
        Name = "Aim",
        Icon = "◎",
    },

    {
        Name = "Speed",
        Icon = "≋",
    },

    {
        Name = "Settings",
        Icon = "⚙",
    },

    {
        Name = "Info",
        Icon = "ⓘ",
    },
}

local TabButtons = {}

--// =========================================================
--// CONTENT
--// =========================================================

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -190, 1, -100)
Content.Position = UDim2.fromOffset(175, 85)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local CurrentContent

local function ClearContent()
    if CurrentContent then
        CurrentContent:Destroy()
        CurrentContent = nil
    end
end

--// TEXT HELPERS

local function CreateTitle(parent, text, position)
    local Label = Instance.new("TextLabel")

    Label.Size = UDim2.new(1, -20, 0, 35)
    Label.Position = position or UDim2.fromOffset(10, 5)

    Label.BackgroundTransparency = 1
    Label.Text = text

    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 23
    Label.TextXAlignment = Enum.TextXAlignment.Left

    Label.Parent = parent

    return Label
end

local function CreateSubtitle(parent, text, position)
    local Label = Instance.new("TextLabel")

    Label.Size = UDim2.new(1, -20, 0, 25)
    Label.Position = position

    Label.BackgroundTransparency = 1
    Label.Text = text

    Label.TextColor3 = Color3.fromRGB(150, 140, 160)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left

    Label.Parent = parent

    return Label
end

--// =========================================================
--// GLASS CARD
--// =========================================================

local function CreateCard(size, position)
    local Card = LiquidGlass.new({
        Size = size,
        Position = position,

        Parent = CurrentContent,

        CornerRadius = UDim.new(0, 18),

        BackgroundColor = Color3.fromRGB(35, 28, 45),
        BackgroundTransparency = 0.68,

        BlurTint = Color3.fromRGB(70, 50, 85),

        BorderColor = Color3.fromRGB(210, 180, 255),
        BorderTransparency = 0.82,
        BorderThickness = 1,

        ShadowColor = Color3.fromRGB(0, 0, 0),
        ShadowTransparency = 0.7,
        ShadowOffset = Vector2.new(0, 6),
        ShadowSize = 18,

        Chromatic = {
            Enabled = true,
            Intensity = 0.22,
        },

        Refraction = {
            Enabled = true,
            EdgeWidth = 5,
        },

        Border = {
            GradientEnabled = true,
            MouseResponsive = true,
        },

        Interaction = {
            Elasticity = 0.08,
        },
    })

    return Card
end

--// =========================================================
--// HOME
--// =========================================================

local function ShowHome()

    ClearContent()

    CurrentContent = Instance.new("Frame")
    CurrentContent.Size = UDim2.fromScale(1, 1)
    CurrentContent.BackgroundTransparency = 1
    CurrentContent.Parent = Content

    CreateTitle(
        CurrentContent,
        "Home",
        UDim2.fromOffset(10, 5)
    )

    CreateSubtitle(
        CurrentContent,
        "Welcome back to NOVA.",
        UDim2.fromOffset(10, 38)
    )

    -- Status card
    local Card = CreateCard(
        UDim2.new(1, -20, 0, 115),
        UDim2.fromOffset(10, 75)
    )

    local CardTitle = Instance.new("TextLabel")
    CardTitle.Size = UDim2.new(1, -30, 0, 25)
    CardTitle.Position = UDim2.fromOffset(15, 15)
    CardTitle.BackgroundTransparency = 1
    CardTitle.Text = "SYSTEM STATUS"
    CardTitle.TextColor3 = Color3.fromRGB(170, 155, 185)
    CardTitle.Font = Enum.Font.GothamMedium
    CardTitle.TextSize = 11
    CardTitle.TextXAlignment = Enum.TextXAlignment.Left
    CardTitle.Parent = Card:GetContentFrame()

    local Active = Instance.new("TextLabel")
    Active.Size = UDim2.new(1, -30, 0, 35)
    Active.Position = UDim2.fromOffset(15, 43)
    Active.BackgroundTransparency = 1
    Active.Text = "●  SYSTEM ACTIVE"
    Active.TextColor3 = Color3.fromRGB(220, 190, 255)
    Active.Font = Enum.Font.GothamBold
    Active.TextSize = 17
    Active.TextXAlignment = Enum.TextXAlignment.Left
    Active.Parent = Card:GetContentFrame()

    -- Profile
    local Profile = CreateCard(
        UDim2.new(0.48, -10, 0, 130),
        UDim2.fromOffset(10, 205)
    )

    local ProfileTitle = Instance.new("TextLabel")
    ProfileTitle.Size = UDim2.new(1, -25, 0, 25)
    ProfileTitle.Position = UDim2.fromOffset(15, 15)
    ProfileTitle.BackgroundTransparency = 1
    ProfileTitle.Text = "PROFILE"
    ProfileTitle.TextColor3 = Color3.fromRGB(170, 155, 185)
    ProfileTitle.Font = Enum.Font.GothamMedium
    ProfileTitle.TextSize = 11
    ProfileTitle.TextXAlignment = Enum.TextXAlignment.Left
    ProfileTitle.Parent = Profile:GetContentFrame()

    local Username = Instance.new("TextLabel")
    Username.Size = UDim2.new(1, -25, 0, 35)
    Username.Position = UDim2.fromOffset(15, 45)
    Username.BackgroundTransparency = 1
    Username.Text = Player.DisplayName
    Username.TextColor3 = Color3.new(1, 1, 1)
    Username.Font = Enum.Font.GothamBold
    Username.TextSize = 17
    Username.TextXAlignment = Enum.TextXAlignment.Left
    Username.Parent = Profile:GetContentFrame()

    local UserTag = Instance.new("TextLabel")
    UserTag.Size = UDim2.new(1, -25, 0, 20)
    UserTag.Position = UDim2.fromOffset(15, 78)
    UserTag.BackgroundTransparency = 1
    UserTag.Text = "@" .. Player.Name
    UserTag.TextColor3 = Color3.fromRGB(145, 135, 155)
    UserTag.Font = Enum.Font.Gotham
    UserTag.TextSize = 11
    UserTag.TextXAlignment = Enum.TextXAlignment.Left
    UserTag.Parent = Profile:GetContentFrame()

    -- Version
    local VersionCard = CreateCard(
        UDim2.new(0.48, -10, 0, 130),
        UDim2.new(0.52, 0, 0, 205)
    )

    local VTitle = Instance.new("TextLabel")
    VTitle.Size = UDim2.new(1, -25, 0, 25)
    VTitle.Position = UDim2.fromOffset(15, 15)
    VTitle.BackgroundTransparency = 1
    VTitle.Text = "NOVA"
    VTitle.TextColor3 = Color3.fromRGB(170, 155, 185)
    VTitle.Font = Enum.Font.GothamMedium
    VTitle.TextSize = 11
    VTitle.TextXAlignment = Enum.TextXAlignment.Left
    VTitle.Parent = VersionCard:GetContentFrame()

    local VNumber = Instance.new("TextLabel")
    VNumber.Size = UDim2.new(1, -25, 0, 40)
    VNumber.Position = UDim2.fromOffset(15, 45)
    VNumber.BackgroundTransparency = 1
    VNumber.Text = NOVA.Version
    VNumber.TextColor3 = Color3.new(1, 1, 1)
    VNumber.Font = Enum.Font.GothamBold
    VNumber.TextSize = 22
    VNumber.TextXAlignment = Enum.TextXAlignment.Left
    VNumber.Parent = VersionCard:GetContentFrame()

end

--// =========================================================
--// PLACEHOLDER PAGES
--// =========================================================

local function ShowPage(Name)

    ClearContent()

    CurrentContent = Instance.new("Frame")
    CurrentContent.Size = UDim2.fromScale(1, 1)
    CurrentContent.BackgroundTransparency = 1
    CurrentContent.Parent = Content

    CreateTitle(
        CurrentContent,
        Name,
        UDim2.fromOffset(10, 5)
    )

    CreateSubtitle(
        CurrentContent,
        "This section is ready for NOVA modules.",
        UDim2.fromOffset(10, 38)
    )

    local Card = CreateCard(
        UDim2.new(1, -20, 0, 130),
        UDim2.fromOffset(10, 80)
    )

    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1, -30, 1, -30)
    Text.Position = UDim2.fromOffset(15, 15)
    Text.BackgroundTransparency = 1
    Text.Text = Name .. "\n\nNo modules configured yet."
    Text.TextColor3 = Color3.fromRGB(210, 200, 220)
    Text.Font = Enum.Font.Gotham
    Text.TextSize = 14
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.TextYAlignment = Enum.TextYAlignment.Top
    Text.Parent = Card:GetContentFrame()
end

--// =========================================================
--// TAB BUTTONS
--// =========================================================

local function SetTabVisual(Name)

    for TabName, Button in pairs(TabButtons) do

        if TabName == Name then
            Button:SetProperty(
                "BackgroundColor",
                Color3.fromRGB(75, 48, 95)
            )

            Button:SetProperty(
                "BackgroundTransparency",
                0.45
            )

        else
            Button:SetProperty(
                "BackgroundColor",
                Color3.fromRGB(35, 28, 45)
            )

            Button:SetProperty(
                "BackgroundTransparency",
                0.78
            )
        end
    end
end

local function SelectTab(Name)

    NOVA.CurrentTab = Name

    SetTabVisual(Name)

    if Name == "Home" then
        ShowHome()
    else
        ShowPage(Name)
    end
end

for Index, Tab in ipairs(Tabs) do

    local Button = LiquidGlass.new({
        Size = UDim2.new(1, -10, 0, 43),

        Position = UDim2.fromOffset(
            5,
            (Index - 1) * 49
        ),

        Parent = Sidebar,

        CornerRadius = UDim.new(0, 13),

        BackgroundColor = Color3.fromRGB(35, 28, 45),
        BackgroundTransparency = 0.78,

        BlurTint = Color3.fromRGB(55, 40, 70),

        BorderColor = Color3.fromRGB(190, 160, 230),
        BorderTransparency = 0.9,

        HoverHighlight = true,

        Chromatic = {
            Enabled = true,
            Intensity = 0.15,
        },

        Refraction = {
            Enabled = true,
            EdgeWidth = 3,
        },

        Border = {
            GradientEnabled = true,
            MouseResponsive = true,
        },

        Interaction = {
            Elasticity = 0.15,
        },

        OnClick = function()
            SelectTab(Tab.Name)
        end,
    })

    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1, -20, 1, 0)
    Text.Position = UDim2.fromOffset(10, 0)
    Text.BackgroundTransparency = 1
    Text.Text = Tab.Icon .. "   " .. Tab.Name
    Text.TextColor3 = Color3.fromRGB(220, 215, 225)
    Text.Font = Enum.Font.GothamMedium
    Text.TextSize = 13
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.Parent = Button:GetContentFrame()

    TabButtons[Tab.Name] = Button
end

--// =========================================================
--// INITIAL PAGE
--// =========================================================

SelectTab("Home")

print("NOVA " .. NOVA.Version .. " loaded.")

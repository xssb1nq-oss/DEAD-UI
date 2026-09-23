--// NOVA Liquid Glass TEST

local Players = game:GetService("Players")
local player = Players.LocalPlayer

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "NOVATest"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

--// обычный фон, чтобы точно видеть результат
local background = Instance.new("Frame")
background.Size = UDim2.fromScale(1, 1)
background.BackgroundColor3 = Color3.fromRGB(8, 7, 12)
background.BorderSizePixel = 0
background.Parent = gui

--// загрузка Liquid Glass Pro
local success, LiquidGlass = pcall(function()
    return loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/alexkkork/liquid-glass-luau/main/LiquidGlassPro.luau"
    ))()
end)

if not success then
    warn("[NOVA] LiquidGlass Pro ERROR:")
    warn(LiquidGlass)

    local errorLabel = Instance.new("TextLabel")
    errorLabel.Size = UDim2.new(1, -40, 0, 100)
    errorLabel.Position = UDim2.fromScale(0.5, 0.5)
    errorLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    errorLabel.BackgroundTransparency = 1
    errorLabel.Text = "LiquidGlass ERROR\n\n" .. tostring(LiquidGlass)
    errorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    errorLabel.Font = Enum.Font.GothamBold
    errorLabel.TextSize = 14
    errorLabel.TextWrapped = true
    errorLabel.Parent = gui

    return
end

print("[NOVA] LiquidGlass Pro loaded")

--// стеклянная кнопка
local button = LiquidGlass.CreateButton(
    "✦  NOVA",
    
    function()
        print("[NOVA] Button clicked")
    end,
    
    {
        Size = UDim2.fromOffset(260, 70),

        Position = UDim2.fromScale(0.5, 0.5),

        AnchorPoint = Vector2.new(0.5, 0.5),

        Parent = gui,

        CornerRadius = 35,

        Frost = {
            Intensity = 0.85,
            TintColor = Color3.fromRGB(170, 110, 255),
            TintOpacity = 0.12,
            NoiseIntensity = 0.015,
        },

        Chromatic = {
            Enabled = true,
            Intensity = 0.7,
            MaxOffset = 3,
        },

        Refraction = {
            Enabled = true,
            Intensity = 5,
            EdgeWidth = 7,
            Layers = 4,
            FalloffExponent = 2,
        },

        BorderGradient = {
            Enabled = true,
            Width = 1.5,
            BaseOpacity = 0.55,
        },

        Shadow = {
            Enabled = true,
            Blur = 25,
            Offset = Vector2.new(0, 10),
            Opacity = 0.2,
        },

        Interaction = {
            HoverScale = 1.03,
            PressScale = 0.96,
            ElasticEnabled = true,
            ElasticIntensity = 3,
        },
    }
)

print("[NOVA] UI created")

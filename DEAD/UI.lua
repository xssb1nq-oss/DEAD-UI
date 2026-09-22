local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local Window = Rayfield:CreateWindow({
    name = "DEAD//UI",
    sidebarLayout = true,
})

-- Home
local Home = Window:CreateTab({
    name = "Home",
    icon = "house",
})

Home:CreateSection({
    name = "DEAD//UI",
})

-- Visuals
local Visuals = Window:CreateTab({
    name = "Visuals",
    icon = "eye",
})

Visuals:CreateSection({
    name = "Visuals",
})

-- Aim
local Aim = Window:CreateTab({
    name = "Aim",
    icon = "crosshair",
})

Aim:CreateSection({
    name = "Aim",
})

-- Speedhack
local Speedhack = Window:CreateTab({
    name = "Speedhack",
    icon = "gauge",
})

Speedhack:CreateSection({
    name = "Speedhack",
})

-- Movement
local Movement = Window:CreateTab({
    name = "Movement",
    icon = "move",
})

Movement:CreateSection({
    name = "Movement",
})

-- Settings
local Settings = Window:CreateTab({
    name = "Settings",
    icon = "settings",
})

Settings:CreateSection({
    name = "Settings",
})

-- Other
local Other = Window:CreateTab({
    name = "Other",
    icon = "ellipsis",
})

Other:CreateSection({
    name = "Other",
})

local Library = (function()
if getgenv().Library then
    getgenv().Library:Unload()
end
local Library do
    local Workspace = game:GetService("Workspace")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")
    gethui = gethui or function()
        return CoreGui
    end
    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()
    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex
    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new
    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new
    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local UDim2FromOffset = UDim2.fromOffset
    local Vector2New = Vector2.new
    local Vector3New = Vector3.new
    local MathClamp = math.clamp
    local MathFloor = math.floor
    local MathAbs = math.abs
    local MathSin = math.sin
    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableClone = table.clone
    local TableUnpack = table.unpack
    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLower = string.lower
    local StringLen = string.len
    local InstanceNew = Instance.new
    local RectNew = Rect.new
    Library = {
        Theme = {},
        MenuKeybind = tostring(Enum.KeyCode.RightControl),
        Flags = {},
        Tween = {
            Time = 0.28,
            Style = Enum.EasingStyle.Quint,
            Direction = Enum.EasingDirection.Out
        },
        FadeSpeed = 0.2,
        Folders = {
            Directory = "css",
            Configs = "css/Configs",
            Assets = "css/Assets",
        },
        Pages = {},
        Sections = {},
        Connections = {},
        Threads = {},
        ThemeMap = {},
        ThemeItems = {},
        OpenFrames = {},
        SetFlags = {},
        UnnamedConnections = 0,
        UnnamedFlags = 0,
        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,
        Font = nil
    }
    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages
    local Keys = {
        ["Unknown"]="Unknown",["Backspace"]="Back",["Tab"]="Tab",["Clear"]="Clear",
        ["Return"]="Return",["Pause"]="Pause",["Escape"]="Escape",["Space"]="Space",
        ["QuotedDouble"]='"',["Hash"]="#",["Dollar"]="$",["Percent"]="%",["Ampersand"]="&",
        ["Quote"]="'",["LeftParenthesis"]="(",["RightParenthesis"]=")",["Asterisk"]="*",
        ["Plus】="+",["Comma"]=",",["Minus】="-",["Period】=".",["Slash"]="`",
        ["Three"]="3",["Seven"]="7",["Eight"]="8",["Colon"]=":",["Semicolon"]=";",
        ["LessThan"]="<",["GreaterThan"]=">",["Question"]="?",["Equals"]="=",["At"]="@",
        ["LeftBracket"]="LeftBracket",["RightBracket"]="RightBracked",["BackSlash"]="BackSlash",
        ["Caret"]="^",["Underscore】="_",["Backquote"]="`",["LeftCurly"]="{",["Pipe"]="|",
        ["RightCurly"]="}",["Tilde"]="~",["Delete"]="Delete",["End"]="End",
        ["KeypadZero"]="Keypad0",["KeypadOne"]="Keypad1",["KeypadTwo"]="Keypad2",
        ["KeypadThree"]="Keypad3",["KeypadFour"]="Keypad4",["KeypadFive"]="Keypad5",
        ["KeypadSix"]="Keypad6",["KeypadSeven"]="Keypad7",["KeypadEight"]="Keypad8",
        ["KeypadNine"]="Keypad9",["KeypadPeriod"]="KeypadP",["KeypadDivide"]="KeypadD",
        ["KeypadMultiply"]="KeypadM",["KeypadMinus"]="KeypadM",["KeypadPlus"]="KeypadP",
        ["KeypadEnter"]="KeypadE",["KeypadEquals"]="KeypadE",["Insert"]="Insert",
        ["Home"]="Home",["PageUp"]="PageUp",["PageDown"]="PageDown",
        ["RightShift"]="RightShift",["LeftShift"]="LeftShift",["RightControl"]="RightControl",
        ["LeftControl"]="LeftControl",["LeftAlt"]="LeftAlt",["RightAlt"]="RightAlt"
    }
    local Themes = {
        ["Preset"] = {
            ["Background"] = FromRGB(9, 9, 12),
            ["Outline"] = FromRGB(34, 34, 43),
            ["Inline"] = FromRGB(20, 20, 26),
            ["Accent"] = FromRGB(139, 149, 246),
            ["Text"] = FromRGB(235, 235, 242),
            ["Element"] = FromRGB(29, 29, 37)
        }
    }
    Library.Theme = TableClone(Themes["Preset"])
    for Index, Value in Library.Folders do
        if not isfolder(Value) then
            makefolder(Value)
        end
    end
    local Tween = {} do
        Tween.__index = Tween
        Tween.Create = function(self, Item, Info, Goal, IsRawItem)
            Item = IsRawItem and Item or Item.Instance
            Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)
            local NewTween = {
                Tween = TweenService:Create(Item, Info, Goal),
                Info = Info,
                Goal = Goal,
                Item = Item
            }
            NewTween.Tween:Play()
            setmetatable(NewTween, Tween)
            return NewTween
        end
        Tween.GetProperty = function(self, Item)
            Item = Item or self.Item
            if Item:IsA("Frame") then
                return {"BackgroundTransparency"}
            elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
                return {"TextTransparency", "BackgroundTransparency"}
            elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
                return {"BackgroundTransparency", "ImageTransparency"}
            elseif Item:IsA("ScrollingFrame") then
                return {"BackgroundTransparency", "ScrollBarImageTransparency"}
            elseif Item:IsA("TextBox") then
                return {"TextTransparency", "BackgroundTransparency"}
            elseif Item:IsA("UIStroke") then
                return {"Transparency"}
            end
        end
        Tween.FadeItem = function(self, Item, Property, Visibility, Speed)
            local Item = Item or self.Item
            local OldTransparency = Item[Property]
            Item[Property] = Visibility and 1 or OldTransparency
            local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
                [Property] = Visibility and OldTransparency or 1
            }, true)
            Library:Connect(NewTween.Tween.Completed, function()
                if not Visibility then
                    task.wait()
                    Item[Property] = OldTransparency
                end
            end)
            return NewTween
        end
        Tween.Get = function(self)
            if not self.Tween then
                return
            end
            return self.Tween, self.Info, self.Goal
        end
        Tween.Pause = function(self)
            if not self.Tween then
                return
            end
            self.Tween:Pause()
        end
        Tween.Play = function(self)
            if not self.Tween then
                return
            end
            self.Tween:Play()
        end
        Tween.Clean = function(self)
            if not self.Tween then
                return
            end
            Tween:Pause()
            self = nil
        end
    end
    local Instances = {} do
        Instances.__index = Instances
        Instances.Create = function(self, Class, Properties)
            local NewItem = {
                Instance = InstanceNew(Class),
                Properties = Properties,
                Class = Class
            }
            setmetatable(NewItem, Instances)
            for Property, Value in NewItem.Properties do
                NewItem.Instance[Property] = Value
            end
            return NewItem
        end
        Instances.AddToTheme = function(self, Properties)
            if not self.Instance then
                return
            end
            Library:AddToTheme(self, Properties)
            return self
        end
        Instances.ChangeItemTheme = function(self, Properties)
            if not self.Instance then
                return
            end
            Library:ChangeItemTheme(self, Properties)
        end
        Instances.Connect = function(self, Event, Callback, Name)
            if not self.Instance then
                return
            end
            if not self.Instance[Event] then
                return
            end
            return Library:Connect(self.Instance[Event], Callback, Name)
        end
        Instances.Tween = function(self, Info, Goal)
            if not self.Instance then
                return
            end
            return Tween:Create(self, Info, Goal)
        end
        Instances.Disconnect = function(self, Name)
            if not self.Instance then
                return
            end
            return Library:Disconnect(Name)
        end
        Instances.Clean = function(self)
            if not self.Instance then
                return
            end
            self.Instance:Destroy()
            self = nil
        end
        Instances.MakeDraggable = function(self)
            if not self.Instance then
                return
            end
            local Gui = self.Instance
            local Dragging = false
            local DragStart
            local StartPosition
            local Set = function(Input)
                local DragDelta = Input.Position - DragStart
                local NewX = StartPosition.X.Offset + DragDelta.X
                local NewY = StartPosition.Y.Offset + DragDelta.Y
                local ScreenSize = Gui.Parent.AbsoluteSize
                local GuiSize = Gui.AbsoluteSize
                NewX = MathClamp(NewX, 0, ScreenSize.X - GuiSize.X)
                NewY = MathClamp(NewY, 0, ScreenSize.Y - GuiSize.Y)
                self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, NewX, 0, NewY)})
            end
            local InputChanged
            self:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    DragStart = Input.Position
                    StartPosition = Gui.Position
                    if InputChanged then
                        return
                    end
                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Dragging = false
                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)
            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dragging then
                        Set(Input)
                    end
                end
            end)
            return Dragging
        end
        Instances.MakeResizeable = function(self, Minimum, Maximum)
            if not self.Instance then
                return
            end
            local Gui = self.Instance
            local Resizing = false
            local CurrentSide = nil
            local StartMouse = nil
            local StartPosition = nil
            local StartSize = nil
            local EdgeThickness = 2
            local MakeEdge = function(Name, Position, Size)
                local Button = Instances:Create("TextButton", {
                    Name = "\0",
                    Size = Size,
                    Position = Position,
                    BackgroundColor3 = FromRGB(166, 147, 243),
                    BackgroundTransparency = 1,
                    Text = "",
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Parent = Gui,
                    ZIndex = 99999,
                })
                Button:AddToTheme({BackgroundColor3 = "Accent"})
                return Button
            end
            local Edges = {
                {Button = MakeEdge("Left", UDim2New(0, 0, 0, 0), UDim2New(0, EdgeThickness, 1, 0)), Side = "L"},
                {Button = MakeEdge("Right", UDim2New(1, -EdgeThickness, 0, 0), UDim2New(0, EdgeThickness, 1, 0)), Side = "R"},
                {Button = MakeEdge("Top", UDim2New(0, 0, 0, 0), UDim2New(1, 0, 0, EdgeThickness)), Side = "T"},
                {Button = MakeEdge("Bottom", UDim2New(0, 0, 1, -EdgeThickness), UDim2New(1, 0, 0, EdgeThickness)), Side = "B"},
            }
            local BeginResizing = function(Side)
                Resizing = true
                CurrentSide = Side
                StartMouse = UserInputService:GetMouseLocation()
                StartPosition = Vector2New(Gui.Position.X.Offset, Gui.Position.Y.Offset)
                StartSize = Vector2New(Gui.Size.X.Offset, Gui.Size.Y.Offset)
                for Index, Value in Edges do
                    Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0 or 1
                end
            end
            local EndResizing = function()
                Resizing = false
                CurrentSide = nil
                for Index, Value in Edges do
                    Value.Button.Instance.BackgroundTransparency = 1
                end
            end
            for Index, Value in Edges do
                Value.Button:Connect("InputBegan", function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        BeginResizing(Value.Side)
                    end
                end)
            end
            Library:Connect(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Resizing then
                        EndResizing()
                    end
                end
            end)
            Library:Connect(RunService.RenderStepped, function()
                if not Resizing or not CurrentSide then
                    return
                end
                local MouseLocation = UserInputService:GetMouseLocation()
                local dx = MouseLocation.X - StartMouse.X
                local dy = MouseLocation.Y - StartMouse.Y
                local x, y = StartPosition.X, StartPosition.Y
                local w, h = StartSize.X, StartSize.Y
                if CurrentSide == "L" then
                    x = StartPosition.X + dx
                    w = StartSize.X - dx
                elseif CurrentSide == "R" then
                    w = StartSize.X + dx
                elseif CurrentSide == "T" then
                    y = StartPosition.Y + dy
                    h = StartSize.Y - dy
                elseif CurrentSide == "B" then
                    h = StartSize.Y + dy
                end
                if w < Minimum.X then
                    if CurrentSide == "L" then
                        x = x - (Minimum.X - w)
                    end
                    w = Minimum.X
                end
                if h < Minimum.Y then
                    if CurrentSide == "T" then
                        y = y - (Minimum.Y - h)
                    end
                    h = Minimum.Y
                end
                self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2FromOffset(x, y)})
                self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2FromOffset(w, h)})
            end)
        end
        Instances.OnHover = function(self, Function)
            if not self.Instance then
                return
            end
            return Library:Connect(self.Instance.MouseEnter, Function)
        end
        Instances.OnHoverLeave = function(self, Function)
            if not self.Instance then
                return
            end
            return Library:Connect(self.Instance.MouseLeave, Function)
        end
    end
    local CustomFont = {} do
        function CustomFont:New(Name, Weight, Style, Data)
            if not isfile(Data.Id) then
                writefile(Data.Id, game:HttpGet(Data.Url))
            end
            local Data = {
                name = Name,
                faces = {
                    {
                        name = Name,
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Data.Id)
                    }
                }
            }
            writefile(`{Library.Folders.Assets}/{Name}.font`, HttpService:JSONEncode(Data))
            return Font.new(getcustomasset(`{Library.Folders.Assets}/{Name}.font`))
        end
        do
            local loaded = pcall(function()
                Library.Font = CustomFont:New("SFProText", 400, "Regular", {
                    Id = "CSS_SFProText",
                    Url = "https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts/raw/master/SF-Pro-Text-Regular.otf"
                })
            end)
            if not loaded then
                pcall(function() delfile("CSS_SFProText") end)
                loaded = pcall(function()
                    Library.Font = CustomFont:New("Inter", 400, "Regular", {
                        Id = "CSS_Inter",
                        Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/Inter.ttf"
                    })
                end)
            end
            if not loaded then
                pcall(function() delfile("CSS_Inter") end)
                Library.Font = CustomFont:New("OutfitMedium", 400, "Regular", {
                    Id = "OutfitMedium",
                    Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/Outfit-Medium.ttf"
                })
            end
        end
    end
    Library.Holder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 2,
        ResetOnSpawn = false
    })
    Library.UnusedHolder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        Enabled = false,
        ResetOnSpawn = false
    })
    Library.Unload = function(self)
        for Index, Value in self.Connections do
            Value.Connection:Disconnect()
        end
        for Index, Value in self.Threads do
            coroutine.close(Value)
        end
        if self.Holder then
            self.Holder:Clean()
        end
        Library = nil
        getgenv().Library = nil
    end
    Library.Round = function(self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return MathFloor(Number * Multiplier) / Multiplier
    end
    Library.Thread = function(self, Function)
        local NewThread = coroutine.create(Function)
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()
        TableInsert(self.Threads, NewThread)
        return NewThread
    end
    Library.SafeCall = function(self, Function, ...)
        local Arguements = {...}
        local Success, Result = pcall(Function, TableUnpack(Arguements))
        if not Success then
            warn(Result)
            return false
        end
        return Success
    end
    Library.Connect = function(self, Event, Callback, Name)
        Name = Name or StringFormat("connection_number_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))
        local NewConnection = {
            Event = Event,
            Callback = Callback,
            Name = Name,
            Connection = nil
        }
        Library:Thread(function()
            NewConnection.Connection = Event:Connect(Callback)
        end)
        TableInsert(self.Connections, NewConnection)
        return NewConnection
    end
    Library.Disconnect = function(self, Name)
        for _, Connection in self.Connections do
            if Connection.Name == Name then
                Connection.Connection:Disconnect()
                break
            end
        end
    end
    Library.NextFlag = function(self)
        local FlagNumber = self.UnnamedFlags + 1
        return StringFormat("flag_number_%s_%s", FlagNumber, HttpService:GenerateGUID(false))
    end
    Library.AddToTheme = function(self, Item, Properties)
        if type(Item) == "table" then
            Item = Item.Instance or Item
        end
        local ThemeData = {
            Item = Item,
            Properties = Properties,
        }
        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                if not self.Theme[Value] then
                    Item[Property] = Value
                end
                Item[Property] = self.Theme[Value]
            else
                Item[Property] = Value()
            end
        end
        TableInsert(self.ThemeItems, ThemeData)
        self.ThemeMap[Item] = ThemeData
    end
    Library.ToRich = function(self, Text, Color)
        return `<font color="rgb({MathFloor(Color.R * 255)}, {MathFloor(Color.G * 255)}, {MathFloor(Color.B * 255)})">{Text}</font>`
    end
    Library.GetConfig = function(self)
        local Config = {}
        for Index, Value in Library.Flags do
            pcall(function()
                if type(Value) == "table" and Value.Key ~= nil then
                    Config[Index] = {Key = tostring(Value.Key), Mode = tostring(Value.Mode or "Toggle")}
                elseif type(Value) == "table" and Value.Color ~= nil then
                    local hex = "#FFFFFF"
                    if type(Value.HexValue) == "string" then
                        hex = "#" .. Value.HexValue
                    elseif typeof(Value.Color) == "Color3" then
                        hex = "#" .. Value.Color:ToHex()
                    end
                    Config[Index] = {Color = hex}
                else
                    Config[Index] = Value
                end
            end)
        end
        return HttpService:JSONEncode(Config)
    end
    Library.LoadConfig = function(self, Config)
        local OkDecoded, Decoded = pcall(function()
            return HttpService:JSONDecode(Config)
        end)
        if not OkDecoded or type(Decoded) ~= "table" then
            warn("[css] LoadConfig: файл конфига битый")
            return false
        end
        for Index, Value in Decoded do
            local SetFunction = Library.SetFlags[Index]
            if SetFunction then
                pcall(function()
                    if type(Value) == "table" and Value.Key ~= nil then
                        SetFunction(Value)
                    elseif type(Value) == "table" and Value.Color ~= nil then
                        SetFunction(Value.Color)
                    else
                        SetFunction(Value)
                    end
                end)
            end
        end
        return true
    end
    Library.DeleteConfig = function(self, Config)
        if isfile(Library.Folders.Configs .. "/" .. Config) then
            delfile(Library.Folders.Configs .. "/" .. Config)
        end
    end
    Library.RefreshConfigsList = function(self, Element)
        local List = {}
        local ReturnList = {}
        List = listfiles(Library.Folders.Configs)
        for Index = 1, #List do
            local File = List[Index]
            if File:sub(-5) == ".json" then
                local Position = File:find(".json", 1, true)
                local StartPosition = Position
                local Character = File:sub(Position, Position)
                while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                    Position = Position - 1
                    Character = File:sub(Position, Position)
                end
                if Character == "/" or Character == "\\" then
                    TableInsert(ReturnList, File:sub(Position + 1, StartPosition - 1))
                end
            end
        end
        Element:Refresh(ReturnList)
    end
    Library.ChangeItemTheme = function(self, Item, Properties)
        if type(Item) == "table" then
            Item = Item.Instance or Item
        end
        if not self.ThemeMap[Item] then
            return
        end
        self.ThemeMap[Item].Properties = Properties
        self.ThemeMap[Item] = self.ThemeMap[Item]
    end
    Library.ChangeTheme = function(self, Theme, Color)
        self.Theme[Theme] = Color
        for _, Item in self.ThemeItems do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end
    Library.IsMouseOverFrame = function(self, Frame)
        Frame = Frame.Instance
        local MousePosition = Vector2New(Mouse.X, Mouse.Y)
        return MousePosition.X >= Frame.AbsolutePosition.X and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X
        and MousePosition.Y >= Frame.AbsolutePosition.Y and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
    end
    Library.Lerp = function(self, Start, Finish, Time)
        return Start + (Finish - Start) * Time
    end
    Library.CompareVectors = function(self, PointA, PointB)
        return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
    end
    Library.IsClipped = function(self, Object, Column)
        local Parent = Column
        local BoundryTop = Parent.AbsolutePosition
        local BoundryBottom = BoundryTop + Parent.AbsoluteSize
        local Top = Object.AbsolutePosition
        local Bottom = Top + Object.AbsoluteSize
        return Library:CompareVectors(Top, BoundryTop) or Library:CompareVectors(BoundryBottom, Bottom)
    end
    Library.CreateColorpicker = function(self, Data)
        local Colorpicker = {
            Flag = Data.Flag,
            Hue = 0,
            Saturation = 0,
            Value = 0,
            Color = Color3.fromRGB(0, 0, 0),
            Hex = "#000000",
            IsOpen = false
        }
        local Items = {} do
            Items["ColorpickerButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Size = UDim2New(0, 16, 0, 16),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(148, 255, 237)
            })
            Instances:Create("UICorner", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(1, 0)
            })
            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                Color = Library.Theme["Outline"],
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = 'Outline'})
            Items["Glow"] = Instances:Create("ImageLabel", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                ImageColor3 = FromRGB(148, 255, 237),
                ScaleType = Enum.ScaleType.Slice,
                ImageTransparency = 0.800000011920929,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 25, 1, 25),
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "http://www.roblox.com/asset/?id=18245826428",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
            })
            Items["ColorpickerWindow"] = Instances:Create("TextButton", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Position = UDim2New(0, 94, 0, 60),
                Size = UDim2New(0, 160, 0, 160),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = Library.Theme["Background"]
            }):AddToTheme({BackgroundColor3 = 'Background'})
            Instances:Create("UICorner", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 6)
            })
            Items["Palette"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Position = UDim2New(0, 8, 0, 8),
                Size = UDim2New(1, -40, 1, -16),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(148, 255, 237)
            })
            Instances:Create("UICorner", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 5)
            })
            Items["Saturation"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 1, 1, 0),
                BorderSizePixel = 0
            })
            Instances:Create("UIGradient", {
                Parent = Items["Saturation"].Instance,
                Name = "\0",
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            })
            Instances:Create("UICorner", {
                Parent = Items["Saturation"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 5)
            })
            Items["Value"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 1, 1, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(0, 0, 0)
            })
            Instances:Create("UIGradient", {
                Parent = Items["Value"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            })
            Instances:Create("UICorner", {
                Parent = Items["Value"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 5)
            })
            Items["PaletteDragger"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 5, 0, 5),
                BorderSizePixel = 0
            })
            Instances:Create("UIStroke", {
                Parent = Items["PaletteDragger"].Instance,
                Name = "\0"
            })
            Instances:Create("UICorner", {
                Parent = Items["PaletteDragger"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(1, 0)
            })
            Items["Hue"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0),
                Position = UDim2New(1, -8, 0, 8),
                Size = UDim2New(0, 15, 1, -16),
                BorderSizePixel = 0,
                TextSize = 14
            })
            Instances:Create("UIGradient", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
            })
            Instances:Create("UICorner", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 6)
            })
            Items["HueDragger"] = Instances:Create("Frame", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 15, 0, 15),
                BorderSizePixel = 0
            })
            Instances:Create("UICorner", {
                Parent = Items["HueDragger"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(1, 0)
            })
            Instances:Create("UIStroke", {
                Parent = Items["HueDragger"].Instance,
                Name = "\0"
            })
        end
        function Colorpicker:Get()
            return Colorpicker.Color
        end
        function Colorpicker:Update()
            local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
            Colorpicker.Color = FromHSV(Hue, Saturation, Value)
            Colorpicker.HexValue = Colorpicker.Color:ToHex()
            Library.Flags[Colorpicker.Flag] = {
                Color = Colorpicker.Color,
                HexValue = Colorpicker.HexValue
            }
            Items["ColorpickerButton"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
            Items["Glow"]:Tween(nil, {ImageColor3 = Colorpicker.Color})
            Items["Palette"]:Tween(nil, {BackgroundColor3 = FromHSV(Hue, 1, 1)})
            if Data.Callback then
                Library:SafeCall(Data.Callback, Colorpicker.Color)
            end
        end
        local SlidingPalette = false
        local PaletteChanged
        function Colorpicker:SlidePalette(Input)
            if not Input or not SlidingPalette then
                return
            end
            local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
            local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)
            Colorpicker.Saturation = ValueX
            Colorpicker.Value = ValueY
            local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.955)
            local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.955)
            Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, SlideY, 0)})
            Colorpicker:Update()
        end
        local SlidingHue = false
        local HueChanged
        function Colorpicker:SlideHue(Input)
            if not Input or not SlidingHue then
                return
            end
            local ValueY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)
            Colorpicker.Hue = ValueY
            local SlideY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.91)
            Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, SlideY, 0)})
            Colorpicker:Update()
        end
        local Debounce = false
        local RenderStepped
        function Colorpicker:SetOpen(Bool)
            if Debounce then
                return
            end
            Colorpicker.IsOpen = Bool
            Debounce = true
            if Colorpicker.IsOpen then
                Items["ColorpickerWindow"].Instance.Visible = true
                Items["ColorpickerWindow"].Instance.Parent = Library.Holder.Instance
                RenderStepped = RunService.RenderStepped:Connect(function()
                    Items["ColorpickerWindow"].Instance.Position = UDim2New(
                        0,
                        Items["ColorpickerButton"].Instance.AbsolutePosition.X,
                        0,
                        Items["ColorpickerButton"].Instance.AbsolutePosition.Y + Items["ColorpickerButton"].Instance.AbsoluteSize.Y + 5
                    )
                end)
                for Index, Value in Library.OpenFrames do
                    if Value ~= Colorpicker then
                        Value:SetOpen(false)
                    end
                end
                Library.OpenFrames[Colorpicker] = Colorpicker
            else
                if Library.OpenFrames[Colorpicker] then
                    Library.OpenFrames[Colorpicker] = nil
                end
                if RenderStepped then
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end
            end
            local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
            TableInsert(Descendants, Items["ColorpickerWindow"].Instance)
            local NewTween
            for Index, Value in Descendants do
                local TransparencyProperty = Tween:GetProperty(Value)
                if not TransparencyProperty then
                    continue
                end
                if not Value.ClassName:find("UI") then
                    Value.ZIndex = (Colorpicker.IsOpen and Data.Section.IsSettings and 9) or (Colorpicker.IsOpen and not Data.Section.IsSettings and 3) or 1
                end
                if type(TransparencyProperty) == "table" then
                    for _, Property in TransparencyProperty do
                        NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                end
            end
            NewTween.Tween.Completed:Connect(function()
                Debounce = false
                Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
                task.wait(0.2)
                Items["ColorpickerWindow"].Instance.Parent = not Colorpicker.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
            end)
        end
        function Colorpicker:Set(Color)
            if type(Color) == "table" then
                Color = FromRGB(Color[1], Color[2], Color[3])
            elseif type(Color) == "string" then
                Color = FromHex(Color)
            end
            Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
            local PaletteValueX = MathClamp(1 - Colorpicker.Saturation, 0, 0.955)
            local PaletteValueY = MathClamp(1 - Colorpicker.Value, 0, 0.955)
            local HuePositionY = MathClamp(Colorpicker.Hue, 0, 0.955)
            Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(PaletteValueX, 0, PaletteValueY, 0)})
            Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, HuePositionY, 0)})
            Colorpicker:Update()
        end
        Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
            Colorpicker:SetOpen(not Colorpicker.IsOpen)
        end)
        Items["Palette"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                SlidingPalette = true
                Colorpicker:SlidePalette(Input)
                if PaletteChanged then
                    return
                end
                PaletteChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingPalette = false
                        PaletteChanged:Disconnect()
                        PaletteChanged = nil
                    end
                end)
            end
        end)
        Items["Hue"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                SlidingHue = true
                Colorpicker:SlideHue(Input)
                if HueChanged then
                    return
                end
                HueChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingHue = false
                        HueChanged:Disconnect()
                        HueChanged = nil
                    end
                end)
            end
        end)
        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if SlidingPalette then
                    Colorpicker:SlidePalette(Input)
                end
                if SlidingHue then
                    Colorpicker:SlideHue(Input)
                end
            end
        end)
        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if not Colorpicker.IsOpen then
                    return
                end
                if Library:IsMouseOverFrame(Items["ColorpickerWindow"]) then
                    return
                end
                Colorpicker:SetOpen(false)
            end
        end)
        if Data.Default then
            Colorpicker:Set(Data.Default)
        end
        Library.SetFlags[Colorpicker.Flag] = function(Value)
            Colorpicker:Set(Value)
        end
        return Colorpicker, Items
    end
    Library.CreateKeybind = function(self, Data)
        local Keybind = {
            Flag = Data.Flag,
            Value = "",
            Key = "",
            Mode = Data.Mode or Data.mode or "Toggle",
            Toggled = false,
            Picking = false,
            IsOpen = false
        }
        local Items = {} do
            Items["KeyButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme["Text"],
                Text = "[NONE]",
                AutoButtonColor = false,
                Size = UDim2New(0, 0, 1, 0),
                BackgroundColor3 = Library.Theme["Element"],
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 12
            }):AddToTheme({BackgroundColor3 = 'Element', TextColor3 = 'Text'})
            Instances:Create("UICorner", {
                Parent = Items["KeyButton"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 6)
            })
            Instances:Create("UIPadding", {
                Parent = Items["KeyButton"].Instance,
                Name = "\0",
                PaddingLeft = UDimNew(0, 7),
                PaddingRight = UDimNew(0, 7)
            })
            Items["KeybindWindow"] = Instances:Create("TextButton", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                Visible = false,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Position = UDim2New(0, 10, 0, 10),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                TextSize = 14,
                BackgroundColor3 = Library.Theme["Background"]
            }):AddToTheme({BackgroundColor3 = 'Background'})
            Instances:Create("UICorner", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 6)
            })
            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme["Text"],
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Toggle",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Size = UDim2New(0, 0, 0, 15),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14
            }):AddToTheme({TextColor3 = 'Text'})
            Instances:Create("UIListLayout", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            Instances:Create("UIPadding", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 10),
                PaddingBottom = UDimNew(0, 10),
                PaddingRight = UDimNew(0, 10),
                PaddingLeft = UDimNew(0, 10)
            })
            Items["Hold"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme["Text"],
                TextTransparency = 0.5,
                Text = "Hold",
                AutoButtonColor = false,
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14
            }):AddToTheme({TextColor3 = 'Text'})
            Items["Always"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme["Text"],
                TextTransparency = 0.5,
                Text = "Always",
                AutoButtonColor = false,
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14
            }):AddToTheme({TextColor3 = 'Text'})
        end
        local Modes = {
            Toggle = Items["Toggle"],
            Hold = Items["Hold"],
            Always = Items["Always"]
        }
        local Debounce = false
        local RenderStepped
        function Keybind:SetOpen(Bool)
            if Debounce then
                return
            end
            Keybind.IsOpen = Bool
            Debounce = true
            if Keybind.IsOpen then
                Items["KeybindWindow"].Instance.Visible = true
                Items["KeybindWindow"].Instance.Parent = Library.Holder.Instance
                RenderStepped = RunService.RenderStepped:Connect(function()
                    Items["KeybindWindow"].Instance.Position = UDim2New(
                        0,
                        Items["KeyButton"].Instance.AbsolutePosition.X,
                        0,
                        Items["KeyButton"].Instance.AbsolutePosition.Y + Items["KeyButton"].Instance.AbsoluteSize.Y + 5
                    )
                end)
                for Index, Value in Library.OpenFrames do
                    if Value ~= Keybind then
                        Value:SetOpen(false)
                    end
                end
                Library.OpenFrames[Keybind] = Keybind
            else
                if Library.OpenFrames[Keybind] then
                    Library.OpenFrames[Keybind] = nil
                end
                if RenderStepped then
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end
            end
            local Descendants = Items["KeybindWindow"].Instance:GetDescendants()
            TableInsert(Descendants, Items["KeybindWindow"].Instance)
            local NewTween
            for Index, Value in Descendants do
                local TransparencyProperty = Tween:GetProperty(Value)
                if not TransparencyProperty then
                    continue
                end
                if not Value.ClassName:find("UI") then
                    Value.ZIndex = Keybind.IsOpen and 4 or 1
                end
                if type(TransparencyProperty) == "table" then
                    for _, Property in TransparencyProperty do
                        NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                end
            end
            NewTween.Tween.Completed:Connect(function()
                Debounce = false
                Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
                task.wait(0.2)
                Items["KeybindWindow"].Instance.Parent = not Keybind.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
            end)
        end
        function Keybind:SetMode(Mode)
            for Index, Value in Modes do
                if Index == Mode then
                    Value:Tween(nil, {TextTransparency = 0})
                else
                    Value:Tween(nil, {TextTransparency = 0.5})
                end
            end
            Library.Flags[Keybind.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled
            }
            if Data.Callback then
                Library:SafeCall(Data.Callback, Keybind.Toggled)
            end
        end
        function Keybind:Press(Bool)
            if Keybind.Mode == "Toggle" then
                Keybind.Toggled = not Keybind.Toggled
            elseif Keybind.Mode == "Hold" then
                Keybind.Toggled = Bool
            elseif Keybind.Mode == "Always" then
                Keybind.Toggled = true
            end
            Library.Flags[Keybind.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled
            }
            if Data.Callback then
                Library:SafeCall(Data.Callback, Keybind.Toggled)
            end
        end
        function Keybind:Get()
            return Keybind.Key, Keybind.Mode, Keybind.Toggled
        end
        function Keybind:Set(Key)
            if StringFind(tostring(Key), "Enum") then
                Keybind.Key = tostring(Key)
                Key = Key.Name == "Backspace" and "None" or Key.Name
                local KeyString = Keys[Keybind.Key] or StringGSub(Key, "Enum.", "") or "None"
                local TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"
                Keybind.Value = TextToDisplay
                Items["KeyButton"].Instance.Text = "["..TextToDisplay.."]"
                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }
                if Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            elseif type(Key) == "table" then
                local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                Keybind.Key = tostring(Key.Key)
                if Key.Mode then
                    Keybind.Mode = Key.Mode
                    Keybind:SetMode(Key.Mode)
                else
                    Keybind.Mode = "Toggle"
                    Keybind:SetMode("Toggle")
                end
                local KeyString = Keys[Keybind.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
                local TextToDisplay = KeyString and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"
                TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")
                Keybind.Value = TextToDisplay
                Items["KeyButton"].Instance.Text = "["..TextToDisplay.."]"
                if Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            elseif TableFind({"Toggle", "Hold", "Always"}, Key) then
                Keybind.Mode = Key
                Keybind:SetMode(Key)
                if Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            end
            Keybind.Picking = false
        end
        Items["KeyButton"]:Connect("MouseButton1Click", function()
            Keybind.Picking = true
            Items["KeyButton"].Instance.Text = "..."
            local InputBegan
            InputBegan = UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.Keyboard then
                    if Input.KeyCode == Enum.KeyCode.Escape then
                        Keybind:Set(Enum.KeyCode.Backspace)
                    else
                        Keybind:Set(Input.KeyCode)
                    end
                else
                    Keybind:Set(Input.UserInputType)
                end
                InputBegan:Disconnect()
                InputBegan = nil
            end)
        end)
        Library:Connect(UserInputService.InputBegan, function(Input)
            if Keybind.Value == "None" then
                return
            end
            if tostring(Input.KeyCode) == Keybind.Key then
                if Keybind.Mode == "Toggle" then
                    Keybind:Press()
                elseif Keybind.Mode == "Hold" then
                    Keybind:Press(true)
                elseif Keybind.Mode == "Always" then
                    Keybind:Press(true)
                end
            elseif tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Mode == "Toggle" then
                    Keybind:Press()
                elseif Keybind.Mode == "Hold" then
                    Keybind:Press(true)
                elseif Keybind.Mode == "Always" then
                    Keybind:Press(true)
                end
            end
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not Keybind.IsOpen then
                    return
                end
                if Library:IsMouseOverFrame(Items["KeybindWindow"]) then
                    return
                end
                Keybind:SetOpen(false)
            end
        end)
        Library:Connect(UserInputService.InputEnded, function(Input)
            if Keybind.Value == "None" then
                return
            end
            if tostring(Input.KeyCode) == Keybind.Key then
                if Keybind.Mode == "Hold" then
                    Keybind:Press(false)
                elseif Keybind.Mode == "Always" then
                    Keybind:Press(true)
                end
            elseif tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Mode == "Hold" then
                    Keybind:Press(false)
                elseif Keybind.Mode == "Always" then
                    Keybind:Press(true)
                end
            end
        end)
        Items["KeyButton"]:Connect("MouseButton2Down", function()
            Keybind:SetOpen(not Keybind.IsOpen)
        end)
        Items["Toggle"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Toggle"
            Keybind:SetMode("Toggle")
        end)
        Items["Hold"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Hold"
            Keybind:SetMode("Hold")
        end)
        Items["Always"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Always"
            Keybind:SetMode("Always")
        end)
        if Data.Default then
            Keybind:Set({
                Mode = Data.Mode or "Toggle",
                Key = Data.Default,
            })
        end
        Library.SetFlags[Keybind.Flag] = function(Value)
            Keybind:Set(Value)
        end
        return Keybind, Items
    end
    do
        Library.Watermark = function(self, Name, Logo)
            local Watermark = {}
            local Items = {} do
                Items["Watermark"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0.5, 0),
                    Position = UDim2New(0.5, 0, 0, 20),
                    Size = UDim2New(0, 0, 0, 35),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                Items["Watermark"]:MakeDraggable()
                Instances:Create("UICorner", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 10)
                })
                Instances:Create("UIPadding", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })
                Items["Logo"] = Instances:Create("ImageLabel", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    Size = UDim2New(0, 25, 0, 25),
                    BorderSizePixel = 0
                })
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "css",
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 34, 0.5, -1),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 18
                }):AddToTheme({TextColor3 = 'Text'})
            end
            function Watermark:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end
            function Watermark:SetVisibility(Bool)
                Items["Watermark"].Instance.Visible = Bool
            end
            function Watermark:SetCenter()
                local CenterPosition = Items["Watermark"].Instance.AbsolutePosition
                task.wait()
                Items["Watermark"].Instance.AnchorPoint = Vector2New(0, 0)
                Items["Watermark"].Instance.Position = UDim2New(0, CenterPosition.X, 0, CenterPosition.Y)
            end
            Watermark:SetText(Name)
            Watermark:SetCenter()
            return Watermark
        end
        Library.Window = function(self, Data)
            Data = Data or {}
            local Window = {
                Name = Data.Name or Data.name or "Window",
                SubName = Data.SubName or Data.subname or "",
                Logo = Data.Logo or Data.logo or "rbxassetid://81441172534384",
                Pages = {},
                Items = {},
                IsOpen = false
            }
            local Items = {} do
                Items["MainFrame"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2New(0.5220375657081604, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 900, 0, 600),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                Items["MainFrame"]:MakeDraggable()
                Items["MainFrame"]:MakeResizeable(Vector2New(900, 600), Vector2New(9999, 9999))
                Instances:Create("UICorner", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 16)
                })
                Instances:Create("UIStroke", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    Transparency = 0.2,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                Items["Sidebar"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 200, 1, 0),
                    BorderSizePixel = 0
                })
                Instances:Create("Frame", {
                    Parent = Items["Sidebar"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, 0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                Items["Top"] = Instances:Create("Frame", {
                    Parent = Items["Sidebar"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 70),
                    BorderSizePixel = 0
                })
                Items["Logo"] = Instances:Create("ImageLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Image = Window.Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 20, 0, 20),
                    Size = UDim2New(0, 30, 0, 30),
                    BorderSizePixel = 0
                })
                Items["Title"] = Instances:Create("TextLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Window.Name,
                    Size = UDim2New(0, 0, 0, 14),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 60, 0, 15),
                    TextWrapped = true,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 18
                }):AddToTheme({TextColor3 = 'Text'})
                Items["Subtitle"] = Instances:Create("TextLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.4000000059604645,
                    Text = Window.SubName,
                    Size = UDim2New(0, 0, 0, 14),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 60, 0, 36),
                    TextWrapped = true,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                Instances:Create("Frame", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                Items["Pages"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["Sidebar"].Instance,
                    Name = "\0",
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2New(0, 0, 0, 0),
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    MidImage = "rbxassetid://128693616966482",
                    BorderColor3 = FromRGB(0, 0, 0),
                    ScrollBarThickness = 3,
                    Size = UDim2New(1, -16, 1, -185),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0, 78),
                    BottomImage = "rbxassetid://128693616966482",
                    TopImage = "rbxassetid://128693616966482"
                }):AddToTheme({ScrollBarImageColor3 = 'Accent'})
                Instances:Create("UIListLayout", {
                    Parent = Items["Pages"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                Instances:Create("UIPadding", {
                    Parent = Items["Pages"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 8),
                    PaddingBottom = UDimNew(0, 8),
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })
                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 200, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -200, 1, 0),
                    BorderSizePixel = 0
                })
                Items["TopBar"] = Instances:Create("Frame", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 0, 46)
                })
                Instances:Create("UIListLayout", {
                    Parent = Items["TopBar"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDimNew(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                Instances:Create("UIPadding", {
                    Parent = Items["TopBar"].Instance,
                    Name = "\0",
                    PaddingLeft = UDimNew(0, 14),
                    PaddingRight = UDimNew(0, 12)
                })
                Items["TopLeft"] = Instances:Create("Frame", {
                    Parent = Items["TopBar"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2New(0, 0, 0, 30),
                    AutomaticSize = Enum.AutomaticSize.XY,
                    LayoutOrder = 1
                })
                Instances:Create("UIListLayout", {
                    Parent = Items["TopLeft"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDimNew(0, 16),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                Items["PageTitle"] = Instances:Create("TextLabel", {
                    Parent = Items["TopLeft"].Instance,
                    FontFace = Library.Font,
                    Text = "",
                    TextColor3 = Library.Theme["Text"],
                    TextSize = 16,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    Size = UDim2New(0, 0, 0, 20),
                    LayoutOrder = 1
                }):AddToTheme({TextColor3 = 'Text'})
                Items["SearchBar"] = Instances:Create("Frame", {
                    Parent = Items["TopBar"].Instance,
                    Name = "\0",
                    BackgroundColor3 = Library.Theme["Element"],
                    BorderSizePixel = 0,
                    Size = UDim2New(0, 0, 0, 28),
                    LayoutOrder = 2
                }):AddToTheme({BackgroundColor3 = 'Element'})
                local SearchFlex = Instance.new("UIFlexItem")
                SearchFlex.FlexMode = Enum.UIFlexMode.Fill
                SearchFlex.Parent = Items["SearchBar"].Instance
                Instances:Create("UICorner", {
                    Parent = Items["SearchBar"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 8)
                })
                Instances:Create("UIStroke", {
                    Parent = Items["SearchBar"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    Transparency = 0.2,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                Instances:Create("ImageLabel", {
                    Parent = Items["SearchBar"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://121018724060431",
                    ImageColor3 = Library.Theme["Text"],
                    ImageTransparency = 0.3,
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 10, 0.5, 0),
                    Size = UDim2New(0, 13, 0, 13),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Text'})
                Items["SearchBox"] = Instances:Create("TextBox", {
                    Parent = Items["SearchBar"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    Text = "",
                    PlaceholderText = "Поиск...",
                    PlaceholderColor3 = Library.Theme["Text"],
                    TextColor3 = Library.Theme["Text"],
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2.fromScale(1, 1),
                    ClearTextOnFocus = false
                }):AddToTheme({TextColor3 = 'Text', PlaceholderColor3 = 'Text'})
                Instances:Create("UIPadding", {
                    Parent = Items["SearchBox"].Instance,
                    Name = "\0",
                    PaddingLeft = UDimNew(0, 30),
                    PaddingRight = UDimNew(0, 10)
                })
                Items["OptsBtn"] = Instances:Create("TextButton", {
                    Parent = Items["TopBar"].Instance,
                    Name = "\0",
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 30, 0, 30),
                    BackgroundColor3 = Library.Theme["Element"],
                    BorderSizePixel = 0,
                    LayoutOrder = 3
                }):AddToTheme({BackgroundColor3 = 'Element'})
                Instances:Create("UICorner", {
                    Parent = Items["OptsBtn"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })
                Instances:Create("UIStroke", {
                    Parent = Items["OptsBtn"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    Transparency = 0.25,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                Instances:Create("ImageLabel", {
                    Parent = Items["OptsBtn"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://85538382643347",
                    ImageColor3 = Library.Theme["Text"],
                    ImageTransparency = 0.25,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    Size = UDim2New(0, 15, 0, 15),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Text'})
                Instances:Create("Frame", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 0, 0, 46),
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 0, 1),
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                Library.SearchRows = {}
                local function ApplySearchFilter(Query)
                    Window.CurrentQuery = Query or ""
                    Query = StringLower(tostring(Query or ""):gsub("%s", ""))
                    for _, Row in ipairs(Library.SearchRows) do
                        Row.Frame.Visible = (Query == "") or (StringFind(Row.Text, Query, 1, true) ~= nil)
                    end
                end
                Window.ApplySearch = ApplySearchFilter
                Items["SearchBox"]:Connect("Changed", function(Property)
                    if Property == "Text" then
                        ApplySearchFilter(Items["SearchBox"].Instance.Text)
                    end
                end)
                Items["OptsBtn"]:Connect("MouseButton1Down", function()
                    for _, P in Window.Pages do
                        if P.Name == "Settings" and not P.Active then
                            for _, Other in Window.Pages do
                                Other:Turn(Other == P)
                            end
                        end
                    end
                end)
                Window.Items = Items
            end
            local Debounce = false
            function Window:SetCenter()
                local CenterPosition = Items["MainFrame"].Instance.AbsolutePosition
                task.wait()
                Items["MainFrame"].Instance.AnchorPoint = Vector2New(0, 0)
                Items["MainFrame"].Instance.Position = UDim2New(0, CenterPosition.X, 0, CenterPosition.Y)
            end
            function Window:SetOpen(Bool)
                if Debounce then
                    return
                end
                Window.IsOpen = Bool
                Debounce = true
                if Window.IsOpen then
                    Items["MainFrame"].Instance.Visible = true
                end
                task.delay(0.2, function()
                    Debounce = false
                    Items["MainFrame"].Instance.Visible = Window.IsOpen
                end)
            end
            Library:Connect(UserInputService.InputBegan, function(Input)
                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    Window:SetOpen(not Window.IsOpen)
                end
            end)
            Window:SetCenter()
            task.wait()
            Window:SetOpen(true)
            return setmetatable(Window, Library)
        end
        Library.Page = function(self, Data)
            Data = Data or {}
            local Page = {
                Window = self,
                Name = Data.Name or Data.name or "Page",
                Icon = Data.Icon or Data.icon or "rbxassetid://72196061405823",
                Items = {},
                Active = false,
                Tabs = {},
                TabOrder = {},
                CurrentTab = nil
            }
            Page.Window._NavCounter = (Page.Window._NavCounter or 0) + 1
            local Items = {} do
                Items["Inactive"] = Instances:Create("TextButton", {
                    Parent = Page.Window.Items["Pages"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 35),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    TextSize = 14,
                    LayoutOrder = Page.Window._NavCounter,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                Items["Background"] = Instances:Create("Frame", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 0, 0, 35),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Fit,
                    ImageTransparency = 0.4000000059604645,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = Page.Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0.5, 0),
                    Size = UDim2New(0, 18, 0, 18),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Text'})
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.4000000059604645,
                    Text = Page.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 38, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                Instances:Create("UICorner", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 8)
                })
                Items["Page"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Position = UDim2New(0, 0, 0, 46),
                    Size = UDim2New(1, 0, 1, -46),
                    BorderSizePixel = 0
                })
                Page.Items = Items
            end
            function Page:GetTab(TabName)
                TabName = TabName or "Основное"
                if Page.Tabs[TabName] then
                    return Page.Tabs[TabName]
                end
                local TabFrame = Instances:Create("Frame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    Visible = false,
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 1, 0)
                })
                Instances:Create("UIListLayout", {
                    Parent = TabFrame.Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDimNew(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                local Columns = {}
                for ColumnIndex = 1, 2 do
                    local Column = Instances:Create("ScrollingFrame", {
                        Parent = TabFrame.Instance,
                        Name = "\0",
                        ScrollBarImageColor3 = Library.Theme["Outline"],
                        ScrollBarThickness = 2,
                        Active = true,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        Size = UDim2New(1, 0, 1, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        CanvasSize = UDim2New(0, 0, 0, 0)
                    }):AddToTheme({ScrollBarImageColor3 = 'Outline'})
                    Instances:Create("UIPadding", {
                        Parent = Column.Instance,
                        Name = "\0",
                        PaddingTop = UDimNew(0, 4),
                        PaddingBottom = UDimNew(0, 10),
                        PaddingRight = UDimNew(0, 2),
                        PaddingLeft = UDimNew(0, 2)
                    })
                    Instances:Create("UIListLayout", {
                        Parent = Column.Instance,
                        Name = "\0",
                        Padding = UDimNew(0, 10),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })
                    Columns[ColumnIndex] = Column
                end
                local Button = Instances:Create("TextButton", {
                    Parent = Page.Window.Items["TopLeft"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    Text = TabName,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.45,
                    TextSize = 13,
                    BackgroundColor3 = Library.Theme["Accent"],
                    BackgroundTransparency = 1,
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    Size = UDim2New(0, 0, 0, 24),
                    Visible = false,
                    LayoutOrder = 1 + #Page.TabOrder
                }):AddToTheme({TextColor3 = 'Text', BackgroundColor3 = 'Accent'})
                Instances:Create("UICorner", {
                    Parent = Button.Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 8)
                })
                Instances:Create("UIPadding", {
                    Parent = Button.Instance,
                    Name = "\0",
                    PaddingLeft = UDimNew(0, 10),
                    PaddingRight = UDimNew(0, 10)
                })
                local Tab = {Name = TabName, Frame = TabFrame, Columns = Columns, Button = Button}
                Page.Tabs[TabName] = Tab
                table.insert(Page.TabOrder, TabName)
                Button:Connect("MouseButton1Down", function()
                    Page:SelectTab(TabName)
                end)
                Button:Connect("MouseEnter", function()
                    if Page.CurrentTab ~= TabName then
                        Button:Tween(nil, {TextTransparency = 0.15})
                    end
                end)
                Button:Connect("MouseLeave", function()
                    if Page.CurrentTab ~= TabName then
                        Button:Tween(nil, {TextTransparency = 0.45})
                    end
                end)
                if Page.Active and Page.CurrentTab == nil then
                    Page:SelectTab(TabName, true)
                end
                return Tab
            end
            function Page:SelectTab(TabName, SkipFade)
                if not Page.Tabs[TabName] then
                    return
                end
                local OldTab = Page.CurrentTab and Page.Tabs[Page.CurrentTab] or nil
                Page.CurrentTab = TabName
                for _, Name in Page.TabOrder do
                    local Tab = Page.Tabs[Name]
                    local IsCurrent = (Name == TabName)
                    Tab.Frame.Instance.Visible = IsCurrent
                    if #Page.TabOrder > 1 then
                        Tab.Button.Instance.Visible = Page.Active
                        Tab.Button:Tween(nil, {
                            TextColor3 = IsCurrent and Library.Theme.Accent or Library.Theme.Text,
                            TextTransparency = IsCurrent and 0 or 0.45,
                            BackgroundTransparency = IsCurrent and 0.84 or 1
                        })
                    else
                        Tab.Button.Instance.Visible = false
                    end
                    if IsCurrent then
                        Tab.Frame.Instance.Position = UDim2New(0, 0, 0, 14)
                        Tab.Frame:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, 0, 0)})
                    end
                end
                if OldTab and OldTab ~= Page.Tabs[TabName] and OldTab.OnHide then
                    OldTab.OnHide()
                end
                if Page.Tabs[TabName].OnSelect then
                    Page.Tabs[TabName].OnSelect()
                end
                if Page.Window.ApplySearch then
                    Page.Window.ApplySearch(Page.Window.CurrentQuery or "")
                end
            end
            local Debounce = false
            function Page:Turn(Bool)
                if Debounce then
                    return
                end
                Page.Active = Bool
                Debounce = true
                Items["Page"].Instance.Visible = Bool
                Items["Page"].Instance.Parent = Bool and Page.Window.Items["Content"].Instance or Library.UnusedHolder.Instance
                if Bool then
                    Items["Page"].Instance.Position = UDim2New(0, 0, 0, 46 + 30)
                    Items["Page"]:Tween(TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, 0, 46)})
                end
                if Page.Active then
                    Items["Background"]:Tween(nil, {BackgroundTransparency = 0.84, Size = UDim2New(1, 0, 0, 35)})
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Accent"})
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})
                    Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Accent, TextTransparency = 0})
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Accent, ImageTransparency = 0})
                    Page.Window.Items["PageTitle"].Instance.Text = Page.Name
                    Page:SelectTab(Page.CurrentTab or Page.TabOrder[1] or "Основное", true)
                else
                    Items["Background"]:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 0, 0, 35)})
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Text"})
                    Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text, TextTransparency = 0.4})
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Text, ImageTransparency = 0.4})
                    for _, Name in Page.TabOrder do
                        Page.Tabs[Name].Button.Instance.Visible = false
                    end
                    local HiddenTab = Page.CurrentTab and Page.Tabs[Page.CurrentTab] or nil
                    if HiddenTab and HiddenTab.OnHide then
                        HiddenTab.OnHide()
                    end
                end
                task.delay(0.25, function()
                    Debounce = false
                end)
            end
            Items["Inactive"]:Connect("MouseEnter", function()
                if not Page.Active then
                    Items["Text"]:Tween(nil, {TextTransparency = 0.12})
                    Items["Icon"]:Tween(nil, {ImageTransparency = 0.12})
                    Items["Background"]:Tween(nil, {BackgroundTransparency = 0.93, Size = UDim2New(1, 0, 0, 35)})
                end
            end)
            Items["Inactive"]:Connect("MouseLeave", function()
                if not Page.Active then
                    Items["Text"]:Tween(nil, {TextTransparency = 0.4})
                    Items["Icon"]:Tween(nil, {ImageTransparency = 0.4})
                    Items["Background"]:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 0, 0, 35)})
                end
            end)
            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Page.Window.Pages do
                    if Value == Page and Page.Active then
                        return
                    end
                    Value:Turn(Value == Page)
                end
            end)
            if #Page.Window.Pages == 0 then
                Page:Turn(true)
            end
            TableInsert(Page.Window.Pages, Page)
            return setmetatable(Page, Library.Pages)
        end
        Library.Group = function(self, Name)
            self._NavCounter = (self._NavCounter or 0) + 1
            Instances:Create("TextLabel", {
                Parent = self.Items["Pages"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                Text = Name,
                TextColor3 = Library.Theme["Text"],
                TextTransparency = 0.55,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 0, 16),
                LayoutOrder = self._NavCounter
            }):AddToTheme({TextColor3 = 'Text'})
        end
        Library.Pages.Section = function(self, Data)
            Data = Data or {}
            local Section = {
                Window = self.Window,
                Page = self,
                Name = Data.Name or Data.name or "Section",
                Side = math.clamp(Data.Side or Data.side or 1, 1, 2),
                Icon = Data.Icon or Data.icon or "rbxassetid://127136375066593",
                Items = {}
            }
            local Tab = Section.Page:GetTab(Data.Tab)
            local TargetColumn = Tab.Columns[Section.Side].Instance
            local Items = {} do
                Items["SectionOutline"] = Instances:Create("Frame", {
                    Parent = TargetColumn,
                    Name = "\0",
                    Size = UDim2New(1, 0, 0, 44),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                Instances:Create("UICorner", {
                    Parent = Items["SectionOutline"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 16)
                })
                Items["Section"] = Instances:Create("Frame", {
                    Parent = Items["SectionOutline"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                Instances:Create("UICorner", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 15)
                })
                Items["Top"] = Instances:Create("Frame", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 38),
                    BorderSizePixel = 0
                })
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextWrapped = true,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Section.Name,
                    Size = UDim2New(0, 0, 0, 14),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 14, 0.5, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 15
                }):AddToTheme({TextColor3 = 'Text'})
                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 38),
                    Size = UDim2New(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })
                Instances:Create("UIPadding", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 4),
                    PaddingBottom = UDimNew(0, 10),
                    PaddingRight = UDimNew(0, 12),
                    PaddingLeft = UDimNew(0, 12)
                })
                Instances:Create("UIListLayout", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                Section.Items = Items
            end
            return setmetatable(Section, Library.Sections)
        end
        Library.Sections.Toggle = function(self, Data)
            Data = Data or {}
            local Toggle = {
                Window = self.Window,
                Page = self.Page,
                Section = self,
                Name = Data.Name or Data.name or "Toggle",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or false,
                Callback = Data.Callback or Data.callback or function() end,
                Value = false
            }
            local Items = {} do
                Items["Toggle"] = Instances:Create("TextButton", {
                    Parent = Toggle.Section.Items["Content"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 14
                })
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.5,
                    Text = Toggle.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14
                }):AddToTheme({TextColor3 = 'Text'})
                Items["Indicator"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2New(1, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 32, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                Instances:Create("UICorner", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })
                Instances:Create("UIStroke", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                Items["Circle"] = Instances:Create("Frame", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    BackgroundTransparency = 0.5,
                    Position = UDim2New(0, 4, 0.5, 0),
                    Size = UDim2New(0, 10, 0, 10),
                    BorderSizePixel = 0
                }):AddToTheme({BackgroundColor3 = function() return FromRGB(255, 255, 255) end})
                Instances:Create("UICorner", {
                    Parent = Items["Circle"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })
                Items["Glow"] = Instances:Create("ImageLabel", {
                    Parent = Items["Circle"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 25, 1, 25),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})
            end
            table.insert(Library.SearchRows, {Frame = Items["Toggle"].Instance, Text = StringLower(Toggle.Name), Page = Toggle.Page})
            function Toggle:Get()
                return Toggle.Value
            end
            function Toggle:Set(Value)
                Toggle.Value = Value
                Library.Flags[Toggle.Flag] = Value
                if Toggle.Value then
                    Items["Glow"]:Tween(nil, {ImageTransparency = 0.7})
                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
                    Items["Circle"]:ChangeItemTheme({BackgroundColor3 = function() return FromRGB(255, 255, 255) end})
                    Items["Circle"]:Tween(TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        AnchorPoint = Vector2New(1, 0.5),
                        Position = UDim2New(1, -3, 0.5, 0),
                        BackgroundTransparency = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })
                    Items["Text"]:Tween(nil, {TextTransparency = 0})
                else
                    Items["Glow"]:Tween(nil, {ImageTransparency = 1})
                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element"})
                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                    Items["Circle"]:ChangeItemTheme({BackgroundColor3 = function() return FromRGB(255, 255, 255) end})
                    Items["Circle"]:Tween(TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        AnchorPoint = Vector2New(0, 0.5),
                        Position = UDim2New(0, 3, 0.5, 0),
                        BackgroundTransparency = 0.45,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })
                    Items["Text"]:Tween(nil, {TextTransparency = 0.45})
                end
                if Toggle.Callback then
                    Library:SafeCall(Toggle.Callback, Toggle.Value)
                end
            end
            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool
            end
            function Toggle:Colorpicker(Data)
                Data = Data or {}
                local Colorpicker = {
                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,
                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or false
                }
                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })
                return NewColorpicker
            end
            function Toggle:Keybind(Data)
                Data = Data or {}
                local Keybind = {
                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,
                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle"
                }
                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })
                return NewKeybind
            end
            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)
            Toggle:Set(Toggle.Default)
            Library.SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end
            return Toggle
        end
        Library.Sections.Button = function(self, Data)
            Data = Data or {}
            local Button = {
                Window = self.Window,
                Page = self.Page,
                Section = self,
                Name = Data.Name or Data.name or "Button",
                Callback = Data.Callback or Data.callback or function() end
            }
            local Items = {} do
                Items["Button"] = Instances:Create("TextButton", {
                    Parent = Button.Section.Items["Content"].Instance,
                    Name = "\0",
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(1, 0, 0, 30),
                    Selectable = false,
                    Active = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Button.Name,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                Instances:Create("UICorner", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                Items["Stroke"] = Instances:Create("UIStroke", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://117716971575946",
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -6, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Text'})
            end
            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end
            function Button:Press()
                Items["Stroke"]:ChangeItemTheme({Color = "Accent"})
                Items["Stroke"]:Tween(nil, {Color = Library.Theme.Accent})
                task.wait(0.1)
                Library:SafeCall(Button.Callback)
                Items["Stroke"]:ChangeItemTheme({Color = "Outline"})
                Items["Stroke"]:Tween(nil, {Color = Library.Theme.Outline})
            end
            Items["Button"]:Connect("MouseButton1Down", function()
                Button:Press()
            end)
            return Button
        end
        Library.Sections.Slider = function(self, Data)
            Data = Data or {}
            local Slider = {
                Window = self.Window,
                Page = self.Page,
                Section = self,
                Name = Data.Name or Data.name or "Slider",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Min = Data.Min or Data.min or 0,
                Default = Data.Default or Data.default or 0,
                Max = Data.Max or Data.max or 100,
                Suffix = Data.Suffix or Data.suffix or "",
                Decimals = Data.Decimals or Data.decimals or 1,
                Callback = Data.Callback or Data.callback or function() end,
                Value = 0,
                Sliding = false
            }
            local Items = {} do
                Items["Slider"] = Instances:Create("Frame", {
                    Parent = Slider.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0
                })
                Instances:Create("UIListLayout", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Slider.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    LayoutOrder = 1,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14
                }):AddToTheme({TextColor3 = 'Text'})
                Items["RealSlider"] = Instances:Create("TextButton", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    Active = false,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 0, 0, 5),
                    Selectable = false,
                    BorderSizePixel = 0,
                    LayoutOrder = 2,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                local SliderFlex = Instance.new("UIFlexItem")
                SliderFlex.FlexMode = Enum.UIFlexMode.Fill
                SliderFlex.Parent = Items["RealSlider"].Instance
                Instances:Create("UICorner", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })
                Instances:Create("UIStroke", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                Items["Accent"] = Instances:Create("Frame", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0.6000000238418579, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                Instances:Create("UICorner", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })
                Items["Glow"] = Instances:Create("ImageLabel", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.800000011920929,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 25, 1, 25),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})
                Items["Dragger"] = Instances:Create("Frame", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(1, -4, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 13, 0, 13),
                    BorderSizePixel = 0
                })
                Instances:Create("UICorner", {
                    Parent = Items["Dragger"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })
                Items["Glow2"] = Instances:Create("ImageLabel", {
                    Parent = Items["Dragger"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.800000011920929,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 25, 1, 25),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})
                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    Text = "50%",
                    Size = UDim2New(0, 48, 0, 18),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"],
                    LayoutOrder = 3,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextSize = 12
                }):AddToTheme({BackgroundColor3 = 'Element', TextColor3 = 'Text'})
                Instances:Create("UICorner", {
                    Parent = Items["Value"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
            end
            table.insert(Library.SearchRows, {Frame = Items["Slider"].Instance, Text = StringLower(Slider.Name), Page = Slider.Page})
            function Slider:Get()
                return Slider.Value
            end
            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end
            function Slider:Set(Value)
                Slider.Value = Library:Round(MathClamp(Value, Slider.Min, Slider.Max), Slider.Decimals)
                Library.Flags[Slider.Flag] = Slider.Value
                Items["Accent"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)})
                Items["Value"].Instance.Text = StringFormat("%s%s", Slider.Value, Slider.Suffix)
                if Slider.Callback then
                    Library:SafeCall(Slider.Callback, Slider.Value)
                end
            end
            local InputChanged
            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = true
                    local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                    local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min
                    Slider:Set(Value)
                    if InputChanged then
                        return
                    end
                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Slider.Sliding = false
                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)
            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.Sliding then
                        local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                        local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min
                        Slider:Set(Value)
                    end
                end
            end)
            if Slider.Default then
                Slider:Set(Slider.Default)
            end
            Library.SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end
            return Slider
        end
        Library.Sections.Dropdown = function(self, Data)
            Data = Data or {}
            local Dropdown = {
                Window = self.Window,
                Page = self.Page,
                Section = self,
                Name = Data.Name or Data.name or "Dropdown",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Items = Data.Items or Data.items or {"One", "Two", "Three"},
                Default = Data.Default or Data.default or nil,
                Callback = Data.Callback or Data.callback or function() end,
                Multi = Data.Multi or Data.multi or false,
                Value = {},
                Options = {},
                IsOpen = false
            }
            local Items = {} do
                Items["Dropdown"] = Instances:Create("Frame", {
                    Parent = Dropdown.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 26),
                    BorderSizePixel = 0
                })
                Instances:Create("UIListLayout", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Dropdown.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    LayoutOrder = 1,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14
                }):AddToTheme({TextColor3 = 'Text'})
                Items["RealDropdown"] = Instances:Create("TextButton", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 0, 0, 26),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    LayoutOrder = 2,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                local DropdownFlex = Instance.new("UIFlexItem")
                DropdownFlex.FlexMode = Enum.UIFlexMode.Fill
                DropdownFlex.Parent = Items["RealDropdown"].Instance
                Instances:Create("UICorner", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 8)
                })
                Instances:Create("UIStroke", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.15,
                    Text = "--",
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 13
                }):AddToTheme({TextColor3 = 'Text'})
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://72690112230014",
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -8, 0.5, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Text'})
                Instances:Create("Frame", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, -32, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                Items["OptionHolder"] = Instances:Create("TextButton", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 200, 0, 0),
                    Position = UDim2New(0, 54, 0, 236),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    TextSize = 14,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                Instances:Create("UICorner", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0"
                })
                Instances:Create("UIListLayout", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                Instances:Create("UIPadding", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 10),
                    PaddingBottom = UDimNew(0, 10),
                    PaddingRight = UDimNew(0, 10),
                    PaddingLeft = UDimNew(0, 10)
                })
            end
            table.insert(Library.SearchRows, {Frame = Items["Dropdown"].Instance, Text = StringLower(Dropdown.Name), Page = Dropdown.Page})
            function Dropdown:Get()
                return Dropdown.Value
            end
            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool
            end
            local Debounce = false
            local RenderStepped
            function Dropdown:SetOpen(Bool)
                if Debounce then
                    return
                end
                Dropdown.IsOpen = Bool
                Debounce = true
                if Dropdown.IsOpen then
                    Items["OptionHolder"].Instance.Visible = true
                    Items["OptionHolder"].Instance.Parent = Library.Holder.Instance
                    RenderStepped = RunService.RenderStepped:Connect(function()
                        Items["OptionHolder"].Instance.Position = UDim2New(0, Items["RealDropdown"].Instance.AbsolutePosition.X, 0, Items["RealDropdown"].Instance.AbsolutePosition.Y - 25)
                        Items["OptionHolder"].Instance.Size = UDim2New(0, Items["RealDropdown"].Instance.AbsoluteSize.X, 0, 0)
                    end)
                    for Index, Value in Library.OpenFrames do
                        if Value ~= Dropdown and not Dropdown.Section.IsSettings then
                            Value:SetOpen(false)
                        end
                    end
                    Library.OpenFrames[Dropdown] = Dropdown
                else
                    if Library.OpenFrames[Dropdown] then
                        Library.OpenFrames[Dropdown] = nil
                    end
                    if RenderStepped then
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end
                local Descendants = Items["OptionHolder"].Instance:GetDescendants()
                TableInsert(Descendants, Items["OptionHolder"].Instance)
                local NewTween
                for Index, Value in Descendants do
                    local TransparencyProperty = Tween:GetProperty(Value)
                    if not TransparencyProperty then
                        continue
                    end
                    if not Value.ClassName:find("UI") then
                        Value.ZIndex = Dropdown.IsOpen and 3 or 1
                    end
                    if type(TransparencyProperty) == "table" then
                        for _, Property in TransparencyProperty do
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false
                    Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
                    task.wait(0.2)
                    Items["OptionHolder"].Instance.Parent = not Dropdown.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end)
            end
            function Dropdown:Set(Option)
                if Dropdown.Multi then
                    if type(Option) ~= "table" then
                        return
                    end
                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option
                    for Index, Value in Option do
                        local OptionData = Dropdown.Options[Value]
                        if not OptionData then
                            continue
                        end
                        OptionData.Selected = true
                        OptionData:Toggle("Active")
                    end
                    Items["Value"].Instance.Text = TableConcat(Option, ", ")
                else
                    if not Dropdown.Options[Option] then
                        return
                    end
                    local OptionData = Dropdown.Options[Option]
                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option
                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.Selected = false
                            Value:Toggle("Inactive")
                        else
                            Value.Selected = true
                            Value:Toggle("Active")
                        end
                    end
                    Items["Value"].Instance.Text = Option
                end
                if Dropdown.Callback then
                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end
            end
            function Dropdown:Add(Option)
                local OptionButton = Instances:Create("TextButton", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 14
                })
                local OptionLiner = Instances:Create("Frame", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 3, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                local OptionGlow = Instances:Create("ImageLabel", {
                    Parent = OptionLiner.Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 25, 1, 25),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})
                Instances:Create("UICorner", {
                    Parent = OptionLiner.Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })
                local OptionText = Instances:Create("TextLabel", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.5,
                    Text = Option,
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                local OptionData = {
                    Button = OptionButton,
                    Name = Option,
                    Liner = OptionLiner,
                    Glow = OptionGlow,
                    Text = OptionText,
                    Selected = false
                }
                function OptionData:Toggle(Value)
                    if Value == "Active" then
                        OptionData.Liner:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0, 3, 1, 0)})
                        OptionData.Glow:Tween(nil, {ImageTransparency = 0.7})
                        OptionData.Text:Tween(nil, {Position = UDim2New(0, 12, 0.5 ,0), TextTransparency = 0})
                    else
                        OptionData.Liner:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 3, 0, 0)})
                        OptionData.Glow:Tween(nil, {ImageTransparency = 1})
                        OptionData.Text:Tween(nil, {Position = UDim2New(0, 0, 0.5 ,0), TextTransparency = 0.5})
                    end
                end
                function OptionData:Set()
                    OptionData.Selected = not OptionData.Selected
                    if Dropdown.Multi then
                        local Index = TableFind(Dropdown.Value, OptionData.Name)
                        if Index then
                            TableRemove(Dropdown.Value, Index)
                        else
                            TableInsert(Dropdown.Value, OptionData.Name)
                        end
                        OptionData:Toggle(Index and "Inactive" or "Active")
                        Library.Flags[Dropdown.Flag] = Dropdown.Value
                        local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "..."
                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.Selected then
                            Dropdown.Value = OptionData.Name
                            Library.Flags[Dropdown.Flag] = OptionData.Name
                            OptionData.Selected = true
                            OptionData:Toggle("Active")
                            for Index, Value in Dropdown.Options do
                                if Value ~= OptionData then
                                    Value.Selected = false
                                    Value:Toggle("Inactive")
                                end
                            end
                            Items["Value"].Instance.Text = OptionData.Name
                        else
                            Dropdown.Value = nil
                            Library.Flags[Dropdown.Flag] = nil
                            OptionData.Selected = false
                            OptionData:Toggle("Inactive")
                            Items["Value"].Instance.Text = "..."
                        end
                    end
                    if Dropdown.Callback then
                        Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                    end
                end
                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)
                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end
            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then
                    Dropdown.Options[Option].Button:Clean()
                    Dropdown.Options[Option] = nil
                end
            end
            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do
                    Dropdown:Remove(Value.Name)
                end
                for Index, Value in List do
                    Dropdown:Add(Value)
                end
            end
            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)
            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dropdown.IsOpen then
                        if Library:IsMouseOverFrame(Items["OptionHolder"]) then
                            return
                        end
                        Dropdown:SetOpen(false)
                    end
                end
            end)
            Items["RealDropdown"]:Connect("Changed", function(Property)
                if Property == "AbsolutePosition" and Dropdown.IsOpen then
                    Dropdown.IsOpen = not Library:IsClipped(Items["OptionHolder"].Instance, Dropdown.Section.Items["Section"].Instance.Parent)
                    Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
                end
            end)
            for Index, Value in Dropdown.Items do
                Dropdown:Add(Value)
            end
            if Dropdown.Default then
                Dropdown:Set(Dropdown.Default)
            end
            Library.SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end
            return Dropdown
        end
        Library.Sections.Label = function(self, Name)
            local Label = {
                Window = self.Window,
                Page = self.Page,
                Section = self,
                Name = Name or "Label"
            }
            local Items = {} do
                Items["Label"] = Instances:Create("Frame", {
                    Parent = Label.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0
                })
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Label.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14
                }):AddToTheme({TextColor3 = 'Text'})
                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })
                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end
            function Label:SetText(Text)
                Text = tostring(Text)
                Items["Text"].Instance.Text = Text
            end
            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool
            end
            function Label:Colorpicker(Data)
                Data = Data or {}
                local Colorpicker = {
                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,
                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or false
                }
                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })
                return NewColorpicker
            end
            function Label:Keybind(Data)
                Data = Data or {}
                local Keybind = {
                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,
                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle"
                }
                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })
                return NewKeybind
            end
            return Label
        end
        Library.Sections.Textbox = function(self, Data)
            Data = Data or {}
            local Textbox = {
                Window = self.Window,
                Page = self.Page,
                Section = self,
                Name = Data.Name or Data.name or "Textbox",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or "",
                Callback = Data.Callback or Data.callback or function() end,
                Placeholder = Data.Placeholder or Data.placeholder or "Placeholder",
                Numeric = Data.Numeric or Data.numeric or false,
                Finished = Data.Finished or Data.finished or false,
                Value = ""
            }
            local Items = {} do
                Items["Textbox"] = Instances:Create("Frame", {
                    Parent = Textbox.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 30),
                    BorderSizePixel = 0
                })
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Textbox.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                Items["Background"] = Instances:Create("Frame", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    Active = true,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 1),
                    Size = UDim2New(0, 0, 0, 30),
                    Position = UDim2New(1, 0, 1, 0),
                    Selectable = true,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                Instances:Create("UICorner", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                Instances:Create("UIStroke", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                Instances:Create("UIPadding", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })
                Items["Input"] = Instances:Create("TextBox", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    Active = false,
                    TextTransparency = 0,
                    AnchorPoint = Vector2New(0, 0.5),
                    PlaceholderColor3 = FromRGB(133, 139, 143),
                    PlaceholderText = Textbox.Placeholder,
                    TextSize = 16,
                    Size = UDim2New(0, 0, 0, 15),
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    Selectable = false,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    CursorPosition = -1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Text'})
            end
            function Textbox:Get()
                return Textbox.Value
            end
            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end
            function Textbox:Set(Value)
                if Textbox.Numeric then
                    if (not tonumber(Value)) and StringLen(tostring(Value)) > 0 then
                        Value = Textbox.Value
                    end
                end
                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Library.Flags[Textbox.Flag] = Value
                if Textbox.Callback then
                    Library:SafeCall(Textbox.Callback, Value)
                end
            end
            if Textbox.Finished then
                Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
                    if PressedEnterQuestionMark then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end)
            else
                Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                    Textbox:Set(Items["Input"].Instance.Text)
                end)
            end
            if Textbox.Default then
                Textbox:Set(Textbox.Default)
            end
            Library.SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end
            return Textbox
        end
    end
    Library.CreateSettingsPage = function(self, Window)
        local SettingsPage = Window:Page({Name = "Settings", Icon = "rbxassetid://80758916183665"})
        do
            local ThemingSection = SettingsPage:Section({Name = "Theming", Tab = "Оформление", Icon = "rbxassetid://73803440257131"})
            do
                for Index, Value in Library.Theme do
                    ThemingSection:Label(Index):Colorpicker({
                        Flag = Index.."_ThemingThing",
                        Default = Value,
                        Alpha = 0,
                        Callback = function(Value)
                            Library.Theme[Index] = Value
                            Library:ChangeTheme(Index, Value)
                        end
                    })
                end
            end
            local ConfigsSection = SettingsPage:Section({Name = "Configs", Tab = "Конфиги", Icon = "rbxassetid://74885853379841"}) do
                local ConfigName
                local ConfigSelected
                local ConfigsDropdown = ConfigsSection:Dropdown({
                    Name = "Configs",
                    Flag = "Configs",
                    Items = {},
                    Multi = false,
                    MaxSize = 120,
                    Callback = function(Value)
                        ConfigSelected = Value
                    end
                })
                ConfigsSection:Textbox({
                    Name = "Config name",
                    Placeholder = "Config name",
                    Flag = "ConfigName",
                    Callback = function(Value)
                        ConfigName = Value
                    end
                })
                ConfigsSection:Button({
                    Name = "Create",
                    Callback = function()
                        if ConfigName and ConfigName ~= "" then
                            if not isfile(Library.Folders.Configs .. "/" .. ConfigName .. ".json") then
                                writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
                                Library:RefreshConfigsList(ConfigsDropdown)
                            end
                        end
                    end
                })
                ConfigsSection:Button({
                    Name = "Load",
                    Callback = function()
                        if ConfigSelected and ConfigSelected ~= "" then
                            Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. ConfigSelected..".json"))
                        end
                    end
                })
                ConfigsSection:Button({
                    Name = "Save",
                    Callback = function()
                        if ConfigSelected and ConfigSelected ~= "" then
                            writefile(Library.Folders.Configs .. "/" .. ConfigSelected..".json", Library:GetConfig())
                        end
                    end
                })
                ConfigsSection:Button({
                    Name = "Delete",
                    Callback = function()
                        if ConfigSelected and ConfigSelected ~= "" then
                            delfile(Library.Folders.Configs .. "/" .. ConfigSelected..".json")
                            Library:RefreshConfigsList(ConfigsDropdown)
                        end
                    end
                })
                ConfigsSection:Button({
                    Name = "Refresh",
                    Callback = function()
                        Library:RefreshConfigsList(ConfigsDropdown)
                    end
                })
                Library:RefreshConfigsList(ConfigsDropdown)
            end
        end
        return SettingsPage
    end
end
getgenv().Library = Library
return Library
end)()

-- ════════════════════════════════════════════════════════
-- ОСНОВНАЯ ЧАСТЬ
-- ════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local Theme = Library.Theme

Library.MenuKeybind = tostring(Enum.KeyCode.Insert)

local viewport = Workspace.CurrentCamera.ViewportSize
local isMobile = UserInputService.TouchEnabled and math.min(viewport.X, viewport.Y) < 760

local ICON_MOVE = "rbxassetid://114551690399915"
local ICON_VISUALS = "rbxassetid://100033680381365"
local ICON_CLIENT = "rbxassetid://93142176757189"
local ICON_COMBAT = "rbxassetid://87563802520297"
local ICON_TROLL = "rbxassetid://104491311361166"
local ICON_BOT = "rbxassetid://80451686744860"
local LOGO = "rbxassetid://134242818164054"

local holderGui = Library.Holder.Instance
local unloaded = false

getgenv().CSSGen = (tonumber(getgenv().CSSGen) or 0) + 1
local GEN = getgenv().CSSGen

-- ЗАГРУЗОЧНОЕ МЕНЮ
local function CreateLoadingScreen()
    local loader = Instance.new("ScreenGui")
    loader.Name = "CSS_Loader"
    loader.Parent = gethui()
    loader.DisplayOrder = 100
    loader.IgnoreGuiInset = true

    local bg = Instance.new("Frame")
    bg.Size = UDim2.fromScale(1, 1)
    bg.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
    bg.BorderSizePixel = 0
    bg.Parent = loader

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(139, 149, 246)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(88, 60, 180)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25)),
    })
    grad.Rotation = 45
    grad.Parent = bg

    task.spawn(function()
        local rot = 0
        while bg.Parent do
            rot = (rot + 0.4) % 360
            grad.Rotation = rot
            task.wait(0.03)
        end
    end)

    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.fromOffset(200, 100)
    logo.Position = UDim2.new(0.5, -100, 0.35, -50)
    logo.BackgroundTransparency = 1
    logo.FontFace = Library.Font
    logo.TextSize = isMobile and 60 or 72
    logo.TextColor3 = Color3.fromRGB(255, 255, 255)
    logo.Text = "css"
    logo.TextStrokeTransparency = 0.3
    logo.TextStrokeColor3 = Color3.fromRGB(139, 149, 246)
    logo.Parent = bg

    task.spawn(function()
        local t = 0
        while logo.Parent do
            t = t + 0.05
            local s = 1 + math.sin(t * 2) * 0.03
            logo.TextSize = (isMobile and 60 or 72) * s
            task.wait(0.03)
        end
    end)

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.fromOffset(300, 30)
    subtitle.Position = UDim2.new(0.5, -150, 0.35, 60)
    subtitle.BackgroundTransparency = 1
    subtitle.FontFace = Library.Font
    subtitle.TextSize = 16
    subtitle.TextColor3 = Color3.fromRGB(180, 180, 200)
    subtitle.Text = "приватный клиент"
    subtitle.Parent = bg

    local status = Instance.new("TextLabel")
    status.Size = UDim2.fromOffset(400, 20)
    status.Position = UDim2.new(0.5, -200, 0.55, 30)
    status.BackgroundTransparency = 1
    status.FontFace = Library.Font
    status.TextSize = 14
    status.TextColor3 = Color3.fromRGB(160, 160, 180)
    status.Text = "Инициализация..."
    status.Parent = bg

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.fromOffset(isMobile and 250 or 300, 4)
    barBg.Position = UDim2.new(0.5, -(isMobile and 125 or 150), 0.55, 60)
    barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    barBg.BorderSizePixel = 0
    barBg.Parent = bg
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.fromScale(0, 1)
    barFill.BackgroundColor3 = Color3.fromRGB(139, 149, 246)
    barFill.BorderSizePixel = 0
    barFill.Parent = barBg
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

    local function setProgress(p, text)
        TweenService:Create(barFill, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.fromScale(p, 1)
        }):Play()
        if text then status.Text = text end
    end

    return {
        gui = loader,
        set = setProgress,
        destroy = function()
            TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
            task.delay(0.5, function() loader:Destroy() end)
        end
    }
end

local loading = CreateLoadingScreen()
loading.set(0.1, "Инициализация ядра...")
task.wait(0.3)

-- СОЗДАНИЕ ОКНА
local Window = Library:Window({
    Name = "css",
    SubName = "приватный клиент",
    Logo = LOGO,
})

loading.set(0.3, "Построение интерфейса...")
task.wait(0.2)

-- АДАПТАЦИЯ ПОД МОБИЛЬНЫЕ
if isMobile then
    local mainFrame = Window.Items["MainFrame"].Instance
    local sidebar = Window.Items["Sidebar"].Instance
    local content = Window.Items["Content"].Instance

    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Position = UDim2.fromScale(0.5, 0.5)
    mainFrame.Size = UDim2.fromOffset(viewport.X - 16, viewport.Y - 70)

    sidebar.Size = UDim2.new(0, 128, 1, 0)
    content.Position = UDim2.new(0, 128, 0, 0)
    content.Size = UDim2.new(1, -128, 1, 0)

    local top = Window.Items["Top"].Instance
    top.Size = UDim2.new(1, 0, 0, 58)

    local logo = Window.Items["Logo"].Instance
    logo.Size = UDim2.fromOffset(24, 24)
    logo.Position = UDim2.new(0, 14, 0, 16)

    local title = Window.Items["Title"].Instance
    title.Position = UDim2.new(0, 46, 0, 12)
    title.TextSize = 16

    local subtitle = Window.Items["Subtitle"].Instance
    subtitle.Position = UDim2.new(0, 46, 0, 32)
    subtitle.TextSize = 12

    local pages = Window.Items["Pages"].Instance
    pages.Position = UDim2.new(0, 6, 0, 66)
    pages.Size = UDim2.new(1, -12, 1, -74)
end

-- КНОПКА ОТКРЫТИЯ/ЗАКРЫТИЯ МЕНЮ
local menuToggleBtn = Instance.new("TextButton")
menuToggleBtn.Name = "CSS_ToggleBtn"
menuToggleBtn.Size = UDim2.fromOffset(isMobile and 56 or 48, isMobile and 56 or 48)
menuToggleBtn.Position = UDim2.new(0, 14, 0.5, -(isMobile and 28 or 24))
menuToggleBtn.BackgroundColor3 = Theme.Background
menuToggleBtn.BackgroundTransparency = 0.1
menuToggleBtn.BorderSizePixel = 0
menuToggleBtn.Text = ""
menuToggleBtn.AutoButtonColor = false
menuToggleBtn.Parent = holderGui
menuToggleBtn.ZIndex = 10

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 12)
btnCorner.Parent = menuToggleBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Theme.Outline
btnStroke.Parent = menuToggleBtn
Library:AddToTheme(btnStroke, {Color = "Outline"})

local btnIcon = Instance.new("TextLabel")
btnIcon.Size = UDim2.fromScale(1, 1)
btnIcon.BackgroundTransparency = 1
btnIcon.FontFace = Library.Font
btnIcon.TextSize = isMobile and 26 or 22
btnIcon.TextColor3 = Theme.Accent
btnIcon.Text = "☰"
btnIcon.Parent = menuToggleBtn
Library:AddToTheme(btnIcon, {TextColor3 = "Accent"})

local function updateToggleIcon()
    btnIcon.Text = Window.IsOpen and "✕" or "☰"
end

local draggingBtn, dragStartBtn, startPosBtn = false, nil, nil
menuToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingBtn = true
        dragStartBtn = input.Position
        startPosBtn = menuToggleBtn.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingBtn = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingBtn and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartBtn
        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
            menuToggleBtn.Position = UDim2.new(startPosBtn.X.Scale, startPosBtn.X.Offset + delta.X,
                startPosBtn.Y.Scale, startPosBtn.Y.Offset + delta.Y)
        end
    end
end)

menuToggleBtn.MouseButton1Click:Connect(function()
    Window:SetOpen(not Window.IsOpen)
    updateToggleIcon()
end)

-- АНИМАЦИЯ ОТКРЫТИЯ/ЗАКРЫТИЯ
local origSetOpen = Window.SetOpen
function Window:SetOpen(v)
    origSetOpen(self, v)
    updateToggleIcon()
    local mainFrame = Window.Items["MainFrame"].Instance
    local uiScale = mainFrame:FindFirstChild("CSS_Pop")
    if not uiScale then
        uiScale = Instance.new("UIScale")
        uiScale.Name = "CSS_Pop"
        uiScale.Parent = mainFrame
    end
    if v then
        uiScale.Scale = 0.93
        TweenService:Create(uiScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        local pos = mainFrame.Position
        mainFrame.Position = pos + UDim2.new(0, 0, 0, 28)
        TweenService:Create(mainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = pos}):Play()
    else
        TweenService:Create(uiScale, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Scale = 0.95}):Play()
    end
end

loading.set(0.5, "Создание вкладок...")
task.wait(0.2)

-- ВКЛАДКИ
Window:Group("Игрок")
local MovementPage = Window:Page({Name = "Movement", Icon = ICON_MOVE})
Window:Group("Бой")
local CombatPage = Window:Page({Name = "Combat", Icon = ICON_COMBAT})
Window:Group("Визуал")
local VisualsPage = Window:Page({Name = "Visuals", Icon = ICON_VISUALS})
Window:Group("Троллинг")
local TrollingPage = Window:Page({Name = "Trolling", Icon = ICON_TROLL})
Window:Group("Прочее")
local ClientPage = Window:Page({Name = "Client", Icon = ICON_CLIENT})
Window:Group("Система")
local settingsPage = Library:CreateSettingsPage(Window)

local flagCounter = 0
local function nextFlag(prefix)
    flagCounter = flagCounter + 1
    return (prefix or "css") .. "_" .. flagCounter
end

local function attachKeybind(section, featureName, toggleObj, defaultKey)
    local skipFirst = (defaultKey ~= nil)
    local kb
    kb = section:Label("Keybind"):Keybind({
        Mode = "Toggle",
        Default = defaultKey,
        Callback = function(state)
            if kb and kb.Picking then return end
            if skipFirst then skipFirst = false; return end
            toggleObj:Set(state)
        end,
    })
    return kb
end

local allToggles = {}

-- NOCLIP
do
    local s = MovementPage:Section({Name = "Noclip", Side = 1, Tab = "Передвижение"})
    local t = s:Toggle({Name = "Noclip", Flag = nextFlag(), Default = false, Callback = function() end})
    table.insert(allToggles, t)
    attachKeybind(s, "Noclip", t, nil)
end

-- TELEPORT
do
    local s = MovementPage:Section({Name = "Teleport", Side = 2, Tab = "Игроки"})
    s:Button({Name = "Player1", Callback = function() end})
    s:Button({Name = "Player2", Callback = function() end})
end

-- SEX
do
    local s = TrollingPage:Section({Name = "Sex", Side = 1, Tab = "Троллинг"})
    local t = s:Toggle({Name = "Sex", Flag = nextFlag(), Default = false, Callback = function() end})
    table.insert(allToggles, t)
    s:Slider({Name = "Дистанция поиска", Flag = nextFlag(), Default = 100, Min = 25, Max = 300, Callback = function() end})
    s:Slider({Name = "Скорость", Flag = nextFlag(), Default = 1, Min = 0.5, Max = 3, Callback = function() end})
    attachKeybind(s, "Sex", t, nil)
end

-- SILENT AIM
do
    local s = CombatPage:Section({Name = "Silent Aim", Side = 1, Tab = "Аим"})
    local t = s:Toggle({Name = "Silent Aim", Flag = nextFlag(), Default = false, Callback = function() end})
    table.insert(allToggles, t)
    s:Dropdown({Name = "Часть тела", Flag = nextFlag(), Items = {"Голова", "Торс"}, Default = "Голова", Multi = false, Callback = function() end})
    s:Slider({Name = "FOV", Flag = nextFlag(), Default = 120, Min = 30, Max = 500, Callback = function() end})
    s:Toggle({Name = "Показывать FOV", Flag = nextFlag(), Default = true, Callback = function() end})
    s:Slider({Name = "Шанс попадания", Flag = nextFlag(), Default = 100, Min = 1, Max = 100, Suffix = "%", Callback = function() end})
    attachKeybind(s, "Silent Aim", t, nil)
end

-- SKY SHADER
do
    local s = VisualsPage:Section({Name = "Sky Shader", Side = 1, Tab = "Мир"})
    local t = s:Toggle({Name = "Sky Shader", Flag = nextFlag(), Default = false, Callback = function() end})
    table.insert(allToggles, t)
    s:Dropdown({Name = "Небо", Flag = nextFlag(), Items = {"Аврора", "Звездопад", "Кровавая луна", "Золотой час", "Vaporwave", "Глубокий космос", "Космос"}, Default = "Аврора", Multi = false, Callback = function() end})
    attachKeybind(s, "Sky Shader", t, nil)
end

-- FULLBRIGHT
do
    local s = VisualsPage:Section({Name = "Fullbright", Side = 1, Tab = "Мир"})
    local t = s:Toggle({Name = "Fullbright", Flag = nextFlag(), Default = false, Callback = function() end})
    table.insert(allToggles, t)
end

-- FOG
do
    local s = VisualsPage:Section({Name = "Fog", Side = 2, Tab = "Мир"})
    local t = s:Toggle({Name = "Fog", Flag = nextFlag(), Default = false, Callback = function() end})
    table.insert(allToggles, t)
    s:Slider({Name = "Дальность", Flag = nextFlag(), Default = 400, Min = 50, Max = 2000, Callback = function() end})
    attachKeybind(s, "Fog", t, nil)
end

-- SKELETON ESP
do
    local s = VisualsPage:Section({Name = "Skeleton ESP", Side = 1, Tab = "ESP"})
    local t = s:Toggle({Name = "Skeleton ESP", Flag = nextFlag(), Default = false, Callback = function() end})
    table.insert(allToggles, t)
    s:Slider({Name = "Толщина", Flag = nextFlag(), Default = 1, Min = 1, Max = 5, Callback = function() end})
    attachKeybind(s, "Skeleton ESP", t, nil)
end

-- SHADER ESP
do
    local s = VisualsPage:Section({Name = "Shader ESP", Side = 2, Tab = "ESP"})
    local t = s:Toggle({Name = "Shader ESP", Flag = nextFlag(), Default = false, Callback = function() end})
    table.insert(allToggles, t)
    s:Slider({Name = "Прозрачность заливки", Flag = nextFlag(), Default = 0.6, Min = 0, Max = 1, Decimals = 0.1, Callback = function() end})
    attachKeybind(s, "Shader ESP", t, nil)
end

loading.set(0.7, "Загрузка модулей...")
task.wait(0.2)

-- КЛИЕНТ
do
    local s = ClientPage:Section({Name = "Клиент", Side = 1, Tab = "Интерфейс"})
    s:Button({
        Name = "Unload (выгрузить скрипт)",
        Callback = function()
            unloaded = true
            for _, toggleObj in ipairs(allToggles) do
                if toggleObj:Get() then
                    toggleObj:Set(false)
                end
            end
            task.delay(0.25, function()
                Library:Unload()
            end)
        end,
    })
end

-- МЕНЮ НАСТРОЙКИ
do
    local s = settingsPage:Section({Name = "Menu", Side = 1, Tab = "Меню"})
    local menuKb
    menuKb = s:Label("Клавиша меню"):Keybind({
        Mode = "Toggle",
        Default = Enum.KeyCode.Insert,
        Callback = function()
            if menuKb and menuKb.Picking and menuKb.Value ~= "None" then
                Library.MenuKeybind = tostring(menuKb.Key)
            end
        end,
    })
    s:Label("Клик по чипу — своя клавиша меню · Escape — сброс")

    local baseSize = Vector2.new(900, 600)
    local mainFrame = Window.Items["MainFrame"].Instance
    s:Slider({
        Name = "Размер меню",
        Flag = nextFlag(),
        Default = 100, Min = 70, Max = 140, Suffix = "%",
        Callback = function(v)
            if not isMobile then
                local sc = v / 100
                mainFrame.Size = UDim2.fromOffset(
                    math.floor(baseSize.X * sc + 0.5),
                    math.floor(baseSize.Y * sc + 0.5)
                )
            end
        end,
    })
    s:Label("На телефоне размер автоматический")

    local menuRgbOn = false
    local uiRgbSpeed = 1
    local accentBackup = nil
    s:Toggle({
        Name = "RGB меню",
        Flag = nextFlag(),
        Default = false,
        Callback = function(on)
            if on then
                accentBackup = Theme.Accent
                menuRgbOn = true
            else
                menuRgbOn = false
                if accentBackup then
                    Theme.Accent = accentBackup
                    Library:ChangeTheme("Accent", accentBackup)
                    accentBackup = nil
                end
            end
        end,
    })
    s:Slider({
        Name = "Скорость RGB интерфейса",
        Flag = nextFlag(),
        Default = 1, Min = 0.1, Max = 5,
        Callback = function(v) uiRgbSpeed = v end,
    })
    task.spawn(function()
        while not unloaded and getgenv().CSSGen == GEN do
            if menuRgbOn then
                local c = Color3.fromHSV((tick() * uiRgbSpeed * 0.35) % 1, 1, 1)
                if menuRgbOn then
                    Theme.Accent = c
                    Library:ChangeTheme("Accent", c)
                end
            end
            task.wait(0.05)
        end
    end)
end

loading.set(0.9, "Финализация...")
task.wait(0.2)

loading.set(1, "Готово")
task.wait(0.3)
loading.destroy()
Window:SetOpen(true)
updateToggleIcon()

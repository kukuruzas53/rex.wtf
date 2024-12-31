local loadstring, game, getgenv, setclipboard = loadstring, game, getgenv, setclipboard

--// Loaded check
if getgenv().Aimbot then return end

loadstring(game:HttpGet("https://raw.githubusercontent.com/kukuruzas53/rex.wtf/refs/heads/main/Resources/main.lua"))()

--// Variables
local Aimbot = getgenv().Aimbot
local Settings, FOVSettings, Functions = Aimbot.Settings, Aimbot.FOVSettings, Aimbot.Functions
local Library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)() -- Pepsi's UI Library

local Parts = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg", "UpperTorso", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "LowerTorso", "RightUpperLeg"}

-- ESP Settings
local ESPSettings = {
    Box_Color = Color3.fromRGB(255, 0, 0),
    Box_Transparency = 1,
    Tracer_Color = Color3.fromRGB(255, 0, 0),
    Tracer_Transparency = 1,
    Tracer_Thickness = 1,
    Box_Thickness = 1,
    Tracer_Origin = "Bottom",
    Tracer_FollowMouse = false,
    Tracers = false,
    BoxESP = false
}
local Team_Check = {
    TeamCheck = false,
    Green = Color3.fromRGB(0, 255, 0),
    Red = Color3.fromRGB(255, 0, 0)
}
local TeamColor = true

--// Functions for ESP
local player = game:GetService("Players").LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local mouse = player:GetMouse()

local function NewQuad(thickness, color, transparency)
    local quad = Drawing.new("Quad")
    quad.Visible = false
    quad.PointA = Vector2.new(0,0)
    quad.PointB = Vector2.new(0,0)
    quad.PointC = Vector2.new(0,0)
    quad.PointD = Vector2.new(0,0)
    quad.Color = color
    quad.Filled = false
    quad.Thickness = thickness
    quad.Transparency = transparency
    return quad
end

local function NewLine(thickness, color, transparency)
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(0, 0)
    line.Color = color 
    line.Thickness = thickness
    line.Transparency = transparency
    return line
end

local function Visibility(state, lib)
    for _, x in pairs(lib) do
        x.Visible = state
    end
end

local function ToColor3(col)
    return Color3.new(col.r, col.g, col.b)
end

local black = Color3.fromRGB(0, 0, 0)

local function ESP(plr)
    local library = {
        blacktracer = NewLine(ESPSettings.Tracer_Thickness*2, black, ESPSettings.Tracer_Transparency),
        tracer = NewLine(ESPSettings.Tracer_Thickness, ESPSettings.Tracer_Color, ESPSettings.Tracer_Transparency),
        black = NewQuad(ESPSettings.Box_Thickness*2, black, ESPSettings.Box_Transparency),
        box = NewQuad(ESPSettings.Box_Thickness, ESPSettings.Box_Color, ESPSettings.Box_Transparency),
        healthbar = NewLine(3, black, ESPSettings.Box_Transparency),
        greenhealth = NewLine(1.5, black, ESPSettings.Box_Transparency)
    }

    local function Colorize(color)
        for u, x in pairs(library) do
            if u ~= "healthbar" and u ~= "greenhealth" and u ~= "blacktracer" and u ~= "black" then
                x.Color = color
            end
        end
    end

    local function Updater()
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Head") then
                local HumPos, OnScreen = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                if OnScreen then
                    local head = camera:WorldToViewportPoint(plr.Character.Head.Position)
                    local DistanceY = math.clamp((Vector2.new(head.X, head.Y) - Vector2.new(HumPos.X, HumPos.Y)).magnitude, 2, math.huge)
                    
                    local function Size(item)
                        item.PointA = Vector2.new(HumPos.X + DistanceY, HumPos.Y - DistanceY*2)
                        item.PointB = Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY*2)
                        item.PointC = Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY*2)
                        item.PointD = Vector2.new(HumPos.X + DistanceY, HumPos.Y + DistanceY*2)
                    end
                    if ESPSettings.BoxESP then
                        Size(library.box)
                        Size(library.black)
                    end

                    -- Tracer 
                    if ESPSettings.Tracers then
                        local fromVector
                        if ESPSettings.Tracer_Origin == "Middle" then
                            fromVector = camera.ViewportSize*0.5
                        elseif ESPSettings.Tracer_Origin == "Bottom" then
                            fromVector = Vector2.new(camera.ViewportSize.X*0.5, camera.ViewportSize.Y)
                        elseif ESPSettings.Tracer_Origin == "Top" then
                            fromVector = Vector2.new(camera.ViewportSize.X*0.5, 0)
                        elseif ESPSettings.Tracer_Origin == "Left" then
                            fromVector = Vector2.new(0, camera.ViewportSize.Y*0.5)
                        elseif ESPSettings.Tracer_Origin == "Right" then
                            fromVector = Vector2.new(camera.ViewportSize.X, camera.ViewportSize.Y*0.5)
                        end

                        if ESPSettings.Tracer_FollowMouse then
                            fromVector = Vector2.new(mouse.X, mouse.Y+36)
                        end

                        library.tracer.From = fromVector
                        library.blacktracer.From = fromVector
                        library.tracer.To = Vector2.new(HumPos.X, HumPos.Y + DistanceY*2)
                        library.blacktracer.To = Vector2.new(HumPos.X, HumPos.Y + DistanceY*2)
                    else 
                        library.tracer.From = Vector2.new(0, 0)
                        library.blacktracer.From = Vector2.new(0, 0)
                        library.tracer.To = Vector2.new(0, 0)
                        library.blacktracer.To = Vector2.new(0, 0)
                    end

                    -- Health Bar
                    local d = (Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY*2) - Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY*2)).magnitude 
                    local healthoffset = plr.Character.Humanoid.Health/plr.Character.Humanoid.MaxHealth * d

                    library.greenhealth.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2)
                    library.greenhealth.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2 - healthoffset)

                    library.healthbar.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2)
                    library.healthbar.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y - DistanceY*2)

                    local green = Color3.fromRGB(0, 255, 0)
                    local red = Color3.fromRGB(255, 0, 0)

                    library.greenhealth.Color = red:lerp(green, plr.Character.Humanoid.Health/plr.Character.Humanoid.MaxHealth);

                    if Team_Check.TeamCheck then
                        if plr.TeamColor == player.TeamColor then
                            Colorize(Team_Check.Green)
                        else 
                            Colorize(Team_Check.Red)
                        end
                    else 
                        library.tracer.Color = ESPSettings.Tracer_Color
                        library.box.Color = ESPSettings.Box_Color
                    end
                    if TeamColor then
                        Colorize(plr.TeamColor.Color)
                    end
                    Visibility(ESPSettings.Tracers, {library.tracer, library.blacktracer})
                    Visibility(ESPSettings.BoxESP, {library.box, library.black, library.healthbar, library.greenhealth})
                else 
                    Visibility(false, library)
                end
            else 
                Visibility(false, library)
                if not game.Players:FindFirstChild(plr.Name) then
                    connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Updater)()
end

-- Initialize ESP for existing players
for _, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.Name ~= player.Name then
        coroutine.wrap(ESP)(v)
    end
end

-- Connect ESP for new players
game.Players.PlayerAdded:Connect(function(newplr)
    if newplr.Name ~= player.Name then
        coroutine.wrap(ESP)(newplr)
    end
end)

--// Frame
Library.UnloadCallback = Functions.Exit

local MainFrame = Library:CreateWindow({
    Name = "rex.wtf",
    Themeable = {
        Image = "7059346386",
        Info = "Made by Exunys\nPowered by Pepsi's UI Library",
        Credit = false
    },
    Background = "",
    Theme = [[{"__Designer.Colors.section":"D0FFD0","__Designer.Colors.topGradient":"051005","__Designer.Settings.ShowHideKey":"Enum.KeyCode.RightShift","__Designer.Colors.otherElementText":"9AB09A","__Designer.Colors.hoveredOptionBottom":"4FA54F","__Designer.Background.ImageAssetID":"109694448653518","__Designer.Colors.unhoveredOptionTop":"5BC95B","__Designer.Colors.innerBorder":"3A6E3A","__Designer.Colors.unselectedOption":"62AD62","__Designer.Background.UseBackgroundImage":false,"__Designer.Files.WorkspaceFile":"Aimbot V2","__Designer.Colors.main":"FFFFFF","__Designer.Colors.outerBorder":"1A3A1A","__Designer.Background.ImageColor":"FFFFFF","__Designer.Colors.tabText":"E0FFE0","__Designer.Colors.elementBorder":"173017","__Designer.Colors.sectionBackground":"091509","__Designer.Colors.selectedOption":"7DE87D","__Designer.Colors.background":"051005","__Designer.Colors.bottomGradient":"102410","__Designer.Background.ImageTransparency":95,"__Designer.Colors.hoveredOptionTop":"65D065","__Designer.Colors.elementText":"B6ECB6","__Designer.Colors.unhoveredOptionBottom":"75E675"}]]
})

--// Tabs
local SettingsTab = MainFrame:CreateTab({
    Name = "Aimbot"
})

local FOVSettingsTab = MainFrame:CreateTab({
    Name = "FOV Settings"
})

local ESPTab = MainFrame:CreateTab({
    Name = "ESP"
})

local FunctionsTab = MainFrame:CreateTab({
    Name = "Misc"
})

--// ESP - Sections
local ESP_Values = ESPTab:CreateSection({
    Name = "Values"
})

local ESP_Appearance = ESPTab:CreateSection({
    Name = "Appearance"
})

--// ESP Settings

-- Enable ESP
ESP_Values:AddToggle({
    Name = "Enable ESP",
    Value = false,
    Callback = function(New, Old)
        ESPSettings.Tracers = New
        ESPSettings.BoxESP = New
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v ~= player then
                ESP(v)
            end
        end
    end
})

-- Box ESP
ESP_Values:AddToggle({
    Name = "Box ESP",
    Value = false,
    Callback = function(New, Old)
        ESPSettings.BoxESP = New
    end
})

-- Tracer
ESP_Values:AddToggle({
    Name = "Tracer",
    Value = false,
    Callback = function(New, Old)
        ESPSettings.Tracers = New
    end
})

-- Team Check
ESP_Values:AddToggle({
    Name = "Team Check",
    Value = false,
    Callback = function(New, Old)
        Team_Check.TeamCheck = New
    end
})

-- Tracer Origin
ESP_Values:AddDropdown({
    Name = "Tracer Origin",
    Value = "Bottom",
    Callback = function(New, Old)
        ESPSettings.Tracer_Origin = New
    end,
    List = {"Top", "Bottom", "Left", "Right", "Middle"},
    Nothing = "Bottom"
})

-- Follow Mouse
ESP_Values:AddToggle({
    Name = "Follow Mouse",
    Value = false,
    Callback = function(New, Old)
        ESPSettings.Tracer_FollowMouse = New
    end
})

--// ESP Appearance

-- Box Color
ESP_Appearance:AddColorpicker({
    Name = "Box Color",
    Value = ESPSettings.Box_Color,
    Callback = function(New, Old)
        ESPSettings.Box_Color = New
    end
})

-- Tracer Color
ESP_Appearance:AddColorpicker({
    Name = "Tracer Color",
    Value = ESPSettings.Tracer_Color,
    Callback = function(New, Old)
        ESPSettings.Tracer_Color = New
    end
})

-- Box Transparency
ESP_Appearance:AddSlider({
    Name = "Box Transparency",
    Value = ESPSettings.Box_Transparency,
    Callback = function(New, Old)
        ESPSettings.Box_Transparency = New
        for _, v in pairs(Drawing.getInstances()) do
            if v.Name == "box" then
                v.Transparency = New
            end
        end
    end,
    Min = 0,
    Max = 1,
    Decimal = 2
})

-- Tracer Transparency
ESP_Appearance:AddSlider({
    Name = "Tracer Transparency",
    Value = ESPSettings.Tracer_Transparency,
    Callback = function(New, Old)
        ESPSettings.Tracer_Transparency = New
        for _, v in pairs(Drawing.getInstances()) do
            if v.Name == "tracer" then
                v.Transparency = New
            end
        end
    end,
    Min = 0,
    Max = 1,
    Decimal = 2
})

--// Functions
local FunctionsSection = FunctionsTab:CreateSection({
    Name = "Functions"
})

FunctionsSection:AddButton({
    Name = "Reset Settings",
    Callback = function()
        Functions.ResetSettings()
        Library.ResetAll()
    end
})

FunctionsSection:AddButton({
    Name = "Restart",
    Callback = Functions.Restart
})

FunctionsSection:AddButton({
    Name = "Exit",
    Callback = function()
        Functions:Exit()
        Library.Unload()
    end
})

FunctionsSection:AddButton({
    Name = "Copy Script Page",
    Callback = function()
        setclipboard("https://github.com/Exunys/Aimbot-V2")
    end
})

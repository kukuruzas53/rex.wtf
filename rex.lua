-- Preview: https://cdn.discordapp.com/attachments/796378086446333984/818089455897542687/unknown.png
-- Made by Blissful#4992, modified for integration with rex.wtf
local loadstring, game, getgenv, setclipboard = loadstring, game, getgenv, setclipboard

-- Loaded check
if getgenv().Aimbot then return end

loadstring(game:HttpGet("https://raw.githubusercontent.com/kukuruzas53/rex.wtf/refs/heads/main/Resources/main.lua"))()

-- Variables
local Aimbot = getgenv().Aimbot
local Settings, FOVSettings, Functions, ESPSettings = Aimbot.Settings, Aimbot.FOVSettings, Aimbot.Functions, Aimbot.ESPSettings or {}

local Library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)() -- Pepsi's UI Library

-- Frame setup
Library.UnloadCallback = Functions.Exit

local MainFrame = Library:CreateWindow({
    Name = "rex.wtf",
    Themeable = {
        Info = "Made by nerf",
        Credit = false
    },
    Background = "",
    [[{"__Designer.Colors.section":"D0FFD0","__Designer.Colors.topGradient":"051005","__Designer.Settings.ShowHideKey":"Enum.KeyCode.RightShift","__Designer.Colors.otherElementText":"9AB09A","__Designer.Colors.hoveredOptionBottom":"4FA54F","__Designer.Background.ImageAssetID":"109694448653518","__Designer.Colors.unhoveredOptionTop":"5BC95B","__Designer.Colors.innerBorder":"3A6E3A","__Designer.Colors.unselectedOption":"62AD62","__Designer.Background.UseBackgroundImage":false,"__Designer.Files.WorkspaceFile":"Aimbot V2","__Designer.Colors.main":"FFFFFF","__Designer.Colors.outerBorder":"1A3A1A","__Designer.Background.ImageColor":"FFFFFF","__Designer.Colors.tabText":"E0FFE0","__Designer.Colors.elementBorder":"173017","__Designer.Colors.sectionBackground":"091509","__Designer.Colors.selectedOption":"7DE87D","__Designer.Colors.background":"051005","__Designer.Colors.bottomGradient":"102410","__Designer.Background.ImageTransparency":95,"__Designer.Colors.hoveredOptionTop":"65D065","__Designer.Colors.elementText":"B6ECB6","__Designer.Colors.unhoveredOptionBottom":"75E675"}]]
})

-- Tabs
local MainTab = MainFrame:CreateTab({
    Name = "Main"
})

local ESPTab = MainFrame:CreateTab({
    Name = "ESP"
})

local FunctionsTab = MainFrame:CreateTab({
    Name = "Misc"
})

-- Main Tab Sections
local AimbotValues = MainTab:CreateSection({
    Name = "Aimbot Values"
})

local AimbotChecks = MainTab:CreateSection({
    Name = "Aimbot Checks"
})

-- FOV Settings are placed on the side of the Main Tab
local FOVSideSection = MainTab:CreateSection({
    Name = "FOV Settings",
    Side = "Right"
})

-- ESP Tab Sections
local ESPControls = ESPTab:CreateSection({
    Name = "ESP Controls"
})

local ESPVisuals = ESPTab:CreateSection({
    Name = "ESP Appearance"
})

local ESPSettingsSection = ESPTab:CreateSection({
    Name = "ESP Settings"
})

-- ESP Settings
ESPSettings = {
    Enabled = false,
    BoxESP = true,
    Tracers = true,
    Healthbar = true,
    WallCheck = true,
    TeamCheck = true,
    UseTeamColors = false,
    Box_Color = Color3.fromRGB(255, 0, 0),
    Tracer_Color = Color3.fromRGB(255, 0, 0),
    Healthbar_Color = Color3.fromRGB(0, 255, 0),
    Tracer_Thickness = 1,
    Box_Thickness = 1,
    Tracer_Origin = "Bottom", -- Middle, Bottom, Left, Right, Top, Following Mouse
    Tracer_FollowMouse = false
}

-- UI Elements for ESP
ESPControls:AddToggle({
    Name = "Enable ESP",
    Value = ESPSettings.Enabled,
    Callback = function(New, Old)
        ESPSettings.Enabled = New
    end
}).Default = ESPSettings.Enabled

ESPControls:AddToggle({
    Name = "Box ESP",
    Value = ESPSettings.BoxESP,
    Callback = function(New, Old)
        ESPSettings.BoxESP = New
    end
}).Default = ESPSettings.BoxESP

ESPControls:AddToggle({
    Name = "Tracers",
    Value = ESPSettings.Tracers,
    Callback = function(New, Old)
        ESPSettings.Tracers = New
    end
}).Default = ESPSettings.Tracers

ESPControls:AddToggle({
    Name = "Healthbar",
    Value = ESPSettings.Healthbar,
    Callback = function(New, Old)
        ESPSettings.Healthbar = New
    end
}).Default = ESPSettings.Healthbar

-- ESP Settings
ESPSettingsSection:AddToggle({
    Name = "Wall Check",
    Value = ESPSettings.WallCheck,
    Callback = function(New, Old)
        ESPSettings.WallCheck = New
    end
}).Default = ESPSettings.WallCheck

ESPSettingsSection:AddToggle({
    Name = "Team Check",
    Value = ESPSettings.TeamCheck,
    Callback = function(New, Old)
        ESPSettings.TeamCheck = New
    end
}).Default = ESPSettings.TeamCheck

ESPSettingsSection:AddToggle({
    Name = "Use Team Colors",
    Value = ESPSettings.UseTeamColors,
    Callback = function(New, Old)
        ESPSettings.UseTeamColors = New
    end
}).Default = ESPSettings.UseTeamColors

ESPSettingsSection:AddDropdown({
    Name = "Tracer Origin",
    Value = ESPSettings.Tracer_Origin,
    Callback = function(New, Old)
        ESPSettings.Tracer_Origin = New
        if New == "Following Mouse" then
            ESPSettings.Tracer_FollowMouse = true
        else
            ESPSettings.Tracer_FollowMouse = false
        end
    end,
    List = {"Middle", "Bottom", "Left", "Right", "Top", "Following Mouse"},
    Nothing = "Bottom"
}).Default = ESPSettings.Tracer_Origin

-- ESP Visuals
ESPVisuals:AddColorpicker({
    Name = "Box Color",
    Value = ESPSettings.Box_Color,
    Callback = function(New, Old)
        ESPSettings.Box_Color = New
    end
}).Default = ESPSettings.Box_Color

ESPVisuals:AddColorpicker({
    Name = "Tracer Color",
    Value = ESPSettings.Tracer_Color,
    Callback = function(New, Old)
        ESPSettings.Tracer_Color = New
    end
}).Default = ESPSettings.Tracer_Color

ESPVisuals:AddColorpicker({
    Name = "Healthbar Base Color",
    Value = ESPSettings.Healthbar_Color,
    Callback = function(New, Old)
        ESPSettings.Healthbar_Color = New
    end
}).Default = ESPSettings.Healthbar_Color

-- Helper functions for drawing
local player = game:GetService("Players").LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local mouse = player:GetMouse()

local function NewQuad(thickness, color)
    local quad = Drawing.new("Quad")
    quad.Visible = false
    quad.PointA = Vector2.new(0,0)
    quad.PointB = Vector2.new(0,0)
    quad.PointC = Vector2.new(0,0)
    quad.PointD = Vector2.new(0,0)
    quad.Color = color
    quad.Filled = false
    quad.Thickness = thickness
    quad.Transparency = 1
    return quad
end

local function NewLine(thickness, color)
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(0, 0)
    line.Color = color 
    line.Thickness = thickness
    line.Transparency = 1
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

-- ESP Function
local function ESP(plr)
    local library = {
        blacktracer = NewLine(ESPSettings.Tracer_Thickness*2, black),
        tracer = NewLine(ESPSettings.Tracer_Thickness, ESPSettings.Tracer_Color),
        black = NewQuad(ESPSettings.Box_Thickness*2, black),
        box = NewQuad(ESPSettings.Box_Thickness, ESPSettings.Box_Color),
        healthbar = NewLine(3, black),
        greenhealth = NewLine(1.5, ESPSettings.Healthbar_Color)
    }

    local function Colorize(color)
        for _, x in pairs(library) do
            if x ~= library.healthbar and x ~= library.greenhealth and x ~= library.blacktracer and x ~= library.black then
                x.Color = color
            end
        end
    end

    local function Updater()
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            if ESPSettings.Enabled and plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                local HumPos, OnScreen = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                local HeadPos, HeadVisible = camera:WorldToViewportPoint(plr.Character.Head.Position)

                if OnScreen and (not ESPSettings.WallCheck or HeadVisible) then
                    local head = camera:WorldToViewportPoint(plr.Character.Head.Position)
                    local DistanceY = math.clamp((Vector2.new(head.X, head.Y) - Vector2.new(HumPos.X, HumPos.Y)).magnitude, 2, math.huge)
                    
                    local function Size(item)
                        item.PointA = Vector2.new(HumPos.X + DistanceY, HumPos.Y - DistanceY*2)
                        item.PointB = Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY*2)
                        item.PointC = Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY*2)
                        item.PointD = Vector2.new(HumPos.X + DistanceY, HumPos.Y + DistanceY*2)
                    end
                    Size(library.box)
                    Size(library.black)

                    if ESPSettings.Tracers then
                        if ESPSettings.Tracer_Origin == "Following Mouse" or ESPSettings.Tracer_FollowMouse then
                            library.tracer.From = Vector2.new(mouse.X, mouse.Y)
                            library.blacktracer.From = Vector2.new(mouse.X, mouse.Y)
                        elseif ESPSettings.Tracer_Origin == "Middle" then
                            library.tracer.From = camera.ViewportSize*0.5
                            library.blacktracer.From = camera.ViewportSize*0.5
                        elseif ESPSettings.Tracer_Origin == "Bottom" then
                            library.tracer.From = Vector2.new(camera.ViewportSize.X*0.5, camera.ViewportSize.Y) 
                            library.blacktracer.From = Vector2.new(camera.ViewportSize.X*0.5, camera.ViewportSize.Y)
                        elseif ESPSettings.Tracer_Origin == "Left" then
                            library.tracer.From = Vector2.new(0, camera.ViewportSize.Y*0.5)
                            library.blacktracer.From = Vector2.new(0, camera.ViewportSize.Y*0.5)
                        elseif ESPSettings.Tracer_Origin == "Right" then
                            library.tracer.From = Vector2.new(camera.ViewportSize.X, camera.ViewportSize.Y*0.5)
                            library.blacktracer.From = Vector2.new(camera.ViewportSize.X, camera.ViewportSize.Y*0.5)
                        elseif ESPSettings.Tracer_Origin == "Top" then
                            library.tracer.From = Vector2.new(camera.ViewportSize.X*0.5, 0)
                            library.blacktracer.From = Vector2.new(camera.ViewportSize.X*0.5, 0)
                        end
                        library.tracer.To = Vector2.new(HumPos.X, HumPos.Y + DistanceY*2)
                        library.blacktracer.To = Vector2.new(HumPos.X, HumPos.Y + DistanceY*2)
                    else 
                        library.tracer.From = Vector2.new(0, 0)
                        library.blacktracer.From = Vector2.new(0, 0)
                        library.tracer.To = Vector2.new(0, 0)
                        library.blacktracer.To = Vector2.new(0, 0)
                    end

                    -- Health Bar
                    if ESPSettings.Healthbar then
                        local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            local healthPercentage = humanoid.Health / humanoid.MaxHealth
                            local d = (Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY*2) - Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY*2)).magnitude 
                            local healthHeight = d * healthPercentage

                            library.healthbar.From = Vector2.new(HumPos.X - DistanceY - 6, HumPos.Y - DistanceY*2)
                            library.healthbar.To = Vector2.new(HumPos.X - DistanceY - 6, HumPos.Y + DistanceY*2)

                            library.greenhealth.From = Vector2.new(HumPos.X - DistanceY - 6, HumPos.Y + DistanceY*2 - healthHeight)
                            library.greenhealth.To = Vector2.new(HumPos.X - DistanceY - 6, HumPos.Y + DistanceY*2)

                            -- Gradient color based on health
                            local green = Color3.fromRGB(0, 255, 0)
                            local red = Color3.fromRGB(255, 0, 0)
                            library.greenhealth.Color = red:lerp(green, healthPercentage)
                        else
                            library.greenhealth.From = Vector2.new(0, 0)
                            library.greenhealth.To = Vector2.new(0, 0)
                            library.healthbar.From = Vector2.new(0, 0)
                            library.healthbar.To = Vector2.new(0, 0)
                        end
                    else
                        library.greenhealth.From = Vector2.new(0, 0)
                        library.greenhealth.To = Vector2.new(0, 0)
                        library.healthbar.From = Vector2.new(0, 0)
                        library.healthbar.To = Vector2.new(0, 0)
                    end

                    if ESPSettings.TeamCheck and plr.Team == player.Team then
                        Visibility(false, library)
                    else
                        if ESPSettings.UseTeamColors then
                            Colorize(plr.TeamColor.Color)
                        else
                            library.tracer.Color = ESPSettings.Tracer_Color
                            library.box.Color = ESPSettings.Box_Color
                        end
                        Visibility(true, library)
                    end
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

-- Initialize ESP for current players
for _, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.Name ~= player.Name then 
        ESP(v)
    end
end

-- Connect function for new players
game:GetService("Players").PlayerAdded:Connect(function(v)
    if v.Name ~= player.Name then 
        ESP(v)
    end
end)

-- Aimbot Functionality
local AimbotConnection
Settings.LockPart = "Head"  -- Default lock part

-- Aimbot UI Elements
AimbotValues:AddToggle({
    Name = "Enabled",
    Value = Settings.Enabled,
    Callback = function(New, Old)
        Settings.Enabled = New
        if New then
            StartAimbot()
        else
            StopAimbot()
        end
    end
}).Default = Settings.Enabled

AimbotValues:AddToggle({
    Name = "Toggle",
    Value = Settings.Toggle,
    Callback = function(New, Old)
        Settings.Toggle = New
    end
}).Default = Settings.Toggle

AimbotValues:AddDropdown({
    Name = "Lock Part",
    Value = Settings.LockPart,
    Callback = function(New, Old)
        Settings.LockPart = New
    end,
    List = {"Head", "HumanoidRootPart"},
    Nothing = "Head"
}).Default = Settings.LockPart

AimbotValues:AddTextbox({
    Name = "Hotkey",
    Value = Settings.TriggerKey,
    Callback = function(New, Old)
        Settings.TriggerKey = New
    end
}).Default = Settings.TriggerKey

AimbotValues:AddSlider({
    Name = "Sensitivity",
    Value = Settings.Sensitivity,
    Callback = function(New, Old)
        Settings.Sensitivity = New
    end,
    Min = 0,
    Max = 1,
    Decimals = 2
}).Default = Settings.Sensitivity

AimbotChecks:AddToggle({
    Name = "Team Check",
    Value = Settings.TeamCheck,
    Callback = function(New, Old)
        Settings.TeamCheck = New
    end
}).Default = Settings.TeamCheck

AimbotChecks:AddToggle({
    Name = "Wall Check",
    Value = Settings.WallCheck,
    Callback = function(New, Old)
        Settings.WallCheck = New
    end
}).Default = Settings.WallCheck

AimbotChecks:AddToggle({
    Name = "Alive Check",
    Value = Settings.AliveCheck,
    Callback = function(New, Old)
        Settings.AliveCheck = New
    end
}).Default = Settings.AliveCheck

-- Aimbot Functions
local function StartAimbot()
    if AimbotConnection then return end
    AimbotConnection = game:GetService("RunService").RenderStepped:Connect(function()
        if Settings.Enabled then
            local closestPlayer = nil
            local closestDistance = math.huge

            for _,v in pairs(game.Players:GetPlayers()) do
                if v.Name ~= player.Name and v.Character and v.Character:FindFirstChild(Settings.LockPart) and v.Character:FindFirstChildOfClass("Humanoid") then
                    local humanoid = v.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid.Health > 0 and (not Settings.AliveCheck or humanoid:GetState() ~= Enum.HumanoidStateType.Dead) then
                        local screenPos, onScreen = camera:WorldToScreenPoint(v.Character[Settings.LockPart].Position)
                        if onScreen then
                            local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude
                            if distance < closestDistance then
                                if Settings.TeamCheck and v.Team ~= player.Team then
                                    closestPlayer = v
                                    closestDistance = distance
                                elseif not Settings.TeamCheck then
                                    closestPlayer = v
                                    closestDistance = distance
                                end
                            end
                        end
                    end
                end
            end

            if closestPlayer then
                local aimPart = closestPlayer.Character:FindFirstChild(Settings.LockPart)
                local aimPosition = camera:WorldToScreenPoint(aimPart.Position)
                local mousePosition = Vector2.new(mouse.X, mouse.Y)
                local aimVector = (Vector2.new(aimPosition.X, aimPosition.Y) - mousePosition) * Settings.Sensitivity

                if game.GuiService then
                    game.GuiService:MoveMouse(aimVector.X, aimVector.Y)
                else
                    -- Fallback for games without GuiService
                    local mousemoverel = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-Script/main/mousemoverel.lua"))()
                    mousemoverel(aimVector.X, aimVector.Y)
                end
            end
        end
    end)
end

local function StopAimbot()
    if AimbotConnection then
        AimbotConnection:Disconnect()
        AimbotConnection = nil
    end
end

-- Toggle Aimbot on Hotkey
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and input.KeyCode == Enum.KeyCode[Settings.TriggerKey] then
        if Settings.Toggle then
            if Settings.Enabled then
                StopAimbot()
                Settings.Enabled = false
            else
                StartAimbot()
                Settings.Enabled = true
            end
        else
            StartAimbot()
        end
    elseif not gameProcessedEvent and input.KeyCode == Enum.KeyCode[Settings.TriggerKey] and not Settings.Toggle then
        StopAimbot()
    end
end)

-- FOV Settings Section
FOVSideSection:AddToggle({
    Name = "Enabled",
    Value = FOVSettings.Enabled,
    Callback = function(New, Old)
        FOVSettings.Enabled = New
    end
}).Default = FOVSettings.Enabled

FOVSideSection:AddToggle({
    Name = "Visible",
    Value = FOVSettings.Visible,
    Callback = function(New, Old)
        FOVSettings.Visible = New
    end
}).Default = FOVSettings.Visible

FOVSideSection:AddSlider({
    Name = "Amount",
    Value = FOVSettings.Amount,
    Callback = function(New, Old)
        FOVSettings.Amount = New
    end,
    Min = 10,
    Max = 300
}).Default = FOVSettings.Amount

FOVSideSection:AddToggle({
    Name = "Filled",
    Value = FOVSettings.Filled,
    Callback = function(New, Old)
        FOVSettings.Filled = New
    end
}).Default = FOVSettings.Filled

FOVSideSection:AddSlider({
    Name = "Transparency",
    Value = FOVSettings.Transparency,
    Callback = function(New, Old)
        FOVSettings.Transparency = New
    end,
    Min = 0,
    Max = 1,
    Decimal = 1
}).Default = FOVSettings.Transparency

FOVSideSection:AddSlider({
    Name = "Sides",
    Value = FOVSettings.Sides,
    Callback = function(New, Old)
        FOVSettings.Sides = New
    end,
    Min = 3,
    Max = 60
}).Default = FOVSettings.Sides

FOVSideSection:AddSlider({
    Name = "Thickness",
    Value = FOVSettings.Thickness,
    Callback = function(New, Old)
        FOVSettings.Thickness = New
    end,
    Min = 1,
    Max = 50
}).Default = FOVSettings.Thickness

FOVSideSection:AddColorpicker({
    Name = "Color",
    Value = FOVSettings.Color,
    Callback = function(New, Old)
        FOVSettings.Color = New
    end
}).Default = FOVSettings.Color

FOVSideSection:AddColorpicker({
    Name = "Locked Color",
    Value = FOVSettings.LockedColor,
    Callback = function(New, Old)
        FOVSettings.LockedColor = New
    end
}).Default = FOVSettings.LockedColor

-- Functions Tab - Functions
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

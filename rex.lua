--// Cache

local loadstring, game, getgenv, setclipboard = loadstring, game, getgenv, setclipboard

--// Loaded check

if getgenv().Aimbot then return end

--// Load Aimbot V2 (Raw)

loadstring(game:HttpGet("https://raw.githubusercontent.com/kukuruzas53/rex.wtf/refs/heads/main/Resources/main.lua"))()

--// Variables

local Aimbot = getgenv().Aimbot
local Settings, FOVSettings, Functions = Aimbot.Settings, Aimbot.FOVSettings, Aimbot.Functions

local Library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)() -- Pepsi's UI Library

local Parts = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg", "UpperTorso", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "LowerTorso", "RightUpperLeg"}

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

local FunctionsTab = MainFrame:CreateTab({
	Name = "Misc"
})

--// Settings - Sections

local Values = SettingsTab:CreateSection({
	Name = "Values"
})

local Checks = SettingsTab:CreateSection({
	Name = "Checks"
})

local ThirdPerson = SettingsTab:CreateSection({
	Name = "Third Person"
})

--// FOV Settings - Sections

local FOV_Values = FOVSettingsTab:CreateSection({
	Name = "Values"
})

local FOV_Appearance = FOVSettingsTab:CreateSection({
	Name = "Appearance"
})

--// Functions - Sections

local FunctionsSection = FunctionsTab:CreateSection({
	Name = "Functions"
})

--// Settings / Values

Values:AddToggle({
	Name = "Enabled",
	Value = Settings.Enabled,
	Callback = function(New, Old)
		Settings.Enabled = New
	end
}).Default = Settings.Enabled

Values:AddToggle({
	Name = "Toggle",
	Value = Settings.Toggle,
	Callback = function(New, Old)
		Settings.Toggle = New
	end
}).Default = Settings.Toggle

Settings.LockPart = Parts[1]; Values:AddDropdown({
	Name = "Lock Part",
	Value = Parts[1],
	Callback = function(New, Old)
		Settings.LockPart = New
	end,
	List = Parts,
	Nothing = "Head"
}).Default = Parts[1]

Values:AddTextbox({ -- Using a Textbox instead of a Keybind because the UI Library doesn't support Mouse inputs like Left Click / Right Click...
	Name = "Hotkey",
	Value = Settings.TriggerKey,
	Callback = function(New, Old)
		Settings.TriggerKey = New
	end
}).Default = Settings.TriggerKey

--[[
Values:AddKeybind({
	Name = "Hotkey",
	Value = Settings.TriggerKey,
	Callback = function(New, Old)
		Settings.TriggerKey = stringmatch(tostring(New), "Enum%.[UserInputType]*[KeyCode]*%.(.+)")
	end,
}).Default = Settings.TriggerKey
]]

Values:AddSlider({
	Name = "Sensitivity",
	Value = Settings.Sensitivity,
	Callback = function(New, Old)
		Settings.Sensitivity = New
	end,
	Min = 0,
	Max = 1,
	Decimals = 2
}).Default = Settings.Sensitivity

--// Settings / Checks

Checks:AddToggle({
	Name = "Team Check",
	Value = Settings.TeamCheck,
	Callback = function(New, Old)
		Settings.TeamCheck = New
	end
}).Default = Settings.TeamCheck

Checks:AddToggle({
	Name = "Wall Check",
	Value = Settings.WallCheck,
	Callback = function(New, Old)
		Settings.WallCheck = New
	end
}).Default = Settings.WallCheck

Checks:AddToggle({
	Name = "Alive Check",
	Value = Settings.AliveCheck,
	Callback = function(New, Old)
		Settings.AliveCheck = New
	end
}).Default = Settings.AliveCheck

--// Settings / ThirdPerson

ThirdPerson:AddToggle({
	Name = "Enable Third Person",
	Value = Settings.ThirdPerson,
	Callback = function(New, Old)
		Settings.ThirdPerson = New
	end
}).Default = Settings.ThirdPerson

ThirdPerson:AddSlider({
	Name = "Sensitivity",
	Value = Settings.ThirdPersonSensitivity,
	Callback = function(New, Old)
		Settings.ThirdPersonSensitivity = New
	end,
	Min = 0.1,
	Max = 5,
	Decimals = 1
}).Default = Settings.ThirdPersonSensitivity

--// FOV Settings / Values

FOV_Values:AddToggle({
	Name = "Enabled",
	Value = FOVSettings.Enabled,
	Callback = function(New, Old)
		FOVSettings.Enabled = New
	end
}).Default = FOVSettings.Enabled

FOV_Values:AddToggle({
	Name = "Visible",
	Value = FOVSettings.Visible,
	Callback = function(New, Old)
		FOVSettings.Visible = New
	end
}).Default = FOVSettings.Visible

FOV_Values:AddSlider({
	Name = "Amount",
	Value = FOVSettings.Amount,
	Callback = function(New, Old)
		FOVSettings.Amount = New
	end,
	Min = 10,
	Max = 300
}).Default = FOVSettings.Amount

--// FOV Settings / Appearance

FOV_Appearance:AddToggle({
	Name = "Filled",
	Value = FOVSettings.Filled,
	Callback = function(New, Old)
		FOVSettings.Filled = New
	end
}).Default = FOVSettings.Filled

FOV_Appearance:AddSlider({
	Name = "Transparency",
	Value = FOVSettings.Transparency,
	Callback = function(New, Old)
		FOVSettings.Transparency = New
	end,
	Min = 0,
	Max = 1,
	Decimal = 1
}).Default = FOVSettings.Transparency

FOV_Appearance:AddSlider({
	Name = "Sides",
	Value = FOVSettings.Sides,
	Callback = function(New, Old)
		FOVSettings.Sides = New
	end,
	Min = 3,
	Max = 60
}).Default = FOVSettings.Sides

FOV_Appearance:AddSlider({
	Name = "Thickness",
	Value = FOVSettings.Thickness,
	Callback = function(New, Old)
		FOVSettings.Thickness = New
	end,
	Min = 1,
	Max = 50
}).Default = FOVSettings.Thickness

FOV_Appearance:AddColorpicker({
	Name = "Color",
	Value = FOVSettings.Color,
	Callback = function(New, Old)
		FOVSettings.Color = New
	end
}).Default = FOVSettings.Color

FOV_Appearance:AddColorpicker({
	Name = "Locked Color",
	Value = FOVSettings.LockedColor,
	Callback = function(New, Old)
		FOVSettings.LockedColor = New
	end
}).Default = FOVSettings.LockedColor

--// Functions / Functions

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
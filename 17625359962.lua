local MacLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Insalad/maclibthing/refs/heads/main/main"))();
local playersService = cloneref(game:GetService("Players")) or game:GetService("Players");
local lplr = playersService.LocalPlayer;
local char = lplr.Character
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage")) or game:GetService("ReplicatedStorage");
local RunService = cloneref(game:GetService("RunService")) or game:GetService("RunService");

local Window = MacLib:Window({
    Title = "Lunar Client",
    Subtitle = "Rivals 1.0.0",
    Size = UDim2.fromOffset(868, 650),
    DragStyle = 1,
    DisabledWindowControls = {},
    ShowUserInfo = true,
    Keybind = Enum.KeyCode.RightControl,
    AcrylicBlur = true,
})

local FPSUnlocker = Window:GlobalSetting({
    Name = "FPSUnlocker",
    Default = false,
    Callback = function(State)
        if state then
            if setfpscap then
                setfpscap(9999) 
            else 
                Window:Notify({Title = "Lunar", Description = "Your exploit doesn't support setfpscap.",Lifetime = 5}) 
            end 
        else 
            setfpscap(60)
        end
    end,
})

local UIBlurToggle = Window:GlobalSetting({
    Name = "UI Blur",
    Default = Window:GetAcrylicBlurState(),
    Callback = function(bool)
        Window:SetAcrylicBlurState(bool)
    end,
})

local NotificationToggler = Window:GlobalSetting({
    Name = "Notifications",
    Default = Window:GetNotificationsState(),
    Callback = function(bool)
        Window:SetNotificationsState(bool)
    end,
})

local ShowUserInfo = Window:GlobalSetting({
    Name = "Show User Info",
    Default = Window:GetUserInfoState(),
    Callback = function(bool)
        Window:SetUserInfoState(bool)
    end,
})

Window:Notify({
    Title = "Lunar",
    Description = "Lunar has loaded! Press RCONTROL to Open/Close",
    Lifetime = 5
})

local TabGroup = Window:TabGroup()

local Tab = TabGroup:Tab({
    Name = "Blatant",
    Image = "rbxassetid://13350767943"
})

local Section = Tab:Section({
    Side = "Left"
})

local HumanoidPartService = {};
local oldsize = {};
local SilentAim = {};
local TorsoSize = {};
local getplrname = function()
    for i,v in pairs(game:GetChildren()) do
        if v.ClassName == "Players" then
            return v.Name;
        end;
    end
end
local plr = game[getplrname()];
local SilentRepeat
SilentAim = Section:Toggle({
    Name = "SilentAim",
    Default = false,
    Callback = function(value)
        if value then
            task.spawn(function()
                SilentRepeat = RunService.Heartbeat:Connect(function()
                    for i,v in pairs(playersService:GetPlayers()) do
                        if v.Name ~= plr.LocalPlayer.Name and v.Character then
                            task.wait()
                            HumanoidPartService = {
                                RightLeg = v.Character.RightUpperLeg,
                                LeftLeg = v.Character.LeftUpperLeg,
                                Head = v.Character.Head,
                                HumanoidRootPart = v.Character.HumanoidRootPart
                            }
                            oldsize = {
                                RightLeg = HumanoidPartService.RightLeg.Size,
                                LeftLeg = HumanoidPartService.LeftLeg.Size,
                                Head = HumanoidPartService.Head.Size,
                                HumanoidRootPart = HumanoidPartService.Head.Size
                            }
                            for i,v in pairs(HumanoidPartService) do
                                v.CanCollide = false;
                                v.Transparency = 10;
                                v.Size = Vector3.new(TorsoSize.Value, TorsoSize.Value, TorsoSize.Value);
                            end
                        end
                    end
                end)
            end)
        else
            SilentRepeat:Disconnect()
            for i,v in pairs(playersService:GetPlayers()) do
                if v.Name ~= lplr.Name and v.Character then
                    for i,v in pairs(HumanoidPartService) do
                        v.CanCollide = true;
                        v.Transparency = 0;
                        v.Size = oldsize[i];
                    end
                    HumanoidPartService = nil;
                    oldsize = nil;
                end
            end
        end
    end
})
TorsoSize = Section:Slider({
    Name = "Torso Size",
    Default = 15,
    Minimum = 10,
    Maximum = 25,
    DisplayMethod = "Value",
    Callback = function(value)
        TorsoSize.Value = value
    end,
})

local Section2 = Tab:Section({
    Side = "Right"
})

local Desync = {};
local DesyncDelay = {};
local Desynccc
Desync = Section2:Toggle({
    Name = "Desync",
    Default = false,
    Callback = function(value)
        if value then
            task.spawn(function()
                Desynccc = RunService.Heartbeat:Connect(function()
                    task.wait()
                    if sethiddenproperty then
                        sethiddenproperty(lplr.character.HumanoidRootPart, "NetworkIsSleeping", true)
                        task.wait(DesyncDelay.Value);
                        sethiddenproperty(lplr.character.HumanoidRootPart, "NetworkIsSleeping", false)
                    end
                end)
            end)
        else
            Desynccc:Disconnect()
            if sethiddenproperty then
                sethiddenproperty(lplr.character.HumanoidRootPart, "NetworkIsSleeping", false)
            end
        end
    end
})
DesyncDelay = Section2:Slider({
    Name = "Delay",
    Default = 0.33,
    Minimum = 0.20,
    Maximum = 0.5,
    DisplayMethod = "Percent",
    Callback = function(value)
        DesyncDelay.Value = value
    end,
})

local Section3 = Tab:Section({
    Side = "Left"
})

local Walkspeed = {};
local WalkspeedSlider = {};
local oldspeed = {};
local SpeedCon
Walkspeed = Section3:Toggle({
    Name = "WalkSpeed",
    Default = false,
    Callback = function(value)
        if value then
            task.spawn(function()
                task.wait()
                oldspeed = {
                    speed = lplr.character.Humanoid.WalkSpeed
                }
                if lplr.character.Humanoid:GetPropertyChangedSignal("WalkSpeed") then
                    SpeedCon = lplr.character.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                        lplr.character.Humanoid.WalkSpeed = WalkspeedSlider.Value
                    end)
                else
                    lplr.character.Humanoid.WalkSpeed = WalkspeedSlider.Value
                end
            end)
        else
            SpeedCon:Disconnect()
            lplr.character.Humanoid.WalkSpeed = oldspeed.speed
            oldspeed = nil
        end
    end
})
WalkspeedSlider = Section3:Slider({
    Name = "Speed",
    Default = 50,
    Minimum = 16,
    Maximum = 75,
    DisplayMethod = "Value",
    Callback = function(value)
        WalkspeedSlider.Value = value
    end,
})

local Section4 = Tab:Section({
    Side = "Right"
})

local ChamsManager = {
    Enabled = false, 
    Settings = {
        FillColor = Color3.fromRGB(255, 255, 255),  
        OutlineColor = Color3.fromRGB(255, 255, 255),
        FillTransparency = 0.8,
        OutlineTransparency = 0.3
    },
    Storage = Instance.new("Folder", game.CoreGui),
    Connections = {}
}
ChamsManager.Storage.Name = "HighlightStorage"
function ChamsManager:CreateHighlightForPlayer(player)
    if player == lplr then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name
    highlight.FillColor = self.Settings.FillColor
    highlight.DepthMode = "AlwaysOnTop"
    highlight.FillTransparency = self.Settings.FillTransparency
    highlight.OutlineColor = self.Settings.OutlineColor
    highlight.OutlineTransparency = self.Settings.OutlineTransparency
    highlight.Parent = self.Storage
    local char = player.Character
    if char then
        highlight.Adornee = char
    end
    self.Connections[player] = player.CharacterAdded:Connect(function(newchar)
        highlight.Adornee = newchar
    end)
end

function ChamsManager:DisableHighlightForPlayer(player)
    if self.Storage:FindFirstChild(player.Name) then
        self.Storage[player.Name]:Destroy()
    end
    if self.Connections[player] then
        self.Connections[player]:Disconnect()
        self.Connections[player] = nil
    end
end
function ChamsManager:EnableAllHighlights()
    for _, player in ipairs(playersService:GetPlayers()) do
        self:CreateHighlightForPlayer(player)
    end
end
function ChamsManager:DisableAllHighlights()
    for _, player in ipairs(playersService:GetPlayers()) do
        self:DisableHighlightForPlayer(player)
    end
end
function ChamsManager:UpdateAllHighlights()
    for _, highlight in ipairs(self.Storage:GetChildren()) do
        if highlight:IsA("Highlight") then
            highlight.FillColor = self.Settings.FillColor
            highlight.FillTransparency = self.Settings.FillTransparency
            highlight.OutlineColor = self.Settings.OutlineColor
            highlight.OutlineTransparency = self.Settings.OutlineTransparency
        end
    end
end
function ChamsManager:Init()
    playersService.PlayerAdded:Connect(function(player)
        if self.Enabled then  
            self:CreateHighlightForPlayer(player)
        end
    end)
    playersService.PlayerRemoving:Connect(function(player)
        self:DisableHighlightForPlayer(player)
    end)
end

ChamsManager:Init()

local Chams = Section4:Toggle({
    Name = "Chams",
    Default = false,
    Callback = function(value)
        ChamsManager.Enabled = value
        if value then
            ChamsManager:EnableAllHighlights()
        else
            ChamsManager:DisableAllHighlights()
        end
    end
})
local OutLineColor = Section4:Colorpicker({
    Name = "Outline Color",
    Default = ChamsManager.Settings.OutlineColor,
    Alpha = 0,
    Callback = function(color, alpha)
        ChamsManager.Settings.OutlineColor = color
        ChamsManager:UpdateAllHighlights()
    end
}, "OutlineColor")
local FillColor = Section4:Colorpicker({
    Name = "Fill Color",
    Default = ChamsManager.Settings.FillColor,
    Alpha = 0,
    Callback = function(color, alpha)
        ChamsManager.Settings.FillColor = color
        ChamsManager:UpdateAllHighlights()
    end
}, "FillColor")
local FillTransparencySlider = Section4:Slider({
    Name = "Fill Transparency",
    Default = ChamsManager.Settings.FillTransparency,
    Minimum = 0,
    Maximum = 1,
    DisplayMethod = "Percent",
    Callback = function(value)
        ChamsManager.Settings.FillTransparency = value
        ChamsManager:UpdateAllHighlights()
    end
})
local OutlineTransparencySlider = Section4:Slider({
    Name = "Outline Transparency",
    Default = ChamsManager.Settings.OutlineTransparency,
    Minimum = 0,
    Maximum = 1,
    DisplayMethod = "Percent",
    Callback = function(value)
        ChamsManager.Settings.OutlineTransparency = value
        ChamsManager:UpdateAllHighlights()
    end
})

local Section5 = Tab:Section({
    Side = "Left"
})

local AntiDeath = {};
local AntiDeathTrigger = {};
local BoostMode = {};
local AntiDeathThread;
local AntiDeathFunctions = {
    Velocity = function()
        lplr.Character.PrimaryPart.Velocity = Vector3.new(0, 300, 0)
    end,
    CFrame = function()
        lplr.Character.PrimaryPart.CFrame = CFrame.new(0, 300, 0)
    end,
    Tween = function()
        tweenService:Create(character.HumanoidRootPart, TweenInfo.new(0.49, Enum.EasingStyle.Linear), {
            CFrame = lplr.Character.PrimaryPart.CFrame + Vector3.new(0, 300, 0)
        }):Play()
    end
}
AntiDeath = Section5:Toggle({
    Name = "AntiDeath",
    Default = false,
    Callback = function(value)
        if value then
            task.spawn(function()
                if lplr.Character.Humanoid.Health < AntiDeathTrigger.Value then
                    task.wait()
                    pcall(AntiDeathFunctions[JumpBoostMode.Value])
                    --use medkit remote
                    --anchor body until medkit is used (5 seconds)
                    --unanchor body
                end
            end)
        end
    end
}, "AntiDeath")
AntiDeathTrigger = Section5:Slider({
    Name = "HealthTrigger",
    Default = 50,
    Minimum = 1,
    Maximum = 100,
    DisplayMethod = "Value",
    Callback = function(Value)     
        AntiDeathTrigger.Value = Value
    end,
}, "AntiDeathTrigger")
BoostMode = Section5:Dropdown({
    Name = "Boost Mode",
    Search = true,
    Multi = false,
    Required = false,
    Options = {"Velocity", "CFrame", "Tween"},
    Default = {"Tween"},
    Callback = function(Value)
        JumpBoostMode.Value = Value
    end,
}, "JumpBoostMode")

local Section6 = Tab:Section({
    Side = "Right"
})

getgenv().JumpBoostEnabled = true
getgenv().JumpBoostDefault = false

local JumpBoostSettings = {
	Visual = {
		Name = "JumpBoost",
		HoverText = "Boosts you in the air"
	},
	Inside = {Default = getgenv().JumpBoostDefault}
}

local JumpBoost = {Enabled = false}
local JumpBoostMode = {Value = "Velocity"}
local JumpBoostVelocity = {Value = 650}
local JumpBoostCFrame = {Value = 50}
local JumpBoostTween = {Value = 1000}
local JumpBoostVelocity2 = {Value = 5}	
local JumpBoostCFrame2 = {Value = 1}
local JumpBoostTween3 = {Value = 25}
local JumpBoostTween2 = {Value = 4}
local JumpBoostNotifyDR = {Value = 3}
local JumpBoostLoop = {Enabled = false}
local JumpBoostArray = {Enabled = true}
local JumpBoostNotify = {Enabled = true}
local JumpBoostNotifyV = {Enabled = true}
local JumpBoostNotifyC = {Enabled = true}
local JumpBoostNotifyT = {Enabled = true}
local JumpBoostNotifyD = {Enabled = true}
local JumpBoostNotifyL = {Enabled = false}
local JumpBoostNotifyS = {Enabled = true}
local JumpBoostTable = {
	Messages = {
		Title = "JumpBoost",
		Context = "Boosted",
		Context2 = "Enable when you're alive",
		Context3 = "Enable in settings to use"
	},
	Sliders = {
		Velocity = JumpBoostVelocity.Value,
		Velocity2 = JumpBoostVelocity2.Value/10,
		CFrame = JumpBoostCFrame.Value,
		CFrame2 = JumpBoostCFrame2.Value/10,
		Tween = JumpBoostTween.Value,
		Tween2 = JumpBoostTween2.Value/10,
		Tween3 = JumpBoostTween3.Value/10,
		Duration = JumpBoostNotifyDR.Value
	}
}
local function JumpBoostDisable()
	JumpBoost.ToggleButton(false)
	return
end
local function SendWarning()
	if JumpBoostNotify.Enabled and JumpBoostNotifyV.Enabled then
		warningNotification(JumpBoostTable.Messages.Title,JumpBoostTable.Messages.Context,JumpBoostTable.Sliders.Duration)
	end
end
local function SendWarning2()
	if JumpBoostNotify.Enabled and JumpBoostNotifyV.Enabled then
		warningNotification(JumpBoostTable.Messages.Title,JumpBoostTable.Messages.Context,JumpBoostTable.Sliders.Duration)
	end
end
local function SendWarning3()
	if JumpBoostNotifyL.Enabled then
		SendWarning()
	end
end
JumpBoost = Section6:Toggle({
	Name = JumpBoostSettings.Visual.Name,
    HoverText = JumpBoostSettings.Visual.HoverText,
	Function = function(EnableBoost)
		if EnableBoost and getgenv().JumpBoostEnabled then
			task.spawn(function()
				if JumpBoostMode.Value == "Velocity" then
					if entityLibrary.isAlive then
						if not JumpBoostLoop.Enabled then
							entityLibrary.character.HumanoidRootPart.Velocity += Vector3.new(0,JumpBoostTable.Sliders.Velocity,0)
							SendWarning()
							JumpBoostDisable()
						else
							repeat task.wait()
								entityLibrary.character.HumanoidRootPart.Velocity += Vector3.new(0,JumpBoostTable.Sliders.Velocity,0)
								SendWarning3()
								task.wait(JumpBoostTable.Sliders.Velocity2)
							until not JumpBoost.Enabled or not JumpBoostLoop.Enabled or not entityLibrary.isAlive or JumpBoostMode.Value ~= "Velocity"
						end
					else
						SendWarning2()
						JumpBoostDisable()
					end
				elseif JumpBoostMode.Value == "CFrame" then
					if entityLibrary.isAlive then
						if not JumpBoostLoop.Enabled then
							entityLibrary.character.HumanoidRootPart.CFrame += Vector3.new(0,JumpBoostTable.Sliders.CFrame,0)
							SendWarning()
							JumpBoostDisable()
						else
							repeat task.wait()
								entityLibrary.character.HumanoidRootPart.CFrame += Vector3.new(0,JumpBoostTable.Sliders.CFrame,0)
								SendWarning3()
								task.wait(JumpBoostTable.Sliders.CFrame2)
							until not JumpBoost.Enabled or not JumpBoostLoop.Enabled or not entityLibrary.isAlive or JumpBoostMode.Value ~= "CFrame"
						end
					else
						SendWarning2()
						JumpBoostDisable()
					end
				elseif JumpBoostMode.Value == "Tween" then
					if entityLibrary.isAlive then
						if not JumpBoostLoop.Enabled then
							tweenService:Create(entityLibrary.character.HumanoidRootPart,TweenInfo.new(JumpBoostTable.Sliders.Tween2),{
								CFrame = entityLibrary.character.HumanoidRootPart.CFrame + Vector3.new(0,JumpBoostTable.Sliders.Tween,0)
							}):Play()
							SendWarning()
							JumpBoostDisable()
						else
							repeat task.wait()
								tweenService:Create(entityLibrary.character.HumanoidRootPart,TweenInfo.new(JumpBoostTable.Sliders.Tween2),{
									CFrame = entityLibrary.character.HumanoidRootPart.CFrame + Vector3.new(0,JumpBoostTable.Sliders.Tween,0)
								}):Play()
								SendWarning3()
								task.wait(JumpBoostTable.Sliders.Tween3)
							until not JumpBoost.Enabled or not JumpBoostLoop.Enabled or not entityLibrary.isAlive or JumpBoostMode.Value ~= "Tween"
						end
					else
						if JumpBoostNotify.Enabled and JumpBoostNotifyD.Enabled then
							warningNotification(JumpBoostTable.Messages.Title,JumpBoostTable.Messages.Context2,JumpBoostTable.Sliders.Duration)
						end
						JumpBoostDisable()
					end
				end
			end)
		elseif EnableBoost and not getgenv().JumpBoostEnabled then
			if JumpBoostNotify.Enabled and JumpBoostNotifyS.Enabled then
				warningNotification(JumpBoostTable.Messages.Title,JumpBoostTable.Messages.Context3,JumpBoostTable.Sliders.Duration)
			end
			JumpBoostDisable()
		end
	end,
    Default = JumpBoostSettings.Inside.Default,
	ExtraText = function()
		if JumpBoostArray.Enabled then
			return JumpBoostMode.Value
		end
	end
}, "JumpBoost")
JumpBoostMode = Section6:Dropdown({
	Name = "Mode",
	List = {
		"Velocity",
		"CFrame",
		"Tween"
	},
	HoverText = "Mode to boost you",
	Function = function() end,
}, "JumpBoostMode")
JumpBoostVelocity = Section6:Slider({
	Name = "Velocity Boost",
	Min = 1,
	Max = 35,
	HoverText = "Velocity boost amount",
	Function = function() end,
	Default = 35
}, "JumpBoostVelocity")
JumpBoostCFrame = Section6:Slider({
	Name = "CFrame Boost",
	Min = 1,
	Max = 35,
	HoverText = "CFrame boost amount",
	Function = function() end,
	Default = 35
}, "JumpBoostCFrame")
JumpBoostTween = Section6:Slider({
	Name = "Tween Boost",
	Min = 1,
	Max = 500,
	HoverText = "Tween boost amount",
	Function = function() end,
	Default = 500
}, "JumpBoostTween")
JumpBoostVelocity2 = Section6:Slider({
	Name = "Velocity Slowdown",
	Min = 1,
	Max = 10,
	HoverText = "Slowdown between Velocity's loop",
	Function = function() end,
	Default = 5
}, "JumpBoostVelocity2")
JumpBoostCFrame2 = Section6:Slider({
	Name = "CFrame Slowdown",
	Min = 1,
	Max = 10,
	HoverText = "Slowdown between CFrame's loop",
	Function = function() end,
	Default = 1
}, "JumpBoostCFrame2")
JumpBoostTween3 = Section6:Slider({
	Name = "Tween Slowdown",
	Min = 1,
	Max = 50,
	HoverText = "Slowdown between Tween's loop",
	Function = function() end,
	Default = 25
}, "JumpBoostTween3")
JumpBoostTween2 = Section6:Slider({
	Name = "Tween Duration",
	Min = 1,
	Max = 10,
	HoverText = "Tween duration amount",
	Function = function() end,
	Default = 4
}, "JumpBoostTween2")
JumpBoostNotifyDR = Section6:Slider({
	Name = "Notify Duration",
	Min = 1,
	Max = 10,
	HoverText = "Notify duration amount",
	Function = function() end,
	Default = 3
}, "JumpBoostNotifyDR")
JumpBoostLoop = Section6:Toggle({
	Name = "Loop",
	Default = false,
	HoverText = "Loops JumpBoost until it's disabled\nLower Values if you're using it",
	Function = function() end,
}, "JumpBoostLoop")
JumpBoostArray = Section6:Toggle({
	Name = "ArrayList Show",
	Default = true,
	HoverText = "Shows JumpBoost's mode in the ArrayList",
	Function = function() end,
}, "JumpBoostArray")
JumpBoostNotify = Section6:Toggle({
	Name = "Notification",
	Default = true,
	HoverText = "Notifies you when JumpBoost actioned",
	Function = function() end,	
}, "JumpBoostNotify")
JumpBoostNotifyV = Section6:Toggle({
	Name = "Notify Velocity",
	Default = true,
	HoverText = "Notifies you when you got boosted\nwith Velocity mode",
	Function = function() end,
}, "JumpBoostNotifyV")
JumpBoostNotifyC = Section6:Toggle({
	Name = "Notify CFrame",
	Default = true,
	HoverText = "Notifies you when you got boosted\nwith CFrame mode",
	Function = function() end,
}, "JumpBoostNotifyC")
JumpBoostNotifyT = Section6:Toggle({
	Name = "Notify Tween",
	Default = true,
	HoverText = "Notifies you when you got boosted\nwith Tween mode",
	Function = function() end,
}, "JumpBoostNotifyT")
JumpBoostNotifyD = Section6:Toggle({
	Name = "Notify Death",
	Default = true,
	HoverText = "Notifies you when you're dead\nand can't use JumpBoost",
	Function = function() end,
}, "JumpBoostNotifyD")
JumpBoostNotifyL = Section6:Toggle({
	Name = "Notify Loop",
	Default = false,
	HoverText = "Notifies you when you got boosted\nwhile having Loop Toggle on",
	Function = function() end,
}, "JumpBoostNotifyL")
JumpBoostNotifyS = Section6:Toggle({
	Name = "Notify Settings",
	Default = true,
	HoverText = "Notifies you when JumpBoostEnabled is false (disabled)\nand can't use JumpBoost",
	Function = function() end,
}, "JumpBoostNotifyS")

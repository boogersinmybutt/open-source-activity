local __namecall
__namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local Args = {...}
    local Method = getnamecallmethod()

    if Method == "InvokeServer" and self.Name == "ReplicationCheck" then
        return nil
    end

    return __namecall(self, ...)
end)

task.wait()

local Starlight = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Starlight-Interface-Suite/master/Source.lua"))()  
local NebulaIcons = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Nebula-Icon-Library/master/Loader.lua"))()

local Zeiki = {
    ["KillNearestNPC"] = {
        Enabled = false,
        Distance = 15,
    }
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character and Character:WaitForChild("HumanoidRootPart")

local Window = Starlight:CreateWindow({
    Name = "Zeiki Hub",
    Subtitle = "v1.0",
    Icon = 123456789,

    LoadingSettings = {
        Title = "The Best Dragon Soul Script",
        Subtitle = "by zeiki",
    },

    ConfigurationSettings = {
        FolderName = "ZeikiHub"
    },
})

local AutoFarm = Window:CreateTabSection("Auto Farm")

local t1 = AutoFarm:CreateTab({
    Name = "Auto Farm",
    Icon = NebulaIcons:GetIcon('view_in_ar', 'Material'),
    Columns = 2,
}, "INDEX")

local g1 = t1:CreateGroupbox({
    Name = "Blatant",
    Column = 1,
}, "INDEX")

g1:CreateToggle({
    Name = "Kill Nearest NPC",
    CurrentValue = false,
    Style = 2,
    Callback = function(Value)
        Zeiki["KillNearestNPC"].Enabled = Value
    end,
}, "INDEX")

g1:CreateSlider({
    Name = "Nearest Radius",
    Icon = NebulaIcons:GetIcon('bar-chart', 'Lucide'),
    Range = {0,100},
    Increment = 1,
    Callback = function(Value)
        Zeiki["KillNearestNPC"].Distance = Value
    end,
}, "INDEX")

task.spawn(function()
	while task.wait() do
        if not Zeiki["KillNearestNPC"].Enabled then
            continue
        end

		local closest
		local shortest = math.huge

		for index, model in workspace.Main.Live:GetChildren() do
			if model:IsA("Model") and model:FindFirstChild("NPC") and model:FindFirstChild("Head") then
				local dist = (model.Head.Position - HumanoidRootPart.Position).Magnitude
				if dist < shortest then
					shortest = dist
					closest = model
				end
			end
		end

		if closest and shortest <= Zeiki["KillNearestNPC"].Distance then
			local args = {
				{
					Victim = closest,
					VictimPosition = closest:FindFirstChild("HumanoidRootPart") and closest.HumanoidRootPart.Position or closest.Head.Position,
					CurrentHeavy = 1,
					LocalInfo = {
						Flying = false
					},
					CurrentLight = 1,
					CurrentLightCombo = 1,
					Type = "Light",
					AnimSet = "Generic"
				}
			}
			game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("TryAttack"):FireServer(unpack(args))
		end
	end
end)

-- // arcade basketball

--@todo autogreen
--@todo autodribble

local AutoDribble = {}

local Players = game:GetService("Players")
local VIM = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local RootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

local checkRadius = 12
local cooldown = 2

local lastPress = 0
local running = false

--@ didn't fix something here will fix later
function AutoDribble.NearestStealing()
    if not RootPart then return 
        nil 
    end

    local closest, closestDist = nil, math.huge

    for _, Value in next, Players:GetPlayers() do
        if Value ~= LocalPlayer and Value.Character and Value.Character:FindFirstChild("HumanoidRootPart") then
            local stealing = Value:FindFirstChild("Values") and Value.Values:FindFirstChild("Stealing")

            if stealing and stealing.Value == true then
                local dist = (RootPart.Position - Value.Character.HumanoidRootPart.Position).Magnitude

                if dist < closestDist and dist <= checkRadius then
                    closest, closestDist = Value, dist
                end
            end
        end
    end

    return closest
end

--@ basically main functionality
function AutoDribble.Start()
    if running then return end
    running = true

    task.spawn(function()
        while running do
            task.wait()
            local now = tick()
            if now - lastPress >= cooldown then
                local thief = AutoDribble.NearestStealing()
                if thief then
                    VIM:SendKeyEvent(true, Enum.KeyCode.C, false, game)
                    VIM:SendKeyEvent(false, Enum.KeyCode.C, false, game)

                    lastPress = now
                end
            end
        end
    end)
end

function AutoDribble.Stop()
    running = false
end

return AutoDribble

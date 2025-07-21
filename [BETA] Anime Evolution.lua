local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/skyDevO01/rblx_scripts/refs/heads/main/mercury%20ui%20lib"))()
local run = game:GetService("RunService")
local GUI = Mercury:Create{
    Name = "Mercury",
    Size = UDim2.fromOffset(600, 400),
    Theme = Mercury.Themes.Dark,
    Link = "https://github.com/deeeity/mercury-lib"
}

local Tab = GUI:Tab{
	Name = "Main",
	Icon = "rbxassetid://8569322835",
}

local Misc = GUI:Tab{
	Name = "Misc",
	Icon = "rbxassetid://126008350065474",
}

config = {
    killaura = false,
    autocollect = false,
    autoclaim = false,
    autoEquipBest = false
}

Tab:Toggle{
	Name = "Kill Aura",
	StartingState = false,
	Description = nil,
	Callback = function(state)
        config.killaura = state
    end
}

Tab:Toggle{
	Name = "Auto Collect Drops",
	StartingState = false,
	Description = nil,
	Callback = function(state)
        config.autocollect = state
    end
}

Tab:Toggle{
	Name = "Auto Claim Rewards",
	StartingState = false,
	Description = nil,
	Callback = function(state)
        config.autoclaim = state
    end
}

Tab:Toggle{
	Name = "Auto Equip Best (Shadow)",
	StartingState = false,
	Description = nil,
	Callback = function(state)
        config.autoEquipBest = state
    end
}

codes = {
    "SLAYER",
    "DELAY",
    "ORC",
    "FROZEN",
    "50KLIKE",
    "SEASON1",
    "35KLIKE",
    "AURA",
    "MINES",
    "NOAURA",
    "RAID2",
    "FIX03",
    "SHADOW",
    "20000LIKE",
    "DEMON",
    "FIX02",
    "10000LIKE"
}
Misc:Button{
	Name = "Redeem Codes",
	Description = nil,
	Callback = function() 
        for i,v in pairs(codes) do
            local args = {
                "Codes",
                "Redeem",
                v
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Bridge"):FireServer(unpack(args))
            wait(0.2)
        end
	end
}
Misc:Toggle{
    Name = "WalkSpeed",
    StartingState = false,
    Description = nil,
    Callback = function(state) 
        local player = game.Players.LocalPlayer
        local character = player.Character
        local humanoid = character:WaitForChild("Humanoid")
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local walkMultiplier = 1.3

        if state then 
            if not walkSpeedLoop then
                walkSpeedLoop = true
                run.Heartbeat:Connect(function()
                    if not walkSpeedLoop or not character or not humanoid or not rootPart then
                        return
                    end
                    local moveDirection = humanoid.MoveDirection
                    local velocity = moveDirection * walkMultiplier
                    local newCFrame = rootPart.CFrame + velocity
                    rootPart.CFrame = newCFrame
                end)
            end
        else  
            walkSpeedLoop = false 
        end
    end
}

local player = game.Players.LocalPlayer
local maxDistance = 30
local replicatedStorage = game:GetService("ReplicatedStorage")
local bridge = replicatedStorage:WaitForChild("Bridge")
local runService = game:GetService("RunService")

local function isPartInRange(part, position)
    return (part.Position - position).Magnitude <= maxDistance
end

local function checkNearbyEnemies()
    local playerPosition = player.Character and player.Character:WaitForChild("HumanoidRootPart").Position
    local nearbyParts = {}
    local mainFolder = workspace.Server.Enemies.World
    for _, subfolder in pairs(mainFolder:GetChildren()) do
        if subfolder:IsA("Folder") then
            for _, part in pairs(subfolder:GetChildren()) do
                if part:IsA("BasePart") then
                    if isPartInRange(part, playerPosition) then
                        table.insert(nearbyParts, part)
                    end
                end
            end
        end
    end
    for _, part in ipairs(nearbyParts) do
        local args = {
            "Attack",
            "Click",
            {
                Type = "World",
                Enemy = part
            }
        }
        bridge:FireServer(unpack(args))
    end
end

run.Heartbeat:Connect(function()
    if not config.killaura then return end
    checkNearbyEnemies()
end)

run.Heartbeat:Connect(function()
    if not config.autocollect then return end
    for i,v in pairs(workspace.Debris:GetChildren()) do
        if v:IsA("Part") then
            local args = {
        "Drops",
        "Collect",
        v.Name
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Bridge"):FireServer(unpack(args))
        v:Destroy()
        end
    end
end)

run.Heartbeat:Connect(function()
    if not config.autoclaim then return end
    local args = {
	{
		"MinutesPlayed1",
		"MinutesPlayed8",
		"MinutesPlayed3",
		"MinutesPlayed5",
		"MinutesPlayed30",
		"MinutesPlayed45",
		"MinutesPlayed15"
	}
}
game:GetService("ReplicatedStorage"):WaitForChild("EngagementRewards"):WaitForChild("Functions"):WaitForChild("ClaimRewardsRemoteFunction"):InvokeServer(unpack(args))
end)

run.Heartbeat:Connect(function()
    if not config.autoEquipBest then return end
    game:GetService("ReplicatedStorage"):WaitForChild("Bridge"):FireServer("Pets", "Best")
end)

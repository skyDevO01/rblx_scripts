local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/skyDevO01/rblx_scripts/refs/heads/main/elerium-v2-ui-library.lua", true))()
local window = library:AddWindow("@stopHurtsme / Legends Of Speed ⚡ / 3101667897", {
	main_color = Color3.fromRGB(41, 74, 122),
	min_size = Vector2.new(480, 406),
	can_resize = true,
})
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local head = character:WaitForChild("Head")
local run = game:GetService("RunService")

local autoorbs = false
local autohoops = false
local autochests = false
local autorebirth = false

local features = window:AddTab("Farm")
features:Show()
features:AddLabel("Legends Of Speed ⚡ / 3101667897")

local switch = features:AddSwitch("Auto Collect Orbs", function(bool)
	autoorbs = bool
end)
local switch = features:AddSwitch("Auto Collect Chests", function(bool)
	autochests = bool
end)
local switch = features:AddSwitch("Auto Hoops", function(bool)
	autohoops = bool
end)
local switch = features:AddSwitch("Auto Rebirth", function(bool)
	autorebirth = bool
end)

run.Heartbeat:Connect(function()
    if not autoorbs then return end
    for _, v in pairs(workspace.orbFolder:GetDescendants()) do
        if v:IsA("BasePart") and v:FindFirstChildOfClass("TouchTransmitter") then
            firetouchinterest(head, v, 1)
            firetouchinterest(head, v, 0)
        end
    end
end)

run.Heartbeat:Connect(function()
    if not autohoops then return end
    for _, v in pairs(workspace.Hoops:GetDescendants()) do
        if v:IsA("BasePart") and v:FindFirstChildOfClass("TouchTransmitter") then
            firetouchinterest(head, v, 1)
            firetouchinterest(head, v, 0)
        end
    end
end)

run.Heartbeat:Connect(function()
    if not autochests then return end
    for _, v in pairs(workspace.rewardChests:GetDescendants()) do
        if v:IsA("BasePart") and v:FindFirstChildOfClass("TouchTransmitter") then
            firetouchinterest(head, v, 1)
            firetouchinterest(head, v, 0)
        end
    end
end)

run.Heartbeat:Connect(function()
    if not autorebirth then return end
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("rebirthEvent"):FireServer("rebirthRequest")
end)

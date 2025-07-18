local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Untitled Farm Game", "DarkTheme")

local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("---------------------------")
local run = game:GetService("RunService")
local plr = game:GetService("Players").LocalPlayer
local root = plr.Character.HumanoidRootPart

_G.cfg = {
    enabledAutoCollect = false,
    enabledAutoSell = false,
}

local ownedplot = nil

for i = 1, 6 do
    local plot = workspace.Farms["Plot" .. i].OwnerSign.Hitbox.SurfaceGui.Title
    if plot.ContentText == game.Players.LocalPlayer.Name then
        ownedplot = i
    end
end

if ownedplot == nil then
    print("Player does not own any plot!")
    return
end
wait(1)

Section:NewToggle("Auto Collect", "", function(state)
    _G.cfg.enabledAutoCollect = state
end)

Section:NewToggle("Auto Sell", "", function(state)
    _G.cfg.enabledAutoSell = state
end)
_G.egg = "None"
Section:NewDropdown("Eggs Selector", "", {"Chicken", "Pig", "Cow", "Sheep", "Donkey", "Horse", "Llama", "Goat"}, function(currentOption)
    _G.egg = currentOption
end)

Section:NewButton("Buy Selected Egg", "", function()
    local args = {
        [1] = _G.egg
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Buy"):InvokeServer(unpack(args))
end)

Section:NewButton("Rejoin", "", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
end)

task.spawn(function()
    while true do
        wait(0.26)
        if _G.cfg.enabledAutoCollect then
            for penIndex, pen in pairs(workspace.Farms["Plot" .. ownedplot].Pens:GetChildren()) do
                if pen:FindFirstChild("Drops") then
                    for _, v in pairs(pen.Drops:GetChildren()) do
                        local args = {
                            [1] = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Drop"):WaitForChild("CollectDrop"),
                            [2] = v.Name
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Drop"):InvokeServer(unpack(args))
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        wait(0.5)
        if _G.cfg.enabledAutoSell then
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Sell"):InvokeServer()
        end
    end
end)

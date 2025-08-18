local plr = game:GetService("Players").LocalPlayer
local name = plr.Name
local back = plr.Backpack
local char = plr.Character
local hrp = char.HumanoidRootPart
local plrinws
local cast
local shake = ''
local oldcf

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local tweenInfo = TweenInfo.new(
    2,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out
)



local cfg = {
    autocast = false,
    autoshake = false,
    autoreel = false,
    farmpos,
    movemethod = 'Tween'
}

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Fisch", "DarkTheme")

local Tab = Window:NewTab("Farm")
local Section = Tab:NewSection("Farm Tab")

Section:NewDropdown("Island Selector", "select an island to farm", {"Moosewood", "Sunstone Island"}, function(v)
    if v == "Moosewood" then
		cfg.farmpos = Vector3.new(377, 135, 135)
		elseif v == "Sunstone Island" then
		cfg.farmpos = Vector3.new(-838, 133, -1171)
	end
end)

Section:NewDropdown("Move to island Method", "how you want to move to island", {"Instant Tp", "Tween"}, function(v)
    if v == "Instant Tp" then
        cfg.movemethod = 'tp'
    else
        cfg.movemethod = 'tw'
    end
end)

Section:NewButton("Teleport To Selected Island", "tp", function()
    if cfg.movemethod == 'tp' then
        hrp.CFrame = CFrame.new(cfg.farmpos)
    else
        tween(CFrame.new(cfg.farmpos))
    end
end)

Section:NewToggle("Auto Cast", "auto cast toggle", function(v)
	cfg.autocast = v
    if v then
        if cfg.movemethod == 'tp' then
            hrp.CFrame = CFrame.new(cfg.farmpos)
        else
            tween(CFrame.new(cfg.farmpos))
        end
    end
end)

Section:NewToggle("Auto Shake", "auto shake toggle", function(v)
	cfg.autoshake = v
end)

Section:NewToggle("Auto Reel", "auto reel toggle", function(v)
	cfg.autoreel = v
end)

local Tab = Window:NewTab("Shop & Sell")
local Section = Tab:NewSection("Shop & Sell Tab")

Section:NewButton("Sell Held Fish", "sell held fish", function()
    teleporter()
        local args = {
        [1] = {
            ["voice"] = 12,
            ["idle"] = workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Marc Merchant"):WaitForChild("description"):WaitForChild("idle"),
            ["npc"] = workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Marc Merchant")
        }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("Sell"):InvokeServer(unpack(args))
    wait(.5)
    hrp.CFrame = oldcf
end)

Section:NewButton("Sell All", "sell all fish", function()
    teleporter()
    local args = {
        [1] = {
            ["voice"] = 12,
            ["idle"] = workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Marc Merchant"):WaitForChild("description"):WaitForChild("idle"),
            ["npc"] = workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Marc Merchant")
        }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("SellAll"):InvokeServer(unpack(args))
    wait(.5)
    hrp.CFrame = oldcf
end)

local Tab = Window:NewTab("Settings")
local Section = Tab:NewSection("Settings Tab")
Section:NewKeybind("Toggle Ui Keybind", "put something", Enum.KeyCode.RightControl, function()
	Library:ToggleUI()
end)

task.spawn(function()
    while true do
        wait(.5)
        pcall(function()
            if cfg.autocast and shake == '' then
                rodfinder()
                wait(0.25)
                cast:FireServer(math.random(90, 100),1)
            end
        end)
    end
end)

task.spawn(function()
    while true do
        wait(.005)
        pcall(function()
            if cfg.autoshake and shake ~= '' then
                game:GetService("Players").LocalPlayer.PlayerGui.shakeui.safezone.button.shake:FireServer()
            end
        end)
    end
end)

task.spawn(function()
    while true do
        wait(.5)
        pcall(function()
            if cfg.autoreel then
                local truefalse = math.random(0, 1) == 1
                game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("reelfinished "):FireServer(100, truefalse)
            end
        end)
    end
end)

task.spawn(function()
    while true do
        wait(.5)
        shake = ''
        pcall(function()
            if shake == '' then
                shake = game:GetService("Players").LocalPlayer.PlayerGui.shakeui.safezone.button.shake
            end
        end)
    end
end)

function teleporter()
    oldcf = hrp.CFrame
    hrp.CFrame = CFrame.new(471, 159, 225)
end

function rodfinder()
	for i,v in pairs(back:GetChildren()) do
		if v:IsA("Tool") and v.Name:find("Rod") then
			v.Parent = char
		end
	end

	for i,v in pairs(workspace:GetChildren()) do
		if v:IsA("Model") and v.Name == name then
			plrinws = v
		end
	end

	for i,v in pairs(plrinws:GetChildren()) do
		if v:IsA("Tool") and v.Name:find("Rod") then
			cast = v.events.cast
		end
	end
end

function tween(cf)
	if typeof(cf) ~= "CFrame" then
		error("Expected a CFrame value, got " .. typeof(cf))
	end

	local tween = TweenService:Create(rootPart, tweenInfo, {
		CFrame = cf
	})
	tween:Play()
end

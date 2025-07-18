local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()

getgenv().Settings = {
    toggledon = false,
    area = "none",
    targetnpc = "none",
    autoclaim = false,
    autospin = false,
    autoclaimupdategift = false,
    autohatch = false,
    eggtype = "none",
    hatchtype = "single",
    autosummon = false,
    summonmode = "single",
    summontype = "normal",
    isUpsideDown = false,
    originalCFrame = nil,
    backupCFrame = nil,
    unlockedHoverboard = false
}
local gui = Library:create{
    Theme = Library.Themes.Serika
}

gui:Credit{
	Name = "credit @stophurtsme or v3w#9205",
	Description = "Thanks for using my script🙏",
	V3rm = "https://www.youtube.com/@lastwordsb4death/videos",
	Discord = "v3w#9205"
}

local tab = gui:tab{
    Icon = "rbxassetid://106179643399588",
    Name = "Main"
}

local tab2 = gui:tab{
    Icon = "rbxassetid://102050463034971",
    Name = "Eggs & Units"
}

local tab3 = gui:tab{
    Icon = "rbxassetid://126008350065474",
    Name = "Claim"
}

local tab4 = gui:tab{
    Icon = "rbxassetid://120903329963747",
    Name = "Player"
}

local autoFarmRunning = false
local toggle = tab:Toggle{
    Name = "Auto Farm",
    StartingState = false,
    Description = nil,
    Callback = function(state)
        getgenv().Settings.toggledon = state
        local player = game.Players.LocalPlayer
        local char = player.Character
        local rootPart = nil
        if getgenv().Settings.toggledon then
            if char and char:FindFirstChild("HumanoidRootPart") then
                getgenv().Settings.originalCFrame = char.HumanoidRootPart.CFrame
                getgenv().Settings.backupCFrame = char.HumanoidRootPart.CFrame -- Store initial CFrame as backup
                char.HumanoidRootPart.Anchored = true
                game.Players.LocalPlayer:SetAttribute("IN_GROUP", false)
            else
                player.CharacterAdded:Wait()
                getgenv().Settings.originalCFrame = player.Character.HumanoidRootPart.CFrame
                getgenv().Settings.backupCFrame = player.Character.HumanoidRootPart.CFrame -- Store initial CFrame as backup
                player.Character.HumanoidRootPart.Anchored = true
            end
            autoFarmRunning = true
            local Ox5256 = getgenv().Settings.area
            player:SetAttribute("Area", Ox5256)
            getgenv().Settings.cfbfatf = player.Character.HumanoidRootPart.CFrame
        else
            char.HumanoidRootPart.Anchored = true
            if char and char:FindFirstChild("HumanoidRootPart") then
                autoFarmRunning = false
                getgenv().Settings.isUpsideDown = false
                player.Character.HumanoidRootPart.CFrame = getgenv().Settings.backupCFrame
                if getgenv().Settings.originalCFrame then
                    char.HumanoidRootPart.CFrame = getgenv().Settings.originalCFrame
                    wait(0.5)
                    char.HumanoidRootPart.Anchored = false
                    game.Players.LocalPlayer:SetAttribute("IN_GROUP", true)
                end
            end
        end
    end
}

game:GetService("RunService").Heartbeat:Connect(function()
    if autoFarmRunning then
        pcall(function()
            local player = game.Players.LocalPlayer
            local targetNPC = nil
            local orbs = {}
            for _, orb in pairs(game.Workspace:GetChildren()) do
                if orb.Name == "ORB" then
                    table.insert(orbs, orb)
                end
            end
            for _, v in pairs(workspace.Enemies[getgenv().Settings.area]:GetDescendants()) do
                if v.Name == getgenv().Settings.targetnpc then
                    if v:FindFirstChild("HumanoidRootPart") then
                        if v.Humanoid.Health > 0 then
                            targetNPC = v
                            break
                        end
                    end
                end
            end
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.Anchored = true
            end
            if targetNPC then
                game.Players.LocalPlayer:SetAttribute("IN_GROUP", false)
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = targetNPC.HumanoidRootPart.CFrame * CFrame.new(0, 0, -7) * CFrame.Angles(math.rad(0), 330, 0) -- 0, 1.8, -1.3 old not angles
                    char.HumanoidRootPart.Anchored = true
                end
            end
            for _, orb in pairs(orbs) do
                orb.CFrame = player.Character.HumanoidRootPart.CFrame
            end
            for _, orb in pairs(orbs) do
                wait(0.1)
                orb:Destroy()
            end
            if not targetNPC then
                player.Character.HumanoidRootPart.CFrame = getgenv().Settings.backupCFrame
                player.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-1128, 2848, -663))
                char.HumanoidRootPart.Anchored = true
            end
        end)
    end
end)

-- Improved backup CFrame handling
game:GetService("RunService").Heartbeat:Connect(function()
    local player = game.Players.LocalPlayer
    if autoFarmRunning and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
        if getgenv().Settings.originalCFrame and getgenv().Settings.backupCFrame and 
           player.Character.HumanoidRootPart.CFrame ~= getgenv().Settings.originalCFrame and
           player.Character.HumanoidRootPart.CFrame ~= getgenv().Settings.backupCFrame then
            player.Character.HumanoidRootPart.CFrame = getgenv().Settings.backupCFrame
        end
    end
end)

local mobs 
local areasDropdown 

local function extractNumber(areaName)
    return tonumber(areaName:match("%d+")) or math.huge
end

local function updateAreasDropdown()
    local areaNames = {}
    local uniqueAreas = {}

    if workspace:FindFirstChild("Enemies") then
        for _, area in pairs(workspace.Enemies:GetChildren()) do
            if area:IsA("Folder") or area:IsA("Model") then
                if not uniqueAreas[area.Name] then
                    table.insert(areaNames, area.Name)
                    uniqueAreas[area.Name] = true
                end
            end
        end
    end
    table.sort(areaNames, function(a, b)
        return extractNumber(a) < extractNumber(b)
    end)

    local formattedAreas = {}
    for _, name in ipairs(areaNames) do
        table.insert(formattedAreas, {name, name})
    end

    if areasDropdown then
        areasDropdown:Clear()
        wait(0.7)
        areasDropdown:AddItems(formattedAreas)
    end
end

local function updateMobsDropdown(area)
    local npcNames = {}
    local uniqueNPCs = {}

    if workspace.Enemies:FindFirstChild(area) then
        for _, npc in pairs(workspace.Enemies[area]:GetChildren()) do
            if npc:IsA("Model") and npc:FindFirstChild("Humanoid") then
                if not uniqueNPCs[npc.Name] then
                    table.insert(npcNames, npc.Name)
                    uniqueNPCs[npc.Name] = true
                end
            end
        end
    end

    table.sort(npcNames)

    local formattedNPCs = {}
    for _, name in ipairs(npcNames) do
        table.insert(formattedNPCs, {name, name})
    end

    if mobs then
        mobs:Clear()
        wait(0.7)
        mobs:AddItems(formattedNPCs)
    end
end

areasDropdown = tab:Dropdown{
    Name = "Areas",
    StartingText = "Select...",
    Description = nil,
    Items = {}, -- เริ่มต้นว่างเปล่า
    Callback = function(v) 
        getgenv().Settings.area = v
        game.Players.LocalPlayer:SetAttribute("Area", v)
        wait(0.5)
        updateMobsDropdown(v)
    end
} 

updateAreasDropdown()

mobs = tab:Dropdown{
    Name = "Mobs",
    StartingText = "Select...",
    Description = nil,
    Items = {}, -- เริ่มต้นว่างเปล่า
    Callback = function(v) 
        getgenv().Settings.targetnpc = v
    end
}

--[[tab:Button{
    Name = "debug areas selection",
    Description = nil,
    Callback = function() 
        print(getgenv().Settings.area)
    end
}

tab:Button{
    Name = "debug currentAttributeArea selection",
    Description = nil,
    Callback = function() 
        print(currentAttributeArea)
    end
}--]]

tab2:Toggle{
    Name = "Auto Summon",
    StartingState = false,
    Description = nil,
    Callback = function(v)
        getgenv().Settings.autosummon = v
        if getgenv().Settings.autosummon then
            -- Start the auto hatch process
            while getgenv().Settings.autosummon do
                wait()  -- Adding a half-second wait to reduce spamming and resource usage
                local args = {
                    [1] = getgenv().Settings.summontype,
                    [2] = tonumber(getgenv().Settings.summonmode)  -- Ensuring summon mode is a number
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CRATE_SUMMON"):InvokeServer(unpack(args))
            end
        end
    end
}

local areas = tab2:Dropdown{
    Name = "Summon Type",
    StartingText = "Select...",
    Description = nil,
    Items = {
        {"Standard Banner", "Summon"},
        {"Premium Banner", "Summon2"}
    },
    Callback = function(v) 
        getgenv().Settings.summontype = v
    end
}

local areas = tab2:Dropdown{
    Name = "Summon Modes",
    StartingText = "Select...",
    Description = nil,
    Items = {
        {"1", "1"},  -- "1" -> Summon 1
        {"3", "2"},  -- "2" -> Summon 3
        {"10", "3"}, -- "3" -> Summon 10
    },
    Callback = function(v) 
        getgenv().Settings.summonmode = v
    end
}

tab2:Toggle{
    Name = "Auto Hatch",
    StartingState = false,
    Description = nil,
    Callback = function(v)
        getgenv().Settings.autohatch = v
        if getgenv().Settings.autohatch then
            -- Start the auto hatch process
            while getgenv().Settings.autohatch do
                wait()  -- wait a small amount of time to prevent locking the game
                local args = {
                    [1] = getgenv().Settings.eggtype,
                    [2] = getgenv().Settings.hatchtype
                }
                
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("HatchEgg"):FireServer(unpack(args))
            end
        end
    end
}

local areas = tab2:Dropdown{
    Name = "Egg",
    StartingText = "Select...",
    Description = nil,
    Items = {
        {"1", "AREA 1"},
        {"2", "AREA 2"},
        {"3", "AREA 3"},
        {"4", "AREA 4"},
        {"5", "AREA 5"},
        {"6", "AREA 6"},
        {"7", "AREA 7"},
        {"8", "AREA 8"},
        {"1", "AREA 9"},
        {"10", "AREA 10"},
        {"11", "AREA 11"},
        {"12", "AREA 12"},
        {"13", "AREA 13"},
        {"14", "AREA 14"},
        {"15", "AREA 15"},
        {"16", "AREA 16"},
        {"17", "AREA 17"},
        {"18", "AREA 18"},
        {"19", "AREA 19"},
        {"20", "AREA 20"},
        {"21", "AREA 21"},
        {"22", "AREA 22"},
        {"23", "AREA 23"},
        {"24", "AREA 24"}
    },
    Callback = function(v) 
        getgenv().Settings.eggtype = v
    end
}

local areas = tab2:Dropdown{
    Name = "Hatch Modes",
    StartingText = "Select...",
    Description = nil,
    Items = {
        {"1", "E"},
        {"3", "R"},
        {"Max", "F"}
    },
    Callback = function(v) 
        getgenv().Settings.hatchtype = v
    end
}

tab3:Toggle{
    Name = "Auto Claim Gifts (If available)",
    StartingState = false,
    Description = nil,
    Callback = function(state)
        getgenv().Settings.autoclaim = state
        if getgenv().Settings.autoclaim then
            task.spawn(function()  -- Using task.spawn to avoid blocking the main thread
                while getgenv().Settings.autoclaim do
                    pcall(function()
                        for i = 1, 12 do
                            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CLAIM_REWARD"):FireServer(i)
                        end
                    end)
                    wait(0.1)  -- Adding a small delay to prevent spamming and overloading the server
                end
            end)
        end
    end
}

tab3:Toggle{
    Name = "Auto Spin (If available)",
    StartingState = false,
    Description = nil,
    Callback = function(state)
        getgenv().Settings.autospin = state
        if getgenv().Settings.autospin then
            task.spawn(function()  -- Using task.spawn to avoid blocking the main thread
                while getgenv().Settings.autospin do
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SPIN_WHEEL"):InvokeServer("SpinWheel")
                    end)
                    wait(0.1)  -- Adding a small delay to prevent spamming and overloading the server
                end
            end)
        end
    end
}

tab3:Toggle{
    Name = "Auto Claim Update Gift (If available)",
    StartingState = false,
    Description = nil,
    Callback = function(state)
        getgenv().Settings.autoclaimdailyreward = state
        if getgenv().Settings.autoclaimdailyreward then
            task.spawn(function()  -- Using task.spawn to avoid blocking the main thread
                while getgenv().Settings.autoclaimdailyreward do
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("FREE_GIFTS"):FireServer("Update 8 Gift")
                    end)
                    wait(0.1)  -- Adding a small delay to prevent spamming and overloading the server
                end
            end)
        end
    end
}

tab3:Toggle{
    Name = "Auto Claim Daily Reward(If available)",
    StartingState = false,
    Description = nil,
    Callback = function(state)
        getgenv().Settings.autoclaimupdategift = state
        if getgenv().Settings.autoclaimupdategift then
            task.spawn(function()  -- Using task.spawn to avoid blocking the main thread
                while getgenv().Settings.autoclaimupdategift do
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ChestClaim"):FireServer("DailyReward")
                    end)
                    wait(0.1)  -- Adding a small delay to prevent spamming and overloading the server
                end
            end)
        end
    end
}

tab3:Button{
    Name = "Redeem Codes",
    Description = nil,
    Callback = function()
        local codes = {
            "RELEASE",
            "WELCOME",
            "1KLIKES",
            "6MVISITS",
            "UPDATE8",
            "50KLIKES",
            "5MVISITS",
            "SMITE",
            "40KLIKES",
            "35KLIKES",
            "30KLIKES",
            "4MVISITS",
            "20KLIKES",
            "UPDATE5"
        }
        
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("REDEEM_CODE")
        
        for _, code in ipairs(codes) do
            remote:FireServer(code)  -- Fire each code to redeem it
        end
    end
}

local walkSpeedLoop -- This will hold the loop so we can stop it later

local walkSpeedLoop -- This will hold the loop so we can stop it later
local runService = game:GetService("RunService")

tab4:Toggle{
    Name = "WalkSpeed",
    StartingState = false,
    Description = nil,
    Callback = function(state) 
        local player = game.Players.LocalPlayer
        local character = player.Character
        local humanoid = character:WaitForChild("Humanoid")
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local walkMultiplier = 1  -- Slower speed multiplier

        if state then  -- WalkSpeed is on
            if not walkSpeedLoop then
                walkSpeedLoop = true
                -- Use Heartbeat to update continuously without using wait()
                runService.Heartbeat:Connect(function()
                    if not walkSpeedLoop or not character or not humanoid or not rootPart then
                        return  -- Exit the function if the loop should stop or the character is invalid
                    end

                    local moveDirection = humanoid.MoveDirection
                    local velocity = moveDirection * walkMultiplier
                    local newCFrame = rootPart.CFrame + velocity
                    rootPart.CFrame = newCFrame
                end)
            end
        else  -- WalkSpeed is off
            walkSpeedLoop = false  -- Stop the loop
        end
    end
}

tab4:Button{
    Name = "Unlock Hoverboard",
    Description = nil,
    Callback = function() 
        getgenv().Settings.unlockedHoverboard = true
        game.Players.LocalPlayer:SetAttribute("IN_GROUP", true)
    end
}

tab4:Button{
    Name = "Reset",
    Description = nil,
    Callback = function() 
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
    end
}

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = humanoid.RootPart
local originalJumping = humanoid.Jumping
local originalFreeFalling = humanoid.FreeFalling
local function disableAnimations()
    humanoid.Jumping:Connect(function() return false end)
    humanoid.FreeFalling:Connect(function() return false end)
end
while getgenv().Settings.isUpsideDown do
    if character and character.Parent then
        rootPart.CFrame = rootPart.CFrame * CFrame.Angles(math.pi, 0, 0)
    else
        break
    end
    wait(0.1)
end

while true do
    wait(0.1) do
        local player = game.Players.LocalPlayer
        local Ox5256 = getgenv().Settings.area
        player:SetAttribute("Area", Ox5256)
    end
end

--[[local currentarea;
while true do
    currentarea = getgenv().Settings.area
    wait(0.1)
    local ll = getgenv().Settings.area
    if ll ~= currentarea then
        if getgenv().Settings.area == "AREA 1" then
            getgenv().Settings.originalCFrame = -365, 265, -97
            mobs:Clear()
            wait(0.5)
            mobs:AddItems({
                {"Prisoner", "Prisoner"},
                {"Criminal", "Criminal"},
                {"Intruder", "Intruder"},
                {"Thief(must have vip gamepass)", "Thief"}
            })
        elseif getgenv().Settings.area == "AREA 2" then
            mobs:Clear()
            wait(0.5)
            mobs:AddItems({
                {"Bandit", "Bandit"},
                {"Thug", "Thug"},
                {"Brigand", "Brigand"}
            })
        elseif getgenv().Settings.area == "AREA 3" then
            mobs:Clear()
            wait(0.5)
            mobs:AddItems({
                {"Inferno Guardian", "Inferno Guardian"},
                {"Violet Ember", "Violet Ember"},
                {"Crystal Blaze", "Crystal Blaze"}
            })
        end
    end
end--]]

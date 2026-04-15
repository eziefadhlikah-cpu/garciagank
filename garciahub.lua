--[[
╔══════════════════════════════════════════════════════════════════╗
║                    GARCIA-HUB DELTA EDITION                      ║
║                  PREMIUM FOR ANDROID / DELTA                      ║
║               INDONESIA DRIVING EXPERIENCE (IDEX)                 ║
║                         V8.0 - LITE-PRO                           ║
║                   [ FULL FITUR | NO BUG | RINGAN ]                ║
╚══════════════════════════════════════════════════════════════════╝
--]]

-- ============================================================================
-- INIT - COMPATIBLE WITH DELTA / ANDROID
-- ============================================================================
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local lighting = game:GetService("Lighting")
local workspace = game:GetService("Workspace")

-- Variables
local isRunning = true
local guiVisible = true

-- Features State (disimpan agar tidak hilang pindah tab)
local features = {
    -- Money
    instantMoney = false,
    moneyValue = 50000,
    autoCollect = false,
    collectRadius = 50,
    moneyGlitch = false,
    glitchAmount = 999999,
    
    -- Driving (WASD)
    autoDrive = false,
    driveSpeed = 80,
    teleportCP = false,
    
    -- Movement
    speedHack = false,
    speedValue = 120,
    flyMode = false,
    flySpeed = 70,
    noclip = false,
    jumpBoost = false,
    jumpValue = 300,
    infiniteStamina = false,
    
    -- Protection
    godMode = false,
    invisible = false,
    hideName = false,
    antiKick = false,
    autoRespawn = false,
    
    -- Troll
    crashOthers = false,
    freezePlayers = false,
    freezeRadius = 100,
    pushPlayers = false,
    pushForce = 10000,
    blindPlayers = false,
    blindRadius = 60,
    explodeOthers = false,
    explodeRadius = 35,
    stealMoney = false,
    stealAmount = 50000,
    kickOthers = false,
    spamChat = false,
    
    -- Visual
    esp = false,
    rainbowCar = false,
    alwaysDay = false,
    fullBright = false,
    
    -- Exploit
    unlockPass = false,
    serverLag = false,
    lagIntensity = 5
}

-- ============================================================================
-- DRIVING KEYS (WASD) - Manual simulation for Delta
-- ============================================================================
local driveKeys = {w = false, a = false, s = false, d = false}

local function pressKey(key)
    if not driveKeys[key] then
        driveKeys[key] = true
        -- Simulasi key press via context action service (compatible)
        pcall(function()
            game:GetService("ContextActionService"):SetCore("Key"..string.upper(key), true)
        end)
    end
end

local function releaseKey(key)
    if driveKeys[key] then
        driveKeys[key] = false
        pcall(function()
            game:GetService("ContextActionService"):SetCore("Key"..string.upper(key), false)
        end)
    end
end

local function releaseAllKeys()
    for k,_ in pairs(driveKeys) do releaseKey(k) end
end

-- ============================================================================
-- AUTO DRIVE WASD (Intelligent)
-- ============================================================================
spawn(function()
    local checkpoints = {}
    local function refreshCP()
        checkpoints = {}
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (string.find(string.lower(obj.Name), "checkpoint") or string.find(string.lower(obj.Name), "waypoint") or string.find(string.lower(obj.Name), "node")) then
                table.insert(checkpoints, obj)
            end
        end
    end
    refreshCP()
    
    while isRunning do
        wait(0.05)
        if not features.autoDrive then
            releaseAllKeys()
            wait(0.5)
            continue
        end
        if not character or not character:FindFirstChild("HumanoidRootPart") then wait(1) continue end
        
        local currentPos = character.HumanoidRootPart.Position
        local target = nil
        local targetDist = math.huge
        
        for _, cp in ipairs(checkpoints) do
            local dist = (cp.Position - currentPos).Magnitude
            if dist < targetDist and dist > 3 then
                targetDist = dist
                target = cp
            end
        end
        
        if not target then refreshCP() continue end
        
        local direction = (target.Position - currentPos).Unit
        local forward = character.HumanoidRootPart.CFrame.LookVector
        local right = character.HumanoidRootPart.CFrame.RightVector
        local dotF = forward:Dot(direction)
        local dotR = right:Dot(direction)
        
        if dotF > 0.2 then pressKey("w") else releaseKey("w") end
        if dotF < -0.2 then pressKey("s") else releaseKey("s") end
        if dotR > 0.15 then pressKey("d") else releaseKey("d") end
        if dotR < -0.15 then pressKey("a") else releaseKey("a") end
    end
end)

-- ============================================================================
-- INSTANT MONEY (Drive-based)
-- ============================================================================
spawn(function()
    local lastPos = Vector3.new()
    local totalDist = 0
    
    while isRunning do
        wait(0.1)
        if features.instantMoney and character and character:FindFirstChild("HumanoidRootPart") then
            local currentPos = character.HumanoidRootPart.Position
            if lastPos ~= Vector3.new() then
                local dist = (currentPos - lastPos).Magnitude
                if dist > 0.1 then
                    totalDist = totalDist + dist
                    if totalDist >= 5 then
                        local add = features.moneyValue
                        pcall(function()
                            if player:FindFirstChild("leaderstats") then
                                for _, v in ipairs(player.leaderstats:GetChildren()) do
                                    if string.find(string.lower(v.Name), "money") or string.find(string.lower(v.Name), "cash") or string.find(string.lower(v.Name), "uang") then
                                        v.Value = v.Value + add
                                    end
                                end
                            end
                            for _, r in ipairs(replicatedStorage:GetDescendants()) do
                                if r:IsA("RemoteEvent") then
                                    pcall(function() r:FireServer("AddMoney", add) end)
                                    pcall(function() r:FireServer("EarnMoney", add) end)
                                end
                            end
                        end)
                        totalDist = 0
                    end
                end
            end
            lastPos = currentPos
        else
            lastPos = Vector3.new()
        end
    end
end)

-- ============================================================================
-- SPEED HACK
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.1)
        if features.speedHack and humanoid then
            humanoid.WalkSpeed = features.speedValue
        elseif humanoid and not features.speedHack then
            humanoid.WalkSpeed = 16
        end
    end
end)

-- ============================================================================
-- FLY MODE (Simple for Android)
-- ============================================================================
local flyVel = nil
spawn(function()
    while isRunning do
        wait()
        if features.flyMode then
            if not flyVel and character and character:FindFirstChild("HumanoidRootPart") then
                flyVel = Instance.new("BodyVelocity")
                flyVel.MaxForce = Vector3.new(100000, 100000, 100000)
                flyVel.Parent = character.HumanoidRootPart
            end
            if flyVel then
                local move = Vector3.new()
                if userInput:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0, 0, -1) end
                if userInput:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0, 0, 1) end
                if userInput:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1, 0, 0) end
                if userInput:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1, 0, 0) end
                if userInput:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
                if userInput:IsKeyDown(Enum.KeyCode.LeftControl) then move = move + Vector3.new(0, -1, 0) end
                if move.Magnitude > 0 then move = move.Unit end
                local cam = workspace.CurrentCamera
                flyVel.Velocity = (cam.CFrame.LookVector * move.Z + cam.CFrame.RightVector * move.X + cam.CFrame.UpVector * move.Y) * features.flySpeed
                if humanoid then humanoid.PlatformStand = true end
            end
        else
            if flyVel then flyVel:Destroy() end
            if humanoid then humanoid.PlatformStand = false end
            flyVel = nil
        end
    end
end)

-- ============================================================================
-- NOCLIP
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.1)
        if features.noclip and character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        elseif character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- ============================================================================
-- GOD MODE
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.3)
        if features.godMode and humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            humanoid.BreakJointsOnDeath = false
        elseif humanoid then
            humanoid.MaxHealth = 100
            humanoid.BreakJointsOnDeath = true
        end
    end
end)

-- ============================================================================
-- JUMP BOOST
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.5)
        if features.jumpBoost and humanoid then
            humanoid.JumpPower = features.jumpValue
        elseif humanoid and not features.jumpBoost then
            humanoid.JumpPower = 50
        end
    end
end)

-- ============================================================================
-- INFINITE STAMINA
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.3)
        if features.infiniteStamina and humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
        end
    end
end)

-- ============================================================================
-- INVISIBLE
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.2)
        if features.invisible and character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                end
            end
        end
    end
end)

-- ============================================================================
-- HIDE NAME
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.5)
        if features.hideName then
            pcall(function()
                player.DisplayName = "⠀"
                player.Name = "⠀"
            end)
        end
    end
end)

-- ============================================================================
-- MONEY GLITCH
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.1)
        if features.moneyGlitch then
            pcall(function()
                for _, r in ipairs(replicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") then
                        r:FireServer("AddMoney", features.glitchAmount)
                    end
                end
                if player:FindFirstChild("leaderstats") then
                    for _, v in ipairs(player.leaderstats:GetChildren()) do
                        if string.find(string.lower(v.Name), "money") then
                            v.Value = v.Value + features.glitchAmount
                        end
                    end
                end
            end)
        end
    end
end)

-- ============================================================================
-- CRASH OTHERS
-- ============================================================================
spawn(function()
    while isRunning do
        wait(3)
        if features.crashOthers then
            for _, plr in ipairs(players:GetPlayers()) do
                if plr ~= player then
                    pcall(function()
                        for i = 1, 100 do
                            local r = Instance.new("RemoteEvent")
                            r.Name = "Crash_" .. i
                            r.Parent = replicatedStorage
                            r:FireClient(plr)
                            game:GetService("Debris"):AddItem(r, 0.01)
                        end
                    end)
                end
            end
        end
    end
end)

-- ============================================================================
-- FREEZE PLAYERS
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.5)
        if features.freezePlayers then
            for _, plr in ipairs(players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and character and character:FindFirstChild("HumanoidRootPart") then
                    local dist = (plr.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                    if dist <= features.freezeRadius then
                        plr.Character.Humanoid.WalkSpeed = 0
                        plr.Character.Humanoid.JumpPower = 0
                    else
                        plr.Character.Humanoid.WalkSpeed = 16
                    end
                end
            end
        end
    end
end)

-- ============================================================================
-- PUSH PLAYERS
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.2)
        if features.pushPlayers and character and character:FindFirstChild("HumanoidRootPart") then
            for _, plr in ipairs(players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dir = (plr.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Unit
                    plr.Character.HumanoidRootPart.Velocity = dir * features.pushForce
                end
            end
        end
    end
end)

-- ============================================================================
-- BLIND PLAYERS
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.5)
        if features.blindPlayers then
            for _, plr in ipairs(players:GetPlayers()) do
                if plr ~= player and character and character:FindFirstChild("HumanoidRootPart") then
                    local dist = (plr.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                    if dist <= features.blindRadius then
                        pcall(function()
                            local blind = plr.PlayerGui:FindFirstChild("BlindEffect")
                            if not blind then
                                blind = Instance.new("Frame")
                                blind.Name = "BlindEffect"
                                blind.Size = UDim2.new(1, 0, 1, 0)
                                blind.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                                blind.BackgroundTransparency = 0.7
                                blind.Parent = plr.PlayerGui
                                game:GetService("Debris"):AddItem(blind, 2)
                            end
                        end)
                    end
                end
            end
        end
    end
end)

-- ============================================================================
-- EXPLODE OTHERS
-- ============================================================================
spawn(function()
    while isRunning do
        wait(1)
        if features.explodeOthers then
            for _, plr in ipairs(players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and character and character:FindFirstChild("HumanoidRootPart") then
                    local dist = (plr.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                    if dist <= features.explodeRadius then
                        pcall(function()
                            local exp = Instance.new("Explosion")
                            exp.BlastRadius = 15
                            exp.BlastPressure = 1000000
                            exp.Position = plr.Character.HumanoidRootPart.Position
                            exp.Parent = workspace
                        end)
                    end
                end
            end
        end
    end
end)

-- ============================================================================
-- STEAL MONEY
-- ============================================================================
spawn(function()
    while isRunning do
        wait(1)
        if features.stealMoney then
            for _, plr in ipairs(players:GetPlayers()) do
                if plr ~= player and plr:FindFirstChild("leaderstats") then
                    for _, stat in ipairs(plr.leaderstats:GetChildren()) do
                        if string.find(string.lower(stat.Name), "money") and stat.Value > 0 then
                            local steal = math.min(features.stealAmount, stat.Value)
                            stat.Value = stat.Value - steal
                            if player:FindFirstChild("leaderstats") then
                                for _, myStat in ipairs(player.leaderstats:GetChildren()) do
                                    if string.find(string.lower(myStat.Name), "money") then
                                        myStat.Value = myStat.Value + steal
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ============================================================================
-- KICK OTHERS
-- ============================================================================
spawn(function()
    while isRunning do
        wait(5)
        if features.kickOthers then
            for _, plr in ipairs(players:GetPlayers()) do
                if plr ~= player then
                    pcall(function()
                        plr:Kick("🔥 Kicked by GARCIA-HUB PREMIUM 🔥")
                    end)
                end
            end
        end
    end
end)

-- ============================================================================
-- SPAM CHAT
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.5)
        if features.spamChat then
            pcall(function()
                local chat = replicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
                if chat then
                    local sayMsg = chat:FindFirstChild("SayMessageRequest")
                    if sayMsg then
                        sayMsg:FireServer("🔥 GARCIA-HUB PREMIUM | IDEX ELITE 🔥", "All")
                    end
                end
            end)
        end
    end
end)

-- ============================================================================
-- TELEPORT TO CHECKPOINTS
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.5)
        if features.teleportCP then
            local cps = {}
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (string.find(string.lower(obj.Name), "checkpoint") or string.find(string.lower(obj.Name), "waypoint")) then
                    table.insert(cps, obj)
                end
            end
            for _, cp in ipairs(cps) do
                if character and character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = cp.CFrame
                    wait(0.2)
                end
            end
        end
    end
end)

-- ============================================================================
-- AUTO COLLECT
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.2)
        if features.autoCollect and character and character:FindFirstChild("HumanoidRootPart") then
            for _, item in ipairs(workspace:GetDescendants()) do
                if item:IsA("BasePart") and (string.find(string.lower(item.Name), "coin") or string.find(string.lower(item.Name), "money") or string.find(string.lower(item.Name), "item")) then
                    local dist = (item.Position - character.HumanoidRootPart.Position).Magnitude
                    if dist <= features.collectRadius then
                        character.HumanoidRootPart.CFrame = item.CFrame
                        wait(0.05)
                    end
                end
            end
        end
    end
end)

-- ============================================================================
-- RAINBOW CAR
-- ============================================================================
local rainbowHue = 0
spawn(function()
    while isRunning do
        wait(0.1)
        if features.rainbowCar then
            local vehicle = character:FindFirstChildOfClass("VehicleSeat")
            if vehicle and vehicle.Parent then
                rainbowHue = (rainbowHue + 0.02) % 1
                local color = Color3.fromHSV(rainbowHue, 1, 1)
                for _, part in ipairs(vehicle.Parent:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Color = color
                    end
                end
            end
        end
    end
end)

-- ============================================================================
-- ALWAYS DAY & FULL BRIGHT
-- ============================================================================
spawn(function()
    while isRunning do
        wait(1)
        if features.alwaysDay then
            lighting.ClockTime = 14
        end
        if features.fullBright then
            lighting.Brightness = 2
            lighting.ExposureCompensation = 2
        else
            lighting.Brightness = 1
            lighting.ExposureCompensation = 0
        end
    end
end)

-- ============================================================================
-- UNLOCK GAMEPASS
-- ============================================================================
spawn(function()
    while isRunning do
        wait(3)
        if features.unlockPass then
            local passes = {"VIP", "PREMIUM", "GOLD", "DIAMOND", "SPEED", "MONEY", "UNLIMITED"}
            for _, p in ipairs(passes) do
                pcall(function()
                    local bv = Instance.new("BoolValue")
                    bv.Name = p
                    bv.Value = true
                    bv.Parent = player
                end)
            end
        end
    end
end)

-- ============================================================================
-- SERVER LAG
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.5)
        if features.serverLag then
            for i = 1, features.lagIntensity * 20 do
                local part = Instance.new("Part")
                part.Size = Vector3.new(5, 5, 5)
                part.Position = Vector3.new(math.random(-5000, 5000), math.random(-500, 500), math.random(-5000, 5000))
                part.Anchored = true
                part.Transparency = 1
                part.Parent = workspace
                game:GetService("Debris"):AddItem(part, 0.05)
            end
        end
    end
end)

-- ============================================================================
-- ANTI KICK (Bypass)
-- ============================================================================
pcall(function()
    local oldKick = player.Kick
    player.Kick = function() end
end)

-- ============================================================================
-- GUI PREMIUM (Ringan untuk Android/Delta)
-- ============================================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GarciaHubDelta"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 550)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 100)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
header.BackgroundTransparency = 0.2
header.BorderSizePixel = 0
header.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ GARCIA-HUB DELTA ⚡"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = header

local subLabel = Instance.new("TextLabel")
subLabel.Size = UDim2.new(1, 0, 0, 20)
subLabel.Position = UDim2.new(0, 0, 1, -22)
subLabel.BackgroundTransparency = 1
subLabel.Text = "PREMIUM | IDEX | ANDROID/PC"
subLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
subLabel.TextSize = 11
subLabel.Font = Enum.Font.Gotham
subLabel.Parent = header

-- Stats Bar
local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(0.95, 0, 0, 35)
statsFrame.Position = UDim2.new(0.025, 0, 0, 65)
statsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
statsFrame.BorderSizePixel = 1
statsFrame.BorderColor3 = Color3.fromRGB(255, 0, 100)
statsFrame.Parent = mainFrame

local moneyStats = Instance.new("TextLabel")
moneyStats.Size = UDim2.new(0.5, -5, 1, 0)
moneyStats.Position = UDim2.new(0, 5, 0, 0)
moneyStats.BackgroundTransparency = 1
moneyStats.Text = "💰 Loading..."
moneyStats.TextColor3 = Color3.fromRGB(255, 215, 0)
moneyStats.TextSize = 13
moneyStats.Font = Enum.Font.GothamBold
moneyStats.TextXAlignment = Enum.TextXAlignment.Left
moneyStats.Parent = statsFrame

local speedStats = Instance.new("TextLabel")
speedStats.Size = UDim2.new(0.5, -5, 1, 0)
speedStats.Position = UDim2.new(0.5, 0, 0, 0)
speedStats.BackgroundTransparency = 1
speedStats.Text = "⚡ Speed: 16"
speedStats.TextColor3 = Color3.fromRGB(100, 255, 100)
speedStats.TextSize = 13
speedStats.Font = Enum.Font.GothamBold
speedStats.TextXAlignment = Enum.TextXAlignment.Right
speedStats.Parent = statsFrame

-- Update stats
spawn(function()
    while isRunning do
        wait(0.5)
        pcall(function()
            local money = 0
            if player:FindFirstChild("leaderstats") then
                for _, v in ipairs(player.leaderstats:GetChildren()) do
                    if string.find(string.lower(v.Name), "money") then
                        money = v.Value
                        break
                    end
                end
            end
            moneyStats.Text = "💰 $" .. tostring(money)
            if humanoid then
                speedStats.Text = "⚡ Speed: " .. math.floor(humanoid.WalkSpeed)
            end
        end)
    end
end)

-- Tab Buttons (7 kategori)
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 40)
tabFrame.Position = UDim2.new(0, 0, 0, 105)
tabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = mainFrame

local tabs = {"💰", "🚗", "⚡", "🛡️", "👹", "👁️", "💀"}
local tabNames = {"MONEY", "DRIVE", "MOVE", "PROTECT", "TROLL", "VISUAL", "EXPLOIT"}
local currentTab = 1
local tabButtons = {}

local contentScroll = Instance.new("ScrollingFrame")
contentScroll.Size = UDim2.new(1, -20, 1, -155)
contentScroll.Position = UDim2.new(0, 10, 0, 150)
contentScroll.BackgroundTransparency = 1
contentScroll.ScrollBarThickness = 6
contentScroll.CanvasSize = UDim2.new(0, 0, 0, 800)
contentScroll.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Parent = contentScroll
contentLayout.Padding = UDim.new(0, 5)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Function create toggle (simple for Delta)
local function createToggle(text, key, defaultValue)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(50, 50, 80)
    frame.Parent = contentScroll
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(240, 240, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 70, 0, 32)
    btn.Position = UDim2.new(1, -80, 0.5, -16)
    btn.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    btn.Text = defaultValue and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = frame
    
    local state = defaultValue
    if features[key] ~= nil then
        state = features[key]
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        btn.Text = state and "ON" or "OFF"
    end
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        features[key] = state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        btn.Text = state and "ON" or "OFF"
    end)
    
    return frame
end

local function createSlider(text, key, minVal, maxVal, defaultVal, suffix)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 65)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(50, 50, 80)
    frame.Parent = contentScroll
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. defaultVal .. (suffix or "")
    label.TextColor3 = Color3.fromRGB(240, 240, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -30, 0, 5)
    sliderBg.Position = UDim2.new(0, 15, 0, 42)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg
    
    local currentVal = defaultVal
    features[key] = currentVal
    local dragging = false
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    sliderBg.InputEnded:Connect(function()
        dragging = false
    end)
    
    userInput.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = userInput:GetMouseLocation()
            local sliderPos = sliderBg.AbsolutePosition
            local percent = math.clamp((mousePos.X - sliderPos.X) / sliderBg.AbsoluteSize.X, 0, 1)
            currentVal = minVal + (maxVal - minVal) * percent
            currentVal = math.floor(currentVal * 10) / 10
            fill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = text .. ": " .. currentVal .. (suffix or "")
            features[key] = currentVal
        end
    end)
    
    return frame
end

-- Build tabs
local function buildMoneyTab()
    for _, v in pairs(contentScroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    createToggle("💰 Instant Money (Drive Based)", "instantMoney", false)
    createSlider("💰 Money per 5 unit", "moneyValue", 1000, 500000, 50000, "")
    createToggle("📦 Auto Collect Items", "autoCollect", false)
    createSlider("📦 Collect Radius", "collectRadius", 10, 200, 50, "m")
    createToggle("🔓 Infinite Money Glitch", "moneyGlitch", false)
    createSlider("💸 Glitch Amount", "glitchAmount", 10000, 99999999, 999999, "")
end

local function buildDriveTab()
    for _, v in pairs(contentScroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    createToggle("🚗 Auto Drive (WASD)", "autoDrive", false)
    createSlider("🏁 Drive Speed", "driveSpeed", 30, 250, 80, "km/h")
    createToggle("🗺️ Teleport to Checkpoints", "teleportCP", false)
end

local function buildMoveTab()
    for _, v in pairs(contentScroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    createToggle("⚡ Speed Hack", "speedHack", false)
    createSlider("🏃 Speed Value", "speedValue", 16, 350, 120, "")
    createToggle("🕊️ Fly Mode", "flyMode", false)
    createSlider("✈️ Fly Speed", "flySpeed", 30, 200, 70, "")
    createToggle("🔧 Noclip", "noclip", false)
    createToggle("🦘 Jump Boost", "jumpBoost", false)
    createSlider("🦘 Jump Value", "jumpValue", 50, 800, 300, "")
    createToggle("💪 Infinite Stamina", "infiniteStamina", false)
end

local function buildProtectTab()
    for _, v in pairs(contentScroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    createToggle("👑 God Mode", "godMode", false)
    createToggle("👻 Invisible", "invisible", false)
    createToggle("📛 Hide Name", "hideName", false)
    createToggle("🛡️ Anti Kick", "antiKick", false)
    createToggle("💚 Auto Respawn", "autoRespawn", false)
end

local function buildTrollTab()
    for _, v in pairs(contentScroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    createToggle("💥 Crash Others", "crashOthers", false)
    createToggle("❄️ Freeze Players", "freezePlayers", false)
    createSlider("❄️ Freeze Radius", "freezeRadius", 20, 500, 100, "m")
    createToggle("👊 Push Players", "pushPlayers", false)
    createSlider("👊 Push Force", "pushForce", 1000, 50000, 10000, "")
    createToggle("👁️ Blind Players", "blindPlayers", false)
    createSlider("👁️ Blind Radius", "blindRadius", 20, 500, 60, "m")
    createToggle("💣 Explode Others", "explodeOthers", false)
    createSlider("💣 Explode Radius", "explodeRadius", 10, 200, 35, "m")
    createToggle("💰 Steal Money", "stealMoney", false)
    createSlider("💰 Steal Amount", "stealAmount", 1000, 500000, 50000, "")
    createToggle("👢 Kick Others", "kickOthers", false)
    createToggle("📢 Spam Chat", "spamChat", false)
end

local function buildVisualTab()
    for _, v in pairs(contentScroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    createToggle("👁️ Player ESP", "esp", false)
    createToggle("🌈 Rainbow Car", "rainbowCar", false)
    createToggle("☀️ Always Day", "alwaysDay", false)
    createToggle("💡 Full Bright", "fullBright", false)
end

local function buildExploitTab()
    for _, v in pairs(contentScroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    createToggle("🎁 Unlock All Gamepass", "unlockPass", false)
    createToggle("🌡️ Server Lag", "serverLag", false)
    createSlider("🌡️ Lag Intensity", "lagIntensity", 1, 20, 5, "")
end

-- Tab buttons
for i = 1, #tabs do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#tabs, -4, 1, -4)
    btn.Position = UDim2.new((i-1)/#tabs, 2, 0, 2)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
    btn.Text = tabs[i] .. "\n" .. tabNames[i]
    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = tabFrame
    tabButtons[i] = btn
    
    btn.MouseButton1Click:Connect(function()
        currentTab = i
        for j, tb in pairs(tabButtons) do
            tb.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
            tb.TextColor3 = Color3.fromRGB(200, 200, 220)
        end
        btn.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        if i == 1 then buildMoneyTab()
        elseif i == 2 then buildDriveTab()
        elseif i == 3 then buildMoveTab()
        elseif i == 4 then buildProtectTab()
        elseif i == 5 then buildTrollTab()
        elseif i == 6 then buildVisualTab()
        elseif i == 7 then buildExploitTab()
        end
    end)
end

-- Default tab
tabButtons[1].BackgroundColor3 = Color3.fromRGB(255, 0, 100)
tabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)
buildMoneyTab()

-- Hotkey F5
userInput.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.F5 then
        guiVisible = not guiVisible
        screenGui.Enabled = guiVisible
    end
end)

-- ============================================================================
-- ESP (Simple for Delta)
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.3)
        if features.esp then
            for _, plr in ipairs(players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local existing = plr.Character:FindFirstChild("ESP_GUI")
                    if not existing then
                        local bill = Instance.new("BillboardGui")
                        bill.Name = "ESP_GUI"
                        bill.Size = UDim2.new(0, 150, 0, 35)
                        bill.AlwaysOnTop = true
                        bill.Parent = plr.Character.HumanoidRootPart
                        
                        local frame = Instance.new("Frame")
                        frame.Size = UDim2.new(1, 0, 1, 0)
                        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                        frame.BackgroundTransparency = 0.6
                        frame.BorderSizePixel = 1
                        frame.BorderColor3 = Color3.fromRGB(255, 0, 100)
                        frame.Parent = bill
                        
                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = plr.Name .. " ⚡"
                        label.TextColor3 = Color3.fromRGB(255, 100, 200)
                        label.TextScaled = true
                        label.Font = Enum.Font.GothamBold
                        label.Parent = frame
                    end
                end
            end
        else
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name == "ESP_GUI" then
                    obj:Destroy()
                end
            end
        end
    end
end)

-- ============================================================================
-- AUTO RESPAWN
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.5)
        if features.autoRespawn and humanoid and humanoid.Health <= 0 then
            humanoid.Health = humanoid.MaxHealth
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
            end
        end
    end
end)

-- ============================================================================
-- SPLASH SCREEN
-- ============================================================================
print("╔════════════════════════════════════════════════════════════╗")
print("║                                                            ║")
print("║     ██████╗  █████╗ ██████╗  ██████╗██╗ █████╗            ║")
print("║    ██╔════╝ ██╔══██╗██╔══██╗██╔════╝██║██╔══██╗           ║")
print("║    ██║  ███╗███████║██████╔╝██║     ██║███████║           ║")
print("║    ██║   ██║██╔══██║██╔══██╗██║     ██║██╔══██║           ║")
print("║    ╚██████╔╝██║  ██║██║  ██║╚██████╗██║██║  ██║           ║")
print("║     ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝╚═╝  ╚═╝           ║")
print("║                                                            ║")
print("║              GARCIA-HUB DELTA EDITION V8.0                 ║")
print("║         PREMIUM | IDEX | ANDROID/PC COMPATIBLE             ║")
print("║                     PRESS F5 TOGGLE GUI                    ║")
print("║                    LOADED SUCCESSFULLY!                    ║")
print("╚════════════════════════════════════════════════════════════╝")

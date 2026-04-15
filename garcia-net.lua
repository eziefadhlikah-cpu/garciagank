--[[
╔═══════════════════════════════════════════════════════════════════════════╗
║                 GARCIA-HUB v10.0 - FINAL EDITION                          ║
║            [ ANTI-DETECT | ALL IN ONE | READY TO EXECUTE ]                ║
║                     INDONESIA DRIVING EXPERIENCE                          ║
╚═══════════════════════════════════════════════════════════════════════════╝
--]]

-- ============================================================================
-- ANTI-DETECTION BYPASS (OTOMATIS)
-- ============================================================================
local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local userInput = game:GetService("UserInputService")
local virtualInput = game:GetService("VirtualInputManager")
local debris = game:GetService("Debris")

-- Bypass: Matikan fungsi kick
pcall(function()
    local oldKick = player.Kick
    player.Kick = function() end
end)

-- Bypass: Blokir remote anti-cheat
pcall(function()
    for _, r in ipairs(replicatedStorage:GetDescendants()) do
        if r:IsA("RemoteEvent") then
            local name = string.lower(r.Name)
            if name:find("kick") or name:find("ban") or name:find("anti") or name:find("cheat") or name:find("detect") then
                r:Destroy()
            end
        end
    end
end)

-- Bypass: Sembunyikan object mencurigakan
pcall(function()
    local character = player.Character
    if character then
        character.DescendantAdded:Connect(function(d)
            if d:IsA("BodyVelocity") or d:IsA("BodyForce") or d:IsA("BodyGyro") then
                task.wait(0.05)
                d.Parent = nil
                task.wait(0.1)
                d.Parent = character
            end
        end)
    end
end)

-- ============================================================================
-- VARIABLES & FEATURES
-- ============================================================================
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local isRunning = true
local guiVisible = true

local features = {
    autoDrive = false,
    instantMoney = false,
    moneyValue = 100000,
    speedHack = false,
    speedValue = 90,
    flyMode = false,
    flySpeed = 70,
    noclip = false,
    jumpBoost = false,
    jumpValue = 200,
    invisible = false,
    hideName = false,
    unlockVip = false,
    freezePlayers = false,
    freezeRadius = 80,
    pushPlayers = false,
    pushForce = 8000,
    serverLag = false,
    lagIntensity = 5,
    rainbowCar = false,
    esp = false
}

-- ============================================================================
-- AUTO DRIVE (W A S D)
-- ============================================================================
local driveKeys = {w = false, a = false, s = false, d = false}

local function pressKey(key)
    if not driveKeys[key] then
        driveKeys[key] = true
        local k = key == "w" and Enum.KeyCode.W or key == "a" and Enum.KeyCode.A or key == "s" and Enum.KeyCode.S or Enum.KeyCode.D
        pcall(function() virtualInput:SendKeyEvent(true, k, false, game) end)
    end
end

local function releaseKey(key)
    if driveKeys[key] then
        driveKeys[key] = false
        local k = key == "w" and Enum.KeyCode.W or key == "a" and Enum.KeyCode.A or key == "s" and Enum.KeyCode.S or Enum.KeyCode.D
        pcall(function() virtualInput:SendKeyEvent(false, k, false, game) end)
    end
end

local function releaseAll()
    for k in pairs(driveKeys) do releaseKey(k) end
end

local function findTarget()
    local target, minDist = nil, math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = string.lower(obj.Name)
            if name:find("checkpoint") or name:find("waypoint") or name:find("node") or obj.Material == Enum.Material.Asphalt then
                local dist = (obj.Position - character.HumanoidRootPart.Position).Magnitude
                if dist < minDist and dist > 5 then
                    minDist, target = dist, obj
                end
            end
        end
    end
    return target
end

spawn(function()
    while isRunning do
        wait(0.03)
        if not features.autoDrive then releaseAll(); wait(0.5); continue end
        if not character or not character.HumanoidRootPart then wait(1); continue end
        
        local target = findTarget()
        if target then
            local dir = (target.Position - character.HumanoidRootPart.Position).Unit
            local fwd = character.HumanoidRootPart.CFrame.LookVector
            local right = character.HumanoidRootPart.CFrame.RightVector
            local df, dr = fwd:Dot(dir), right:Dot(dir)
            
            if df > 0.15 then pressKey("w") else releaseKey("w") end
            if df < -0.15 then pressKey("s") else releaseKey("s") end
            if dr > 0.1 then pressKey("d"); releaseKey("a")
            elseif dr < -0.1 then pressKey("a"); releaseKey("d")
            else releaseKey("a"); releaseKey("d") end
        else
            pressKey("w")
        end
    end
end)

-- ============================================================================
-- INSTANT MONEY (BERDASARKAN JARAK)
-- ============================================================================
local lastPos = Vector3.new()
local distance = 0

spawn(function()
    while isRunning do
        wait(0.1)
        if features.instantMoney and character and character.HumanoidRootPart then
            local curPos = character.HumanoidRootPart.Position
            if lastPos ~= Vector3.new() then
                local dist = (curPos - lastPos).Magnitude
                if dist > 0.2 and dist < 50 then
                    distance = distance + dist
                    if distance >= 15 then
                        pcall(function()
                            if player.leaderstats then
                                for _, v in ipairs(player.leaderstats:GetChildren()) do
                                    local n = string.lower(v.Name)
                                    if n:find("money") or n:find("cash") or n:find("uang") then
                                        v.Value = v.Value + features.moneyValue
                                    end
                                end
                            end
                            for _, r in ipairs(replicatedStorage:GetDescendants()) do
                                if r:IsA("RemoteEvent") then
                                    r:FireServer("AddMoney", features.moneyValue)
                                end
                            end
                        end)
                        distance = 0
                    end
                end
            end
            lastPos = curPos
        else
            lastPos, distance = Vector3.new(), 0
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
-- FLY MODE
-- ============================================================================
local flyVel = nil
spawn(function()
    while isRunning do
        wait()
        if features.flyMode then
            if not flyVel and character and character.HumanoidRootPart then
                flyVel = Instance.new("BodyVelocity")
                flyVel.MaxForce = Vector3.new(100000, 100000, 100000)
                flyVel.Parent = character.HumanoidRootPart
            end
            if flyVel then
                local move = Vector3.new()
                if userInput:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0,0,-1) end
                if userInput:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0,0,1) end
                if userInput:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1,0,0) end
                if userInput:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1,0,0) end
                if userInput:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
                if userInput:IsKeyDown(Enum.KeyCode.LeftControl) then move = move + Vector3.new(0,-1,0) end
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
            for _, p in ipairs(character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        elseif character then
            for _, p in ipairs(character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
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
-- INVISIBLE
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.2)
        if features.invisible and character then
            for _, p in ipairs(character:GetDescendants()) do
                if p:IsA("BasePart") then p.Transparency = 1 end
            end
        elseif character then
            for _, p in ipairs(character:GetDescendants()) do
                if p:IsA("BasePart") then p.Transparency = 0 end
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
            pcall(function() player.DisplayName = "⠀"; player.Name = "⠀" end)
        else
            pcall(function() player.DisplayName = player.Name end)
        end
    end
end)

-- ============================================================================
-- UNLOCK VIP
-- ============================================================================
spawn(function()
    while isRunning do
        wait(2)
        if features.unlockVip then
            pcall(function()
                local b = Instance.new("BoolValue")
                b.Name = "VIP"; b.Value = true; b.Parent = player
                local f = player:FindFirstChild("Gamepasses") or Instance.new("Folder")
                f.Name = "Gamepasses"; f.Parent = player
                local v = Instance.new("BoolValue")
                v.Name = "VIP_Pass"; v.Value = true; v.Parent = f
            end)
        end
    end
end)

-- ============================================================================
-- FREEZE PLAYERS
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.5)
        if features.freezePlayers and character and character.HumanoidRootPart then
            for _, p in ipairs(players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") then
                    local dist = (p.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                    if dist <= features.freezeRadius then
                        p.Character.Humanoid.WalkSpeed = 0
                        p.Character.Humanoid.JumpPower = 0
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
        if features.pushPlayers and character and character.HumanoidRootPart then
            for _, p in ipairs(players:GetPlayers()) do
                if p ~= player and p.Character and p.Character.HumanoidRootPart then
                    local dir = (p.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Unit
                    p.Character.HumanoidRootPart.Velocity = dir * features.pushForce
                end
            end
        end
    end
end)

-- ============================================================================
-- SERVER LAG (GANAS)
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.3)
        if features.serverLag then
            for i = 1, features.lagIntensity * 30 do
                local p = Instance.new("Part")
                p.Size = Vector3.new(5,5,5)
                p.Position = Vector3.new(math.random(-5000,5000), math.random(-500,500), math.random(-5000,5000))
                p.Anchored = true
                p.Transparency = 1
                p.CanCollide = false
                p.Parent = workspace
                debris:AddItem(p, 0.1)
            end
            for i = 1, features.lagIntensity * 5 do
                pcall(function()
                    for _, r in ipairs(replicatedStorage:GetDescendants()) do
                        if r:IsA("RemoteEvent") then r:FireServer("lag_" .. i) end
                    end
                end)
            end
        end
    end
end)

-- ============================================================================
-- RAINBOW CAR
-- ============================================================================
local hue = 0
spawn(function()
    while isRunning do
        wait(0.1)
        if features.rainbowCar then
            local vehicle = character:FindFirstChildOfClass("VehicleSeat")
            if vehicle and vehicle.Parent then
                hue = (hue + 0.02) % 1
                for _, p in ipairs(vehicle.Parent:GetDescendants()) do
                    if p:IsA("BasePart") then p.Color = Color3.fromHSV(hue, 1, 1) end
                end
            end
        end
    end
end)

-- ============================================================================
-- ESP
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.3)
        if features.esp then
            for _, p in ipairs(players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if not p.Character:FindFirstChild("ESP_GUI") then
                        local bill = Instance.new("BillboardGui")
                        bill.Name = "ESP_GUI"
                        bill.Size = UDim2.new(0,150,0,35)
                        bill.AlwaysOnTop = true
                        bill.Parent = p.Character.HumanoidRootPart
                        local f = Instance.new("Frame")
                        f.Size = UDim2.new(1,0,1,0)
                        f.BackgroundColor3 = Color3.fromRGB(0,0,0)
                        f.BackgroundTransparency = 0.5
                        f.BorderSizePixel = 1
                        f.BorderColor3 = Color3.fromRGB(255,50,150)
                        f.Parent = bill
                        local l = Instance.new("TextLabel")
                        l.Size = UDim2.new(1,0,1,0)
                        l.BackgroundTransparency = 1
                        l.Text = p.Name .. " 🔥"
                        l.TextColor3 = Color3.fromRGB(255,100,200)
                        l.TextScaled = true
                        l.Font = Enum.Font.GothamBold
                        l.Parent = f
                    end
                end
            end
        else
            for _, o in ipairs(workspace:GetDescendants()) do
                if o.Name == "ESP_GUI" then o:Destroy() end
            end
        end
    end
end)

-- ============================================================================
-- PREMIUM GUI (SEDERHANA, RINGAN, NO BUG)
-- ============================================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GarciaHub"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 380, 0, 520)
main.Position = UDim2.new(0.5, -190, 0.5, -260)
main.BackgroundColor3 = Color3.fromRGB(8,8,18)
main.BackgroundTransparency = 0.08
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(255,50,150)
main.Active = true
main.Draggable = true
main.Parent = screenGui

local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,55)
header.BackgroundColor3 = Color3.fromRGB(255,50,150)
header.BackgroundTransparency = 0.2
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "⚡ GARCIA-HUB v10.0 ⚡"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = header

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1,0,0,18)
sub.Position = UDim2.new(0,0,1,-20)
sub.BackgroundTransparency = 1
sub.Text = "IDEX | ANTI-DETECT | READY"
sub.TextColor3 = Color3.fromRGB(255,255,100)
sub.TextSize = 10
sub.Font = Enum.Font.Gotham
sub.Parent = header

local stats = Instance.new("Frame")
stats.Size = UDim2.new(0.95,0,0,35)
stats.Position = UDim2.new(0.025,0,0,60)
stats.BackgroundColor3 = Color3.fromRGB(15,15,30)
stats.BorderSizePixel = 1
stats.BorderColor3 = Color3.fromRGB(255,50,150)
stats.Parent = main

local moneyStat = Instance.new("TextLabel")
moneyStat.Size = UDim2.new(0.5,-5,1,0)
moneyStat.Position = UDim2.new(0,5,0,0)
moneyStat.BackgroundTransparency = 1
moneyStat.Text = "💰 Loading..."
moneyStat.TextColor3 = Color3.fromRGB(255,215,0)
moneyStat.TextSize = 12
moneyStat.Font = Enum.Font.GothamBold
moneyStat.TextXAlignment = Enum.TextXAlignment.Left
moneyStat.Parent = stats

local speedStat = Instance.new("TextLabel")
speedStat.Size = UDim2.new(0.5,-5,1,0)
speedStat.Position = UDim2.new(0.5,0,0,0)
speedStat.BackgroundTransparency = 1
speedStat.Text = "⚡ Speed: 16"
speedStat.TextColor3 = Color3.fromRGB(100,255,100)
speedStat.TextSize = 12
speedStat.Font = Enum.Font.GothamBold
speedStat.TextXAlignment = Enum.TextXAlignment.Right
speedStat.Parent = stats

spawn(function()
    while isRunning do
        wait(0.5)
        pcall(function()
            local money = 0
            if player.leaderstats then
                for _, v in ipairs(player.leaderstats:GetChildren()) do
                    if string.lower(v.Name):find("money") then money = v.Value break end
                end
            end
            moneyStat.Text = "💰 $" .. tostring(money)
            if humanoid then speedStat.Text = "⚡ Speed: " .. math.floor(humanoid.WalkSpeed) end
        end)
    end
end)

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1,0,0,38)
tabFrame.Position = UDim2.new(0,0,0,100)
tabFrame.BackgroundColor3 = Color3.fromRGB(18,18,35)
tabFrame.Parent = main

local tabs = {"💰","🚗","⚡","🛡️","👹","👁️"}
local tabNames = {"MONEY","DRIVE","MOVE","PROTECT","TROLL","VISUAL"}
local currentTab = 1
local tabBtns = {}

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-20,1,-150)
scroll.Position = UDim2.new(0,10,0,143)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.CanvasSize = UDim2.new(0,0,0,700)
scroll.Parent = main

local layout = Instance.new("UIListLayout")
layout.Parent = scroll
layout.Padding = UDim.new(0,5)

local function toggle(text, key, default)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,-10,0,44)
    f.BackgroundColor3 = Color3.fromRGB(22,22,42)
    f.BorderSizePixel = 1
    f.BorderColor3 = Color3.fromRGB(45,45,70)
    f.Parent = scroll
    
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.65,0,1,0)
    l.Position = UDim2.new(0,10,0,0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(240,240,255)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextSize = 12
    l.Font = Enum.Font.GothamBold
    l.Parent = f
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,65,0,30)
    btn.Position = UDim2.new(1,-75,0.5,-15)
    btn.BackgroundColor3 = default and Color3.fromRGB(0,180,0) or Color3.fromRGB(180,0,0)
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Parent = f
    
    local state = features[key] ~= nil and features[key] or default
    btn.BackgroundColor3 = state and Color3.fromRGB(0,180,0) or Color3.fromRGB(180,0,0)
    btn.Text = state and "ON" or "OFF"
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        features[key] = state
        btn.BackgroundColor3 = state and Color3.fromRGB(0,180,0) or Color3.fromRGB(180,0,0)
        btn.Text = state and "ON" or "OFF"
    end)
end

local function slider(text, key, minv, maxv, default, suffix)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,-10,0,62)
    f.BackgroundColor3 = Color3.fromRGB(22,22,42)
    f.BorderSizePixel = 1
    f.BorderColor3 = Color3.fromRGB(45,45,70)
    f.Parent = scroll
    
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,-20,0,22)
    l.Position = UDim2.new(0,10,0,5)
    l.BackgroundTransparency = 1
    l.Text = text .. ": " .. default .. (suffix or "")
    l.TextColor3 = Color3.fromRGB(240,240,255)
    l.TextSize = 11
    l.Font = Enum.Font.GothamBold
    l.Parent = f
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1,-30,0,5)
    bg.Position = UDim2.new(0,15,0,42)
    bg.BackgroundColor3 = Color3.fromRGB(55,55,85)
    bg.Parent = f
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-minv)/(maxv-minv),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(255,50,150)
    fill.Parent = bg
    
    local val = default
    features[key] = val
    local dragging = false
    
    bg.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    bg.InputEnded:Connect(function() dragging = false end)
    
    userInput.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local mp = userInput:GetMouseLocation()
            local sp = bg.AbsolutePosition
            local p = math.clamp((mp.X - sp.X) / bg.AbsoluteSize.X, 0, 1)
            val = minv + (maxv - minv) * p
            val = math.floor(val * 10) / 10
            fill.Size = UDim2.new(p,0,1,0)
            l.Text = text .. ": " .. val .. (suffix or "")
            features[key] = val
        end
    end)
end

local function buildMoney()
    for _,v in pairs(scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    toggle("💰 Instant Money (Drive Based)", "instantMoney", false)
    slider("💰 Money per 15 unit", "moneyValue", 5000, 500000, 100000, "")
end

local function buildDrive()
    for _,v in pairs(scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    toggle("🚗 Auto Drive (WASD)", "autoDrive", false)
    toggle("⚡ Speed Hack", "speedHack", false)
    slider("🏃 Speed Value", "speedValue", 16, 200, 90, "")
end

local function buildMove()
    for _,v in pairs(scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    toggle("⚡ Speed Hack", "speedHack", false)
    slider("🏃 Speed Value", "speedValue", 16, 200, 90, "")
    toggle("🕊️ Fly Mode (WASD+Space)", "flyMode", false)
    slider("✈️ Fly Speed", "flySpeed", 30, 150, 70, "")
    toggle("🔧 Noclip", "noclip", false)
    toggle("🦘 Jump Boost", "jumpBoost", false)
    slider("🦘 Jump Value", "jumpValue", 50, 500, 200, "")
end

local function buildProtect()
    for _,v in pairs(scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    toggle("👻 Invisible", "invisible", false)
    toggle("📛 Hide Name", "hideName", false)
    toggle("💎 Unlock VIP Gamepass", "unlockVip", false)
end

local function buildTroll()
    for _,v in pairs(scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    toggle("❄️ Freeze Players", "freezePlayers", false)
    slider("❄️ Freeze Radius", "freezeRadius", 20, 200, 80, "m")
    toggle("👊 Push Players", "pushPlayers", false)
    slider("👊 Push Force", "pushForce", 1000, 30000, 8000, "")
    toggle("🌡️ Server Lag", "serverLag", false)
    slider("🌡️ Lag Intensity", "lagIntensity", 1, 15, 5, "")
end

local function buildVisual()
    for _,v in pairs(scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    toggle("👁️ Player ESP", "esp", false)
    toggle("🌈 Rainbow Car", "rainbowCar", false)
end

for i = 1, #tabs do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#tabs, -4, 1, -4)
    btn.Position = UDim2.new((i-1)/#tabs, 2, 0, 2)
    btn.BackgroundColor3 = Color3.fromRGB(28,28,50)
    btn.Text = tabs[i] .. "\n" .. tabNames[i]
    btn.TextColor3 = Color3.fromRGB(200,200,220)
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamBold
    btn.Parent = tabFrame
    tabBtns[i] = btn
    
    btn.MouseButton1Click:Connect(function()
        currentTab = i
        for j, b in pairs(tabBtns) do
            b.BackgroundColor3 = Color3.fromRGB(28,28,50)
            b.TextColor3 = Color3.fromRGB(200,200,220)
        end
        btn.BackgroundColor3 = Color3.fromRGB(255,50,150)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        if i == 1 then buildMoney()
        elseif i == 2 then buildDrive()
        elseif i == 3 then buildMove()
        elseif i == 4 then buildProtect()
        elseif i == 5 then buildTroll()
        elseif i == 6 then buildVisual()
        end
    end)
end

tabBtns[1].BackgroundColor3 = Color3.fromRGB(255,50,150)
tabBtns[1].TextColor3 = Color3.fromRGB(255,255,255)
buildMoney()

userInput.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.F5 then
        guiVisible = not guiVisible
        screenGui.Enabled = guiVisible
    end
end)

print("╔══════════════════════════════════════════════════════════════╗")
print("║            GARCIA-HUB v10.0 - FINAL EDITION                  ║")
print("║         [ ANTI-DETECT | READY TO EXECUTE ]                   ║")
print("║                  PRESS F5 TOGGLE GUI                         ║")
print("╚══════════════════════════════════════════════════════════════╝")

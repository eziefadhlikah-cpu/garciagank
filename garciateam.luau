--[[
╔══════════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                          ║
║     ██████╗  █████╗ ██████╗  ██████╗██╗ █████╗     ██╗  ██╗██╗   ██╗██████╗             ║
║    ██╔════╝ ██╔══██╗██╔══██╗██╔════╝██║██╔══██╗    ██║  ██║██║   ██║██╔══██╗            ║
║    ██║  ███╗███████║██████╔╝██║     ██║███████║    ███████║██║   ██║██████╔╝            ║
║    ██║   ██║██╔══██║██╔══██╗██║     ██║██╔══██║    ██╔══██║██║   ██║██╔══██╗            ║
║    ╚██████╔╝██║  ██║██║  ██║╚██████╗██║██║  ██║    ██║  ██║╚██████╔╝██████╔╝            ║
║     ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝             ║
║                                                                                          ║
║                         ██╗   ██╗██╗████████╗██╗███╗   ███╗ █████╗ ████████╗███████╗    ║
║                         ██║   ██║██║╚══██╔══╝██║████╗ ████║██╔══██╗╚══██╔══╝██╔════╝    ║
║                         ██║   ██║██║   ██║   ██║██╔████╔██║███████║   ██║   █████╗      ║
║                         ╚██╗ ██╔╝██║   ██║   ██║██║╚██╔╝██║██╔══██║   ██║   ██╔══╝      ║
║                          ╚████╔╝ ██║   ██║   ██║██║ ╚═╝ ██║██║  ██║   ██║   ███████╗    ║
║                           ╚═══╝  ╚═╝   ╚═╝   ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝    ║
║                                                                                          ║
║                      GARCIA-HUB v13.0 - ULTIMATE BYPASS                                   ║
║            [ TEMBUS ANTI-CHEAT | AUTO FARM | FORCE MONEY ]                               ║
║                         INDONESIA DRIVING EXPERIENCE                                     ║
║                                                                                          ║
╚══════════════════════════════════════════════════════════════════════════════════════════╝
--]]

-- ============================================================================
-- UNIVERSAL ANTI-CHEAT BYPASS (Dari referensi)
-- ============================================================================
local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local workspace = game:GetService("Workspace")
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local virtualInput = game:GetService("VirtualInputManager")
local lighting = game:GetService("Lighting")
local debris = game:GetService("Debris")
local httpService = game:GetService("HttpService")
local coreGui = game:GetService("CoreGui")

-- ============================================================================
-- 1. PROPERTY SPOOFING (Bypass deteksi WalkSpeed/JumpPower)
-- ============================================================================
local originalWalkSpeed = 16
local originalJumpPower = 50

local function spoofProperties()
    if not player.Character then return end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Hook metamethod untuk mengembalikan nilai asli saat dicek anti-cheat
    local mt = getrawmetatable(humanoid)
    local oldIndex = mt.__index
    setreadonly(mt, false)
    mt.__index = function(self, key)
        if key == "WalkSpeed" and rawget(self, key) ~= originalWalkSpeed then
            return originalWalkSpeed
        elseif key == "JumpPower" and rawget(self, key) ~= originalJumpPower then
            return originalJumpPower
        end
        return oldIndex(self, key)
    end
    setreadonly(mt, true)
end

-- ============================================================================
-- 2. REMOTE EVENT BLOCKING (Blokir remote anti-cheat)
-- ============================================================================
local blockedRemotes = {
    "iac-respond", "AntiCheat", "Detection", "Report", "KickPlayer", 
    "BanPlayer", "LogCheat", "AC-Response", "memer", "Adonis"
}

local function blockAntiCheatRemotes()
    for _, r in ipairs(replicatedStorage:GetDescendants()) do
        if r:IsA("RemoteEvent") or r:IsA("RemoteFunction") then
            for _, blocked in ipairs(blockedRemotes) do
                if string.find(string.lower(r.Name), string.lower(blocked)) then
                    pcall(function()
                        local oldFire = r.FireServer
                        r.FireServer = function() end
                        r:Destroy()
                    end)
                end
            end
        end
    end
end

-- ============================================================================
-- 3. HOOKMETAMETHOD UNTUK HIDE SCRIPT
-- ============================================================================
local function hookMetamethods()
    local oldNewcclosure = newcclosure or function(f) return f end
    
    -- Sembunyikan script dari debug
    pcall(function()
        local debugInfo = debug.getinfo
        debug.getinfo = function(...)
            local ret = {debugInfo(...)}
            if ret and ret.source and string.find(ret.source, "GarciaHub") then
                ret.source = "=[C]"
            end
            return unpack(ret)
        end
    end)
end

-- ============================================================================
-- 4. GETCONNECTIONS DISABLE (Matikan event handler anti-cheat)
-- ============================================================================
local function disableAntiCheatConnections()
    pcall(function()
        for _, v in pairs(getconnections or {}) do
            if v and v.Function then
                local funcStr = string.dump(v.Function)
                if string.find(funcStr, "AntiCheat") or 
                   string.find(funcStr, "Detection") or
                   string.find(funcStr, "WalkSpeed") then
                    v:Disable()
                end
            end
        end
    end)
end

-- ============================================================================
-- 5. GUI DETECTION PREVENTION
-- ============================================================================
local function hideGUIFromDetection()
    pcall(function()
        for _, v in pairs(coreGui:GetChildren()) do
            if v.Name == "GarciaHub" then
                v.Enabled = true
            end
        end
    end)
end

-- ============================================================================
-- 6. FAKE REMOTE HONEYPOT (Umpan untuk anti-cheat)
-- ============================================================================
local function createHoneypot()
    local fakeRemote = Instance.new("RemoteEvent")
    fakeRemote.Name = "HoneyPot_" .. httpService:GenerateGUID(false)
    fakeRemote.Parent = replicatedStorage
    
    fakeRemote.OnServerEvent:Connect(function(plr)
        -- Jika ada yang memicu ini, diamkan saja
    end)
end

-- ============================================================================
-- 7. BYPASS KICK/BAN
-- ============================================================================
local function bypassKick()
    local oldKick = player.Kick
    player.Kick = function() end
    
    local oldTeleport = game:GetService("TeleportService").Teleport
    game:GetService("TeleportService").Teleport = function() end
end

-- ============================================================================
-- 8. SAFER INPUT SIMULATION
-- ============================================================================
local function saferInput(keyCode, isDown)
    pcall(function()
        virtualInput:SendKeyEvent(isDown, keyCode, false, game)
    end)
end

-- ============================================================================
-- JALANKAN SEMUA BYPASS
-- ============================================================================
spawn(function()
    wait(0.5)
    spoofProperties()
    blockAntiCheatRemotes()
    hookMetamethods()
    disableAntiCheatConnections()
    hideGUIFromDetection()
    createHoneypot()
    bypassKick()
    
    -- Loop untuk maintain bypass
    while true do
        wait(10)
        blockAntiCheatRemotes()
        disableAntiCheatConnections()
        spoofProperties()
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
    -- FORCE MONEY
    forceMoney = false,
    forceMoneyAmount = 99999999,
    forceMoneyDelay = 3,
    
    -- AUTO FARM (MAJU MUNDUR)
    autoFarm = false,
    
    -- DRIVING
    autoDrive = false,
    insaneSpeed = false,
    insaneSpeedValue = 500,
    
    -- MOVEMENT
    noclip = false,
    flyHack = false,
    flySpeed = 120,
    teleportAnywhere = false,
    
    -- TROLL
    crashPlayer = false,
    loopKill = false,
    freezeAll = false,
    pushAll = false,
    serverCrasher = false,
    
    -- VISUAL
    esp = false,
    rainbowCar = false
}

-- ============================================================================
-- AUTO FARM (MAJU 2 DETIK, MUNDUR 2 DETIK) - LURUS TIDAK BELOK
-- ============================================================================
local farmDirection = "maju" -- maju atau mundur
local farmTimer = 0

local function pressFarmKey(key, isDown)
    local k = key == "w" and Enum.KeyCode.W or Enum.KeyCode.S
    pcall(function()
        virtualInput:SendKeyEvent(isDown, k, false, game)
    end)
end

local function releaseAllFarmKeys()
    pcall(function()
        virtualInput:SendKeyEvent(false, Enum.KeyCode.W, false, game)
        virtualInput:SendKeyEvent(false, Enum.KeyCode.S, false, game)
    end)
end

spawn(function()
    while isRunning do
        wait(0.1)
        
        if features.autoFarm then
            farmTimer = farmTimer + 0.1
            
            if farmDirection == "maju" and farmTimer >= 2 then
                -- 2 detik maju, ganti ke mundur
                pressFarmKey("w", false)
                farmDirection = "mundur"
                farmTimer = 0
            elseif farmDirection == "mundur" and farmTimer >= 2 then
                -- 2 detik mundur, ganti ke maju
                pressFarmKey("s", false)
                farmDirection = "maju"
                farmTimer = 0
            end
            
            -- Tekan tombol sesuai arah
            if farmDirection == "maju" then
                pressFarmKey("w", true)
            else
                pressFarmKey("s", true)
            end
        else
            -- Matikan auto farm
            releaseAllFarmKeys()
            farmTimer = 0
            farmDirection = "maju"
        end
    end
end)

-- ============================================================================
-- FORCE MONEY (PAKSA LANGSUNG)
-- ============================================================================
local function paksaTambahUang(amount)
    pcall(function()
        -- Method 1: Langsung ke leaderstats
        if player:FindFirstChild("leaderstats") then
            for _, v in ipairs(player.leaderstats:GetChildren()) do
                v.Value = v.Value + amount
            end
        end
        
        -- Method 2: Scan semua nilai
        local function scanAndAdd(obj)
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("IntValue") or child:IsA("NumberValue") then
                    local name = string.lower(child.Name)
                    if name:find("money") or name:find("cash") or name:find("uang") or name:find("rp") then
                        child.Value = child.Value + amount
                    end
                end
                scanAndAdd(child)
            end
        end
        scanAndAdd(player)
        scanAndAdd(replicatedStorage)
        
        -- Method 3: Spam remote
        for _, r in ipairs(replicatedStorage:GetDescendants()) do
            if r:IsA("RemoteEvent") then
                for i = 1, 50 do
                    r:FireServer("AddMoney", amount)
                    r:FireServer("Earn", amount)
                    r:FireServer("UpdateCash", amount)
                end
            end
        end
    end)
end

spawn(function()
    while isRunning do
        wait(features.forceMoneyDelay)
        if features.forceMoney then
            paksaTambahUang(features.forceMoneyAmount)
            print("[FORCE] +Rp" .. features.forceMoneyAmount)
        end
    end
end)

-- ============================================================================
-- INSANE SPEED (SAMPAI 500+)
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.05)
        if features.insaneSpeed and humanoid then
            humanoid.WalkSpeed = features.insaneSpeedValue
        elseif humanoid and not features.insaneSpeed then
            humanoid.WalkSpeed = 16
        end
    end
end)

-- ============================================================================
-- AUTO DRIVE (WASD) + STABILIZER (CEGAH MOBIL LONCAT)
-- ============================================================================
local driveKeys = {w = false, a = false, s = false, d = false}

local function pressKey(key)
    if not driveKeys[key] then
        driveKeys[key] = true
        local k = key == "w" and Enum.KeyCode.W or key == "a" and Enum.KeyCode.A or key == "s" and Enum.KeyCode.S or Enum.KeyCode.D
        saferInput(k, true)
    end
end

local function releaseKey(key)
    if driveKeys[key] then
        driveKeys[key] = false
        local k = key == "w" and Enum.KeyCode.W or key == "a" and Enum.KeyCode.A or key == "s" and Enum.KeyCode.S or Enum.KeyCode.D
        saferInput(k, false)
    end
end

local function releaseAll()
    for k in pairs(driveKeys) do releaseKey(k) end
end

-- STABILIZER UNTUK MOBIL (CEGAH LONCAT-LONCAT)
local function stabilizeVehicle()
    local vehicle = character:FindFirstChildOfClass("VehicleSeat")
    if vehicle and vehicle.Parent then
        local vehicleBody = vehicle.Parent:FindFirstChild("Body")
        if vehicleBody and vehicleBody:IsA("BasePart") then
            -- Paksa stabil
            local vel = vehicleBody:FindFirstChild("Stabilizer")
            if not vel then
                vel = Instance.new("BodyVelocity")
                vel.Name = "Stabilizer"
                vel.MaxForce = Vector3.new(100000, 100000, 100000)
                vel.Parent = vehicleBody
            end
            vel.Velocity = Vector3.new(vel.Velocity.X, 0, vel.Velocity.Z)
            
            -- Suspension lebih stabil
            if vehicle:FindFirstChild("Suspension") then
                vehicle.Suspension.Value = 0.5
            end
        end
    end
end

spawn(function()
    while isRunning do
        wait(0.1)
        stabilizeVehicle()
    end
end)

local function findTarget()
    local target, minDist = nil, math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = string.lower(obj.Name)
            if name:find("checkpoint") or name:find("waypoint") or obj.Material == Enum.Material.Asphalt then
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
        if not features.autoDrive then
            releaseAll()
            wait(0.5)
            continue
        end
        
        if not character or not character.HumanoidRootPart then
            wait(1)
            continue
        end
        
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
-- FLY HACK
-- ============================================================================
local flyVelocity = nil
spawn(function()
    while isRunning do
        wait()
        if features.flyHack then
            if not flyVelocity and character and character:FindFirstChild("HumanoidRootPart") then
                flyVelocity = Instance.new("BodyVelocity")
                flyVelocity.MaxForce = Vector3.new(1000000, 1000000, 1000000)
                flyVelocity.Parent = character.HumanoidRootPart
                
                local gyro = Instance.new("BodyGyro")
                gyro.MaxTorque = Vector3.new(1000000, 1000000, 1000000)
                gyro.Parent = character.HumanoidRootPart
            end
            if flyVelocity then
                local move = Vector3.new()
                if userInput:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0,0,-1) end
                if userInput:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0,0,1) end
                if userInput:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1,0,0) end
                if userInput:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1,0,0) end
                if userInput:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
                if userInput:IsKeyDown(Enum.KeyCode.LeftControl) then move = move + Vector3.new(0,-1,0) end
                if move.Magnitude > 0 then move = move.Unit end
                local cam = workspace.CurrentCamera
                flyVelocity.Velocity = (cam.CFrame.LookVector * move.Z + cam.CFrame.RightVector * move.X + cam.CFrame.UpVector * move.Y) * features.flySpeed
                if humanoid then humanoid.PlatformStand = true end
            end
        else
            if flyVelocity then flyVelocity:Destroy() end
            flyVelocity = nil
            if humanoid then humanoid.PlatformStand = false end
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
        end
    end
end)

-- ============================================================================
-- TELEPORT ANYWHERE
-- ============================================================================
local mouse = player:GetMouse()
spawn(function()
    while isRunning do
        wait()
        if features.teleportAnywhere and mouse then
            mouse.Button1Down:Connect(function()
                local target = mouse.Target
                if target and target:IsA("BasePart") and character and character.HumanoidRootPart then
                    character.HumanoidRootPart.CFrame = target.CFrame + Vector3.new(0, 3, 0)
                end
            end)
        end
    end
end)

-- ============================================================================
-- CRASH OTHER PLAYER
-- ============================================================================
local function crashPlayerTarget(targetPlayer)
    pcall(function()
        for i = 1, 5000 do
            local remote = Instance.new("RemoteEvent")
            remote.Name = "Crash_" .. i .. httpService:GenerateGUID(false)
            remote.Parent = replicatedStorage
            remote:FireClient(targetPlayer)
            debris:AddItem(remote, 0.01)
        end
        for i = 1, 100 do
            local part = Instance.new("Part")
            part.Size = Vector3.new(1000, 1000, 1000)
            part.CFrame = targetPlayer.Character and targetPlayer.Character.HumanoidRootPart and targetPlayer.Character.HumanoidRootPart.CFrame or CFrame.new()
            part.Anchored = true
            part.Transparency = 1
            part.Parent = workspace
            debris:AddItem(part, 0.05)
        end
    end)
end

spawn(function()
    while isRunning do
        wait(2)
        if features.crashPlayer then
            for _, plr in ipairs(players:GetPlayers()) do
                if plr ~= player then
                    crashPlayerTarget(plr)
                end
            end
        end
    end
end)

-- ============================================================================
-- LOOP KILL
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.5)
        if features.loopKill then
            for _, plr in ipairs(players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") then
                    pcall(function()
                        plr.Character.Humanoid.Health = 0
                        local exp = Instance.new("Explosion")
                        exp.BlastRadius = 10
                        exp.BlastPressure = 1000000
                        exp.Position = plr.Character.HumanoidRootPart.Position
                        exp.Parent = workspace
                    end)
                end
            end
        end
    end
end)

-- ============================================================================
-- FREEZE ALL
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.3)
        if features.freezeAll then
            for _, plr in ipairs(players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") then
                    plr.Character.Humanoid.WalkSpeed = 0
                    plr.Character.Humanoid.JumpPower = 0
                end
            end
        end
    end
end)

-- ============================================================================
-- PUSH ALL
-- ============================================================================
spawn(function()
    while isRunning do
        wait(0.2)
        if features.pushAll and character and character:FindFirstChild("HumanoidRootPart") then
            for _, plr in ipairs(players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dir = (plr.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Unit
                    plr.Character.HumanoidRootPart.Velocity = dir * 50000
                end
            end
        end
    end
end)

-- ============================================================================
-- SERVER CRASHER
-- ============================================================================
spawn(function()
    while isRunning do
        wait(1)
        if features.serverCrasher then
            for i = 1, 5000 do
                local part = Instance.new("Part")
                part.Size = Vector3.new(100, 100, 100)
                part.Position = Vector3.new(math.random(-10000, 10000), math.random(-1000, 1000), math.random(-10000, 10000))
                part.Anchored = true
                part.Parent = workspace
                debris:AddItem(part, 0.05)
            end
            for _, plr in ipairs(players:GetPlayers()) do
                for i = 1, 1000 do
                    local remote = Instance.new("RemoteEvent")
                    remote.Name = "Overload_" .. i
                    remote.Parent = replicatedStorage
                    remote:FireClient(plr)
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
            for _, plr in ipairs(players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    if not plr.Character:FindFirstChild("ESP_GUI") then
                        local bill = Instance.new("BillboardGui")
                        bill.Name = "ESP_GUI"
                        bill.Size = UDim2.new(0, 200, 0, 50)
                        bill.AlwaysOnTop = true
                        bill.Parent = plr.Character.HumanoidRootPart
                        
                        local f = Instance.new("Frame")
                        f.Size = UDim2.new(1, 0, 1, 0)
                        f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                        f.BackgroundTransparency = 0.4
                        f.BorderSizePixel = 2
                        f.BorderColor3 = Color3.fromRGB(255, 0, 0)
                        f.Parent = bill
                        
                        local l = Instance.new("TextLabel")
                        l.Size = UDim2.new(1, 0, 1, 0)
                        l.BackgroundTransparency = 1
                        l.Text = plr.Name .. " 💀"
                        l.TextColor3 = Color3.fromRGB(255, 0, 0)
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
                    if p:IsA("BasePart") then
                        p.Color = Color3.fromHSV(hue, 1, 1)
                    end
                end
            end
        end
    end
end)

-- ============================================================================
-- GUI PREMIUM (FORCE EDITION)
-- ============================================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GarciaHub"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 450, 0, 600)
main.Position = UDim2.new(0.5, -225, 0.5, -300)
main.BackgroundColor3 = Color3.fromRGB(5, 0, 10)
main.BackgroundTransparency = 0.05
main.BorderSizePixel = 3
main.BorderColor3 = Color3.fromRGB(255, 0, 0)
main.Active = true
main.Draggable = true
main.Parent = screenGui

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 65)
header.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
header.BackgroundTransparency = 0.3
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "💀 GARCIA-HUB v13.0 💀"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = header

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1, 0, 0, 20)
sub.Position = UDim2.new(0, 0, 1, -22)
sub.BackgroundTransparency = 1
sub.Text = "ULTIMATE BYPASS | AUTO FARM | FORCE MONEY"
sub.TextColor3 = Color3.fromRGB(255, 100, 100)
sub.TextSize = 10
sub.Font = Enum.Font.Gotham
sub.Parent = header

-- Tab menu
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 45)
tabFrame.Position = UDim2.new(0, 0, 0, 70)
tabFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 20)
tabFrame.Parent = main

local tabs = {"💵", "🌾", "🚗", "🕊️", "💀", "👁️"}
local tabNames = {"FORCE", "FARM", "DRIVE", "MOVE", "TROLL", "VISUAL"}
local currentTab = 1
local tabBtns = {}

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -130)
scroll.Position = UDim2.new(0, 10, 0, 120)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 8
scroll.CanvasSize = UDim2.new(0, 0, 0, 700)
scroll.Parent = main

local layout = Instance.new("UIListLayout")
layout.Parent = scroll
layout.Padding = UDim.new(0, 6)

local function toggle(text, key, default)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -10, 0, 50)
    f.BackgroundColor3 = Color3.fromRGB(20, 0, 25)
    f.BorderSizePixel = 1
    f.BorderColor3 = Color3.fromRGB(100, 0, 0)
    f.Parent = scroll
    
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.6, 0, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(255, 100, 100)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextSize = 13
    l.Font = Enum.Font.GothamBold
    l.Parent = f
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 75, 0, 35)
    btn.Position = UDim2.new(1, -85, 0.5, -17.5)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = f
    
    local state = features[key] ~= nil and features[key] or default
    btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    btn.Text = state and "ON" or "OFF"
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        features[key] = state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        btn.Text = state and "ON" or "OFF"
    end)
end

local function slider(text, key, minv, maxv, default, suffix)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -10, 0, 70)
    f.BackgroundColor3 = Color3.fromRGB(20, 0, 25)
    f.BorderSizePixel = 1
    f.BorderColor3 = Color3.fromRGB(100, 0, 0)
    f.Parent = scroll
    
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 0, 25)
    l.Position = UDim2.new(0, 10, 0, 5)
    l.BackgroundTransparency = 1
    l.Text = text .. ": " .. default .. (suffix or "")
    l.TextColor3 = Color3.fromRGB(255, 200, 200)
    l.TextSize = 12
    l.Font = Enum.Font.GothamBold
    l.Parent = f
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, -30, 0, 6)
    bg.Position = UDim2.new(0, 15, 0, 48)
    bg.BackgroundColor3 = Color3.fromRGB(60, 0, 60)
    bg.Parent = f
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - minv) / (maxv - minv), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
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
            fill.Size = UDim2.new(p, 0, 1, 0)
            l.Text = text .. ": " .. val .. (suffix or "")
            features[key] = val
        end
    end)
end

local function buildForceTab()
    for _, v in pairs(scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    toggle("💵 FORCE MONEY (PAKSA)", "forceMoney", false)
    slider("💰 NOMINAL PAKSA", "forceMoneyAmount", 1000000, 999999999, 99999999, "")
    slider("⏱️ DELAY (DETIK)", "forceMoneyDelay", 1, 10, 3, " detik")
end

local function buildFarmTab()
    for _, v in pairs(scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    toggle("🌾 AUTO FARM (MAJU 2D - MUNDUR 2D)", "autoFarm", false)
end

local function buildDriveTab()
    for _, v in pairs(scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    toggle("🚗 AUTO DRIVE (WASD)", "autoDrive", false)
    toggle("⚡ INSANE SPEED", "insaneSpeed", false)
    slider("🏃 SPEED VALUE", "insaneSpeedValue", 50, 1000, 500, "")
end

local function buildMoveTab()
    for _, v in pairs(scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    toggle("🔧 NOCLIP", "noclip", false)
    toggle("🕊️ FLY HACK", "flyHack", false)
    slider("✈️ FLY SPEED", "flySpeed", 50, 300, 120, "")
    toggle("📍 TELEPORT ANYWHERE (KLIK)", "teleportAnywhere", false)
end

local function buildTrollTab()
    for _, v in pairs(scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    toggle("💀 CRASH OTHER PLAYER", "crashPlayer", false)
    toggle("🔪 LOOP KILL PLAYER", "loopKill", false)
    toggle("❄️ FREEZE ALL", "freezeAll", false)
    toggle("👊 PUSH ALL", "pushAll", false)
    toggle("🌡️ SERVER CRASHER", "serverCrasher", false)
end

local function buildVisualTab()
    for _, v in pairs(scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    toggle("👁️ PLAYER ESP", "esp", false)
    toggle("🌈 RAINBOW CAR", "rainbowCar", false)
end

for i = 1, #tabs do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#tabs, -4, 1, -4)
    btn.Position = UDim2.new((i-1)/#tabs, 2, 0, 2)
    btn.BackgroundColor3 = Color3.fromRGB(25, 0, 35)
    btn.Text = tabs[i] .. "\n" .. tabNames[i]
    btn.TextColor3 = Color3.fromRGB(200, 100, 100)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.Parent = tabFrame
    tabBtns[i] = btn
    
    btn.MouseButton1Click:Connect(function()
        currentTab = i
        for j, b in pairs(tabBtns) do
            b.BackgroundColor3 = Color3.fromRGB(25, 0, 35)
            b.TextColor3 = Color3.fromRGB(200, 100, 100)
        end
        btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        if i == 1 then buildForceTab()
        elseif i == 2 then buildFarmTab()
        elseif i == 3 then buildDriveTab()
        elseif i == 4 then buildMoveTab()
        elseif i == 5 then buildTrollTab()
        elseif i == 6 then buildVisualTab()
        end
    end)
end

tabBtns[1].BackgroundColor3 = Color3.fromRGB(150, 0, 0)
tabBtns[1].TextColor3 = Color3.fromRGB(255, 255, 255)
buildForceTab()

userInput.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.F5 then
        guiVisible = not guiVisible
        screenGui.Enabled = guiVisible
    end
end)

print("╔══════════════════════════════════════════════════════════════════════╗")
print("║         GARCIA-HUB v13.0 - ULTIMATE BYPASS ACTIVATED                 ║")
print("║              [ TEMBUS ANTI-CHEAT | FORCE MONEY ]                      ║")
print("║              [ AUTO FARM MAJU 2D - MUNDUR 2D ]                        ║")
print("║                   PRESS F5 TOGGLE GUI                                 ║")
print("╚══════════════════════════════════════════════════════════════════════╝")

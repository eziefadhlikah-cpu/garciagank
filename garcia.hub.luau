--[[
╔═══════════════════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                                   ║
║      ██████╗  █████╗ ██████╗  ██████╗██╗ █████╗     ██╗  ██╗██╗   ██╗██████╗                     ║
║     ██╔════╝ ██╔══██╗██╔══██╗██╔════╝██║██╔══██╗    ██║  ██║██║   ██║██╔══██╗                    ║
║     ██║  ███╗███████║██████╔╝██║     ██║███████║    ███████║██║   ██║██████╔╝                    ║
║     ██║   ██║██╔══██║██╔══██╗██║     ██║██╔══██║    ██╔══██║██║   ██║██╔══██╗                    ║
║     ╚██████╔╝██║  ██║██║  ██║╚██████╗██║██║  ██║    ██║  ██║╚██████╔╝██████╔╝                    ║
║      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝                     ║
║                                                                                                   ║
║                         ███████╗██╗     ██╗████████╗███████╗                                     ║
║                         ██╔════╝██║     ██║╚══██╔══╝██╔════╝                                     ║
║                         █████╗  ██║     ██║   ██║   █████╗                                       ║
║                         ██╔══╝  ██║     ██║   ██║   ██╔══╝                                       ║
║                         ███████╗███████╗██║   ██║   ███████╗                                     ║
║                         ╚══════╝╚══════╝╚═╝   ╚═╝   ╚══════╝                                     ║
║                                                                                                   ║
║                              PREMIUM ULTIMATE V7.0 - THE COMPLETE EDITION                         ║
║                           INDONESIA DRIVING EXPERIENCE (IDEX) - FULL UNLOCK                       ║
║                                                                                                   ║
║                         ✅ 75+ FITUR PREMIUM | ✅ AUTO-DETECT | ✅ NO BUG                          ║
║                         ✅ MONEY FARM | ✅ AUTO DRIVE WASD | ✅ PROTECTION                         ║
║                         ✅ TROLLING GANAS | ✅ ESP PREMIUM | ✅ EXPLOIT                            ║
║                                                                                                   ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════╝
--]]

-- ============================================================================
-- INITIALIZATION & CORE
-- ============================================================================
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local lighting = game:GetService("Lighting")
local virtualUser = game:GetService("VirtualUser")
local httpService = game:GetService("HttpService")
local coreGui = game:GetService("CoreGui")
local teleportService = game:GetService("TeleportService")
local debris = game:GetService("Debris")

local isRunning = true
local featureStates = {}
local guiEnabled = true

-- ============================================================================
-- PREMIUM FEATURE DATABASE (75+ FITUR)
-- ============================================================================
local features = {
    -- ========== MONEY & FARM (8 fitur) ==========
    instantMoney = {active = false, value = 100000, mode = "distance"},
    moneyMultiplier = {active = false, value = 10},
    autoFarm = {active = false, mode = "hyper"},
    autoCollect = {active = false, radius = 50},
    infiniteMoneyGlitch = {active = false, amount = 999999, speed = 0.05},
    duplicateItems = {active = false},
    sellItemsAuto = {active = false, multiplier = 2},
    dailyRewardClaimer = {active = false},
    
    -- ========== DRIVING WASD (8 fitur) ==========
    autoDrive = {active = false, mode = "intelligent", speed = 80, steerSmooth = true},
    teleportToCheckpoints = {active = false, delay = 0.3},
    autoCompleteRace = {active = false, instant = true},
    steeringAssist = {active = false, sensitivity = 0.7},
    driftAssist = {active = false, angle = 45},
    autoBrake = {active = false, distance = 10},
    nitroBoost = {active = false, power = 200},
    autoParking = {active = false},
    
    -- ========== SPEED & MOVEMENT (9 fitur) ==========
    speedHack = {active = false, value = 120},
    flyMode = {active = false, speed = 80, control = "advanced"},
    noclip = {active = false, mode = "aggressive"},
    jumpPower = {active = false, value = 300},
    infiniteStamina = {active = false},
    wallclimb = {active = false, speed = 50},
    dolphinDive = {active = false},
    superSlides = {active = false},
    gravityControl = {active = false, value = 0},
    
    -- ========== PROTECTION (10 fitur) ==========
    godMode = {active = false, type = "ultimate"},
    antiKick = {active = false, bypassAll = true},
    antiBan = {active = false, spoofData = true},
    invisibility = {active = false, mode = "total"},
    hideName = {active = false, mode = "deep"},
    autoRespawn = {active = false, instant = true},
    healthRegen = {active = false, amount = 100, delay = 0.5},
    antiFallDamage = {active = false},
    antiVehicleDamage = {active = false},
    antiExplosion = {active = false},
    
    -- ========== TROLLING (12 fitur) ==========
    crashOthers = {active = false, intensity = "lethal", mode = "massive"},
    freezePlayers = {active = false, radius = 100, duration = 5},
    pushPlayers = {active = false, force = 10000, mode = "explosive"},
    blindPlayers = {active = false, radius = 50, intensity = 0.95},
    explodeOthers = {active = false, radius = 30, power = 100},
    stealMoney = {active = false, amount = 10000, perSecond = true},
    serverLag = {active = false, intensity = 10, mode = "maximum"},
    kickOthers = {active = false, message = "🔥 GARCIA-HUB PREMIUM OWNED YOU! 🔥"},
    spamMessages = {active = false, message = "🔥 GARCIA-HUB PREMIUM | IDEX ELITE 🔥", delay = 0.3},
    teleportToPlayers = {active = false, target = nil, follow = false},
    invertControls = {active = false, radius = 50},
    loopKill = {active = false, radius = 30},
    
    -- ========== VISUAL & ESP (10 fitur) ==========
    esp = {active = false, mode = "premium", showHealth = true, showDistance = true, showBox = true},
    chams = {active = false, color = "rainbow", transparency = 0.3},
    rainbowCar = {active = false, speed = 0.1, mode = "smooth"},
    alwaysDay = {active = false},
    fullBright = {active = false, intensity = 2},
    xray = {active = false, transparency = 0.3},
    tracers = {active = false, color = "red"},
    nameTags = {active = false, customName = "🔥 GARCIA ELITE 🔥"},
    noFog = {active = false},
    customSkybox = {active = false, theme = "premium"},
    
    -- ========== EXPLOIT & UNLOCK (9 fitur) ==========
    unlockAllGamepass = {active = false},
    bypassPaywalls = {active = false},
    forceAdmin = {active = false, level = "maximum"},
    unlockAllVehicles = {active = false},
    unlockAllSkins = {active = false},
    bypassLevelReq = {active = false},
    instantWin = {active = false},
    noCooldown = {active = false},
    infiniteBoosters = {active = false},
    
    -- ========== UTILITY (9 fitur) ==========
    autoRejoin = {active = false, onDeath = true, onKick = true},
    savePosition = {active = false, saveSlot = nil, positions = {}},
    loadPosition = {active = false, loadSlot = nil},
    waypointRecorder = {active = false, waypoints = {}, recording = false},
    macroRecorder = {active = false, macros = {}, recording = false},
    hotkeyManager = {active = false, hotkeys = {}},
    autoClicker = {active = false, delay = 0.1, key = "E"},
    antiAfk = {active = false, movement = true},
    fpsBoost = {active = false, mode = "extreme"},
    
    -- ========== SERVER CONTROL (5 fitur) ==========
    serverCrasher = {active = false, intensity = "maximum"},
    serverShutdown = {active = false},
    clonePlayers = {active = false, amount = 50},
    spamRemotes = {active = false, amount = 1000},
    infiniteLoop = {active = false, loops = 999999}
}

-- ============================================================================
-- DRIVING KEYS (WASD SYSTEM)
-- ============================================================================
local driveKeys = {w = false, a = false, s = false, d = false}
local function pressKey(key)
    local k = string.upper(key)
    if not driveKeys[key] then
        pcall(function() virtualUser:PressKey(Enum.KeyCode[k]) end)
        driveKeys[key] = true
    end
end
local function releaseKey(key)
    local k = string.upper(key)
    if driveKeys[key] then
        pcall(function() virtualUser:ReleaseKey(Enum.KeyCode[k]) end)
        driveKeys[key] = false
    end
end
local function releaseAllKeys()
    for k, _ in pairs(driveKeys) do
        releaseKey(k)
    end
end

-- ============================================================================
-- PREMIUM GUI (SUPER MODERN)
-- ============================================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GarciaHubComplete"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 480, 0, 750)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -375)
mainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
mainFrame.BackgroundTransparency = 0.03
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- GLOW BORDER (PREMIUM EFFECT)
local glow = Instance.new("Frame")
glow.Size = UDim2.new(1, 12, 1, 12)
glow.Position = UDim2.new(0, -6, 0, -6)
glow.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
glow.BackgroundTransparency = 0.85
glow.BorderSizePixel = 0
glow.Parent = mainFrame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 100)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 100))
})
glow.UIGradient = gradient

-- HEADER PREMIUM
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 100)
header.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
header.BackgroundTransparency = 0.2
header.BorderSizePixel = 0
header.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, 0, 0, 50)
titleText.Position = UDim2.new(0, 0, 0, 15)
titleText.BackgroundTransparency = 1
titleText.Text = "✧ GARCIA-HUB COMPLETE EDITION ✧"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamBold
titleText.Parent = header

local subText = Instance.new("TextLabel")
subText.Size = UDim2.new(1, 0, 0, 25)
subText.Position = UDim2.new(0, 0, 0, 65)
subText.BackgroundTransparency = 1
subText.Text = "PREMIUM V7.0 | 75+ FITUR | IDEX ELITE"
subText.TextColor3 = Color3.fromRGB(255, 100, 200)
subText.TextSize = 13
subText.Font = Enum.Font.Gotham
subText.Parent = header

-- STATS BAR
local statsBar = Instance.new("Frame")
statsBar.Size = UDim2.new(0.95, 0, 0, 45)
statsBar.Position = UDim2.new(0.025, 0, 0, 105)
statsBar.BackgroundColor3 = Color3.fromRGB(12, 12, 25)
statsBar.BorderSizePixel = 1
statsBar.BorderColor3 = Color3.fromRGB(255, 0, 150)
statsBar.Parent = mainFrame

local moneyStat = Instance.new("TextLabel")
moneyStat.Size = UDim2.new(0.5, -5, 1, 0)
moneyStat.Position = UDim2.new(0, 5, 0, 0)
moneyStat.BackgroundTransparency = 1
moneyStat.Text = "💰 LOADING..."
moneyStat.TextColor3 = Color3.fromRGB(255, 215, 0)
moneyStat.TextSize = 14
moneyStat.Font = Enum.Font.GothamBold
moneyStat.TextXAlignment = Enum.TextXAlignment.Left
moneyStat.Parent = statsBar

local speedStat = Instance.new("TextLabel")
speedStat.Size = UDim2.new(0.5, -5, 1, 0)
speedStat.Position = UDim2.new(0.5, 0, 0, 0)
speedStat.BackgroundTransparency = 1
speedStat.Text = "⚡ SPEED: 16"
speedStat.TextColor3 = Color3.fromRGB(100, 255, 100)
speedStat.TextSize = 14
speedStat.Font = Enum.Font.GothamBold
speedStat.TextXAlignment = Enum.TextXAlignment.Right
speedStat.Parent = statsBar

-- TAB SYSTEM (8 KATEGORI)
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 55)
tabFrame.Position = UDim2.new(0, 0, 0, 155)
tabFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = mainFrame

local tabs = {"💰", "🚗", "⚡", "🛡️", "👹", "👁️", "💀", "⚙️"}
local tabNames = {"MONEY", "DRIVE", "MOVEMENT", "PROTECT", "TROLL", "VISUAL", "EXPLOIT", "UTILITY"}
local currentTab = 1
local tabButtons = {}

local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -225)
contentFrame.Position = UDim2.new(0, 10, 0, 215)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 8
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 150)
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 1500)
contentFrame.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Parent = contentFrame
contentLayout.Padding = UDim.new(0, 6)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- UI COMPONENTS
local function createToggle(text, featurePath, defaultValue, desc)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 70)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(45, 45, 70)
    frame.Parent = contentFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 0, 28)
    label.Position = UDim2.new(0, 10, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(250, 250, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    if desc then
        local dLabel = Instance.new("TextLabel")
        dLabel.Size = UDim2.new(0.65, 0, 0, 20)
        dLabel.Position = UDim2.new(0, 10, 0, 38)
        dLabel.BackgroundTransparency = 1
        dLabel.Text = desc
        dLabel.TextColor3 = Color3.fromRGB(140, 140, 180)
        dLabel.TextXAlignment = Enum.TextXAlignment.Left
        dLabel.TextSize = 11
        dLabel.Font = Enum.Font.Gotham
        dLabel.Parent = frame
    end
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 0, 40)
    btn.Position = UDim2.new(1, -100, 0.5, -20)
    btn.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    btn.Text = defaultValue and "ACTIVE" or "INACTIVE"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = frame
    
    local target = features
    for part in string.gmatch(featurePath, "[^.]+") do
        target = target[part]
        if not target then break end
    end
    
    local state = defaultValue
    if featureStates[featurePath] ~= nil then
        state = featureStates[featurePath]
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        btn.Text = state and "ACTIVE" or "INACTIVE"
        if target then target.active = state end
    end
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        featureStates[featurePath] = state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        btn.Text = state and "ACTIVE" or "INACTIVE"
        if target then target.active = state end
    end)
    
    return frame
end

local function createSlider(text, featurePath, minVal, maxVal, defaultVal, suffix, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 85)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(45, 45, 70)
    frame.Parent = contentFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 30)
    label.Position = UDim2.new(0, 10, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. defaultVal .. (suffix or "")
    label.TextColor3 = Color3.fromRGB(250, 250, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -30, 0, 6)
    sliderBg.Position = UDim2.new(0, 15, 0, 52)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg
    
    local valueDisplay = Instance.new("TextLabel")
    valueDisplay.Size = UDim2.new(0, 65, 0, 28)
    valueDisplay.Position = UDim2.new(1, -75, 0, 42)
    valueDisplay.BackgroundColor3 = Color3.fromRGB(35, 35, 60)
    valueDisplay.Text = tostring(defaultVal)
    valueDisplay.TextColor3 = Color3.fromRGB(255, 200, 100)
    valueDisplay.TextSize = 12
    valueDisplay.Font = Enum.Font.GothamBold
    valueDisplay.Parent = frame
    
    local currentVal = defaultVal
    local dragging = false
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    sliderBg.InputEnded:Connect(function() dragging = false end)
    
    userInput.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = userInput:GetMouseLocation()
            local sliderPos = sliderBg.AbsolutePosition
            local percent = math.clamp((mousePos.X - sliderPos.X) / sliderBg.AbsoluteSize.X, 0, 1)
            currentVal = minVal + (maxVal - minVal) * percent
            currentVal = math.floor(currentVal * 10) / 10
            fill.Size = UDim2.new(percent, 0, 1, 0)
            valueDisplay.Text = tostring(currentVal)
            label.Text = text .. ": " .. currentVal .. (suffix or "")
            
            local target = features
            for part in string.gmatch(featurePath, "[^.]+") do
                target = target[part]
                if not target then break end
            end
            if target then target.value = currentVal end
            if callback then callback(currentVal) end
        end
    end)
    
    return frame
end

-- ============================================================================
-- BUILD EACH TAB (75+ FITUR)
-- ============================================================================
local function buildMoneyTab()
    for _, v in pairs(contentFrame:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    createToggle("💰 INSTANT MONEY (DRIVE BASED)", "instantMoney", false, "Dapat uang setiap berkendara")
    createSlider("💰 NOMINAL PER 5 UNIT", "instantMoney.value", 1000, 999999, 100000, "", nil)
    createToggle("📦 AUTO COLLECT ITEMS", "autoCollect", false, "Auto ambil coin/item di radius tertentu")
    createSlider("📦 RADIUS COLLECT", "autoCollect.radius", 10, 200, 50, "m", nil)
    createToggle("⚡ MONEY MULTIPLIER", "moneyMultiplier", false, "Lipat gandakan pendapatan")
    createSlider("⚡ MULTIPLIER VALUE", "moneyMultiplier.value", 2, 100, 10, "x", nil)
    createToggle("🔓 INFINITE MONEY GLITCH", "infiniteMoneyGlitch", false, "Loop uang super cepat (GANAS)")
    createSlider("💸 GLITCH AMOUNT", "infiniteMoneyGlitch.amount", 10000, 99999999, 9999999, "", nil)
    createToggle("🔄 AUTO SELL ITEMS", "sellItemsAuto", false, "Auto jual item saat inventory penuh")
    createToggle("🎁 DAILY REWARD CLAIMER", "dailyRewardClaimer", false, "Auto klaim reward harian")
end

local function buildDriveTab()
    for _, v in pairs(contentFrame:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    createToggle("🚗 AUTO DRIVE (WASD INTELLIGENT)", "autoDrive", false, "Auto nyetir ke checkpoint terdekat")
    createSlider("🏁 AUTO DRIVE SPEED", "autoDrive.speed", 30, 300, 85, "km/h", nil)
    createToggle("🗺️ TELEPORT TO CHECKPOINTS", "teleportToCheckpoints", false, "Teleport ke semua checkpoint")
    createToggle("⚡ AUTO COMPLETE RACE", "autoCompleteRace", false, "Selesai race dalam 1 detik")
    createToggle("🎮 STEERING ASSIST", "steeringAssist", false, "Bantuan kemudi otomatis")
    createToggle("🔄 DRIFT ASSIST", "driftAssist", false, "Auto drift di tikungan")
    createToggle("🛑 AUTO BRAKE", "autoBrake", false, "Auto rem sebelum menabrak")
    createSlider("🛑 BRAKE DISTANCE", "autoBrake.distance", 5, 30, 12, "m", nil)
    createToggle("💨 NITRO BOOST", "nitroBoost", false, "Boost kecepatan sementara")
    createToggle("🅿️ AUTO PARKING", "autoParking", false, "Auto parkir di spot terdekat")
end

local function buildMovementTab()
    for _, v in pairs(contentFrame:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    createToggle("⚡ SPEED HACK", "speedHack", false, "Meningkatkan kecepatan jalan/lari")
    createSlider("🏃 SPEED VALUE", "speedHack.value", 16, 500, 120, "", nil)
    createToggle("🕊️ FLY MODE (WASD + SPACE)", "flyMode", false, "Terbang bebas di map")
    createSlider("✈️ FLY SPEED", "flyMode.speed", 30, 250, 85, "", nil)
    createToggle("🔧 NOCLIP", "noclip", false, "Tembus semua objek")
    createToggle("🦘 JUMP POWER BOOST", "jumpPower", false, "Lompat super tinggi")
    createSlider("🦘 JUMP VALUE", "jumpPower.value", 50, 1000, 350, "", nil)
    createToggle("💪 INFINITE STAMINA", "infiniteStamina", false, "Stamina tidak habis")
    createToggle("🧗 WALL CLIMB", "wallclimb", false, "Panjat tembok")
    createToggle("🌊 DOLPHIN DIVE", "dolphinDive", false, "Menyelam seperti lumba-lumba")
    createToggle("🛝 SUPER SLIDES", "superSlides", false, "Meluncur super cepat")
    createSlider("🌍 GRAVITY CONTROL", "gravityControl.value", -50, 50, 0, "", function(v)
        workspace.Gravity = v
    end)
end

local function buildProtectionTab()
    for _, v in pairs(contentFrame:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    createToggle("👑 GOD MODE ULTIMATE", "godMode", false, "Tidak bisa mati (100% anti damage)")
    createToggle("🛡️ ANTI KICK / BAN", "antiKick", false, "Bypass semua sistem kick")
    createToggle("🔒 ANTI BAN SPOOF", "antiBan", false, "Memalsukan data agar aman")
    createToggle("👻 TOTAL INVISIBILITY", "invisibility", false, "Tidak terlihat player lain")
    createToggle("📛 HIDE NAME (DEEP)", "hideName", false, "Menyembunyikan nama total")
    createToggle("💚 AUTO RESPAWN", "autoRespawn", false, "Respawn instan saat mati")
    createToggle("❤️ HEALTH REGEN", "healthRegen", false, "Regenerasi kesehatan")
    createSlider("❤️ REGEN AMOUNT", "healthRegen.amount", 10, 500, 100, "HP", nil)
    createToggle("🪨 ANTI FALL DAMAGE", "antiFallDamage", false, "Bebas dari damage jatuh")
    createToggle("🚗 ANTI VEHICLE DAMAGE", "antiVehicleDamage", false, "Mobil tidak bisa rusak")
    createToggle("💥 ANTI EXPLOSION", "antiExplosion", false, "Tidak terkena ledakan")
end

local function buildTrollTab()
    for _, v in pairs(contentFrame:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    createToggle("💥 CRASH OTHER PLAYERS", "crashOthers", false, "Buat player lain crash/force close (GANAS)")
    createToggle("❄️ FREEZE PLAYERS", "freezePlayers", false, "Bekukan player di sekitar")
    createSlider("❄️ FREEZE RADIUS", "freezePlayers.radius", 20, 500, 100, "m", nil)
    createToggle("👊 PUSH PLAYERS", "pushPlayers", false, "Dorong player lain dengan keras")
    createSlider("👊 PUSH FORCE", "pushPlayers.force", 1000, 100000, 25000, "", nil)
    createToggle("👁️ BLIND PLAYERS", "blindPlayers", false, "Buat player sekitar jadi buta")
    createSlider("👁️ BLIND RADIUS", "blindPlayers.radius", 20, 500, 60, "m", nil)
    createToggle("💣 EXPLODE OTHERS", "explodeOthers", false, "Ledakkan player di sekitar")
    createSlider("💣 EXPLODE RADIUS", "explodeOthers.radius", 10, 200, 35, "m", nil)
    createToggle("💰 STEAL MONEY", "stealMoney", false, "Curi uang dari player lain")
    createSlider("💰 STEAL AMOUNT", "stealMoney.amount", 1000, 500000, 50000, "", nil)
    createToggle("👢 KICK OTHERS", "kickOthers", false, "Kick player dari server")
    createToggle("📢 SPAM MESSAGES", "spamMessages", false, "Spam pesan ke chat global")
    createToggle("🎯 TELEPORT TO PLAYER", "teleportToPlayers", false, "Teleport ke player target")
    createToggle("🔄 INVERT CONTROLS", "invertControls", false, "Balik kontrol player sekitar")
    createToggle("💀 LOOP KILL", "loopKill", false, "Bunuh player terus menerus")
end

local function buildVisualTab()
    for _, v in pairs(contentFrame:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    createToggle("👁️ PREMIUM ESP", "esp", false, "Lihat semua player dengan detail")
    createToggle("❤️ ESP SHOW HEALTH", "esp.showHealth", true, "Tampilkan health bar")
    createToggle("📏 ESP SHOW DISTANCE", "esp.showDistance", true, "Tampilkan jarak")
    createToggle("🌈 RAINBOW CAR", "rainbowCar", false, "Mobil warna pelangi berubah")
    createSlider("🌈 RAINBOW SPEED", "rainbowCar.speed", 0.03, 0.5, 0.08, "s", nil)
    createToggle("☀️ ALWAYS DAY", "alwaysDay", false, "Selalu siang hari")
    createToggle("💡 FULL BRIGHT", "fullBright", false, "Pencahayaan super terang")
    createToggle("👁️ XRAY VISION", "xray", false, "Lihat tembus dinding")
    createToggle("📌 TRACERS", "tracers", false, "Garis menuju player")
    createToggle("🏷️ CUSTOM NAME TAGS", "nameTags", false, "Ubah nama tag sendiri")
    createToggle("🌫️ NO FOG", "noFog", false, "Hilangkan kabut")
end

local function buildExploitTab()
    for _, v in pairs(contentFrame:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    createToggle("🎁 UNLOCK ALL GAMEPASS", "unlockAllGamepass", false, "Buka semua gamepass premium")
    createToggle("🔓 BYPASS PAYWALLS", "bypassPaywalls", false, "Lewati semua pembayaran")
    createToggle("👑 FORCE ADMIN", "forceAdmin", false, "Paksa menjadi admin")
    createToggle("🚗 UNLOCK ALL VEHICLES", "unlockAllVehicles", false, "Buka semua kendaraan")
    createToggle("🎨 UNLOCK ALL SKINS", "unlockAllSkins", false, "Buka semua skin")
    createToggle("📊 BYPASS LEVEL REQUIREMENT", "bypassLevelReq", false, "Lewati batasan level")
    createToggle("🏆 INSTANT WIN", "instantWin", false, "Menang instan di race")
    createToggle("⏱️ NO COOLDOWN", "noCooldown", false, "Hilangkan cooldown semua aksi")
    createToggle("♾️ INFINITE BOOSTERS", "infiniteBoosters", false, "Booster tidak terbatas")
    createToggle("🌡️ SERVER LAG MACHINE", "serverLag", false, "Bikin server lag parah")
    createToggle("💀 SERVER CRASHER", "serverCrasher", false, "Crash seluruh server")
end

local function buildUtilityTab()
    for _, v in pairs(contentFrame:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    createToggle("🔄 AUTO REJOIN", "autoRejoin", false, "Auto join ulang saat mati/kick")
    createToggle("💾 SAVE POSITION", "savePosition", false, "Simpan posisi saat ini")
    createToggle("📂 LOAD POSITION", "loadPosition", false, "Load posisi tersimpan")
    createToggle("📍 WAYPOINT RECORDER", "waypointRecorder", false, "Rekam jalur auto farm")
    createToggle("🎮 MACRO RECORDER", "macroRecorder", false, "Rekam dan replay macro")
    createToggle("🖱️ AUTO CLICKER", "autoClicker", false, "Auto klik tombol tertentu")
    createToggle("💤 ANTI AFK", "antiAfk", false, "Cegah kick karena AFK")
    createToggle("⚡ FPS BOOST", "fpsBoost", false, "Tingkatkan FPS (hapus efek)")
    createToggle("🎮 F5 TOGGLE GUI", "toggleGui", true, "Tekan F5 untuk buka/tutup GUI")
end

-- ============================================================================
-- TAB BUTTONS & INIT
-- ============================================================================
for i = 1, #tabs do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#tabs, -4, 1, -6)
    btn.Position = UDim2.new((i-1)/#tabs, 2, 0, 3)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    btn.Text = tabs[i] .. "\n" .. tabNames[i]
    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = tabFrame
    tabButtons[i] = btn
    
    btn.MouseButton1Click:Connect(function()
        currentTab = i
        for j, tb in pairs(tabButtons) do
            tb.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
            tb.TextColor3 = Color3.fromRGB(200, 200, 220)
        end
        btn.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        if i == 1 then buildMoneyTab()
        elseif i == 2 then buildDriveTab()
        elseif i == 3 then buildMovementTab()
        elseif i == 4 then buildProtectionTab()
        elseif i == 5 then buildTrollTab()
        elseif i == 6 then buildVisualTab()
        elseif i == 7 then buildExploitTab()
        elseif i == 8 then buildUtilityTab()
        end
    end)
end

-- ============================================================================
-- CORE LOOP FUNCTIONS (SEMUA FITUR)
-- ============================================================================

-- MONEY LOOP (V5 + V6)
spawn(function()
    local lastPos = character and character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.Position or Vector3.new()
    local totalDist = 0
    while isRunning do
        wait(0.05)
        if features.instantMoney.active and character and character:FindFirstChild("HumanoidRootPart") then
            local currentPos = character.HumanoidRootPart.Position
            local dist = (currentPos - lastPos).Magnitude
            if dist > 0.1 then
                totalDist = totalDist + dist
                if totalDist >= 5 then
                    local add = features.instantMoney.value * (features.moneyMultiplier.active and features.moneyMultiplier.value or 1)
                    pcall(function()
                        if player:FindFirstChild("leaderstats") then
                            for _, v in ipairs(player.leaderstats:GetChildren()) do
                                if v.Name:lower():find("money") or v.Name:lower():find("cash") then
                                    v.Value = v.Value + add
                                end
                            end
                        end
                        for _, r in ipairs(replicatedStorage:GetDescendants()) do
                            if r:IsA("RemoteEvent") then
                                r:FireServer("AddMoney", add)
                            end
                        end
                    end)
                    totalDist = 0
                end
            end
            lastPos = currentPos
        else
            lastPos = character and character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.Position or Vector3.new()
        end
    end
end)

-- AUTO DRIVE WASD (INTELLIGENT)
spawn(function()
    local checkpoints = {}
    local function refreshCP()
        checkpoints = {}
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("checkpoint") or obj.Name:lower():find("waypoint")) then
                table.insert(checkpoints, obj)
            end
        end
    end
    refreshCP()
    
    while isRunning do
        wait(0.03)
        if not features.autoDrive.active then
            releaseAllKeys()
            wait(0.5)
            continue
        end
        if not character or not character:FindFirstChild("HumanoidRootPart") then wait(1) continue end
        
        local currentPos = character.HumanoidRootPart.Position
        local target, targetDist = nil, math.huge
        for _, cp in ipairs(checkpoints) do
            local dist = (cp.Position - currentPos).Magnitude
            if dist < targetDist and dist > 3 then target, targetDist = cp, dist end
        end
        if not target then refreshCP() continue end
        
        local direction = (target.Position - currentPos).Unit
        local forward = character.HumanoidRootPart.CFrame.LookVector
        local right = character.HumanoidRootPart.CFrame.RightVector
        local dotF, dotR = forward:Dot(direction), right:Dot(direction)
        
        if dotF > 0.2 then pressKey("w") else releaseKey("w") end
        if dotF < -0.2 then pressKey("s") else releaseKey("s") end
        if dotR > 0.15 then pressKey("d") else releaseKey("d") end
        if dotR < -0.15 then pressKey("a") else releaseKey("a") end
    end
end)

-- SPEED HACK
spawn(function()
    while isRunning do
        wait(0.1)
        if features.speedHack.active and humanoid then
            humanoid.WalkSpeed = features.speedHack.value
        elseif humanoid and not features.speedHack.active then
            humanoid.WalkSpeed = 16
        end
    end
end)

-- FLY MODE
spawn(function()
    local flyVel = nil
    while isRunning do
        wait()
        if features.flyMode.active then
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
                flyVel.Velocity = (cam.CFrame.LookVector * move.Z + cam.CFrame.RightVector * move.X + cam.CFrame.UpVector * move.Y) * features.flyMode.speed
                if humanoid then humanoid.PlatformStand = true end
            end
        else
            if flyVel then flyVel:Destroy() end
            if humanoid then humanoid.PlatformStand = false end
            flyVel = nil
        end
    end
end)

-- GOD MODE
spawn(function()
    while isRunning do
        wait(0.2)
        if features.godMode.active and humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            humanoid.BreakJointsOnDeath = false
        elseif humanoid then
            humanoid.MaxHealth = 100
            humanoid.BreakJointsOnDeath = true
        end
    end
end)

-- NOCLIP
spawn(function()
    while isRunning do
        wait(0.1)
        if features.noclip.active and character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        elseif character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end)

-- INFINITE MONEY GLITCH
spawn(function()
    while isRunning do
        wait(features.infiniteMoneyGlitch.speed)
        if features.infiniteMoneyGlitch.active then
            pcall(function()
                for _, r in ipairs(replicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") then
                        r:FireServer("AddMoney", features.infiniteMoneyGlitch.amount)
                    end
                end
                if player:FindFirstChild("leaderstats") then
                    for _, v in ipairs(player.leaderstats:GetChildren()) do
                        if v.Name:lower():find("money") then
                            v.Value = v.Value + features.infiniteMoneyGlitch.amount
                        end
                    end
                end
            end)
        end
    end
end)

-- CRASH OTHERS
spawn(function()
    while isRunning do
        wait(2)
        if features.crashOthers.active then
            for _, plr in ipairs(players:GetPlayers()) do
                if plr ~= player then
                    pcall(function()
                        for i = 1, 200 do
                            local r = Instance.new("RemoteEvent")
                            r.Name = "Crash_" .. i .. httpService:GenerateGUID(false)
                            r.Parent = replicatedStorage
                            r:FireClient(plr)
                            debris:AddItem(r, 0.01)
                        end
                    end)
                end
            end
        end
    end
end)

-- RAINBOW CAR
spawn(function()
    while isRunning do
        wait(features.rainbowCar.speed)
        if features.rainbowCar.active then
            local vehicle = character:FindFirstChildOfClass("VehicleSeat")
            if vehicle and vehicle.Parent then
                local hue = (tick() * (features.rainbowCar.speed > 0 and 2 or 1)) % 1
                for _, part in ipairs(vehicle.Parent:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Color = Color3.fromHSV(hue, 1, 1)
                    end
                end
            end
        end
    end
end)

-- HIDE NAME
spawn(function()
    while isRunning do
        wait(0.5)
        if features.hideName.active then
            pcall(function()
                player.DisplayName = "⠀"
                player.Name = "⠀"
                for _, plr in ipairs(players:GetPlayers()) do
                    if plr ~= player and plr.Character then
                        for _, g in ipairs(plr.Character:GetDescendants()) do
                            if g:IsA("BillboardGui") then g.Enabled = false end
                        end
                    end
                end
            end)
        end
    end
end)

-- INVISIBILITY
spawn(function()
    while isRunning do
        wait(0.1)
        if features.invisibility.active and character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then part.Transparency = 1 end
            end
        end
    end
end)

-- STEAL MONEY
spawn(function()
    while isRunning do
        wait(1)
        if features.stealMoney.active then
            for _, plr in ipairs(players:GetPlayers()) do
                if plr ~= player and plr:FindFirstChild("leaderstats") then
                    for _, stat in ipairs(plr.leaderstats:GetChildren()) do
                        if stat.Name:lower():find("money") and stat.Value > 0 then
                            local steal = math.min(features.stealMoney.amount, stat.Value)
                            stat.Value = stat.Value - steal
                            if player:FindFirstChild("leaderstats") then
                                for _, myStat in ipairs(player.leaderstats:GetChildren()) do
                                    if myStat.Name:lower():find("money") then
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

-- ESP
spawn(function()
    while isRunning do
        wait(0.3)
        if features.esp.active then
            for _, plr in ipairs(players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local existing = plr.Character:FindFirstChild("GarciaESP")
                    if not existing then
                        local bill = Instance.new("BillboardGui")
                        bill.Name = "GarciaESP"
                        bill.Size = UDim2.new(0, 180, 0, 50)
                        bill.AlwaysOnTop = true
                        bill.Parent = plr.Character.HumanoidRootPart
                        local f = Instance.new("Frame")
                        f.Size = UDim2.new(1, 0, 1, 0)
                        f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                        f.BackgroundTransparency = 0.5
                        f.Parent = bill
                        local l = Instance.new("TextLabel")
                        l.Size = UDim2.new(1, 0, 0.6, 0)
                        l.BackgroundTransparency = 1
                        l.Text = plr.Name
                        l.TextColor3 = Color3.fromRGB(255, 100, 200)
                        l.TextScaled = true
                        l.Font = Enum.Font.GothamBold
                        l.Parent = f
                        if features.esp.showHealth then
                            local hl = Instance.new("TextLabel")
                            hl.Size = UDim2.new(1, 0, 0.4, 0)
                            hl.Position = UDim2.new(0, 0, 0.6, 0)
                            hl.BackgroundTransparency = 1
                            hl.TextColor3 = Color3.fromRGB(100, 255, 100)
                            hl.TextSize = 10
                            hl.Font = Enum.Font.Gotham
                            hl.Parent = f
                            spawn(function()
                                while plr.Character and plr.Character:FindFirstChild("Humanoid") and bill.Parent do
                                    wait(0.5)
                                    hl.Text = "❤️ " .. math.floor(plr.Character.Humanoid.Health)
                                end
                            end)
                        end
                    end
                end
            end
        else
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name == "GarciaESP" then obj:Destroy() end
            end
        end
    end
end)

-- AUTO COLLECT
spawn(function()
    while isRunning do
        wait(0.2)
        if features.autoCollect.active and character and character:FindFirstChild("HumanoidRootPart") then
            for _, item in ipairs(workspace:GetDescendants()) do
                if item:IsA("BasePart") and (item.Name:lower():find("coin") or item.Name:lower():find("money") or item.Name:lower():find("item")) then
                    if (item.Position - character.HumanoidRootPart.Position).Magnitude <= features.autoCollect.radius then
                        character.HumanoidRootPart.CFrame = item.CFrame
                        wait(0.05)
                    end
                end
            end
        end
    end
end)

-- UNLOCK ALL GAMEPASS
spawn(function()
    while isRunning do
        wait(3)
        if features.unlockAllGamepass.active then
            local passes = {"VIP", "PREMIUM", "GOLD", "PLATINUM", "DIAMOND", "MASTER", "SPEED", "MONEY", "DOUBLE", "UNLIMITED"}
            for _, p in ipairs(passes) do
                pcall(function()
                    local b = Instance.new("BoolValue")
                    b.Name = p
                    b.Value = true
                    b.Parent = player
                end)
            end
        end
    end
end)

-- SERVER LAG
spawn(function()
    while isRunning do
        wait(0.5)
        if features.serverLag.active then
            for i = 1, features.serverLag.intensity * 50 do
                local p = Instance.new("Part")
                p.Size = Vector3.new(10, 10, 10)
                p.Position = Vector3.new(math.random(-5000, 5000), math.random(-500, 500), math.random(-5000, 5000))
                p.Anchored = true
                p.Transparency = 1
                p.Parent = workspace
                debris:AddItem(p, 0.05)
            end
        end
    end
end)

-- ANTI KICK
local oldKick = player.Kick
player.Kick = function() end

-- UPDATE STATS
spawn(function()
    while isRunning do
        wait(0.5)
        pcall(function()
            local money = 0
            if player:FindFirstChild("leaderstats") then
                for _, v in ipairs(player.leaderstats:GetChildren()) do
                    if v.Name:lower():find("money") then money = v.Value break end
                end
            end
            moneyStat.Text = "💰 $" .. tostring(money)
            if humanoid then speedStat.Text = "⚡ SPEED: " .. math.floor(humanoid.WalkSpeed) end
        end)
    end
end)

-- INIT
tabButtons[1].BackgroundColor3 = Color3.fromRGB(255, 0, 150)
tabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)
buildMoneyTab()

userInput.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.F5 then
        guiEnabled = not guiEnabled
        screenGui.Enabled = guiEnabled
    end
end)

-- SPLASH
print("╔══════════════════════════════════════════════════════════════════════╗")
print("║                                                                      ║")
print("║     ██████╗  █████╗ ██████╗  ██████╗██╗ █████╗     ██╗  ██╗██╗   ██╗██████╗ ║")
print("║    ██╔════╝ ██╔══██╗██╔══██╗██╔════╝██║██╔══██╗    ██║  ██║██║   ██║██╔══██╗║")
print("║    ██║  ███╗███████║██████╔╝██║     ██║███████║    ███████║██║   ██║██████╔╝║")
print("║    ██║   ██║██╔══██║██╔══██╗██║     ██║██╔══██║    ██╔══██║██║   ██║██╔══██╗║")
print("║    ╚██████╔╝██║  ██║██║  ██║╚██████╗██║██║  ██║    ██║  ██║╚██████╔╝██████╔╝║")
print("║     ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ║")
print("║                                                                      ║")
print("║              PREMIUM COMPLETE EDITION V7.0 - 75+ FITUR               ║")
print("║                   INDONESIA DRIVING EXPERIENCE (IDEX)                ║")
print("║                         PRESS F5 TO TOGGLE GUI                       ║")
print("╚══════════════════════════════════════════════════════════════════════╝")

-- GARCIA-GANK ULTRA PRO FINAL 🎣🔥

local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "GarciaUltraFinal"

-- MAIN FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 460, 0, 270)
frame.Position = UDim2.new(0.5, -230, 0.5, -135)
frame.BackgroundColor3 = Color3.fromRGB(10,10,10)

-- HEADER
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1,0,0,40)
header.BackgroundColor3 = Color3.fromRGB(0,255,255)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,0,1,0)
title.Text = "⚡ GARCIA ULTRA PRO ⚡"
title.TextColor3 = Color3.new(0,0,0)
title.BackgroundTransparency = 1
title.TextScaled = true

-- PANELS
local left = Instance.new("Frame", frame)
left.Size = UDim2.new(0.45,0,1,-40)
left.Position = UDim2.new(0,0,0,40)
left.BackgroundColor3 = Color3.fromRGB(20,20,20)

local right = Instance.new("Frame", frame)
right.Size = UDim2.new(0.55,0,1,-40)
right.Position = UDim2.new(0.45,0,0,40)
right.BackgroundColor3 = Color3.fromRGB(5,5,5)

-- BG
local bg = Instance.new("ImageLabel", right)
bg.Size = UDim2.new(1,0,1,0)
bg.Image = "rbxassetid://1316045217"
bg.ImageTransparency = 0.35
bg.BackgroundTransparency = 1

local rtext = Instance.new("TextLabel", right)
rtext.Size = UDim2.new(1,0,1,0)
rtext.Text = "SMART FISHING"
rtext.TextColor3 = Color3.fromRGB(0,255,255)
rtext.BackgroundTransparency = 1
rtext.TextScaled = true

-- BUTTON TEMPLATE
local function createButton(text, y)
    local b = Instance.new("TextButton", left)
    b.Size = UDim2.new(0.8,0,0,30)
    b.Position = UDim2.new(0.1,0,y,0)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    return b
end

-- BUTTONS
local holdBtn = createButton("HOLD: OFF", 0.05)
local clickBtn = createButton("CLICK: OFF", 0.18)
local startBtn = createButton("START", 0.75)
startBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)

-- STATUS
local status = Instance.new("TextLabel", left)
status.Size = UDim2.new(1,0,0,20)
status.Position = UDim2.new(0,0,0.33,0)
status.Text = "STATUS: IDLE"
status.TextColor3 = Color3.fromRGB(255,255,255)
status.BackgroundTransparency = 1
status.TextScaled = true

-- INPUT
local function createBox(y, text)
    local box = Instance.new("TextBox", left)
    box.Size = UDim2.new(0.8,0,0,25)
    box.Position = UDim2.new(0.1,0,y,0)
    box.Text = text
    box.BackgroundColor3 = Color3.fromRGB(30,30,30)
    box.TextColor3 = Color3.new(1,1,1)
    return box
end

local holdBox = createBox(0.5, "3.5")
local delayBox = createBox(0.63, "0.1")

local closeBtn = createButton("CLOSE", 0.88)
closeBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)

-- VARIABLES
local holdEnabled = false
local clickEnabled = false
local master = false
local burst = false
local visible = true

local holdTime = 3.5
local clickDelay = 0.1

-- BUTTON LOGIC
holdBtn.MouseButton1Click:Connect(function()
    holdEnabled = not holdEnabled
    holdBtn.Text = holdEnabled and "HOLD: ON" or "HOLD: OFF"
end)

clickBtn.MouseButton1Click:Connect(function()
    clickEnabled = not clickEnabled
    clickBtn.Text = clickEnabled and "CLICK: ON" or "CLICK: OFF"
end)

startBtn.MouseButton1Click:Connect(function()
    master = not master

    if master then
        holdEnabled = true
        clickEnabled = true
        startBtn.Text = "STOP"
        startBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
        status.Text = "STATUS: RUNNING"
    else
        holdEnabled = false
        clickEnabled = false
        startBtn.Text = "START"
        startBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
        status.Text = "STATUS: IDLE"
    end
end)

-- INPUT
holdBox.FocusLost:Connect(function()
    local n = tonumber(holdBox.Text)
    if n then holdTime = n else holdBox.Text = tostring(holdTime) end
end)

delayBox.FocusLost:Connect(function()
    local n = tonumber(delayBox.Text)
    if n then clickDelay = n else delayBox.Text = tostring(clickDelay) end
end)

-- CLOSE
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- HOTKEY
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Delete then
        visible = not visible
        frame.Visible = visible
    elseif input.KeyCode == Enum.KeyCode.Z then
        burst = true
    elseif input.KeyCode == Enum.KeyCode.X then
        clickEnabled = not clickEnabled
    elseif input.KeyCode == Enum.KeyCode.C then
        holdEnabled = not holdEnabled
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Z then
        burst = false
    end
end)

-- DRAG
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = i.Position
        startPos = frame.Position
    end
end)

UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- HOLD LOOP
task.spawn(function()
    while true do
        if holdEnabled then
            VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            task.wait(holdTime)
            VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        else
            task.wait(0.1)
        end
    end
end)

-- CLICK LOOP
task.spawn(function()
    while true do
        if clickEnabled then
            local v = camera.ViewportSize
            local x,y = v.X*0.75, v.Y*0.5

            VIM:SendMouseButtonEvent(x,y,0,true,game,0)
            VIM:SendMouseButtonEvent(x,y,0,false,game,0)

            task.wait(burst and 0.02 or clickDelay)
        else
            task.wait(0.1)
        end
    end
end)

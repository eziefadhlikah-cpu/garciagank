-- GARCIA-GANK ELITE HUB (ULTIMATE CONTROL)

local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "GarciaGankHub"

-- FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 420, 0, 230)
frame.Position = UDim2.new(0.5, -210, 0.5, -115)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "⚡ GARCIA-GANK ELITE ⚡"
title.TextColor3 = Color3.fromRGB(0,255,255)
title.BackgroundTransparency = 1
title.TextScaled = true

-- LEFT PANEL
local leftPanel = Instance.new("Frame", frame)
leftPanel.Size = UDim2.new(0.45,0,1,-40)
leftPanel.Position = UDim2.new(0,0,0,40)
leftPanel.BackgroundColor3 = Color3.fromRGB(25,25,25)

-- RIGHT PANEL
local rightPanel = Instance.new("Frame", frame)
rightPanel.Size = UDim2.new(0.55,0,1,-40)
rightPanel.Position = UDim2.new(0.45,0,0,40)
rightPanel.BackgroundColor3 = Color3.fromRGB(10,10,10)

-- BG IMAGE
local bg = Instance.new("ImageLabel", rightPanel)
bg.Size = UDim2.new(1,0,1,0)
bg.Image = "rbxassetid://1316045217"
bg.ImageTransparency = 0.3
bg.BackgroundTransparency = 1

-- GRADIENT
local grad = Instance.new("UIGradient", bg)
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,255))
}

-- LABEL
local rightLabel = Instance.new("TextLabel", rightPanel)
rightLabel.Size = UDim2.new(1,0,1,0)
rightLabel.Text = "GARCIA-GANK"
rightLabel.TextColor3 = Color3.fromRGB(255,255,255)
rightLabel.BackgroundTransparency = 1
rightLabel.TextScaled = true

-- START BUTTON
local startBtn = Instance.new("TextButton", leftPanel)
startBtn.Size = UDim2.new(0.8,0,0,30)
startBtn.Position = UDim2.new(0.1,0,0.08,0)
startBtn.Text = "START"
startBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)

-- STATUS
local status = Instance.new("TextLabel", leftPanel)
status.Size = UDim2.new(1,0,0,20)
status.Position = UDim2.new(0,0,0.3,0)
status.Text = "STATUS: OFF"
status.TextColor3 = Color3.fromRGB(255,0,0)
status.BackgroundTransparency = 1
status.TextScaled = true

-- HOLD INPUT
local holdBox = Instance.new("TextBox", leftPanel)
holdBox.Size = UDim2.new(0.8,0,0,25)
holdBox.Position = UDim2.new(0.1,0,0.45,0)
holdBox.PlaceholderText = "Hold Time (detik)"
holdBox.Text = "3.5"
holdBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
holdBox.TextColor3 = Color3.new(1,1,1)

-- LOOP DELAY INPUT
local delayBox = Instance.new("TextBox", leftPanel)
delayBox.Size = UDim2.new(0.8,0,0,25)
delayBox.Position = UDim2.new(0.1,0,0.6,0)
delayBox.PlaceholderText = "Loop Delay (0.1 / 0.05 / 0.03)"
delayBox.Text = "0.1"
delayBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
delayBox.TextColor3 = Color3.new(1,1,1)

-- BUTTONS
local hideBtn = Instance.new("TextButton", leftPanel)
hideBtn.Size = UDim2.new(0.35,0,0,25)
hideBtn.Position = UDim2.new(0.1,0,0.8,0)
hideBtn.Text = "HIDE"

local closeBtn = Instance.new("TextButton", leftPanel)
closeBtn.Size = UDim2.new(0.35,0,0,25)
closeBtn.Position = UDim2.new(0.55,0,0.8,0)
closeBtn.Text = "CLOSE"
closeBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)

-- DRAG
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- VARIABLES
local running = false
local visible = true
local holdTime = 3.5
local loopDelay = 0.1

-- BUTTON LOGIC
startBtn.MouseButton1Click:Connect(function()
    running = not running
    startBtn.Text = running and "STOP" or "START"
    status.Text = running and "STATUS: ON" or "STATUS: OFF"
end)

-- INPUT LOGIC
holdBox.FocusLost:Connect(function()
    local n = tonumber(holdBox.Text)
    if n then holdTime = n else holdBox.Text = tostring(holdTime) end
end)

delayBox.FocusLost:Connect(function()
    local n = tonumber(delayBox.Text)
    if n then loopDelay = n else delayBox.Text = tostring(loopDelay) end
end)

-- HIDE / CLOSE
hideBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- KEYBIND
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Delete then
        visible = not visible
        frame.Visible = visible
    end
end)

-- LOOP
task.spawn(function()
    while true do
        if running then
            VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)

            local viewport = camera.ViewportSize
            local x = viewport.X * 0.75
            local y = viewport.Y * 0.5

            local steps = math.floor(holdTime / loopDelay)

            for i = 1, steps do
                VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
                VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
                task.wait(loopDelay)
            end

            VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)

            task.wait(0.05)
        else
            task.wait(0.1)
        end
    end
end)

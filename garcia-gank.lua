-- GARCIA-GANK ELITE HUB 🔥

local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "GarciaGankHub"

-- FRAME UTAMA (LEBAR)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 420, 0, 180)
frame.Position = UDim2.new(0.5, -210, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "⚡ GARCIA-GANK ELITE ⚡"
title.TextColor3 = Color3.fromRGB(0,255,255)
title.BackgroundTransparency = 1
title.TextScaled = true

-- PANEL KIRI (FITUR)
local leftPanel = Instance.new("Frame", frame)
leftPanel.Size = UDim2.new(0.45,0,1,-40)
leftPanel.Position = UDim2.new(0,0,0,40)
leftPanel.BackgroundColor3 = Color3.fromRGB(25,25,25)

-- PANEL KANAN (KOSONG / ELITE LOOK)
local rightPanel = Instance.new("Frame", frame)
rightPanel.Size = UDim2.new(0.55,0,1,-40)
rightPanel.Position = UDim2.new(0.45,0,0,40)
rightPanel.BackgroundColor3 = Color3.fromRGB(10,10,10)

-- LABEL KANAN
local rightLabel = Instance.new("TextLabel", rightPanel)
rightLabel.Size = UDim2.new(1,0,1,0)
rightLabel.Text = "COMING SOON"
rightLabel.TextColor3 = Color3.fromRGB(100,100,100)
rightLabel.BackgroundTransparency = 1
rightLabel.TextScaled = true

-- BUTTON START
local startBtn = Instance.new("TextButton", leftPanel)
startBtn.Size = UDim2.new(0.8,0,0,40)
startBtn.Position = UDim2.new(0.1,0,0.2,0)
startBtn.Text = "START"
startBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.TextScaled = true

-- STATUS
local status = Instance.new("TextLabel", leftPanel)
status.Size = UDim2.new(1,0,0,30)
status.Position = UDim2.new(0,0,0.6,0)
status.Text = "STATUS: OFF"
status.TextColor3 = Color3.fromRGB(255,0,0)
status.BackgroundTransparency = 1
status.TextScaled = true

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

-- LOGIC
local running = false

startBtn.MouseButton1Click:Connect(function()
    running = not running
    startBtn.Text = running and "STOP" or "START"
    startBtn.BackgroundColor3 = running and Color3.fromRGB(170,0,0) or Color3.fromRGB(0,170,0)
    
    status.Text = running and "STATUS: ON" or "STATUS: OFF"
    status.TextColor3 = running and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
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

            for i = 1, 35 do
                VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
                VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
                task.wait(0.1)
            end

            VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)

            task.wait(0.05)
        else
            task.wait(0.1)
        end
    end
end)

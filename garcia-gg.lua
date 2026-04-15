-- GARCIA - GANK Auto W/S GUI

local CoreGui = game:GetService("CoreGui")
local VIM = game:GetService("VirtualInputManager")

pcall(function()
    CoreGui["GARCIA - GANK"]:Destroy()
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GARCIA - GANK"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0,270,0,160)
Main.Position = UDim2.new(0.5,-135,0.5,-80)
Main.BackgroundColor3 = Color3.fromRGB(15,15,20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0,170,255)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1,0,0,38)
Title.BackgroundTransparency = 1
Title.Text = "GARCIA - GANK"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 24
Title.TextColor3 = Color3.fromRGB(255,255,255)

local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = Main
Subtitle.Position = UDim2.new(0,0,0,30)
Subtitle.Size = UDim2.new(1,0,0,20)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "AUTO W / S"
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 14
Subtitle.TextColor3 = Color3.fromRGB(0,170,255)

local Status = Instance.new("TextLabel")
Status.Parent = Main
Status.Position = UDim2.new(0,0,0,58)
Status.Size = UDim2.new(1,0,0,22)
Status.BackgroundTransparency = 1
Status.Text = "STATUS : OFF"
Status.Font = Enum.Font.GothamBold
Status.TextSize = 16
Status.TextColor3 = Color3.fromRGB(255,80,80)

local Toggle = Instance.new("TextButton")
Toggle.Parent = Main
Toggle.Size = UDim2.new(0,210,0,50)
Toggle.Position = UDim2.new(0.5,-105,0,95)
Toggle.BackgroundColor3 = Color3.fromRGB(35,35,45)
Toggle.Text = "START"
Toggle.Font = Enum.Font.GothamBlack
Toggle.TextSize = 22
Toggle.TextColor3 = Color3.fromRGB(255,255,255)

Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0,14)

local ToggleStroke = Instance.new("UIStroke", Toggle)
ToggleStroke.Color = Color3.fromRGB(0,170,255)
ToggleStroke.Thickness = 2

local Close = Instance.new("TextButton")
Close.Parent = Main
Close.Size = UDim2.new(0,30,0,30)
Close.Position = UDim2.new(1,-38,0,8)
Close.BackgroundColor3 = Color3.fromRGB(255,60,60)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255,255,255)
Close.Font = Enum.Font.GothamBlack
Close.TextSize = 16

Instance.new("UICorner", Close).CornerRadius = UDim.new(1,0)

local Minimize = Instance.new("TextButton")
Minimize.Parent = Main
Minimize.Size = UDim2.new(0,30,0,30)
Minimize.Position = UDim2.new(1,-74,0,8)
Minimize.BackgroundColor3 = Color3.fromRGB(255,200,0)
Minimize.Text = "-"
Minimize.TextColor3 = Color3.fromRGB(255,255,255)
Minimize.Font = Enum.Font.GothamBlack
Minimize.TextSize = 18

Instance.new("UICorner", Minimize).CornerRadius = UDim.new(1,0)

local Mini = Instance.new("TextButton")
Mini.Parent = ScreenGui
Mini.Visible = false
Mini.Size = UDim2.new(0,65,0,65)
Mini.Position = UDim2.new(0,20,0.5,-32)
Mini.BackgroundColor3 = Color3.fromRGB(15,15,20)
Mini.Text = "GG"
Mini.TextColor3 = Color3.fromRGB(255,255,255)
Mini.Font = Enum.Font.GothamBlack
Mini.TextSize = 22
Mini.Active = true
Mini.Draggable = true

Instance.new("UICorner", Mini).CornerRadius = UDim.new(1,0)

local MiniStroke = Instance.new("UIStroke", Mini)
MiniStroke.Color = Color3.fromRGB(0,170,255)
MiniStroke.Thickness = 2

local enabled = false
local delayTime = 1.5

task.spawn(function()
    while task.wait() do
        if enabled then
            VIM:SendKeyEvent(true, Enum.KeyCode.W, false, game)
            task.wait(delayTime)
            VIM:SendKeyEvent(false, Enum.KeyCode.W, false, game)

            if not enabled then
                continue
            end

            VIM:SendKeyEvent(true, Enum.KeyCode.S, false, game)
            task.wait(delayTime)
            VIM:SendKeyEvent(false, Enum.KeyCode.S, false, game)
        end
    end
end)

Toggle.MouseButton1Click:Connect(function()
    enabled = not enabled

    if enabled then
        Toggle.Text = "STOP"
        Toggle.BackgroundColor3 = Color3.fromRGB(0,170,100)
        Status.Text = "STATUS : ON"
        Status.TextColor3 = Color3.fromRGB(0,255,120)
    else
        Toggle.Text = "START"
        Toggle.BackgroundColor3 = Color3.fromRGB(35,35,45)
        Status.Text = "STATUS : OFF"
        Status.TextColor3 = Color3.fromRGB(255,80,80)

        VIM:SendKeyEvent(false, Enum.KeyCode.W, false, game)
        VIM:SendKeyEvent(false, Enum.KeyCode.S, false, game)
    end
end)

Close.MouseButton1Click:Connect(function()
    enabled = false
    VIM:SendKeyEvent(false, Enum.KeyCode.W, false, game)
    VIM:SendKeyEvent(false, Enum.KeyCode.S, false, game)
    ScreenGui:Destroy()
end)

Minimize.MouseButton1Click:Connect(function()
    Main.Visible = false
    Mini.Visible = true
end)

Mini.MouseButton1Click:Connect(function()
    Main.Visible = true
    Mini.Visible = false
end)

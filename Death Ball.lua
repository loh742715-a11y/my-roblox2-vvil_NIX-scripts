local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Is_Enabled = true
local DistanceThreshold = 6.5
local MenuVisible = true
local ToggleKey = Enum.KeyCode.R
local WaitingForBind = false


local function Notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = 2;
        })
    end)
end


local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoParryMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 190, 0, 155)
MainFrame.Position = UDim2.new(0.5, -95, 0.35, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 1.5
Stroke.Color = Color3.fromRGB(255, 120, 190)
Stroke.Transparency = 0.2
Stroke.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame


local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 28)
TitleBar.BackgroundColor3 = Color3.fromRGB(5, 5, 9)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "⁎vvil_NIX⁎"
Title.TextColor3 = Color3.fromRGB(255, 105, 180)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = TitleBar


local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 18)
Status.Position = UDim2.new(0, 10, 0, 36)
Status.BackgroundTransparency = 1
Status.Text = "Auto Parry OFF"
Status.TextColor3 = Color3.fromRGB(170, 170, 170)
Status.TextSize = 13
Status.Font = Enum.Font.GothamSemibold
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = MainFrame


local BindLabel = Instance.new("TextButton")
BindLabel.Size = UDim2.new(1, -20, 0, 28)
BindLabel.Position = UDim2.new(0, 10, 0, 60)
BindLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BindLabel.Text = "Toggle Key: R"
BindLabel.TextColor3 = Color3.fromRGB(255, 200, 220)
BindLabel.TextSize = 14
BindLabel.Font = Enum.Font.GothamSemibold
BindLabel.Parent = MainFrame

local BindStroke = Instance.new("UIStroke")
BindStroke.Thickness = 1.5
BindStroke.Color = Color3.fromRGB(255, 120, 190)
BindStroke.Transparency = 0.3
BindStroke.Parent = BindLabel

local BindCorner = Instance.new("UICorner")
BindCorner.CornerRadius = UDim.new(0, 8)
BindCorner.Parent = BindLabel


local DistanceLabel = Instance.new("TextLabel")
DistanceLabel.Size = UDim2.new(1, -20, 0, 18)
DistanceLabel.Position = UDim2.new(0, 10, 0, 94)
DistanceLabel.BackgroundTransparency = 1
DistanceLabel.Text = "Distance: 6.5"
DistanceLabel.TextColor3 = Color3.fromRGB(255, 200, 220)
DistanceLabel.TextSize = 14
DistanceLabel.Font = Enum.Font.GothamSemibold
DistanceLabel.TextXAlignment = Enum.TextXAlignment.Left
DistanceLabel.Parent = MainFrame


local MinusBtn = Instance.new("TextButton")
MinusBtn.Size = UDim2.new(0, 40, 0, 28)
MinusBtn.Position = UDim2.new(0, 15, 0, 118)
MinusBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MinusBtn.Text = "-"
MinusBtn.TextColor3 = Color3.fromRGB(255, 120, 190)
MinusBtn.TextSize = 20
MinusBtn.Font = Enum.Font.GothamBold
MinusBtn.Parent = MainFrame

local PlusBtn = Instance.new("TextButton")
PlusBtn.Size = UDim2.new(0, 40, 0, 28)
PlusBtn.Position = UDim2.new(1, -55, 0, 118)
PlusBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
PlusBtn.Text = "+"
PlusBtn.TextColor3 = Color3.fromRGB(255, 120, 190)
PlusBtn.TextSize = 20
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.Parent = MainFrame

local function StyleButton(btn)
    local s = Instance.new("UIStroke")
    s.Thickness = 1.5
    s.Color = Color3.fromRGB(255, 120, 190)
    s.Transparency = 0.2
    s.Parent = btn

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
end

StyleButton(MinusBtn)
StyleButton(PlusBtn)

local function UpdateDistanceLabel()
    DistanceLabel.Text = string.format("Distance: %.1f", DistanceThreshold)
end

local function UpdateBindLabel()
    BindLabel.Text = "Toggle Key: " .. ToggleKey.Name
end


MinusBtn.MouseButton1Click:Connect(function()
    DistanceThreshold = math.max(1, DistanceThreshold - 0.1)
    UpdateDistanceLabel()
end)

PlusBtn.MouseButton1Click:Connect(function()
    DistanceThreshold = DistanceThreshold + 0.1
    UpdateDistanceLabel()
end)


BindLabel.MouseButton1Click:Connect(function()
    WaitingForBind = true
    BindLabel.Text = "Натисни нову клавішу..."
    BindLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
end)


local ToggleFrame = Instance.new("Frame")
ToggleFrame.Size = UDim2.new(0, 36, 0, 18)
ToggleFrame.Position = UDim2.new(1, -48, 0, 36)
ToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
ToggleFrame.BorderSizePixel = 0
ToggleFrame.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleFrame

local ToggleCircle = Instance.new("Frame")
ToggleCircle.Size = UDim2.new(0, 14, 0, 14)
ToggleCircle.Position = UDim2.new(0, 2, 0.5, -7)
ToggleCircle.BackgroundColor3 = Color3.fromRGB(220, 220, 230)
ToggleCircle.BorderSizePixel = 0
ToggleCircle.Parent = ToggleFrame

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = ToggleCircle


local CursorFolder = Instance.new("Folder")
CursorFolder.Name = "CustomCursor"
CursorFolder.Parent = ScreenGui

local Crosshair = Instance.new("Frame")
Crosshair.Name = "Crosshair"
Crosshair.Size = UDim2.new(0, 8, 0, 8)
Crosshair.BackgroundTransparency = 1
Crosshair.Visible = false
Crosshair.ZIndex = 10000
Crosshair.Parent = CursorFolder

local OutlineH = Instance.new("Frame")
OutlineH.Size = UDim2.new(0, 10, 0, 2)
OutlineH.Position = UDim2.new(0, -1, 0.5, -1)
OutlineH.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
OutlineH.BorderSizePixel = 0
OutlineH.Parent = Crosshair

local OutlineV = Instance.new("Frame")
OutlineV.Size = UDim2.new(0, 2, 0, 10)
OutlineV.Position = UDim2.new(0.5, -1, 0, -1)
OutlineV.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
OutlineV.BorderSizePixel = 0
OutlineV.Parent = Crosshair

local Horizontal = Instance.new("Frame")
Horizontal.Size = UDim2.new(0, 8, 0, 1)
Horizontal.Position = UDim2.new(0, 0, 0.5, -0.5)
Horizontal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Horizontal.BorderSizePixel = 0
Horizontal.Parent = Crosshair

local Vertical = Instance.new("Frame")
Vertical.Size = UDim2.new(0, 1, 0, 8)
Vertical.Position = UDim2.new(0.5, -0.5, 0, 0)
Vertical.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Vertical.BorderSizePixel = 0
Vertical.Parent = Crosshair

local cursorConnection

local function ShowCustomCursor()
    Crosshair.Visible = true
    UserInputService.MouseIconEnabled = false
    if cursorConnection then cursorConnection:Disconnect() end
    cursorConnection = RunService.RenderStepped:Connect(function()
        local mousePos = UserInputService:GetMouseLocation()
        Crosshair.Position = UDim2.new(0, mousePos.X - 3.2, 0, mousePos.Y - 5)
    end)
end

local function HideCustomCursor()
    Crosshair.Visible = false
    UserInputService.MouseIconEnabled = true
    if cursorConnection then
        cursorConnection:Disconnect()
        cursorConnection = nil
    end
end

MainFrame.MouseEnter:Connect(ShowCustomCursor)
MainFrame.MouseLeave:Connect(HideCustomCursor)


local function UpdateToggle()
    if Is_Enabled then
        Status.Text = "Auto Parry ON"
        Status.TextColor3 = Color3.fromRGB(255, 105, 180)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(255, 60, 150)
        ToggleCircle.Position = UDim2.new(0, 20, 0.5, -7)
    else
        Status.Text = "Auto Parry OFF"
        Status.TextColor3 = Color3.fromRGB(170, 170, 170)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        ToggleCircle.Position = UDim2.new(0, 2, 0.5, -7)
    end
end

ToggleFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Is_Enabled = not Is_Enabled
        UpdateToggle()
        Notify("vvil_NIX", Is_Enabled and "Auto Parry ON" or "Auto Parry OFF")
    end
end)


local dragging = false
local dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)


local function Is_Target()
    if not Is_Enabled then return false end
    local character = Player.Character
    if not character then return false end
    local Highlight = character:FindFirstChildOfClass("Highlight") or character:FindFirstChild("Highlight")
    if Highlight then
        return Highlight.Enabled and Highlight.FillTransparency ~= 1
    end
    return false
end

local function Parry()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
end

local function Start(Ball)
    if typeof(Ball) == "Instance" and Ball:IsA("MeshPart") then
        local Old_Position = Ball.Position
        task.spawn(function()
            local connection = Ball:GetPropertyChangedSignal("Position"):Connect(function()
                if not Ball or not Ball.Parent then
                    connection:Disconnect()
                    return
                end
                if Is_Target() then
                    local currentPos = Ball.Position
                    local camera = workspace.CurrentCamera
                    local cameraPos = camera and camera.Focus.Position or Vector3.new(0,0,0)
                    local Distance = (currentPos - cameraPos).Magnitude
                    local Velocity = (Old_Position - currentPos).Magnitude
                    if Velocity > 0.05 and Velocity < 500 then
                        if (Distance / Velocity) <= DistanceThreshold then
                            Parry()
                        end
                    end
                    Old_Position = currentPos
                else
                    Old_Position = Ball.Position
                end
            end)
        end)
    end
end

for _, v in ipairs(workspace:GetChildren()) do
    if v:IsA("MeshPart") and (v.Name == "Part" or v.Name:match("Ball")) then
        Start(v)
    end
end

workspace.ChildAdded:Connect(function(Ball)
    task.wait(0.01)
    if Ball:IsA("MeshPart") and (Ball.Name == "Part" or Ball.Name:match("Ball")) then
        Start(Ball)
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if WaitingForBind then
        if input.KeyCode ~= Enum.KeyCode.Unknown then
            ToggleKey = input.KeyCode
            WaitingForBind = false
            UpdateBindLabel()
            BindLabel.TextColor3 = Color3.fromRGB(255, 200, 220)
            Notify("vvil_NIX", "ToggleKey: " .. ToggleKey.Name)
        end
        return
    end

    if input.KeyCode == ToggleKey then
        Is_Enabled = not Is_Enabled
        UpdateToggle()
        Notify("vvil_NIX", Is_Enabled and "Auto Parry ON" or "Auto Parry OFF")
    elseif input.KeyCode == Enum.KeyCode.Equals or input.KeyCode == Enum.KeyCode.KeypadPlus then
        DistanceThreshold = DistanceThreshold + 0.1
        UpdateDistanceLabel()
        Notify("vvil_NIX", "Distance: " .. string.format("%.1f", DistanceThreshold))
    elseif input.KeyCode == Enum.KeyCode.Minus or input.KeyCode == Enum.KeyCode.KeypadMinus then
        DistanceThreshold = math.max(1, DistanceThreshold - 0.1)
        UpdateDistanceLabel()
        Notify("vvil_NIX", "Distance: " .. string.format("%.1f", DistanceThreshold))
    elseif input.KeyCode == Enum.KeyCode.X then
        MenuVisible = not MenuVisible
        MainFrame.Visible = MenuVisible
        if MenuVisible then
            Notify("vvil_NIX", "Меню увімкнено")
        else
            Notify("vvil_NIX", "Меню вимкнено (X - повернути)")
        end
    end
end)

UpdateToggle()
UpdateDistanceLabel()
UpdateBindLabel()
Notify("")

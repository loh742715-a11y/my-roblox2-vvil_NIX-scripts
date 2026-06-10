local runService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Is_Enabled = true
local DistanceThreshold = 6.5
local OriginalDistance = 6.5  
local MenuVisible = true
local ToggleKey = Enum.KeyCode.R
local WaitingForBind = false

local SpeedEnabled = true
local PushForce = 0.5

local NoclipEnabled = false
local NoclipConnection = nil

local TeleportEnabled = false
local TeleportConnection = nil
local TargetPosition = Vector3.new(721.1123657225652, 328.289306640625, 1476.4405517578125)

-- === НОВАЯ ФУНКЦИЯ АВТОФАРМА ===
local TeleportEnabled2 = false
local TeleportConnection2 = nil
local TargetPosition2 = Vector3.new(570.57, 284.59, -770.59)
-- =================================

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
MainFrame.Size = UDim2.new(0, 400, 0, 450)
MainFrame.Position = UDim2.new(0.5, -230, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
MainFrame.BackgroundTransparency = 0.5
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
Status.Size = UDim2.new(0.48, -20, 0, 18)
Status.Position = UDim2.new(0, 10, 0, 36)
Status.BackgroundTransparency = 1
Status.Text = "Auto Parry OFF"
Status.TextColor3 = Color3.fromRGB(170, 170, 170)
Status.TextSize = 13
Status.Font = Enum.Font.GothamSemibold
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = MainFrame

local ToggleFrame = Instance.new("Frame")
ToggleFrame.Size = UDim2.new(0, 36, 0, 18)
ToggleFrame.Position = UDim2.new(0.48, -55, 0, 36)
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

local BindLabel = Instance.new("TextButton")
BindLabel.Size = UDim2.new(0.48, -20, 0, 28)
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
DistanceLabel.Size = UDim2.new(0.48, -20, 0, 18)
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
PlusBtn.Position = UDim2.new(0.48, -65, 0, 118)
PlusBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
PlusBtn.Text = "+"
PlusBtn.TextColor3 = Color3.fromRGB(255, 120, 190)
PlusBtn.TextSize = 20
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.Parent = MainFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.48, -20, 0, 18)
SpeedLabel.Position = UDim2.new(0, 10, 0, 152)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed: 0.5"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 200, 220)
SpeedLabel.TextSize = 14
SpeedLabel.Font = Enum.Font.GothamSemibold
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = MainFrame

local SpeedMinusBtn = Instance.new("TextButton")
SpeedMinusBtn.Size = UDim2.new(0, 40, 0, 28)
SpeedMinusBtn.Position = UDim2.new(0, 15, 0, 176)
SpeedMinusBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SpeedMinusBtn.Text = "-"
SpeedMinusBtn.TextColor3 = Color3.fromRGB(255, 120, 190)
SpeedMinusBtn.TextSize = 20
SpeedMinusBtn.Font = Enum.Font.GothamBold
SpeedMinusBtn.Parent = MainFrame

local SpeedPlusBtn = Instance.new("TextButton")
SpeedPlusBtn.Size = UDim2.new(0, 40, 0, 28)
SpeedPlusBtn.Position = UDim2.new(0.48, -65, 0, 176)
SpeedPlusBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SpeedPlusBtn.Text = "+"
SpeedPlusBtn.TextColor3 = Color3.fromRGB(255, 120, 190)
SpeedPlusBtn.TextSize = 20
SpeedPlusBtn.Font = Enum.Font.GothamBold
SpeedPlusBtn.Parent = MainFrame

local SpeedToggleFrame = Instance.new("Frame")
SpeedToggleFrame.Size = UDim2.new(0, 36, 0, 18)
SpeedToggleFrame.Position = UDim2.new(0.48, -55, 0, 152)
SpeedToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
SpeedToggleFrame.BorderSizePixel = 0
SpeedToggleFrame.Parent = MainFrame

local SpeedToggleCorner = Instance.new("UICorner")
SpeedToggleCorner.CornerRadius = UDim.new(1, 0)
SpeedToggleCorner.Parent = SpeedToggleFrame

local SpeedToggleCircle = Instance.new("Frame")
SpeedToggleCircle.Size = UDim2.new(0, 14, 0, 14)
SpeedToggleCircle.Position = UDim2.new(0, 2, 0.5, -7)
SpeedToggleCircle.BackgroundColor3 = Color3.fromRGB(220, 220, 230)
SpeedToggleCircle.BorderSizePixel = 0
SpeedToggleCircle.Parent = SpeedToggleFrame

local SpeedToggleCircleCorner = Instance.new("UICorner")
SpeedToggleCircleCorner.CornerRadius = UDim.new(1, 0)
SpeedToggleCircleCorner.Parent = SpeedToggleCircle

local TimeLabel = Instance.new("TextLabel")
TimeLabel.Size = UDim2.new(0.48, -20, 0, 18)
TimeLabel.Position = UDim2.new(0, 10, 0, 210)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "Time of Day"
TimeLabel.TextColor3 = Color3.fromRGB(255, 200, 220)
TimeLabel.TextSize = 14
TimeLabel.Font = Enum.Font.GothamSemibold
TimeLabel.TextXAlignment = Enum.TextXAlignment.Left
TimeLabel.Parent = MainFrame

local DayBtn = Instance.new("TextButton")
DayBtn.Size = UDim2.new(0, 75, 0, 28)
DayBtn.Position = UDim2.new(0, 15, 0, 234)
DayBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DayBtn.Text = "Day"
DayBtn.TextColor3 = Color3.fromRGB(255, 120, 190)
DayBtn.TextSize = 16
DayBtn.Font = Enum.Font.GothamBold
DayBtn.Parent = MainFrame

local NightBtn = Instance.new("TextButton")
NightBtn.Size = UDim2.new(0, 75, 0, 28)
NightBtn.Position = UDim2.new(0.48, -90, 0, 234)
NightBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
NightBtn.Text = "Night"
NightBtn.TextColor3 = Color3.fromRGB(255, 120, 190)
NightBtn.TextSize = 16
NightBtn.Font = Enum.Font.GothamBold
NightBtn.Parent = MainFrame

local NoclipLabel = Instance.new("TextLabel")
NoclipLabel.Size = UDim2.new(0.48, -20, 0, 18)
NoclipLabel.Position = UDim2.new(0, 10, 0, 268)
NoclipLabel.BackgroundTransparency = 1
NoclipLabel.Text = "NoClip"
NoclipLabel.TextColor3 = Color3.fromRGB(255, 200, 220)
NoclipLabel.TextSize = 14
NoclipLabel.Font = Enum.Font.GothamSemibold
NoclipLabel.TextXAlignment = Enum.TextXAlignment.Left
NoclipLabel.Parent = MainFrame

local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Size = UDim2.new(0.48, -30, 0, 28)
NoclipBtn.Position = UDim2.new(0, 15, 0, 292)
NoclipBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
NoclipBtn.Text = "NoClip OFF"
NoclipBtn.TextColor3 = Color3.fromRGB(255, 120, 190)
NoclipBtn.TextSize = 16
NoclipBtn.Font = Enum.Font.GothamBold
NoclipBtn.Parent = MainFrame

local FarmLabel = Instance.new("TextLabel")
FarmLabel.Size = UDim2.new(0.48, -20, 0, 18)
FarmLabel.Position = UDim2.new(0, 10, 0, 326)
FarmLabel.BackgroundTransparency = 1
FarmLabel.Text = "Auto Farm Boss"
FarmLabel.TextColor3 = Color3.fromRGB(255, 200, 220)
FarmLabel.TextSize = 14
FarmLabel.Font = Enum.Font.GothamSemibold
FarmLabel.TextXAlignment = Enum.TextXAlignment.Left
FarmLabel.Parent = MainFrame

local FarmBtn = Instance.new("TextButton")
FarmBtn.Size = UDim2.new(0.48, -30, 0, 28)
FarmBtn.Position = UDim2.new(0, 15, 0, 350)
FarmBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FarmBtn.Text = "Farm OFF"
FarmBtn.TextColor3 = Color3.fromRGB(255, 120, 190)
FarmBtn.TextSize = 16
FarmBtn.Font = Enum.Font.GothamBold
FarmBtn.Parent = MainFrame

-- ==================== НОВЫЙ ФАРМ ====================
local FarmLabel2 = Instance.new("TextLabel")
FarmLabel2.Size = UDim2.new(0.48, -20, 0, 18)
FarmLabel2.Position = UDim2.new(0, 10, 0, 384)
FarmLabel2.BackgroundTransparency = 1
FarmLabel2.Text = "Auto Farm 2"
FarmLabel2.TextColor3 = Color3.fromRGB(255, 200, 220)
FarmLabel2.TextSize = 14
FarmLabel2.Font = Enum.Font.GothamSemibold
FarmLabel2.TextXAlignment = Enum.TextXAlignment.Left
FarmLabel2.Parent = MainFrame

local FarmBtn2 = Instance.new("TextButton")
FarmBtn2.Size = UDim2.new(0.48, -30, 0, 28)
FarmBtn2.Position = UDim2.new(0, 15, 0, 408)
FarmBtn2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FarmBtn2.Text = "Farm 2 OFF"
FarmBtn2.TextColor3 = Color3.fromRGB(255, 120, 190)
FarmBtn2.TextSize = 16
FarmBtn2.Font = Enum.Font.GothamBold
FarmBtn2.Parent = MainFrame
-- ===================================================

local TPLabel = Instance.new("TextLabel")
TPLabel.Size = UDim2.new(0.48, -20, 0, 18)
TPLabel.Position = UDim2.new(0.5, 10, 0, 36)
TPLabel.BackgroundTransparency = 1
TPLabel.Text = "Player TP"
TPLabel.TextColor3 = Color3.fromRGB(255, 200, 220)
TPLabel.TextSize = 14
TPLabel.Font = Enum.Font.GothamSemibold
TPLabel.TextXAlignment = Enum.TextXAlignment.Left
TPLabel.Parent = MainFrame

local TPScroll = Instance.new("ScrollingFrame")
TPScroll.Size = UDim2.new(0.48, -20, 0, 300)
TPScroll.Position = UDim2.new(0.5, 10, 0, 60)
TPScroll.BackgroundTransparency = 1
TPScroll.BorderSizePixel = 0
TPScroll.ScrollBarThickness = 5
TPScroll.Parent = MainFrame

local TPListLayout = Instance.new("UIListLayout")
TPListLayout.Padding = UDim.new(0, 4)
TPListLayout.Parent = TPScroll

local RefreshTPBtn = Instance.new("TextButton")
RefreshTPBtn.Size = UDim2.new(0, 100, 0, 28)
RefreshTPBtn.Position = UDim2.new(0.5, 10, 0, 370)
RefreshTPBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
RefreshTPBtn.Text = "🔄 Обновить"
RefreshTPBtn.TextColor3 = Color3.fromRGB(255, 120, 190)
RefreshTPBtn.TextSize = 14
RefreshTPBtn.Font = Enum.Font.GothamBold
RefreshTPBtn.Parent = MainFrame


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
StyleButton(SpeedMinusBtn)
StyleButton(SpeedPlusBtn)
StyleButton(DayBtn)
StyleButton(NightBtn)
StyleButton(NoclipBtn)
StyleButton(FarmBtn)
StyleButton(FarmBtn2)  -- новый
StyleButton(BindLabel)
StyleButton(RefreshTPBtn)


local function teleportTo(targetPlayer)
    local targetChar = targetPlayer.Character
    local myChar = player.Character
    if targetChar and targetChar:FindFirstChild("HumanoidRootPart") and myChar and myChar:FindFirstChild("HumanoidRootPart") then
        myChar.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame * CFrame.new(3, 2, 0)
        Notify("🚀 TP", "К " .. targetPlayer.DisplayName)
    end
end

local function updatePlayerList()
    for _, child in pairs(TPScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            btn.Text = p.DisplayName
            btn.TextColor3 = Color3.fromRGB(255, 200, 220)
            btn.TextSize = 14
            btn.Font = Enum.Font.GothamSemibold
            btn.Parent = TPScroll
            StyleButton(btn)
            
            btn.MouseButton1Click:Connect(function()
                teleportTo(p)
            end)
            btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55) end)
            btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0) end)
        end
    end
    TPScroll.CanvasSize = UDim2.new(0, 0, 0, TPListLayout.AbsoluteContentSize.Y + 10)
end

RefreshTPBtn.MouseButton1Click:Connect(updatePlayerList)
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)


local function UpdateDistanceLabel()
    DistanceLabel.Text = string.format("Distance: %.1f", DistanceThreshold)
end

local function UpdateSpeedLabel()
    SpeedLabel.Text = string.format("Speed: %.1f", PushForce)
end

local function UpdateBindLabel()
    BindLabel.Text = "Toggle Key: " .. ToggleKey.Name
end

local function UpdateNoclipLabel()
    NoclipBtn.Text = NoclipEnabled and "NoClip ON" or "NoClip OFF"
    NoclipBtn.TextColor3 = NoclipEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 120, 190)
end

local function UpdateFarmLabel()
    FarmBtn.Text = TeleportEnabled and "Farm ON" or "Farm OFF"
    FarmBtn.TextColor3 = TeleportEnabled and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 120, 190)
end

-- === Обновление для второй фермы ===
local function UpdateFarmLabel2()
    FarmBtn2.Text = TeleportEnabled2 and "Farm 2 ON" or "Farm 2 OFF"
    FarmBtn2.TextColor3 = TeleportEnabled2 and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 120, 190)
end

local function CreatePlatform(pos)
    local platform = Instance.new("Part")
    platform.Name = "TempPlatform"
    platform.Size = Vector3.new(12, 1, 12)
    platform.Position = pos - Vector3.new(0, 3.5, 0)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = 0.4
    platform.Color = Color3.fromRGB(255, 120, 190)
    platform.Material = Enum.Material.Neon
    platform.Parent = workspace
    task.delay(1.5, function()
        if platform and platform.Parent then platform:Destroy() end
    end)
end

local function ToggleFarm()
    TeleportEnabled = not TeleportEnabled
    if TeleportEnabled then
        OriginalDistance = DistanceThreshold
        DistanceThreshold = 9.5
        UpdateDistanceLabel()
        TeleportConnection = RunService.Heartbeat:Connect(function()
            if TeleportEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                hrp.CFrame = CFrame.new(TargetPosition + Vector3.new(0, 4, 0))
                CreatePlatform(TargetPosition)
            end
        end)
        Notify("vvil_NIX", "Auto Farm Boss ON (Distance: 9.5)")
    else
        DistanceThreshold = OriginalDistance
        UpdateDistanceLabel()
        if TeleportConnection then
            TeleportConnection:Disconnect()
            TeleportConnection = nil
        end
        Notify("vvil_NIX", "Auto Farm Boss OFF")
    end
    UpdateFarmLabel()
end

local function ToggleFarm2()
    TeleportEnabled2 = not TeleportEnabled2
    if TeleportEnabled2 then
        TeleportConnection2 = RunService.Heartbeat:Connect(function()
            if TeleportEnabled2 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                hrp.CFrame = CFrame.new(TargetPosition2 + Vector3.new(0, 4, 0))
                CreatePlatform(TargetPosition2)
            end
        end)
        Notify("vvil_NIX", "Auto Farm 2 ON")
    else
        if TeleportConnection2 then
            TeleportConnection2:Disconnect()
            TeleportConnection2 = nil
        end
        Notify("vvil_NIX", "Auto Farm 2 OFF")
    end
    UpdateFarmLabel2()
end

FarmBtn.MouseButton1Click:Connect(ToggleFarm)
FarmBtn2.MouseButton1Click:Connect(ToggleFarm2)  -- новая кнопка

MinusBtn.MouseButton1Click:Connect(function()
    DistanceThreshold = math.max(1, DistanceThreshold - 0.1)
    UpdateDistanceLabel()
end)

PlusBtn.MouseButton1Click:Connect(function()
    DistanceThreshold = DistanceThreshold + 0.1
    UpdateDistanceLabel()
end)

SpeedMinusBtn.MouseButton1Click:Connect(function()
    PushForce = math.max(0.1, PushForce - 0.1)
    UpdateSpeedLabel()
end)

SpeedPlusBtn.MouseButton1Click:Connect(function()
    PushForce = PushForce + 0.1
    UpdateSpeedLabel()
end)

local function UpdateSpeedToggle()
    if SpeedEnabled then
        SpeedToggleFrame.BackgroundColor3 = Color3.fromRGB(255, 60, 150)
        SpeedToggleCircle.Position = UDim2.new(0, 20, 0.5, -7)
    else
        SpeedToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        SpeedToggleCircle.Position = UDim2.new(0, 2, 0.5, -7)
    end
end

SpeedToggleFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        SpeedEnabled = not SpeedEnabled
        UpdateSpeedToggle()
        Notify("vvil_NIX", SpeedEnabled and "Speed ON" or "Speed OFF")
    end
end)

local function ToggleNoclip()
    NoclipEnabled = not NoclipEnabled
    if NoclipEnabled then
        NoclipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide == true then
                        part.CanCollide = false
                    end
                end
            end
        end)
        Notify("vvil_NIX", "NoClip Enabled")
    else
        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end
        Notify("vvil_NIX", "NoClip Disabled")
    end
    UpdateNoclipLabel()
end

NoclipBtn.MouseButton1Click:Connect(ToggleNoclip)

DayBtn.MouseButton1Click:Connect(function()
    Lighting.ClockTime = 14
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(200, 200, 200)
    Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = true
    Notify("vvil_NIX", "Set to Day")
end)

NightBtn.MouseButton1Click:Connect(function()
    Lighting.ClockTime = 2.5
    Lighting.Brightness = 0.4
    Lighting.Ambient = Color3.fromRGB(40, 45, 70)
    Lighting.OutdoorAmbient = Color3.fromRGB(35, 40, 65)
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = true
    Notify("vvil_NIX", "Set to Night")
end)

BindLabel.MouseButton1Click:Connect(function()
    WaitingForBind = true
    BindLabel.Text = "Press new key..."
    BindLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
end)

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
            Notify("vvil_NIX", "Menu Enabled")
        else
            Notify("vvil_NIX", "Menu Disabled (X to show)")
        end
    end
end)

runService.Heartbeat:Connect(function()
    if not SpeedEnabled then return end
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid
        if hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * PushForce)
        end
    end
end)

UpdateToggle()
UpdateDistanceLabel()
UpdateSpeedLabel()
UpdateBindLabel()
UpdateSpeedToggle()
UpdateNoclipLabel()
UpdateFarmLabel()
UpdateFarmLabel2()   -- новая
updatePlayerList()

Notify("vvil_NIX", "Auto Farm 2 добавлен!")

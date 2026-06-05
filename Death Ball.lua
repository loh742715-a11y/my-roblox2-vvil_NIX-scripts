local Players = game:GetService("Players")
local Virtual_Input_Manager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()

--
local Is_Enabled = true

--
local function Notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = 2;
        })
    end)
end

--
local function Is_Target()
    --
    if not Is_Enabled then return false end
    
    local character = Player.Character
    if not character then return false end
    
    --
    local Highlight = character:FindFirstChildOfClass("Highlight") or character:FindFirstChild("Highlight")
    
    -- 
    --
    if Highlight then
        return Highlight.Enabled and Highlight.FillTransparency ~= 1
    end
    return false
end

local function Parry()
    Virtual_Input_Manager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    Virtual_Input_Manager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
end

local function Start(Ball)
    if typeof(Ball) == "Instance" and Ball:IsA("MeshPart") then
        local Old_Position = Ball.Position
        
        --
        task.spawn(function()
            local connection
            connection = Ball:GetPropertyChangedSignal("Position"):Connect(function()
                --
                if not Ball or not Ball.Parent then 
                    if connection then connection:Disconnect() end
                    return 
                end
                
                if Is_Target() then
                    local currentPos = Ball.Position
                    local camera = workspace.CurrentCamera
                    local cameraPos = camera and camera.Focus.Position or Vector3.new(0,0,0)
                    
                    local Distance = (currentPos - cameraPos).Magnitude
                    local Velocity = (Old_Position - currentPos).Magnitude
                    
                    --
                    if Velocity > 0.05 and Velocity < 500 then
                        if (Distance / Velocity) <= 5.5 then
                            Parry()
                        end
                    end
                    Old_Position = currentPos
                else
                    --
                    Old_Position = Ball.Position
                end
            end)
        end)
    end
end

--
for _, v in ipairs(workspace:GetChildren()) do
    if v:IsA("MeshPart") and (v.Name == "Part" or v.Name:match("Ball")) then
        Start(v)
    end
end

--
workspace.ChildAdded:Connect(function(Ball)
    task.wait(0.01) --
    if Ball:IsA("MeshPart") and (Ball.Name == "Part" or Ball.Name:match("Ball")) then
        Start(Ball)
    end
end)

--
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    --
    if gameProcessedEvent then return end
    
    if input.KeyCode == Enum.KeyCode.R then
        Is_Enabled = not Is_Enabled
        if Is_Enabled then
            Notify("Auto Parry", "Скрипт ВКЛЮЧЕН (ON)")
        else
            Notify("Auto Parry", "Скрипт ВЫКЛЮЧЕН (OFF)")
        end
    end
end)

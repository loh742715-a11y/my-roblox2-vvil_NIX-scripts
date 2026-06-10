-- === Большое сообщение на экране Roblox ===
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаём GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BigMessageGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Большой TextLabel
local textLabel = Instance.new("TextLabel")
textLabel.Name = "BigMessage"
textLabel.Size = UDim2.new(0.9, 0, 0.6, 0)
textLabel.Position = UDim2.new(0.05, 0, 0.2, 0)
textLabel.BackgroundTransparency = 1
textLabel.TextColor3 = Color3.fromRGB(0, 255, 255) -- ярко-голубой
textLabel.TextScaled = true
textLabel.Font = Enum.Font.Arcade -- крутой шрифт
textLabel.TextStrokeTransparency = 0
textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
textLabel.Text = "AI\n\nЭТОТ СКРИПТ МОЙ\nСОРЯН"
textLabel.Parent = screenGui

-- Делаем текст ещё больше и красивым
textLabel.TextSize = 100

-- Добавляем небольшую анимацию (появление)
textLabel.TextTransparency = 1
for i = 1, 20 do
    textLabel.TextTransparency = 1 - (i/20)
    wait(0.03)
end

print("Большое сообщение показано!")

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- VARIABLES
local savedBasePosition = nil
local baseSpeed = 20
local burstSpeed = 21
local stepSize = 0.2
local stepDelay = 0.02
local burstDuration = 0.22 -- ربع ثانية
local normalDuration = 1   -- ثانية
local burstInterval = 1    -- تقريبًا كل ثانية

-- GUI SETUP
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BaseTPGui"
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- مربع يمين الشاشة
    local rightFrame = Instance.new("Frame")
    rightFrame.Size = UDim2.new(0, 150, 0, 40)
    rightFrame.Position = UDim2.new(1, -160, 0, 10) -- يمين فوق
    rightFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    rightFrame.Parent = screenGui

    local rightLabel = Instance.new("TextLabel")
    rightLabel.Size = UDim2.new(1, 0, 1, 0)
    rightLabel.Text = "حقوق البلوي"
    rightLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    rightLabel.BackgroundTransparency = 1
    rightLabel.Parent = rightFrame

    -- مربع يسار تحت
    local leftFrame = Instance.new("Frame")
    leftFrame.Size = UDim2.new(0, 150, 0, 40)
    leftFrame.Position = UDim2.new(0, 10, 1, -50) -- يسار تحت
    leftFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    leftFrame.Parent = screenGui

    local leftLabel = Instance.new("TextLabel")
    leftLabel.Size = UDim2.new(1, 0, 1, 0)
    leftLabel.Text = "حقوق البلوي"
    leftLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    leftLabel.BackgroundTransparency = 1
    leftLabel.Parent = leftFrame

    -- أزرار حفظ والذهاب للقاعدة
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 100)
    frame.Position = UDim2.new(0.05, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.Parent = screenGui

    local saveButton = Instance.new("TextButton")
    saveButton.Size = UDim2.new(0, 180, 0, 40)
    saveButton.Position = UDim2.new(0, 10, 0, 10)
    saveButton.Text = "احفظ مكانك يا كنق"
    saveButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    saveButton.TextColor3 = Color3.fromRGB(255, 0, 0)
    saveButton.Parent = frame

    local tpButton = Instance.new("TextButton")
    tpButton.Size = UDim2.new(0, 180, 0, 40)
    tpButton.Position = UDim2.new(0, 10, 0, 50)
    tpButton.Text = "افشخه واهرب"
    tpButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    tpButton.TextColor3 = Color3.fromRGB(255, 0, 0)
    tpButton.Parent = frame

    -- SAVE BASE
    saveButton.MouseButton1Click:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            savedBasePosition = char.HumanoidRootPart.Position
            print("Base saved at:", savedBasePosition)
        end
    end)

    -- TP BASE
    tpButton.MouseButton1Click:Connect(function()
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not savedBasePosition then return end
        local hrp = char.HumanoidRootPart

        local lastBurst = tick()
        local inBurst = false
        local burstStart = 0

        while (hrp.Position - savedBasePosition).Magnitude > stepSize do
            local direction = (savedBasePosition - hrp.Position).Unit
            local currentTime = tick()
            local speed = baseSpeed

            if not inBurst and currentTime - lastBurst >= burstInterval then
                inBurst = true
                burstStart = currentTime
                speed = burstSpeed
            elseif inBurst and currentTime - burstStart >= burstDuration then
                inBurst = false
                lastBurst = currentTime
                speed = baseSpeed
            elseif inBurst then
                speed = burstSpeed
            end

            hrp.CFrame = CFrame.new(hrp.Position + direction * stepSize * (speed/baseSpeed))
            RunService.RenderStepped:Wait()
        end

        hrp.CFrame = CFrame.new(savedBasePosition)
        print("Teleported to base with continuous bursts!")
    end)
end

-- إنشاء GUI
createGUI()

-- إعادة إنشاء السكربت بعد الموت
player.CharacterAdded:Connect(function()
    wait(1)
    createGUI()
end)

-- الخدمات
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- ----- الأدوات الخاصة بـ Steal a brainrot -----
local stealItems = {"Tung Bat","Tung","Cloner","Body","Hook"}

local function hasStealItem()
    for _, item in ipairs(backpack:GetChildren()) do
        for _, name in ipairs(stealItems) do
            if string.find(item.Name:lower(), name:lower()) then
                return true
            end
        end
    end
    return false
end

-- ----- عناصر الماب الخاصة بـ 99 Nights -----
local targetNames = {"Carrot","Chest","Open","Box","Flower"}

local function hasMapItem()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        for _, name in ipairs(targetNames) do
            if obj.Name and string.find(obj.Name:lower(), name:lower()) then
                return true
            end
        end
    end
    return false
end

-- ----- دالة تشغيل 99 Nights -----
local function run99Nights()
    if player.PlayerGui:FindFirstChild("FullScreenCover") then
        player.PlayerGui.FullScreenCover:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FullScreenCover"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 9999
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,1,0)
    frame.Position = UDim2.new(0,0,0,0)
    frame.BackgroundColor3 = Color3.new(0,0,0)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0,0,0,0)
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.TextColor3 = Color3.new(1,1,1)
    label.Text = "جار التجميع..\nN60 Hub افضل سكربت\nلاتنسى تشرفنا ديس\nhttps://discord.gg/wczEq8yg"
    label.Parent = frame

    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Rx1m/CpsHub/refs/heads/main/Cpsnerfv2"))()
    end)
    if not success then warn("فشل تشغيل السكربت: "..err) end
end

-- ----- نسخة Steal a brainrot كاملة -----
local function runStealScript()
    -- واجهة N60 Hub
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "N60Hub"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 160, 0, 90)
    frame.Position = UDim2.new(0.05,0,0.2,0)
    frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    frame.BorderColor3 = Color3.fromRGB(255,0,0)
    frame.BorderSizePixel = 3
    frame.Active = true
    frame.Draggable = true

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1,0,0,25)
    title.BackgroundTransparency = 1
    title.Text = "Steal a brainrot"
    title.TextColor3 = Color3.fromRGB(255,0,0)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20

    -- زر اختفاء (Flip + Sit Toggle)
    local hideBtn = Instance.new("TextButton", frame)
    hideBtn.Size = UDim2.new(0.8,0,0,30)
    hideBtn.Position = UDim2.new(0.1,0,0.5,0)
    hideBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    hideBtn.Text = "اختفاء"
    hideBtn.TextColor3 = Color3.fromRGB(255,255,255)
    hideBtn.Font = Enum.Font.SourceSansBold
    hideBtn.TextSize = 18

    local hidden = false
    local originalCFrame

    hideBtn.MouseButton1Click:Connect(function()
        if not hrp or not humanoid then return end

        if not hidden then
            originalCFrame = hrp.CFrame
            hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(180),0,0) * CFrame.new(0,-5,0)
            humanoid.Sit = true
            hidden = true
            hideBtn.Text = "إلغاء الاختفاء"
        else
            if originalCFrame then
                hrp.CFrame = originalCFrame
            else
                hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(-180),0,0)
            end
            humanoid.Sit = false
            hidden = false
            hideBtn.Text = "اختفاء"
        end
    end)

    -- God Mode
    local function enableGodMode()
        humanoid.Health = humanoid.MaxHealth
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    end
    enableGodMode()
    player.CharacterAdded:Connect(function(char)
        character = char
        hrp = char:WaitForChild("HumanoidRootPart")
        humanoid = char:WaitForChild("Humanoid")
        enableGodMode()
    end)

    -- Rainbow ESP
    local function getRainbowColor()
        local hue = (tick() % 5)/5
        return Color3.fromHSV(hue,1,1)
    end

    local function createRainbowESP(targetPlayer)
        if targetPlayer == player then return end
        local targetChar = targetPlayer.Character
        if not targetChar then return end

        local boxes = {}
        local nameLabel

        local function makeESP(part)
            if not part then return end
            local box = Instance.new("BoxHandleAdornment")
            box.Adornee = part
            box.Size = part.Size
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Parent = part
            table.insert(boxes, box)
        end

        local function addName()
            local head = targetChar:FindFirstChild("Head")
            if head then
                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(0,100,0,25)
                billboard.AlwaysOnTop = true
                billboard.Adornee = head
                billboard.Parent = head

                nameLabel = Instance.new("TextLabel", billboard)
                nameLabel.Size = UDim2.new(1,0,1,0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = targetPlayer.Name
                nameLabel.TextSize = 12
                nameLabel.Font = Enum.Font.SourceSansBold
                nameLabel.TextColor3 = getRainbowColor()
            end
        end

        local function addESP()
            for _,p in pairs(targetChar:GetChildren()) do
                if p:IsA("BasePart") then
                    makeESP(p)
                end
            end
            addName()
        end

        addESP()
        targetPlayer.CharacterAdded:Connect(function(char)
            targetChar = char
            addESP()
        end)

        RunService.RenderStepped:Connect(function()
            for _,b in pairs(boxes) do
                b.Color3 = getRainbowColor()
            end
            if nameLabel then
                nameLabel.TextColor3 = getRainbowColor()
            end
        end)
    end

    for _,p in pairs(Players:GetPlayers()) do
        createRainbowESP(p)
    end
    Players.PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function()
            createRainbowESP(p)
        end)
    end)
end

-- ----- تشغيل النسخة المناسبة عند دخول الماب -----
if hasStealItem() then
    runStealScript()
elseif hasMapItem() then
    run99Nights()
end

